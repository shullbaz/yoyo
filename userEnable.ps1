Import-Module ActiveDirectory

$Users = @(
    "dmitchell","brodriguez","bdavis","dthompson","eparker",
    "rwilliams","afoster","janderson","lnguyen","clee",
    "rmartinez","kbrown","mdavis","dharris","jtaylor"
)

foreach ($User in $Users) {
    Enable-ADAccount -Identity $User
    Write-Host "Enabled account: $User"
}

Write-Host "All specified accounts have been enabled."
