//----------------------------------------------------------------------------------------------------------------------
// raymath bindings for QB64-PE
// Copyright (c) 2024 Samuel Gomes
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#include "raylib.h"
#define RAYMATH_IMPLEMENTATION
#include "external/raymath.h"

inline qb_bool __FloatEquals(float f1, float f2)
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

inline qb_bool __Vector2Equals(void *v1, void *v2)
{
    return TO_QB_BOOL(Vector2Equals(*(Vector2 *)v1, *(Vector2 *)v2));
}

inline void __Vector3Zero(void *result)
{
    *(Vector3 *)result = Vector3Zero();
}

inline void __Vector3One(void *result)
{
    *(Vector3 *)result = Vector3One();
}

inline void __Vector3Add(void *v1, void *v2, void *result)
{
    *(Vector3 *)result = Vector3Add(*(Vector3 *)v1, *(Vector3 *)v2);
}

inline void __Vector3AddValue(void *v, float add, void *result)
{
    *(Vector3 *)result = Vector3AddValue(*(Vector3 *)v, add);
}

inline void __Vector3Subtract(void *v1, void *v2, void *result)
{
    *(Vector3 *)result = Vector3Subtract(*(Vector3 *)v1, *(Vector3 *)v2);
}

inline void __Vector3SubtractValue(void *v, float sub, void *result)
{
    *(Vector3 *)result = Vector3SubtractValue(*(Vector3 *)v, sub);
}

inline void __Vector3Scale(void *v, float scalar, void *result)
{
    *(Vector3 *)result = Vector3Scale(*(Vector3 *)v, scalar);
}

inline void __Vector3Multiply(void *v1, void *v2, void *result)
{
    *(Vector3 *)result = Vector3Multiply(*(Vector3 *)v1, *(Vector3 *)v2);
}

inline void __Vector3CrossProduct(void *v1, void *v2, void *result)
{
    *(Vector3 *)result = Vector3CrossProduct(*(Vector3 *)v1, *(Vector3 *)v2);
}

inline void __Vector3Perpendicular(void *v, void *result)
{
    *(Vector3 *)result = Vector3Perpendicular(*(Vector3 *)v);
}

inline float __Vector3Length(void *v)
{
    return Vector3Length(*(Vector3 *)v);
}

inline float __Vector3LengthSqr(void *v)
{
    return Vector3LengthSqr(*(Vector3 *)v);
}

inline float __Vector3DotProduct(void *v1, void *v2)
{
    return Vector3DotProduct(*(Vector3 *)v1, *(Vector3 *)v2);
}

inline float __Vector3Distance(void *v1, void *v2)
{
    return Vector3Distance(*(Vector3 *)v1, *(Vector3 *)v2);
}

inline float __Vector3DistanceSqr(void *v1, void *v2)
{
    return Vector3DistanceSqr(*(Vector3 *)v1, *(Vector3 *)v2);
}

inline float __Vector3Angle(void *v1, void *v2)
{
    return Vector3Angle(*(Vector3 *)v1, *(Vector3 *)v2);
}

inline void __Vector3Negate(void *v, void *result)
{
    *(Vector3 *)result = Vector3Negate(*(Vector3 *)v);
}

inline void __Vector3Divide(void *v1, void *v2, void *result)
{
    *(Vector3 *)result = Vector3Divide(*(Vector3 *)v1, *(Vector3 *)v2);
}

inline void __Vector3Normalize(void *v, void *result)
{
    *(Vector3 *)result = Vector3Normalize(*(Vector3 *)v);
}

inline void __Vector3Transform(void *v, void *mat, void *result)
{
    *(Vector3 *)result = Vector3Transform(*(Vector3 *)v, *(Matrix *)mat);
}

inline void __Vector3RotateByQuaternion(void *v, void *q, void *result)
{
    *(Vector3 *)result = Vector3RotateByQuaternion(*(Vector3 *)v, *(Quaternion *)q);
}

inline void __Vector3RotateByAxisAngle(void *v, void *axis, float angle, void *result)
{
    *(Vector3 *)result = Vector3RotateByAxisAngle(*(Vector3 *)v, *(Vector3 *)axis, angle);
}

inline void __Vector3Lerp(void *v1, void *v2, float amount, void *result)
{
    *(Vector3 *)result = Vector3Lerp(*(Vector3 *)v1, *(Vector3 *)v2, amount);
}

inline void __Vector3Reflect(void *v, void *normal, void *result)
{
    *(Vector3 *)result = Vector3Reflect(*(Vector3 *)v, *(Vector3 *)normal);
}

inline void __Vector3Min(void *v1, void *v2, void *result)
{
    *(Vector3 *)result = Vector3Min(*(Vector3 *)v1, *(Vector3 *)v2);
}

