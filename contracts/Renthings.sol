// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "./interfaces/IRenthings.sol";

contract Renthings is IRenthings {
    using SafeMath for uint256;
    // struct Rental {
    //     bytes32 ref;
    //     uint256 fee;
    //     uint256 guarantee;
    //     address token;
    //     address lessor;
    //     uint256 status; // status: 0 = not available, 1 = available
    // }

    struct RentalAgreement {
        bytes32 ref;
        address tenant;
        address lessor;
        uint256 fee;
        uint256 guarantee;
        int256 fine;
        address token;
        uint256 status; // status: 0 = pending, 1 = renting, 2 = refunded, 3 = appealed
    }

    struct Participant {
        uint256 latestRental;
        int256 latestRentalIndex;
        uint256 rewards;
    }

    // mapping(bytes32 => Rental) renthings;
    // bytes32[] public renthingsIds;

    RentalAgreement[] public agreements;
    mapping(address => Participant) participants;

    address acceptedToken;

    address admin;
    uint256 feeRate = 200;
    uint256 pltFees = 0;
    uint256 sharedRewardRate = 250;

    modifier onlyPending(uint256 _id) {
        RentalAgreement memory ra = agreements[_id];
        require(ra.status == 0, "only pending");
        _;
    }

    modifier onlyRenting(uint256 _id) {
        RentalAgreement memory ra = agreements[_id];
        require(ra.status == 1 && ra.fine < 0, "only renting");
        _;
    }

    modifier onlyRefundReady(uint256 _id) {
        RentalAgreement memory ra = agreements[_id];
        require(ra.status == 1 && ra.fine >= 0, "refund not ready");
        _;
    }

    modifier onlyAllReturned() {
        Participant memory me = participants[msg.sender];
        require(me.latestRental == 0, "must return all rental");
        _;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "only admin");
        _;
    }

    constructor(address _acceptedToken) {
        admin = msg.sender;
        acceptedToken = _acceptedToken;
    }

    // function createRental(
    //     bytes32 _ref,
    //     uint256 _fee,
    //     uint256 _quarantee,
    //     address _token
    // ) external {
    //     uint256 _defaultStatus = 1;

    //     renthings[_ref] = Rental(
    //         _ref,
    //         _fee,
    //         _quarantee,
    //         _token,
    //         msg.sender,
    //         _defaultStatus
    //     );
    //     renthingsIds.push(_ref);

    //     emit CreateRental(
    //         _ref,
    //         _fee,
    //         _quarantee,
    //         _token,
    //         msg.sender,
    //         _defaultStatus
    //     );
    // }

    // function removeRental(bytes32 _ref) external {
    //     delete renthings[_ref];
    // }

    function createRentalAgreement(
        bytes32 _ref,
        address _tenant,
        // address _lessor,
        uint256 _fee,
        uint256 _guarantee
    ) external returns (uint256) {
        uint256 _defaultStatus = 0;
        address _lessor = msg.sender;

        agreements.push(
            RentalAgreement(
                _ref,
                _tenant,
                _lessor,
                _fee,
                _guarantee,
                -1,
                acceptedToken,
                _defaultStatus
            )
        );

        uint256 _id = agreements.length - 1;

        emit RentalAgreementCreated(
            _id,
            _ref,
            _tenant,
            _lessor,
            _fee,
            _guarantee,
            acceptedToken,
            _defaultStatus
        );

        return (_id);
    }

    function rent(uint256 _id) external onlyPending(_id) returns (uint256) {
        RentalAgreement storage ra = agreements[_id];
        address _tenant = msg.sender;

        uint256 _deposit = ra.fee + ra.guarantee;
        IERC20(ra.token).transferFrom(_tenant, address(this), _deposit);
        ra.status = 1;

        emit Rented(_id, ra.ref);

        return (_id);
    }

    function refund(uint256 _id, uint256 _fine)
        external
        onlyRenting(_id)
        returns (uint256)
    {
        RentalAgreement storage _ra = agreements[_id];

        _ra.fine = int256(_fine);

        emit Refunded(_id, _ra.ref, _fine);

        return (_id);
    }

    function acceptRefund(uint256 _id)
        external
        onlyRefundReady(_id)
        returns (uint256)
    {
        RentalAgreement storage _ra = agreements[_id];
        // address _tenantAddr = _ra.tenant;
        // address _lessorAddr = _ra.lessor;
        Participant storage _tenant = participants[_ra.tenant];
        Participant storage _lessor = participants[_ra.lessor];

        uint256 _deposit = _ra.fee + _ra.guarantee;
        uint256 _pltFee = _deposit *
            SafeMath.div(SafeMath.div(feeRate, 10000), 100);
        uint256 _sharedRewards = _pltFee *
            SafeMath.div(SafeMath.div(_pltFee, 10000), 100);

        pltFees = _pltFee - SafeMath.mul(_sharedRewards, 2);
        _ra.status = 3;
        _tenant.latestRental = 0;
        _tenant.latestRentalIndex = -1;
        _tenant.rewards = _tenant.rewards.add(_sharedRewards);
        _lessor.rewards = _lessor.rewards.add(_sharedRewards);

        emit RefundAccepted(_id, _ra.ref, _pltFee, _sharedRewards);

        return (_id);
    }

    function getMyRewards() external view returns (uint256) {
        Participant memory _me = participants[msg.sender];
        return (_me.rewards);
    }

    function claimRewards() external onlyAllReturned returns (uint256) {
        Participant storage _me = participants[msg.sender];

        _me.rewards = 0;

        emit RewardsClaimed(msg.sender, _me.rewards);

        return (_me.rewards);
    }

    function claimPlatformFees() external onlyAdmin returns (uint256) {
        IERC20(acceptedToken).transferFrom(address(this), msg.sender, pltFees);

        pltFees = 0;

        emit PlatformFeesClaimed(msg.sender, pltFees);

        return (pltFees);
    }
}
