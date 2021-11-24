#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
#Include getD2RConnections.ahk
#Include filterIPs.ahk
#Include ui\showText.ahk

if !FileExist(A_Scriptdir . "\settings.ini") {
    MsgBox, , Missing settings, Could not find settings.ini file
    ExitApp
}

IniRead, vertPadding, settings.ini, IPText, vertPadding, 20
IniRead, horizPadding, settings.ini, IPText, horizPadding, 20

; force admin
if not A_IsAdmin
  Run *RunAs "%A_ScriptFullPath%"


if (!windowTitle) {
    windowTitle := "Diablo II: Resurrected"
}
WinGet, D2RPID, pid, %windowTitle%

SetTimer, ShowIP, 1000

ShowIP:
    currentIPs := getD2RConnections(D2RPID)
    currentIPs := filterIPs(currentIPs)
    ;currentIps.push("12.552.342.43")

    position := "TOP_RIGHT"
    vertPadding := 20
    horizPadding := 20

    if (position == "TOP_RIGHT") {
        ; top right
        align = Right
        valign = Top
        ShowIPText(A_ScreenWidth - 200 - horizPadding, vertPadding, align, valign, currentIPs)
    } else if (position == "TOP_LEFT") {
        ; top left
        align = Left
        valign = Top
        ShowIPText(horizPadding, vertPadding, align, valign, currentIPs)
    } else if (position == "BOTTOM_LEFT") {
        ; bottom left
        align = Left
        valign = Bottom
        ShowIPText(horizPadding, A_ScreenHeight - vertPadding - 500, align, valign, currentIPs)
    } else if (position == "BOTTOM_RIGHT") {
        ; bottom right
        align = Right
        valign = Bottom
        ShowIPText(A_ScreenWidth - 200 - horizPadding, A_ScreenHeight - vertPadding - 500, align, valign, currentIPs)
    } else {
        WriteLog("Choose a location TOP_RIGHT, TOP_LEFT, BOTTOM_LEFT, BOTTOM_RIGHT")
    }
    Sleep, 5000
return

ExitApp






WriteLog(text) {
	FormatTime, vDate,, yyyy-MM-dd HH-mm-ss ;24-hour
	FileAppend, % vDate ": " text "`n", log.txt ; can provide a full path to write to another directory
}


; this will let us run netstat without comspec, comspec is so 2006
CmdRet(sCmd, callBackFuncObj := "", encoding := "CP0")
{
   static HANDLE_FLAG_INHERIT := 0x00000001, flags := HANDLE_FLAG_INHERIT
        , STARTF_USESTDHANDLES := 0x100, CREATE_NO_WINDOW := 0x08000000
   
   DllCall("CreatePipe", "PtrP", hPipeRead, "PtrP", hPipeWrite, "Ptr", 0, "UInt", 0)
   DllCall("SetHandleInformation", "Ptr", hPipeWrite, "UInt", flags, "UInt", HANDLE_FLAG_INHERIT)
   
   VarSetCapacity(STARTUPINFO , siSize :=    A_PtrSize*4 + 4*8 + A_PtrSize*5, 0)
   NumPut(siSize              , STARTUPINFO)
   NumPut(STARTF_USESTDHANDLES, STARTUPINFO, A_PtrSize*4 + 4*7)
   NumPut(hPipeWrite          , STARTUPINFO, A_PtrSize*4 + 4*8 + A_PtrSize*3)
   NumPut(hPipeWrite          , STARTUPINFO, A_PtrSize*4 + 4*8 + A_PtrSize*4)
   
   VarSetCapacity(PROCESS_INFORMATION, A_PtrSize*2 + 4*2, 0)

   if !DllCall("CreateProcess", "UInt", 0, "Str", sCmd, "UInt", 0, "UInt", 0, "UInt", true, "UInt", CREATE_NO_WINDOW
                              , "UInt", 0, "UInt", 0, "Ptr", &STARTUPINFO, "Ptr", &PROCESS_INFORMATION)
   {
      DllCall("CloseHandle", "Ptr", hPipeRead)
      DllCall("CloseHandle", "Ptr", hPipeWrite)
      throw Exception("CreateProcess is failed")
   }
   DllCall("CloseHandle", "Ptr", hPipeWrite)
   VarSetCapacity(sTemp, 4096), nSize := 0
   while DllCall("ReadFile", "Ptr", hPipeRead, "Ptr", &sTemp, "UInt", 4096, "UIntP", nSize, "UInt", 0) {
      sOutput .= stdOut := StrGet(&sTemp, nSize, encoding)
      ( callBackFuncObj && callBackFuncObj.Call(stdOut) )
   }
   DllCall("CloseHandle", "Ptr", NumGet(PROCESS_INFORMATION))
   DllCall("CloseHandle", "Ptr", NumGet(PROCESS_INFORMATION, A_PtrSize))
   DllCall("CloseHandle", "Ptr", hPipeRead)
   Return sOutput
}