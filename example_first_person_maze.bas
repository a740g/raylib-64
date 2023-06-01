' raylib [core] example - first person maze                                                                                                        ````

'$INCLUDE:'include/raylib.bi'

Const screenWidth = 800
Const screenHeight = 450

InitWindow screenWidth, screenHeight, "raylib [models] example - first person maze"

' Define the camera to look into our 3d world
Dim v As Vector3, camera As Camera3D
v.x = 0.2!: v.y = 0.4!: v.z = 0.2!: camera.position = v ' Camera position
v.x = 0.185!: v.y = 0.4!: v.z = 0.0!: camera.target = v ' Camera looking at point
v.x = 0.0!: v.y = 1.0!: v.z = 0.0!: camera.up = v ' Camera up vector (rotation towards target)
camera.fovy = 45.0! ' Camera field-of-view Y
camera.projection = CAMERA_PERSPECTIVE ' Camera projection type

Dim As Image imMap: LoadImage "assets/image/cubicmap.png", imMap ' Load cubicmap image (RAM)
Dim As Texture cubicmap: LoadTextureFromImage imMap, cubicmap ' Convert image to texture to display (VRAM)
Dim As Mesh msh: v.x = 1.0!: v.y = 1.0!: v.z = 1.0!: GenMeshCubicmap imMap, v, msh
Dim As Model mdl: LoadModelFromMesh msh, mdl

' NOTE: By default each cube is mapped to one part of texture atlas
Dim As Texture tex: LoadTexture "assets/image/cubicmap_atlas.png", tex ' Load map texture
Dim As Material matrl: PeekTypeAtOffset mdl.materials, 0, _Offset(matrl), Len(matrl)
Dim As MaterialMap matrlmap: PeekTypeAtOffset matrl.maps, MATERIAL_MAP_DIFFUSE, _Offset(matrlmap), Len(matrlmap)
matrlmap.tex = tex: PokeTypeAtOffset matrl.maps, MATERIAL_MAP_DIFFUSE, _Offset(matrlmap), Len(matrlmap) ' Set map diffuse texture

' Get map image data to be used for collision detection
Dim As _Unsigned _Offset mapPixels: mapPixels = LoadImageColors(imMap)
UnloadImage imMap ' Unload image from RAM

Dim As Vector3 mapPosition: mapPosition.x = -16.0!: mapPosition.y = 0.0!: mapPosition.z = -8.0! ' Set model position

DisableCursor ' Limit cursor to relative movement inside the window

SetTargetFPS 60 ' Set our game to run at 60 frames-per-second

Do Until WindowShouldClose
    Dim As Vector3 oldCamPos: oldCamPos = camera.position ' Store old camera position

    UpdateCamera camera, CAMERA_FIRST_PERSON

    ' Check player collision (we simplify to 2D collision detection)
    Dim As Vector2 playerPos: playerPos.x = camera.position.x: playerPos.y = camera.position.z
    Dim As Single playerRadius: playerRadius = 0.1! ' Collision radius (player is modelled as a cilinder for collision)

    Dim As Long playerCellX: playerCellX = playerPos.x - mapPosition.x + 0.5!
    Dim As Long playerCellY: playerCellY = playerPos.y - mapPosition.z + 0.5!

    ' Out-of-limits security check
    If playerCellX < 0 Then
        playerCellX = 0
    ElseIf playerCellX >= cubicmap.W Then
        playerCellX = cubicmap.W - 1
    End If

    If playerCellY < 0 Then
        playerCellY = 0
    ElseIf playerCellY >= cubicmap.H Then
        playerCellY = cubicmap.H - 1
    End If

    ' Check map collisions using image data and player position
    ' TODO: Improvement: Just check player surrounding cells for collision
    Dim As Long x, y
    Dim r As Rectangle
    For y = 0 To cubicmap.H - 1
        For x = 0 To cubicmap.W - 1
            If GetRGBARed(PeekLongAtOffset(mapPixels, y * cubicmap.W + x)) = 255 Then ' Collision: white pixel, only check R channel
                r.x = mapPosition.x - 0.5! + x * 1.0!: r.y = mapPosition.z - 0.5! + y * 1.0!: r.W = 1.0!: r.H = 1.0!
                If CheckCollisionCircleRec(playerPos, playerRadius, r) Then
                    ' Collision detected, reset camera position
                    camera.position = oldCamPos
                End If
            End If
        Next
    Next

    BeginDrawing

    ClearBackground RAYWHITE

    BeginMode3D camera
    DrawModel mdl, mapPosition, 1.0!, WHITE ' Draw maze map
    EndMode3D

    Dim v2 As Vector2: v2.x = GetScreenWidth - cubicmap.W * 4.0! - 20: v2.y = 20.0!
    DrawTextureEx cubicmap, v2, 0.0!, 4.0!, WHITE
    DrawRectangleLines GetScreenWidth - cubicmap.W * 4 - 20, 20, cubicmap.W * 4, cubicmap.H * 4, GREEN

    ' Draw player position radar
    DrawRectangle GetScreenWidth - cubicmap.W * 4 - 20 + playerCellX * 4, 20 + playerCellY * 4, 4, 4, RED

    DrawFPS 10, 10

    EndDrawing
Loop

' De-Initialization
UnloadImageColors mapPixels ' Unload color array
UnloadTexture cubicmap ' Unload cubicmap texture
UnloadTexture tex ' Unload map texture
UnloadModel mdl ' Unload map model
CloseWindow ' Close window and OpenGL context

System

'$INCLUDE:'include/raylib.bas'
