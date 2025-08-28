.globl entrypoint
entrypoint: // CPI IXN: | &program_id | &account_metas | account_metas.len() | ixn_data.len() | &ixn_data |
    lddw r1, 0x8d44054140a81fe4 // Memo Program ID 1st double word
    stxdw [r10-8], r1
    lddw r1, 0x81bb92bcddb5357c // Memo Program ID 2nd double word
    stxdw [r10-16], r1
    lddw r1, 0x7c38da6071e8244d // Memo Program ID 3rd double word
    stxdw [r10-24], r1
    lddw r1, 0x62129995a534a05 // Memo Program ID 4th double word
    stxdw [r10-32], r1
    lddw r1, 4 // Memo instruction data length
    stxdw [r10-40], r1
    mov64 r9, r10
    sub64 r9, 80 // Pointer to start of instruction data
    stxdw [r10-48], r9 // We skipped over accountmetas and len since memory is zeroed
    add64 r9, 48 // Pointer to start of program ID
    stxdw [r10-72], r9
    lddw r1, 0x46504253 // b"SBPF" double word
    stxdw [r10-80], r1
    mov64 r1, r10
    sub64 r1, 72 // Pointer to Instruction
    call sol_invoke_signed_c // Invoke CPI
    exit 
