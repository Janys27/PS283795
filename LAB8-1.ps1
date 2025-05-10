<#
.SYNOPSIS
	Checks the exchange rate for a given currency (EUR by default) for the past 5 dates, calculates and displays the difference between each one.

.PARAMETER CurrencyCode
	Currency code for which the rates will be retrieved (USD, EUR, PLN etc)

.EXAMPLE
	pwsh laby1.ps1 -CurrencyCode "PLN"

.NOTES
	It uses an API key from Open Exchange Rates.

#>


param (
    [string]$CurrencyCode = "EUR"
)

$klucz = "8d548106e28e4392ad16f6ea1e7fde5f"
$strona = "https://openexchangerates.org/api"

#pusta tablica na daty
$daty = @()


#pętla dla ostatnich 5 dat
for ($i =0; $i -lt 5; $i++) {
    $data = (Get-Date).AddDays(-$i).ToString("yyyy-MM-dd")
    $daty += $data
}


$results= @{}

foreach ($data in $daty) {
    $url = "$strona/historical/$data.json?app_id=$klucz&symbols=$CurrencyCode"
    $response = Invoke-RestMethod -Uri $url
    $rate = $response.rates.$CurrencyCode
    $results[$data]= $rate
}

$previousRate = $null
foreach ($day in $results.GetEnumerator() | Sort-Object Name) {
    Write-Host "$($day.Name): $($day.Value)"
    if ($previousRate -ne $null) {
        $difference = $day.Value - $previousRate
        Write-Host "Różnica między ostatnim dniem: $difference"

    }
$previousRate = $day.Value

}
