; ------------------------------------ Barns LidPowerController -----------------------------------
; - switcht zwischen den verschiedenen Aktionen beim Schließen der Laptopklappe,
; 	wobei sich die Zustände zyklisch wiederholen.
;	- läuft auf Windows XP-Laptops und enthält die Zustände:
;				
;				-	"Nichts unternehmen"
;				-	"In den Standbymodus wechseln"
;				- "In den Ruhezustand wechseln"
;
;		Achtung: 	-	Die Dateien DoNothing.reg, StandBy.reg und Hibernate.reg werden benötigt und der 
;								Dateipfad muss korrekt justiert sein!
;
;							-	Legt einen Wert in der Registry ab: 
;								HKCU\Control Panel\PowerCfg\GlobalPowerPolicy\barnLidPowerState
;
;--------------------------------------------------------------------------------------------------

$currentState = RegRead("HKCU\Control Panel\PowerCfg\GlobalPowerPolicy", "barnLidPowerState")

If( $currentState = "") Then
	SetLidPowerAction(0)
	RegWrite ( "HKCU\Control Panel\PowerCfg\GlobalPowerPolicy", "barnLidPowerState", "REG_SZ" , 0 )
	Sleep(1000)
	Exit
EndIf

$newState = Mod($currentState+1,3)
SetLidPowerAction( $newState)
RegWrite ( "HKCU\Control Panel\PowerCfg\GlobalPowerPolicy", "barnLidPowerState", "REG_SZ" , $newState )
Sleep(1000)

; Setzt die LidPowerAction anhand des neuen Zustands
Func SetLidPowerAction($action)
    
		If $action <> 0 AND $action <> 1 AND $action <> 2 Then Return
				
		If $action = 0 Then
			Run("REGEDIT /S ""G:\AutoIt\Barns LidPowerController\DoNothing.reg""")
			ToolTip( " ", 512, 300, "Laptopklappe: Nichts unternehmen", 0, 2)
		ElseIf $action = 1 Then
			Run("REGEDIT /S ""G:\AutoIt\Barns LidPowerController\StandBy.reg""") 
			ToolTip( " ", 512, 300, "Laptopklappe: In den Standby wechseln", 0, 2)
		Else
			Run("REGEDIT /S ""G:\AutoIt\Barns LidPowerController\Hibernate.reg""") 
			ToolTip( " ", 512, 300, "Laptopklappe: In den Ruhezustand wechseln", 0, 2)
		EndIf

		RunWait( "rundll32.exe powrprof.dll,LoadCurrentPwrScheme", @SystemDir, @SW_HIDE)

EndFunc