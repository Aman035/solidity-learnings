# Lottery ( Provably Random Raffle Contract )

[Resource Referenced](https://www.youtube.com/playlist?list=PL4Rj_WH6yLgWe7TxankiqkrkVKXIwOP42)

## Table of Contents

- [Introduction](#introduction)
- [Project Purpose](#project-purpose)
- [Requirements](#requirements)
- [Learnings + Resources](#learnings--resources)

## Introduction

A Raffle Contract with the following features :-

- Allow users to take part in lottery by buying a ticket ( each ticket will have some fee associated )
- After a fixed period a random user will be chossen and all the ticket fees would to tranfered to that user
  - Chainlink automation will be used for this
  - Chainlink VRF is used for having true randomness

## Project Purpose

## Requirements

- `Git`
- `Foundry`
- `make` ( Optional )

## Learnings + Resources

#### Layout Structure of Contract ( Taken from Solidity Docs )

1. version
2. imports
3. errors
4. interfaces, libraries, contracts
5. Type declarations
6. State variables
7. Events
8. Modifiers
9. Functions
   1. constructor
   2. receive function (if exists)
   3. fallback function (if exists)
   4. external
   5. public
   6. internal
   7. private
   8. view & pure functions ( Getters )

#### Events

- Events are usually emited out whenever there are changes to storage variables and are a cheap way of logging data.
- At max 3 params can be indexed ( indexed params are easy to query and bloom filters can be applied to them )

#### Check Effect Interaction Design Pattern

- [CEI Design Pattern](https://fravoll.github.io/solidity-patterns/checks_effects_interactions.html)

#### ChainLink VRF

- Need
  - Generating a pure random no. inside a Smart contract is not possible and can be manipulated by the miner.
  - Chainlink overcomes the above issue and enables to verify this randomness thus enabling any temper of info.
- [Intro, Security Considerations, Best Practices, Implementation](https://docs.chain.link/vrf/v2/introduction)
- Reason for choosing Subscription Method - Seems more scalable
- VRF is a 2 trx fn rather than being executed in a single trx.

#### ChainLink Automation

- Used for calling contract function after a certain interval or on having some custom condition meet.

#### Raffle Contract Overview

- Errors can have different params which help to debug issue easily.
  ```
  error Raffle__UpkeepNotNeeded(uint256 balance, uint256 playersLength, uint256 raffleState);
  ```
- Use of `VRFConsumerBaseV2` Interface - To make sure we are using a chainLink compatible `fulfillRandomWords` fn.
- use of `AutomationCompatibleInterface` Interface - To make sure we are using compatible `checkUpkeep` and `performUpkeep` fn.
- Use of `VRFCoordinatorV2Interface`- To make sure conract has access to all the fn provided by the vrfCoordinator contract.
- Events has indexed param thus enabling filtered fetching of event logs using those params.
  ```
  event PickedWinner(address indexed winner);
  ```
- `checkUpkeep` is kept as public rather than external ( as mentioned in docs ) since we are also calling it in the `performUpKeep` fn from the contract itself.
- `checkUpkeep` checkData is changed to memory from callData ( as mentioned in docs ) since we are calling it also internally from contract.
- Fn input params and return params can be marked as commented to avoid warnings and tell compiler we are not going to use it.
  ```
  function checkUpkeep(bytes memory /* checkData */ )
        public
        view
        override
        returns (bool upkeepNeeded, bytes memory /* performData */ )
  ```
- `fulfillRandomWords` is kept as internal and is called by `requestRandomWords` as a callback fn

#### Tests OverView

- Mostly Test follows the structure of
  - Arrange
  - Act
  - Asset
- [Foundry Cheatcodes](https://book.getfoundry.sh/cheatcodes/) can be very useful for tests and help to test various conditions as depicted in test files.
- Checkout `test_RafflePerformUpkeepUpdatesStateAndEmitEventOnCheckUpkeepTrue` as it focuses on detailed analysis and testing of an event. ( Mostly running test with -vvvv shows all event details too. )
- [Fuzz Tests](https://book.getfoundry.sh/forge/fuzz-testing?highlight=fuzz#fuzz-testing) are important to test a fn for various inputs.
- The tests where we call `vrfCoordinatorV2Mock.fulfillRandomWords` should be skipped on other networks since this would be called by chainLink nodes itself.

#### Deploy Scripts Overview

- Raffle Contract deployed using HelperConfig for defining config for diff chains
- For local testing Mock VRFCoordinatorV2 needs to be deployed
- For using VRFCoordinatorV2 in Raffle Contract
  1. A subscription should be created.
  2. Subscription should be funded using LINK Token - for local one needs to deploy a mock LINK Token
  3. Raffle Contract should be added as a consumer to VRFCoordinatorV2 - foundry-devops is used for getting the latest deployed Raffle contract so that it can be added as consumer. ( For this ffi should be true in foundry.toml )
  4. We added deployerKey in deploy script since only the address which created the subscription can add the raffle contract as a consumer, there using the default anvil key won't work and deployer script will fail.
