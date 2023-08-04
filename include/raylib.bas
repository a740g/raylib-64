'-----------------------------------------------------------------------------------------------------------------------
' raylib bindings for QB64-PE
' Copyright (c) 2023 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$IF RAYLIB_BAS = UNDEFINED THEN
    $LET RAYLIB_BAS = TRUE

    '$INCLUDE:'raylib.bi'

    $CHECKING:OFF

    ' Returns a BASIC string (bstring) from NULL terminated C string (cstring)
    FUNCTION ToBString$ (s AS STRING)
        DIM zeroPos AS LONG: zeroPos = INSTR(s, CHR$(NULL))
        IF zeroPos > NULL THEN ToBString = LEFT$(s, zeroPos - 1) ELSE ToBString = s
    END FUNCTION

    ' Just a convenience function for use when calling external libraries
    FUNCTION ToCString$ (s AS STRING)
        ToCString = s + CHR$(NULL)
    END FUNCTION

    SUB InitWindow (W AS LONG, H AS LONG, caption AS STRING)
        __InitWindow W, H, ToCString(caption)
    END SUB

    SUB SetWindowTitle (caption AS STRING)
        __SetWindowTitle ToCString(caption)
    END SUB

    SUB SetClipboardText (text AS STRING)
        __SetClipboardText ToCString(text)
    END SUB

    SUB DrawText (text AS STRING, posX AS LONG, posY AS LONG, fontSize AS LONG, clr AS _UNSIGNED LONG)
        __DrawText ToCString(text), posX, posY, fontSize, clr
    END SUB

    SUB DrawTextEx (fnt AS Font, text AS STRING, position AS Vector2, fontSize AS SINGLE, spacing AS SINGLE, tint AS _UNSIGNED LONG)
        __DrawTextEx fnt, ToCString(text), position, fontSize, spacing, tint
    END SUB

    SUB DrawTextPro (fnt AS Font, text AS STRING, position AS Vector2, origin AS Vector2, rotation AS SINGLE, fontSize AS SINGLE, spacing AS SINGLE, tint AS _UNSIGNED LONG)
        __DrawTextPro fnt, ToCString(text), position, origin, rotation, fontSize, spacing, tint
    END SUB

    SUB LoadMusicStream (fileName AS STRING, retVal AS Music)
        __LoadMusicStream ToCString(fileName), retVal
    END SUB

    SUB LoadShader (vsFileName AS STRING, fsFileName AS STRING, retVal AS Shader)
        __LoadShader ToCString(vsFileName), ToCString(fsFileName), retVal
    END SUB

    SUB LoadShaderFromMemory (vsCode AS STRING, fsCode AS STRING, retVal AS Shader)
        __LoadShaderFromMemory ToCString(vsCode), ToCString(fsCode), retVal
    END SUB

    FUNCTION GetShaderLocation& (shdr AS Shader, uniformName AS STRING)
        GetShaderLocation = __GetShaderLocation(shdr, ToCString(uniformName))
    END FUNCTION

    FUNCTION GetShaderLocationAttrib& (shdr AS Shader, attribName AS STRING)
        GetShaderLocationAttrib = __GetShaderLocationAttrib(shdr, ToCString(attribName))
    END FUNCTION

    SUB TakeScreenshot (fileName AS STRING)
        __TakeScreenshot ToCString(fileName)
    END SUB

    SUB TraceLog (logLevel AS LONG, text AS STRING)
        __TraceLog logLevel, ToCString(text)
    END SUB

    SUB TraceLogString (logLevel AS LONG, text AS STRING, s AS STRING)
        __TraceLogString logLevel, ToCString(text), ToCString(s)
    END SUB

    SUB TraceLogLong (logLevel AS LONG, text AS STRING, i AS LONG)
        __TraceLogLong logLevel, ToCString(text), i
    END SUB

    SUB TraceLogSingle (logLevel AS LONG, text AS STRING, f AS SINGLE)
        __TraceLogSingle logLevel, ToCString(text), f
    END SUB

    SUB OpenURL (url AS STRING)
        __OpenURL ToCString(url)
    END SUB

    FUNCTION LoadFileData~%& (fileName AS STRING, bytesRead AS _UNSIGNED LONG)
        LoadFileData = __LoadFileData(ToCString(fileName), bytesRead)
    END FUNCTION

    SUB LoadImage (fileName AS STRING, retVal AS Image)
        __LoadImage ToCString(fileName), retVal
    END SUB

    SUB LoadTexture (fileName AS STRING, retVal AS Texture)
        __LoadTexture ToCString(fileName), retVal
    END SUB

    SUB LoadFont (fileName AS STRING, retVal AS Font)
        __LoadFont ToCString(fileName), retVal
    END SUB

    SUB LoadFontEx (fileName AS STRING, fontSize AS LONG, fontChars AS _UNSIGNED _OFFSET, glyphCount AS LONG, retVal AS Font)
        __LoadFontEx ToCString(fileName), fontSize, fontChars, glyphCount, retVal
    END SUB

    SUB LoadModel (fileName AS STRING, retVal AS Model)
        __LoadModel ToCString(fileName), retVal
    END SUB

    FUNCTION TextFormatString$ (text AS STRING, s AS STRING)
        TextFormatString = __TextFormatString(ToCString(text), ToCString(s))
    END FUNCTION

    FUNCTION TextFormatLong$ (text AS STRING, i AS LONG)
        TextFormatLong = __TextFormatLong(ToCString(text), i)
    END FUNCTION

    FUNCTION TextFormatSingle$ (text AS STRING, f AS SINGLE)
        TextFormatSingle = __TextFormatSingle(ToCString(text), f)
    END FUNCTION

    FUNCTION MeasureText& (text AS STRING, fontSize AS LONG)
        MeasureText = __MeasureText(ToCString(text), fontSize)
    END FUNCTION

    SUB MeasureTextEx (fnt AS Font, text AS STRING, fontSize AS SINGLE, spacing AS SINGLE, retVal AS Vector2)
        __MeasureTextEx fnt, ToCString(text), fontSize, spacing, retVal
    END SUB

    FUNCTION SaveFileText%% (fileName AS STRING, text AS STRING)
        SaveFileText = __SaveFileText(ToCString(fileName), ToCString(text))
    END FUNCTION

    FUNCTION FileExists%% (fileName AS STRING)
        FileExists = __FileExists(ToCString(fileName))
    END FUNCTION

    FUNCTION DirectoryExists%% (dirPath AS STRING)
        DirectoryExists = __DirectoryExists(ToCString(dirPath))
    END FUNCTION

    FUNCTION IsFileExtension%% (fileName AS STRING, ext AS STRING)
        IsFileExtension = __IsFileExtension(ToCString(fileName), ToCString(ext))
    END FUNCTION

    FUNCTION GetFileLength& (fileName AS STRING)
        GetFileLength = __GetFileLength(ToCString(fileName))
    END FUNCTION

    FUNCTION GetFileExtension$ (fileName AS STRING)
        GetFileExtension = __GetFileExtension(ToCString(fileName))
    END FUNCTION

    FUNCTION GetFileName$ (filePath AS STRING)
        GetFileName = __GetFileName(ToCString(filePath))
    END FUNCTION

    FUNCTION GetFileNameWithoutExt$ (filePath AS STRING)
        GetFileNameWithoutExt = __GetFileNameWithoutExt(ToCString(filePath))
    END FUNCTION

    FUNCTION GetDirectoryPath$ (filePath AS STRING)
        GetDirectoryPath = __GetDirectoryPath(ToCString(filePath))
    END FUNCTION

    FUNCTION GetPrevDirectoryPath$ (dirPath AS STRING)
        GetPrevDirectoryPath = __GetPrevDirectoryPath(ToCString(dirPath))
    END FUNCTION

    FUNCTION ChangeDirectory%% (dir AS STRING)
        ChangeDirectory = __ChangeDirectory(ToCString(dir))
    END FUNCTION

    FUNCTION IsPathFile%% (path AS STRING)
        IsPathFile = __IsPathFile(ToCString(path))
    END FUNCTION

    SUB LoadDirectoryFiles (dirPath AS STRING, retVal AS FilePathList)
        __LoadDirectoryFiles ToCString(dirPath), retVal
    END SUB

    SUB LoadDirectoryFilesEx (basePath AS STRING, filter AS STRING, scanSubdirs AS _BYTE, retVal AS FilePathList)
        __LoadDirectoryFilesEx ToCString(basePath), ToCString(filter), scanSubdirs, retVal
    END SUB

    FUNCTION GetFileModTime& (fileName AS STRING)
        GetFileModTime = __GetFileModTime(ToCString(fileName))
    END FUNCTION

    $CHECKING:ON
$END IF
