$csvPath = "C:\Temp\Username\Script\contact.csv"
 
# Import the CSV and create contacts
Import-Csv -Path $csvPath | ForEach-Object {
    $name = $_.Name
    $email = $_.Email
 
    # Split name into first and last if possible
    $firstName = $name.Split(' ')[0]
    $lastName = ($name.Split(' ').Count -gt 1) ? $name.Split(' ')[1] : ''
 
    try {
        New-MailContact -Name $name `
                        -DisplayName $name `
                        -ExternalEmailAddress $email `
                        -FirstName $firstName `
                        -LastName $lastName `
                        -Alias ($name -replace '\s','.' -replace '[^a-zA-Z0-9\.]', '') `
                        -ErrorAction Stop
 
        Write-Host "Created contact: $name <$email>" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to create contact: $name <$email> - $_" -ForegroundColor Red
    }
}