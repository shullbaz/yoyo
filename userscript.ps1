# Users Setup Script -- only needs to run once!

# Import Active Directory Module
Import-Module ActiveDirectory

# Set common password
$Password = ConvertTo-SecureString "Secure!23" -AsPlainText -Force

# Define users
$Users = @(
    @{Name="Dave Mitchell"; Sam="dmitchell"; Title="Chief Executive Officer"},
    @{Name="Bob Rodriguez"; Sam="brodriguez"; Title="Chief Information Officer"},
    @{Name="Brandon Davis"; Sam="bdavis"; Title="IT Director"},
    @{Name="David Thompson"; Sam="dthompson"; Title="HR Manager"},
    @{Name="Emily Parker"; Sam="eparker"; Title="Operations Manager"},
    @{Name="Robert Williams"; Sam="rwilliams"; Title="Sales Director"},
    @{Name="Amanda Foster"; Sam="afoster"; Title="Marketing Manager"},
    @{Name="James Anderson"; Sam="janderson"; Title="Senior Developer"},
    @{Name="Lisa Nguyen"; Sam="lnguyen"; Title="Senior Developer"},
    @{Name="Christopher Lee"; Sam="clee"; Title="Junior Developer"},
    @{Name="Rachel Martinez"; Sam="rmartinez"; Title="Junior Developer"},
    @{Name="Kevin Brown"; Sam="kbrown"; Title="Help Desk Technician"},
    @{Name="Michelle Davis"; Sam="mdavis"; Title="Accountant"},
    @{Name="Daniel Harris"; Sam="dharris"; Title="Customer Service Representative"},
    @{Name="Jessica Taylor"; Sam="jtaylor"; Title="Administrative Assistant"}
)

# Loop through each user and create account
foreach ($User in $Users) {
    
    New-ADUser `
        -Name $User.Name `
        -SamAccountName $User.Sam `
        -UserPrincipalName "$($User.Sam)@yourdomain.local" `
        -DisplayName $User.Name `
        -Description $User.Title `
        -AccountPassword $Password `
        -ChangePasswordAtLogon $false
}

# Add admin users
Add-ADGroupMember -Identity "Domain Admins" -Members dmitchell,brodriguez,bdavis,eparker,janderson,lnguyen,clee,rmartinez