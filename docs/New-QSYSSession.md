---
external help file: PS-QSYS-help.xml
Module Name: PS-QSYS
online version:
schema: 2.0.0
---

# New-QSYSSession

## SYNOPSIS
Creates a new HTTP session for communicating with a Q-SYS device.

## SYNTAX

### Unauthenticated (Default)
```
New-QSYSSession -HostName <String> [-SkipCertificateCheck] [<CommonParameters>]
```

### Authenticated
```
New-QSYSSession -HostName <String> -User <String> -Pass <String> [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Creates a new HTTP session for communicating with a Q-SYS device.

Optionally takes username and password parameters, and then
stores the resultant Bearer token for further requests.

## EXAMPLES

### EXAMPLE 1
```
$qs = New-QSYSSession -HostName 192.168.1.42 -SkipCertificateCheck
```

PS\> Get-QSYSCoreDetails -Session $qs

Name            : Core-1
Model           : Core 110f
HardwareID      : 3-12345678901234567890123456789012
FirmwareVersion : 9.0.1-2104.002
Status          : Idle

### EXAMPLE 2
```
$qs = New-QSYSSession -HostName 192.168.1.42 -User admin -Pass mypassword
```

PS\> Get-QSYSCoreDetails -Session $qs

Name            : Core-1
Model           : Core 110f
HardwareID      : 3-12345678901234567890123456789012
FirmwareVersion : 9.0.1-2104.002
Status          : Idle

## PARAMETERS

### -HostName
The IP address or DNS name of the device.

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

### -User
Specifies the username used to connect to the device.

```yaml
Type: String
Parameter Sets: Authenticated
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Pass
{{ Fill Pass Description }}

```yaml
Type: String
Parameter Sets: Authenticated
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipCertificateCheck
Disables validation of the device's HTTPS certificate.
This is required when the device has a self-signed
certificate that is not trusted by the local machine.

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
