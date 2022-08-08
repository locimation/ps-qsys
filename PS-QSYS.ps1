Import-Module -Force D:\Dropbox\Locimation\Projects\PS-QSYS\PS-QSYS.psm1

$core = New-QSYSSession -HostName "10.10.10.4" -SkipCertificateCheck

#Get-QSYSCoreDetails -Session $core | Write-Host

#Get-QSYSDesignerVersions

Push-QSYSDesign -Session $core -File D:\Dropbox\Locimation\Projects\PS-QSYS\untitled-design.qsys -AllowNewerDesigner

#Get-QSYSCoreDetails -Session $core

#Get-QSYSDeviceStatus -Session $core

#Identify-QSYSCore -Session $core -Disable

#Set-QSYSCoreName -Session $core -Name "Core-1"

#Set-QSYSCoreDNS -Session $core -Primary "1.1.1.1" -Secondary "8.8.8.8"

#Get-QSysCoreInterfaces -Session $core

#Get-QSysCoreInterface -Session $core -Name "LAN A"

#Set-QSysCoreInterface -Session $core -Name "LAN B" -Auto

#Get-QSYSCoreNTP -Session $core

#Set-QSYSCoreNTP -Session $core -Servers 0.pool.ntp.org, 1.pool.ntp.org

#Get-QSYSCoreServices -Session $core

#Get-QSYSCoreSNMP -Session $core

#Set-QSYSCoreAccessControl -Session $core -Disabled

#Reboot-QSYSCore -Session $core