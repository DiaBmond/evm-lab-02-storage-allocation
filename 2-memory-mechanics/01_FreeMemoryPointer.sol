// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FreeMemoryPointer {
    /**
     * @dev Retrieves the initial value of the Free Memory Pointer (0x40).
     */
    function getInitialPointer() public pure returns (uint256 result) {
        assembly {
            // Expected result: 128 (0x80), the default starting offset for EVM free memory.
            result := mload(0x40)
        }
    }

    /**
     * @dev Simulates memory allocation and observes how the Free Memory Pointer expands.
     */
    function allocateArrayAndGetPointer() public pure returns (uint256 result) {
        // 1. Allocate an array of 5 elements in memory.
        uint256[] memory arr = new uint256[](5);

        // 2. Dummy assignment to suppress compiler warnings for unused variables.
        arr[0] = 999;

        assembly {
            // 3. Load the updated 32-byte pointer value from offset 0x40.
            result := mload(0x40)
        }
    }
}
