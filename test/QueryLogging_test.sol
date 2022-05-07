// SPDX-License-Identifier: GPL-3.0
        
pragma solidity >=0.4.22 <0.9.0;

import "remix_tests.sol"; 
import "remix_accounts.sol";
import "../contracts/QueryLogging.sol";

contract QueryLoggingTest {

    QueryLogging query_logging;

    address device_address;
    uint hashed_device_id = 12345;
    uint query_reference = 54321;

    function beforeAll() public {
        query_logging = new QueryLogging();
        bool request_logged = query_logging.logQueryRequest(hashed_device_id, query_reference, "erasure", 1357924680);
        Assert.ok(request_logged == true, "fail: query request sucessfully logged");
    }

    function checkQueryDataStored() public {
        (, , bool resolution, , ) = query_logging.getQuery(hashed_device_id, query_reference);
        Assert.ok(resolution == false, "fail: query request sucessfully stored");
    }

    function checkAlreadyLogged() public {
        bool logged = query_logging.logQueryRequest(hashed_device_id, query_reference, "erasure", 1357924680);
        Assert.ok(logged == false, "fail: logging not redone");
    }

    function checkResolutionLogged() public {
        bool logged = query_logging.logQueryResolution(hashed_device_id, query_reference, true);
        Assert.ok(logged == true, "fail: resolution logged successfully");
    }

    function checkResolutionStored() public {
        query_logging.logQueryResolution(hashed_device_id, query_reference, true);
        (, , bool resolution, , ) = query_logging.getQuery(hashed_device_id, query_reference);
        Assert.ok(resolution == true, "fail: query resolution sucessfully stored");
    }

    function checkUnknownQuery() public {
        bool logged = query_logging.logQueryResolution(hashed_device_id, 5432, true);
        Assert.ok(logged == false, "fail: unknown query not logged");
    }
}    