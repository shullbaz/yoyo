Import-Module GroupPolicy
Import-Module ActiveDirectory

$GPOName = "dada-core-gpo"

# Password GPOs
$SystemKey = "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System"

Set-GPRegistryValue -Name $GPOName -Key $SystemKey -ValueName "ClearTextPassword" -Type DWord -Value 1
Set-GPRegistryValue -Name $GPOName -Key $SystemKey -ValueName "MinimumPasswordLength" -Type DWord -Value 0
Set-GPRegistryValue -Name $GPOName -Key $SystemKey -ValueName "PasswordComplexity" -Type DWord -Value 0

# Networking GPOs
$NtlmKey = "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0"

Set-GPRegistryValue -Name $GPOName -Key "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" -ValueName "LmCompatibilityLevel" -Type DWord -Value 1
Set-GPRegistryValue -Name $GPOName -Key $NtlmKey -ValueName "NtlmMinClientSec" -Type DWord -Value 0
Set-GPRegistryValue -Name $GPOName -Key $NtlmKey -ValueName "NtlmMinServerSec" -Type DWord -Value 0
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -ValueName "RequireSecuritySignature" -Type DWord -Value 0

# Remote Desktop
$TSKey = "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server"
$RDPKey = "$TSKey\WinStations\RDP-Tcp"

Set-GPRegistryValue -Name $GPOName -Key $TSKey -ValueName "fDenyTSConnections" -Type DWord -Value 0
Set-GPRegistryValue -Name $GPOName -Key $RDPKey -ValueName "UserAuthentication" -Type DWord -Value 0

# Windows Defender
$DefenderBase = "HKLM\Software\Policies\Microsoft\Windows Defender"
$DefenderRTP  = "$DefenderBase\Real-Time Protection"

Set-GPRegistryValue -Name $GPOName -Key $DefenderBase -ValueName "DisableAntiSpyware" -Type DWord -Value 1
Set-GPRegistryValue -Name $GPOName -Key $DefenderRTP -ValueName "DisableRealtimeMonitoring" -Type DWord -Value 1
Set-GPRegistryValue -Name $GPOName -Key $DefenderRTP -ValueName "DisableBehaviorMonitoring" -Type DWord -Value 1
Set-GPRegistryValue -Name $GPOName -Key $DefenderRTP -ValueName "DisableOnAccessProtection" -Type DWord -Value 1

# PowerShell
Set-GPRegistryValue -Name $GPOName -Key "HKLM\Software\Policies\Microsoft\Windows\PowerShell" -ValueName "ExecutionPolicy" -Type String -Value "RemoteSigned"
# Insecure Guest Logons
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows\LanmanWorkstation" -ValueName "AllowInsecureGuestAuth" -Type DWord -Value 1

# Must be done manually:
# Access this computer from network: Add "Domain Users"
# Allow log on locally: Add Guests, Administrators, and Domain Users
# Bypass traverse checking: Add "Domain Users"
# Software Restriction Policies - Allow All