inline void __Vector3Max(void *v1, void *v2, void *result)
{
    *(Vector3 *)result = Vector3Max(*(Vector3 *)v1, *(Vector3 *)v2);
}

inline void __Vector3Barycenter(void *p, void *a, void *b, void *c, void *result)
{
    *(Vector3 *)result = Vector3Barycenter(*(Vector3 *)p, *(Vector3 *)a, *(Vector3 *)b, *(Vector3 *)c);
}

inline void __Vector3Unproject(void *source, void *projection, void *view, void *result)
{
    *(Vector3 *)result = Vector3Unproject(*(Vector3 *)source, *(Matrix *)projection, *(Matrix *)view);
}

inline void __Vector3ToFloatV(void *v, float *result)
{
    *(float3 *)result = Vector3ToFloatV(*(Vector3 *)v);
}

inline void __Vector3Invert(void *v, void *result)
{
    *(Vector3 *)result = Vector3Invert(*(Vector3 *)v);
}

inline void __Vector3Clamp(void *v, void *min, void *max, void *result)
{
    *(Vector3 *)result = Vector3Clamp(*(Vector3 *)v, *(Vector3 *)min, *(Vector3 *)max);
}

inline void __Vector3ClampValue(void *v, float min, float max, void *result)
{
    *(Vector3 *)result = Vector3ClampValue(*(Vector3 *)v, min, max);
}

inline qb_bool __Vector3Equals(void *v1, void *v2)
{
    return TO_QB_BOOL(Vector3Equals(*(Vector3 *)v1, *(Vector3 *)v2));
}

inline void __Vector3Refract(void *v, void *n, float r, void *result)
{
    *(Vector3 *)result = Vector3Refract(*(Vector3 *)v, *(Vector3 *)n, r);
}

inline float __MatrixDeterminant(void *mat)
{
    return MatrixDeterminant(*(Matrix *)mat);
}

inline float __MatrixTrace(void *mat)
{
    return MatrixTrace(*(Matrix *)mat);
}

inline void __MatrixTranspose(void *mat, void *result)
{
    *(Matrix *)result = MatrixTranspose(*(Matrix *)mat);
}

inline void __MatrixInvert(void *mat, void *result)
{
    *(Matrix *)result = MatrixInvert(*(Matrix *)mat);
}

inline void __MatrixIdentity(void *result)
{
    *(Matrix *)result = MatrixIdentity();
}

inline void __MatrixAdd(void *mat1, void *mat2, void *result)
{
    *(Matrix *)result = MatrixAdd(*(Matrix *)mat1, *(Matrix *)mat2);
}

inline void __MatrixSubtract(void *mat1, void *mat2, void *result)
{
    *(Matrix *)result = MatrixSubtract(*(Matrix *)mat1, *(Matrix *)mat2);
}

inline void __MatrixMultiply(void *mat1, void *mat2, void *result)
{
    *(Matrix *)result = MatrixMultiply(*(Matrix *)mat1, *(Matrix *)mat2);
}

inline void __MatrixTranslate(float x, float y, float z, void *result)
{
    *(Matrix *)result = MatrixTranslate(x, y, z);
}

inline void __MatrixRotate(void *axis, float angle, void *result)
{
    *(Matrix *)result = MatrixRotate(*(Vector3 *)axis, angle);
}

inline void __MatrixRotateX(float angle, void *result)
{
    *(Matrix *)result = MatrixRotateX(angle);
}

inline void __MatrixRotateY(float angle, void *result)
{
    *(Matrix *)result = MatrixRotateY(angle);
}

inline void __MatrixRotateZ(float angle, void *result)
{
    *(Matrix *)result = MatrixRotateZ(angle);
}

inline void __MatrixRotateXYZ(void *angle, void *result)
{
    *(Matrix *)result = MatrixRotateXYZ(*(Vector3 *)angle);
}

inline void __MatrixRotateZYX(void *angle, void *result)
{
    *(Matrix *)result = MatrixRotateZYX(*(Vector3 *)angle);
}

inline void __MatrixScale(float x, float y, float z, void *result)
{
    *(Matrix *)result = MatrixScale(x, y, z);
}

inline void __MatrixFrustum(double r_left, double r_right, double r_bottom, double r_top, double r_near, double r_far, void *result)
{
    *(Matrix *)result = MatrixFrustum(r_left, r_right, r_bottom, r_top, r_near, r_far);
}

inline void __MatrixPerspective(double fovy, double aspect, double nearPlane, double farPlane, void *result)
{
    *(Matrix *)result = MatrixPerspective(fovy, aspect, nearPlane, farPlane);
}

