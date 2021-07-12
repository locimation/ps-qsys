---
external help file: PS-QSYS-help.xml
Module Name: PS-QSYS
online version:
schema: 2.0.0
---

# Set-QSYSCoreSNMPv3

## SYNOPSIS
Sets the Q-SYS core's SNMPv3 configuration.

## SYNTAX

```
Set-QSYSCoreSNMPv3 [-Session] <QSYS_Session> [[-Access] <String>] [[-Username] <String>] [[-Password] <String>]
 [[-SecurityLevel] <String>] [[-PrivPassword] <String>] [[-AuthProtocol] <String>] [[-Encryption] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Sets the Q-SYS core's SNMPv3 configuration, including:
 - Access
 - Community

## EXAMPLES

### EXAMPLE 1
```
Set-QSYSCoreSNMPv3 -Session $qs -Access ReadWrite -Username testuser -Password myauthpass -SecurityLevel AuthPriv -AuthProtocol SHA -Encryption AES -PrivPassword myprivpass
```

SNMPv3 Settings:

Access: ReadWrite
Username: testuser
SecurityLevel: AuthPriv
AuthProtocol: SHA
Encryption: AES

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
The level of access granted via SNMPv3

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

### -Username
The username for SNMPv3 authentication.

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

### -Password
The password for SNMPv3 authentication.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SecurityLevel
The SNMPv3 security level - one of:
 - NoAuthNoPriv (no authentication, no privacy)
 - AuthNoPriv (authentication, no privacy)
 - AuthPriv (authentication and privacy)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrivPassword
The password used for SNMPv3 privacy.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AuthProtocol
The protocol used for SNMPv3 authentication.
(MD5 or SHA)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Encryption
The encryption scheme used for SNMPv3 privacy
(AES or DES)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
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
