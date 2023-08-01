'/*******************************************************************************************
'*
'*   raylib [models] example - loading gltf with animations
'*
'*   LIMITATIONS:
'*     - Only supports 1 armature per file, and skips loading it if there are multiple armatures
'*     - Only supports linear interpolation (default method in Blender when checked
'*       "Always Sample Animations" when exporting a GLTF file)
'*     - Only supports translation/rotation/scale animation channel.path,
'*       weights not considered (i.e. morph targets)
'*
'*   Example originally created with raylib 3.7, last time updated with raylib 4.2
'*
'*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
'*   BSD-like license that allows static linking with closed source software
'*
'*   Copyright (c) 2020-2023 Ramon Santamaria (@raysan5)
'*
'********************************************************************************************/

'$INCLUDE:'include/raylib.bi'

'//------------------------------------------------------------------------------------
'// Program main entry point
'//------------------------------------------------------------------------------------
'    // Initialization
'    //--------------------------------------------------------------------------------------
CONST screenWidth = 800
CONST screenHeight = 450

InitWindow screenWidth, screenHeight, "raylib [models] example - loading gltf"
DIM camera AS Camera3D, v3 AS Vector3
v3.x = 5.0!: v3.y = 5.0!: v3.z = 5.0!: camera.position = v3 ' Camera position
v3.x = 0.0!: v3.y = 2.0!: v3.z = 0.0!: camera.target = v3 ' Camera looking at point
v3.x = 0.0!: v3.y = 1.0!: v3.z = 0.0!: camera.up = v3 ' Camera up vector (rotation towards target)
camera.fovy = 45.0! ' Camera field-of-view Y
camera.projection = CAMERA_PERSPECTIVE ' Camera mode type

'    // Load gltf model
DIM AS Model mdl: LoadModel "assets/model/gltf/robot.glb", mdl ' Load model
'    // Load gltf model animations
DIM AS _UNSIGNED LONG animsCount: animsCount = 0
DIM AS _UNSIGNED LONG animIndex: animIndex = 0
DIM AS _UNSIGNED LONG animCurrentFrame: animCurrentFrame = 0
DIM AS _OFFSET mdlAnim: mdlAnim = LoadModelAnimations("assets/model/gltf/robot.glb", animsCount)
'    // Set model position
DIM AS Vector3 position: position.x = 0: position.y = 0: position.z = 0
'    // Limit cursor to relative movement inside the window
DisableCursor
'    // Set our game to run at 60 frames-per-second
SetTargetFPS 60
'    //--------------------------------------------------------------------------------------

'    // Main game loop
'    // Detect window close button or ESC key
WHILE NOT WindowShouldClose

    '    // Update
    '    //----------------------------------------------------------------------------------
    UpdateCamera camera, CAMERA_THIRD_PERSON
    '    // Select current animation
    IF IsKeyPressed(KEY_ONE) THEN
        animIndex = (animIndex + 1) MOD animsCount
    ELSE
        IF IsKeyPressed(KEY_TWO) THEN
            animIndex = (animIndex + animsCount - 1) MOD animsCount
        END IF
    END IF

    '    // Update model animation
    DIM AS ModelAnimation anim: PeekType mdlAnim, animIndex, _OFFSET(anim), LEN(anim)
    animCurrentFrame = (animCurrentFrame + 1) MOD anim.frameCount
    UpdateModelAnimation mdl, anim, animCurrentFrame
    '    //----------------------------------------------------------------------------------

    '    // Draw
    '    //----------------------------------------------------------------------------------
    BeginDrawing

    ClearBackground RAYWHITE

    BeginMode3D camera

    '    // Draw animated model
    DrawModel mdl, position, 1.0!, WHITE
    DrawGrid 10, 1.0!

    EndMode3D

    DrawText "Use the [1][2] keys to switch animation", 10, 10, 20, GRAY

    EndDrawing
    '   //----------------------------------------------------------------------------------

WEND
'    // De-Initialization
'    //--------------------------------------------------------------------------------------
'    // Unload model and meshes/material
UnloadModel mdl
'    // Close window and OpenGL context
CloseWindow
'    //--------------------------------------------------------------------------------------

SYSTEM

'$INCLUDE:'include/raylib.bas'
