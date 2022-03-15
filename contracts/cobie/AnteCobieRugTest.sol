// SPDX-License-Identifier: GPL-3.0-only

// ┏━━━┓━━━━━┏┓━━━━━━━━━┏━━━┓━━━━━━━━━━━━━━━━━━━━━━━
// ┃┏━┓┃━━━━┏┛┗┓━━━━━━━━┃┏━━┛━━━━━━━━━━━━━━━━━━━━━━━
// ┃┗━┛┃┏━┓━┗┓┏┛┏━━┓━━━━┃┗━━┓┏┓┏━┓━┏━━┓━┏━┓━┏━━┓┏━━┓
// ┃┏━┓┃┃┏┓┓━┃┃━┃┏┓┃━━━━┃┏━━┛┣┫┃┏┓┓┗━┓┃━┃┏┓┓┃┏━┛┃┏┓┃
// ┃┃ ┃┃┃┃┃┃━┃┗┓┃┃━┫━┏┓━┃┃━━━┃┃┃┃┃┃┃┗┛┗┓┃┃┃┃┃┗━┓┃┃━┫
// ┗┛ ┗┛┗┛┗┛━┗━┛┗━━┛━┗┛━┗┛━━━┗┛┗┛┗┛┗━━━┛┗┛┗┛┗━━┛┗━━┛
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

pragma solidity ^0.8.0;

import {AnteTest} from "../AnteTest.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @title  Cobie doesn't rug Do-Algod-DCR escrow wallet
/// @notice Ante Test to check if the USDC + USDT balance of the Do-Algod-DCR LUNA bet 
///         escrow wallet drops below 22M before 2023-03-14 
contract AnteCobieRugTest is AnteTest("Cobie Doesnt Rug Do-Algod-DCR Escrow Wallet") {
    // https://etherscan.io/address/0x4Cbe68d825d21cB4978F56815613eeD06Cf30152
    address public constant ESCROW_ADDR = 0x4Cbe68d825d21cB4978F56815613eeD06Cf30152;
    uint256 public constant BET_EXPIRY_TIMESTAMP = 1678838399; // 2023-03-14 23:59:59 GMT
    uint256 public immutable rugThreshold;
    IERC20 usdcToken, usdtToken;
    
    /// @param _usdcAddr $USDC contract addr (0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48)
    /// @param _usdtAddr $USDT contract addr (0xdAC17F958D2ee523a2206206994597C13D831ec7)
    constructor(address _usdcAddr, address _usdtAddr) {
        usdcToken = IERC20(_usdcAddr);
        usdtToken = IERC20(_usdtAddr);

        // 22M USDC+USDT (both have 6 decimals so can just combine total)
        rugThreshold = (22 * 1000 * 1000) * (10**usdtToken.decimals());
        
        protocolName = "Cobie"; // lol
        testedContracts = [ESCROW_ADDR, _usdcAddr, _usdtAddr];
    }

    /// @notice Checks balance of Do-Algod-DCR escrow wallet address
    /// @return true if escrow wallet has greater than or equal to 22M USDC/USDT
    function checkTestPasses() external view override returns (bool) {
        // only check rug during the bet period
        if ((block.timestamp <= BET_EXPIRY_TIMESTAMP) {
            return (usdcToken.balanceOf(ESCROW_ADDR) 
                    + usdtToken.balanceOf(ESCROW_ADDR)) >= rugThreshold;
        }

        // if the bet period has passed the test will always return true
        return true;
    }
}