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
    'float MatrixDeterminant(Matrix mat);                                        ' Compute matrix determinant
    'float MatrixTrace(Matrix mat);                                              ' Get the trace of the matrix (sum of the values along the diagonal)
    'Matrix MatrixTranspose(Matrix mat);                                         ' Transposes provided matrix
    'Matrix MatrixInvert(Matrix mat);                                            ' Invert provided matrix
    'Matrix MatrixIdentity(void);                                                ' Get identity matrix
    'Matrix MatrixAdd(Matrix left, Matrix right);                                ' Add two matrices
    'Matrix MatrixSubtract(Matrix left, Matrix right);                           ' Subtract two matrices (left - right)
    'Matrix MatrixMultiply(Matrix left, Matrix right);                           ' Get two matrix multiplication NOTE: When multiplying matrices... the order matters!
    'Matrix MatrixTranslate(float x, float y, float z);                          ' Get translation matrix
    'Matrix MatrixRotate(Vector3 axis, float angle);                             ' Create rotation matrix from axis and angle NOTE: Angle should be provided in radians
    'Matrix MatrixRotateX(float angle);                                          ' Get x-rotation matrix NOTE: Angle must be provided in radians
    'Matrix MatrixRotateY(float angle);                                          ' Get y-rotation matrix NOTE: Angle must be provided in radians
    'Matrix MatrixRotateZ(float angle);                                          ' Get z-rotation matrix NOTE: Angle must be provided in radians
    'Matrix MatrixRotateXYZ(Vector3 angle);                                      ' Get xyz-rotation matrix NOTE: Angle must be provided in radians
    'Matrix MatrixRotateZYX(Vector3 angle);                                      ' Get zyx-rotation matrix NOTE: Angle must be provided in radians
    'Matrix MatrixScale(float x, float y, float z);                              ' Get scaling matrix
    'Matrix MatrixFrustum(double left, double right, double bottom, double top, double near, double far); ' Get perspective projection matrix
    'Matrix MatrixPerspective(double fovy, double aspect, double near, double far); ' Get perspective projection matrix NOTE: Fovy angle must be provided in radians
    'Matrix MatrixOrtho(double left, double right, double bottom, double top, double near, double far); ' Get orthographic projection matrix
    'Matrix MatrixLookAt(Vector3 eye, Vector3 target, Vector3 up);               ' Get camera look-at matrix (view matrix)
    'float16 MatrixToFloatV(Matrix mat);                                         ' Get float array of matrix data

    ' Quaternion math
    'Quaternion QuaternionAdd(Quaternion q1, Quaternion q2);                     ' Add two quaternions
    'Quaternion QuaternionAddValue(Quaternion q, float add);                     ' Add quaternion and float value
    'Quaternion QuaternionSubtract(Quaternion q1, Quaternion q2);                ' Subtract two quaternions
    'Quaternion QuaternionSubtractValue(Quaternion q, float sub);                ' Subtract quaternion and float value
    'Quaternion QuaternionIdentity(void);                                        ' Get identity quaternion
    'float QuaternionLength(Quaternion q);                                       ' Computes the length of a quaternion
    'Quaternion QuaternionNormalize(Quaternion q);                               ' Normalize provided quaternion
    'Quaternion QuaternionInvert(Quaternion q);                                  ' Invert provided quaternion
    'Quaternion QuaternionMultiply(Quaternion q1, Quaternion q2);                ' Calculate two quaternion multiplication
    'Quaternion QuaternionScale(Quaternion q, float mul);                        ' Scale quaternion by float value
    'Quaternion QuaternionDivide(Quaternion q1, Quaternion q2);                  ' Divide two quaternions
    'Quaternion QuaternionLerp(Quaternion q1, Quaternion q2, float amount);      ' Calculate linear interpolation between two quaternions
    'Quaternion QuaternionNlerp(Quaternion q1, Quaternion q2, float amount);     ' Calculate slerp-optimized interpolation between two quaternions
    'Quaternion QuaternionSlerp(Quaternion q1, Quaternion q2, float amount);     ' Calculates spherical linear interpolation between two quaternions
    'Quaternion QuaternionFromVector3ToVector3(Vector3 from, Vector3 to);        ' Calculate quaternion based on the rotation from one vector to another
    'Quaternion QuaternionFromMatrix(Matrix mat);                                ' Get a quaternion for a given rotation matrix
    'Matrix QuaternionToMatrix(Quaternion q);                                    ' Get a matrix for a given quaternion
    'Quaternion QuaternionFromAxisAngle(Vector3 axis, float angle);              ' Get rotation quaternion for an angle and axis NOTE: Angle must be provided in radians
    'void QuaternionToAxisAngle(Quaternion q, Vector3 *outAxis, float *outAngle); ' Get the rotation angle and axis for a given quaternion
    'Quaternion QuaternionFromEuler(float pitch, float yaw, float roll);         ' Get the quaternion equivalent to Euler angles NOTE: Rotation order is ZYX
    'Vector3 QuaternionToEuler(Quaternion q);                                    ' Get the Euler angles equivalent to quaternion (roll, pitch, yaw) NOTE: Angles are returned in a Vector3 struct in radians
    'Quaternion QuaternionTransform(Quaternion q, Matrix mat);                   ' Transform a quaternion given a transformation matrix
    'int QuaternionEquals(Quaternion p, Quaternion q);                           ' Check whether two given quaternions are almost equal
END DECLARE
