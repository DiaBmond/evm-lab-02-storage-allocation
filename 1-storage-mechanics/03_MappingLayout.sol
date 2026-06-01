// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MappingLayout {
    // The base slot for this mapping is Slot 0.
    // Note: Slot 0 itself remains empty. It is only used as a seed for hashing.
    mapping(uint256 => uint256) public balances;

    /**
     * @dev Standard Solidity function to set a value in the mapping.
     */
    function setBalances(uint256 _key, uint256 _value) public {
        balances[_key] = _value;
    }

    /**
     * @dev Calculates the exact storage slot of a mapping element.
     * EVM Formula: keccak256(abi.encode(key, mapping_slot))
     * @param _key The dictionary key you want to look up.
     * @param _mappingSlot The slot where the mapping is declared (0 in this case).
     */
    function getMappingSlot(
        uint256 _key,
        uint256 _mappingSlot
    ) public pure returns (bytes32 result) {
        assembly {
            // 1. Store the 32-byte key at memory offset 0x00
            mstore(0x00, _key)

            // 2. Store the 32-byte mapping slot at memory offset 0x20 (concatenation)
            mstore(0x20, _mappingSlot)

            // 3. Hash the entire 64 bytes (0x40) of memory to find the coordinate
            result := keccak256(0x00, 0x40)
        }
    }

    /**
     * @dev Bypasses Solidity and retrieves the value directly from the calculated storage slot.
     * @param _key The dictionary key you want to read.
     */
    function getMappingValue(
        uint256 _key
    ) public view returns (uint256 result) {
        // Calculate the hash coordinate first
        bytes32 hash = getMappingSlot(_key, 0);

        assembly {
            // Load the 32-byte value directly from the hidden storage slot
            result := sload(hash)
        }
    }
}
