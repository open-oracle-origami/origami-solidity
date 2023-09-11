import { hethers } from 'hardhat'

const ethers = hethers

const main = async () => {
    const ERC1967Proxy = await ethers.getContractFactory('ERC1967Proxy')
    const UpgradeableBeacon = await ethers.getContractFactory('UpgradeableBeacon')
    const ShibuyaImplV1 = await ethers.getContractFactory('ShibuyaImplV1')
    const MuseumImplV1 = await ethers.getContractFactory('MuseumImplV1')
    const CollectionImplV1 = await ethers.getContractFactory('CollectionImplV1')

    const collectionImpl = await CollectionImplV1.deploy()
    await collectionImpl.waitForDeployment()
    const collectionBeacon = await UpgradeableBeacon.deploy(collectionImpl.target)
    // await collectionBeacon.waitForDeployment()

    const museumImpl = await MuseumImplV1.deploy()
    // await museumImpl.waitForDeployment()
    const museumBeacon = await UpgradeableBeacon.deploy(museumImpl.target)
    // await museumBeacon.waitForDeployment()

    const shibuyaImpl = await ShibuyaImplV1.deploy()
    // await shibuyaImpl.waitForDeployment()
    const shibuyaProxy = await ERC1967Proxy.deploy(shibuyaImpl.target, shibuyaImpl.interface.encodeFunctionData('initialize', [museumBeacon.target, collectionBeacon.target]))
    // await shibuyaProxy.waitForDeployment()

    console.log(`Collection Implementation: ${collectionImpl.target}`)
    console.log(`Collection Beacon: ${collectionBeacon.target}`)

    console.log(`Museum Implementation: ${museumImpl.target}`)
    console.log(`Museum Beacon: ${museumBeacon.target}`)

    console.log(`Shibuya Implementation: ${shibuyaImpl.target}`)
    console.log(`Shibuya Proxy: ${shibuyaProxy.target}`)
}

main().catch((error) => {
    console.error(error)
    process.exitCode = 1
})
