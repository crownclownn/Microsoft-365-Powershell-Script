#Disable AutoReply
# Path to your CSV file
$csvPath = "C:\Temp\Username\AutoReply Stamp\AutoReplyStamp.csv"

# Read the CSV and apply auto-reply settings
Import-Csv -Path $csvPath | ForEach-Object {
    $user = $_.UserPrincipalName
    $internalMsg = $_.InternalMessage
    $externalMsg = $_.ExternalMessage

    Set-MailboxAutoReplyConfiguration -Identity $user `
        -AutoReplyState Disabled `
        -InternalMessage $internalMsg `
        -ExternalMessage $externalMsg `
        -ExternalAudience All

    Write-Host "Auto-reply configured for $user"
}
