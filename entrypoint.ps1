function Generate-Changelog-Dawg {
	Param([Parameter(Mandatory=$true)]
		  [String]$Owner, 
		  [Parameter(Mandatory=$true)]
		  [String]$Repository,
		  [String]$Template = @"
{{#releases}}
# [{{ name }}]({{ html_url }})
> {{ published_at }} UTC
##### ``{{ tag_name }}``

{{ body }}
{{/releases}}
"@)
	$response = Invoke-RestMethod https://api.github.com/repos/$Owner/$Repository/releases | Sort-Object published_at -Descending | ConvertTo-Json | ConvertFrom-Json
	ConvertTo-PoshstacheTemplate -InputString $Template -ParametersObject (@{ releases = $response.value } | ConvertTo-Json)
}

# Install-Module Poshstache -Force

$repository = @{ $true = $env:INPUT_REPOSITORY; $false = $env:GITHUB_REPOSITORY; }[[bool]$env:INPUT_REPOSITORY]
$temp = [bool]$env:INPUT_SECURITY_TOKEN 
"Repository: $repository - $temp"
# Generate-Changelog-Dawg $env:GITHUB_REPOSITORY