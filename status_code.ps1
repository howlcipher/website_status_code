
# read json configuration file
$configuration_json = Get-Content .\configuration.json | ConvertFrom-Json

# intranet sites
$intranet = $configuration_json.websites.windows_login

# local login sites
$local_login = $configuration_json.websites.no_login

# single site
$login_needed = $configuration_json.websites.login_needed  

# Loops through the websites and creditials if needed and prints the status code if able to connect to the website
function Get-StatusCode_Multiple { 
    param($websites, $cred_check)
    
    if ($cred_check -eq "true") {
        # Get the credentials from user for the website
        $cred = $host.ui.PromptForCredential("Need local account credentials", "Please enter your local username and password.", "", "")
        Foreach ($website in $websites) {
            Get-StatusCode $website.url $website.name $cred
        }
    }
    else {
        Get-all-status_codes_no_credentials $websites
    }
}

# Takes a website and checks for credentials, if needed, before printing status code
function Get-StatusCode_Single {
    param($websites, $cred_check)
    if ($cred_check -eq "true") {
        # Get the credentials from user for each website
        Foreach ($website in $websites) {
            $name = $website.name
            $cred = $host.ui.PromptForCredential("Need $name credentials", "Please enter your $name username and password.", "", "")
            Get-StatusCode $website.url $website.name $cred
        }
    }
    else {
        Get-all-status_codes_no_credentials $websites
    }
}

# Loops through the websites and gets the status code of each with no credentials
function Get-all-status_codes_no_credentials {
    param($websites)
    Foreach ($website in $websites) {
        $cred = "false"
        Get-StatusCode $website.url $website.name $cred
    }
}

# Function to print the status code of the website
function Get-StatusCode {
    param($url, $name, $cred)
    $url = "$url"

    if ($cred -eq "false") {
        try {
            No_credentials $url $name
        }
        catch {
            Incorrect_login
        }
    }
    else {
        try {
            credentials_login $url $name $cred
        }
        catch {
            Incorrect_login
        }
    }
}

# Login for the website failed
function Incorrect_login {
    "$name - Incorrect Login - Status Code -- $($_.Exception.Response.StatusCode.Value__)"
}

# Login for the website
function Credentials_login {
    param($url, $name, $cred)
    $req = Invoke-WebRequest -uri $url -Credential $cred   
    "$name - Status Code -- $($req.StatusCode)"
}

# No login for the website needed
function No_credentials {
    param($url, $name)
    $req = Invoke-WebRequest -uri $url   
    "$name - Status Code -- $($req.StatusCode)"
}

# Create status directory if does not exist
New-Item -ItemType Directory -Force -Path status

# Create status.txt file if doesn't exist
New-Item -path "status\" -name "status.txt" -type "file" -Force

$status_file = "status\status.txt"
$spacer = "----------------------------------------------------------------"

$spacer | Out-File -Append -FilePath $status_file -Encoding ASCII
Get-Date -DisplayHint Datetime | Out-File -Append -FilePath $status_file -Encoding ASCII
Get-StatusCode_Multiple $local_login False | Out-File -Append -FilePath $status_file -Encoding ASCII
Get-StatusCode_Multiple $intranet True | Out-File -Append -FilePath $status_file -Encoding ASCII
Get-StatusCode_Single $login_needed True | Out-File -Append -FilePath $status_file -Encoding ASCII
