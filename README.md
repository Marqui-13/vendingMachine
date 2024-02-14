# Vending Machine Smart Contract

This project presents a Vending Machine smart contract developed in Solidity. It's designed to simulate the operation of a real-world vending machine within the Ethereum blockchain, allowing users to purchase donuts with Ether. The contract includes features for checking the vending machine's balance of donuts, restocking donuts by the owner, and purchasing donuts by customers.

## Features

- Owner Privileges: Only the owner can restock the vending machine.
- Donut Purchases: Users can purchase donuts with Ether.
- Balance Checks: Both the owner and customers can check the vending machine's donut balance.

## Technology Stack

- Solidity ^0.8.13: For writing the smart contract.
- Ethereum Blockchain: For deploying and running the smart contract.

## Smart Contract Functions

- `getVendingMachineBalance()`: Returns the number of donuts currently available in the vending machine.
- `restock(uint amount)`: Allows the owner to add more donuts to the vending machine.
- `purchase(uint amount)`: Enables customers to buy donuts, transferring ownership of the donuts to the buyer's address.

## Deployment

To deploy this contract to the Ethereum blockchain, you will need:

1. An Ethereum wallet with Ether for gas fees.
2. A development environment like Remix IDE, Truffle, or Hardhat.

### Steps

1. Compile the Contract: Use a Solidity compiler with version ^0.8.13.
2. Deploy the Contract: Through your chosen environment, deploy the contract to your desired Ethereum network (mainnet or testnets).
3. Verify the Contract: Optionally, verify and publish the contract's source code on Etherscan for transparency.

## Interacting with the Contract

After deployment, interact with the contract using:

- Ethereum wallets that support smart contract interaction (e.g., MetaMask).
- Web3 libraries like Web3.js or Ethers.js for building a frontend interface.

Examples:

- Restocking the Machine: Send a transaction to `restock()` with the desired amount as the owner.
- Purchasing Donuts: Send a transaction with the correct amount of Ether to `purchase()` specifying the number of donuts.

## Security Considerations

- Ensure that transactions are conducted securely, especially when sending Ether.
- The contract assumes a fixed price of 1 Ether per donut for simplicity.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE) file for details.

## Acknowledgments

- Ethereum and Solidity documentation for providing guidance on smart contract development.