---
external help file: PS-QSYS-help.xml
Module Name: PS-QSYS
online version:
schema: 2.0.0
---

# Get-QSYSCoreServices

## SYNOPSIS
Retrieves the Q-SYS core's network service configuration.

## SYNTAX

```
Get-QSYSCoreServices [-Session] <QSYS_Session> [<CommonParameters>]
```

## DESCRIPTION
Retrieves the Q-SYS core's network service configuration.
This includes which services are enabled or disabled, and
which network interfaces they are reachable on.

Some network services may only be enabled or disabled globally.

## EXAMPLES

### EXAMPLE 1
```
Get-QSYSCoreServices -Session $qs
```

ID                 Description                               Enabled Interfaces                
--                 -----------                               ------- ----------                
discovery          Q-SYS Device Discovery                       True LAN A, LAN B, AUX A, AUX B
legacy             Q-SYS Designer Communications - Legacy       True LAN A, LAN B, AUX A, AUX B
secure             Q-SYS Designer Communications - Secure       True LAN A, LAN B, AUX A, AUX B
peripheralsAudio   Q-SYS Audio Enabled Peripherals              True LAN A, LAN B              
peripheralsControl Q-SYS Control Peripherals                    True LAN A, LAN B              
uci                Q-SYS UCI Viewers - Windows and iOS          True LAN A, LAN B, AUX A, AUX B
cameraDiscovery    Q-SYS Cameras                                True LAN A, LAN B              
qec                Q-SYS External Control Protocol - ASCII      True LAN A, LAN B, AUX A, AUX B
qrc                Q-SYS Remote Control Protocol - JSONRPC      True LAN A, LAN B, AUX A, AUX B
coreRedundancy     Q-SYS Core Redundancy                        True LAN A, LAN B              
ssh                Secure Maintenance & Support                 True LAN A, LAN B, AUX A, AUX B
mdns               Q-SYS Device Discovery via mDNS / Bonjour    True -                         
hovermon           Hovermon Audio                               True -

## PARAMETERS

### -Session
A Q-SYS session, as returned from New-QSYSSession

```yaml
Type: QSYS_Session
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
