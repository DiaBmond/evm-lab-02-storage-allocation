// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BypassingStack {
    /**
     * @dev Solution 1: Bypassing "Stack too deep" using Block Scoping.
     * By wrapping variables in {}, they are automatically popped from the stack
     * once the execution leaves the block, freeing up stack slots for new variables.
     */
    function bypassWithScope() public pure returns (uint256 result) {
        uint256 sum1;
        uint256 sum2;

        // Block 1: Handle the first half of the variables
        {
            uint256 a = 1;
            uint256 b = 2;
            uint256 c = 3;
            uint256 d = 4;
            uint256 e = 5;
            uint256 f = 6;
            uint256 g = 7;
            uint256 h = 8;
            uint256 i = 9;

            sum1 = a + b + c + d + e + f + g + h + i;
        } // a through i are destroyed and popped from the stack here!

        // Block 2: Handle the second half of the variables
        {
            uint256 j = 10;
            uint256 k = 11;
            uint256 l = 12;
            uint256 m = 13;
            uint256 n = 14;
            uint256 o = 15;
            uint256 p = 16;
            uint256 q = 17;

            sum2 = j + k + l + m + n + o + p + q;
        } // j through q are destroyed and popped from the stack here!

        // Combine the results safely without exceeding the 16-slot limit
        result = sum1 + sum2;
    }

    /**
     * @dev Solution 2: Bypassing "Stack too deep" using Memory.
     * Instead of pushing 17 individual variables onto the stack, we allocate an array in memory.
     * The stack only needs to hold 1 slot (the memory pointer), preventing overflow.
     */
    function bypassWithMemory() public pure returns (uint256 result) {
        // This array takes up lots of memory, but ONLY 1 stack slot (the pointer).
        uint256[] memory nums = new uint256[](17);

        nums[0] = 1;
        nums[1] = 2;
        nums[2] = 3;
        nums[3] = 4;
        nums[4] = 5;
        nums[5] = 6;
        nums[6] = 7;
        nums[7] = 8;
        nums[8] = 9;
        nums[9] = 10;
        nums[10] = 11;
        nums[11] = 12;
        nums[12] = 13;
        nums[13] = 14;
        nums[14] = 15;
        nums[15] = 16;
        nums[16] = 17;

        // Loop through the memory array to calculate the sum
        for (uint256 i = 0; i < 17; i++) {
            result += nums[i];
        }
    }
}
