'/*******************************************************************************************
'*
'*   raylib example - particles blending
'*
'*   Example originally created with raylib 1.7, last time updated with raylib 3.5
'*
'*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
'*   BSD-like license that allows static linking with closed source software
'*
'*   Copyright (c) 2017-2023 Ramon Santamaria (@raysan5)
'*
'********************************************************************************************/

'$INCLUDE:'include/raylib.bi'

CONST MAX_PARTICLES = 200

'// Particle structure with basic data
TYPE Particle
    position AS Vector2
    colour AS RGBA
    alpha AS SINGLE
    size AS SINGLE
    rotation AS SINGLE
    active AS _BYTE 'NOTE: Use it to activate/deactive particle
END TYPE

'//------------------------------------------------------------------------------------
'// Program main entry point
'//------------------------------------------------------------------------------------
'    // Initialization
'    //--------------------------------------------------------------------------------------
CONST screenWidth = 800
CONST screenHeight = 450

InitWindow screenWidth, screenHeight, "raylib [models] example - particles blending"
'    // Particles pool, reuse them!
DIM AS Particle mouseTail(0 TO MAX_PARTICLES)

'    // Initialize particles
DIM AS Vector2 vZero: vZero.x = 0: vZero.y = 0
DIM AS LONG i
FOR i = 0 TO MAX_PARTICLES - 1
    mouseTail(i).position = vZero
    mouseTail(i).colour.r = GetRandomValue(0, 255): mouseTail(i).colour.g = GetRandomValue(0, 255): mouseTail(i).colour.b = GetRandomValue(0, 255)
    mouseTail(i).alpha = 1.0
    mouseTail(i).size = GetRandomValue(1, 30) / 20.0!
    mouseTail(i).rotation = GetRandomValue(0, 360)
    mouseTail(i).active = FALSE
NEXT

DIM AS SINGLE gravity: gravity = 3.0!

DIM AS Texture smoke: LoadTexture "assets/image/spark_flame.png", smoke

DIM AS LONG blending: blending = BLEND_ALPHA

DIM AS Rectangle sourceRect, destRect
DIM AS Vector2 origin
DIM AS LONG c


SetTargetFPS 60
'    //--------------------------------------------------------------------------------------
'    // Main game loop

WHILE NOT WindowShouldClose '// Detect window close button or ESC key

    '        // Update
    '        //----------------------------------------------------------------------------------

    '        // Activate one particle every frame and Update active particles
    '        // NOTE: Particles initial position should be mouse position when activated
    '        // NOTE: Particles fall down with gravity and rotation... and disappear after 2 seconds (alpha = 0)
    '        // NOTE: When a particle disappears, active = false and it can be reused.

    FOR i = 0 TO MAX_PARTICLES - 1
        IF NOT mouseTail(i).active THEN
            mouseTail(i).active = TRUE
            mouseTail(i).alpha = 1.0!
            GetMousePosition mouseTail(i).position
            i = MAX_PARTICLES
        END IF
    NEXT
    FOR i = 0 TO MAX_PARTICLES - 1
        IF mouseTail(i).active THEN
            mouseTail(i).position.y = mouseTail(i).position.y + (gravity / 2)
            mouseTail(i).alpha = mouseTail(i).alpha - 0.005!
            IF mouseTail(i).alpha <= 0.0! THEN mouseTail(i).active = FALSE
            mouseTail(i).rotation = mouseTail(i).rotation + 2.0!
        END IF
    NEXT
    IF IsKeyPressed(KEY_SPACE) THEN
        IF blending = BLEND_ALPHA THEN
            blending = BLEND_ADDITIVE
        ELSE
            blending = BLEND_ALPHA
        END IF
    END IF
    '        //----------------------------------------------------------------------------------
    '        // Draw
    '        //----------------------------------------------------------------------------------
    BeginDrawing

    ClearBackground DARKGRAY

    BeginBlendMode blending

    '                // Draw active particles
    FOR i = 0 TO MAX_PARTICLES - 1
        IF mouseTail(i).active THEN
            sourceRect.x = 0
            sourceRect.y = 0
            sourceRect.W = smoke.W
            sourceRect.H = smoke.H
            destRect.x = mouseTail(i).position.x
            destRect.y = mouseTail(i).position.y
            destRect.W = smoke.W * mouseTail(i).size
            destRect.H = smoke.H * mouseTail(i).size
            origin.x = smoke.W * mouseTail(i).size / 2.0!
            origin.y = smoke.H * mouseTail(i).size / 2.0!
            c = _RGB32(mouseTail(i).colour.r, mouseTail(i).colour.g, mouseTail(i).colour.b)
            DrawTexturePro smoke, sourceRect, destRect, origin, mouseTail(i).rotation, Fade(c, mouseTail(i).alpha)
        END IF
    NEXT
    EndBlendMode

    DrawText "PRESS SPACE to CHANGE BLENDING MODE", 180, 20, 20, BLACK

    IF blending = BLEND_ALPHA THEN
        DrawText "ALPHA BLENDING", 290, screenHeight - 40, 20, BLACK
    ELSE
        DrawText "ADDITIVE BLENDING", 280, screenHeight - 40, 20, RAYWHITE
    END IF
    EndDrawing
    '        //----------------------------------------------------------------------------------
WEND
'    // De-Initialization
'    //--------------------------------------------------------------------------------------
UnloadTexture smoke
CloseWindow
'    //--------------------------------------------------------------------------------------

SYSTEM

'$INCLUDE:'include/raylib.bas'
