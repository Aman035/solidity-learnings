# Call Anything

[Resource Referenced](https://github.com/Cyfrin/foundry-nft-f23/blob/main/src/sublesson/CallAnything.sol)

## Table of Contents

- [Introduction](#introduction)
- [Learnings + Resources](#learnings--resources)

## Introduction

Here, we would see how we can call contract functions ( same or other contract ) using `call` and function encoding.
Al the examples here are tested using `remix`.

## Learnings + Resources

### Calling Function of Other Contract

- For calling a contract from another contract, we require 2 things
  - Address of the contract
  - Contract ABI
- Generally to call a fn of another contract, we keep its addreess as a state variable or a constant and import the function interface ( this works out as the ABI for the function we want to call )
- Another way of calling contract is using low level `call` function, we still need the address of the contract and also we can pass the fn signature that we are trying to call ( this is the function encoding )

### Using Call and encoding function to be called

- Each contract assigns each function a unique function ID. This is known as the "function selector".
  - Note - This also means that a single contract cannot have two functions with the same function selector. ( There are same possible cases where a contract might not compile since 2 functions have same function selector )
  - A Good resource to check functions with same selectors - https://openchain.xyz/signatures
    ![image](https://github.com/Aman035/solidity-learnings/assets/54989169/6d13c078-9920-4203-8bfa-78687600bb3c)

- The `function selector` is the first 4 bytes of the function signature.
- The `function signature` is a string that defines the function name & parameters.
