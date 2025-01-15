#Persistent
#SingleInstance force
#NoEnv
SendMode Input

Menu, Tray, NoStandard
Menu, Tray, Add, Close, PLGClose
Menu, Tray, Icon, trayIcon.png

Gui, 1: +AlwaysOnTop +ToolWindow -Caption +E0x20
Gui, 1: Color, 202020
Gui, 1: Font, s16, cWhite, Consolas Bold3
Gui, 1: Add, Text, vDisplayText cWhite BackgroundTrans w480 h480
Gui, 1: +LastFound 
WinSet, Transparent, 225

GuiControl, 1:, DisplayText, Ilyu's Leveling Overlay
Gui, 1: Show, NoActivate w250 h50
boxX := 0
boxY := 0

filePath := "D:\SteamLibrary\steamapps\common\Path of Exile 2\logs\Client.txt"
csvPath := A_ScriptDir "\zonemapping.csv"
Process, Wait, PathOfExileSteam.exe

SetTimer, WatchFile, 2000, -100
return

WatchFile:
Critical, Off
Sleep, 10

FileRead, content, %filePath% 
Line := StrSplit(content, "`n")
Loop % Line.MaxIndex()
{
    Zeile := Line[Line.MaxIndex() - A_Index + 1]
    IfInString, Zeile, area
    {
        RegExMatch(Zeile, """([^""]+)""", match)
        if (match1)
        {
            foundString := match1
            break
        }
    }
}
if (foundString)
{
    FileRead, csvContent, %csvPath% 
    Loop, Parse, csvContent, `n, `r
    {
        columns := StrSplit(A_LoopField, ";")
        if (columns[1] = foundString)
        {
            varAct := columns[2]
            varZone := columns[3]
            break
        }
    }
    notesPath := A_ScriptDir "\Leveling\Acts\" varAct "\notes.txt"
    FileRead, notesContent, %notesPath%

    relevantSection := ""
    isRelevant := false
    Loop, Parse, notesContent, `n, `r
    {
        if RegExMatch(A_LoopField, "zone:\s*" varZone)
        {
            isRelevant := true
            continue
        }
        if (isRelevant && RegExMatch(A_LoopField, "zone:\s*"))
            break
        if (isRelevant)
            relevantSection .= A_LoopField "`n"
    }

    displayText := "Act " varAct " - " varZone "`n`n" relevantSection
    lineCount := 0
    Loop, Parse, displayText, `n
    {
        lineCount++
    }
    boxHeight := lineCount * 25

    GuiControl, 1:, DisplayText, % displayText
    Gui, 1: Show, NoActivate x%boxX% y%boxY% w500 h%boxHeight%, NA

}
return

+Esc:: ; Shift+Esc hotkey
GuiClose:
ExitApp

PLGClose:
ExitApp
