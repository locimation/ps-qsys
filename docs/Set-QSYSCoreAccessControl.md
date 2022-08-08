---
external help file: PS-QSYS-help.xml
Module Name: PS-QSYS
online version:
schema: 2.0.0
---

# Set-QSYSCoreAccessControl

## SYNOPSIS
Sets the Q-SYS core's access control configuration.

## SYNTAX

### Enabled (Default)
```
Set-QSYSCoreAccessControl -Session <QSYS_Session> [-Enabled] -Username <String> -Password <String>
 [<CommonParameters>]
```

### Disabled
```
Set-QSYSCoreAccessControl -Session <QSYS_Session> [-Disabled] [<CommonParameters>]
```

## DESCRIPTION
Sets the Q-SYS core's access control configuration.
 - Access control enable / disable
 - First user's username / password

## EXAMPLES

### EXAMPLE 1
```
Set-QSYSCoreAccessControl -Session $qs -Disabled
```

### EXAMPLE 2
```
Set-QSYSCoreAccessControl -Session $qs -Enabled -Username myuser -Password mypassword
```

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
Disables access control.
Removes all users.

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
Enables access control.
Username and Password for first user required.

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

### -Username
Username for the first configured user.

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

### -Password
Password for the first configured user.

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
