#Include <WinAPI.au3>
While 1
For $y = 0 To 9 Step 1
	For $x = 1 To 25 Step 0.1
	_WinAPI_Beep( Sin($x)*1000 + 1032, 10-$y)
	Next
	_WinAPI_Beep( 1900, 80)
	Sleep(30)
	_WinAPI_Beep( 1900, 80)
	Sleep(50)
	_WinAPI_Beep( 1900, 80)
	Sleep(30)
	_WinAPI_Beep( 1900, 80)
	Sleep(30)
	For $x = 1 To 25 Step 0.1
	_WinAPI_Beep( Sin($x)*1000 + 1032, 10-$y)
	Next
Next
WEnd