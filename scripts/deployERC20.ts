async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying with account:", deployer.address);

    const ERC20 = await ethers.getContractFactory("ERC20");
    const token = await ERC20.deploy("Kenny Token", "KT", 1, 1000000);

    await token.deployed();
    console.log("ERC20 deployed to:", token.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
