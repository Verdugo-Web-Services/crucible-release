$github_repo = "https://github.com/Verdugo-Web-Services/crucible-release"

# get latest release
$version = git ls-remote -t --refs $github_repo | Out-String -stream | Select-String -Pattern tags\/.* | % { $_.Matches } | % { $_.Value } 
$version = $version.Substring(5)
# TODO: check for install version

$app_directory = "$env:LocalAppData\Crucible"
$has_previous = $false

if( Test-Path $app_directory ) {
    Remove-Item -Path "$app_directory\bin\crucible.exe"
    $has_previous = $true;
} else {
   New-Item -Path "$app_directory\bin" -ItemType Directory -Force
}

echo "Downloading crucible $version..."
$ProgressPreference = 'SilentlyContinue'  
Invoke-WebRequest -uri "$github_repo/releases/download/$version/crucible-windows-x64.exe" -OutFile "$app_directory\bin\crucible.exe"

if(!$has_previous) {
setx path "%path%;$app_directory\bin"
echo "Successfully added crucible to PATH"
}