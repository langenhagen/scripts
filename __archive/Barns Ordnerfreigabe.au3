; ------------------------------------ Barns Ordnerfreigabe ---------------------------------------
; - gibt bei Start verschiedene Verzeichnisse auf diesem Rechner frei und kann diese Freigabe wieder
;		deaktivieren
; - Dateifreigabe bezieht sich auf Lese/Schreibrechte
;
; - Achtung:	klappt bei NTFS-Verzeichnissen nur für das aktuell bestimmte, 
;							Unterverzeichnisse erhalten nur Leserechte!
;
; -------------------------------------------------------------------------------------------------

#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <NetShare.au3>

$frmMain = GUICreate("", 125, 51, 880, 480, BitOR($WS_MINIMIZEBOX,$WS_SYSMENU,$WS_DLGFRAME,$WS_POPUP,$WS_GROUP,$WS_CLIPSIBLINGS,$DS_SETFOREGROUND), BitOR($WS_EX_TOPMOST,$WS_EX_WINDOWEDGE))
$btnUnShare = GUICtrlCreateButton("Freigaben deaktivieren", 0, 0, 125, 49, 0)
GUISetState(@SW_SHOW)

$err = False	; Fehlerindikator

; VERZEICHNISSE FREIGEBEN *************************************************************************
$err = $err OR _Net_Share_ShareAdd("","Programme",$STYPE_DISKTREE ,"H:\")
$err = $err OR _Net_Share_ShareAdd("","Entwicklung",$STYPE_DISKTREE ,"G:\")
$err = $err OR _Net_Share_ShareAdd("","Studium",$STYPE_DISKTREE ,"F:\")
$err = $err OR _Net_Share_ShareAdd("","Barn",$STYPE_DISKTREE ,"D:\")


; FEHLER ABFANGEN *********************************************************************************
If( $err) Then
	Msgbox(0, "Fehler", "Fehler bei der Dateifreigabe. Die Freigaben werden zurückgesetzt.")
	; FREIGABEN LOESCHEN ****************************************************************************
	_Net_Share_ShareDel("","Programme")
	_Net_Share_ShareDel("","Entwicklung")
	_Net_Share_ShareDel("","Studium")
	_Net_Share_ShareDel("","Media")
	_Net_Share_ShareDel("","Barn")
	Exit
EndIf


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $btnUnShare
				; FREIGABEN LOESCHEN **********************************************************************
				_Net_Share_ShareDel("","Programme")
				_Net_Share_ShareDel("","Entwicklung")
				_Net_Share_ShareDel("","Studium")
				_Net_Share_ShareDel("","Media")
				_Net_Share_ShareDel("","Barn")
				_Net_Share_ShareDel("","Musik")
				Exit
	EndSwitch
WEnd