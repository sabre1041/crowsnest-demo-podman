<?php

include 'functions.php';

$color = "";
foreach ($_REQUEST as $key => $val) {
    if ($val == "1") {
        $color = "green";
    } else {
        $color = "red";
    }
    $requestedFlag = invokeCrowsNestAPI(
        sprintf("/api/flags?description=%s", urlencode($color))
    );

    $flag_id = $requestedFlag[0]["id"];

    $explode = explode("-", $key);
    $capability = $explode[1];

    $capability_request = new stdClass();
    $capability_request->id = $capability;
    $capability_request->flag = intval($flag_id);

    invokeCrowsNestAPI(
        sprintf("/api/capabilities/%s", $capability),
        "PUT",
        json_encode($capability_request));

}

$refefer = $_SERVER["HTTP_REFERER"];
header("Location: $refefer");

?>
