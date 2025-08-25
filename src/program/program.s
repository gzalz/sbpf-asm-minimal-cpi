.globl entrypoint
entrypoint:
    # CPI Instruction | 32-byte program id | 8 byte data len | u8* data | 8 byte accounts len | AccountMeta* accounts
    
    # Memo program id split into 4 double-words
    lddw r1, 0x8d44054140a81fe4
    stxdw [r10-8], r1
    lddw r1, 0x81bb92bcddb5357c
    stxdw [r10-16], r1
    lddw r1, 0x7c38da6071e8244d
    stxdw [r10-24], r1
    lddw r1, 0x62129995a534a05
    stxdw [r10-32], r1

    # [r10-40] = data_len = 1
    lddw r1, 4
    stxdw [r10-40], r1

    # r9 = &instruction.data
    mov64 r9, r10
    sub64 r9, 80

    # data ptr = [r10 - 80]
    stxdw [r10-48], r9

    # r1 = null
    lddw r1, 0
    # accounts ptr (null)
    stxdw [r10-56], r1
    # acc ptr point is null
    stxdw [r10-64], r1

    # Log "CPI Program Pubkey:"
    lddw r1, log_cpi_program_pubkey
    lddw r2, 18
    call sol_log_
    # [r10-72] = &program_id (memo program id)
    mov64 r1, r10
    sub64 r1, 32
    stxdw [r10-72], r1
    # Log program id, r1 is what we need it to be
    call sol_log_pubkey

    # [r10-80] = instruction_data = b"SBPF"
    lddw r1, 0x46504253
    stxdw [r10-80], r1

    # Set arguments
    # r1 = &instruction
    mov64 r1, r10
    add64 r1, -72

    mov64 r2, 0         # account infos
    mov64 r3, 0         # account infos len
    mov64 r4, 0         # signers
    mov64 r5, 0         # signers len

    call sol_invoke_signed_c

    mov64 r0, 0
    exit

.rodata
  log_cpi_program_pubkey:
    .asciz "CPI Program Pubkey:"
