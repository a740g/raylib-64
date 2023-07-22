' raylib [textures] example - Background scrolling

'$INCLUDE:'include/raylib.bi'

CONST screenWidth = 800
CONST screenHeight = 450

' Initialization
'--------------------------------------------------------------------------------------
InitWindow screenWidth, screenHeight, "raylib [textures] example - background scrolling"

' NOTE: Be careful, background width must be equal or bigger than screen width
' if not, texture should be draw more than two times for scrolling effect
DIM AS Texture background: LoadTexture "assets/image/cyberpunk_street_background.png", background
DIM AS Texture midground: LoadTexture "assets/image/cyberpunk_street_midground.png", midground
DIM AS Texture foreground: LoadTexture "assets/image/cyberpunk_street_foreground.png", foreground

DIM AS SINGLE scrollingBack, scrollingMid, scrollingFore
DIM v AS Vector2

SetTargetFPS 60 ' Set our game to run at 60 frames-per-second
'--------------------------------------------------------------------------------------

' Main game loop
DO UNTIL WindowShouldClose ' Detect window close button or ESC key
    ' Update
    '----------------------------------------------------------------------------------
    scrollingBack = scrollingBack - 0.1!
    scrollingMid = scrollingMid - 0.5!
    scrollingFore = scrollingFore - 1.0!

    ' NOTE: Texture is scaled twice its size, so it sould be considered on scrolling
    IF scrollingBack <= -background.W * 2 THEN scrollingBack = 0
    IF scrollingMid <= -midground.W * 2 THEN scrollingMid = 0
    IF scrollingFore <= -foreground.W * 2 THEN scrollingFore = 0
    '----------------------------------------------------------------------------------

    ' Draw
    '----------------------------------------------------------------------------------
    BeginDrawing

    ClearBackground GetColor(&H052C46FF)

    ' Draw background image twice
    ' NOTE: Texture is scaled twice its size
    v.x = scrollingBack: v.y = 20: DrawTextureEx background, v, 0.0!, 2.0!, WHITE
    v.x = background.W * 2 + scrollingBack: v.y = 20: DrawTextureEx background, v, 0.0!, 2.0!, WHITE

    ' Draw midground image twice
    v.x = scrollingMid: v.y = 20: DrawTextureEx midground, v, 0.0!, 2.0!, WHITE
    v.x = midground.W * 2 + scrollingMid: v.y = 20: DrawTextureEx midground, v, 0.0!, 2.0!, WHITE

    ' Draw foreground image twice
    v.x = scrollingFore: v.y = 70: DrawTextureEx foreground, v, 0.0!, 2.0!, WHITE
    v.x = foreground.W * 2 + scrollingFore: v.y = 70: DrawTextureEx foreground, v, 0.0!, 2.0!, WHITE

    DrawText "BACKGROUND SCROLLING & PARALLAX", 10, 10, 20, RED
    DrawText "(c) Cyberpunk Street Environment by Luis Zuno (@ansimuz)", screenWidth - 330, screenHeight - 20, 10, RAYWHITE

    EndDrawing
    '----------------------------------------------------------------------------------
LOOP

' De-Initialization
'--------------------------------------------------------------------------------------
UnloadTexture background ' Unload background texture
UnloadTexture midground ' Unload midground texture
UnloadTexture foreground ' Unload foreground texture

CloseWindow ' Close window and OpenGL context
'--------------------------------------------------------------------------------------

SYSTEM

'$INCLUDE:'include/raylib.bas'
