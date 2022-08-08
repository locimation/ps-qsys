---
external help file: PS-QSYS-help.xml
Module Name: PS-QSYS
online version:
schema: 2.0.0
---

# Set-QSYSCoreInterface

## SYNOPSIS
Configures a Q-SYS core network interface.

## SYNTAX

### Static (Default)
```
Set-QSYSCoreInterface -Session <QSYS_Session> -Name <String> [-Static] -IPAddress <String> -SubnetMask <String>
 [-Gateway <String>] [<CommonParameters>]
```

### Disabled
```
Set-QSYSCoreInterface -Session <QSYS_Session> -Name <String> [-Disabled] [<CommonParameters>]
```

### Auto
```
Set-QSYSCoreInterface -Session <QSYS_Session> -Name <String> [-Auto] [<CommonParameters>]
```

## DESCRIPTION
Configures a Q-SYS core network interface, including:
 - Mode (static / auto / off)
 - IP Address
 - Subnet Mask
 - Gateway Address

## EXAMPLES

### EXAMPLE 1
```
Set-QSYSCoreInterface -Session $qs -Name "LAN B" -Disabled
```

LAN B is now disabled.

### EXAMPLE 2
```
Set-QSYSCoreInterface -Session $qs -Name "LAN B" -Auto
```

LAN B is now set to use automation configuration (DHCP / Auto-IP).

### EXAMPLE 3
```
Set-QSYSCoreInterface -Session $qs -Name "LAN B" -Static -IPAddress 192.168.1.42 -SubnetMask 255.255.255.0
```

LAN B is now set to use a static address:
IP Address  : 192.168.1.42
Subnet Mask : 255.255.255.0
Gateway     :

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
The name of the network interface to configure.

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
Disables the network interface.

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

### -Auto
Sets the network interface to use DHCP or Auto-IP.

```yaml
Type: SwitchParameter
Parameter Sets: Auto
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Static
Sets the network interface to use a static address.
The IPAddress and SubnetMask parameters are required.

```yaml
Type: SwitchParameter
Parameter Sets: Static
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -IPAddress
Specifies the static IP address for the interface.

```yaml
Type: String
Parameter Sets: Static
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SubnetMask
Specifies the subnet mask for the interface.

```yaml
Type: String
Parameter Sets: Static
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Gateway
Optionally specifies the gateway address for the interface.

```yaml
Type: String
Parameter Sets: Static
Aliases:

Required: False
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
