' raylib [text] example - Font SDF loading

'$INCLUDE:'include/raylib.bi'

Const GLSL_VERSION = 330

' Initialization
'--------------------------------------------------------------------------------------
Const screenWidth = 800
Const screenHeight = 450

InitWindow screenWidth, screenHeight, "raylib [text] example - SDF fonts"

' NOTE: Textures/Fonts MUST be loaded after Window initialization (OpenGL context is required)

Const msg = "Signed Distance Fields"

' Loading file to memory
Dim As _Unsigned Long fileSize
Dim As _Unsigned _Offset fileData: fileData = LoadFileData("assets/font/anonymous_pro_bold.ttf", fileSize)

' Default font generation from TTF font
Dim As Font fontDefault
fontDefault.baseSize = 16
fontDefault.glyphCount = 95

' Loading font data from memory data
' Parameters > font size: 16, no glyphs array provided (0), glyphs count: 95 (autogenerate chars array)
fontDefault.glyphs = LoadFontData(fileData, fileSize, 16, NULL, 95, FONT_DEFAULT)
' Parameters > glyphs count: 95, font size: 16, glyphs padding in image: 4 px, pack method: 0 (default)
Dim As Image atlas: GenImageFontAtlas fontDefault.glyphs, fontDefault.recs, 95, 16, 4, 0, atlas
LoadTextureFromImage atlas, fontDefault.tex
UnloadImage atlas

' SDF font generation from TTF font
Dim As Font fontSDF
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
Dim As Shader shader: LoadShader "", TextFormatLong("assets/shader/glsl%i/sdf.fs", GLSL_VERSION), shader
SetTextureFilter fontSDF.tex, TEXTURE_FILTER_BILINEAR ' Required for SDF font

Dim As Vector2 fontPosition: fontPosition.x = 40: fontPosition.y = screenHeight / 2.0! - 50
Dim As Vector2 textSize
Dim As Single fontSize: fontSize = 16.0!
Dim As Long currentFont ' 0 - fontDefault, 1 - fontSDF

SetTargetFPS 60 ' Set our game to run at 60 frames-per-second
'--------------------------------------------------------------------------------------

' Main game loop
While Not WindowShouldClose ' Detect window close button or ESC key
    ' Update
    '----------------------------------------------------------------------------------
    fontSize = fontSize + GetMouseWheelMove * 8.0!

    If fontSize < 6 Then fontSize = 6

    If IsKeyDown(KEY_SPACE) Then currentFont = 1 Else currentFont = 0

    If currentFont = 0 Then
        MeasureTextEx fontDefault, msg, fontSize, 0, textSize
    Else
        MeasureTextEx fontSDF, msg, fontSize, 0, textSize
    End If

    fontPosition.x = GetScreenWidth / 2 - textSize.x / 2
    fontPosition.y = GetScreenHeight / 2 - textSize.y / 2 + 80
    '----------------------------------------------------------------------------------

    ' Draw
    '----------------------------------------------------------------------------------
    BeginDrawing

    ClearBackground RAYWHITE

    If currentFont = 1 Then
        ' NOTE: SDF fonts require a custom SDF shader to compute fragment color
        BeginShaderMode shader ' Activate SDF font shader
        DrawTextEx fontSDF, msg, fontPosition, fontSize, 0, BLACK
        EndShaderMode ' Activate our default shader for next drawings

        DrawTexture fontSDF.tex, 10, 10, BLACK
    Else
        DrawTextEx fontDefault, msg, fontPosition, fontSize, 0, BLACK
        DrawTexture fontDefault.tex, 10, 10, BLACK
    End If

    If currentFont = 1 Then DrawText "SDF!", 320, 20, 80, RED Else DrawText "default font", 315, 40, 30, GRAY

    DrawText "FONT SIZE: 16.0", GetScreenWidth - 240, 20, 20, DARKGRAY
    DrawText TextFormatSingle("RENDER SIZE: %02.02f", fontSize), GetScreenWidth - 240, 50, 20, DARKGRAY
    DrawText "Use MOUSE WHEEL to SCALE TEXT!", GetScreenWidth - 240, 90, 10, DARKGRAY

    DrawText "HOLD SPACE to USE SDF FONT VERSION!", 340, GetScreenHeight - 30, 20, MAROON

    EndDrawing
    '----------------------------------------------------------------------------------
Wend

' De-Initialization
'--------------------------------------------------------------------------------------
UnloadFont fontDefault ' Default font unloading
UnloadFont fontSDF ' SDF font unloading

UnloadShader shader ' Unload SDF shader

CloseWindow ' Close window and OpenGL context
'--------------------------------------------------------------------------------------

System

'$INCLUDE:'include/raylib.bas'
