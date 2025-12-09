// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IAccessController
/// @notice Minimal interface for access control checks used by LoopToken.
/// @dev The concrete AccessController contract will be defined separately.
interface IAccessController {
    function isMinter(address account) external view returns (bool);
    function isAdmin(address account) external view returns (bool);
}

/// @title LoopToken
/// @notice ERC20-style token whose minting is restricted to approved minters
///         (e.g. the YieldLoopCore contract) via an AccessController.
/// @dev This is a minimal ERC20 implementation to avoid external dependencies.
///      It is intentionally simple and focused on the "mint-only-by-proof"
///      constraint enforced via the AccessController.
contract LoopToken {
    // ------------------------------------------------------------------------
    // ERC20 basic state
    // ------------------------------------------------------------------------
    string public name;
    string public symbol;
    uint8 public immutable decimals = 18;

    uint256 public totalSupply;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    // ------------------------------------------------------------------------
    // Access control
    // ------------------------------------------------------------------------
    IAccessController public accessController;

    // ------------------------------------------------------------------------
    // Events
    // ------------------------------------------------------------------------
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    event AccessControllerUpdated(address indexed newController);

    // ------------------------------------------------------------------------
    // Modifiers
    // ------------------------------------------------------------------------
    modifier onlyMinter() {
        require(
            accessController.isMinter(msg.sender),
            "LoopToken: caller is not minter"
        );
        _;
    }

    modifier onlyAdmin() {
        require(
            accessController.isAdmin(msg.sender),
            "LoopToken: caller is not admin"
        );
        _;
    }

    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    constructor(
        string memory _name,
        string memory _symbol,
        address _accessController
    ) {
        require(_accessController != address(0), "LoopToken: zero controller");
        name = _name;
        symbol = _symbol;
        accessController = IAccessController(_accessController);
    }

    // ------------------------------------------------------------------------
    // ERC20 standard functions
    // ------------------------------------------------------------------------

    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256) {
        return _allowances[owner][spender];
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool) {
        uint256 currentAllowance = _allowances[from][msg.sender];
        require(
            currentAllowance >= amount,
            "LoopToken: transfer amount exceeds allowance"
        );

        _transfer(from, to, amount);
        _approve(from, msg.sender, currentAllowance - amount);
        return true;
    }

    // ------------------------------------------------------------------------
    // Minting / Burning (Veridic constraint hooks)
    // ------------------------------------------------------------------------

    /// @notice Mint new tokens to `to`.
    /// @dev Only callable by addresses recognized as minters by the AccessController.
    ///      In the full system, YieldLoopCore (or another proof-aware contract)
    ///      will call this *only after* verifying P via ProofEngine.
    function mint(address to, uint256 amount) external onlyMinter {
        require(to != address(0), "LoopToken: mint to zero address");
        _mint(to, amount);
    }

    /// @notice Burn tokens from `from`.
    /// @dev Only callable by minters (e.g. to handle redemptions).
    function burn(address from, uint256 amount) external onlyMinter {
        require(from != address(0), "LoopToken: burn from zero address");
        _burn(from, amount);
    }

    /// @notice Update the access controller.
    /// @dev Restricted to admins as defined in the current accessController.
    function setAccessController(address _accessController) external onlyAdmin {
        require(_accessController != address(0), "LoopToken: zero controller");
        accessController = IAccessController(_accessController);
        emit AccessControllerUpdated(_accessController);
    }

    // ------------------------------------------------------------------------
    // Internal logic
    // ------------------------------------------------------------------------

    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0), "LoopToken: transfer from zero address");
        require(to != address(0), "LoopToken: transfer to zero address");

        uint256 fromBal = _balances[from];
        require(fromBal >= amount, "LoopToken: transfer exceeds balance");

        unchecked {
            _balances[from] = fromBal - amount;
        }
        _balances[to] += amount;

        emit Transfer(from, to, amount);
    }

    function _mint(address to, uint256 amount) internal {
        totalSupply += amount;
        _balances[to] += amount;
        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint256 amount) internal {
        uint256 fromBal = _balances[from];
        require(fromBal >= amount, "LoopToken: burn exceeds balance");

        unchecked {
            _balances[from] = fromBal - amount;
        }
        totalSupply -= amount;
        emit Transfer(from, address(0), amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal {
        require(owner != address(0), "LoopToken: approve from zero");
        require(spender != address(0), "LoopToken: approve to zero");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}
