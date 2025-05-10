<#
.SYNOPSIS
	Fetches an article with the given title, "technology" by default.

.PARAMETER Topic
	The topic of the article.

.EXAMPLE
	.\laby2.ps1 -Topic nature

.NOTES
	Uses the articles from newsapi.org


#>

param (
	[string]$Topic = "technology"
)


#klucz api

$klucz = "a60024ad05354dd29cfab84fc682f5f2"

#link do strony z ktorej bierzemy artykul

$url = "https://newsapi.org/v2/everything?q=$Topic&apiKey=$klucz"



$response = Invoke-RestMethod -Uri $url


foreach ($article in $response.articles) {
	Write-Host "Tytuł: $($article.title)"
	Write-Host "Żródło: $($article.source.name)"
	Write-Host "URL: $($article.url)"
}
