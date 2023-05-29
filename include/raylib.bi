'-----------------------------------------------------------------------------------------------------------------------
' raylib bindings for QB64-PE
' Copyright (c) 2023 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$If RAYLIB_BI = UNDEFINED Then
    $Let RAYLIB_BI = TRUE

    ' Check QB64-PE compiler version and complain if it does not meet minimum version requirement
    ' We do not support 32-bit versions. There are multiple roadblocks for supporting 32-bit platforms
    '   1. The official raylib binary distributons do not contain 32-bit shared libraries for all platforms
    '   2. The TYPES below are aligned for x86-64 arch. Padded with extra bytes wherever needed
    '   3. 32-bit machines and OSes are not mainstream anymore
    '   4. I clearly lack the motivation for adding 32-bit support. If anyone wants to do it, then please open a PR!
    $If VERSION < 3.7 OR 32BIT Then
            $ERROR This requires the latest 64-bit version of QB64-PE from https://github.com/QB64-Phoenix-Edition/QB64pe/releases
    $End If

    ' All identifiers must default to long (32-bits). This results in fastest code execution on x86 & x64
    DefLng A-Z

    ' Force all arrays to be defined (technically not required since we use _EXPLICIT below)
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

    Const PI! = 3.14159265358979323846!
    Const DEG2RAD! = PI / 180.0!
    Const RAD2DEG! = 180.0! / PI

    ' Some Basic Colors
    ' NOTE: Custom raylib color palette for amazing visuals on WHITE background
    Const LIGHTGRAY = &HFFC8C8C8 ' Light Gray
    Const GRAY = &HFF828282 ' Gray
    Const DARKGRAY = &HFF505050 ' Dark Gray
    Const YELLOW = &HFF00F9FD ' Yellow
    Const GOLD = &HFF00CBFF ' Gold
    Const ORANGE = &HFF00A1FF ' Orange
    Const PINK = &HFFC26DFF ' Pink
    Const RED = &HFF3729E6 ' Red
    Const MAROON = &HFF3721BE ' Maroon
    Const GREEN = &HFF30E400 ' Green
    Const LIME = &HFF2F9E00 ' Lime
    Const DARKGREEN = &HFF2C7500 ' Dark Green
    Const SKYBLUE = &HFFFFBF66 ' Sky Blue
    Const BLUE = &HFFF17900 ' Blue
    Const DARKBLUE = &HFFAC5200 ' Dark Blue
    Const PURPLE = &HFFFF7AC8 ' Purple
    Const VIOLET = &HFFBE3C87 ' Violet
    Const DARKPURPLE = &HFF7E1F70 ' Dark Purple
    Const BEIGE = &HFF83B0D3 ' Beige
    Const BROWN = &HFF4F6A7F ' Brown
    Const DARKBROWN = &HFF2F3F4C ' Dark Brown
    Const WHITE = &HFFFFFFFF ' White
    Const BLACK = &HFF000000 ' Black
    Const BLANK = &H00000000 ' Blank (Transparent)
    Const MAGENTA = &HFFFF00FF ' Magenta
    Const RAYWHITE = &HFFF5F5F5 ' My own White (raylib logo)

    ' System/Window config flags
    ' NOTE: Every bit registers one state (use it with bit masks)
    ' By default all flags are set to 0
    Const FLAG_VSYNC_HINT = &H00000040 ' Set to try enabling V-Sync on GPU
    Const FLAG_FULLSCREEN_MODE = &H00000002 ' Set to run program in fullscreen
    Const FLAG_WINDOW_RESIZABLE = &H00000004 ' Set to allow resizable window
    Const FLAG_WINDOW_UNDECORATED = &H00000008 ' Set to disable window decoration (frame and buttons)
    Const FLAG_WINDOW_HIDDEN = &H00000080 ' Set to hide window
    Const FLAG_WINDOW_MINIMIZED = &H00000200 ' Set to minimize window (iconify)
    Const FLAG_WINDOW_MAXIMIZED = &H00000400 ' Set to maximize window (expanded to monitor)
    Const FLAG_WINDOW_UNFOCUSED = &H00000800 ' Set to window non focused
    Const FLAG_WINDOW_TOPMOST = &H00001000 ' Set to window always on top
    Const FLAG_WINDOW_ALWAYS_RUN = &H00000100 ' Set to allow windows running while minimized
    Const FLAG_WINDOW_TRANSPARENT = &H00000010 ' Set to allow transparent framebuffer
    Const FLAG_WINDOW_HIGHDPI = &H00002000 ' Set to support HighDPI
    Const FLAG_WINDOW_MOUSE_PASSTHROUGH = &H00004000 ' Set to support mouse passthrough, only supported when FLAG_WINDOW_UNDECORATED
    Const FLAG_MSAA_4X_HINT = &H00000020 ' Set to try enabling MSAA 4X
    Const FLAG_INTERLACED_HINT = &H00010000 ' Set to try enabling interlaced video format (for V3D)

    ' Trace log level
    ' NOTE: Organized by priority level
    Const LOG_ALL = 0 ' Display all logs
    Const LOG_TRACE = 1 ' Trace logging, intended for internal use only
    Const LOG_DEBUG = 2 ' Debug logging, used for internal debugging, it should be disabled on release builds
    Const LOG_INFO = 3 ' Info logging, used for program execution info
    Const LOG_WARNING = 4 ' Warning logging, used on recoverable failures
    Const LOG_ERROR = 5 ' Error logging, used on unrecoverable failures
    Const LOG_FATAL = 6 ' Fatal logging, used to abort program: exit(EXIT_FAILURE)
    Const LOG_NONE = 7 ' Disable logging

    ' Keyboard keys (US keyboard layout)
    ' NOTE: Use GetKeyPressed() to allow redefining
    ' required keys for alternative layouts
    Const KEY_NULL = 0 ' Key: NULL
    ' Alphanumeric keys
    Const KEY_APOSTROPHE = 39 ' Key: '
    Const KEY_COMMA = 44 ' Key:
    Const KEY_MINUS = 45 ' Key: -
    Const KEY_PERIOD = 46 ' Key: .
    Const KEY_SLASH = 47 ' Key:
    Const KEY_ZERO = 48 ' Key: 0
    Const KEY_ONE = 49 ' Key: 1
    Const KEY_TWO = 50 ' Key: 2
    Const KEY_THREE = 51 ' Key: 3
    Const KEY_FOUR = 52 ' Key: 4
    Const KEY_FIVE = 53 ' Key: 5
    Const KEY_SIX = 54 ' Key: 6
    Const KEY_SEVEN = 55 ' Key: 7
    Const KEY_EIGHT = 56 ' Key: 8
    Const KEY_NINE = 57 ' Key: 9
    Const KEY_SEMICOLON = 59 ' Key: ;
    Const KEY_EQUAL = 61 ' Key:
    Const KEY_A = 65 ' Key: A | a
    Const KEY_B = 66 ' Key: B | b
    Const KEY_C = 67 ' Key: C | c
    Const KEY_D = 68 ' Key: D | d
    Const KEY_E = 69 ' Key: E | e
    Const KEY_F = 70 ' Key: F | f
    Const KEY_G = 71 ' Key: G | g
    Const KEY_H = 72 ' Key: H | h
    Const KEY_I = 73 ' Key: I | i
    Const KEY_J = 74 ' Key: J | j
    Const KEY_K = 75 ' Key: K | k
    Const KEY_L = 76 ' Key: L | l
    Const KEY_M = 77 ' Key: M | m
    Const KEY_N = 78 ' Key: N | n
    Const KEY_O = 79 ' Key: O | o
    Const KEY_P = 80 ' Key: P | p
    Const KEY_Q = 81 ' Key: Q | q
    Const KEY_R = 82 ' Key: R | r
    Const KEY_S = 83 ' Key: S | s
    Const KEY_T = 84 ' Key: T | t
    Const KEY_U = 85 ' Key: U | u
    Const KEY_V = 86 ' Key: V | v
    Const KEY_W = 87 ' Key: W | w
    Const KEY_X = 88 ' Key: X | x
    Const KEY_Y = 89 ' Key: Y | y
    Const KEY_Z = 90 ' Key: Z | z
    Const KEY_LEFT_BRACKET = 91 ' Key: [
    Const KEY_BACKSLASH = 92 ' Key: '\'
    Const KEY_RIGHT_BRACKET = 93 ' Key: ]
    Const KEY_GRAVE = 96 ' Key: `
    ' Function keys
    Const KEY_SPACE = 32 ' Key: Space
    Const KEY_ESCAPE = 256 ' Key: Esc
    Const KEY_ENTER = 257 ' Key: Enter
    Const KEY_TAB = 258 ' Key: Tab
    Const KEY_BACKSPACE = 259 ' Key: Backspace
    Const KEY_INSERT = 260 ' Key: Ins
    Const KEY_DELETE = 261 ' Key: Del
    Const KEY_RIGHT = 262 ' Key: Cursor right
    Const KEY_LEFT = 263 ' Key: Cursor left
    Const KEY_DOWN = 264 ' Key: Cursor down
    Const KEY_UP = 265 ' Key: Cursor up
    Const KEY_PAGE_UP = 266 ' Key: Page up
    Const KEY_PAGE_DOWN = 267 ' Key: Page down
    Const KEY_HOME = 268 ' Key: Home
    Const KEY_END = 269 ' Key: End
    Const KEY_CAPS_LOCK = 280 ' Key: Caps lock
    Const KEY_SCROLL_LOCK = 281 ' Key: Scroll down
    Const KEY_NUM_LOCK = 282 ' Key: Num lock
    Const KEY_PRINT_SCREEN = 283 ' Key: Print screen
    Const KEY_PAUSE = 284 ' Key: Pause
    Const KEY_F1 = 290 ' Key: F1
    Const KEY_F2 = 291 ' Key: F2
    Const KEY_F3 = 292 ' Key: F3
    Const KEY_F4 = 293 ' Key: F4
    Const KEY_F5 = 294 ' Key: F5
    Const KEY_F6 = 295 ' Key: F6
    Const KEY_F7 = 296 ' Key: F7
    Const KEY_F8 = 297 ' Key: F8
    Const KEY_F9 = 298 ' Key: F9
    Const KEY_F10 = 299 ' Key: F10
    Const KEY_F11 = 300 ' Key: F11
    Const KEY_F12 = 301 ' Key: F12
    Const KEY_LEFT_SHIFT = 340 ' Key: Shift left
    Const KEY_LEFT_CONTROL = 341 ' Key: Control left
    Const KEY_LEFT_ALT = 342 ' Key: Alt left
    Const KEY_LEFT_SUPER = 343 ' Key: Super left
    Const KEY_RIGHT_SHIFT = 344 ' Key: Shift right
    Const KEY_RIGHT_CONTROL = 345 ' Key: Control right
    Const KEY_RIGHT_ALT = 346 ' Key: Alt right
    Const KEY_RIGHT_SUPER = 347 ' Key: Super right
    Const KEY_KB_MENU = 348 ' Key: KB menu
    ' Keypad keys
    Const KEY_KP_0 = 320 ' Key: Keypad 0
    Const KEY_KP_1 = 321 ' Key: Keypad 1
    Const KEY_KP_2 = 322 ' Key: Keypad 2
    Const KEY_KP_3 = 323 ' Key: Keypad 3
    Const KEY_KP_4 = 324 ' Key: Keypad 4
    Const KEY_KP_5 = 325 ' Key: Keypad 5
    Const KEY_KP_6 = 326 ' Key: Keypad 6
    Const KEY_KP_7 = 327 ' Key: Keypad 7
    Const KEY_KP_8 = 328 ' Key: Keypad 8
    Const KEY_KP_9 = 329 ' Key: Keypad 9
    Const KEY_KP_DECIMAL = 330 ' Key: Keypad .
    Const KEY_KP_DIVIDE = 331 ' Key: Keypad
    Const KEY_KP_MULTIPLY = 332 ' Key: Keypad *
    Const KEY_KP_SUBTRACT = 333 ' Key: Keypad -
    Const KEY_KP_ADD = 334 ' Key: Keypad +
    Const KEY_KP_ENTER = 335 ' Key: Keypad Enter
    Const KEY_KP_EQUAL = 336 ' Key: Keypad
    ' Android key buttons
    Const KEY_BACK = 4 ' Key: Android back button
    Const KEY_MENU = 82 ' Key: Android menu button
    Const KEY_VOLUME_UP = 24 ' Key: Android volume up button
    Const KEY_VOLUME_DOWN = 25 ' Key: Android volume down button

    ' Mouse buttons
    Const MOUSE_BUTTON_LEFT = 0 ' Mouse button left
    Const MOUSE_BUTTON_RIGHT = 1 ' Mouse button right
    Const MOUSE_BUTTON_MIDDLE = 2 ' Mouse button middle (pressed wheel)
    Const MOUSE_BUTTON_SIDE = 3 ' Mouse button side (advanced mouse device)
    Const MOUSE_BUTTON_EXTRA = 4 ' Mouse button extra (advanced mouse device)
    Const MOUSE_BUTTON_FORWARD = 5 ' Mouse button forward (advanced mouse device)
    Const MOUSE_BUTTON_BACK = 6 ' Mouse button back (advanced mouse device)
    ' Add backwards compatibility support for deprecated names
    Const MOUSE_LEFT_BUTTON = MOUSE_BUTTON_LEFT
    Const MOUSE_RIGHT_BUTTON = MOUSE_BUTTON_RIGHT
    Const MOUSE_MIDDLE_BUTTON = MOUSE_BUTTON_MIDDLE

    ' Mouse cursor
    Const MOUSE_CURSOR_DEFAULT = 0 ' Default pointer shape
    Const MOUSE_CURSOR_ARROW = 1 ' Arrow shape
    Const MOUSE_CURSOR_IBEAM = 2 ' Text writing cursor shape
    Const MOUSE_CURSOR_CROSSHAIR = 3 ' Cross shape
    Const MOUSE_CURSOR_POINTING_HAND = 4 ' Pointing hand cursor
    Const MOUSE_CURSOR_RESIZE_EW = 5 ' Horizontal resize/move arrow shape
    Const MOUSE_CURSOR_RESIZE_NS = 6 ' Vertical resize/move arrow shape
    Const MOUSE_CURSOR_RESIZE_NWSE = 7 ' Top-left to bottom-right diagonal resize/move arrow shape
    Const MOUSE_CURSOR_RESIZE_NESW = 8 ' The top-right to bottom-left diagonal resize/move arrow shape
    Const MOUSE_CURSOR_RESIZE_ALL = 9 ' The omnidirectional resize/move cursor shape
    Const MOUSE_CURSOR_NOT_ALLOWED = 10 ' The operation-not-allowed shape

    ' Gamepad buttons
    Const GAMEPAD_BUTTON_UNKNOWN = 0 ' Unknown button, just for error checking
    Const GAMEPAD_BUTTON_LEFT_FACE_UP = 1 ' Gamepad left DPAD up button
    Const GAMEPAD_BUTTON_LEFT_FACE_RIGHT = 2 ' Gamepad left DPAD right button
    Const GAMEPAD_BUTTON_LEFT_FACE_DOWN = 3 ' Gamepad left DPAD down button
    Const GAMEPAD_BUTTON_LEFT_FACE_LEFT = 4 ' Gamepad left DPAD left button
    Const GAMEPAD_BUTTON_RIGHT_FACE_UP = 5 ' Gamepad right button up (i.e. PS3: Triangle, Xbox: Y)
    Const GAMEPAD_BUTTON_RIGHT_FACE_RIGHT = 6 ' Gamepad right button right (i.e. PS3: Square, Xbox: X)
    Const GAMEPAD_BUTTON_RIGHT_FACE_DOWN = 7 ' Gamepad right button down (i.e. PS3: Cross, Xbox: A)
    Const GAMEPAD_BUTTON_RIGHT_FACE_LEFT = 8 ' Gamepad right button left (i.e. PS3: Circle, Xbox: B)
    Const GAMEPAD_BUTTON_LEFT_TRIGGER_1 = 9 ' Gamepad top/back trigger left (first), it could be a trailing button
    Const GAMEPAD_BUTTON_LEFT_TRIGGER_2 = 10 ' Gamepad top/back trigger left (second), it could be a trailing button
    Const GAMEPAD_BUTTON_RIGHT_TRIGGER_1 = 11 ' Gamepad top/back trigger right (one), it could be a trailing button
    Const GAMEPAD_BUTTON_RIGHT_TRIGGER_2 = 12 ' Gamepad top/back trigger right (second), it could be a trailing button
    Const GAMEPAD_BUTTON_MIDDLE_LEFT = 13 ' Gamepad center buttons, left one (i.e. PS3: Select)
    Const GAMEPAD_BUTTON_MIDDLE = 14 ' Gamepad center buttons, middle one (i.e. PS3: PS, Xbox: XBOX)
    Const GAMEPAD_BUTTON_MIDDLE_RIGHT = 15 ' Gamepad center buttons, right one (i.e. PS3: Start)
    Const GAMEPAD_BUTTON_LEFT_THUMB = 16 ' Gamepad joystick pressed button left
    Const GAMEPAD_BUTTON_RIGHT_THUMB = 17 ' Gamepad joystick pressed button right

    ' Gamepad axis
    Const GAMEPAD_AXIS_LEFT_X = 0 ' Gamepad left stick X axis
    Const GAMEPAD_AXIS_LEFT_Y = 1 ' Gamepad left stick Y axis
    Const GAMEPAD_AXIS_RIGHT_X = 2 ' Gamepad right stick X axis
    Const GAMEPAD_AXIS_RIGHT_Y = 3 ' Gamepad right stick Y axis
    Const GAMEPAD_AXIS_LEFT_TRIGGER = 4 ' Gamepad back trigger left, pressure level: [1..-1]
    Const GAMEPAD_AXIS_RIGHT_TRIGGER = 5 ' Gamepad back trigger right, pressure level: [1..-1]

    ' Material map index
    Const MATERIAL_MAP_ALBEDO = 0 ' Albedo material (same as: MATERIAL_MAP_DIFFUSE)
    Const MATERIAL_MAP_METALNESS = 1 ' Metalness material (same as: MATERIAL_MAP_SPECULAR)
    Const MATERIAL_MAP_NORMAL = 2 ' Normal material
    Const MATERIAL_MAP_ROUGHNESS = 3 ' Roughness material
    Const MATERIAL_MAP_OCCLUSION = 4 ' Ambient occlusion material
    Const MATERIAL_MAP_EMISSION = 5 ' Emission material
    Const MATERIAL_MAP_HEIGHT = 6 ' Heightmap material
    Const MATERIAL_MAP_CUBEMAP = 7 ' Cubemap material (NOTE: Uses GL_TEXTURE_CUBE_MAP)
    Const MATERIAL_MAP_IRRADIANCE = 8 ' Irradiance material (NOTE: Uses GL_TEXTURE_CUBE_MAP)
    Const MATERIAL_MAP_PREFILTER = 9 ' Prefilter material (NOTE: Uses GL_TEXTURE_CUBE_MAP)
    Const MATERIAL_MAP_BRDF = 10 ' Brdf material
    Const MATERIAL_MAP_DIFFUSE = MATERIAL_MAP_ALBEDO
    Const MATERIAL_MAP_SPECULAR = MATERIAL_MAP_METALNESS

    ' Shader location index
    Const SHADER_LOC_VERTEX_POSITION = 0 ' Shader location: vertex attribute: position
    Const SHADER_LOC_VERTEX_TEXCOORD01 = 1 ' Shader location: vertex attribute: texcoord01
    Const SHADER_LOC_VERTEX_TEXCOORD02 = 2 ' Shader location: vertex attribute: texcoord02
    Const SHADER_LOC_VERTEX_NORMAL = 3 ' Shader location: vertex attribute: normal
    Const SHADER_LOC_VERTEX_TANGENT = 4 ' Shader location: vertex attribute: tangent
    Const SHADER_LOC_VERTEX_COLOR = 5 ' Shader location: vertex attribute: color
    Const SHADER_LOC_MATRIX_MVP = 6 ' Shader location: matrix uniform: model-view-projection
    Const SHADER_LOC_MATRIX_VIEW = 7 ' Shader location: matrix uniform: view (camera transform)
    Const SHADER_LOC_MATRIX_PROJECTION = 8 ' Shader location: matrix uniform: projection
    Const SHADER_LOC_MATRIX_MODEL = 9 ' Shader location: matrix uniform: model (transform)
    Const SHADER_LOC_MATRIX_NORMAL = 10 ' Shader location: matrix uniform: normal
    Const SHADER_LOC_VECTOR_VIEW = 11 ' Shader location: vector uniform: view
    Const SHADER_LOC_COLOR_DIFFUSE = 12 ' Shader location: vector uniform: diffuse color
    Const SHADER_LOC_COLOR_SPECULAR = 13 ' Shader location: vector uniform: specular color
    Const SHADER_LOC_COLOR_AMBIENT = 14 ' Shader location: vector uniform: ambient color
    Const SHADER_LOC_MAP_ALBEDO = 15 ' Shader location: sampler2d texture: albedo (same as: SHADER_LOC_MAP_DIFFUSE)
    Const SHADER_LOC_MAP_METALNESS = 16 ' Shader location: sampler2d texture: metalness (same as: SHADER_LOC_MAP_SPECULAR)
    Const SHADER_LOC_MAP_NORMAL = 17 ' Shader location: sampler2d texture: normal
    Const SHADER_LOC_MAP_ROUGHNESS = 18 ' Shader location: sampler2d texture: roughness
    Const SHADER_LOC_MAP_OCCLUSION = 19 ' Shader location: sampler2d texture: occlusion
    Const SHADER_LOC_MAP_EMISSION = 20 ' Shader location: sampler2d texture: emission
    Const SHADER_LOC_MAP_HEIGHT = 21 ' Shader location: sampler2d texture: height
    Const SHADER_LOC_MAP_CUBEMAP = 22 ' Shader location: samplerCube texture: cubemap
    Const SHADER_LOC_MAP_IRRADIANCE = 23 ' Shader location: samplerCube texture: irradiance
    Const SHADER_LOC_MAP_PREFILTER = 24 ' Shader location: samplerCube texture: prefilter
    Const SHADER_LOC_MAP_BRDF = 25 ' Shader location: sampler2d texture: brdf
    Const SHADER_LOC_MAP_DIFFUSE = SHADER_LOC_MAP_ALBEDO
    Const SHADER_LOC_MAP_SPECULAR = SHADER_LOC_MAP_METALNESS

    ' Shader uniform data type
    Const SHADER_UNIFORM_FLOAT = 0 ' Shader uniform type: float
    Const SHADER_UNIFORM_VEC2 = 1 ' Shader uniform type: vec2 (2 float)
    Const SHADER_UNIFORM_VEC3 = 2 ' Shader uniform type: vec3 (3 float)
    Const SHADER_UNIFORM_VEC4 = 3 ' Shader uniform type: vec4 (4 float)
    Const SHADER_UNIFORM_INT = 4 ' Shader uniform type: int
    Const SHADER_UNIFORM_IVEC2 = 5 ' Shader uniform type: ivec2 (2 int)
    Const SHADER_UNIFORM_IVEC3 = 6 ' Shader uniform type: ivec3 (3 int)
    Const SHADER_UNIFORM_IVEC4 = 7 ' Shader uniform type: ivec4 (4 int)
    Const SHADER_UNIFORM_SAMPLER2D = 8 ' Shader uniform type: sampler2d

    ' Shader attribute data types
    Const SHADER_ATTRIB_FLOAT = 0 ' Shader attribute type: float
    Const SHADER_ATTRIB_VEC2 = 1 ' Shader attribute type: vec2 (2 float)
    Const SHADER_ATTRIB_VEC3 = 2 ' Shader attribute type: vec3 (3 float)
    Const SHADER_ATTRIB_VEC4 = 3 ' Shader attribute type: vec4 (4 float)

    ' Pixel formats
    ' NOTE: Support depends on OpenGL version and platform
    Const PIXELFORMAT_UNCOMPRESSED_GRAYSCALE = 1 ' 8 bit per pixel (no alpha)
    Const PIXELFORMAT_UNCOMPRESSED_GRAY_ALPHA = 2 ' 8*2 bpp (2 channels)
    Const PIXELFORMAT_UNCOMPRESSED_R5G6B5 = 3 ' 16 bpp
    Const PIXELFORMAT_UNCOMPRESSED_R8G8B8 = 4 ' 24 bpp
    Const PIXELFORMAT_UNCOMPRESSED_R5G5B5A1 = 5 ' 16 bpp (1 bit alpha)
    Const PIXELFORMAT_UNCOMPRESSED_R4G4B4A4 = 6 ' 16 bpp (4 bit alpha)
    Const PIXELFORMAT_UNCOMPRESSED_R8G8B8A8 = 7 ' 32 bpp
    Const PIXELFORMAT_UNCOMPRESSED_R32 = 8 ' 32 bpp (1 channel - float)
    Const PIXELFORMAT_UNCOMPRESSED_R32G32B32 = 9 ' 32*3 bpp (3 channels - float)
    Const PIXELFORMAT_UNCOMPRESSED_R32G32B32A32 = 10 ' 32*4 bpp (4 channels - float)
    Const PIXELFORMAT_COMPRESSED_DXT1_RGB = 11 ' 4 bpp (no alpha)
    Const PIXELFORMAT_COMPRESSED_DXT1_RGBA = 12 ' 4 bpp (1 bit alpha)
    Const PIXELFORMAT_COMPRESSED_DXT3_RGBA = 13 ' 8 bpp
    Const PIXELFORMAT_COMPRESSED_DXT5_RGBA = 14 ' 8 bpp
    Const PIXELFORMAT_COMPRESSED_ETC1_RGB = 15 ' 4 bpp
    Const PIXELFORMAT_COMPRESSED_ETC2_RGB = 16 ' 4 bpp
    Const PIXELFORMAT_COMPRESSED_ETC2_EAC_RGBA = 17 ' 8 bpp
    Const PIXELFORMAT_COMPRESSED_PVRT_RGB = 18 ' 4 bpp
    Const PIXELFORMAT_COMPRESSED_PVRT_RGBA = 19 ' 4 bpp
    Const PIXELFORMAT_COMPRESSED_ASTC_4x4_RGBA = 20 ' 8 bpp
    Const PIXELFORMAT_COMPRESSED_ASTC_8x8_RGBA = 21 ' 2 bpp

    ' Texture parameters: filter mode
    ' NOTE 1: Filtering considers mipmaps if available in the texture
    ' NOTE 2: Filter is accordingly set for minification and magnification
    Const TEXTURE_FILTER_POINT = 0 ' No filter, just pixel approximation
    Const TEXTURE_FILTER_BILINEAR = 1 ' Linear filtering
    Const TEXTURE_FILTER_TRILINEAR = 2 ' Trilinear filtering (linear with mipmaps)
    Const TEXTURE_FILTER_ANISOTROPIC_4X = 3 ' Anisotropic filtering 4x
    Const TEXTURE_FILTER_ANISOTROPIC_8X = 4 ' Anisotropic filtering 8x
    Const TEXTURE_FILTER_ANISOTROPIC_16X = 5 ' Anisotropic filtering 16x

    ' Texture parameters: wrap mode
    Const TEXTURE_WRAP_REPEAT = 0 ' Repeats texture in tiled mode
    Const TEXTURE_WRAP_CLAMP = 1 ' Clamps texture to edge pixel in tiled mode
    Const TEXTURE_WRAP_MIRROR_REPEAT = 2 ' Mirrors and repeats the texture in tiled mode
    Const TEXTURE_WRAP_MIRROR_CLAMP = 3 ' Mirrors and clamps to border the texture in tiled mode

    ' Cubemap layouts
    Const CUBEMAP_LAYOUT_AUTO_DETECT = 0 ' Automatically detect layout type
    Const CUBEMAP_LAYOUT_LINE_VERTICAL = 1 ' Layout is defined by a vertical line with faces
    Const CUBEMAP_LAYOUT_LINE_HORIZONTAL = 2 ' Layout is defined by a horizontal line with faces
    Const CUBEMAP_LAYOUT_CROSS_THREE_BY_FOUR = 3 ' Layout is defined by a 3x4 cross with cubemap faces
    Const CUBEMAP_LAYOUT_CROSS_FOUR_BY_THREE = 4 ' Layout is defined by a 4x3 cross with cubemap faces
    Const CUBEMAP_LAYOUT_PANORAMA = 5 ' Layout is defined by a panorama image (equirrectangular map)

    ' Font type, defines generation method
    Const FONT_DEFAULT = 0 ' Default font generation, anti-aliased
    Const FONT_BITMAP = 1 ' Bitmap font generation, no anti-aliasing
    Const FONT_SDF = 2 ' SDF font generation, requires external shader

    ' Color blending modes (pre-defined)
    Const BLEND_ALPHA = 0 ' Blend textures considering alpha (default)
    Const BLEND_ADDITIVE = 1 ' Blend textures adding colors
    Const BLEND_MULTIPLIED = 2 ' Blend textures multiplying colors
    Const BLEND_ADD_COLORS = 3 ' Blend textures adding colors (alternative)
    Const BLEND_SUBTRACT_COLORS = 4 ' Blend textures subtracting colors (alternative)
    Const BLEND_ALPHA_PREMULTIPLY = 5 ' Blend premultiplied textures considering alpha
    Const BLEND_CUSTOM = 6 ' Blend textures using custom src/dst factors (use rlSetBlendFactors())
    Const BLEND_CUSTOM_SEPARATE = 7 ' Blend textures using custom rgb/alpha separate src/dst factors (use rlSetBlendFactorsSeparate())

    ' Gesture
    ' NOTE: Provided as bit-wise flags to enable only desired gestures
    Const GESTURE_NONE = 0 ' No gesture
    Const GESTURE_TAP = 1 ' Tap gesture
    Const GESTURE_DOUBLETAP = 2 ' Double tap gesture
    Const GESTURE_HOLD = 4 ' Hold gesture
    Const GESTURE_DRAG = 8 ' Drag gesture
    Const GESTURE_SWIPE_RIGHT = 16 ' Swipe right gesture
    Const GESTURE_SWIPE_LEFT = 32 ' Swipe left gesture
    Const GESTURE_SWIPE_UP = 64 ' Swipe up gesture
    Const GESTURE_SWIPE_DOWN = 128 ' Swipe down gesture
    Const GESTURE_PINCH_IN = 256 ' Pinch in gesture
    Const GESTURE_PINCH_OUT = 512 ' Pinch out gesture

    ' Camera system modes
    Const CAMERA_CUSTOM = 0 ' Custom camera
    Const CAMERA_FREE = 1 ' Free camera
    Const CAMERA_ORBITAL = 2 ' Orbital camera
    Const CAMERA_FIRST_PERSON = 3 ' First person camera
    Const CAMERA_THIRD_PERSON = 4 ' Third person camera

    ' Camera projection
    Const CAMERA_PERSPECTIVE = 0 ' Perspective projection
    Const CAMERA_ORTHOGRAPHIC = 1 ' Orthographic projection

    ' N-patch layout
    Const NPATCH_NINE_PATCH = 0 ' Npatch layout: 3x3 tiles
    Const NPATCH_THREE_PATCH_VERTICAL = 1 ' Npatch layout: 1x3 tiles
    Const NPATCH_THREE_PATCH_HORIZONTAL = 2 ' Npatch layout: 3x1 tiles

    ' Vector2, 2 components
    Type Vector2
        As Single x ' Vector x component
        As Single y ' Vector y component
    End Type

    ' Vector3, 3 components
    Type Vector3
        As Single x ' Vector x component
        As Single y ' Vector y component
        As Single z ' Vector z component
    End Type

    ' Vector4, 4 components
    Type Vector4
        As Single x ' Vector x component
        As Single y ' Vector y component
        As Single z ' Vector z component
        As Single w ' Vector w component
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
        As _Unsigned _Byte r ' Color red value
        As _Unsigned _Byte g ' Color green value
        As _Unsigned _Byte b ' Color blue value
        As _Unsigned _Byte a ' Color alpha value
    End Type

    ' Rectangle, 4 components
    Type Rectangle
        As Single x ' Rectangle top-left corner position x
        As Single y ' Rectangle top-left corner position y
        As Single W ' Rectangle width
        As Single H ' Rectangle height
    End Type

    ' Image, pixel data stored in CPU memory (RAM)
    Type Image
        As _Offset dat ' Image raw data
        As Long W ' Image base width
        As Long H ' Image base height
        As Long mipmaps ' Mipmap levels, 1 by default
        As Long format ' Data format (PixelFormat type)
    End Type

    ' Texture, tex data stored in GPU memory (VRAM)
    Type Texture
        As Long id ' OpenGL texture id
        As Long W ' Texture base width
        As Long H ' Texture base height
        As Long mipmaps ' Mipmap levels, 1 by default
        As Long format ' Data format (PixelFormat type)
    End Type

    ' RenderTexture, fbo for texture rendering
    Type RenderTexture
        As Long id ' OpenGL framebuffer object id
        As Texture tex ' Color buffer attachment texture
        As Texture depth ' Depth buffer attachment texture
    End Type

    ' NPatchInfo, n-patch layout info
    Type NPatchInfo
        As Rectangle source ' Texture source rectangle
        As Long left ' Left border offset
        As Long top ' Top border offset
        As Long right ' Right border offset
        As Long bottom ' Bottom border offset
        As Long layout ' Layout of the n-patch: 3x3, 1x3 or 3x1
    End Type

    ' GlyphInfo, font characters glyphs info
    Type GlyphInfo
        As Long value ' Character value (Unicode)
        As Long offsetX ' Character offset X when drawing
        As Long offsetY ' Character offset Y when drawing
        As Long advanceX ' Character advance position X
        As Image img ' Character image data
    End Type

    ' Font, font texture and GlyphInfo array data
    Type Font
        As Long baseSize ' Base size (default chars height)
        As Long glyphCount ' Number of glyph characters
        As Long glyphPadding ' Padding around the glyph characters
        As Texture tex ' Texture atlas containing the glyphs
        As _Unsigned _Offset recs ' Rectangles in texture for the glyphs (Rectangle *)
        As _Unsigned _Offset glyphs ' Glyphs info data (GlyphInfo *)
    End Type

    ' Camera, defines position/orientation in 3d space
    Type Camera3D
        As Vector3 position ' Camera position
        As Vector3 target ' Camera target it looks-at
        As Vector3 up ' Camera up vector (rotation over its axis)
        As Single fovy ' Camera field-of-view aperture in Y (degrees) in perspective, used as near plane width in orthographic
        As Long projection ' Camera projection: CAMERA_PERSPECTIVE or CAMERA_ORTHOGRAPHIC
    End Type

    ' Camera2D, defines position/orientation in 2d space
    Type Camera2D
        As Vector2 offset ' Camera offset (displacement from target)
        As Vector2 target ' Camera target (rotation and zoom origin)
        As Single rotation ' Camera rotation in degrees
        As Single zoom ' Camera zoom (scaling), should be 1.0f by default
    End Type

    ' Mesh, vertex data and vao/vbo
    Type Mesh
        As Long vertexCount ' Number of vertices stored in arrays
        As Long triangleCount ' Number of triangles stored (indexed or not)
        ' Vertex attributes data
        As _Unsigned _Offset vertices ' Vertex position (XYZ - 3 components per vertex) (shader-location = 0) (float *)
        As _Unsigned _Offset texcoords ' Vertex texture coordinates (UV - 2 components per vertex) (shader-location = 1) (float *)
        As _Unsigned _Offset texcoords2 ' Vertex texture second coordinates (UV - 2 components per vertex) (shader-location = 5) (float *)
        As _Unsigned _Offset normals ' Vertex normals (XYZ - 3 components per vertex) (shader-location = 2) (float *)
        As _Unsigned _Offset tangents ' Vertex tangents (XYZW - 4 components per vertex) (shader-location = 4) (float *)
        As _Unsigned _Offset colors ' Vertex colors (RGBA - 4 components per vertex) (shader-location = 3) (unsigned char *)
        As _Unsigned _Offset indices ' Vertex indices (in case vertex data comes indexed) (unsigned short *)
        ' Animation vertex data
        As _Unsigned _Offset animVertices ' Animated vertex positions (after bones transformations) (float *)
        As _Unsigned _Offset animNormals ' Animated normals (after bones transformations) (float *)
        As _Unsigned _Offset boneIds ' Vertex bone ids, max 255 bone ids, up to 4 bones influence by vertex (skinning) (unsigned char *)
        As _Unsigned _Offset boneWeights ' Vertex bone weight, up to 4 bones influence by vertex (skinning) (float *)
        ' OpenGL identifiers
        As _Unsigned Long vaoId ' OpenGL Vertex Array Object id
        As String * 4 padding
        As _Unsigned _Offset vboId ' OpenGL Vertex Buffer Objects id (default vertex data) (unsigned int *)
    End Type

    ' Shader
    Type Shader
        As Long id ' Shader program id
        As String * 4 padding
        As _Offset locs ' Shader locations array (RL_MAX_SHADER_LOCATIONS)
    End Type

    ' MaterialMap
    Type MaterialMap
        As Texture tex ' Material map texture
        As _Unsigned Long clr ' Material map color
        As Single value ' Material map value
    End Type

    ' Material, includes shader and maps
    Type Material
        As Shader shdr ' Material shader
        As _Unsigned _Offset maps ' Material maps array (MAX_MATERIAL_MAPS) (MaterialMap *)
        As Single params0 ' Material generic parameters (if required)
        As Single params1 ' Material generic parameters (if required)
        As Single params2 ' Material generic parameters (if required)
        As Single params3 ' Material generic parameters (if required)
    End Type

    ' Transform, vertex transformation data
    Type Transform
        As Vector3 translation ' Translation
        As Vector4 rotation ' Rotation
        As Vector3 scale ' Scale
    End Type

    ' Bone, skeletal animation bone
    Type BoneInfo
        As String * 32 tag ' Bone name
        As Long parent ' Bone parent
    End Type

    ' Model, meshes, materials and animation data
    Type Model
        As Matrix transform ' Local transform matrix
        As Long meshCount ' Number of meshes
        As Long materialCount ' Number of materials
        As _Unsigned _Offset meshes ' Meshes array (Mesh *)
        As _Unsigned _Offset materials ' Materials array (Material *)
        As _Unsigned _Offset meshMaterial ' Mesh material number (int *)
        ' Animation data
        As Long boneCount ' Number of bones
        As String * 4 padding
        As _Unsigned _Offset bones ' Bones information (skeleton) (BoneInfo *)
        As _Unsigned _Offset bindPose ' Bones base transformation (pose) (Transform *)
    End Type

    ' ModelAnimation
    Type ModelAnimation
        As Long boneCount ' Number of bones
        As Long frameCount ' Number of animation frames
        As _Unsigned _Offset bones ' Bones information (skeleton) (BoneInfo *)
        As _Unsigned _Offset framePoses ' Poses array by frame (Transform **)
    End Type

    ' Ray, ray for raycasting
    Type Ray
        As Vector3 position ' Ray position (origin)
        As Vector3 direction ' Ray direction
    End Type

    ' RayCollision, ray hit information
    Type RayCollision
        As Long hit ' Did the ray hit something?
        As Single distance ' Distance to the nearest hit
        As Vector3 position ' Point of the nearest hit
        As Vector3 normal ' Surface normal of hit
    End Type

    ' BoundingBox
    Type BoundingBox
        As Vector3 min ' Minimum vertex box-corner
        As Vector3 max ' Maximum vertex box-corner
    End Type

    ' Wave, audio wave data
    Type Wave
        As _Unsigned Long frameCount ' Total number of frames (considering channels)
        As _Unsigned Long sampleRate ' Frequency (samples per second)
        As _Unsigned Long sampleSize ' Bit depth (bits per sample): 8, 16, 32 (24 not supported)
        As _Unsigned Long channels ' Number of channels (1-mono, 2-stereo, ...)
        As _Unsigned _Offset dat ' Buffer data pointer (void *)
    End Type

    ' AudioStream, custom audio stream
    Type AudioStream
        As _Unsigned _Offset buffer ' Pointer to internal data used by the audio system (rAudioBuffer *)
        As _Unsigned _Offset processor ' Pointer to internal data processor, useful for audio effects (rAudioProcessor *)
        As _Unsigned Long sampleRate ' Frequency (samples per second)
        As _Unsigned Long sampleSize ' Bit depth (bits per sample): 8, 16, 32 (24 not supported)
        As _Unsigned Long channels ' Number of channels (1-mono, 2-stereo, ...)
        As String * 4 padding
    End Type

    ' Sound
    Type RSound
        As AudioStream stream ' Audio stream
        As _Unsigned Long frameCount ' Total number of frames (considering channels)
        As String * 4 padding
    End Type

    ' Music, audio stream, anything longer than ~10 seconds should be streamed
    Type Music
        As AudioStream stream ' Audio stream
        As _Unsigned Long frameCount ' Total number of frames (considering channels)
        As Long looping ' Music looping enable
        As Long ctxType ' Type of music context (audio filetype)
        As _Unsigned _Offset ctxData ' Audio context data, depends on type (void *)
        As String * 4 padding
    End Type

    ' VrDeviceInfo, Head-Mounted-Display device parameters
    Type VrDeviceInfo
        As Long hResolution ' Horizontal resolution in pixels
        As Long vResolution ' Vertical resolution in pixels
        As Single hScreenSize ' Horizontal size in meters
        As Single vScreenSize ' Vertical size in meters
        As Single vScreenCenter ' Screen center in meters
        As Single eyeToScreenDistance ' Distance between eye and display in meters
        As Single lensSeparationDistance ' Lens separation distance in meters
        As Single interpupillaryDistance ' IPD (distance between pupils) in meters
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

    ' File path list
    Type FilePathList
        As _Unsigned Long capacity ' Filepaths max entries
        As _Unsigned Long count ' Filepaths entries count
        As _Unsigned _Offset paths ' Filepaths entries (char **)
    End Type

    '-------------------------------------------------------------------------------------------------------------------
    ' Autogenerated QB64-PE DECLARE STATIC LIBRARY stuff
    ' Some of these may be incorrect due to the simple autogen code that I wrote and will need to be manually corrected
    ' Do not call anything with leading `__` directly. Use the QB64-PE function wrappers in raylib.bas instead
    '-------------------------------------------------------------------------------------------------------------------
    Declare Static Library "raylib"
        Function __init_raylib%% ' for iternal use only

        ' Low-level stuff that makes life easy when working with external libraries
        Function CLngPtr~&& (ByVal p As _Unsigned _Offset)
        Function ToQBBool%% (ByVal x As Long)
        Function ToCBool%% (ByVal x As Long)

        ' raylib color management stuff
        Function MakeRGBA~& (ByVal r As _Unsigned _Byte, Byval g As _Unsigned _Byte, Byval b As _Unsigned _Byte, Byval a As _Unsigned _Byte)
        Function GetRGBARed~%% (ByVal rgba As _Unsigned Long)
        Function GetRGBAGreen~%% (ByVal rgba As _Unsigned Long)
        Function GetRGBABlue~%% (ByVal rgba As _Unsigned Long)
        Function GetRGBAAlpha~%% (ByVal rgba As _Unsigned Long)
        Function GetRGBARGB~& (ByVal rgba As _Unsigned Long)
        Function ToRGBA~& (ByVal bgra As _Unsigned Long)

        Sub __InitWindow Alias InitWindow (ByVal W As Long, Byval H As Long, title As String)
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
        Sub SetWindowIcon (img As Image)
        Sub SetWindowIcons (images As Image, Byval count As Long)
        Sub __SetWindowTitle Alias SetWindowTitle (title As String)
        Sub SetWindowPosition (ByVal x As Long, Byval y As Long)
        Sub SetWindowMonitor (ByVal monitor As Long)
        Sub SetWindowMinSize (ByVal W As Long, Byval H As Long)
        Sub SetWindowSize (ByVal W As Long, Byval H As Long)
        Sub SetWindowOpacity (ByVal opacity As Single)
        Function GetWindowHandle~%&
        Function GetScreenWidth&
        Function GetScreenHeight&
        Function GetRenderWidth&
        Function GetRenderHeight&
        Function GetMonitorCount&
        Function GetCurrentMonitor&
        Sub GetMonitorPosition (ByVal monitor As Long, retVal As Vector2)
        Function GetMonitorWidth& (ByVal monitor As Long)
        Function GetMonitorHeight& (ByVal monitor As Long)
        Function GetMonitorPhysicalWidth& (ByVal monitor As Long)
        Function GetMonitorPhysicalHeight& (ByVal monitor As Long)
        Function GetMonitorRefreshRate& (ByVal monitor As Long)
        Sub GetWindowPosition (retVal As Vector2)
        Sub GetWindowScaleDPI (retVal As Vector2)
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
        Sub BeginMode2D (cam As Camera2D)
        Sub EndMode2D
        Sub BeginMode3D (cam As Camera3D)
        Sub EndMode3D
        Sub BeginTextureMode (target As RenderTexture)
        Sub EndTextureMode
        Sub BeginShaderMode (shdr As Shader)
        Sub EndShaderMode
        Sub BeginBlendMode (ByVal mode As Long)
        Sub EndBlendMode
        Sub BeginScissorMode (ByVal x As Long, Byval y As Long, Byval W As Long, Byval H As Long)
        Sub EndScissorMode
        Sub BeginVrStereoMode (config As VrStereoConfig)
        Sub EndVrStereoMode
        Sub LoadVrStereoConfig (device As VrDeviceInfo, retVal As VrStereoConfig)
        Sub UnloadVrStereoConfig (config As VrStereoConfig)
        Sub LoadShader (vsFileName As String, fsFileName As String, retVal As Shader)
        Sub LoadShaderFromMemory (vsCode As String, fsCode As String, retVal As Shader)
        Function IsShaderReady%% (shdr As Shader)
        Function GetShaderLocation& (shdr As Shader, uniformName As String)
        Function GetShaderLocationAttrib& (shdr As Shader, attribName As String)
        Sub SetShaderValue (shdr As Shader, Byval locIndex As Long, Byval value As _Unsigned _Offset, Byval uniformType As Long)
        Sub SetShaderValueV (shdr As Shader, Byval locIndex As Long, Byval value As _Unsigned _Offset, Byval uniformType As Long, Byval count As Long)
        Sub SetShaderValueMatrix (shdr As Shader, Byval locIndex As Long, mat As Matrix)
        Sub SetShaderValueTexture (shdr As Shader, Byval locIndex As Long, tex As Texture)
        Sub UnloadShader (shdr As Shader)
        Sub GetMouseRay (mousePosition As Vector2, cam As Camera3D, retVal As Ray)
        Sub GetCameraMatrix (cam As Camera3D, retVal As Matrix)
        Sub GetCameraMatrix2D (cam As Camera2D, retVal As Matrix)
        Sub GetWorldToScreen (position As Vector3, cam As Camera3D, retVal As Vector2)
        Sub GetScreenToWorld2D (position As Vector2, cam As Camera2D, retVal As Vector2)
        Sub GetWorldToScreenEx (position As Vector3, cam As Camera3D, Byval W As Long, Byval H As Long, retVal As Vector2)
        Sub GetWorldToScreen2D (position As Vector2, cam As Camera2D, retVal As Vector2)
        Sub SetTargetFPS (ByVal fps As Long)
        Function GetFPS&
        Function GetFrameTime!
        Function GetTime#
        Function GetRandomValue& (ByVal min As Long, Byval max As Long)
        Sub SetRandomSeed (ByVal seed As _Unsigned Long)
        Sub TakeScreenshot (fileName As String)
        Sub SetConfigFlags (ByVal flags As _Unsigned Long)
        Sub __TraceLog Alias TraceLog (ByVal logLevel As Long, text As String)
        Sub __TraceLogString Alias TraceLog (ByVal logLevel As Long, text As String, s As String)
        Sub __TraceLogLong Alias TraceLog (ByVal logLevel As Long, text As String, Byval i As Long)
        Sub __TraceLogSingle Alias TraceLog (ByVal logLevel As Long, text As String, Byval f As Single)
        Sub SetTraceLogLevel (ByVal logLevel As Long)
        Function MemAlloc~%& (ByVal size As _Unsigned Long)
        Function MemRealloc~%& (ByVal ptr As _Unsigned _Offset, Byval size As _Unsigned Long)
        Sub MemFree (ByVal ptr As _Unsigned _Offset)
        Sub OpenURL (url As String)
        Sub SetTraceLogCallback (ByVal callback As _Unsigned _Offset)
        Sub SetLoadFileDataCallback (ByVal callback As _Unsigned _Offset)
        Sub SetSaveFileDataCallback (ByVal callback As _Unsigned _Offset)
        Sub SetLoadFileTextCallback (ByVal callback As _Unsigned _Offset)
        Sub SetSaveFileTextCallback (ByVal callback As _Unsigned _Offset)
        Function LoadFileData~%& (fileName As String, bytesRead As _Unsigned Long)
        Sub UnloadFileData (dat As _Unsigned _Byte)
        Function SaveFileData%% (fileName As String, Byval dat As _Unsigned _Offset, Byval bytesToWrite As _Unsigned Long)
        Function ExportDataAsCode%% (dat As _Unsigned _Byte, Byval size As _Unsigned Long, fileName As String)
        Function LoadFileText$ (fileName As String)
        Sub UnloadFileText (text As String)
        Function SaveFileText%% (fileName As String, text As String)
        Function FileExists%% (fileName As String)
        Function DirectoryExists%% (dirPath As String)
        Function IsFileExtension%% (fileName As String, ext As String)
        Function GetFileLength& (fileName As String)
        Function GetFileExtension$ (fileName As String)
        Function GetFileName$ (filePath As String)
        Function GetFileNameWithoutExt$ (filePath As String)
        Function GetDirectoryPath$ (filePath As String)
        Function GetPrevDirectoryPath$ (dirPath As String)
        Function GetWorkingDirectory$
        Function GetApplicationDirectory$
        Function ChangeDirectory%% (dir As String)
        Function IsPathFile%% (path As String)
        Sub LoadDirectoryFiles (dirPath As String, retVal As FilePathList)
        Sub LoadDirectoryFilesEx (basePath As String, filter As String, Byval scanSubdirs As _Byte, retVal As FilePathList)
        Sub UnloadDirectoryFiles (files As FilePathList)
        Function IsFileDropped%%
        Sub LoadDroppedFiles (retVal As FilePathList)
        Sub UnloadDroppedFiles (files As FilePathList)
        Function GetFileModTime& (fileName As String)
        Function CompressData~%& (dat As _Unsigned _Byte, Byval dataSize As Long, compDataSize As Long)
        Function DecompressData~%& (compData As _Unsigned _Byte, Byval compDataSize As Long, dataSize As Long)
        Function EncodeDataBase64$ (dat As _Unsigned _Byte, Byval dataSize As Long, outputSize As Long)
        Function DecodeDataBase64~%& (dat As _Unsigned _Byte, outputSize As Long)
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
        Function SetGamepadMappings& (mappings As String)
        Function IsMouseButtonPressed%% (ByVal button As Long)
        Function IsMouseButtonDown%% (ByVal button As Long)
        Function IsMouseButtonReleased%% (ByVal button As Long)
        Function IsMouseButtonUp%% (ByVal button As Long)
        Function GetMouseX&
        Function GetMouseY&
        Sub GetMousePosition (retVal As Vector2)
        Sub GetMouseDelta (retVal As Vector2)
        Sub SetMousePosition (ByVal x As Long, Byval y As Long)
        Sub SetMouseOffset (ByVal offsetX As Long, Byval offsetY As Long)
        Sub SetMouseScale (ByVal scaleX As Single, Byval scaleY As Single)
        Function GetMouseWheelMove!
        Sub GetMouseWheelMoveV (retVal As Vector2)
        Sub SetMouseCursor (ByVal cursor As Long)
        Function GetTouchX&
        Function GetTouchY&
        Sub GetTouchPosition (ByVal index As Long, retVal As Vector2)
        Function GetTouchPointId& (ByVal index As Long)
        Function GetTouchPointCount&
        Sub SetGesturesEnabled (ByVal flags As _Unsigned Long)
        Function IsGestureDetected%% (ByVal gesture As Long)
        Function GetGestureDetected&
        Function GetGestureHoldDuration!
        Sub GetGestureDragVector (retVal As Vector2)
        Function GetGestureDragAngle!
        Sub GetGesturePinchVector (retVal As Vector2)
        Function GetGesturePinchAngle!
        Sub UpdateCamera (cam As Camera3D, Byval mode As Long)
        Sub UpdateCameraPro (cam As Camera3D, movement As Vector3, rotation As Vector3, Byval zoom As Single)
        Sub SetShapesTexture (tex As Texture, source As Rectangle)
        Sub DrawPixel (ByVal posX As Long, Byval posY As Long, Byval clr As _Unsigned Long)
        Sub DrawPixelV (position As Vector2, Byval clr As _Unsigned Long)
        Sub DrawLine (ByVal startPosX As Long, Byval startPosY As Long, Byval endPosX As Long, Byval endPosY As Long, Byval clr As _Unsigned Long)
        Sub DrawLineV (startPos As Vector2, endPos As Vector2, Byval clr As _Unsigned Long)
        Sub DrawLineEx (startPos As Vector2, endPos As Vector2, Byval thick As Single, Byval clr As _Unsigned Long)
        Sub DrawLineBezier (startPos As Vector2, endPos As Vector2, Byval thick As Single, Byval clr As _Unsigned Long)
        Sub DrawLineBezierQuad (startPos As Vector2, endPos As Vector2, controlPos As Vector2, Byval thick As Single, Byval clr As _Unsigned Long)
        Sub DrawLineBezierCubic (startPos As Vector2, endPos As Vector2, startControlPos As Vector2, endControlPos As Vector2, Byval thick As Single, Byval clr As _Unsigned Long)
        Sub DrawLineStrip (points As Vector2, Byval pointCount As Long, Byval clr As _Unsigned Long)
        Sub DrawCircle (ByVal centerX As Long, Byval centerY As Long, Byval radius As Single, Byval clr As _Unsigned Long)
        Sub DrawCircleSector (center As Vector2, Byval radius As Single, Byval startAngle As Single, Byval endAngle As Single, Byval segments As Long, Byval clr As _Unsigned Long)
        Sub DrawCircleSectorLines (center As Vector2, Byval radius As Single, Byval startAngle As Single, Byval endAngle As Single, Byval segments As Long, Byval clr As _Unsigned Long)
        Sub DrawCircleGradient (ByVal centerX As Long, Byval centerY As Long, Byval radius As Single, Byval color1 As _Unsigned Long, Byval color2 As _Unsigned Long)
        Sub DrawCircleV (center As Vector2, Byval radius As Single, Byval clr As _Unsigned Long)
        Sub DrawCircleLines (ByVal centerX As Long, Byval centerY As Long, Byval radius As Single, Byval clr As _Unsigned Long)
        Sub DrawEllipse (ByVal centerX As Long, Byval centerY As Long, Byval radiusH As Single, Byval radiusV As Single, Byval clr As _Unsigned Long)
        Sub DrawEllipseLines (ByVal centerX As Long, Byval centerY As Long, Byval radiusH As Single, Byval radiusV As Single, Byval clr As _Unsigned Long)
        Sub DrawRing (center As Vector2, Byval innerRadius As Single, Byval outerRadius As Single, Byval startAngle As Single, Byval endAngle As Single, Byval segments As Long, Byval clr As _Unsigned Long)
        Sub DrawRingLines (center As Vector2, Byval innerRadius As Single, Byval outerRadius As Single, Byval startAngle As Single, Byval endAngle As Single, Byval segments As Long, Byval clr As _Unsigned Long)
        Sub DrawRectangle (ByVal posX As Long, Byval posY As Long, Byval W As Long, Byval H As Long, Byval clr As _Unsigned Long)
        Sub DrawRectangleV (position As Vector2, size As Vector2, Byval clr As _Unsigned Long)
        Sub DrawRectangleRec (rec As Rectangle, Byval clr As _Unsigned Long)
        Sub DrawRectanglePro (rec As Rectangle, origin As Vector2, Byval rotation As Single, Byval clr As _Unsigned Long)
        Sub DrawRectangleGradientV (ByVal posX As Long, Byval posY As Long, Byval W As Long, Byval H As Long, Byval color1 As _Unsigned Long, Byval color2 As _Unsigned Long)
        Sub DrawRectangleGradientH (ByVal posX As Long, Byval posY As Long, Byval W As Long, Byval H As Long, Byval color1 As _Unsigned Long, Byval color2 As _Unsigned Long)
        Sub DrawRectangleGradientEx (rec As Rectangle, Byval col1 As _Unsigned Long, Byval col2 As _Unsigned Long, Byval col3 As _Unsigned Long, Byval col4 As _Unsigned Long)
        Sub DrawRectangleLines (ByVal posX As Long, Byval posY As Long, Byval W As Long, Byval H As Long, Byval clr As _Unsigned Long)
        Sub DrawRectangleLinesEx (rec As Rectangle, Byval lineThick As Single, Byval clr As _Unsigned Long)
        Sub DrawRectangleRounded (rec As Rectangle, Byval roundness As Single, Byval segments As Long, Byval clr As _Unsigned Long)
        Sub DrawRectangleRoundedLines (rec As Rectangle, Byval roundness As Single, Byval segments As Long, Byval lineThick As Single, Byval clr As _Unsigned Long)
        Sub DrawTriangle (v1 As Vector2, v2 As Vector2, v3 As Vector2, Byval clr As _Unsigned Long)
        Sub DrawTriangleLines (v1 As Vector2, v2 As Vector2, v3 As Vector2, Byval clr As _Unsigned Long)
        Sub DrawTriangleFan (points As Vector2, Byval pointCount As Long, Byval clr As _Unsigned Long)
        Sub DrawTriangleStrip (points As Vector2, Byval pointCount As Long, Byval clr As _Unsigned Long)
        Sub DrawPoly (center As Vector2, Byval sides As Long, Byval radius As Single, Byval rotation As Single, Byval clr As _Unsigned Long)
        Sub DrawPolyLines (center As Vector2, Byval sides As Long, Byval radius As Single, Byval rotation As Single, Byval clr As _Unsigned Long)
        Sub DrawPolyLinesEx (center As Vector2, Byval sides As Long, Byval radius As Single, Byval rotation As Single, Byval lineThick As Single, Byval clr As _Unsigned Long)
        Function CheckCollisionRecs%% (rec1 As Rectangle, rec2 As Rectangle)
        Function CheckCollisionCircles%% (center1 As Vector2, Byval radius1 As Single, center2 As Vector2, Byval radius2 As Single)
        Function CheckCollisionCircleRec%% (center As Vector2, Byval radius As Single, rec As Rectangle)
        Function CheckCollisionPointRec%% (point As Vector2, rec As Rectangle)
        Function CheckCollisionPointCircle%% (point As Vector2, center As Vector2, Byval radius As Single)
        Function CheckCollisionPointTriangle%% (point As Vector2, p1 As Vector2, p2 As Vector2, p3 As Vector2)
        Function CheckCollisionPointPoly%% (point As Vector2, points As Vector2, Byval pointCount As Long)
        Function CheckCollisionLines%% (startPos1 As Vector2, endPos1 As Vector2, startPos2 As Vector2, endPos2 As Vector2, collisionPoint As Vector2)
        Function CheckCollisionPointLine%% (point As Vector2, p1 As Vector2, p2 As Vector2, Byval threshold As Long)
        Sub GetCollisionRec (rec1 As Rectangle, rec2 As Rectangle, retVal As Rectangle)
        Sub LoadImage (fileName As String, retVal As Image)
        Sub LoadImageRaw (fileName As String, Byval W As Long, Byval H As Long, Byval format As Long, Byval headerSize As Long, retVal As Image)
        Sub LoadImageAnim (fileName As String, frames As Long, retVal As Image)
        Sub LoadImageFromMemory (fileType As String, fileData As _Unsigned _Byte, Byval dataSize As Long, retVal As Image)
        Sub LoadImageFromTexture (tex As Texture, retVal As Image)
        Sub LoadImageFromScreen (retVal As Image)
        Function IsImageReady%% (img As Image)
        Sub UnloadImage (img As Image)
        Function ExportImage%% (img As Image, fileName As String)
        Function ExportImageAsCode%% (img As Image, fileName As String)
        Sub GenImageColor (ByVal W As Long, Byval H As Long, Byval clr As _Unsigned Long, retVal As Image)
        Sub GenImageGradientV (ByVal W As Long, Byval H As Long, Byval top As _Unsigned Long, Byval bottom As _Unsigned Long, retVal As Image)
        Sub GenImageGradientH (ByVal W As Long, Byval H As Long, Byval left As _Unsigned Long, Byval right As _Unsigned Long, retVal As Image)
        Sub GenImageGradientRadial (ByVal W As Long, Byval H As Long, Byval density As Single, Byval inner As _Unsigned Long, Byval outer As _Unsigned Long, retVal As Image)
        Sub GenImageChecked (ByVal W As Long, Byval H As Long, Byval checksX As Long, Byval checksY As Long, Byval col1 As _Unsigned Long, Byval col2 As _Unsigned Long, retVal As Image)
        Sub GenImageWhiteNoise (ByVal W As Long, Byval H As Long, Byval factor As Single, retVal As Image)
        Sub GenImagePerlinNoise (ByVal W As Long, Byval H As Long, Byval offsetX As Long, Byval offsetY As Long, Byval scale As Single, retVal As Image)
        Sub GenImageCellular (ByVal W As Long, Byval H As Long, Byval tileSize As Long, retVal As Image)
        Sub GenImageText (ByVal W As Long, Byval H As Long, text As String, retVal As Image)
        Sub ImageCopy (img As Image, retVal As Image)
        Sub ImageFromImage (img As Image, rec As Rectangle, retVal As Image)
        Sub ImageText (text As String, Byval fontSize As Long, Byval clr As _Unsigned Long, retVal As Image)
        Sub ImageTextEx (font As Font, text As String, Byval fontSize As Single, Byval spacing As Single, Byval tint As _Unsigned Long, retVal As Image)
        Sub ImageFormat (img As Image, Byval newFormat As Long)
        Sub ImageToPOT (img As Image, Byval fill As _Unsigned Long)
        Sub ImageCrop (img As Image, crop As Rectangle)
        Sub ImageAlphaCrop (img As Image, Byval threshold As Single)
        Sub ImageAlphaClear (img As Image, Byval clr As _Unsigned Long, Byval threshold As Single)
        Sub ImageAlphaMask (img As Image, alphaMask As Image)
        Sub ImageAlphaPremultiply (img As Image)
        Sub ImageBlurGaussian (img As Image, Byval blurSize As Long)
        Sub ImageResize (img As Image, Byval newWidth As Long, Byval newHeight As Long)
        Sub ImageResizeNN (img As Image, Byval newWidth As Long, Byval newHeight As Long)
        Sub ImageResizeCanvas (img As Image, Byval newWidth As Long, Byval newHeight As Long, Byval offsetX As Long, Byval offsetY As Long, Byval fill As _Unsigned Long)
        Sub ImageMipmaps (img As Image)
        Sub ImageDither (img As Image, Byval rBpp As Long, Byval gBpp As Long, Byval bBpp As Long, Byval aBpp As Long)
        Sub ImageFlipVertical (img As Image)
        Sub ImageFlipHorizontal (img As Image)
        Sub ImageRotateCW (img As Image)
        Sub ImageRotateCCW (img As Image)
        Sub ImageColorTint (img As Image, Byval clr As _Unsigned Long)
        Sub ImageColorInvert (img As Image)
        Sub ImageColorGrayscale (img As Image)
        Sub ImageColorContrast (img As Image, Byval contrast As Single)
        Sub ImageColorBrightness (img As Image, Byval brightness As Long)
        Sub ImageColorReplace (img As Image, Byval clr As _Unsigned Long, Byval replace As _Unsigned Long)
        Function LoadImageColors~%& (img As Image)
        Function LoadImagePalette~%& (img As Image, Byval maxPaletteSize As Long, colorCount As Long)
        Sub UnloadImageColors (colors As _Unsigned Long)
        Sub UnloadImagePalette (colors As _Unsigned Long)
        Sub GetImageAlphaBorder (img As Image, Byval threshold As Single, retVal As Rectangle)
        Function GetImageColor~& (img As Image, Byval x As Long, Byval y As Long)
        Sub ImageClearBackground (dst As Image, Byval clr As _Unsigned Long)
        Sub ImageDrawPixel (dst As Image, Byval posX As Long, Byval posY As Long, Byval clr As _Unsigned Long)
        Sub ImageDrawPixelV (dst As Image, position As Vector2, Byval clr As _Unsigned Long)
        Sub ImageDrawLine (dst As Image, Byval startPosX As Long, Byval startPosY As Long, Byval endPosX As Long, Byval endPosY As Long, Byval clr As _Unsigned Long)
        Sub ImageDrawLineV (dst As Image, start As Vector2, end As Vector2, Byval clr As _Unsigned Long)
        Sub ImageDrawCircle (dst As Image, Byval centerX As Long, Byval centerY As Long, Byval radius As Long, Byval clr As _Unsigned Long)
        Sub ImageDrawCircleV (dst As Image, center As Vector2, Byval radius As Long, Byval clr As _Unsigned Long)
        Sub ImageDrawCircleLines (dst As Image, Byval centerX As Long, Byval centerY As Long, Byval radius As Long, Byval clr As _Unsigned Long)
        Sub ImageDrawCircleLinesV (dst As Image, center As Vector2, Byval radius As Long, Byval clr As _Unsigned Long)
        Sub ImageDrawRectangle (dst As Image, Byval posX As Long, Byval posY As Long, Byval W As Long, Byval H As Long, Byval clr As _Unsigned Long)
        Sub ImageDrawRectangleV (dst As Image, position As Vector2, size As Vector2, Byval clr As _Unsigned Long)
        Sub ImageDrawRectangleRec (dst As Image, rec As Rectangle, Byval clr As _Unsigned Long)
        Sub ImageDrawRectangleLines (dst As Image, rec As Rectangle, Byval thick As Long, Byval clr As _Unsigned Long)
        Sub ImageDraw (dst As Image, src As Image, srcRec As Rectangle, dstRec As Rectangle, Byval tint As _Unsigned Long)
        Sub ImageDrawText (dst As Image, text As String, Byval posX As Long, Byval posY As Long, Byval fontSize As Long, Byval clr As _Unsigned Long)
        Sub ImageDrawTextEx (dst As Image, font As Font, text As String, position As Vector2, Byval fontSize As Single, Byval spacing As Single, Byval tint As _Unsigned Long)
        Sub LoadTexture (fileName As String, retVal As Texture)
        Sub LoadTextureFromImage (img As Image, retVal As Texture)
        Sub LoadTextureCubemap (img As Image, Byval layout As Long, retVal As Texture)
        Sub LoadRenderTexture (ByVal W As Long, Byval H As Long, retVal As RenderTexture)
        Function IsTextureReady%% (tex As Texture)
        Sub UnloadTexture (tex As Texture)
        Function IsRenderTextureReady%% (target As RenderTexture)
        Sub UnloadRenderTexture (target As RenderTexture)
        Sub UpdateTexture (tex As Texture, Byval pixels As _Unsigned _Offset)
        Sub UpdateTextureRec (tex As Texture, rec As Rectangle, Byval pixels As _Unsigned _Offset)
        Sub GenTextureMipmaps (tex As Texture)
        Sub SetTextureFilter (tex As Texture, Byval filter As Long)
        Sub SetTextureWrap (tex As Texture, Byval wrap As Long)
        Sub DrawTexture (tex As Texture, Byval posX As Long, Byval posY As Long, Byval tint As _Unsigned Long)
        Sub DrawTextureV (tex As Texture, position As Vector2, Byval tint As _Unsigned Long)
        Sub DrawTextureEx (tex As Texture, position As Vector2, Byval rotation As Single, Byval scale As Single, Byval tint As _Unsigned Long)
        Sub DrawTextureRec (tex As Texture, source As Rectangle, position As Vector2, Byval tint As _Unsigned Long)
        Sub DrawTexturePro (tex As Texture, source As Rectangle, dest As Rectangle, origin As Vector2, Byval rotation As Single, Byval tint As _Unsigned Long)
        Sub DrawTextureNPatch (tex As Texture, nPatchInfo As NPatchInfo, dest As Rectangle, origin As Vector2, Byval rotation As Single, Byval tint As _Unsigned Long)
        Function Fade~& (ByVal clr As _Unsigned Long, Byval alpha As Single)
        Function ColorToInt& (ByVal clr As _Unsigned Long)
        Sub ColorNormalize (ByVal clr As _Unsigned Long, retVal As Vector4)
        Function ColorFromNormalized~& (normalized As Vector4)
        Sub ColorToHSV (ByVal clr As _Unsigned Long, retVal As Vector3)
        Function ColorFromHSV~& (ByVal hue As Single, Byval saturation As Single, Byval value As Single)
        Function ColorTint~& (ByVal clr As _Unsigned Long, Byval tint As _Unsigned Long)
        Function ColorBrightness~& (ByVal clr As _Unsigned Long, Byval factor As Single)
        Function ColorContrast~& (ByVal clr As _Unsigned Long, Byval contrast As Single)
        Function ColorAlpha~& (ByVal clr As _Unsigned Long, Byval alpha As Single)
        Function ColorAlphaBlend~& (ByVal dst As _Unsigned Long, Byval src As _Unsigned Long, Byval tint As _Unsigned Long)
        Function GetColor~& (ByVal hexValue As _Unsigned Long)
        Function GetPixelColor~& (ByVal srcPtr As _Unsigned _Offset, Byval format As Long)
        Sub SetPixelColor (ByVal dstPtr As _Unsigned _Offset, Byval clr As _Unsigned Long, Byval format As Long)
        Function GetPixelDataSize& (ByVal W As Long, Byval H As Long, Byval format As Long)
        Sub GetFontDefault (retVal As Font)
        Sub LoadFont (fileName As String, retVal As Font)
        Sub LoadFontEx (fileName As String, Byval fontSize As Long, fontChars As Long, Byval glyphCount As Long, retVal As Font)
        Sub LoadFontFromImage (img As Image, Byval key As _Unsigned Long, Byval firstChar As Long, retVal As Font)
        Sub LoadFontFromMemory (fileType As String, fileData As _Unsigned _Byte, Byval dataSize As Long, Byval fontSize As Long, fontChars As Long, Byval glyphCount As Long, retVal As Font)
        Function IsFontReady%% (font As Font)
        Function LoadFontData~%& (fileData As _Unsigned _Byte, Byval dataSize As Long, Byval fontSize As Long, fontChars As Long, Byval glyphCount As Long, Byval type As Long)
        Sub GenImageFontAtlas (chars As GlyphInfo, Byval recs As _Unsigned _Offset, Byval glyphCount As Long, Byval fontSize As Long, Byval padding As Long, Byval packMethod As Long, retVal As Image)
        Sub UnloadFontData (chars As GlyphInfo, Byval glyphCount As Long)
        Sub UnloadFont (font As Font)
        Function ExportFontAsCode%% (font As Font, fileName As String)
        Sub DrawFPS (ByVal posX As Long, Byval posY As Long)
        Sub __DrawText Alias DrawText (text As String, Byval posX As Long, Byval posY As Long, Byval fontSize As Long, Byval clr As _Unsigned Long)
        Sub DrawTextEx (font As Font, text As String, position As Vector2, Byval fontSize As Single, Byval spacing As Single, Byval tint As _Unsigned Long)
        Sub DrawTextPro (font As Font, text As String, position As Vector2, origin As Vector2, Byval rotation As Single, Byval fontSize As Single, Byval spacing As Single, Byval tint As _Unsigned Long)
        Sub DrawTextCodepoint (font As Font, Byval codepoint As Long, position As Vector2, Byval fontSize As Single, Byval tint As _Unsigned Long)
        Sub DrawTextCodepoints (font As Font, codepoints As Long, Byval count As Long, position As Vector2, Byval fontSize As Single, Byval spacing As Single, Byval tint As _Unsigned Long)
        Function MeasureText& (text As String, Byval fontSize As Long)
        Sub MeasureTextEx (font As Font, text As String, Byval fontSize As Single, Byval spacing As Single, retVal As Vector2)
        Function GetGlyphIndex& (font As Font, Byval codepoint As Long)
        Sub GetGlyphInfo (font As Font, Byval codepoint As Long, retVal As GlyphInfo)
        Sub GetGlyphAtlasRec (font As Font, Byval codepoint As Long, retVal As Rectangle)
        Function LoadUTF8$ (codepoints As Long, Byval length As Long)
        Sub UnloadUTF8 (text As String)
        Function LoadCodepoints~%& (text As String, count As Long)
        Sub UnloadCodepoints (codepoints As Long)
        Function GetCodepointCount& (text As String)
        Function GetCodepoint& (text As String, codepointSize As Long)
        Function GetCodepointNext& (text As String, codepointSize As Long)
        Function GetCodepointPrevious& (text As String, codepointSize As Long)
        Function CodepointToUTF8$ (ByVal codepoint As Long, utf8Size As Long)
        Function TextCopy& (dst As String, src As String)
        Function TextIsEqual%% (text1 As String, text2 As String)
        Function TextLength~& (text As String)
        Function __TextFormatString$ Alias TextFormat (text As String, s As String)
        Function __TextFormatLong$ Alias TextFormat (text As String, Byval i As Long)
        Function __TextFormatSingle$ Alias TextFormat (text As String, Byval f As Single)
        Function TextSubtext$ (text As String, Byval position As Long, Byval length As Long)
        Function TextReplace$ (text As String, replace As String, by As String)
        Function TextInsert$ (text As String, insert As String, Byval position As Long)
        Function TextJoin$ (ByVal textList As _Unsigned _Offset, Byval count As Long, delimiter As String)
        Function TextSplit~%& (text As String, Byval delimiter As _Byte, count As Long)
        Sub TextAppend (text As String, append As String, position As Long)
        Function TextFindIndex& (text As String, find As String)
        Function TextToUpper$ (text As String)
        Function TextToLower$ (text As String)
        Function TextToPascal$ (text As String)
        Function TextToInteger& (text As String)
        Sub DrawLine3D (startPos As Vector3, endPos As Vector3, Byval clr As _Unsigned Long)
        Sub DrawPoint3D (position As Vector3, Byval clr As _Unsigned Long)
        Sub DrawCircle3D (center As Vector3, Byval radius As Single, rotationAxis As Vector3, Byval rotationAngle As Single, Byval clr As _Unsigned Long)
        Sub DrawTriangle3D (v1 As Vector3, v2 As Vector3, v3 As Vector3, Byval clr As _Unsigned Long)
        Sub DrawTriangleStrip3D (points As Vector3, Byval pointCount As Long, Byval clr As _Unsigned Long)
        Sub DrawCube (position As Vector3, Byval W As Single, Byval H As Single, Byval length As Single, Byval clr As _Unsigned Long)
        Sub DrawCubeV (position As Vector3, size As Vector3, Byval clr As _Unsigned Long)
        Sub DrawCubeWires (position As Vector3, Byval W As Single, Byval H As Single, Byval length As Single, Byval clr As _Unsigned Long)
        Sub DrawCubeWiresV (position As Vector3, size As Vector3, Byval clr As _Unsigned Long)
        Sub DrawSphere (centerPos As Vector3, Byval radius As Single, Byval clr As _Unsigned Long)
        Sub DrawSphereEx (centerPos As Vector3, Byval radius As Single, Byval rings As Long, Byval slices As Long, Byval clr As _Unsigned Long)
        Sub DrawSphereWires (centerPos As Vector3, Byval radius As Single, Byval rings As Long, Byval slices As Long, Byval clr As _Unsigned Long)
        Sub DrawCylinder (position As Vector3, Byval radiusTop As Single, Byval radiusBottom As Single, Byval H As Single, Byval slices As Long, Byval clr As _Unsigned Long)
        Sub DrawCylinderEx (startPos As Vector3, endPos As Vector3, Byval startRadius As Single, Byval endRadius As Single, Byval sides As Long, Byval clr As _Unsigned Long)
        Sub DrawCylinderWires (position As Vector3, Byval radiusTop As Single, Byval radiusBottom As Single, Byval H As Single, Byval slices As Long, Byval clr As _Unsigned Long)
        Sub DrawCylinderWiresEx (startPos As Vector3, endPos As Vector3, Byval startRadius As Single, Byval endRadius As Single, Byval sides As Long, Byval clr As _Unsigned Long)
        Sub DrawCapsule (startPos As Vector3, endPos As Vector3, Byval radius As Single, Byval slices As Long, Byval rings As Long, Byval clr As _Unsigned Long)
        Sub DrawCapsuleWires (startPos As Vector3, endPos As Vector3, Byval radius As Single, Byval slices As Long, Byval rings As Long, Byval clr As _Unsigned Long)
        Sub DrawPlane (centerPos As Vector3, size As Vector2, Byval clr As _Unsigned Long)
        Sub DrawRay (ray As Ray, Byval clr As _Unsigned Long)
        Sub DrawGrid (ByVal slices As Long, Byval spacing As Single)
        Sub LoadModel (fileName As String, retVal As Model)
        Sub LoadModelFromMesh (mesh As Mesh, retVal As Model)
        Function IsModelReady%% (model As Model)
        Sub UnloadModel (model As Model)
        Sub GetModelBoundingBox (model As Model, retVal As BoundingBox)
        Sub DrawModel (model As Model, position As Vector3, Byval scale As Single, Byval tint As _Unsigned Long)
        Sub DrawModelEx (model As Model, position As Vector3, rotationAxis As Vector3, Byval rotationAngle As Single, scale As Vector3, Byval tint As _Unsigned Long)
        Sub DrawModelWires (model As Model, position As Vector3, Byval scale As Single, Byval tint As _Unsigned Long)
        Sub DrawModelWiresEx (model As Model, position As Vector3, rotationAxis As Vector3, Byval rotationAngle As Single, scale As Vector3, Byval tint As _Unsigned Long)
        Sub DrawBoundingBox (box As BoundingBox, Byval clr As _Unsigned Long)
        Sub DrawBillboard (cam As Camera3D, tex As Texture, position As Vector3, Byval size As Single, Byval tint As _Unsigned Long)
        Sub DrawBillboardRec (cam As Camera3D, tex As Texture, source As Rectangle, position As Vector3, size As Vector2, Byval tint As _Unsigned Long)
        Sub DrawBillboardPro (cam As Camera3D, tex As Texture, source As Rectangle, position As Vector3, up As Vector3, size As Vector2, origin As Vector2, Byval rotation As Single, Byval tint As _Unsigned Long)
        Sub UploadMesh (mesh As Mesh, Byval dyna As _Byte)
        Sub UpdateMeshBuffer (mesh As Mesh, Byval index As Long, Byval dat As _Unsigned _Offset, Byval dataSize As Long, Byval offset As Long)
        Sub UnloadMesh (mesh As Mesh)
        Sub DrawMesh (mesh As Mesh, material As Material, transform As Matrix)
        Sub DrawMeshInstanced (mesh As Mesh, material As Material, transforms As Matrix, Byval instances As Long)
        Function ExportMesh%% (mesh As Mesh, fileName As String)
        Sub GetMeshBoundingBox (mesh As Mesh, retVal As BoundingBox)
        Sub GenMeshTangents (mesh As Mesh)
        Sub GenMeshPoly (ByVal sides As Long, Byval radius As Single, retVal As Mesh)
        Sub GenMeshPlane (ByVal W As Single, Byval length As Single, Byval resX As Long, Byval resZ As Long, retVal As Mesh)
        Sub GenMeshCube (ByVal W As Single, Byval H As Single, Byval length As Single, retVal As Mesh)
        Sub GenMeshSphere (ByVal radius As Single, Byval rings As Long, Byval slices As Long, retVal As Mesh)
        Sub GenMeshHemiSphere (ByVal radius As Single, Byval rings As Long, Byval slices As Long, retVal As Mesh)
        Sub GenMeshCylinder (ByVal radius As Single, Byval H As Single, Byval slices As Long, retVal As Mesh)
        Sub GenMeshCone (ByVal radius As Single, Byval H As Single, Byval slices As Long, retVal As Mesh)
        Sub GenMeshTorus (ByVal radius As Single, Byval size As Single, Byval radSeg As Long, Byval sides As Long, retVal As Mesh)
        Sub GenMeshKnot (ByVal radius As Single, Byval size As Single, Byval radSeg As Long, Byval sides As Long, retVal As Mesh)
        Sub GenMeshHeightmap (heightmap As Image, size As Vector3, retVal As Mesh)
        Sub GenMeshCubicmap (cubicmap As Image, cubeSize As Vector3, retVal As Mesh)
        Function LoadMaterials~%& (fileName As String, materialCount As Long)
        Sub LoadMaterialDefault (retVal As Material)
        Function IsMaterialReady%% (material As Material)
        Sub UnloadMaterial (material As Material)
        Sub SetMaterialTexture (material As Material, Byval mapType As Long, tex As Texture)
        Sub SetModelMeshMaterial (model As Model, Byval meshId As Long, Byval materialId As Long)
        Function LoadModelAnimations~%& (fileName As String, animCount As _Unsigned Long)
        Sub UpdateModelAnimation (model As Model, anim As ModelAnimation, Byval frame As Long)
        Sub UnloadModelAnimation (anim As ModelAnimation)
        Sub UnloadModelAnimations (animations As ModelAnimation, Byval count As _Unsigned Long)
        Function IsModelAnimationValid%% (model As Model, anim As ModelAnimation)
        Function CheckCollisionSpheres%% (center1 As Vector3, Byval radius1 As Single, center2 As Vector3, Byval radius2 As Single)
        Function CheckCollisionBoxes%% (box1 As BoundingBox, box2 As BoundingBox)
        Function CheckCollisionBoxSphere%% (box As BoundingBox, center As Vector3, Byval radius As Single)
        Sub GetRayCollisionSphere (ray As Ray, center As Vector3, Byval radius As Single, retVal As RayCollision)
        Sub GetRayCollisionBox (ray As Ray, box As BoundingBox, retVal As RayCollision)
        Sub GetRayCollisionMesh (ray As Ray, mesh As Mesh, transform As Matrix, retVal As RayCollision)
        Sub GetRayCollisionTriangle (ray As Ray, p1 As Vector3, p2 As Vector3, p3 As Vector3, retVal As RayCollision)
        Sub GetRayCollisionQuad (ray As Ray, p1 As Vector3, p2 As Vector3, p3 As Vector3, p4 As Vector3, retVal As RayCollision)
        Sub InitAudioDevice
        Sub CloseAudioDevice
        Function IsAudioDeviceReady%%
        Sub SetMasterVolume (ByVal volume As Single)
        Sub LoadWave (fileName As String, retVal As Wave)
        Sub LoadWaveFromMemory (fileType As String, fileData As _Unsigned _Byte, Byval dataSize As Long, retVal As Wave)
        Function IsWaveReady%% (wav As Wave)
        Sub LoadSound (fileName As String, retVal As RSound)
        Sub LoadSoundFromWave (wav As Wave, retVal As RSound)
        Function IsSoundReady%% (snd As RSound)
        Sub UpdateSound (snd As RSound, Byval dat As _Unsigned _Offset, Byval sampleCount As Long)
        Sub UnloadWave (wav As Wave)
        Sub UnloadSound (snd As RSound)
        Function ExportWave%% (wav As Wave, fileName As String)
        Function ExportWaveAsCode%% (wav As Wave, fileName As String)
        Sub PlaySound (snd As RSound)
        Sub StopSound (snd As RSound)
        Sub PauseSound (snd As RSound)
        Sub ResumeSound (snd As RSound)
        Function IsSoundPlaying%% (snd As RSound)
        Sub SetSoundVolume (snd As RSound, Byval volume As Single)
        Sub SetSoundPitch (snd As RSound, Byval pitch As Single)
        Sub SetSoundPan (snd As RSound, Byval pan As Single)
        Sub WaveCopy (wav As Wave, retVal As Wave)
        Sub WaveCrop (wav As Wave, Byval initSample As Long, Byval finalSample As Long)
        Sub WaveFormat (wav As Wave, Byval sampleRate As Long, Byval sampleSize As Long, Byval channels As Long)
        Function LoadWaveSamples~%& (wav As Wave)
        Sub UnloadWaveSamples (samples As Single)
        Sub __LoadMusicStream Alias LoadMusicStream (fileName As String, retVal As Music)
        Sub LoadMusicStreamFromMemory (fileType As String, dat As _Unsigned _Offset, Byval dataSize As Long, retVal As Music)
        Function IsMusicReady%% (mus As Music)
        Sub UnloadMusicStream (mus As Music)
        Sub PlayMusicStream (mus As Music)
        Function IsMusicStreamPlaying%% (mus As Music)
        Sub UpdateMusicStream (mus As Music)
        Sub StopMusicStream (mus As Music)
        Sub PauseMusicStream (mus As Music)
        Sub ResumeMusicStream (mus As Music)
        Sub SeekMusicStream (mus As Music, Byval position As Single)
        Sub SetMusicVolume (mus As Music, Byval volume As Single)
        Sub SetMusicPitch (mus As Music, Byval pitch As Single)
        Sub SetMusicPan (mus As Music, Byval pan As Single)
        Function GetMusicTimeLength! (mus As Music)
        Function GetMusicTimePlayed! (mus As Music)
        Sub LoadAudioStream (ByVal sampleRate As _Unsigned Long, Byval sampleSize As _Unsigned Long, Byval channels As _Unsigned Long, retVal As AudioStream)
        Function IsAudioStreamReady%% (stream As AudioStream)
        Sub UnloadAudioStream (stream As AudioStream)
        Sub UpdateAudioStream (stream As AudioStream, Byval dat As _Unsigned _Offset, Byval frameCount As Long)
        Function IsAudioStreamProcessed%% (stream As AudioStream)
        Sub PlayAudioStream (stream As AudioStream)
        Sub PauseAudioStream (stream As AudioStream)
        Sub ResumeAudioStream (stream As AudioStream)
        Function IsAudioStreamPlaying%% (stream As AudioStream)
        Sub StopAudioStream (stream As AudioStream)
        Sub SetAudioStreamVolume (stream As AudioStream, Byval volume As Single)
        Sub SetAudioStreamPitch (stream As AudioStream, Byval pitch As Single)
        Sub SetAudioStreamPan (stream As AudioStream, Byval pan As Single)
        Sub SetAudioStreamBufferSizeDefault (ByVal size As Long)
        Sub SetAudioStreamCallback (stream As AudioStream, Byval callback As _Unsigned _Offset)
        Sub AttachAudioStreamProcessor (stream As AudioStream, Byval processor As _Unsigned _Offset)
        Sub DetachAudioStreamProcessor (stream As AudioStream, Byval processor As _Unsigned _Offset)
        Sub AttachAudioMixedProcessor (ByVal processor As _Unsigned _Offset)
        Sub DetachAudioMixedProcessor (ByVal processor As _Unsigned _Offset)
    End Declare

    ' Initialize the C-side glue code
    If __init_raylib Then
        _Delay 0.1! ' the delay is needed for the console window to appear
        _Console Off ' hide the console by default
    Else
        Print "raylib initialization failed!"
        End 1
    End If

$End If
'-----------------------------------------------------------------------------------------------------------------------
