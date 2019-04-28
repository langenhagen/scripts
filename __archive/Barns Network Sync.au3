; -------------------------------------- Barns Network Sync ---------------------------------------
;
; - Synchronisiert den Schlepptop und seinen großen Bruder
;
;	- UNSOLVED:	- Programm nur ausser Scbnellstart oder Taskleiste nutzen! -> ALT+TAB !!!
;							- verkackt in einem zu vernachlässigendem Maße (in Ordnung bringen??!?)
;
; - wählt das Explorerfenster, welches als Nächstes getabt werden würde
; - Ordner werden jeweils mit ihrem Pendant auf dem anderen Rechner
;		bzw. mit dem Standardverzeichnis synchronisiert
; - greift auf die Datei syncrobarn.txt im Verzeichnis 'C:\' zu
; - beide Computer sollten natürlich an und connected sein...
; - Adressleiste muss im Explorer angezeigt werden, sie muss gesamte
;		Adresse anzeigen und sollte nicht vom Nutzer manuell manipuliert sein
; - Titelleiste im Explorer soll nur Ordnernamen und nich
;		ganzes Directory anzeigen!
; - genügend Speicherplatz im workdir sicherstellen!
;
; - syncrobarn.txt:
;		- zeilenweise Syntax: Syncroschlüssel ? Dateipfad
; 	- vorausgesetzte Namen:	- workdir:	Freigabeordner, auf dem gearbeitet wird;
;																				braucht auf beiden Rechnern r/w - Rechte
;														- standard: Standardpfad, in den synchronisiert werden soll
;		- eindeutige Keys benutzen!
;		- Keys müssen auch als Ordnernamen zulässig sein!
;		- für korrektes Verhalten sollten die gleichen Keys in den syncrobarn-Dateien
;			auf beiden Rechnern vorhanden sein!
;		- Keys sind nicht Case-Sensitive
; -------------------------------------------------------------------------------------------------

#include <File.au3>
#Include <Array.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

; Globale Vars ************************************************************************************
Dim $type = 1								; Typ: send = 1 / receive = 0
Dim $dirsLgnth							; Länge des Dirs Arrays
Dim $workdir								; Working Directory
Dim $standard								; Standardverzeichnis 'standard'
; *************************************************************************************************

isSingleScript() ; prüft, ob schon eine Programminstanz läuft und beended ggf.

IF NOT FileExists("C:\syncrobarn.txt") Then				; wenn syncrobarn.txt nich existiert
	MsgBox ( 16, "Barns Network Sync", "syncrobarn.txt nicht gefunden!")
	Exit
EndIf

Dim $fLines		; Datei nach Array
_FileReadToArray("C:\syncrobarn.txt", $fLines)
$dirsLgnth = $fLines[0] ; dirsLgnth setzen

Dim $dirs[$dirsLgnth][2] 		; PfadArray: 		[]: Keys []: Values ----------------------------------
For $i=0 To $dirsLgnth - 1
	$tmp = StringSplit($fLines[$i+1], " ? ", 3)
	$dirs[$i][0] = $tmp[0]
	$dirs[$i][1] = $tmp[1]
Next

Dim $w = _ArraySearch( $dirs, "workdir") 			; workdir, standard enthalten?!?
Dim $s = _ArraySearch( $dirs, "standard")
If $w = -1 OR $s = -1 Then
	MsgBox ( 16, "Barns Network Sync", "Schlüssel 'workdir' und/oder 'standard' nicht in syncrobarn.txt gefunden!")
	Exit
EndIf

$workdir = $dirs[$w][1] ; workdir  und standard getten!
$standard = $dirs[$s][1]

