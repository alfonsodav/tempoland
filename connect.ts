/* import { config as loadEnv } from "dotenv";
import { SDK, Auth, TEMPLATES } from "@infura/sdk";

loadEnv();

const auth = new Auth({
  projectId: process.env.INFURA_API_KEY,
  secretId: process.env.INFURA_API_KEY_SECRET,
  privateKey: process.env.WALLET_PRIVATE_KEY,
  rpcUrl: process.env.EVM_RPC_URL,
  chainId: 5, // Goerli
  ipfs: {
    projectId: process.env.INFURA_IPFS_PROJECT_ID,
    apiKeySecret: process.env.INFURA_IPFS_PROJECT_SECRET,
  },
});

const sdk = new SDK(auth);

const newContract = await sdk.deploy({
  template: TEMPLATES.ERC721Mintable,
  params: {
    name: '1507Contract',
    symbol: 'TOC',
    contractURI: storeMetadata,
  },
});

// mint a NFT
const mint = await newContract.mint({
  publicAddress:
    process.env.WALLET_PUBLIC_ADDRESS ??
    "0x3bE0Ec232d2D9B3912dE6f1ff941CB499db4eCe7",
  tokenURI: storeTokenMetadata,
});

const minted = await mint.wait();

// READ API
// Get contract metadata
const contractMetadata = await sdk.api.getContractMetadata({
  contractAddress: newContract.contractAddress,
});
console.log("contractMetadata:", contractMetadata);

// Get the token metadata
const tokenMetadataResult = await sdk.api.getTokenMetadata({
  contractAddress: newContract.contractAddress,
  tokenId: 0,
});

console.log("tokenMetadataResult:", tokenMetadataResult);
 */
