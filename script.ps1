Param(
    [string]$website, 
    [array]$urls = @(
		"http://$website", 
		"https://$website"
	)

)

Function WebRequest {

 # Stop the script if the parameter isn't provided, and write the output to the log.txt file

    if ( !$website ) {
        echo 'Not correct. Add this part after the name of the script: "... mail.ru'
        add-content -path "/var/log/web_checks/script.log" -value "A website's URL isn't added"
        exit 1
    }

 # Check the availability of $website and and write the output to the log.txt file
	
	Try {
    	$response = iwr -uri $website -TimeoutSec 10 -ErrorAction Stop
		echo "The request is True"
		add-content -path "/var/log/web_checks/script.log" -value "The request is True"
			
		if ($response.StatusCode -eq 200) {
			add-content -path "/var/log/web_checks/script.log" -value "The status code of the website is: $($response.StatusCode)"
			echo "The status code of the website is: $($response.StatusCode)"
		} else {
			add-content -path "/var/log/web_checks/script.log" -value "The website is not available: $($response.StatusCode)"
			echo "The website is not available: $($response.StatusCode)"
		exit 1
		}
	}

	Catch {
    	echo "The request is False"
    	add-content -path "/var/log/web_checks/script.log" -value "The request is False"
		exit 1
	}

 # Check the availability three times for ports 80 and 443, and and write the output to the log.txt file

	foreach ($x in $urls) {

    for ($a = 1; $a -le 3; $a++) {
		$response2 = iwr $x
        if ($response2.StatusCode -eq 200) {
            echo "$x StatusCode: $($response2.StatusCode) and StatusDescription: $($response2.StatusDescription)"
			add-content -path "/var/log/web_checks/script.log" -value "$x StatusCode: $($response2.StatusCode) and StatusDescription: $($response2.StatusDescription)"
        }
        else {
            echo "$x StatusCode: $($response2.StatusCode) and StatusDescription: $($response2.StatusDescription)"
            add-content -path "/var/log/web_checks/script.log" -value "$x StatusCode: $($response2.StatusCode) and StatusDescription: $($response2.StatusDescription)"
            exit 1
        }
    }
}
		
}

WebRequest

