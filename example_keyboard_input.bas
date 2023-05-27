' raylib [core] example - Keyboard input

'$INCLUDE:'include/raylib.bi'

CONST screenWidth = 800
CONST screenHeight = 450

InitWindow screenWidth, screenHeight, "raylib [core] example - keyboard input"

DIM ballposition AS Vector2: ballposition.x = screenWidth \ 2: ballposition.y = screenHeight \ 2

SetTargetFPS 60

DO UNTIL WindowShouldClose
    IF IsKeyDown(KEY_RIGHT) THEN ballposition.x = ballposition.x + 2.0!
    IF IsKeyDown(KEY_LEFT) THEN ballposition.x = ballposition.x - 2.0!
    IF IsKeyDown(KEY_UP) THEN ballposition.y = ballposition.y - 2.0!
    IF IsKeyDown(KEY_DOWN) THEN ballposition.y = ballposition.y + 2.0!

    BeginDrawing

    ClearBackground RAYWHITE

    DrawText "move the ball with arrow keys", 10, 10, 20, DARKGRAY

    DrawCircleV ballposition, 50, MAROON

    EndDrawing
LOOP

CloseWindow

SYSTEM

'$INCLUDE:'include/raylib.bas'
