Class QSYS_Session {

    [String] $HostName
    [String] $BearerToken
    [bool] $SkipCertificateCheck
    hidden [System.Net.Http.HttpClient] $HttpClient

    QSYS_Session() {
        $this.HttpClient = [System.Net.Http.HttpClient]::new();
        $this.HttpClient.DefaultRequestHeaders.Add("Accept", "application/json");

    }

    # TODO: switch to HTTPS
    [String] BaseUri() {
        return "http://" + $this.HostName
    }

    UpdateToken([String] $Token) {
        $this.BearerToken = $Token
    }

    [PSCustomObject] Request(
        [String] $EP,
        [String] $Method,
        [Object] $Body
    ) {

        try {
            if($this.SkipCertificateCheck) {
                [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true} ;
            }
            
            $Headers = @{
                Accept = "application/json"
            }

            if($this.BearerToken) {
                $Headers.Authorization = ("Bearer " + $this.BearerToken);
            }

            return Invoke-RestMethod `
                -Uri ($this.BaseUri() + $EP) `
                -Method $Method `
                -Body ($body | ConvertTo-Json -Depth 100) `
                -ContentType 'application/json' `
                -Headers $Headers
        } catch {
            if($_.Exception.ToString().Contains("trust relationship")) {
                "", "A TLS connection could not be established.",
                "This is likely because the core has an untrusted self-signed certificate.",
                "If you'd like to proceed anyway, try using the -SkipCertificateCheck flag.", "" | Write-Host
            }
            throw
        }

        return $null

    }

    [PSCustomObject] Request(
        [String] $EP
    ) { return $this.Request($EP, "GET", $null) }

    [PSCustomObject] UploadDesign(
        [String] $DesignCode,
        [String] $FilePath
    ) {

        $Content = [System.Net.Http.MultipartFormDataContent]::new();
        #$Content.Headers.Add("Accept", "application/json");
        $FileStream = [System.IO.File]::OpenRead($FilePath);
        $FileContent = [System.Net.Http.StreamContent]::new($FileStream);
        $FileContent.Headers.ContentType = "application/gzip";
        $TextContent = [System.Net.Http.StringContent]::new("untitled-design");
        $Content.Add($TextContent, "prettyname");
        $Content.Add($FileContent, "designtar", $DesignCode + ".tar.gz");

        $result = $this.HttpClient.PutAsync($this.BaseUri() + "/api-qsd/v0/designs/" + $DesignCode, $Content).Result;
        $result.EnsureSuccessStatusCode();
        
        return $result;

    }

}

Function New-QSYSSession {

<#

.SYNOPSIS
Creates a new HTTP session for communicating with a Q-SYS device.

.DESCRIPTION
Creates a new HTTP session for communicating with a Q-SYS device.

Optionally takes username and password parameters, and then
stores the resultant Bearer token for further requests.

.PARAMETER HostName
The IP address or DNS name of the device.

.PARAMETER User
Specifies the username used to connect to the device.

.PARAMETER Password
Specifies the password used to connect to the device.

.PARAMETER SkipCertificateCheck
Disables validation of the device's HTTPS certificate.
This is required when the device has a self-signed
certificate that is not trusted by the local machine.

.EXAMPLE
PS> $qs = New-QSYSSession -HostName 192.168.1.42 -SkipCertificateCheck
PS> Get-QSYSCoreDetails -Session $qs

Name            : Core-1
Model           : Core 110f
HardwareID      : 3-12345678901234567890123456789012
FirmwareVersion : 9.0.1-2104.002
Status          : Idle

.EXAMPLE
PS> $qs = New-QSYSSession -HostName 192.168.1.42 -User admin -Pass mypassword
PS> Get-QSYSCoreDetails -Session $qs

Name            : Core-1
Model           : Core 110f
HardwareID      : 3-12345678901234567890123456789012
FirmwareVersion : 9.0.1-2104.002
Status          : Idle

#>

    [CmdletBinding(DefaultParametersetName='Unauthenticated')] 
    param(
        [Parameter(mandatory)] [String] $HostName,
        [Parameter(ParameterSetName="Authenticated", mandatory)][String] $User,
        [Parameter(ParameterSetName="Authenticated", mandatory)][String] $Pass,
        [switch] $SkipCertificateCheck
    )

    $session = [QSYS_Session]@{
        HostName = $HostName;
        SkipCertificateCheck = $SkipCertificateCheck;
    }

    if($PSCmdlet.ParameterSetName -eq "Authenticated") {

        $response = $session.Request("/api/v0/logon", "POST", @{
            username = $User;
            password = $Pass;
        });

        if(-not($response.token)) {
            throw ("Failed to create session")
        }

        $session.UpdateToken($response.token);
    
    }

    return $session

}

Function Get-QSYSCoreDetails {

<#

.SYNOPSIS
Retrieves basic information about a Q-SYS core.

.DESCRIPTION
Retrieves basic information about a Q-SYS core, including:
 - Name
 - Model
 - Hardware ID
 - Firmware Version
 - Status

.PARAMETER Session
A Q-SYS session, as returned from New-QSYSSession

.EXAMPLE
PS> Get-QSYSCoreDetails -Session $qs

Name            : Core-1
Model           : Core 110f
HardwareID      : 3-12345678901234567890123456789012
FirmwareVersion : 9.0.1-2104.002
Status          : Idle

#>

    param([Parameter(mandatory)] [QSYS_Session] $Session)
    return $Session.Request("/api/v0/cores/self") | select -Property `
        @{ Name = 'Name'; Expression = {$_.name} },
        @{ Name = 'Model'; Expression = {$_.model} },
        @{ Name = 'HardwareID'; Expression = {$_.hardwareId} },
        @{ Name = 'FirmwareVersion'; Expression = {$_.firmware} },
        @{ Name = 'Status'; Expression = {$_.status.name} };
}

Function Set-QSYSCoreIdentify {

<#

.SYNOPSIS
Enables or disables Q-SYS core identification

.DESCRIPTION
Enables or disables Q-SYS core identification

.PARAMETER Session
A Q-SYS session, as returned from New-QSYSSession

.PARAMETER Disabled
Disables core identification

.EXAMPLE
PS> Set-QSYSCoreIdentify -Session $qs
Core identification is now enabled.

.EXAMPLE
PS> Set-QSYSCoreIdentify -Session $qs -Disabled
Core identification is now disabled.

#>

    param( [Parameter(mandatory)] [QSYS_Session] $Session, [switch] $Disabled )
    $response = $Session.Request("/api/v0/cores/self/config/id_mode", "PUT", @{ mode = !$Disabled.IsPresent  });
    ("Core identification is now " + $(if($response.mode) { "en" } else { "dis" }) + "abled.")
}

# Internal use only
Function _INT_GetNetConfig {
    param([Parameter(mandatory)] [QSYS_Session] $Session)
    $Session.Request("/api/v0/cores/self/config/network");
}

Function Get-QSYSCoreInterfaces {

<#

.SYNOPSIS
Retrieves a list of Q-SYS core network interfaces.

.DESCRIPTION
Retrieves a list of Q-SYS core network interfaces, and
their configuration and status information, including:
 - Interface Name
 - Mode (static / auto / off)
 - IP Address
 - Subnet Mask
 - Gateway Address
 - MAC Address
 - LLDP Chassis ID
 - LLDP Port Number

.PARAMETER Session
A Q-SYS session, as returned from New-QSYSSession

.EXAMPLE
PS> Get-QSYSCoreInterfaces -Session $qs

Name           : LAN A
Mode           : static
IPAddress      : 192.168.1.42
SubnetMask     : 255.255.255.0
Gateway        : 192.168.1.1
MACAddress     : 00:60:74:01:23:45
LLDPChassisID  : 00:11:22:33:44:55
LLDPPortNumber : 4

Name           : LAN B
Mode           : auto
IPAddress      : 
SubnetMask     : 
Gateway        : 
MACAddress     : 
LLDPChassisID  : 
LLDPPortNumber : 

#>

    param([Parameter(mandatory)] [QSYS_Session] $Session)
    _INT_GetNetConfig -Session $core | Select -ExpandProperty interfaces | Select -Property `
        @{ Name = 'Name'; Expression = {$_.name} },
        @{ Name = 'Mode'; Expression = {$_.mode} },
        @{ Name = 'IPAddress'; Expression = {$_.ipAddress} },
        @{ Name = 'SubnetMask'; Expression = {$_.netMask} },
        @{ Name = 'Gateway'; Expression = {$_.gateway} },
        @{ Name = 'MACAddress'; Expression = {$_.macAddress} },
        @{ Name = 'LLDPChassisID'; Expression = {$_.chassis} },
        @{ Name = 'LLDPPortNumber'; Expression = {$_.port} };
        
    #* -Exclude id, staticRoutes
}

Function Set-QSYSCoreInterface {
<#

.SYNOPSIS
Configures a Q-SYS core network interface.

.DESCRIPTION
Configures a Q-SYS core network interface, including:
 - Mode (static / auto / off)
 - IP Address
 - Subnet Mask
 - Gateway Address

.PARAMETER Session
A Q-SYS session, as returned from New-QSYSSession

.PARAMETER Name
The name of the network interface to configure.
 
.PARAMETER Disabled
Disables the network interface.

.PARAMETER Auto
Sets the network interface to use DHCP or Auto-IP.

.PARAMETER Static
Sets the network interface to use a static address.
The IPAddress and SubnetMask parameters are required.

.PARAMETER IPAddress
Specifies the static IP address for the interface.

.PARAMETER SubnetMask
Specifies the subnet mask for the interface.

.PARAMETER Gateway
Optionally specifies the gateway address for the interface.

.EXAMPLE
PS> Set-QSYSCoreInterface -Session $qs -Name "LAN B" -Disabled
LAN B is now disabled.

.EXAMPLE
PS> Set-QSYSCoreInterface -Session $qs -Name "LAN B" -Auto
LAN B is now set to use automation configuration (DHCP / Auto-IP).

.EXAMPLE
PS> Set-QSYSCoreInterface -Session $qs -Name "LAN B" -Static -IPAddress 192.168.1.42 -SubnetMask 255.255.255.0

LAN B is now set to use a static address:
IP Address  : 192.168.1.42
Subnet Mask : 255.255.255.0
Gateway     : 


#>
    [CmdletBinding(DefaultParametersetName='Static')] 
    param(
        [Parameter(mandatory)] [QSYS_Session] $Session,
        [Parameter(mandatory)] [String] $Name,
        [Parameter(ParameterSetName="Disabled", mandatory)] [switch] $Disabled,
        [Parameter(ParameterSetName="Auto", mandatory)] [switch] $Auto,
        [Parameter(ParameterSetName="Static", mandatory)] [switch] $Static,
        [Parameter(ParameterSetName="Static", mandatory)] [string] $IPAddress,
        [Parameter(ParameterSetName="Static", mandatory)] [string] $SubnetMask,
        [Parameter(ParameterSetName="Static")] [string] $Gateway
    )

    $interfaceFound = $false;
    $config = _INT_GetNetConfig -Session $Session;
    $config | select -ExpandProperty interfaces | Foreach {
        if($_.name -eq $Name) {

            $interfaceFound = $true;

            if($Disabled) {
                $_.mode = "off";
            } elseif($Auto) {
                $_.mode = "auto";
            } elseif($Static) {
                $_.mode = "static";
            }

            $_.ipAddress = $IPAddress;
            $_.netMask = $SubnetMask;
            $_.gateway = $Gateway;

        }
    }

    if(-not($interfaceFound)) {
        throw ('Interface "' + $Name + '" was not found on this core.');
    }
    
    $newConfig = $Session.Request("/api/v0/cores/self/config/network", "PUT", $config) `
         | select -ExpandProperty interfaces `
         | where Name -eq $Name;
    if($newConfig.mode -eq "off") {
        return ($Name + " is now disabled.");
    } elseif($newConfig.mode -eq "auto") {
        return ($Name + " is now set to use automation configuration (DHCP / Auto-IP)");
    } elseif($newConfig.mode -eq "static") {
        return ($Name + " is now set to use a static address:`r`n" + `
            "IP Address  : " + $newConfig.ipAddress + "`r`n" + ` 
            "Subnet Mask : " + $newConfig.netMask + "`r`n" + `
            "Gateway     : " + $newConfig.gateway + "`r`n" `
        );
    }
        
}

Function Set-QSYSCoreName {
<#

.SYNOPSIS
Sets a Q-SYS core's hostname.

.DESCRIPTION
Sets a Q-SYS core's hostname.

.PARAMETER Session
A Q-SYS session, as returned from New-QSYSSession

.PARAMETER Name
The new hostname for the Q-SYS core.

.EXAMPLE
PS> Set-QSYSCoreName -Session $qs -Name MyTestCore

Core name is set to "MyTestCore"


#>
    param([Parameter(mandatory)] [QSYS_Session] $Session, [Parameter(mandatory)] [string] $Name)
    $config = _INT_GetNetConfig -Session $Session;
    $config.hostname = $Name;
    $response = $Session.Request("/api/v0/cores/self/config/network", "PUT", $config);
    'Core name is set to "' + $response.hostname + '"';
}

Function Get-QSYSCoreDNS {
<#

.SYNOPSIS
Retrieves the Q-SYS core's DNS configuration.

.DESCRIPTION
Retrieves the Q-SYS core's DNS configuration, including:
 - Whether DNS is enabled, and
 - The configured DNS servers

.PARAMETER Session
A Q-SYS session, as returned from New-QSYSSession

.EXAMPLE
PS> Get-QSYSCoreDNS -Session $qs

Enabled Primary Secondary
------- ------- ---------
   True 1.1.1.1 8.8.8.8  


#>
    param([Parameter(mandatory)] [QSYS_Session] $Session)
    return _INT_GetNetConfig -Session $Session | Select -Property `
        @{ Name = 'Enabled'; Expression = {$_.enableDNS} },
        @{ Name = 'Primary'; Expression = {$_.primaryDNS} },
        @{ Name = 'Secondary'; Expression = {$_.secondaryDNS} };
}

Function Set-QSYSCoreDNS {
<#

.SYNOPSIS
Configures a Q-SYS core's DNS settings.

.DESCRIPTION
Configures a Q-SYS core's DNS settings, including:
 - Whether DNS is enabled, and
 - The configured DNS servers

.PARAMETER Session
A Q-SYS session, as returned from New-QSYSSession

.PARAMETER Disabled
Disables DNS on the Q-SYS core.
 
.PARAMETER Enabled
Enables DNS on the Q-SYS core. (Optional)
This parameter is implied by the Primary
and Secondary parameters, if supplied.

.PARAMETER Primary
Specifies the primary DNS server.

.PARAMETER Secondary
Specifies the secondary DNS server.

.EXAMPLE
PS> Set-QSYSCoreDNS -Session $qs -Disabled
DNS is now disabled.

.EXAMPLE
PS> Set-QSYSCoreDNS -Session $qs -Primary "1.1.1.1" -Secondary "8.8.8.8"

DNS is now enabled:
Primary   : 1.1.1.1
Secondary : 8.8.8.8


#>
    [CmdletBinding(DefaultParametersetName='Enabled')] 
    param(
        [Parameter(mandatory)] [QSYS_Session] $Session,
        [Parameter(ParameterSetName="Disabled")] [switch] $Disabled,
        [Parameter(ParameterSetName="Enabled")] [switch] $Enabled,
        [Parameter(ParameterSetName="Enabled", mandatory)] [string] $Primary,
        [Parameter(ParameterSetName="Enabled", mandatory)] [string] $Secondary
    )
    $config = _INT_GetNetConfig -Session $Session;
    $config.enableDNS = !$Disabled.IsPresent;
    $config.primaryDNS = $Primary;
    $config.secondaryDNS = $Secondary;

    $response = $Session.Request("/api/v0/cores/self/config/network", "PUT", $config);

    if($response.enableDNS) {
        return (
            "DNS is now enabled:`r`n" + `
            "Primary   : " + $response.primaryDNS + "`r`n" + `
            "Secondary : " + $response.secondaryDNS + "`r`n"
        );
    } else {
        return (
            "DNS is now disabled."
        );
    }

}

Function Get-QSYSCoreNTP {
<#

.SYNOPSIS
Retrieves the Q-SYS core's NTP configuration.

.DESCRIPTION
Retrieves the Q-SYS core's NTP configuration, including:
 - Whether NTP is enabled, and
 - The configured NTP servers

.PARAMETER Session
A Q-SYS session, as returned from New-QSYSSession

.EXAMPLE
PS> Get-QSYSCoreNTP -Session $qs

Enabled Servers                         
------- -------                         
   True {0.pool.ntp.org, 1.pool.ntp.org}


#>
    param([Parameter(mandatory)] [QSYS_Session] $Session)
    $Session.Request("/api/v0/cores/self/config/ntp") | Select -Property `
        @{ Name = 'Enabled'; Expression = {$_.enabled -eq "yes"} },
        @{ Name = 'Servers'; Expression = {$_.servers} };
}

Function Set-QSYSCoreNTP {
<#

.SYNOPSIS
Configures a Q-SYS core's NTP settings.

.DESCRIPTION
Configures a Q-SYS core's NTP settings, including:
 - Whether NTP is enabled, and
 - The configured NTP servers

.PARAMETER Session
A Q-SYS session, as returned from New-QSYSSession

.PARAMETER Disabled
Disables NTP on the Q-SYS core.
 
.PARAMETER Enabled
Enables NTP on the Q-SYS core.

.PARAMETER Servers
Specifies the list of NTP servers

.EXAMPLE
PS> Set-QSYSCoreNTP -Session $qs -Enabled
NTP is now enabled.

Servers:
 - 0.pool.ntp.org
 - 1.pool.ntp.org

.EXAMPLE
PS> Set-QSYSCoreNTP -Session $qs -Disabled
NTP is now disabled.

.EXAMPLE
PS> Set-QSYSCoreDNS -Session $qs -Primary "1.1.1.1" -Secondary "8.8.8.8"

NTP is now enabled.

Servers:
 - 0.pool.ntp.org
 - 1.pool.ntp.org


#>
    [CmdletBinding(DefaultParametersetName='None')] 
    param(
        [Parameter(mandatory)] [QSYS_Session] $Session,
        [string[]] $Servers,
        [Parameter(ParameterSetName="Disabled")] [switch] $Disabled,
        [Parameter(ParameterSetName="Enabled")] [switch] $Enabled
    )

    $config = $Session.Request("/api/v0/cores/self/config/ntp");
    if($Enabled) { $config.enabled = "yes"; }
    if($Disabled) { $config.enabled = "no"; }
    if($Servers) { $config.servers = $Servers; }

    
    $response = $Session.Request("/api/v0/cores/self/config/ntp", "PUT", $config);
    if($response.enabled -eq "yes") {
        return ("NTP is now enabled.`r`n`r`nServers:`r`n - " + [system.String]::Join("`r`n - ", $response.servers));
    } elseif($response.enabled -eq "no") {
        return ("NTP is now disabled.");
    }

}

Class QSYS_NetworkService {
    [string] $Name;
    [boolean] $Enabled;
    [string] $Interfaces;
}

Function Get-QSYSCoreServices {
<#

.SYNOPSIS
Retrieves the Q-SYS core's network service configuration.

.DESCRIPTION
Retrieves the Q-SYS core's network service configuration.
This includes which services are enabled or disabled, and
which network interfaces they are reachable on.

Some network services may only be enabled or disabled globally.

.PARAMETER Session
A Q-SYS session, as returned from New-QSYSSession

.EXAMPLE
PS> Get-QSYSCoreServices -Session $qs

ID                 Description                               Enabled Interfaces                
--                 -----------                               ------- ----------                
discovery          Q-SYS Device Discovery                       True LAN A, LAN B, AUX A, AUX B
legacy             Q-SYS Designer Communications - Legacy       True LAN A, LAN B, AUX A, AUX B
secure             Q-SYS Designer Communications - Secure       True LAN A, LAN B, AUX A, AUX B
peripheralsAudio   Q-SYS Audio Enabled Peripherals              True LAN A, LAN B              
peripheralsControl Q-SYS Control Peripherals                    True LAN A, LAN B              
uci                Q-SYS UCI Viewers - Windows and iOS          True LAN A, LAN B, AUX A, AUX B
cameraDiscovery    Q-SYS Cameras                                True LAN A, LAN B              
qec                Q-SYS External Control Protocol - ASCII      True LAN A, LAN B, AUX A, AUX B
qrc                Q-SYS Remote Control Protocol - JSONRPC      True LAN A, LAN B, AUX A, AUX B
coreRedundancy     Q-SYS Core Redundancy                        True LAN A, LAN B              
ssh                Secure Maintenance & Support                 True LAN A, LAN B, AUX A, AUX B
mdns               Q-SYS Device Discovery via mDNS / Bonjour    True -                         
hovermon           Hovermon Audio                               True - 


#>
    param([Parameter(mandatory)] [QSYS_Session] $Session)

    $NetworkServices = @();

    $Session.Request("/api/v0/cores/self/config/network/services") `
        | ForEach-Object {
            if($_.Enabled -is [System.Boolean]) {

                $NetworkServices += [QSYS_NetworkService]@{
                    Name = [string] $_.name;
                    Enabled = [System.Boolean] $_.enabled;
                    Interfaces = '-';
                }

            } else {

                [string[]] $InterfaceList = $();
                if($_.enabled.lanA) { $InterfaceList += "LAN A" };
                if($_.enabled.lanB) { $InterfaceList += "LAN B" };
                if($_.enabled.auxA) { $InterfaceList += "AUX A" };
                if($_.enabled.auxB) { $InterfaceList += "AUX B" };

                $NetworkServices += [QSYS_NetworkService]@{
                    Name = [string] $_.name;
                    Enabled = [System.Boolean] $_.enabled.lanA -or $_.enabled.lanB -or $_.enabled.lanB -or $_.enabled.lanB;
                    Interfaces = [system.String]::Join(", ", $InterfaceList);
                }

            }
        }

    return $NetworkServices;

}

Function Set-QSYSCoreService {
<#

.SYNOPSIS
Enables or disables a Q-SYS core network service.

.DESCRIPTION
Enables or disables a Q-SYS core network service.
Specific network interfaces to enable / disable
may be selected for most services.

.PARAMETER Session
A Q-SYS session, as returned from New-QSYSSession

.PARAMETER Name
The service name, as seen in Get-QSYSCoreServices
 
.PARAMETER Enabled
Enables the network service.

.PARAMETER Disabled
Disables the network service.

.PARAMETER Interfaces
Specifies the list of network interfaces
to which the action (Disabled / Enabled)
will apply.

.PARAMETER Only
When used in conjunction with the Enabled
switch, the service will be disabled on all
interfaces not listed in the Interfaces
parameter.

.EXAMPLE
PS> Set-QSYSCoreService -Session $qs -Name "Hovermon Audio" -Disabled
Hovermon Audio is now disabled.

.EXAMPLE
PS> Set-QSYSCoreService -Session $qs -Name "Hovermon Audio" -Enabled
Hovermon Audio is now enabled.

.EXAMPLE
PS> Set-QSYSCoreService -Session $qs -Name "Q-SYS Cameras" -Disabled
Q-SYS Cameras:

LAN A : Disabled
LAN B : Disabled

.EXAMPLE
PS> Set-QSYSCoreService -Session $qs -Name "Q-SYS Cameras" -Enabled
Q-SYS Cameras:

LAN A : Enabled
LAN B : Enabled

PS> Set-QSYSCoreService -Session $qs -Name "Q-SYS Cameras" -Enabled -Interfaces "LAN A"
Q-SYS Cameras:

LAN A : Enabled
LAN B : Enabled

PS> Set-QSYSCoreService -Session $qs -Name "Q-SYS Cameras" -Enabled -Interfaces "LAN A" -Only
Q-SYS Cameras:

LAN A : Enabled
LAN B : Disabled


#>
    [CmdletBinding(DefaultParametersetName='Enabled')] 
    param(
        [Parameter(mandatory)] [QSYS_Session] $Session,
        [Parameter(mandatory)] [string] $Name,

        [Parameter(mandatory, ParameterSetName="Disabled")]
        [switch] $Disabled,

        [Parameter(mandatory, ParameterSetName="Enabled")]
        [Parameter(mandatory, ParameterSetName="EnabledOnly")]
        [switch] $Enabled,

        [Parameter(ParameterSetName="Disabled")]
        [Parameter(ParameterSetName="Enabled")]
        [Parameter(mandatory, ParameterSetName="EnabledOnly")]
        [string[]] $Interfaces,

        [Parameter(mandatory, ParameterSetName="EnabledOnly")]
        [switch] $Only

    )

    $InterfaceMapping = @{
        lanA = "LAN A";
        lanB = "LAN B";
        auxA = "AUX A";
        auxB = "AUX B";
    }

    # Check provided interface names are valid
    if($Interfaces) {
        $Interfaces | Foreach {
            if($_ -notin $InterfaceMapping.Values) {
                throw ($_ + " is not a valid interface.");
            }
        }
    }

    $config = $Session.Request("/api/v0/cores/self/config/network/services");

    $serviceKey;
    $config | Foreach {
        if($_.name -eq $Name) {

            $serviceKey = $_.key;

            # Global services (not interface specific)
            if($_.enabled -is [System.Boolean]) {

                if($Interfaces) {
                    throw ($Name + " does not support per-interface configuration.");
                }

                $_.enabled = $Enabled.IsPresent;

            # Interface-specific services
            } else {

                $selected = @{};

                foreach($if in $InterfaceMapping.GetEnumerator()) {
                    $selected[$if.Name] = -not($Interfaces) -or ($Interfaces -ccontains $if.Value);
                }

                $_.enabled.PSObject.Properties | ForEach-Object {
                    if($Interfaces -and $Only) {
                        $_.Value = $selected[$_.Name];
                    } else {
                        if($selected[$_.Name]) { $_.Value = $Enabled.IsPresent };
                    }
                }
            }

        }
    }

    # Check service was found
    if(-not($serviceKey)) {
        throw ($Name + " is not a recognised Q-SYS network service.");
    }

    $response = $Session.Request("/api/v0/cores/self/config/network/services", "PUT", $config);
    $newState = $response.details | Select -ExpandProperty $serviceKey;

    if($newState -is [System.Boolean]) {
        return ($Name + " is now " + $(if($Enabled) { "en" } else { "dis" }) + "abled.");
    } else {
        $result = ($Name + ":`r`n`r`n");
        $newState.PSObject.Properties | ForEach-Object {
            $result += ($InterfaceMapping[$_.Name] + " : " + $(if($_.Value) { "En" } else { "Dis" }) + "abled`r`n");
        }
        return $result;
    }

}

Function Get-QSYSCoreSNMP {
<#

.SYNOPSIS
Retrieves the Q-SYS core's SNMP configuration.

.DESCRIPTION
Retrieves the Q-SYS core's SNMP configuration, including:

SNMPv2:
 - Access
 - Community

SNMPv3:
 - Access
 - Username
 - Security Level
 - Auth Protocol
 - Encryption

.PARAMETER Session
A Q-SYS session, as returned from New-QSYSSession

.PARAMETER Version
The SNMP version to retrieve settings for (2 or 3)

.EXAMPLE
PS> Get-QSYSCoreSNMP -Session $qs -Version 2

Access    Community
------    ---------
ReadWrite public

.EXAMPLE
PS> Get-QSYSCoreSNMP -Session $qs -Version 3

Access        : Read
SecurityLevel : AuthPriv
Username      : defaultuser
AuthProtocol  : MD5
Encryption    : AES


#>
    param(
        [Parameter(mandatory)] [QSYS_Session] $Session,

        [Parameter(mandatory)] 
        [ValidateSet(2,3)]
        [int] $Version
    )
    $response = $Session.Request("/api/v0/systems/1/snmp")
    
    if($Version -eq 2) {
        return $response | Select -Property `
            @{ Name = 'Access'; Expression = {$_.v2Access} },
            @{ Name = 'Community'; Expression = {$_.v2Community} };
    } elseif($Version -eq 3) {
        return $response | Select -Property `
            @{ Name = 'Access'; Expression = {$_.v3Access} },
            @{ Name = 'SecurityLevel'; Expression = {$_.v3SecurityLevel} },
            @{ Name = 'Username'; Expression = {$_.v3AuthUserName} },
            @{ Name = 'AuthProtocol'; Expression = {$_.v3AuthProtocol} },
            @{ Name = 'Encryption'; Expression = {$_.v3Encryption} };
    }
            
}

Function Set-QSYSCoreSNMPv2 {
<#

.SYNOPSIS
Sets the Q-SYS core's SNMPv2 configuration.

.DESCRIPTION
Sets the Q-SYS core's SNMPv2 configuration, including:
 - Access
 - Community

.PARAMETER Session
A Q-SYS session, as returned from New-QSYSSession

.PARAMETER Access
The level of access granted via SNMPv2

.PARAMETER Community
The SNMPv2 community name.

.EXAMPLE
PS> Set-QSYSCoreSNMPv2 -Session $qs -Access ReadWrite -Community public

SNMPv2 Settings:

Access: ReadWrite
Community: public


#>
    param(
        [Parameter(mandatory)] [QSYS_Session] $Session,
        [ValidateSet('None','Read','ReadWrite')] [string] $Access,
        [string] $Community
    )

    $config = $Session.Request("/api/v0/systems/1/snmp");
    if($Access) { $config.v2access = $Access; }
    if($Community) { $config.v2community = $Community; }

    $response = $Session.Request("/api/v0/systems/1/snmp", "PUT", $config);

    return(
        "SNMPv2 Settings:`r`n`r`n" +
        "Access: " + $response.v2Access + "`r`n" +
        "Community: " + $response.v2Community + "`r`n"
    );

}

Function Set-QSYSCoreSNMPv3 {
<#

.SYNOPSIS
Sets the Q-SYS core's SNMPv3 configuration.

.DESCRIPTION
Sets the Q-SYS core's SNMPv3 configuration, including:
 - Access
 - Community

.PARAMETER Session
A Q-SYS session, as returned from New-QSYSSession

.PARAMETER Access
The level of access granted via SNMPv3

.PARAMETER Username
The username for SNMPv3 authentication.

.PARAMETER Password
The password for SNMPv3 authentication.

.PARAMETER AuthProtocol
The protocol used for SNMPv3 authentication.
(MD5 or SHA)

.PARAMETER SecurityLevel
The SNMPv3 security level - one of:
 - NoAuthNoPriv (no authentication, no privacy)
 - AuthNoPriv (authentication, no privacy)
 - AuthPriv (authentication and privacy)

.PARAMETER PrivPassword
The password used for SNMPv3 privacy.

.PARAMETER Encryption
The encryption scheme used for SNMPv3 privacy
(AES or DES)

.EXAMPLE
PS> Set-QSYSCoreSNMPv3 -Session $qs -Access ReadWrite -Username testuser -Password myauthpass -SecurityLevel AuthPriv -AuthProtocol SHA -Encryption AES -PrivPassword myprivpass

SNMPv3 Settings:

Access: ReadWrite
Username: testuser
SecurityLevel: AuthPriv
AuthProtocol: SHA
Encryption: AES


#>
    param(
        [Parameter(mandatory)] [QSYS_Session] $Session,
        [ValidateSet('None','Read','ReadWrite')] [string] $Access,
        [string] $Username,
        [string] $Password,
        [ValidateSet('NoAuthNoPriv','AuthNoPriv','AuthPriv')][string] $SecurityLevel,
        [string] $PrivPassword,
        [ValidateSet('MD5','SHA')] [string] $AuthProtocol,
        [ValidateSet('AES', 'DES')] [string] $Encryption
    )

    $config = $Session.Request("/api/v0/systems/1/snmp");
    if($Access) { $config.v3Access = $Access; }
    if($Username) { $config.v3AuthUserName = $Username; }
    if($Password) { $config.v3AuthPassword = $Username; }
    if($SecurityLevel) { $config.v3SecurityLevel = $SecurityLevel; }
    if($PrivPassword) { $config.v3PrivPassword = $PrivPassword; }
    if($AuthProtocol) { $config.v3AuthProtocol = $AuthProtocol; }
    if($Encryption) { $config.v3Encryption = $Encryption; }

    $response = $Session.Request("/api/v0/systems/1/snmp", "PUT", $config);

    return(
        "SNMPv3 Settings:`r`n`r`n" +
        "Access: " + $response.v3Access + "`r`n" +
        "Username: " + $response.v3AuthUserName + "`r`n" +
        "SecurityLevel: " + $response.v3SecurityLevel + "`r`n" +
        "AuthProtocol: " + $response.v3AuthProtocol + "`r`n" +
        "Encryption: " + $response.v3Encryption + "`r`n"
    );

}

Function Set-QSYSCoreAccessControl {
<#

.SYNOPSIS
Sets the Q-SYS core's access control configuration.

.DESCRIPTION
Sets the Q-SYS core's access control configuration.
 - Access control enable / disable
 - First user's username / password

.PARAMETER Session
A Q-SYS session, as returned from New-QSYSSession

.PARAMETER Enabled
Enables access control.
Username and Password for first user required.

.PARAMETER Disabled
Disables access control.
Removes all users.

.PARAMETER Username
Username for the first configured user.

.PARAMETER Password
Password for the first configured user.

.EXAMPLE
PS> Set-QSYSCoreAccessControl -Session $qs -Disabled

.EXAMPLE
PS> Set-QSYSCoreAccessControl -Session $qs -Enabled -Username myuser -Password mypassword


#>
    [CmdletBinding(DefaultParametersetName='Enabled')] 
    param(
        [Parameter(mandatory)] [QSYS_Session] $Session,
        [Parameter(ParameterSetName="Disabled")] [switch] $Disabled,
        [Parameter(ParameterSetName="Enabled")] [switch] $Enabled,
        [Parameter(ParameterSetName="Enabled", mandatory)] [string] $Username,
        [Parameter(ParameterSetName="Enabled", mandatory)] [string] $Password
    )

    $currentConfig = $Session.Request("/api/v0/cores/self/access_mode")

    
    if($PSCmdlet.ParameterSetName -eq "Enabled") {

        if($currentConfig.accessMode -eq "protected") {
            throw "Access control is already enabled.";
        }

        $config = @{
            accessMode = "protected";
            removeUsers = $false;
            rootUser = @{
                username = $Username;
                password = $Password;
                passwordConfirm = $Password;
            }
        };

    } elseif($PSCmdlet.ParameterSetName -eq "Disabled") {

        if($currentConfig.accessMode -eq "open") {
            return "Access control is disabled.";
        }

        $config = @{
            accessMode = "open";
            removeUsers = $true;
        };

    }

    $response = $Session.Request("/api/v0/cores/self/access_mode", "PUT", $config);
    if($response.accessMode -eq "protected") {
        return "Access control is enabled.";
    } elseif($response.accessMode -eq "open") {
        return "Access control is disabled.";
    }


}

Function Restart-QSYSCore {
<#

.SYNOPSIS
Restarts the Q-SYS core.

.DESCRIPTION
Restarts the Q-SYS core.

.PARAMETER Session
A Q-SYS session, as returned from New-QSYSSession

.EXAMPLE
PS> Restart-QSYSCore -Session $qs


#>
    param([Parameter(mandatory)] [QSYS_Session] $Session);
    $Session.Request("/api/v0/cores/self/config/reboot", "PUT", $null);
}

Function Get-QSYSDeviceStatus {
<#

.SYNOPSIS
Gets the status of all devices in the Q-SYS system.

.DESCRIPTION
Gets the status of all devices in the Q-SYS system, including:
 - Name
 - Model
 - Manufacturer
 - Location
 - Status
 - Status Detail

.PARAMETER Session
A Q-SYS session, as returned from New-QSYSSession

.EXAMPLE
PS> Get-QSYSDeviceStatus -Session $qs

Name         : Core-1
Model        : Core 110f
Manufacturer : QSC
Location     : Default Location
Status       : OK
StatusDetail : 

Name         : MS-RX-1
Model        : Media Stream Receiver
Manufacturer : QSC
Location     : Default Location
Status       : Initializing
StatusDetail : 

Name         : MS-RX-2
Model        : Media Stream Receiver
Manufacturer : QSC
Location     : Default Location
Status       : Not Present
StatusDetail : No Stream Specified


#>
    param([Parameter(mandatory)] [QSYS_Session] $Session);
    $Session.Request("/api/v0/systems/1/items") `
        | Select -Property `
            @{ Name = 'Name'; Expression = {$_.name} },
            @{ Name = 'Model'; Expression = {$_.model} },
            @{ Name = 'Manufacturer'; Expression = {$_.manufacturer} },
            @{ Name = 'Location'; Expression = {$_.location} },
            @{ Name = 'Status'; Expression = {$_.status.message} },
            @{ Name = 'StatusDetail'; Expression = {$_.status.details} };
}

Function _INT_GetDesignerVersions {
    $InstalledSoftware = Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall";
    $DesignerVersions = @();
    foreach($obj in $InstalledSoftware){
        $name = $obj.GetValue('DisplayName');
        if($name -like "Q-Sys Designer *") {
            $version = ($obj.GetValue('DisplayName') | Select-String -Pattern "(\d+\.\d+)$").Matches.Groups[1].Value;
            $DesignerVersions += [pscustomobject]@{ Version = $version; Path = $obj.GetValue('InstallLocation') };
        }
    }
    $DesignerVersions | Sort-Object -Property Version -Descending
}

Function _INT_GetDesignFileVersion {
    param(
        [Parameter(mandatory)] [String] $File
    );
    
    $header = [System.Text.Encoding]::ASCII.GetString((Get-Content $File -Encoding byte -TotalCount 64));
    return ($header | Select-String -Pattern "Q-Sys Designer, Version=(\d+\.\d+)").Matches.Groups[1].Value;

}

Function _INT_GetBestQSYSDesignerForFile {
    param(
        [Parameter(mandatory)] [pscustomobject[]] $DesignerVersions,
        [Parameter(mandatory)] [String] $FileVersion
    );

    # Natural Sorting
    $PaddedDesignerVersions = $DesignerVersions | Select @{Name = 'VX'; Expression = { `
        [regex]::Replace($_.Version, '\d+', { $args[0].Value.PadLeft(20,'0') }) `
    }};

    $BestVersions = ($PaddedDesignerVersions | Sort-Object -Property Version | Where-Object {$_.Version -gt $FileVersion});
    if($BestVersions) { return $BestVersions[0]; } else { return $null; }

}

Function _INT_GetQSYSDesignState {
    param([Parameter(mandatory)] [QSYS_Session] $Session);
    $Session.Request("/api-qsd/v0/designs/undefined") | select -ExpandProperty status
}

Function _INT_SetQSYSDesignState {
    param(
        [Parameter(mandatory)] [QSYS_Session] $Session,
        [Parameter(ParameterSetName="Start", mandatory)] [switch] $Start,
        [Parameter(ParameterSetName="Stop", mandatory)] [switch] $Stop
    );

    $DesignCode = Get-QSYSDesignState -Session $Session | select -ExpandProperty code;

    $RequestBody;

    if($PSCmdlet.ParameterSetName -eq "Stop") {
        $RequestBody = @{ name = "stop" };
    } else {
        $RequestBody = @{ name = "start" };
    }
    $Session.Request(("/api-qsd/v0/designs/"+$DesignCode+"/commands"), "POST", $RequestBody);
}

Function _INT_StopDesign {
    param([Parameter(mandatory)] [QSYS_Session] $Session)
    Write-Host -NoNewline "Waiting for design to stop...";
    _INT_SetDesignState -Session $Session -Stop | Out-Null;
    $WaitCycles = 50;
    $DesignState | Out-Null;
    while($WaitCycles -gt 0) {
        Write-Host -NoNewline ".";
        $DesignState = _INT_GetQSYSDesignState -Session $core | select -ExpandProperty stateId;
        if($DesignState -eq 0) { break; }
        Start-Sleep -Seconds 1;
        $WaitCycles--;
    }

    if($DesignState -eq 0) {
        Write-Output " done";
    } else {
        Write-Output " timed out.";
    }

}

Function Push-QSYSDesign {
<#

.SYNOPSIS
Uploads a Q-SYS design file to a core.

.DESCRIPTION
Uploads a Q-SYS design file to a core.
The design is compiled using the most
appropriate version of Q-SYS Designer
installed on the local computer.

The resulting package is then uploaded
to the core, and the design is started.

.PARAMETER Session
A Q-SYS session, as returned from New-QSYSSession

.PARAMETER File
Path to the Q-SYS design file

.EXAMPLE
PS> Push-QSYSDesign -Session $qs -File .\MyDesignFile.qsys


#>
    param(
        [Parameter(mandatory)] [QSYS_Session] $Session,
        [Parameter(mandatory)] [String] $File,
        [switch] $AllowNewerDesigner
    );

    # Determine which version of Designer to use

    $FileVersion = _INT_GetDesignFileVersion -File $File;
    $DesignerVersions = _INT_GetDesignerVersions;

    $SelectedVersion;

    $IdealDesigner = $DesignerVersions | Where-Object {$_.Version -eq $FileVersion};
    if($IdealDesigner) {
        $SelectedVersion = $IdealDesigner
    } else {
        if(-not($AllowNewerDesigner)) {
            Write-Output "","A suitable version of Q-SYS Designer could not be found.", `
                         ("The file version is " + $FileVersion + ", but the only installed versions are:");
            Write-Output $DesignerVersions | select Version;
            Write-Output "","You may wish to use a newer version of Designer,","by passing the -AllowNewerDesigner switch."
            return;
        } else {
            $SelectedVersion = _INT_GetBestQSYSDesignerForFile -DesignerVersions $DesignerVersions -FileVersion $FileVersion;
            if(-not($SelectedVersion)) {
                Write-Output "","A suitable version of Q-SYS Designer could not be found.", `
                             ("The file version is " + $FileVersion + ", but the only installed versions are:");
                Write-Output $DesignerVersions | select Version;
                return;
            }
        }
    }

    $DesignerExe = Get-ChildItem -Path $SelectedVersion.Path -Filter "*Designer.exe" | select -ExpandProperty FullName;
    Write-Output "",("Using Designer version " + $SelectedVersion.Version + " (" + $DesignerExe + ")");

    # Compile design file

    $TempDir = (Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid()));
    Write-Output "", ("Creating working directory (" + $TempDir + ")...");
    New-Item -ItemType Directory -Path $TempDir | Out-Null;
    New-Item -ItemType Directory -Path ($TempDir + "\designfiles\temp") | Out-Null;

    Write-Output ""
    Write-Host -NoNewline "Starting compile...";

    Start-Process `
        -Wait `
        -FilePath $DesignerExe `
        -ArgumentList @("/build:"+$File, "/output:"+$TempDir+"\designfiles\temp");

    $CompileIDFilePath = $TempDir + "\designfiles\temp\compile_id";
    if(-not(Test-Path $CompileIDFilePath -PathType Leaf)) {
        Write-Output " failed.";
        return;
    }

    $CompileID = Get-Content -Path $CompileIDFilePath;
    Write-Output " done",("Compile ID is " + $CompileID + ".");

    # Package design

    Write-Host -NoNewline "Packaging design...";
    $DesignDirectory = $TempDir+"\designfiles\"+$CompileID;
    Rename-Item ($TempDir+"\designfiles\temp") ($DesignDirectory);
    
    $Package = $TempDir+"\designpackage.tar.gz";
    [System.Reflection.Assembly]::LoadFrom($SelectedVersion.Path + "\ICSharpCode.SharpZipLib.dll") | Out-Null;
    $FileStream = [System.IO.File]::Create($TempDir+"\designpackage.tar.gz");
    $GZipStream = [ICSharpCode.SharpZipLib.GZip.GZipOutputStream]::new($FileStream);
    $TarArchive = [ICSharpCode.SharpZipLib.Tar.TarArchive]::CreateOutputTarArchive($GZipStream);

    $TarArchive.RootPath = ($TempDir+"\designfiles").Replace('\\', '/');
    if ($TarArchive.RootPath.EndsWith("/")) {
        $TarArchive.RootPath = $TarArchive.RootPath.Remove($TarArchive.RootPath.Length - 1);
    }

    $TarEntry = [ICSharpCode.SharpZipLib.Tar.TarEntry]::CreateEntryFromFile($TempDir+"\designfiles");
    $TarEntry.Name = $CompileID;
    $TarArchive.WriteEntry($TarEntry, $true);

    $TarArchive.Close();

    if(-not(Test-Path $Package -PathType Leaf)) {
        Write-Output " failed.";
        return;
    }

    Write-Output " done";


    # Get core ready for upload

    Write-Output "";
    _INT_StopDesign -Session $Session;

    # Upload files
    $Session.UploadDesign($CompileID, $Package);

}

Export-ModuleMember *-*


#### TESTS ####


#$core = New-QSYSSession -HostName "10.10.10.4" -SkipCertificateCheck

#Get-QSYSCoreDetails -Session $core | Write-Host

#Get-QSYSDesignerVersions

# Upload-QSYSDesign -Session $core -File .\untitled-design.qsys -AllowNewerDesigner

#Get-QSYSCoreDetails -Session $core

#Get-QSYSDeviceStatus -Session $core

#Identify-QSYSCore -Session $core -Disable

#Set-QSYSCoreName -Session $core -Name "Core-1"

#Set-QSYSCoreDNS -Session $core -Primary "1.1.1.1" -Secondary "8.8.8.8"

#Get-QSysCoreInterfaces -Session $core

#Get-QSysCoreInterface -Session $core -Name "LAN A"

#Set-QSysCoreInterface -Session $core -Name "LAN B" -Auto

#Get-QSYSCoreNTP -Session $core

#Set-QSYSCoreNTP -Session $core -Servers 0.pool.ntp.org, 1.pool.ntp.org

#Get-QSYSCoreServices -Session $core

#Get-QSYSCoreSNMP -Session $core

#Set-QSYSCoreAccessControl -Session $core -Disabled

#Reboot-QSYSCore -Session $core