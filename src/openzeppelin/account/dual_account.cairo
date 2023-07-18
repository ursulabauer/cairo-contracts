use array::ArrayTrait;
use array::SpanTrait;
use starknet::ContractAddress;
use starknet::SyscallResultTrait;

use openzeppelin::utils::selectors;
use openzeppelin::utils::serde::SerializedAppend;
use openzeppelin::utils::try_selector_with_fallback;
use openzeppelin::utils::UnwrapAndCast;

#[derive(Copy, Drop)]
struct DualCaseAccount {
    contract_address: ContractAddress
}

trait DualCaseAccountTrait {
    fn set_public_key(self: @DualCaseAccount, new_public_key: felt252);
    fn get_public_key(self: @DualCaseAccount) -> felt252;
    fn is_valid_signature(
        self: @DualCaseAccount, hash: felt252, signature: Array<felt252>
    ) -> felt252;
    fn supports_interface(self: @DualCaseAccount, interface_id: felt252) -> bool;
}

impl DualCaseAccountImpl of DualCaseAccountTrait {
    fn set_public_key(self: @DualCaseAccount, new_public_key: felt252) {
        let mut args = ArrayTrait::new();
        args.append_serde(new_public_key);

        try_selector_with_fallback(
            *self.contract_address, selectors::set_public_key, selectors::setPublicKey, args.span()
        )
            .unwrap_syscall();
    }

    fn get_public_key(self: @DualCaseAccount) -> felt252 {
        let mut args = ArrayTrait::new();

        try_selector_with_fallback(
            *self.contract_address, selectors::get_public_key, selectors::getPublicKey, args.span()
        )
            .unwrap_and_cast()
    }

    fn is_valid_signature(
        self: @DualCaseAccount, hash: felt252, signature: Array<felt252>
    ) -> felt252 {
        let mut args = ArrayTrait::new();
        args.append_serde(hash);
        args.append_serde(signature);

        try_selector_with_fallback(
            *self.contract_address,
            selectors::is_valid_signature,
            selectors::isValidSignature,
            args.span()
        )
            .unwrap_and_cast()
    }

    fn supports_interface(self: @DualCaseAccount, interface_id: felt252) -> bool {
        let mut args = ArrayTrait::new();
        args.append_serde(interface_id);

        try_selector_with_fallback(
            *self.contract_address,
            selectors::supports_interface,
            selectors::supportsInterface,
            args.span()
        )
            .unwrap_and_cast()
    }
}