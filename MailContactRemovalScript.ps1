$csvPath = "C:\Temp\Username\Script\contact.csv"
 
# Import the CSV and remove contacts
Import-Csv -Path $csvPath | ForEach-Object {
    $email = $_.Email
 
    try {
        $contact = Get-MailContact -Filter "ExternalEmailAddress -eq '$email'" -ErrorAction Stop
        Remove-MailContact -Identity $contact.Identity -Confirm:$false -ErrorAction Stop
        Write-Host "Deleted contact: $($contact.DisplayName) <$email>" -ForegroundColor Yellow
    }
    catch {
        Write-Host "Failed to delete or find contact for <$email> - $_" -ForegroundColor Red
    }
}