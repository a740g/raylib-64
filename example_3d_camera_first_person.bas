' raylib [core] example - Basic window

'$INCLUDE:'include/raylib.bi'

CONST MAX_COLUMNS = 19

CONST screenWidth = 800
CONST screenHeight = 450

InitWindow screenWidth, screenHeight, "raylib [core] example - 3d camera first person"

DIM v AS Vector3
DIM AS Camera3D cam
v.x = 0!: v.y = 2!: v.z = 4!: cam.position = v
v.x = 0!: v.y = 2!: v.z = 0!: cam.target = v
v.x = 0!: v.y = 1!: v.z = 0!: cam.up = v
cam.fovy = 60!
cam.projection = CAMERA_PERSPECTIVE

DIM AS SINGLE heights(0 TO MAX_COLUMNS)
DIM AS Vector3 positions(0 TO MAX_COLUMNS)
DIM AS _UNSIGNED LONG clr(0 TO MAX_COLUMNS)

DIM i AS LONG
FOR i = 0 TO MAX_COLUMNS
    heights(i) = GetRandomValue(1, 12)
    v.x = GetRandomValue(-15, 15): v.y = heights(i) / 2.0!: v.z = GetRandomValue(-15, 15): positions(i) = v
    clr(i) = ToRGBA(GetRandomValue(20, 255), GetRandomValue(10, 55), 30, 255)
NEXT

DisableCursor ' Limit cursor to relative movement inside the window

SetTargetFPS 60

DIM vs AS Vector2

WHILE NOT WindowShouldClose
    UpdateCamera cam, CAMERA_FIRST_PERSON ' Update camera

    BeginDrawing

    ClearBackground RAYWHITE

    BeginMode3D cam

    v.x = 0!: v.y = 0!: v.z = 0!: vs.x = 32!: vs.y = 32!: DrawPlane v, vs, LIGHTGRAY ' Draw ground
    v.x = -16.0!: v.y = 2.5!: v.z = 0.0!: DrawCube v, 1.0, 5.0, 32.0, BLUE ' Draw a blue wall
    v.x = 16.0!: v.y = 2.5!: v.z = 0.0!: DrawCube v, 1.0, 5.0, 32.0, LIME ' Draw a green wall
    v.x = 0.0!: v.y = 2.5!: v.z = 16.0!: DrawCube v, 32.0, 5.0, 1.0, GOLD ' Draw a yellow wall

    DIM j AS LONG
    FOR j = 0 TO MAX_COLUMNS
        DrawCube positions(j), 2.0, heights(j), 2.0, clr(j)
        DrawCubeWires positions(j), 2.0, heights(j), 2.0, MAROON
    NEXT

    EndMode3D

    DrawRectangle 10, 10, 220, 70, Fade(SKYBLUE, 0.5!)
    DrawRectangleLines 10, 10, 220, 70, BLUE

    DrawText "First person camera default controls:", 20, 20, 10, BLACK
    DrawText "- Move with keys: W, A, S, D", 40, 40, 10, DARKGRAY
    DrawText "- Mouse move to look around", 40, 60, 10, DARKGRAY

    EndDrawing
WEND

CloseWindow

SYSTEM

'$INCLUDE:'include/raylib.bas'
