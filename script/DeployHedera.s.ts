import 'dotenv/config'
import { ethers } from 'hardhat'


const main = async () => {
    const Shibuya = await ethers.getContractFactory('Shibuya')
    const Museum = await ethers.getContractFactory('Museum')
    const Collection = await ethers.getContractFactory('Collection')

    const shibuya = Shibuya.attach(process.env.SHIBUYA_ADDRESS ?? '')
    let museumAddress = await shibuya.createMuseum('Origami Primary Arrangement Museum')
    await museumAddress.wait()
    museumAddress = await shibuya.museums(0)
    const museum = Museum.attach(museumAddress)

    let btcusdAddress = await museum.createCollection('BTC-USD', 8, 1, '(int256)', true)
    btcusdAddress.wait()
    btcusdAddress = await museum.collections(0)
    const btcusd = Collection.attach(btcusdAddress)

    let ethusdAddress = await museum.createCollection('ETH-USD', 8, 1, '(int256)', true)
    ethusdAddress.wait()
    ethusdAddress = await museum.collections(1)
    const ethusd = Collection.attach(ethusdAddress)

    let ethbtcAddress = await museum.createCollection('ETH-BTC', 8, 1, '(int256)', true)
    ethbtcAddress.wait()
    ethbtcAddress = await museum.collections(2)
    const ethbtc = Collection.attach(ethbtcAddress)

    let hbarusdAddress = await museum.createCollection('HBAR-USD', 8, 1, '(int256)', true)
    hbarusdAddress.wait()
    hbarusdAddress = await museum.collections(3)
    const hbarusd = Collection.attach(hbarusdAddress)

    const c1 = await btcusd.curate(1, new ethers.AbiCoder().encode(['int256'], [2509757000000]))
    await c1.wait()
    const c2 = await ethusd.curate(1, new ethers.AbiCoder().encode(['int256'], [154270000000]))
    await c2.wait()
    const c3 = await ethbtc.curate(1, new ethers.AbiCoder().encode(['int256'], [61445000]))
    await c3.wait()
    const c4 = await hbarusd.curate(1, new ethers.AbiCoder().encode(['int256'], [4699000]))
    await c4.wait()

    console.log(`Origami Primary Arrangement Museum: ${museumAddress}`)
    console.log(`BTC-USD: ${btcusdAddress}`)
    console.log(`ETH-USD: ${ethusdAddress}`)
    console.log(`ETH-BTC: ${ethbtcAddress}`)
    console.log(`HBAR-USD: ${hbarusdAddress}`)
}

main().catch((error) => {
    console.error(error)
    process.exitCode = 1
})
