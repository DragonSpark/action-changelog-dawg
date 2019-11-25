function Generate-Changelog-Dawg {
	Param(
		[Parameter(Mandatory=$true)]
		[SecureString]$AccessToken,
	
		[Parameter(Mandatory=$true)]
		[String]$Repository,
		
		[Parameter(Mandatory=$true)]
		[String]$Template
	)
	
	$uri = "https://api.github.com/repos/$Repository/releases"

	$response = Invoke-RestMethod $uri -Authentication Bearer -Token $AccessToken
	$query = $response | Where-Object draft -Not | Sort-Object published_at -Descending
	$query | ConvertTo-Json | Write-Host
	$parameters = @{ releases = $query } | ConvertTo-Json;
	$result = ConvertTo-PoshstacheTemplate -InputString $Template -ParametersObject $parameters;
	return $result
}

Install-Module Poshstache -Force

$repository = @{ $true = $env:INPUT_REPOSITORY; $false = $env:GITHUB_REPOSITORY; }[[bool]$env:INPUT_REPOSITORY]
$token = ConvertTo-SecureString $env:INPUT_ACCESS_TOKEN -AsPlainText -Force
$result = Generate-Changelog-Dawg $token $repository $env:INPUT_TEMPLATE

"Using Template:" | Write-Host
$env:INPUT_TEMPLATE | Write-Host

"Result:" | Write-Host
$result | Write-Host

"====================================" | Write-Host

if ($Error.Count)
{
	foreach ($e in $Error)
	{
		echo "::error file=$($e.InvocationInfo.ScriptName),line=$($e.InvocationInfo.ScriptLineNumber),col=$($e.InvocationInfo.OffsetInLine)::$($e)"
	}
	exit 1
}
"Before==" | Write-Host
echo "::set-output name=result::$result"
"After==" | Write-Host