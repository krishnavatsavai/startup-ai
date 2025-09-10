# Set-ApplicationSettings.ps1 - Fixed for Windows
param(
    [Parameter(Mandatory=$true)]
    [string]$FunctionAppName,
    
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,
    
    [Parameter(Mandatory=$true)]
    [string]$AzureSubscriptionId,
    
    [Parameter(Mandatory=$true)]
    [string]$AzureTenantId,
    
    [Parameter(Mandatory=$true)]
    [string]$AzureClientId,
    
    [Parameter(Mandatory=$true)]
    [string]$AzureClientSecret,
    
    [Parameter(Mandatory=$true)]
    [string]$OpenAIApiKey,
    
    [Parameter(Mandatory=$false)]
    [string]$OpenAIEndpoint = "",
    
    [Parameter(Mandatory=$false)]
    [string]$OpenAIDeploymentName = "gpt-4"
)

try {
    Write-Host "Configuring Function App Settings..." -ForegroundColor Yellow
    
    # Prepare settings array - each setting on its own line for clarity
    $settingsArray = @()
    $settingsArray += "AZURE_SUBSCRIPTION_ID=$AzureSubscriptionId"
    $settingsArray += "AZURE_TENANT_ID=$AzureTenantId"
    $settingsArray += "AZURE_CLIENT_ID=$AzureClientId"
    $settingsArray += "AZURE_CLIENT_SECRET=$AzureClientSecret"
    $settingsArray += "OPENAI_API_KEY=$OpenAIApiKey"
    $settingsArray += "OPENAI_DEPLOYMENT_NAME=$OpenAIDeploymentName"
    $settingsArray += "OPENAI_API_VERSION=2024-02-01"
    
    # Add OpenAI endpoint if provided (for Azure OpenAI)
    if ($OpenAIEndpoint -ne "") {
        $settingsArray += "OPENAI_ENDPOINT=$OpenAIEndpoint"
    }
    
    # Apply settings using splatting
    $params = @{
        name = $FunctionAppName
        'resource-group' = $ResourceGroupName
        settings = $settingsArray
        output = 'none'
    }
    
    az functionapp config appsettings set @params
    
    Write-Host "Application settings configured successfully!" -ForegroundColor Green
    
    # Enable CORS for local development
    Write-Host "Enabling CORS for local development..." -ForegroundColor Yellow
    
    $corsParams = @{
        name = $FunctionAppName
        'resource-group' = $ResourceGroupName
        'allowed-origins' = @("http://localhost:3000", "https://localhost:3000")
        output = 'none'
    }
    
    az functionapp cors add @corsParams
    
    Write-Host "CORS configured for local development" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "Configuration completed successfully!" -ForegroundColor Green
}
catch {
    Write-Host "Failed to configure application settings: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}