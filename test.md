Account #9
Address: 0x32086ff5e0fe7c1841665e6122fedfbb0b2eb860b74deda82d488a88162a21a
Public key: 0xaa1a3b37e81bb9222816b8cf4d6b949e22b503922effa77c01f85b6491e649
Private key: 0xfc6b2b4453560fc7a02918e68c7c4adf



protostar -p devnet deploy ./build/StarkInu.json --inputs 6013538546500595317 6013538546500595317 18 1000000000000000000000 0 1414409370525475998969266615127130454452006551554748816457262779365616427546


protostar -p devnet invoke --contract-address 0x037a79dc75d9cb8b35b989dcf97bfd47befa2d8801983af508c6d26407c62d5a --function "transfer" --account-address 0x32086ff5e0fe7c1841665e6122fedfbb0b2eb860b74deda82d488a88162a21a --max-fee auto --inputs 0x00DF51989eF24C01edD95818aD10E3FCb46cBaF7dc5408D7C67D17C58b0b815f 1000000000000000000 --private-key-path ./.pkey