function Generate-Changelog-Dawg {
	Param(
		[Parameter(Mandatory=$true)]
		[SecureString]$AccessToken,
	
		[Parameter(Mandatory=$true)]
		[String]$Repository,
		
		[Parameter(Mandatory=$true)]
		[String]$Template
	)
	
	$response = Invoke-RestMethod https://api.github.com/repos/$Repository/releases | Sort-Object published_at -Descending | ConvertTo-Json | ConvertFrom-Json -Authentication OAuth -Token $AccessToken
	ConvertTo-PoshstacheTemplate -InputString $Template -ParametersObject (@{ releases = $response.value } | ConvertTo-Json)
}

Install-Module Poshstache -Force

$repository = @{ $true = $env:INPUT_REPOSITORY; $false = $env:GITHUB_REPOSITORY; }[[bool]$env:INPUT_REPOSITORY]
$token = ConvertTo-SecureString $env:INPUT_ACCESS_TOKEN -AsPlainText -Force
Generate-Changelog-Dawg $token $env:GITHUB_REPOSITORY $INPUT_TEMPLATE