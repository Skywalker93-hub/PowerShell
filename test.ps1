$weight = @()
$today = (get-date -Format 'dd-MM-yyyy HH:mm:ss')

for ($a = 1; $a -le 3; $a++) { 
    $response = invoke-webrequest -uri mail.ru 
    $weight += $response.RawContentLength   
    add-content -path ./test.log -value "${today} $weight"}

    $avr = ($weight | measure-object -average).average 
    write-output "${today}: $avr bytes"





