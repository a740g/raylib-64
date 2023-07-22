//----------------------------------------------------------------------------------------------------------------------
// physac bindings for QB64-PE
// Copyright (c) 2023 Samuel Gomes
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#include "raylib.h"
#define PHYSAC_IMPLEMENTATION
#include "external/physac.h"

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

inline void __DestroyPhysicsBody(void *body)
{
    DestroyPhysicsBody((PhysicsBody)body);
}

inline void __PhysicsAddForce(void *body, void *force)
{
    PhysicsAddForce((PhysicsBody)body, *(Vector2 *)force);
}

inline void __PhysicsAddTorque(void *body, float amount)
{
    PhysicsAddTorque((PhysicsBody)body, amount);
}

inline void __PhysicsShatter(void *body, void *position, float force)
{
    PhysicsShatter((PhysicsBody)body, *(Vector2 *)position, force);
}

inline void __SetPhysicsBodyRotation(void *body, float radians)
{
    SetPhysicsBodyRotation((PhysicsBody)body, radians);
}

inline void __GetPhysicsShapeVertex(void *body, int vertex, void *retVal)
{
    *(Vector2 *)retVal = GetPhysicsShapeVertex((PhysicsBody)body, vertex);
}
