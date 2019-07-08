//! FrozenToken ECR20-compliant token contract


pragma solidity ^0.4.17;

// Owned contract.
contract Owned {
	modifier only_owner { require (msg.sender == owner); _; }

	address public owner;
}

// FrozenToken, a bit like an ECR20 token (though not - as it doesn't
// implement most of the API).
// All token balances are generally non-transferable.
// All "tokens" belong to the owner (who is uniquely liquid) at construction.
contract FrozenToken is Owned {
	event Transfer(address indexed from, address indexed to, uint256 value);

	// constructor sets the parameters of execution, _totalSupply is all units
	function FrozenToken(uint _totalSupply, address _owner)
        public
		when_non_zero(_totalSupply)
	{
		totalSupply = _totalSupply;
		owner = _owner;
		accounts[_owner] = totalSupply;
	}

	// balance of a specific address
	function balanceOf(address _who) public constant returns (uint256) {
		return accounts[_who];
	}

	// transfer
	function transfer(address _to, uint256 _value)
		public
		only_owner
		returns(bool)
	{
		Transfer(msg.sender, _to, _value);
		accounts[msg.sender] -= _value;
		accounts[_to] += _value;

		return true;
	}

	// no default function, simple contract only, entry-level users
	function() public {
		assert(false);
	}

	// a value should be > 0
	modifier when_non_zero(uint _value) {
		require (_value > 0);
		_;
	}

	// Available token supply
	uint public totalSupply;

	// Storage and mapping of all balances & allowances
	mapping (address => uint256) accounts;

	// Conventional metadata.
	string public constant name = "AVA Allocation Indicator";
	string public constant symbol = "AVA";
	uint8 public constant decimals = 3;
}
