// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title FeeRouter
/// @notice Routes performance fees according to Veridic / YieldLoop split.
/// @dev This is a scaffold: you'll later wire in actual ERC20/native transfers.
contract FeeRouter {
    address public devWallet;
    address public marketingWallet;
    address public systemDepositWallet;
    address public impactWallet; // Loop Lab or similar impact destination

    // Percentages expressed in basis points (e.g. 1000 = 10%)
    uint256 public devBps = 1000;          // 10%
    uint256 public marketingBps = 500;     // 5%
    uint256 public systemDepositBps = 500; // 5%
    uint256 public impactBps = 500;        // 5%

    event FeesRouted(
        uint256 totalFee,
        uint256 devAmount,
        uint256 marketingAmount,
        uint256 systemDepositAmount,
        uint256 impactAmount
    );

    event WalletsUpdated(
        address devWallet,
        address marketingWallet,
        address systemDepositWallet,
        address impactWallet
    );

    event BpsUpdated(
        uint256 devBps,
        uint256 marketingBps,
        uint256 systemDepositBps,
        uint256 impactBps
    );

    constructor(
        address _dev,
        address _marketing,
        address _systemDeposit,
        address _impact
    ) {
        devWallet = _dev;
        marketingWallet = _marketing;
        systemDepositWallet = _systemDeposit;
        impactWallet = _impact;
    }

    /// @notice Update destination wallets.
    /// @dev In production this should be restricted (e.g. onlyOwner or multisig).
    function setWallets(
        address _dev,
        address _marketing,
        address _systemDeposit,
        address _impact
    ) external {
        // TODO: add access control
        devWallet = _dev;
        marketingWallet = _marketing;
        systemDepositWallet = _systemDeposit;
        impactWallet = _impact;

        emit WalletsUpdated(_dev, _marketing, _systemDeposit, _impact);
    }

    /// @notice Update fee split basis points.
    /// @dev Sum of bps can be <= 10000. Any remainder stays where the caller wants (e.g. treasury).
    function setBps(
        uint256 _devBps,
        uint256 _marketingBps,
        uint256 _systemDepositBps,
        uint256 _impactBps
    ) external {
        // TODO: add access control
        uint256 total = _devBps + _marketingBps + _systemDepositBps + _impactBps;
        require(total <= 10000, "Total bps > 100%");

        devBps = _devBps;
        marketingBps = _marketingBps;
        systemDepositBps = _systemDepositBps;
        impactBps = _impactBps;

        emit BpsUpdated(_devBps, _marketingBps, _systemDepositBps, _impactBps);
    }

    /// @notice Compute and *conceptually* route fees.
    /// @dev This version only emits an event; you will later add token transfers.
    function routeFees(uint256 totalFee) external {
        uint256 devAmount = (totalFee * devBps) / 10000;
        uint256 marketingAmount = (totalFee * marketingBps) / 10000;
        uint256 systemDepositAmount = (totalFee * systemDepositBps) / 10000;
        uint256 impactAmount = (totalFee * impactBps) / 10000;

        // TODO: transfer ERC20s or native asset to each wallet.
        // e.g., IERC20(token).transferFrom(msg.sender, devWallet, devAmount);

        emit FeesRouted(
            totalFee,
            devAmount,
            marketingAmount,
            systemDepositAmount,
            impactAmount
        );
    }
}
