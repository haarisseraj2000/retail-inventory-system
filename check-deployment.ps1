# GitHub Pages Deployment Status Checker
# Run this script to check if your live demo is working

Write-Host "🚀 Checking GitHub Pages Deployment Status..." -ForegroundColor Green
Write-Host ""

$repoUrl = "https://github.com/haarisseraj2000/retail-inventory-system"
$liveUrl = "https://haarisseraj2000.github.io/retail-inventory-system/"

Write-Host "📍 Repository: $repoUrl" -ForegroundColor Blue
Write-Host "🌐 Live Demo: $liveUrl" -ForegroundColor Blue
Write-Host ""

# Check if the live URL is accessible
try {
    Write-Host "⏳ Checking if live demo is accessible..." -ForegroundColor Yellow
    $response = Invoke-WebRequest -Uri $liveUrl -Method Head -TimeoutSec 10 -ErrorAction Stop
    
    Write-Host "✅ SUCCESS! Live demo is accessible!" -ForegroundColor Green
    Write-Host "🎉 Your demo is live at: $liveUrl" -ForegroundColor Green
    Write-Host ""
    Write-Host "🔗 Opening live demo in browser..." -ForegroundColor Cyan
    Start-Process $liveUrl
}
catch {
    Write-Host "⏳ Demo is still deploying or not yet accessible" -ForegroundColor Yellow
    Write-Host "🕒 GitHub Pages deployment can take 5-10 minutes after first setup" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "📋 Next Steps:" -ForegroundColor White
    Write-Host "1. Go to: $repoUrl/settings/pages" -ForegroundColor Gray
    Write-Host "2. Set Source to 'GitHub Actions'" -ForegroundColor Gray
    Write-Host "3. Wait 5-10 minutes for deployment" -ForegroundColor Gray
    Write-Host "4. Visit: $liveUrl" -ForegroundColor Gray
}

Write-Host ""
Write-Host "📊 To check GitHub Actions deployment status:" -ForegroundColor White
Write-Host "   $repoUrl/actions" -ForegroundColor Gray

Read-Host "Press Enter to continue..."
