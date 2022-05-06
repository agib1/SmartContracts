// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract NewDevice {

    function getAddress() public view returns (address) {
        return address(this);
    }
}

contract DeviceRegistration {
    
    event DeviceRegistering(string message);

    struct RegistrationData {
        bool device_exists;
        address device_address;
        uint256 time_registered;
    }

    mapping(uint => RegistrationData) private deviceToRegistrationData;

    modifier notRegistered(uint hashed_device_id) {
        if (deviceToRegistrationData[hashed_device_id].device_exists == true) {
            emit DeviceRegistering("device already registered");
        }
        else {
            _;
        }
    }

    function RegisterDevice(uint hashed_device_id) public notRegistered(hashed_device_id) returns (address device_address) {

        NewDevice new_device = new NewDevice();
        device_address = new_device.getAddress();

        deviceToRegistrationData[hashed_device_id] = RegistrationData(true, device_address, block.timestamp);
        
        emit DeviceRegistering("device registered");

        return device_address;
    }

    function getDeviceRegistrationData(uint hashed_device_id) external view returns (bool device_exists, address device_address, uint256 time_registered) {
        RegistrationData memory registration_data = deviceToRegistrationData[hashed_device_id];
        
        return (registration_data.device_exists, registration_data.device_address, registration_data.time_registered);
    }
}