param([string]$ServerName, [string]$DropFolder)

[string] $sqlpackage = "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\120\sqlpackage.exe"

	

Get-ChildItem $DropFolder -Exclude *tSQLt*,*test*,*Test*,*master*,*db* -Filter *.dacpac -Recurse | `
Foreach-Object{
	$DACPAC = $_.FullName
	$ProfilePath = join-Path ($_.Directory) ('..\..\')

	Get-ChildItem $ProfilePath -Filter *local.publish.xml | `
	Foreach-Object{
		# This will take the last publish profile if there are mutliple
		$Profile = $_.FullName
	}

	$vars = ('/a:publish'), ('/sf:' + $DACPAC), ('/pr:' + $PROFILE), ('/TargetServerName:' + $ServerName)
    $date1=get-date
	write-output "Deploying model for database "$DACPAC
		& $SQLPackage $vars
	if (! $?) { throw "Deploy failed" }
    $date2=get-date
    $deploytime = "Deployment of "+$_.Name+" took(HH:MM:SS:MS) "+(New-TimeSpan –Start $date1 –End $date2)
    write-output $deploytime
}

