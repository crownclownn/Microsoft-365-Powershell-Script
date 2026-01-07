# Load mailbox and delegate lists
$mailboxes = Get-Content "C:\Temp\Username\Script\Shared mailbox permission\Sharemailbox.txt"
$delegates = Get-Content "C:\Temp\Username\Script\Shared mailbox permission\delegate list.txt"
 
foreach ($mailbox in $mailboxes) {
    foreach ($delegate in $delegates) {
        try {
            Write-Host "Assigning Full Access from $mailbox to $delegate..."
            Add-MailboxPermission -Identity $mailbox -User $delegate -AccessRights FullAccess -InheritanceType All -AutoMapping:$false -ErrorAction Stop
 
            Write-Host "Assigning Send As from $mailbox to $delegate..."
            Add-RecipientPermission -Identity $mailbox -Trustee $delegate -AccessRights SendAs -Confirm:$false -ErrorAction Stop
 
        } catch {
            Write-Warning "Failed to assign permissions for $delegate on $mailbox"
        }
    }
}