'-----------------------------------------------------------------------------------------------------------------------
' raylib bindings for QB64-PE
' Copyright (c) 2023 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$IF RAYLIB_BI = UNDEFINED THEN
    $LET RAYLIB_BI = TRUE

    ' Check QB64-PE compiler version and complain if it does not meet minimum version requirement
    ' We do not support 32-bit versions. Although it is trivial to add if we can find 32-bit raylib shared libraries
    $IF VERSION < 3.7 OR 32BIT THEN
            $ERROR This requires the latest 64-bit version of QB64-PE from https://github.com/QB64-Phoenix-Edition/QB64pe/releases
    $END IF

    ' All identifiers must default to long (32-bits). This results in fastest code execution on x86 & x64
    DEFLNG A-Z

    ' Force all arrays to be defined
    OPTION _EXPLICITARRAY

    ' Force all variables to be defined
    OPTION _EXPLICIT

    ' All arrays should be static. If dynamic arrays are required use "REDIM"
    '$STATIC

    ' Start array lower bound from 1. If 0 is required, then it should be explicitly specified as (0 To X)
    OPTION BASE 1

    ' raylib uses it's own window. So, we force QB64-PE to generate a console only executable. The console can be used for debugging
    $CONSOLE:ONLY

    ' Some common and useful constants
    CONST FALSE = 0, TRUE = NOT FALSE
    CONST NULL = 0

    ' Some Basic Colors
    ' NOTE: Custom raylib color palette for amazing visuals on WHITE background
    CONST LIGHTGRAY = &HFFC8C8C8 ' Light Gray
    CONST GRAY = &HFF828282 ' Gray
    CONST DARKGRAY = &HFF505050 ' Dark Gray
    CONST YELLOW = &HFF00F9FD ' Yellow
    CONST GOLD = &HFF00CBFF ' Gold
    CONST ORANGE = &HFF00A1FF ' Orange
    CONST PINK = &HFFC26DFF ' Pink
    CONST RED = &HFF3729E6 ' Red
    CONST MAROON = &HFF3721BE ' Maroon
    CONST GREEN = &HFF30E400 ' Green
    CONST LIME = &HFF2F9E00 ' Lime
    CONST DARKGREEN = &HFF2C7500 ' Dark Green
    CONST SKYBLUE = &HFFFFBF66 ' Sky Blue
    CONST BLUE = &HFFF17900 ' Blue
    CONST DARKBLUE = &HFFAC5200 ' Dark Blue
    CONST PURPLE = &HFFFF7AC8 ' Purple
    CONST VIOLET = &HFFBE3C87 ' Violet
    CONST DARKPURPLE = &HFF7E1F70 ' Dark Purple
    CONST BEIGE = &HFF83B0D3 ' Beige
    CONST BROWN = &HFF4F6A7F ' Brown
    CONST DARKBROWN = &HFF2F3F4C ' Dark Brown
    CONST WHITE = &HFFFFFFFF ' White
    CONST BLACK = &HFF000000 ' Black
    CONST BLANK = &H00000000 ' Blank (Transparent)
    CONST MAGENTA = &HFFFF00FF ' Magenta
    CONST RAYWHITE = &HFFF5F5F5 ' My own White (raylib logo)

    ' Keyboard keys (US keyboard layout)
    ' NOTE: Use GetKeyPressed() to allow redefining
    ' required keys for alternative layouts
    CONST KEY_NULL = 0 ' Key: NULL
    ' Alphanumeric keys
    CONST KEY_APOSTROPHE = 39 ' Key: '
    CONST KEY_COMMA = 44 ' Key:
    CONST KEY_MINUS = 45 ' Key: -
    CONST KEY_PERIOD = 46 ' Key: .
    CONST KEY_SLASH = 47 ' Key:
    CONST KEY_ZERO = 48 ' Key: 0
    CONST KEY_ONE = 49 ' Key: 1
    CONST KEY_TWO = 50 ' Key: 2
    CONST KEY_THREE = 51 ' Key: 3
    CONST KEY_FOUR = 52 ' Key: 4
    CONST KEY_FIVE = 53 ' Key: 5
    CONST KEY_SIX = 54 ' Key: 6
    CONST KEY_SEVEN = 55 ' Key: 7
    CONST KEY_EIGHT = 56 ' Key: 8
    CONST KEY_NINE = 57 ' Key: 9
    CONST KEY_SEMICOLON = 59 ' Key: ;
    CONST KEY_EQUAL = 61 ' Key:
    CONST KEY_A = 65 ' Key: A | a
    CONST KEY_B = 66 ' Key: B | b
    CONST KEY_C = 67 ' Key: C | c
    CONST KEY_D = 68 ' Key: D | d
    CONST KEY_E = 69 ' Key: E | e
    CONST KEY_F = 70 ' Key: F | f
    CONST KEY_G = 71 ' Key: G | g
    CONST KEY_H = 72 ' Key: H | h
    CONST KEY_I = 73 ' Key: I | i
    CONST KEY_J = 74 ' Key: J | j
    CONST KEY_K = 75 ' Key: K | k
    CONST KEY_L = 76 ' Key: L | l
    CONST KEY_M = 77 ' Key: M | m
    CONST KEY_N = 78 ' Key: N | n
    CONST KEY_O = 79 ' Key: O | o
    CONST KEY_P = 80 ' Key: P | p
    CONST KEY_Q = 81 ' Key: Q | q
    CONST KEY_R = 82 ' Key: R | r
    CONST KEY_S = 83 ' Key: S | s
    CONST KEY_T = 84 ' Key: T | t
    CONST KEY_U = 85 ' Key: U | u
    CONST KEY_V = 86 ' Key: V | v
    CONST KEY_W = 87 ' Key: W | w
    CONST KEY_X = 88 ' Key: X | x
    CONST KEY_Y = 89 ' Key: Y | y
    CONST KEY_Z = 90 ' Key: Z | z
    CONST KEY_LEFT_BRACKET = 91 ' Key: [
    CONST KEY_BACKSLASH = 92 ' Key: '\'
    CONST KEY_RIGHT_BRACKET = 93 ' Key: ]
    CONST KEY_GRAVE = 96 ' Key: `
    ' Function keys
    CONST KEY_SPACE = 32 ' Key: Space
    CONST KEY_ESCAPE = 256 ' Key: Esc
    CONST KEY_ENTER = 257 ' Key: Enter
    CONST KEY_TAB = 258 ' Key: Tab
    CONST KEY_BACKSPACE = 259 ' Key: Backspace
    CONST KEY_INSERT = 260 ' Key: Ins
    CONST KEY_DELETE = 261 ' Key: Del
    CONST KEY_RIGHT = 262 ' Key: Cursor right
    CONST KEY_LEFT = 263 ' Key: Cursor left
    CONST KEY_DOWN = 264 ' Key: Cursor down
    CONST KEY_UP = 265 ' Key: Cursor up
    CONST KEY_PAGE_UP = 266 ' Key: Page up
    CONST KEY_PAGE_DOWN = 267 ' Key: Page down
    CONST KEY_HOME = 268 ' Key: Home
    CONST KEY_END = 269 ' Key: End
    CONST KEY_CAPS_LOCK = 280 ' Key: Caps lock
    CONST KEY_SCROLL_LOCK = 281 ' Key: Scroll down
    CONST KEY_NUM_LOCK = 282 ' Key: Num lock
    CONST KEY_PRINT_SCREEN = 283 ' Key: Print screen
    CONST KEY_PAUSE = 284 ' Key: Pause
    CONST KEY_F1 = 290 ' Key: F1
    CONST KEY_F2 = 291 ' Key: F2
    CONST KEY_F3 = 292 ' Key: F3
    CONST KEY_F4 = 293 ' Key: F4
    CONST KEY_F5 = 294 ' Key: F5
    CONST KEY_F6 = 295 ' Key: F6
    CONST KEY_F7 = 296 ' Key: F7
    CONST KEY_F8 = 297 ' Key: F8
    CONST KEY_F9 = 298 ' Key: F9
    CONST KEY_F10 = 299 ' Key: F10
    CONST KEY_F11 = 300 ' Key: F11
    CONST KEY_F12 = 301 ' Key: F12
    CONST KEY_LEFT_SHIFT = 340 ' Key: Shift left
    CONST KEY_LEFT_CONTROL = 341 ' Key: Control left
    CONST KEY_LEFT_ALT = 342 ' Key: Alt left
    CONST KEY_LEFT_SUPER = 343 ' Key: Super left
    CONST KEY_RIGHT_SHIFT = 344 ' Key: Shift right
    CONST KEY_RIGHT_CONTROL = 345 ' Key: Control right
    CONST KEY_RIGHT_ALT = 346 ' Key: Alt right
    CONST KEY_RIGHT_SUPER = 347 ' Key: Super right
    CONST KEY_KB_MENU = 348 ' Key: KB menu
    ' Keypad keys
    CONST KEY_KP_0 = 320 ' Key: Keypad 0
    CONST KEY_KP_1 = 321 ' Key: Keypad 1
    CONST KEY_KP_2 = 322 ' Key: Keypad 2
    CONST KEY_KP_3 = 323 ' Key: Keypad 3
    CONST KEY_KP_4 = 324 ' Key: Keypad 4
    CONST KEY_KP_5 = 325 ' Key: Keypad 5
    CONST KEY_KP_6 = 326 ' Key: Keypad 6
    CONST KEY_KP_7 = 327 ' Key: Keypad 7
    CONST KEY_KP_8 = 328 ' Key: Keypad 8
    CONST KEY_KP_9 = 329 ' Key: Keypad 9
    CONST KEY_KP_DECIMAL = 330 ' Key: Keypad .
    CONST KEY_KP_DIVIDE = 331 ' Key: Keypad
    CONST KEY_KP_MULTIPLY = 332 ' Key: Keypad *
    CONST KEY_KP_SUBTRACT = 333 ' Key: Keypad -
    CONST KEY_KP_ADD = 334 ' Key: Keypad +
    CONST KEY_KP_ENTER = 335 ' Key: Keypad Enter
    CONST KEY_KP_EQUAL = 336 ' Key: Keypad
    ' Android key buttons
    CONST KEY_BACK = 4 ' Key: Android back button
    CONST KEY_MENU = 82 ' Key: Android menu button
    CONST KEY_VOLUME_UP = 24 ' Key: Android volume up button
    CONST KEY_VOLUME_DOWN = 25 ' Key: Android volume down button

    ' Vector2, 2 components
    TYPE Vector2
        AS SINGLE x ' Vector x component
        AS SINGLE y ' Vector y component
    END TYPE

    ' Vector3, 3 components
    TYPE Vector3
        AS SINGLE x ' Vector x component
        AS SINGLE y ' Vector y component
        AS SINGLE z ' Vector z component
    END TYPE

    ' Vector4, 4 components
    TYPE Vector4
        AS SINGLE x ' Vector x component
        AS SINGLE y ' Vector y component
        AS SINGLE z ' Vector z component
        AS SINGLE w ' Vector w component
    END TYPE

    ' Quaternion, 4 components (Vector4 alias)
    TYPE Quaternion
        AS SINGLE x ' Vector x component
        AS SINGLE y ' Vector y component
        AS SINGLE z ' Vector z component
        AS SINGLE w ' Vector w component
    END TYPE

    ' Matrix, 4x4 components, column major, OpenGL style, right-handed
    TYPE Matrix
        AS SINGLE m0, m4, m8, m12 ' Matrix first row (4 components)
        AS SINGLE m1, m5, m9, m13 ' Matrix second row (4 components)
        AS SINGLE m2, m6, m10, m14 ' Matrix third row (4 components)
        AS SINGLE m3, m7, m11, m15 ' Matrix fourth row (4 components)
    END TYPE

    ' Color, 4 components, R8G8B8A8 (32bit)
    TYPE RGBA
        AS _UNSIGNED _BYTE r ' Color red value
        AS _UNSIGNED _BYTE g ' Color green value
        AS _UNSIGNED _BYTE b ' Color blue value
        AS _UNSIGNED _BYTE a ' Color alpha value
    END TYPE

    ' Rectangle, 4 components
    TYPE Rectangle
        AS SINGLE x ' Rectangle top-left corner position x
        AS SINGLE y ' Rectangle top-left corner position y
        AS SINGLE W ' Rectangle width
        AS SINGLE H ' Rectangle height
    END TYPE

    ' Image, pixel data stored in CPU memory (RAM)
    TYPE Image
        AS _OFFSET dat ' Image raw data
        AS LONG W ' Image base width
        AS LONG H ' Image base height
        AS LONG mipmaps ' Mipmap levels, 1 by default
        AS LONG format ' Data format (PixelFormat type)
    END TYPE

    ' Texture, tex data stored in GPU memory (VRAM)
    TYPE Texture
        AS LONG id ' OpenGL texture id
        AS LONG W ' Texture base width
        AS LONG H ' Texture base height
        AS LONG mipmaps ' Mipmap levels, 1 by default
        AS LONG format ' Data format (PixelFormat type)
    END TYPE

    ' Texture2D, same as Texture
    TYPE Texture2D
        AS LONG id ' OpenGL texture id
        AS LONG W ' Texture base width
        AS LONG H ' Texture base height
        AS LONG mipmaps ' Mipmap levels, 1 by default
        AS LONG format ' Data format (PixelFormat type)
    END TYPE

    ' TextureCubemap, same as Texture
    TYPE TextureCubemap
        AS LONG id ' OpenGL texture id
        AS LONG W ' Texture base width
        AS LONG H ' Texture base height
        AS LONG mipmaps ' Mipmap levels, 1 by default
        AS LONG format ' Data format (PixelFormat type)
    END TYPE

    ' RenderTexture, fbo for texture rendering
    TYPE RenderTexture
        AS LONG id ' OpenGL framebuffer object id
        AS Texture tex ' Color buffer attachment texture
        AS Texture depth ' Depth buffer attachment texture
    END TYPE

    ' RenderTexture2D, same as RenderTexture
    TYPE RenderTexture2D
        AS LONG id ' OpenGL framebuffer object id
        AS Texture tex ' Color buffer attachment texture
        AS Texture depth ' Depth buffer attachment texture
    END TYPE

    ' NPatchInfo, n-patch layout info
    TYPE NPatchInfo
        AS Rectangle source ' Texture source rectangle
        AS LONG left ' Left border offset
        AS LONG top ' Top border offset
        AS LONG right ' Right border offset
        AS LONG bottom ' Bottom border offset
        AS LONG layout ' Layout of the n-patch: 3x3, 1x3 or 3x1
    END TYPE

    ' GlyphInfo, font characters glyphs info
    TYPE GlyphInfo
        AS LONG value ' Character value (Unicode)
        AS LONG offsetX ' Character offset X when drawing
        AS LONG offsetY ' Character offset Y when drawing
        AS LONG advanceX ' Character advance position X
        AS Image img ' Character image data
    END TYPE

    ' Font, font texture and GlyphInfo array data
    TYPE Font
        AS LONG baseSize ' Base size (default chars height)
        AS LONG glyphCount ' Number of glyph characters
        AS LONG glyphPadding ' Padding around the glyph characters
        AS Texture2D tex ' Texture atlas containing the glyphs
        AS _UNSIGNED _OFFSET recs ' Rectangles in texture for the glyphs (Rectangle *)
        AS _UNSIGNED _OFFSET glyphs ' Glyphs info data (GlyphInfo *)
    END TYPE

    ' Camera, defines position/orientation in 3d space
    TYPE Camera3D
        AS Vector3 position ' Camera position
        AS Vector3 target ' Camera target it looks-at
        AS Vector3 up ' Camera up vector (rotation over its axis)
        AS SINGLE fovy ' Camera field-of-view aperture in Y (degrees) in perspective, used as near plane width in orthographic
        AS LONG projection ' Camera projection: CAMERA_PERSPECTIVE or CAMERA_ORTHOGRAPHIC
    END TYPE

    ' Camera type fallback, defaults to Camera3D
    TYPE Camera
        AS Vector3 position ' Camera position
        AS Vector3 target ' Camera target it looks-at
        AS Vector3 up ' Camera up vector (rotation over its axis)
        AS SINGLE fovy ' Camera field-of-view aperture in Y (degrees) in perspective, used as near plane width in orthographic
        AS LONG projection ' Camera projection: CAMERA_PERSPECTIVE or CAMERA_ORTHOGRAPHIC
    END TYPE

    ' Camera2D, defines position/orientation in 2d space
    TYPE Camera2D
        AS Vector2 offset ' Camera offset (displacement from target)
        AS Vector2 target ' Camera target (rotation and zoom origin)
        AS SINGLE rotation ' Camera rotation in degrees
        AS SINGLE zoom ' Camera zoom (scaling), should be 1.0f by default
    END TYPE

    ' Mesh, vertex data and vao/vbo
    TYPE Mesh
        AS LONG vertexCount ' Number of vertices stored in arrays
        AS LONG triangleCount ' Number of triangles stored (indexed or not)
        ' Vertex attributes data
        AS _UNSIGNED _OFFSET vertices ' Vertex position (XYZ - 3 components per vertex) (shader-location = 0) (float *)
        AS _UNSIGNED _OFFSET texcoords ' Vertex texture coordinates (UV - 2 components per vertex) (shader-location = 1) (float *)
        AS _UNSIGNED _OFFSET texcoords2 ' Vertex texture second coordinates (UV - 2 components per vertex) (shader-location = 5) (float *)
        AS _UNSIGNED _OFFSET normals ' Vertex normals (XYZ - 3 components per vertex) (shader-location = 2) (float *)
        AS _UNSIGNED _OFFSET tangents ' Vertex tangents (XYZW - 4 components per vertex) (shader-location = 4) (float *)
        AS _UNSIGNED _OFFSET colors ' Vertex colors (RGBA - 4 components per vertex) (shader-location = 3) (unsigned char *)
        AS _UNSIGNED _OFFSET indices ' Vertex indices (in case vertex data comes indexed) (unsigned short *)
        ' Animation vertex data
        AS _UNSIGNED _OFFSET animVertices ' Animated vertex positions (after bones transformations) (float *)
        AS _UNSIGNED _OFFSET animNormals ' Animated normals (after bones transformations) (float *)
        AS _UNSIGNED _OFFSET boneIds ' Vertex bone ids, max 255 bone ids, up to 4 bones influence by vertex (skinning) (unsigned char *)
        AS _UNSIGNED _OFFSET boneWeights ' Vertex bone weight, up to 4 bones influence by vertex (skinning) (float *)
        ' OpenGL identifiers
        AS _UNSIGNED LONG vaoId ' OpenGL Vertex Array Object id
        AS _UNSIGNED _OFFSET vboId ' OpenGL Vertex Buffer Objects id (default vertex data) (unsigned int *)
    END TYPE


    ' Shader
    TYPE Shader
        AS LONG id ' Shader program id
        AS _OFFSET locs ' Shader locations array (RL_MAX_SHADER_LOCATIONS)
    END TYPE

    ' MaterialMap
    TYPE MaterialMap
        AS Texture2D tex ' Material map texture
        AS _UNSIGNED LONG clr ' Material map color
        AS SINGLE value ' Material map value
    END TYPE

    ' Material, includes shader and maps
    TYPE Material
        AS Shader shdr ' Material shader
        AS _UNSIGNED _OFFSET maps ' Material maps array (MAX_MATERIAL_MAPS) (MaterialMap *)
        AS SINGLE params0 ' Material generic parameters (if required)
        AS SINGLE params1 ' Material generic parameters (if required)
        AS SINGLE params2 ' Material generic parameters (if required)
        AS SINGLE params3 ' Material generic parameters (if required)
    END TYPE

    ' Transform, vertex transformation data
    TYPE Transform
        AS Vector3 translation ' Translation
        AS Quaternion rotation ' Rotation
        AS Vector3 scale ' Scale
    END TYPE

    ' Bone, skeletal animation bone
    TYPE BoneInfo
        AS STRING * 32 tag ' Bone name
        AS LONG parent ' Bone parent
    END TYPE

    ' Model, meshes, materials and animation data
    TYPE Model
        AS Matrix transform ' Local transform matrix
        AS LONG meshCount ' Number of meshes
        AS LONG materialCount ' Number of materials
        AS _UNSIGNED _OFFSET meshes ' Meshes array (Mesh *)
        AS _UNSIGNED _OFFSET materials ' Materials array (Material *)
        AS _UNSIGNED _OFFSET meshMaterial ' Mesh material number (int *)
        ' Animation data
        AS LONG boneCount ' Number of bones
        AS _UNSIGNED _OFFSET bones ' Bones information (skeleton) (BoneInfo *)
        AS _UNSIGNED _OFFSET bindPose ' Bones base transformation (pose) (Transform *)
    END TYPE

    ' ModelAnimation
    TYPE ModelAnimation
        AS LONG boneCount ' Number of bones
        AS LONG frameCount ' Number of animation frames
        AS _UNSIGNED _OFFSET bones ' Bones information (skeleton) (BoneInfo *)
        AS _UNSIGNED _OFFSET framePoses ' Poses array by frame (Transform **)
    END TYPE

    ' Ray, ray for raycasting
    TYPE Ray
        AS Vector3 position ' Ray position (origin)
        AS Vector3 direction ' Ray direction
    END TYPE

    ' RayCollision, ray hit information
    TYPE RayCollision
        AS _BYTE hit ' Did the ray hit something?
        AS SINGLE distance ' Distance to the nearest hit
        AS Vector3 position ' Point of the nearest hit
        AS Vector3 normal ' Surface normal of hit
    END TYPE

    ' BoundingBox
    TYPE BoundingBox
        AS Vector3 min ' Minimum vertex box-corner
        AS Vector3 max ' Maximum vertex box-corner
    END TYPE

    ' Wave, audio wave data
    TYPE Wave
        AS _UNSIGNED LONG frameCount ' Total number of frames (considering channels)
        AS _UNSIGNED LONG sampleRate ' Frequency (samples per second)
        AS _UNSIGNED LONG sampleSize ' Bit depth (bits per sample): 8, 16, 32 (24 not supported)
        AS _UNSIGNED LONG channels ' Number of channels (1-mono, 2-stereo, ...)
        AS _UNSIGNED _OFFSET dat ' Buffer data pointer (void *)
    END TYPE

    ' AudioStream, custom audio stream
    TYPE AudioStream
        AS _UNSIGNED _OFFSET buffer ' Pointer to internal data used by the audio system (rAudioBuffer *)
        AS _UNSIGNED _OFFSET processor ' Pointer to internal data processor, useful for audio effects (rAudioProcessor *)
        AS _UNSIGNED LONG sampleRate ' Frequency (samples per second)
        AS _UNSIGNED LONG sampleSize ' Bit depth (bits per sample): 8, 16, 32 (24 not supported)
        AS _UNSIGNED LONG channels ' Number of channels (1-mono, 2-stereo, ...)
    END TYPE

    ' Sound
    TYPE Sound
        AS AudioStream stream ' Audio stream
        AS _UNSIGNED LONG frameCount ' Total number of frames (considering channels)
    END TYPE

    ' Music, audio stream, anything longer than ~10 seconds should be streamed
    TYPE Music
        AS AudioStream stream ' Audio stream
        AS _UNSIGNED LONG frameCount ' Total number of frames (considering channels)
        AS _BYTE looping ' Music looping enable
        AS LONG ctxType ' Type of music context (audio filetype)
        AS _UNSIGNED _OFFSET ctxData ' Audio context data, depends on type (void *)
    END TYPE

    ' VrDeviceInfo, Head-Mounted-Display device parameters
    TYPE VrDeviceInfo
        AS LONG hResolution ' Horizontal resolution in pixels
        AS LONG vResolution ' Vertical resolution in pixels
        AS SINGLE hScreenSize ' Horizontal size in meters
        AS SINGLE vScreenSize ' Vertical size in meters
        AS SINGLE vScreenCenter ' Screen center in meters
        AS SINGLE eyeToScreenDistance ' Distance between eye and display in meters
        AS SINGLE lensSeparationDistance ' Lens separation distance in meters
        AS SINGLE interpupillaryDistance ' IPD (distance between pupils) in meters
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

    ' File path list
    TYPE FilePathList
        AS _UNSIGNED LONG capacity ' Filepaths max entries
        AS _UNSIGNED LONG count ' Filepaths entries count
        AS _UNSIGNED _OFFSET paths ' Filepaths entries (char **)
    END TYPE

    '-------------------------------------------------------------------------------------------------------------------
    ' Autogenerated QB64-PE DECLARE STATIC LIBRARY stuff
    ' Do not call anything with leading `__` directly. Use the QB64-PE function wrappers in raylib.bas instead
    '-------------------------------------------------------------------------------------------------------------------
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __init_raylib%% ' for iternal use only

        ' raylib color management stuff
        FUNCTION MakeRGBA~& (BYVAL r AS _UNSIGNED _BYTE, BYVAL g AS _UNSIGNED _BYTE, BYVAL b AS _UNSIGNED _BYTE, BYVAL a AS _UNSIGNED _BYTE)
        FUNCTION GetRGBARed~%% (BYVAL rgba AS _UNSIGNED LONG)
        FUNCTION GetRGBAGreen~%% (BYVAL rgba AS _UNSIGNED LONG)
        FUNCTION GetRGBABlue~%% (BYVAL rgba AS _UNSIGNED LONG)
        FUNCTION GetRGBAAlpha~%% (BYVAL rgba AS _UNSIGNED LONG)
        FUNCTION GetRGBARGB~& (BYVAL rgba AS _UNSIGNED LONG)
        FUNCTION BGRAToRGBA~& (BYVAL bgra AS _UNSIGNED LONG)

        SUB __InitWindow ALIAS InitWindow (BYVAL W AS LONG, BYVAL H AS LONG, title AS STRING)
        FUNCTION WindowShouldClose%%
        SUB CloseWindow
        FUNCTION IsWindowReady%%
        FUNCTION IsWindowFullscreen%%
        FUNCTION IsWindowHidden%%
        FUNCTION IsWindowMinimized%%
        FUNCTION IsWindowMaximized%%
        FUNCTION IsWindowFocused%%
        FUNCTION IsWindowResized%%
        FUNCTION IsWindowState%% (BYVAL flag AS _UNSIGNED LONG)
        SUB SetWindowState (BYVAL flags AS _UNSIGNED LONG)
        SUB ClearWindowState (BYVAL flags AS _UNSIGNED LONG)
        SUB ToggleFullscreen
        SUB MaximizeWindow
        SUB MinimizeWindow
        SUB RestoreWindow
        SUB SetWindowIcon (img AS Image)
        SUB SetWindowIcons (images AS Image, BYVAL count AS LONG)
        SUB __SetWindowTitle ALIAS SetWindowTitle (title AS STRING)
        SUB SetWindowPosition (BYVAL x AS LONG, BYVAL y AS LONG)
        SUB SetWindowMonitor (BYVAL monitor AS LONG)
        SUB SetWindowMinSize (BYVAL W AS LONG, BYVAL H AS LONG)
        SUB SetWindowSize (BYVAL W AS LONG, BYVAL H AS LONG)
        SUB SetWindowOpacity (BYVAL opacity AS SINGLE)
        FUNCTION GetWindowHandle~%&
        FUNCTION GetScreenWidth&
        FUNCTION GetScreenHeight&
        FUNCTION GetRenderWidth&
        FUNCTION GetRenderHeight&
        FUNCTION GetMonitorCount&
        FUNCTION GetCurrentMonitor&
        SUB GetMonitorPosition (BYVAL monitor AS LONG, retVal AS Vector2)
        FUNCTION GetMonitorWidth& (BYVAL monitor AS LONG)
        FUNCTION GetMonitorHeight& (BYVAL monitor AS LONG)
        FUNCTION GetMonitorPhysicalWidth& (BYVAL monitor AS LONG)
        FUNCTION GetMonitorPhysicalHeight& (BYVAL monitor AS LONG)
        FUNCTION GetMonitorRefreshRate& (BYVAL monitor AS LONG)
        SUB GetWindowPosition (retVal AS Vector2)
        SUB GetWindowScaleDPI (retVal AS Vector2)
        FUNCTION GetMonitorName$ (BYVAL monitor AS LONG)
        SUB __SetClipboardText ALIAS SetClipboardText (text AS STRING)
        FUNCTION GetClipboardText$
        SUB EnableEventWaiting
        SUB DisableEventWaiting
        SUB SwapScreenBuffer
        SUB PollInputEvents
        SUB WaitTime (BYVAL seconds AS DOUBLE)
        SUB ShowCursor
        SUB HideCursor
        FUNCTION IsCursorHidden%%
        SUB EnableCursor
        SUB DisableCursor
        FUNCTION IsCursorOnScreen%%
        SUB ClearBackground (BYVAL clr AS _UNSIGNED LONG)
        SUB BeginDrawing
        SUB EndDrawing
        SUB BeginMode2D (camera AS Camera2D)
        SUB EndMode2D
        SUB BeginMode3D (camera AS Camera3D)
        SUB EndMode3D
        SUB BeginTextureMode (target AS RenderTexture2D)
        SUB EndTextureMode
        SUB BeginShaderMode (shdr AS Shader)
        SUB EndShaderMode
        SUB BeginBlendMode (BYVAL mode AS LONG)
        SUB EndBlendMode
        SUB BeginScissorMode (BYVAL x AS LONG, BYVAL y AS LONG, BYVAL W AS LONG, BYVAL H AS LONG)
        SUB EndScissorMode
        SUB BeginVrStereoMode (config AS VrStereoConfig)
        SUB EndVrStereoMode
        SUB LoadVrStereoConfig (device AS VrDeviceInfo, retVal AS VrStereoConfig)
        SUB UnloadVrStereoConfig (config AS VrStereoConfig)
        SUB LoadShader (vsFileName AS STRING, fsFileName AS STRING, retVal AS Shader)
        SUB LoadShaderFromMemory (vsCode AS STRING, fsCode AS STRING, retVal AS Shader)
        FUNCTION IsShaderReady%% (shdr AS Shader)
        FUNCTION GetShaderLocation& (shdr AS Shader, uniformName AS STRING)
        FUNCTION GetShaderLocationAttrib& (shdr AS Shader, attribName AS STRING)
        SUB SetShaderValue (shdr AS Shader, BYVAL locIndex AS LONG, BYVAL value AS _UNSIGNED _OFFSET, BYVAL uniformType AS LONG)
        SUB SetShaderValueV (shdr AS Shader, BYVAL locIndex AS LONG, BYVAL value AS _UNSIGNED _OFFSET, BYVAL uniformType AS LONG, BYVAL count AS LONG)
        SUB SetShaderValueMatrix (shdr AS Shader, BYVAL locIndex AS LONG, mat AS Matrix)
        SUB SetShaderValueTexture (shdr AS Shader, BYVAL locIndex AS LONG, tex AS Texture2D)
        SUB UnloadShader (shdr AS Shader)
        SUB GetMouseRay (mousePosition AS Vector2, camera AS Camera, retVal AS Ray)
        SUB GetCameraMatrix (camera AS Camera, retVal AS Matrix)
        SUB GetCameraMatrix2D (camera AS Camera2D, retVal AS Matrix)
        SUB GetWorldToScreen (position AS Vector3, camera AS Camera, retVal AS Vector2)
        SUB GetScreenToWorld2D (position AS Vector2, camera AS Camera2D, retVal AS Vector2)
        SUB GetWorldToScreenEx (position AS Vector3, camera AS Camera, BYVAL W AS LONG, BYVAL H AS LONG, retVal AS Vector2)
        SUB GetWorldToScreen2D (position AS Vector2, camera AS Camera2D, retVal AS Vector2)
        SUB SetTargetFPS (BYVAL fps AS LONG)
        FUNCTION GetFPS&
        FUNCTION GetFrameTime!
        FUNCTION GetTime#
        FUNCTION GetRandomValue& (BYVAL min AS LONG, BYVAL max AS LONG)
        SUB SetRandomSeed (BYVAL seed AS _UNSIGNED LONG)
        SUB TakeScreenshot (fileName AS STRING)
        SUB SetConfigFlags (BYVAL flags AS _UNSIGNED LONG)
        SUB __TraceLog ALIAS TraceLog (BYVAL logLevel AS LONG, text AS STRING)
        SUB __TraceLogString ALIAS TraceLog (BYVAL logLevel AS LONG, text AS STRING, s AS STRING)
        SUB __TraceLogLong ALIAS TraceLog (BYVAL logLevel AS LONG, text AS STRING, BYVAL i AS LONG)
        SUB __TraceLogSingle ALIAS TraceLog (BYVAL logLevel AS LONG, text AS STRING, BYVAL f AS SINGLE)
        SUB SetTraceLogLevel (BYVAL logLevel AS LONG)
        FUNCTION MemAlloc~%& (BYVAL size AS _UNSIGNED LONG)
        FUNCTION MemRealloc~%& (BYVAL ptr AS _UNSIGNED _OFFSET, BYVAL size AS _UNSIGNED LONG)
        SUB MemFree (BYVAL ptr AS _UNSIGNED _OFFSET)
        SUB OpenURL (url AS STRING)
        SUB SetTraceLogCallback (BYVAL callback AS _UNSIGNED _OFFSET)
        SUB SetLoadFileDataCallback (BYVAL callback AS _UNSIGNED _OFFSET)
        SUB SetSaveFileDataCallback (BYVAL callback AS _UNSIGNED _OFFSET)
        SUB SetLoadFileTextCallback (BYVAL callback AS _UNSIGNED _OFFSET)
        SUB SetSaveFileTextCallback (BYVAL callback AS _UNSIGNED _OFFSET)
        FUNCTION LoadFileData~%& (fileName AS STRING, bytesRead AS _UNSIGNED LONG)
        SUB UnloadFileData (dat AS _UNSIGNED _BYTE)
        FUNCTION SaveFileData%% (fileName AS STRING, BYVAL dat AS _UNSIGNED _OFFSET, BYVAL bytesToWrite AS _UNSIGNED LONG)
        FUNCTION ExportDataAsCode%% (dat AS _UNSIGNED _BYTE, BYVAL size AS _UNSIGNED LONG, fileName AS STRING)
        FUNCTION LoadFileText$ (fileName AS STRING)
        SUB UnloadFileText (text AS STRING)
        FUNCTION SaveFileText%% (fileName AS STRING, text AS STRING)
        FUNCTION FileExists%% (fileName AS STRING)
        FUNCTION DirectoryExists%% (dirPath AS STRING)
        FUNCTION IsFileExtension%% (fileName AS STRING, ext AS STRING)
        FUNCTION GetFileLength& (fileName AS STRING)
        FUNCTION GetFileExtension$ (fileName AS STRING)
        FUNCTION GetFileName$ (filePath AS STRING)
        FUNCTION GetFileNameWithoutExt$ (filePath AS STRING)
        FUNCTION GetDirectoryPath$ (filePath AS STRING)
        FUNCTION GetPrevDirectoryPath$ (dirPath AS STRING)
        FUNCTION GetWorkingDirectory$
        FUNCTION GetApplicationDirectory$
        FUNCTION ChangeDirectory%% (dir AS STRING)
        FUNCTION IsPathFile%% (path AS STRING)
        SUB LoadDirectoryFiles (dirPath AS STRING, retVal AS FilePathList)
        SUB LoadDirectoryFilesEx (basePath AS STRING, filter AS STRING, BYVAL scanSubdirs AS _BYTE, retVal AS FilePathList)
        SUB UnloadDirectoryFiles (files AS FilePathList)
        FUNCTION IsFileDropped%%
        SUB LoadDroppedFiles (retVal AS FilePathList)
        SUB UnloadDroppedFiles (files AS FilePathList)
        FUNCTION GetFileModTime& (fileName AS STRING)
        FUNCTION CompressData~%& (dat AS _UNSIGNED _BYTE, BYVAL dataSize AS LONG, compDataSize AS LONG)
        FUNCTION DecompressData~%& (compData AS _UNSIGNED _BYTE, BYVAL compDataSize AS LONG, dataSize AS LONG)
        FUNCTION EncodeDataBase64$ (dat AS _UNSIGNED _BYTE, BYVAL dataSize AS LONG, outputSize AS LONG)
        FUNCTION DecodeDataBase64~%& (dat AS _UNSIGNED _BYTE, outputSize AS LONG)
        FUNCTION IsKeyPressed%% (BYVAL key AS LONG)
        FUNCTION IsKeyDown%% (BYVAL key AS LONG)
        FUNCTION IsKeyReleased%% (BYVAL key AS LONG)
        FUNCTION IsKeyUp%% (BYVAL key AS LONG)
        SUB SetExitKey (BYVAL key AS LONG)
        FUNCTION GetKeyPressed&
        FUNCTION GetCharPressed&
        FUNCTION IsGamepadAvailable%% (BYVAL gamepad AS LONG)
        FUNCTION GetGamepadName$ (BYVAL gamepad AS LONG)
        FUNCTION IsGamepadButtonPressed%% (BYVAL gamepad AS LONG, BYVAL button AS LONG)
        FUNCTION IsGamepadButtonDown%% (BYVAL gamepad AS LONG, BYVAL button AS LONG)
        FUNCTION IsGamepadButtonReleased%% (BYVAL gamepad AS LONG, BYVAL button AS LONG)
        FUNCTION IsGamepadButtonUp%% (BYVAL gamepad AS LONG, BYVAL button AS LONG)
        FUNCTION GetGamepadButtonPressed&
        FUNCTION GetGamepadAxisCount& (BYVAL gamepad AS LONG)
        FUNCTION GetGamepadAxisMovement! (BYVAL gamepad AS LONG, BYVAL axis AS LONG)
        FUNCTION SetGamepadMappings& (mappings AS STRING)
        FUNCTION IsMouseButtonPressed%% (BYVAL button AS LONG)
        FUNCTION IsMouseButtonDown%% (BYVAL button AS LONG)
        FUNCTION IsMouseButtonReleased%% (BYVAL button AS LONG)
        FUNCTION IsMouseButtonUp%% (BYVAL button AS LONG)
        FUNCTION GetMouseX&
        FUNCTION GetMouseY&
        SUB GetMousePosition (retVal AS Vector2)
        SUB GetMouseDelta (retVal AS Vector2)
        SUB SetMousePosition (BYVAL x AS LONG, BYVAL y AS LONG)
        SUB SetMouseOffset (BYVAL offsetX AS LONG, BYVAL offsetY AS LONG)
        SUB SetMouseScale (BYVAL scaleX AS SINGLE, BYVAL scaleY AS SINGLE)
        FUNCTION GetMouseWheelMove!
        SUB GetMouseWheelMoveV (retVal AS Vector2)
        SUB SetMouseCursor (BYVAL cursor AS LONG)
        FUNCTION GetTouchX&
        FUNCTION GetTouchY&
        SUB GetTouchPosition (BYVAL index AS LONG, retVal AS Vector2)
        FUNCTION GetTouchPointId& (BYVAL index AS LONG)
        FUNCTION GetTouchPointCount&
        SUB SetGesturesEnabled (BYVAL flags AS _UNSIGNED LONG)
        FUNCTION IsGestureDetected%% (BYVAL gesture AS LONG)
        FUNCTION GetGestureDetected&
        FUNCTION GetGestureHoldDuration!
        SUB GetGestureDragVector (retVal AS Vector2)
        FUNCTION GetGestureDragAngle!
        SUB GetGesturePinchVector (retVal AS Vector2)
        FUNCTION GetGesturePinchAngle!
        SUB UpdateCamera (camera AS Camera, BYVAL mode AS LONG)
        SUB UpdateCameraPro (camera AS Camera, movement AS Vector3, rotation AS Vector3, BYVAL zoom AS SINGLE)
        SUB SetShapesTexture (tex AS Texture2D, source AS Rectangle)
        SUB DrawPixel (BYVAL posX AS LONG, BYVAL posY AS LONG, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawPixelV (position AS Vector2, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawLine (BYVAL startPosX AS LONG, BYVAL startPosY AS LONG, BYVAL endPosX AS LONG, BYVAL endPosY AS LONG, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawLineV (startPos AS Vector2, endPos AS Vector2, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawLineEx (startPos AS Vector2, endPos AS Vector2, BYVAL thick AS SINGLE, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawLineBezier (startPos AS Vector2, endPos AS Vector2, BYVAL thick AS SINGLE, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawLineBezierQuad (startPos AS Vector2, endPos AS Vector2, controlPos AS Vector2, BYVAL thick AS SINGLE, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawLineBezierCubic (startPos AS Vector2, endPos AS Vector2, startControlPos AS Vector2, endControlPos AS Vector2, BYVAL thick AS SINGLE, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawLineStrip (points AS Vector2, BYVAL pointCount AS LONG, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawCircle (BYVAL centerX AS LONG, BYVAL centerY AS LONG, BYVAL radius AS SINGLE, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawCircleSector (center AS Vector2, BYVAL radius AS SINGLE, BYVAL startAngle AS SINGLE, BYVAL endAngle AS SINGLE, BYVAL segments AS LONG, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawCircleSectorLines (center AS Vector2, BYVAL radius AS SINGLE, BYVAL startAngle AS SINGLE, BYVAL endAngle AS SINGLE, BYVAL segments AS LONG, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawCircleGradient (BYVAL centerX AS LONG, BYVAL centerY AS LONG, BYVAL radius AS SINGLE, BYVAL color1 AS _UNSIGNED LONG, BYVAL color2 AS _UNSIGNED LONG)
        SUB DrawCircleV (center AS Vector2, BYVAL radius AS SINGLE, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawCircleLines (BYVAL centerX AS LONG, BYVAL centerY AS LONG, BYVAL radius AS SINGLE, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawEllipse (BYVAL centerX AS LONG, BYVAL centerY AS LONG, BYVAL radiusH AS SINGLE, BYVAL radiusV AS SINGLE, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawEllipseLines (BYVAL centerX AS LONG, BYVAL centerY AS LONG, BYVAL radiusH AS SINGLE, BYVAL radiusV AS SINGLE, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawRing (center AS Vector2, BYVAL innerRadius AS SINGLE, BYVAL outerRadius AS SINGLE, BYVAL startAngle AS SINGLE, BYVAL endAngle AS SINGLE, BYVAL segments AS LONG, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawRingLines (center AS Vector2, BYVAL innerRadius AS SINGLE, BYVAL outerRadius AS SINGLE, BYVAL startAngle AS SINGLE, BYVAL endAngle AS SINGLE, BYVAL segments AS LONG, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawRectangle (BYVAL posX AS LONG, BYVAL posY AS LONG, BYVAL W AS LONG, BYVAL H AS LONG, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawRectangleV (position AS Vector2, size AS Vector2, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawRectangleRec (rec AS Rectangle, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawRectanglePro (rec AS Rectangle, origin AS Vector2, BYVAL rotation AS SINGLE, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawRectangleGradientV (BYVAL posX AS LONG, BYVAL posY AS LONG, BYVAL W AS LONG, BYVAL H AS LONG, BYVAL color1 AS _UNSIGNED LONG, BYVAL color2 AS _UNSIGNED LONG)
        SUB DrawRectangleGradientH (BYVAL posX AS LONG, BYVAL posY AS LONG, BYVAL W AS LONG, BYVAL H AS LONG, BYVAL color1 AS _UNSIGNED LONG, BYVAL color2 AS _UNSIGNED LONG)
        SUB DrawRectangleGradientEx (rec AS Rectangle, BYVAL col1 AS _UNSIGNED LONG, BYVAL col2 AS _UNSIGNED LONG, BYVAL col3 AS _UNSIGNED LONG, BYVAL col4 AS _UNSIGNED LONG)
        SUB DrawRectangleLines (BYVAL posX AS LONG, BYVAL posY AS LONG, BYVAL W AS LONG, BYVAL H AS LONG, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawRectangleLinesEx (rec AS Rectangle, BYVAL lineThick AS SINGLE, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawRectangleRounded (rec AS Rectangle, BYVAL roundness AS SINGLE, BYVAL segments AS LONG, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawRectangleRoundedLines (rec AS Rectangle, BYVAL roundness AS SINGLE, BYVAL segments AS LONG, BYVAL lineThick AS SINGLE, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawTriangle (v1 AS Vector2, v2 AS Vector2, v3 AS Vector2, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawTriangleLines (v1 AS Vector2, v2 AS Vector2, v3 AS Vector2, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawTriangleFan (points AS Vector2, BYVAL pointCount AS LONG, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawTriangleStrip (points AS Vector2, BYVAL pointCount AS LONG, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawPoly (center AS Vector2, BYVAL sides AS LONG, BYVAL radius AS SINGLE, BYVAL rotation AS SINGLE, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawPolyLines (center AS Vector2, BYVAL sides AS LONG, BYVAL radius AS SINGLE, BYVAL rotation AS SINGLE, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawPolyLinesEx (center AS Vector2, BYVAL sides AS LONG, BYVAL radius AS SINGLE, BYVAL rotation AS SINGLE, BYVAL lineThick AS SINGLE, BYVAL clr AS _UNSIGNED LONG)
        FUNCTION CheckCollisionRecs%% (rec1 AS Rectangle, rec2 AS Rectangle)
        FUNCTION CheckCollisionCircles%% (center1 AS Vector2, BYVAL radius1 AS SINGLE, center2 AS Vector2, BYVAL radius2 AS SINGLE)
        FUNCTION CheckCollisionCircleRec%% (center AS Vector2, BYVAL radius AS SINGLE, rec AS Rectangle)
        FUNCTION CheckCollisionPointRec%% (point AS Vector2, rec AS Rectangle)
        FUNCTION CheckCollisionPointCircle%% (point AS Vector2, center AS Vector2, BYVAL radius AS SINGLE)
        FUNCTION CheckCollisionPointTriangle%% (point AS Vector2, p1 AS Vector2, p2 AS Vector2, p3 AS Vector2)
        FUNCTION CheckCollisionPointPoly%% (point AS Vector2, points AS Vector2, BYVAL pointCount AS LONG)
        FUNCTION CheckCollisionLines%% (startPos1 AS Vector2, endPos1 AS Vector2, startPos2 AS Vector2, endPos2 AS Vector2, collisionPoint AS Vector2)
        FUNCTION CheckCollisionPointLine%% (point AS Vector2, p1 AS Vector2, p2 AS Vector2, BYVAL threshold AS LONG)
        SUB GetCollisionRec (rec1 AS Rectangle, rec2 AS Rectangle, retVal AS Rectangle)
        SUB LoadImage (fileName AS STRING, retVal AS Image)
        SUB LoadImageRaw (fileName AS STRING, BYVAL W AS LONG, BYVAL H AS LONG, BYVAL format AS LONG, BYVAL headerSize AS LONG, retVal AS Image)
        SUB LoadImageAnim (fileName AS STRING, frames AS LONG, retVal AS Image)
        SUB LoadImageFromMemory (fileType AS STRING, fileData AS _UNSIGNED _BYTE, BYVAL dataSize AS LONG, retVal AS Image)
        SUB LoadImageFromTexture (tex AS Texture2D, retVal AS Image)
        SUB LoadImageFromScreen (retVal AS Image)
        FUNCTION IsImageReady%% (img AS Image)
        SUB UnloadImage (img AS Image)
        FUNCTION ExportImage%% (img AS Image, fileName AS STRING)
        FUNCTION ExportImageAsCode%% (img AS Image, fileName AS STRING)
        SUB GenImageColor (BYVAL W AS LONG, BYVAL H AS LONG, BYVAL clr AS _UNSIGNED LONG, retVal AS Image)
        SUB GenImageGradientV (BYVAL W AS LONG, BYVAL H AS LONG, BYVAL top AS _UNSIGNED LONG, BYVAL bottom AS _UNSIGNED LONG, retVal AS Image)
        SUB GenImageGradientH (BYVAL W AS LONG, BYVAL H AS LONG, BYVAL left AS _UNSIGNED LONG, BYVAL right AS _UNSIGNED LONG, retVal AS Image)
        SUB GenImageGradientRadial (BYVAL W AS LONG, BYVAL H AS LONG, BYVAL density AS SINGLE, BYVAL inner AS _UNSIGNED LONG, BYVAL outer AS _UNSIGNED LONG, retVal AS Image)
        SUB GenImageChecked (BYVAL W AS LONG, BYVAL H AS LONG, BYVAL checksX AS LONG, BYVAL checksY AS LONG, BYVAL col1 AS _UNSIGNED LONG, BYVAL col2 AS _UNSIGNED LONG, retVal AS Image)
        SUB GenImageWhiteNoise (BYVAL W AS LONG, BYVAL H AS LONG, BYVAL factor AS SINGLE, retVal AS Image)
        SUB GenImagePerlinNoise (BYVAL W AS LONG, BYVAL H AS LONG, BYVAL offsetX AS LONG, BYVAL offsetY AS LONG, BYVAL scale AS SINGLE, retVal AS Image)
        SUB GenImageCellular (BYVAL W AS LONG, BYVAL H AS LONG, BYVAL tileSize AS LONG, retVal AS Image)
        SUB GenImageText (BYVAL W AS LONG, BYVAL H AS LONG, text AS STRING, retVal AS Image)
        SUB ImageCopy (img AS Image, retVal AS Image)
        SUB ImageFromImage (img AS Image, rec AS Rectangle, retVal AS Image)
        SUB ImageText (text AS STRING, BYVAL fontSize AS LONG, BYVAL clr AS _UNSIGNED LONG, retVal AS Image)
        SUB ImageTextEx (font AS Font, text AS STRING, BYVAL fontSize AS SINGLE, BYVAL spacing AS SINGLE, BYVAL tint AS _UNSIGNED LONG, retVal AS Image)
        SUB ImageFormat (img AS Image, BYVAL newFormat AS LONG)
        SUB ImageToPOT (img AS Image, BYVAL fill AS _UNSIGNED LONG)
        SUB ImageCrop (img AS Image, crop AS Rectangle)
        SUB ImageAlphaCrop (img AS Image, BYVAL threshold AS SINGLE)
        SUB ImageAlphaClear (img AS Image, BYVAL clr AS _UNSIGNED LONG, BYVAL threshold AS SINGLE)
        SUB ImageAlphaMask (img AS Image, alphaMask AS Image)
        SUB ImageAlphaPremultiply (img AS Image)
        SUB ImageBlurGaussian (img AS Image, BYVAL blurSize AS LONG)
        SUB ImageResize (img AS Image, BYVAL newWidth AS LONG, BYVAL newHeight AS LONG)
        SUB ImageResizeNN (img AS Image, BYVAL newWidth AS LONG, BYVAL newHeight AS LONG)
        SUB ImageResizeCanvas (img AS Image, BYVAL newWidth AS LONG, BYVAL newHeight AS LONG, BYVAL offsetX AS LONG, BYVAL offsetY AS LONG, BYVAL fill AS _UNSIGNED LONG)
        SUB ImageMipmaps (img AS Image)
        SUB ImageDither (img AS Image, BYVAL rBpp AS LONG, BYVAL gBpp AS LONG, BYVAL bBpp AS LONG, BYVAL aBpp AS LONG)
        SUB ImageFlipVertical (img AS Image)
        SUB ImageFlipHorizontal (img AS Image)
        SUB ImageRotateCW (img AS Image)
        SUB ImageRotateCCW (img AS Image)
        SUB ImageColorTint (img AS Image, BYVAL clr AS _UNSIGNED LONG)
        SUB ImageColorInvert (img AS Image)
        SUB ImageColorGrayscale (img AS Image)
        SUB ImageColorContrast (img AS Image, BYVAL contrast AS SINGLE)
        SUB ImageColorBrightness (img AS Image, BYVAL brightness AS LONG)
        SUB ImageColorReplace (img AS Image, BYVAL clr AS _UNSIGNED LONG, BYVAL replace AS _UNSIGNED LONG)
        FUNCTION LoadImageColors~%& (img AS Image)
        FUNCTION LoadImagePalette~%& (img AS Image, BYVAL maxPaletteSize AS LONG, colorCount AS LONG)
        SUB UnloadImageColors (colors AS _UNSIGNED LONG)
        SUB UnloadImagePalette (colors AS _UNSIGNED LONG)
        SUB GetImageAlphaBorder (img AS Image, BYVAL threshold AS SINGLE, retVal AS Rectangle)
        FUNCTION GetImageColor~& (img AS Image, BYVAL x AS LONG, BYVAL y AS LONG)
        SUB ImageClearBackground (dst AS Image, BYVAL clr AS _UNSIGNED LONG)
        SUB ImageDrawPixel (dst AS Image, BYVAL posX AS LONG, BYVAL posY AS LONG, BYVAL clr AS _UNSIGNED LONG)
        SUB ImageDrawPixelV (dst AS Image, position AS Vector2, BYVAL clr AS _UNSIGNED LONG)
        SUB ImageDrawLine (dst AS Image, BYVAL startPosX AS LONG, BYVAL startPosY AS LONG, BYVAL endPosX AS LONG, BYVAL endPosY AS LONG, BYVAL clr AS _UNSIGNED LONG)
        SUB ImageDrawLineV (dst AS Image, start AS Vector2, end AS Vector2, BYVAL clr AS _UNSIGNED LONG)
        SUB ImageDrawCircle (dst AS Image, BYVAL centerX AS LONG, BYVAL centerY AS LONG, BYVAL radius AS LONG, BYVAL clr AS _UNSIGNED LONG)
        SUB ImageDrawCircleV (dst AS Image, center AS Vector2, BYVAL radius AS LONG, BYVAL clr AS _UNSIGNED LONG)
        SUB ImageDrawCircleLines (dst AS Image, BYVAL centerX AS LONG, BYVAL centerY AS LONG, BYVAL radius AS LONG, BYVAL clr AS _UNSIGNED LONG)
        SUB ImageDrawCircleLinesV (dst AS Image, center AS Vector2, BYVAL radius AS LONG, BYVAL clr AS _UNSIGNED LONG)
        SUB ImageDrawRectangle (dst AS Image, BYVAL posX AS LONG, BYVAL posY AS LONG, BYVAL W AS LONG, BYVAL H AS LONG, BYVAL clr AS _UNSIGNED LONG)
        SUB ImageDrawRectangleV (dst AS Image, position AS Vector2, size AS Vector2, BYVAL clr AS _UNSIGNED LONG)
        SUB ImageDrawRectangleRec (dst AS Image, rec AS Rectangle, BYVAL clr AS _UNSIGNED LONG)
        SUB ImageDrawRectangleLines (dst AS Image, rec AS Rectangle, BYVAL thick AS LONG, BYVAL clr AS _UNSIGNED LONG)
        SUB ImageDraw (dst AS Image, src AS Image, srcRec AS Rectangle, dstRec AS Rectangle, BYVAL tint AS _UNSIGNED LONG)
        SUB ImageDrawText (dst AS Image, text AS STRING, BYVAL posX AS LONG, BYVAL posY AS LONG, BYVAL fontSize AS LONG, BYVAL clr AS _UNSIGNED LONG)
        SUB ImageDrawTextEx (dst AS Image, font AS Font, text AS STRING, position AS Vector2, BYVAL fontSize AS SINGLE, BYVAL spacing AS SINGLE, BYVAL tint AS _UNSIGNED LONG)
        SUB LoadTexture (fileName AS STRING, retVal AS Texture2D)
        SUB LoadTextureFromImage (img AS Image, retVal AS Texture2D)
        SUB LoadTextureCubemap (img AS Image, BYVAL layout AS LONG, retVal AS TextureCubemap)
        SUB LoadRenderTexture (BYVAL W AS LONG, BYVAL H AS LONG, retVal AS RenderTexture2D)
        FUNCTION IsTextureReady%% (tex AS Texture2D)
        SUB UnloadTexture (tex AS Texture2D)
        FUNCTION IsRenderTextureReady%% (target AS RenderTexture2D)
        SUB UnloadRenderTexture (target AS RenderTexture2D)
        SUB UpdateTexture (tex AS Texture2D, BYVAL pixels AS _UNSIGNED _OFFSET)
        SUB UpdateTextureRec (tex AS Texture2D, rec AS Rectangle, BYVAL pixels AS _UNSIGNED _OFFSET)
        SUB GenTextureMipmaps (tex AS Texture2D)
        SUB SetTextureFilter (tex AS Texture2D, BYVAL filter AS LONG)
        SUB SetTextureWrap (tex AS Texture2D, BYVAL wrap AS LONG)
        SUB DrawTexture (tex AS Texture2D, BYVAL posX AS LONG, BYVAL posY AS LONG, BYVAL tint AS _UNSIGNED LONG)
        SUB DrawTextureV (tex AS Texture2D, position AS Vector2, BYVAL tint AS _UNSIGNED LONG)
        SUB DrawTextureEx (tex AS Texture2D, position AS Vector2, BYVAL rotation AS SINGLE, BYVAL scale AS SINGLE, BYVAL tint AS _UNSIGNED LONG)
        SUB DrawTextureRec (tex AS Texture2D, source AS Rectangle, position AS Vector2, BYVAL tint AS _UNSIGNED LONG)
        SUB DrawTexturePro (tex AS Texture2D, source AS Rectangle, dest AS Rectangle, origin AS Vector2, BYVAL rotation AS SINGLE, BYVAL tint AS _UNSIGNED LONG)
        SUB DrawTextureNPatch (tex AS Texture2D, nPatchInfo AS NPatchInfo, dest AS Rectangle, origin AS Vector2, BYVAL rotation AS SINGLE, BYVAL tint AS _UNSIGNED LONG)
        FUNCTION Fade~& (BYVAL clr AS _UNSIGNED LONG, BYVAL alpha AS SINGLE)
        FUNCTION ColorToInt& (BYVAL clr AS _UNSIGNED LONG)
        SUB ColorNormalize (BYVAL clr AS _UNSIGNED LONG, retVal AS Vector4)
        FUNCTION ColorFromNormalized~& (normalized AS Vector4)
        SUB ColorToHSV (BYVAL clr AS _UNSIGNED LONG, retVal AS Vector3)
        FUNCTION ColorFromHSV~& (BYVAL hue AS SINGLE, BYVAL saturation AS SINGLE, BYVAL value AS SINGLE)
        FUNCTION ColorTint~& (BYVAL clr AS _UNSIGNED LONG, BYVAL tint AS _UNSIGNED LONG)
        FUNCTION ColorBrightness~& (BYVAL clr AS _UNSIGNED LONG, BYVAL factor AS SINGLE)
        FUNCTION ColorContrast~& (BYVAL clr AS _UNSIGNED LONG, BYVAL contrast AS SINGLE)
        FUNCTION ColorAlpha~& (BYVAL clr AS _UNSIGNED LONG, BYVAL alpha AS SINGLE)
        FUNCTION ColorAlphaBlend~& (BYVAL dst AS _UNSIGNED LONG, BYVAL src AS _UNSIGNED LONG, BYVAL tint AS _UNSIGNED LONG)
        FUNCTION GetColor~& (BYVAL hexValue AS _UNSIGNED LONG)
        FUNCTION GetPixelColor~& (BYVAL srcPtr AS _UNSIGNED _OFFSET, BYVAL format AS LONG)
        SUB SetPixelColor (BYVAL dstPtr AS _UNSIGNED _OFFSET, BYVAL clr AS _UNSIGNED LONG, BYVAL format AS LONG)
        FUNCTION GetPixelDataSize& (BYVAL W AS LONG, BYVAL H AS LONG, BYVAL format AS LONG)
        SUB GetFontDefault (retVal AS Font)
        SUB LoadFont (fileName AS STRING, retVal AS Font)
        SUB LoadFontEx (fileName AS STRING, BYVAL fontSize AS LONG, fontChars AS LONG, BYVAL glyphCount AS LONG, retVal AS Font)
        SUB LoadFontFromImage (img AS Image, BYVAL key AS _UNSIGNED LONG, BYVAL firstChar AS LONG, retVal AS Font)
        SUB LoadFontFromMemory (fileType AS STRING, fileData AS _UNSIGNED _BYTE, BYVAL dataSize AS LONG, BYVAL fontSize AS LONG, fontChars AS LONG, BYVAL glyphCount AS LONG, retVal AS Font)
        FUNCTION IsFontReady%% (font AS Font)
        FUNCTION LoadFontData~%& (fileData AS _UNSIGNED _BYTE, BYVAL dataSize AS LONG, BYVAL fontSize AS LONG, fontChars AS LONG, BYVAL glyphCount AS LONG, BYVAL type AS LONG)
        SUB GenImageFontAtlas (chars AS GlyphInfo, BYVAL recs AS _UNSIGNED _OFFSET, BYVAL glyphCount AS LONG, BYVAL fontSize AS LONG, BYVAL padding AS LONG, BYVAL packMethod AS LONG, retVal AS Image)
        SUB UnloadFontData (chars AS GlyphInfo, BYVAL glyphCount AS LONG)
        SUB UnloadFont (font AS Font)
        FUNCTION ExportFontAsCode%% (font AS Font, fileName AS STRING)
        SUB DrawFPS (BYVAL posX AS LONG, BYVAL posY AS LONG)
        SUB __DrawText ALIAS DrawText (text AS STRING, BYVAL posX AS LONG, BYVAL posY AS LONG, BYVAL fontSize AS LONG, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawTextEx (font AS Font, text AS STRING, position AS Vector2, BYVAL fontSize AS SINGLE, BYVAL spacing AS SINGLE, BYVAL tint AS _UNSIGNED LONG)
        SUB DrawTextPro (font AS Font, text AS STRING, position AS Vector2, origin AS Vector2, BYVAL rotation AS SINGLE, BYVAL fontSize AS SINGLE, BYVAL spacing AS SINGLE, BYVAL tint AS _UNSIGNED LONG)
        SUB DrawTextCodepoint (font AS Font, BYVAL codepoint AS LONG, position AS Vector2, BYVAL fontSize AS SINGLE, BYVAL tint AS _UNSIGNED LONG)
        SUB DrawTextCodepoints (font AS Font, codepoints AS LONG, BYVAL count AS LONG, position AS Vector2, BYVAL fontSize AS SINGLE, BYVAL spacing AS SINGLE, BYVAL tint AS _UNSIGNED LONG)
        FUNCTION MeasureText& (text AS STRING, BYVAL fontSize AS LONG)
        SUB MeasureTextEx (font AS Font, text AS STRING, BYVAL fontSize AS SINGLE, BYVAL spacing AS SINGLE, retVal AS Vector2)
        FUNCTION GetGlyphIndex& (font AS Font, BYVAL codepoint AS LONG)
        SUB GetGlyphInfo (font AS Font, BYVAL codepoint AS LONG, retVal AS GlyphInfo)
        SUB GetGlyphAtlasRec (font AS Font, BYVAL codepoint AS LONG, retVal AS Rectangle)
        FUNCTION LoadUTF8$ (codepoints AS LONG, BYVAL length AS LONG)
        SUB UnloadUTF8 (text AS STRING)
        FUNCTION LoadCodepoints~%& (text AS STRING, count AS LONG)
        SUB UnloadCodepoints (codepoints AS LONG)
        FUNCTION GetCodepointCount& (text AS STRING)
        FUNCTION GetCodepoint& (text AS STRING, codepointSize AS LONG)
        FUNCTION GetCodepointNext& (text AS STRING, codepointSize AS LONG)
        FUNCTION GetCodepointPrevious& (text AS STRING, codepointSize AS LONG)
        FUNCTION CodepointToUTF8$ (BYVAL codepoint AS LONG, utf8Size AS LONG)
        FUNCTION TextCopy& (dst AS STRING, src AS STRING)
        FUNCTION TextIsEqual%% (text1 AS STRING, text2 AS STRING)
        FUNCTION TextLength~& (text AS STRING)
        FUNCTION __TextFormatString$ ALIAS TextFormat (text AS STRING, s AS STRING)
        FUNCTION __TextFormatLong$ ALIAS TextFormat (text AS STRING, BYVAL i AS LONG)
        FUNCTION __TextFormatSingle$ ALIAS TextFormat (text AS STRING, BYVAL f AS SINGLE)
        FUNCTION TextSubtext$ (text AS STRING, BYVAL position AS LONG, BYVAL length AS LONG)
        FUNCTION TextReplace$ (text AS STRING, replace AS STRING, by AS STRING)
        FUNCTION TextInsert$ (text AS STRING, insert AS STRING, BYVAL position AS LONG)
        FUNCTION TextJoin$ (BYVAL textList AS _UNSIGNED _OFFSET, BYVAL count AS LONG, delimiter AS STRING)
        FUNCTION TextSplit~%& (text AS STRING, BYVAL delimiter AS _BYTE, count AS LONG)
        SUB TextAppend (text AS STRING, append AS STRING, position AS LONG)
        FUNCTION TextFindIndex& (text AS STRING, find AS STRING)
        FUNCTION TextToUpper$ (text AS STRING)
        FUNCTION TextToLower$ (text AS STRING)
        FUNCTION TextToPascal$ (text AS STRING)
        FUNCTION TextToInteger& (text AS STRING)
        SUB DrawLine3D (startPos AS Vector3, endPos AS Vector3, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawPoint3D (position AS Vector3, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawCircle3D (center AS Vector3, BYVAL radius AS SINGLE, rotationAxis AS Vector3, BYVAL rotationAngle AS SINGLE, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawTriangle3D (v1 AS Vector3, v2 AS Vector3, v3 AS Vector3, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawTriangleStrip3D (points AS Vector3, BYVAL pointCount AS LONG, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawCube (position AS Vector3, BYVAL W AS SINGLE, BYVAL H AS SINGLE, BYVAL length AS SINGLE, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawCubeV (position AS Vector3, size AS Vector3, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawCubeWires (position AS Vector3, BYVAL W AS SINGLE, BYVAL H AS SINGLE, BYVAL length AS SINGLE, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawCubeWiresV (position AS Vector3, size AS Vector3, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawSphere (centerPos AS Vector3, BYVAL radius AS SINGLE, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawSphereEx (centerPos AS Vector3, BYVAL radius AS SINGLE, BYVAL rings AS LONG, BYVAL slices AS LONG, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawSphereWires (centerPos AS Vector3, BYVAL radius AS SINGLE, BYVAL rings AS LONG, BYVAL slices AS LONG, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawCylinder (position AS Vector3, BYVAL radiusTop AS SINGLE, BYVAL radiusBottom AS SINGLE, BYVAL H AS SINGLE, BYVAL slices AS LONG, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawCylinderEx (startPos AS Vector3, endPos AS Vector3, BYVAL startRadius AS SINGLE, BYVAL endRadius AS SINGLE, BYVAL sides AS LONG, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawCylinderWires (position AS Vector3, BYVAL radiusTop AS SINGLE, BYVAL radiusBottom AS SINGLE, BYVAL H AS SINGLE, BYVAL slices AS LONG, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawCylinderWiresEx (startPos AS Vector3, endPos AS Vector3, BYVAL startRadius AS SINGLE, BYVAL endRadius AS SINGLE, BYVAL sides AS LONG, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawCapsule (startPos AS Vector3, endPos AS Vector3, BYVAL radius AS SINGLE, BYVAL slices AS LONG, BYVAL rings AS LONG, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawCapsuleWires (startPos AS Vector3, endPos AS Vector3, BYVAL radius AS SINGLE, BYVAL slices AS LONG, BYVAL rings AS LONG, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawPlane (centerPos AS Vector3, size AS Vector2, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawRay (ray AS Ray, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawGrid (BYVAL slices AS LONG, BYVAL spacing AS SINGLE)
        SUB LoadModel (fileName AS STRING, retVal AS Model)
        SUB LoadModelFromMesh (mesh AS Mesh, retVal AS Model)
        FUNCTION IsModelReady%% (model AS Model)
        SUB UnloadModel (model AS Model)
        SUB GetModelBoundingBox (model AS Model, retVal AS BoundingBox)
        SUB DrawModel (model AS Model, position AS Vector3, BYVAL scale AS SINGLE, BYVAL tint AS _UNSIGNED LONG)
        SUB DrawModelEx (model AS Model, position AS Vector3, rotationAxis AS Vector3, BYVAL rotationAngle AS SINGLE, scale AS Vector3, BYVAL tint AS _UNSIGNED LONG)
        SUB DrawModelWires (model AS Model, position AS Vector3, BYVAL scale AS SINGLE, BYVAL tint AS _UNSIGNED LONG)
        SUB DrawModelWiresEx (model AS Model, position AS Vector3, rotationAxis AS Vector3, BYVAL rotationAngle AS SINGLE, scale AS Vector3, BYVAL tint AS _UNSIGNED LONG)
        SUB DrawBoundingBox (box AS BoundingBox, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawBillboard (camera AS Camera, tex AS Texture2D, position AS Vector3, BYVAL size AS SINGLE, BYVAL tint AS _UNSIGNED LONG)
        SUB DrawBillboardRec (camera AS Camera, tex AS Texture2D, source AS Rectangle, position AS Vector3, size AS Vector2, BYVAL tint AS _UNSIGNED LONG)
        SUB DrawBillboardPro (camera AS Camera, tex AS Texture2D, source AS Rectangle, position AS Vector3, up AS Vector3, size AS Vector2, origin AS Vector2, BYVAL rotation AS SINGLE, BYVAL tint AS _UNSIGNED LONG)
        SUB UploadMesh (mesh AS Mesh, BYVAL dynamic AS _BYTE)
        SUB UpdateMeshBuffer (mesh AS Mesh, BYVAL index AS LONG, BYVAL dat AS _UNSIGNED _OFFSET, BYVAL dataSize AS LONG, BYVAL offset AS LONG)
        SUB UnloadMesh (mesh AS Mesh)
        SUB DrawMesh (mesh AS Mesh, material AS Material, transform AS Matrix)
        SUB DrawMeshInstanced (mesh AS Mesh, material AS Material, transforms AS Matrix, BYVAL instances AS LONG)
        FUNCTION ExportMesh%% (mesh AS Mesh, fileName AS STRING)
        SUB GetMeshBoundingBox (mesh AS Mesh, retVal AS BoundingBox)
        SUB GenMeshTangents (mesh AS Mesh)
        SUB GenMeshPoly (BYVAL sides AS LONG, BYVAL radius AS SINGLE, retVal AS Mesh)
        SUB GenMeshPlane (BYVAL W AS SINGLE, BYVAL length AS SINGLE, BYVAL resX AS LONG, BYVAL resZ AS LONG, retVal AS Mesh)
        SUB GenMeshCube (BYVAL W AS SINGLE, BYVAL H AS SINGLE, BYVAL length AS SINGLE, retVal AS Mesh)
        SUB GenMeshSphere (BYVAL radius AS SINGLE, BYVAL rings AS LONG, BYVAL slices AS LONG, retVal AS Mesh)
        SUB GenMeshHemiSphere (BYVAL radius AS SINGLE, BYVAL rings AS LONG, BYVAL slices AS LONG, retVal AS Mesh)
        SUB GenMeshCylinder (BYVAL radius AS SINGLE, BYVAL H AS SINGLE, BYVAL slices AS LONG, retVal AS Mesh)
        SUB GenMeshCone (BYVAL radius AS SINGLE, BYVAL H AS SINGLE, BYVAL slices AS LONG, retVal AS Mesh)
        SUB GenMeshTorus (BYVAL radius AS SINGLE, BYVAL size AS SINGLE, BYVAL radSeg AS LONG, BYVAL sides AS LONG, retVal AS Mesh)
        SUB GenMeshKnot (BYVAL radius AS SINGLE, BYVAL size AS SINGLE, BYVAL radSeg AS LONG, BYVAL sides AS LONG, retVal AS Mesh)
        SUB GenMeshHeightmap (heightmap AS Image, size AS Vector3, retVal AS Mesh)
        SUB GenMeshCubicmap (cubicmap AS Image, cubeSize AS Vector3, retVal AS Mesh)
        FUNCTION LoadMaterials~%& (fileName AS STRING, materialCount AS LONG)
        SUB LoadMaterialDefault (retVal AS Material)
        FUNCTION IsMaterialReady%% (material AS Material)
        SUB UnloadMaterial (material AS Material)
        SUB SetMaterialTexture (material AS Material, BYVAL mapType AS LONG, tex AS Texture2D)
        SUB SetModelMeshMaterial (model AS Model, BYVAL meshId AS LONG, BYVAL materialId AS LONG)
        FUNCTION LoadModelAnimations~%& (fileName AS STRING, animCount AS _UNSIGNED LONG)
        SUB UpdateModelAnimation (model AS Model, anim AS ModelAnimation, BYVAL frame AS LONG)
        SUB UnloadModelAnimation (anim AS ModelAnimation)
        SUB UnloadModelAnimations (animations AS ModelAnimation, BYVAL count AS _UNSIGNED LONG)
        FUNCTION IsModelAnimationValid%% (model AS Model, anim AS ModelAnimation)
        FUNCTION CheckCollisionSpheres%% (center1 AS Vector3, BYVAL radius1 AS SINGLE, center2 AS Vector3, BYVAL radius2 AS SINGLE)
        FUNCTION CheckCollisionBoxes%% (box1 AS BoundingBox, box2 AS BoundingBox)
        FUNCTION CheckCollisionBoxSphere%% (box AS BoundingBox, center AS Vector3, BYVAL radius AS SINGLE)
        SUB GetRayCollisionSphere (ray AS Ray, center AS Vector3, BYVAL radius AS SINGLE, retVal AS RayCollision)
        SUB GetRayCollisionBox (ray AS Ray, box AS BoundingBox, retVal AS RayCollision)
        SUB GetRayCollisionMesh (ray AS Ray, mesh AS Mesh, transform AS Matrix, retVal AS RayCollision)
        SUB GetRayCollisionTriangle (ray AS Ray, p1 AS Vector3, p2 AS Vector3, p3 AS Vector3, retVal AS RayCollision)
        SUB GetRayCollisionQuad (ray AS Ray, p1 AS Vector3, p2 AS Vector3, p3 AS Vector3, p4 AS Vector3, retVal AS RayCollision)
        SUB InitAudioDevice
        SUB CloseAudioDevice
        FUNCTION IsAudioDeviceReady%%
        SUB SetMasterVolume (BYVAL volume AS SINGLE)
        SUB LoadWave (fileName AS STRING, retVal AS Wave)
        SUB LoadWaveFromMemory (fileType AS STRING, fileData AS _UNSIGNED _BYTE, BYVAL dataSize AS LONG, retVal AS Wave)
        FUNCTION IsWaveReady%% (wave AS Wave)
        SUB LoadSound (fileName AS STRING, retVal AS Sound)
        SUB LoadSoundFromWave (wave AS Wave, retVal AS Sound)
        FUNCTION IsSoundReady%% (sound AS Sound)
        SUB UpdateSound (sound AS Sound, BYVAL dat AS _UNSIGNED _OFFSET, BYVAL sampleCount AS LONG)
        SUB UnloadWave (wave AS Wave)
        SUB UnloadSound (sound AS Sound)
        FUNCTION ExportWave%% (wave AS Wave, fileName AS STRING)
        FUNCTION ExportWaveAsCode%% (wave AS Wave, fileName AS STRING)
        SUB PlaySound (sound AS Sound)
        SUB StopSound (sound AS Sound)
        SUB PauseSound (sound AS Sound)
        SUB ResumeSound (sound AS Sound)
        FUNCTION IsSoundPlaying%% (sound AS Sound)
        SUB SetSoundVolume (sound AS Sound, BYVAL volume AS SINGLE)
        SUB SetSoundPitch (sound AS Sound, BYVAL pitch AS SINGLE)
        SUB SetSoundPan (sound AS Sound, BYVAL pan AS SINGLE)
        SUB WaveCopy (wave AS Wave, retVal AS Wave)
        SUB WaveCrop (wave AS Wave, BYVAL initSample AS LONG, BYVAL finalSample AS LONG)
        SUB WaveFormat (wave AS Wave, BYVAL sampleRate AS LONG, BYVAL sampleSize AS LONG, BYVAL channels AS LONG)
        FUNCTION LoadWaveSamples~%& (wave AS Wave)
        SUB UnloadWaveSamples (samples AS SINGLE)
        SUB LoadMusicStream (fileName AS STRING, retVal AS Music)
        SUB LoadMusicStreamFromMemory (fileType AS STRING, dat AS _UNSIGNED _BYTE, BYVAL dataSize AS LONG, retVal AS Music)
        FUNCTION IsMusicReady%% (music AS Music)
        SUB UnloadMusicStream (music AS Music)
        SUB PlayMusicStream (music AS Music)
        FUNCTION IsMusicStreamPlaying%% (music AS Music)
        SUB UpdateMusicStream (music AS Music)
        SUB StopMusicStream (music AS Music)
        SUB PauseMusicStream (music AS Music)
        SUB ResumeMusicStream (music AS Music)
        SUB SeekMusicStream (music AS Music, BYVAL position AS SINGLE)
        SUB SetMusicVolume (music AS Music, BYVAL volume AS SINGLE)
        SUB SetMusicPitch (music AS Music, BYVAL pitch AS SINGLE)
        SUB SetMusicPan (music AS Music, BYVAL pan AS SINGLE)
        FUNCTION GetMusicTimeLength! (music AS Music)
        FUNCTION GetMusicTimePlayed! (music AS Music)
        SUB LoadAudioStream (BYVAL sampleRate AS _UNSIGNED LONG, BYVAL sampleSize AS _UNSIGNED LONG, BYVAL channels AS _UNSIGNED LONG, retVal AS AudioStream)
        FUNCTION IsAudioStreamReady%% (stream AS AudioStream)
        SUB UnloadAudioStream (stream AS AudioStream)
        SUB UpdateAudioStream (stream AS AudioStream, BYVAL dat AS _UNSIGNED _OFFSET, BYVAL frameCount AS LONG)
        FUNCTION IsAudioStreamProcessed%% (stream AS AudioStream)
        SUB PlayAudioStream (stream AS AudioStream)
        SUB PauseAudioStream (stream AS AudioStream)
        SUB ResumeAudioStream (stream AS AudioStream)
        FUNCTION IsAudioStreamPlaying%% (stream AS AudioStream)
        SUB StopAudioStream (stream AS AudioStream)
        SUB SetAudioStreamVolume (stream AS AudioStream, BYVAL volume AS SINGLE)
        SUB SetAudioStreamPitch (stream AS AudioStream, BYVAL pitch AS SINGLE)
        SUB SetAudioStreamPan (stream AS AudioStream, BYVAL pan AS SINGLE)
        SUB SetAudioStreamBufferSizeDefault (BYVAL size AS LONG)
        SUB SetAudioStreamCallback (stream AS AudioStream, BYVAL callback AS _UNSIGNED _OFFSET)
        SUB AttachAudioStreamProcessor (stream AS AudioStream, BYVAL processor AS _UNSIGNED _OFFSET)
        SUB DetachAudioStreamProcessor (stream AS AudioStream, BYVAL processor AS _UNSIGNED _OFFSET)
        SUB AttachAudioMixedProcessor (BYVAL processor AS _UNSIGNED _OFFSET)
        SUB DetachAudioMixedProcessor (BYVAL processor AS _UNSIGNED _OFFSET)
    END DECLARE

    ' Initialize the C-side glue code
    IF __init_raylib THEN
        _DELAY 0.1 ' the delay is needed for the console window to appear
        _CONSOLE OFF ' hide the console by default
    ELSE
        PRINT "raylib initialization failed!"
        END 1
    END IF

$END IF
'-----------------------------------------------------------------------------------------------------------------------
