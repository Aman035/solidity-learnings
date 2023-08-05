# FundeMe

[Resource Referenced](https://www.youtube.com/playlist?list=PL4Rj_WH6yLgWe7TxankiqkrkVKXIwOP42)

## Table of Contents

- [Introduction](#introduction)
- [Project Purpose](#project-purpose)
- [Requirements](#requirements)
- [Learnings + Resources](#learnings--resources)

## Introduction

A simple crowdfunding contract with the following features :-

- A min contribution amount in USD ( By using Chainlink orcales )
- Owner can withdraw all the funds

## Project Purpose

- Setup and Learn Foundry Functionalities
- Best Practices for writing Tests
- Some Solidity Optimizations

## Requirements

- `Git`
- `Foundry`
- `jq` ( Requirement for [Foundry DevOps](https://github.com/Cyfrin/foundry-devops) )
- `make` ( Optional )

## Learnings + Resources

#### Solidity Best Practices

- [Chainlink Style Guide](https://github.com/smartcontractkit/chainlink/blob/develop/contracts/STYLE.md)

- Custom errors are generally named as `ContractName__Error()`

- [NatSpec Comments](https://blockchainknowledge.in/guide-to-comments-in-solidity-including-natspec-format/)

#### Foundry Related

- [Installing Dependencies & Creating Remappings](https://book.getfoundry.sh/projects/dependencies)

- Foundry allows to write scripts in solidity itself which can be used for various use cases - such as Deployment etc.
- **Contract Deployment**

  - [Using forge create](https://book.getfoundry.sh/forge/deploying) - Most basic way of deployment
  - Using Deployment Script - Better And Clean Way of Deployment

    ```shell
    # Load env vars to shell
    source .env
    # To check if vars are loaded correctly
    echo $PRIVATE_KEY
    ```

    ```shell
      # ANVIL | LOCAL DEPLOYMENT

      # Start anvil
      anvil
      # ANVIL_PRC_URL & PRIVATE_KEY can be obtained from anvil terminal
      # Broadcast flag will create all contract details in .broadcast directory
      forge script script/DeployFundMe.s.sol --rpc-url $ANVIL_RPC_URL --private-key $PRIVATE_KEY --broadcast
    ```

    ```shell
      # REAL ENV DEPLOYMENT

      # Take rpc url from alchemy or quicknode
      # Use any metamask acc priv key
      # Verify flag with etherscan api key can verify contract at the time of deployment programatically
      forge script script/DeployFundMe.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
    ```

- **Tests in Foundry**

  - [Writing Tests as solidity contracts](https://book.getfoundry.sh/forge/tests)
  - [Different Test Command Params](https://book.getfoundry.sh/reference/forge/forge-test)
  - Types of Testing
    1. **Unit**: Testing a single function
    2. **Integration**: Testing multiple functions
    3. **Forked**: Testing on a forked network
    4. **Staging**: Testing on a live network (testnet or mainnet)
  - **Refactor** - Using Deployment Script in test cases.
  - Executing tests with fork env ( simulatues to the given rpc url ie mainly reads data from the blockchain environment ). This is very useful since contracts can use other contracts which are deployed to specific env and would fail for local anvil chain testing
    ```shell
    forge test --rpc-url $SEPOLIA_RPC_URL
    ```
  - **Refactor** - Testing contracts on diff forks using HelperConfig scripts and mocking contracts on Anvil ( local ) chain which enables running tests and coverage on Anvil itself
  - Running only a specific test
    ```shell
    # Just do forge test --help to see all options
    forge test --mt test_FundUpdatesFundedDataStructure
    ```

- [Forge Coverage](https://www.rareskills.io/post/foundry-testing-solidity) - Checking Test Coverage of Code

  ```shell
  forge coverage
  # Tesing on a specific fork
  forge coverage --rpc-url $SEPOLIA_URL
  ```

- [Brief Intro to Chisel](https://book.getfoundry.sh/reference/chisel/)

- [Checking Gas Usage By Test Fns](https://book.getfoundry.sh/reference/forge/forge-snapshot?highlight=snapshot#forge-snapshot)
  ```shell
  gas snapshot
  ```
- Code Formating
  ```shell
  forge fmt
  ```
- Gas Price on Anvil is 0 but this can also be changed for testing - This is the reason one can perform mathematical operations on balance checks before and after tx ignoring gas costs

  ```shell
  // vm.txGasPrice(GAS_PRICE); // set price
  // uint256 gasStart = gasleft();
  // // Act
  vm.startPrank(fundMe.getOwner());
  fundMe.withdraw();
  vm.stopPrank();

  // uint256 gasEnd = gasleft();
  // uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
  ```

#### Gas Optimization

- Using Constant & Immutable
- Less Read and write to storage varaibles - This takes more gas as compared to memory. Check out gas usage by `SLOAD` `SSTORE` [here](https://www.evm.codes/?fork=shanghai)
