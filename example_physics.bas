'*******************************************************************************************
'
'   raylib [physac] example - physics demo
'
'   This example has been created using raylib 1.5 (www.raylib.com)
'   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
'
'   This example uses physac 1.1 (https://github.com/raysan5/raylib/blob/master/src/physac.h)
'
'   Copyright (c) 2016-2021 Victor Fisac (@victorfisac) and Ramon Santamaria (@raysan5)
'
'*******************************************************************************************/

'$INCLUDE:'include/raylib.bi'
'$INCLUDE:'include/physac.bi'

' Initialization
'--------------------------------------------------------------------------------------
CONST screenWidth = 800
CONST screenHeight = 450

SetConfigFlags FLAG_MSAA_4X_HINT
InitWindow screenWidth, screenHeight, "raylib [physac] example - physics demo"

' Physac logo drawing position
DIM AS LONG logoX: logoX = screenWidth - MeasureText("Physac", 30) - 10
DIM AS LONG logoY: logoY = 15

' Initialize physics and default physics bodies
InitPhysics

DIM vec AS Vector2, body AS PhysicsBody, bodyPtr AS _UNSIGNED _OFFSET

' Create floor rectangle physics body (PhysicsBody)
vec.x = screenWidth / 2!: vec.y = screenHeight
DIM AS _UNSIGNED _OFFSET floor: floor = CreatePhysicsBodyRectangle(vec, 500, 100, 10)
GetPtrBody body, floor ' read type from ptr
body.enabled = FALSE ' Disable body state to convert it to static (no dynamics, but collisions)
SetPtrBody floor, body ' write type to ptr

' Create obstacle circle physics body (PhysicsBody)
vec.x = screenWidth / 2!: vec.y = screenHeight / 2!
DIM AS _UNSIGNED _OFFSET circl: circl = CreatePhysicsBodyCircle(vec, 45, 10)
GetPtrBody body, circl ' read type from ptr
body.enabled = FALSE ' Disable body state to convert it to static (no dynamics, but collisions)
SetPtrBody circl, body ' write type to ptr


SetTargetFPS 60 ' Set our game to run at 60 frames-per-second
'--------------------------------------------------------------------------------------

' Main game loop
WHILE NOT WindowShouldClose ' Detect window close button or ESC key
    ' Update
    '----------------------------------------------------------------------------------
    UpdatePhysics ' Update physics system

    IF IsKeyPressed(KEY_R) THEN ' Reset physics system

        ResetPhysics

        vec.x = screenWidth / 2!: vec.y = screenHeight
        floor = CreatePhysicsBodyRectangle(vec, 500, 100, 10)
        GetPtrBody body, floor ' read type from ptr
        body.enabled = FALSE ' Disable body state to convert it to static (no dynamics, but collisions)
        SetPtrBody floor, body ' write type to ptr

        vec.x = screenWidth / 2!: vec.y = screenHeight / 2!
        circl = CreatePhysicsBodyCircle(vec, 45, 10)
        GetPtrBody body, circl ' read type from ptr
        body.enabled = FALSE ' Disable body state to convert it to static (no dynamics, but collisions)
        SetPtrBody circl, body ' write type to ptr
    END IF

    ' Physics body creation inputs
    IF IsMouseButtonPressed(MOUSE_BUTTON_LEFT) THEN
        GetMousePosition vec
        bodyPtr = CreatePhysicsBodyPolygon(vec, GetRandomValue(20, 80), GetRandomValue(3, 8), 10)
    ELSEIF IsMouseButtonPressed(MOUSE_BUTTON_RIGHT) THEN
        GetMousePosition vec
        bodyPtr = CreatePhysicsBodyCircle(vec, GetRandomValue(10, 45), 10)
    END IF

    ' Destroy falling physics bodies
    DIM AS LONG bodiesCount: bodiesCount = GetPhysicsBodiesCount

    DIM i AS LONG: FOR i = bodiesCount - 1 TO 0 STEP -1
        bodyPtr = GetPhysicsBody(i)
        IF bodyPtr <> NULL THEN
            GetPtrBody body, bodyPtr ' read type from ptr
            IF body.position.y > screenHeight * 2 THEN DestroyPhysicsBody bodyPtr
        END IF
    NEXT
    '----------------------------------------------------------------------------------

    ' Draw
    '----------------------------------------------------------------------------------
    BeginDrawing

    ClearBackground BLACK

    DrawFPS screenWidth - 90, screenHeight - 30

    ' Draw created physics bodies
    bodiesCount = GetPhysicsBodiesCount
    FOR i = 0 TO bodiesCount - 1

        bodyPtr = GetPhysicsBody(i)

        IF bodyPtr <> NULL THEN
            DIM AS LONG vertexCount: vertexCount = GetPhysicsShapeVerticesCount(i)

            DIM j AS LONG: FOR j = 0 TO vertexCount - 1

                ' Get physics bodies shape vertices to draw lines
                ' Note: GetPhysicsShapeVertex() already calculates rotation transformations
                DIM AS Vector2 vertexA: GetPhysicsShapeVertex bodyPtr, j, vertexA

                DIM AS LONG jj
                IF j + 1 < vertexCount THEN jj = j + 1 ELSE jj = 0 ' Get next vertex or first to close the shape
                DIM AS Vector2 vertexB: GetPhysicsShapeVertex bodyPtr, jj, vertexB

                DrawLineV vertexA, vertexB, GREEN ' Draw a line between two vertex positions
            NEXT
        END IF
    NEXT

    DrawText "Left mouse button to create a polygon", 10, 10, 10, WHITE
    DrawText "Right mouse button to create a circle", 10, 25, 10, WHITE
    DrawText "Press 'R' to reset example", 10, 40, 10, WHITE

    DrawText "Physac", logoX, logoY, 30, WHITE
    DrawText "Powered by", logoX + 50, logoY - 7, 10, WHITE

    EndDrawing
    '----------------------------------------------------------------------------------
WEND

' De-Initialization
'--------------------------------------------------------------------------------------
ClosePhysics ' Unitialize physics

CloseWindow ' Close window and OpenGL context
'--------------------------------------------------------------------------------------

SYSTEM


SUB GetPtrBody (body AS PhysicsBody, bodyPtr AS _UNSIGNED _OFFSET)
    PeekType bodyPtr, 0, _OFFSET(body), LEN(body) ' read type from ptr
END SUB


SUB SetPtrBody (bodyPtr AS _UNSIGNED _OFFSET, body AS PhysicsBody)
    PokeType bodyPtr, 0, _OFFSET(body), LEN(body) ' write type to ptr
END SUB


'$INCLUDE:'include/raylib.bas'
