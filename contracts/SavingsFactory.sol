// SPDX-License-Identifier: MIT
pragma >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";w
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract SavingsFactory is AccessControl, Pausable, Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    address _beneficiary;
    address _simplicy;

     // The token being saved
    IERC20 private _token;

    uint256 private _openingTime;
    uint256 private _closingTime;

    uint8 private _apy;

    /**
     * @dev Reverts if not in savings time range.
     */
    modifier onlyWhileOpen {
        require(isOpen(), "Savings: not open");
        _;
    }

    /**
     * @dev Reverts if not in savings time range.
     */
    modifier onlyWhileClosed {
        require(hasClosed(), "Savings: not closed");
        _;
    }

    constructor(address beneficiary_, IERC20 token_, uint256 openingTime_, uint256 closingTime_, uint apy_) {
        // solhint-disable-next-line not-rely-on-time
        require(openingTime >= block.timestamp, "Savings: opening time is before current time");
        // solhint-disable-next-line max-line-length
        require(closingTime > openingTime, "Savings: opening time is not before closing time");

        _openingTime = openingTime_;
        _closingTime = closingTime_;
        _apy = apy_;
        _token = token_;
        _beneficiary = _beneficiary;
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

     /**
     * @return the savings opening time.
     */
    function openingTime() public view returns (uint256) {
        return _openingTime;
    }

    /**
     * @return the savings closing time.
     */
    function closingTime() public view returns (uint256) {
        return _closingTime;
    }

    /**
     * @return true if the savings is open, false otherwise.
     */
    function isOpen() public view returns (bool) {
        // solhint-disable-next-line not-rely-on-time
        return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
    }

    /**
     * @dev Checks whether the period in which the savings is open has already elapsed.
     * @return Whether savings period has elapsed
     */
    function hasClosed() public view returns (bool) {
        // solhint-disable-next-line not-rely-on-time
        return block.timestamp > _closingTime;
    }

    /**
     * @return the token being saved.
     */
    function token() public view returns (IERC20) {
        return _token;
    }

    /**
     * @return the apy of the contract.
     */
    function apy() public view returns (uint8) {
        return _apy;
    }

    /**
     * @dev Source of tokens. Override this method to modify the way in which the savings ultimately gets and sends
     * its tokens.
     * @param tokenAmount Number of tokens to be emitted
     */
    function redeemTokens() public onlyOwner onlyWhileClosed {
        require(_token.balanceOf(address(this) > 0);
        uint256 tokenBalance = _token.balanceOf(address(this))
        _token.safeTransfer(beneficiary_, tokenBalance);
    }

    // This function is called for all messages sent to
    // this contract, except plain Ether transfers
    // (there is no other function except the receive function).
    // Any call with non-empty calldata to this contract will execute
    // the fallback function (even if Ether is sent along with the call).
    fallback() external payable {
        _simplicy.transfer(msg.value);
    }  

    // This function is called for plain Ether transfers, i.e.
    // for every call with empty calldata.
    receive() external payable {
        _simplicy.transfer(msg.value);
    }

}