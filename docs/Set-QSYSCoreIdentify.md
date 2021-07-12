---
external help file: PS-QSYS-help.xml
Module Name: PS-QSYS
online version:
schema: 2.0.0
---

# Set-QSYSCoreIdentify

## SYNOPSIS
Enables or disables Q-SYS core identification

## SYNTAX

```
Set-QSYSCoreIdentify [-Session] <QSYS_Session> [-Disabled] [<CommonParameters>]
```

## DESCRIPTION
Enables or disables Q-SYS core identification

## EXAMPLES

### EXAMPLE 1
```
Set-QSYSCoreIdentify -Session $qs
```

Core identification is now enabled.

### EXAMPLE 2
```
Set-QSYSCoreIdentify -Session $qs -Disabled
```

Core identification is now disabled.

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

### -Disabled
Disables core identification

```yaml
Type: SwitchParameter
Parameter Sets: (All)
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
