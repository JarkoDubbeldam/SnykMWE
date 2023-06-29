param keyvaultName string
param location string


resource keyvault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyvaultName
  location: location
  properties: {
    sku: {
      name: 'standard'
      family: 'A'
    }
    publicNetworkAccess: 'enabled' // Gasp!
    tenantId: tenant().tenantId
  }
}
