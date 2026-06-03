# EVM Lab 02: Storage, Memory, and Stack Mechanics

Welcome to my deep dive into the Ethereum Virtual Machine (EVM) architecture. This repository serves as a personal sandbox and portfolio demonstrating my understanding of how the EVM manages data across its three primary locations: Storage, Memory, and Stack.

By utilizing inline assembly (Yul), this project bypasses high-level Solidity abstractions to observe raw EVM behavior, calculate storage slots, trigger quadratic memory expansion, and deliberately hit hardware limitations like the infamous "Stack Too Deep" error.

## Repository Structure

This project is divided into three main areas of exploration:

### 1. `1-storage-mechanics/`

Explores the EVM's persistent storage, a massive key-value store where data is highly expensive to read and write.

* **`01_BasicSlots.sol`**: Demonstrates the fundamental rule of EVM storage, where state variables are assigned sequentially to 32-byte slots (Slot 0, Slot 1, etc.).
* **`02_VariablePacking.sol`**: Shows how multiple smaller data types (e.g., `uint8`, `uint128`) are packed into a single 32-byte slot by the compiler to optimize gas, and how to extract them using bitwise operations (`shr`, `and`) in assembly.
* **`03_MappingLayout.sol`**: Bypasses Solidity to manually retrieve mapping values.
* *Concept:* The slot where a mapping is declared remains empty (used only as a seed). The actual value is stored at the keccak256 hash of the key concatenated with the base slot.


* **`04_DynamicArrayLayout.sol`**: Demonstrates the structural difference between mappings and arrays in storage.
* *Developer Note:* Unlike mappings, the base slot of a dynamic array is NOT empty. It explicitly stores the total `length` of the array. The actual array elements begin at the keccak256 hash of the base slot, with subsequent elements found by adding the index to this starting hash.



### 2. `2-memory-mechanics/`

Explores the EVM's temporary RAM, a linear byte array that expands on demand and is cleared after execution.

* **`01_FreeMemoryPointer.sol`**: Investigates the EVM reserved memory space and the Free Memory Pointer (`0x40`).
* *Developer Note (Linear Byte Array vs. Slots):* Memory is not divided into rigid 32-byte lockers like Storage. It is a continuous byte array. However, because the EVM is a 256-bit machine, it reads/writes in 32-byte "words". This is why the pointer at `0x40` occupies the space up to `0x5F` (32 bytes) just to hold a single memory offset value (which defaults to `0x80` or 128).


* **`02_MemoryExpansion.sol`**: Measures the aggressive gas costs associated with expanding memory.
* *Developer Note (msize anomaly):* Initializing EVM memory defaults the pointer to `128`, but calling `msize()` initially returns `96`. This happens because `msize()` measures the highest byte actually accessed. The EVM skips writing to the "Zero Slot" (bytes 96-127), so the highest accessed byte remains 95 (size: 96).
* *Developer Note (Memory Corruption):* During testing, manually storing data at offset `50` caused an `Out of Gas` error, while offset `65` caused a `BUFFER_OVERRUN`. This was a breakthrough in understanding memory corruption: writing over bytes 64-95 explicitly overwrites the Free Memory Pointer at `0x40`. Doing so destroys Solidity's ability to safely allocate memory for return variables, causing catastrophic execution failure.



### 3. `3-stack-mechanics/`

Explores the EVM Stack, a highly restricted LIFO (Last-In, First-Out) data structure used for immediate computations.

* **`01_StackTooDeep.sol`**: Intentionally triggers the `CompilerError: Stack too deep`.
* *Developer Note (Intermediate Results):* The EVM stack can hold up to 1024 items, but opcodes (like `DUP` and `SWAP`) can only reach the top 16 slots. When declaring 17 variables and adding them together, the compiler error does not trigger at the 17th variable, but rather around the 9th. This is because arithmetic operations generate "intermediate results" that are pushed back onto the stack, exhausting the 16-slot limit much faster than the raw variable count implies.


* **`02_BypassingStack.sol`**: Implements and benchmarks two distinct solutions for bypassing the 16-variable limit.
* *Developer Note (The 8-8-1 Scope Balance):* To fix the stack error using Block Scoping `{ }`, variables must be carefully batched. Simply splitting them into batches of 9 and 8 still fails due to intermediate calculation overhead. The perfect balance discovered was an `8-8-1` split, leaving enough empty stack slots for the EVM to perform arithmetic without overflowing.
* *Developer Note (Gas Profiling):* By implementing `gasleft()` checkpoints, this contract mathematically proves that utilizing Block Scoping (pure stack manipulation) is over 2x cheaper than allocating a Memory Array to bypass the error. Memory incurs heavy overhead due to allocation, zeroing out bytes, and quadratic expansion costs.



## How to Run the Experiments

It is highly recommended to test these contracts using [Remix IDE](https://remix.ethereum.org/).

1. Paste the contracts into the editor.
2. Compile and Deploy using the Remix VM environment.
3. Call the read functions and observe the decoded outputs and `gasUsed` metrics.
4. For `02_MemoryExpansion.sol`, try passing extreme values like `500000` to the `_offset` parameter to witness the quadratic gas cost in real-time.

## References & Documentation

* [EVM Opcodes Reference (evm.codes)](https://www.evm.codes/) - Crucial for understanding memory expansion and stack limitations (DUP1-DUP16).
* [Solidity Documentation: Layout of State Variables in Storage](https://docs.soliditylang.org/en/latest/internals/layout_in_storage.html)
* [Solidity Documentation: Layout in Memory](https://docs.soliditylang.org/en/latest/internals/layout_in_memory.html)
* [Ethereum Yellow Paper](https://ethereum.github.io/yellowpaper/paper.pdf) - Mathematical definitions of EVM memory and stack environments.