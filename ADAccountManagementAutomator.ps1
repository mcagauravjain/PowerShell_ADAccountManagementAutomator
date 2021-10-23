function New-EmployeeOnboardUser
{
	<#
	.SYNOPSIS
		
	.EXAMPLE
		PS> New-AdvancedFunction -Param1 MYPARAM

        This example does something to this and that.
	.PARAMETER Param1
        This param does this thing.
	.PARAMETER 
	.PARAMETER 
	.PARAMETER 
	#>

	[CmdletBinding()]
	
    param($FirstName,$MiddleInitial,$LastName,$Location = 'OU=CorporateUsers,',$Title)

	process
    {
	    try
        {
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
		    } 
        
        catch
        {
			Write-Error "$($_.Exception.Message) - Line Number: $($_.InvocationInfo.ScriptLineNumber)"
		}
	}
}

function New-EmployeeOnboardComputer
{
	<#
	.SYNOPSIS
		
	.EXAMPLE
		PS> New-AdvancedFunction -Param1 MYPARAM

        This example does something to this and that.
	.PARAMETER Param1
        This param does this thing.
	.PARAMETER 
	.PARAMETER 
	.PARAMETER 
	#>

	[CmdletBinding()]
	
    param ($ComputerName, $ComputerLocation = 'OU=CorporateComputers')

	process
    {
	    try
        {
	        if (Get-ADComputer $ComputerName)
            {
                Write-Error "The computer name '$ComputerName' already exists in AD"
                return
            }

            $DomainDn = (Get-ADDomain).DistinguishedName
            $ComputerDefaultOuPath = "$ComputerLocation,$DomainDn"

            New-ADComputer -Location $ComputerDefaultOuPath -Name $ComputerName
		} 
        
        catch
        {
			Write-Error "$($_.Exception.Message) - Line Number: $($_.InvocationInfo.ScriptLineNumber)"
		}
	}
}

function Set-MyAdComputer 
{
	<#
	.SYNOPSIS
		
	.EXAMPLE
		PS> New-AdvancedFunction -Param1 MYPARAM

        This example does something to this and that.
	.PARAMETER Param1
        This param does this thing.
	.PARAMETER 
	.PARAMETER 
	.PARAMETER 
	#>

	[CmdletBinding()]
	
    param ([string]$ComputerName, [hashtable]$Attributes)

	process
    {
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
			Write-Error "$($_.Exception.Message) - Line Number: $($_.InvocationInfo.ScriptLineNumber)"
		}
	}
}

function Set-MyAdUser 
{
	<#
	.SYNOPSIS
		
	.EXAMPLE
		PS> New-AdvancedFunction -Param1 MYPARAM

        This example does something to this and that.
	.PARAMETER Param1
        This param does this thing.
	.PARAMETER 
	.PARAMETER 
	.PARAMETER 
	#>

	[CmdletBinding()]
	
    param ([string]$Username, [hashtable]$Attributes)

	process
    {
	    try
        {
	        $Useraccount = Get-ADUser -Identity $Username

            if (!$Useraccount)
            {
                Write-Error "The username '$Username' does not exist"
                return
            }

            if($Attributes.ContainsKey('Password'))
            {
                $Useraccount | Set-ADAccountPassword -Reset -NewPassword (ConvertTo-SecureString -AsPlainText -String $Attributes.Password -Force)
                $Attributes
            }

            $Useraccount | Set-ADUser @Attributes
		} 
        
        catch
        {
			Write-Error "$($_.Exception.Message) - Line Number: $($_.InvocationInfo.ScriptLineNumber)"
		}
	}
}

