<?php

include "functions.php";

$profile = htmlspecialchars($_REQUEST["profileName"], ENT_QUOTES, "UTF-8");

$domains = [];
foreach ($_GET as $name => $options) {
    if ($options == "1") {
        $domainNumber = substr($name, 6);
        print $domainNumber . "<br>";
        array_push($domains, intval($domainNumber));
    }
}
$profile_request = new stdClass();
$profile_request->name = $profile;
$profile_request->domains = $domains;

invokeCrowsNestAPI("/api/profiles", "POST", json_encode($profile_request));

header("Location: index.php");

?>
