---
external help file: PS-QSYS-help.xml
Module Name: PS-QSYS
online version:
schema: 2.0.0
---

# Get-QSYSCoreNTP

## SYNOPSIS
Retrieves the Q-SYS core's NTP configuration.

## SYNTAX

```
Get-QSYSCoreNTP [-Session] <QSYS_Session> [<CommonParameters>]
```

## DESCRIPTION
Retrieves the Q-SYS core's NTP configuration, including:
 - Whether NTP is enabled, and
 - The configured NTP servers

## EXAMPLES

### EXAMPLE 1
```
Get-QSYSCoreNTP -Session $qs
```

Enabled Servers                         
------- -------                         
   True {0.pool.ntp.org, 1.pool.ntp.org}

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
