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
    '-------------------------------------------------------------------------------------------------------------------

    $Checking:On
$End If
'-----------------------------------------------------------------------------------------------------------------------
