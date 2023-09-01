# MoodNFT

[Resource Referenced](https://youtu.be/sas02qSFZ74?si=uhET4MoBXiiLrg2b&t=29647)

## Table of Contents

- [Introduction](#introduction)
- [Requirements](#requirements)
- [Learnings + Resources](#learnings--resources)

## Introduction

## Requirements

- `Git`
- `Foundry`
- `jq` ( Requirement for [Foundry DevOps](https://github.com/Cyfrin/foundry-devops) )
- `make` ( Optional )

## Learnings + Resources

### String Comparison

```soldity
// Does not work
sting memory a = "abc";
sting memory b = "abc";
if (a == b) {
    // Do something
}
```

- Strings are stored as arrays of bytes in Solidity and thus cannot be compared directly.
- Use `keccak256` to compare strings

```solidity
sting memory a = "abc";
bytes memory aEncoded = abi.encodePacked(a);
bytes32 aHash = keccak256(aEncoded);

sting memory b = "abc";
bytes memory bEncoded = abi.encodePacked(b);
bytes32 bHash = keccak256(bEncoded);

if (aHash == bHash) {
    // Do something
}
```
