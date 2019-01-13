pragma solidity >=0.4.11 <0.6.0;

// pretty much the same contract as CrowdFunding, except it is compatible with zos-lib
import "zos-lib/contracts/Initializable.sol";
contract CFunding is Initializable {
    uint public timestamp;
    
    function initialize() initializer public {
      timestamp = block.timestamp;
    }
    // Defines a new type with two fields.
    struct Funder {
        address addr;
        uint amount;
    }

    struct Campaign {
        address payable beneficiary;
        uint fundingGoal;
        uint numFunders;
        uint amount;
        mapping (uint => Funder) funders;
    }

    uint numCampaigns;
    mapping (uint => Campaign) campaigns;

    function newCampaign(address payable beneficiary, uint goal) public returns (uint campaignID) {
        campaignID = numCampaigns++; // campaignID is return variable
        // Creates new struct in memory and copies it to storage.
        // We leave out the mapping type, because it is not valid in memory.
        // If structs are copied (even from storage to storage), mapping types
        // are always omitted, because they cannot be enumerated.
        campaigns[campaignID] = Campaign(beneficiary, goal, 0, 0);
    }

    function contribute(uint campaignID) public payable {
        Campaign storage c = campaigns[campaignID];
        // Creates a new temporary memory struct, initialised with the given values
        // and copies it over to storage.
        // Note that you can also use Funder(msg.sender, msg.value) to initialise.
        c.funders[c.numFunders++] = Funder({addr: msg.sender, amount: msg.value});
        c.amount += msg.value;
    }

    function checkGoalReached(uint campaignID) public returns (bool reached) {
        Campaign storage c = campaigns[campaignID];
        if (c.amount < c.fundingGoal)
            return false;
        uint amount = c.amount;
        c.amount = 0;
        c.beneficiary.transfer(amount);
        return true;
    }
    
    function viewCampaignDetails(uint campaignID) public view returns (address, uint, uint,uint) {
        Campaign storage c = campaigns[campaignID];
        // have to use the numFunders to access the funders
        return (c.beneficiary, c.fundingGoal, c.numFunders, c.amount);
    }
    
    function viewCampaignFunders(uint campaignID) external view returns (address[] memory, uint256[] memory) {
        Campaign storage c = campaigns[campaignID];
        // have to use the numFunders to access the funders
        // don't think this will work, maybe just hardcode it to 1000
        address[] memory funders     = new address[](c.numFunders);
        uint256[] memory amounts     = new uint256[](c.numFunders);
        for (uint256 i = 0; i < c.numFunders; i++) {
            Funder storage funder = c.funders[i];
            funders[i] = funder.addr;
            amounts[i] = funder.amount;
        }
      return (funders, amounts);
    }

}