# pack_project.ps1
# Usage: run from project root (or double-click). Creates web_project.zip next to project folder.
# It excludes common developer dirs like .venv, .git, .vscode and node_modules.

$project = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$project = Resolve-Path $project
$project = $project.Path
$temp = Join-Path $env:TEMP "web_transfer_temp"

if (Test-Path $temp) { Remove-Item $temp -Recurse -Force }
New-Item -ItemType Directory -Path $temp | Out-Null

# Use robocopy to mirror project to temp excluding developer cruft
# /MIR mirrors directory, /XD excludes directories, /XF excludes files by pattern
$excludeDirs = @('.venv', 'venv', '.git', '.vscode', 'node_modules')
$excludeFiles = @('*.pyc', '*.pyo', '*.log')

$xdArgs = $excludeDirs -join ' '
$xfArgs = $excludeFiles -join ' '

# robocopy requires trailing backslash on destination for proper behavior
$robocopyCmd = "robocopy `"$project`" `"$temp`" /MIR /NDL /NJH /NJS /COPY:DAT /R:1 /W:1 /XD $xdArgs /XF $xfArgs"
Write-Host "Running: $robocopyCmd"
Invoke-Expression $robocopyCmd

# Create ZIP in project parent folder
$zipPath = Join-Path (Split-Path $project -Parent) "web_project.zip"
if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
Compress-Archive -Path (Join-Path $temp '*') -DestinationPath $zipPath -Force

# Cleanup
Remove-Item $temp -Recurse -Force

Write-Host "Created archive: $zipPath"
