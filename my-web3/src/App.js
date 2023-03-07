import "./App.css";
import React, { useEffect, useState } from "react";
import { init, mintToken } from "./web3";

function App() {
  const [minted, setMinted] = useState(false);
  const mint = () => {
    mintToken()
      .then((tx) => {
        console.log(tx);
        setMinted(true);
      })
      .catch((err) => {
        console.log(err);
      });
  };
  useEffect(() => {
    init();
  }, []);
  return (
    <div className="App">
      {!minted ? (
        <button onClick={() => mint()}>Mint Token</button>
      ) : (
        <p>Token minted successfully!</p>
      )}
    </div>
  );
}
export default App;
