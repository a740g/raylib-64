//-----------------------------------------------------------------------------------------------------
// raylib bindings for QB64-PE
// Copyright (c) 2023 Samuel Gomes
//-----------------------------------------------------------------------------------------------------

#pragma once

#include "dylib.hpp"

#define RAYLIB_DEBUG_PRINT(_fmt_, _args_...) fprintf(stderr, "DEBUG: %s:%d:%s(): " _fmt_ "\n", __FILE__, __LINE__, __func__, ##_args_)

// Vector2, 2 components
struct Vector2
{
    float x; // Vector x component
    float y; // Vector y component
};

// Matrix, 4x4 components, column major, OpenGL style, right-handed
struct Matrix
{
    float m0, m4, m8, m12;  // Matrix first row (4 components)
    float m1, m5, m9, m13;  // Matrix second row (4 components)
    float m2, m6, m10, m14; // Matrix third row (4 components)
    float m3, m7, m11, m15; // Matrix fourth row (4 components)
};

// Image, pixel data stored in CPU memory (RAM)
struct Image
{
    void *data;  // Image raw data
    int width;   // Image base width
    int height;  // Image base height
    int mipmaps; // Mipmap levels, 1 by default
    int format;  // Data format (PixelFormat type)
};

// Shader
struct Shader
{
    unsigned int id; // Shader program id
    int *locs;       // Shader locations array (RL_MAX_SHADER_LOCATIONS)
};

// VrDeviceInfo, Head-Mounted-Display device parameters
struct VrDeviceInfo
{
    int hResolution;               // Horizontal resolution in pixels
    int vResolution;               // Vertical resolution in pixels
    float hScreenSize;             // Horizontal size in meters
    float vScreenSize;             // Vertical size in meters
    float vScreenCenter;           // Screen center in meters
    float eyeToScreenDistance;     // Distance between eye and display in meters
    float lensSeparationDistance;  // Lens separation distance in meters
    float interpupillaryDistance;  // IPD (distance between pupils) in meters
    float lensDistortionValues[4]; // Lens distortion constant parameters
    float chromaAbCorrection[4];   // Chromatic aberration correction parameters
};

// VrStereoConfig, VR stereo rendering configuration for simulator
struct VrStereoConfig
{
    Matrix projection[2];       // VR projection matrices (per eye)
    Matrix viewOffset[2];       // VR view offset matrices (per eye)
    float leftLensCenter[2];    // VR left lens center
    float rightLensCenter[2];   // VR right lens center
    float leftScreenCenter[2];  // VR left screen center
    float rightScreenCenter[2]; // VR right screen center
    float scale[2];             // VR distortion scale
    float scaleIn[2];           // VR distortion scale in
};

static dylib *raylib = nullptr; //  this is our shared lib handle

static void (*_SetWindowIcon)(Image image) = nullptr;                                     // Set icon for window (single image, RGBA 32bit, only PLATFORM_DESKTOP)
static Vector2 (*_GetMonitorPosition)(int monitor) = nullptr;                             // Get specified monitor position
static Vector2 (*_GetWindowPosition)() = nullptr;                                         // Get window position XY on monitor
static Vector2 (*_GetWindowScaleDPI)() = nullptr;                                         // Get window scale DPI factor
static VrStereoConfig (*_LoadVrStereoConfig)(VrDeviceInfo device) = nullptr;              // Load VR stereo config for VR simulator device parameters
static Shader (*_LoadShader)(const char *vsFileName, const char *fsFileName) = nullptr;   // Load shader from files and bind default locations
static Shader (*_LoadShaderFromMemory)(const char *vsCode, const char *fsCode) = nullptr; // Load shader from code strings and bind default locations
static bool (*_IsShaderReady)(Shader shader) = nullptr;                                   // Check if a shader is ready
static int (*_GetShaderLocation)(Shader shader, const char *uniformName) = nullptr;       // Get shader uniform location
static int (*_GetShaderLocationAttrib)(Shader shader, const char *attribName) = nullptr;  // Get shader attribute location

