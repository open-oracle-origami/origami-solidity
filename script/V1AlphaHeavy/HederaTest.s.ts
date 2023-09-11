import { hethers } from 'hardhat'

const main = async () => {
    const CollectionImplV1 = await hethers.getContractFactory('CollectionImplV1')

    const collectionImpl = await CollectionImplV1.deploy()
    //await collectionImpl.waitForDeployment()

    console.log(`Collection Implementation: ${collectionImpl.target}`)
}

main().catch((error) => {
    console.error(error)
    process.exitCode = 1
})
