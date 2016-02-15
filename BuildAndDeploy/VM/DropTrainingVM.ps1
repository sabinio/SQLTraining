param(
[string]$serverNumber = "10")

$rgName="sqltraining"
$vmName="sabiniotr" + $serverNumber
$nicName="NIC-" + $vmName
$StorageAccountName = "sabiniotraining1"
$StorageAccountKey = "5r9bxMh6hSsuwRLihcLhAwJ0tbXs4Xy6cLCoGIfwiknRpf5rlaaZARJryy3u3G6JR4V8msCWG5xRt0Jum8RZog=="
$vhd = "SabinioTR"+$ServerNumber+"OSDisk.vhd"

$context = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey

Stop-AzureRmVm -ResourceGroupName $rgName -Name $vmName -Force
Remove-AzureRmVm -ResourceGroupName $rgName -Name $vmName -Force
Remove-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -Force
Remove-AzureRmPublicIpAddress -Name $nicName -ResourceGroupName $rgName -Force
Remove-AzureStorageBlob -Blob $vhd  -Container 'vhds' -Context $context -Force
