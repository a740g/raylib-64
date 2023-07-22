' raylib [text] example - Font loading

'$INCLUDE:'include/raylib.bi'

' Initialization
'--------------------------------------------------------------------------------------
CONST screenWidth = 800
CONST screenHeight = 450

InitWindow screenWidth, screenHeight, "raylib [text] example - font loading"

' Define characters to draw
DIM msg AS STRING: msg = "~!@#$%^&*()_+QWERTYUIOP{}|" + CHR$(10) + "ASDFGHJKL:" + CHR$(34) + "ZXCVBNM<>?" + CHR$(10) + "`1234567890-=qwertyuiop[]\" + CHR$(10) + "asdfghjkl;'zxcvbnm,./"

' NOTE: Textures/Fonts MUST be loaded after Window initialization (OpenGL context is required)

' BMFont (AngelCode) : Font data and image atlas have been generated using external program
DIM AS Font fontBm: LoadFont "assets/font/pixantiqua.fnt", fontBm

' TTF font : Font data and atlas are generated directly from TTF
' NOTE: We define a font base size of 32 pixels tall and up-to 250 characters
DIM AS Font fontTtf: LoadFontEx "assets/font/pixantiqua.ttf", 32, NULL, 250, fontTtf

DIM useTtf AS _BYTE, v AS Vector2: v.x = 20!: v.y = 100!

SetTargetFPS (60) ' Set our game to run at 60 frames-per-second
'--------------------------------------------------------------------------------------

' Main game loop
WHILE NOT WindowShouldClose ' Detect window close button or ESC key
    ' Update
    '----------------------------------------------------------------------------------
    IF IsKeyDown(KEY_SPACE) THEN useTtf = TRUE ELSE useTtf = FALSE
    '----------------------------------------------------------------------------------

    ' Draw
    '----------------------------------------------------------------------------------
    BeginDrawing

    ClearBackground (RAYWHITE)

    DrawText "Hold SPACE to use TTF generated font", 20, 20, 20, LIGHTGRAY

    IF NOT useTtf THEN
        DrawTextEx fontBm, msg, v, fontBm.baseSize, 2, MAROON
        DrawText "Using BMFont (Angelcode) imported", 20, GetScreenHeight - 30, 20, GRAY
    ELSE
        DrawTextEx fontTtf, msg, v, fontTtf.baseSize, 2, LIME
        DrawText "Using TTF font generated", 20, GetScreenHeight - 30, 20, GRAY
    END IF

    EndDrawing
    '----------------------------------------------------------------------------------
WEND

' De-Initialization
'--------------------------------------------------------------------------------------
UnloadFont fontBm ' AngelCode Font unloading
UnloadFont fontTtf ' TTF Font unloading

CloseWindow ' Close window and OpenGL context
'--------------------------------------------------------------------------------------

SYSTEM

'$INCLUDE:'include/raylib.bas'
