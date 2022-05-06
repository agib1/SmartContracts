// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract MedicalDataLogging {

    event MedicalMetadataLogging(string message);

    struct MedicalMetadata {
        bool storage_reference_exists;
        uint256 time_generated;
        uint data_size;
        uint256 time_logged;
    }

    mapping(uint => mapping(uint => MedicalMetadata)) private deviceToMedicalData;

    modifier alreadyStored(uint hashed_device_id, uint storage_reference) { 
        if (deviceToMedicalData[hashed_device_id][storage_reference].storage_reference_exists == true) {
            emit MedicalMetadataLogging("medical metadata already stored");
        }
        else {
            _;
        }
    }

    function logMedicalMetadata(uint hashed_device_id, uint storage_reference, uint time_generated, uint data_size) public alreadyStored(hashed_device_id, storage_reference) returns (bool stored) {
        deviceToMedicalData[hashed_device_id][storage_reference] = MedicalMetadata(true, time_generated, data_size, block.timestamp);

        emit MedicalMetadataLogging("medical metadata logged");

        return true;
    }

    function getMedicalMetadata(uint hashed_device_id, uint storage_reference) external view returns (uint256 time_generated, uint data_size, uint256 time_logged) {
        MedicalMetadata memory medical_metadata = deviceToMedicalData[hashed_device_id][storage_reference];
        
        return (medical_metadata.time_generated, medical_metadata.data_size, medical_metadata.time_logged);
    }
}