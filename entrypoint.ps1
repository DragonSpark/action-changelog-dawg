function Generate-Changelog-Dawg {
	Param(
		[Parameter(Mandatory=$true)]
		[SecureString]$AccessToken,
	
		[Parameter(Mandatory=$true)]
		[String]$Repository,
		
		[Parameter(Mandatory=$true)]
		[String]$Template
	)
	
	$response = Invoke-RestMethod https://api.github.com/repos/$Repository/releases -Authentication OAuth -Token $AccessToken | Sort-Object published_at -Descending | ConvertTo-Json | ConvertFrom-Json
	ConvertTo-PoshstacheTemplate -InputString $Template -ParametersObject (@{ releases = $response.value } | ConvertTo-Json)
}

Install-Module Poshstache -Force

$repository = @{ $true = $env:INPUT_REPOSITORY; $false = $env:GITHUB_REPOSITORY; }[[bool]$env:INPUT_REPOSITORY]
$token = ConvertTo-SecureString $env:INPUT_ACCESS_TOKEN -AsPlainText -Force
$result = Generate-Changelog-Dawg $token $env:GITHUB_REPOSITORY $env:INPUT_TEMPLATE

if($lastexitcode -ne 0)
{
	$details = $error[0].InvocationInfo
	echo "::error file=$($details.ScriptName),line=$($details.ScriptLineNumber),col=$($details.OffsetInLine)::$($error[0])"
}
else
{
	echo "::set-output name=result::$result"
}