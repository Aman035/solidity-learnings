# Smart Contract Development

Welcome to the Smart Contract Development Repository!

This repository serves as a comprehensive collection of my journey and discoveries in smart contract development. Whether you're a seasoned blockchain developer or just taking your first steps into smart contract development, you'll find valuable insights, code snippets, and resources that can enhance your understanding and proficiency.

## Table of Contents

- [Introduction](#introduction)
- [Basic Concepts](#basic-concepts)
- [Project 1: Fund Me](#project-1-fund-me)
- [Contributions and Acknowledgements](#contributions-and-acknowledgements)

## Introduction

This repository documents my learning journey in smart contract development, focusing primarily on Solidity for EVM-compatible blockchains.

**This is a project-centric roadmap** - learning happens through building projects, not just studying theory. Each project builds on previous knowledge and introduces new concepts through hands-on implementation.

The goal is to create a consolidated reference for revisiting concepts and techniques, while also serving as a resource for others on similar learning paths. Each project includes its own directory with code and documentation.

## Basic Concepts

> **Note:** These concepts are meant to be skimmed for quick reference. Don't spend too much time here - the real learning happens through the projects. If you get bored, jump straight to the Project section.

- https://solidity-by-example.org/ - The Basics Section
- [Storage Vs Memory Vs Calldata](https://hackernoon.com/memory-calldata-and-storage-in-solidity-understanding-the-differences)
- [Inheritence in Solidity](https://solidity-by-example.org/inheritance/)
- [Bytes in Solidity](https://jeancvllr.medium.com/solidity-tutorial-all-about-bytes-9d88fdb22676)
- [Require Vs Assert](<https://dev.to/tawseef/require-vs-assert-in-solidity-5e9d#:~:text=assert(bool%20condition)%20causes%20a,in%20inputs%20or%20external%20components>)
- [Modifiers](https://medium.com/coinmonks/solidity-tutorial-all-about-modifiers-a86cf81c14cb)
- [Events](https://medium.com/coinmonks/learn-solidity-lesson-27-events-f47070b55851)
  - What r indexed values & their usage ?
  - Max indexed values in event - 3
  - What r anonymous events ?
  - Max indexed values in anon events - 4
- [Where r event logs stored](https://ethereum.stackexchange.com/questions/1302/where-do-contract-event-logs-get-stored-in-the-ethereum-architecture)
- [Fallback and Receive & Related Security](https://blog.solidityscan.com/understanding-security-of-fallback-recieve-function-in-solidity-9d18c8cad337)
- [Usecase for Unchecked](https://medium.com/@ashwin.yar/solidity-tips-and-tricks-1-unchecked-arithmetic-trick-cefa18792f0b)
- Pure and view functions do not cost when called externally. But they do cost when called internally.
- External visibility type is not available for state variables.
- By default storage variables are internal.
- Constant becomes part of the bytecode at compile time whereas immutable variables become part of bytecode at deployment.
  - For a constant variable, the expression assigned to it is copied to all the places where it is accessed and also re-evaluated each time. This allows for local optimizations.
  - Immutable variables are evaluated once at construction time and their value is copied to all the places in the code where they are accessed. For these values, 32 bytes are reserved. Due to this, constant values can sometimes be cheaper than immutable values.
- Assignment btw diff data locations types.

  - Assignments between storage and memory (or from calldata) always create an independent copy.
  - Assignments from memory to memory only create references. As a result changes to one memory variable are also visible in all other memory variables that refer to the same data.

      <img src="https://github.com/Aman035/solidity-learnings/assets/54989169/690f48f9-bd93-4ee8-ab77-7d8a08577410" alt="alt text" height="400">

  - Assignments from storage to a localstorage variable also only assign a reference.
  - All other assignments to storage always creates independent copies.

- Before writing any smart contract, one can add the license identifier at the top of the file (Optional but recommended) and specify the Solidity version you intend to work with.

  ```solidity
  // SPDX-License-Identifier: MIT

  // Specifies that contract is written for Solidity version 0.8.17 and is compatible with any version of Solidity greater than or equal to 0.8.17
  pragma solidity ^0.8.17;

  // Specifies that contract is written for Solidity version 0.8.17 and is compatible with any version of Solidity greater than or equal to 0.8.17 but less than 0.9.0
  pragma solidity >=0.8.17 <0.9.0;
  ```

- Using Named Imports is recommended over using wildcard imports.

  ```solidity
  // Named Imports
  import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

  // Wildcard Imports - Importing all the contracts from the ERC20.sol file
  import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
  ```

- Assigning Min and Max Values to int and uint

  ```solidity
  // int
  int public minInt = type(int).min; // -2^255
  int public maxInt = type(int).max; // 2^255 -1

  // uint
  uint public minUint = type(uint).min; // 0
  uint public maxUint = type(uint).max; // 2^256-1
  ```

- `delete` keyword resets the value to default ( used in mappings and array )

  ```solidity
  // Mapping from address to uint
  mapping(address => uint) public myMap;
  // Reset the value to the default value.
  delete myMap[_addr];

  uint[] public arr;
  // Delete does not change the array length.
  // It resets the value at index to it's default value,
  // in this case 0
  delete arr[index];
  ```

- Only fixed size array can be declared in memory ( ie inside functions ) and also mapping can't be declared in memory.
- Enums in solidity r a bit diff than TS - u can't assign them anything

  ```solidity
  enum Status {
      Pending,
      Shipped,
      Accepted,
      Rejected,
      Canceled
  }
  // Returns uint
  // Pending  - 0
  // Shipped  - 1
  // Accepted - 2
  // Rejected - 3
  // Canceled - 4
  ```

## Project 1: Fund Me

### Goal

### Learnings

## Contributions and Acknowledgements

Resources referenced throughout this repository are credited in their respective directories.
