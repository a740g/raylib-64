' A simple "Hello, World" program using raylib

$EXEICON:'./raylib.ico'

'$INCLUDE:'./raylib.bi'

CONST APP_NAME = "Hello, world!"

CONST w = 800
CONST h = 600

InitWindow w, h, APP_NAME
'SetTargetFPS (60)

DO
    BeginDrawing

    'ClearBackground _RGBA32(Col.r, Col.g, Col.b, Col.a)

    'DrawText "Hello World" + CHR$(0), 10, 30, 20, _RGBA32(255, 0, 0, 255)

    'IF IsKeyPressed(KEY_LEFT) THEN
    '    DrawText "Left" + CHR$(0), 10, 60, 20, _RGBA32(255, 0, 0, 255)
    'END IF

    'DrawFPS 1, 1

    'DrawLine 10, 20, 50, 50, _RGBA32(0, 0, 255, 255)

    EndDrawing
LOOP UNTIL WindowShouldClose

CloseWindow

SYSTEM

'$INCLUDE:'./raylib.bas'

