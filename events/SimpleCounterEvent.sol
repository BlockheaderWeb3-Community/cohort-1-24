// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract SimpleCounterEvent {
    // emit event on store() call
    event storeEvent(address indexed sender, uint256 count);

    // emit event on underCountChanged
    event underCountChanged(address indexed sender, int256 underCount);
}
