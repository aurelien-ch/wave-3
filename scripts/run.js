const main = async () => {
  const [owner, randomPerson1, randomPerson2] = await hre.ethers.getSigners();
  const waveContractFactory = await hre.ethers.getContractFactory("Wave3");
  const waveContract = await waveContractFactory.deploy();
  await waveContract.deployed();

  console.log("Contract deployed to :", waveContract.address);
  console.log("Contract deployed by :", owner.address);

  await waveContract.getTotalWaves();

  const firstWaveTxn = await waveContract.wave();
  await firstWaveTxn.wait();

  await waveContract.getTotalWaves();

  const secondWaveTxn = await waveContract.connect(randomPerson1).wave();
  await secondWaveTxn.wait();

  await waveContract.getTotalWaves();

  const thirdWaveTxn = await waveContract.wave();
  await thirdWaveTxn.wait();

  await waveContract.getTotalWaves();

  const fourthWaveTxn = await waveContract.connect(randomPerson2).wave();
  await fourthWaveTxn.wait();

  const fifthWaveTxn = await waveContract.connect(randomPerson2).wave();
  await fifthWaveTxn.wait();

  await waveContract.getTotalWaves();
  await waveContract.getSenderWaves();
  await waveContract.getTopWavers();
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();