Import-Module ActiveDirectory

Search-ADAccount -LockedOut | ForEach-Object {
    Unlock-ADAccount -Identity $_.SamAccountName
    Write-Host "Unlocked $($_.SamAccountName)"
}