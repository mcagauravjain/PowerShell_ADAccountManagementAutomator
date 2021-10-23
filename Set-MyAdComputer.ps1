param ([string]$ComputerName, [hashtable]$Attributes)

try
{
    $ComputerAccount = Get-ADComputer -Identity $ComputerName

    if (!$ComputerAccount)
    {
        Write-Error "The computer '$ComputerName' does not exist"
        return
    }

    $ComputerAccount | Set-ADComputer @Attributes
}

catch
{
}