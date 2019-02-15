Import-Module PowerSchool_Query

$ConnectionString = "User Id=USERNAME;Password=PASSWORD;Data Source=DATABASE_FQDN:PORT_NUMBER/DATABASE_NAME"

$Find = 'username'
$Where = 'LOGINID'
$Extra = "EMAIL_ADDR, PSGUID, LOGINID"

$SQL = ”SELECT FIRST_NAME, LAST_NAME, EMAIL_ADDR, LOGINID, PSGUID
FROM USERS
"

PowerSchool_Query -ConnectionString $ConnectionString # Search using the module, will return all users in the USERS table. Uses default SQL Query built into module

PowerSchool_Query -ConnectionString $ConnectionString -Find $Find -Where $Where    # Search using the Module, specified Find and Where. Will Return only the user requested

PowerSchool_Query -ConnectionString $ConnectionString -Find $Find -Where $Where -ExtraFields $Extra   # Search using the module, specified Extra which will return all extra fields listed in $Extra

PowerSchool_Query -ConnectionString $ConnectionString -SQLQuery $SQL # Search using the module, uses custom built SQL query provided in $SQL