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
Write-Host "Hello World! $PWD"

echo "Testing: $env:ACTIONS_RUNTIME_URL - $env:RUNNER_WORKSPACE - $env:RUNNER_TEMP "

Start-Process /usr/bin/whereis -ArgumentList "whereis"
Start-Process /usr/bin/whereis -ArgumentList "set-output"

# Get-ChildItem ../../usr/bin/
# Get-ChildItem ../../usr/sbin/
# Get-ChildItem /home/runner/work/action-jackson/
# Get-ChildItem /home/runner/work/_temp/
# Get-ChildItem /github/home/
# Get-ChildItem /var/run/docker.sock/
# 
# Get-ChildItem /github/workflow



#& warning file=app.js,line=1,col=5::Missing semicolon

Write-Host "===============+++"
# Get-Help