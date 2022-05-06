// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract QueryLogging {

    struct Query {
        bool exists;
        uint device_reference;
        string request_type;
        uint date_generated;
        uint time_generated;
        bool resolution;
    }

    event QueryLogged(uint query_reference, Query new_query);
    event UnknownQuery(uint query_reference, string error_message);

    mapping(uint => Query) private referenceToQuery;

    function logQueryRequest(uint query_reference, uint device_reference, string memory request_type, uint date_generated, uint time_generated) public {
        Query memory new_query = Query(true, device_reference, request_type, date_generated, time_generated, false);
        referenceToQuery[query_reference] = new_query;

        emit QueryLogged(query_reference, new_query);
    }

    modifier queryRequested(uint query_reference) { 
        if (!referenceToQuery[query_reference].exists == true) {
            emit UnknownQuery(query_reference, "query request wasn't made");
        }
        else {
            _;
        }
    }

    function logQueryResolution(uint query_reference, bool resolution) public queryRequested(query_reference) returns (bool _resolution){
        Query memory solved_query = referenceToQuery[query_reference];
        solved_query.resolution = resolution;
        referenceToQuery[query_reference] = solved_query;

        emit QueryLogged(query_reference, solved_query);

        return resolution;
    }

}