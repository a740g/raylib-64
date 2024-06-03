'*******************************************************************************************
'
'   raylib [core] example - Generates a random sequence
'
'   Example originally created with raylib 5.0, last time updated with raylib 5.0
'
'   Example contributed by Dalton Overmyer (@REDl3east) and reviewed by Ramon Santamaria (@raysan5)
'
'   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
'   BSD-like license that allows static linking with closed source software
'
'   Copyright (c) 2023 Dalton Overmyer (@REDl3east)
'
'*******************************************************************************************

' a740g: LoadRandomSequence() is buggy and returns out-of-range values (negative numbers in this case)
' See https://github.com/raysan5/raylib/issues/3794
' This should be reported to raysan5 with a suitable C example

'$INCLUDE:'include/raylib.bi'
'$INCLUDE:'include/raymath.bi'

TYPE ColorRect
    AS _UNSIGNED LONG c
    AS Rectangle r
END TYPE

'------------------------------------------------------------------------------------
' Program main entry point
'------------------------------------------------------------------------------------
' Initialization
'--------------------------------------------------------------------------------------
CONST screenWidth& = 800
CONST screenHeight& = 450
CONST fontSize& = 20

InitWindow screenWidth, screenHeight, "raylib [core] example - Generates a random sequence"

DIM rectCount AS LONG: rectCount = 20
DIM rectSize AS SINGLE: rectSize = screenWidth / rectCount
REDIM rectangles(0 TO 0) AS ColorRect
GenerateRandomColorRectSequence rectCount, rectSize, screenWidth, 0.75! * screenHeight, rectangles()

SetTargetFPS 60
'--------------------------------------------------------------------------------------

' Main game loop
WHILE NOT WindowShouldClose ' Detect window close button or ESC key
    ' Update
    '----------------------------------------------------------------------------------

    IF IsKeyPressed(KEY_SPACE) THEN
        ShuffleColorRectSequence rectangles(), rectCount
    END IF

    IF (IsKeyPressed(KEY_UP)) THEN
        rectCount = rectCount + 1
        rectSize = screenWidth / rectCount
        REDIM rectangles(0 TO 0) AS ColorRect
        GenerateRandomColorRectSequence rectCount, rectSize, screenWidth, 0.75! * screenHeight, rectangles()
    END IF

    IF (IsKeyPressed(KEY_DOWN)) THEN
        IF rectCount >= 4 THEN
            rectCount = rectCount - 1
            rectSize = screenWidth / rectCount
            REDIM rectangles(0 TO 0) AS ColorRect
            GenerateRandomColorRectSequence rectCount, rectSize, screenWidth, 0.75! * screenHeight, rectangles()
        END IF
    END IF

    ' Draw
    '----------------------------------------------------------------------------------
    BeginDrawing

    ClearBackground RAYWHITE

    DIM x AS LONG: FOR x = 0 TO rectCount - 1
        DrawRectangleRec rectangles(x).r, rectangles(x).c
        DrawTextCenterKeyHelp "SPACE", "to shuffle the sequence.", 10, screenHeight - 96, fontSize, BLACK
        DrawTextCenterKeyHelp "UP", "to add a rectangle and generate a new sequence.", 10, screenHeight - 64, fontSize, BLACK
        DrawTextCenterKeyHelp "DOWN", "to remove a rectangle and generate a new sequence.", 10, screenHeight - 32, fontSize, BLACK
    NEXT x

    DIM rectCountText AS STRING: rectCountText = TextFormatLong("%d rectangles", rectCount)
    DIM rectCountTextSize AS LONG: rectCountTextSize = MeasureText(rectCountText, fontSize)
    DrawText rectCountText, screenWidth - rectCountTextSize - 10, 10, fontSize, BLACK

    DrawFPS 10, 10

    EndDrawing
    '----------------------------------------------------------------------------------
WEND

' De-Initialization
'--------------------------------------------------------------------------------------

CloseWindow ' Close window and OpenGL context
'--------------------------------------------------------------------------------------

SYSTEM


FUNCTION GenerateRandomColor~&
    GenerateRandomColor = ToRGBA(GetRandomValue(0, 255), GetRandomValue(0, 255), GetRandomValue(0, 255), 255)
END FUNCTION


SUB GenerateRandomColorRectSequence (rectCount AS SINGLE, rectWidth AS SINGLE, screenWidth AS SINGLE, screenHeight AS SINGLE, rectangles() AS ColorRect)
    DIM seq AS _UNSIGNED _OFFSET: seq = LoadRandomSequence(rectCount, 0, rectCount - 1)
    REDIM rectangles(0 TO rectCount - 1) AS ColorRect

    DIM rectSeqWidth AS SINGLE: rectSeqWidth = rectCount * rectWidth
    DIM startX AS LONG: startX = (screenWidth - rectSeqWidth) * 0.5!

    DIM x AS LONG: FOR x = 0 TO rectCount - 1
        DIM rectHeight AS LONG: rectHeight = Remap(PeekLong(seq, x), 0, rectCount - 1, 0, screenHeight)
        rectangles(x).c = GenerateRandomColor
        SetRectangle rectangles(x).r, startX + x * rectWidth, screenHeight - rectHeight, rectWidth, rectHeight
    NEXT x

    UnloadRandomSequence seq
END SUB


SUB ShuffleColorRectSequence (rectangles() AS ColorRect, rectCount AS LONG)
    DIM seq AS _UNSIGNED _OFFSET: seq = LoadRandomSequence(rectCount, 0, rectCount - 1)

    DIM r1 AS LONG: FOR r1 = 0 TO rectCount - 1
        DIM r2 AS LONG: r2 = ABS(PeekLong(seq, r1)) ' ABS here is a hack to prevent subscript-out-of-range errors. See bug note on top!

        ' swap only the color and height
        SWAP rectangles(r1).c, rectangles(r2).c
        SWAP rectangles(r1).r.Rheight, rectangles(r2).r.Rheight
        SWAP rectangles(r1).r.y, rectangles(r2).r.y
    NEXT r1

    UnloadRandomSequence seq
END SUB


SUB DrawTextCenterKeyHelp (sKey AS STRING, sText AS STRING, posX AS LONG, posY AS LONG, fontSize AS LONG, clr AS _UNSIGNED LONG)
    DIM spaceSize AS LONG: spaceSize = MeasureText(" ", fontSize)
    DIM pressSize AS LONG: pressSize = MeasureText("Press", fontSize)
    DIM keySize AS LONG: keySize = MeasureText(sKey, fontSize)
    DIM textSize AS LONG: textSize = MeasureText(sText, fontSize)
    DIM totalSize AS LONG: totalSize = pressSize + 2 * spaceSize + keySize + 2 * spaceSize + textSize
    DIM textSizeCurrent AS LONG

    DrawText "Press", posX, posY, fontSize, clr
    textSizeCurrent = textSizeCurrent + pressSize + 2 * spaceSize
    DrawText sKey, posX + textSizeCurrent, posY, fontSize, RRED
    DrawRectangle posX + textSizeCurrent, posY + fontSize, keySize, 3, RRED
    textSizeCurrent = textSizeCurrent + keySize + 2 * spaceSize
    DrawText sText, posX + textSizeCurrent, posY, fontSize, clr
END SUB


'$INCLUDE:'include/raylib.bas'
