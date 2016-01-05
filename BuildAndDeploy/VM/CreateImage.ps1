# USE TO CREATE A VM IMAGE FOR REUSE

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
$MasterMachine = "sabiniotr10"        # THIS IS THE MACHINE THAT YOU HAVE ALREADY SYSPREPED AND WANT TO USE AS THE FUTURE IMAGE
$VHDName = "Trainingv3"


Import-AzureRM
Import-Module AzureRM.Compute
Import-Module Azure

# Login-AzureRmAccount # COMMENT OUT IF YOU HAVE LOGGED IN DURING THIS SESSION ALREADY


Get-AzureRmSubscription –SubscriptionName $subscriptionName | Select-AzureRmSubscription


# Deallocate the virtual machine
Stop-AzureRmVM -ResourceGroupName $rgName -Name $MasterMachine -Force

# Set the Generalized state to the virtual machine
Set-AzureRmVM -ResourceGroupName $rgName -Name $MasterMachine -Generalized

# Capture the image to storage account.
Save-AzureRmVMImage -ResourceGroupName $rgName -VMName $MasterMachine -DestinationContainerName 'mytemplates' -VHDNamePrefix $VHDName -Path C:\temp\SampleTemplate3.json -Overwrite

