'-----------------------------------------------------------------------------------------------------------------------
' physac bindings for QB64-PE
' Copyright (c) 2023 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$IF PHYSAC_BI = UNDEFINED THEN
    $LET PHYSAC_BI = TRUE

    '$INCLUDE:'raylib.bi'

    CONST PHYSAC_MAX_BODIES = 64 ' Maximum number of physic bodies supported
    CONST PHYSAC_MAX_MANIFOLDS = 4096 ' Maximum number of physic bodies interactions (64x64)
    CONST PHYSAC_MAX_VERTICES = 24 ' Maximum number of vertex for polygons shapes
    CONST PHYSAC_DEFAULT_CIRCLE_VERTICES = 24 ' Default number of vertices for circle shapes

    CONST PHYSAC_COLLISION_ITERATIONS = 100
    CONST PHYSAC_PENETRATION_ALLOWANCE = 0.05!
    CONST PHYSAC_PENETRATION_CORRECTION = 0.4!

    CONST PHYSAC_PI = 3.14159265358979323846!
    CONST PHYSAC_DEG2RAD = PHYSAC_PI / 180.0!

    CONST PHYSICS_CIRCLE = 0
    CONST PHYSICS_POLYGON = 1

    ' Matrix2x2 type (used for polygon shape rotation matrix)
    TYPE Matrix2x2
        AS SINGLE m00
        AS SINGLE m01
        AS SINGLE m10
        AS SINGLE m11
    END TYPE

    CONST SIZE_OF_PHYSICS_VERTEX_DATA_POSITIONS = SIZE_OF_VECTOR2 * PHYSAC_MAX_VERTICES
    CONST SIZE_OF_PHYSICS_VERTEX_DATA_NORMALS = SIZE_OF_VECTOR2 * PHYSAC_MAX_VERTICES
    TYPE PhysicsVertexData
        AS _UNSIGNED LONG vertexCount ' Vertex count (positions and normals)
        AS STRING * SIZE_OF_PHYSICS_VERTEX_DATA_POSITIONS positions ' Vertex positions vectors
        AS STRING * SIZE_OF_PHYSICS_VERTEX_DATA_NORMALS normals ' Vertex normals vectors
    END TYPE

    TYPE PhysicsShape
        AS LONG typ ' Shape type (circle or polygon)
        AS STRING * 4 __padding
        AS _UNSIGNED _OFFSET body ' Shape physics body data pointer
        AS PhysicsVertexData vertexData ' Shape vertices data (used for polygon shapes)
        AS SINGLE radius ' Shape radius (used for circle shapes)
        AS Matrix2x2 transform ' Vertices transform matrix 2x2
    END TYPE

    TYPE PhysicsBody
        AS _UNSIGNED LONG id ' Unique identifier
        AS LONG enabled ' Enabled dynamics state (collisions are calculated anyway)
        AS Vector2 position ' Physics body shape pivot
        AS Vector2 velocity ' Current linear velocity applied to position
        AS Vector2 force ' Current linear force (reset to 0 every step)
        AS SINGLE angularVelocity ' Current angular velocity applied to orient
        AS SINGLE torque ' Current angular force (reset to 0 every step)
        AS SINGLE orient ' Rotation in radians
        AS SINGLE inertia ' Moment of inertia
        AS SINGLE inverseInertia ' Inverse value of inertia
        AS SINGLE mass ' Physics body mass
        AS SINGLE inverseMass ' Inverse value of mass
        AS SINGLE staticFriction ' Friction when the body has not movement (0 to 1)
        AS SINGLE dynamicFriction ' Friction when the body has movement (0 to 1)
        AS SINGLE restitution ' Restitution coefficient of the body (0 to 1)
        AS _BYTE useGravity ' Apply gravity force to dynamics
        AS _BYTE isGrounded ' Physics grounded on other body state
        AS INTEGER freezeOrient ' Physics rotation constraint
        AS STRING * 4 __padding
        AS PhysicsShape shape ' Physics body shape information (type, radius, vertices, transform)
    END TYPE

    DECLARE CUSTOMTYPE LIBRARY "physac"
        SUB InitPhysics
        SUB UpdatePhysics
        SUB ResetPhysics
        SUB ClosePhysics
        SUB SetPhysicsTimeStep (BYVAL delta AS DOUBLE)
        SUB SetPhysicsGravity (BYVAL x AS SINGLE, BYVAL y AS SINGLE)
        FUNCTION CreatePhysicsBodyCircle~%& ALIAS __CreatePhysicsBodyCircle (position AS Vector2, BYVAL radius AS SINGLE, BYVAL density AS SINGLE)
        FUNCTION CreatePhysicsBodyRectangle~%& ALIAS __CreatePhysicsBodyRectangle (position AS Vector2, BYVAL wid AS SINGLE, BYVAL hgt AS SINGLE, BYVAL density AS SINGLE)
        FUNCTION CreatePhysicsBodyPolygon~%& ALIAS __CreatePhysicsBodyPolygon (position AS Vector2, BYVAL radius AS SINGLE, BYVAL sides AS LONG, BYVAL density AS SINGLE)
        SUB DestroyPhysicsBody ALIAS __DestroyPhysicsBody (BYVAL body AS _UNSIGNED _OFFSET)
        SUB PhysicsAddForce ALIAS __PhysicsAddForce (BYVAL body AS _UNSIGNED _OFFSET, force AS Vector2)
        SUB PhysicsAddTorque ALIAS __PhysicsAddTorque (BYVAL body AS _UNSIGNED _OFFSET, BYVAL amount AS SINGLE)
        SUB PhysicsShatter ALIAS __PhysicsShatter (BYVAL body AS _UNSIGNED _OFFSET, position AS Vector2, BYVAL force AS SINGLE)
        SUB SetPhysicsBodyRotation ALIAS __SetPhysicsBodyRotation (BYVAL body AS _UNSIGNED _OFFSET, BYVAL radians AS SINGLE)
        FUNCTION GetPhysicsBody~%& (BYVAL index AS LONG)
        FUNCTION GetPhysicsBodiesCount&
        FUNCTION GetPhysicsShapeType& (BYVAL index AS LONG)
        FUNCTION GetPhysicsShapeVerticesCount& (BYVAL index AS LONG)
        SUB GetPhysicsShapeVertex ALIAS __GetPhysicsShapeVertex (BYVAL body AS _UNSIGNED _OFFSET, BYVAL vertex AS LONG, retVal AS Vector2)
    END DECLARE

$END IF
