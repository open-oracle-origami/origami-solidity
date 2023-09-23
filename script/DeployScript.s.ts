import 'dotenv/config'
import { ethers } from 'hardhat'


const main = async () => {
    // TODO: Make work with Create3 later...
    // const C3 = await ethers.getContractFactory('C3')
    // const c3 = await C3.deploy()
    // await c3.waitForDeployment()

    const Collection = await ethers.getContractFactory('Collection')
    const collection = await Collection.deploy()
    await collection.waitForDeployment()

    const Museum = await ethers.getContractFactory('Museum')
    const museum = await Museum.deploy()
    await museum.waitForDeployment()

    const Shibuya = await ethers.getContractFactory('Shibuya')
    const shibuya = await Shibuya.deploy(500, process.env.TREASURY_ADDRESS ?? '', museum.target, collection.target)
    await shibuya.waitForDeployment()

    console.log(`Collection: ${collection.target}`)
    console.log(`Museum: ${museum.target}`)
    console.log(`Shibuya: ${shibuya.target}`)
}

main().catch((error) => {
    console.error(error)
    process.exitCode = 1
})
