// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DynamicArrayLayout {
    // The base slot for this dynamic array is Slot 0.
    // Note: Unlike mappings, Slot 0 is NOT empty. It stores the total length of the array.
    uint256[] public numbers;

    /**
     * @dev Standard Solidity function to append a value to the array.
     * @param _val The value to be added.
     */
    function pushNumber(uint256 _val) public {
        numbers.push(_val);
    }

    /**
     * @dev Bypasses Solidity and retrieves the array length directly from its base slot.
     */
    function getArrayLength() public view returns (uint256 result) {
        assembly {
            // Load the 32-byte value from Slot 0, which holds the current length of the array
            result := sload(0)
        }
    }

    /**
     * @dev Calculates the exact storage slot of an array element and retrieves it.
     * EVM Formula for Arrays: keccak256(array_slot) + index
     * @param _index The array index you want to look up.
     */
    function getArrayElement(
        uint256 _index
    ) public view returns (uint256 result) {
        assembly {
            // 1. Store the 32-byte base slot (0 in this case) at memory offset 0x00
            mstore(0x00, 0)

            // 2. Hash only the first 32 bytes (0x20) to find the starting slot of the array data (Index 0)
            let startSlot := keccak256(0x00, 0x20)

            // 3. Add the target index to the starting slot to find the exact storage coordinate
            let targetSlot := add(startSlot, _index)

            // 4. Load the value directly from the calculated target slot
            result := sload(targetSlot)
        }
    }
}
