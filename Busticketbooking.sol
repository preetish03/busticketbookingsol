// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract BusTicketBooking {
    address public owner;
    mapping(uint => address) public seatToOwner;
    mapping(address => uint[]) public ownerToSeats;
    uint[] public availableSeats;

    constructor() {
        owner = msg.sender;
        for (uint i = 1; i <= 20; i++) {
            availableSeats.push(i);
        }
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }

    function bookSeats(uint[] memory seatNumbers) public {
        require(seatNumbers.length > 0 && seatNumbers.length <= 4, "Invalid number of seats");
        require(seatNumbers.length <= availableSeats.length, "Insufficient seats available");

        for (uint i = 0; i < seatNumbers.length; i++) {
            require(seatToOwner[seatNumbers[i]] == address(0), "Seat is already booked");
            _removeElement(availableSeats, seatNumbers[i]);
            seatToOwner[seatNumbers[i]] = msg.sender;
            ownerToSeats[msg.sender].push(seatNumbers[i]);
        }
    }

    function showAvailableSeats() public view returns (uint[] memory) {
        return availableSeats;
    }

    function checkAvailability(uint seatNumber) public view returns (bool) {
        return seatToOwner[seatNumber] == address(0);
    }

    function myTickets() public view returns (uint[] memory) {
        return ownerToSeats[msg.sender];
    }

    // Helper function to remove an element from an array
    function _removeElement(uint[] storage array, uint element) internal {
        for (uint i = 0; i < array.length; i++) {
            if (array[i] == element) {
                array[i] = array[array.length - 1];
                array.pop();
                break;
            }
        }
    }
}