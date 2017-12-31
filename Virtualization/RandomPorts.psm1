<#
.SYNOPSIS
Generates a random port number in a (hopefully) open range.
.LINK
https://www.cymru.com/jtk/misc/ephemeralports.html
#>
Function Get-RandomPort
{
    return Get-Random -Max 32767 -Min 10001;
}

Function Test-PortInUse
{
    Param(
        [Parameter(Mandatory=$true)]
        [Int] $portToTest
    );
    $count = netstat -aon | find `":$portToTest `" /c;
    return [bool]($count -gt 0);
}

Function Get-RandomUsablePort
{
    Param(
        [Int] $maxTries = 100
    );
    $result = -1;
    $tries = 0;
    DO
    {
        $randomPort = Get-RandomPort;
        if (-Not (Test-PortInUse($randomPort)))
        {
            $result = $randomPort;
        }
        $tries += 1;
    } While (($result -lt 0) -and ($tries -lt $maxTries));
    return $result;
}
