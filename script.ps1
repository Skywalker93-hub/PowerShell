Param(
    [string]$website
)

# List of variables

$today = (Get-Date -Format 'dd-MM-yyyy HH:mm:ss')
$urls = @(
		"http://$website", 
		"https://$website")
$logfile = "./script.log"
$time = @()

Function Caltime {

    # Count the average response time for ports 80 and 443, and write the output to the log.txt file

	Param(
		[array]$time
	)

	if ( !$time ) {
		write-output 'Parameter is empty. The average response time for ports 80 and 443 cannot be calculated'
		add-content -path $logfile -value "${today}: Parameter is empty. The average response time for ports 80 and 443 cannot be calculated"
		exit 1
	}
	$avg_time = ($time / 6)
	write-output "${today}: The average response time for ports 80 and 443 is: $avg_time milliseconds"
	add-content -path $logfile -value "${today}: The average response time for ports 80 and 443 is: $avg_time milliseconds"

}

Function WebRequest {

# Stop the script if the parameter isn't provided, and write the output to the log.txt file

    if ( !$website ) {
        write-output 'Not correct. Add this part after the name of the script: "... mail.ru'
        add-content -path $logfile -value "${today}: a website's URL wasn't added"
        exit 1
    }
 
 # Check the availability of website and and write the output to the log.txt file
	
	Try {
    	$response = invoke-webrequest -uri $website -TimeoutSec 10 -ErrorAction Stop
		write-output "The request is True"
		add-content -path $logfile -value "${today}: the request is True"
			
		if ($response.StatusCode -eq 200) {
			add-content -path $logfile -value "${today}: the status code of the website is: $($response.StatusCode)"
			write-output "${today}: The status code of the website is: $($response.StatusCode)"
		} else {
			add-content -path $logfile -value "${today}: the website is not available: $($response.StatusCode)"
			write-output "${today}: The website is not available: $($response.StatusCode)"
		exit 1
		}
	}

	Catch {
    	write-output "The request is False"
    	add-content -path $logfile -value "${today}: the request is False"
		exit 1
	}

 # Create a stopwatch to measure the execution time of checking the ports availability  


 # Check the availability three times for ports 80 and 443, and and write the output to the log.txt file

	foreach ($x in $urls) {

    	for ($a = 1; $a -le 3; $a++) {
		
			$watch = [System.Diagnostics.Stopwatch]::StartNew()
		
			$response2 = invoke-webrequest -uri $x -TimeoutSec 10 -ErrorAction Stop 
			$watch.Stop()
			$time += $watch.Elapsed.TotalMilliseconds

        	if ($response2.StatusCode -eq 200) {
            	write-output "${today}: $x StatusCode: $($response2.StatusCode) and StatusDescription: $($response2.StatusDescription)"
				add-content -path $logfile -value "${today}: $x StatusCode: $($response2.StatusCode) and StatusDescription: $($response2.StatusDescription)"
        	}
       		else {
            	write-output "${today}: $x StatusCode: $($response2.StatusCode) and StatusDescription: $($response2.StatusDescription)"
            	add-content -path $logfile -value "${today}: $x StatusCode: $($response2.StatusCode) and StatusDescription: $($response2.StatusDescription)"
        	exit 1
       		}
    	}
    }

	#Write-Host $time 
	Caltime -time $time

}

 WebRequest


