// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract MedicalDataLogging {

    event MedicalMetadataLogged(uint device_reference, MedicalMetadata new_medical_data);

    struct MedicalMetadata {
        uint storage_reference;
        uint date_generated;
        uint time_generated;
        uint data_size;
    }

    mapping(uint => MedicalMetadata) private deviceToMedicalData;

    function logMedicalMetaData(uint device_reference, uint storage_reference, uint date_generated, uint time_generated, uint data_size) public {
        MedicalMetadata memory new_medical_data = MedicalMetadata(storage_reference, date_generated, time_generated, data_size);
        deviceToMedicalData[device_reference] = new_medical_data;

        emit MedicalMetadataLogged(device_reference, new_medical_data);
    }
}