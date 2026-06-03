// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StackTooDeep {
    /**
     * @dev Intentionally triggers the famous "CompilerError: Stack too deep".
     * The EVM stack can only be accessed up to 16 slots deep (DUP1 to DUP16).
     * Declaring 17 variables and using them all simultaneously will exhaust this limit.
     */
    function causeError() public pure returns (uint256 result) {
        // 1. Declare 17 local variables.
        // The EVM pushes these onto the stack one by one.
        uint256 a = 1;
        uint256 b = 2;
        uint256 c = 3;
        uint256 d = 4;
        uint256 e = 5;
        uint256 f = 6;
        uint256 g = 7;
        uint256 h = 8;
        uint256 i = 9;
        uint256 j = 10;
        uint256 k = 11;
        uint256 l = 12;
        uint256 m = 13;
        uint256 n = 14;
        uint256 o = 15;
        uint256 p = 16;
        uint256 q = 17;

        // 2. Attempt to use all variables at once.
        // As the EVM adds these numbers, it creates "intermediate results" and pushes them to the stack.
        result =
            a +
            b +
            c +
            d +
            e +
            f +
            g +
            h +
            // EXPECTED COMPILER ERROR HERE: "Stack too deep."
            // Why here? The combination of the remaining variables at the bottom of the stack
            // plus the intermediate sum results at the top has pushed the data beyond the 16-slot limit.
            i +
            j +
            k +
            l +
            m +
            n +
            o +
            p +
            q;
    }
}
