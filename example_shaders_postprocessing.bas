'/*******************************************************************************************
'*
'*   raylib [shaders] example - Apply a postprocessing shader to a scene
'*
'*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
'*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version.
'*
'*   NOTE: Shaders used in this example are #version 330 (OpenGL 3.3), to test this example
'*         on OpenGL ES 2.0 platforms (Android, Raspberry Pi, HTML5), use #version 100 shaders
'*         raylib comes with shaders ready for both versions, check raylib/shaders install folder
'*
'*   Example originally created with raylib 1.3, last time updated with raylib 4.0
'*
'*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
'*   BSD-like license that allows static linking with closed source software
'*
'*   Copyright (c) 2015-2023 Ramon Santamaria (@raysan5)
'*
'********************************************************************************************/

' raylib [shader] example - postprocessing shader

'$INCLUDE:'include/raylib.bi'

CONST MAX_POSTPRO_SHADERS = 12

CONST FX_GRAYSCALE = 0
CONST FX_POSTERIZATION = 1
CONST FX_DREAM_VISION = 2
CONST FX_PIXELIZER = 3
CONST FX_CROSS_HATCHING = 4
CONST FX_CROSS_STITCHING = 5
CONST FX_PREDATOR_VIEW = 6
CONST FX_SCANLINES = 7
CONST FX_FISHEYE = 8
CONST FX_SOBEL = 9
CONST FX_BLOOM = 10
CONST FX_BLUR = 11

DIM AS STRING postproShaderText(0 TO 11)
postproShaderText(0) = "GRAYSCALE"
postproShaderText(1) = "POSTERIZATION"
postproShaderText(2) = "DREAM_VISION"
postproShaderText(3) = "PIXELIZER"
postproShaderText(4) = "CROSS_HATCHING"
postproShaderText(5) = "CROSS_STITCHING"
postproShaderText(6) = "PREDATOR_VIEW"
postproShaderText(7) = "SCANLINES"
postproShaderText(8) = "FISHEYE"
postproShaderText(9) = "SOBEL"
postproShaderText(10) = "BLOOM"
postproShaderText(11) = "BLUR"

' Initialization
'--------------------------------------------------------------------------------------
CONST screenWidth = 800
CONST screenHeight = 450
CONST GLSL_VERSION = 330

SetConfigFlags FLAG_MSAA_4X_HINT ' Enable Multi Sampling Anti Aliasing 4x (if available)

InitWindow screenWidth, screenHeight, "raylib [shaders] example - postprocessing shader"

' Define the camera to look into our 3d world
DIM cam AS Camera3D, v3 AS Vector3
v3.x = 2.0!: v3.y = 3.0!: v3.z = 2.0!: cam.position = v3 ' Camera position
v3.x = 0.0!: v3.y = 1.0!: v3.z = 0.0!: cam.target = v3 ' Camera looking at point
v3.x = 0.0!: v3.y = 1.0!: v3.z = 0.0!: cam.up = v3 ' Camera up vector (rotation towards target)
cam.fovy = 45.0! ' Camera field-of-view Y
cam.projection = CAMERA_PERSPECTIVE ' Camera mode type

DIM AS Model model: LoadModel "assets/model/obj/castle.obj", model ' Load OBJ model
DIM AS Texture tex: LoadTexture "assets/model/obj/castle_diffuse.png", tex ' Load model texture

DIM AS Material matrl: PeekType model.materials, 0, _OFFSET(matrl), LEN(matrl)
DIM AS MaterialMap matrlMap: PeekType matrl.maps, MATERIAL_MAP_DIFFUSE, _OFFSET(matrlMap), LEN(matrlMap)
matrlMap.tex = tex: PokeType matrl.maps, MATERIAL_MAP_DIFFUSE, _OFFSET(matrlMap), LEN(matrlMap) ' Set map diffuse texture


DIM AS Vector3 position: position.x = 0.0!: position.y = 0.0!: position.z = 0.0! ' Set model position

' Load all postpro shaders
' NOTE 1: All postpro shader use the base vertex shader (DEFAULT_VERTEX_SHADER)
' NOTE 2: We load the correct shader depending on GLSL version

DIM AS Shader shaders(0 TO MAX_POSTPRO_SHADERS)

