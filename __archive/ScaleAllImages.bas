' Scales all images in an MS Office Word Script

Attribute VB_Name = "Module1"
Sub ScaleAllImages()

    Dim i As Long
    With ActiveDocument
        For i = 1 To .InlineShapes.Count
            With .InlineShapes(i)
                .ScaleHeight = 50
                .ScaleWidth = 50
            End With
        Next i
    End With

End Sub
