#[cfg(test)]
mod tests {
    use mollusk_svm::program;
    use mollusk_svm::{result::Check, Mollusk};
    use solana_sdk::account::Account;
    use solana_sdk::instruction::AccountMeta;
    use solana_sdk::instruction::Instruction;
    use solana_sdk::pubkey::Pubkey;
    use std::str::FromStr;

    // This needs to fail for the right reasons
    #[test]
    fn test_increment_init() {
        let program_id_keypair_bytes = std::fs::read("deploy/program-keypair.json").unwrap()[..32]
            .try_into()
            .expect("slice with incorrect length");
        let program_id = Pubkey::new_from_array(program_id_keypair_bytes);
        let signer_pubkey = Pubkey::new_from_array([3; 32]);

        let (system_program, _) = mollusk_svm::program::keyed_account_for_system_program();
        let memo_program_id =
            Pubkey::from_str("MemoSq4gqABAXKb96qnH8TysNcWxMyWCqXgDLGmfcHr").unwrap();

        let instruction = Instruction::new_with_bytes(
            program_id,
            &[10, 0, 0, 0, 0, 0, 0, 0],
            vec![
                AccountMeta::new(signer_pubkey, true),
                AccountMeta::new_readonly(memo_program_id, false),
            ],
        );

        let mut mollusk = Mollusk::new(&program_id, "deploy/program");

        mollusk.add_program(
            &memo_program_id,
            "sbpf/memo",
            &mollusk_svm::program::loader_keys::LOADER_V3,
        );

        let memo_account = program::create_program_account_loader_v3(&memo_program_id);

        let mut signer_account = Account::new(6, 12, &system_program);
        signer_account.data = vec![4; 8];
        let accounts = vec![
            (signer_pubkey, signer_account),
            (memo_program_id, memo_account),
        ];

        let _ =
            mollusk.process_and_validate_instruction(&instruction, &accounts, &[Check::success()]);
    }
}
