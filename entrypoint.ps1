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
	$query = $response | Where-Object draft -Not # | Sort-Object published_at -Descending
	$parameters = @{ releases = $query } | ConvertTo-Json;
	return ConvertTo-PoshstacheTemplate -InputString $Template -ParametersObject $parameters
}

Install-Module Poshstache -Force

$repository = @{ $true = $env:INPUT_REPOSITORY; $false = $env:GITHUB_REPOSITORY; }[[bool]$env:INPUT_REPOSITORY]
$token = ConvertTo-SecureString $env:INPUT_ACCESS_TOKEN -AsPlainText -Force
$content = Generate-Changelog-Dawg $token $repository $env:INPUT_TEMPLATE

Set-Content $env:INPUT_FILEPATH $content

if ($Error.Count)
{
	foreach ($e in $Error)
	{
		echo "::error file=$($e.InvocationInfo.ScriptName),line=$($e.InvocationInfo.ScriptLineNumber),col=$($e.InvocationInfo.OffsetInLine)::$($e)"
	}
	exit 1
}

$filename = Split-Path $env:INPUT_FILEPATH -Leaf
echo "::set-output name=filename::$filename"