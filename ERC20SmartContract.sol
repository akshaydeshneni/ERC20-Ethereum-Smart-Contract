// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

/**
 * @title Project2
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */

interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address _owner) external view returns (uint256 balance);
    function transfer(address _to, uint256 _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
    function approve(address _spender, uint256 _value) external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}


contract Project2 is IERC20 {

    mapping(address => uint256) private _balances;

    mapping(address => mapping (address => uint256)) private _allowed;

    uint256 private _totalSupply = 10 ether;


    constructor() {
        _balances[msg.sender] = _totalSupply;
    }

    function name() public pure returns (string memory) {
        string memory n = "EC6353DB";
        return n;
    }

    function symbol() public pure returns (string memory) {
        string memory s = "6BB39113";
        return s;
    }

    function decimals() public pure returns (uint8) {
        uint8 d = 0;
        return d;
    }

    function totalSupply() public view override returns (uint256) {
    return _totalSupply;
    }

    function balanceOf(address owner) public view override returns (uint256) {
        return _balances[owner];
    }

    function transfer(address receiver, uint256 numTokens) public override returns (bool) {
        require(numTokens <= _balances[msg.sender]);
        _balances[msg.sender] = _balances[msg.sender]-numTokens;
        _balances[receiver] = _balances[receiver]+numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens) public override returns (bool) {
        _allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public override view returns (uint) {
        return _allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
        require(numTokens <= _balances[owner]);
        require(numTokens <= _allowed[owner][msg.sender]);

        _balances[owner] = _balances[owner]-numTokens;
        _allowed[owner][msg.sender] = _allowed[owner][msg.sender]-numTokens;
        _balances[buyer] = _balances[buyer]+numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}
