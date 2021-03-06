param([string]$ServerName, [string]$DropFolder)

[string] $sqlpackage = "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\120\sqlpackage.exe"

	

Get-ChildItem $DropFolder -Exclude *tSQLt*,*test*,*Test*,*master* -Filter *.dacpac -Recurse | `
Foreach-Object{
	$DACPAC = $_.FullName
	$ProfilePath = join-Path ($_.Directory) ('..\..\')

	Get-ChildItem $ProfilePath -Filter *local.publish.xml | `
	Foreach-Object{
		# This will take the last publish profile if there are mutliple
		$Profile = $_.FullName
	}

	$vars = ('/a:publish'), ('/sf:' + $DACPAC), ('/pr:' + $PROFILE), ('/TargetServerName:' + $ServerName)

	write-host "Deploying model for database " $DACPAC  -foregroundcolor green -backgroundcolor black 
		& $SQLPackage $vars
	if (! $?) { throw "Deploy failed" }
}

