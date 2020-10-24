#Azure Function for PSElection Module
using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)


$HouseNumber = $Request.Query.HouseNumber
$Street = $Request.Query.Street
$City= $Request.Query.City
$State = $Request.Query.State



$Address = "$HouseNumber $Street $City $State"
$AddressFormat = $Address.Replace(" ","%20")
$APIKey = $ENV:apikey
$resource = "https://www.googleapis.com/civicinfo/v2/voterinfo/?key=$APIKey&address=$AddressFormat"

$body = Invoke-RestMethod -Method Get -Uri $resource 


# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})
