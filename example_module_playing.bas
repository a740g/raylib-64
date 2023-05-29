' raylib [audio] example - Module playing (streaming)

'$INCLUDE:'include/raylib.bi'

Const MAX_CIRCLES = 64

Type CircleWave
    position As Vector2
    radius As Single
    alpha As Single
    speed As Single
    clr As _Unsigned Long ' color (DWORD)
End Type

Const ScreenWidth = 800
Const ScreenHeight = 450

SetConfigFlags FLAG_MSAA_4X_HINT ' NOTE: Try to enable MSAA 4X

InitWindow ScreenWidth, ScreenHeight, "raylib [audio] example - module playing (streaming)"

InitAudioDevice ' Initialize audio device

Dim colors(0 To 13) As _Unsigned Long
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
Dim circles(0 To MAX_CIRCLES) As CircleWave

Dim i As Long
For i = 0 To MAX_CIRCLES - 1
    circles(i).alpha = 0
    circles(i).radius = GetRandomValue(10, 40)
    circles(i).position.x = GetRandomValue(circles(i).radius, ScreenWidth - circles(i).radius)
    circles(i).position.y = GetRandomValue(circles(i).radius, ScreenHeight - circles(i).radius)
    circles(i).speed = GetRandomValue(1, 100) / 2000!
    circles(i).clr = colors(GetRandomValue(0, 13))
Next

Dim mus As Music: LoadMusicStream "assets/audio/mini1111.xm", mus

mus.looping = FALSE
Dim pitch As Single: pitch = 1

PlayMusicStream mus

Dim timePlayed As Single
Dim pause As _Byte

SetTargetFPS 60 ' Set our game to run at 60 frames-per-second

Do Until WindowShouldClose
    UpdateMusicStream mus ' Update music buffer with new stream data

    ' Restart music playing (stop and play)
    If IsKeyPressed(KEY_SPACE) Then
        StopMusicStream mus
        PlayMusicStream mus
    End If

    ' Pause/Resume music playing
    If IsKeyPressed(KEY_P) Then
        pause = Not pause
        If (pause) Then PauseMusicStream mus Else ResumeMusicStream mus
    End If

    If IsKeyDown(KEY_DOWN) Then
        pitch = pitch - 0.01!
    ElseIf IsKeyDown(KEY_UP) Then
        pitch = pitch + 0.01!
    End If

    SetMusicPitch mus, pitch

    ' Get timePlayed scaled to bar dimensions
    timePlayed = GetMusicTimePlayed(mus) / GetMusicTimeLength(mus) * (ScreenWidth - 40)

    ' Color circles animation
    For i = MAX_CIRCLES - 1 To 0 Step -1
        If pause Then Exit For

        circles(i).alpha = circles(i).alpha + circles(i).speed
        circles(i).radius = circles(i).radius + circles(i).speed * 10!

        If circles(i).alpha > 1.0! Then circles(i).speed = circles(i).speed * -1

        If circles(i).alpha <= 0 Then
            circles(i).alpha = 0
            circles(i).radius = GetRandomValue(10, 40)
            circles(i).position.x = GetRandomValue(circles(i).radius, ScreenWidth - circles(i).radius)
            circles(i).position.y = GetRandomValue(circles(i).radius, ScreenHeight - circles(i).radius)
            circles(i).clr = colors(GetRandomValue(0, 13))
            circles(i).speed = GetRandomValue(1, 100) / 2000!
        End If
    Next

    BeginDrawing

    ClearBackground RAYWHITE

    For i = MAX_CIRCLES - 1 To 0 Step -1
        DrawCircleV circles(i).position, circles(i).radius, Fade(circles(i).clr, circles(i).alpha)
    Next

    ' Draw time bar
    DrawRectangle 20, ScreenHeight - 20 - 12, ScreenWidth - 40, 12, LIGHTGRAY
    DrawRectangle 20, ScreenHeight - 20 - 12, timePlayed, 12, MAROON
    DrawRectangleLines 20, ScreenHeight - 20 - 12, ScreenWidth - 40, 12, GRAY

    EndDrawing
Loop

UnloadMusicStream mus ' Unload music stream buffers from RAM

CloseAudioDevice ' Close audio device (music streaming is automatically stopped)

CloseWindow

System

'$INCLUDE:'include/raylib.bas'
