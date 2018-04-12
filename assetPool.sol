pragma solidity ^0.4.20;

import "./bpToken.sol";

contract ownedPool {
    address public owner;

    function ownedPool() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) onlyOwner public {
        owner = newOwner;
    }
}

/**
 * Asset pool contract
*/
contract AssetPool is ownedPool {
    uint  baseLockPercent;
    uint  startLockTime;
    uint  stopLockTime;
    uint  linearRelease;
    address public bpTokenAddress;

    BPToken bp;

    function AssetPool(address _bpTokenAddress, uint _baseLockPercent, uint _startLockTime, uint _stopLockTime, uint _linearRelease) {
        assert(_stopLockTime > _startLockTime);
        
        baseLockPercent = _baseLockPercent;
        startLockTime = _startLockTime;
        stopLockTime = _stopLockTime;
        linearRelease = _linearRelease;

        bpTokenAddress = _bpTokenAddress;
        bp = BPToken(bpTokenAddress);

        owner = msg.sender;
    }
    
    /// set role value
    function setRule(uint _baseLockPercent, uint _startLockTime, uint _stopLockTime, uint _linearRelease) onlyOwner {
        assert(_stopLockTime > _startLockTime);
       
        baseLockPercent = _baseLockPercent;
        startLockTime = _startLockTime;
        stopLockTime = _stopLockTime;
        linearRelease = _linearRelease;
    }

    /// set bp token contract address
    // function setBpToken(address _bpTokenAddress) onlyOwner {
    //     bpTokenAddress = _bpTokenAddress;
    //     bp = BPToken(bpTokenAddress);
    // }
    
    /// assign BP token to another address
    function assign(address to, uint256 amount) onlyOwner returns (bool) {
        if (bp.setPoolAndAmount(to,amount)) {
            if (bp.transfer(to,amount)) {
                return true;
            }
        }
        return false;
    }

    /// get the balance of current asset pool
    function getPoolBalance() constant returns (uint) {
        return bp.getBalance();
    }
    
    function getStartLockTime() constant returns (uint) {
        return startLockTime;
    }
    
    function getStopLockTime() constant returns (uint) {
        return stopLockTime;
    }
    
    function getBaseLockPercent() constant returns (uint) {
        return baseLockPercent;
    }
    
    function getLinearRelease() constant returns (uint) {
        return linearRelease;
    }
}