

#
#
#         Run this command on client 
#                    & "$Env:SystemRoot\system32\sysprep\sysprep.exe" /generalize /oobe /shutdown
#
#         Wait for Server to shutdown
#         Run this script
#
#

$subScriptionName = "Visual Studio Ultimate with MSDN"
$rgName="sqltraining"
$MasterMachine = "SQLTRAINMASTER"

$user = "Simon.DMorias@sabin.io"
$pw = ConvertTo-SecureString "" -AsPlainText -Force
$cred = New-Object –TypeName System.Management.Automation.PSCredential –ArgumentList $user, $pw

Import-AzureRM
Import-Module AzureRM.Compute
Import-Module Azure
Login-AzureRmAccount # -Credential $cred



Get-AzureRmSubscription –SubscriptionName $subscriptionName | Select-AzureRmSubscription




# Deallocate the virtual machine
Stop-AzureRmVM -ResourceGroupName $rgName -Name $MasterMachine -Force

# Set the Generalized state to the virtual machine
Set-AzureRmVM -ResourceGroupName $rgName -Name $MasterMachine -Generalized

# Capture the image to storage account.
Save-AzureRmVMImage -ResourceGroupName $rgName -VMName $MasterMachine -DestinationContainerName 'mytemplates' -VHDNamePrefix 'Trainingv1' -Path C:\temp\SampleTemplate.json -Overwrite

