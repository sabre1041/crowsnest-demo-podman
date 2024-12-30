<?php
include 'functions.php';

$domain = htmlspecialchars($_REQUEST['domain'], ENT_QUOTES, 'UTF-8');

$domain_request = new stdClass();
$domain_request->description = $domain;

invokeCrowsNestAPI("/api/domains", "POST", json_encode($domain_request));

header("Location: index.php");



?>
