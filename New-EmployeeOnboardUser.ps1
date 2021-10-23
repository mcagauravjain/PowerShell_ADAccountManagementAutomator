param($FirstName,$MiddleInitial,$LastName,$Location = 'OU=CorporateUsers,',$Title)

$DefaultPassword = 'p@$$w0rd12##'
$DomainDn = (Get-ADDomain).DistinguishedName
$DefaultGroup = 'Company-All'

### Figure out what the username should be

$Username = $FirstName.Substring(0,1) + $LastName

$ErrorActionPreferenceBefore = $ErrorActionPreference
$ErrorActionPreference = 'SilentlyContinue'


if (Get-ADUser $Username)
    {
        $Username = $FirstName.Substring(0,1) + $MiddleInitial + $LastName

        if (Get-ADUser $Username)
            {
                Write-Warning "No acceptable username schema could be created"
                return
            }
    }

### Create the user account

$ErrorActionPreference = $ErrorActionPreferenceBefore
$AccountPassword = ConvertTo-SecureString -AsPlainText -Force -String $DefaultPassword
$Path = $Location + $DomainDn

New-ADUser -UserPrincipalName $Username -Name $Username -GivenName $FirstName -Surname $LastName -Title $Title -SamAccountName $Username -AccountPassword $AccountPassword -Enabled $true -Initials $MiddleInitial -Path $Path -ChangePasswordAtLogon $true

### Add the user account to the company standard group

Add-ADGroupMember -Identity $DefaultGroup -Members $Username