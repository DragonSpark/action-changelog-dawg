function Generate-Changelog-Dawg {
	Param(
		[Parameter(Mandatory=$true)]
		[SecureString]$AccessToken,
	
		[Parameter(Mandatory=$true)]
		[String]$Repository,
		
		[Parameter(Mandatory=$true)]
		[String]$Template
	)
	
	# $response = Invoke-RestMethod https://api.github.com/repos/$Repository/releases -Authentication OAuth -Token $AccessToken | Sort-Object published_at -Descending | ConvertTo-Json | ConvertFrom-Json
	$response = Invoke-RestMethod https://api.github.com/repos/$Repository/releases  | Sort-Object published_at -Descending | ConvertTo-Json | ConvertFrom-Json -Authentication OAuth -Token $AccessToken
	ConvertTo-PoshstacheTemplate -InputString $Template -ParametersObject (@{ releases = $response.value } | ConvertTo-Json)
}

Install-Module Poshstache -Force

$repository = @{ $true = $env:INPUT_REPOSITORY; $false = $env:GITHUB_REPOSITORY; }[[bool]$env:INPUT_REPOSITORY]
$token = ConvertTo-SecureString $env:INPUT_ACCESS_TOKEN -AsPlainText -Force
$result = Generate-Changelog-Dawg $token $env:GITHUB_REPOSITORY $env:INPUT_TEMPLATE

$error.Count

"ERROR: $error"

<#
if($lastexitcode -ne 0)
{
	echo "::error file=app.js,line=10,col=15::Something went wrong"

|
#>