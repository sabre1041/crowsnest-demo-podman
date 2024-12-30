<?php
$crowsnest_backend = getenv("CROWSNEST_BACKEND");
if (empty($crowsnest_backend)) {
    die("Error: 'CROWSNEST_BACKEND' Environment Variable Not Defined\n");
}

$greenFlagId = getGreenFlagId();

function putToggles($domain)
{
    global $greenFlagId;
    // $qq = "SELECT capability.id as id, capability.description as capability, flag.description as flag from capability,flag where domain_id = $domain and capability.flag_id = flag.id ORDER BY capability;";
    // $result = pg_query($qq) or die('Error message: ' . pg_last_error());
    $capabilityResult = invokeCrowsNestAPI(
        sprintf("/api/capabilities/domain/%s", $domainResult["id"])
    );
    foreach ($capabilities as $row) {
        if ($row["flag"] == $greenFlagId) {
            $checked = "checked";
        } else {
            $checked = "";
        }

        print '          	<li class="toggle-label"> 
<label class="pf-c-switch" for="' .
            $row["id"] .
            '">
  <input class="pf-c-switch__input" type="checkbox" name="capability-' .
            $row["id"] .
            '" id="' .
            $row["id"] .
            '" aria-labelledby="' .
            $row["id"] .
            '-on" ' .
            $checked .
            ' />
  <span class="pf-c-switch__toggle">
    <span class="pf-c-switch__toggle-icon">
      <i class="fas fa-check" aria-hidden="true"></i>
    </span>
  </span>
  <p class="toggle-capability">' .
            $row["capability"] .
            '</p>
  </li>
</label>';
    }
}

function putAperture($domainId)
{
    global $greenFlagId;
    # Get total number of capabilities
    // $capabilityCount = "select count(capability) as total, domain.description from capability,domain where domain.id = capability.domain_id and domain.id ='" . $domainId . "' group by domain.description;";
    // $capabilityCountTotal = pg_query($capabilityCount) or die('Error message: ' . pg_last_error());
    // $capabilityRow = pg_fetch_assoc($capabilityCountTotal);
    $capabilityRow = invokeCrowsNestAPI(
        sprintf("/api/capabilities/domain/%s/count", $domainId)
    );
    $totalCapabilities = $capabilityRow["count"];
    if ($totalCapabilities != 0) {
        // $capabilityName = $capabilityRow['description'];
        // $greenCount = "select count(flag_id) as totalgreen from capability where domain_id = '" . $domainId . "' and flag_id = '2'";
        // $greenTotal = pg_query($greenCount) or die('Error message: ' . pg_last_error());
        $greens = invokeCrowsNestAPI(
            sprintf(
                "/api/capabilities/domain/%s/flag/%s/count",
                $domainId,
                $greenFlagId
            )
        );
        $totalGreens = $greens["count"];

        $percentComplete = ($totalGreens / $totalCapabilities) * 100;

        # If greens < total, add red aperture
        if ($totalGreens < $totalCapabilities) {
            print "<img src=images/aperture-red-closed.png title='" .
                round($percentComplete) .
                "% Compliant'>";
        } else {
            print "<img src=images/aperture-green.png title='" .
                round($percentComplete) .
                "% Compliant'>";
        }
    } else {
        print "<img src=images/aperture-red-closed.png>";
    }
}

function putIcon($colour, $capability)
{
    global $greenFlagId;
    if ($colour == $greenFlagId) {
        print '
<span class="pf-c-icon pf-m-inline">
  <span class="pf-c-icon__content  pf-m-success">
    <i class="fas fa-check-circle" aria-hidden="true"></i>
  </span>
</span>&nbsp;<span>' .
            $capability .
            "</span><br><br>";
    } else {
        print '
<span class="pf-c-icon pf-m-inline">
  <span class="pf-c-icon__content pf-m-danger">
    <i class="fas fa-exclamation-circle" aria-hidden="true"></i>
  </span>
</span>&nbsp;<span>' .
            $capability .
            "</span><br><br>";
    }
}

function putProfileOptions()
{
    // $qq = "select id, name from profiles order by id asc";
    // $profilesCall = pg_query($qq) or die('Error message: ' . pg_last_error());
    $profiles = invokeCrowsNestAPI("/api/profiles");
    print '<div class="pf-c-toggle-group "><span class="profileTitle">Profiles:</span> ';
    foreach ($profiles as $row) {
        print '
<div class="pf-c-toggle-group__item">
    <button onclick="location.href=\'index.php?profile=' .
            $row["id"] .
            "&name=" .
            $row["name"] .
            '\'" class="pf-c-toggle-group__button" type="button">
      <span class="pf-c-toggle-group__text">' .
            $row["name"] .
            '</span>
    </button>
  </div>

';
    }
    print "</div>";
}

function getDomainsByProfile($profile)
{
    # First get the domain IDs based  on the profile
    // $domains = "select array_to_json(domains) as domain from profiles where id = '" . $profile . "'";
    // $selectedDomains = pg_query($domains) or die('Error message: ' . pg_last_error());
    // $selectedDomainsArray = pg_fetch_array($selectedDomains);
    // $selectedDomains = json_decode($selectedDomainsArray[0]);
    $profile_result = invokeCrowsNestAPI(sprintf("/api/profiles/%s", $profile));
    return $profile_result["domains"];
}

