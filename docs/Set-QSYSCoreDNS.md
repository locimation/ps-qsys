---
external help file: PS-QSYS-help.xml
Module Name: PS-QSYS
online version:
schema: 2.0.0
---

# Set-QSYSCoreDNS

## SYNOPSIS
Configures a Q-SYS core's DNS settings.

## SYNTAX

### Enabled (Default)
```
Set-QSYSCoreDNS -Session <QSYS_Session> [-Enabled] -Primary <String> -Secondary <String> [<CommonParameters>]
```

### Disabled
```
Set-QSYSCoreDNS -Session <QSYS_Session> [-Disabled] [<CommonParameters>]
```

## DESCRIPTION
Configures a Q-SYS core's DNS settings, including:
 - Whether DNS is enabled, and
 - The configured DNS servers

## EXAMPLES

### EXAMPLE 1
```
Set-QSYSCoreDNS -Session $qs -Disabled
```

DNS is now disabled.

### EXAMPLE 2
```
Set-QSYSCoreDNS -Session $qs -Primary "1.1.1.1" -Secondary "8.8.8.8"
```

DNS is now enabled:
Primary   : 1.1.1.1
Secondary : 8.8.8.8

## PARAMETERS

### -Session
A Q-SYS session, as returned from New-QSYSSession

```yaml
Type: QSYS_Session
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Disabled
Disables DNS on the Q-SYS core.

```yaml
Type: SwitchParameter
Parameter Sets: Disabled
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Enabled
Enables DNS on the Q-SYS core.
(Optional)
This parameter is implied by the Primary
and Secondary parameters, if supplied.

```yaml
Type: SwitchParameter
Parameter Sets: Enabled
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Primary
Specifies the primary DNS server.

```yaml
Type: String
Parameter Sets: Enabled
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Secondary
Specifies the secondary DNS server.

```yaml
Type: String
Parameter Sets: Enabled
Aliases:

Required: True
Position: Named
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
