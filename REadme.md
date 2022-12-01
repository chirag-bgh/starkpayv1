# StarkPay

## ⚠️ WARNING! ⚠️

This code is entirely experimental, changing frequently and un-audited. Please do not use it in production!

Stream seamless recurring crypto payments! Automate salaries by streaming them - so employees can withdraw whenever they want.

The `StarkPay.cairo` contract has 2 external functions that called by any address on the chain.

1. `createStream(_payer, _payee, _token, _amountPerBlock, _balance)` -> `_id`
2. `withdraw(_id, _payee)`