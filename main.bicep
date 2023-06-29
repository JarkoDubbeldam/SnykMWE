param location string

module keyvault 'submodule.bicep' = {
  name: 'submodule'
  params: {
    keyvaultName: 'somekeyvault'
    location: location
  }
}
