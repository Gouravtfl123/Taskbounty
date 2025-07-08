const hre = require("hardhat");

async function main() {
  // Get the ContractFactory for TaskBounty
  const TaskBounty = await hre.ethers.getContractFactory("TaskBounty");

  // Deploy the contract
  const taskBounty = await TaskBounty.deploy();

  // Wait for deployment
  await taskBounty.deployed();

  console.log("✅ TaskBounty deployed to:", taskBounty.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Deployment failed:", error);
    process.exit(1);
  });
