'---------------------------------------------------------------------------------------------------------------------------------------------------------------
'
' raylib [shapes] example - easings box anim
'
' Example originally created with raylib 2.5, last time updated with raylib 2.5
'
' Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
' BSD-like license that allows static linking with closed source software
'
' Copyright (c) 2014-2022 Ramon Santamaria (@raysan5)
'
' QB64-PE port by Samuel Gomes
'
'---------------------------------------------------------------------------------------------------------------------------------------------------------------

'---------------------------------------------------------------------------------------------------------------------------------------------------------------
' HEADER FILES
'---------------------------------------------------------------------------------------------------------------------------------------------------------------
'$include:'./reasings.bi'
'---------------------------------------------------------------------------------------------------------------------------------------------------------------

'---------------------------------------------------------------------------------------------------------------------------------------------------------------
' CONSTANTS
'---------------------------------------------------------------------------------------------------------------------------------------------------------------
Const SCREENWIDTH = 800
Const SCREENHEIGHT = 450
'---------------------------------------------------------------------------------------------------------------------------------------------------------------

'---------------------------------------------------------------------------------------------------------------------------------------------------------------
' USER DEFINED TYPES
'---------------------------------------------------------------------------------------------------------------------------------------------------------------
' Vector2, 2 components
Type Vector2
    x As Single ' Vector x component
    y As Single ' Vector y component
End Type

Type Rectangle
    x As Single ' Rectangle top-left corner position x
    y As Single ' Rectangle top-left corner position y
    w As Single ' Rectangle width
    h As Single ' Rectangle height
End Type
'---------------------------------------------------------------------------------------------------------------------------------------------------------------

'---------------------------------------------------------------------------------------------------------------------------------------------------------------
' PROGRAM ENTRY POINT
'---------------------------------------------------------------------------------------------------------------------------------------------------------------
Screen NewImage(SCREENWIDTH, SCREENHEIGHT, 32)
Title "raylib [shapes] example - easings box anim"

Dim Shared gRec As Rectangle: gRec.x = Width / 2.0!: gRec.y = -100: gRec.w = 100: gRec.h = 100
Dim Shared gVec As Vector2
Dim Shared gRotation As Single
Dim Shared gCAlpha As Single: gCAlpha = 1.0!
Dim state As Long
Dim framesCounter As Long

' Main game loop
While Not KeyDown(KEY_ESCAPE) ' Detect ESC key
    ' Update
    Select Case state
        Case 0 ' Move box down to center of screen
            framesCounter = framesCounter + 1

            ' NOTE: Remember that 3rd parameter of easing function refers to desired value variation, do not confuse it with expected final value!
            gRec.y = EaseElasticOut(framesCounter, -100, Height / 2.0! + 100, 120)

            If framesCounter >= 120 Then
                framesCounter = 0
                state = 1
            End If

        Case 1 ' Scale box to an horizontal bar

            framesCounter = framesCounter + 1
            gRec.h = EaseBounceOut(framesCounter, 100, -90, 120)
            gRec.w = EaseBounceOut(framesCounter, 100, Width, 120)

            If framesCounter >= 120 Then
                framesCounter = 0
                state = 2
            End If

        Case 2 ' Rotate horizontal bar rectangle

            framesCounter = framesCounter + 1
            gRotation = EaseQuadOut(framesCounter, 0.0!, 270.0!, 240)

            If framesCounter >= 240 Then
                framesCounter = 0
                state = 3
            End If

        Case 3 ' Increase bar size to fill all screen

            framesCounter = framesCounter + 1
            gRec.h = EaseCircOut(framesCounter, 10, Width, 120)

            If (framesCounter >= 120) Then
                framesCounter = 0
                state = 4
            End If

        Case 4 ' Fade out animation

            framesCounter = framesCounter + 1
            gCAlpha = EaseSineOut(framesCounter, 1.0!, -1.0!, 160)

            If framesCounter >= 160 Then
                framesCounter = 0
                state = 5
            End If
    End Select

    ' Reset animation at any moment
    If KeyDown(KEY_SPACE_BAR) Then
        gRec.x = Width / 2.0!: gRec.y = -100: gRec.w = 100: gRec.h = 100
        gRotation = 0.0!
        gCAlpha = 1.0!
        state = 0
        framesCounter = 0
    End If

    ' Draw
    Cls , White

    gVec.x = gRec.w / 2: gVec.y = gRec.h / 2
    DrawRectanglePro gRec, gVec, gRotation, RGBA32(0, 0, 0, gCAlpha * 255)

    Color Gray, White
    PrintString (20, Height - 25), "PRESS [SPACE] TO RESET BOX ANIMATION!"

    Display

    Limit 60 ' Set our game to run at 60 frames-per-second
Wend

AutoDisplay
System
'---------------------------------------------------------------------------------------------------------------------------------------------------------------

'---------------------------------------------------------------------------------------------------------------------------------------------------------------
' FUNCTIONS AND SUBROUTINES
'---------------------------------------------------------------------------------------------------------------------------------------------------------------
' Draw a color-filled rectangle with pro parameters
' Lazy implementation for this demo only. Do not use in production code!
Sub DrawRectanglePro (rect As Rectangle, origin As Vector2, rotation As Single, fcolor As Unsigned Long)
    Dim As Vector2 topLeft, topRight, bottomLeft, bottomRight
    Dim As Single x, y

    Dim sinRotation As Single: sinRotation = Sin(D2R(rotation))
    Dim cosRotation As Single: cosRotation = Cos(D2R(rotation))
    x = rect.x
    y = rect.y
    Dim dx As Single: dx = -origin.x
    Dim dy As Single: dy = -origin.y

    topLeft.x = x + dx * cosRotation - dy * sinRotation
    topLeft.y = y + dx * sinRotation + dy * cosRotation

    topRight.x = x + (dx + rect.w) * cosRotation - dy * sinRotation
    topRight.y = y + (dx + rect.w) * sinRotation + dy * cosRotation

    bottomLeft.x = x + dx * cosRotation - (dy + rect.h) * sinRotation
    bottomLeft.y = y + dx * sinRotation + (dy + rect.h) * cosRotation

    bottomRight.x = x + (dx + rect.w) * cosRotation - (dy + rect.h) * sinRotation
    bottomRight.y = y + (dx + rect.w) * sinRotation + (dy + rect.h) * cosRotation

    Line (topLeft.x, topLeft.y)-(topRight.x, topRight.y), fcolor
    Line (topRight.x, topRight.y)-(bottomRight.x, bottomRight.y), fcolor
    Line (bottomRight.x, bottomRight.y)-(bottomLeft.x, bottomLeft.y), fcolor
    Line (bottomLeft.x, bottomLeft.y)-(topLeft.x, topLeft.y), fcolor
    Paint (x, y), fcolor, fcolor
End Sub
'---------------------------------------------------------------------------------------------------------------------------------------------------------------
'---------------------------------------------------------------------------------------------------------------------------------------------------------------

