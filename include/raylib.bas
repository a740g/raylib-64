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

    Sub InitWindow (w As Long, h As Long, title As String)
        __InitWindow w, h, BStrToCStr(title)
    End Sub

    Sub SetWindowIcons (imgs() As Image, count As Long)
        Dim lb As Long: lb = LBound(imgs)
        Dim ct As Long: ct = 1 + UBound(imgs) - lb: If ct > count Then ct = count
        __SetWindowIcons _Offset(imgs(lb)), ct
    End Sub

    Sub SetWindowTitle (title As String)
        __SetWindowTitle BStrToCStr(title)
    End Sub

    Sub SetClipboardText (text As String)
        __SetClipboardText BStrToCStr(text)
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
