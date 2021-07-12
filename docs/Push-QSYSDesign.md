---
external help file: PS-QSYS-help.xml
Module Name: PS-QSYS
online version:
schema: 2.0.0
---

# Push-QSYSDesign

## SYNOPSIS
Uploads a Q-SYS design file to a core.

## SYNTAX

```
Push-QSYSDesign [-Session] <QSYS_Session> [-File] <String> [-AllowNewerDesigner] [<CommonParameters>]
```

## DESCRIPTION
Uploads a Q-SYS design file to a core.
The design is compiled using the most
appropriate version of Q-SYS Designer
installed on the local computer.

The resulting package is then uploaded
to the core, and the design is started.

## EXAMPLES

### EXAMPLE 1
```
Push-QSYSDesign -Session $qs -File .\MyDesignFile.qsys
```

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

### -File
Path to the Q-SYS design file

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

### -AllowNewerDesigner
{{ Fill AllowNewerDesigner Description }}

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
