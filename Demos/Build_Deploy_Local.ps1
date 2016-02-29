#######################################################################################################
#Script process                                                                                       #
#                                                                                                     #
# 1. compile all projects                                                                             #
# 2. deploys all dacpacs to SQL                                                                       #
# 3. assigns the microsoft sql server service permissions on adventureworks.bak file                  #
# 4. restores adventureworks                                                                          #
# notes:                                                                                              #
#     script assumes that it is launched from one folder "up" from the solutions                      #
#     also assumes that user is running with admin permissions on box                                 #
#     SSDT and Visual Studio 2015 need to be installed on the box                                     #
#     the connection to local SQL instance is trusted                                                 #
#                                                                                                     #
#######################################################################################################


#build all projects; we call an msbuild file that excludes the performancetesting sln as it will fail
#on build unless we have ultimate/enterprise visual studio installed
$msbuild = "C:\Windows\Microsoft.Net\Framework\v4.0.30319\MSBuild.exe"
$MsBuilExists = Test-Path $msbuild
If ($MsBuilExists -ne $true) {write-host "msbuild does not exist at this location. Install Visual Studio 2015 (Community Edition should be adequate)"}
$buildFile = $PSScriptRoot+"\BuildAllDBProjects.targets.xml"
$arg = "/p:VisualStudioVersion=14.0"

& $msbuild $buildFile $arg
#end of build

#deploy all projects
#ignores any tSQLt projects
$SQLServer = "." # if you have a named instance, change here
$DropFolder = $PSScriptRoot

$sqlpackage = "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\120\sqlpackage.exe"
$sqlpackageExists = Test-Path $sqlpackage
If ($sqlpackageExists -ne $true) {write-host "sqlpackage does not exist at this location. Install SQL Server Data Tools"}


Get-ChildItem $DropFolder -Exclude *tSQLt*,*test*,*Test*,*master*,*db* -Filter *.dacpac -Recurse | `
Foreach-Object{
	$DACPAC = $_.FullName
	$ProfilePath = join-Path ($_.Directory) ('..\..\')

	Get-ChildItem $ProfilePath -Filter *local.publish.xml | `
	Foreach-Object{
		# This will take the last publish profile if there are mutliple
		$Profile = $_.FullName
	}

	$vars = ('/a:publish'), ('/sf:' + $DACPAC), ('/pr:' + $PROFILE), ('/TargetServerName:' + $SQLServer)

	write-host "Deploying model for database "$DACPAC
		& $SQLPackage $vars
	if (! $?) { throw "Deploy failed" }
}
#end of deploy

#grant sql server service full access to the bak file location so that adventureworks can be restored
try{
$backupLocation = $PSScriptRoot+"\"+"Adventureworks"
$AccessPolicy = Get-Acl $backupLocation
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("nt service\mssqlserver", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$AccessPolicy.SetAccessRule($AccessRule)
Set-Acl $backupLocation $AccessPolicy
write-host "access policy updated" -ForegroundColor Green

}
catch{
write-host "access policy change failed. Access policy will only update defualt instances. Below is a list of all instacnes running on this machine." -ForegroundColor Red
$srvr = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Wmi.ManagedComputer $computerName
    $instances = $srvr | ForEach-Object {$_.ServerInstances} | Select @{Name="fullName";Expression={$computerName +"\"+ $_.Name}}   
    return $instances
}
#end of access policy change

#restore adventureworks
$path = get-childitem $PSScriptRoot -include "AdventureWorks2014.bak" -recurse
$SQLDatabase = $path.Name
$SQLDatabase = $SQLDatabase.TrimEnd(".bak")

$SQLConn = New-Object System.Data.SQLClient.SQLConnection
$SQLConn.ConnectionString = "Server=$SQLServer; Trusted_Connection=True"

try
{
$SQLConn.Open()

write-host "success" -ForegroundColor Green
$SqlConn.Close()
}
catch {
Write-warning "An exception was caught while attempting to open the SQL connection"
Break
}


$SQLConn.Open()
 $Command = New-Object System.Data.SQLClient.SQLCommand
    $Command = $SQlconn.CreateCommand()
    $Command.CommandTimeout =0
    $Command.CommandText = "select top 1 physical_name
from master.sys.master_files
where database_id = 1"
try{
    $Reader = $Command.ExecuteReader()
     while ($Reader.Read()) 
     {
         $r = $Reader.GetValue($1)
         $r = $r.ToString()
         $r = $r.TrimEnd("\master.mdf")
    }
$SQLConn.Close()
}
catch
{
write-host "something went wrong"
write-host "$_"
}

$SQLConn.Open()
$SQLCmd = New-Object System.Data.SQLClient.SQLCommand
$SQLcmd = $SQLconn.CreateCommand()
$sqlcmd.commandtimeout=0
$SQLcmd.CommandText="IF EXISTS(select * from sys.databases where name='$SQLDatabase')
ALTER DATABASE $SQLDatabase
SET SINGLE_USER WITH
ROLLBACK IMMEDIATE
RESTORE DATABASE $SQLDatabase
FROM DISK = '$path'
WITH  FILE = 1, REPLACE,
MOVE N'AdventureWorks2014_Data' 
TO N'$r\AdventureWorks2014_Data.mdf',  
MOVE N'AdventureWorks2014_Log' 
TO N'$r\AdventureWorks2014_Log.ldf'"

$starttime = Get-date
try{
$SQLcmd.Executenonquery() | out-null
write-host "aventureworks deployed" -ForegroundColor Green
}
catch{
write-warning "An Exception was caught while restoring the database!"
write-warning "$_"
write-warning "attempting to recover the database"
}
Write-Host "Press Any Key To Exit"
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
(Get-Host).SetShouldExit(0)