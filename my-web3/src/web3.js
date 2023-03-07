import Web3 from "web3";
import NFTContractBuild from "./build/contracts/TempolandContract.json";

let selectedAccount;
let nftContract;

export const init = async () => {
  let provider = window.ethereum;

  if (typeof provider !== "undefined") {
    provider
      .request({ method: "eth_requestAccounts" })
      .then((accounts) => {
        selectedAccount = accounts[0];
        console.log(`Selected account is ${selectedAccount}`);
      })
      .catch((err) => {
        console.log(err);
      });
    window.ethereum.on("accountsChanged", function (accounts) {
      selectedAccount = accounts[0];
      console.log(`Selected account changed to ${selectedAccount}`);
    });
  }
  const web3 = new Web3(provider);
  //const networkId = await web3.eth.net.getId();
  nftContract = new web3.eth.Contract(
    NFTContractBuild.abi,
    "0x11a92e37ccaf92b34518cc153ef36a52bdb3cf7c"
  );
  console.log(nftContract);
};

export const mintToken = async () => {
  return nftContract.methods
    .mint(
      "0x0E19c7E7f63fD797970E1553f05F101d6403c74e",
      11,
      "day",
      10,
      "https://gateway.pinata.cloud/ipfs/QmYJoN3F5s99LgwAqtR7Vz3Jk6Wvbr4koe5Yx6mp5pZ3kK"
    )
    .send({ from: selectedAccount });
};
