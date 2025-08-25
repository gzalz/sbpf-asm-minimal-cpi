.globl entrypoint
entrypoint:
    # Memo program id split into 4 double-words
    lddw r6, 0x8d44054140a81fe4
    stxdw [r10-8], r6
    lddw r6, 0x81bb92bcddb5357c
    stxdw [r10-16], r6
    lddw r6, 0x7c38da6071e8244d
    stxdw [r10-24], r6
    lddw r6, 0x62129995a534a05
    stxdw [r10-32], r6

    # "SBPF" in little-endian double-word
    lddw r6, 0x46504253
    stxdw [r10-80], r6
   
    mov64 r9, r10
    sub64 r9, 80

    # program_id ptr
    mov64 r6, r10
    add64 r6, -32
    stxdw [r10-72], r6

    # To check program_id
    #mov64 r1, r6
    #call sol_log_pubkey

    # data ptr points to [r10-80]
    lddw r7, 0
    stxdw [r10-64], r9

    # data_len = 1
    lddw r8, 4
    stxdw [r10-40], r8

    # accounts ptr (null)
    lddw r7, 0
    stxdw [r10-56], r7

    # accounts_len = 0
    lddw r7, 0
    stxdw [r10-48], r9

    # Set arguments
    # r1 = &instruction
    mov64 r1, r10
    add64 r1, -72

    mov64 r2, 0         # account infos
    mov64 r3, 0         # account infos len
    mov64 r4, 0         # signers
    mov64 r5, 0         # signers len

    # --- CPI ---
    call sol_invoke_signed_c   # sol_invoke_signed syscall

    # --- Return success ---
    mov64 r0, 0
    exit

.rodata
