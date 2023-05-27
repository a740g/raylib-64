'-----------------------------------------------------------------------------------------------------------------------
' raylib bindings for QB64-PE
' Copyright (c) 2023 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$If RAYLIB_BI = UNDEFINED Then
    $Let RAYLIB_BI = TRUE

    ' Check QB64-PE compiler version and complain if it does not meet minimum version requirement
    ' We do not support 32-bit versions. Although it is trivial to add if we can find 32-bit raylib shared libraries
    $If VERSION < 3.7 OR 32BIT Then
            $ERROR This requires the latest 64-bit version of QB64-PE from https://github.com/QB64-Phoenix-Edition/QB64pe/releases
    $End If

    ' All identifiers must default to long (32-bits). This results in fastest code execution on x86 & x64
    DefLng A-Z

    ' Force all arrays to be defined
    Option _ExplicitArray

    ' Force all variables to be defined
    Option _Explicit

    ' All arrays should be static. If dynamic arrays are required use "REDIM"
    '$STATIC

    ' Start array lower bound from 1. If 0 is required, then it should be explicitly specified as (0 To X)
    Option Base 1

    ' raylib uses it's own window. So, we force QB64-PE to generate a console only executable. The console can be used for debugging
    $Console:Only

    ' Some common and useful constants
    Const FALSE = 0, TRUE = Not FALSE
    Const NULL = 0

    ' Vector2, 2 components
    Type Vector2
        x As Single ' Vector x component
        y As Single ' Vector y component
    End Type

    ' Vector3, 3 components
    Type Vector3
        x As Single ' Vector x component
        y As Single ' Vector y component
        z As Single ' Vector z component
    End Type

    ' Matrix, 4x4 components, column major, OpenGL style, right-handed
    Type Matrix
        As Single m0, m4, m8, m12 ' Matrix first row (4 components)
        As Single m1, m5, m9, m13 ' Matrix second row (4 components)
        As Single m2, m6, m10, m14 ' Matrix third row (4 components)
        As Single m3, m7, m11, m15 ' Matrix fourth row (4 components)
    End Type

    ' Color, 4 components, R8G8B8A8 (32bit)
    Type RColor
        r As _Unsigned _Byte ' Color red value
        g As _Unsigned _Byte ' Color green value
        b As _Unsigned _Byte ' Color blue value
        a As _Unsigned _Byte ' Color alpha value
    End Type

    ' Image, pixel data stored in CPU memory (RAM)
    Type Image
        dat As _Offset ' Image raw data
        w As Long ' Image base width
        h As Long ' Image base height
        mipmaps As Long ' Mipmap levels, 1 by default
        format As Long ' Data format (PixelFormat type)
    End Type

    ' Texture, tex data stored in GPU memory (VRAM)
    Type Texture
        id As Long ' OpenGL texture id
        w As Long ' Texture base width
        h As Long ' Texture base height
        mipmaps As Long ' Mipmap levels, 1 by default
        format As Long ' Data format (PixelFormat type)
    End Type

    ' Texture2D, same as Texture
    Type Texture2D
        id As Long ' OpenGL texture id
        w As Long ' Texture base width
        h As Long ' Texture base height
        mipmaps As Long ' Mipmap levels, 1 by default
        format As Long ' Data format (PixelFormat type)
    End Type

    ' TextureCubemap, same as Texture
    Type TextureCubemap
        id As Long ' OpenGL texture id
        w As Long ' Texture base width
        h As Long ' Texture base height
        mipmaps As Long ' Mipmap levels, 1 by default
        format As Long ' Data format (PixelFormat type)
    End Type

    ' RenderTexture, fbo for texture rendering
    Type RenderTexture
        id As Long ' OpenGL framebuffer object id
        texture As Texture ' Color buffer attachment texture
        depth As Texture ' Depth buffer attachment texture
    End Type

    ' RenderTexture2D, same as RenderTexture
    Type RenderTexture2D
        id As Long ' OpenGL framebuffer object id
        texture As Texture ' Color buffer attachment texture
        depth As Texture ' Depth buffer attachment texture
    End Type

    ' Camera, defines position/orientation in 3d space
    Type Camera3D
        position As Vector3 ' Camera position
        target As Vector3 ' Camera target it looks-at
        up As Vector3 ' Camera up vector (rotation over its axis)
        fovy As Single ' Camera field-of-view aperture in Y (degrees) in perspective, used as near plane width in orthographic
        projection As Long ' Camera projection: CAMERA_PERSPECTIVE or CAMERA_ORTHOGRAPHIC
    End Type

    ' Camera type fallback, defaults to Camera3D
    Type Camera
        position As Vector3 ' Camera position
        target As Vector3 ' Camera target it looks-at
        up As Vector3 ' Camera up vector (rotation over its axis)
        fovy As Single ' Camera field-of-view aperture in Y (degrees) in perspective, used as near plane width in orthographic
        projection As Long ' Camera projection: CAMERA_PERSPECTIVE or CAMERA_ORTHOGRAPHIC
    End Type

    ' Camera2D, defines position/orientation in 2d space
    Type Camera2D
        offset As Vector2 ' Camera offset (displacement from target)
        target As Vector2 ' Camera target (rotation and zoom origin)
        rotation As Single ' Camera rotation in degrees
        zoom As Single ' Camera zoom (scaling), should be 1.0f by default
    End Type

    ' Shader
    Type Shader
        id As Long ' Shader program id
        locs As _Offset ' Shader locations array (RL_MAX_SHADER_LOCATIONS)
    End Type

    ' VrDeviceInfo, Head-Mounted-Display device parameters
    Type VrDeviceInfo
        hResolution As Long ' Horizontal resolution in pixels
        vResolution As Long ' Vertical resolution in pixels
        hScreenSize As Single ' Horizontal size in meters
        vScreenSize As Single ' Vertical size in meters
        vScreenCenter As Single ' Screen center in meters
        eyeToScreenDistance As Single ' Distance between eye and display in meters
        lensSeparationDistance As Single ' Lens separation distance in meters
        interpupillaryDistance As Single ' IPD (distance between pupils) in meters
        As Single lensDistortionValues0, lensDistortionValues1, lensDistortionValues2, lensDistortionValues3 ' Lens distortion constant parameters
        As Single chromaAbCorrection0, chromaAbCorrection1, chromaAbCorrection2, chromaAbCorrection3 ' Chromatic aberration correction parameters
    End Type

    ' VrStereoConfig, VR stereo rendering configuration for simulator
    Type VrStereoConfig
        As Matrix projection0, projection1 ' VR projection matrices (per eye)
        As Matrix viewOffset0, viewOffset1 ' VR view offset matrices (per eye)
        As Single leftLensCenter0, leftLensCenter1 ' VR left lens center
        As Single rightLensCenter0, rightLensCenter1 ' VR right lens center
        As Single leftScreenCenter0, leftScreenCenter1 ' VR left screen center
        As Single rightScreenCenter0, rightScreenCenter1 ' VR right screen center
        As Single scale0, scale1 ' VR distortion scale
        As Single scaleIn0, scaleIn1 ' VR distortion scale in
    End Type

    ' Stuff with leading `__` are not supposed to be called directly. Use the QB64-PE function wrappers in raylib.bas instead
    Declare Static Library "raylib"
        Function __init_raylib%% ' for iternal use only

    End Declare

    ' Initialize the C-side glue code
    If __init_raylib Then
        _Delay 0.1 ' the delay is needed for the console window to appear
        _Console Off ' hide the console by default
    Else
        Print "raylib initialization failed!"
        End 1
    End If

$End If
'-----------------------------------------------------------------------------------------------------------------------
