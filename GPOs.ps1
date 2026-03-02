Import-Module GroupPolicy
Import-Module ActiveDirectory

$GPOName = "dada-core-gpo"
$DomainDN = (Get-ADDomain).DistinguishedName
$DomainName = (Get-ADDomain).DNSRoot
$DCHostName = $env:COMPUTERNAME

$WallpaperPath = "\\$DCHostName\sysvol\$DomainName\Policies\Wallpaper\image.jpg"

if (Get-GPO -Name $GPOName -ErrorAction SilentlyContinue) {
    Remove-GPO -Name $GPOName -Confirm:$false
}

New-GPO -Name $GPOName

Set-GPRegistryValue -Name $GPOName -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" -ValueName "Wallpaper" -Type String -Value $WallpaperPath
Set-GPRegistryValue -Name $GPOName -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" -ValueName "WallpaperStyle" -Type String -Value "2"

Set-GPRegistryValue -Name $GPOName -Key "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" -ValueName "EnableFirewall" -Type DWord -Value 0
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" -ValueName "DefaultInboundAction" -Type DWord -Value 0
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" -ValueName "DefaultOutboundAction" -Type DWord -Value 0

Set-GPRegistryValue -Name $GPOName -Key "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" -ValueName "EnableFirewall" -Type DWord -Value 0
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" -ValueName "DefaultInboundAction" -Type DWord -Value 0
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" -ValueName "DefaultOutboundAction" -Type DWord -Value 0

Set-GPRegistryValue -Name $GPOName -Key "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" -ValueName "EnableFirewall" -Type DWord -Value 0
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" -ValueName "DefaultInboundAction" -Type DWord -Value 0
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" -ValueName "DefaultOutboundAction" -Type DWord -Value 0

New-GPLink -Name $GPOName -Target $DomainDN -LinkEnabled Yes
Set-GPLink -Name $GPOName -Target $DomainDN -Enforced Yes
Set-GPLink -Name $GPOName -Target $DomainDN -Order 1
