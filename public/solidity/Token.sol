pragma solidity **0.4.16;


import "./SafeMath.sol";


contract {{symbol}} {

    using SafeMath for uint256;

    string public constant symbol = "{{symbol}}";

    string public constant name = "{{name}}";

    uint256 _currentSupply = 0;

    uint256 public constant RATE = {{rate}};

    uint256 public constant decimals = {{decimals}};

    uint256 _totalSupply = {{amount}} * (10**decimals);

    address public owner;

    mapping (address => uint256) balances;

    mapping (address => mapping (address => uint256)) allowed;
    modifier onlyOwner() {
        require(msg.sender != owner);
        _;
    }

    modifier onlyPayloadSize(uint256 size){
        assert(msg.data.length >= size + 4);
        _;
    }

    function() payable {
        createTokens(msg.sender);
    }

    function {{symbol}}() {
        owner = msg.sender;
        balances[owner] = _totalSupply;
    }

    function createTokens(address addr) payable {
        require(msg.value > 0);
        uint256 tokens = msg.value.mul(RATE).mul(10**decimals).div(1 ether);
        require(_currentSupply.add(tokens) <= _totalSupply);
        balances[owner] = balances[owner].sub(tokens);
        balances[addr] = balances[addr].add(tokens);
        Transfer(owner, addr, tokens);

        owner.transfer(msg.value);
        _currentSupply = _currentSupply.add(tokens);
    }

    function totalSupply() constant returns (uint256 totalSupply) {
        return _totalSupply;
    }

    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    function transfer(address _to, uint256 _value) returns (bool success) {
        require(
        balances[msg.sender] >= _value
        && _value > 0
        );
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        require(
        balances[_from] >= _value
        && allowed[_from][msg.sender] >= _value
        && _value > 0
        );
        balances[_from] = balances[_from].sub(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }


    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}
