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

  /* ---------------- DEPLOYMENT ---------------- */

  it("should deploy successfully", async function () {
    expect(await nft.getAddress()).to.properAddress;
  });

  /* ---------------- PAUSE / UNPAUSE ---------------- */

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

  /* ---------------- MINTING ---------------- */

  it("should allow admin to mint NFT", async function () {
    await nft.connect(owner).mint(owner.address);
    expect(await nft.ownerOf(0)).to.equal(owner.address);
  });

  it("should emit Transfer event on mint", async function () {
    await expect(nft.connect(owner).mint(owner.address))
      .to.emit(nft, "Transfer")
      .withArgs(ethers.ZeroAddress, owner.address, 0);
  });

  it("should revert minting to zero address", async function () {
    await expect(
      nft.connect(owner).mint(ethers.ZeroAddress)
    ).to.be.reverted;
  });

  /* ---------------- TRANSFERS ---------------- */

  it("should transfer NFT between users", async function () {
    await nft.connect(owner).mint(owner.address);
    await nft.connect(owner).transferFrom(owner.address, user.address, 0);
    expect(await nft.ownerOf(0)).to.equal(user.address);
  });

  /* ---------------- APPROVALS ---------------- */

  it("should approve another address", async function () {
    await nft.connect(owner).mint(owner.address);
    await nft.connect(owner).approve(user.address, 0);
    expect(await nft.getApproved(0)).to.equal(user.address);
  });

  it("should set operator approval", async function () {
    await nft.connect(owner).setApprovalForAll(user.address, true);
    expect(
      await nft.isApprovedForAll(owner.address, user.address)
    ).to.equal(true);
  });

  /* ---------------- INVALID TOKEN ---------------- */

  it("tokenURI should revert for invalid tokenId", async function () {
    await expect(nft.tokenURI(0)).to.be.revertedWith("Token does not exist");
  });
});
