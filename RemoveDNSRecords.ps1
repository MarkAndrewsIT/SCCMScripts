<#
This script removes multiple DNS names for a single server by getting it's IP Address and connecting to a Windows DNS Server and removing all the names in the array DNSNames
For this to work the account in $User must be a member of DNSAdmins and Remote Management Users. If it is a domain Admin (not recommended) this is not necessary
1. Open Computer Management Console. Right click WMI Control (under Services and Applications) and click property.
2. In the newly open Window, click on Security tab.
3. Expand Root tree, and then click on the node CIMV2, and click the button security
4. In the newly open Window, click the button Advanced.
5. In the newly open Window, click the button Add under the permission tab.
6. In the newly open Window, click on “select a principal”, then search and add the group DNSAdmins as the principal, then click ok.
7. In the applies to, choose “this namespace and subnamespace”.
8. For the permission, check on “Execute Methods”, “Enable Accounts” and “Remote Enable”
9. Click OK three times.
10. Then navigate to the node Root – Microsoft – Windows – DNS. Do the same things, add permission for DNSAdmins.
11. Restart service “Windows Management Instrumentation.

#>

$User = "domain\username"
$PWord = ConvertTo-SecureString -String "passwordforuser" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
$DNSServer = "DNSServerName"
$DNSNames = @(
	("servername1","domain"),
	("servername2","domain"),
	("servername3","domain")
)

$IPAddr = Get-NetIPAddress -AddressFamily ipv4 | Where-Object {$_.Interfaceindex -ne "1"} | select -ExpandProperty IPAddress

Invoke-Command -computername $DNSServer -Credential $Credential -argumentlist ($DNSServer, $IPAddr, $DNSNames) -scriptblock {
	param ($DNSServer,$IPAddr,$DNSNames)
	
	for ($i = 0; $i -lt $DNSNames.Count; $i++) {
		$name = $DNSNames[$i][0]
		$zone = $DNSNames[$i][1]
		write-host "$DNSServer $name.$zone"
		Remove-DnsServerResourceRecord -ComputerName $DNSServer -ZoneName $zone -RRType "A" -Name $name -RecordData $IPAddr -force
	}
	
}
