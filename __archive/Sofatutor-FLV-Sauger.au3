; ------------------------------------ Sofatutor-FLV-Sauger --------------------------------------
; - l�dt eine Liste von .flv-Dateien von Sofatutor richtig benannt herunter
; - kann genutzt werden, um mehrere Videos von Sofatutor auf die Festplatte zu saugen
; 
; - die Liste der Webseiten muss in der Datei "C:\websites.txt" abgelegt werden
; - ben�tigt die Programme FDM, Safari und NP++ an den im Quelltext vermerkten Dateipfaden
; - In NP++ muss ein Makro existieren, welches mit "Strg+Alt+M" die ganze aktuelle Zeile markiert
;
; - Author: Barn
; -------------------------------------------------------------------------------------------------
#Include <WinAPI.au3>
#Include <File.au3>
#Include <Array.au3>

; Pfad der Webseiten-Datei
Dim $file = "C:\websites.txt"

; Webseiten-Datei �ffnen und in $sites-Array schreiben
Dim $sites
If Not _FileReadToArray( $file,$sites) Then
	MsgBox(4096,"Fehler", $file & " konnte nicht gelesen werden.")
	Exit
EndIf

; Offset f�r Nummerierung
Dim $offset = Int(InputBox("Offset", "Nummerierungsoffset w�hlen."))

; FDM, NP++, Safari �ffnen
Run("G:\Free Download Manager\fdm.exe", "", @SW_MAXIMIZE)
WinWait ( "Free Download Manager")
Run("G:\Notepad++\notepad++", "", @SW_MAXIMIZE)
WinWait ( "[CLASS:Notepad++]")
Send("^n")
Run("G:\Safari\Safari.exe", "", @SW_MAXIMIZE)
WinWait ( "[CLASS:{1C03B488-D53B-4a81-97F8-754559640193}]")
Sleep(7000)

; manuelles Anmelden bei Sofatutor.com erm�glichen
ControlClick("[CLASS:{1C03B488-D53B-4a81-97F8-754559640193}]", "", "[CLASS:URLEdit; INSTANCE:1]")
Send("^a")
Send("https://www.sofatutor.com/login")
Send("{ENTER}")
Sleep(20000)

; alle Videos der Reihe nach runter laden
For $n = 1+$offset To $sites[0]

	; in Safari die neue Seite eingeben
	WinActivate("[CLASS:{1C03B488-D53B-4a81-97F8-754559640193}]")
	ControlClick("[CLASS:{1C03B488-D53B-4a81-97F8-754559640193}]", "", "[CLASS:URLEdit; INSTANCE:1]")
	Send("^a")
	Send($sites[$n])
	Send("{ENTER}")
	Sleep(8000)
	
	; Das Aktivit�ts-Fenster �ffnen und Inhalt kopieren
	Send("^!a")
	WinWait( "[CLASS:SafariOverlappedWindow]")
	Sleep(5000)
	ControlClick( "[CLASS:SafariOverlappedWindow]", "", "[CLASS:SysListView32; INSTANCE:1]")
	Send("^a")
	Send("^c")
	Send("!{F4}")

	; Aktivit�tsinhalt in NP++ einf�gen, .flv-URL suchen, kopieren
	WinActivate("[CLASS:Notepad++]")
	Sleep(1000)
	Send("^v")
	Send("^f")
	WinWait ("[CLASS:#32770]")
	Sleep(1000)
	Send(".flv")
	Send("{ENTER}")
	Sleep(1000)
	Send("{ESC}")
	Sleep(1000)
	Send("^!m")
	Send("^c")
	Send("^a")
	Send("{DEL}")

	; URL in FDM einladen
	WinActivate("[CLASS:Free Download Manager Main Window]")
	Sleep(1000)
	Send("^n")
	WinWaitActive("[CLASS:#32770]")
	Sleep(1000)
	
	; Name der Datei festlegen und runterladen
	ControlClick("[CLASS:#32770]", "", "[CLASS:Edit; INSTANCE:5]", "", 2)
	If $n < 10 Then Send("0")
	If $n < 100 Then Send("0")
	Send( $n)
	Send(" ")
	
	$addr = StringSplit($sites[$n], '/')
	Send( $addr[$addr[0]])
	Send(".flv")
	Send("{ENTER}")
	
	; Timeout
	Sleep(90000)
	
Next