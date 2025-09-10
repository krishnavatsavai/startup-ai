# Create-AzureResources.ps1 - Fixed for Windows
param(
    [Parameter(Mandatory=$false)]
    [string]$ResourceGroupName = "rg-intelligent-dashboard",
    
    [Parameter(Mandatory=$false)]
    [string]$Location = "australiaeast",
    
    [Parameter(Mandatory=$false)]
    [string]$ProjectPrefix = "intelligent-dashboard"
)

# Function to generate unique names
function Get-UniqueResourceName {
    param([string]$prefix, [int]$maxLength = 24)
    $timestamp = (Get-Date).ToString("yyyyMMddHHmm")
    $uniqueName = "$prefix$timestamp"
    if ($uniqueName.Length -gt $maxLength) {
        $uniqueName = $uniqueName.Substring(0, $maxLength)
    }
    return $uniqueName.ToLower()
}

# Function to check if logged into Azure
function Test-AzureLogin {
    try {
        $null = az account show 2>$null
        $account = az account show | ConvertFrom-Json
        if ($account) {
            Write-Host "Azure login verified: $($account.user.name)" -ForegroundColor Green
            return $true
        }
    }
    catch {
        return $false
    }
    return $false
}

# Function to check prerequisites
function Test-Prerequisites {
    Write-Host "Checking prerequisites..." -ForegroundColor Yellow
    
    $errors = @()
    
    # Check Azure CLI
    try {
        $null = az --version 2>$null
        Write-Host "Azure CLI is installed" -ForegroundColor Green
    }
    catch {
        $errors += "Azure CLI not found. Install with: winget install Microsoft.AzureCLI"
    }
    
    # Check Azure Functions Core Tools
    try {
        $null = func --version 2>$null
        Write-Host "Azure Functions Core Tools is installed" -ForegroundColor Green
    }
    catch {
        $errors += "Azure Functions Core Tools not found. Install with: npm install -g azure-functions-core-tools@4"
    }
    
    # Check Node.js
    try {
        $nodeVersion = node --version 2>$null
        Write-Host "Node.js is installed: $nodeVersion" -ForegroundColor Green
    }
    catch {
        $errors += "Node.js not found. Install with: winget install OpenJS.NodeJS.LTS"
    }
    
    if ($errors.Count -gt 0) {
        Write-Host "Prerequisites missing:" -ForegroundColor Red
        foreach ($error in $errors) {
            Write-Host "  - $error" -ForegroundColor Red
        }
        return $false
    }
    
    return $true
}

# Main script execution
try {
    Write-Host "Starting Azure Intelligent Dashboard Deployment" -ForegroundColor Blue
    Write-Host "============================================================" -ForegroundColor Blue
    
    # Check prerequisites
    if (-not (Test-Prerequisites)) {
        Write-Host "Please install missing prerequisites and run the script again." -ForegroundColor Red
        exit 1
    }
    
    # Check Azure login
    if (-not (Test-AzureLogin)) {
        Write-Host "Please login to Azure..." -ForegroundColor Yellow
        az login
        
        if (-not (Test-AzureLogin)) {
            Write-Host "Failed to login to Azure" -ForegroundColor Red
            exit 1
        }
    }
    
    # Generate unique resource names
    $functionAppName = Get-UniqueResourceName -prefix "func-$ProjectPrefix-" -maxLength 60
    $storageAccountName = Get-UniqueResourceName -prefix "st$($ProjectPrefix.Replace('-',''))" -maxLength 24
    $appInsightsName = Get-UniqueResourceName -prefix "ai-$ProjectPrefix-" -maxLength 60
    
    Write-Host ""
    Write-Host "Resource Configuration:" -ForegroundColor Cyan
    Write-Host "  Resource Group: $ResourceGroupName" -ForegroundColor White
    Write-Host "  Location: $Location" -ForegroundColor White
    Write-Host "  Function App: $functionAppName" -ForegroundColor White
    Write-Host "  Storage Account: $storageAccountName" -ForegroundColor White
    Write-Host "  Application Insights: $appInsightsName" -ForegroundColor White
    Write-Host ""
    
    # Create resource group
    Write-Host "Creating resource group: $ResourceGroupName" -ForegroundColor Yellow
    az group create --name $ResourceGroupName --location $Location --output none
    Write-Host "Resource group created successfully" -ForegroundColor Green
    
    # Create Application Insights
    Write-Host "Creating Application Insights: $appInsightsName" -ForegroundColor Yellow
    az monitor app-insights component create --app $appInsightsName --location $Location --resource-group $ResourceGroupName --output none
    Write-Host "Application Insights created successfully" -ForegroundColor Green
    
    # Create storage account
    Write-Host "Creating storage account: $storageAccountName" -ForegroundColor Yellow
    az storage account create --name $storageAccountName --resource-group $ResourceGroupName --location $Location --sku Standard_LRS --kind StorageV2 --output none
    Write-Host "Storage account created successfully" -ForegroundColor Green
    
    # Create Function App
    Write-Host "Creating Function App: $functionAppName" -ForegroundColor Yellow
    az functionapp create --resource-group $ResourceGroupName --consumption-plan-location $Location --runtime node --runtime-version 18 --functions-version 4 --name $functionAppName --storage-account $storageAccountName --app-insights $appInsightsName --os-type Windows --output none
    Write-Host "Function App created successfully" -ForegroundColor Green
    
    # Get Function App URL and keys
    Write-Host "Retrieving Function App details..." -ForegroundColor Yellow
    $functionUrl = az functionapp show --name $functionAppName --resource-group $ResourceGroupName --query defaultHostName -o tsv
    $instrumentationKey = az monitor app-insights component show --app $appInsightsName --resource-group $ResourceGroupName --query instrumentationKey -o tsv
    
    Write-Host ""
    Write-Host "Deployment Completed Successfully!" -ForegroundColor Green
    Write-Host "============================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Resource Details:" -ForegroundColor Cyan
    Write-Host "  Resource Group: $ResourceGroupName" -ForegroundColor White
    Write-Host "  Function App Name: $functionAppName" -ForegroundColor White
    Write-Host "  Function URL: https://$functionUrl" -ForegroundColor White
    Write-Host "  Storage Account: $storageAccountName" -ForegroundColor White
    Write-Host "  Application Insights: $appInsightsName" -ForegroundColor White
    Write-Host ""
    
    # Save configuration to file
    $configPath = "azure-config.json"
    $config = @{
        resourceGroup = $ResourceGroupName
        functionAppName = $functionAppName
        functionUrl = "https://$functionUrl"
        storageAccount = $storageAccountName
        appInsights = $appInsightsName
        location = $Location
        instrumentationKey = $instrumentationKey
        createdDate = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    }
    
    $config | ConvertTo-Json -Depth 3 | Out-File -FilePath $configPath -Encoding UTF8
    Write-Host "Configuration saved to: $configPath" -ForegroundColor Cyan
    
    Write-Host ""
    Write-Host "Next Steps:" -ForegroundColor Yellow
    Write-Host "  1. Configure application settings (see Set-ApplicationSettings.ps1)" -ForegroundColor White
    Write-Host "  2. Deploy your function code" -ForegroundColor White
    Write-Host "  3. Update your React app configuration" -ForegroundColor White
    
    # Return resource information
    return @{
        ResourceGroup = $ResourceGroupName
        FunctionAppName = $functionAppName
        FunctionUrl = "https://$functionUrl"
        StorageAccount = $storageAccountName
        AppInsights = $appInsightsName
    }
}
catch {
    Write-Host "Deployment failed with error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Error details: $($_.Exception.ToString())" -ForegroundColor Red
    exit 1
}