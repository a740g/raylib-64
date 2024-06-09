'*******************************************************************************************
'
'   raylib [core] example - 2D Camera platformer
'
'   Example originally created with raylib 2.5, last time updated with raylib 3.0
'
'   Example contributed by arvyy (@arvyy) and reviewed by Ramon Santamaria (@raysan5)
'
'   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
'   BSD-like license that allows static linking with closed source software
'
'   Copyright (c) 2019-2024 arvyy (@arvyy)
'
'*******************************************************************************************

'$INCLUDE:'include/raylib.bi'
'$INCLUDE:'include/raymath.bi'

CONST G& = 400&
CONST PLAYER_JUMP_SPD! = 350!
CONST PLAYER_HOR_SPD! = 200!

TYPE Player
    AS Vector2 position
    AS SINGLE speed
    AS _BYTE canJump
END TYPE

TYPE EnvItem
    AS Rectangle rect
    AS _BYTE blocking
    AS _UNSIGNED LONG clr
END TYPE

'------------------------------------------------------------------------------------
' Program main entry point
'------------------------------------------------------------------------------------
' Initialization
'--------------------------------------------------------------------------------------
CONST screenWidth& = 800&
CONST screenHeight& = 450&

InitWindow screenWidth, screenHeight, "raylib [core] example - 2d camera"

DIM player AS Player
SetVector2 player.position, 400, 280
player.speed = 0
player.canJump = FALSE

DIM envItems(0 TO 4) AS EnvItem

SetRectangle envItems(0).rect, 0, 0, 1000, 400
envItems(0).blocking = FALSE
envItems(0).clr = LIGHTGRAY

SetRectangle envItems(1).rect, 0, 400, 1000, 200
envItems(1).blocking = TRUE
envItems(1).clr = GRAY

SetRectangle envItems(2).rect, 300, 200, 400, 10
envItems(2).blocking = TRUE
envItems(2).clr = GRAY

SetRectangle envItems(3).rect, 250, 300, 100, 10
envItems(3).blocking = TRUE
envItems(3).clr = GRAY

SetRectangle envItems(4).rect, 650, 300, 100, 10
envItems(4).blocking = TRUE
envItems(4).clr = GRAY

DIM envItemsLength AS LONG: envItemsLength = UBOUND(envItems)

DIM camera AS Camera2D
camera.target = player.position
SetVector2 camera.Roffset, screenWidth / 2!, screenHeight / 2!
camera.zoom = 1!

CONST cameraUpdatersLength& = 5&

DIM cameraOption AS LONG

DIM cameraDescriptions(0 TO cameraUpdatersLength - 1) AS STRING

cameraDescriptions(0) = "Follow player center"
cameraDescriptions(1) = "Follow player center, but clamp to map edges"
cameraDescriptions(2) = "Follow player center; smoothed"
cameraDescriptions(3) = "Follow player center horizontally; update player center vertically after landing"
cameraDescriptions(4) = "Player push camera on getting too close to screen edge"

SetTargetFPS 60
'--------------------------------------------------------------------------------------

