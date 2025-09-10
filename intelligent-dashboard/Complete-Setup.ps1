# Complete-Setup.ps1 - Fixed for Windows
# Set execution policy if needed
try {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
}
catch {
    Write-Host "Could not set execution policy. You may need to run as administrator." -ForegroundColor Yellow
}

Write-Host "Intelligent Azure Dashboard - Complete Setup" -ForegroundColor Blue
Write-Host "============================================================" -ForegroundColor Blue

try {
    # Step 1: Create Azure Resources
    Write-Host ""
    Write-Host "Step 1: Creating Azure Resources..." -ForegroundColor Cyan
    $resources = & ".\Create-AzureResources.ps1"
    if ($LASTEXITCODE -ne 0 -or !$resources) { 
        throw "Failed to create Azure resources"
    }

    # Step 2: Create Service Principal
    Write-Host ""
    Write-Host "Step 2: Creating Service Principal..." -ForegroundColor Cyan
    $credentials = & ".\Create-ServicePrincipal.ps1"
    if ($LASTEXITCODE -ne 0 -or !$credentials) { 
        throw "Failed to create service principal"
    }

    # Step 3: Get OpenAI credentials
    Write-Host ""
    Write-Host "Step 3: OpenAI Configuration..." -ForegroundColor Cyan
    $openaiKey = Read-Host "Enter your OpenAI API Key"
    if ([string]::IsNullOrEmpty($openaiKey)) {
        throw "OpenAI API Key is required"
    }
    
    $openaiEndpoint = Read-Host "Enter your OpenAI Endpoint (leave empty for standard OpenAI, not Azure OpenAI)"

    # Step 4: Configure Application Settings
    Write-Host ""
    Write-Host "Step 4: Configuring Application Settings..." -ForegroundColor Cyan
    $settingsParams = @{
        FunctionAppName = $resources.FunctionAppName
        ResourceGroupName = $resources.ResourceGroup
        AzureSubscriptionId = $credentials.subscriptionId
        AzureTenantId = $credentials.tenantId
        AzureClientId = $credentials.clientId
        AzureClientSecret = $credentials.clientSecret
        OpenAIApiKey = $openaiKey
    }
    
    if (![string]::IsNullOrEmpty($openaiEndpoint)) {
        $settingsParams.OpenAIEndpoint = $openaiEndpoint
    }
    
    & ".\Set-ApplicationSettings.ps1" @settingsParams
    if ($LASTEXITCODE -ne 0) { 
        throw "Failed to configure application settings"
    }

    Write-Host ""
    Write-Host "Setup completed successfully!" -ForegroundColor Green
    Write-Host "============================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next Steps:" -ForegroundColor Yellow
    Write-Host "  1. Deploy your function code using Deploy-Functions.ps1" -ForegroundColor White
    Write-Host "  2. Update your React app .env file with the function URL" -ForegroundColor White
    Write-Host "  3. Test your deployment" -ForegroundColor White
    Write-Host ""
    Write-Host "Function App URL: $($resources.FunctionUrl)" -ForegroundColor Cyan
}
catch {
    Write-Host ""
    Write-Host "Setup failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}