' raylib [core] example - Basic window

'$INCLUDE:'include/raylib.bi'

CONST screenWidth = 800
CONST screenHeight = 450

InitWindow screenWidth, screenHeight, "raylib [core] example - basic window"

SetTargetFPS 60

DO UNTIL WindowShouldClose
    BeginDrawing

    ClearBackground RAYWHITE

    DrawText "Congrats! You created your first window!", 190, 200, 20, LIGHTGRAY

    EndDrawing
LOOP

CloseWindow

SYSTEM

'$INCLUDE:'include/raylib.bas'
