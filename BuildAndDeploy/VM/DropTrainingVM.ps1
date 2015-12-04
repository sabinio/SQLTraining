$serverNumber = "02"
$rgName="TrainingServers"
$vmName="SABINIOTRNG" + $serverNumber
$nicName="NIC-" + $vmName
$StorageAccountName = "storsabiniotraining01"
$StorageAccountKey = "6otHGIt4BbrrGZJhKftw+8JNIeU5Ki48BDCtmLbzdB1JcsQb9f2T35oJUVOZnKQe4nrZkIMPHCqefUrBR2J1Gg=="
$vhd = "SABINIOTRNG"+$serverNumber+"OSDisk.vhd"

cls

Stop-AzureRmVm -ResourceGroupName $rgName -Name $vmName -Force
Remove-AzureRmVm -ResourceGroupName $rgName -Name $vmName -Force
Remove-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -Force
Remove-AzureRmPublicIpAddress -Name $nicName -ResourceGroupName $rgName -Force
Remove-AzureStorageBlob -Blob $vhd  -Container 'vhds' -Context $context