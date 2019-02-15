<#
.SYNOPSIS
    Query PowerSchool Database by using PowerShell.
 
.DESCRIPTION
    Query PowerSchool Database by using SQL queries without the need of another SQL Writer. The default SQL query returns the First and Last name
    and searchs by LoginID which is a AD linked field to SamAccountName. 
 
.PARAMETER ConnectionString
    Enter your Oracle ConnectionString Similar to "User Id=username;Password=password;Data Source=databaseFQDN:1521/databasename". This is a mandatory parameter.

.PARAMETER Find
    Enter the user you want to find. This looks to PowerSchool's UserID Field.  This is a Mandatory Parameter.

.PARAMETER ExtraFields
    Enter the Extra Fields that you want in your query. By Default only First Name and Last name are Returned. This is a optional parameter.

.PARAMETER SQLQuery
    Enter the custom SQL query that you want to use. This is a Opitional Parameter. If it isn't supplied, only First and Last Name are returned. 

.NOTES
    Author: Carter Sema
    Date: 2/6/2018
    Modified: Carter Sema 2/6/2018

.EXAMPLE
    
    
    The Query below uses the -SQLQuery Parameter so it uses the supplied SQL Query
        
        PowerSchool_Query -ConnectionString $ConnectionString -SQLQuery $SQL
    
    The Query below uses the -Find and -Where Parameters so you can Search for Specific users within Specific Tables

        PowerSchool_Query -ConnectionString $ConnectionString -Find $User -Where $Table

    The Query below uses the -ExtraFields Parameter so it uses the supplied Extra Fields and its default query
        
        PowerSchool_Query -ConnectionString $ConnectionString -Find $Find -Where $Table -ExtraFields $Extra
    
    The Query Below uses no parameters and just the built in SQL Query
        
        PowerSchool_Query -ConnectionString $ConnectionString 

#>
function PowerSchool_Query {

    param (
        [Parameter(Mandatory=$true)]
        
        [string]$ConnectionString,

        [string]$Find,
        
        [Parameter(Mandatory=$false)]
        [String[]]$ExtraFields,

        [Parameter(Mandatory=$false)]
        [string]$SQLQuery,

        [Parameter(Mandatory=$false)]
        [string]$Where
    )
    
    Try {
    Add-Type -Path 'C:\Windows\Oracle\Oracle.ManagedDataAccess.dll' -ErrorAction SilentlyContinue -ErrorVariable OracleError
    }
    Catch{
    Write-Host $_.Exception.Message -ForegroundColor "Yellow"
    }

    $resultSet=@()

    try {

        $con = New-Object Oracle.ManagedDataAccess.Client.OracleConnection($ConnectionString)

        $cmd=$con.CreateCommand()
        
        if ($Where -and $ExtraFields)
        {
            $cmd.CommandText = ”SELECT FIRST_NAME, LAST_NAME, $ExtraFields 
            FROM USERS 
            WHERE $Where = '$Find'
            "
        }

        Else {

        if ($SQLQuery)
        {
         $cmd.CommandText= $SQLQuery
        }
        
        else {
        
        if ($Where)
        {
            $cmd.CommandText =”SELECT FIRST_NAME, LAST_NAME
            FROM USERS
            WHERE $Where = '$Find'"
        }

        Else {
        
        If ({$SQLQuery -or $ExtraFields -or $Where -or $Find -eq $null})
        {
            
            $cmd.CommandText= ”SELECT FIRST_NAME, LAST_NAME
            FROM USERS"
        }
        }
        }
        }
        

        $da=New-Object Oracle.ManagedDataAccess.Client.OracleDataAdapter($cmd);

        $resultSet=New-Object System.Data.DataTable

        [void]$da.fill($resultSet)

              

    } catch {

        Write-Host ($_.Exception.Message) -ForegroundColor 'Yellow'

    } finally {

         if ($con.State -eq 'Open') { $con.close() }

    }

    $resultSet

}