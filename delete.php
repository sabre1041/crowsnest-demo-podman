<?php

include "functions.php";

$endpoint = htmlspecialchars($_REQUEST["endpoint"], ENT_QUOTES, "UTF-8");
$id = htmlspecialchars($_REQUEST["id"], ENT_QUOTES, "UTF-8");

invokeCrowsNestAPI(sprintf("/api/%s/%s", $endpoint, $id), "DELETE");

header("Location: index.php");

?>
