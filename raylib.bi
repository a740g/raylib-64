'-----------------------------------------------------------------------------------------------------
' raylib bindings for QB64-PE
' Copyright (c) 2023 Samuel Gomes
'-----------------------------------------------------------------------------------------------------

$IF RAYLIB_BI = UNDEFINED THEN
    $LET RAYLIB_BI = TRUE

    ' Check QB64-PE compiler version and complain if it does not meet minimum version requirement
    $IF VERSION < 3.7 THEN
            $ERROR This requires the latest version of QB64-PE from https://github.com/QB64-Phoenix-Edition/QB64pe/releases
    $END IF

    ' All identifiers must default to long (32-bits). This results in fastest code execution on x86 & x64
    DEFLNG A-Z

    ' Force all arrays to be defined
    OPTION _EXPLICITARRAY

    ' Force all variables to be defined
    OPTION _EXPLICIT

    ' All arrays should be static. If dynamic arrays are required use "ReDim"
    '$STATIC

    ' Start array lower bound from 1. If 0 is required, then it should be explicitly specified as (0 To X)
    OPTION BASE 1

    ' raylib uses it's own window. So, we force QB64-PE to generate a console only executable. The console can be used for debugging
    $CONSOLE:ONLY

    ' Some common and useful constants
    CONST FALSE = 0, TRUE = NOT FALSE
    CONST NULL = 0

    ' Vector2, 2 components
    TYPE Vector2
        x AS SINGLE ' Vector x component
        y AS SINGLE ' Vector y component
    END TYPE

    ' Vector3, 3 components
    TYPE Vector3
        x AS SINGLE ' Vector x component
        y AS SINGLE ' Vector y component
        z AS SINGLE ' Vector z component
    END TYPE

    ' Matrix, 4x4 components, column major, OpenGL style, right-handed
    TYPE Matrix
        AS SINGLE m0, m4, m8, m12 ' Matrix first row (4 components)
        AS SINGLE m1, m5, m9, m13 ' Matrix second row (4 components)
        AS SINGLE m2, m6, m10, m14 ' Matrix third row (4 components)
        AS SINGLE m3, m7, m11, m15 ' Matrix fourth row (4 components)
    END TYPE

    ' Color, 4 components, R8G8B8A8 (32bit)
    TYPE RColor
        r AS _UNSIGNED _BYTE ' Color red value
        g AS _UNSIGNED _BYTE ' Color green value
        b AS _UNSIGNED _BYTE ' Color blue value
        a AS _UNSIGNED _BYTE ' Color alpha value
    END TYPE

    ' Image, pixel data stored in CPU memory (RAM)
    TYPE Image
        dat AS _OFFSET ' Image raw data
        w AS LONG ' Image base width
        h AS LONG ' Image base height
        mipmaps AS LONG ' Mipmap levels, 1 by default
        format AS LONG ' Data format (PixelFormat type)
    END TYPE

    ' Texture, tex data stored in GPU memory (VRAM)
    TYPE Texture
        id AS LONG ' OpenGL texture id
        w AS LONG ' Texture base width
        h AS LONG ' Texture base height
        mipmaps AS LONG ' Mipmap levels, 1 by default
        format AS LONG ' Data format (PixelFormat type)
    END TYPE

    ' Texture2D, same as Texture
    TYPE Texture2D
        id AS LONG ' OpenGL texture id
        w AS LONG ' Texture base width
        h AS LONG ' Texture base height
        mipmaps AS LONG ' Mipmap levels, 1 by default
        format AS LONG ' Data format (PixelFormat type)
    END TYPE

    ' TextureCubemap, same as Texture
    TYPE TextureCubemap
        id AS LONG ' OpenGL texture id
        w AS LONG ' Texture base width
        h AS LONG ' Texture base height
        mipmaps AS LONG ' Mipmap levels, 1 by default
        format AS LONG ' Data format (PixelFormat type)
    END TYPE

    ' RenderTexture, fbo for texture rendering
    TYPE RenderTexture
        id AS LONG ' OpenGL framebuffer object id
        texture AS Texture ' Color buffer attachment texture
        depth AS Texture ' Depth buffer attachment texture
    END TYPE

    ' RenderTexture2D, same as RenderTexture
    TYPE RenderTexture2D
        id AS LONG ' OpenGL framebuffer object id
        texture AS Texture ' Color buffer attachment texture
        depth AS Texture ' Depth buffer attachment texture
    END TYPE

    ' Camera, defines position/orientation in 3d space
    TYPE Camera3D
        position AS Vector3 ' Camera position
        target AS Vector3 ' Camera target it looks-at
        up AS Vector3 ' Camera up vector (rotation over its axis)
        fovy AS SINGLE ' Camera field-of-view aperture in Y (degrees) in perspective, used as near plane width in orthographic
        projection AS LONG ' Camera projection: CAMERA_PERSPECTIVE or CAMERA_ORTHOGRAPHIC
    END TYPE

    ' Camera type fallback, defaults to Camera3D
    TYPE Camera
        position AS Vector3 ' Camera position
        target AS Vector3 ' Camera target it looks-at
        up AS Vector3 ' Camera up vector (rotation over its axis)
        fovy AS SINGLE ' Camera field-of-view aperture in Y (degrees) in perspective, used as near plane width in orthographic
        projection AS LONG ' Camera projection: CAMERA_PERSPECTIVE or CAMERA_ORTHOGRAPHIC
    END TYPE

    ' Camera2D, defines position/orientation in 2d space
    TYPE Camera2D
        offset AS Vector2 ' Camera offset (displacement from target)
        target AS Vector2 ' Camera target (rotation and zoom origin)
        rotation AS SINGLE ' Camera rotation in degrees
        zoom AS SINGLE ' Camera zoom (scaling), should be 1.0f by default
    END TYPE

    ' Shader
    TYPE Shader
        id AS LONG ' Shader program id
        locs AS _OFFSET ' Shader locations array (RL_MAX_SHADER_LOCATIONS)
    END TYPE

    ' VrDeviceInfo, Head-Mounted-Display device parameters
    TYPE VrDeviceInfo
        hResolution AS LONG ' Horizontal resolution in pixels
        vResolution AS LONG ' Vertical resolution in pixels
        hScreenSize AS SINGLE ' Horizontal size in meters
        vScreenSize AS SINGLE ' Vertical size in meters
        vScreenCenter AS SINGLE ' Screen center in meters
        eyeToScreenDistance AS SINGLE ' Distance between eye and display in meters
        lensSeparationDistance AS SINGLE ' Lens separation distance in meters
        interpupillaryDistance AS SINGLE ' IPD (distance between pupils) in meters
        AS SINGLE lensDistortionValues0, lensDistortionValues1, lensDistortionValues2, lensDistortionValues3 ' Lens distortion constant parameters
        AS SINGLE chromaAbCorrection0, chromaAbCorrection1, chromaAbCorrection2, chromaAbCorrection3 ' Chromatic aberration correction parameters
    END TYPE

    ' VrStereoConfig, VR stereo rendering configuration for simulator
    TYPE VrStereoConfig
        AS Matrix projection0, projection1 ' VR projection matrices (per eye)
        AS Matrix viewOffset0, viewOffset1 ' VR view offset matrices (per eye)
        AS SINGLE leftLensCenter0, leftLensCenter1 ' VR left lens center
        AS SINGLE rightLensCenter0, rightLensCenter1 ' VR right lens center
        AS SINGLE leftScreenCenter0, leftScreenCenter1 ' VR left screen center
        AS SINGLE rightScreenCenter0, rightScreenCenter1 ' VR right screen center
        AS SINGLE scale0, scale1 ' VR distortion scale
        AS SINGLE scaleIn0, scaleIn1 ' VR distortion scale in
    END TYPE

    ' These are funtions that wraps stuff that cannot be used directly
    DECLARE STATIC LIBRARY "./raylib"
        FUNCTION __init_raylib%%

        SUB GetMonitorPosition (BYVAL monitor AS LONG, v AS Vector2)
        SUB GetWindowPosition (v AS Vector2)
        SUB GetWindowScaleDPI (v AS Vector2)

        SUB LoadVrStereoConfig (device AS VrDeviceInfo, config AS VrStereoConfig)
    END DECLARE

    ' These are functions that can be used directly from the dynamic library and does not need a wrapper
    ' Stuff with leading `__` are not supposed to be called directly. Use the wrapper functions instead
    $IF WINDOWS OR LINUX OR MACOSX AND 64BIT THEN
        DECLARE DYNAMIC LIBRARY "./raylib"
            ' Window-related functions
            SUB __InitWindow ALIAS InitWindow (BYVAL w AS LONG, BYVAL h AS LONG, title AS STRING) ' Initialize window and OpenGL context
            FUNCTION WindowShouldClose%% ' Check if KEY_ESCAPE pressed or Close icon pressed
            SUB CloseWindow ' Close window and unload OpenGL context
            FUNCTION IsWindowReady%% ' Check if window has been initialized successfully
            FUNCTION IsWindowFullscreen%% ' Check if window is currently fullscreen
            FUNCTION IsWindowHidden%% ' Check if window is currently hidden (only PLATFORM_DESKTOP)
            FUNCTION IsWindowMinimized%% ' Check if window is currently minimized (only PLATFORM_DESKTOP)
            FUNCTION IsWindowMaximized%% ' Check if window is currently maximized (only PLATFORM_DESKTOP)
            FUNCTION IsWindowFocused%% ' Check if window is currently focused (only PLATFORM_DESKTOP)
            FUNCTION IsWindowResized%% ' Check if window has been resized last frame
            FUNCTION IsWindowState (BYVAL flag AS _UNSIGNED LONG) ' Check if one specific window flag is enabled
            SUB SetWindowState (BYVAL flags AS _UNSIGNED LONG) ' Set window configuration state using flags (only PLATFORM_DESKTOP)
            SUB ClearWindowState (BYVAL flags AS _UNSIGNED LONG) ' Clear window configuration state flags
            SUB ToggleFullscreen ' Toggle window state: fullscreen/windowed (only PLATFORM_DESKTOP)
            SUB MaximizeWindow ' Set window state: maximized, if resizable (only PLATFORM_DESKTOP)
            SUB MinimizeWindow ' Set window state: minimized, if resizable (only PLATFORM_DESKTOP)
            SUB RestoreWindow ' Set window state: not minimized/maximized (only PLATFORM_DESKTOP)
            'RLAPI void SetWindowIcon(Image image); // Set icon for window (single image, RGBA 32bit, only PLATFORM_DESKTOP)
            SUB SetWindowIcons (BYVAL images AS _OFFSET, BYVAL count AS LONG) ' Set icon for window (multiple images, RGBA 32bit, only PLATFORM_DESKTOP)
            SUB __SetWindowTitle ALIAS SetWindowTitle (title AS STRING) ' Set title for window (only PLATFORM_DESKTOP)
            SUB SetWindowPosition (BYVAL x AS LONG, BYVAL y AS LONG) ' Set window position on screen (only PLATFORM_DESKTOP)
            SUB SetWindowMonitor (BYVAL monitor AS LONG) ' Set monitor for the current window (fullscreen mode)
            SUB SetWindowMinSize (BYVAL w AS LONG, BYVAL h AS LONG) ' Set window minimum dimensions (for FLAG_WINDOW_RESIZABLE)
            SUB SetWindowSize (BYVAL w AS LONG, BYVAL h AS LONG) ' Set window dimensions
            SUB SetWindowOpacity (BYVAL opacity AS SINGLE) ' Set window opacity [0.0f..1.0f] (only PLATFORM_DESKTOP)
            FUNCTION GetWindowHandle%& ' Get native window handle
            FUNCTION GetScreenWidth& ' Get current screen width
            FUNCTION GetScreenHeight& ' Get current screen height
            FUNCTION GetRenderWidth& ' Get current render width (it considers HiDPI)
            FUNCTION GetRenderHeight& ' Get current render height (it considers HiDPI)
            FUNCTION GetMonitorCount& ' Get number of connected monitors
            FUNCTION GetCurrentMonitor& ' Get current connected monitor
            'RLAPI Vector2 GetMonitorPosition(int monitor); // Get specified monitor position
            FUNCTION GetMonitorWidth& (BYVAL monitor AS LONG) ' Get specified monitor width (current video mode used by monitor)
            FUNCTION GetMonitorHeight& (BYVAL monitor AS LONG) ' Get specified monitor height (current video mode used by monitor)
            FUNCTION GetMonitorPhysicalWidth& (BYVAL monitor AS LONG) ' Get specified monitor physical width in millimetres
            FUNCTION GetMonitorPhysicalHeight& (BYVAL monitor AS LONG) ' Get specified monitor physical height in millimetres
            FUNCTION GetMonitorRefreshRate& (BYVAL monitor AS LONG) ' Get specified monitor refresh rate
            'RLAPI Vector2 GetWindowPosition(void); // Get window position XY on monitor
            'RLAPI Vector2 GetWindowScaleDPI(void); // Get window scale DPI factor
            FUNCTION GetMonitorName$ (BYVAL monitor AS LONG) ' Get the human-readable, UTF-8 encoded name of the primary monitor
            SUB __SetClipboardText ALIAS SetClipboardText (text AS STRING) ' Set clipboard text content
            FUNCTION GetClipboardText$ ' Get clipboard text content
            SUB EnableEventWaiting ' Enable waiting for events on EndDrawing(), no automatic event polling
            SUB DisableEventWaiting ' Disable waiting for events on EndDrawing(), automatic events polling

            ' Custom frame control functions
            ' NOTE: Those functions are intended for advance users that want full control over the frame processing
            ' By default EndDrawing() does this job: draws everything + SwapScreenBuffer() + manage frame timing + PollInputEvents()
            ' To avoid that behaviour and control frame processes manually, enable in config.h: SUPPORT_CUSTOM_FRAME_CONTROL
            SUB SwapScreenBuffer ' Swap back buffer with front buffer (screen drawing)
            SUB PollInputEvents ' Register all input events
            SUB WaitTime (BYVAL seconds AS DOUBLE) ' Wait for some time (halt program execution)

            ' Cursor-related functions
            SUB ShowCursor ' Shows cursor
            SUB HideCursor ' Hides cursor
            FUNCTION IsCursorHidden%% ' Check if cursor is not visible
            SUB EnableCursor ' Enables cursor (unlock cursor)
            SUB DisableCursor ' Disables cursor (lock cursor)
            FUNCTION IsCursorOnScreen%% ' Check if cursor is on the screen

            ' Drawing-related functions
            SUB ClearBackground (BYVAL c AS RColor) ' Set background color (framebuffer clear color)
            SUB BeginDrawing ' Setup canvas (framebuffer) to start drawing
            SUB EndDrawing ' End canvas drawing and swap buffers (double buffering)
            SUB BeginMode2D (BYVAL camera AS Camera2D) ' Begin 2D mode with custom camera (2D)
            SUB EndMode2D ' Ends 2D mode with custom camera
            SUB BeginMode3D (BYVAL camera AS Camera3D) ' Begin 3D mode with custom camera (3D)
            SUB EndMode3D ' Ends 3D mode and returns to default 2D orthographic mode
            SUB BeginTextureMode (BYVAL target AS RenderTexture2D) ' Begin drawing to render texture
            SUB EndTextureMode ' Ends drawing to render texture
            SUB BeginShaderMode (BYVAL shdr AS Shader) ' Begin custom shader drawing
            SUB EndShaderMode ' End custom shader drawing (use default shader)
            SUB BeginBlendMode (BYVAL mode AS LONG) ' Begin blending mode (alpha, additive, multiplied, subtract, custom)
            SUB EndBlendMode ' End blending mode (reset to default: alpha blending)
            SUB BeginScissorMode (BYVAL x AS LONG, BYVAL y AS LONG, BYVAL w AS LONG, BYVAL h AS LONG) ' Begin scissor mode (define screen area for following drawing)
            SUB EndScissorMode ' End scissor mode
            SUB BeginVrStereoMode (BYVAL config AS VrStereoConfig) ' Begin stereo rendering (requires VR simulator)
            SUB EndVrStereoMode ' End stereo rendering (requires VR simulator)

            ' VR stereo config functions for VR simulator
            'RLAPI VrStereoConfig LoadVrStereoConfig(VrDeviceInfo device); // Load VR stereo config for VR simulator device parameters
            SUB UnloadVrStereoConfig (BYVAL config AS VrStereoConfig) ' Unload VR stereo config

            ' Shader management functions
            ' NOTE: Shader functionality is not available on OpenGL 1.1
            'RLAPI Shader LoadShader(const char *vsFileName, const char *fsFileName); // Load shader from files and bind default locations
            'RLAPI Shader LoadShaderFromMemory(const char *vsCode, const char *fsCode); // Load shader from code strings and bind default locations
            'RLAPI bool IsShaderReady(Shader shader); // Check if a shader is ready
            'RLAPI int GetShaderLocation(Shader shader, const char *uniformName); // Get shader uniform location
            'RLAPI int GetShaderLocationAttrib(Shader shader, const char *attribName); // Get shader attribute location
            SUB SetShaderValue (BYVAL shdr AS Shader, BYVAL locIndex AS LONG, BYVAL value AS _OFFSET, BYVAL uniformType AS LONG) ' Set shader uniform value
            SUB SetShaderValueV (BYVAL shdr AS Shader, BYVAL locIndex AS LONG, BYVAL value AS _OFFSET, BYVAL uniformType AS LONG, BYVAL count AS LONG) ' Set shader uniform value vector
            SUB SetShaderValueMatrix (BYVAL shdr AS Shader, BYVAL locIndex AS LONG, BYVAL mat AS Matrix) ' Set shader uniform value (matrix 4x4)
            SUB SetShaderValueTexture (BYVAL shdr AS Shader, BYVAL locIndex AS LONG, BYVAL texture AS Texture2D) ' Set shader uniform value for texture (sampler2d)
            SUB UnloadShader (BYVAL shdr AS Shader)

        END DECLARE
    $ELSE
            $ERROR Unsupported platform
    $END IF

    ' Initialize the C-side glue code
    IF __init_raylib THEN
        _DELAY 0.1 ' the delay is needed for the console window to appear
        _CONSOLE OFF ' hide the console by default
    ELSE
        PRINT "raylib initialization failed!"
        END 1
    END IF

$END IF

