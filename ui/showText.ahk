#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
#Include ui\Gdip_All.ahk

ShowIPText(leftMargin, topMargin, align, valign, iplist) {
    ipText := ""
    for ipindex, ip in iplist
    {
        ipText = %ipText%%ip%`n
    }
    Height = 500
    Width = 200
    pToken := Gdip_Startup()
    Text := ipText
    
    Options = x0 y0 %align% v%valign% cFFffffff r4 s20
    Font = Arial
    DetectHiddenWindows, On
    Gui, HelpText: -Caption +E0x20 +E0x80000 +LastFound +OwnDialogs +Owner +AlwaysOnTop
    Gui, HelpText: Show, NA
    hwnd1 := WinExist()
    hbm := CreateDIBSection(Width, Height)
    hdc := CreateCompatibleDC()
    obm := SelectObject(hdc, hbm)
   
    G := Gdip_GraphicsFromHDC(hdc)
    Gdip_SetSmoothingMode(G, 4)
    pBrush := Gdip_BrushCreateSolid(0xAA000000)
    Gdip_DeleteBrush(pBrush)
    Gdip_TextToGraphics(G, Text, Options, Font, Width, Height)
    UpdateLayeredWindow(hwnd1, hdc, leftMargin, topMargin, Width, Height)
    SelectObject(hdc, obm)
    DeleteObject(hbm)
    DeleteDC(hdc)
    Gdip_DeleteGraphics(G)
    Return
}