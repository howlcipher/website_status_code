<h2>Summary:</h2>
<p>This is a command line tool that uses powershell to check the status codes of websites in the <b>configuration.json</b> file.  To run execute the <b>status_code.ps1</b> file.  The results are put into a file called <b>status.txt</b> and the output is shown in the command line as well. The PowerShell .ps1 can be run or the Go  .go file.  The Go file will offer an easier task if building an executable is desire.  See Build below for instructions on making an executable.<br><br>No passwords live in the files the user with be prompted to input during the running of the file where appropriate.
<br>
<h3>Build</h3>
To build an executable of the powershell command run <b>go build execute_powershell.go</b>.<br>
Go will need to be installed on the machine where the script is being built: <a href='https://go.dev/dl/'>Go Download</a>
</p>
<h3>Configuration</h3>
<p>By default the configuration.json file contains the following sites listed below in the json. There are three types of sites.  More sites can be added in each section or sites can be removed.  The structure is <b>the type of login</b>, <b>the name of the website</b> (can be anything) and <b>the url</b> (the location of the website).</p>
<ol>
    <li><b>windows_login:</b>  These require your windows username and password and permissions on the sites to get a code.  These are typically intranet sites.</li>
    <li><b>no_login:</b>  No login information is required.  Mostly public facing or general http/s websites.</li>
    <li><b>login_needed:</b> These are sites that have specific login information for themselves unique to other sites.</li>
</ol>

```json
{ "websites" : {
    "windows_login": [
        {"name" : "Fifsmail", 
         "url" : ["http://intranet/fifsmail"]},
         {"name" : "Admin Portal", 
         "url": ["http://intranet/adminportal/"]},
         {"name" : "Exposure Summary", 
         "url": ["http://intranet/fifssign/Apps/ExposureSummary"]},
         {"name" : "Welcome Dashboard", 
         "url": ["http://intranet/FIFSSign/Send/WelcomeCallDashboard"]},
         {"name" : "FIFS SIGN", 
         "url" : ["http://intranet/fifssign"]}  
    ],

    "no_login" : [
        {"name" : "Stellantis-fs.com", 
        "url" : ["http://www.stellantis-fs.com"]},
        {"name" : "FIFSG.com", 
        "url": ["https://www.fifsg.com/"]},
        {"name" : "FIFS API", 
        "url": ["https://api.fifsg.com/api/test/StatusCode_FromReturn"]}  
        ],
        
    "login_needed" : [
        {"name" : "SFS Taskrunner", 
        "url" : ["http://intranet/SFStaskrunner/hangfire"]}   
        ] 
    }                   
}
```