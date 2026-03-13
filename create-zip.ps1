#!/usr/bin/env powershell
# Script: Create Portable ZIP Archive
# Purpose: Creates a transferable ZIP file excluding unnecessary files
# Usage: Run this script from the Desktop folder

# Colors for output
$Green = 'Green'
$Red = 'Red'
$Yellow = 'Yellow'
$Cyan = 'Cyan'

function Write-Color {
    param([string]$Text, [string]$Color = 'White')
    Write-Host $Text -ForegroundColor $Color
}

Write-Color "`n=== ZIP Archive Creator ===" $Cyan
Write-Color "Creates portable ZIP excluding venv, .env, media, etc.`n" $Cyan

# Check if we're in the right location
if (-not (Test-Path "web" -PathType Container)) {
    Write-Color "❌ ERROR: 'web' folder not found in current directory!" $Red
    Write-Color "   Run this script from: C:\Users\Delta-Game\OneDrive\Desktop\" $Yellow
    Write-Color "   Current location: $(Get-Location)" $Yellow
    exit 1
}

# Define exclusions
$Exclusions = @(
    'web/venv',
    'web/.venv',
    'web/env',
    'web/ENV',
    'web/__pycache__',
    'web/staticfiles',
    'web/.git',
    'web/.env',
    'web/media',
    'web/*.pyc',
    'web/.pytest_cache'
)

$ZipPath = "web-structures-course.zip"

Write-Color "`n📦 Creating ZIP archive..." $Cyan
Write-Color "   Source: web/" $Cyan
Write-Color "   Output: $ZipPath" $Cyan
Write-Color "`n   Excluding:` $Yellow
foreach ($excl in $Exclusions) {
    Write-Color "      - $excl" $Yellow
}

try {
    # Create ZIP with exclusions
    Compress-Archive -Path web -DestinationPath $ZipPath -Force -Exclude $Exclusions -ErrorAction Stop
    
    # Get file info
    $FileSize = (Get-Item $ZipPath).Length / 1MB
    $FileCount = (Get-Item $ZipPath).Length
    
    Write-Color "`n✅ SUCCESS!" $Green
    Write-Color "   Archive created: $ZipPath" $Green
    Write-Color "   Size: $([Math]::Round($FileSize, 2)) MB" $Green
    
    Write-Color "`n📋 Contents:" $Cyan
    Write-Color "   ✓ config/ (Django settings)" $Green
    Write-Color "   ✓ gallery/ (App code)" $Green
    Write-Color "   ✓ templates/ (HTML)" $Green
    Write-Color "   ✓ static/ (CSS, JS)" $Green
    Write-Color "   ✓ migrations/ (Database schema)" $Green
    Write-Color "   ✓ requirements.txt (Dependencies)" $Green
    Write-Color "   ✓ .env.example (Template)" $Green
    Write-Color "   ✓ README_TRANSFER.md (Setup guide)" $Green
    Write-Color "   ✗ .env (Excluded - secrets)" $Red
    Write-Color "   ✗ venv/ (Excluded - too large)" $Red
    Write-Color "   ✗ media/ (Excluded - user uploads)" $Red
    
    Write-Color "`n🚀 Next Steps:" $Cyan
    Write-Color "   1. Copy: $ZipPath" $Cyan
    Write-Color "   2. Share via email, USB, or cloud" $Cyan
    Write-Color "   3. Recipient extracts ZIP" $Cyan
    Write-Color "   4. Recipient follows README_TRANSFER.md" $Cyan
    
    Write-Color "`n💡 Pro Tips:" $Cyan
    Write-Color "   • Test transfer: Extract to another folder & run setup" $Cyan
    Write-Color "   • Prefer GitHub: Push to GitHub instead of ZIP" $Cyan
    Write-Color "   • Size too big? Delete media/ folder before zipping" $Cyan
    
    Write-Color "`n✅ Everything ready to transfer!" $Green
    
} catch {
    Write-Color "`n❌ ERROR creating ZIP: $($_.Exception.Message)" $Red
    exit 1
}

Write-Host ""
