' raylib [text] example - Font loading

'$INCLUDE:'include/raylib.bi'

' Initialization
'--------------------------------------------------------------------------------------
Const screenWidth = 800
Const screenHeight = 450

InitWindow screenWidth, screenHeight, "raylib [text] example - font loading"

' Define characters to draw
' NOTE: raylib supports UTF-8 encoding, following list is actually codified as UTF8 internally
Const msg = "!#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHI\nJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmn\nopqrstuvwxyz{|}~¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓ\nÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷\nøùúûüýþÿ"

' NOTE: Textures/Fonts MUST be loaded after Window initialization (OpenGL context is required)

' BMFont (AngelCode) : Font data and image atlas have been generated using external program
Dim As Font fontBm: LoadFont "assets/font/pixantiqua.fnt", fontBm

' TTF font : Font data and atlas are generated directly from TTF
' NOTE: We define a font base size of 32 pixels tall and up-to 250 characters
Dim As Font fontTtf: LoadFontEx "assets/font/pixantiqua.ttf", 32, NULL, 250, fontTtf

Dim useTtf As _Byte, v As Vector2: v.x = 20!: v.y = 100!

SetTargetFPS (60) ' Set our game to run at 60 frames-per-second
'--------------------------------------------------------------------------------------

' Main game loop
While Not WindowShouldClose ' Detect window close button or ESC key
    ' Update
    '----------------------------------------------------------------------------------
    If IsKeyDown(KEY_SPACE) Then useTtf = TRUE Else useTtf = FALSE
    '----------------------------------------------------------------------------------

    ' Draw
    '----------------------------------------------------------------------------------
    BeginDrawing

    ClearBackground (RAYWHITE)

    DrawText "Hold SPACE to use TTF generated font", 20, 20, 20, LIGHTGRAY

    If Not useTtf Then
        DrawTextEx fontBm, msg, v, fontBm.baseSize, 2, MAROON
        DrawText "Using BMFont (Angelcode) imported", 20, GetScreenHeight - 30, 20, GRAY
    Else
        DrawTextEx fontTtf, msg, v, fontTtf.baseSize, 2, LIME
        DrawText "Using TTF font generated", 20, GetScreenHeight - 30, 20, GRAY
    End If

    EndDrawing
    '----------------------------------------------------------------------------------
Wend

' De-Initialization
'--------------------------------------------------------------------------------------
UnloadFont fontBm ' AngelCode Font unloading
UnloadFont fontTtf ' TTF Font unloading

CloseWindow ' Close window and OpenGL context
'--------------------------------------------------------------------------------------

System

'$INCLUDE:'include/raylib.bas'