inline void __MatrixOrtho(double r_left, double r_right, double r_bottom, double r_top, double r_near, double r_far, void *result)
{
    *(Matrix *)result = MatrixOrtho(r_left, r_right, r_bottom, r_top, r_near, r_far);
}

inline void __MatrixLookAt(void *eye, void *target, void *up, void *result)
{
    *(Matrix *)result = MatrixLookAt(*(Vector3 *)eye, *(Vector3 *)target, *(Vector3 *)up);
}

inline void __MatrixToFloatV(void *mat, float *result)
{
    *(float16 *)result = MatrixToFloatV(*(Matrix *)mat);
}

inline void __QuaternionAdd(void *q1, void *q2, void *result)
{
    *(Quaternion *)result = QuaternionAdd(*(Quaternion *)q1, *(Quaternion *)q2);
}

inline void __QuaternionAddValue(void *q, float add, void *result)
{
    *(Quaternion *)result = QuaternionAddValue(*(Quaternion *)q, add);
}

inline void __QuaternionSubtract(void *q1, void *q2, void *result)
{
    *(Quaternion *)result = QuaternionSubtract(*(Quaternion *)q1, *(Quaternion *)q2);
}

inline void __QuaternionSubtractValue(void *q, float sub, void *result)
{
    *(Quaternion *)result = QuaternionSubtractValue(*(Quaternion *)q, sub);
}

inline void __QuaternionIdentity(void *result)
{
    *(Quaternion *)result = QuaternionIdentity();
}

inline float __QuaternionLength(void *q)
{
    return QuaternionLength(*(Quaternion *)q);
}

inline void __QuaternionNormalize(void *q, void *result)
{
    *(Quaternion *)result = QuaternionNormalize(*(Quaternion *)q);
}

inline void __QuaternionInvert(void *q, void *result)
{
    *(Quaternion *)result = QuaternionInvert(*(Quaternion *)q);
}

inline void __QuaternionMultiply(void *q1, void *q2, void *result)
{
    *(Quaternion *)result = QuaternionMultiply(*(Quaternion *)q1, *(Quaternion *)q2);
}

inline void __QuaternionScale(void *q, float mul, void *result)
{
    *(Quaternion *)result = QuaternionScale(*(Quaternion *)q, mul);
}

inline void __QuaternionDivide(void *q1, void *q2, void *result)
{
    *(Quaternion *)result = QuaternionDivide(*(Quaternion *)q1, *(Quaternion *)q2);
}

inline void __QuaternionLerp(void *q1, void *q2, float amount, void *result)
{
    *(Quaternion *)result = QuaternionLerp(*(Quaternion *)q1, *(Quaternion *)q2, amount);
}

inline void __QuaternionNlerp(void *q1, void *q2, float amount, void *result)
{
    *(Quaternion *)result = QuaternionNlerp(*(Quaternion *)q1, *(Quaternion *)q2, amount);
}

inline void __QuaternionSlerp(void *q1, void *q2, float amount, void *result)
{
    *(Quaternion *)result = QuaternionSlerp(*(Quaternion *)q1, *(Quaternion *)q2, amount);
}

inline void __QuaternionFromVector3ToVector3(void *from, void *to, void *result)
{
    *(Quaternion *)result = QuaternionFromVector3ToVector3(*(Vector3 *)from, *(Vector3 *)to);
}

inline void __QuaternionToMatrix(void *q, void *result)
{
    *(Matrix *)result = QuaternionToMatrix(*(Quaternion *)q);
}

inline void __QuaternionFromAxisAngle(void *axis, float angle, void *result)
{
    *(Quaternion *)result = QuaternionFromAxisAngle(*(Vector3 *)axis, angle);
}

inline void __QuaternionToAxisAngle(void *q, void *outAxis, float *outAngle)
{
    QuaternionToAxisAngle(*(Quaternion *)q, (Vector3 *)outAxis, outAngle);
}

inline void __QuaternionFromEuler(float pitch, float yaw, float roll, void *result)
{
    *(Quaternion *)result = QuaternionFromEuler(pitch, yaw, roll);
}

inline void __QuaternionToEuler(void *q, void *result)
{
    *(Vector3 *)result = QuaternionToEuler(*(Quaternion *)q);
}

inline void __QuaternionTransform(void *q, void *mat, void *result)
{
    *(Quaternion *)result = QuaternionTransform(*(Quaternion *)q, *(Matrix *)mat);
}

inline qb_bool __QuaternionEquals(void *q1, void *q2)
{
    return TO_QB_BOOL(QuaternionEquals(*(Quaternion *)q1, *(Quaternion *)q2));
}
