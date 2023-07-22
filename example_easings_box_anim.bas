' raylib [shapes] example - easings box anim

'$INCLUDE:'include/raylib.bi'
'$INCLUDE:'include/reasings.bi'

CONST screenWidth = 800
CONST screenHeight = 450

InitWindow screenWidth, screenHeight, "raylib [shapes] example - easings box anim"

DIM rec AS Rectangle: rec.x = GetScreenWidth / 2.0!: rec.y = -100: rec.W = 100: rec.H = 100
DIM rotation AS SINGLE
DIM alpha AS SINGLE: alpha = 1.0!
DIM vec AS Vector2

DIM state AS LONG
DIM framesCounter AS LONG

SetTargetFPS 60

DO UNTIL WindowShouldClose
    ' Update
    SELECT CASE state
        CASE 0 ' Move box down to center of screen
            framesCounter = framesCounter + 1

            ' NOTE: Remember that 3rd parameter of easing function refers to desired value variation, do not confuse it with expected final value!
            rec.y = EaseElasticOut(framesCounter, -100, GetScreenHeight / 2.0! + 100, 120)

            IF framesCounter >= 120 THEN
                framesCounter = 0
                state = 1
            END IF

        CASE 1 ' Scale box to an horizontal bar
            framesCounter = framesCounter + 1
            rec.H = EaseBounceOut(framesCounter, 100, -90, 120)
            rec.W = EaseBounceOut(framesCounter, 100, GetScreenWidth, 120)

            IF framesCounter >= 120 THEN
                framesCounter = 0
                state = 2
            END IF

        CASE 2 ' Rotate horizontal bar rectangle
            framesCounter = framesCounter + 1
            rotation = EaseQuadOut(framesCounter, 0.0!, 270.0!, 240)

            IF framesCounter >= 240 THEN
                framesCounter = 0
                state = 3
            END IF

        CASE 3 ' Increase bar size to fill all screen
            framesCounter = framesCounter + 1
            rec.H = EaseCircOut(framesCounter, 10, GetScreenWidth, 120)

            IF framesCounter >= 120 THEN
                framesCounter = 0
                state = 4
            END IF

        CASE 4 ' Fade out animation
            framesCounter = framesCounter + 1
            alpha = EaseSineOut(framesCounter, 1.0!, -1.0!, 160)

            IF framesCounter >= 160 THEN
                framesCounter = 0
                state = 5
            END IF
    END SELECT

    ' Reset animation at any moment
    IF IsKeyPressed(KEY_SPACE) THEN
        rec.x = GetScreenWidth / 2.0!: rec.y = -100: rec.W = 100: rec.H = 100
        rotation = 0.0!
        alpha = 1.0!
        state = 0
        framesCounter = 0
    END IF

    ' Draw
    BeginDrawing

    ClearBackground RAYWHITE

    vec.x = rec.W / 2: vec.y = rec.H / 2
    DrawRectanglePro rec, vec, rotation, Fade(BLACK, alpha)

    DrawText "PRESS [SPACE] TO RESET BOX ANIMATION!", 10, GetScreenHeight - 25, 20, LIGHTGRAY

    EndDrawing
LOOP

CloseWindow

SYSTEM

'$INCLUDE:'include/raylib.bas'
