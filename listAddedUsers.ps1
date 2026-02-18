Import-Module ActiveDirectory

$Users = @(
    "dmitchell","brodriguez","bdavis","dthompson","eparker",
    "rwilliams","afoster","janderson","lnguyen","clee",
    "rmartinez","kbrown","mdavis","dharris","jtaylor"
)

foreach ($User in $Users) {
    Get-ADUser -Identity $User -Properties Description |
    Select-Object Name, SamAccountName, Description
}
