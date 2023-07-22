' raylib [models] example - Models loading

'$INCLUDE:'include/raylib.bi'

' Initialization
'--------------------------------------------------------------------------------------
CONST screenWidth = 800
CONST screenHeight = 450

InitWindow screenWidth, screenHeight, "raylib [models] example - models loading"

' Define the camera to look into our 3d world
DIM cam AS Camera3D, v3 AS Vector3
v3.x = 50.0!: v3.y = 50.0!: v3.z = 50.0!: cam.position = v3 ' Camera position
v3.x = 0.0!: v3.y = 10.0!: v3.z = 0.0!: cam.target = v3 ' Camera looking at point
v3.x = 0.0!: v3.y = 1.0!: v3.z = 0.0!: cam.up = v3 ' Camera up vector (rotation towards target)
cam.fovy = 45.0! ' Camera field-of-view Y
cam.projection = CAMERA_PERSPECTIVE ' Camera mode type

DIM AS Model mdl: LoadModel "assets/model/obj/castle.obj", mdl ' Load model
DIM AS Texture tex: LoadTexture "assets/model/obj/castle_diffuse.png", tex ' Load model texture
DIM AS Material matrl: PeekType mdl.materials, 0, _OFFSET(matrl), LEN(matrl)
DIM AS MaterialMap matrlMap: PeekType matrl.maps, MATERIAL_MAP_DIFFUSE, _OFFSET(matrlMap), LEN(matrlMap)
matrlMap.tex = tex: PokeType matrl.maps, MATERIAL_MAP_DIFFUSE, _OFFSET(matrlMap), LEN(matrlMap) ' Set map diffuse texture

DIM AS Vector3 position ' Set model position

DIM msh AS Mesh: PeekType mdl.meshes, 0, _OFFSET(msh), LEN(msh)
DIM AS BoundingBox bounds: GetMeshBoundingBox msh, bounds ' Set model bounds

' NOTE: bounds are calculated from the original size of the model,
' if model is scaled on drawing, bounds must be also scaled

DIM AS _BYTE selected ' Selected object flag

DisableCursor ' Limit cursor to relative movement inside the window

SetTargetFPS 60 ' Set our game to run at 60 frames-per-second
'--------------------------------------------------------------------------------------

' Main game loop
WHILE NOT WindowShouldClose ' Detect window close button or ESC key
    ' Update
    '----------------------------------------------------------------------------------
    UpdateCamera cam, CAMERA_FIRST_PERSON

    ' Load new models/textures on drag&drop
    IF IsFileDropped THEN
        DIM AS FilePathList droppedFiles: LoadDroppedFiles droppedFiles

        IF droppedFiles.count = 1 THEN ' Only support one file dropped
            If IsFileExtension(CStr(PeekOffset(droppedFiles.paths, 0)), ".obj") Or _
             IsFileExtension(CStr(PeekOffset(droppedFiles.paths, 0)), ".gltf") Or _
             IsFileExtension(CStr(PeekOffset(droppedFiles.paths, 0)), ".glb") Or _
             IsFileExtension(CStr(PeekOffset(droppedFiles.paths, 0)), ".vox") Or _
             IsFileExtension(CStr(PeekOffset(droppedFiles.paths, 0)), ".iqm") Or _
             IsFileExtension(CStr(PeekOffset(droppedFiles.paths, 0)), ".m3d") Then ' Model file formats supported

                UnloadModel mdl ' Unload previous model
                LoadModel CStr(PeekOffset(droppedFiles.paths, 0)), mdl ' Load new model
                'model.materials[0].maps[MATERIAL_MAP_DIFFUSE].texture = texture
                PeekType mdl.materials, 0, _OFFSET(matrl), LEN(matrl)
                PeekType matrl.maps, MATERIAL_MAP_DIFFUSE, _OFFSET(matrlMap), LEN(matrlMap)
                matrlMap.tex = tex: PokeType matrl.maps, MATERIAL_MAP_DIFFUSE, _OFFSET(matrlMap), LEN(matrlMap) ' Set current map diffuse texture

                PeekType mdl.meshes, 0, _OFFSET(msh), LEN(msh)
                GetMeshBoundingBox msh, bounds

                ' TODO: Move camera position from target enough distance to visualize model properly
            ELSEIF IsFileExtension(CStr(PeekOffset(droppedFiles.paths, 0)), ".png") THEN ' Texture file formats supported
                ' Unload current model texture and load new one
                UnloadTexture tex
                LoadTexture CStr(PeekOffset(droppedFiles.paths, 0)), tex
                'model.materials[0].maps[MATERIAL_MAP_DIFFUSE].texture = texture
                PeekType mdl.materials, 0, _OFFSET(matrl), LEN(matrl)
                PeekType matrl.maps, MATERIAL_MAP_DIFFUSE, _OFFSET(matrlMap), LEN(matrlMap)
                matrlMap.tex = tex: PokeType matrl.maps, MATERIAL_MAP_DIFFUSE, _OFFSET(matrlMap), LEN(matrlMap) ' Set current map diffuse texture
            END IF
        END IF

        UnloadDroppedFiles droppedFiles ' Unload filepaths from memory
    END IF

    ' Select model on mouse click
    IF IsMouseButtonPressed(MOUSE_BUTTON_LEFT) THEN
        ' Check collision between ray and box
        DIM msPos AS Vector2: GetMousePosition msPos
        DIM msRay AS Ray: GetMouseRay msPos, cam, msRay
        DIM rCollision AS RayCollision: GetRayCollisionBox msRay, bounds, rCollision
        IF rCollision.hit THEN selected = NOT selected ELSE selected = FALSE
    END IF
    '----------------------------------------------------------------------------------

    ' Draw
    '----------------------------------------------------------------------------------
    BeginDrawing

    ClearBackground RAYWHITE

    BeginMode3D cam

    DrawModel mdl, position, 1.0!, WHITE ' Draw 3d model with texture

    DrawGrid 20, 10.0! ' Draw a grid

    IF selected THEN DrawBoundingBox bounds, GREEN ' Draw selection box

    EndMode3D

    DrawText "Drag & drop model to load mesh/texture.", 10, GetScreenHeight - 20, 10, DARKGRAY
    IF selected THEN DrawText "MODEL SELECTED", GetScreenWidth - 110, 10, 10, GREEN

    DrawText "(c) Castle 3D model by Alberto Cano", screenWidth - 200, screenHeight - 20, 10, GRAY

    DrawFPS 10, 10

    EndDrawing
    '----------------------------------------------------------------------------------
WEND

' De-Initialization
'--------------------------------------------------------------------------------------
UnloadTexture tex ' Unload texture
UnloadModel mdl ' Unload model

CloseWindow ' Close window and OpenGL context
'--------------------------------------------------------------------------------------

SYSTEM

'$INCLUDE:'include/raylib.bas'
