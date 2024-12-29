# Fund Me

**Fund Me** is a simple crowdsourcing app that runs on the blockchain. It allows users to pool funds together for various causes or projects, leveraging the transparency and security of smart contracts.

## Getting Started

To get started with the Fund Me app, you'll need to set up the development environment, which involves installing Foundry, cloning the repository, and running the contract locally.

### Prerequisites

- **Foundry**: A fast, portable, and secure toolchain for Ethereum smart contract development. 
  - Install Foundry: [https://foundry.paradigm.xyz](https://foundry.paradigm.xyz)

### Requirements

- **Solidity**: This project is written purely in Solidity.
- **Foundry**: Required to test and deploy the smart contracts.

### Quick Start

Follow these steps to get the app running locally:

1. **Install Foundry** if you haven't already:

    ```bash
    curl -L https://foundry.paradigm.xyz | bash
    ```

2. **Clone the repository**:

    ```bash
    git clone https://github.com/yourusername/fund-me.git
    ```

3. **Navigate to the project folder**:

    ```bash
    cd fund-me
    ```

4. **Install dependencies**:

    ```bash
    forge install
    ```

5. **Run tests**:

    To run the tests for the smart contracts, use the following command:

    ```bash
    forge test
    ```

    This will execute all the tests written in the contract files and show you the results.

6. **Deploy the smart contract** (optional):

    To deploy the smart contract, use Foundry’s deployment scripts or modify as needed. For example:

    ```bash
    forge deploy
    ```

## License

Distributed under the MIT License. See `LICENSE` for more information.


