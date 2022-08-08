---
external help file: PS-QSYS-help.xml
Module Name: PS-QSYS
online version:
schema: 2.0.0
---

# Get-QSYSDeviceStatus

## SYNOPSIS
Gets the status of all devices in the Q-SYS system.

## SYNTAX

```
Get-QSYSDeviceStatus [-Session] <QSYS_Session> [<CommonParameters>]
```

## DESCRIPTION
Gets the status of all devices in the Q-SYS system, including:
 - Name
 - Model
 - Manufacturer
 - Location
 - Status
 - Status Detail

## EXAMPLES

### EXAMPLE 1
```
Get-QSYSDeviceStatus -Session $qs
```

Name         : Core-1
Model        : Core 110f
Manufacturer : QSC
Location     : Default Location
Status       : OK
StatusDetail : 

Name         : MS-RX-1
Model        : Media Stream Receiver
Manufacturer : QSC
Location     : Default Location
Status       : Initializing
StatusDetail : 

Name         : MS-RX-2
Model        : Media Stream Receiver
Manufacturer : QSC
Location     : Default Location
Status       : Not Present
StatusDetail : No Stream Specified

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
