; ------------------------------------ Barn's Programmstarter -------------------------------------
; - startet eine Reihe von Dateien / Programmen in sequenzieller Reihenfolge 
;		und minimiert die entsprechenden Programme
; - Programme werden aus der start-o-barn.txt im Verzeichnis C:\ gegettet
; - Programme und Anwendungen müssen vorhanden und entsprechend behandelbar sein!
; - minimiert ALLE momentan geöffneten Fenster!
;
; - start-o-barn.txt
; 	- zeilenweise Syntax: {PROGRAMMPFAD}\{PROGRAMMNAME}[.DATEIERWEITERUNG] ? {EINDEUTIGER TEIL DES TITELS DES FENSTERS}
;
; -------------------------------------------------------------------------------------------------

#include <File.au3>
#include <Array.au3>

AutoItSetOption ( "WinTitleMatchMode" , 2 )

IF NOT FileExists("C:\start-o-barn.txt") Then				; wenn start-o-barn.txt nich existiert
	MsgBox ( 16, "Barns Program Starter", "start-o-barn.txt nicht gefunden!!")
	Exit
EndIf

Dim $fLines		; Datei nach Array
_FileReadToArray("C:\start-o-barn.txt", $fLines)
$dirsLgnth = $fLines[0] ; dirsLgnth setzen

Dim $progs[$dirsLgnth][2] 		; PfadArray: 		[]: Keys []: Values ----------------------------------
For $i=0 To $dirsLgnth - 1
	$tmp = StringSplit($fLines[$i+1], " ? ", 3)
	$progs[$i][0] = $tmp[0]
	$progs[$i][1] = $tmp[1]
	
	Run( $progs[$i][0],"",@SW_HIDE) ; Programm starten
Next
	
	
For $i=0 To $dirsLgnth - 1 ; Minimieren
	WinWait( $progs[$i][1])									
	
	For $j=0 To 2
		WinSetState ( $progs[$i][1], "" , @SW_MINIMIZE )
		Sleep(300)
	Next
Next	