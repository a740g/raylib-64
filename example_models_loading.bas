' raylib [models] example - Models loading

'$INCLUDE:'include/raylib.bi'

' Initialization
'--------------------------------------------------------------------------------------
Const screenWidth = 800
Const screenHeight = 450

InitWindow screenWidth, screenHeight, "raylib [models] example - models loading"

' Define the camera to look into our 3d world
Dim cam As Camera3D, v3 As Vector3
v3.x = 50.0!: v3.y = 50.0!: v3.z = 50.0!: cam.position = v3 ' Camera position
v3.x = 0.0!: v3.y = 10.0!: v3.z = 0.0!: cam.target = v3 ' Camera looking at point
v3.x = 0.0!: v3.y = 1.0!: v3.z = 0.0!: cam.up = v3 ' Camera up vector (rotation towards target)
cam.fovy = 45.0! ' Camera field-of-view Y
cam.projection = CAMERA_PERSPECTIVE ' Camera mode type

Dim As Model mdl: LoadModel "assets/model/obj/castle.obj", mdl ' Load model
Dim As Texture tex: LoadTexture "assets/model/obj/castle_diffuse.png", tex ' Load model texture
Dim As Material matrl: PeekType mdl.materials, 0, _Offset(matrl), Len(matrl)
Dim As MaterialMap matrlMap: PeekType matrl.maps, MATERIAL_MAP_DIFFUSE, _Offset(matrlMap), Len(matrlMap)
matrlMap.tex = tex: PokeType matrl.maps, MATERIAL_MAP_DIFFUSE, _Offset(matrlMap), Len(matrlMap) ' Set map diffuse texture

Dim As Vector3 position ' Set model position

Dim msh As Mesh: PeekType mdl.meshes, 0, _Offset(msh), Len(msh)
Dim As BoundingBox bounds: GetMeshBoundingBox msh, bounds ' Set model bounds

' NOTE: bounds are calculated from the original size of the model,
' if model is scaled on drawing, bounds must be also scaled

Dim As _Byte selected ' Selected object flag

DisableCursor ' Limit cursor to relative movement inside the window

SetTargetFPS 60 ' Set our game to run at 60 frames-per-second
'--------------------------------------------------------------------------------------

' Main game loop
While Not WindowShouldClose ' Detect window close button or ESC key
    ' Update
    '----------------------------------------------------------------------------------
    UpdateCamera cam, CAMERA_FIRST_PERSON

    ' Load new models/textures on drag&drop
    If IsFileDropped Then
        Dim As FilePathList droppedFiles: LoadDroppedFiles droppedFiles

        If droppedFiles.count = 1 Then ' Only support one file dropped
            If IsFileExtension(CStr(PeekOffset(droppedFiles.paths, 0)), ".obj") Or _
             IsFileExtension(CStr(PeekOffset(droppedFiles.paths, 0)), ".gltf") Or _
             IsFileExtension(CStr(PeekOffset(droppedFiles.paths, 0)), ".glb") Or _
             IsFileExtension(CStr(PeekOffset(droppedFiles.paths, 0)), ".vox") Or _
             IsFileExtension(CStr(PeekOffset(droppedFiles.paths, 0)), ".iqm") Or _
             IsFileExtension(CStr(PeekOffset(droppedFiles.paths, 0)), ".m3d") Then ' Model file formats supported

                UnloadModel mdl ' Unload previous model
                LoadModel CStr(PeekOffset(droppedFiles.paths, 0)), mdl ' Load new model
                'model.materials[0].maps[MATERIAL_MAP_DIFFUSE].texture = texture
                PeekType mdl.materials, 0, _Offset(matrl), Len(matrl)
                PeekType matrl.maps, MATERIAL_MAP_DIFFUSE, _Offset(matrlMap), Len(matrlMap)
                matrlMap.tex = tex: PokeType matrl.maps, MATERIAL_MAP_DIFFUSE, _Offset(matrlMap), Len(matrlMap) ' Set current map diffuse texture

                PeekType mdl.meshes, 0, _Offset(msh), Len(msh)
                GetMeshBoundingBox msh, bounds

                ' TODO: Move camera position from target enough distance to visualize model properly
            ElseIf IsFileExtension(CStr(PeekOffset(droppedFiles.paths, 0)), ".png") Then ' Texture file formats supported
                ' Unload current model texture and load new one
                UnloadTexture tex
                LoadTexture CStr(PeekOffset(droppedFiles.paths, 0)), tex
                'model.materials[0].maps[MATERIAL_MAP_DIFFUSE].texture = texture
                PeekType mdl.materials, 0, _Offset(matrl), Len(matrl)
                PeekType matrl.maps, MATERIAL_MAP_DIFFUSE, _Offset(matrlMap), Len(matrlMap)
                matrlMap.tex = tex: PokeType matrl.maps, MATERIAL_MAP_DIFFUSE, _Offset(matrlMap), Len(matrlMap) ' Set current map diffuse texture
            End If
        End If

        UnloadDroppedFiles droppedFiles ' Unload filepaths from memory
    End If

    ' Select model on mouse click
    If IsMouseButtonPressed(MOUSE_BUTTON_LEFT) Then
        ' Check collision between ray and box
        Dim msPos As Vector2: GetMousePosition msPos
        Dim msRay As Ray: GetMouseRay msPos, cam, msRay
        Dim rCollision As RayCollision: GetRayCollisionBox msRay, bounds, rCollision
        If rCollision.hit Then selected = Not selected Else selected = FALSE
    End If
    '----------------------------------------------------------------------------------

    ' Draw
    '----------------------------------------------------------------------------------
    BeginDrawing

    ClearBackground RAYWHITE

    BeginMode3D cam

    DrawModel mdl, position, 1.0!, WHITE ' Draw 3d model with texture

    DrawGrid 20, 10.0! ' Draw a grid

    If selected Then DrawBoundingBox bounds, GREEN ' Draw selection box

    EndMode3D

    DrawText "Drag & drop model to load mesh/texture.", 10, GetScreenHeight - 20, 10, DARKGRAY
    If selected Then DrawText "MODEL SELECTED", GetScreenWidth - 110, 10, 10, GREEN

    DrawText "(c) Castle 3D model by Alberto Cano", screenWidth - 200, screenHeight - 20, 10, GRAY

    DrawFPS 10, 10

    EndDrawing
    '----------------------------------------------------------------------------------
Wend

' De-Initialization
'--------------------------------------------------------------------------------------
UnloadTexture tex ' Unload texture
UnloadModel mdl ' Unload model

CloseWindow ' Close window and OpenGL context
'--------------------------------------------------------------------------------------

System

'$INCLUDE:'include/raylib.bas'
