targetScope = 'subscription'

param location string = 'eastus'
param sshPublicKey string
param bitcoinPassword string

var deploymentName = 'bitcoinvm'
var adminUsername = '${deploymentName}user'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${deploymentName}-${location}'
  location: location
}

module vnet 'modules/vnet.bicep' = {
  name: 'vnet'
  scope: resourceGroup(rg.name)
  params: {
    deploymentName: deploymentName
    location: location
  }
}

module nic 'modules/nic.bicep' = {
  name: 'nic'
  scope: resourceGroup(rg.name)
  params: {
    deploymentName: deploymentName
    location: location
    subnetId: vnet.outputs.subnetId
  }
}

module vm 'modules/vm.bicep' = {
  name: 'vm'
  scope: resourceGroup(rg.name)
  params: {
    deploymentName: deploymentName
    location: location
    networkInterfaceId: nic.outputs.networkInterfaceId
    adminUsername: adminUsername
    sshPublicKey: sshPublicKey
    bitcoinPassword: bitcoinPassword
  }
}
