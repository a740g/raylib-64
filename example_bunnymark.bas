' raylib [textures] example - Bunnymark

'$INCLUDE:'include/raylib.bi'

Const MAX_BUNNIES = 50000 ' 50K bunnies limit

' This is the maximum amount of elements (quads) per batch
' NOTE: This value is defined in [rlgl] module and can be changed there
Const MAX_BATCH_ELEMENTS = 8192

Type Bunny
    As Vector2 position
    As Vector2 speed
    As _Unsigned Long clr
End Type

'------------------------------------------------------------------------------------
' Program main entry point
'------------------------------------------------------------------------------------
' Initialization
'--------------------------------------------------------------------------------------
Const screenWidth = 800
Const screenHeight = 450

InitWindow screenWidth, screenHeight, "raylib [textures] example - bunnymark"

' Load bunny texture
Dim As Texture texBunny: LoadTexture "assets/image/wabbit_alpha.png", texBunny

Dim bunnies(0 To MAX_BUNNIES - 1) As Bunny ' Bunnies array

Dim bunniesCount As Long ' Bunnies counter

SetTargetFPS 60 ' Set our game to run at 60 frames-per-second
'--------------------------------------------------------------------------------------

' Main game loop
While Not WindowShouldClose ' Detect window close button or ESC key

    ' Update
    '----------------------------------------------------------------------------------
    If (IsMouseButtonDown(MOUSE_BUTTON_LEFT)) Then
        ' Create more bunnies
        Dim i As Long
        For i = 0 To 99
            If bunniesCount < MAX_BUNNIES Then
                GetMousePosition bunnies(bunniesCount).position
                bunnies(bunniesCount).speed.x = GetRandomValue(-250, 250) / 60.0!
                bunnies(bunniesCount).speed.y = GetRandomValue(-250, 250) / 60.0!
                bunnies(bunniesCount).clr = ToRGBA(GetRandomValue(50, 240), GetRandomValue(80, 240), GetRandomValue(100, 240), 255)
                bunniesCount = bunniesCount + 1
            End If
        Next
    End If

    ' Update bunnies
    For i = 0 To bunniesCount - 1
        bunnies(i).position.x = bunnies(i).position.x + bunnies(i).speed.x
        bunnies(i).position.y = bunnies(i).position.y + bunnies(i).speed.y

        If (((bunnies(i).position.x + texBunny.W \ 2) > GetScreenWidth) Or ((bunnies(i).position.x + texBunny.W \ 2) < 0)) Then bunnies(i).speed.x = bunnies(i).speed.x * -1
        If (((bunnies(i).position.y + texBunny.H \ 2) > GetScreenHeight) Or ((bunnies(i).position.y + texBunny.H \ 2 - 40) < 0)) Then bunnies(i).speed.y = bunnies(i).speed.y * -1
    Next
    '----------------------------------------------------------------------------------

    ' Draw
    '----------------------------------------------------------------------------------
    BeginDrawing

    ClearBackground RAYWHITE

    For i = 0 To bunniesCount - 1
        ' NOTE: When internal batch buffer limit is reached (MAX_BATCH_ELEMENTS),
        ' a draw call is launched and buffer starts being filled again;
        ' before issuing a draw call, updated vertex data from internal CPU buffer is send to GPU...
        ' Process of sending data is costly and it could happen that GPU data has not been completely
        ' processed for drawing while new data is tried to be sent (updating current in-use buffers)
        ' it could generates a stall and consequently a frame drop, limiting the number of drawn bunnies
        DrawTexture texBunny, bunnies(i).position.x, bunnies(i).position.y, bunnies(i).clr
    Next

    DrawRectangle 0, 0, screenWidth, 40, BLACK
    DrawText TextFormatLong("bunnies: %i", bunniesCount), 120, 10, 20, GREEN
    DrawText TextFormatLong("batched draw calls: %i", 1 + bunniesCount / MAX_BATCH_ELEMENTS), 320, 10, 20, MAROON

    DrawFPS 10, 10

    EndDrawing
    '----------------------------------------------------------------------------------
Wend

' De-Initialization
'--------------------------------------------------------------------------------------
UnloadTexture texBunny ' Unload bunny texture

CloseWindow ' Close window and OpenGL context
'--------------------------------------------------------------------------------------

System

'$INCLUDE:'include/raylib.bas'
