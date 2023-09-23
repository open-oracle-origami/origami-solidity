import 'dotenv/config'
import { ethers } from 'hardhat'


const main = async () => {
    const Collection = await ethers.getContractFactory('Collection')
    const hbarusd = Collection.attach(process.env.HBARUSD_ADDRESS ?? '')

    console.log(await hbarusd.latestAnswer())
}

main().catch((error) => {
    console.error(error)
    process.exitCode = 1
})
