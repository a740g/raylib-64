# raylib for QB64-PE

![raylib](/assets/logo/raylib-q64pe.png)

[raylib for QB64-PE](https://github.com/a740g/raylib-64) is a [QB64-PE](https://github.com/QB64-Phoenix-Edition/QB64pe) binding library for [raylib](https://www.raylib.com).
**raylib is a simple and easy-to-use library to enjoy videogames programming.**

raylib is highly inspired by Borland BGI graphics lib and by XNA framework and it's specially well suited for prototyping, tooling, graphical applications, embedded systems and education.

![Screenshot](assets/screenshots/screenshot1.png)
![Screenshot](assets/screenshots/screenshot2.png)
![Screenshot](assets/screenshots/screenshot3.png)

## SUPPORTED PLATFORMS

| API | Windows (x86-64) | Linux (x86-64) | macOS (x86-64) |
| --- | ---------------- | -------------- | -------------- |
| core | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| reasings | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| raymath | :construction: | :construction: | :construction: |
| rgui | :x: | :x: | :x: |
| physac | :x: | :x: | :x: |

## EXAMPLE

```vb
' raylib [core] example - Basic window

'$INCLUDE:'include/raylib.bi'

Const screenWidth = 800
Const screenHeight = 450

InitWindow screenWidth, screenHeight, "raylib [core] example - basic window"

SetTargetFPS 60

Do Until WindowShouldClose
    BeginDrawing

    ClearBackground RAYWHITE

    DrawText "Congrats! You created your first window!", 190, 200, 20, LIGHTGRAY

    EndDrawing
Loop

CloseWindow

System

'$INCLUDE:'include/raylib.bas'
```