' NOTE: Defining 0 (NULL) for vertex shader forces usage of internal default vertex shader
LoadShader "", TextFormatLong("assets/shader/glsl%i/grayscale.fs", GLSL_VERSION), shaders(FX_GRAYSCALE)
LoadShader "", TextFormatLong("assets/shader/glsl%i/posterization.fs", GLSL_VERSION), shaders(FX_POSTERIZATION)
LoadShader "", TextFormatLong("assets/shader/glsl%i/dream_vision.fs", GLSL_VERSION), shaders(FX_DREAM_VISION)
LoadShader "", TextFormatLong("assets/shader/glsl%i/pixelizer.fs", GLSL_VERSION), shaders(FX_PIXELIZER)
LoadShader "", TextFormatLong("assets/shader/glsl%i/cross_hatching.fs", GLSL_VERSION), shaders(FX_CROSS_HATCHING)
LoadShader "", TextFormatLong("assets/shader/glsl%i/cross_stitching.fs", GLSL_VERSION), shaders(FX_CROSS_STITCHING)
LoadShader "", TextFormatLong("assets/shader/glsl%i/predator.fs", GLSL_VERSION), shaders(FX_PREDATOR_VIEW)
LoadShader "", TextFormatLong("assets/shader/glsl%i/scanlines.fs", GLSL_VERSION), shaders(FX_SCANLINES)
LoadShader "", TextFormatLong("assets/shader/glsl%i/fisheye.fs", GLSL_VERSION), shaders(FX_FISHEYE)
LoadShader "", TextFormatLong("assets/shader/glsl%i/sobel.fs", GLSL_VERSION), shaders(FX_SOBEL)
LoadShader "", TextFormatLong("assets/shader/glsl%i/bloom.fs", GLSL_VERSION), shaders(FX_BLOOM)
LoadShader "", TextFormatLong("assets/shader/glsl%i/blur.fs", GLSL_VERSION), shaders(FX_BLUR)

DIM AS LONG currentShader: currentShader = FX_GRAYSCALE

' Create a RenderTexture2D to be used for render to texture
DIM AS RenderTexture target: LoadRenderTexture screenWidth, screenHeight, target

DIM AS Rectangle targetRec: DIM AS Vector2 targetPos

SetTargetFPS 60 ' Set our game to run at 60 frames-per-second
'--------------------------------------------------------------------------------------

' Main game loop
WHILE NOT WindowShouldClose ' Detect window close button or ESC key
    ' Update
    '----------------------------------------------------------------------------------
    UpdateCamera cam, CAMERA_ORBITAL

    IF IsKeyPressed(KEY_RIGHT) THEN
        currentShader = currentShader + 1
    ELSE IF IsKeyPressed(KEY_LEFT) THEN
            currentShader = currentShader - 1
        END IF
    END IF

    IF currentShader >= MAX_POSTPRO_SHADERS THEN currentShader = 0
    IF currentShader < 0 THEN currentShader = MAX_POSTPRO_SHADERS - 1

    '----------------------------------------------------------------------------------
    ' Draw
    '----------------------------------------------------------------------------------
    BeginTextureMode target ' Enable drawing to texture
    ClearBackground RAYWHITE ' Clear texture background
    BeginMode3D cam ' Begin 3d mode drawing
    DrawModel model, position, 0.1!, WHITE ' Draw 3d model with texture
    DrawGrid 10, 1.0! ' Draw a grid
    EndMode3D ' End 3d mode drawing, returns to orthographic 2d mode
    EndTextureMode 'End drawing to texture (now we have a texture available for the next passes)

    BeginDrawing

    ClearBackground RAYWHITE 'Clear Screen Background
    ' Render generated texture using selected postprocessing shader
    BeginShaderMode shaders(currentShader)
    targetRec.x = 0: targetRec.y = 0
    targetRec.W = target.tex.W: targetRec.H = -target.tex.H
    targetPos.x = 0: targetPos.y = 0
    ' NOTE: render texture must be y-flipped due to default OpenGL coordinates (left-bottom)
    DrawTextureRec target.tex, targetRec, targetPos, WHITE
    EndShaderMode

    ' Draw 2d shapes and text over drawn texture
    DrawRectangle 0, 9, 580, 30, Fade(LIGHTGRAY, 0.7!)

    DrawText "(c) Church 3d model by Alberto Cano", screenWidth - 200, screenHeight - 20, 10, GRAY
    DrawText "CURRENT POSTPRO SHADER", 10, 15, 20, BLACK
    DrawText postproShaderText(currentShader), 330, 15, 20, RED
    DrawText "< >", 540, 10, 30, DARKBLUE
    DrawFPS 700, 15

    EndDrawing
    '----------------------------------------------------------------------------------
WEND

' De-Initialization
'--------------------------------------------------------------------------------------
' Unload all postpro shaders
DIM i AS LONG
FOR i = 0 TO MAX_POSTPRO_SHADERS - 1
    UnloadShader shaders(i)
NEXT
UnloadTexture tex ' Unload texture
UnloadModel model ' Unload model
UnloadRenderTexture target ' Unload render texture

CloseWindow ' Close window and OpenGL context
'--------------------------------------------------------------------------------------

SYSTEM

'$INCLUDE:'include/raylib.bas'
