# Create-ServicePrincipal.ps1 - Fixed for Windows
param(
    [Parameter(Mandatory=$false)]
    [string]$ServicePrincipalName = "intelligent-dashboard-sp",
    
    [Parameter(Mandatory=$false)]
    [string]$Role = "Contributor"
)

try {
    Write-Host "Creating Service Principal..." -ForegroundColor Yellow
    
    # Get current subscription ID
    $subscriptionId = az account show --query id -o tsv
    Write-Host "Current subscription: $subscriptionId" -ForegroundColor Cyan
    
    # Create service principal
    $spOutput = az ad sp create-for-rbac --name $ServicePrincipalName --role $Role --scopes "/subscriptions/$subscriptionId" --output json
    
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to create service principal"
    }
    
    $spInfo = $spOutput | ConvertFrom-Json
    
    Write-Host ""
    Write-Host "Service Principal Created Successfully!" -ForegroundColor Green
    Write-Host "============================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Service Principal Details:" -ForegroundColor Cyan
    Write-Host "  Name: $ServicePrincipalName" -ForegroundColor White
    Write-Host "  Application (Client) ID: $($spInfo.appId)" -ForegroundColor White
    Write-Host "  Client Secret: $($spInfo.password)" -ForegroundColor White
    Write-Host "  Tenant ID: $($spInfo.tenant)" -ForegroundColor White
    Write-Host "  Subscription ID: $subscriptionId" -ForegroundColor White
    Write-Host ""
    
    # Save to secure file
    $credentialsPath = "azure-credentials.json"
    $credentials = @{
        subscriptionId = $subscriptionId
        tenantId = $spInfo.tenant
        clientId = $spInfo.appId
        clientSecret = $spInfo.password
        servicePrincipalName = $ServicePrincipalName
        createdDate = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    }
    
    $credentials | ConvertTo-Json -Depth 3 | Out-File -FilePath $credentialsPath -Encoding UTF8
    Write-Host "Credentials saved to: $credentialsPath" -ForegroundColor Cyan
    Write-Host "WARNING: Keep this file secure and do not commit to version control!" -ForegroundColor Red
    
    return $credentials
}
catch {
    Write-Host "Failed to create service principal: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.InnerException) {
        Write-Host "Inner exception: $($_.Exception.InnerException.Message)" -ForegroundColor Red
    }
    exit 1
}