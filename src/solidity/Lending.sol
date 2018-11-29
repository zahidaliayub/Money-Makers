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
        string borrowerName,
        address contractAddress,
        uint requestedAmount,
        uint paybackTime,
        uint interest
    );

    function launchLendingContract(string memory borrowerName, uint requestedAmount, uint paybackTime, uint interest) public {
        require (contracts[msg.sender] == address(0));
        Lending cont = new Lending(borrowerName, msg.sender, requestedAmount, paybackTime, interest);
        contracts[msg.sender] = address(cont);
        contractAddresses.push(address(cont)) -1;
        borrowerAddresses.push(msg.sender) -1;
        
        emit showContractDetails(borrowerName, address(cont), requestedAmount, paybackTime, interest);
    }
        
    function getContractAddressFromBorrower(address borrower) public view returns (address) {
        return contracts[borrower];
    }
    
    function getNumberOfBorrowers() public view returns (uint){
        return borrowerAddresses.length;
    }
}

    
contract Lending {
    address payable creator = 0xA901c9891Ff175125D51274359A507A20eC3Ef82;
    
    address public deployer;
    address payable public borrower;
    
    string public borrowerName;
    uint256 public requestedAmount;
    uint paybackTime;
    uint interest;
    
    uint public totalLendedAmount;
    uint numberOfLenders;

    struct Lender {
        address lenderAddress;
        uint lendAmount;
    }
    
    mapping (address => Lender) lenders;
    mapping (address => bool) lendersAvailable;
    
    event showLenderInfo (
        address borrowerAddress,
        uint requestedAmount,
        uint paybackTime,
        uint interest,
        uint lendersCount
    );
    
    event loanFulfilled (
        uint lenderCount
    );

    constructor (string memory _borrowerName, address payable _borrower, uint _requestedAmount, uint _paybackTime, uint _interest) public {
        deployer = msg.sender;
        borrower = _borrower;
        requestedAmount = _requestedAmount*10**18;
        paybackTime = _paybackTime;
        interest = _interest;
        totalLendedAmount = 0;
        numberOfLenders = 0;
        borrowerName = _borrowerName;
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

        if (totalLendedAmount > requestedAmount + 0.01 ether) {
            msg.sender.transfer(totalLendedAmount - requestedAmount - 0.01 ether);
            
            // transfer amount to borrower
            borrower.transfer(requestedAmount);
            
            //transfer all the rest to contract creator
            creator.transfer(address(this).balance);
            
            emit loanFulfilled(numberOfLenders);
        }
    }
    
    function getLendingContractInformation() public view returns (string memory name, address borrowerAddress, uint256 amount, uint payback, uint rate){
        return (borrowerName, borrower, requestedAmount / 10**18, paybackTime, interest);
    }
    
    function getTotalLendedAmount() public view returns (uint) {
        return totalLendedAmount / 10**18;
    }
    
    function getRequestedAmount() public view returns (uint) {
        return requestedAmount / 10**18;
    }
}
