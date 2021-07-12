---
external help file: PS-QSYS-help.xml
Module Name: PS-QSYS
online version:
schema: 2.0.0
---

# Get-QSYSCoreDetails

## SYNOPSIS
Retrieves basic information about a Q-SYS core.

## SYNTAX

```
Get-QSYSCoreDetails [-Session] <QSYS_Session> [<CommonParameters>]
```

## DESCRIPTION
Retrieves basic information about a Q-SYS core, including:
 - Name
 - Model
 - Hardware ID
 - Firmware Version
 - Status

## EXAMPLES

### EXAMPLE 1
```
Get-QSYSCoreDetails -Session $qs
```

Name            : Core-1
Model           : Core 110f
HardwareID      : 3-12345678901234567890123456789012
FirmwareVersion : 9.0.1-2104.002
Status          : Idle

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
