// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

interface RegisteredDevices {
    function verifyDeviceAddress(address device_registration_address) external view returns (bool);
    function getDeviceFromAddress(address device_registration_address) external view returns (uint);
    function sourceVerificationLinked(address device_registration_address) external view returns (bool);
}

contract SourceVerification { 

    event DeviceRegistrationContractLinked(address _device_registration_contract, bool _linked);
    event DeviceVerified(address _device_address, uint _device_reference, bool _verified);
    
    address device_registration_contract;

    function setDeviceRegistrationContract(address _device_registration_contract) public returns (bool is_linked) {
        device_registration_contract = _device_registration_contract;
        bool _linked = isLinked(device_registration_contract);

        emit DeviceRegistrationContractLinked(device_registration_contract, _linked);

        return _linked;
    }

    function isLinked(address device_registration_address) private view returns (bool) {
        bool _linked = RegisteredDevices(device_registration_address).sourceVerificationLinked(device_registration_contract);    
        return _linked;
    }

    modifier linked() { 
        if (!isLinked(device_registration_contract)) {
            emit DeviceRegistrationContractLinked(device_registration_contract, false);
        }
        else {
            _;
        }
    }

    function verifyDeviceAddress(address device_address) private view returns (bool exists) {
        return RegisteredDevices(device_registration_contract).verifyDeviceAddress(device_address);
    }

    function getDeviceFromAddress(address device_address) private view returns (uint device_reference) {
        return RegisteredDevices(device_registration_contract).getDeviceFromAddress(device_address);
    }

    function Verify(uint device_reference, address device_address) public linked() returns (bool _verfied) {
        bool verified;
        
        bool device_address_exists = verifyDeviceAddress(device_address);

        if (device_address_exists) {
            uint reteieved_device_reference = getDeviceFromAddress(device_address);

            if (device_reference == reteieved_device_reference) {
                verified = true;
            }
            else {
                verified = false;
            }
        }
    
        emit DeviceVerified(device_address, device_reference, verified);

        return verified;
    }
}