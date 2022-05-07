// SPDX-License-Identifier: GPL-3.0
        
pragma solidity >=0.4.22 <0.9.0;

import "remix_tests.sol"; 
import "remix_accounts.sol";
import "hardhat/console.sol";
import "../contracts/DeviceRegistration.sol";
import "../contracts/SourceVerification.sol";
import "../contracts/MedicalDataLogging.sol";

contract MedicalDataLoggingTest {

    MedicalDataLogging medical_data_logging;

    address device_address;
    uint hashed_device_id = 12345;
    uint storage_reference = 54321;

    function beforeAll() public {
        DeviceRegistration device_registration = new DeviceRegistration();
        device_address = device_registration.RegisterDevice(hashed_device_id);
        address _device_registration_contract = address(device_registration);
        
        SourceVerification source_verification = new SourceVerification();
        bool device_registration_linked = source_verification.setDeviceRegistrationContract(_device_registration_contract);
        console.log("device registration contract linked:");
        console.log(device_registration_linked);
        source_verification.Verify(hashed_device_id, device_address, storage_reference);
        address _source_verification_contract = address(source_verification);
        
        medical_data_logging = new MedicalDataLogging();
        bool source_verification_linked = medical_data_logging.setSourceVerificationContract(_source_verification_contract);
        console.log("source verification contract linked:");
        console.log(source_verification_linked);

        bool logged = medical_data_logging.logMedicalMetadata(hashed_device_id, storage_reference, 1357924680, 300);
        Assert.ok(logged == true, "fail: medical data sucessfully logged");
    }

    function checkMedicalMetadataStored() public {
        (bool source_verified, , , ) = medical_data_logging.getMedicalMetadata(hashed_device_id, storage_reference);
        Assert.ok(source_verified == true, "fail: medical metadata sucessfully stored");
    }

    function checkAlreadyLogged() public {
        bool logged = medical_data_logging.logMedicalMetadata(hashed_device_id, storage_reference, 1357924680, 300);
        Assert.ok(logged == false, "fail: logging not redone");
    }
}