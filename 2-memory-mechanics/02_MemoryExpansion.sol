// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MemoryExpansion {
    /**
     * @dev Retrieves the current total size of allocated memory.
     * Initial size is always 128 bytes (0x80) for EVM reserved space.
     */
    function getCurrentSize() public pure returns (uint256 result) {
        assembly {
            result := msize()
        }
    }

    /**
     * @dev Forces memory expansion by storing a value at a distant offset,
     * and calculates the exact gas penalty incurred by this expansion.
     * @param _offset The distant memory location to write to.
     * @param _val The value to write.
     */
    function forceExpandAndMeasureGas(
        uint256 _offset,
        uint256 _val
    )
        public
        view
        returns (uint256 sizeBefore, uint256 sizeAfter, uint256 gasUsed)
    {
        assembly {
            // 1. Snapshot the initial gas available
            let startGas := gas()

            // 2. Measure memory size BEFORE expansion
            sizeBefore := msize()

            // 3. FORCE EXPANSION: Store value at the distant offset
            // (EVM will aggressively expand the memory to reach this offset)
            mstore(_offset, _val)

            // 4. Measure memory size AFTER expansion
            sizeAfter := msize()

            // 5. Snapshot the remaining gas and calculate the difference
            let endGas := gas()

            // Gas Used = startGas - endGas
            gasUsed := sub(startGas, endGas)
        }
    }
}
