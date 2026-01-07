# PowerShell Script to add Users as member to Mail-Enabled Security Group
# Define the security group identity (name or email)
$groupIdentity = "ProjectMigration@domain.com"

# Path to your CSV file
$csvPath = "C:\Temp\Username\FolderName\UsersAddition.csv"

# Read users and add them to the group
Import-Csv -Path $csvPath | ForEach-Object {
    $user = $_.UserPrincipalName

    Add-DistributionGroupMember -Identity $groupIdentity -Member $user -BypassSecurityGroupManagerCheck
    Write-Host "Added $user to $groupIdentity"
}