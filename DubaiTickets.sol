// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";



contract EventTicket is ERC1155, Ownable {

    //Errors
    error AlreadyCanceled();
    error CanceledEvent();
    error NonAvailableTickets();
    error InsufficientBalance();
    error InsufficientTickets();

    //Variable
    uint256 eventId; 

    //Event
    event EventCreated(uint256 id, string name, uint256 totalSupply, uint256 price);
    event TicketBought(address to, uint256 id, uint256 amount);

    //Estructura
    struct Event {
        uint256 id;
        string name;
        uint256 totalSupply;
        uint256 availableTickets;
        uint256 price;
        bool isActive;
    }

    //Mapping
    mapping(uint256 => Event) public events;


    constructor() ERC1155("https://api.example/metadata/{id}.json") Ownable(msg.sender) {
        eventId = 0;
    }


    //Functions
    function createEvent(string memory name, uint256 totalSupply, uint256 price) external onlyOwner {
        eventId = eventId + 1;

        events[eventId] = Event({
             id: eventId,
             name: name, 
             totalSupply: totalSupply, 
             availableTickets: totalSupply,
             price: price, 
             isActive: true             
        });

        emit EventCreated(eventId, name, totalSupply, price);
    }

    function cancelEvent(uint256 _eventId) external onlyOwner {
        if(!events[_eventId].isActive) {
            revert AlreadyCanceled();
        }

        events[_eventId].isActive = false;
    }


    function buyTickets(uint256 id, uint256 amount) external payable {
        Event storage _event = events[id];

        if(!_event.isActive){
            revert CanceledEvent();
        }
        if(_event.availableTickets < amount){
            revert NonAvailableTickets();
        }
        uint totalCost = _event.price*amount;
        if(msg.value < (totalCost)) {
            revert InsufficientBalance();
        }

        //Minteamos tokens
        _mint (msg.sender, id, amount,  "");

        
        uint256 refund = msg.value - totalCost;
        
        if(refund > 0){
            payable (msg.sender).transfer (refund);
        }

        emit TicketBought(msg.sender, id, amount);

        _event.availableTickets = _event.availableTickets-amount;

    }


    //Transferir un ticket
    function transferTickets (address to, uint256 id, uint256 amount) external {
        safeTransferFrom(msg.sender, to, id, amount, "");
    }

    //Transferir varios tickets
    function transferTicketsBatch (address to, uint256[] memory ids, uint256[] memory amounts) external {
        safeBatchTransferFrom(msg.sender, to, ids, amounts, "");
    }

    function validateTicket(address to, uint256 id) external view returns (uint256) {
        return balanceOf(to, id);
    }

    //funcion reembolso / devolver tickets
    function refundTickets(uint256 id, uint256 amount) external {
        Event storage _event = events[id];

        if(!_event.isActive) {
            revert CanceledEvent();
        }
        if(balanceOf(msg.sender, id) < amount) {
            revert InsufficientTickets();
        }


        uint256 refundAmount = _event.price * amount;
        //Le devolvemos el dinero
        payable(msg.sender).transfer(refundAmount);

        _event.availableTickets = _event.availableTickets+amount;
        _burn(msg.sender, id, amount);
    }

    function withdraw() external onlyOwner{
        payable(owner()).transfer(address(this).balance);
    }


}