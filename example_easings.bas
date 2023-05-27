' raylib [shapes] example - easings box anim

'$INCLUDE:'include/raylib.bi'
'$INCLUDE:'include/reasings.bi'

Const screenWidth = 800
Const screenHeight = 450

InitWindow screenWidth, screenHeight, "raylib [shapes] example - easings box anim"

Dim rec As Rectangle: rec.x = GetScreenWidth / 2.0!: rec.y = -100: rec.w = 100: rec.h = 100
Dim rotation As Single
Dim alpha As Single: alpha = 1.0!
Dim vec As Vector2

Dim state As Long
Dim framesCounter As Long

SetTargetFPS 60

Do Until WindowShouldClose
    ' Update
    Select Case state
        Case 0 ' Move box down to center of screen
            framesCounter = framesCounter + 1

            ' NOTE: Remember that 3rd parameter of easing function refers to desired value variation, do not confuse it with expected final value!
            rec.y = EaseElasticOut(framesCounter, -100, GetScreenHeight / 2.0! + 100, 120)

            If framesCounter >= 120 Then
                framesCounter = 0
                state = 1
            End If

        Case 1 ' Scale box to an horizontal bar
            framesCounter = framesCounter + 1
            rec.h = EaseBounceOut(framesCounter, 100, -90, 120)
            rec.w = EaseBounceOut(framesCounter, 100, GetScreenWidth, 120)

            If framesCounter >= 120 Then
                framesCounter = 0
                state = 2
            End If

        Case 2 ' Rotate horizontal bar rectangle
            framesCounter = framesCounter + 1
            rotation = EaseQuadOut(framesCounter, 0.0!, 270.0!, 240)

            If framesCounter >= 240 Then
                framesCounter = 0
                state = 3
            End If

        Case 3 ' Increase bar size to fill all screen
            framesCounter = framesCounter + 1
            rec.h = EaseCircOut(framesCounter, 10, GetScreenWidth, 120)

            If framesCounter >= 120 Then
                framesCounter = 0
                state = 4
            End If

        Case 4 ' Fade out animation
            framesCounter = framesCounter + 1
            alpha = EaseSineOut(framesCounter, 1.0!, -1.0!, 160)

            If framesCounter >= 160 Then
                framesCounter = 0
                state = 5
            End If
    End Select

    ' Reset animation at any moment
    If IsKeyPressed(KEY_SPACE) Then
        rec.x = GetScreenWidth / 2.0!: rec.y = -100: rec.w = 100: rec.h = 100
        rotation = 0.0!
        alpha = 1.0!
        state = 0
        framesCounter = 0
    End If

    ' Draw
    BeginDrawing

    ClearBackground RAYWHITE

    vec.x = rec.w / 2: vec.y = rec.h / 2
    DrawRectanglePro rec, vec, rotation, Fade(BLACK, alpha)

    DrawText "PRESS [SPACE] TO RESET BOX ANIMATION!", 10, GetScreenHeight - 25, 20, LIGHTGRAY

    EndDrawing
Loop

CloseWindow

System

'$INCLUDE:'include/raylib.bas'
