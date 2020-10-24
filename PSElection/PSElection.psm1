<#	
	===========================================================================
	 Created on:   	10/23/2020 7:27 PM
	 Created by:   	Bradley Wyatt
	 Filename:     	PSElection.psm1
	-------------------------------------------------------------------------
	 Module Name: PSElection
	===========================================================================
#>



Function Get-PollingPlaces
{
	 <#
	.SYNOPSIS
      Gets your registered polling place based on address
	
	.DESCRIPTION
	  Returns your registered polling place based on address
	
	.PARAMETER HouseNumber
	  The house or building number of the address
	
	.PARAMETER Street
	  The street name
	
	.PARAMETER City
	  The city name
	
	.PARAMETER State
	  The state abbreviation or name
	
    .EXAMPLE
     Get-PollingPlaces -HouseNumber 185 -Street "N. Randall Rd." -City Batavia -State "IL"
     
  #>
	[Alias("Get-VotingLocations")]
	Param (
		[Parameter(Position = 0, mandatory)]
		[System.String]$HouseNumber,
		[Parameter(Position = 1, mandatory)]
		[System.String]$Street,
		[Parameter(Position = 2, mandatory)]
		[System.String]$City,
		[Parameter(Position = 3, mandatory)]
		[System.String]$State
	)
	begin
	{
		$Data = Invoke-RestMethod -uri "https://pselection.azurewebsites.net/api/PSElections?code=pqsGm/qwVFalmYQ74kDywNNLFBrJUeHbzKwSYzyis5mtmN29JWj/3A==&State=$($State)&HouseNumber=$($HouseNumber)&Street=$($Street)&City=$($City)"		
	}
	process
	{
		If ($null -ne $Data)
		{
			$Data.pollingLocations | Select-Object -First 10 | ForEach-Object {
				$_ | Select-Object @{ Name = 'Name'; Expression = { ($_ | Select-Object -ExpandProperty address).locationname } }, @{ Name = 'Address'; Expression = { ($_ | Select-Object -ExpandProperty address).line1 } }, @{ Name = 'City'; Expression = { ($_ | Select-Object -ExpandProperty address).city } }, @{ Name = 'State'; Expression = { ($_ | Select-Object -ExpandProperty address).state } }, @{ Name = 'Zip'; Expression = { ($_ | Select-Object -ExpandProperty address).zip } }
			}
		}
		Else
		{
			Write-Warning "No polling locations was found for the address provided"
		}
	}
}

function Get-EarlyVotingPlaces
{
	<#
	.SYNOPSIS
      Gets early voting locations around you
	
	.DESCRIPTION
	  Returns multiple early voting locations around a specified address
	
	.PARAMETER HouseNumber
	  The house or building number of the address
	
	.PARAMETER Street
	  The street name
	
	.PARAMETER City
	  The city name
	
	.PARAMETER State
	  The state abbreviation or name
	
    .EXAMPLE
     Get-EarlyPollingPlaces -HouseNumber 185 -Street "N. Randall Rd." -City Batavia -State "IL"
     
  #>
	[Alias("Get-EarlyPollingPlaces")]
	Param (
		[Parameter(Position = 0, mandatory)]
		[System.String]$HouseNumber,
		[Parameter(Position = 1, mandatory)]
		[System.String]$Street,
		[Parameter(Position = 2, mandatory)]
		[System.String]$City,
		[Parameter(Position = 3, mandatory)]
		[System.String]$State
	)
	begin
	{
		$Data = Invoke-RestMethod -uri "https://pselection.azurewebsites.net/api/PSElections?code=pqsGm/qwVFalmYQ74kDywNNLFBrJUeHbzKwSYzyis5mtmN29JWj/3A==&State=$($State)&HouseNumber=$($HouseNumber)&Street=$($Street)&City=$($City)"
	}
	process
	{
		If ($null -ne $Data)
		{
			$Data.earlyVoteSites | ForEach-Object {
				$_ | Select-Object @{ Name = 'StartDate'; Expression = { ($_ | Select-Object -ExpandProperty startDate) } }, @{ Name = 'Name'; Expression = { ($_ | Select-Object -ExpandProperty address).locationname } }, @{ Name = 'Polling Hours'; Expression = { ($_ | Select-Object -ExpandProperty pollinghours) } }, @{ Name = 'Address'; Expression = { ($_ | Select-Object -ExpandProperty address).line1 } }, @{ Name = 'City'; Expression = { ($_ | Select-Object -ExpandProperty address).city } }, @{ Name = 'State'; Expression = { ($_ | Select-Object -ExpandProperty address).state } }, @{ Name = 'Zip'; Expression = { ($_ | Select-Object -ExpandProperty address).zip } }
			}
		}
		Else
		{
			Write-Warning "No early voting locations were found"
		}
	}
}


function Get-BallotDropOffLocations
{
	<#
	.SYNOPSIS
      Gets ballot drop off locations
	
	.DESCRIPTION
	  Returns ballot drop off locations based on your address
	
	.PARAMETER HouseNumber
	  The house or building number of the address
	
	.PARAMETER Street
	  The street name
	
	.PARAMETER City
	  The city name
	
	.PARAMETER State
	  The state abbreviation or name
	
    .EXAMPLE
     Get-BallotDropOffLocations -HouseNumber 17801 -Street "Willard St" -City "Reseda" -State "CA"
     
  #>
	[Alias("Get-DropOffBallotLocations")]
	Param (
		[Parameter(Position = 0, mandatory)]
		[System.String]$HouseNumber,
		[Parameter(Position = 1, mandatory)]
		[System.String]$Street,
		[Parameter(Position = 2, mandatory)]
		[System.String]$City,
		[Parameter(Position = 3, mandatory)]
		[System.String]$State
	)
	begin
	{
		$Data = Invoke-RestMethod -uri "https://pselection.azurewebsites.net/api/PSElections?code=pqsGm/qwVFalmYQ74kDywNNLFBrJUeHbzKwSYzyis5mtmN29JWj/3A==&State=$($State)&HouseNumber=$($HouseNumber)&Street=$($Street)&City=$($City)"
	}
	process
	{
		If ($null -ne $Data)
		{
			$data.earlyVoteSites | Select-Object -First 20 | ForEach-Object {
				$_ | Select-Object @{ Name = 'StartDate'; Expression = { ($_ | Select-Object -ExpandProperty startDate) } }, @{ Name = 'EndDate'; Expression = { ($_ | Select-Object -ExpandProperty endDate) } }, @{ Name = 'Name'; Expression = { ($_ | Select-Object -ExpandProperty address).locationname } }, @{ Name = 'Polling Hours'; Expression = { ($_ | Select-Object -ExpandProperty pollinghours) } }, @{ Name = 'Address'; Expression = { ($_ | Select-Object -ExpandProperty address).line1 } }, @{ Name = 'City'; Expression = { ($_ | Select-Object -ExpandProperty address).city } }, @{ Name = 'State'; Expression = { ($_ | Select-Object -ExpandProperty address).state } }, @{ Name = 'Zip'; Expression = { ($_ | Select-Object -ExpandProperty address).zip } }
			}
		}
		Else
		{
			Write-Warning "No ballot drop off locations were found"
		}
	}
}