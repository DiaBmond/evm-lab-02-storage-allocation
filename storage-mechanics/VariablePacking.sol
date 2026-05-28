// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VariablePacking {
    // These 3 variables will be packed into Slot 0 (Right-aligned)
    uint8 public a = 17; // Hex: 0x11
    uint8 public b = 34; // Hex: 0x22
    uint8 public c = 51; // Hex: 0x33

    // This variable exceeds the remaining space in Slot 0, moving to Slot 1
    uint256 public d = 100; // Hex: 0x64

    /**
     * @dev Reads the entire 32-byte data from a specific slot.
     * @param slotNumber The slot index to read.
     */
    function readSlot(uint256 slotNumber) public view returns (bytes32 result) {
        assembly {
            result := sload(slotNumber)
        }
    }

    /**
     * @dev Extracts a specific 1-byte variable from the packed slot using shift and mask.
     * @param shiftBits The number of bits to shift right (e.g., 8 bits for variable 'b').
     */
    function bitwiseManipulation(
        uint256 shiftBits
    ) public view returns (uint8 result) {
        assembly {
            // 1. Load the entire Slot 0
            let rawData := sload(0)

            // 2. Shift right by 'shiftBits'
            let shifted := shr(shiftBits, rawData)

            // 3. Mask with 0xFF to isolate the rightmost byte
            result := and(shifted, 0xFF)
        }
    }
}
