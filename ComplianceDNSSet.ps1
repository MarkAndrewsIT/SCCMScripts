<#
This Powershell script can be used in SCCM Compliance to set DNS Servers a particular way. 
Set the DNS server IPs as you need in the variables at the top.
If you require more or less DNS Servers, add/remove variables that store the IP Addresses, 
and add/remove -AND ($IPList.DNSServerSearchOrder[X] -eq $serverX) sections from the code.
If the settings match it returns "Complaint", or if not matching "Not Compliant" which can be checked for in a baseline rule
#>
$server0 = "x.x.x.x"
$server1 = "x.x.x.x"
$server2 = "x.x.x.x"
$server3 = "x.x.x.x"

$IPList = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName .
$i = 0
$nicwithdnscount = 0
$conformity = "Not Compliant"

if ($IPList.Count -ne $null)
	{
		while ($i -ne $IPList.Count)
			{
			try{
				if ($IPList[$i].DNSServerSearchOrder[0] -ne $null)
					{
						$nicwithdnscount = $nicwithdnscount + 1
					}
				if (($IPList[$i].DNSServerSearchOrder[2] -eq $null))
					{
						if (($IPList[$i].DNSServerSearchOrder[0] -ne $null) -AND ($IPList[$i].DNSServerSearchOrder[1] -ne $null))
							{
								if (($IPList[$i].DNSServerSearchOrder[0] -eq $server0) -AND ($IPList[$i].DNSServerSearchOrder[1] -eq $server1) -AND ($IPList[$i].DNSServerSearchOrder[2] -eq $server2) -AND ($IPList[$i].DNSServerSearchOrder[3] -eq $server3))
									{
										$conformity = "Compliant"
									}
						else
							{
								$conformity = "Not Compliant"
							}
					}
				}
			}
			catch
				{

				}

			$i = $i + 1
			if ($nicwithdnscount -ne 1)
				{
					$conformity = "Not Compliant"
				}
			}
	}
else
	{
		try{
			if ($IPList.DNSServerSearchOrder[0] -ne $null)
				{
					$nicwithdnscount = $nicwithdnscount + 1
				}
			if (($IPList.DNSServerSearchOrder[2] -eq $null))
				{
					if (($IPList.DNSServerSearchOrder[0] -ne $null) -AND ($IPList.DNSServerSearchOrder[1] -ne $null))
						{
							if (($IPList.DNSServerSearchOrder[0] -eq $server0) -AND ($IPList.DNSServerSearchOrder[1] -eq $server1) -AND ($IPList[$i].DNSServerSearchOrder[2] -eq $server2) -AND ($IPList[$i].DNSServerSearchOrder[3] -eq $server3))
								{
									$conformity = "Compliant"
								}
							else
								{
									$conformity = "Not Compliant"
								}
						}
				}
			}
		catch
			{

			}
		}

$i = 0
if (($conformity -eq "Not Compliant") -AND ($nicwithdnscount -eq 1))

	{
		if ($IPList.Count -ne $null)
			{
				while ($i -ne $IPList.Count)
					{
						try{
							if ($IPList[$i].DNSServerSearchOrder[0] -ne $null)
								{
									$arrDNSServers = $server0, $server1, $server2, $server3
									$IPList[$i].SetDNSServerSearchOrder($arrDNSServers)
								}
							}
						catch
							{

							}
						$i = $i + 1

					}

			}
		else
			{
				try{
					if ($IPList.DNSServerSearchOrder[0] -ne $null)
						{
							$arrDNSServers = $server0, $server1, $server2, $server3
							$IPList.SetDNSServerSearchOrder($arrDNSServers)
						}
					}
			catch
				{

				}
			}
	}
