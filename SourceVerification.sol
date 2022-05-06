// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

interface RegisteredDevices {
    function getDeviceRegistrationData(uint hashed_device_id) external view returns (bool device_exists, address device_address, uint256 time_registered);
}

contract SourceVerification { 

    event DeviceRegistrationContractLinking(string message);
    event DeviceVerifying(string message);

    struct VerificationData {
        bool storage_reference_exists;
        bool verified;
        uint256 time_verified;
    }

    mapping(uint => mapping(uint => VerificationData)) private deviceToVerificationData;
    
    address _device_registration_contract;
    bool _linked;

    function setDeviceRegistrationContract(address device_registration_contract) public returns (bool linked) {
        _device_registration_contract = device_registration_contract;
        _linked = true;

        emit DeviceRegistrationContractLinking("deployed contract linked");
       
        return _linked;
    }

    modifier isLinked() { 
        if (_linked == false) {
            emit DeviceRegistrationContractLinking("contract not linked");
        }
        else {
            _;
        }
    }

    modifier alreadyVerified(uint hashed_device_id, uint storage_reference) { 
        if (deviceToVerificationData[hashed_device_id][storage_reference].storage_reference_exists == true) {
            emit DeviceVerifying("source already verified");
        }
        else {
            _;
        }
    }

    function Verify(uint hashed_device_id, address device_address, uint storage_reference) public isLinked() alreadyVerified(hashed_device_id, storage_reference) returns (bool verified) {   
        
        (bool device_exists, address registered_device_address, ) = RegisteredDevices(_device_registration_contract).getDeviceRegistrationData(hashed_device_id);
        
        if (device_exists) {
            if (device_address == registered_device_address) {
                verified = true;
                emit DeviceVerifying("device is verified");
            }
            else {
                emit DeviceVerifying("device not associated with address");
            }
        }
        else {
            emit DeviceVerifying("device is not registered");
        }

        deviceToVerificationData[hashed_device_id][storage_reference] = VerificationData(true, verified, block.timestamp);
    
        return verified;
    }

    function getSourceVerificationData(uint hashed_device_id, uint storage_reference) external view returns (bool verified, uint256 time_verified) {
        VerificationData memory verification_data = deviceToVerificationData[hashed_device_id][storage_reference];
        
        return (verification_data.verified, verification_data.time_verified);
    }
}