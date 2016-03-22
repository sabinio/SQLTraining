param(
[string]$serverNumber = "10")

$rgName="training"
$vmName="sabiniotr" + $serverNumber
$nicName="NIC-" + $vmName
$StorageAccountName = "siotraining"
$StorageAccountKey = "Ro6Id471dYenfdg8bNo4JaGOygaV32f389nXWi/J2T9UjgPd6OPP/SXGmIBFHLb90KjPy32Y9bWs9XMWUgDQwQ=="
$vhd = "SabinioTR"+$ServerNumber+"OSDisk.vhd"

$context = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey

Stop-AzureRmVm -ResourceGroupName $rgName -Name $vmName -Force
Remove-AzureRmVm -ResourceGroupName $rgName -Name $vmName -Force
Remove-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -Force
Remove-AzureRmPublicIpAddress -Name $nicName -ResourceGroupName $rgName -Force
Remove-AzureStorageBlob -Blob $vhd  -Container 'vhds' -Context $context -Force
