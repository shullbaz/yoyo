# Import-Module ActiveDirectory

# Search-ADAccount -LockedOut | ForEach-Object {
#     Unlock-ADAccount -Identity $_.SamAccountName
#     Write-Host "Unlocked $($_.SamAccountName)"
# }

# Import Active Directory module
Import-Module ActiveDirectory

# Define users 
$Users = @(
    "dmitchell",
    "brodriguez",
    "bdavis",
    "dthompson",
    "eparker",
    "rwilliams",
    "afoster",
    "janderson",
    "lnguyen",
    "clee",
    "rmartinez",
    "kbrown",
    "mdavis",
    "dharris",
    "jtaylor"
)

# Unlock each account
foreach ($User in $Users) {
    Unlock-ADAccount -Identity $User
    Write-Host "Unlocked account: $User"
}

# list users
Get-ADUser -Filter { SamAccountName -in $Users } -Properties Title |
Select-Object Name, SamAccountName, Title