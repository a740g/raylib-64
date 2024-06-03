//----------------------------------------------------------------------------------------------------------------------
// raymath bindings for QB64-PE
// Copyright (c) 2024 Samuel Gomes
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#include "raylib.h"
#define RAYMATH_IMPLEMENTATION
#include "external/raymath.h"

inline int __FloatEquals(float f1, float f2)
{
    return TO_QB_BOOL(FloatEquals(f1, f2));
}

inline void __Vector2Zero(void *v)
{
    *(Vector2 *)v = Vector2Zero();
}

inline void __Vector2One(void *v)
{
    *(Vector2 *)v = Vector2One();
}

inline void __Vector2Add(void *v1, void *v2, void *result)
{
    *(Vector2 *)result = Vector2Add(*(Vector2 *)v1, *(Vector2 *)v2);
}

inline void __Vector2AddValue(void *v, float add, void *result)
{
    *(Vector2 *)result = Vector2AddValue(*(Vector2 *)v, add);
}

inline void __Vector2Subtract(void *v1, void *v2, void *result)
{
    *(Vector2 *)result = Vector2Subtract(*(Vector2 *)v1, *(Vector2 *)v2);
}

inline void __Vector2SubtractValue(void *v, float sub, void *result)
{
    *(Vector2 *)result = Vector2SubtractValue(*(Vector2 *)v, sub);
}

inline float __Vector2Length(void *v)
{
    return Vector2Length(*(Vector2 *)v);
}

inline float __Vector2LengthSqr(void *v)
{
    return Vector2LengthSqr(*(Vector2 *)v);
}

inline float __Vector2DotProduct(void *v1, void *v2)
{
    return Vector2DotProduct(*(Vector2 *)v1, *(Vector2 *)v2);
}

inline float __Vector2Distance(void *v1, void *v2)
{
    return Vector2Distance(*(Vector2 *)v1, *(Vector2 *)v2);
}

inline float __Vector2DistanceSqr(void *v1, void *v2)
{
    return Vector2DistanceSqr(*(Vector2 *)v1, *(Vector2 *)v2);
}

inline float __Vector2Angle(void *v1, void *v2)
{
    return Vector2Angle(*(Vector2 *)v1, *(Vector2 *)v2);
}

inline void __Vector2Scale(void *v, float scale, void *result)
{
    *(Vector2 *)result = Vector2Scale(*(Vector2 *)v, scale);
}

inline void __Vector2Multiply(void *v1, void *v2, void *result)
{
    *(Vector2 *)result = Vector2Multiply(*(Vector2 *)v1, *(Vector2 *)v2);
}

inline void __Vector2Negate(void *v, void *result)
{
    *(Vector2 *)result = Vector2Negate(*(Vector2 *)v);
}

inline void __Vector2Divide(void *v1, void *v2, void *result)
{
    *(Vector2 *)result = Vector2Divide(*(Vector2 *)v1, *(Vector2 *)v2);
}

inline void __Vector2Normalize(void *v, void *result)
{
    *(Vector2 *)result = Vector2Normalize(*(Vector2 *)v);
}

inline void __Vector2Transform(void *v, void *mat, void *result)
{
    *(Vector2 *)result = Vector2Transform(*(Vector2 *)v, *(Matrix *)mat);
}

inline void __Vector2Lerp(void *v1, void *v2, float amount, void *result)
{
    *(Vector2 *)result = Vector2Lerp(*(Vector2 *)v1, *(Vector2 *)v2, amount);
}

inline void __Vector2Reflect(void *v, void *normal, void *result)
{
    *(Vector2 *)result = Vector2Reflect(*(Vector2 *)v, *(Vector2 *)normal);
}

inline void __Vector2Rotate(void *v, float angle, void *result)
{
    *(Vector2 *)result = Vector2Rotate(*(Vector2 *)v, angle);
}

inline void __Vector2MoveTowards(void *v, void *target, float maxDistance, void *result)
{
    *(Vector2 *)result = Vector2MoveTowards(*(Vector2 *)v, *(Vector2 *)target, maxDistance);
}

inline void __Vector2Invert(void *v, void *result)
{
    *(Vector2 *)result = Vector2Invert(*(Vector2 *)v);
}

inline void __Vector2Clamp(void *v, void *min, void *max, void *result)
{
    *(Vector2 *)result = Vector2Clamp(*(Vector2 *)v, *(Vector2 *)min, *(Vector2 *)max);
}

inline void __Vector2ClampValue(void *v, float min, float max, void *result)
{
    *(Vector2 *)result = Vector2ClampValue(*(Vector2 *)v, min, max);
}

inline int __Vector2Equals(void *v1, void *v2)
{
    return TO_QB_BOOL(Vector2Equals(*(Vector2 *)v1, *(Vector2 *)v2));
}
