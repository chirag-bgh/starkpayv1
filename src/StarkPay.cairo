%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import  (
    Uint256, 
    uint256_eq, 
    uint256_le, 
    uint256_lt, 
    uint256_sub,
    uint256_mul
)
from starkware.starknet.common.syscalls import (
    get_caller_address,
    get_contract_address,
    get_block_timestamp,
    get_block_number
)
from starkware.cairo.common.bool import TRUE, FALSE

@contract_interface
namespace IERC20 {
    func name() -> (name: felt) {
    }

    func symbol() -> (symbol: felt) {
    }

    func decimals() -> (decimals: felt) {
    }

    func totalSupply() -> (totalSupply: Uint256) {
    }

    func balanceOf(account: felt) -> (balance: Uint256) {
    }

    func allowance(owner: felt, spender: felt) -> (remaining: Uint256) {
    }

    func transfer(recipient: felt, amount: Uint256) -> (success: felt) {
    }

    func transferFrom(sender: felt, recipient: felt, amount: Uint256) -> (success: felt) {
    }

    func approve(spender: felt, amount: Uint256) -> (success: felt) {
    }
}

@constructor
func constructor{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr
}() {
    next_stream_id_storage.write(1);
    return ();
}

struct Stream {
    payer: felt,
    payee: felt,
    token: felt,
    amountPerBlock: Uint256,
    startBlock: felt,
    balance: Uint256,
}

@storage_var
func next_stream_id_storage() -> (next_stream_id: felt) {

}

@storage_var
func id_to_stream(id: felt) -> (s: Stream) {

}

@external
func createStream {
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr
} ( _payer: felt,
    _payee: felt,
    _token: felt, 
    _amountPerBlock: Uint256,
    _balance: Uint256 ) -> (id: felt) {
        let (id) = next_stream_id_storage.read();
        let (self_address) = get_contract_address();
        let (block_number) = get_block_number();

        let stream = Stream(
            payer = _payer,
            payee = _payee,
            token = _token,
            amountPerBlock = _amountPerBlock,
            startBlock = block_number,
            balance = _balance,
        );

        // transfer erc20 token

        IERC20.transferFrom(_token, _payer, self_address, _balance);

        id_to_stream.write(id, stream);

        let next_id = id + 1;
        next_stream_id_storage.write(next_id);

        return (id=id);
}

@external
func withdraw{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr
} (
    _id: felt,
    _payee: felt) 
    -> (success: felt) {
        let (stream) = id_to_stream.read(_id);

        let (block_number) = get_block_number();

        let payee = stream.payee;
        let balance_last = stream.balance;
        let startBlock_last = stream.startBlock;
        


        let zero: Uint256 = Uint256(0, 0);

        let (positive) = uint256_lt(zero, balance_last);
        assert positive = 1;
        let block_delta: Uint256 = Uint256((block_number - startBlock_last), 0);
        let amount: Uint256 = uint256_mul(block_delta, stream.amountPerBlock);
        let balance_now: Uint256 = uint256_sub(balance_last, amount);
        IERC20.transfer(stream.token, _payee, amount);
        let stream = Stream(
            payer = stream.payer,
            payee = stream.payee,
            token = stream.token,
            amountPerBlock = stream.amountPerBlock,
            startBlock = block_number,
            balance = balance_now,
        );
        id_to_stream.write(_id, stream);
        return (TRUE,);
}