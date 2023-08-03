// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/* Inheritance tree
   A
 /  \ \
B   C  E
 \ / /
  D
*/

contract A {
    // This is called an event. You can emit events from your function
    // and they are logged into the transaction log.
    // In our case, this will be useful for tracing function calls.
    event Log(string message);

    function foo() public virtual {
        emit Log("A.foo called");
    }

    function bar() public virtual {
        emit Log("A.bar called");
    }
}

contract B is A {
    function foo() public virtual override {
        emit Log("B.foo called");
        A.foo();
    }

    function bar() public virtual override {
        emit Log("B.bar called");
        super.bar();
    }
}

contract C is A {
    function foo() public virtual override {
        emit Log("C.foo called");
        A.foo();
    }

    function bar() public virtual override {
        emit Log("C.bar called");
        super.bar();
    }
}

contract E is A {
    function foo() public virtual override {
        emit Log("E.foo called");
        A.foo();
    }

    function bar() public virtual override {
        emit Log("E.bar called");
        super.bar();
    }
}

contract D is B, C, E {
    // E -> A
    function foo() public override(B, C, E) {
        super.foo();
    }

    // E -> C -> B -> A
    function bar() public override(B, C, E) {
        super.bar();
    }
}
