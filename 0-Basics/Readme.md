# Basics

Welcome to the Solidity Basics directory!

This directory covers the basic concepts of Solidity.
All the contracts implemented in this directory are some concepts which I found essential to practice or to experiment with.
All the contracts are implemented using `remix`.

## Learnings + References
1. [Basic Blockchain Terminologies](https://connect.comptia.org/content/articles/blockchain-terminology)
2. https://solidity-by-example.org/ - The Basics Section
3. Assigning Min and Max Values to int and uint

   ```solidity
   // int
   int public minInt = type(int).min; // -2^255
   int public maxInt = type(int).max; // 2^255 -1

   // uint
   uint public minUint = type(uint).min; // 0
   uint public maxUint = type(uint).max; // 2^256-1
   ```

4. Constant becomes part of the bytecode at compile time whereas immutable variables become part of bytecode at deployment.
   - For a constant variable, the expression assigned to it is copied to all the places where it is accessed and also re-evaluated each time. This allows for local optimizations.
   - Immutable variables are evaluated once at construction time and their value is copied to all the places in the code where they are accessed. For these values, 32 bytes are reserved. Due to this, constant values can sometimes be cheaper than immutable values.
5. `delete` keyword resets the value to default ( used in mappings and array )

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

6. Only fixed size array can be declared in memory ( ie inside functions ) and also mapping can’t be declared in memory.
7. Bytes in Solidity
   [Solidity Tutorial : all about Bytes](https://jeancvllr.medium.com/solidity-tutorial-all-about-bytes-9d88fdb22676)
8. Enums in solidity r a bit diff than TS - u can’t assign them anything

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

9. Require Vs Assert [https://dev.to/tawseef/require-vs-assert-in-solidity-5e9d#:~:text=assert(bool condition) causes a,in inputs or external components](<https://dev.to/tawseef/require-vs-assert-in-solidity-5e9d#:~:text=assert(bool%20condition)%20causes%20a,in%20inputs%20or%20external%20components>).
10. External visibility type is not available for state variables.
11. Modifiers - [Solidity Tutorial : all about Modifiers](https://medium.com/coinmonks/solidity-tutorial-all-about-modifiers-a86cf81c14cb)
12. Events - [Learn Solidity lesson 27. Events.](https://medium.com/coinmonks/learn-solidity-lesson-27-events-f47070b55851)
    - What r indexed values & their usage ?
    - Max indexed values in event - 3
    - What r anonymous events ?
    - Max indexed values in anon events - 4
13. Where r event logs stored - [Where do contract event logs get stored in the Ethereum architecture?](https://ethereum.stackexchange.com/questions/1302/where-do-contract-event-logs-get-stored-in-the-ethereum-architecture)
14. Fallback and Receive & Related Security - [Understanding Security of Fallback & Recieve Function in Solidity](https://blog.solidityscan.com/understanding-security-of-fallback-recieve-function-in-solidity-9d18c8cad337)
15. Usecase for Unchecked - [Solidity tips and tricks #1: Unchecked arithmetic trick](https://medium.com/@ashwin.yar/solidity-tips-and-tricks-1-unchecked-arithmetic-trick-cefa18792f0b)
16. Pure and view functions do not cost when called externally. But they do cost when called internally.
17. By default storage variables are internal.
18. Assignment btw diff data locations types.

    - Assignments between storage and memory (or from calldata) always create an independent copy.
    - Assignments from memory to memory only create references. As a result changes to one memory variable are also visible in all other memory variables that refer to the same data.

        <img src="https://github.com/Aman035/solidity-learnings/assets/54989169/690f48f9-bd93-4ee8-ab77-7d8a08577410" alt="alt text" height="400">

    - Assignments from storage to a localstorage variable also only assign a reference.
    - All other assignments to storage always creates independent copies.
