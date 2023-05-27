' raylib [core] example - Keyboard input

'$INCLUDE:'include/raylib.bi'

Const screenWidth = 800
Const screenHeight = 450

InitWindow screenWidth, screenHeight, "raylib [core] example - keyboard input"

Dim ballposition As Vector2: ballposition.x = screenWidth \ 2: ballposition.y = screenHeight \ 2

SetTargetFPS 60

Do Until WindowShouldClose
    If IsKeyDown(KEY_RIGHT) Then ballposition.x = ballposition.x + 2.0!
    If IsKeyDown(KEY_LEFT) Then ballposition.x = ballposition.x - 2.0!
    If IsKeyDown(KEY_UP) Then ballposition.y = ballposition.y - 2.0!
    If IsKeyDown(KEY_DOWN) Then ballposition.y = ballposition.y + 2.0!

    BeginDrawing

    ClearBackground RAYWHITE

    DrawText "move the ball with arrow keys", 10, 10, 20, DARKGRAY

    DrawCircleV ballposition, 50, MAROON

    EndDrawing
Loop

CloseWindow

System

'$INCLUDE:'include/raylib.bas'
