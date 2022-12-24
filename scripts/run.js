const main = async () => {
  const [owner, randomPerson1, randomPerson2] = await hre.ethers.getSigners();
  const waveContractFactory = await hre.ethers.getContractFactory("Wave3");
  const waveContract = await waveContractFactory.deploy();
  await waveContract.deployed();

  console.log("Contract deployed to :", waveContract.address);
  console.log("Contract deployed by :", owner.address);

  console.log("Total waves count :", await waveContract.getTotalWavesCount());

  const firstWaveTxn = await waveContract.wave();
  await firstWaveTxn.wait();

  console.log(owner.address, "just waved");
  console.log("Total waves count :", await waveContract.getTotalWavesCount());

  const secondWaveTxn = await waveContract.connect(randomPerson1).wave();
  await secondWaveTxn.wait();

  console.log(randomPerson1.address, "just waved");
  console.log("Total waves count :", await waveContract.getTotalWavesCount());

  const thirdWaveTxn = await waveContract.connect(randomPerson2).wave();
  await thirdWaveTxn.wait();

  console.log(randomPerson2.address, "just waved");
  console.log("Total waves count :", await waveContract.getTotalWavesCount());

  console.log("Top wavers :", await waveContract.getTopWavers());
  console.log("Five first waves :", await waveContract.getWaves(0, 5));
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