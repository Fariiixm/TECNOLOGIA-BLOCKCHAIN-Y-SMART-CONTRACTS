// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.8.0;
contract PiggyMapping2 {
    
    struct Cliente {
        string nombre;
        address direccion;
        uint cantidad;
    }
    
    mapping(address => Cliente) clients;
    
    address[] public clientAddresses; // array hucha
    
    function addClient(string memory name) external payable {
        require(bytes(name).length > 0, "Nombre no puede estar vacio");
        require(bytes(clients[msg.sender].nombre).length == 0, "Cliente ya registrado");
        Cliente memory c = Cliente(name, msg.sender, msg.value);
        clients[msg.sender] = c;
        clientAddresses.push(msg.sender); //nuevo
    }
    
    function deposit() external payable {
        require(bytes(clients[msg.sender].nombre).length > 0, "Cliente no registrado");
        clients[msg.sender].cantidad += msg.value;
    }
    
    function withdraw(uint amountInWei) external {
        require(bytes(clients[msg.sender].nombre).length > 0, "Cliente no registrado");
        require(clients[msg.sender].cantidad >= amountInWei, "Fondos insuficientes");
        clients[msg.sender].cantidad -= amountInWei;
        payable(msg.sender).transfer(amountInWei);
    }
    
    function getBalance() external view returns (uint) {
        require(bytes(clients[msg.sender].nombre).length > 0, "Cliente no registrado");
        return clients[msg.sender].cantidad;
    }
    // nuevo
    function checkBalances() external view returns (bool) {
        uint totalBalance = 0;
        for (uint i = 0; i < clientAddresses.length; i++) {
            totalBalance += clients[clientAddresses[i]].cantidad;
        }
        return totalBalance == address(this).balance;
    }
}