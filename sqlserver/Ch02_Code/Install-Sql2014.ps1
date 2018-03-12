Function Install-Sql2014
{
	param
	(
		[Parameter(Position=0,Mandatory=$false)][string] $Path,
		[Parameter(Position=1,Mandatory=$false)][string] $InstanceName = "MSSQLSERVER",
		[Parameter(Position=2,Mandatory=$false)][string] $ServiceAccount,
		[Parameter(Position=3,Mandatory=$false)][string] $ServicePassword,
		[Parameter(Position=4,Mandatory=$false)][string] $SaPassword,
		[Parameter(Position=5,Mandatory=$false)][string] $LicenseKey,
		[Parameter(Position=6,Mandatory=$false)][string] $SqlCollation = "SQL_Latin1_General_CP1_CI_AS",
		[Parameter(Position=7,Mandatory=$false)][switch] $NoTcp,
		[Parameter(Position=8,Mandatory=$false)][switch] $NoNamedPipes
	)
	
	#Build the setup command using the install mode
	if ($Path -eq $null -or $Path -eq "")
	{
		#No path means that the setup is in the same folder
		$command = 'setup.exe /Action="Install"'
	}
	else
	{
		#Ensure that the path ends with a backslash
		if(!$Path.EndsWith("\"))
		{
			$Path += "\"
		}
		
		$command = $path + 'setup.exe /Action="Install"'
	}
	
	#Accept the license agreement - required for command line installs
	$command += ' /IACCEPTSQLSERVERLICENSETERMS'
	
	#Use the QuietSimple mode (progress bar, but not interactive)
	$command += ' /QS'
	
	#Set the features to be installed
	$command += ' /FEATURES=SQLENGINE,CONN,BC,SSMS,ADV_SSMS'
	
	#Set the Instance Name
	$command += (' /INSTANCENAME="{0}"' -f $InstanceName)
	
	#Set the License Key only if a value was provided, otherwise install Evaluation edition
	if ($LicenseKey -ne $null -and $LicenseKey -ne "")
	{
		$command += (' /PID="{0}"' -f $LicenseKey)
	}
	
	#Check to see if a service account was specified
	if ($ServiceAccount -ne $null -and $ServiceAccount -ne "")
	{
		#Set the database engine service account
		$command += (' /SQLSVCACCOUNT="{0}" /SQLSVCPASSWORD="{1}" /SQLSVCSTARTUPTYPE="Automatic"' -f $ServiceAccount, $ServicePassword)
		#Set the SQL Agent service account
		$command += (' /AGTSVCACCOUNT="{0}" /AGTSVCPASSWORD="{1}" /AGTSVCSTARTUPTYPE="Automatic"' -f $ServiceAccount, $ServicePassword)
	}
	else
	{
		#Set the database engine service account to Local System
		$command += ' /SQLSVCACCOUNT="NT AUTHORITY\SYSTEM" /SQLSVCSTARTUPTYPE="Automatic"'
		#Set the SQL Agent service account to Local System
		$command += ' /AGTSVCACCOUNT="NT AUTHORITY\SYSTEM" /AGTSVCSTARTUPTYPE="Automatic"'
	}
	
	#Set the server in SQL authentication mode if an SA password was provided
	if ($SaPassword -ne $null -and $SaPassword -ne "")
	{
		$command += (' /SECURITYMODE="SQL" /SAPWD="{0}"' -f $SaPassword)
	}
	
	#Add current user as SysAdmin
	$command += (' /SQLSYSADMINACCOUNTS="{0}"' -f [Security.Principal.WindowsIdentity]::GetCurrent().Name)
	
	#Set the database collation
	$command += (' /SQLCOLLATION="{0}"' -f $SqlCollation)
	
	#Enable/Disable the TCP Protocol
	if ($NoTcp)
	{
		$command += ' /TCPENABLED="0"'
	}
	else
	{
		$command += ' /TCPENABLED="1"'
	}
	
	#Enable/Disable the Named Pipes Protocol
	if ($NoNamedPipes)
	{
		$command += ' /NPENABLED="0"'
	}
	else
	{
		$command += ' /NPENABLED="1"'
	}
	
	if ($PSBoundParameters['Debug']) 
	{
		Write-Output $command
	}
	else
	{
		Invoke-Expression $command
	}
}