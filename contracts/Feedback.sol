pragma solidity ^0.5.0;

//Smart contract for Decentralized Feedback System
contract MyContract
{


    //to check whether the Person has voted or not
    enum State {NONE,VOTED}

    /* Fill in the keyword. Hint: We want to protect our users balance from other contracts*/
    mapping (address => uint) private balances;

    //mapping of the address to the policymaker
    mapping (address => Policymaker) policymakers;

    //mapping of the address to the person
    mapping (address => Policy) public policies;

    //mapping of the address to the policy
    mapping(address => Person) public persons;

    //store accounts that has given feedback
    mapping(address => bool) public voters;

    //to check whether the Contract is active or not
    enum contractState {ACTIVE,INACTIVE}

    //initially set to inactive
    contractState state=contractState.INACTIVE;

    address private commisioner;

    event votedEvent (address indexed _policyAddress);

    //setting the state to active
    constructor() public
    {
        commisioner = msg.sender;
        state = contractState.ACTIVE;

    }

    //defining structure of the Policymaker
    struct Policymaker
    {
        bytes32 name;
        uint id;
        uint constituency;
        bool exists;
    }

    //defining Structure of the Policy
    struct Policy
    {
        bytes32 details; //stores only the hash of the actual statement
        bytes32 beneficiary; //stores only the hash of the actual beneficiary criteria
        address framer;
        uint voteCountFor;
        uint votecountAgainst;
        bool exists;

    }

    //defining the structure of the feedback
    struct Feedback
    {
        address policy;
        State feedback;
    }

    //defining the structure of the person
    struct Person
    {
        uint id;
        bytes32 name;
        //initializing a dynamic array for the feedbacks
        //stores the feedback everytime the person votes in for a policy with the profile
        uint numPolcies; //counts the number of policies the person is enrolled in
        Feedback[] feedbacks;
        bool exists;
    }


    //setting up the permissions an passing thee _personAddress as a key
    //initializing the parameters of the function
    //mapping of the address to the Person
    function addPerson(uint _id, bytes32 _name, address _personAddress) public
    {
        require(msg.sender == commisioner, "Only Comissioner can take this action!");
        require(!persons[_personAddress].exists);

        persons[_personAddress].id = _id;
        persons[_personAddress].name = _name;
        persons[_personAddress].numPolcies = 0;
        persons[_personAddress].exists = true;


    }

        //setting up the permissions an passing thee _personAddress as a key
        //initializing the parameters of the function
        //mapping of the address to the Policymaker

    function addPolicymaker(address _policymakerAddress,bytes32 _name, uint _id,uint _constituency) public
    {
        require(msg.sender==commisioner);
        require(!policymakers[_policymakerAddress].exists);

        policymakers[_policymakerAddress].name=_name;
        policymakers[_policymakerAddress].id=_id;
        policymakers[_policymakerAddress].constituency=_constituency;
        policymakers[_policymakerAddress].exists=true;
    }

        //setting up the permissions an passing thee _personAddress as a key
        //initializing the parameters of the function
        //mapping of the address to the Policy

    function addPolicy( address _policyAddress,address _framer, bytes32 _beneficiary, bytes32 _details) public
    {
        require(msg.sender == commisioner);
        require(policymakers[_framer].exists);
        require(!policies[_policyAddress].exists);


        policies[_policyAddress].details=_details;
        policies[_policyAddress].beneficiary=_beneficiary;
        policies[_policyAddress].framer=_framer;
        policies[_policyAddress].exists=true;

    }

    function enrollPerson(address _policyAddress,address _personAddress) public returns (uint)
     {
        require(msg.sender==commisioner);
        require(policies[_policyAddress].exists);
        require(persons[_personAddress].exists);

        persons[_personAddress].numPolcies++;
        persons[_personAddress].feedbacks.push(Feedback(_policyAddress, State.NONE));
    }

    function crediting() public payable returns (uint) {
      /* Add the amount to the user's balance, call the event associated with a deposit,
        then return the balance of the user */
      address user = msg.sender;

      balances[user] += msg.value;

      emit votedEvent(user);

      return balances[user];
  }

  function balance() public view returns (uint) {
      /* Get the balance of the sender of this transaction */
      address user = msg.sender;

      return balances[user];
  }



    function vote(address _policyAddress) public
    {
      //require person has not voted before
      require(persons[msg.sender].exists);
      require(policies[_policyAddress].exists);

      uint i;
      for(i=0;i<persons[msg.sender].numPolcies;i++){

          //check if the person is enrolled in the policy and has not yet voted.
          if(persons[msg.sender].feedbacks[i].policy == _policyAddress && persons[msg.sender].feedbacks[i].feedback == State.NONE)
          persons[msg.sender].feedbacks[i].feedback = State.VOTED;
          else
          revert();
      }

      // trigger voted event
        emit votedEvent(_policyAddress);
    }


}
