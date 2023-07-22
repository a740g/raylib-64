' raylib [text] example - Font SDF loading

'$INCLUDE:'include/raylib.bi'

CONST GLSL_VERSION = 330

' Initialization
'--------------------------------------------------------------------------------------
CONST screenWidth = 800
CONST screenHeight = 450

InitWindow screenWidth, screenHeight, "raylib [text] example - SDF fonts"

' NOTE: Textures/Fonts MUST be loaded after Window initialization (OpenGL context is required)

CONST msg = "Signed Distance Fields"

' Loading file to memory
DIM AS _UNSIGNED LONG fileSize
DIM AS _UNSIGNED _OFFSET fileData: fileData = LoadFileData("assets/font/anonymous_pro_bold.ttf", fileSize)

' Default font generation from TTF font
DIM AS Font fontDefault
fontDefault.baseSize = 16
fontDefault.glyphCount = 95

' Loading font data from memory data
' Parameters > font size: 16, no glyphs array provided (0), glyphs count: 95 (autogenerate chars array)
fontDefault.glyphs = LoadFontData(fileData, fileSize, 16, NULL, 95, FONT_DEFAULT)
' Parameters > glyphs count: 95, font size: 16, glyphs padding in image: 4 px, pack method: 0 (default)
DIM AS Image atlas: GenImageFontAtlas fontDefault.glyphs, fontDefault.recs, 95, 16, 4, 0, atlas
LoadTextureFromImage atlas, fontDefault.tex
UnloadImage atlas

' SDF font generation from TTF font
DIM AS Font fontSDF
fontSDF.baseSize = 16
fontSDF.glyphCount = 95
' Parameters > font size: 16, no glyphs array provided (0), glyphs count: 0 (defaults to 95)
fontSDF.glyphs = LoadFontData(fileData, fileSize, 16, NULL, 0, FONT_SDF)
' Parameters > glyphs count: 95, font size: 16, glyphs padding in image: 0 px, pack method: 1 (Skyline algorythm)
GenImageFontAtlas fontSDF.glyphs, fontSDF.recs, 95, 16, 0, 1, atlas
LoadTextureFromImage atlas, fontSDF.tex
UnloadImage atlas

UnloadFileData fileData ' Free memory from loaded file

' Load SDF required shader (we use default vertex shader)
DIM AS Shader shader: LoadShader "", TextFormatLong("assets/shader/glsl%i/sdf.fs", GLSL_VERSION), shader
SetTextureFilter fontSDF.tex, TEXTURE_FILTER_BILINEAR ' Required for SDF font

DIM AS Vector2 fontPosition: fontPosition.x = 40: fontPosition.y = screenHeight / 2.0! - 50
DIM AS Vector2 textSize
DIM AS SINGLE fontSize: fontSize = 16.0!
DIM AS LONG currentFont ' 0 - fontDefault, 1 - fontSDF

SetTargetFPS 60 ' Set our game to run at 60 frames-per-second
'--------------------------------------------------------------------------------------

' Main game loop
WHILE NOT WindowShouldClose ' Detect window close button or ESC key
    ' Update
    '----------------------------------------------------------------------------------
    fontSize = fontSize + GetMouseWheelMove * 8.0!

    IF fontSize < 6 THEN fontSize = 6

    IF IsKeyDown(KEY_SPACE) THEN currentFont = 1 ELSE currentFont = 0

    IF currentFont = 0 THEN
        MeasureTextEx fontDefault, msg, fontSize, 0, textSize
    ELSE
        MeasureTextEx fontSDF, msg, fontSize, 0, textSize
    END IF

    fontPosition.x = GetScreenWidth / 2 - textSize.x / 2
    fontPosition.y = GetScreenHeight / 2 - textSize.y / 2 + 80
    '----------------------------------------------------------------------------------

    ' Draw
    '----------------------------------------------------------------------------------
    BeginDrawing

    ClearBackground RAYWHITE

    IF currentFont = 1 THEN
        ' NOTE: SDF fonts require a custom SDF shader to compute fragment color
        BeginShaderMode shader ' Activate SDF font shader
        DrawTextEx fontSDF, msg, fontPosition, fontSize, 0, BLACK
        EndShaderMode ' Activate our default shader for next drawings

        DrawTexture fontSDF.tex, 10, 10, BLACK
    ELSE
        DrawTextEx fontDefault, msg, fontPosition, fontSize, 0, BLACK
        DrawTexture fontDefault.tex, 10, 10, BLACK
    END IF

    IF currentFont = 1 THEN DrawText "SDF!", 320, 20, 80, RED ELSE DrawText "default font", 315, 40, 30, GRAY

    DrawText "FONT SIZE: 16.0", GetScreenWidth - 240, 20, 20, DARKGRAY
    DrawText TextFormatSingle("RENDER SIZE: %02.02f", fontSize), GetScreenWidth - 240, 50, 20, DARKGRAY
    DrawText "Use MOUSE WHEEL to SCALE TEXT!", GetScreenWidth - 240, 90, 10, DARKGRAY

    DrawText "HOLD SPACE to USE SDF FONT VERSION!", 340, GetScreenHeight - 30, 20, MAROON

    EndDrawing
    '----------------------------------------------------------------------------------
WEND

' De-Initialization
'--------------------------------------------------------------------------------------
UnloadFont fontDefault ' Default font unloading
UnloadFont fontSDF ' SDF font unloading

UnloadShader shader ' Unload SDF shader

CloseWindow ' Close window and OpenGL context
'--------------------------------------------------------------------------------------

SYSTEM

'$INCLUDE:'include/raylib.bas'
