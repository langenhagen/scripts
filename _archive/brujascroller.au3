#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

$frmMain = GUICreate("", 125, 51, 882, 3, BitOR($WS_MINIMIZEBOX,$WS_SYSMENU,$WS_DLGFRAME,$WS_POPUP,$WS_GROUP,$WS_CLIPSIBLINGS,$DS_SETFOREGROUND), BitOR($WS_EX_TOPMOST,$WS_EX_WINDOWEDGE))
$btnPrev = GUICtrlCreateButton("Prev", 0, 0, 65, 49, 0)
$btnNext = GUICtrlCreateButton("Next", 64, 0, 57, 49, 0)
GUISetState(@SW_SHOW)


$num = InputBox("Brujascroller", "Suche nach welcher Zahl??")

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $btnPrev
				onPrevClick()
			Case $btnNext
				onNextClick()
	EndSwitch
WEnd

Func onNextClick()
				getLastFireFoxWin()
				bswitch(1)
EndFunc

Func onPrevClick()
				getLastFireFoxWin()
				bswitch(0)
EndFunc

Func bswitch( $val)

	Send("^l")
	Send("^a")
	Send("^a")
	Send("^a")
	Send("^c")
	Sleep(100)
	$dir = ClipGet()
	
	$pos = StringInStr ( $dir, $num, 1, -1)
	If $pos = 0 Then Exit
	
	$ft = StringLeft( $dir, $pos-1 )
	$lt = StringRight( $dir, StringLen($dir) - StringLen($ft) - StringLen($num))
	
	If $val = 0 Then 
		$num -=1
	Else
		$num +=1
	EndIf
	
	Send( $ft & $num & $lt & "{ENTER}")

EndFunc

; HILFSFUNKTIONEN ###############################################################################################################

; /////////////////////////////////////////////////////////////////// -----------------------------
; // getLastExplorerWin : aktiviert das zuletzt aktive ExplorerFenster
; // und zeigt es an (über ALT+TAB)
Func getLastFireFoxWin()

	Send("{ALT down}")		; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	Send("{TAB}")
	Send("{ALT up}")
	
	Local $n = 0
	While Not WinActive("[CLASS:MozillaUIWindowClass]")
		
		Send("{ALT down}")
		For $i = 0 To $n
			Send("{TAB}")
		Next
		Send("{ALT up}")
	
		$n +=1
	WEnd
	
	Return 1
	
EndFunc