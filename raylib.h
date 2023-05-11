//-----------------------------------------------------------------------------------------------------
// raylib bindings for QB64-PE
// Copyright (c) 2023 Samuel Gomes
//
// This file contains wrapper functions for stuff that cannot be used directly in QB64-PE
//-----------------------------------------------------------------------------------------------------

#pragma once

#include "dylib.hpp"

// Vector2, 2 components
struct Vector2
{
    float x; // Vector x component
    float y; // Vector y component
};

static dylib *raylib = nullptr; //  this is our shared lib handle

static Vector2 (*_GetMonitorPosition)(int monitor) = nullptr; // Get specified monitor position
static Vector2 (*_GetWindowPosition)() = nullptr;             // Get window position XY on monitor
static Vector2 (*_GetWindowScaleDPI)() = nullptr;             // Get window scale DPI factor

void __done_raylib()
{
    _GetWindowScaleDPI = nullptr;
    _GetWindowPosition = nullptr;
    _GetMonitorPosition = nullptr;
    delete raylib;
}

bool __init_raylib()
{
    raylib = new dylib("raylib");
    if (!raylib)
        return false;

    _GetMonitorPosition = raylib->get_function<Vector2(int)>("GetMonitorPosition");
    _GetWindowPosition = raylib->get_function<Vector2()>("GetWindowPosition");
    _GetWindowScaleDPI = raylib->get_function<Vector2()>("GetWindowScaleDPI");

    if (!_GetMonitorPosition || !_GetWindowPosition || !_GetWindowScaleDPI)
    {
        __done_raylib();
        return false;
    }

    return true;
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
