<#
.SYNOPSIS
	Fetches basic information and open ports of a given ip (default 8.8.8.8) and displays them.

.PARAMETERS IP
	Ip address about which the information is fetched.

.EXAMPLE
	pwsh laby2.ps1 -IP "127.0.0.1"

.NOTES
	The script uses Shodan
#>


param() {
	[string]$IP =  "8.8.8.8"
}

$klucz = "HonMUvojwkmUNJ101etHqjtXlXv3CR27"

$url = "https://api.shodan.io/shodan/host/${IP}?key=$klucz"

$response = Invoke-RestMethod -Uri $url

Write-Host "IP: $($response.ip_str)"
Write-Host "Kraj: $($response.country_name)"
Write-Host "Miasto: $($response.city)"
Write-Host "Otwarte porty:  $($response.ports -join ', ')"
