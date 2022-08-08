---
external help file: PS-QSYS-help.xml
Module Name: PS-QSYS
online version:
schema: 2.0.0
---

# Get-QSYSCoreSNMP

## SYNOPSIS
Retrieves the Q-SYS core's SNMP configuration.

## SYNTAX

```
Get-QSYSCoreSNMP [-Session] <QSYS_Session> [-Version] <Int32> [<CommonParameters>]
```

## DESCRIPTION
Retrieves the Q-SYS core's SNMP configuration, including:

SNMPv2:
 - Access
 - Community

SNMPv3:
 - Access
 - Username
 - Security Level
 - Auth Protocol
 - Encryption

## EXAMPLES

### EXAMPLE 1
```
Get-QSYSCoreSNMP -Session $qs -Version 2
```

Access    Community
------    ---------
ReadWrite public

### EXAMPLE 2
```
Get-QSYSCoreSNMP -Session $qs -Version 3
```

Access        : Read
SecurityLevel : AuthPriv
Username      : defaultuser
AuthProtocol  : MD5
Encryption    : AES

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

### -Version
The SNMP version to retrieve settings for (2 or 3)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