' Main game loop
WHILE NOT WindowShouldClose
    ' Update
    '----------------------------------------------------------------------------------
    DIM deltaTime AS SINGLE: deltaTime = GetFrameTime

    UpdatePlayer player, envItems(), envItemsLength, deltaTime

    camera.zoom = camera.zoom + GetMouseWheelMove * 0.05!
    camera.zoom = Clamp(camera.zoom, 0.25!, 3!)

    IF IsKeyPressed(KEY_R) THEN
        camera.zoom = 1!
        SetVector2 player.position, 400, 280
    END IF

    IF IsKeyPressed(KEY_C) THEN cameraOption = (cameraOption + 1) MOD cameraUpdatersLength

    ' Call update camera function
    SELECT CASE cameraOption
        CASE 1
            UpdateCameraCenterInsideMap camera, player, envItems(), envItemsLength, screenWidth, screenHeight
        CASE 2
            UpdateCameraCenterSmoothFollow camera, player, deltaTime, screenWidth, screenHeight
        CASE 3
            UpdateCameraEvenOutOnLanding camera, player, deltaTime, screenWidth, screenHeight
        CASE 4
            UpdateCameraPlayerBoundsPush camera, player, screenWidth, screenHeight
        CASE ELSE
            UpdateCameraCenter camera, player, screenWidth, screenHeight
    END SELECT
    '----------------------------------------------------------------------------------

    ' Draw
    '----------------------------------------------------------------------------------
    BeginDrawing

    ClearBackground LIGHTGRAY

    BeginMode2D camera

    DIM i AS LONG: FOR i = 0 TO envItemsLength
        DrawRectangleRec envItems(i).rect, envItems(i).clr
    NEXT i

    DIM playerRect AS Rectangle: SetRectangle playerRect, player.position.x - 20, player.position.y - 40, 40, 40
    DrawRectangleRec playerRect, RRED

    DrawCircle player.position.x, player.position.y, 5, GOLD

    EndMode2D

    DrawText "Controls:", 20, 20, 10, BLACK
    DrawText "- Right/Left to move", 40, 40, 10, DARKGRAY
    DrawText "- Space to jump", 40, 60, 10, DARKGRAY
    DrawText "- Mouse Wheel to Zoom in-out, R to reset zoom", 40, 80, 10, DARKGRAY
    DrawText "- C to change camera mode", 40, 100, 10, DARKGRAY
    DrawText "Current camera mode:", 20, 120, 10, BLACK
    DrawText cameraDescriptions(cameraOption), 40, 140, 10, DARKGRAY

    EndDrawing
    '----------------------------------------------------------------------------------
WEND

' De-Initialization
'--------------------------------------------------------------------------------------
CloseWindow ' Close window and OpenGL context
'--------------------------------------------------------------------------------------

SYSTEM


SUB UpdatePlayer (player AS Player, envItems() AS EnvItem, envItemsLength AS LONG, delta AS SINGLE)
    IF IsKeyDown(KEY_LEFT) THEN player.position.x = player.position.x - PLAYER_HOR_SPD * delta

    IF IsKeyDown(KEY_RIGHT) THEN player.position.x = player.position.x + PLAYER_HOR_SPD * delta

    IF IsKeyDown(KEY_SPACE) _ANDALSO player.canJump THEN
        player.speed = -PLAYER_JUMP_SPD
        player.canJump = FALSE
    END IF

    DIM hitObstacle AS _BYTE
    DIM i AS LONG: FOR i = 0 TO envItemsLength
        IF envItems(i).blocking _ANDALSO envItems(i).rect.x <= player.position.x _ANDALSO envItems(i).rect.x + envItems(i).rect.Rwidth >= player.position.x _ANDALSO envItems(i).rect.y >= player.position.y _ANDALSO envItems(i).rect.y <= player.position.y + player.speed * delta THEN
            hitObstacle = TRUE
            player.speed = 0!
            player.position.y = envItems(i).rect.y
            EXIT FOR
        END IF
    NEXT i

    IF hitObstacle THEN
        player.canJump = TRUE
    ELSE
        player.position.y = player.position.y + player.speed * delta
        player.speed = player.speed + G * delta
        player.canJump = FALSE
    END IF
END SUB


SUB UpdateCameraCenter (camera AS Camera2D, player AS Player, rwidth AS LONG, rheight AS LONG)
    SetVector2 camera.Roffset, rwidth / 2!, rheight / 2!
    camera.target = player.position
END SUB


SUB UpdateCameraCenterInsideMap (camera AS Camera2D, player AS Player, envItems() AS EnvItem, envItemsLength AS LONG, rwidth AS LONG, rheight AS LONG)
    camera.target = player.position
    SetVector2 camera.Roffset, rwidth / 2!, rheight / 2!
    DIM AS SINGLE minX, minY, maxX, maxY: minX = 1000: minY = 1000: maxX = -1000: maxY = -1000

    DIM i AS LONG: FOR i = 0 TO envItemsLength
        minX = MinSingle(envItems(i).rect.x, minX)
        maxX = MaxSingle(envItems(i).rect.x + envItems(i).rect.Rwidth, maxX)
        minY = MinSingle(envItems(i).rect.y, minY)
        maxY = MaxSingle(envItems(i).rect.y + envItems(i).rect.Rheight, maxY)
    NEXT i

    DIM AS Vector2 tmp, max, min
    SetVector2 tmp, maxX, maxY
    GetWorldToScreen2D tmp, camera, max
    SetVector2 tmp, minX, minY
    GetWorldToScreen2D tmp, camera, min

    IF max.x < rwidth THEN camera.Roffset.x = rwidth - (max.x - rwidth / 2!)
    IF max.y < rheight THEN camera.Roffset.y = rheight - (max.y - rheight / 2!)
    IF min.x > 0 THEN camera.Roffset.x = rwidth / 2! - min.x
    IF min.y > 0 THEN camera.Roffset.y = rheight / 2! - min.y
