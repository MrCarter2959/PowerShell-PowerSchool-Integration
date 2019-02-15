# Import PowerSchool_Query Module
Import-Module PowerSchool_Query

# Import Active Directory Moudle
Import-Module ActiveDirectory

$ConnectionString = "User Id=USERNAME;Password=PASSWORD;Data Source=DATABASE_FQDN:PORT_NUMBER/DATABASE_NAME"

$DomainController = "DomainController_FQDN"

$SQL = ”SELECT FIRST_NAME, LAST_NAME, EMAIL_ADDR, LOGINID, PSGUID
FROM USERS"

$Query = PowerSchool_Query -ConnectionString $ConnectionString -SQLQuery $SQL # Use the Custom SQL Flag, and use the $SQL variable to return the users or fields that you want


Foreach ($user in $Query) {
    # Assign fields to variables 
    $First = ($user.FIRST_NAME)
    $Last = ($User.LAST_NAME)
    $Email = ($user.EMAIL_ADDR)
    $guid = ($user.PSGUID)
    $id = ($user.LOGINID)

    # Search AD For the user by using Filter's and variables from above
    $FindUser = Get-ADUser -Server $DomainController -Filter {(SamaccountName -eq $id)} -Properties userPrincipalName, extensionAttribute15 | Select-Object userPrincipalName, extensionAttribute15
   
    # Assign Variables to users found from the Get-ADUser Command
    $upn = ($FindUser.userPrincipalName)
    $PS = ($FindUser.extensionAttribute15)
    
    #Check to see if the users returned from $Query match any in $Finduser and write-host to alert you
    if ($null -eq $FindUser) {
        Write-Host "Account For $id is null, account doesnt exist.... No $guid found in AD" -BackgroundColor "Cyan" -ForegroundColor "Black"
    }
    Else
    {Write-Host "$upn exists, and has GUID of $PS....." -BackgroundColor "Yellow" -ForegroundColor "Black"}
}