# Tic Tac Token ( A simple Tic Tac Toe Game )

[Resource Referenced](https://book.tictactoken.co/)
This project is a bit different from the referenced project. I actually have modified it according to hwat I feel is best practice and more optimized.

## Table of Contents

- [Introduction](#introduction)
- [Requirements](#requirements)
- [Learnings + Resources](#learnings--resources)

## Introduction

A Tic Tac Token Game with the following features :-

1. Add multiple game instances btw 2 players
2. Owner can reset a game incase it is tied
3. Winner of a game gets an NFT and erc20 Tokens based on no. of moves taken to win.

## Requirements

- `Git`
- `Foundry`
- `jq` ( Requirement for [Foundry DevOps](https://github.com/Cyfrin/foundry-devops) )
- `make` ( Optional )

## Learnings + Resources

#### String Comparison in Solidity

- In solidity we can't compare string directly using assignment operators, it needs to be encoded first.

```
function compareStrings(string memory a, string memory b) public view returns (bool) {
    return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
}
```

#### ERC20 And ERC721 Tokens

- Unserstanding Fungiable & Non-Funcgiable Tokens
- Difference Btw mint and safeMint - safeMint checks that the address to whom the tokens are being tranfered is able to receive and use it, otherwise it will be locked and forever lost.
- [SafeMint can also create security issues](https://samczsun.com/the-dangers-of-surprising-code/)
