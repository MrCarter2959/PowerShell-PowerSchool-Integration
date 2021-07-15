Import-Module PowerSchool_Query

$ConnectionString = "User Id=USERNAME;Password=PASSWORD;Data Source=DATABASE_FQDN:PORT_NUMBER/DATABASE_NAME"

$Find = 'username'
$Where = 'LOGINID'
$Extra = "EMAIL_ADDR, PSGUID, LOGINID"

$SQL = @"
SELECT FIRST_NAME, LAST_NAME, EMAIL_ADDR, LOGINID, PSGUID
FROM USERS
"@;


PowerSchool_Query -ConnectionString $ConnectionString -Find $Find -Where $Where | Export-CSV -Path 'C:\SomePath\filename.csv' -NoTypeInformation # Export the results to CSV for import-csv or manual verification

