'-----------------------------------------------------------------------------------------------------------------------
' raylib bindings for QB64-PE
' Copyright (c) 2023 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

'-----------------------------------------------------------------------------------------------------------------------
' HEADER FILES
'-----------------------------------------------------------------------------------------------------------------------
'$INCLUDE:'raylib.bi'
'-----------------------------------------------------------------------------------------------------------------------

$If RAYLIB_BAS = UNDEFINED Then
    $Let RAYLIB_BAS = TRUE

    $Checking:Off

    '-------------------------------------------------------------------------------------------------------------------
    ' FUNCTIONS & SUBROUTINES
    '-------------------------------------------------------------------------------------------------------------------
    ' Returns a BASIC string (bstring) from a NULL terminated C string (cstring) pointer
    Function CStrPtrToBStr$ (cStrPtr As _Unsigned _Offset)
        If cStrPtr <> NULL Then
            Dim bufferSize As _Unsigned _Offset: bufferSize = StrLen(cStrPtr)

            If bufferSize > NULL Then
                Dim buffer As String: buffer = String$(bufferSize + 1, NULL)

                StrNCpy _Offset(buffer), cStrPtr, bufferSize

                CStrPtrToBStr = Left$(buffer, bufferSize)
            End If
        End If
    End Function

    ' Returns a BASIC string (bstring) from NULL terminated C string (cstring)
    Function CStrToBStr$ (cStr As String)
        Dim zeroPos As Long: zeroPos = InStr(cStr, Chr$(NULL))
        If zeroPos > NULL Then CStrToBStr = Left$(cStr, zeroPos - 1) Else CStrToBStr = cStr
    End Function

    ' Just a convenience function for use when calling external libraries
    Function BStrToCStr$ (s As String)
        BStrToCStr = s + Chr$(NULL)
    End Function

    Sub InitWindow (W As Long, H As Long, caption As String)
        __InitWindow W, H, BStrToCStr(caption)
    End Sub

    Sub SetWindowTitle (caption As String)
        __SetWindowTitle BStrToCStr(caption)
    End Sub

    Sub SetClipboardText (text As String)
        __SetClipboardText BStrToCStr(text)
    End Sub

    Sub DrawText (text As String, posX As Long, posY As Long, fontSize As Long, clr As _Unsigned Long)
        __DrawText BStrToCStr(text), posX, posY, fontSize, clr
    End Sub

    Sub DrawTextEx (fnt As Font, text As String, position As Vector2, fontSize As Single, spacing As Single, tint As _Unsigned Long)
        __DrawTextEx fnt, BStrToCStr(text), position, fontSize, spacing, tint
    End Sub

    Sub DrawTextPro (fnt As Font, text As String, position As Vector2, origin As Vector2, rotation As Single, fontSize As Single, spacing As Single, tint As _Unsigned Long)
        __DrawTextPro fnt, BStrToCStr(text), position, origin, rotation, fontSize, spacing, tint
    End Sub

    Sub LoadMusicStream (fileName As String, retVal As Music)
        __LoadMusicStream BStrToCStr(fileName), retVal
    End Sub

    Sub LoadShader (vsFileName As String, fsFileName As String, retVal As Shader)
        __LoadShader BStrToCStr(vsFileName), BStrToCStr(fsFileName), retVal
    End Sub

    Sub LoadShaderFromMemory (vsCode As String, fsCode As String, retVal As Shader)
        __LoadShaderFromMemory BStrToCStr(vsCode), BStrToCStr(fsCode), retVal
    End Sub

    Function GetShaderLocation& (shdr As Shader, uniformName As String)
        GetShaderLocation = __GetShaderLocation(shdr, BStrToCStr(uniformName))
    End Function

    Function GetShaderLocationAttrib& (shdr As Shader, attribName As String)
        GetShaderLocationAttrib = __GetShaderLocationAttrib(shdr, BStrToCStr(attribName))
    End Function

    Sub TakeScreenshot (fileName As String)
        __TakeScreenshot BStrToCStr(fileName)
    End Sub

    Sub TraceLog (logLevel As Long, text As String)
        __TraceLog logLevel, BStrToCStr(text)
    End Sub

    Sub TraceLogString (logLevel As Long, text As String, s As String)
        __TraceLogString logLevel, BStrToCStr(text), BStrToCStr(s)
    End Sub

    Sub TraceLogLong (logLevel As Long, text As String, i As Long)
        __TraceLogLong logLevel, BStrToCStr(text), i
    End Sub

    Sub TraceLogSingle (logLevel As Long, text As String, f As Single)
        __TraceLogSingle logLevel, BStrToCStr(text), f
    End Sub

    Sub OpenURL (url As String)
        __OpenURL BStrToCStr(url)
    End Sub

    Function LoadFileData~%& (fileName As String, bytesRead As _Unsigned Long)
        LoadFileData = __LoadFileData(BStrToCStr(fileName), bytesRead)
    End Function

    Sub LoadImage (fileName As String, retVal As Image)
        __LoadImage BStrToCStr(fileName), retVal
    End Sub

    Sub LoadTexture (fileName As String, retVal As Texture)
        __LoadTexture BStrToCStr(fileName), retVal
    End Sub

    Sub LoadFont (fileName As String, retVal As Font)
        __LoadFont BStrToCStr(fileName), retVal
    End Sub

    Sub LoadFontEx (fileName As String, fontSize As Long, fontChars As _Unsigned _Offset, glyphCount As Long, retVal As Font)
        __LoadFontEx BStrToCStr(fileName), fontSize, fontChars, glyphCount, retVal
    End Sub

    Function TextFormatString$ (text As String, s As String)
        TextFormatString = CStrToBStr(__TextFormatString(BStrToCStr(text), BStrToCStr(s)))
    End Function

    Function TextFormatLong$ (text As String, i As Long)
        TextFormatLong = CStrToBStr(__TextFormatLong(BStrToCStr(text), i))
    End Function

    Function TextFormatSingle$ (text As String, f As Single)
        TextFormatSingle = CStrToBStr(__TextFormatSingle(BStrToCStr(text), f))
    End Function

    Function MeasureText (text As String, fontSize As Long)
        MeasureText = __MeasureText(BStrToCStr(text), fontSize)
    End Function

    Sub MeasureTextEx (fnt As Font, text As String, fontSize As Single, spacing As Single, retVal As Vector2)
        __MeasureTextEx fnt, BStrToCStr(text), fontSize, spacing, retVal
    End Sub
    '-------------------------------------------------------------------------------------------------------------------

    $Checking:On
$End If
'-----------------------------------------------------------------------------------------------------------------------
