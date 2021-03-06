﻿# USE TO CREATE A VM IMAGE FOR REUSE

#
#
#         Run this command on client 
#                    & "$Env:SystemRoot\system32\sysprep\sysprep.exe" /generalize /oobe /shutdown
#
#         Wait for Server to shutdown
#         Log into Azure portal and deallocate VM
#         Run this script
#
#         Once run please get the vhd URL from the C:\temp output file and paste it into the CreateVM_FromImage.ps1 script

$subScriptionName = "Visual Studio Ultimate with MSDN"
$rgName="sqltraining"
$MasterMachine = "sabiniotr03"        # THIS IS THE MACHINE THAT YOU HAVE ALREADY SYSPREPED AND WANT TO USE AS THE FUTURE IMAGE
$VHDName = "Trainingv9"


#Import-AzureRM
#Import-Module AzureRM.Compute
#Import-Module Azure

# Login-AzureRmAccount # COMMENT OUT IF YOU HAVE LOGGED IN DURING THIS SESSION ALREADY


#Get-AzureRmSubscription –SubscriptionName $subscriptionName | Select-AzureRmSubscription


# Deallocate the virtual machine
Stop-AzureRmVM -ResourceGroupName $rgName -Name $MasterMachine -Force

# Set the Generalized state to the virtual machine
Set-AzureRmVM -ResourceGroupName $rgName -Name $MasterMachine -Generalized

# Capture the image to storage account.
Save-AzureRmVMImage -ResourceGroupName $rgName -VMName $MasterMachine -DestinationContainerName 'mytemplates' -VHDNamePrefix $VHDName -Path C:\temp\SampleTemplate9.json -Overwrite

