$permissions = Import-Csv "C:\Temp\Username\SMPermission.csv"
$results = @()
 
foreach ($entry in $permissions) {
    $mailbox = $entry.Mailbox
    $user = $entry.User
    $accessType = $entry.AccessType
    $status = "Success"
    $message = ""
 
    switch ($accessType) {
        "FullAccess" {
            try {
                Add-MailboxPermission -Identity $mailbox -User $user -AccessRights FullAccess -AutoMapping:$true -ErrorAction Stop
            } catch {
                $status = "Failed"
                $message = $_.Exception.Message
            }
        }
        "SendAs" {
            try {
                Add-RecipientPermission -Identity $mailbox -Trustee $user -AccessRights SendAs -Confirm:$false -ErrorAction Stop
            } catch {
                $status = "Failed"
                $message = $_.Exception.Message
            }
        }
        "SendOnBehalf" {
            try {
                $existing = (Get-Mailbox -Identity $mailbox -ErrorAction Stop).GrantSendOnBehalfTo
                Set-Mailbox -Identity $mailbox -GrantSendOnBehalfTo ($existing + $user) -ErrorAction Stop
            } catch {
                $status = "Failed"
                $message = $_.Exception.Message
            }
        }
        default {
            $status = "Failed"
            $message = "Unknown access type: $accessType"
        }
    }
 
    $results += [PSCustomObject]@{
        Mailbox     = $mailbox
        User        = $user
        AccessType  = $accessType
        Status      = $status
        Message     = $message
    }
}
 
# Export the result log
$results | Export-Csv "C:\Temp\Username\SMPermission.csv"