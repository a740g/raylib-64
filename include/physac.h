//----------------------------------------------------------------------------------------------------------------------
// physac bindings for QB64-PE
// Copyright (c) 2024 Samuel Gomes
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#include "raylib.h"
#define PHYSAC_IMPLEMENTATION
#include "external/physac.h"

inline qb_bool __IsPhysicsEnabled()
{
    return TO_QB_BOOL(IsPhysicsEnabled());
}

inline PhysicsBody __CreatePhysicsBodyCircle(void *pos, float radius, float density)
{
    return CreatePhysicsBodyCircle(*(Vector2 *)pos, radius, density);
}

inline PhysicsBody __CreatePhysicsBodyRectangle(void *pos, float width, float height, float density)
{
    return CreatePhysicsBodyRectangle(*(Vector2 *)pos, width, height, density);
}

inline PhysicsBody __CreatePhysicsBodyPolygon(void *pos, float radius, int sides, float density)
{
    return CreatePhysicsBodyPolygon(*(Vector2 *)pos, radius, sides, density);
}

inline void __PhysicsAddForce(uintptr_t body, void *force)
{
    PhysicsAddForce((PhysicsBody)body, *(Vector2 *)force);
}

inline void __PhysicsAddTorque(uintptr_t body, float amount)
{
    PhysicsAddTorque((PhysicsBody)body, amount);
}

inline void __PhysicsShatter(uintptr_t body, void *position, float force)
{
    PhysicsShatter((PhysicsBody)body, *(Vector2 *)position, force);
}

inline void __GetPhysicsShapeVertex(uintptr_t body, int vertex, void *retVal)
{
    *(Vector2 *)retVal = GetPhysicsShapeVertex((PhysicsBody)body, vertex);
}

inline void __SetPhysicsBodyRotation(uintptr_t body, float radians)
{
    SetPhysicsBodyRotation((PhysicsBody)body, radians);
}

inline void __DestroyPhysicsBody(uintptr_t body)
{
    DestroyPhysicsBody((PhysicsBody)body);
}
