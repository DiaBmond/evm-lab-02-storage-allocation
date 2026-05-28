// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BasicSlots {
    // Set easy-to-remember values for verification during data retrieval.
    // The EVM will allocate this variable to Slot 0.
    uint256 public slot0 = 100; // Hex value is 0x64

    // The EVM will allocate this variable to Slot 1.
    uint256 public slot1 = 200; // Hex value is 0xC8

    /**
     * @dev Retrieves 32 bytes of raw data from the specified storage slot.
     * @param slotNumber The index of the storage slot to read (e.g., 0 or 1).
     */
    function readSlot(uint256 slotNumber) public view returns (bytes32 result) {
        assembly {
            // sload(p) loads 32 bytes of data from storage slot 'p'
            // and assigns it to the 'result' variable to be returned.
            result := sload(slotNumber)
        }
    }
}
