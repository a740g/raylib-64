'-----------------------------------------------------------------------------------------------------------------------
' raylib bindings for QB64-PE
' Copyright (c) 2023 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$IF RAYLIB_BI = UNDEFINED THEN
    $LET RAYLIB_BI = TRUE

    ' Check QB64-PE compiler version and complain if it does not meet minimum version requirement
    ' We do not support 32-bit versions. There are multiple roadblocks for supporting 32-bit platforms
    '   1. The official raylib binary distributons do not contain 32-bit shared libraries for all platforms
    '   2. The TYPES below are aligned for x86-64 arch. Padded with extra bytes wherever needed
    '   3. 32-bit machines and OSes are not mainstream anymore
    '   4. I clearly lack the motivation for adding 32-bit support. If anyone wants to do it, then please open a PR!
    $IF VERSION < 3.8 OR 32BIT THEN
            $ERROR This requires the latest 64-bit version of QB64-PE from https://github.com/QB64-Phoenix-Edition/QB64pe/releases/latest
    $END IF

    ' All identifiers must default to long (32-bits). This results in fastest code execution on x86 & x64
    DEFLNG A-Z

    ' Force all arrays to be defined (technically not required since we use _EXPLICIT below)
    OPTION _EXPLICITARRAY

    ' Force all variables to be defined
    OPTION _EXPLICIT

    ' All arrays should be static. If dynamic arrays are required use "REDIM"
    '$STATIC

    ' Start array lower bound from 1. If 0 is required, then it should be explicitly specified as (0 To X)
    OPTION BASE 1

    ' raylib uses it's own window. So, we force QB64-PE to hide it's own OpenGL window
    $SCREENHIDE

    ' Some common and useful constants
    CONST FALSE = 0, TRUE = NOT FALSE
    CONST NULL = 0
    CONST EMPTY_STRING = ""

    CONST SIZE_OF_BYTE = 1
    CONST SIZE_OF_INTEGER = 2
    CONST SIZE_OF_LONG = 4
    CONST SIZE_OF_INTEGER64 = 8
    CONST SIZE_OF_SINGLE = 4
    CONST SIZE_OF_DOUBLE = 8
    CONST SIZE_OF_OFFSET = 8

    CONST PI! = 3.14159265358979323846!
    CONST DEG2RAD! = PI / 180.0!
    CONST RAD2DEG! = 180.0! / PI

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

    ' System/Window config flags
    ' NOTE: Every bit registers one state (use it with bit masks)
    ' By default all flags are set to 0
    CONST FLAG_VSYNC_HINT = &H00000040 ' Set to try enabling V-Sync on GPU
    CONST FLAG_FULLSCREEN_MODE = &H00000002 ' Set to run program in fullscreen
    CONST FLAG_WINDOW_RESIZABLE = &H00000004 ' Set to allow resizable window
    CONST FLAG_WINDOW_UNDECORATED = &H00000008 ' Set to disable window decoration (frame and buttons)
    CONST FLAG_WINDOW_HIDDEN = &H00000080 ' Set to hide window
    CONST FLAG_WINDOW_MINIMIZED = &H00000200 ' Set to minimize window (iconify)
    CONST FLAG_WINDOW_MAXIMIZED = &H00000400 ' Set to maximize window (expanded to monitor)
    CONST FLAG_WINDOW_UNFOCUSED = &H00000800 ' Set to window non focused
    CONST FLAG_WINDOW_TOPMOST = &H00001000 ' Set to window always on top
    CONST FLAG_WINDOW_ALWAYS_RUN = &H00000100 ' Set to allow windows running while minimized
    CONST FLAG_WINDOW_TRANSPARENT = &H00000010 ' Set to allow transparent framebuffer
    CONST FLAG_WINDOW_HIGHDPI = &H00002000 ' Set to support HighDPI
    CONST FLAG_WINDOW_MOUSE_PASSTHROUGH = &H00004000 ' Set to support mouse passthrough, only supported when FLAG_WINDOW_UNDECORATED
    CONST FLAG_MSAA_4X_HINT = &H00000020 ' Set to try enabling MSAA 4X
    CONST FLAG_INTERLACED_HINT = &H00010000 ' Set to try enabling interlaced video format (for V3D)

    ' Trace log level
    ' NOTE: Organized by priority level
    CONST LOG_ALL = 0 ' Display all logs
    CONST LOG_TRACE = 1 ' Trace logging, intended for internal use only
    CONST LOG_DEBUG = 2 ' Debug logging, used for internal debugging, it should be disabled on release builds
    CONST LOG_INFO = 3 ' Info logging, used for program execution info
    CONST LOG_WARNING = 4 ' Warning logging, used on recoverable failures
    CONST LOG_ERROR = 5 ' Error logging, used on unrecoverable failures
    CONST LOG_FATAL = 6 ' Fatal logging, used to abort program: exit(EXIT_FAILURE)
    CONST LOG_NONE = 7 ' Disable logging

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

    ' Mouse buttons
    CONST MOUSE_BUTTON_LEFT = 0 ' Mouse button left
    CONST MOUSE_BUTTON_RIGHT = 1 ' Mouse button right
    CONST MOUSE_BUTTON_MIDDLE = 2 ' Mouse button middle (pressed wheel)
    CONST MOUSE_BUTTON_SIDE = 3 ' Mouse button side (advanced mouse device)
    CONST MOUSE_BUTTON_EXTRA = 4 ' Mouse button extra (advanced mouse device)
    CONST MOUSE_BUTTON_FORWARD = 5 ' Mouse button forward (advanced mouse device)
    CONST MOUSE_BUTTON_BACK = 6 ' Mouse button back (advanced mouse device)
    ' Add backwards compatibility support for deprecated names
    CONST MOUSE_LEFT_BUTTON = MOUSE_BUTTON_LEFT
    CONST MOUSE_RIGHT_BUTTON = MOUSE_BUTTON_RIGHT
    CONST MOUSE_MIDDLE_BUTTON = MOUSE_BUTTON_MIDDLE

    ' Mouse cursor
    CONST MOUSE_CURSOR_DEFAULT = 0 ' Default pointer shape
    CONST MOUSE_CURSOR_ARROW = 1 ' Arrow shape
    CONST MOUSE_CURSOR_IBEAM = 2 ' Text writing cursor shape
    CONST MOUSE_CURSOR_CROSSHAIR = 3 ' Cross shape
    CONST MOUSE_CURSOR_POINTING_HAND = 4 ' Pointing hand cursor
    CONST MOUSE_CURSOR_RESIZE_EW = 5 ' Horizontal resize/move arrow shape
    CONST MOUSE_CURSOR_RESIZE_NS = 6 ' Vertical resize/move arrow shape
    CONST MOUSE_CURSOR_RESIZE_NWSE = 7 ' Top-left to bottom-right diagonal resize/move arrow shape
    CONST MOUSE_CURSOR_RESIZE_NESW = 8 ' The top-right to bottom-left diagonal resize/move arrow shape
    CONST MOUSE_CURSOR_RESIZE_ALL = 9 ' The omnidirectional resize/move cursor shape
    CONST MOUSE_CURSOR_NOT_ALLOWED = 10 ' The operation-not-allowed shape

    ' Gamepad buttons
    CONST GAMEPAD_BUTTON_UNKNOWN = 0 ' Unknown button, just for error checking
    CONST GAMEPAD_BUTTON_LEFT_FACE_UP = 1 ' Gamepad left DPAD up button
    CONST GAMEPAD_BUTTON_LEFT_FACE_RIGHT = 2 ' Gamepad left DPAD right button
    CONST GAMEPAD_BUTTON_LEFT_FACE_DOWN = 3 ' Gamepad left DPAD down button
    CONST GAMEPAD_BUTTON_LEFT_FACE_LEFT = 4 ' Gamepad left DPAD left button
    CONST GAMEPAD_BUTTON_RIGHT_FACE_UP = 5 ' Gamepad right button up (i.e. PS3: Triangle, Xbox: Y)
    CONST GAMEPAD_BUTTON_RIGHT_FACE_RIGHT = 6 ' Gamepad right button right (i.e. PS3: Square, Xbox: X)
    CONST GAMEPAD_BUTTON_RIGHT_FACE_DOWN = 7 ' Gamepad right button down (i.e. PS3: Cross, Xbox: A)
    CONST GAMEPAD_BUTTON_RIGHT_FACE_LEFT = 8 ' Gamepad right button left (i.e. PS3: Circle, Xbox: B)
    CONST GAMEPAD_BUTTON_LEFT_TRIGGER_1 = 9 ' Gamepad top/back trigger left (first), it could be a trailing button
    CONST GAMEPAD_BUTTON_LEFT_TRIGGER_2 = 10 ' Gamepad top/back trigger left (second), it could be a trailing button
    CONST GAMEPAD_BUTTON_RIGHT_TRIGGER_1 = 11 ' Gamepad top/back trigger right (one), it could be a trailing button
    CONST GAMEPAD_BUTTON_RIGHT_TRIGGER_2 = 12 ' Gamepad top/back trigger right (second), it could be a trailing button
    CONST GAMEPAD_BUTTON_MIDDLE_LEFT = 13 ' Gamepad center buttons, left one (i.e. PS3: Select)
    CONST GAMEPAD_BUTTON_MIDDLE = 14 ' Gamepad center buttons, middle one (i.e. PS3: PS, Xbox: XBOX)
    CONST GAMEPAD_BUTTON_MIDDLE_RIGHT = 15 ' Gamepad center buttons, right one (i.e. PS3: Start)
    CONST GAMEPAD_BUTTON_LEFT_THUMB = 16 ' Gamepad joystick pressed button left
    CONST GAMEPAD_BUTTON_RIGHT_THUMB = 17 ' Gamepad joystick pressed button right

    ' Gamepad axis
    CONST GAMEPAD_AXIS_LEFT_X = 0 ' Gamepad left stick X axis
    CONST GAMEPAD_AXIS_LEFT_Y = 1 ' Gamepad left stick Y axis
    CONST GAMEPAD_AXIS_RIGHT_X = 2 ' Gamepad right stick X axis
    CONST GAMEPAD_AXIS_RIGHT_Y = 3 ' Gamepad right stick Y axis
    CONST GAMEPAD_AXIS_LEFT_TRIGGER = 4 ' Gamepad back trigger left, pressure level: [1..-1]
    CONST GAMEPAD_AXIS_RIGHT_TRIGGER = 5 ' Gamepad back trigger right, pressure level: [1..-1]

    ' Material map index
    CONST MATERIAL_MAP_ALBEDO = 0 ' Albedo material (same as: MATERIAL_MAP_DIFFUSE)
    CONST MATERIAL_MAP_METALNESS = 1 ' Metalness material (same as: MATERIAL_MAP_SPECULAR)
    CONST MATERIAL_MAP_NORMAL = 2 ' Normal material
    CONST MATERIAL_MAP_ROUGHNESS = 3 ' Roughness material
    CONST MATERIAL_MAP_OCCLUSION = 4 ' Ambient occlusion material
    CONST MATERIAL_MAP_EMISSION = 5 ' Emission material
    CONST MATERIAL_MAP_HEIGHT = 6 ' Heightmap material
    CONST MATERIAL_MAP_CUBEMAP = 7 ' Cubemap material (NOTE: Uses GL_TEXTURE_CUBE_MAP)
    CONST MATERIAL_MAP_IRRADIANCE = 8 ' Irradiance material (NOTE: Uses GL_TEXTURE_CUBE_MAP)
    CONST MATERIAL_MAP_PREFILTER = 9 ' Prefilter material (NOTE: Uses GL_TEXTURE_CUBE_MAP)
    CONST MATERIAL_MAP_BRDF = 10 ' Brdf material
    CONST MATERIAL_MAP_DIFFUSE = MATERIAL_MAP_ALBEDO
    CONST MATERIAL_MAP_SPECULAR = MATERIAL_MAP_METALNESS

    ' Shader location index
    CONST SHADER_LOC_VERTEX_POSITION = 0 ' Shader location: vertex attribute: position
    CONST SHADER_LOC_VERTEX_TEXCOORD01 = 1 ' Shader location: vertex attribute: texcoord01
    CONST SHADER_LOC_VERTEX_TEXCOORD02 = 2 ' Shader location: vertex attribute: texcoord02
    CONST SHADER_LOC_VERTEX_NORMAL = 3 ' Shader location: vertex attribute: normal
    CONST SHADER_LOC_VERTEX_TANGENT = 4 ' Shader location: vertex attribute: tangent
    CONST SHADER_LOC_VERTEX_COLOR = 5 ' Shader location: vertex attribute: color
    CONST SHADER_LOC_MATRIX_MVP = 6 ' Shader location: matrix uniform: model-view-projection
    CONST SHADER_LOC_MATRIX_VIEW = 7 ' Shader location: matrix uniform: view (camera transform)
    CONST SHADER_LOC_MATRIX_PROJECTION = 8 ' Shader location: matrix uniform: projection
    CONST SHADER_LOC_MATRIX_MODEL = 9 ' Shader location: matrix uniform: model (transform)
    CONST SHADER_LOC_MATRIX_NORMAL = 10 ' Shader location: matrix uniform: normal
    CONST SHADER_LOC_VECTOR_VIEW = 11 ' Shader location: vector uniform: view
    CONST SHADER_LOC_COLOR_DIFFUSE = 12 ' Shader location: vector uniform: diffuse color
    CONST SHADER_LOC_COLOR_SPECULAR = 13 ' Shader location: vector uniform: specular color
    CONST SHADER_LOC_COLOR_AMBIENT = 14 ' Shader location: vector uniform: ambient color
    CONST SHADER_LOC_MAP_ALBEDO = 15 ' Shader location: sampler2d texture: albedo (same as: SHADER_LOC_MAP_DIFFUSE)
    CONST SHADER_LOC_MAP_METALNESS = 16 ' Shader location: sampler2d texture: metalness (same as: SHADER_LOC_MAP_SPECULAR)
    CONST SHADER_LOC_MAP_NORMAL = 17 ' Shader location: sampler2d texture: normal
    CONST SHADER_LOC_MAP_ROUGHNESS = 18 ' Shader location: sampler2d texture: roughness
    CONST SHADER_LOC_MAP_OCCLUSION = 19 ' Shader location: sampler2d texture: occlusion
    CONST SHADER_LOC_MAP_EMISSION = 20 ' Shader location: sampler2d texture: emission
    CONST SHADER_LOC_MAP_HEIGHT = 21 ' Shader location: sampler2d texture: height
    CONST SHADER_LOC_MAP_CUBEMAP = 22 ' Shader location: samplerCube texture: cubemap
    CONST SHADER_LOC_MAP_IRRADIANCE = 23 ' Shader location: samplerCube texture: irradiance
    CONST SHADER_LOC_MAP_PREFILTER = 24 ' Shader location: samplerCube texture: prefilter
    CONST SHADER_LOC_MAP_BRDF = 25 ' Shader location: sampler2d texture: brdf
    CONST SHADER_LOC_MAP_DIFFUSE = SHADER_LOC_MAP_ALBEDO
    CONST SHADER_LOC_MAP_SPECULAR = SHADER_LOC_MAP_METALNESS

    ' Shader uniform data type
    CONST SHADER_UNIFORM_FLOAT = 0 ' Shader uniform type: float
    CONST SHADER_UNIFORM_VEC2 = 1 ' Shader uniform type: vec2 (2 float)
    CONST SHADER_UNIFORM_VEC3 = 2 ' Shader uniform type: vec3 (3 float)
    CONST SHADER_UNIFORM_VEC4 = 3 ' Shader uniform type: vec4 (4 float)
    CONST SHADER_UNIFORM_INT = 4 ' Shader uniform type: int
    CONST SHADER_UNIFORM_IVEC2 = 5 ' Shader uniform type: ivec2 (2 int)
    CONST SHADER_UNIFORM_IVEC3 = 6 ' Shader uniform type: ivec3 (3 int)
    CONST SHADER_UNIFORM_IVEC4 = 7 ' Shader uniform type: ivec4 (4 int)
    CONST SHADER_UNIFORM_SAMPLER2D = 8 ' Shader uniform type: sampler2d

    ' Shader attribute data types
    CONST SHADER_ATTRIB_FLOAT = 0 ' Shader attribute type: float
    CONST SHADER_ATTRIB_VEC2 = 1 ' Shader attribute type: vec2 (2 float)
    CONST SHADER_ATTRIB_VEC3 = 2 ' Shader attribute type: vec3 (3 float)
    CONST SHADER_ATTRIB_VEC4 = 3 ' Shader attribute type: vec4 (4 float)

    ' Pixel formats
    ' NOTE: Support depends on OpenGL version and platform
    CONST PIXELFORMAT_UNCOMPRESSED_GRAYSCALE = 1 ' 8 bit per pixel (no alpha)
    CONST PIXELFORMAT_UNCOMPRESSED_GRAY_ALPHA = 2 ' 8*2 bpp (2 channels)
    CONST PIXELFORMAT_UNCOMPRESSED_R5G6B5 = 3 ' 16 bpp
    CONST PIXELFORMAT_UNCOMPRESSED_R8G8B8 = 4 ' 24 bpp
    CONST PIXELFORMAT_UNCOMPRESSED_R5G5B5A1 = 5 ' 16 bpp (1 bit alpha)
    CONST PIXELFORMAT_UNCOMPRESSED_R4G4B4A4 = 6 ' 16 bpp (4 bit alpha)
    CONST PIXELFORMAT_UNCOMPRESSED_R8G8B8A8 = 7 ' 32 bpp
    CONST PIXELFORMAT_UNCOMPRESSED_R32 = 8 ' 32 bpp (1 channel - float)
    CONST PIXELFORMAT_UNCOMPRESSED_R32G32B32 = 9 ' 32*3 bpp (3 channels - float)
    CONST PIXELFORMAT_UNCOMPRESSED_R32G32B32A32 = 10 ' 32*4 bpp (4 channels - float)
    CONST PIXELFORMAT_COMPRESSED_DXT1_RGB = 11 ' 4 bpp (no alpha)
    CONST PIXELFORMAT_COMPRESSED_DXT1_RGBA = 12 ' 4 bpp (1 bit alpha)
    CONST PIXELFORMAT_COMPRESSED_DXT3_RGBA = 13 ' 8 bpp
    CONST PIXELFORMAT_COMPRESSED_DXT5_RGBA = 14 ' 8 bpp
    CONST PIXELFORMAT_COMPRESSED_ETC1_RGB = 15 ' 4 bpp
    CONST PIXELFORMAT_COMPRESSED_ETC2_RGB = 16 ' 4 bpp
    CONST PIXELFORMAT_COMPRESSED_ETC2_EAC_RGBA = 17 ' 8 bpp
    CONST PIXELFORMAT_COMPRESSED_PVRT_RGB = 18 ' 4 bpp
    CONST PIXELFORMAT_COMPRESSED_PVRT_RGBA = 19 ' 4 bpp
    CONST PIXELFORMAT_COMPRESSED_ASTC_4x4_RGBA = 20 ' 8 bpp
    CONST PIXELFORMAT_COMPRESSED_ASTC_8x8_RGBA = 21 ' 2 bpp

    ' Texture parameters: filter mode
    ' NOTE 1: Filtering considers mipmaps if available in the texture
    ' NOTE 2: Filter is accordingly set for minification and magnification
    CONST TEXTURE_FILTER_POINT = 0 ' No filter, just pixel approximation
    CONST TEXTURE_FILTER_BILINEAR = 1 ' Linear filtering
    CONST TEXTURE_FILTER_TRILINEAR = 2 ' Trilinear filtering (linear with mipmaps)
    CONST TEXTURE_FILTER_ANISOTROPIC_4X = 3 ' Anisotropic filtering 4x
    CONST TEXTURE_FILTER_ANISOTROPIC_8X = 4 ' Anisotropic filtering 8x
    CONST TEXTURE_FILTER_ANISOTROPIC_16X = 5 ' Anisotropic filtering 16x

    ' Texture parameters: wrap mode
    CONST TEXTURE_WRAP_REPEAT = 0 ' Repeats texture in tiled mode
    CONST TEXTURE_WRAP_CLAMP = 1 ' Clamps texture to edge pixel in tiled mode
    CONST TEXTURE_WRAP_MIRROR_REPEAT = 2 ' Mirrors and repeats the texture in tiled mode
    CONST TEXTURE_WRAP_MIRROR_CLAMP = 3 ' Mirrors and clamps to border the texture in tiled mode

    ' Cubemap layouts
    CONST CUBEMAP_LAYOUT_AUTO_DETECT = 0 ' Automatically detect layout type
    CONST CUBEMAP_LAYOUT_LINE_VERTICAL = 1 ' Layout is defined by a vertical line with faces
    CONST CUBEMAP_LAYOUT_LINE_HORIZONTAL = 2 ' Layout is defined by a horizontal line with faces
    CONST CUBEMAP_LAYOUT_CROSS_THREE_BY_FOUR = 3 ' Layout is defined by a 3x4 cross with cubemap faces
    CONST CUBEMAP_LAYOUT_CROSS_FOUR_BY_THREE = 4 ' Layout is defined by a 4x3 cross with cubemap faces
    CONST CUBEMAP_LAYOUT_PANORAMA = 5 ' Layout is defined by a panorama image (equirrectangular map)

    ' Font type, defines generation method
    CONST FONT_DEFAULT = 0 ' Default font generation, anti-aliased
    CONST FONT_BITMAP = 1 ' Bitmap font generation, no anti-aliasing
    CONST FONT_SDF = 2 ' SDF font generation, requires external shader

    ' Color blending modes (pre-defined)
    CONST BLEND_ALPHA = 0 ' Blend textures considering alpha (default)
    CONST BLEND_ADDITIVE = 1 ' Blend textures adding colors
    CONST BLEND_MULTIPLIED = 2 ' Blend textures multiplying colors
    CONST BLEND_ADD_COLORS = 3 ' Blend textures adding colors (alternative)
    CONST BLEND_SUBTRACT_COLORS = 4 ' Blend textures subtracting colors (alternative)
    CONST BLEND_ALPHA_PREMULTIPLY = 5 ' Blend premultiplied textures considering alpha
    CONST BLEND_CUSTOM = 6 ' Blend textures using custom src/dst factors (use rlSetBlendFactors())
    CONST BLEND_CUSTOM_SEPARATE = 7 ' Blend textures using custom rgb/alpha separate src/dst factors (use rlSetBlendFactorsSeparate())

    ' Gesture
    ' NOTE: Provided as bit-wise flags to enable only desired gestures
    CONST GESTURE_NONE = 0 ' No gesture
    CONST GESTURE_TAP = 1 ' Tap gesture
    CONST GESTURE_DOUBLETAP = 2 ' Double tap gesture
    CONST GESTURE_HOLD = 4 ' Hold gesture
    CONST GESTURE_DRAG = 8 ' Drag gesture
    CONST GESTURE_SWIPE_RIGHT = 16 ' Swipe right gesture
    CONST GESTURE_SWIPE_LEFT = 32 ' Swipe left gesture
    CONST GESTURE_SWIPE_UP = 64 ' Swipe up gesture
    CONST GESTURE_SWIPE_DOWN = 128 ' Swipe down gesture
    CONST GESTURE_PINCH_IN = 256 ' Pinch in gesture
    CONST GESTURE_PINCH_OUT = 512 ' Pinch out gesture

    ' Camera system modes
    CONST CAMERA_CUSTOM = 0 ' Custom camera
    CONST CAMERA_FREE = 1 ' Free camera
    CONST CAMERA_ORBITAL = 2 ' Orbital camera
    CONST CAMERA_FIRST_PERSON = 3 ' First person camera
    CONST CAMERA_THIRD_PERSON = 4 ' Third person camera

    ' Camera projection
    CONST CAMERA_PERSPECTIVE = 0 ' Perspective projection
    CONST CAMERA_ORTHOGRAPHIC = 1 ' Orthographic projection

    ' N-patch layout
    CONST NPATCH_NINE_PATCH = 0 ' Npatch layout: 3x3 tiles
    CONST NPATCH_THREE_PATCH_VERTICAL = 1 ' Npatch layout: 1x3 tiles
    CONST NPATCH_THREE_PATCH_HORIZONTAL = 2 ' Npatch layout: 3x1 tiles

    ' Vector2, 2 components
    TYPE Vector2
        AS SINGLE x ' Vector x component
        AS SINGLE y ' Vector y component
    END TYPE
    CONST SIZE_OF_VECTOR2 = SIZE_OF_SINGLE * 2

    ' Vector3, 3 components
    TYPE Vector3
        AS SINGLE x ' Vector x component
        AS SINGLE y ' Vector y component
        AS SINGLE z ' Vector z component
    END TYPE
    CONST SIZE_OF_VECTOR3 = SIZE_OF_SINGLE * 3

    ' Vector4, 4 components
    TYPE Vector4
        AS SINGLE x ' Vector x component
        AS SINGLE y ' Vector y component
        AS SINGLE z ' Vector z component
        AS SINGLE w ' Vector w component
    END TYPE
    CONST SIZE_OF_VECTOR4 = SIZE_OF_SINGLE * 4

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
    CONST SIZE_OF_RGBA = SIZE_OF_BYTE * 4

    ' Rectangle, 4 components
    TYPE Rectangle
        AS SINGLE x ' Rectangle top-left corner position x
        AS SINGLE y ' Rectangle top-left corner position y
        AS SINGLE W ' Rectangle width
        AS SINGLE H ' Rectangle height
    END TYPE
    CONST SIZE_OF_RECTANGLE = SIZE_OF_SINGLE * 4

    ' Image, pixel data stored in CPU memory (RAM)
    TYPE Image
        AS _UNSIGNED _OFFSET dat ' Image raw data
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

    ' RenderTexture, fbo for texture rendering
    TYPE RenderTexture
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
        AS Texture tex ' Texture atlas containing the glyphs
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
        AS STRING * 4 padding
        AS _UNSIGNED _OFFSET vboId ' OpenGL Vertex Buffer Objects id (default vertex data) (unsigned int *)
    END TYPE

    ' Shader
    TYPE Shader
        AS LONG id ' Shader program id
        AS STRING * 4 padding
        AS _UNSIGNED _OFFSET locs ' Shader locations array (RL_MAX_SHADER_LOCATIONS)
    END TYPE

    ' MaterialMap
    TYPE MaterialMap
        AS Texture tex ' Material map texture
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
        AS Vector4 rotation ' Rotation
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
        AS STRING * 4 padding
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
        AS LONG hit ' Did the ray hit something?
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
        AS STRING * 4 padding
    END TYPE

    ' Sound
    TYPE RSound
        AS AudioStream stream ' Audio stream
        AS _UNSIGNED LONG frameCount ' Total number of frames (considering channels)
        AS STRING * 4 padding
    END TYPE

    ' Music, audio stream, anything longer than ~10 seconds should be streamed
    TYPE Music
        AS AudioStream stream ' Audio stream
        AS _UNSIGNED LONG frameCount ' Total number of frames (considering channels)
        AS LONG looping ' Music looping enable
        AS LONG ctxType ' Type of music context (audio filetype)
        AS _UNSIGNED _OFFSET ctxData ' Audio context data, depends on type (void *)
        AS STRING * 4 padding
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
    ' Some of these may be incorrect due to the simple autogen code that I wrote and will need to be manually corrected
    ' Do not call anything with leading `__` directly. Use the QB64-PE function wrappers in raylib.bas instead
    '-------------------------------------------------------------------------------------------------------------------
    DECLARE STATIC LIBRARY "raylib"
        FUNCTION __init_raylib%% ' for iternal use only

        ' Low-level stuff that makes life easy when working with external libraries
        FUNCTION ToQBBool%% (BYVAL x AS LONG)
        FUNCTION ToCBool%% (BYVAL x AS LONG)
        FUNCTION CLngPtr~&& (BYVAL ptr AS _UNSIGNED _OFFSET)
        FUNCTION CStr$ (BYVAL ptr AS _UNSIGNED _OFFSET)
        FUNCTION PeekByte~%% (BYVAL ptr AS _UNSIGNED _OFFSET, BYVAL ofs AS _UNSIGNED _OFFSET)
        SUB PokeByte (BYVAL ptr AS _UNSIGNED _OFFSET, BYVAL ofs AS _UNSIGNED _OFFSET, BYVAL n AS _UNSIGNED _BYTE)
        FUNCTION PeekInteger~% (BYVAL ptr AS _UNSIGNED _OFFSET, BYVAL ofs AS _UNSIGNED _OFFSET)
        SUB PokeInteger (BYVAL ptr AS _UNSIGNED _OFFSET, BYVAL ofs AS _UNSIGNED _OFFSET, BYVAL n AS _UNSIGNED INTEGER)
        FUNCTION PeekLong~& (BYVAL ptr AS _UNSIGNED _OFFSET, BYVAL ofs AS _UNSIGNED _OFFSET)
        SUB PokeLong (BYVAL ptr AS _UNSIGNED _OFFSET, BYVAL ofs AS _UNSIGNED _OFFSET, BYVAL n AS _UNSIGNED LONG)
        FUNCTION PeekInteger64~&& (BYVAL ptr AS _UNSIGNED _OFFSET, BYVAL ofs AS _UNSIGNED _OFFSET)
        SUB PokeInteger64 (BYVAL ptr AS _UNSIGNED _OFFSET, BYVAL ofs AS _UNSIGNED _OFFSET, BYVAL n AS _UNSIGNED _INTEGER64)
        FUNCTION PeekSingle! (BYVAL ptr AS _UNSIGNED _OFFSET, BYVAL ofs AS _UNSIGNED _OFFSET)
        SUB PokeSingle (BYVAL ptr AS _UNSIGNED _OFFSET, BYVAL ofs AS _UNSIGNED _OFFSET, BYVAL n AS SINGLE)
        FUNCTION PeekDouble# (BYVAL ptr AS _UNSIGNED _OFFSET, BYVAL ofs AS _UNSIGNED _OFFSET)
        SUB PokeDouble (BYVAL ptr AS _UNSIGNED _OFFSET, BYVAL ofs AS _UNSIGNED _OFFSET, BYVAL n AS DOUBLE)
        FUNCTION PeekOffset%& (BYVAL ptr AS _UNSIGNED _OFFSET, BYVAL ofs AS _UNSIGNED _OFFSET)
        SUB PokeOffset (BYVAL ptr AS _UNSIGNED _OFFSET, BYVAL ofs AS _UNSIGNED _OFFSET, BYVAL n AS _UNSIGNED _OFFSET)
        SUB PeekType (BYVAL ptr AS _UNSIGNED _OFFSET, BYVAL ofs AS _UNSIGNED _OFFSET, BYVAL typeVar AS _UNSIGNED _OFFSET, BYVAL typeSize AS _UNSIGNED _OFFSET)
        SUB PokeType (BYVAL ptr AS _UNSIGNED _OFFSET, BYVAL ofs AS _UNSIGNED _OFFSET, BYVAL typeVar AS _UNSIGNED _OFFSET, BYVAL typeSize AS _UNSIGNED _OFFSET)
        FUNCTION PeekStringByte%% (s AS STRING, BYVAL ofs AS _UNSIGNED _OFFSET)
        SUB PokeStringByte (s AS STRING, BYVAL ofs AS _UNSIGNED _OFFSET, BYVAL n AS _BYTE)
        FUNCTION PeekStringInteger% (s AS STRING, BYVAL ofs AS _UNSIGNED _OFFSET)
        SUB PokeStringInteger (s AS STRING, BYVAL ofs AS _UNSIGNED _OFFSET, BYVAL n AS INTEGER)
        FUNCTION PeekStringLong& (s AS STRING, BYVAL ofs AS _UNSIGNED _OFFSET)
        SUB PokeStringLong (s AS STRING, BYVAL ofs AS _UNSIGNED _OFFSET, BYVAL n AS LONG)
        FUNCTION PeekStringInteger64&& (s AS STRING, BYVAL ofs AS _UNSIGNED _OFFSET)
        SUB PokeStringInteger64 (s AS STRING, BYVAL ofs AS _UNSIGNED _OFFSET, BYVAL n AS _INTEGER64)
        FUNCTION PeekStringSingle! (s AS STRING, BYVAL ofs AS _UNSIGNED _OFFSET)
        SUB PokeStringSingle (s AS STRING, BYVAL ofs AS _UNSIGNED _OFFSET, BYVAL n AS SINGLE)
        FUNCTION PeekStringDouble# (s AS STRING, BYVAL ofs AS _UNSIGNED _OFFSET)
        SUB PokeStringDouble (s AS STRING, BYVAL ofs AS _UNSIGNED _OFFSET, BYVAL n AS DOUBLE)
        FUNCTION PeekStringOffset~%& (s AS STRING, BYVAL ofs AS _UNSIGNED _OFFSET)
        SUB PokeStringOffset (s AS STRING, BYVAL ofs AS _UNSIGNED _OFFSET, BYVAL n AS _UNSIGNED _OFFSET)
        SUB PeekStringType (s AS STRING, BYVAL ofs AS _UNSIGNED _OFFSET, BYVAL typeVar AS _UNSIGNED _OFFSET, BYVAL typeSize AS _UNSIGNED _OFFSET)
        SUB PokeStringType (s AS STRING, BYVAL ofs AS _UNSIGNED _OFFSET, BYVAL typeVar AS _UNSIGNED _OFFSET, BYVAL typeSize AS _UNSIGNED _OFFSET)
        FUNCTION ToRGBA~& (BYVAL r AS _UNSIGNED _BYTE, BYVAL g AS _UNSIGNED _BYTE, BYVAL b AS _UNSIGNED _BYTE, BYVAL a AS _UNSIGNED _BYTE)
        FUNCTION GetRed~%% (BYVAL rgba AS _UNSIGNED LONG)
        FUNCTION GetGreen~%% (BYVAL rgba AS _UNSIGNED LONG)
        FUNCTION GetBlue~%% (BYVAL rgba AS _UNSIGNED LONG)
        FUNCTION GetAlpha~%% (BYVAL rgba AS _UNSIGNED LONG)
        FUNCTION GetRGB~& (BYVAL rgba AS _UNSIGNED LONG)
        FUNCTION SwapRedBlue~& (BYVAL clr AS _UNSIGNED LONG)

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
        SUB BeginMode2D (cam AS Camera2D)
        SUB EndMode2D
        SUB BeginMode3D (cam AS Camera3D)
        SUB EndMode3D
        SUB BeginTextureMode (target AS RenderTexture)
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
        SUB __LoadShader ALIAS LoadShader (vsFileName AS STRING, fsFileName AS STRING, retVal AS Shader)
        SUB __LoadShaderFromMemory ALIAS LoadShaderFromMemory (vsCode AS STRING, fsCode AS STRING, retVal AS Shader)
        FUNCTION IsShaderReady%% (shdr AS Shader)
        FUNCTION __GetShaderLocation& ALIAS GetShaderLocation (shdr AS Shader, uniformName AS STRING)
        FUNCTION __GetShaderLocationAttrib& ALIAS GetShaderLocationAttrib (shdr AS Shader, attribName AS STRING)
        SUB SetShaderValue (shdr AS Shader, BYVAL locIndex AS LONG, BYVAL value AS _UNSIGNED _OFFSET, BYVAL uniformType AS LONG)
        SUB SetShaderValueV (shdr AS Shader, BYVAL locIndex AS LONG, BYVAL value AS _UNSIGNED _OFFSET, BYVAL uniformType AS LONG, BYVAL count AS LONG)
        SUB SetShaderValueMatrix (shdr AS Shader, BYVAL locIndex AS LONG, mat AS Matrix)
        SUB SetShaderValueTexture (shdr AS Shader, BYVAL locIndex AS LONG, tex AS Texture)
        SUB UnloadShader (shdr AS Shader)
        SUB GetMouseRay (mousePosition AS Vector2, cam AS Camera3D, retVal AS Ray)
        SUB GetCameraMatrix (cam AS Camera3D, retVal AS Matrix)
        SUB GetCameraMatrix2D (cam AS Camera2D, retVal AS Matrix)
        SUB GetWorldToScreen (position AS Vector3, cam AS Camera3D, retVal AS Vector2)
        SUB GetScreenToWorld2D (position AS Vector2, cam AS Camera2D, retVal AS Vector2)
        SUB GetWorldToScreenEx (position AS Vector3, cam AS Camera3D, BYVAL W AS LONG, BYVAL H AS LONG, retVal AS Vector2)
        SUB GetWorldToScreen2D (position AS Vector2, cam AS Camera2D, retVal AS Vector2)
        SUB SetTargetFPS (BYVAL fps AS LONG)
        FUNCTION GetFPS&
        FUNCTION GetFrameTime!
        FUNCTION GetTime#
        FUNCTION GetRandomValue& (BYVAL min AS LONG, BYVAL max AS LONG)
        SUB SetRandomSeed (BYVAL seed AS _UNSIGNED LONG)
        SUB __TakeScreenshot ALIAS TakeScreenshot (fileName AS STRING)
        SUB SetConfigFlags (BYVAL flags AS _UNSIGNED LONG)
        SUB __TraceLog ALIAS TraceLog (BYVAL logLevel AS LONG, text AS STRING)
        SUB __TraceLogString ALIAS TraceLog (BYVAL logLevel AS LONG, text AS STRING, s AS STRING)
        SUB __TraceLogLong ALIAS TraceLog (BYVAL logLevel AS LONG, text AS STRING, BYVAL i AS LONG)
        SUB __TraceLogSingle ALIAS TraceLog (BYVAL logLevel AS LONG, text AS STRING, BYVAL f AS SINGLE)
        SUB SetTraceLogLevel (BYVAL logLevel AS LONG)
        FUNCTION MemAlloc~%& (BYVAL size AS _UNSIGNED LONG)
        FUNCTION MemRealloc~%& (BYVAL ptr AS _UNSIGNED _OFFSET, BYVAL size AS _UNSIGNED LONG)
        SUB MemFree (BYVAL ptr AS _UNSIGNED _OFFSET)
        SUB __OpenURL ALIAS OpenURL (url AS STRING)
        SUB SetTraceLogCallback (BYVAL callback AS _UNSIGNED _OFFSET)
        SUB SetLoadFileDataCallback (BYVAL callback AS _UNSIGNED _OFFSET)
        SUB SetSaveFileDataCallback (BYVAL callback AS _UNSIGNED _OFFSET)
        SUB SetLoadFileTextCallback (BYVAL callback AS _UNSIGNED _OFFSET)
        SUB SetSaveFileTextCallback (BYVAL callback AS _UNSIGNED _OFFSET)
        FUNCTION __LoadFileData~%& ALIAS LoadFileData (fileName AS STRING, bytesRead AS _UNSIGNED LONG)
        SUB UnloadFileData (BYVAL dat AS _UNSIGNED _OFFSET)
        FUNCTION SaveFileData%% (fileName AS STRING, BYVAL dat AS _UNSIGNED _OFFSET, BYVAL bytesToWrite AS _UNSIGNED LONG)
        FUNCTION ExportDataAsCode%% (BYVAL dat AS _UNSIGNED _OFFSET, BYVAL size AS _UNSIGNED LONG, fileName AS STRING)
        FUNCTION LoadFileText~%& (fileName AS STRING)
        SUB UnloadFileText (BYVAL text AS _UNSIGNED _OFFSET)
        FUNCTION __SaveFileText%% ALIAS SaveFileText (fileName AS STRING, text AS STRING)
        FUNCTION __FileExists%% ALIAS FileExists (fileName AS STRING)
        FUNCTION __DirectoryExists%% ALIAS DirectoryExists (dirPath AS STRING)
        FUNCTION __IsFileExtension%% ALIAS IsFileExtension (fileName AS STRING, ext AS STRING)
        FUNCTION __GetFileLength& ALIAS GetFileLength (fileName AS STRING)
        FUNCTION __GetFileExtension$ ALIAS GetFileExtension (fileName AS STRING)
        FUNCTION __GetFileName$ ALIAS GetFileName (filePath AS STRING)
        FUNCTION __GetFileNameWithoutExt$ ALIAS GetFileNameWithoutExt (filePath AS STRING)
        FUNCTION __GetDirectoryPath$ ALIAS GetDirectoryPath (filePath AS STRING)
        FUNCTION __GetPrevDirectoryPath$ ALIAS GetPrevDirectoryPath (dirPath AS STRING)
        FUNCTION GetWorkingDirectory$
        FUNCTION GetApplicationDirectory$
        FUNCTION __ChangeDirectory%% ALIAS ChangeDirectory (dir AS STRING)
        FUNCTION __IsPathFile%% ALIAS IsPathFile (path AS STRING)
        SUB __LoadDirectoryFiles ALIAS LoadDirectoryFiles (dirPath AS STRING, retVal AS FilePathList)
        SUB __LoadDirectoryFilesEx ALIAS LoadDirectoryFilesEx (basePath AS STRING, filter AS STRING, BYVAL scanSubdirs AS _BYTE, retVal AS FilePathList)
        SUB UnloadDirectoryFiles (files AS FilePathList)
        FUNCTION IsFileDropped%%
        SUB LoadDroppedFiles (retVal AS FilePathList)
        SUB UnloadDroppedFiles (droppedFiles AS FilePathList)
        FUNCTION __GetFileModTime& ALIAS GetFileModTime (fileName AS STRING)
        FUNCTION CompressData~%& (BYVAL dat AS _UNSIGNED _OFFSET, BYVAL dataSize AS LONG, compDataSize AS LONG)
        FUNCTION DecompressData~%& (BYVAL compData AS _UNSIGNED _OFFSET, BYVAL compDataSize AS LONG, dataSize AS LONG)
        FUNCTION EncodeDataBase64$ (BYVAL dat AS _UNSIGNED _OFFSET, BYVAL dataSize AS LONG, outputSize AS LONG)
        FUNCTION DecodeDataBase64~%& (BYVAL dat AS _UNSIGNED _OFFSET, outputSize AS LONG)
        FUNCTION IsKeyPressed%% (BYVAL kbKey AS LONG)
        FUNCTION IsKeyDown%% (BYVAL kbKey AS LONG)
        FUNCTION IsKeyReleased%% (BYVAL kbKey AS LONG)
        FUNCTION IsKeyUp%% (BYVAL kbKey AS LONG)
        SUB SetExitKey (BYVAL kbKey AS LONG)
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
        SUB UpdateCamera (cam AS Camera3D, BYVAL mode AS LONG)
        SUB UpdateCameraPro (cam AS Camera3D, movement AS Vector3, rotation AS Vector3, BYVAL zoom AS SINGLE)
        SUB SetShapesTexture (tex AS Texture, source AS Rectangle)
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
        SUB __LoadImage ALIAS LoadImage (fileName AS STRING, retVal AS Image)
        SUB LoadImageRaw (fileName AS STRING, BYVAL W AS LONG, BYVAL H AS LONG, BYVAL format AS LONG, BYVAL headerSize AS LONG, retVal AS Image)
        SUB LoadImageAnim (fileName AS STRING, frames AS LONG, retVal AS Image)
        SUB LoadImageFromMemory (fileType AS STRING, BYVAL fileData AS _UNSIGNED _OFFSET, BYVAL dataSize AS LONG, retVal AS Image)
        SUB LoadImageFromTexture (tex AS Texture, retVal AS Image)
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
        SUB ImageTextEx (fnt AS Font, text AS STRING, BYVAL fontSize AS SINGLE, BYVAL spacing AS SINGLE, BYVAL tint AS _UNSIGNED LONG, retVal AS Image)
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
        SUB UnloadImageColors (BYVAL colors AS _UNSIGNED _OFFSET)
        SUB UnloadImagePalette (BYVAL colors AS _UNSIGNED _OFFSET)
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
        SUB ImageDrawTextEx (dst AS Image, fnt AS Font, text AS STRING, position AS Vector2, BYVAL fontSize AS SINGLE, BYVAL spacing AS SINGLE, BYVAL tint AS _UNSIGNED LONG)
        SUB __LoadTexture ALIAS LoadTexture (fileName AS STRING, retVal AS Texture)
        SUB LoadTextureFromImage (img AS Image, retVal AS Texture)
        SUB LoadTextureCubemap (img AS Image, BYVAL layout AS LONG, retVal AS Texture)
        SUB LoadRenderTexture (BYVAL W AS LONG, BYVAL H AS LONG, retVal AS RenderTexture)
        FUNCTION IsTextureReady%% (tex AS Texture)
        SUB UnloadTexture (tex AS Texture)
        FUNCTION IsRenderTextureReady%% (target AS RenderTexture)
        SUB UnloadRenderTexture (target AS RenderTexture)
        SUB UpdateTexture (tex AS Texture, BYVAL pixels AS _UNSIGNED _OFFSET)
        SUB UpdateTextureRec (tex AS Texture, rec AS Rectangle, BYVAL pixels AS _UNSIGNED _OFFSET)
        SUB GenTextureMipmaps (tex AS Texture)
        SUB SetTextureFilter (tex AS Texture, BYVAL filter AS LONG)
        SUB SetTextureWrap (tex AS Texture, BYVAL wrap AS LONG)
        SUB DrawTexture (tex AS Texture, BYVAL posX AS LONG, BYVAL posY AS LONG, BYVAL tint AS _UNSIGNED LONG)
        SUB DrawTextureV (tex AS Texture, position AS Vector2, BYVAL tint AS _UNSIGNED LONG)
        SUB DrawTextureEx (tex AS Texture, position AS Vector2, BYVAL rotation AS SINGLE, BYVAL scale AS SINGLE, BYVAL tint AS _UNSIGNED LONG)
        SUB DrawTextureRec (tex AS Texture, source AS Rectangle, position AS Vector2, BYVAL tint AS _UNSIGNED LONG)
        SUB DrawTexturePro (tex AS Texture, source AS Rectangle, dest AS Rectangle, origin AS Vector2, BYVAL rotation AS SINGLE, BYVAL tint AS _UNSIGNED LONG)
        SUB DrawTextureNPatch (tex AS Texture, nPatchInfo AS NPatchInfo, dest AS Rectangle, origin AS Vector2, BYVAL rotation AS SINGLE, BYVAL tint AS _UNSIGNED LONG)
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
        SUB __LoadFont ALIAS LoadFont (fileName AS STRING, retVal AS Font)
        SUB __LoadFontEx ALIAS LoadFontEx (fileName AS STRING, BYVAL fontSize AS LONG, BYVAL fontChars AS _UNSIGNED _OFFSET, BYVAL glyphCount AS LONG, retVal AS Font)
        SUB LoadFontFromImage (img AS Image, BYVAL colorKey AS _UNSIGNED LONG, BYVAL firstChar AS LONG, retVal AS Font)
        SUB LoadFontFromMemory (fileType AS STRING, BYVAL fileData AS _UNSIGNED _OFFSET, BYVAL dataSize AS LONG, BYVAL fontSize AS LONG, BYVAL fontChars AS _UNSIGNED _OFFSET, BYVAL glyphCount AS LONG, retVal AS Font)
        FUNCTION IsFontReady%% (fnt AS Font)
        FUNCTION LoadFontData~%& (BYVAL fileData AS _UNSIGNED _OFFSET, BYVAL dataSize AS LONG, BYVAL fontSize AS LONG, BYVAL fontChars AS _UNSIGNED _OFFSET, BYVAL glyphCount AS LONG, BYVAL typ AS LONG)
        SUB GenImageFontAtlas (BYVAL chars AS _UNSIGNED _OFFSET, recs AS _UNSIGNED _OFFSET, BYVAL glyphCount AS LONG, BYVAL fontSize AS LONG, BYVAL padding AS LONG, BYVAL packMethod AS LONG, retVal AS Image)
        SUB UnloadFontData (BYVAL chars AS _UNSIGNED _OFFSET, BYVAL glyphCount AS LONG)
        SUB UnloadFont (fnt AS Font)
        FUNCTION ExportFontAsCode%% (fnt AS Font, fileName AS STRING)
        SUB DrawFPS (BYVAL posX AS LONG, BYVAL posY AS LONG)
        SUB __DrawText ALIAS DrawText (text AS STRING, BYVAL posX AS LONG, BYVAL posY AS LONG, BYVAL fontSize AS LONG, BYVAL clr AS _UNSIGNED LONG)
        SUB __DrawTextEx ALIAS DrawTextEx (fnt AS Font, text AS STRING, position AS Vector2, BYVAL fontSize AS SINGLE, BYVAL spacing AS SINGLE, BYVAL tint AS _UNSIGNED LONG)
        SUB __DrawTextPro ALIAS DrawTextPro (fnt AS Font, text AS STRING, position AS Vector2, origin AS Vector2, BYVAL rotation AS SINGLE, BYVAL fontSize AS SINGLE, BYVAL spacing AS SINGLE, BYVAL tint AS _UNSIGNED LONG)
        SUB DrawTextCodepoint (fnt AS Font, BYVAL codepoint AS LONG, position AS Vector2, BYVAL fontSize AS SINGLE, BYVAL tint AS _UNSIGNED LONG)
        SUB DrawTextCodepoints (fnt AS Font, codepoints AS LONG, BYVAL count AS LONG, position AS Vector2, BYVAL fontSize AS SINGLE, BYVAL spacing AS SINGLE, BYVAL tint AS _UNSIGNED LONG)
        FUNCTION __MeasureText& ALIAS MeasureText (text AS STRING, BYVAL fontSize AS LONG)
        SUB __MeasureTextEx ALIAS MeasureTextEx (fnt AS Font, text AS STRING, BYVAL fontSize AS SINGLE, BYVAL spacing AS SINGLE, retVal AS Vector2)
        FUNCTION GetGlyphIndex& (fnt AS Font, BYVAL codepoint AS LONG)
        SUB GetGlyphInfo (fnt AS Font, BYVAL codepoint AS LONG, retVal AS GlyphInfo)
        SUB GetGlyphAtlasRec (fnt AS Font, BYVAL codepoint AS LONG, retVal AS Rectangle)
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
        SUB __LoadModel ALIAS LoadModel (fileName AS STRING, retVal AS Model)
        SUB LoadModelFromMesh (msh AS Mesh, retVal AS Model)
        FUNCTION IsModelReady%% (model AS Model)
        SUB UnloadModel (model AS Model)
        SUB GetModelBoundingBox (model AS Model, retVal AS BoundingBox)
        SUB DrawModel (model AS Model, position AS Vector3, BYVAL scale AS SINGLE, BYVAL tint AS _UNSIGNED LONG)
        SUB DrawModelEx (model AS Model, position AS Vector3, rotationAxis AS Vector3, BYVAL rotationAngle AS SINGLE, scale AS Vector3, BYVAL tint AS _UNSIGNED LONG)
        SUB DrawModelWires (model AS Model, position AS Vector3, BYVAL scale AS SINGLE, BYVAL tint AS _UNSIGNED LONG)
        SUB DrawModelWiresEx (model AS Model, position AS Vector3, rotationAxis AS Vector3, BYVAL rotationAngle AS SINGLE, scale AS Vector3, BYVAL tint AS _UNSIGNED LONG)
        SUB DrawBoundingBox (box AS BoundingBox, BYVAL clr AS _UNSIGNED LONG)
        SUB DrawBillboard (cam AS Camera3D, tex AS Texture, position AS Vector3, BYVAL size AS SINGLE, BYVAL tint AS _UNSIGNED LONG)
        SUB DrawBillboardRec (cam AS Camera3D, tex AS Texture, source AS Rectangle, position AS Vector3, size AS Vector2, BYVAL tint AS _UNSIGNED LONG)
        SUB DrawBillboardPro (cam AS Camera3D, tex AS Texture, source AS Rectangle, position AS Vector3, up AS Vector3, size AS Vector2, origin AS Vector2, BYVAL rotation AS SINGLE, BYVAL tint AS _UNSIGNED LONG)
        SUB UploadMesh (msh AS Mesh, BYVAL dyna AS _BYTE)
        SUB UpdateMeshBuffer (msh AS Mesh, BYVAL index AS LONG, BYVAL dat AS _UNSIGNED _OFFSET, BYVAL dataSize AS LONG, BYVAL offset AS LONG)
        SUB UnloadMesh (msh AS Mesh)
        SUB DrawMesh (msh AS Mesh, material AS Material, transform AS Matrix)
        SUB DrawMeshInstanced (msh AS Mesh, material AS Material, transforms AS Matrix, BYVAL instances AS LONG)
        FUNCTION ExportMesh%% (msh AS Mesh, fileName AS STRING)
        SUB GetMeshBoundingBox (msh AS Mesh, retVal AS BoundingBox)
        SUB GenMeshTangents (msh AS Mesh)
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
        SUB SetMaterialTexture (material AS Material, BYVAL mapType AS LONG, tex AS Texture)
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
        SUB GetRayCollisionMesh (ray AS Ray, msh AS Mesh, transform AS Matrix, retVal AS RayCollision)
        SUB GetRayCollisionTriangle (ray AS Ray, p1 AS Vector3, p2 AS Vector3, p3 AS Vector3, retVal AS RayCollision)
        SUB GetRayCollisionQuad (ray AS Ray, p1 AS Vector3, p2 AS Vector3, p3 AS Vector3, p4 AS Vector3, retVal AS RayCollision)
        SUB InitAudioDevice
        SUB CloseAudioDevice
        FUNCTION IsAudioDeviceReady%%
        SUB SetMasterVolume (BYVAL volume AS SINGLE)
        SUB LoadWave (fileName AS STRING, retVal AS Wave)
        SUB LoadWaveFromMemory (fileType AS STRING, BYVAL fileData AS _UNSIGNED _OFFSET, BYVAL dataSize AS LONG, retVal AS Wave)
        FUNCTION IsWaveReady%% (wav AS Wave)
        SUB LoadSound (fileName AS STRING, retVal AS RSound)
        SUB LoadSoundFromWave (wav AS Wave, retVal AS RSound)
        FUNCTION IsSoundReady%% (snd AS RSound)
        SUB UpdateSound (snd AS RSound, BYVAL dat AS _UNSIGNED _OFFSET, BYVAL sampleCount AS LONG)
        SUB UnloadWave (wav AS Wave)
        SUB UnloadSound (snd AS RSound)
        FUNCTION ExportWave%% (wav AS Wave, fileName AS STRING)
        FUNCTION ExportWaveAsCode%% (wav AS Wave, fileName AS STRING)
        SUB PlaySound (snd AS RSound)
        SUB StopSound (snd AS RSound)
        SUB PauseSound (snd AS RSound)
        SUB ResumeSound (snd AS RSound)
        FUNCTION IsSoundPlaying%% (snd AS RSound)
        SUB SetSoundVolume (snd AS RSound, BYVAL volume AS SINGLE)
        SUB SetSoundPitch (snd AS RSound, BYVAL pitch AS SINGLE)
        SUB SetSoundPan (snd AS RSound, BYVAL pan AS SINGLE)
        SUB WaveCopy (wav AS Wave, retVal AS Wave)
        SUB WaveCrop (wav AS Wave, BYVAL initSample AS LONG, BYVAL finalSample AS LONG)
        SUB WaveFormat (wav AS Wave, BYVAL sampleRate AS LONG, BYVAL sampleSize AS LONG, BYVAL channels AS LONG)
        FUNCTION LoadWaveSamples~%& (wav AS Wave)
        SUB UnloadWaveSamples (samples AS SINGLE)
        SUB __LoadMusicStream ALIAS LoadMusicStream (fileName AS STRING, retVal AS Music)
        SUB LoadMusicStreamFromMemory (fileType AS STRING, BYVAL dat AS _UNSIGNED _OFFSET, BYVAL dataSize AS LONG, retVal AS Music)
        FUNCTION IsMusicReady%% (mus AS Music)
        SUB UnloadMusicStream (mus AS Music)
        SUB PlayMusicStream (mus AS Music)
        FUNCTION IsMusicStreamPlaying%% (mus AS Music)
        SUB UpdateMusicStream (mus AS Music)
        SUB StopMusicStream (mus AS Music)
        SUB PauseMusicStream (mus AS Music)
        SUB ResumeMusicStream (mus AS Music)
        SUB SeekMusicStream (mus AS Music, BYVAL position AS SINGLE)
        SUB SetMusicVolume (mus AS Music, BYVAL volume AS SINGLE)
        SUB SetMusicPitch (mus AS Music, BYVAL pitch AS SINGLE)
        SUB SetMusicPan (mus AS Music, BYVAL pan AS SINGLE)
        FUNCTION GetMusicTimeLength! (mus AS Music)
        FUNCTION GetMusicTimePlayed! (mus AS Music)
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

    IF NOT __init_raylib THEN
        _MESSAGEBOX "raylib-64 Error", "raylib-64 initialization failed! Application execution will be terminated. Please ensure raylib shared library or dynamic link library is in the path.", "error"
        SYSTEM LOG_FATAL
    END IF

$END IF
