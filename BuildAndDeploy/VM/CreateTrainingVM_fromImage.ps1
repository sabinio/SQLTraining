param(
[string]$subScriptionName = "Visual Studio Ultimate with MSDN"  # Subscription Name (login before calling script)
,[string]$serverNumber = "10"                              # Unique Number (if exists the VM will be reconfigured/imaged/sized as below)
,[string]$rgName="sqltraining"                         	  # Resource Group
,[string]$locName="WestEurope"                             # Azure Location
,[string]$saName="sabiniotraining1"                        # Image must be in same storage account as vhd for this vm
,[string]$vmName="SabinioTR" + $serverNumber               # Max 15 chars
,[string]$vmSize="Standard_A1"                             # Machine Size
,[string]$vnetName="trainingvnet"                          # Network Name (the first valid subnet will be selected)/(Will overwrite any manual changes)
,[string]$SourceImageUri = "https://sabiniotraining1.blob.core.windows.net/system/Microsoft.Compute/Images/mytemplates/Trainingv2-osDisk.4d11904f-0c3d-4559-9fde-3f18eb6c517f.vhd"
)

#	To call this script:
#	Login first:
# 		Import-AzureRM
#		Login-AzureRmAccount
#		Import-Module AzureRM.Compute
#		Import-Module Azure
#
#	 Get Subscription
#		Get-AzureRmSubscription –SubscriptionName $subscriptionName | Select-AzureRmSubscription
#		
#	Then call script overriding any variables:
#	.\CreateTrainingVM_fromImage.ps1 -serverNumber "12" -SourceImageUri "https://blah"
#
#

cls






# Make Sure Resource Group Exists
New-AzureRmResourceGroup -Name $rgName -Location $locName -Force

# Create Virtual Network if it doesn't exist (will overide any manual changes)
#$subnet = New-AzureRmVirtualNetworkSubnetConfig -Name "trainingvnet" -AddressPrefix "10.0.1.0/24"
#$vnet = New-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName -Location $locName -AddressPrefix "10.0.0.0/16" -Subnet $subnet -Force
#$subnet = Get-AzureRmVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vnet

# Set the existing virtual network and subnet index
$subnetIndex=0
$vnet=Get-AzureRMVirtualNetwork -Name $vnetName -ResourceGroupName $rgName

# Create the NIC
$nicName="NIC-" + $vmName
$domName=$vmName.ToLower()
$pip=New-AzureRmPublicIpAddress -Name $nicName -ResourceGroupName $rgName -DomainNameLabel $domName -Location $locName -AllocationMethod Dynamic -Force
$nic=New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $locName -SubnetId $vnet.Subnets[$subnetIndex].Id -PublicIpAddressId $pip.Id -Force

$vm=New-AzureRmVMConfig -VMName $vmName -VMSize $vmSize

# No need to create storage account as it must exist as image should be in same account
# New-AzureRmStorageAccount -ResourceGroupName $rgName -AccountName $saName -Location $locName -Type Standard_LRS


$user = "SQLTraining"
$pw = ConvertTo-SecureString "SQLTraining123" -AsPlainText -Force
$localAdmin=New-Object –TypeName System.Management.Automation.PSCredential –ArgumentList $user, $pw
$vm=Set-AzureRmVMOperatingSystem -VM $vm -Windows -ComputerName $vmName -Credential $localAdmin -ProvisionVMAgent -EnableAutoUpdate
$vm=Add-AzureRmVMNetworkInterface -VM $vm -Id $nic.Id

# Specify the OS disk name and create the VM
$diskName="OSDisk"
$storageAcc=Get-AzureRmStorageAccount -ResourceGroupName $rgName -Name $saName
$osDiskUri=$storageAcc.PrimaryEndpoints.Blob.ToString() + "vhds/" + $vmName + $diskName  + ".vhd"
$vm=Set-AzureRmVMOSDisk -VM $vm -Name $diskName -VhdUri $osDiskUri -CreateOption fromImage -SourceImageUri $SourceImageUri -Windows
New-AzureRmVM -ResourceGroupName $rgName -Location $locName -VM $vm