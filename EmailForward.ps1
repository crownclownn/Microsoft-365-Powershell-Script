# Import the Exchange Online module
Import-Module ExchangeOnlineManagement
# Connect to Exchange Online
Connect-ExchangeOnline -UserPrincipalName username@domain.com
# Path to the CSV file
$csvPath = "C:\\Path\\To\\forwarding_template.csv"
# Import the CSV and apply settings
Import-Csv -Path $csvPath | ForEach-Object {
    $user = $_.UserPrincipalName
    $forwardTo = $_.ForwardingSMTPAddress
    Set-Mailbox -Identity $user `
                -DeliverToMailboxAndForward $true `
                -ForwardingSsMTPAddress $forwardTo
    Write-Host "Forwarding set for $user to $forwardTo"
}
# Disconnect the session
Disconnect-ExchangeOnline