function getDomainsForProfiles()
{
    $domains = invokeCrowsNestAPI("/api/domains");
    foreach ($domains as $row) {
        print '    &nbsp<input type="checkbox" name="domain' .
            $row["id"] .
            '" value="' .
            $row["id"] .
            '" id="' .
            $row["id"] .
            '" >&nbsp' .
            $row["description"] .
            "<br>";
    }
}

function putToggleItems($profile)
{
    global $greenFlagId;
    # Get domains depending on Profile
    $chosenDomains = getDomainsByProfile($profile);

    foreach ($chosenDomains as $domainId) {
        #$selectDomains = "select * from domain ORDER by description;";
        $domain = invokeCrowsNestAPI(sprintf("/api/domains/%s", $domainId));

        if (!array_key_exists("code", $domain)) {
            #$domainResults = pg_query($selectDomains) or die('Error message: ' . pg_last_error());
            // $domainResults = pg_query($getDomains) or die('Error message: ' . pg_last_error());
            $i = 1;
            // while ($row = pg_fetch_assoc($domainResults)) {
            print '
<div class="pf-c-card pf-m-selectable-raised pf-m-rounded" id="card-' .
                $i .
                '">
          <div class="pf-c-card__title">
            <p id="card-' .
                $i .
                '-check-label">' .
                $domain["description"] .
                '</p>
            <div class="pf-c-content">
              <small>Key Capabilities</small>
            </div>
          </div>
          <div class="pf-c-card__body">
          <div class="pf-c-content">
          ';

            $capabilities = invokeCrowsNestAPI(
                sprintf("/api/capabilities/domain/%s", $domainId)
            );
            // $qq = "select capability.id as id, capability.description as capability, flag.description as flag from capability,flag where domain_id = '" . $domain['id'] . "' and capability.flag_id = flag.id ORDER by capability;";
            // $result = pg_query($qq) or die('Error message: ' . pg_last_error());
            foreach ($capabilities as $row) {
                if ($row["flag"] == $greenFlagId) {
                    $checked = "checked";
                } else {
                    $checked = "";
                }

                ## Check if there is an integration for the capability
                // $integrationQuery = "select count(*) as total from integrations where capability_id = '" . $row['id'] . "'";

                // $integrationResult = pg_query($integrationQuery) or die('Error message: ' . pg_last_error());
                $integrationResult = invokeCrowsNestAPI(
                    sprintf("/api/integrations/capability/%s/count", $row["id"])
                );
                $intCount = $integrationResult["count"];

                if ($intCount > 0) {
                    $toggleClass = "toggle-capability-integration";
                } else {
                    $toggleClass = "toggle-capability";
                }

                print '          	<div class="toggle-label"> 
<label class="pf-c-switch" for="' .
                    $row["id"] .
                    '">
  <input class="pf-c-switch__input" type="checkbox" name="capability-' .
                    $row["id"] .
                    '" id="' .
                    $row["id"] .
                    '" aria-labelledby="' .
                    $row["id"] .
                    '-on" ' .
                    $checked .
                    ' />
  <span class="pf-c-switch__toggle">
    <span class="pf-c-switch__toggle-icon">
      <i class="fas fa-check" aria-hidden="true"></i>
    </span>
  </span>
  <p class="' .
                    $toggleClass .
                    '">' .
                    $row["description"] .
                    '</p>
  </div>
</label>';
            }
            print '          	         	
         </div>
          </div>
        </div>';
            $i++;
        }
        // }
    }
}

function putAdminTabs()
{
    print '
  <input type="radio" name="tabset" id="tab1" aria-controls="dashboard" checked>
  <label for="tab1" >Dashboard</label>

  <input type="radio" name="tabset" id="tab2" aria-controls="toggle">
  <label for="tab2" >CrowsNest Toggle</label>
  <!-- Tab 2 -->
  <input type="radio" name="tabset" id="tab3" aria-controls="integrations">
  <label for="tab3" >Integrations</label>

  <input type="radio" name="tabset" id="tab4" aria-controls="capabilities">
  <label for="tab4" >Capabilities</label>

  <input type="radio" name="tabset" id="tab5" aria-controls="domains">
  <label for="tab5" >Domains</label>

  <input type="radio" name="tabset" id="tab6" aria-controls="profiles">
  <label for="tab6" >Profiles</label>
';
}

function putUserTabs()
{
    print '
  <input type="radio" name="tabset" id="tab1" aria-controls="dashboard" checked>
  <label for="tab1" >Dashboard</label>
';
}

function getGreenFlagId()
{
    $greenFlags = invokeCrowsNestAPI(
        sprintf("/api/flags?description=%s", urlencode("green"))
    );
    return $greenFlags[0]["id"];
}

function invokeCrowsNestAPI($path, $method = "GET", $data = null)
{
    global $crowsnest_backend;

    $url = sprintf("%s%s", $crowsnest_backend, $path);

    $curl_http_headers = ["Accept: application/json"];

    $curl = curl_init();

    curl_setopt($curl, CURLOPT_URL, $url);
    curl_setopt($curl, CURLOPT_CUSTOMREQUEST, $method);
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);

    if ($data) {
        array_push($curl_http_headers, "Content-Type: application/json");
        curl_setopt($curl, CURLOPT_POSTFIELDS, $data);
    }

    curl_setopt($curl, CURLOPT_HTTPHEADER, $curl_http_headers);

    $result = curl_exec($curl);

    $statusCode = curl_getinfo($curl, CURLINFO_HTTP_CODE);

    curl_close($curl);

    return json_decode($result, true);
}

?>
