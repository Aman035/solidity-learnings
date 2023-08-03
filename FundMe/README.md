# FundeMe

A simple crowdfunding contract with the following features :-

- A min contribution amount in USD ( By using Chainlink orcales )
- Withdaw fn by Contract Owner
- Handling cases when someone tries to send Eth to contract

## Learnings From This Project

- Installing dependencies in Foundry and remappings- https://book.getfoundry.sh/projects/dependencies
- Loading env variables to shell ( this is related to shell and not solidity or foundry )
  ```shell
  # After making changes in .env
  source .env
  echo $PRIVATE_KEY
  ```
- Deploying Contracts

  - Using forge create - https://book.getfoundry.sh/forge/deploying
  - Using Deployment Script
    ```shell
      # Load env vars to shell
      source .env
      # Start anvil
      anvil
      # Deploy Contract and boradcast
      # We can also verify the contract using --verify flag in this command
      # Also we can change the rpc url to Sepolia to mainnet to deploy it to that env
      # We can skip private key if we r just deploying to anvil
      forge script script/DeployMyWallet.s.sol --rpc-url $LOCAL_RPC_URL --private-key $PRIVATE_KEY --broadcast
    ```

- Solidity Learnings

  - Naming conventions for constant, immutable, storage types and code structuring
  - Usage of receive and fallback
  - Using constants wherever possible - Gas Opt. as they r stored in bytecode
  - Using immutable if constant is not possible - Gas Opt. as they r stored in bytecode ( Some Gas is used to initialize it while deployment )
  - Using Custom Errors - Using this instead of require with strings saves Gas
  - Using private for storage members and using getters for them instead - Gas Opt.

- Wrting Tests in Foundry

  - https://book.getfoundry.sh/forge/tests
  - Different Test Command Params - https://book.getfoundry.sh/reference/forge/forge-test
  - Types of Testing
    1. Unit: Testing a single function
    2. Integration: Testing multiple functions
    3. Forked: Testing on a forked network
    4. Staging: Testing on a live network (testnet or mainnet)
  - Refactor - Using Deployment Script for Contract Deployment and using this script for test cases
  - Executing tests with fork env ( simulatues to the given rpc url ie mainly reads data from the blockchain environment ). This is very useful since contracts can use other contracts which are deployed to specific env and would fail for local anvil chain testing
    ```
    forge test --rpc-url $SEPOLIA_RPC_URL
    ```
  - Testing contracts on diff forks using HelperConfig scripts and mocking contracts on Anvil ( local ) chain which enables running tests and coverage on Anvil itself
  - Running only a specific test
    ```shell
    # Just do forge test --help to see all options
    forge test --mt test_FundUpdatesFundedDataStructure
    ```

- Forge Coverage - For checking out test coverage of code

  - https://www.rareskills.io/post/foundry-testing-solidity
    ```shell
    forge coverage
    # Tesing on a specific fork
    forge coverage --rpc-url $SEPOLIA_URL
    ```

- Brief intro to chisel - https://book.getfoundry.sh/reference/chisel/
- To check how much fee our test functions are using - https://book.getfoundry.sh/reference/forge/forge-snapshot?highlight=snapshot#forge-snapshot
  ```shell
  gas snapshot
  ```