# PS-QSYS (BETA)
*A PowerShell module for managing QSC's Q-SYS cores.*

![MIT License](https://img.shields.io/badge/license-MIT-blue) [![Public beta](https://img.shields.io/badge/stability-public_beta-orange)](https://gist.github.com/gdyr/2e54d8afb39d4ea789b4830603ca34b2) [![Uses unstable undocumented features](https://img.shields.io/badge/support-unstable-red)](https://gist.github.com/gdyr/2e54d8afb39d4ea789b4830603ca34b2)

This PowerShell module provides a collection of CmdLets for managing QSC's Q-SYS cores, including:

 - Retrieving core details & status information
 - Configuring network interfaces & DNS
 - NTP, SNMPv2 and SNMPv3 settings
 - Identifying the core
 - Enabling & disabling access control
 - Blocking / allowing network services
 - Restarting the core

These CmdLets have been developed and tested against Q-SYS firmware version 9.0.1, and are expected to work with the versions immediately prior and thereafter.

## CmdLet Reference

<a href="docs/Get-QSYSCoreDetails.md">Get-QSYSCoreDetails</a>

<a href="docs/Get-QSYSCoreDNS.md">Get-QSYSCoreDNS</a>

<a href="docs/Get-QSYSCoreInterfaces.md">Get-QSYSCoreInterfaces</a>

<a href="docs/Get-QSYSCoreNTP.md">Get-QSYSCoreNTP</a>

<a href="docs/Get-QSYSCoreServices.md">Get-QSYSCoreServices</a>

<a href="docs/Get-QSYSCoreSNMP.md">Get-QSYSCoreSNMP</a>

<a href="docs/Get-QSYSDeviceStatus.md">Get-QSYSDeviceStatus</a>

<a href="docs/New-QSYSSession.md">New-QSYSSession</a>

<a href="docs/Restart-QSYSCore.md">Restart-QSYSCore</a>

<a href="docs/Set-QSYSCoreAccessControl.md">Set-QSYSCoreAccessControl</a>

<a href="docs/Set-QSYSCoreDNS.md">Set-QSYSCoreDNS</a>

<a href="docs/Set-QSYSCoreIdentify.md">Set-QSYSCoreIdentify</a>

<a href="docs/Set-QSYSCoreInterface.md">Set-QSYSCoreInterface</a>

<a href="docs/Set-QSYSCoreName.md">Set-QSYSCoreName</a>

<a href="docs/Set-QSYSCoreNTP.md">Set-QSYSCoreNTP</a>

<a href="docs/Set-QSYSCoreService.md">Set-QSYSCoreService</a>

<a href="docs/Set-QSYSCoreSNMPv2.md">Set-QSYSCoreSNMPv2</a>

<a href="docs/Set-QSYSCoreSNMPv3.md">Set-QSYSCoreSNMPv3</a>
