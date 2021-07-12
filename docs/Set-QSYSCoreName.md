---
external help file: PS-QSYS-help.xml
Module Name: PS-QSYS
online version:
schema: 2.0.0
---

# Set-QSYSCoreName

## SYNOPSIS
Sets a Q-SYS core's hostname.

## SYNTAX

```
Set-QSYSCoreName [-Session] <QSYS_Session> [-Name] <String> [<CommonParameters>]
```

## DESCRIPTION
Sets a Q-SYS core's hostname.

## EXAMPLES

### EXAMPLE 1
```
Set-QSYSCoreName -Session $qs -Name MyTestCore
```

Core name is set to "MyTestCore"

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

### -Name
The new hostname for the Q-SYS core.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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
