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
    ' Returns a BASIC string (bstring) from NULL terminated C string (cstring)
    Function ToBString$ (s As String)
        Dim zeroPos As Long: zeroPos = InStr(s, Chr$(NULL))
        If zeroPos > NULL Then ToBString = Left$(s, zeroPos - 1) Else ToBString = s
    End Function

    ' Just a convenience function for use when calling external libraries
    Function ToCString$ (s As String)
        ToCString = s + Chr$(NULL)
    End Function

    Sub InitWindow (W As Long, H As Long, caption As String)
        __InitWindow W, H, ToCString(caption)
    End Sub

    Sub SetWindowTitle (caption As String)
        __SetWindowTitle ToCString(caption)
    End Sub

    Sub SetClipboardText (text As String)
        __SetClipboardText ToCString(text)
    End Sub

    Sub DrawText (text As String, posX As Long, posY As Long, fontSize As Long, clr As _Unsigned Long)
        __DrawText ToCString(text), posX, posY, fontSize, clr
    End Sub

    Sub DrawTextEx (fnt As Font, text As String, position As Vector2, fontSize As Single, spacing As Single, tint As _Unsigned Long)
        __DrawTextEx fnt, ToCString(text), position, fontSize, spacing, tint
    End Sub

    Sub DrawTextPro (fnt As Font, text As String, position As Vector2, origin As Vector2, rotation As Single, fontSize As Single, spacing As Single, tint As _Unsigned Long)
        __DrawTextPro fnt, ToCString(text), position, origin, rotation, fontSize, spacing, tint
    End Sub

    Sub LoadMusicStream (fileName As String, retVal As Music)
        __LoadMusicStream ToCString(fileName), retVal
    End Sub

    Sub LoadShader (vsFileName As String, fsFileName As String, retVal As Shader)
        __LoadShader ToCString(vsFileName), ToCString(fsFileName), retVal
    End Sub

    Sub LoadShaderFromMemory (vsCode As String, fsCode As String, retVal As Shader)
        __LoadShaderFromMemory ToCString(vsCode), ToCString(fsCode), retVal
    End Sub

    Function GetShaderLocation& (shdr As Shader, uniformName As String)
        GetShaderLocation = __GetShaderLocation(shdr, ToCString(uniformName))
    End Function

    Function GetShaderLocationAttrib& (shdr As Shader, attribName As String)
        GetShaderLocationAttrib = __GetShaderLocationAttrib(shdr, ToCString(attribName))
    End Function

    Sub TakeScreenshot (fileName As String)
        __TakeScreenshot ToCString(fileName)
    End Sub

    Sub TraceLog (logLevel As Long, text As String)
        __TraceLog logLevel, ToCString(text)
    End Sub

    Sub TraceLogString (logLevel As Long, text As String, s As String)
        __TraceLogString logLevel, ToCString(text), ToCString(s)
    End Sub

    Sub TraceLogLong (logLevel As Long, text As String, i As Long)
        __TraceLogLong logLevel, ToCString(text), i
    End Sub

    Sub TraceLogSingle (logLevel As Long, text As String, f As Single)
        __TraceLogSingle logLevel, ToCString(text), f
    End Sub

    Sub OpenURL (url As String)
        __OpenURL ToCString(url)
    End Sub

    Function LoadFileData~%& (fileName As String, bytesRead As _Unsigned Long)
        LoadFileData = __LoadFileData(ToCString(fileName), bytesRead)
    End Function

    Sub LoadImage (fileName As String, retVal As Image)
        __LoadImage ToCString(fileName), retVal
    End Sub

    Sub LoadTexture (fileName As String, retVal As Texture)
        __LoadTexture ToCString(fileName), retVal
    End Sub

    Sub LoadFont (fileName As String, retVal As Font)
        __LoadFont ToCString(fileName), retVal
    End Sub

    Sub LoadFontEx (fileName As String, fontSize As Long, fontChars As _Unsigned _Offset, glyphCount As Long, retVal As Font)
        __LoadFontEx ToCString(fileName), fontSize, fontChars, glyphCount, retVal
    End Sub

    Sub LoadModel (fileName As String, retVal As Model)
        __LoadModel ToCString(fileName), retVal
    End Sub

    Function TextFormatString$ (text As String, s As String)
        TextFormatString = __TextFormatString(ToCString(text), ToCString(s))
    End Function

    Function TextFormatLong$ (text As String, i As Long)
        TextFormatLong = __TextFormatLong(ToCString(text), i)
    End Function

    Function TextFormatSingle$ (text As String, f As Single)
        TextFormatSingle = __TextFormatSingle(ToCString(text), f)
    End Function

    Function MeasureText& (text As String, fontSize As Long)
        MeasureText = __MeasureText(ToCString(text), fontSize)
    End Function

    Sub MeasureTextEx (fnt As Font, text As String, fontSize As Single, spacing As Single, retVal As Vector2)
        __MeasureTextEx fnt, ToCString(text), fontSize, spacing, retVal
    End Sub

    Function SaveFileText%% (fileName As String, text As String)
        SaveFileText = __SaveFileText(ToCString(fileName), ToCString(text))
    End Function

    Function FileExists%% (fileName As String)
        FileExists = __FileExists(ToCString(fileName))
    End Function

    Function DirectoryExists%% (dirPath As String)
        DirectoryExists = __DirectoryExists(ToCString(dirPath))
    End Function

    Function IsFileExtension%% (fileName As String, ext As String)
        IsFileExtension = __IsFileExtension(ToCString(fileName), ToCString(ext))
    End Function

    Function GetFileLength& (fileName As String)
        GetFileLength = __GetFileLength(ToCString(fileName))
    End Function

    Function GetFileExtension$ (fileName As String)
        GetFileExtension = __GetFileExtension(ToCString(fileName))
    End Function

    Function GetFileName$ (filePath As String)
        GetFileName = __GetFileName(ToCString(filePath))
    End Function

    Function GetFileNameWithoutExt$ (filePath As String)
        GetFileNameWithoutExt = __GetFileNameWithoutExt(ToCString(filePath))
    End Function

    Function GetDirectoryPath$ (filePath As String)
        GetDirectoryPath = __GetDirectoryPath(ToCString(filePath))
    End Function

    Function GetPrevDirectoryPath$ (dirPath As String)
        GetPrevDirectoryPath = __GetPrevDirectoryPath(ToCString(dirPath))
    End Function

    Function ChangeDirectory%% (dir As String)
        ChangeDirectory = __ChangeDirectory(ToCString(dir))
    End Function

    Function IsPathFile%% (path As String)
        IsPathFile = __IsPathFile(ToCString(path))
    End Function

    Sub LoadDirectoryFiles (dirPath As String, retVal As FilePathList)
        __LoadDirectoryFiles ToCString(dirPath), retVal
    End Sub

    Sub LoadDirectoryFilesEx (basePath As String, filter As String, scanSubdirs As _Byte, retVal As FilePathList)
        __LoadDirectoryFilesEx ToCString(basePath), ToCString(filter), scanSubdirs, retVal
    End Sub

    Function GetFileModTime& (fileName As String)
        GetFileModTime = __GetFileModTime(ToCString(fileName))
    End Function
    '-------------------------------------------------------------------------------------------------------------------

    $Checking:On
$End If
'-----------------------------------------------------------------------------------------------------------------------
