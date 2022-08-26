// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IRenthings {
    // event CreateRental(
    //     bytes32 id,
    //     uint256 fee,
    //     uint256 guarantee,
    //     address token,
    //     address lessor,
    //     uint256 status
    // );
    // event RemoveRental(bytes32 id);
    event RentalAgreementCreated(
        uint256 id,
        bytes32 ref,
        address tenant,
        address lessor,
        uint256 fee,
        uint256 guarantee,
        address token,
        uint256 status
    );
    event Rented(uint256 id, bytes32 ref);
    event Refunded(uint256 id, bytes32 ref, uint256 fine);
    event RefundAccepted(
        uint256 id,
        bytes32 ref,
        uint256 platformFee,
        uint256 sharedRewards
    );
    event RewardsClaimed(address participant, uint256 rewards);
    event PlatformFeesClaimed(address admin, uint256 fees);

    // function createRental(
    //     bytes32 _id,
    //     uint256 _fee,
    //     uint256 _guarantee,
    //     address _token
    // ) external;

    // function removeRental(uint256 _i) external;

    function createRentalAgreement(
        bytes32 _id,
        address _tenant,
        // address _lessor,
        uint256 _fee,
        uint256 _guarantee
    ) external returns (uint256);

    function rent(uint256 _id) external returns (uint256);

    function refund(uint256 _id, uint256 _fine) external returns (uint256);

    function acceptRefund(uint256 _id) external returns (uint256);

    function getMyRewards() external view returns (uint256);

    function claimRewards() external returns (uint256);

    function claimPlatformFees() external returns (uint256);
}
