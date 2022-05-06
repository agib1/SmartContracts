// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract NewDevice {

    function getAddress() public view returns (address) {
        return address(this);
    }
}

contract DeviceRegistration {
    
    event DeviceRegistered(uint _device_reference, address _device_address);

    mapping(uint => bool) private devices;
    mapping(address => bool) private addresses;
    mapping(address => uint) private addressToDevice;

 
    modifier notRegistered(uint device_reference) {
        require(devices[device_reference] != true);
        _;
    }

    function RegisterDevice(uint device_reference) public notRegistered(device_reference) returns (address _device_address) {

        NewDevice new_device = new NewDevice();
        address device_address = new_device.getAddress();

        addresses[device_address] = true;
        devices[device_reference] = true;
        addressToDevice[device_address] = device_reference;
        
        emit DeviceRegistered(device_reference, device_address);

        return device_address;
    }

    function verifyDeviceAddress(address device_address) external view returns (bool) {
        return addresses[device_address];
    }

    function getDeviceFromAddress(address device_address) external view returns (uint) {
        return addressToDevice[device_address];
    }

    function sourceVerificationLinked(address device_registration_address) external view returns (bool) {
        if (device_registration_address == address(this)) {
            return true;
        }
        else {
            return false;
        }
    }
}

