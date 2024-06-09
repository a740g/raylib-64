'-----------------------------------------------------------------------------------------------------------------------
' raymath bindings for QB64-PE
' Copyright (c) 2024 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$INCLUDEONCE

'$INCLUDE:'raylib.bi'

CONST EPSILON! = 0.000001!

DECLARE STATIC LIBRARY "raymath"
    ' Utils math
    FUNCTION Clamp! (BYVAL value AS SINGLE, BYVAL min AS SINGLE, BYVAL max AS SINGLE) ' Function specifiers definition Defines and Macros Get float vector for Matrix Get float vector for Vector3 Types and Structures Definition Vector2 type Vector3 type Vector4 type Quaternion type Matrix type (OpenGL style 4x4 - right handed, column major) NOTE: Helper types to be used instead of array return types for *ToFloat functions Clamp float value
    FUNCTION Lerp! (BYVAL rStart AS SINGLE, BYVAL rEnd AS SINGLE, BYVAL rAmount AS SINGLE) ' Calculate linear interpolation between two floats
    FUNCTION Normalize! (BYVAL rValue AS SINGLE, BYVAL rStart AS SINGLE, BYVAL rEnd AS SINGLE) ' Normalize input value within input range
    FUNCTION Remap! (BYVAL value AS SINGLE, BYVAL inputStart AS SINGLE, BYVAL inputEnd AS SINGLE, BYVAL outputStart AS SINGLE, BYVAL outputEnd AS SINGLE) ' Remap input value within input range to output range
    FUNCTION Wrap! (BYVAL value AS SINGLE, BYVAL min AS SINGLE, BYVAL max AS SINGLE) ' Wrap input value from min to max
    FUNCTION FloatEquals%% ALIAS "__FloatEquals" (BYVAL x AS SINGLE, BYVAL y AS SINGLE) ' Check whether two given floats are almost equal

    ' Support utils math
    FUNCTION LongToSingle! ALIAS "float" (BYVAL x AS LONG)
    FUNCTION Integer64ToSingle! ALIAS "float" (BYVAL x AS _INTEGER64)
    FUNCTION LongToDouble# ALIAS "double" (BYVAL x AS LONG)
    FUNCTION Integer64ToDouble# ALIAS "double" (BYVAL x AS _INTEGER64)
    FUNCTION SingleToLong& ALIAS "int32_t" (BYVAL x AS SINGLE)
    FUNCTION DoubleToLong& ALIAS "int32_t" (BYVAL x AS DOUBLE)
    FUNCTION SingleToInteger64&& ALIAS "int64_t" (BYVAL x AS SINGLE)
    FUNCTION DoubleToInteger64&& ALIAS "int64_t" (BYVAL x AS DOUBLE)
    FUNCTION MaxSingle! ALIAS "fmaxf" (BYVAL a AS SINGLE, BYVAL b AS SINGLE)
    FUNCTION MinSingle! ALIAS "fminf" (BYVAL a AS SINGLE, BYVAL b AS SINGLE)
    FUNCTION MaxDouble# ALIAS "fmax" (BYVAL a AS DOUBLE, BYVAL b AS DOUBLE)
    FUNCTION MinDouble# ALIAS "fmin" (BYVAL a AS DOUBLE, BYVAL b AS DOUBLE)
    FUNCTION FMASingle! ALIAS "fmaf" (BYVAL x AS SINGLE, BYVAL y AS SINGLE, BYVAL z AS SINGLE)
    FUNCTION FMADouble# ALIAS "fma" (BYVAL x AS DOUBLE, BYVAL y AS DOUBLE, BYVAL z AS DOUBLE)
    FUNCTION PowerSingle! ALIAS "powf" (BYVAL b AS SINGLE, BYVAL e AS SINGLE)
    FUNCTION PowerDouble# ALIAS "pow" (BYVAL b AS DOUBLE, BYVAL e AS DOUBLE)
    FUNCTION Log10Single! ALIAS "log10f" (BYVAL n AS SINGLE)
    FUNCTION Log10Double# ALIAS "log10" (BYVAL n AS DOUBLE)
    FUNCTION Log2Single! ALIAS "log2f" (BYVAL n AS SINGLE)
    FUNCTION Log2Double# ALIAS "log2" (BYVAL n AS DOUBLE)
    FUNCTION CubeRootSingle! ALIAS "cbrtf" (BYVAL n AS SINGLE)
    FUNCTION CubeRootDouble# ALIAS "cbrt" (BYVAL n AS DOUBLE)

    ' Vector2 math
    SUB Vector2Zero ALIAS "__Vector2Zero" (v AS Vector2) ' Vector with components value 0.0f
    SUB Vector2One ALIAS "__Vector2One" (v AS Vector2) ' Vector with components value 1.0f
    SUB Vector2Add ALIAS "__Vector2Add" (v1 AS Vector2, v2 AS Vector2, result AS Vector2) ' Add two vectors (v1 + v2)
    SUB Vector2AddValue ALIAS "__Vector2AddValue" (v AS Vector2, BYVAL value AS SINGLE, result AS Vector2) ' Add vector and float value
    SUB Vector2Subtract ALIAS "__Vector2Subtract" (v1 AS Vector2, v2 AS Vector2, result AS Vector2) ' Subtract two vectors (v1 - v2)
    SUB Vector2SubtractValue ALIAS "__Vector2SubtractValue" (v AS Vector2, BYVAL value AS SINGLE, result AS Vector2) ' Subtract vector by float value
    FUNCTION Vector2Length! ALIAS "__Vector2Length" (v AS Vector2) ' Calculate vector length
    FUNCTION Vector2LengthSqr! ALIAS "__Vector2LengthSqr" (v AS Vector2) ' Calculate vector square length
    FUNCTION Vector2DotProduct! ALIAS "__Vector2DotProduct" (v1 AS Vector2, v2 AS Vector2) ' Calculate two vectors dot product
    FUNCTION Vector2Distance! ALIAS "__Vector2Distance" (v1 AS Vector2, v2 AS Vector2) ' Calculate distance between two vectors
    FUNCTION Vector2DistanceSqr! ALIAS "__Vector2DistanceSqr" (v1 AS Vector2, v2 AS Vector2) ' Calculate square distance between two vectors
    FUNCTION Vector2Angle! ALIAS "__Vector2Angle" (v1 AS Vector2, v2 AS Vector2) ' Calculate angle from two vectors
    SUB Vector2Scale ALIAS "__Vector2Scale" (v AS Vector2, BYVAL scale AS SINGLE, result AS Vector2) ' Scale vector (multiply by value)
    SUB Vector2Multiply ALIAS "__Vector2Multiply" (v1 AS Vector2, v2 AS Vector2, result AS Vector2) ' Multiply vector by vector
    SUB Vector2Negate ALIAS "__Vector2Negate" (v AS Vector2, result AS Vector2) ' Negate vector
    SUB Vector2Divide ALIAS "__Vector2Divide" (v1 AS Vector2, v2 AS Vector2, result AS Vector2) ' Divide vector by vector
    SUB Vector2Normalize ALIAS "__Vector2Normalize" (v AS Vector2, result AS Vector2) ' Normalize provided vector
    SUB Vector2Transform ALIAS "__Vector2Transform" (v AS Vector2, mat AS Matrix, result AS Vector2) ' Transforms a Vector2 by a given Matrix
    SUB Vector2Lerp ALIAS "__Vector2Lerp" (v1 AS Vector2, v2 AS Vector2, BYVAL amount AS SINGLE, result AS Vector2) ' Calculate linear interpolation between two vectors
    SUB Vector2Reflect ALIAS "__Vector2Reflect" (v AS Vector2, normal AS Vector2, result AS Vector2) ' Calculate reflected vector to normal
    SUB Vector2Rotate ALIAS "__Vector2Rotate" (v AS Vector2, BYVAL angle AS SINGLE, result AS Vector2) ' Rotate vector by angle
    SUB Vector2MoveTowards ALIAS "__Vector2MoveTowards" (v AS Vector2, target AS Vector2, BYVAL maxDistance AS SINGLE, result AS Vector2) ' Move Vector towards target
    SUB Vector2Invert ALIAS "__Vector2Invert" (v AS Vector2, result AS Vector2) ' Invert provided vector
    SUB Vector2Clamp ALIAS "__Vector2Clamp" (v AS Vector2, min AS Vector2, max AS Vector2, result AS Vector2) ' Clamp vector between min and max vectors
    SUB Vector2ClampValue ALIAS "__Vector2ClampValue" (v AS Vector2, BYVAL min AS SINGLE, BYVAL max AS SINGLE, result AS Vector2) ' Clamp the magnitude of the vector between two min and max values
    FUNCTION Vector2Equals%% ALIAS "__Vector2Equals" (v1 AS Vector2, v2 AS Vector2) ' Check whether two given vectors are almost equal

    ' Vector3 math
    SUB Vector3Zero ALIAS "__Vector3Zero" (v AS Vector3) ' Vector with components value 0.0f
    SUB Vector3One ALIAS "__Vector3One" (v AS Vector3) ' Vector with components value 1.0f
    SUB Vector3Add ALIAS "__Vector3Add" (v1 AS Vector3, v2 AS Vector3, result AS Vector3) ' Add two vectors (v1 + v2)
    SUB Vector3AddValue ALIAS "__Vector3AddValue" (v AS Vector3, BYVAL value AS SINGLE, result AS Vector3) ' Add vector and float value
    SUB Vector3Subtract ALIAS "__Vector3Subtract" (v1 AS Vector3, v2 AS Vector3, result AS Vector3) ' Subtract two vectors (v1 - v2)
    SUB Vector3SubtractValue ALIAS "__Vector3SubtractValue" (v AS Vector3, BYVAL value AS SINGLE, result AS Vector3) ' Subtract vector and float value
    SUB Vector3Scale ALIAS "__Vector3Scale" (v AS Vector3, BYVAL scalar AS SINGLE, result AS Vector3) ' Multiply vector by scalar
    SUB Vector3Multiply ALIAS "__Vector3Multiply" (v1 AS Vector3, v2 AS Vector3, result AS Vector3) ' Multiply vector by vector
    SUB Vector3CrossProduct ALIAS "__Vector3CrossProduct" (v1 AS Vector3, v2 AS Vector3, result AS Vector3) ' Calculate two vectors cross product
    SUB Vector3Perpendicular ALIAS "__Vector3Perpendicular" (v AS Vector3, result AS Vector3) ' Calculate one vector perpendicular vector
    FUNCTION Vector3Length! ALIAS "__Vector3Length" (v AS Vector3) ' Calculate vector length
    FUNCTION Vector3LengthSqr! ALIAS "__Vector3LengthSqr" (v AS Vector3) ' Calculate vector square length
    FUNCTION Vector3DotProduct! ALIAS "__Vector3DotProduct" (v1 AS Vector3, v2 AS Vector3) ' Calculate two vectors dot product
    FUNCTION Vector3Distance! ALIAS "__Vector3Distance" (v1 AS Vector3, v2 AS Vector3) ' Calculate distance between two vectors
    FUNCTION Vector3DistanceSqr! ALIAS "__Vector3DistanceSqr" (v1 AS Vector3, v2 AS Vector3) ' Calculate square distance between two vectors
    FUNCTION Vector3Angle! ALIAS "__Vector3Angle" (v1 AS Vector3, v2 AS Vector3) ' Calculate angle between two vectors
    SUB Vector3Negate ALIAS "__Vector3Negate" (v AS Vector3, result AS Vector3) ' Negate provided vector (invert direction)
    SUB Vector3Divide ALIAS "__Vector3Divide" (v1 AS Vector3, v2 AS Vector3, result AS Vector3) ' Divide vector by vector
    SUB Vector3Normalize ALIAS "__Vector3Normalize" (v AS Vector3, result AS Vector3) ' Normalize provided vector
    SUB Vector3OrthoNormalize (v1 AS Vector3, v2 AS Vector3) ' Orthonormalize provided vectors (makes vectors normalized and orthogonal to each other Gram-Schmidt function implementation)
    SUB Vector3Transform ALIAS "__Vector3Transform" (v AS Vector3, mat AS Matrix, result AS Vector3) ' Transforms a Vector3 by a given Matrix
    SUB Vector3RotateByQuaternion ALIAS "__Vector3RotateByQuaternion" (v AS Vector3, q AS Vector4, result AS Vector3) ' Transform a vector by quaternion rotation
    SUB Vector3RotateByAxisAngle ALIAS "__Vector3RotateByAxisAngle" (v AS Vector3, axis AS Vector3, BYVAL angle AS SINGLE, result AS Vector3) ' Rotates a vector around an axis
    SUB Vector3Lerp ALIAS "__Vector3Lerp" (v1 AS Vector3, v2 AS Vector3, BYVAL amount AS SINGLE, result AS Vector3) ' Calculate linear interpolation between two vectors
    SUB Vector3Reflect ALIAS "__Vector3Reflect" (v AS Vector3, normal AS Vector3, result AS Vector3) ' Calculate reflected vector to normal
    SUB Vector3Min ALIAS "__Vector3Min" (v1 AS Vector3, v2 AS Vector3, result AS Vector3) ' Get min value for each pair of components
    SUB Vector3Max ALIAS "__Vector3Max" (v1 AS Vector3, v2 AS Vector3, result AS Vector3) ' Get max value for each pair of components
    SUB Vector3Barycenter ALIAS "__Vector3Barycenter" (p AS Vector3, a AS Vector3, b AS Vector3, c AS Vector3, result AS Vector3) ' Compute barycenter coordinates (u, v, w) for point p with respect to triangle (a, b, c). NOTE: Assumes P is on the plane of the triangle
    SUB Vector3Unproject ALIAS "__Vector3Unproject" (source AS Vector3, projection AS Matrix, view AS Matrix, result AS Vector3) ' Projects a Vector3 from screen space into object space. NOTE: We are avoiding calling other raymath functions despite available
    SUB Vector3ToFloatV ALIAS "__Vector3ToFloatV" (v AS Vector3, result AS SINGLE) ' Get Vector3 as float array (result). Example: Vector3ToFloatV myVector, myFloatArray!(0)
    SUB Vector3Invert ALIAS "__Vector3Invert" (v AS Vector3, result AS Vector3) ' Invert provided vector
    SUB Vector3Clamp ALIAS "__Vector3Clamp" (v AS Vector3, min AS Vector3, max AS Vector3, result AS Vector3) ' Clamp provided vector between min and max vectors
    SUB Vector3ClampValue ALIAS "__Vector3ClampValue" (v AS Vector3, BYVAL min AS SINGLE, BYVAL max AS SINGLE, result AS Vector3) ' Clamp the magnitude of the vector between two min and max values
    FUNCTION Vector3Equals%% ALIAS "__Vector3Equals" (v1 AS Vector3, v2 AS Vector3) ' Check whether two given vectors are almost equal
    SUB Vector3Refract ALIAS "__Vector3Refract" (v AS Vector3, n AS Vector3, BYVAL r AS SINGLE, result AS Vector3) ' Compute the direction of a refracted ray where v specifies the normalized direction of the incoming ray, n specifies the normalized normal vector of the interface of two optical media, and r specifies the ratio of the refractive index of the medium from where the ray comes to the refractive index of the medium on the other side of the surface

    ' Matrix math
    FUNCTION MatrixDeterminant! ALIAS "__MatrixDeterminant" (mat AS Matrix) ' Compute matrix determinant
    FUNCTION MatrixTrace! ALIAS "__MatrixTrace" (mat AS Matrix) ' Get the trace of the matrix (sum of the values along the diagonal)
    SUB MatrixTranspose ALIAS "__MatrixTranspose" (mat AS Matrix, result AS Matrix) ' Transpose provided matrix
    SUB MatrixInvert ALIAS "__MatrixInvert" (mat AS Matrix, result AS Matrix) ' Invert provided matrix
    SUB MatrixIdentity ALIAS "__MatrixIdentity" (result AS Matrix) ' Get identity matrix
    SUB MatrixAdd ALIAS "__MatrixAdd" (mat1 AS Matrix, mat2 AS Matrix, result AS Matrix) ' Add two matrices
    SUB MatrixSubtract ALIAS "__MatrixSubtract" (mat1 AS Matrix, mat2 AS Matrix, result AS Matrix) ' Subtract two matrices
    SUB MatrixMultiply ALIAS "__MatrixMultiply" (mat1 AS Matrix, mat2 AS Matrix, result AS Matrix) ' Multiply two matrices NOTE: when multiplying matrices... the order matters!
    SUB MatrixTranslate ALIAS "__MatrixTranslate" (BYVAL x AS SINGLE, BYVAL y AS SINGLE, BYVAL z AS SINGLE, result AS Matrix) ' Get translation matrix
    SUB MatrixRotate ALIAS "__MatrixRotate" (axis AS Vector3, BYVAL angle AS SINGLE, result AS Matrix) ' Get x-rotation matrix NOTE: Angle must be provided in radians
    SUB MatrixRotateX ALIAS "__MatrixRotateX" (BYVAL angle AS SINGLE, result AS Matrix) ' Get x-rotation matrix NOTE: Angle must be provided in radians
    SUB MatrixRotateY ALIAS "__MatrixRotateY" (BYVAL angle AS SINGLE, result AS Matrix) ' Get y-rotation matrix NOTE: Angle must be provided in radians
    SUB MatrixRotateZ ALIAS "__MatrixRotateZ" (BYVAL angle AS SINGLE, result AS Matrix) ' Get z-rotation matrix NOTE: Angle must be provided in radians
    SUB MatrixRotateXYZ ALIAS "__MatrixRotateXYZ" (angle AS Vector3, result AS Matrix) ' Get xyz-rotation matrix NOTE: Angle must be provided in radians
    SUB MatrixRotateZYX ALIAS "__MatrixRotateZYX" (angle AS Vector3, result AS Matrix) ' Get zyx-rotation matrix NOTE: Angle must be provided in radians
    SUB MatrixScale ALIAS "__MatrixScale" (BYVAL x AS SINGLE, BYVAL y AS SINGLE, BYVAL z AS SINGLE, result AS Matrix) ' Get scaling matrix
    SUB MatrixFrustum ALIAS "__MatrixFrustum" (BYVAL r_left AS DOUBLE, BYVAL r_right AS DOUBLE, BYVAL r_bottom AS DOUBLE, BYVAL r_top AS DOUBLE, BYVAL r_near AS DOUBLE, BYVAL r_far AS DOUBLE, result AS Matrix) ' Get perspective projection matrix
    SUB MatrixPerspective ALIAS "__MatrixPerspective" (BYVAL fovy AS DOUBLE, BYVAL aspect AS DOUBLE, BYVAL near AS DOUBLE, BYVAL far AS DOUBLE, result AS Matrix) ' Get perspective projection matrix NOTE: Fovy angle must be provided in radians
    SUB MatrixOrtho ALIAS "__MatrixOrtho" (BYVAL r_left AS DOUBLE, BYVAL r_right AS DOUBLE, BYVAL r_bottom AS DOUBLE, BYVAL r_top AS DOUBLE, BYVAL r_near AS DOUBLE, BYVAL r_far AS DOUBLE, result AS Matrix) ' Get orthographic projection matrix
    SUB MatrixLookAt ALIAS "__MatrixLookAt" (eye AS Vector3, target AS Vector3, up AS Vector3, result AS Matrix) ' Get camera look-at matrix (view matrix)
    SUB MatrixToFloatV ALIAS "__MatrixToFloatV" (mat AS Matrix, result AS SINGLE) ' Get float array of matrix data (result). Example: MatrixToFloatV myMatrix, myFloatArray!(0)

    ' Quaternion math
    SUB QuaternionAdd ALIAS "__QuaternionAdd" (q1 AS Vector4, q2 AS Vector4, result AS Vector4) ' Add two quaternions
    SUB QuaternionAddValue ALIAS "__QuaternionAddValue" (q AS Vector4, BYVAL value AS SINGLE, result AS Vector4) ' Add quaternion and float value
    SUB QuaternionSubtract ALIAS "__QuaternionSubtract" (q1 AS Vector4, q2 AS Vector4, result AS Vector4) ' Subtract two quaternions
    SUB QuaternionSubtractValue ALIAS "__QuaternionSubtractValue" (q AS Vector4, BYVAL value AS SINGLE, result AS Vector4) ' Subtract quaternion and float value
    SUB QuaternionIdentity ALIAS "__QuaternionIdentity" (result AS Vector4) ' Get identity quaternion
    FUNCTION QuaternionLength! ALIAS "__QuaternionLength" (q AS Vector4) ' Computes the length of a quaternion
    SUB QuaternionNormalize ALIAS "__QuaternionNormalize" (q AS Vector4, result AS Vector4) ' Normalize provided quaternion
    SUB QuaternionInvert ALIAS "__QuaternionInvert" (q AS Vector4, result AS Vector4) ' Invert provided quaternion
    SUB QuaternionMultiply ALIAS "__QuaternionMultiply" (q1 AS Vector4, q2 AS Vector4, result AS Vector4) ' Calculate two quaternion multiplication
    SUB QuaternionScale ALIAS "__QuaternionScale" (q AS Vector4, BYVAL mul AS SINGLE, result AS Vector4) ' Scale quaternion by float value
    SUB QuaternionDivide ALIAS "__QuaternionDivide" (q1 AS Vector4, q2 AS Vector4, result AS Vector4) ' Divide two quaternions
    SUB QuaternionLerp ALIAS "__QuaternionLerp" (q1 AS Vector4, q2 AS Vector4, BYVAL amount AS SINGLE, result AS Vector4) ' Calculate linear interpolation between two quaternions
    SUB QuaternionNlerp ALIAS "__QuaternionNlerp" (q1 AS Vector4, q2 AS Vector4, BYVAL amount AS SINGLE, result AS Vector4) ' Calculate slerp-optimized interpolation between two quaternions
    SUB QuaternionSlerp ALIAS "__QuaternionSlerp" (q1 AS Vector4, q2 AS Vector4, BYVAL amount AS SINGLE, result AS Vector4) ' Calculate spherical linear interpolation between two quaternions
    SUB QuaternionFromVector3ToVector3 ALIAS "__QuaternionFromVector3ToVector3" (fromV3 AS Vector3, toV3 AS Vector3, result AS Vector4) ' Calculate quaternion based on the rotation from one vector to another
    SUB QuaternionFromMatrix ALIAS "__QuaternionFromMatrix" (mat AS Matrix, result AS Vector4) ' Get a quaternion for a given rotation matrix
    SUB QuaternionToMatrix ALIAS "__QuaternionToMatrix" (q AS Vector4, result AS Matrix) ' Get a matrix for a given quaternion
    SUB QuaternionFromAxisAngle ALIAS "__QuaternionFromAxisAngle" (axis AS Vector3, BYVAL angle AS SINGLE, result AS Vector4) ' Get rotation quaternion for an angle and axis NOTE: Angle must be provided in radians
    SUB QuaternionToAxisAngle ALIAS "__QuaternionToAxisAngle" (q AS Vector4, axis AS Vector3, angle AS SINGLE) ' Get the rotation angle and axis for a given quaternion
    SUB QuaternionFromEuler ALIAS "__QuaternionFromEuler" (BYVAL pitch AS SINGLE, BYVAL yaw AS SINGLE, BYVAL roll AS SINGLE, result AS Vector4) ' Get the quaternion equivalent to Euler angles NOTE: Rotation order is ZYX
    SUB QuaternionToEuler ALIAS "__QuaternionToEuler" (q AS Vector4, result AS Vector3) ' Transform a quaternion into Euler angles NOTE: Angles are returned in a Vector3 struct in radians
    SUB QuaternionTransform ALIAS "__QuaternionTransform" (q AS Vector4, mat AS Matrix, result AS Vector4) ' Transform a quaternion given a transformation matrix
    FUNCTION QuaternionEquals%% ALIAS "__QuaternionEquals" (q1 AS Vector4, q2 AS Vector4) ' Check whether two given quaternions are almost equal
END DECLARE
