# ============================================
# Modify Existing GPO + Install Select Sysinternals Tools
# ============================================

Import-Module GroupPolicy
Import-Module ActiveDirectory

$GPOName = "dada-core-gpo"

# Validate GPO exists
$GPO = Get-GPO -Name $GPOName -ErrorAction SilentlyContinue
if (!$GPO) {
    Write-Error "GPO '$GPOName' does not exist."
    exit
}

Write-Host "Modifying existing GPO: $GPOName" -ForegroundColor Cyan

# ============================================
# Enforce Advanced Audit Policy
# ============================================

Set-GPRegistryValue -Name $GPOName `
 -Key "HKLM\System\CurrentControlSet\Control\Lsa" `
 -ValueName "SCENoApplyLegacyAuditPolicy" `
 -Type DWord -Value 1

# ============================================
# Apply Advanced Audit Policies (Local DC)
# ============================================

Write-Host "Applying Advanced Audit Policies..." -ForegroundColor Cyan

$auditCommands = @(
'auditpol /set /subcategory:"Credential Validation" /success:enable /failure:enable',
'auditpol /set /subcategory:"User Account Management" /success:enable',
'auditpol /set /subcategory:"Directory Service Access" /success:enable /failure:enable',
'auditpol /set /subcategory:"Directory Service Changes" /success:enable /failure:enable',
'auditpol /set /subcategory:"Logon" /success:enable /failure:enable',
'auditpol /set /subcategory:"Audit Policy Change" /success:enable /failure:enable',
'auditpol /set /subcategory:"Authentication Policy Change" /success:enable /failure:enable',
'auditpol /set /subcategory:"Sensitive Privilege Use" /success:enable',
'auditpol /set /subcategory:"Process Creation" /success:enable /failure:enable',
'auditpol /set /subcategory:"Process Termination" /success:enable /failure:enable',
'auditpol /set /subcategory:"File System" /success:enable /failure:enable',
'auditpol /set /subcategory:"Registry" /success:enable /failure:enable',
'auditpol /set /subcategory:"Security State Change" /failure:enable',
'auditpol /set /subcategory:"System Integrity" /failure:enable',
'auditpol /set /subcategory:"Security System Extension" /failure:enable'
)

foreach ($cmd in $auditCommands) {
    Invoke-Expression $cmd
}

Write-Host "Audit Policies Applied." -ForegroundColor Green

# ============================================
# Configure PowerShell Logging in GPO
# ============================================

Write-Host "Configuring PowerShell Logging..." -ForegroundColor Cyan

New-Item -Path $SysvolPSPath -ItemType Directory -Force | Out-Null

# Script Block Logging
Set-GPRegistryValue -Name $GPOName `
 -Key "HKLM\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" `
 -ValueName "EnableScriptBlockLogging" `
 -Type DWord -Value 1

# Module Logging (All Modules)
Set-GPRegistryValue -Name $GPOName `
 -Key "HKLM\Software\Policies\Microsoft\Windows\PowerShell\ModuleLogging" `
 -ValueName "EnableModuleLogging" `
 -Type DWord -Value 1

Set-GPRegistryValue -Name $GPOName `
 -Key "HKLM\Software\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames" `
 -ValueName "*" `
 -Type String -Value "*"

# Transcription → SYSVOL\PS_logs
Set-GPRegistryValue -Name $GPOName `
 -Key "HKLM\Software\Policies\Microsoft\Windows\PowerShell\Transcription" `
 -ValueName "EnableTranscripting" `
 -Type DWord -Value 1

Set-GPRegistryValue -Name $GPOName `
 -Key "HKLM\Software\Policies\Microsoft\Windows\PowerShell\Transcription" `
 -ValueName "IncludeInvocationHeader" `
 -Type DWord -Value 1

Write-Host "PowerShell Logging Configured in GPO." -ForegroundColor Green

# ============================================
# Install Specific Sysinternals Tools
# ============================================

Write-Host "Installing Selected Sysinternals Tools..." -ForegroundColor Cyan

New-Item -Path $InstallPath -ItemType Directory -Force | Out-Null

# Download individual tools
Invoke-WebRequest "https://download.sysinternals.com/files/ProcessExplorer.zip" `
    -OutFile "$InstallPath\ProcessExplorer.zip"

Invoke-WebRequest "https://download.sysinternals.com/files/ProcessMonitor.zip" `
    -OutFile "$InstallPath\ProcessMonitor.zip"

Invoke-WebRequest "https://download.sysinternals.com/files/Autoruns.zip" `
    -OutFile "$InstallPath\Autoruns.zip"

Invoke-WebRequest "https://download.sysinternals.com/files/Sysmon.zip" `
    -OutFile "$InstallPath\Sysmon.zip"

# Extract each tool
Expand-Archive "$InstallPath\ProcessExplorer.zip" -DestinationPath $InstallPath -Force
Expand-Archive "$InstallPath\ProcessMonitor.zip" -DestinationPath $InstallPath -Force
Expand-Archive "$InstallPath\Autoruns.zip" -DestinationPath $InstallPath -Force
Expand-Archive "$InstallPath\Sysmon.zip" -DestinationPath $InstallPath -Force

Write-Host "Tools Extracted." -ForegroundColor Green

# ============================================
# Install Sysmon with SwiftOnSecurity Config
# ============================================

Write-Host "Installing Sysmon with SwiftOnSecurity Config..." -ForegroundColor Cyan

$SysmonExe = "$InstallPath\Sysmon64.exe"
$SwiftConfig = "$InstallPath\sysmonconfig-export.xml"

Invoke-WebRequest `
 -Uri "https://raw.githubusercontent.com/SwiftOnSecurity/sysmon-config/master/sysmonconfig-export.xml" `
 -OutFile $SwiftConfig

Start-Process -FilePath $SysmonExe `
 -ArgumentList "-accepteula -i `"$SwiftConfig`"" `
 -Wait

Write-Host "Sysmon Installed and Configured." -ForegroundColor Green

gpupdate /force

Write-Host "========================================="
Write-Host "GPO Updated + Selected Tools Installed"
Write-Host "=========================================" -ForegroundColor Cyan