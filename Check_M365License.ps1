# Import Microsoft Graph module
Import-Module Microsoft.Graph.Users

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "User.Read.All"

# Load user list from CSV
$users = Import-Csv -Path "C:\Username\Wave1.csv"

# Output file
$output = @()

foreach ($user in $users) {
    $upn = $user.UserPrincipalName
    try {
        $userDetails = Get-MgUser -UserId $upn
        $licenseDetails = Get-MgUserLicenseDetail -UserId $upn

        if ($licenseDetails) {
            $licenseAssigned = $true
            $licenseNames = $licenseDetails.SkuPartNumber -join ", "
        } else {
            $licenseAssigned = $false
            $licenseNames = "None"
        }

        $output += [PSCustomObject]@{
            UserPrincipalName = $upn
            LicenseAssigned   = $licenseAssigned
            Licenses          = $licenseNames
        }
    } catch {
        $output += [PSCustomObject]@{
            UserPrincipalName = $upn
            LicenseAssigned   = "Error"
            Licenses          = $_.Exception.Message
        }
    }
}

# Generate timestamp
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$outputPath = "C:\Username\LicenseReportWave1.csv"

# Export results to CSV
$output | Export-Csv -Path $outputPath -NoTypeInformation

Write-Host "License check completed. Report saved to $outputPath"
