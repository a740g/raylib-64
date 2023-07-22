' raylib [audio] example - Module playing (streaming)

'$INCLUDE:'include/raylib.bi'

CONST MAX_CIRCLES = 64

TYPE CircleWave
    position AS Vector2
    radius AS SINGLE
    alpha AS SINGLE
    speed AS SINGLE
    clr AS _UNSIGNED LONG ' color (DWORD)
END TYPE

CONST ScreenWidth = 800
CONST ScreenHeight = 450

SetConfigFlags FLAG_MSAA_4X_HINT ' NOTE: Try to enable MSAA 4X

InitWindow ScreenWidth, ScreenHeight, "raylib [audio] example - module playing (streaming)"

InitAudioDevice ' Initialize audio device

DIM colors(0 TO 13) AS _UNSIGNED LONG
colors(0) = ORANGE
colors(1) = RED
colors(2) = GOLD
colors(3) = LIME
colors(4) = BLUE
colors(5) = VIOLET
colors(6) = BROWN
colors(7) = LIGHTGRAY
colors(8) = PINK
colors(9) = YELLOW
colors(10) = GREEN
colors(11) = SKYBLUE
colors(12) = PURPLE
colors(13) = BEIGE

' Creates some circles for visual effect
DIM circles(0 TO MAX_CIRCLES) AS CircleWave

DIM i AS LONG
FOR i = 0 TO MAX_CIRCLES - 1
    circles(i).alpha = 0
    circles(i).radius = GetRandomValue(10, 40)
    circles(i).position.x = GetRandomValue(circles(i).radius, ScreenWidth - circles(i).radius)
    circles(i).position.y = GetRandomValue(circles(i).radius, ScreenHeight - circles(i).radius)
    circles(i).speed = GetRandomValue(1, 100) / 2000!
    circles(i).clr = colors(GetRandomValue(0, 13))
NEXT

DIM mus AS Music: LoadMusicStream "assets/audio/mini1111.xm", mus

mus.looping = FALSE
DIM pitch AS SINGLE: pitch = 1

PlayMusicStream mus

DIM timePlayed AS SINGLE
DIM pause AS _BYTE

SetTargetFPS 60 ' Set our game to run at 60 frames-per-second

DO UNTIL WindowShouldClose
    UpdateMusicStream mus ' Update music buffer with new stream data

    ' Restart music playing (stop and play)
    IF IsKeyPressed(KEY_SPACE) THEN
        StopMusicStream mus
        PlayMusicStream mus
    END IF

    ' Pause/Resume music playing
    IF IsKeyPressed(KEY_P) THEN
        pause = NOT pause
        IF (pause) THEN PauseMusicStream mus ELSE ResumeMusicStream mus
    END IF

    IF IsKeyDown(KEY_DOWN) THEN
        pitch = pitch - 0.01!
    ELSEIF IsKeyDown(KEY_UP) THEN
        pitch = pitch + 0.01!
    END IF

    SetMusicPitch mus, pitch

    ' Get timePlayed scaled to bar dimensions
    timePlayed = GetMusicTimePlayed(mus) / GetMusicTimeLength(mus) * (ScreenWidth - 40)

    ' Color circles animation
    FOR i = MAX_CIRCLES - 1 TO 0 STEP -1
        IF pause THEN EXIT FOR

        circles(i).alpha = circles(i).alpha + circles(i).speed
        circles(i).radius = circles(i).radius + circles(i).speed * 10!

        IF circles(i).alpha > 1.0! THEN circles(i).speed = circles(i).speed * -1

        IF circles(i).alpha <= 0 THEN
            circles(i).alpha = 0
            circles(i).radius = GetRandomValue(10, 40)
            circles(i).position.x = GetRandomValue(circles(i).radius, ScreenWidth - circles(i).radius)
            circles(i).position.y = GetRandomValue(circles(i).radius, ScreenHeight - circles(i).radius)
            circles(i).clr = colors(GetRandomValue(0, 13))
            circles(i).speed = GetRandomValue(1, 100) / 2000!
        END IF
    NEXT

    BeginDrawing

    ClearBackground RAYWHITE

    FOR i = MAX_CIRCLES - 1 TO 0 STEP -1
        DrawCircleV circles(i).position, circles(i).radius, Fade(circles(i).clr, circles(i).alpha)
    NEXT

    ' Draw time bar
    DrawRectangle 20, ScreenHeight - 20 - 12, ScreenWidth - 40, 12, LIGHTGRAY
    DrawRectangle 20, ScreenHeight - 20 - 12, timePlayed, 12, MAROON
    DrawRectangleLines 20, ScreenHeight - 20 - 12, ScreenWidth - 40, 12, GRAY

    EndDrawing
LOOP

UnloadMusicStream mus ' Unload music stream buffers from RAM

CloseAudioDevice ' Close audio device (music streaming is automatically stopped)

CloseWindow

SYSTEM


'$INCLUDE:'include/raylib.bas'
