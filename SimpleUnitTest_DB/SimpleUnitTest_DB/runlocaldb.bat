"%ProgramFiles%\Microsoft SQL Server\120\Tools\Binn\SqlLocalDB.exe" create "ProjectsV12" 12.0 -s

"%ProgramFiles(x86)%\Microsoft Visual Studio 12.0\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\120\SqlPackage.exe" /Action:Publish /SourceFile:"**\bin\$(BuildConfiguration)\**\SimpleUnitTest_DB.dacpac" /Profile:"**\bin\$(BuildConfiguration)\**\localdb_SimpleUnitTest_DB.publish.publish.xml"