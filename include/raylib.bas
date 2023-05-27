'-----------------------------------------------------------------------------------------------------------------------
' raylib bindings for QB64-PE
' Copyright (c) 2023 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

'$INCLUDE:'raylib.bi'

$If RAYLIB_BAS = UNDEFINED Then
    $Let RAYLIB_BAS = TRUE

    $Checking:Off

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

    ' TODO: QB64 does not like byval UTD in expressions. Sigh!
    'FUNCTION GetShaderLocation& (shdr AS Shader, uniformName AS STRING)
    '    GetShaderLocation = __GetShaderLocation(shdr, uniformName)
    'END FUNCTION

    'FUNCTION GetShaderLocationAttrib& (shdr AS Shader, attribName AS STRING)
    '    GetShaderLocationAttrib = __GetShaderLocationAttrib(shdr, BStrToCStr(attribName))
    'END FUNCTION

    $Checking:On

$End If
'-----------------------------------------------------------------------------------------------------------------------
