<?php
include "functions.php";

$capability = htmlspecialchars($_REQUEST["capability"], ENT_QUOTES, "UTF-8");
$domainId = htmlspecialchars($_REQUEST["domainId"], ENT_QUOTES, "UTF-8");

$redFlags = invokeCrowsNestAPI(
    sprintf("/api/flags?description=%s", urlencode("red"))
);
$capability_request = new stdClass();
$capability_request->description = $capability;
$domain = new stdClass();
$domain->id = $domainId;
$capability_request->domain = $domain;
$capability_request->flag = $redFlags[0]["id"];

invokeCrowsNestAPI(
    "/api/capabilities",
    "POST",
    json_encode($capability_request)
);

header("Location: index.php");

?>
