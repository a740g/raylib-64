' A simple "Hello, World" program using raylib

$ExeIcon:'./raylib.ico'

'$INCLUDE:'./raylib.bi'

Const APP_NAME = "Hello, world!"

Const w = 800
Const h = 600

InitWindow w, h, APP_NAME
'SetTargetFPS (60)

Do
    BeginDrawing

    'ClearBackground _RGBA32(Col.r, Col.g, Col.b, Col.a)

    'DrawText "Hello World" + CHR$(0), 10, 30, 20, _RGBA32(255, 0, 0, 255)

    'IF IsKeyPressed(KEY_LEFT) THEN
    '    DrawText "Left" + CHR$(0), 10, 60, 20, _RGBA32(255, 0, 0, 255)
    'END IF

    'DrawFPS 1, 1

    'DrawLine 10, 20, 50, 50, _RGBA32(0, 0, 255, 255)

    EndDrawing
Loop Until WindowShouldClose

CloseWindow

System

'$INCLUDE:'./raylib.bas'

