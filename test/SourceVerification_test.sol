// SPDX-License-Identifier: GPL-3.0
        
pragma solidity >=0.4.22 <0.9.0;

import "remix_tests.sol"; 
import "remix_accounts.sol";
import "hardhat/console.sol";
import "../contracts/DeviceRegistration.sol";
import "../contracts/SourceVerification.sol";

contract SourceVerificationTest {

    SourceVerification source_verification;

    address device_address;
    uint hashed_device_id = 12345;
    uint storage_reference = 54321;

    function beforeAll() public {
        DeviceRegistration device_registration = new DeviceRegistration();
        device_address = device_registration.RegisterDevice(hashed_device_id);
        address _device_registration_contract = address(device_registration);
        source_verification = new SourceVerification();
        bool linked = source_verification.setDeviceRegistrationContract(_device_registration_contract);
        console.log("device registration contract linked:");
        console.log(linked);

        bool verified = source_verification.Verify(hashed_device_id, device_address, storage_reference);
        Assert.ok(verified == true, "fail: device successfully verified");
    }

    function checkVerificationDataStored() public {
        (bool verified, ) = source_verification.getSourceVerificationData(hashed_device_id, storage_reference);
        Assert.ok(verified == true, "fail: device successfully verification stored");
    }

    function checkAlreadyVerified() public {
        bool verified = source_verification.Verify(hashed_device_id, device_address, storage_reference);
        Assert.ok(verified == false, "fail: verification not redone");
    }

    function checkNotRegistered() public {
        bool verified = source_verification.Verify(1234, device_address, storage_reference);
        Assert.ok(verified == false, "fail: verification not done for unregistered device");
    }

    function checkIncorrectAddress() public {
        bool verified = source_verification.Verify(hashed_device_id, 0x26F175375871068e55c9588413858Ee051521375, storage_reference);
        Assert.ok(verified == false, "fail: verification not done for unknown device");
    }  
}