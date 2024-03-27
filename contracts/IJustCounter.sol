// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

interface IJustCounter {
    function store(uint256 num) external;

    function retrieve() external view returns (uint256);

    function increaseCount() external;

    function decreaseCount() external;

    function isCountEven() external view returns (bool);

    function increaseUnderCount() external;

    function decreaseUnderCount() external;

    function getUnderCount() external view returns (int256);
}
