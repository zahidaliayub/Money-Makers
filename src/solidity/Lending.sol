pragma solidity ^0.5.0;

contract LendingContract {
    
    uint lendingContracts;
 
    mapping (address => address) contracts;
    address [] public contractAddresses;
    address [] public borrowerAddresses;
 
    constructor() public {
        lendingContracts = 0;
    }
        
    event showContractDetails(
        string uname,
        address contractAddress,
        uint borrowAmount,
        uint paybackTime,
        uint interest
    );
    
    event errorMessage (
        string message
    );

    function launchLendingContract(string memory name, uint borrowAmount, uint paybackTime, uint interest) public {
        require (contracts[msg.sender] == address(0));
        Lending cont = new Lending(msg.sender, borrowAmount);
        contracts[msg.sender] = address(cont);
        contractAddresses.push(address(cont)) -1;
        borrowerAddresses.push(msg.sender) -1;
        
        emit showContractDetails(name, address(cont), borrowAmount, paybackTime, interest);
    }
        
    function getContractAddressFromBorrower(address borrower) public view returns (address) {
        return contracts[borrower];
    }
}

    
contract Lending {
    address public deployer;
    address payable public borrower;
    
    ///borrower details
    string public borrowerName;
    
    uint256 public borrowAmount;
    uint public totalLendedAmount;
    
    uint numberOfLenders;

    struct Lender {
        address lenderAddress;
        uint lendAmount;
    }
    
    mapping (address => Lender) lenders;
    mapping (address => bool) lendersAvailable;
    
    event borrowingContractInitialized(
        address payable borrowerAddress,
        uint amount
    );
    
    event showLenderInfo (
        address addresss,
        uint amount,
        uint lendersCount
    );
    
    event loanFulfilled (
        uint lenderCount
    );

    constructor (address payable _borrower, uint _borrowAmount) public {
        deployer = msg.sender;
        borrower = _borrower;
        borrowAmount = _borrowAmount*10**18;
        totalLendedAmount = 0;
        numberOfLenders = 0;
        borrowerName = "default name";
        emit borrowingContractInitialized(_borrower, _borrowAmount);
    }
    
    function setName(string memory _name) public {
        require (msg.sender==deployer);
        borrowerName = _name;
    }

    function lend() public payable {
        //check whether this lender paid this borrower before
        if (!lendersAvailable[msg.sender]){
            //add this lender to the list of lenders who paid this borrower
            lendersAvailable[msg.sender] = true;
            //increas count of lenders
            numberOfLenders = numberOfLenders + 1;
            lenders[msg.sender] = Lender(msg.sender, 0);
        }
        
        //increase the amout a lender is giving to this borrower + total amount being lended
        lenders[msg.sender].lendAmount += msg.value;
        
        totalLendedAmount = totalLendedAmount + msg.value;

        if (totalLendedAmount > borrowAmount + 0.01 ether) {
            msg.sender.transfer(totalLendedAmount - borrowAmount - 0.01 ether);
            
            // transfer amount to borrower
            borrower.transfer(borrowAmount);
            
            emit loanFulfilled(numberOfLenders);
        }

        emit showLenderInfo(msg.sender, lenders[msg.sender].lendAmount, numberOfLenders);
    }
    
    function getTotalLendedAmount() public view returns (uint) {
        return totalLendedAmount;
    }
    
    function getRequestedAmount() public view returns (uint) {
        return borrowAmount;
    }
}
