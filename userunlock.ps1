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