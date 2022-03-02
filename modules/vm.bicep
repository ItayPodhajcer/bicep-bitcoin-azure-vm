param deploymentName string
param location string
param networkInterfaceId string
param adminUsername string
param sshPublicKey string
param bitcoinPassword string

var serviceFile = format(loadTextContent('./bitcoind.tpl'), adminUsername)
var entrypointFile = format(loadTextContent('./entrypoint.tpl'), adminUsername, bitcoinPassword, serviceFile)

resource vm 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: 'vm-${deploymentName}'
  location: location
  properties: {
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaceId
        }
      ]
    }
    hardwareProfile: {
      vmSize: 'Standard_L8s_v2'
    }
    storageProfile: {
      osDisk: {
       name:'disk-${deploymentName}' 
       createOption: 'FromImage'
       caching: 'ReadWrite'
       managedDisk: {
         storageAccountType: 'Premium_LRS'
       }
      }
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
    }
    osProfile: {
      computerName: 'vm-${deploymentName}'
      adminUsername: adminUsername
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              keyData: sshPublicKey
              path: '/home/${adminUsername}/.ssh/authorized_keys'
            }
          ]
        }
      }
    }
    userData: base64(entrypointFile)
  }
}