static void __done_raylib()
{
    _GetShaderLocationAttrib = nullptr;
    _GetShaderLocation = nullptr;
    _IsShaderReady = nullptr;
    _LoadShaderFromMemory = nullptr;
    _LoadShader = nullptr;
    _LoadVrStereoConfig = nullptr;
    _GetWindowScaleDPI = nullptr;
    _GetWindowPosition = nullptr;
    _GetMonitorPosition = nullptr;
    _SetWindowIcon = nullptr;
    delete raylib;
    raylib = nullptr;

    RAYLIB_DEBUG_PRINT("Shared library unloaded");
}

bool __init_raylib()
{
    try
    {
        raylib = new dylib("./", "raylib");
    }
    catch (dylib::load_error e)
    {
        RAYLIB_DEBUG_PRINT("Error: %s", e.what());
        try
        {
            raylib = new dylib("raylib");
        }
        catch (dylib::load_error e)
        {
            RAYLIB_DEBUG_PRINT("Error: %s", e.what());
            if (!raylib)
                return false;
        }
    }

    _SetWindowIcon = raylib->get_function<void(Image)>("SetWindowIcon");
    _GetMonitorPosition = raylib->get_function<Vector2(int)>("GetMonitorPosition");
    _GetWindowPosition = raylib->get_function<Vector2()>("GetWindowPosition");
    _GetWindowScaleDPI = raylib->get_function<Vector2()>("GetWindowScaleDPI");
    _LoadVrStereoConfig = raylib->get_function<VrStereoConfig(VrDeviceInfo)>("LoadVrStereoConfig");
    _LoadShader = raylib->get_function<Shader(const char *, const char *)>("LoadShader");
    _LoadShaderFromMemory = raylib->get_function<Shader(const char *, const char *)>("LoadShaderFromMemory");
    _IsShaderReady = raylib->get_function<bool(Shader)>("IsShaderReady");
    _GetShaderLocation = raylib->get_function<int(Shader, const char *)>("GetShaderLocation");
    _GetShaderLocationAttrib = raylib->get_function<int(Shader, const char *)>("GetShaderLocationAttrib");

    if (!_SetWindowIcon || !_GetMonitorPosition || !_GetWindowPosition || !_GetWindowScaleDPI || !_LoadVrStereoConfig ||
        !_LoadShader || !_LoadShaderFromMemory || !_IsShaderReady || !_GetShaderLocation || !_GetShaderLocationAttrib)
    {
        __done_raylib();
        return false;
    }

    atexit(__done_raylib); // cleanup before the program ends

    RAYLIB_DEBUG_PRINT("Shared library loaded");

    return true;
}

inline void SetWindowIcon(void *image)
{
    _SetWindowIcon(*(Image *)image);
}

inline void GetMonitorPosition(int monitor, void *v)
{
    *(Vector2 *)v = _GetMonitorPosition(monitor);
}

inline void GetWindowPosition(void *v)
{
    *(Vector2 *)v = _GetWindowPosition();
}

inline void GetWindowScaleDPI(void *v)
{
    *(Vector2 *)v = _GetWindowScaleDPI();
}

inline void LoadVrStereoConfig(void *device, void *config)
{
    *(VrStereoConfig *)config = _LoadVrStereoConfig(*(VrDeviceInfo *)device);
}

inline void LoadShader(char *vsFileName, char *fsFileName, void *shader)
{
    *(Shader *)shader = _LoadShader(vsFileName, fsFileName);
}

inline void LoadShaderFromMemory(char *vsCode, char *fsCode, void *shader)
{
    *(Shader *)shader = _LoadShaderFromMemory(vsCode, fsCode);
}

inline bool IsShaderReady(void *shader)
{
    return _IsShaderReady(*(Shader *)shader);
}

inline int GetShaderLocation(void *shader, char *uniformName)
{
    return _GetShaderLocation(*(Shader *)shader, uniformName);
}

inline int GetShaderLocationAttrib(void *shader, char *attribName)
{
    return _GetShaderLocationAttrib(*(Shader *)shader, attribName);
}
