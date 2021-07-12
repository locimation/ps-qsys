---
external help file: PS-QSYS-help.xml
Module Name: PS-QSYS
online version:
schema: 2.0.0
---

# Set-QSYSCoreService

## SYNOPSIS
Enables or disables a Q-SYS core network service.

## SYNTAX

### Enabled (Default)
```
Set-QSYSCoreService -Session <QSYS_Session> -Name <String> [-Enabled] [-Interfaces <String[]>]
 [<CommonParameters>]
```

### Disabled
```
Set-QSYSCoreService -Session <QSYS_Session> -Name <String> [-Disabled] [-Interfaces <String[]>]
 [<CommonParameters>]
```

### EnabledOnly
```
Set-QSYSCoreService -Session <QSYS_Session> -Name <String> [-Enabled] -Interfaces <String[]> [-Only]
 [<CommonParameters>]
```

## DESCRIPTION
Enables or disables a Q-SYS core network service.
Specific network interfaces to enable / disable
may be selected for most services.

## EXAMPLES

### EXAMPLE 1
```
Set-QSYSCoreService -Session $qs -Name "Hovermon Audio" -Disabled
```

Hovermon Audio is now disabled.

### EXAMPLE 2
```
Set-QSYSCoreService -Session $qs -Name "Hovermon Audio" -Enabled
```

Hovermon Audio is now enabled.

### EXAMPLE 3
```
Set-QSYSCoreService -Session $qs -Name "Q-SYS Cameras" -Disabled
```

Q-SYS Cameras:

LAN A : Disabled
LAN B : Disabled

### EXAMPLE 4
```
Set-QSYSCoreService -Session $qs -Name "Q-SYS Cameras" -Enabled
```

Q-SYS Cameras:

LAN A : Enabled
LAN B : Enabled

PS\> Set-QSYSCoreService -Session $qs -Name "Q-SYS Cameras" -Enabled -Interfaces "LAN A"
Q-SYS Cameras:

LAN A : Enabled
LAN B : Enabled

PS\> Set-QSYSCoreService -Session $qs -Name "Q-SYS Cameras" -Enabled -Interfaces "LAN A" -Only
Q-SYS Cameras:

LAN A : Enabled
LAN B : Disabled

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

### -Name
The service name, as seen in Get-QSYSCoreServices

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Disabled
Disables the network service.

```yaml
Type: SwitchParameter
Parameter Sets: Disabled
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Enabled
Enables the network service.

```yaml
Type: SwitchParameter
Parameter Sets: Enabled, EnabledOnly
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Interfaces
Specifies the list of network interfaces
to which the action (Disabled / Enabled)
will apply.

```yaml
Type: String[]
Parameter Sets: Enabled, Disabled
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String[]
Parameter Sets: EnabledOnly
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Only
When used in conjunction with the Enabled
switch, the service will be disabled on all
interfaces not listed in the Interfaces
parameter.

```yaml
Type: SwitchParameter
Parameter Sets: EnabledOnly
Aliases:

Required: True
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
