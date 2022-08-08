---
external help file: PS-QSYS-help.xml
Module Name: PS-QSYS
online version:
schema: 2.0.0
---

# Set-QSYSCoreSNMPv2

## SYNOPSIS
Sets the Q-SYS core's SNMPv2 configuration.

## SYNTAX

```
Set-QSYSCoreSNMPv2 [-Session] <QSYS_Session> [[-Access] <String>] [[-Community] <String>] [<CommonParameters>]
```

## DESCRIPTION
Sets the Q-SYS core's SNMPv2 configuration, including:
 - Access
 - Community

## EXAMPLES

### EXAMPLE 1
```
Set-QSYSCoreSNMPv2 -Session $qs -Access ReadWrite -Community public
```

SNMPv2 Settings:

Access: ReadWrite
Community: public

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

### -Access
The level of access granted via SNMPv2

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Community
The SNMPv2 community name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
