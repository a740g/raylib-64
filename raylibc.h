//-----------------------------------------------------------------------------------------------------
// raylib bindings for QB64-PE
// Copyright (c) 2023 Samuel Gomes
//
// This file contains wrapper functions for stuff that cannot be used directly in QB64-PE
//-----------------------------------------------------------------------------------------------------

#pragma once

//#define RLAPI __declspec(dllimport) // We are using the library as a Win32 shared library (.dll)
#define RLAPI __attribute__ ((dllimport))

// Vector2, 2 components
typedef struct Vector2
{
    float x; // Vector x component
    float y; // Vector y component
} Vector2;

// Prevents name mangling of functions
#if defined(__cplusplus)
extern "C"
{
#endif

    RLAPI Vector2 GetMonitorPosition(int monitor); // Get specified monitor position
    RLAPI Vector2 GetWindowPosition(void);         // Get window position XY on monitor
    RLAPI Vector2 GetWindowScaleDPI(void);         // Get window scale DPI factor

    void GetMonitorPositionVector2(int monitor, Vector2 *v)
    {
        *v = GetMonitorPosition(monitor);
    }

    void GetWindowPositionVector2(Vector2 *v)
    {
        *v = GetWindowPosition();
    }

    void GetWindowScaleDPIVector2(Vector2 *v)
    {
        *v = GetWindowScaleDPI();
    }

#if defined(__cplusplus)
}
#endif
