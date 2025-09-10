param(
    [Parameter(Mandatory=$true)]
    [string]$FunctionAppName,
    
    [Parameter(Mandatory=$false)]
    [string]$ProjectPath = ".\azure-functions"
)

try {
    Write-Host "Deploying Azure Functions..." -ForegroundColor Blue
    
    # Check if functions directory exists
    if (!(Test-Path $ProjectPath)) {
        throw "Functions directory not found: $ProjectPath"
    }
    
    # Navigate to functions directory
    $originalLocation = Get-Location
    Set-Location $ProjectPath
    
    try {
        # Check if package.json exists
        if (!(Test-Path "package.json")) {
            throw "package.json not found in functions directory"
        }
        
        # Install dependencies
        Write-Host "Installing dependencies..." -ForegroundColor Yellow
        npm install
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to install npm dependencies"
        }
        
        # Build the project if build script exists
        $packageJson = Get-Content "package.json" | ConvertFrom-Json
        if ($packageJson.scripts -and $packageJson.scripts.build) {
            Write-Host "Building project..." -ForegroundColor Yellow
            npm run build
            if ($LASTEXITCODE -ne 0) {
                throw "Failed to build project"
            }
        }
        
        # Deploy to Azure
        Write-Host "Deploying to Azure Function App: $FunctionAppName" -ForegroundColor Yellow
        func azure functionapp publish $FunctionAppName
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to deploy to Azure"
        }
        
        Write-Host ""
        Write-Host "Deployment completed successfully!" -ForegroundColor Green
        Write-Host "Function is available at: https://$FunctionAppName.azurewebsites.net" -ForegroundColor Cyan
    }
    finally {
        # Return to original location
        Set-Location $originalLocation
    }
}
catch {
    Write-Host "Deployment failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}