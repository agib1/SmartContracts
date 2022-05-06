// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract QueryLogging {

    event QueryStatusLogging(string message);

    struct Query {
        bool exists;
        string request_type;
        uint256 time_generated;
        bool resolution;
        uint256 time_request_logged;
        uint256 time_resolution_logged;
    }

    mapping(uint => mapping(uint => Query)) private deviceToQuery;

    modifier queryExists(uint hashed_device_id, uint query_reference) { 
        if (deviceToQuery[hashed_device_id][query_reference].exists == true) {
            emit QueryStatusLogging("query already exists");
        }
        else {
            _;
        }
    }

    function logQueryRequest(uint hashed_device_id, uint query_reference, string memory request_type, uint time_generated) queryExists(hashed_device_id, query_reference) public returns (bool logged) {
        deviceToQuery[hashed_device_id][query_reference] = Query(true, request_type, time_generated, false, block.timestamp, 0);
        
        emit QueryStatusLogging("query request logged");

        return true;
    }

    modifier queryRequested(uint hashed_device_id, uint query_reference) { 
        if (deviceToQuery[hashed_device_id][query_reference].exists == false) {
            emit QueryStatusLogging("query request wasn't made");
        }
        else {
            _;
        }
    }

    function logQueryResolution(uint hashed_device_id, uint query_reference, bool resolution) public queryRequested(hashed_device_id, query_reference) returns (bool logged) {
        deviceToQuery[hashed_device_id][query_reference].resolution = resolution;
        deviceToQuery[hashed_device_id][query_reference].time_resolution_logged = block.timestamp;
   
        emit QueryStatusLogging("query resolution logged");

        return true;
    }

    function getQuery(uint hashed_device_id, uint storage_reference) external view returns (string memory request_type, uint256 time_generated, bool resolution, uint256 time_request_logged, uint256 time_resolution_logged) {
        Query memory query = deviceToQuery[hashed_device_id][storage_reference];
        
        return (query.request_type, query.time_generated, query.resolution, query.time_request_logged, query.time_resolution_logged);
    }
}