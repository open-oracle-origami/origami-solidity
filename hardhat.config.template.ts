import type { HardhatUserConfig } from 'hardhat/config'
import '@nomicfoundation/hardhat-toolbox'
import '@nomicfoundation/hardhat-foundry'
//import '@hashgraph/hardhat-hethers'
import '@nomicfoundation/hardhat-ethers'

const config: HardhatUserConfig = {
    solidity: '0.8.21',
    hedera: {
        gasLimit: 300000,
        networks: {
            testnet: {
                accounts: [
                    {
                        account: '0.0.0...',
                        privateKey: '0x00...'
                    },
                ]
            }
        }
    }
}

export default config
