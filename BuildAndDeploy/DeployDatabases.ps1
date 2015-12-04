
[string] $SERVER = "SQL14"
[string] $sqlpackage = "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\120\sqlpackage.exe"

cls


function Get-ScriptDirectory
{
 $Invocation = (Get-Variable MyInvocation -Scope 1).Value
 Split-Path $Invocation.MyCommand.Path
}


$DropFolder = join-Path (Get-ScriptDirectory) ('..\Demos\')

if((Test-Path C:\Demos) -eq 1)
    {
        Remove-Item C:\Demos;
    }
New-Item C:\Demos -type directory -force


Get-ChildItem $DropFolder -Filter *.sql -Recurse | `
Foreach-Object{
   if (([uri]$_.FullName).segments[-2].trim('/') -eq "Demos"){   # In a folder called Demos
    if (([uri]$_.FullName).segments[-4].trim('/') -ne "bin"){    # Not in Bin sub-folder
        write-host $_.FullName
        $NewSubFolder = join-Path ("C:\Demos\") ([uri]$_.FullName).segments[-3].trim('/')
        if((Test-Path $NewSubFolder) -eq 0)
        {
            mkdir $NewSubFolder;
        }
        Copy-Item $_.FullName $NewSubFolder
    }
    }
}


return

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

    write-host "Comparing model for database " + $DACPAC  -foregroundcolor green -backgroundcolor black 
	    & $SQLPackage $vars
    if (! $?) { throw "Deploy failed" }
}



