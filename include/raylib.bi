'-----------------------------------------------------------------------------------------------------------------------
' raylib bindings for QB64-PE
' Copyright (c) 2023 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$If RAYLIB_BI = UNDEFINED Then
    $Let RAYLIB_BI = TRUE

    ' Check QB64-PE compiler version and complain if it does not meet minimum version requirement
    ' We do not support 32-bit versions. Although it is trivial to add if we can find 32-bit raylib shared libraries
    $If VERSION < 3.7 OR 32BIT Then
            $ERROR This requires the latest 64-bit version of QB64-PE from https://github.com/QB64-Phoenix-Edition/QB64pe/releases
    $End If

    ' All identifiers must default to long (32-bits). This results in fastest code execution on x86 & x64
    DefLng A-Z

    ' Force all arrays to be defined
    Option _ExplicitArray

    ' Force all variables to be defined
    Option _Explicit

    ' All arrays should be static. If dynamic arrays are required use "REDIM"
    '$STATIC

    ' Start array lower bound from 1. If 0 is required, then it should be explicitly specified as (0 To X)
    Option Base 1

    ' raylib uses it's own window. So, we force QB64-PE to generate a console only executable. The console can be used for debugging
    $Console:Only

    ' Some common and useful constants
    Const FALSE = 0, TRUE = Not FALSE
    Const NULL = 0

    ' Vector2, 2 components
    Type Vector2
        x As Single ' Vector x component
        y As Single ' Vector y component
    End Type

    ' Vector3, 3 components
    Type Vector3
        x As Single ' Vector x component
        y As Single ' Vector y component
        z As Single ' Vector z component
    End Type

    ' Matrix, 4x4 components, column major, OpenGL style, right-handed
    Type Matrix
        As Single m0, m4, m8, m12 ' Matrix first row (4 components)
        As Single m1, m5, m9, m13 ' Matrix second row (4 components)
        As Single m2, m6, m10, m14 ' Matrix third row (4 components)
        As Single m3, m7, m11, m15 ' Matrix fourth row (4 components)
    End Type

    ' Color, 4 components, R8G8B8A8 (32bit)
    Type RGBA
        r As _Unsigned _Byte ' Color red value
        g As _Unsigned _Byte ' Color green value
        b As _Unsigned _Byte ' Color blue value
        a As _Unsigned _Byte ' Color alpha value
    End Type

    ' Image, pixel data stored in CPU memory (RAM)
    Type Image
        dat As _Offset ' Image raw data
        w As Long ' Image base width
        h As Long ' Image base height
        mipmaps As Long ' Mipmap levels, 1 by default
        format As Long ' Data format (PixelFormat type)
    End Type

    ' Texture, tex data stored in GPU memory (VRAM)
    Type Texture
        id As Long ' OpenGL texture id
        w As Long ' Texture base width
        h As Long ' Texture base height
        mipmaps As Long ' Mipmap levels, 1 by default
        format As Long ' Data format (PixelFormat type)
    End Type

    ' Texture2D, same as Texture
    Type Texture2D
        id As Long ' OpenGL texture id
        w As Long ' Texture base width
        h As Long ' Texture base height
        mipmaps As Long ' Mipmap levels, 1 by default
        format As Long ' Data format (PixelFormat type)
    End Type

    ' TextureCubemap, same as Texture
    Type TextureCubemap
        id As Long ' OpenGL texture id
        w As Long ' Texture base width
        h As Long ' Texture base height
        mipmaps As Long ' Mipmap levels, 1 by default
        format As Long ' Data format (PixelFormat type)
    End Type

    ' RenderTexture, fbo for texture rendering
    Type RenderTexture
        id As Long ' OpenGL framebuffer object id
        texture As Texture ' Color buffer attachment texture
        depth As Texture ' Depth buffer attachment texture
    End Type

    ' RenderTexture2D, same as RenderTexture
    Type RenderTexture2D
        id As Long ' OpenGL framebuffer object id
        texture As Texture ' Color buffer attachment texture
        depth As Texture ' Depth buffer attachment texture
    End Type

    ' Camera, defines position/orientation in 3d space
    Type Camera3D
        position As Vector3 ' Camera position
        target As Vector3 ' Camera target it looks-at
        up As Vector3 ' Camera up vector (rotation over its axis)
        fovy As Single ' Camera field-of-view aperture in Y (degrees) in perspective, used as near plane width in orthographic
        projection As Long ' Camera projection: CAMERA_PERSPECTIVE or CAMERA_ORTHOGRAPHIC
    End Type

    ' Camera type fallback, defaults to Camera3D
    Type Camera
        position As Vector3 ' Camera position
        target As Vector3 ' Camera target it looks-at
        up As Vector3 ' Camera up vector (rotation over its axis)
        fovy As Single ' Camera field-of-view aperture in Y (degrees) in perspective, used as near plane width in orthographic
        projection As Long ' Camera projection: CAMERA_PERSPECTIVE or CAMERA_ORTHOGRAPHIC
    End Type

    ' Camera2D, defines position/orientation in 2d space
    Type Camera2D
        offset As Vector2 ' Camera offset (displacement from target)
        target As Vector2 ' Camera target (rotation and zoom origin)
        rotation As Single ' Camera rotation in degrees
        zoom As Single ' Camera zoom (scaling), should be 1.0f by default
    End Type

    ' Shader
    Type Shader
        id As Long ' Shader program id
        locs As _Offset ' Shader locations array (RL_MAX_SHADER_LOCATIONS)
    End Type

    ' VrDeviceInfo, Head-Mounted-Display device parameters
    Type VrDeviceInfo
        hResolution As Long ' Horizontal resolution in pixels
        vResolution As Long ' Vertical resolution in pixels
        hScreenSize As Single ' Horizontal size in meters
        vScreenSize As Single ' Vertical size in meters
        vScreenCenter As Single ' Screen center in meters
        eyeToScreenDistance As Single ' Distance between eye and display in meters
        lensSeparationDistance As Single ' Lens separation distance in meters
        interpupillaryDistance As Single ' IPD (distance between pupils) in meters
        As Single lensDistortionValues0, lensDistortionValues1, lensDistortionValues2, lensDistortionValues3 ' Lens distortion constant parameters
        As Single chromaAbCorrection0, chromaAbCorrection1, chromaAbCorrection2, chromaAbCorrection3 ' Chromatic aberration correction parameters
    End Type

    ' VrStereoConfig, VR stereo rendering configuration for simulator
    Type VrStereoConfig
        As Matrix projection0, projection1 ' VR projection matrices (per eye)
        As Matrix viewOffset0, viewOffset1 ' VR view offset matrices (per eye)
        As Single leftLensCenter0, leftLensCenter1 ' VR left lens center
        As Single rightLensCenter0, rightLensCenter1 ' VR right lens center
        As Single leftScreenCenter0, leftScreenCenter1 ' VR left screen center
        As Single rightScreenCenter0, rightScreenCenter1 ' VR right screen center
        As Single scale0, scale1 ' VR distortion scale
        As Single scaleIn0, scaleIn1 ' VR distortion scale in
    End Type

    '-------------------------------------------------------------------------------------------------------------------
    ' Autogenerated QB64-PE DECLARE STATIC LIBRARY stuff
    ' Do no call anything with leading `__` directly. Use the QB64-PE function wrappers in raylib.bas instead
    '-------------------------------------------------------------------------------------------------------------------
    Declare Static Library "raylib"
        Function __init_raylib%% ' for iternal use only

        ' QB64 <> raylib color stuff
        Function MakeRGBA~& (ByVal r As _Unsigned _Byte, Byval g As _Unsigned _Byte, Byval b As _Unsigned _Byte, Byval a As _Unsigned _Byte)
        Function GetRGBARed~%% (ByVal rgba As _Unsigned Long)
        Function GetRGBAGreen~%% (ByVal rgba As _Unsigned Long)
        Function GetRGBABlue~%% (ByVal rgba As _Unsigned Long)
        Function GetRGBAAlpha~%% (ByVal rgba As _Unsigned Long)
        Function GetRGBARGB~& (ByVal rgba As _Unsigned Long)
        Function BGRAToRGBA~& (ByVal bgra As _Unsigned Long)

        Sub __InitWindow Alias InitWindow (ByVal W As Long, Byval H As Long, caption As String)
        Function WindowShouldClose%%
        Sub CloseWindow
        Function IsWindowReady%%
        Function IsWindowFullscreen%%
        Function IsWindowHidden%%
        Function IsWindowMinimized%%
        Function IsWindowMaximized%%
        Function IsWindowFocused%%
        Function IsWindowResized%%
        Function IsWindowState%% (ByVal flag As _Unsigned Long)
        Sub SetWindowState (ByVal flags As _Unsigned Long)
        Sub ClearWindowState (ByVal flags As _Unsigned Long)
        Sub ToggleFullscreen
        Sub MaximizeWindow
        Sub MinimizeWindow
        Sub RestoreWindow
        Sub SetWindowIcon (ByVal image As _Unsigned _Offset)
        Sub SetWindowIcons (ByVal images As _Unsigned _Offset, Byval count As Long)
        Sub __SetWindowTitle Alias SetWindowTitle (title As String)
        Sub SetWindowPosition (ByVal x As Long, Byval y As Long)
        Sub SetWindowMonitor (ByVal monitor As Long)
        Sub SetWindowMinSize (ByVal width As Long, Byval height As Long)
        Sub SetWindowSize (ByVal width As Long, Byval height As Long)
        Sub SetWindowOpacity (ByVal opacity As Single)
        Function GetWindowHandle~%&
        Function GetScreenWidth&
        Function GetScreenHeight&
        Function GetRenderWidth&
        Function GetRenderHeight&
        Function GetMonitorCount&
        Function GetCurrentMonitor&
        Sub GetMonitorPosition (ByVal monitor As Long, Byval retVal As _Unsigned _Offset)
        Function GetMonitorWidth& (ByVal monitor As Long)
        Function GetMonitorHeight& (ByVal monitor As Long)
        Function GetMonitorPhysicalWidth& (ByVal monitor As Long)
        Function GetMonitorPhysicalHeight& (ByVal monitor As Long)
        Function GetMonitorRefreshRate& (ByVal monitor As Long)
        Sub GetWindowPosition (ByVal retVal As _Unsigned _Offset)
        Sub GetWindowScaleDPI (ByVal retVal As _Unsigned _Offset)
        Function GetMonitorName$ (ByVal monitor As Long)
        Sub __SetClipboardText Alias SetClipboardText (text As String)
        Function GetClipboardText$
        Sub EnableEventWaiting
        Sub DisableEventWaiting
        Sub SwapScreenBuffer
        Sub PollInputEvents
        Sub WaitTime (ByVal seconds As Double)
        Sub ShowCursor
        Sub HideCursor
        Function IsCursorHidden%%
        Sub EnableCursor
        Sub DisableCursor
        Function IsCursorOnScreen%%
        Sub ClearBackground (ByVal clr As _Unsigned Long)
        Sub BeginDrawing
        Sub EndDrawing
        Sub BeginMode2D (ByVal camera As _Unsigned _Offset)
        Sub EndMode2D
        Sub BeginMode3D (ByVal camera As _Unsigned _Offset)
        Sub EndMode3D
        Sub BeginTextureMode (ByVal target As _Unsigned _Offset)
        Sub EndTextureMode
        Sub BeginShaderMode (ByVal shader As _Unsigned _Offset)
        Sub EndShaderMode
        Sub BeginBlendMode (ByVal mode As Long)
        Sub EndBlendMode
        Sub BeginScissorMode (ByVal x As Long, Byval y As Long, Byval width As Long, Byval height As Long)
        Sub EndScissorMode
        Sub BeginVrStereoMode (ByVal config As _Unsigned _Offset)
        Sub EndVrStereoMode
        Sub LoadVrStereoConfig (ByVal device As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Sub UnloadVrStereoConfig (ByVal config As _Unsigned _Offset)
        Sub __LoadShader Alias LoadShader (vsFileName As String, fsFileName As String, Byval retVal As _Unsigned _Offset)
        Sub __LoadShaderFromMemory Alias LoadShaderFromMemory (vsCode As String, fsCode As String, Byval retVal As _Unsigned _Offset)
        Function IsShaderReady%% (ByVal shader As _Unsigned _Offset)
        Function __GetShaderLocation& Alias GetShaderLocation (ByVal shader As _Unsigned _Offset, uniformName As String)
        Function __GetShaderLocationAttrib& Alias GetShaderLocationAttrib (ByVal shader As _Unsigned _Offset, attribName As String)
        Sub SetShaderValue (ByVal shader As _Unsigned _Offset, Byval locIndex As Long, Byval value As _Unsigned _Offset, Byval uniformType As Long)
        Sub SetShaderValueV (ByVal shader As _Unsigned _Offset, Byval locIndex As Long, Byval value As _Unsigned _Offset, Byval uniformType As Long, Byval count As Long)
        Sub SetShaderValueMatrix (ByVal shader As _Unsigned _Offset, Byval locIndex As Long, Byval mat As _Unsigned _Offset)
        Sub SetShaderValueTexture (ByVal shader As _Unsigned _Offset, Byval locIndex As Long, Byval texture As _Unsigned _Offset)
        Sub UnloadShader (ByVal shader As _Unsigned _Offset)
        Sub GetMouseRay (ByVal mousePosition As _Unsigned _Offset, Byval camera As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Sub GetCameraMatrix (ByVal camera As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Sub GetCameraMatrix2D (ByVal camera As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Sub GetWorldToScreen (ByVal position As _Unsigned _Offset, Byval camera As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Sub GetScreenToWorld2D (ByVal position As _Unsigned _Offset, Byval camera As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Sub GetWorldToScreenEx (ByVal position As _Unsigned _Offset, Byval camera As _Unsigned _Offset, Byval width As Long, Byval height As Long, Byval retVal As _Unsigned _Offset)
        Sub GetWorldToScreen2D (ByVal position As _Unsigned _Offset, Byval camera As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Sub SetTargetFPS (ByVal fps As Long)
        Function GetFPS&
        Function GetFrameTime!
        Function GetTime#
        Function GetRandomValue& (ByVal min As Long, Byval max As Long)
        Sub SetRandomSeed (ByVal seed As _Unsigned Long)
        Sub __TakeScreenshot Alias TakeScreenshot (fileName As String)
        Sub SetConfigFlags (ByVal flags As _Unsigned Long)
        Sub __TraceLog Alias TraceLog (ByVal logLevel As Long, text As String)
        Sub __TraceLogString Alias TraceLog (ByVal logLevel As Long, text As String, s As String) ' overloaded
        Sub __TraceLogLong Alias TraceLog (ByVal logLevel As Long, text As String, Byval i As Long) ' overloaded
        Sub __TraceLogSingle Alias TraceLog (ByVal logLevel As Long, text As String, Byval f As Single) ' overloaded
        Sub SetTraceLogLevel (ByVal logLevel As Long)
        Function MemAlloc~%& (ByVal size As _Unsigned Long)
        Function MemRealloc~%& (ByVal ptr As _Unsigned _Offset, Byval size As _Unsigned Long)
        Sub MemFree (ByVal ptr As _Unsigned _Offset)
        Sub __OpenURL Alias OpenURL (url As String)
        Sub SetTraceLogCallback (ByVal callback As _Unsigned _Offset)
        Sub SetLoadFileDataCallback (ByVal callback As _Unsigned _Offset)
        Sub SetSaveFileDataCallback (ByVal callback As _Unsigned _Offset)
        Sub SetLoadFileTextCallback (ByVal callback As _Unsigned _Offset)
        Sub SetSaveFileTextCallback (ByVal callback As _Unsigned _Offset)
        Function __LoadFileData~%& Alias LoadFileData (fileName As String, bytesRead As _Unsigned Long)
        Sub UnloadFileData (ByVal dat As _Unsigned _Offset)
        Function __SaveFileData%% Alias SaveFileData (fileName As String, Byval dat As _Unsigned _Offset, Byval bytesToWrite As _Unsigned Long)
        Function __ExportDataAsCode%% Alias ExportDataAsCode (ByVal dat As _Unsigned _Offset, Byval size As _Unsigned Long, fileName As String)
        Function __LoadFileText~%& Alias LoadFileText (fileName As String)
        Sub UnloadFileText (ByVal text As _Unsigned _Offset)
        Function __SaveFileText%% Alias SaveFileText (fileName As String, Byval text As _Unsigned _Offset)
        Function __FileExists%% Alias FileExists (fileName As String)
        Function __DirectoryExists%% Alias DirectoryExists (dirPath As String)
        Function __IsFileExtension%% Alias IsFileExtension (fileName As String, ext As String)
        Function __GetFileLength& Alias GetFileLength (fileName As String)
        Function __GetFileExtension$ Alias GetFileExtension (fileName As String)
        Function __GetFileName$ Alias GetFileName (filePath As String)
        Function __GetFileNameWithoutExt$ Alias GetFileNameWithoutExt (filePath As String)
        Function __GetDirectoryPath$ Alias GetDirectoryPath (filePath As String)
        Function __GetPrevDirectoryPath$ Alias GetPrevDirectoryPath (dirPath As String)
        Function GetWorkingDirectory$
        Function GetApplicationDirectory$
        Function __ChangeDirectory%% Alias ChangeDirectory (dir As String)
        Function __IsPathFile%% Alias IsPathFile (path As String)
        Sub __LoadDirectoryFiles Alias LoadDirectoryFiles (dirPath As String, Byval retVal As _Unsigned _Offset)
        Sub __LoadDirectoryFilesEx Alias LoadDirectoryFilesEx (basePath As String, filter As String, Byval scanSubdirs As _Byte, Byval retVal As _Unsigned _Offset)
        Sub UnloadDirectoryFiles (ByVal files As _Unsigned _Offset)
        Function IsFileDropped%%
        Sub LoadDroppedFiles (ByVal retVal As _Unsigned _Offset)
        Sub UnloadDroppedFiles (ByVal files As _Unsigned _Offset)
        Function __GetFileModTime& Alias GetFileModTime (fileName As String)
        Function CompressData~%& (ByVal dat As _Unsigned _Offset, Byval dataSize As _Unsigned Long, compDataSize As _Unsigned Long)
        Function DecompressData~%& (ByVal compData As _Unsigned _Offset, Byval compDataSize As _Unsigned Long, dataSize As _Unsigned Long)
        Function EncodeDataBase64~%& (ByVal dat As _Unsigned _Offset, Byval dataSize As Long, outputSize As _Unsigned Long)
        Function DecodeDataBase64~%& (ByVal dat As _Unsigned _Offset, outputSize As _Unsigned Long)
        Function IsKeyPressed%% (ByVal key As Long)
        Function IsKeyDown%% (ByVal key As Long)
        Function IsKeyReleased%% (ByVal key As Long)
        Function IsKeyUp%% (ByVal key As Long)
        Sub SetExitKey (ByVal key As Long)
        Function GetKeyPressed&
        Function GetCharPressed&
        Function IsGamepadAvailable%% (ByVal gamepad As Long)
        Function GetGamepadName$ (ByVal gamepad As Long)
        Function IsGamepadButtonPressed%% (ByVal gamepad As Long, Byval button As Long)
        Function IsGamepadButtonDown%% (ByVal gamepad As Long, Byval button As Long)
        Function IsGamepadButtonReleased%% (ByVal gamepad As Long, Byval button As Long)
        Function IsGamepadButtonUp%% (ByVal gamepad As Long, Byval button As Long)
        Function GetGamepadButtonPressed&
        Function GetGamepadAxisCount& (ByVal gamepad As Long)
        Function GetGamepadAxisMovement! (ByVal gamepad As Long, Byval axis As Long)
        Function __SetGamepadMappings& Alias SetGamepadMappings (mappings As String)
        Function IsMouseButtonPressed%% (ByVal button As Long)
        Function IsMouseButtonDown%% (ByVal button As Long)
        Function IsMouseButtonReleased%% (ByVal button As Long)
        Function IsMouseButtonUp%% (ByVal button As Long)
        Function GetMouseX&
        Function GetMouseY&
        Sub GetMousePosition (ByVal retVal As _Unsigned _Offset)
        Sub GetMouseDelta (ByVal retVal As _Unsigned _Offset)
        Sub SetMousePosition (ByVal x As Long, Byval y As Long)
        Sub SetMouseOffset (ByVal offsetX As Long, Byval offsetY As Long)
        Sub SetMouseScale (ByVal scaleX As Single, Byval scaleY As Single)
        Function GetMouseWheelMove!
        Sub GetMouseWheelMoveV (ByVal retVal As _Unsigned _Offset)
        Sub SetMouseCursor (ByVal cursor As Long)
        Function GetTouchX&
        Function GetTouchY&
        Sub GetTouchPosition (ByVal index As Long, Byval retVal As _Unsigned _Offset)
        Function GetTouchPointId& (ByVal index As Long)
        Function GetTouchPointCount&
        Sub SetGesturesEnabled (ByVal flags As _Unsigned Long)
        Function IsGestureDetected%% (ByVal gesture As Long)
        Function GetGestureDetected&
        Function GetGestureHoldDuration!
        Sub GetGestureDragVector (ByVal retVal As _Unsigned _Offset)
        Function GetGestureDragAngle!
        Sub GetGesturePinchVector (ByVal retVal As _Unsigned _Offset)
        Function GetGesturePinchAngle!
        Sub UpdateCamera (ByVal camera As _Unsigned _Offset, Byval mode As Long)
        Sub UpdateCameraPro (ByVal camera As _Unsigned _Offset, Byval movement As _Unsigned _Offset, Byval rotation As _Unsigned _Offset, Byval zoom As Single)
        Sub SetShapesTexture (ByVal texture As _Unsigned _Offset, Byval source As _Unsigned _Offset)
        Sub DrawPixel (ByVal posX As Long, Byval posY As Long, Byval color As _Unsigned _Offset)
        Sub DrawPixelV (ByVal position As _Unsigned _Offset, Byval color As _Unsigned _Offset)
        Sub DrawLine (ByVal startPosX As Long, Byval startPosY As Long, Byval endPosX As Long, Byval endPosY As Long, Byval color As _Unsigned _Offset)
        Sub DrawLineV (ByVal startPos As _Unsigned _Offset, Byval endPos As _Unsigned _Offset, Byval color As _Unsigned _Offset)
        Sub DrawLineEx (ByVal startPos As _Unsigned _Offset, Byval endPos As _Unsigned _Offset, Byval thick As Single, Byval color As _Unsigned _Offset)
        Sub DrawLineBezier (ByVal startPos As _Unsigned _Offset, Byval endPos As _Unsigned _Offset, Byval thick As Single, Byval color As _Unsigned _Offset)
        Sub DrawLineBezierQuad (ByVal startPos As _Unsigned _Offset, Byval endPos As _Unsigned _Offset, Byval controlPos As _Unsigned _Offset, Byval thick As Single, Byval color As _Unsigned _Offset)
        Sub DrawLineBezierCubic (ByVal startPos As _Unsigned _Offset, Byval endPos As _Unsigned _Offset, Byval startControlPos As _Unsigned _Offset, Byval endControlPos As _Unsigned _Offset, Byval thick As Single, Byval color As _Unsigned _Offset)
        Sub DrawLineStrip (ByVal points As _Unsigned _Offset, Byval pointCount As Long, Byval color As _Unsigned _Offset)
        Sub DrawCircle (ByVal centerX As Long, Byval centerY As Long, Byval radius As Single, Byval color As _Unsigned _Offset)
        Sub DrawCircleSector (ByVal center As _Unsigned _Offset, Byval radius As Single, Byval startAngle As Single, Byval endAngle As Single, Byval segments As Long, Byval color As _Unsigned _Offset)
        Sub DrawCircleSectorLines (ByVal center As _Unsigned _Offset, Byval radius As Single, Byval startAngle As Single, Byval endAngle As Single, Byval segments As Long, Byval color As _Unsigned _Offset)
        Sub DrawCircleGradient (ByVal centerX As Long, Byval centerY As Long, Byval radius As Single, Byval color1 As _Unsigned _Offset, Byval color2 As _Unsigned _Offset)
        Sub DrawCircleV (ByVal center As _Unsigned _Offset, Byval radius As Single, Byval color As _Unsigned _Offset)
        Sub DrawCircleLines (ByVal centerX As Long, Byval centerY As Long, Byval radius As Single, Byval color As _Unsigned _Offset)
        Sub DrawEllipse (ByVal centerX As Long, Byval centerY As Long, Byval radiusH As Single, Byval radiusV As Single, Byval color As _Unsigned _Offset)
        Sub DrawEllipseLines (ByVal centerX As Long, Byval centerY As Long, Byval radiusH As Single, Byval radiusV As Single, Byval color As _Unsigned _Offset)
        Sub DrawRing (ByVal center As _Unsigned _Offset, Byval innerRadius As Single, Byval outerRadius As Single, Byval startAngle As Single, Byval endAngle As Single, Byval segments As Long, Byval color As _Unsigned _Offset)
        Sub DrawRingLines (ByVal center As _Unsigned _Offset, Byval innerRadius As Single, Byval outerRadius As Single, Byval startAngle As Single, Byval endAngle As Single, Byval segments As Long, Byval color As _Unsigned _Offset)
        Sub DrawRectangle (ByVal posX As Long, Byval posY As Long, Byval width As Long, Byval height As Long, Byval color As _Unsigned _Offset)
        Sub DrawRectangleV (ByVal position As _Unsigned _Offset, Byval size As _Unsigned _Offset, Byval color As _Unsigned _Offset)
        Sub DrawRectangleRec (ByVal rec As _Unsigned _Offset, Byval color As _Unsigned _Offset)
        Sub DrawRectanglePro (ByVal rec As _Unsigned _Offset, Byval origin As _Unsigned _Offset, Byval rotation As Single, Byval color As _Unsigned _Offset)
        Sub DrawRectangleGradientV (ByVal posX As Long, Byval posY As Long, Byval width As Long, Byval height As Long, Byval color1 As _Unsigned _Offset, Byval color2 As _Unsigned _Offset)
        Sub DrawRectangleGradientH (ByVal posX As Long, Byval posY As Long, Byval width As Long, Byval height As Long, Byval color1 As _Unsigned _Offset, Byval color2 As _Unsigned _Offset)
        Sub DrawRectangleGradientEx (ByVal rec As _Unsigned _Offset, Byval col1 As _Unsigned _Offset, Byval col2 As _Unsigned _Offset, Byval col3 As _Unsigned _Offset, Byval col4 As _Unsigned _Offset)
        Sub DrawRectangleLines (ByVal posX As Long, Byval posY As Long, Byval width As Long, Byval height As Long, Byval color As _Unsigned _Offset)
        Sub DrawRectangleLinesEx (ByVal rec As _Unsigned _Offset, Byval lineThick As Single, Byval color As _Unsigned _Offset)
        Sub DrawRectangleRounded (ByVal rec As _Unsigned _Offset, Byval roundness As Single, Byval segments As Long, Byval color As _Unsigned _Offset)
        Sub DrawRectangleRoundedLines (ByVal rec As _Unsigned _Offset, Byval roundness As Single, Byval segments As Long, Byval lineThick As Single, Byval color As _Unsigned _Offset)
        Sub DrawTriangle (ByVal v1 As _Unsigned _Offset, Byval v2 As _Unsigned _Offset, Byval v3 As _Unsigned _Offset, Byval color As _Unsigned _Offset)
        Sub DrawTriangleLines (ByVal v1 As _Unsigned _Offset, Byval v2 As _Unsigned _Offset, Byval v3 As _Unsigned _Offset, Byval color As _Unsigned _Offset)
        Sub DrawTriangleFan (ByVal points As _Unsigned _Offset, Byval pointCount As Long, Byval color As _Unsigned _Offset)
        Sub DrawTriangleStrip (ByVal points As _Unsigned _Offset, Byval pointCount As Long, Byval color As _Unsigned _Offset)
        Sub DrawPoly (ByVal center As _Unsigned _Offset, Byval sides As Long, Byval radius As Single, Byval rotation As Single, Byval color As _Unsigned _Offset)
        Sub DrawPolyLines (ByVal center As _Unsigned _Offset, Byval sides As Long, Byval radius As Single, Byval rotation As Single, Byval color As _Unsigned _Offset)
        Sub DrawPolyLinesEx (ByVal center As _Unsigned _Offset, Byval sides As Long, Byval radius As Single, Byval rotation As Single, Byval lineThick As Single, Byval color As _Unsigned _Offset)
        Function CheckCollisionRecs%% (ByVal rec1 As _Unsigned _Offset, Byval rec2 As _Unsigned _Offset)
        Function CheckCollisionCircles%% (ByVal center1 As _Unsigned _Offset, Byval radius1 As Single, Byval center2 As _Unsigned _Offset, Byval radius2 As Single)
        Function CheckCollisionCircleRec%% (ByVal center As _Unsigned _Offset, Byval radius As Single, Byval rec As _Unsigned _Offset)
        Function CheckCollisionPointRec%% (ByVal point As _Unsigned _Offset, Byval rec As _Unsigned _Offset)
        Function CheckCollisionPointCircle%% (ByVal point As _Unsigned _Offset, Byval center As _Unsigned _Offset, Byval radius As Single)
        Function CheckCollisionPointTriangle%% (ByVal point As _Unsigned _Offset, Byval p1 As _Unsigned _Offset, Byval p2 As _Unsigned _Offset, Byval p3 As _Unsigned _Offset)
        Function CheckCollisionPointPoly%% (ByVal point As _Unsigned _Offset, Byval points As _Unsigned _Offset, Byval pointCount As Long)
        Function CheckCollisionLines%% (ByVal startPos1 As _Unsigned _Offset, Byval endPos1 As _Unsigned _Offset, Byval startPos2 As _Unsigned _Offset, Byval endPos2 As _Unsigned _Offset, Byval collisionPoint As _Unsigned _Offset)
        Function CheckCollisionPointLine%% (ByVal point As _Unsigned _Offset, Byval p1 As _Unsigned _Offset, Byval p2 As _Unsigned _Offset, Byval threshold As Long)
        Sub GetCollisionRec (ByVal rec1 As _Unsigned _Offset, Byval rec2 As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Sub __LoadImage Alias LoadImage (fileName As String, Byval retVal As _Unsigned _Offset)
        Sub __LoadImageRaw Alias LoadImageRaw (fileName As String, Byval width As Long, Byval height As Long, Byval format As Long, Byval headerSize As Long, Byval retVal As _Unsigned _Offset)
        Sub __LoadImageAnim Alias LoadImageAnim (fileName As String, Byval frames As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Sub __LoadImageFromMemory Alias LoadImageFromMemory (fileType As String, fileData As String, Byval dataSize As Long, Byval retVal As _Unsigned _Offset)
        Sub LoadImageFromTexture (ByVal texture As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Sub LoadImageFromScreen (ByVal retVal As _Unsigned _Offset)
        Function IsImageReady%% (ByVal image As _Unsigned _Offset)
        Sub UnloadImage (ByVal image As _Unsigned _Offset)
        Function __ExportImage%% Alias ExportImage (ByVal image As _Unsigned _Offset, fileName As String)
        Function __ExportImageAsCode%% Alias ExportImageAsCode (ByVal image As _Unsigned _Offset, fileName As String)
        Sub GenImageColor (ByVal width As Long, Byval height As Long, Byval color As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Sub GenImageGradientV (ByVal width As Long, Byval height As Long, Byval top As _Unsigned _Offset, Byval bottom As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Sub GenImageGradientH (ByVal width As Long, Byval height As Long, Byval left As _Unsigned _Offset, Byval right As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Sub GenImageGradientRadial (ByVal width As Long, Byval height As Long, Byval density As Single, Byval inner As _Unsigned _Offset, Byval outer As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Sub GenImageChecked (ByVal width As Long, Byval height As Long, Byval checksX As Long, Byval checksY As Long, Byval col1 As _Unsigned _Offset, Byval col2 As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Sub GenImageWhiteNoise (ByVal width As Long, Byval height As Long, Byval factor As Single, Byval retVal As _Unsigned _Offset)
        Sub GenImagePerlinNoise (ByVal width As Long, Byval height As Long, Byval offsetX As Long, Byval offsetY As Long, Byval scale As Single, Byval retVal As _Unsigned _Offset)
        Sub GenImageCellular (ByVal width As Long, Byval height As Long, Byval tileSize As Long, Byval retVal As _Unsigned _Offset)
        Sub __GenImageText Alias GenImageText (ByVal width As Long, Byval height As Long, text As String, Byval retVal As _Unsigned _Offset)
        Sub ImageCopy (ByVal image As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Sub ImageFromImage (ByVal image As _Unsigned _Offset, Byval rec As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Sub __ImageText Alias ImageText (text As String, Byval fontSize As Long, Byval color As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Sub __ImageTextEx Alias ImageTextEx (ByVal font As _Unsigned _Offset, text As String, Byval fontSize As Single, Byval spacing As Single, Byval tint As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Sub ImageFormat (ByVal image As _Unsigned _Offset, Byval newFormat As Long)
        Sub ImageToPOT (ByVal image As _Unsigned _Offset, Byval fill As _Unsigned _Offset)
        Sub ImageCrop (ByVal image As _Unsigned _Offset, Byval crop As _Unsigned _Offset)
        Sub ImageAlphaCrop (ByVal image As _Unsigned _Offset, Byval threshold As Single)
        Sub ImageAlphaClear (ByVal image As _Unsigned _Offset, Byval color As _Unsigned _Offset, Byval threshold As Single)
        Sub ImageAlphaMask (ByVal image As _Unsigned _Offset, Byval alphaMask As _Unsigned _Offset)
        Sub ImageAlphaPremultiply (ByVal image As _Unsigned _Offset)
        Sub ImageBlurGaussian (ByVal image As _Unsigned _Offset, Byval blurSize As Long)
        Sub ImageResize (ByVal image As _Unsigned _Offset, Byval newWidth As Long, Byval newHeight As Long)
        Sub ImageResizeNN (ByVal image As _Unsigned _Offset, Byval newWidth As Long, Byval newHeight As Long)
        Sub ImageResizeCanvas (ByVal image As _Unsigned _Offset, Byval newWidth As Long, Byval newHeight As Long, Byval offsetX As Long, Byval offsetY As Long, Byval fill As _Unsigned _Offset)
        Sub ImageMipmaps (ByVal image As _Unsigned _Offset)
        Sub ImageDither (ByVal image As _Unsigned _Offset, Byval rBpp As Long, Byval gBpp As Long, Byval bBpp As Long, Byval aBpp As Long)
        Sub ImageFlipVertical (ByVal image As _Unsigned _Offset)
        Sub ImageFlipHorizontal (ByVal image As _Unsigned _Offset)
        Sub ImageRotateCW (ByVal image As _Unsigned _Offset)
        Sub ImageRotateCCW (ByVal image As _Unsigned _Offset)
        Sub ImageColorTint (ByVal image As _Unsigned _Offset, Byval color As _Unsigned _Offset)
        Sub ImageColorInvert (ByVal image As _Unsigned _Offset)
        Sub ImageColorGrayscale (ByVal image As _Unsigned _Offset)
        Sub ImageColorContrast (ByVal image As _Unsigned _Offset, Byval contrast As Single)
        Sub ImageColorBrightness (ByVal image As _Unsigned _Offset, Byval brightness As Long)
        Sub ImageColorReplace (ByVal image As _Unsigned _Offset, Byval color As _Unsigned _Offset, Byval replace As _Unsigned _Offset)
        Function LoadImageColors~%& (ByVal image As _Unsigned _Offset)
        Function LoadImagePalette~%& (ByVal image As _Unsigned _Offset, Byval maxPaletteSize As Long, Byval colorCount As _Unsigned _Offset)
        Sub UnloadImageColors (ByVal colors As _Unsigned _Offset)
        Sub UnloadImagePalette (ByVal colors As _Unsigned _Offset)
        Sub GetImageAlphaBorder (ByVal image As _Unsigned _Offset, Byval threshold As Single, Byval retVal As _Unsigned _Offset)
        Sub GetImageColor (ByVal image As _Unsigned _Offset, Byval x As Long, Byval y As Long, Byval retVal As _Unsigned _Offset)
        Sub ImageClearBackground (ByVal dst As _Unsigned _Offset, Byval color As _Unsigned _Offset)
        Sub ImageDrawPixel (ByVal dst As _Unsigned _Offset, Byval posX As Long, Byval posY As Long, Byval color As _Unsigned _Offset)
        Sub ImageDrawPixelV (ByVal dst As _Unsigned _Offset, Byval position As _Unsigned _Offset, Byval color As _Unsigned _Offset)
        Sub ImageDrawLine (ByVal dst As _Unsigned _Offset, Byval startPosX As Long, Byval startPosY As Long, Byval endPosX As Long, Byval endPosY As Long, Byval color As _Unsigned _Offset)
        Sub ImageDrawLineV (ByVal dst As _Unsigned _Offset, Byval start As _Unsigned _Offset, Byval end As _Unsigned _Offset, Byval color As _Unsigned _Offset)
        Sub ImageDrawCircle (ByVal dst As _Unsigned _Offset, Byval centerX As Long, Byval centerY As Long, Byval radius As Long, Byval color As _Unsigned _Offset)
        Sub ImageDrawCircleV (ByVal dst As _Unsigned _Offset, Byval center As _Unsigned _Offset, Byval radius As Long, Byval color As _Unsigned _Offset)
        Sub ImageDrawCircleLines (ByVal dst As _Unsigned _Offset, Byval centerX As Long, Byval centerY As Long, Byval radius As Long, Byval color As _Unsigned _Offset)
        Sub ImageDrawCircleLinesV (ByVal dst As _Unsigned _Offset, Byval center As _Unsigned _Offset, Byval radius As Long, Byval color As _Unsigned _Offset)
        Sub ImageDrawRectangle (ByVal dst As _Unsigned _Offset, Byval posX As Long, Byval posY As Long, Byval width As Long, Byval height As Long, Byval color As _Unsigned _Offset)
        Sub ImageDrawRectangleV (ByVal dst As _Unsigned _Offset, Byval position As _Unsigned _Offset, Byval size As _Unsigned _Offset, Byval color As _Unsigned _Offset)
        Sub ImageDrawRectangleRec (ByVal dst As _Unsigned _Offset, Byval rec As _Unsigned _Offset, Byval color As _Unsigned _Offset)
        Sub ImageDrawRectangleLines (ByVal dst As _Unsigned _Offset, Byval rec As _Unsigned _Offset, Byval thick As Long, Byval color As _Unsigned _Offset)
        Sub ImageDraw (ByVal dst As _Unsigned _Offset, Byval src As _Unsigned _Offset, Byval srcRec As _Unsigned _Offset, Byval dstRec As _Unsigned _Offset, Byval tint As _Unsigned _Offset)
        Sub __ImageDrawText Alias ImageDrawText (ByVal dst As _Unsigned _Offset, text As String, Byval posX As Long, Byval posY As Long, Byval fontSize As Long, Byval color As _Unsigned _Offset)
        Sub __ImageDrawTextEx Alias ImageDrawTextEx (ByVal dst As _Unsigned _Offset, Byval font As _Unsigned _Offset, text As String, Byval position As _Unsigned _Offset, Byval fontSize As Single, Byval spacing As Single, Byval tint As _Unsigned _Offset)
        Sub __LoadTexture Alias LoadTexture (fileName As String, Byval retVal As _Unsigned _Offset)
        Sub LoadTextureFromImage (ByVal image As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Sub LoadTextureCubemap (ByVal image As _Unsigned _Offset, Byval layout As Long, Byval retVal As _Unsigned _Offset)
        Sub LoadRenderTexture (ByVal width As Long, Byval height As Long, Byval retVal As _Unsigned _Offset)
        Function IsTextureReady%% (ByVal texture As _Unsigned _Offset)
        Sub UnloadTexture (ByVal texture As _Unsigned _Offset)
        Function IsRenderTextureReady%% (ByVal target As _Unsigned _Offset)
        Sub UnloadRenderTexture (ByVal target As _Unsigned _Offset)
        Sub UpdateTexture (ByVal texture As _Unsigned _Offset, Byval pixels As _Unsigned _Offset)
        Sub UpdateTextureRec (ByVal texture As _Unsigned _Offset, Byval rec As _Unsigned _Offset, Byval pixels As _Unsigned _Offset)
        Sub GenTextureMipmaps (ByVal texture As _Unsigned _Offset)
        Sub SetTextureFilter (ByVal texture As _Unsigned _Offset, Byval filter As Long)
        Sub SetTextureWrap (ByVal texture As _Unsigned _Offset, Byval wrap As Long)
        Sub DrawTexture (ByVal texture As _Unsigned _Offset, Byval posX As Long, Byval posY As Long, Byval tint As _Unsigned _Offset)
        Sub DrawTextureV (ByVal texture As _Unsigned _Offset, Byval position As _Unsigned _Offset, Byval tint As _Unsigned _Offset)
        Sub DrawTextureEx (ByVal texture As _Unsigned _Offset, Byval position As _Unsigned _Offset, Byval rotation As Single, Byval scale As Single, Byval tint As _Unsigned _Offset)
        Sub DrawTextureRec (ByVal texture As _Unsigned _Offset, Byval source As _Unsigned _Offset, Byval position As _Unsigned _Offset, Byval tint As _Unsigned _Offset)
        Sub DrawTexturePro (ByVal texture As _Unsigned _Offset, Byval source As _Unsigned _Offset, Byval dest As _Unsigned _Offset, Byval origin As _Unsigned _Offset, Byval rotation As Single, Byval tint As _Unsigned _Offset)
        Sub DrawTextureNPatch (ByVal texture As _Unsigned _Offset, Byval nPatchInfo As _Unsigned _Offset, Byval dest As _Unsigned _Offset, Byval origin As _Unsigned _Offset, Byval rotation As Single, Byval tint As _Unsigned _Offset)
        Sub Fade (ByVal color As _Unsigned _Offset, Byval alpha As Single, Byval retVal As _Unsigned _Offset)
        Function ColorToInt& (ByVal color As _Unsigned _Offset)
        Sub ColorNormalize (ByVal color As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Sub ColorFromNormalized (ByVal normalized As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Sub ColorToHSV (ByVal color As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Sub ColorFromHSV (ByVal hue As Single, Byval saturation As Single, Byval value As Single, Byval retVal As _Unsigned _Offset)
        Sub ColorTint (ByVal color As _Unsigned _Offset, Byval tint As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Sub ColorBrightness (ByVal color As _Unsigned _Offset, Byval factor As Single, Byval retVal As _Unsigned _Offset)
        Sub ColorContrast (ByVal color As _Unsigned _Offset, Byval contrast As Single, Byval retVal As _Unsigned _Offset)
        Sub ColorAlpha (ByVal color As _Unsigned _Offset, Byval alpha As Single, Byval retVal As _Unsigned _Offset)
        Sub ColorAlphaBlend (ByVal dst As _Unsigned _Offset, Byval src As _Unsigned _Offset, Byval tint As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Sub GetColor (ByVal hexValue As _Unsigned Long, Byval retVal As _Unsigned _Offset)
        Sub GetPixelColor (ByVal srcPtr As _Unsigned _Offset, Byval format As Long, Byval retVal As _Unsigned _Offset)
        Sub SetPixelColor (ByVal dstPtr As _Unsigned _Offset, Byval color As _Unsigned _Offset, Byval format As Long)
        Function GetPixelDataSize& (ByVal width As Long, Byval height As Long, Byval format As Long)
        Sub GetFontDefault (ByVal retVal As _Unsigned _Offset)
        Sub __LoadFont Alias LoadFont (fileName As String, Byval retVal As _Unsigned _Offset)
        Sub __LoadFontEx Alias LoadFontEx (fileName As String, Byval fontSize As Long, Byval fontChars As _Unsigned _Offset, Byval glyphCount As Long, Byval retVal As _Unsigned _Offset)
        Sub LoadFontFromImage (ByVal image As _Unsigned _Offset, Byval key As _Unsigned _Offset, Byval firstChar As Long, Byval retVal As _Unsigned _Offset)
        Sub __LoadFontFromMemory Alias LoadFontFromMemory (fileType As String, fileData As String, Byval dataSize As Long, Byval fontSize As Long, Byval fontChars As _Unsigned _Offset, Byval glyphCount As Long, Byval retVal As _Unsigned _Offset)
        Function IsFontReady%% (ByVal font As _Unsigned _Offset)
        Function LoadFontData~%& (ByVal fileData As _Unsigned _Offset, Byval dataSize As _Unsigned Long, Byval fontSize As Long, Byval fontChars As _Unsigned _Offset, Byval glyphCount As Long, Byval type As Long)
        Sub GenImageFontAtlas (ByVal chars As _Unsigned _Offset, Byval recs As _Unsigned _Offset, Byval glyphCount As Long, Byval fontSize As Long, Byval padding As Long, Byval packMethod As Long, Byval retVal As _Unsigned _Offset)
        Sub UnloadFontData (ByVal chars As _Unsigned _Offset, Byval glyphCount As Long)
        Sub UnloadFont (ByVal font As _Unsigned _Offset)
        Function __ExportFontAsCode%% Alias ExportFontAsCode (ByVal font As _Unsigned _Offset, fileName As String)
        Sub DrawFPS (ByVal posX As Long, Byval posY As Long)
        Sub __DrawText Alias DrawText (text As String, Byval posX As Long, Byval posY As Long, Byval fontSize As Long, Byval color As _Unsigned _Offset)
        Sub __DrawTextEx Alias DrawTextEx (ByVal font As _Unsigned _Offset, text As String, Byval position As _Unsigned _Offset, Byval fontSize As Single, Byval spacing As Single, Byval tint As _Unsigned _Offset)
        Sub __DrawTextPro Alias DrawTextPro (ByVal font As _Unsigned _Offset, text As String, Byval position As _Unsigned _Offset, Byval origin As _Unsigned _Offset, Byval rotation As Single, Byval fontSize As Single, Byval spacing As Single, Byval tint As _Unsigned _Offset)
        Sub DrawTextCodepoint (ByVal font As _Unsigned _Offset, Byval codepoint As Long, Byval position As _Unsigned _Offset, Byval fontSize As Single, Byval tint As _Unsigned _Offset)
        Sub DrawTextCodepoints (ByVal font As _Unsigned _Offset, Byval codepoints As _Unsigned _Offset, Byval count As Long, Byval position As _Unsigned _Offset, Byval fontSize As Single, Byval spacing As Single, Byval tint As _Unsigned _Offset)
        Function __MeasureText& Alias MeasureText (text As String, Byval fontSize As Long)
        Sub __MeasureTextEx Alias MeasureTextEx (ByVal font As _Unsigned _Offset, text As String, Byval fontSize As Single, Byval spacing As Single, Byval retVal As _Unsigned _Offset)
        Function GetGlyphIndex& (ByVal font As _Unsigned _Offset, Byval codepoint As Long)
        Sub GetGlyphInfo (ByVal font As _Unsigned _Offset, Byval codepoint As Long, Byval retVal As _Unsigned _Offset)
        Sub GetGlyphAtlasRec (ByVal font As _Unsigned _Offset, Byval codepoint As Long, Byval retVal As _Unsigned _Offset)
        Function LoadUTF8~%& (ByVal codepoints As _Unsigned _Offset, Byval length As Long)
        Sub UnloadUTF8 (ByVal text As _Unsigned _Offset)
        Function __LoadCodepoints~%& Alias LoadCodepoints (text As String, count As _Unsigned Long)
        Sub UnloadCodepoints (ByVal codepoints As _Unsigned _Offset)
        Function __GetCodepointCount& Alias GetCodepointCount (text As String)
        Function __GetCodepoint& Alias GetCodepointCount (text As String, Byval codepointSize As _Unsigned _Offset)
        Function __GetCodepointNext& Alias GetCodepointNext (text As String, Byval codepointSize As _Unsigned _Offset)
        Function __GetCodepointPrevious& Alias GetCodepointPrevious (text As String, Byval codepointSize As _Unsigned _Offset)
        Function CodepointToUTF8$ (ByVal codepoint As Long, Byval utf8Size As _Unsigned _Offset)
        Function TextCopy& (dst As String, src As String)
        Function TextIsEqual%% (text1 As String, text2 As String)
        Function TextLength~& (text As String)
        Function TextFormat$ (text As String, s As String) ' TODO: overloaded!
        Function TextSubtext$ (text As String, Byval position As Long, Byval length As Long)
        Function TextReplace$ (text As String, replace As String, by As String)
        Function TextInsert$ (text As String, insert As String, Byval position As Long)
        Function TextJoin$ (textList As String, Byval count As Long, delimiter As String)
        Function TextSplit$ (text As String, Byval delimiter As _Byte, Byval count As _Unsigned _Offset)
        Sub TextAppend (text As String, append As String, Byval position As _Unsigned _Offset)
        Function __TextFindIndex& Alias TextFindIndex (text As String, find As String)
        Function TextToUpper$ (text As String)
        Function TextToLower$ (text As String)
        Function TextToPascal$ (text As String)
        Function __TextToInteger& Alias TextToInteger (text As String)
        Sub DrawLine3D (ByVal startPos As _Unsigned _Offset, Byval endPos As _Unsigned _Offset, Byval color As _Unsigned _Offset)
        Sub DrawPoint3D (ByVal position As _Unsigned _Offset, Byval color As _Unsigned _Offset)
        Sub DrawCircle3D (ByVal center As _Unsigned _Offset, Byval radius As Single, Byval rotationAxis As _Unsigned _Offset, Byval rotationAngle As Single, Byval color As _Unsigned _Offset)
        Sub DrawTriangle3D (ByVal v1 As _Unsigned _Offset, Byval v2 As _Unsigned _Offset, Byval v3 As _Unsigned _Offset, Byval color As _Unsigned _Offset)
        Sub DrawTriangleStrip3D (ByVal points As _Unsigned _Offset, Byval pointCount As Long, Byval color As _Unsigned _Offset)
        Sub DrawCube (ByVal position As _Unsigned _Offset, Byval width As Single, Byval height As Single, Byval length As Single, Byval color As _Unsigned _Offset)
        Sub DrawCubeV (ByVal position As _Unsigned _Offset, Byval size As _Unsigned _Offset, Byval color As _Unsigned _Offset)
        Sub DrawCubeWires (ByVal position As _Unsigned _Offset, Byval width As Single, Byval height As Single, Byval length As Single, Byval color As _Unsigned _Offset)
        Sub DrawCubeWiresV (ByVal position As _Unsigned _Offset, Byval size As _Unsigned _Offset, Byval color As _Unsigned _Offset)
        Sub DrawSphere (ByVal centerPos As _Unsigned _Offset, Byval radius As Single, Byval color As _Unsigned _Offset)
        Sub DrawSphereEx (ByVal centerPos As _Unsigned _Offset, Byval radius As Single, Byval rings As Long, Byval slices As Long, Byval color As _Unsigned _Offset)
        Sub DrawSphereWires (ByVal centerPos As _Unsigned _Offset, Byval radius As Single, Byval rings As Long, Byval slices As Long, Byval color As _Unsigned _Offset)
        Sub DrawCylinder (ByVal position As _Unsigned _Offset, Byval radiusTop As Single, Byval radiusBottom As Single, Byval height As Single, Byval slices As Long, Byval color As _Unsigned _Offset)
        Sub DrawCylinderEx (ByVal startPos As _Unsigned _Offset, Byval endPos As _Unsigned _Offset, Byval startRadius As Single, Byval endRadius As Single, Byval sides As Long, Byval color As _Unsigned _Offset)
        Sub DrawCylinderWires (ByVal position As _Unsigned _Offset, Byval radiusTop As Single, Byval radiusBottom As Single, Byval height As Single, Byval slices As Long, Byval color As _Unsigned _Offset)
        Sub DrawCylinderWiresEx (ByVal startPos As _Unsigned _Offset, Byval endPos As _Unsigned _Offset, Byval startRadius As Single, Byval endRadius As Single, Byval sides As Long, Byval color As _Unsigned _Offset)
        Sub DrawCapsule (ByVal startPos As _Unsigned _Offset, Byval endPos As _Unsigned _Offset, Byval radius As Single, Byval slices As Long, Byval rings As Long, Byval color As _Unsigned _Offset)
        Sub DrawCapsuleWires (ByVal startPos As _Unsigned _Offset, Byval endPos As _Unsigned _Offset, Byval radius As Single, Byval slices As Long, Byval rings As Long, Byval color As _Unsigned _Offset)
        Sub DrawPlane (ByVal centerPos As _Unsigned _Offset, Byval size As _Unsigned _Offset, Byval color As _Unsigned _Offset)
        Sub DrawRay (ByVal ray As _Unsigned _Offset, Byval color As _Unsigned _Offset)
        Sub DrawGrid (ByVal slices As Long, Byval spacing As Single)
        Sub LoadModel (fileName As String, Byval retVal As _Unsigned _Offset)
        Sub LoadModelFromMesh (ByVal mesh As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Function IsModelReady%% (ByVal model As _Unsigned _Offset)
        Sub UnloadModel (ByVal model As _Unsigned _Offset)
        Sub GetModelBoundingBox (ByVal model As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Sub DrawModel (ByVal model As _Unsigned _Offset, Byval position As _Unsigned _Offset, Byval scale As Single, Byval tint As _Unsigned _Offset)
        Sub DrawModelEx (ByVal model As _Unsigned _Offset, Byval position As _Unsigned _Offset, Byval rotationAxis As _Unsigned _Offset, Byval rotationAngle As Single, Byval scale As _Unsigned _Offset, Byval tint As _Unsigned _Offset)
        Sub DrawModelWires (ByVal model As _Unsigned _Offset, Byval position As _Unsigned _Offset, Byval scale As Single, Byval tint As _Unsigned _Offset)
        Sub DrawModelWiresEx (ByVal model As _Unsigned _Offset, Byval position As _Unsigned _Offset, Byval rotationAxis As _Unsigned _Offset, Byval rotationAngle As Single, Byval scale As _Unsigned _Offset, Byval tint As _Unsigned _Offset)
        Sub DrawBoundingBox (ByVal box As _Unsigned _Offset, Byval color As _Unsigned _Offset)
        Sub DrawBillboard (ByVal camera As _Unsigned _Offset, Byval texture As _Unsigned _Offset, Byval position As _Unsigned _Offset, Byval size As Single, Byval tint As _Unsigned _Offset)
        Sub DrawBillboardRec (ByVal camera As _Unsigned _Offset, Byval texture As _Unsigned _Offset, Byval source As _Unsigned _Offset, Byval position As _Unsigned _Offset, Byval size As _Unsigned _Offset, Byval tint As _Unsigned _Offset)
        Sub DrawBillboardPro (ByVal camera As _Unsigned _Offset, Byval texture As _Unsigned _Offset, Byval source As _Unsigned _Offset, Byval position As _Unsigned _Offset, Byval up As _Unsigned _Offset, Byval size As _Unsigned _Offset, Byval origin As _Unsigned _Offset, Byval rotation As Single, Byval tint As _Unsigned _Offset)
        Sub UploadMesh (ByVal mesh As _Unsigned _Offset, Byval dynamic As _Byte)
        Sub UpdateMeshBuffer (ByVal mesh As _Unsigned _Offset, Byval index As Long, Byval dat As _Unsigned _Offset, Byval dataSize As Long, Byval ofst As Long)
        Sub UnloadMesh (ByVal mesh As _Unsigned _Offset)
        Sub DrawMesh (ByVal mesh As _Unsigned _Offset, Byval material As _Unsigned _Offset, Byval transform As _Unsigned _Offset)
        Sub DrawMeshInstanced (ByVal mesh As _Unsigned _Offset, Byval material As _Unsigned _Offset, Byval transforms As _Unsigned _Offset, Byval instances As Long)
        Function ExportMesh%% (ByVal mesh As _Unsigned _Offset, fileName As String)
        Sub GetMeshBoundingBox (ByVal mesh As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Sub GenMeshTangents (ByVal mesh As _Unsigned _Offset)
        Sub GenMeshPoly (ByVal sides As Long, Byval radius As Single, Byval retVal As _Unsigned _Offset)
        Sub GenMeshPlane (ByVal width As Single, Byval length As Single, Byval resX As Long, Byval resZ As Long, Byval retVal As _Unsigned _Offset)
        Sub GenMeshCube (ByVal width As Single, Byval height As Single, Byval length As Single, Byval retVal As _Unsigned _Offset)
        Sub GenMeshSphere (ByVal radius As Single, Byval rings As Long, Byval slices As Long, Byval retVal As _Unsigned _Offset)
        Sub GenMeshHemiSphere (ByVal radius As Single, Byval rings As Long, Byval slices As Long, Byval retVal As _Unsigned _Offset)
        Sub GenMeshCylinder (ByVal radius As Single, Byval height As Single, Byval slices As Long, Byval retVal As _Unsigned _Offset)
        Sub GenMeshCone (ByVal radius As Single, Byval height As Single, Byval slices As Long, Byval retVal As _Unsigned _Offset)
        Sub GenMeshTorus (ByVal radius As Single, Byval size As Single, Byval radSeg As Long, Byval sides As Long, Byval retVal As _Unsigned _Offset)
        Sub GenMeshKnot (ByVal radius As Single, Byval size As Single, Byval radSeg As Long, Byval sides As Long, Byval retVal As _Unsigned _Offset)
        Sub GenMeshHeightmap (ByVal heightmap As _Unsigned _Offset, Byval size As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Sub GenMeshCubicmap (ByVal cubicmap As _Unsigned _Offset, Byval cubeSize As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Function LoadMaterials~%& (fileName As String, Byval materialCount As _Unsigned _Offset)
        Sub LoadMaterialDefault (ByVal retVal As _Unsigned _Offset)
        Function IsMaterialReady%% (ByVal material As _Unsigned _Offset)
        Sub UnloadMaterial (ByVal material As _Unsigned _Offset)
        Sub SetMaterialTexture (ByVal material As _Unsigned _Offset, Byval mapType As Long, Byval texture As _Unsigned _Offset)
        Sub SetModelMeshMaterial (ByVal model As _Unsigned _Offset, Byval meshId As Long, Byval materialId As Long)
        Function LoadModelAnimations~%& (fileName As String, Byval animCount As _Unsigned _Offset)
        Sub UpdateModelAnimation (ByVal model As _Unsigned _Offset, Byval anim As _Unsigned _Offset, Byval frame As Long)
        Sub UnloadModelAnimation (ByVal anim As _Unsigned _Offset)
        Sub UnloadModelAnimations (ByVal animations As _Unsigned _Offset, Byval count As _Unsigned Long)
        Function IsModelAnimationValid%% (ByVal model As _Unsigned _Offset, Byval anim As _Unsigned _Offset)
        Function CheckCollisionSpheres%% (ByVal center1 As _Unsigned _Offset, Byval radius1 As Single, Byval center2 As _Unsigned _Offset, Byval radius2 As Single)
        Function CheckCollisionBoxes%% (ByVal box1 As _Unsigned _Offset, Byval box2 As _Unsigned _Offset)
        Function CheckCollisionBoxSphere%% (ByVal box As _Unsigned _Offset, Byval center As _Unsigned _Offset, Byval radius As Single)
        Sub GetRayCollisionSphere (ByVal ray As _Unsigned _Offset, Byval center As _Unsigned _Offset, Byval radius As Single, Byval retVal As _Unsigned _Offset)
        Sub GetRayCollisionBox (ByVal ray As _Unsigned _Offset, Byval box As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Sub GetRayCollisionMesh (ByVal ray As _Unsigned _Offset, Byval mesh As _Unsigned _Offset, Byval transform As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Sub GetRayCollisionTriangle (ByVal ray As _Unsigned _Offset, Byval p1 As _Unsigned _Offset, Byval p2 As _Unsigned _Offset, Byval p3 As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Sub GetRayCollisionQuad (ByVal ray As _Unsigned _Offset, Byval p1 As _Unsigned _Offset, Byval p2 As _Unsigned _Offset, Byval p3 As _Unsigned _Offset, Byval p4 As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Sub InitAudioDevice
        Sub CloseAudioDevice
        Function IsAudioDeviceReady%%
        Sub SetMasterVolume (ByVal volume As Single)
        Sub LoadWave (fileName As String, Byval retVal As _Unsigned _Offset)
        Sub LoadWaveFromMemory (fileType As String, fileData As String, Byval dataSize As Long, Byval retVal As _Unsigned _Offset)
        Function IsWaveReady%% (ByVal wave As _Unsigned _Offset)
        Sub LoadSound (fileName As String, Byval retVal As _Unsigned _Offset)
        Sub LoadSoundFromWave (ByVal wave As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Function IsSoundReady%% (ByVal sound As _Unsigned _Offset)
        Sub UpdateSound (ByVal sound As _Unsigned _Offset, Byval dat As _Unsigned _Offset, Byval sampleCount As Long)
        Sub UnloadWave (ByVal wave As _Unsigned _Offset)
        Sub UnloadSound (ByVal sound As _Unsigned _Offset)
        Function ExportWave%% (ByVal wave As _Unsigned _Offset, fileName As String)
        Function ExportWaveAsCode%% (ByVal wave As _Unsigned _Offset, fileName As String)
        Sub PlaySound (ByVal sound As _Unsigned _Offset)
        Sub StopSound (ByVal sound As _Unsigned _Offset)
        Sub PauseSound (ByVal sound As _Unsigned _Offset)
        Sub ResumeSound (ByVal sound As _Unsigned _Offset)
        Function IsSoundPlaying%% (ByVal sound As _Unsigned _Offset)
        Sub SetSoundVolume (ByVal sound As _Unsigned _Offset, Byval volume As Single)
        Sub SetSoundPitch (ByVal sound As _Unsigned _Offset, Byval pitch As Single)
        Sub SetSoundPan (ByVal sound As _Unsigned _Offset, Byval pan As Single)
        Sub WaveCopy (ByVal wave As _Unsigned _Offset, Byval retVal As _Unsigned _Offset)
        Sub WaveCrop (ByVal wave As _Unsigned _Offset, Byval initSample As Long, Byval finalSample As Long)
        Sub WaveFormat (ByVal wave As _Unsigned _Offset, Byval sampleRate As Long, Byval sampleSize As Long, Byval channels As Long)
        Function LoadWaveSamples~%& (ByVal wave As _Unsigned _Offset)
        Sub UnloadWaveSamples (ByVal samples As _Unsigned _Offset)
        Sub LoadMusicStream (fileName As String, Byval retVal As _Unsigned _Offset)
        Sub LoadMusicStreamFromMemory (fileType As String, dat As String, Byval dataSize As Long, Byval retVal As _Unsigned _Offset)
        Function IsMusicReady%% (ByVal music As _Unsigned _Offset)
        Sub UnloadMusicStream (ByVal music As _Unsigned _Offset)
        Sub PlayMusicStream (ByVal music As _Unsigned _Offset)
        Function IsMusicStreamPlaying%% (ByVal music As _Unsigned _Offset)
        Sub UpdateMusicStream (ByVal music As _Unsigned _Offset)
        Sub StopMusicStream (ByVal music As _Unsigned _Offset)
        Sub PauseMusicStream (ByVal music As _Unsigned _Offset)
        Sub ResumeMusicStream (ByVal music As _Unsigned _Offset)
        Sub SeekMusicStream (ByVal music As _Unsigned _Offset, Byval position As Single)
        Sub SetMusicVolume (ByVal music As _Unsigned _Offset, Byval volume As Single)
        Sub SetMusicPitch (ByVal music As _Unsigned _Offset, Byval pitch As Single)
        Sub SetMusicPan (ByVal music As _Unsigned _Offset, Byval pan As Single)
        Function GetMusicTimeLength! (ByVal music As _Unsigned _Offset)
        Function GetMusicTimePlayed! (ByVal music As _Unsigned _Offset)
        Sub LoadAudioStream (ByVal sampleRate As _Unsigned Long, Byval sampleSize As _Unsigned Long, Byval channels As _Unsigned Long, Byval retVal As _Unsigned _Offset)
        Function IsAudioStreamReady%% (ByVal stream As _Unsigned _Offset)
        Sub UnloadAudioStream (ByVal stream As _Unsigned _Offset)
        Sub UpdateAudioStream (ByVal stream As _Unsigned _Offset, Byval dat As _Unsigned _Offset, Byval frameCount As Long)
        Function IsAudioStreamProcessed%% (ByVal stream As _Unsigned _Offset)
        Sub PlayAudioStream (ByVal stream As _Unsigned _Offset)
        Sub PauseAudioStream (ByVal stream As _Unsigned _Offset)
        Sub ResumeAudioStream (ByVal stream As _Unsigned _Offset)
        Function IsAudioStreamPlaying%% (ByVal stream As _Unsigned _Offset)
        Sub StopAudioStream (ByVal stream As _Unsigned _Offset)
        Sub SetAudioStreamVolume (ByVal stream As _Unsigned _Offset, Byval volume As Single)
        Sub SetAudioStreamPitch (ByVal stream As _Unsigned _Offset, Byval pitch As Single)
        Sub SetAudioStreamPan (ByVal stream As _Unsigned _Offset, Byval pan As Single)
        Sub SetAudioStreamBufferSizeDefault (ByVal size As Long)
        Sub SetAudioStreamCallback (ByVal stream As _Unsigned _Offset, Byval callback As _Unsigned _Offset)
        Sub AttachAudioStreamProcessor (ByVal stream As _Unsigned _Offset, Byval processor As _Unsigned _Offset)
        Sub DetachAudioStreamProcessor (ByVal stream As _Unsigned _Offset, Byval processor As _Unsigned _Offset)
        Sub AttachAudioMixedProcessor (ByVal processor As _Unsigned _Offset)
        Sub DetachAudioMixedProcessor (ByVal processor As _Unsigned _Offset)
    End Declare

    ' Initialize the C-side glue code
    If __init_raylib Then
        _Delay 0.1 ' the delay is needed for the console window to appear
        _Console Off ' hide the console by default
    Else
        Print "raylib initialization failed!"
        End 1
    End If

$End If
'-----------------------------------------------------------------------------------------------------------------------
