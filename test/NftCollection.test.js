const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("NftCollection", function () {
  let nft;
  let owner;
  let user;

  beforeEach(async function () {
    [owner, user] = await ethers.getSigners();
    const NftCollection = await ethers.getContractFactory("NftCollection");
    nft = await NftCollection.deploy();
    await nft.waitForDeployment();
  });

  it("should deploy successfully", async function () {
    expect(await nft.getAddress()).to.properAddress;
  });

  it("admin should be able to pause minting", async function () {
    await nft.connect(owner).pauseMinting();
  });

  it("admin should be able to unpause minting", async function () {
    await nft.connect(owner).pauseMinting();
    await nft.connect(owner).unpauseMinting();
  });

  it("non-admin should not be able to pause minting", async function () {
    await expect(
      nft.connect(user).pauseMinting()
    ).to.be.revertedWith("Not admin");
  });

  it("tokenURI should revert for invalid tokenId", async function () {
    await expect(nft.tokenURI(0)).to.be.revertedWith("Token does not exist");
  });
});
