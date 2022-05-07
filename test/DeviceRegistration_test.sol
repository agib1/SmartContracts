// SPDX-License-Identifier: GPL-3.0
        
pragma solidity >=0.4.22 <0.9.0;

import "remix_tests.sol"; 
import "remix_accounts.sol";
import "../contracts/DeviceRegistration.sol";

contract DeviceRegistrationTest {

    DeviceRegistration device_registration;
    address device_address;
    uint hashed_device_id = 12345;

    function beforeAll() public {
        device_registration = new DeviceRegistration();
        device_address = device_registration.RegisterDevice(hashed_device_id);
    }

    function checkDeviceDataStored() public {
        (, address stored_device_address, ) = device_registration.getDeviceRegistrationData(hashed_device_id);
        Assert.ok(stored_device_address == device_address, "address correctly stored");
    }

    function checkAlreadyRegistered() public {
        address empty_device_address = 0x0000000000000000000000000000000000000000;
        address retrieved_device_address = device_registration.RegisterDevice(hashed_device_id);
        Assert.ok(empty_device_address == retrieved_device_address, "new address not generated");
    }
}