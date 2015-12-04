# Set values for existing resource group and storage account names

$subScriptionName = "Visual Studio Ultimate with MSDN"
$serverNumber = "05"
$rgName="sqltraining"
$locName="WestEurope" 
$saName="sabiniotraining1"   # No upper case or special characters
$vmName="SABINIOBUILD" # + $serverNumber
$vmSize="Standard_A1"
$vnetName="trainingvnet"


$user = "simon.dmorias@sabin.io"
$pw = ConvertTo-SecureString "" -AsPlainText -Force
$cred = New-Object –TypeName System.Management.Automation.PSCredential –ArgumentList $user, $pw

cls

Import-AzureRM
Import-Module AzureRM.Compute
Import-Module Azure
# Login-AzureRmAccount # -Credential $cred

Get-AzureRmSubscription –SubscriptionName $subscriptionName | Select-AzureRmSubscription

# Make Sure Resource Group Exists
New-AzureRmResourceGroup -Name $rgName -Location $locName -Force

# Create Virtual Network if it doesn't exist (will overide any manual changes)
$subnet = New-AzureRmVirtualNetworkSubnetConfig -Name "primaryvlan" -AddressPrefix "10.0.10.0/24"
$vnet = New-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName -Location $locName -AddressPrefix "10.0.0.0/16" -Subnet $subnet -Force
$subnet = Get-AzureRmVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vnet

# Set the existing virtual network and subnet index
$subnetIndex=0
$vnet=Get-AzureRMVirtualNetwork -Name $vnetName -ResourceGroupName $rgName

# Create the NIC
$nicName="NIC-" + $vmName
$domName=$vmName.ToLower()
$pip=New-AzureRmPublicIpAddress -Name $nicName -ResourceGroupName $rgName -DomainNameLabel $domName -Location $locName -AllocationMethod Dynamic -Force
$nic=New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $locName -SubnetId $vnet.Subnets[$subnetIndex].Id -PublicIpAddressId $pip.Id -Force

$vm=New-AzureRmVMConfig -VMName $vmName -VMSize $vmSize

New-AzureRmStorageAccount -ResourceGroupName $rgName -AccountName $saName -Location $locName -Type Standard_LRS


# Specify the image and local administrator account, and then add the NIC
$pubName="MicrosoftWindowsServer"
$offerName="WindowsServer"
$skuName="2012-R2-Datacenter"

$user = "SQLTraining"
$pw = ConvertTo-SecureString "SQLTraining123" -AsPlainText -Force
$localAdmin=New-Object –TypeName System.Management.Automation.PSCredential –ArgumentList $user, $pw
$vm=Set-AzureRmVMOperatingSystem -VM $vm -Windows -ComputerName $vmName -Credential $localAdmin -ProvisionVMAgent -EnableAutoUpdate
$vm=Set-AzureRmVMSourceImage -VM $vm -PublisherName $pubName -Offer $offerName -Skus $skuName -Version "latest"
$vm=Add-AzureRmVMNetworkInterface -VM $vm -Id $nic.Id

# Specify the OS disk name and create the VM
$diskName="OSDisk"
$storageAcc=Get-AzureRmStorageAccount -ResourceGroupName $rgName -Name $saName
$osDiskUri=$storageAcc.PrimaryEndpoints.Blob.ToString() + "vhds/" + $vmName + $diskName  + ".vhd"
$vm=Set-AzureRmVMOSDisk -VM $vm -Name $diskName -VhdUri $osDiskUri -CreateOption fromImage
New-AzureRmVM -ResourceGroupName $rgName -Location $locName -VM $vm