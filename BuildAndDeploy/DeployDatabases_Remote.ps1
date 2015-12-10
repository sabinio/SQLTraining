
## Execute stuff on remote machine
Enter-PSSession sabiniotr01.2a0elsp3h2ze1jnokg4br13lnf.ax.internal.cloudapp.net -UseSSL:$true -SessionOption (New-PSSessionOption -SkipCACheck)

[string] $SERVER = "."
[string] $sqlpackage = "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\120\sqlpackage.exe"

#function Get-ScriptDirectory
#{
# $Invocation = (Get-Variable MyInvocation -Scope 1).Value
# Split-Path $Invocation.MyCommand.Path
#}


# $DropFolder = join-Path (Get-ScriptDirectory) ('..\Demos\')
$DropFolder = ('C:\Drops')

if((Test-Path C:\Demos) -eq 1)
    {
        Remove-Item C:\Demos -Recurse -Force;
    }
New-Item C:\Demos -type directory -force


Get-ChildItem $DropFolder -Filter *.sql -Recurse | `
Foreach-Object{
   if (([uri]$_.FullName).segments[-2].trim('/') -eq "Demos"){   # In a folder called Demos
    if (([uri]$_.FullName).segments[-4].trim('/') -ne "bin"){    # Not in Bin sub-folder
        write-host $_.FullName
        $NewSubFolder = join-Path ("C:\Demos\") ([uri]$_.FullName).segments[-3].trim('/')  # Get the Project name from folder name 2 deep
        if((Test-Path $NewSubFolder) -eq 0)
        {
            mkdir $NewSubFolder;
        }
        Copy-Item $_.FullName $NewSubFolder
    }
    }
}


Get-ChildItem $DropFolder -Filter *.dacpac -Recurse | `
Foreach-Object{
    $DACPAC = $_.FullName
    $ProfilePath = join-Path ($_.Directory) ('..\..\')

    Get-ChildItem $ProfilePath -Filter *.publish.xml | `
    Foreach-Object{
        # This will take the last publish profile if there are mutliple
        $Profile = $_.FullName
    }

    $vars = ('/a:publish'), ('/sf:' + $DACPAC), ('/pr:' + $PROFILE), ('/TargetServerName:' + $SERVER)

    write-host "Deploying model for database " $DACPAC  -foregroundcolor green -backgroundcolor black 
	    & $SQLPackage $vars
    if (! $?) { throw "Deploy failed" }
}



