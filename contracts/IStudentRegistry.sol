pragma solidity >=0.8.2 <0.9.0;

interface IStudentRegistry {
    function count() external view returns (uint256);

    function increment() external;
}