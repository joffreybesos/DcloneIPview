#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%



filterIPs(iplist) {
    
    FilteredIP := []
    FilteredIP.push("24.105.29.76") ; GLOBAL
    FilteredIP.push("34.117.122.6") ; GLOBAL
    FilteredIP.push("37.244.28.") ; EU
    FilteredIP.push("37.244.54.") ; EU
    FilteredIP.push("117.52.35.") ; ASIA
    FilteredIP.push("127.0.0.1") ; LOCAL
    FilteredIP.push("137.221.105.") ; NA
    FilteredIP.push("137.221.106.") ; NA
    filteredIps := []
    
    for ipindex, ip in iplist
    {
        found := 0
        for index, filterip in FilteredIP
        {
            if InStr(ip, filterip) {
                found := 1
            }
        }
        if (!found) {
            filteredIps.push(ip)
        }
    }
    return filteredIps
}