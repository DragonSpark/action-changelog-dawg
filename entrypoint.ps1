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

	$response = Invoke-RestMethod $uri -Authentication Bearer -Token $AccessToken | Where-Object {!$_.draft} | Sort-Object published_at -Descending
	$response | ConvertTo-Json | Write-Host
	$parameters = @{ releases = $response } | ConvertTo-Json;
	$result = ConvertTo-PoshstacheTemplate -InputString $Template -ParametersObject $parameters;
	return $result
}

$Template | Write-Host

Install-Module Poshstache -Force

$repository = @{ $true = $env:INPUT_REPOSITORY; $false = $env:GITHUB_REPOSITORY; }[[bool]$env:INPUT_REPOSITORY]
$token = ConvertTo-SecureString $env:INPUT_ACCESS_TOKEN -AsPlainText -Force
$result = Generate-Changelog-Dawg $token $repository $env:INPUT_TEMPLATE

if ($Error.Count)
{
	foreach ($e in $Error)
	{
		echo "::error file=$($e.InvocationInfo.ScriptName),line=$($e.InvocationInfo.ScriptLineNumber),col=$($e.InvocationInfo.OffsetInLine)::$($e)"
	}
	exit 1
}
echo "::set-output name=result::$result"