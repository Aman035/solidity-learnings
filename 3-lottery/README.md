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

#### Check Effect Implementation Design Pattern

- [CEI Design Pattern](https://fravoll.github.io/solidity-patterns/checks_effects_interactions.html)

#### ChainLink VRF

- Need
  - Generating a pure random no. inside a Smart contract is not possible and can be manipulated by the miner.
  - Chainlink overcomes the above issue and enables to verify this randomness thus enabling any temper of info.
- [Intro, Security Considerations, Best Practices, Implementation](https://docs.chain.link/vrf/v2/introduction)
- Reason for chossing Subscription Method - Seems more scalable
