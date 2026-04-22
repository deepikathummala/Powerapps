param(
    [parameter(Mandatory=$true,Position=1)]
     [String]$SolutionName,
    [parameter(Mandatory=$true,Position=2)]
    [Alias("ConnString","CS")]
    [String]$ConnectionString,
    [Parameter(Mandatory)]
    [bool]$BuildVersionChange
)

# Load the necessary module if it's not already loaded
$Module = Get-InstalledModule -Name "Microsoft.Xrm.Data.Powershell" -ErrorAction SilentlyContinue
if ($Module -eq $null) {
    Write-Host "Module is not installed, installing 'Microsoft.Xrm.Data.Powershell'...";
    Install-Module -Name Microsoft.Xrm.Data.Powershell -Force -Scope CurrentUser -Verbose
}

# Create the service connection to Dynamics 365
$ServiceConn = Get-CrmConnection -ConnectionString $ConnectionString
if ($ServiceConn) {
    Write-Host "Connection established successfully: $($ServiceConn.ConnectedOrgFriendlyName)";

    # Create a query to retrieve the solution
    $SolutionQuery = New-Object Microsoft.Xrm.Sdk.Query.QueryExpression("solution")
    $SolutionQuery.ColumnSet = New-Object Microsoft.Xrm.Sdk.Query.ColumnSet($true)
    $SolutionQuery.Criteria.AddCondition("uniquename", [Microsoft.Xrm.Sdk.Query.ConditionOperator]::Equal, $SolutionName)
    
    $SolutionCollection = $ServiceConn.RetrieveMultiple($SolutionQuery)

    if ($SolutionCollection.Entities.Count -gt 0) {
        $CurrentVersion = $SolutionCollection.Entities[0].Attributes["version"]
        Write-Host "Current solution version is $CurrentVersion"
        $outputFilePath = "currentversion.txt"
        Write-Output $CurrentVersion | Out-File -FilePath $outputFilePath
        return $CurrentVersion;

    } else {
        Write-Warning "No solution found with the name '$SolutionName'."
    }
} else {
    Write-Error "Connection is not established."
}
