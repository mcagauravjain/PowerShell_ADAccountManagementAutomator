param ($ComputerName, $ComputerLocation = 'OU=CorporateComputers')

try
{

    if (Get-ADComputer $ComputerName)
    {
        Write-Error "The computer name '$ComputerName' already exists in AD"
        return
    }
}

catch
{
}

$DomainDn = (Get-ADDomain).DistinguishedName
$ComputerDefaultOuPath = "$ComputerLocation,$DomainDn"

New-ADComputer -Location $ComputerDefaultOuPath -Name $ComputerName