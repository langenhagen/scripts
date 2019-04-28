#include <Misc.au3>

; Presses the "right" key repeatedly with a certain amount of waiting between presses

$timeout = 5000

While true

	if( NOT _IsPressed(11)) Then
		Send("{RIGHT}")
	EndIf
	
	Sleep($timeout)
		
WEnd