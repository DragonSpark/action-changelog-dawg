function Generate-Changelog-Dawg {
	Param(
		[Parameter(Mandatory=$true)]
		[String]$AccessToken,
	
		[Parameter(Mandatory=$true)]
		[String]$Repository,
		
		[Parameter(Mandatory=$true)]
		[String]$Template
	)
	$headers = @{ 
		"authorization" = "Bearer $AccessToken"	
		"content-type" = "application/json"
	};
	
	$uri = "https://api.github.com/repos/$Repository/releases"
	Write-Host $uri
	$response = Invoke-RestMethod $uri -Headers $headers | Sort-Object published_at -Descending | ConvertTo-Json | ConvertFrom-Json
	
	Write-Host "HELLO??? $($response.value)"
	
	return ConvertTo-PoshstacheTemplate -InputString $Template -ParametersObject (@{ releases = $response.value } | ConvertTo-Json)
}

<#
Install-Module Poshstache -Force

$repository = @{ $true = $env:INPUT_REPOSITORY; $false = $env:GITHUB_REPOSITORY; }[[bool]$env:INPUT_REPOSITORY]
$token = ConvertTo-SecureString $env:INPUT_ACCESS_TOKEN -AsPlainText -Force
$result = Generate-Changelog-Dawg $env:INPUT_ACCESS_TOKEN $repository $env:INPUT_TEMPLATE
Write-Host "WHATTAP: $($result.Length)"
if ($Error.Count)
{
	foreach ($e in $Error)
	{
		echo "::error file=$($e.InvocationInfo.ScriptName),line=$($e.InvocationInfo.ScriptLineNumber),col=$($e.InvocationInfo.OffsetInLine)::$($e)"
	}
	exit 1
}

echo "::set-output name=result::$result"
#>

$repository = @{ $true = $env:INPUT_REPOSITORY; $false = $env:GITHUB_REPOSITORY; }[[bool]$env:INPUT_REPOSITORY]
$headers = @{ 
		"authorization" = "Bearer $($env:INPUT_ACCESS_TOKEN)"	
		# "content-type" = "application/json"
	};
	
$uri = "https://api.github.com/repos/$repository/releases"
Write-Host $uri
$token = ConvertTo-SecureString $env:INPUT_ACCESS_TOKEN -AsPlainText -Force
$response = Invoke-RestMethod $uri -Authentication Bearer -Token $token
$response