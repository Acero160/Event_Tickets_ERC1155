# Event Ticketing Smart Contract (ERC1155)

A decentralized solution for event ticketing built using ERC1155 tokens. This smart contract allows event organizers to create, manage, and sell tickets in a secure, transparent, and efficient way. By leveraging blockchain technology, the contract ensures seamless ticket purchasing, transferring, and refunding processes, enabling event-goers to buy and transfer tickets with ease.

## 📝 **Features**
- **Event Creation**: Organizers can create events with defined ticket supply, price, and active status.
- **Ticket Purchase**: Users can purchase tickets by paying the specified price, with automatic minting of ERC1155 tokens for each ticket.
- **Ticket Transfer**: Supports secure transfer of individual or multiple tickets between users.
- **Refund System**: Users can request a refund by returning their tickets.
- **Event Cancellation**: Organizers can cancel events, halting the sale of further tickets.
- **Security**: Includes safeguards for sufficient balance, ticket availability, and event status validation.

## 🔑 **Key Features**
- **ERC1155 Token**: The tickets are represented as ERC1155 tokens, which allows for efficient batch operations.
- **Custom Events**: Each event is a unique contract entity with a specific supply of tickets.
- **Refundable Tickets**: Users can get refunds for tickets they no longer need.
- **Transferable Tickets**: Tickets can be securely transferred between users via the contract.

## 🛠 **Technologies Used**
- **Solidity**: Smart contract development on the Ethereum blockchain.
- **ERC1155**: Multi-token standard for handling both fungible and non-fungible tokens efficiently.
- **OpenZeppelin**: Reusable, secure, and community-reviewed smart contract libraries.

## ⚙️ **How It Works**
1. **Create Event**: 
  - Organizers create an event with a specific number of tickets and a set price.
 - Tickets are minted upon purchase.
   
 Example:
 ```solidity
 function createEvent(string memory name, uint256 totalSupply, uint256 price) external onlyOwner;
  ````
 2. **Buy Tickets**:

   - Users buy tickets for an event by sending ETH to the contract.
   - Tickets are minted as ERC1155 tokens and the transaction is recorded.
    Example:
 ```solidity
function buyTickets(uint256 id, uint256 amount) external payable;
````
3. **Transfer Tickets**:

  - Users can transfer their tickets to others.
  Example:

````solidity
function transferTickets(address to, uint256 id, uint256 amount) external;
````
4. **Refund Tickets**:

- Users can return tickets for a refund if the event is still active.
Example:

````solidity
function refundTickets(uint256 id, uint256 amount) external;
````
📈 Event Management Cancel Event: 
- Organizers can cancel events at any time, halting further ticket sales.
- Withdraw Funds: Organizers can withdraw collected funds from ticket sales.
