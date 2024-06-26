'-----------------------------------------------------------------------------------------------------------------------
' raylib-64: raylib bindings for QB64-PE
' Copyright (c) 2024 Samuel Gomes
'
' This file was autogenerated by QB64-PE raylib bindings generator (bindgen.bas)
'-----------------------------------------------------------------------------------------------------------------------

$INCLUDEONCE

'$INCLUDE:'raylib.bi'

' Returns a BASIC string (bstring) from NULL terminated C string (cstring)
FUNCTION ToBString$ (s AS STRING)
    $CHECKING:OFF
    DIM zeroPos AS _UNSIGNED LONG: zeroPos = INSTR(s, STRING_NULL)
    IF zeroPos > 0 THEN ToBString = LEFT$(s, zeroPos - 1) ELSE ToBString = s
    $CHECKING:ON
END FUNCTION

' Just a convenience function for use when calling external libraries
FUNCTION ToCString$ (s AS STRING)
    $CHECKING:OFF
    ToCString = s + STRING_NULL
    $CHECKING:ON
END FUNCTION

' Initialize window and OpenGL context
SUB InitWindow (Rwidth AS LONG, Rheight AS LONG, Rtitle AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        SUB __InitWindow ALIAS "InitWindow" (BYVAL Rwidth AS LONG, BYVAL Rheight AS LONG, Rtitle AS STRING)
    END DECLARE

    __InitWindow Rwidth, Rheight, ToCString(Rtitle)
END SUB

' Set title for window (only PLATFORM_DESKTOP and PLATFORM_WEB)
SUB SetWindowTitle (Rtitle AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        SUB __SetWindowTitle ALIAS "SetWindowTitle" (Rtitle AS STRING)
    END DECLARE

    __SetWindowTitle ToCString(Rtitle)
END SUB

' Set clipboard text content
SUB SetClipboardText (text AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        SUB __SetClipboardText ALIAS "SetClipboardText" (text AS STRING)
    END DECLARE

    __SetClipboardText ToCString(text)
END SUB

' Load shader from files and bind default locations
SUB LoadShader (vsFileName AS STRING, fsFileName AS STRING, retVal AS Shader)
    DECLARE STATIC LIBRARY "raylib"
        SUB __LoadShader ALIAS "LoadShader" (vsFileName AS STRING, fsFileName AS STRING, retVal AS Shader)
    END DECLARE

    __LoadShader ToCString(vsFileName), ToCString(fsFileName), retVal
END SUB

' Load shader from code strings and bind default locations
SUB LoadShaderFromMemory (vsCode AS STRING, fsCode AS STRING, retVal AS Shader)
    DECLARE STATIC LIBRARY "raylib"
        SUB __LoadShaderFromMemory ALIAS "LoadShaderFromMemory" (vsCode AS STRING, fsCode AS STRING, retVal AS Shader)
    END DECLARE

    __LoadShaderFromMemory ToCString(vsCode), ToCString(fsCode), retVal
END SUB

' Get shader uniform location
FUNCTION GetShaderLocation& (shader AS Shader, uniformName AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __GetShaderLocation& ALIAS "GetShaderLocation" (shader AS Shader, uniformName AS STRING)
    END DECLARE

    GetShaderLocation = __GetShaderLocation(shader, ToCString(uniformName))
END FUNCTION

' Get shader attribute location
FUNCTION GetShaderLocationAttrib& (shader AS Shader, attribName AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __GetShaderLocationAttrib& ALIAS "GetShaderLocationAttrib" (shader AS Shader, attribName AS STRING)
    END DECLARE

    GetShaderLocationAttrib = __GetShaderLocationAttrib(shader, ToCString(attribName))
END FUNCTION

' Takes a screenshot of current screen (filename extension defines format)
SUB TakeScreenshot (fileName AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        SUB __TakeScreenshot ALIAS "TakeScreenshot" (fileName AS STRING)
    END DECLARE

    __TakeScreenshot ToCString(fileName)
END SUB

' Open URL with default system browser (if available)
SUB OpenURL (url AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        SUB __OpenURL ALIAS "OpenURL" (url AS STRING)
    END DECLARE

    __OpenURL ToCString(url)
END SUB

' Show trace log messages (LOG_DEBUG, LOG_INFO, LOG_WARNING, LOG_ERROR...)
SUB TraceLog (logLevel AS LONG, text AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        SUB __TraceLog ALIAS TraceLog (BYVAL logLevel AS LONG, text AS STRING)
    END DECLARE

    __TraceLog logLevel, ToCString(text)
END SUB

' Show trace log messages (LOG_DEBUG, LOG_INFO, LOG_WARNING, LOG_ERROR...)
SUB TraceLogString (logLevel AS LONG, text AS STRING, s AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        SUB __TraceLogString ALIAS TraceLog (BYVAL logLevel AS LONG, text AS STRING, s AS STRING)
    END DECLARE

    __TraceLogString logLevel, ToCString(text), ToCString(s)
END SUB

' Show trace log messages (LOG_DEBUG, LOG_INFO, LOG_WARNING, LOG_ERROR...)
SUB TraceLogLong (logLevel AS LONG, text AS STRING, i AS LONG)
    DECLARE STATIC LIBRARY "raylib"
        SUB __TraceLogLong ALIAS TraceLog (BYVAL logLevel AS LONG, text AS STRING, BYVAL i AS LONG)
    END DECLARE

    __TraceLogLong logLevel, ToCString(text), i
END SUB

' Show trace log messages (LOG_DEBUG, LOG_INFO, LOG_WARNING, LOG_ERROR...)
SUB TraceLogInteger64 (logLevel AS LONG, text AS STRING, i AS _INTEGER64)
    DECLARE STATIC LIBRARY "raylib"
        SUB __TraceLogInteger64 ALIAS TraceLog (BYVAL logLevel AS LONG, text AS STRING, BYVAL i AS _INTEGER64)
    END DECLARE

    __TraceLogInteger64 logLevel, ToCString(text), i
END SUB

' Show trace log messages (LOG_DEBUG, LOG_INFO, LOG_WARNING, LOG_ERROR...)
SUB TraceLogSingle (logLevel AS LONG, text AS STRING, f AS SINGLE)
    DECLARE STATIC LIBRARY "raylib"
        SUB __TraceLogSingle ALIAS TraceLog (BYVAL logLevel AS LONG, text AS STRING, BYVAL f AS SINGLE)
    END DECLARE

    __TraceLogSingle logLevel, ToCString(text), f
END SUB

' Show trace log messages (LOG_DEBUG, LOG_INFO, LOG_WARNING, LOG_ERROR...)
SUB TraceLogDouble (logLevel AS LONG, text AS STRING, d AS DOUBLE)
    DECLARE STATIC LIBRARY "raylib"
        SUB __TraceLogDouble ALIAS TraceLog (BYVAL logLevel AS LONG, text AS STRING, BYVAL d AS DOUBLE)
    END DECLARE

    __TraceLogDouble logLevel, ToCString(text), d
END SUB

' Load file data as byte array (read)
FUNCTION LoadFileData~%& (fileName AS STRING, dataSize AS LONG)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __LoadFileData~%& ALIAS "LoadFileData" (fileName AS STRING, dataSize AS LONG)
    END DECLARE

    LoadFileData = __LoadFileData(ToCString(fileName), dataSize)
END FUNCTION

' Save data to file from byte array (write), returns true on success
FUNCTION SaveFileData%% (fileName AS STRING, Rdata AS _UNSIGNED _OFFSET, dataSize AS LONG)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __SaveFileData%% ALIAS "SaveFileData" (fileName AS STRING, BYVAL Rdata AS _UNSIGNED _OFFSET, BYVAL dataSize AS LONG)
    END DECLARE

    SaveFileData = __SaveFileData(ToCString(fileName), Rdata, dataSize)
END FUNCTION

' Export data to code (.h), returns true on success
FUNCTION ExportDataAsCode%% (Rdata AS _UNSIGNED _OFFSET, dataSize AS LONG, fileName AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __ExportDataAsCode%% ALIAS "ExportDataAsCode" (BYVAL Rdata AS _UNSIGNED _OFFSET, BYVAL dataSize AS LONG, fileName AS STRING)
    END DECLARE

    ExportDataAsCode = __ExportDataAsCode(Rdata, dataSize, ToCString(fileName))
END FUNCTION

' Load text data from file (read), returns a '\\0' terminated string
FUNCTION LoadFileText$ (fileName AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __LoadFileText~%& ALIAS LoadFileText (fileName AS STRING)
        SUB __UnloadFileText ALIAS UnloadFileText (BYVAL text AS _UNSIGNED _OFFSET)
    END DECLARE

    DIM ptr AS _UNSIGNED _OFFSET: ptr = __LoadFileText(ToCString(fileName))
    IF ptr THEN
        LoadFileText = CStr(ptr)
        __UnloadFileText ptr
    END IF
END FUNCTION

' Save text data to file (write), string must be '\0' terminated, returns true on success
FUNCTION SaveFileText%% (fileName AS STRING, text AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __SaveFileText%% ALIAS "SaveFileText" (fileName AS STRING, text AS STRING)
    END DECLARE

    SaveFileText = __SaveFileText(ToCString(fileName), ToCString(text))
END FUNCTION

' Check if file exists
FUNCTION RFileExists%% (fileName AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __RFileExists%% ALIAS "RFileExists" (fileName AS STRING)
    END DECLARE

    RFileExists = __RFileExists(ToCString(fileName))
END FUNCTION

' Check if a directory path exists
FUNCTION DirectoryExists%% (dirPath AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __DirectoryExists%% ALIAS "DirectoryExists" (dirPath AS STRING)
    END DECLARE

    DirectoryExists = __DirectoryExists(ToCString(dirPath))
END FUNCTION

' Check file extension (including point: .png, .wav)
FUNCTION IsFileExtension%% (fileName AS STRING, ext AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __IsFileExtension%% ALIAS "IsFileExtension" (fileName AS STRING, ext AS STRING)
    END DECLARE

    IsFileExtension = __IsFileExtension(ToCString(fileName), ToCString(ext))
END FUNCTION

' Get file length in bytes (NOTE: GetFileSize() conflicts with windows.h)
FUNCTION GetFileLength& (fileName AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __GetFileLength& ALIAS "GetFileLength" (fileName AS STRING)
    END DECLARE

    GetFileLength = __GetFileLength(ToCString(fileName))
END FUNCTION

' Get pointer to extension for a filename string (includes dot: '.png')
FUNCTION GetFileExtension$ (fileName AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __GetFileExtension$ ALIAS "GetFileExtension" (fileName AS STRING)
    END DECLARE

    GetFileExtension = __GetFileExtension(ToCString(fileName))
END FUNCTION

' Get pointer to filename for a path string
FUNCTION GetFileName$ (filePath AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __GetFileName$ ALIAS "GetFileName" (filePath AS STRING)
    END DECLARE

    GetFileName = __GetFileName(ToCString(filePath))
END FUNCTION

' Get filename string without extension (uses static string)
FUNCTION GetFileNameWithoutExt$ (filePath AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __GetFileNameWithoutExt$ ALIAS "GetFileNameWithoutExt" (filePath AS STRING)
    END DECLARE

    GetFileNameWithoutExt = __GetFileNameWithoutExt(ToCString(filePath))
END FUNCTION

' Get full path for a given fileName with path (uses static string)
FUNCTION GetDirectoryPath$ (filePath AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __GetDirectoryPath$ ALIAS "GetDirectoryPath" (filePath AS STRING)
    END DECLARE

    GetDirectoryPath = __GetDirectoryPath(ToCString(filePath))
END FUNCTION

' Get previous directory path for a given path (uses static string)
FUNCTION GetPrevDirectoryPath$ (dirPath AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __GetPrevDirectoryPath$ ALIAS "GetPrevDirectoryPath" (dirPath AS STRING)
    END DECLARE

    GetPrevDirectoryPath = __GetPrevDirectoryPath(ToCString(dirPath))
END FUNCTION

' Change working directory, return true on success
FUNCTION ChangeDirectory%% (dir AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __ChangeDirectory%% ALIAS "ChangeDirectory" (dir AS STRING)
    END DECLARE

    ChangeDirectory = __ChangeDirectory(ToCString(dir))
END FUNCTION

' Check if a given path is a file or a directory
FUNCTION IsPathFile%% (path AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __IsPathFile%% ALIAS "IsPathFile" (path AS STRING)
    END DECLARE

    IsPathFile = __IsPathFile(ToCString(path))
END FUNCTION

' Load directory filepaths
SUB LoadDirectoryFiles (dirPath AS STRING, retVal AS FilePathList)
    DECLARE STATIC LIBRARY "raylib"
        SUB __LoadDirectoryFiles ALIAS "LoadDirectoryFiles" (dirPath AS STRING, retVal AS FilePathList)
    END DECLARE

    __LoadDirectoryFiles ToCString(dirPath), retVal
END SUB

' Load directory filepaths with extension filtering and recursive directory scan
SUB LoadDirectoryFilesEx (basePath AS STRING, filter AS STRING, scanSubdirs AS _BYTE, retVal AS FilePathList)
    DECLARE STATIC LIBRARY "raylib"
        SUB __LoadDirectoryFilesEx ALIAS "LoadDirectoryFilesEx" (basePath AS STRING, filter AS STRING, BYVAL scanSubdirs AS _BYTE, retVal AS FilePathList)
    END DECLARE

    __LoadDirectoryFilesEx ToCString(basePath), ToCString(filter), scanSubdirs, retVal
END SUB

' Get file modification time (last write time)
FUNCTION GetFileModTime& (fileName AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __GetFileModTime& ALIAS "GetFileModTime" (fileName AS STRING)
    END DECLARE

    GetFileModTime = __GetFileModTime(ToCString(fileName))
END FUNCTION

' Compress data (DEFLATE algorithm), memory must be MemFree()
FUNCTION CompressData$ (dat AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __CompressData~%& ALIAS CompressData (dat AS STRING, BYVAL dataSize AS LONG, compDataSize AS LONG)
    END DECLARE

    DIM outputSize AS LONG, outputPtr AS _UNSIGNED _OFFSET: outputPtr = __CompressData(dat, LEN(dat), outputSize)

    IF outputPtr THEN
        IF outputSize > 0 THEN
            DIM outputBuffer AS STRING: outputBuffer = STRING$(outputSize, NULL)

            CopyMemory _OFFSET(outputBuffer), outputPtr, outputSize

            CompressData = outputBuffer
        END IF

        RMemFree outputPtr
    END IF
END FUNCTION

' Decompress data (DEFLATE algorithm), memory must be MemFree()
FUNCTION DecompressData$ (compData AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __DecompressData~%& ALIAS DecompressData (compData AS STRING, BYVAL compDataSize AS LONG, dataSize AS LONG)
    END DECLARE

    DIM outputSize AS LONG, outputPtr AS _UNSIGNED _OFFSET: outputPtr = __DecompressData(compData, LEN(compData), outputSize)

    IF outputPtr THEN
        IF outputSize > 0 THEN
            DIM outputBuffer AS STRING: outputBuffer = STRING$(outputSize, NULL)

            CopyMemory _OFFSET(outputBuffer), outputPtr, outputSize

            DecompressData = outputBuffer
        END IF

        RMemFree outputPtr
    END IF
END FUNCTION

' Encode data to Base64 string, memory must be MemFree()
FUNCTION EncodeDataBase64$ (dat AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __EncodeDataBase64~%& ALIAS EncodeDataBase64 (dat AS STRING, BYVAL dataSize AS LONG, outputSize AS LONG)
    END DECLARE

    DIM outputSize AS LONG, outputPtr AS _UNSIGNED _OFFSET: outputPtr = __EncodeDataBase64(dat, LEN(dat), outputSize)

    IF outputPtr THEN
        IF outputSize > 0 THEN
            EncodeDataBase64 = CStr(outputPtr)
        END IF

        RMemFree outputPtr
    END IF
END FUNCTION

' Decode Base64 string data, memory must be MemFree()
FUNCTION DecodeDataBase64$ (dat AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __DecodeDataBase64~%& ALIAS DecodeDataBase64 (dat AS STRING, outputSize AS LONG)
    END DECLARE

    DIM outputSize AS LONG, outputPtr AS _UNSIGNED _OFFSET: outputPtr = __DecodeDataBase64(ToCString(dat), outputSize)

    IF outputPtr THEN
        IF outputSize > 0 THEN
            DIM outputBuffer AS STRING: outputBuffer = STRING$(outputSize, NULL)

            CopyMemory _OFFSET(outputBuffer), outputPtr, outputSize

            DecodeDataBase64 = outputBuffer
        END IF

        RMemFree outputPtr
    END IF
END FUNCTION

' Load automation events list from file, NULL for empty list, capacity = MAX_AUTOMATION_EVENTS
SUB LoadAutomationEventList (fileName AS STRING, retVal AS AutomationEventList)
    DECLARE STATIC LIBRARY "raylib"
        SUB __LoadAutomationEventList ALIAS "LoadAutomationEventList" (fileName AS STRING, retVal AS AutomationEventList)
    END DECLARE

    __LoadAutomationEventList ToCString(fileName), retVal
END SUB

' Export automation events list as text file
FUNCTION ExportAutomationEventList%% (Rlist AS AutomationEventList, fileName AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __ExportAutomationEventList%% ALIAS "ExportAutomationEventList" (Rlist AS AutomationEventList, fileName AS STRING)
    END DECLARE

    ExportAutomationEventList = __ExportAutomationEventList(Rlist, ToCString(fileName))
END FUNCTION

' Set internal gamepad mappings (SDL_GameControllerDB)
FUNCTION SetGamepadMappings& (mappings AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __SetGamepadMappings& ALIAS "SetGamepadMappings" (mappings AS STRING)
    END DECLARE

    SetGamepadMappings = __SetGamepadMappings(ToCString(mappings))
END FUNCTION

' Load image from file into CPU memory (RAM)
SUB RLoadImage (fileName AS STRING, retVal AS Image)
    DECLARE STATIC LIBRARY "raylib"
        SUB __RLoadImage ALIAS "RLoadImage" (fileName AS STRING, retVal AS Image)
    END DECLARE

    __RLoadImage ToCString(fileName), retVal
END SUB

' Load image from RAW file data
SUB LoadImageRaw (fileName AS STRING, Rwidth AS LONG, Rheight AS LONG, format AS LONG, headerSize AS LONG, retVal AS Image)
    DECLARE STATIC LIBRARY "raylib"
        SUB __LoadImageRaw ALIAS "LoadImageRaw" (fileName AS STRING, BYVAL Rwidth AS LONG, BYVAL Rheight AS LONG, BYVAL format AS LONG, BYVAL headerSize AS LONG, retVal AS Image)
    END DECLARE

    __LoadImageRaw ToCString(fileName), Rwidth, Rheight, format, headerSize, retVal
END SUB

' Load image from SVG file data or string with specified size
SUB LoadImageSvg (fileNameOrString AS STRING, Rwidth AS LONG, Rheight AS LONG, retVal AS Image)
    DECLARE STATIC LIBRARY "raylib"
        SUB __LoadImageSvg ALIAS "LoadImageSvg" (fileNameOrString AS STRING, BYVAL Rwidth AS LONG, BYVAL Rheight AS LONG, retVal AS Image)
    END DECLARE

    __LoadImageSvg ToCString(fileNameOrString), Rwidth, Rheight, retVal
END SUB

' Load image sequence from file (frames appended to image.data)
SUB LoadImageAnim (fileName AS STRING, frames AS LONG, retVal AS Image)
    DECLARE STATIC LIBRARY "raylib"
        SUB __LoadImageAnim ALIAS "LoadImageAnim" (fileName AS STRING, frames AS LONG, retVal AS Image)
    END DECLARE

    __LoadImageAnim ToCString(fileName), frames, retVal
END SUB

' Load image from memory buffer, fileType refers to extension: i.e. '.png'
SUB LoadImageFromMemory (fileType AS STRING, fileData AS _UNSIGNED _OFFSET, dataSize AS LONG, retVal AS Image)
    DECLARE STATIC LIBRARY "raylib"
        SUB __LoadImageFromMemory ALIAS "LoadImageFromMemory" (fileType AS STRING, BYVAL fileData AS _UNSIGNED _OFFSET, BYVAL dataSize AS LONG, retVal AS Image)
    END DECLARE

    __LoadImageFromMemory ToCString(fileType), fileData, dataSize, retVal
END SUB

' Export image data to file, returns true on success
FUNCTION ExportImage%% (image AS Image, fileName AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __ExportImage%% ALIAS "ExportImage" (image AS Image, fileName AS STRING)
    END DECLARE

    ExportImage = __ExportImage(image, ToCString(fileName))
END FUNCTION

' Export image to memory buffer
FUNCTION ExportImageToMemory~%& (image AS Image, fileType AS STRING, fileSize AS LONG)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __ExportImageToMemory~%& ALIAS "ExportImageToMemory" (image AS Image, fileType AS STRING, fileSize AS LONG)
    END DECLARE

    ExportImageToMemory = __ExportImageToMemory(image, ToCString(fileType), fileSize)
END FUNCTION

' Export image as code file defining an array of bytes, returns true on success
FUNCTION ExportImageAsCode%% (image AS Image, fileName AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __ExportImageAsCode%% ALIAS "ExportImageAsCode" (image AS Image, fileName AS STRING)
    END DECLARE

    ExportImageAsCode = __ExportImageAsCode(image, ToCString(fileName))
END FUNCTION

' Generate image: grayscale image from text data
SUB GenImageText (Rwidth AS LONG, Rheight AS LONG, text AS STRING, retVal AS Image)
    DECLARE STATIC LIBRARY "raylib"
        SUB __GenImageText ALIAS "GenImageText" (BYVAL Rwidth AS LONG, BYVAL Rheight AS LONG, text AS STRING, retVal AS Image)
    END DECLARE

    __GenImageText Rwidth, Rheight, ToCString(text), retVal
END SUB

' Create an image from text (default font)
SUB ImageText (text AS STRING, fontSize AS LONG, Rcolor AS _UNSIGNED LONG, retVal AS Image)
    DECLARE STATIC LIBRARY "raylib"
        SUB __ImageText ALIAS "ImageText" (text AS STRING, BYVAL fontSize AS LONG, BYVAL Rcolor AS _UNSIGNED LONG, retVal AS Image)
    END DECLARE

    __ImageText ToCString(text), fontSize, Rcolor, retVal
END SUB

' Create an image from text (custom sprite font)
SUB ImageTextEx (Rfont AS RFont, text AS STRING, fontSize AS SINGLE, spacing AS SINGLE, tint AS _UNSIGNED LONG, retVal AS Image)
    DECLARE STATIC LIBRARY "raylib"
        SUB __ImageTextEx ALIAS "ImageTextEx" (Rfont AS RFont, text AS STRING, BYVAL fontSize AS SINGLE, BYVAL spacing AS SINGLE, BYVAL tint AS _UNSIGNED LONG, retVal AS Image)
    END DECLARE

    __ImageTextEx Rfont, ToCString(text), fontSize, spacing, tint, retVal
END SUB

' Draw text (using default font) within an image (destination)
SUB ImageDrawText (dst AS Image, text AS STRING, posX AS LONG, posY AS LONG, fontSize AS LONG, Rcolor AS _UNSIGNED LONG)
    DECLARE STATIC LIBRARY "raylib"
        SUB __ImageDrawText ALIAS "ImageDrawText" (dst AS Image, text AS STRING, BYVAL posX AS LONG, BYVAL posY AS LONG, BYVAL fontSize AS LONG, BYVAL Rcolor AS _UNSIGNED LONG)
    END DECLARE

    __ImageDrawText dst, ToCString(text), posX, posY, fontSize, Rcolor
END SUB

' Draw text (custom sprite font) within an image (destination)
SUB ImageDrawTextEx (dst AS Image, Rfont AS RFont, text AS STRING, position AS Vector2, fontSize AS SINGLE, spacing AS SINGLE, tint AS _UNSIGNED LONG)
    DECLARE STATIC LIBRARY "raylib"
        SUB __ImageDrawTextEx ALIAS "ImageDrawTextEx" (dst AS Image, Rfont AS RFont, text AS STRING, position AS Vector2, BYVAL fontSize AS SINGLE, BYVAL spacing AS SINGLE, BYVAL tint AS _UNSIGNED LONG)
    END DECLARE

    __ImageDrawTextEx dst, Rfont, ToCString(text), position, fontSize, spacing, tint
END SUB

' Load texture from file into GPU memory (VRAM)
SUB LoadTexture (fileName AS STRING, retVal AS Texture)
    DECLARE STATIC LIBRARY "raylib"
        SUB __LoadTexture ALIAS "LoadTexture" (fileName AS STRING, retVal AS Texture)
    END DECLARE

    __LoadTexture ToCString(fileName), retVal
END SUB

' Load font from file into GPU memory (VRAM)
SUB RLoadFont (fileName AS STRING, retVal AS RFont)
    DECLARE STATIC LIBRARY "raylib"
        SUB __RLoadFont ALIAS "RLoadFont" (fileName AS STRING, retVal AS RFont)
    END DECLARE

    __RLoadFont ToCString(fileName), retVal
END SUB

' Load font from file with extended parameters, use NULL for codepoints and 0 for codepointCount to load the default character setFont
SUB LoadFontEx (fileName AS STRING, fontSize AS LONG, codepoints AS _UNSIGNED _OFFSET, codepointCount AS LONG, retVal AS RFont)
    DECLARE STATIC LIBRARY "raylib"
        SUB __LoadFontEx ALIAS "LoadFontEx" (fileName AS STRING, BYVAL fontSize AS LONG, BYVAL codepoints AS _UNSIGNED _OFFSET, BYVAL codepointCount AS LONG, retVal AS RFont)
    END DECLARE

    __LoadFontEx ToCString(fileName), fontSize, codepoints, codepointCount, retVal
END SUB

' Load font from memory buffer, fileType refers to extension: i.e. '.ttf'
SUB LoadFontFromMemory (fileType AS STRING, fileData AS _UNSIGNED _OFFSET, dataSize AS LONG, fontSize AS LONG, codepoints AS _UNSIGNED _OFFSET, codepointCount AS LONG, retVal AS RFont)
    DECLARE STATIC LIBRARY "raylib"
        SUB __LoadFontFromMemory ALIAS "LoadFontFromMemory" (fileType AS STRING, BYVAL fileData AS _UNSIGNED _OFFSET, BYVAL dataSize AS LONG, BYVAL fontSize AS LONG, BYVAL codepoints AS _UNSIGNED _OFFSET, BYVAL codepointCount AS LONG, retVal AS RFont)
    END DECLARE

    __LoadFontFromMemory ToCString(fileType), fileData, dataSize, fontSize, codepoints, codepointCount, retVal
END SUB

' Export font as code file, returns true on success
FUNCTION ExportFontAsCode%% (Rfont AS RFont, fileName AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __ExportFontAsCode%% ALIAS "ExportFontAsCode" (Rfont AS RFont, fileName AS STRING)
    END DECLARE

    ExportFontAsCode = __ExportFontAsCode(Rfont, ToCString(fileName))
END FUNCTION

' Draw text (using default font)
SUB DrawText (text AS STRING, posX AS LONG, posY AS LONG, fontSize AS LONG, Rcolor AS _UNSIGNED LONG)
    DECLARE STATIC LIBRARY "raylib"
        SUB __DrawText ALIAS "DrawText" (text AS STRING, BYVAL posX AS LONG, BYVAL posY AS LONG, BYVAL fontSize AS LONG, BYVAL Rcolor AS _UNSIGNED LONG)
    END DECLARE

    __DrawText ToCString(text), posX, posY, fontSize, Rcolor
END SUB

' Draw text using font and additional parameters
SUB DrawTextEx (Rfont AS RFont, text AS STRING, position AS Vector2, fontSize AS SINGLE, spacing AS SINGLE, tint AS _UNSIGNED LONG)
    DECLARE STATIC LIBRARY "raylib"
        SUB __DrawTextEx ALIAS "DrawTextEx" (Rfont AS RFont, text AS STRING, position AS Vector2, BYVAL fontSize AS SINGLE, BYVAL spacing AS SINGLE, BYVAL tint AS _UNSIGNED LONG)
    END DECLARE

    __DrawTextEx Rfont, ToCString(text), position, fontSize, spacing, tint
END SUB

' Draw text using Font and pro parameters (rotation)
SUB DrawTextPro (Rfont AS RFont, text AS STRING, position AS Vector2, origin AS Vector2, rotation AS SINGLE, fontSize AS SINGLE, spacing AS SINGLE, tint AS _UNSIGNED LONG)
    DECLARE STATIC LIBRARY "raylib"
        SUB __DrawTextPro ALIAS "DrawTextPro" (Rfont AS RFont, text AS STRING, position AS Vector2, origin AS Vector2, BYVAL rotation AS SINGLE, BYVAL fontSize AS SINGLE, BYVAL spacing AS SINGLE, BYVAL tint AS _UNSIGNED LONG)
    END DECLARE

    __DrawTextPro Rfont, ToCString(text), position, origin, rotation, fontSize, spacing, tint
END SUB

' Measure string width for default font
FUNCTION MeasureText& (text AS STRING, fontSize AS LONG)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __MeasureText& ALIAS "MeasureText" (text AS STRING, BYVAL fontSize AS LONG)
    END DECLARE

    MeasureText = __MeasureText(ToCString(text), fontSize)
END FUNCTION

' Measure string size for Font
SUB MeasureTextEx (Rfont AS RFont, text AS STRING, fontSize AS SINGLE, spacing AS SINGLE, retVal AS Vector2)
    DECLARE STATIC LIBRARY "raylib"
        SUB __MeasureTextEx ALIAS "MeasureTextEx" (Rfont AS RFont, text AS STRING, BYVAL fontSize AS SINGLE, BYVAL spacing AS SINGLE, retVal AS Vector2)
    END DECLARE

    __MeasureTextEx Rfont, ToCString(text), fontSize, spacing, retVal
END SUB

' Unload UTF-8 text encoded from codepoints array
SUB UnloadUTF8 (text AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        SUB __UnloadUTF8 ALIAS "UnloadUTF8" (text AS STRING)
    END DECLARE

    __UnloadUTF8 ToCString(text)
END SUB

' Load all codepoints from a UTF-8 text string, codepoints count returned by parameter
FUNCTION LoadCodepoints~%& (text AS STRING, count AS LONG)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __LoadCodepoints~%& ALIAS "LoadCodepoints" (text AS STRING, count AS LONG)
    END DECLARE

    LoadCodepoints = __LoadCodepoints(ToCString(text), count)
END FUNCTION

' Get total number of codepoints in a UTF-8 encoded string
FUNCTION GetCodepointCount& (text AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __GetCodepointCount& ALIAS "GetCodepointCount" (text AS STRING)
    END DECLARE

    GetCodepointCount = __GetCodepointCount(ToCString(text))
END FUNCTION

' Get next codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure
FUNCTION GetCodepoint& (text AS STRING, codepointSize AS LONG)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __GetCodepoint& ALIAS "GetCodepoint" (text AS STRING, codepointSize AS LONG)
    END DECLARE

    GetCodepoint = __GetCodepoint(ToCString(text), codepointSize)
END FUNCTION

' Get next codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure
FUNCTION GetCodepointNext& (text AS STRING, codepointSize AS LONG)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __GetCodepointNext& ALIAS "GetCodepointNext" (text AS STRING, codepointSize AS LONG)
    END DECLARE

    GetCodepointNext = __GetCodepointNext(ToCString(text), codepointSize)
END FUNCTION

' Get previous codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure
FUNCTION GetCodepointPrevious& (text AS STRING, codepointSize AS LONG)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __GetCodepointPrevious& ALIAS "GetCodepointPrevious" (text AS STRING, codepointSize AS LONG)
    END DECLARE

    GetCodepointPrevious = __GetCodepointPrevious(ToCString(text), codepointSize)
END FUNCTION

' Check if two text string are equal
FUNCTION TextIsEqual%% (text1 AS STRING, text2 AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __TextIsEqual%% ALIAS "TextIsEqual" (text1 AS STRING, text2 AS STRING)
    END DECLARE

    TextIsEqual = __TextIsEqual(ToCString(text1), ToCString(text2))
END FUNCTION

' Get text length, checks for '\0' ending
FUNCTION TextLength~& (text AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __TextLength~& ALIAS "TextLength" (text AS STRING)
    END DECLARE

    TextLength = __TextLength(ToCString(text))
END FUNCTION

' Text formatting with variables (sprintf() style)
FUNCTION TextFormatString$ (text AS STRING, s AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __TextFormatString$ ALIAS TextFormat (text AS STRING, s AS STRING)
    END DECLARE

    TextFormatString = __TextFormatString(ToCString(text), ToCString(s))
END FUNCTION

' Text formatting with variables (sprintf() style)
FUNCTION TextFormatLong$ (text AS STRING, i AS LONG)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __TextFormatLong$ ALIAS TextFormat (text AS STRING, BYVAL i AS LONG)
    END DECLARE

    TextFormatLong = __TextFormatLong(ToCString(text), i)
END FUNCTION

' Text formatting with variables (sprintf() style)
FUNCTION TextFormatInteger64$ (text AS STRING, i AS _INTEGER64)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __TextFormatInteger64$ ALIAS TextFormat (text AS STRING, BYVAL i AS _INTEGER64)
    END DECLARE

    TextFormatInteger64 = __TextFormatInteger64(ToCString(text), i)
END FUNCTION

' Text formatting with variables (sprintf() style)
FUNCTION TextFormatSingle$ (text AS STRING, f AS SINGLE)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __TextFormatSingle$ ALIAS TextFormat (text AS STRING, BYVAL f AS SINGLE)
    END DECLARE

    TextFormatSingle = __TextFormatSingle(ToCString(text), f)
END FUNCTION

' Text formatting with variables (sprintf() style)
FUNCTION TextFormatDouble$ (text AS STRING, d AS DOUBLE)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __TextFormatDouble$ ALIAS TextFormat (text AS STRING, BYVAL d AS DOUBLE)
    END DECLARE

    TextFormatDouble = __TextFormatDouble(ToCString(text), d)
END FUNCTION

' Find first text occurrence within a string
FUNCTION TextFindIndex& (text AS STRING, find AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __TextFindIndex& ALIAS "TextFindIndex" (text AS STRING, find AS STRING)
    END DECLARE

    TextFindIndex = __TextFindIndex(ToCString(text), ToCString(find))
END FUNCTION

' Get upper case version of provided string
FUNCTION TextToUpper$ (text AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __TextToUpper$ ALIAS "TextToUpper" (text AS STRING)
    END DECLARE

    TextToUpper = __TextToUpper(ToCString(text))
END FUNCTION

' Get lower case version of provided string
FUNCTION TextToLower$ (text AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __TextToLower$ ALIAS "TextToLower" (text AS STRING)
    END DECLARE

    TextToLower = __TextToLower(ToCString(text))
END FUNCTION

' Get Pascal case notation version of provided string
FUNCTION TextToPascal$ (text AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __TextToPascal$ ALIAS "TextToPascal" (text AS STRING)
    END DECLARE

    TextToPascal = __TextToPascal(ToCString(text))
END FUNCTION

' Get integer value from text (negative values not supported)
FUNCTION TextToInteger& (text AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __TextToInteger& ALIAS "TextToInteger" (text AS STRING)
    END DECLARE

    TextToInteger = __TextToInteger(ToCString(text))
END FUNCTION

' Load model from files (meshes and materials)
SUB LoadModel (fileName AS STRING, retVal AS Model)
    DECLARE STATIC LIBRARY "raylib"
        SUB __LoadModel ALIAS "LoadModel" (fileName AS STRING, retVal AS Model)
    END DECLARE

    __LoadModel ToCString(fileName), retVal
END SUB

' Export mesh data to file, returns true on success
FUNCTION ExportMesh%% (mesh AS Mesh, fileName AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __ExportMesh%% ALIAS "ExportMesh" (mesh AS Mesh, fileName AS STRING)
    END DECLARE

    ExportMesh = __ExportMesh(mesh, ToCString(fileName))
END FUNCTION

' Load materials from model file
FUNCTION LoadMaterials~%& (fileName AS STRING, materialCount AS LONG)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __LoadMaterials~%& ALIAS "LoadMaterials" (fileName AS STRING, materialCount AS LONG)
    END DECLARE

    LoadMaterials = __LoadMaterials(ToCString(fileName), materialCount)
END FUNCTION

' Load model animations from file
FUNCTION LoadModelAnimations~%& (fileName AS STRING, animCount AS LONG)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __LoadModelAnimations~%& ALIAS "LoadModelAnimations" (fileName AS STRING, animCount AS LONG)
    END DECLARE

    LoadModelAnimations = __LoadModelAnimations(ToCString(fileName), animCount)
END FUNCTION

' Load wave data from file
SUB LoadWave (fileName AS STRING, retVal AS Wave)
    DECLARE STATIC LIBRARY "raylib"
        SUB __LoadWave ALIAS "LoadWave" (fileName AS STRING, retVal AS Wave)
    END DECLARE

    __LoadWave ToCString(fileName), retVal
END SUB

' Load wave from memory buffer, fileType refers to extension: i.e. '.wav'
SUB LoadWaveFromMemory (fileType AS STRING, fileData AS _UNSIGNED _OFFSET, dataSize AS LONG, retVal AS Wave)
    DECLARE STATIC LIBRARY "raylib"
        SUB __LoadWaveFromMemory ALIAS "LoadWaveFromMemory" (fileType AS STRING, BYVAL fileData AS _UNSIGNED _OFFSET, BYVAL dataSize AS LONG, retVal AS Wave)
    END DECLARE

    __LoadWaveFromMemory ToCString(fileType), fileData, dataSize, retVal
END SUB

' Load sound from file
SUB LoadSound (fileName AS STRING, retVal AS RSound)
    DECLARE STATIC LIBRARY "raylib"
        SUB __LoadSound ALIAS "LoadSound" (fileName AS STRING, retVal AS RSound)
    END DECLARE

    __LoadSound ToCString(fileName), retVal
END SUB

' Export wave data to file, returns true on success
FUNCTION ExportWave%% (wave AS Wave, fileName AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __ExportWave%% ALIAS "ExportWave" (wave AS Wave, fileName AS STRING)
    END DECLARE

    ExportWave = __ExportWave(wave, ToCString(fileName))
END FUNCTION

' Export wave sample data to code (.h), returns true on success
FUNCTION ExportWaveAsCode%% (wave AS Wave, fileName AS STRING)
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __ExportWaveAsCode%% ALIAS "ExportWaveAsCode" (wave AS Wave, fileName AS STRING)
    END DECLARE

    ExportWaveAsCode = __ExportWaveAsCode(wave, ToCString(fileName))
END FUNCTION

' Load music stream from file
SUB LoadMusicStream (fileName AS STRING, retVal AS Music)
    DECLARE STATIC LIBRARY "raylib"
        SUB __LoadMusicStream ALIAS "LoadMusicStream" (fileName AS STRING, retVal AS Music)
    END DECLARE

    __LoadMusicStream ToCString(fileName), retVal
END SUB

' Load music stream from data
SUB LoadMusicStreamFromMemory (fileType AS STRING, Rdata AS _UNSIGNED _OFFSET, dataSize AS LONG, retVal AS Music)
    DECLARE STATIC LIBRARY "raylib"
        SUB __LoadMusicStreamFromMemory ALIAS "LoadMusicStreamFromMemory" (fileType AS STRING, BYVAL Rdata AS _UNSIGNED _OFFSET, BYVAL dataSize AS LONG, retVal AS Music)
    END DECLARE

    __LoadMusicStreamFromMemory ToCString(fileType), Rdata, dataSize, retVal
END SUB
