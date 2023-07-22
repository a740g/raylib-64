' raylib [core] example - first person maze                                                                                                        ````

'$INCLUDE:'include/raylib.bi'

CONST screenWidth = 800
CONST screenHeight = 450

InitWindow screenWidth, screenHeight, "raylib [models] example - first person maze"

' Define the camera to look into our 3d world
DIM v AS Vector3, camera AS Camera3D
v.x = 0.2!: v.y = 0.4!: v.z = 0.2!: camera.position = v ' Camera position
v.x = 0.185!: v.y = 0.4!: v.z = 0.0!: camera.target = v ' Camera looking at point
v.x = 0.0!: v.y = 1.0!: v.z = 0.0!: camera.up = v ' Camera up vector (rotation towards target)
camera.fovy = 45.0! ' Camera field-of-view Y
camera.projection = CAMERA_PERSPECTIVE ' Camera projection type

DIM AS Image imMap: LoadImage "assets/image/cubicmap.png", imMap ' Load cubicmap image (RAM)
DIM AS Texture cubicmap: LoadTextureFromImage imMap, cubicmap ' Convert image to texture to display (VRAM)
DIM AS Mesh msh: v.x = 1.0!: v.y = 1.0!: v.z = 1.0!: GenMeshCubicmap imMap, v, msh
DIM AS Model mdl: LoadModelFromMesh msh, mdl

' NOTE: By default each cube is mapped to one part of texture atlas
DIM AS Texture tex: LoadTexture "assets/image/cubicmap_atlas.png", tex ' Load map texture
DIM AS Material matrl: PeekType mdl.materials, 0, _OFFSET(matrl), LEN(matrl)
DIM AS MaterialMap matrlmap: PeekType matrl.maps, MATERIAL_MAP_DIFFUSE, _OFFSET(matrlmap), LEN(matrlmap)
matrlmap.tex = tex: PokeType matrl.maps, MATERIAL_MAP_DIFFUSE, _OFFSET(matrlmap), LEN(matrlmap) ' Set map diffuse texture

' Get map image data to be used for collision detection
DIM AS _UNSIGNED _OFFSET mapPixels: mapPixels = LoadImageColors(imMap)
UnloadImage imMap ' Unload image from RAM

DIM AS Vector3 mapPosition: mapPosition.x = -16.0!: mapPosition.y = 0.0!: mapPosition.z = -8.0! ' Set model position

DisableCursor ' Limit cursor to relative movement inside the window

SetTargetFPS 60 ' Set our game to run at 60 frames-per-second

DO UNTIL WindowShouldClose
    DIM AS Vector3 oldCamPos: oldCamPos = camera.position ' Store old camera position

    UpdateCamera camera, CAMERA_FIRST_PERSON

    ' Check player collision (we simplify to 2D collision detection)
    DIM AS Vector2 playerPos: playerPos.x = camera.position.x: playerPos.y = camera.position.z
    DIM AS SINGLE playerRadius: playerRadius = 0.1! ' Collision radius (player is modelled as a cilinder for collision)

    DIM AS LONG playerCellX: playerCellX = playerPos.x - mapPosition.x + 0.5!
    DIM AS LONG playerCellY: playerCellY = playerPos.y - mapPosition.z + 0.5!

    ' Out-of-limits security check
    IF playerCellX < 0 THEN
        playerCellX = 0
    ELSEIF playerCellX >= cubicmap.W THEN
        playerCellX = cubicmap.W - 1
    END IF

    IF playerCellY < 0 THEN
        playerCellY = 0
    ELSEIF playerCellY >= cubicmap.H THEN
        playerCellY = cubicmap.H - 1
    END IF

    ' Check map collisions using image data and player position
    ' TODO: Improvement: Just check player surrounding cells for collision
    DIM AS LONG x, y
    DIM r AS Rectangle
    FOR y = 0 TO cubicmap.H - 1
        FOR x = 0 TO cubicmap.W - 1
            IF GetRed(PeekLong(mapPixels, y * cubicmap.W + x)) = 255 THEN ' Collision: white pixel, only check R channel
                r.x = mapPosition.x - 0.5! + x * 1.0!: r.y = mapPosition.z - 0.5! + y * 1.0!: r.W = 1.0!: r.H = 1.0!
                IF CheckCollisionCircleRec(playerPos, playerRadius, r) THEN
                    ' Collision detected, reset camera position
                    camera.position = oldCamPos
                END IF
            END IF
        NEXT
    NEXT

    BeginDrawing

    ClearBackground RAYWHITE

    BeginMode3D camera
    DrawModel mdl, mapPosition, 1.0!, WHITE ' Draw maze map
    EndMode3D

    DIM v2 AS Vector2: v2.x = GetScreenWidth - cubicmap.W * 4.0! - 20: v2.y = 20.0!
    DrawTextureEx cubicmap, v2, 0.0!, 4.0!, WHITE
    DrawRectangleLines GetScreenWidth - cubicmap.W * 4 - 20, 20, cubicmap.W * 4, cubicmap.H * 4, GREEN

    ' Draw player position radar
    DrawRectangle GetScreenWidth - cubicmap.W * 4 - 20 + playerCellX * 4, 20 + playerCellY * 4, 4, 4, RED

    DrawFPS 10, 10

    EndDrawing
LOOP

' De-Initialization
UnloadImageColors mapPixels ' Unload color array
UnloadTexture cubicmap ' Unload cubicmap texture
UnloadTexture tex ' Unload map texture
UnloadModel mdl ' Unload map model
CloseWindow ' Close window and OpenGL context

SYSTEM

'$INCLUDE:'include/raylib.bas'
