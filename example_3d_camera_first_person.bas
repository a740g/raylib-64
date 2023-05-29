' raylib [core] example - Basic window

'$INCLUDE:'include/raylib.bi'

Const MAX_COLUMNS = 19

Const screenWidth = 800
Const screenHeight = 450

InitWindow screenWidth, screenHeight, "raylib [core] example - 3d camera first person"

Dim v As Vector3
Dim As Camera3D cam
v.x = 0!: v.y = 2!: v.z = 4!: cam.position = v
v.x = 0!: v.y = 2!: v.z = 0!: cam.target = v
v.x = 0!: v.y = 1!: v.z = 0!: cam.up = v
cam.fovy = 60!
cam.projection = CAMERA_PERSPECTIVE

Dim As Single heights(0 To MAX_COLUMNS)
Dim As Vector3 positions(0 To MAX_COLUMNS)
Dim As _Unsigned Long clr(0 To MAX_COLUMNS)

Dim i As Long
For i = 0 To MAX_COLUMNS
    heights(i) = GetRandomValue(1, 12)
    v.x = GetRandomValue(-15, 15): v.y = heights(i) / 2.0!: v.z = GetRandomValue(-15, 15): positions(i) = v
    clr(i) = MakeRGBA(GetRandomValue(20, 255), GetRandomValue(10, 55), 30, 255)
Next

DisableCursor ' Limit cursor to relative movement inside the window

SetTargetFPS 60

Dim vs As Vector2

While Not WindowShouldClose
    UpdateCamera cam, CAMERA_FIRST_PERSON ' Update camera

    BeginDrawing

    ClearBackground RAYWHITE

    BeginMode3D cam

    v.x = 0!: v.y = 0!: v.z = 0!: vs.x = 32!: vs.y = 32!: DrawPlane v, vs, LIGHTGRAY ' Draw ground
    v.x = -16.0!: v.y = 2.5!: v.z = 0.0!: DrawCube v, 1.0, 5.0, 32.0, BLUE ' Draw a blue wall
    v.x = 16.0!: v.y = 2.5!: v.z = 0.0!: DrawCube v, 1.0, 5.0, 32.0, LIME ' Draw a green wall
    v.x = 0.0!: v.y = 2.5!: v.z = 16.0!: DrawCube v, 32.0, 5.0, 1.0, GOLD ' Draw a yellow wall

    Dim j As Long
    For j = 0 To MAX_COLUMNS
        DrawCube positions(j), 2.0, heights(j), 2.0, clr(j)
        DrawCubeWires positions(j), 2.0, heights(j), 2.0, MAROON
    Next

    EndMode3D

    DrawRectangle 10, 10, 220, 70, Fade(SKYBLUE, 0.5!)
    DrawRectangleLines 10, 10, 220, 70, BLUE

    DrawText "First person camera default controls:", 20, 20, 10, BLACK
    DrawText "- Move with keys: W, A, S, D", 40, 40, 10, DARKGRAY
    DrawText "- Mouse move to look around", 40, 60, 10, DARKGRAY

    EndDrawing
Wend

CloseWindow

System

'$INCLUDE:'include/raylib.bas'
