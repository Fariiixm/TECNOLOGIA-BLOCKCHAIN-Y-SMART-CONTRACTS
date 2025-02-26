// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.8.0;

contract PiggyArray {
    
    struct Cliente {
        string nombre;
        address direccion;
        uint cantidad;
    }
    
    Cliente[] clients;
    
    function addClient(string memory name) external payable {
        require(bytes(name).length > 0, "Nombre no puede estar vacio");
        Cliente memory c = Cliente(name, msg.sender, msg.value);
        clients.push(c);
    }
    function ClientIdx(address clienteDireccion) internal view returns (uint) {
        for (uint i = 0; i < clients.length; i++) {
            if (clients[i].direccion == clienteDireccion) {
                return i;
            }
        }
        revert("Cliente no registrado");
    }
    
    function deposit() external payable {
        uint index = ClientIdx(msg.sender);
        clients[index].cantidad += msg.value;
    }
    
    function withdraw(uint amountInWei) external {
        uint index = ClientIdx(msg.sender);
        require(clients[index].cantidad >= amountInWei, "Fondos insuficientes");
        clients[index].cantidad -= amountInWei;
        payable(msg.sender).transfer(amountInWei);
    }
    
    function getBalance() external view returns (uint) {
        uint index = ClientIdx(msg.sender);
        return clients[index].cantidad;
    }
}