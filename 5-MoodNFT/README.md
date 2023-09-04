# MoodNFT

[Resource Referenced](https://youtu.be/sas02qSFZ74?si=uhET4MoBXiiLrg2b&t=29647)

## Table of Contents

- [Introduction](#introduction)
- [Requirements](#requirements)
- [Learnings + Resources](#learnings--resources)

## Introduction

In this project, we will create 2 NFT implementations

1. BasicNFT - A simple NFT implementation to understand working of ERC721
2. MoodNFT - A dynamic NFT implementation where metadata is stored onchain as SVG in base64 format

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
bytes memory aEncoded = abi.encodePacked(a); // dynamic bytes array
bytes32 aHash = keccak256(aEncoded); // bytes32

sting memory b = "abc";
bytes memory bEncoded = abi.encodePacked(b);
bytes32 bHash = keccak256(bEncoded);

if (aHash == bHash) {
    // Do something
}
```

### Storing NFT Metadata

1. Offchain data with a https link
   - Affect metadata availability if a server goes down
   - Affect metadata integrity if a server is compromised
2. Offchain data with IPFS
   - Better metadata availability than 1.
   - Can affect metadata availability if IPFS node that pinned the data goes down
   - Using services such as Pinata can help with making sure the data is always available
3. Onchain data
   - Using SVG to store the metadata which can be stored onChain itself
   - Best but a bit more expensive
   - Can be used to create a dynamic NFT

### Converting SVG to base64

- By any online software
- Using `base64` command line tool
  ```bash
  ## INPUT
  base64 -i happy.svg
  ```
  ```
  ## OUTPUT
  PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgIGhlaWdodD0iNDAwIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgogIDxjaXJjbGUgY3g9IjEwMCIgY3k9IjEwMCIgZmlsbD0ieWVsbG93IiByPSI3OCIgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSIzIi8+CiAgPGcgY2xhc3M9ImV5ZXMiPgogICAgPGNpcmNsZSBjeD0iNjEiIGN5PSI4MiIgcj0iMTIiLz4KICAgIDxjaXJjbGUgY3g9IjEyNyIgY3k9IjgyIiByPSIxMiIvPgogIDwvZz4KICA8cGF0aCBkPSJtMTM2LjgxIDExNi41M2MuNjkgMjYuMTctNjQuMTEgNDItODEuNTItLjczIiBzdHlsZT0iZmlsbDpub25lOyBzdHJva2U6IGJsYWNrOyBzdHJva2Utd2lkdGg6IDM7Ii8+Cjwvc3ZnPg==
  ```
