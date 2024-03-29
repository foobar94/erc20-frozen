//! FrozenToken ECR20-compliant token contract
pragma solidity >=0.4.22 <0.7.0;
// Owned contract.
contract Owned {
	modifier only_owner { require (msg.sender == owner); _; }
	address public owner;
}

contract ERC20Interface {
    function totalSupply() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function allowance(address tokenOwner, address spender) public view returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

// All "tokens" belong to the owner at construction.
contract FrozenToken is Owned, ERC20Interface {
	event Transfer(address indexed from, address indexed to, uint256 value);
	// constructor sets the parameters of execution, _totalSupply is all units
	constructor(uint _totalSupply, address _owner)
        	public
		when_non_zero(_totalSupply)
	{
		totalTokenSupply = _totalSupply;
		owner = _owner;
		accounts[_owner] = totalTokenSupply;
	}
	// balance of a specific address
	function balanceOf(address _who) public view returns (uint256) {
		return accounts[_who];
	}
	
	function approve(address spender, uint tokens) public returns (bool success) {
		return false;
	}
	
	function transferFrom(address from, address to, uint tokens) public returns (bool success) {
		return false;
	}
	
	function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
		return 0;
	}
	
	//returns total supply
	function totalSupply() public view returns (uint256) {
        	return totalTokenSupply;
    	}
	
	// transfer
	function transfer(address _to, uint256 _value)
		public
		only_owner
		returns(bool)
	{
		emit Transfer(msg.sender, _to, _value);
		accounts[msg.sender] -= _value;
		accounts[_to] += _value;
		return true;
	}
	function() external {
		assert(false);
	}
	// a value should be > 0
	modifier when_non_zero(uint _value) {
		require (_value > 0);
		_;
	}
	// Available token supply
	uint public totalTokenSupply;
	// Storage and mapping of all balances & allowances
	mapping (address => uint256) accounts;
	// Conventional metadata.
	string public constant name = "AVA Allocation Indicator";
	string public constant symbol = "AVA";
	uint8 public constant decimals = 18;
}
