<#
This Powershell script is designed to be used with SCCM Orchestration Groups or standalone to put a server into Maintenance Mode in SCOM for 60 minutes
To use set variable SCOMServer to your SCOM servers name, $User to an account with Operator Privileges in SCOM, and this account must be a member of the "Remote Management Users"
group on the SCOM Server. Finally in $PWord enter the password for this account

NOTE PSRemoting must be enabled on the SCOM Server
#>

$SCOMServer = "xxxx"
$User = "domain\username"
$PWord = ConvertTo-SecureString -String "password" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord

$myFQDN=(Get-WmiObject win32_computersystem).DNSHostName+"."+(Get-WmiObject win32_computersystem).Domain
Invoke-Command -computername $SCOMServer -Credential $Credential -argumentlist $myFQDN -scriptblock {
	param ($myFQDN)
	Import-Module -Name OperationsManager
	$Instance = Get-SCOMClassInstance -Name $myFQDN
	$MMEntry = Get-SCOMMaintenanceMode -Instance $Instance
	$NewEndTime = (Get-Date)
	Set-SCOMMaintenanceMode -MaintenanceModeEntry $MMEntry -EndTime $NewEndTime -Comment "Finished Applying Software Update."
	}
		
