#requires -version 2
<#
.SYNOPSIS
  Detail Load Index information from Citrix environment
.DESCRIPTION
  This Script will retrieve the deatil Load Index information from your Citrix Environment.
.PARAMETER
  None
.INPUTS
  None
.OUTPUTS
  Output of results on screen
.NOTES
  Version:        1.0
  Author:         Nik Heyligers
  Creation Date:  2020-04-22
  Purpose/Change: Initial script development
  
.EXAMPLE
  Run Script on Delivery Controller or on a machines with Citrix Powershell cmdlets installed
#>

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#Set Error Action to Silently Continue
	$ErrorActionPreference = "SilentlyContinue"
#Load Citrix cmdlets
	asnp Citrix*

#----------------------------------------------------------[Declarations]----------------------------------------------------------

#Script Version
	$sScriptVersion = "1.0"

#Desktop Delivery Controller
	$DDC = "Desktop Deluvery Controller Hostname"
# Desktop Group Name
	$DGN = "Name of Desktop Delivery Group"

#-----------------------------------------------------------[Functions]------------------------------------------------------------



#-----------------------------------------------------------[Execution]------------------------------------------------------------

	$Servers = Get-BrokerMachine -AdminAddress $DDC | Where {($_.DesktopGroupname -eq $DGN)}
	$myArray = @()

	foreach($server in $servers)
		{
			$totLoadIndex = $server.LoadIndex
			$totSessions = $server.SessionCount
			$servername = ($server.DNSName.Split("."))[0]

			foreach($li in $server.LoadIndexes)
				{
					$tmp = $li.split(":")
					if($tmp[0] -eq "CPU")
						{
						   $LoadCPU = $tmp[1]
						}
					elseif($tmp[0] -eq "Memory")
						{
						   $LoadMem = $tmp[1]
						}
					elseif($tmp[0] -like "*SessionCount*")
						{
						   $LoadSession = $tmp[1]
						}
				}
			
			$myObject = New-Object System.Object
			$myObject | Add-Member -type NoteProperty -name Server -Value $servername
			$myObject | Add-Member -type NoteProperty -name Sessions -Value $totSessions
			$myObject | Add-Member -type NoteProperty -name LoadIndex -Value $totLoadIndex
			$myObject | Add-Member -type NoteProperty -name LoadCPU -Value $LoadCPU
			$myObject | Add-Member -type NoteProperty -name LoadMem -Value $LoadMem
			$myObject | Add-Member -type NoteProperty -name Loadsession -Value $Loadsession
			$myArray += $myObject
		}

	$myArray | Ft -AutoSize