END SUB


SUB UpdateCameraCenterSmoothFollow (camera AS Camera2D, player AS Player, delta AS SINGLE, rwidth AS LONG, rheight AS LONG)
    STATIC initDone AS _BYTE
    STATIC AS SINGLE minSpeed, minEffectLength, fractionSpeed

    IF NOT initDone THEN
        minSpeed = 30!
        minEffectLength = 10!
        fractionSpeed = 0.8!
        initDone = TRUE
    END IF

    SetVector2 camera.Roffset, rwidth / 2!, rheight / 2!
    DIM diff AS Vector2
    Vector2Subtract player.position, camera.target, diff
    DIM length AS SINGLE: length = Vector2Length(diff)

    IF length > minEffectLength THEN
        DIM speed AS SINGLE: speed = MaxSingle(fractionSpeed * length, minSpeed)
        DIM tmp AS Vector2: Vector2Scale diff, speed * delta / length, tmp
        Vector2Add camera.target, tmp, camera.target
    END IF
END SUB


SUB UpdateCameraEvenOutOnLanding (camera AS Camera2D, player AS Player, delta AS SINGLE, rwidth AS LONG, rheight AS LONG)
    STATIC initDone AS _BYTE, eveningOut AS _BYTE
    DIM AS SINGLE evenOutSpeed, evenOutTarget

    IF NOT initDone THEN
        evenOutSpeed = 700!
        eveningOut = FALSE
        initDone = TRUE
    END IF

    SetVector2 camera.Roffset, rwidth / 2!, rheight / 2!
    camera.target.x = player.position.x

    IF eveningOut THEN
        IF evenOutTarget > camera.target.y THEN
            camera.target.y = camera.target.y + evenOutSpeed * delta

            IF camera.target.y > evenOutTarget THEN
                camera.target.y = evenOutTarget
                eveningOut = FALSE
            END IF
        ELSE
            camera.target.y = camera.target.y - evenOutSpeed * delta

            IF camera.target.y < evenOutTarget THEN
                camera.target.y = evenOutTarget
                eveningOut = FALSE
            END IF
        END IF
    ELSE
        IF player.canJump _ANDALSO player.speed = 0 _ANDALSO player.position.y <> camera.target.y THEN
            eveningOut = TRUE
            evenOutTarget = player.position.y
        END IF
    END IF
END SUB


SUB UpdateCameraPlayerBoundsPush (camera AS Camera2D, player AS Player, rwidth AS LONG, rheight AS LONG)
    STATIC initDone AS _BYTE
    STATIC bbox AS Vector2

    IF NOT initDone THEN
        SetVector2 bbox, 0.2!, 0.2!
        initDone = TRUE
    END IF

    DIM AS Vector2 tmp, bboxWorldMin, bboxWorldMax

    SetVector2 tmp, (1 - bbox.x) * 0.5! * rwidth, (1 - bbox.y) * 0.5! * rheight
    GetScreenToWorld2D tmp, camera, bboxWorldMin
    SetVector2 tmp, (1 + bbox.x) * 0.5! * rwidth, (1 + bbox.y) * 0.5! * rheight
    GetScreenToWorld2D tmp, camera, bboxWorldMax
    SetVector2 camera.Roffset, (1 - bbox.x) * 0.5! * rwidth, (1 - bbox.y) * 0.5! * rheight

    IF player.position.x < bboxWorldMin.x THEN camera.target.x = player.position.x
    IF player.position.y < bboxWorldMin.y THEN camera.target.y = player.position.y
    IF player.position.x > bboxWorldMax.x THEN camera.target.x = bboxWorldMin.x + (player.position.x - bboxWorldMax.x)
    IF player.position.y > bboxWorldMax.y THEN camera.target.y = bboxWorldMin.y + (player.position.y - bboxWorldMax.y)
END SUB

'$INCLUDE:'include/raylib.bas'
