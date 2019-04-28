;Recursive File Lister

Dim $FolderName = "E:\Musik\"
Dim $FileCount = 0

ScanFolder($FolderName)

MsgBox(0,"Done","Folder Scan Complete.  Scanned " & $FileCount & " Files")

Func ScanFolder($SourceFolder)
	Local $Search
	Local $File
	Local $FileAttributes
	Local $FullFilePath
	
	$Search = FileFindFirstFile($SourceFolder & "\*.*")  

	While 1
		If $Search = -1 Then
			ExitLoop
		EndIf
		
		$File = FileFindNextFile($Search)
		If @error Then ExitLoop
		
		$FullFilePath = $SourceFolder & "\" & $File
		$FileAttributes = FileGetAttrib($FullFilePath)
		
		If StringInStr($FileAttributes,"D") Then
			ScanFolder($FullFilePath)
		Else
			LogFile($FullFilePath)
		EndIf

	WEnd

	FileClose($Search)
EndFunc

Func LogFile($FileName)
	FileWriteLine(@ScriptDir & "\FileList.txt",$FileName)
	$FileCount += 1
	ToolTip($FileName,0,0)
EndFunc
