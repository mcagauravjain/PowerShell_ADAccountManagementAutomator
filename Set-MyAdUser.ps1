param ([string]$Username, [hashtable]$Attributes)

try
{
    $Useraccount = Get-ADUser -Identity $Username

    if (!$Useraccount)
    {
        Write-Error "The username '$Username' does not exist"
        return
    }
}

catch
{
    
}

if($Attributes.ContainsKey('Password'))
{
    $Useraccount | Set-ADAccountPassword -Reset -NewPassword (ConvertTo-SecureString -AsPlainText -String $Attributes.Password -Force)
    $Attributes
}

$Useraccount | Set-ADUser @Attributes