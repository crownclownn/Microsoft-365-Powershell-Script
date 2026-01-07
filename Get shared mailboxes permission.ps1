# Connect to Exchange Online if not already connected
#Connect-ExchangeOnline
 
$sharedMailboxes = Get-Content "C:\Temp\Username\TestSM.txt"
$report = @()
 
foreach ($mbx in $sharedMailboxes) {
    try {
        # Full Access Permissions
        $fullAccess = Get-MailboxPermission -Identity $mbx -ErrorAction Stop | Where-Object {
            $_.User.ToString() -ne "NT AUTHORITY\SELF" -and $_.AccessRights -contains "FullAccess"
        }
 
        foreach ($perm in $fullAccess) {
            $report += [PSCustomObject]@{
                Mailbox        = $mbx
                AccessType     = "FullAccess"
                User           = $perm.User
                IsInherited    = $perm.IsInherited
            }
        }
 
        # Send As Permissions
        $sendAs = Get-RecipientPermission -Identity $mbx -ErrorAction SilentlyContinue | Where-Object {
            $_.Trustee -ne "NT AUTHORITY\SELF" -and $_.AccessRights -contains "SendAs"
        }
 
        foreach ($perm in $sendAs) {
            $report += [PSCustomObject]@{
                Mailbox        = $mbx
                AccessType     = "SendAs"
                User           = $perm.Trustee
                IsInherited    = $null
            }
        }
 
        # Send on Behalf Permissions
        $mbxObj = Get-Mailbox -Identity $mbx -ErrorAction Stop
        if ($mbxObj.GrantSendOnBehalfTo.Count -gt 0) {
            foreach ($user in $mbxObj.GrantSendOnBehalfTo) {
                $report += [PSCustomObject]@{
                    Mailbox        = $mbx
                    AccessType     = "SendOnBehalf"
                    User           = $user.Name
                    IsInherited    = $null
                }
            }
        }
 
    } catch {
        Write-Warning "Failed to process mailbox: $mbx - $_"
    }
}
 
# Export the final report
$report | Export-Csv "C:\Temp\Username\TestSMaccessresult.csv"