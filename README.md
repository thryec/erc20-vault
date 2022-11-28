# ERC20 Vault

https://github.com/yieldprotocol/mentorship2022/issues/2

### Objectives

1. Users can send a pre-specified ERC-20 token to a Vault contract.
2. The contract records the user's balance.
3. Only the owner can retrieve their tokens.
4. 2 contracts required: a ERC20 token to be moved around, and the Vault that will store it for the users.
5. Vault should import the IERC20 interface, take the Token address in the Vault constructor, and cast it into an IERC20 state variable.
6. User can approve the Vault and receive the ERC20 token from them in one transaction.
7. User calls a function that instructs the Vault to take from them an amount of Token
8. User can withdraw their deposit at any time. The Token is returned, and the Vault updates its user records.

### Functions

#### Vault Contract

`constructor()`

- record ERC20 token address in a constant variable

`deposit()`

- calls ERC20.approve() to allow the vault access to the user's tokens
- takes the desired amount of tokens from the user's wallet
- record the number of tokens deposited in a mapping
- emits a Deposit event

`withdraw()`

- checks that the user has a positive token balanace in the vault
- sends the desired number of tokens from the vault to the user
- updates the mapping of user's holdings in storage accordingly
- emits a Withdrawn event

#### ERC20 Contract

- public mint function to allow users to mint from it
- approve function for vault to access users' tokens
