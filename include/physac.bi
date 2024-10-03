'-----------------------------------------------------------------------------------------------------------------------
' physac bindings for QB64-PE
' Copyright (c) 2024 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$INCLUDEONCE

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

CONST SIZE_OF_POLYGON_DATA_POSITIONS = SIZE_OF_VECTOR2 * PHYSAC_MAX_VERTICES
CONST SIZE_OF_POLYGON_DATA_NORMALS = SIZE_OF_VECTOR2 * PHYSAC_MAX_VERTICES
TYPE PolygonData
    AS _UNSIGNED LONG vertexCount ' Current used vertex and normals count
    AS STRING * SIZE_OF_POLYGON_DATA_POSITIONS positions ' Polygon vertex positions vectors
    AS STRING * SIZE_OF_POLYGON_DATA_NORMALS normals ' Polygon vertex normals vectors
END TYPE

TYPE PhysicsShape
    AS LONG typ ' Physics shape type (circle or polygon)
    AS STRING * 4 __padding
    AS _UNSIGNED _OFFSET body ' Shape physics body reference
    AS SINGLE radius ' Circle shape radius (used for circle shapes)
    AS Matrix2x2 transform ' Vertices transform matrix 2x2
    AS PolygonData vertexData ' Polygon shape vertices position and normals data (just used for polygon shapes)
END TYPE

TYPE PhysicsBody
    AS _UNSIGNED LONG id ' Reference unique identifier
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
    AS PhysicsShape shape ' Physics body shape information (type, radius, vertices, normals)
END TYPE

DECLARE STATIC LIBRARY "physac"
    SUB InitPhysics ' Initializes physics values, pointers and creates physics loop thread
    SUB RunPhysicsStep ' Run physics step, to be used if PHYSICS_NO_THREADS is set in your main loop
    SUB SetPhysicsTimeStep (BYVAL delta AS DOUBLE) 'Sets physics fixed time step in milliseconds. 1.666666 by default
    FUNCTION IsPhysicsEnabled%% ALIAS "__IsPhysicsEnabled" ' Returns true if physics thread is currently enabled
    SUB SetPhysicsGravity (BYVAL x AS SINGLE, BYVAL y AS SINGLE) ' Sets physics global gravity force
    FUNCTION CreatePhysicsBodyCircle~%& ALIAS "__CreatePhysicsBodyCircle" (position AS Vector2, BYVAL radius AS SINGLE, BYVAL density AS SINGLE) ' Creates a new circle physics body with generic parameters
    FUNCTION CreatePhysicsBodyRectangle~%& ALIAS "__CreatePhysicsBodyRectangle" (position AS Vector2, BYVAL wid AS SINGLE, BYVAL hgt AS SINGLE, BYVAL density AS SINGLE) ' Creates a new rectangle physics body with generic parameters
    FUNCTION CreatePhysicsBodyPolygon~%& ALIAS "__CreatePhysicsBodyPolygon" (position AS Vector2, BYVAL radius AS SINGLE, BYVAL sides AS LONG, BYVAL density AS SINGLE) ' Creates a new polygon physics body with generic parameters
    SUB PhysicsAddForce ALIAS "__PhysicsAddForce" (BYVAL body AS _UNSIGNED _OFFSET, force AS Vector2) ' Adds a force to a physics body
    SUB PhysicsAddTorque ALIAS "__PhysicsAddTorque" (BYVAL body AS _UNSIGNED _OFFSET, BYVAL amount AS SINGLE) ' Adds a angular force to a physics body
    SUB PhysicsShatter ALIAS "__PhysicsShatter" (BYVAL body AS _UNSIGNED _OFFSET, position AS Vector2, BYVAL force AS SINGLE) ' Shatters a polygon shape physics body to little physics bodies with explosion force
    FUNCTION GetPhysicsBodiesCount& ' Returns the current amount of created physics bodies
    FUNCTION GetPhysicsBody~%& (BYVAL index AS LONG) ' Returns a physics body of the bodies pool at a specific index
    FUNCTION GetPhysicsShapeType& (BYVAL index AS LONG) ' Returns the physics body shape type (PHYSICS_CIRCLE or PHYSICS_POLYGON)
    FUNCTION GetPhysicsShapeVerticesCount& (BYVAL index AS LONG) ' Returns the amount of vertices of a physics body shape
    SUB GetPhysicsShapeVertex ALIAS "__GetPhysicsShapeVertex" (BYVAL body AS _UNSIGNED _OFFSET, BYVAL vertex AS LONG, retVal AS Vector2) ' Returns transformed position of a body shape (body position + vertex transformed position)
    SUB SetPhysicsBodyRotation ALIAS "__SetPhysicsBodyRotation" (BYVAL body AS _UNSIGNED _OFFSET, BYVAL radians AS SINGLE) ' Sets physics body shape transform based on radians parameter
    SUB DestroyPhysicsBody ALIAS "__DestroyPhysicsBody" (BYVAL body AS _UNSIGNED _OFFSET) ' Unitializes physics pointers and closes physics loop thread
    SUB ClosePhysics ' Unitializes physics pointers and closes physics loop thread
END DECLARE
