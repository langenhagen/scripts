$n = 0
While 1

WinWaitActive("", "besteht bereits.")
Send("n")
WinWaitActive("Grafik speichern", "")
Send("brujafriend_xy")
Send($n)
Send("__")
Send( Random ( 0, 999999,1))
While WinActive("Grafik speichern")
	Send("{ENTER}")
WEnd

$n = $n +1
WEnd