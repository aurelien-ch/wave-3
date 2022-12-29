# Wave3

Wave3 is a decentralized application (dApp) that allows users to wave at me by making an Ethereum transaction on the Goerli testnet. Each user's waves are recorded on the blockchain, and a leaderboard displays the users who have waved the most times. Users can only wave once every 24 hours.

Link : https://wave-3.vercel.app/

This repository is the smart contract of Wave3 (Solidity).

## Set up

To set up and test the smart contract locally:

1. Clone the repository : `git clone https://github.com/aurelien-ch/wave-3.git`
2. Run the test script : `npx hardhat run scripts/run.js`

## Deployment

To deploy the contract on the Goerli testnet : `npx hardhat run scripts/deploy.js --network goerli`
