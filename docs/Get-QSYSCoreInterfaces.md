---
external help file: PS-QSYS-help.xml
Module Name: PS-QSYS
online version:
schema: 2.0.0
---

# Get-QSYSCoreInterfaces

## SYNOPSIS
Retrieves a list of Q-SYS core network interfaces.

## SYNTAX

```
Get-QSYSCoreInterfaces [-Session] <QSYS_Session> [<CommonParameters>]
```

## DESCRIPTION
Retrieves a list of Q-SYS core network interfaces, and
their configuration and status information, including:
 - Interface Name
 - Mode (static / auto / off)
 - IP Address
 - Subnet Mask
 - Gateway Address
 - MAC Address
 - LLDP Chassis ID
 - LLDP Port Number

## EXAMPLES

### EXAMPLE 1
```
Get-QSYSCoreInterfaces -Session $qs
```

Name           : LAN A
Mode           : static
IPAddress      : 192.168.1.42
SubnetMask     : 255.255.255.0
Gateway        : 192.168.1.1
MACAddress     : 00:60:74:01:23:45
LLDPChassisID  : 00:11:22:33:44:55
LLDPPortNumber : 4

Name           : LAN B
Mode           : auto
IPAddress      : 
SubnetMask     : 
Gateway        : 
MACAddress     : 
LLDPChassisID  : 
LLDPPortNumber :

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