; GUI - Setup -------------------------------------------------------------------------------------
$frmMain = GUICreate("Barns Network Sync", 269, 103, -1, -1, BitOR($WS_SYSMENU,$WS_CAPTION,$WS_POPUP,$WS_POPUPWINDOW,$WS_BORDER,$WS_CLIPSIBLINGS))
$rdSend = GUICtrlCreateRadio("&Senden", 16, 8, 113, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$rdReceive = GUICtrlCreateRadio("&Empfangen", 16, 32, 113, 17)
$btnOk = GUICtrlCreateButton("&Ok", 104, 72, 73, 25, $BS_DEFPUSHBUTTON)
$btnCancel = GUICtrlCreateButton("&Abbrechen", 184, 72, 73, 25, 0)
GUISetState(@SW_SHOW)

; GUI - Schleife ----------------------------------------------------------------------------------
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $rdSend							; initial Ok Button freigeben
			$type = 1
		Case $rdReceive						; initial Ok Button freigeben
			$type = 0
		Case $btnCancel
			Exit
		Case $btnOk
			onOkClick( $type)
	EndSwitch
WEnd

; FUNKTIONEN ####################################################################################################################

; /////////////////////////////////////////////////////////////////// -----------------------------------------------------------
; // onOkClick
Func onOkClick( $type)
	GUISetState(@SW_HIDE)
	If $type = 1 Then	; zwischen der 'send'- oder 'receive'-Funktionalität wählen
		syncSend()						; send
	Else
		syncReceive()					; receive
	EndIf
	
	Exit	; ---ENDE ---
EndFunc

; /////////////////////////////////////////////////////////////////// -----------------------------------------------------------
; // syncSend() : Sendefunktionalität!
Func syncSend()
	getLastExplorerWin()

	Dim $jobAddr = ControlGetText("","", 41477) ; Namen und Adresse des betreffenden Ordners finden
	Dim $job = WinGetTitle ( "[ACTIVE]")
	
	If StringLen($jobAddr) <= 3 Then			; Wenn Pfad = Laufwerk: '\' aus Pfad cutten, Titel ändern
		$jobAddr = StringLeft( $jobAddr, 2)
		$job = StringLeft( $job, StringLen($job) - 5)
	EndIf
	
	scanAndLog($jobAddr, $job, StringLen($jobAddr)) ; erstellt Datei <job>_request mit allen Files aufgelistet
	
	If _ArraySearch( $dirs, $jobAddr, 0, 0, 0, 0, 1, 1) = -1 Then					; Job in syncrobarn?
		FileClose(FileOpen( $workdir & "\_sync\" & $job & "_ready_1.dat", 2 ))
	Else ; WENN in der Pfad in der syncrobarn steht!
		FileWrite( $workdir & "\_sync\" & $job & "_ready_1.dat", "look4" )
	EndIf
	
	syncA1( $job) ; Synchro der PCs!
	
	; SEND - PHASE2 #######################################################################
	
	Dim $wantedfiles
	Dim $num = 0 
	If _FileReadToArray( $workdir & "\_sync\" & $job & "_wanted", $wantedfiles) = 1 Then
		$num = $wantedfiles[0]
	EndIf
	
	For $i = 1 To $num
		$c = FileCopy( $jobAddr & $wantedfiles[$i], $workdir & "\_sync\" & $job & $wantedfiles[$i], 9)
		If $c = 0 Then FileWriteLine( $workdir & "\Barns NetSync ErrLog.txt", "Couldn't copy file into workdir: " & $wantedfiles[$i])
	Next
	
	FileMove( $workdir & "\_sync\" & $job & "_ready_0.dat" , $workdir & "\_sync\" & $job & "_ready_1.dat")

	If FileExists( $workdir & "\Barns NetSync ErrLog.txt") = 1 Then 								; ggf ErrLog anzeigen
		MsgBox( 64, "Barns Network Sync", "Folgendende Dateien konnten nicht ins Working Directory kopiert werden:")
		Run("notepad.exe")
		WinWaitActive("Unbenannt - Editor")
		Send("^o")
		;WinWaitActive("Öffnen")
		Send( $workdir & "\Barns NetSync ErrLog.txt{ENTER}")
	EndIf

EndFunc ; --- ENDE syncSend ---

; /////////////////////////////////////////////////////////////////// -----------------------------------------------------------
; // syncReceive() : Empfangsfunktionalität!
Func syncReceive()

	Dim $job			; entspricht $job in der Send Funktion
	Dim $wanted		; Handle der Wanted-File
	Dim $request		; Handle der Request-File
	Dim $base			; Basisverzeichnis (ausser syncrobarn)
	
	$job = syncB1() ; Synchro und Festlegung des Jobs für den Synchronizer!
	$wanted = FileOpen( $workdir & "\_sync\" & $job & "_wanted", 1)
	$request = FileOpen( $workdir & "\_sync\" & $job & "_request", 0)

	$std = ""
	
	If look4check( $job) = 1 Then				; baseverzeichnis wählen
		$i = _ArraySearch( $dirs, $job)
		If $i <> -1 Then
			$base = $dirs[$i][1]
		Else
			$std = "\" & $job
			$base = $standard
		EndIf
	Else
		$base = $standard
	EndIf
	
	While 1						; wanted-Datei schreiben
    $line = FileReadLine( $request)
    If @error = -1 Then ExitLoop
		If Not FileExists( $base & $line) Then FileWriteLine($wanted, $line)
	Wend
	
	FileClose( $wanted)
	FileClose( $request)

	syncB2( $job)

	$err = 0
	$wanted = FileOpen( $workdir & "\_sync\" & $job & "_wanted", 0)	
	While 1						; Dateien verschieben
    $line = FileReadLine( $wanted)
    If @error = -1 Then ExitLoop
		$c = FileMove( $workdir & "\_sync\" & $job & $line, $base & $std & $line, 8)
		If $c = 0 Then 
			FileWriteLine( $workdir & "\Barns NetSync ErrLog.txt", "Couldn't move file into target dir: " & $line)
			$err = 1
		EndIf
	Wend
	
	FileClose( $wanted)
	
	DirRemove ( $workdir & "\_sync", 1)

	If $err = 1 Then 								; ggf ErrLog anzeigen
		MsgBox( 64, "Barns Network Sync", "Folgendende Dateien konnten nicht ins Target Directory übertragen werden:")
		Run("notepad.exe")
		WinWaitActive("Unbenannt - Editor")
		Send("^o")
		;WinWaitActive("Öffnen")
		Send( $workdir & "\Barns NetSync ErrLog.txt{ENTER}")
	EndIf
	
EndFunc ; --- ENDE syncReceive() ---

; HILFSFUNKTIONEN ###############################################################################################################

; /////////////////////////////////////////////////////////////////// -----------------------------
; // getLastExplorerWin : aktiviert das zuletzt aktive ExplorerFenster
; // und zeigt es an (über ALT+TAB)
Func getLastExplorerWin()
	
	If Not WinExists("[CLASS:CabinetWClass]") Then			; is Explorerfenster existent?!?!?
		MsgBox ( 16, "Barns Network Sync", "Kein Explorerfenster offen, welches synchronisiert werden kann!")
		Exit
	EndIf

	Send("{ALT down}")		; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	Send("{TAB}")
	Send("{ALT up}")
	
	Local $n = 0
	While Not WinActive("[CLASS:CabinetWClass]")
		
		Send("{ALT down}")
		For $i = 0 To $n
			Send("{TAB}")
		Next
		Send("{ALT up}")
	
		$n +=1
	WEnd
	
EndFunc

; /////////////////////////////////////////////////////////////////// -----------------------------
; // scanAndLog :	scannt das Directory rekursiv nach allen Dateien
; // und schreibt jede File in die files-Datei
Func scanAndLog($SourceFolder, $job, $initlen)
	Local $Search
	Local $File
	Local $FileAttributes
	Local $FullFilePath
	Local $request ; Handle welcher die Request-Datei symbolisiert
	
	$Search = FileFindFirstFile($SourceFolder & "\*.*")
	$request = FileOpen( $workdir & "\_sync\" & $job & "_request", 9)
	
	While 1
		If $Search = -1 Then ExitLoop
		
		$File = FileFindNextFile($Search)
		If @error Then ExitLoop
		
		$FullFilePath = $SourceFolder & "\" & $File
		$FileAttributes = FileGetAttrib($FullFilePath)
		
		If StringInStr($FileAttributes,"D") Then
			scanAndLog($FullFilePath, $job, $initlen)
		Else
			FileWriteLine( $request, StringRight( $FullFilePath, StringLen($FullFilePath) - $initlen))
		EndIf
	WEnd
	
	FileClose($request)
	FileClose($Search)
EndFunc

; /////////////////////////////////////////////////////////////////// -----------------------------
; // look4check() : Checkt, ob der angeg. Job einen
; // 'look4'-Eintrag hat; Return: 1: ja, 0: nein
Func look4check( $job)

	FileReadLine($workdir & "_sync\" & $job & "_ready_0.dat")
	If @error = -1 Then
		return 0
	Else
		return 1
	EndIf

EndFunc

; /////////////////////////////////////////////////////////////////// -----------------------------
; // syncA1() : Passt erstes Rendezvous zwischen den
; // Programminstanzen ab, Version für Sender;)
Func syncA1( $job)

	While FileExists( $workdir & "\_sync\" & $job & "_ready_0.dat" ) = 0
		Sleep(500)
	WEnd
	While FileExists( $workdir & "\_sync\" & $job & "_ready_1.dat" ) = 0
		Sleep(1000)
	WEnd
	FileMove ( $workdir & "\_sync\" & $job & "_ready_1.dat", $workdir & "\_sync\" & $job & "_ready_0.dat")
	Sleep(3000)
EndFunc

; /////////////////////////////////////////////////////////////////// -----------------------------
; // syncB1() : Passt erstes Rendezvous zwischen den
; // Programminstanzen ab, Version für Receiver;)
Func syncB1()

	Dim $filename
	Dim $job				; Name des Jobs
	
	While 1
		$fList = _FileListToArray( $workdir & "\_sync\", "*", 1)
		For $i=1 To $fList[0]
				$filename = $fList[$i]
				If StringRight($filename, 12) = "_ready_1.dat" Then ExitLoop 2
		Next
		Sleep(2000)
	WEnd
	$job = StringLeft( $filename, StringLen( $filename) - 12)
	FileMove ( $workdir & "\_sync\" & $filename, $workdir & "\_sync\" & $job & "_ready_0.dat")
	
	Sleep(3000)
	Return $job
	
EndFunc

; /////////////////////////////////////////////////////////////////// -----------------------------
; // syncB2() : Passt zweites Rendezvous zwischen den
; // Programminstanzen ab, Version für Receiver;)
Func syncB2( $job)
	FileMove ( $workdir & "\_sync\" & $job & "_ready_0.dat", $workdir & "\_sync\" & $job & "_ready_1.dat")

	While Not FileExists( $workdir & "\_sync\" & $job & "_ready_0.dat" )
		Sleep(1000)
	WEnd
	While Not FileExists( $workdir & "\_sync\" & $job & "_ready_1.dat" )
		Sleep(1000)
	WEnd
EndFunC

; /////////////////////////////////////////////////////////////////// -----------------------------
; // isSingleScript() : Überprüft, ob dies das einzige
; // Syncrobarn Script ist, welches momentan läuft

Func isSingleScript()
	$winName = "Barns Network Sync"
	If WinExists($winName) Then
		MsgBox(48,"Barns Network Sync", "Es läuft bereits eine Instanz dieses Programmes!")
		Exit
	EndIf
	AutoItWinSetTitle($winName)
 EndFunc