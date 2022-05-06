// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

interface VerifiedSources {
    function getSourceVerificationData(uint hashed_device_id, uint storage_reference) external view returns (bool verified, uint256 time_verified);
}

contract MedicalDataLogging {

    event MedicalMetadataLogging(string message);
    event ContractLinking(string message);

    struct MedicalMetadata {
        bool storage_reference_exists;
        bool source_verified;
        uint256 time_generated;
        uint data_size;
        uint256 time_logged;
    }

    mapping(uint => mapping(uint => MedicalMetadata)) private deviceToMedicalData;

    address _source_verification_contract;
    bool _linked = false;

    function setSourceVerificationContract(address source_verification_contract) public returns (bool linked) {
        _source_verification_contract = source_verification_contract;
        _linked = true;

        emit ContractLinking("deployed contract linked");
       
        return _linked;
    }

    modifier isLinked() { 
        if (_linked == false) {
            emit ContractLinking("contract not linked");
        }
        else {
            _;
        }
    }

    modifier alreadyStored(uint hashed_device_id, uint storage_reference) { 
        if (deviceToMedicalData[hashed_device_id][storage_reference].storage_reference_exists == true) {
            emit MedicalMetadataLogging("medical metadata already stored");
        }
        else {
            _;
        }
    }

    function logMedicalMetadata(uint hashed_device_id, uint storage_reference, uint time_generated, uint data_size) public isLinked() alreadyStored(hashed_device_id, storage_reference) returns (bool stored) {
        (bool verified, ) = VerifiedSources(_source_verification_contract).getSourceVerificationData(hashed_device_id, storage_reference);
        deviceToMedicalData[hashed_device_id][storage_reference] = MedicalMetadata(true, verified, time_generated, data_size, block.timestamp);

        emit MedicalMetadataLogging("medical metadata logged");

        return true;
    }

    function getMedicalMetadata(uint hashed_device_id, uint storage_reference) external view returns (bool source_verified, uint256 time_generated, uint data_size, uint256 time_logged) {
        MedicalMetadata memory medical_metadata = deviceToMedicalData[hashed_device_id][storage_reference];
        
        return (medical_metadata.source_verified, medical_metadata.time_generated, medical_metadata.data_size, medical_metadata.time_logged);
    }
}