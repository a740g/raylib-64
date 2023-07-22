' raylib [textures] example - Bunnymark

'$INCLUDE:'include/raylib.bi'

CONST MAX_BUNNIES = 50000 ' 50K bunnies limit

' This is the maximum amount of elements (quads) per batch
' NOTE: This value is defined in [rlgl] module and can be changed there
CONST MAX_BATCH_ELEMENTS = 8192

TYPE Bunny
    AS Vector2 position
    AS Vector2 speed
    AS _UNSIGNED LONG clr
END TYPE

'------------------------------------------------------------------------------------
' Program main entry point
'------------------------------------------------------------------------------------
' Initialization
'--------------------------------------------------------------------------------------
CONST screenWidth = 800
CONST screenHeight = 450

InitWindow screenWidth, screenHeight, "raylib [textures] example - bunnymark"

' Load bunny texture
DIM AS Texture texBunny: LoadTexture "assets/image/wabbit_alpha.png", texBunny

DIM bunnies(0 TO MAX_BUNNIES - 1) AS Bunny ' Bunnies array

DIM bunniesCount AS LONG ' Bunnies counter

SetTargetFPS 60 ' Set our game to run at 60 frames-per-second
'--------------------------------------------------------------------------------------

' Main game loop
WHILE NOT WindowShouldClose ' Detect window close button or ESC key

    ' Update
    '----------------------------------------------------------------------------------
    IF (IsMouseButtonDown(MOUSE_BUTTON_LEFT)) THEN
        ' Create more bunnies
        DIM i AS LONG
        FOR i = 0 TO 99
            IF bunniesCount < MAX_BUNNIES THEN
                GetMousePosition bunnies(bunniesCount).position
                bunnies(bunniesCount).speed.x = GetRandomValue(-250, 250) / 60.0!
                bunnies(bunniesCount).speed.y = GetRandomValue(-250, 250) / 60.0!
                bunnies(bunniesCount).clr = ToRGBA(GetRandomValue(50, 240), GetRandomValue(80, 240), GetRandomValue(100, 240), 255)
                bunniesCount = bunniesCount + 1
            END IF
        NEXT
    END IF

    ' Update bunnies
    FOR i = 0 TO bunniesCount - 1
        bunnies(i).position.x = bunnies(i).position.x + bunnies(i).speed.x
        bunnies(i).position.y = bunnies(i).position.y + bunnies(i).speed.y

        IF (((bunnies(i).position.x + texBunny.W \ 2) > GetScreenWidth) OR ((bunnies(i).position.x + texBunny.W \ 2) < 0)) THEN bunnies(i).speed.x = bunnies(i).speed.x * -1
        IF (((bunnies(i).position.y + texBunny.H \ 2) > GetScreenHeight) OR ((bunnies(i).position.y + texBunny.H \ 2 - 40) < 0)) THEN bunnies(i).speed.y = bunnies(i).speed.y * -1
    NEXT
    '----------------------------------------------------------------------------------

    ' Draw
    '----------------------------------------------------------------------------------
    BeginDrawing

    ClearBackground RAYWHITE

    FOR i = 0 TO bunniesCount - 1
        ' NOTE: When internal batch buffer limit is reached (MAX_BATCH_ELEMENTS),
        ' a draw call is launched and buffer starts being filled again;
        ' before issuing a draw call, updated vertex data from internal CPU buffer is send to GPU...
        ' Process of sending data is costly and it could happen that GPU data has not been completely
        ' processed for drawing while new data is tried to be sent (updating current in-use buffers)
        ' it could generates a stall and consequently a frame drop, limiting the number of drawn bunnies
        DrawTexture texBunny, bunnies(i).position.x, bunnies(i).position.y, bunnies(i).clr
    NEXT

    DrawRectangle 0, 0, screenWidth, 40, BLACK
    DrawText TextFormatLong("bunnies: %i", bunniesCount), 120, 10, 20, GREEN
    DrawText TextFormatLong("batched draw calls: %i", 1 + bunniesCount / MAX_BATCH_ELEMENTS), 320, 10, 20, MAROON

    DrawFPS 10, 10

    EndDrawing
    '----------------------------------------------------------------------------------
WEND

' De-Initialization
'--------------------------------------------------------------------------------------
UnloadTexture texBunny ' Unload bunny texture

CloseWindow ' Close window and OpenGL context
'--------------------------------------------------------------------------------------

SYSTEM

'$INCLUDE:'include/raylib.bas'
