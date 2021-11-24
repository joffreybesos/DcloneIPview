#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
D2RPID := 5140

getD2RConnections(D2RPID) {

    ;if D2R PID is 5140, then this will run
    ;netstat /aon and get all valid IPs of established connections

    d2rconnections := []
    exeFile := "C:\Windows\System32\netstat.exe"
    RunArgs := "-a -o -n"
    AllConnections := CmdRet("""" . exeFile . """ " . RunArgs . """")
    Loop, parse, AllConnections, `n
    {
        if InStr(A_LoopField, D2RPID) {
            if InStr(A_LoopField, "ESTABLISHED") {
                if !InStr(A_LoopField, "127.0.0.1") {
                    RegExMatch(A_LoopField, "TCP\s+[\d\.]+:\d+\s+([\d\.]+):443\s+ESTABLISHED", IPvalue)
                    if (IPvalue1) {
                        d2rconnections.push(IPvalue1)
                    }
                }
            }
        }
    }
    return d2rconnections
}
