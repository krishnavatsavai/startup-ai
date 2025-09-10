# Project Setup Script
# Save this as Setup-Project.ps1

param(
    [Parameter(Mandatory=$false)]
    [string]$ProjectPath = "C:\workspace\startup-ai\intelligent-dashboard"
)

try {
    Write-Host "📦 Setting up project structure..." -ForegroundColor Yellow
    
    # Navigate to project directory
    if (Test-Path $ProjectPath) {
        Set-Location $ProjectPath
        Write-Host "✅ Found project directory: $ProjectPath" -ForegroundColor Green
    } else {
        Write-Host "❌ Project directory not found: $ProjectPath" -ForegroundColor Red
        exit 1
    }
    
    # Setup Azure Functions
    Write-Host "⚡ Setting up Azure Functions..." -ForegroundColor Yellow
    
    if (!(Test-Path "azure-functions")) {
        New-Item -ItemType Directory -Name "azure-functions"
        Write-Host "✅ Created azure-functions directory" -ForegroundColor Green
    }
    
    Set-Location "azure-functions"
    
    # Initialize Functions project if not already done
    if (!(Test-Path "host.json")) {
        func init . --typescript --docker
        Write-Host "✅ Initialized Azure Functions project" -ForegroundColor Green
    }
    
    # Install dependencies
    if (Test-Path "package.json") {
        Write-Host "📦 Installing Azure Functions dependencies..." -ForegroundColor Yellow
        npm install
        Write-Host "✅ Dependencies installed" -ForegroundColor Green
    }
    
    # Create function if it doesn't exist
    if (!(Test-Path "ProcessIntelligentQuery")) {
        func new --name ProcessIntelligentQuery --template "HTTP trigger" --authlevel "function"
        Write-Host "✅ Created ProcessIntelligentQuery function" -ForegroundColor Green
    }
    
    # Setup React app
    Set-Location ".."
    if (Test-Path "package.json") {
        Write-Host "⚛️ Installing React app dependencies..." -ForegroundColor Yellow
        npm install
        Write-Host "✅ React dependencies installed" -ForegroundColor Green
    }
    
    Write-Host ""
    Write-Host "✅ Project setup completed!" -ForegroundColor Green
}
catch {
    Write-Host "❌ Project setup failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}