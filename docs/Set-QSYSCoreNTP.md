---
external help file: PS-QSYS-help.xml
Module Name: PS-QSYS
online version:
schema: 2.0.0
---

# Set-QSYSCoreNTP

## SYNOPSIS
Configures a Q-SYS core's NTP settings.

## SYNTAX

### None (Default)
```
Set-QSYSCoreNTP -Session <QSYS_Session> [-Servers <String[]>] [<CommonParameters>]
```

### Disabled
```
Set-QSYSCoreNTP -Session <QSYS_Session> [-Servers <String[]>] [-Disabled] [<CommonParameters>]
```

### Enabled
```
Set-QSYSCoreNTP -Session <QSYS_Session> [-Servers <String[]>] [-Enabled] [<CommonParameters>]
```

## DESCRIPTION
Configures a Q-SYS core's NTP settings, including:
 - Whether NTP is enabled, and
 - The configured NTP servers

## EXAMPLES

### EXAMPLE 1
```
Set-QSYSCoreNTP -Session $qs -Enabled
```

NTP is now enabled.

Servers:
 - 0.pool.ntp.org
 - 1.pool.ntp.org

### EXAMPLE 2
```
Set-QSYSCoreNTP -Session $qs -Disabled
```

NTP is now disabled.

### EXAMPLE 3
```
Set-QSYSCoreDNS -Session $qs -Primary "1.1.1.1" -Secondary "8.8.8.8"
```

NTP is now enabled.

Servers:
 - 0.pool.ntp.org
 - 1.pool.ntp.org

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

### -Servers
Specifies the list of NTP servers

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Disabled
Disables NTP on the Q-SYS core.

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
Enables NTP on the Q-SYS core.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
