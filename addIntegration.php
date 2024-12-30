<?php

include "functions.php";

$integration_request = new stdClass();
$integration_request->name = $_REQUEST["integration-name"];
$integration_request->capability = $_REQUEST["capability-id"];
$integration_request->user = $_REQUEST["username"];
$integration_request->password = $_REQUEST["password"];
$integration_request->token = $_REQUEST["token"];
$integration_request->successCriteria = $_REQUEST["success-criteria"];
$integration_request->hash = $_REQUEST["hash"];

invokeCrowsNestAPI(
    "/api/integrations",
    "POST",
    json_encode($integration_request)
);

header("Location: index.php");

?>
