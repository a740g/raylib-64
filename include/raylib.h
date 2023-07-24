//----------------------------------------------------------------------------------------------------------------------
// raylib bindings for QB64-PE
// Copyright (c) 2023 Samuel Gomes
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#include <cstdint>
#include "external/dylib.hpp"

#define RAYLIB_DEBUG_PRINT(_fmt_, _args_...) fprintf(stderr, "\e[1;37mDEBUG: %s:%d:%s(): \e[1;33m" _fmt_ "\e[1;37m\n", __FILE__, __LINE__, __func__, ##_args_)
#define RAYLIB_DEBUG_CHECK(_exp_) \
    if (!(_exp_))                 \
    RAYLIB_DEBUG_PRINT("\e[0;31mCondition (%s) failed", #_exp_)

// QB64 false is 0 and true is -1 (sad, but true XD)
enum qb_bool : int8_t
{
    QB_TRUE = -1,
    QB_FALSE = false
};

// This one is just for safety just in case someone is doing _exp_ == 1 inside raylib
#define TO_C_BOOL(_exp_) ((_exp_) != false)
// We have to do this for the QB64 side
#define TO_QB_BOOL(_exp_) ((qb_bool)(-TO_C_BOOL(_exp_)))

#if !defined(RL_VECTOR2_TYPE)
// Vector2, 2 components
struct Vector2
{
    float x; // Vector x component
    float y; // Vector y component
};
#define RL_VECTOR2_TYPE 1
#endif

// Vector3, 3 components
struct Vector3
{
    float x; // Vector x component
    float y; // Vector y component
    float z; // Vector z component
};

// Vector4, 4 components
struct Vector4
{
    float x; // Vector x component
    float y; // Vector y component
    float z; // Vector z component
    float w; // Vector w component
};

// Quaternion, 4 components (Vector4 alias)
typedef Vector4 Quaternion;

// Matrix, 4x4 components, column major, OpenGL style, right-handed
struct Matrix
{
    float m0, m4, m8, m12;  // Matrix first row (4 components)
    float m1, m5, m9, m13;  // Matrix second row (4 components)
    float m2, m6, m10, m14; // Matrix third row (4 components)
    float m3, m7, m11, m15; // Matrix fourth row (4 components)
};

// Rectangle, 4 components
struct RRectangle
{
    float x;      // Rectangle top-left corner position x
    float y;      // Rectangle top-left corner position y
    float width;  // Rectangle width
    float height; // Rectangle height
};

// Image, pixel data stored in CPU memory (RAM)
struct Image
{
    void *data;  // Image raw data
    int width;   // Image base width
    int height;  // Image base height
    int mipmaps; // Mipmap levels, 1 by default
    int format;  // Data format (PixelFormat type)
};

// Texture, tex data stored in GPU memory (VRAM)
struct Texture
{
    unsigned int id; // OpenGL texture id
    int width;       // Texture base width
    int height;      // Texture base height
    int mipmaps;     // Mipmap levels, 1 by default
    int format;      // Data format (PixelFormat type)
};

// Texture2D, same as Texture
typedef Texture Texture2D;

// TextureCubemap, same as Texture
typedef Texture TextureCubemap;

// RenderTexture, fbo for texture rendering
struct RenderTexture
{
    unsigned int id; // OpenGL framebuffer object id
    Texture texture; // Color buffer attachment texture
    Texture depth;   // Depth buffer attachment texture
};

// RenderTexture2D, same as RenderTexture
typedef RenderTexture RenderTexture2D;

// NPatchInfo, n-patch layout info
struct NPatchInfo
{
    RRectangle source; // Texture source rectangle
    int left;          // Left border offset
    int top;           // Top border offset
    int right;         // Right border offset
    int bottom;        // Bottom border offset
    int layout;        // Layout of the n-patch: 3x3, 1x3 or 3x1
};

// GlyphInfo, font characters glyphs info
struct GlyphInfo
{
    int value;    // Character value (Unicode)
    int offsetX;  // Character offset X when drawing
    int offsetY;  // Character offset Y when drawing
    int advanceX; // Character advance position X
    Image image;  // Character image data
};

// Font, font texture and GlyphInfo array data
struct Font
{
    int baseSize;      // Base size (default chars height)
    int glyphCount;    // Number of glyph characters
    int glyphPadding;  // Padding around the glyph characters
    Texture2D texture; // Texture atlas containing the glyphs
    RRectangle *recs;  // Rectangles in texture for the glyphs
    GlyphInfo *glyphs; // Glyphs info data
};

// Camera, defines position/orientation in 3d space
struct Camera3D
{
    Vector3 position; // Camera position
    Vector3 target;   // Camera target it looks-at
    Vector3 up;       // Camera up vector (rotation over its axis)
    float fovy;       // Camera field-of-view aperture in Y (degrees) in perspective, used as near plane width in orthographic
    int projection;   // Camera projection: CAMERA_PERSPECTIVE or CAMERA_ORTHOGRAPHIC
};

typedef Camera3D Camera; // Camera type fallback, defaults to Camera3D

// Camera2D, defines position/orientation in 2d space
struct Camera2D
{
    Vector2 offset; // Camera offset (displacement from target)
    Vector2 target; // Camera target (rotation and zoom origin)
    float rotation; // Camera rotation in degrees
    float zoom;     // Camera zoom (scaling), should be 1.0f by default
};

// Mesh, vertex data and vao/vbo
struct Mesh
{
    int vertexCount;   // Number of vertices stored in arrays
    int triangleCount; // Number of triangles stored (indexed or not)

    // Vertex attributes data
    float *vertices;         // Vertex position (XYZ - 3 components per vertex) (shader-location = 0)
    float *texcoords;        // Vertex texture coordinates (UV - 2 components per vertex) (shader-location = 1)
    float *texcoords2;       // Vertex texture second coordinates (UV - 2 components per vertex) (shader-location = 5)
    float *normals;          // Vertex normals (XYZ - 3 components per vertex) (shader-location = 2)
    float *tangents;         // Vertex tangents (XYZW - 4 components per vertex) (shader-location = 4)
    unsigned char *colors;   // Vertex colors (RGBA - 4 components per vertex) (shader-location = 3)
    unsigned short *indices; // Vertex indices (in case vertex data comes indexed)

    // Animation vertex data
    float *animVertices;    // Animated vertex positions (after bones transformations)
    float *animNormals;     // Animated normals (after bones transformations)
    unsigned char *boneIds; // Vertex bone ids, max 255 bone ids, up to 4 bones influence by vertex (skinning)
    float *boneWeights;     // Vertex bone weight, up to 4 bones influence by vertex (skinning)

    // OpenGL identifiers
    unsigned int vaoId;  // OpenGL Vertex Array Object id
    unsigned int *vboId; // OpenGL Vertex Buffer Objects id (default vertex data)
};

// Shader
struct Shader
{
    unsigned int id; // Shader program id
    int *locs;       // Shader locations array (RL_MAX_SHADER_LOCATIONS)
};

// MaterialMap
struct MaterialMap
{
    Texture2D texture; // Material map texture
    uint32_t color;    // Material map color
    float value;       // Material map value
};

// Material, includes shader and maps
struct Material
{
    Shader shader;     // Material shader
    MaterialMap *maps; // Material maps array (MAX_MATERIAL_MAPS)
    float params[4];   // Material generic parameters (if required)
};

// Transform, vertex transformation data
struct Transform
{
    Vector3 translation; // Translation
    Quaternion rotation; // Rotation
    Vector3 scale;       // Scale
};

// Bone, skeletal animation bone
struct BoneInfo
{
    char name[32]; // Bone name
    int parent;    // Bone parent
};

// Model, meshes, materials and animation data
struct Model
{
    Matrix transform; // Local transform matrix

    int meshCount;       // Number of meshes
    int materialCount;   // Number of materials
    Mesh *meshes;        // Meshes array
    Material *materials; // Materials array
    int *meshMaterial;   // Mesh material number

    // Animation data
    int boneCount;       // Number of bones
    BoneInfo *bones;     // Bones information (skeleton)
    Transform *bindPose; // Bones base transformation (pose)
};

// ModelAnimation
struct ModelAnimation
{
    int boneCount;          // Number of bones
    int frameCount;         // Number of animation frames
    BoneInfo *bones;        // Bones information (skeleton)
    Transform **framePoses; // Poses array by frame
};

// Ray, ray for raycasting
struct Ray
{
    Vector3 position;  // Ray position (origin)
    Vector3 direction; // Ray direction
};

// RayCollision, ray hit information
struct RayCollision
{
    bool hit;       // Did the ray hit something?
    float distance; // Distance to the nearest hit
    Vector3 point;  // Point of the nearest hit
    Vector3 normal; // Surface normal of hit
};

// BoundingBox
struct BoundingBox
{
    Vector3 min; // Minimum vertex box-corner
    Vector3 max; // Maximum vertex box-corner
};

// Wave, audio wave data
struct Wave
{
    unsigned int frameCount; // Total number of frames (considering channels)
    unsigned int sampleRate; // Frequency (samples per second)
    unsigned int sampleSize; // Bit depth (bits per sample): 8, 16, 32 (24 not supported)
    unsigned int channels;   // Number of channels (1-mono, 2-stereo, ...)
    void *data;              // Buffer data pointer
};

// Opaque structs declaration
// NOTE: Actual structs are defined internally in raudio module
typedef struct rAudioBuffer rAudioBuffer;
typedef struct rAudioProcessor rAudioProcessor;

// AudioStream, custom audio stream
struct AudioStream
{
    rAudioBuffer *buffer;       // Pointer to internal data used by the audio system
    rAudioProcessor *processor; // Pointer to internal data processor, useful for audio effects

    unsigned int sampleRate; // Frequency (samples per second)
    unsigned int sampleSize; // Bit depth (bits per sample): 8, 16, 32 (24 not supported)
    unsigned int channels;   // Number of channels (1-mono, 2-stereo, ...)
};

// Sound
struct Sound
{
    AudioStream stream;      // Audio stream
    unsigned int frameCount; // Total number of frames (considering channels)
};

// Music, audio stream, anything longer than ~10 seconds should be streamed
struct Music
{
    AudioStream stream;      // Audio stream
    unsigned int frameCount; // Total number of frames (considering channels)
    bool looping;            // Music looping enable

    int ctxType;   // Type of music context (audio filetype)
    void *ctxData; // Audio context data, depends on type
};

// VrDeviceInfo, Head-Mounted-Display device parameters
struct VrDeviceInfo
{
    int hResolution;               // Horizontal resolution in pixels
    int vResolution;               // Vertical resolution in pixels
    float hScreenSize;             // Horizontal size in meters
    float vScreenSize;             // Vertical size in meters
    float vScreenCenter;           // Screen center in meters
    float eyeToScreenDistance;     // Distance between eye and display in meters
    float lensSeparationDistance;  // Lens separation distance in meters
    float interpupillaryDistance;  // IPD (distance between pupils) in meters
    float lensDistortionValues[4]; // Lens distortion constant parameters
    float chromaAbCorrection[4];   // Chromatic aberration correction parameters
};

// VrStereoConfig, VR stereo rendering configuration for simulator
struct VrStereoConfig
{
    Matrix projection[2];       // VR projection matrices (per eye)
    Matrix viewOffset[2];       // VR view offset matrices (per eye)
    float leftLensCenter[2];    // VR left lens center
    float rightLensCenter[2];   // VR right lens center
    float leftScreenCenter[2];  // VR left screen center
    float rightScreenCenter[2]; // VR right screen center
    float scale[2];             // VR distortion scale
    float scaleIn[2];           // VR distortion scale in
};

// File path list
struct FilePathList
{
    unsigned int capacity; // Filepaths max entries
    unsigned int count;    // Filepaths entries count
    char **paths;          // Filepaths entries
};

// Callbacks to hook some internal functions
// WARNING: These callbacks are intended for advance users
typedef void (*TraceLogCallback)(int logLevel, const char *text, va_list args);                    // Logging: Redirect trace log messages
typedef unsigned char *(*LoadFileDataCallback)(const char *fileName, unsigned int *bytesRead);     // FileIO: Load binary data
typedef bool (*SaveFileDataCallback)(const char *fileName, void *data, unsigned int bytesToWrite); // FileIO: Save binary data
typedef char *(*LoadFileTextCallback)(const char *fileName);                                       // FileIO: Load text data
typedef bool (*SaveFileTextCallback)(const char *fileName, char *text);                            // FileIO: Save text data
typedef void (*AudioCallback)(void *bufferData, unsigned int frames);                              // Audio: Audio processing

static dylib *raylib = nullptr; //  this is our raylib shared library object

//----------------------------------------------------------------------------------------------------------------------
// Autogenerated raw global static raylib function pointers
//----------------------------------------------------------------------------------------------------------------------
static void (*_InitWindow)(int width, int height, const char *title) = nullptr;
static bool (*_WindowShouldClose)(void) = nullptr;
static void (*_CloseWindow)(void) = nullptr;
static bool (*_IsWindowReady)(void) = nullptr;
static bool (*_IsWindowFullscreen)(void) = nullptr;
static bool (*_IsWindowHidden)(void) = nullptr;
static bool (*_IsWindowMinimized)(void) = nullptr;
static bool (*_IsWindowMaximized)(void) = nullptr;
static bool (*_IsWindowFocused)(void) = nullptr;
static bool (*_IsWindowResized)(void) = nullptr;
static bool (*_IsWindowState)(unsigned int flag) = nullptr;
static void (*_SetWindowState)(unsigned int flags) = nullptr;
static void (*_ClearWindowState)(unsigned int flags) = nullptr;
static void (*_ToggleFullscreen)(void) = nullptr;
static void (*_MaximizeWindow)(void) = nullptr;
static void (*_MinimizeWindow)(void) = nullptr;
static void (*_RestoreWindow)(void) = nullptr;
static void (*_SetWindowIcon)(Image image) = nullptr;
static void (*_SetWindowIcons)(Image *images, int count) = nullptr;
static void (*_SetWindowTitle)(const char *title) = nullptr;
static void (*_SetWindowPosition)(int x, int y) = nullptr;
static void (*_SetWindowMonitor)(int monitor) = nullptr;
static void (*_SetWindowMinSize)(int width, int height) = nullptr;
static void (*_SetWindowSize)(int width, int height) = nullptr;
static void (*_SetWindowOpacity)(float opacity) = nullptr;
static void *(*_GetWindowHandle)(void) = nullptr;
static int (*_GetScreenWidth)(void) = nullptr;
static int (*_GetScreenHeight)(void) = nullptr;
static int (*_GetRenderWidth)(void) = nullptr;
static int (*_GetRenderHeight)(void) = nullptr;
static int (*_GetMonitorCount)(void) = nullptr;
static int (*_GetCurrentMonitor)(void) = nullptr;
static Vector2 (*_GetMonitorPosition)(int monitor) = nullptr;
static int (*_GetMonitorWidth)(int monitor) = nullptr;
static int (*_GetMonitorHeight)(int monitor) = nullptr;
static int (*_GetMonitorPhysicalWidth)(int monitor) = nullptr;
static int (*_GetMonitorPhysicalHeight)(int monitor) = nullptr;
static int (*_GetMonitorRefreshRate)(int monitor) = nullptr;
static Vector2 (*_GetWindowPosition)(void) = nullptr;
static Vector2 (*_GetWindowScaleDPI)(void) = nullptr;
static const char *(*_GetMonitorName)(int monitor) = nullptr;
static void (*_SetClipboardText)(const char *text) = nullptr;
static const char *(*_GetClipboardText)(void) = nullptr;
static void (*_EnableEventWaiting)(void) = nullptr;
static void (*_DisableEventWaiting)(void) = nullptr;
static void (*_SwapScreenBuffer)(void) = nullptr;
static void (*_PollInputEvents)(void) = nullptr;
static void (*_WaitTime)(double seconds) = nullptr;
static void (*_ShowCursor)(void) = nullptr;
static void (*_HideCursor)(void) = nullptr;
static bool (*_IsCursorHidden)(void) = nullptr;
static void (*_EnableCursor)(void) = nullptr;
static void (*_DisableCursor)(void) = nullptr;
static bool (*_IsCursorOnScreen)(void) = nullptr;
static void (*_ClearBackground)(uint32_t color) = nullptr;
static void (*_BeginDrawing)(void) = nullptr;
static void (*_EndDrawing)(void) = nullptr;
static void (*_BeginMode2D)(Camera2D camera) = nullptr;
static void (*_EndMode2D)(void) = nullptr;
static void (*_BeginMode3D)(Camera3D camera) = nullptr;
static void (*_EndMode3D)(void) = nullptr;
static void (*_BeginTextureMode)(RenderTexture2D target) = nullptr;
static void (*_EndTextureMode)(void) = nullptr;
static void (*_BeginShaderMode)(Shader shader) = nullptr;
static void (*_EndShaderMode)(void) = nullptr;
static void (*_BeginBlendMode)(int mode) = nullptr;
static void (*_EndBlendMode)(void) = nullptr;
static void (*_BeginScissorMode)(int x, int y, int width, int height) = nullptr;
static void (*_EndScissorMode)(void) = nullptr;
static void (*_BeginVrStereoMode)(VrStereoConfig config) = nullptr;
static void (*_EndVrStereoMode)(void) = nullptr;
static VrStereoConfig (*_LoadVrStereoConfig)(VrDeviceInfo device) = nullptr;
static void (*_UnloadVrStereoConfig)(VrStereoConfig config) = nullptr;
static Shader (*_LoadShader)(const char *vsFileName, const char *fsFileName) = nullptr;
static Shader (*_LoadShaderFromMemory)(const char *vsCode, const char *fsCode) = nullptr;
static bool (*_IsShaderReady)(Shader shader) = nullptr;
static int (*_GetShaderLocation)(Shader shader, const char *uniformName) = nullptr;
static int (*_GetShaderLocationAttrib)(Shader shader, const char *attribName) = nullptr;
static void (*_SetShaderValue)(Shader shader, int locIndex, const void *value, int uniformType) = nullptr;
static void (*_SetShaderValueV)(Shader shader, int locIndex, const void *value, int uniformType, int count) = nullptr;
static void (*_SetShaderValueMatrix)(Shader shader, int locIndex, Matrix mat) = nullptr;
static void (*_SetShaderValueTexture)(Shader shader, int locIndex, Texture2D texture) = nullptr;
static void (*_UnloadShader)(Shader shader) = nullptr;
static Ray (*_GetMouseRay)(Vector2 mousePosition, Camera camera) = nullptr;
static Matrix (*_GetCameraMatrix)(Camera camera) = nullptr;
static Matrix (*_GetCameraMatrix2D)(Camera2D camera) = nullptr;
static Vector2 (*_GetWorldToScreen)(Vector3 position, Camera camera) = nullptr;
static Vector2 (*_GetScreenToWorld2D)(Vector2 position, Camera2D camera) = nullptr;
static Vector2 (*_GetWorldToScreenEx)(Vector3 position, Camera camera, int width, int height) = nullptr;
static Vector2 (*_GetWorldToScreen2D)(Vector2 position, Camera2D camera) = nullptr;
static void (*_SetTargetFPS)(int fps) = nullptr;
static int (*_GetFPS)(void) = nullptr;
static float (*_GetFrameTime)(void) = nullptr;
static double (*_GetTime)(void) = nullptr;
static int (*_GetRandomValue)(int min, int max) = nullptr;
static void (*_SetRandomSeed)(unsigned int seed) = nullptr;
static void (*_TakeScreenshot)(const char *fileName) = nullptr;
static void (*_SetConfigFlags)(unsigned int flags) = nullptr;
static void (*_TraceLog)(int logLevel, const char *text, ...) = nullptr;
static void (*_SetTraceLogLevel)(int logLevel) = nullptr;
static void *(*_MemAlloc)(unsigned int size) = nullptr;
static void *(*_MemRealloc)(void *ptr, unsigned int size) = nullptr;
static void (*_MemFree)(void *ptr) = nullptr;
static void (*_OpenURL)(const char *url) = nullptr;
static void (*_SetTraceLogCallback)(TraceLogCallback callback) = nullptr;
static void (*_SetLoadFileDataCallback)(LoadFileDataCallback callback) = nullptr;
static void (*_SetSaveFileDataCallback)(SaveFileDataCallback callback) = nullptr;
static void (*_SetLoadFileTextCallback)(LoadFileTextCallback callback) = nullptr;
static void (*_SetSaveFileTextCallback)(SaveFileTextCallback callback) = nullptr;
static unsigned char *(*_LoadFileData)(const char *fileName, unsigned int *bytesRead) = nullptr;
static void (*_UnloadFileData)(unsigned char *data) = nullptr;
static bool (*_SaveFileData)(const char *fileName, void *data, unsigned int bytesToWrite) = nullptr;
static bool (*_ExportDataAsCode)(const unsigned char *data, unsigned int size, const char *fileName) = nullptr;
static char *(*_LoadFileText)(const char *fileName) = nullptr;
static void (*_UnloadFileText)(char *text) = nullptr;
static bool (*_SaveFileText)(const char *fileName, char *text) = nullptr;
static bool (*_FileExists)(const char *fileName) = nullptr;
static bool (*_DirectoryExists)(const char *dirPath) = nullptr;
static bool (*_IsFileExtension)(const char *fileName, const char *ext) = nullptr;
static int (*_GetFileLength)(const char *fileName) = nullptr;
static const char *(*_GetFileExtension)(const char *fileName) = nullptr;
static const char *(*_GetFileName)(const char *filePath) = nullptr;
static const char *(*_GetFileNameWithoutExt)(const char *filePath) = nullptr;
static const char *(*_GetDirectoryPath)(const char *filePath) = nullptr;
static const char *(*_GetPrevDirectoryPath)(const char *dirPath) = nullptr;
static const char *(*_GetWorkingDirectory)(void) = nullptr;
static const char *(*_GetApplicationDirectory)(void) = nullptr;
static bool (*_ChangeDirectory)(const char *dir) = nullptr;
static bool (*_IsPathFile)(const char *path) = nullptr;
static FilePathList (*_LoadDirectoryFiles)(const char *dirPath) = nullptr;
static FilePathList (*_LoadDirectoryFilesEx)(const char *basePath, const char *filter, bool scanSubdirs) = nullptr;
static void (*_UnloadDirectoryFiles)(FilePathList files) = nullptr;
static bool (*_IsFileDropped)(void) = nullptr;
static FilePathList (*_LoadDroppedFiles)(void) = nullptr;
static void (*_UnloadDroppedFiles)(FilePathList files) = nullptr;
static long (*_GetFileModTime)(const char *fileName) = nullptr;
static unsigned char *(*_CompressData)(const unsigned char *data, int dataSize, int *compDataSize) = nullptr;
static unsigned char *(*_DecompressData)(const unsigned char *compData, int compDataSize, int *dataSize) = nullptr;
static char *(*_EncodeDataBase64)(const unsigned char *data, int dataSize, int *outputSize) = nullptr;
static unsigned char *(*_DecodeDataBase64)(const unsigned char *data, int *outputSize) = nullptr;
static bool (*_IsKeyPressed)(int key) = nullptr;
static bool (*_IsKeyDown)(int key) = nullptr;
static bool (*_IsKeyReleased)(int key) = nullptr;
static bool (*_IsKeyUp)(int key) = nullptr;
static void (*_SetExitKey)(int key) = nullptr;
static int (*_GetKeyPressed)(void) = nullptr;
static int (*_GetCharPressed)(void) = nullptr;
static bool (*_IsGamepadAvailable)(int gamepad) = nullptr;
static const char *(*_GetGamepadName)(int gamepad) = nullptr;
static bool (*_IsGamepadButtonPressed)(int gamepad, int button) = nullptr;
static bool (*_IsGamepadButtonDown)(int gamepad, int button) = nullptr;
static bool (*_IsGamepadButtonReleased)(int gamepad, int button) = nullptr;
static bool (*_IsGamepadButtonUp)(int gamepad, int button) = nullptr;
static int (*_GetGamepadButtonPressed)(void) = nullptr;
static int (*_GetGamepadAxisCount)(int gamepad) = nullptr;
static float (*_GetGamepadAxisMovement)(int gamepad, int axis) = nullptr;
static int (*_SetGamepadMappings)(const char *mappings) = nullptr;
static bool (*_IsMouseButtonPressed)(int button) = nullptr;
static bool (*_IsMouseButtonDown)(int button) = nullptr;
static bool (*_IsMouseButtonReleased)(int button) = nullptr;
static bool (*_IsMouseButtonUp)(int button) = nullptr;
static int (*_GetMouseX)(void) = nullptr;
static int (*_GetMouseY)(void) = nullptr;
static Vector2 (*_GetMousePosition)(void) = nullptr;
static Vector2 (*_GetMouseDelta)(void) = nullptr;
static void (*_SetMousePosition)(int x, int y) = nullptr;
static void (*_SetMouseOffset)(int offsetX, int offsetY) = nullptr;
static void (*_SetMouseScale)(float scaleX, float scaleY) = nullptr;
static float (*_GetMouseWheelMove)(void) = nullptr;
static Vector2 (*_GetMouseWheelMoveV)(void) = nullptr;
static void (*_SetMouseCursor)(int cursor) = nullptr;
static int (*_GetTouchX)(void) = nullptr;
static int (*_GetTouchY)(void) = nullptr;
static Vector2 (*_GetTouchPosition)(int index) = nullptr;
static int (*_GetTouchPointId)(int index) = nullptr;
static int (*_GetTouchPointCount)(void) = nullptr;
static void (*_SetGesturesEnabled)(unsigned int flags) = nullptr;
static bool (*_IsGestureDetected)(int gesture) = nullptr;
static int (*_GetGestureDetected)(void) = nullptr;
static float (*_GetGestureHoldDuration)(void) = nullptr;
static Vector2 (*_GetGestureDragVector)(void) = nullptr;
static float (*_GetGestureDragAngle)(void) = nullptr;
static Vector2 (*_GetGesturePinchVector)(void) = nullptr;
static float (*_GetGesturePinchAngle)(void) = nullptr;
static void (*_UpdateCamera)(Camera *camera, int mode) = nullptr;
static void (*_UpdateCameraPro)(Camera *camera, Vector3 movement, Vector3 rotation, float zoom) = nullptr;
static void (*_SetShapesTexture)(Texture2D texture, RRectangle source) = nullptr;
static void (*_DrawPixel)(int posX, int posY, uint32_t color) = nullptr;
static void (*_DrawPixelV)(Vector2 position, uint32_t color) = nullptr;
static void (*_DrawLine)(int startPosX, int startPosY, int endPosX, int endPosY, uint32_t color) = nullptr;
static void (*_DrawLineV)(Vector2 startPos, Vector2 endPos, uint32_t color) = nullptr;
static void (*_DrawLineEx)(Vector2 startPos, Vector2 endPos, float thick, uint32_t color) = nullptr;
static void (*_DrawLineBezier)(Vector2 startPos, Vector2 endPos, float thick, uint32_t color) = nullptr;
static void (*_DrawLineBezierQuad)(Vector2 startPos, Vector2 endPos, Vector2 controlPos, float thick, uint32_t color) = nullptr;
static void (*_DrawLineBezierCubic)(Vector2 startPos, Vector2 endPos, Vector2 startControlPos, Vector2 endControlPos, float thick, uint32_t color) = nullptr;
static void (*_DrawLineStrip)(Vector2 *points, int pointCount, uint32_t color) = nullptr;
static void (*_DrawCircle)(int centerX, int centerY, float radius, uint32_t color) = nullptr;
static void (*_DrawCircleSector)(Vector2 center, float radius, float startAngle, float endAngle, int segments, uint32_t color) = nullptr;
static void (*_DrawCircleSectorLines)(Vector2 center, float radius, float startAngle, float endAngle, int segments, uint32_t color) = nullptr;
static void (*_DrawCircleGradient)(int centerX, int centerY, float radius, uint32_t color1, uint32_t color2) = nullptr;
static void (*_DrawCircleV)(Vector2 center, float radius, uint32_t color) = nullptr;
static void (*_DrawCircleLines)(int centerX, int centerY, float radius, uint32_t color) = nullptr;
static void (*_DrawEllipse)(int centerX, int centerY, float radiusH, float radiusV, uint32_t color) = nullptr;
static void (*_DrawEllipseLines)(int centerX, int centerY, float radiusH, float radiusV, uint32_t color) = nullptr;
static void (*_DrawRing)(Vector2 center, float innerRadius, float outerRadius, float startAngle, float endAngle, int segments, uint32_t color) = nullptr;
static void (*_DrawRingLines)(Vector2 center, float innerRadius, float outerRadius, float startAngle, float endAngle, int segments, uint32_t color) = nullptr;
static void (*_DrawRectangle)(int posX, int posY, int width, int height, uint32_t color) = nullptr;
static void (*_DrawRectangleV)(Vector2 position, Vector2 size, uint32_t color) = nullptr;
static void (*_DrawRectangleRec)(RRectangle rec, uint32_t color) = nullptr;
static void (*_DrawRectanglePro)(RRectangle rec, Vector2 origin, float rotation, uint32_t color) = nullptr;
static void (*_DrawRectangleGradientV)(int posX, int posY, int width, int height, uint32_t color1, uint32_t color2) = nullptr;
static void (*_DrawRectangleGradientH)(int posX, int posY, int width, int height, uint32_t color1, uint32_t color2) = nullptr;
static void (*_DrawRectangleGradientEx)(RRectangle rec, uint32_t col1, uint32_t col2, uint32_t col3, uint32_t col4) = nullptr;
static void (*_DrawRectangleLines)(int posX, int posY, int width, int height, uint32_t color) = nullptr;
static void (*_DrawRectangleLinesEx)(RRectangle rec, float lineThick, uint32_t color) = nullptr;
static void (*_DrawRectangleRounded)(RRectangle rec, float roundness, int segments, uint32_t color) = nullptr;
static void (*_DrawRectangleRoundedLines)(RRectangle rec, float roundness, int segments, float lineThick, uint32_t color) = nullptr;
static void (*_DrawTriangle)(Vector2 v1, Vector2 v2, Vector2 v3, uint32_t color) = nullptr;
static void (*_DrawTriangleLines)(Vector2 v1, Vector2 v2, Vector2 v3, uint32_t color) = nullptr;
static void (*_DrawTriangleFan)(Vector2 *points, int pointCount, uint32_t color) = nullptr;
static void (*_DrawTriangleStrip)(Vector2 *points, int pointCount, uint32_t color) = nullptr;
static void (*_DrawPoly)(Vector2 center, int sides, float radius, float rotation, uint32_t color) = nullptr;
static void (*_DrawPolyLines)(Vector2 center, int sides, float radius, float rotation, uint32_t color) = nullptr;
static void (*_DrawPolyLinesEx)(Vector2 center, int sides, float radius, float rotation, float lineThick, uint32_t color) = nullptr;
static bool (*_CheckCollisionRecs)(RRectangle rec1, RRectangle rec2) = nullptr;
static bool (*_CheckCollisionCircles)(Vector2 center1, float radius1, Vector2 center2, float radius2) = nullptr;
static bool (*_CheckCollisionCircleRec)(Vector2 center, float radius, RRectangle rec) = nullptr;
static bool (*_CheckCollisionPointRec)(Vector2 point, RRectangle rec) = nullptr;
static bool (*_CheckCollisionPointCircle)(Vector2 point, Vector2 center, float radius) = nullptr;
static bool (*_CheckCollisionPointTriangle)(Vector2 point, Vector2 p1, Vector2 p2, Vector2 p3) = nullptr;
static bool (*_CheckCollisionPointPoly)(Vector2 point, Vector2 *points, int pointCount) = nullptr;
static bool (*_CheckCollisionLines)(Vector2 startPos1, Vector2 endPos1, Vector2 startPos2, Vector2 endPos2, Vector2 *collisionPoint) = nullptr;
static bool (*_CheckCollisionPointLine)(Vector2 point, Vector2 p1, Vector2 p2, int threshold) = nullptr;
static RRectangle (*_GetCollisionRec)(RRectangle rec1, RRectangle rec2) = nullptr;
static Image (*_LoadImage)(const char *fileName) = nullptr;
static Image (*_LoadImageRaw)(const char *fileName, int width, int height, int format, int headerSize) = nullptr;
static Image (*_LoadImageAnim)(const char *fileName, int *frames) = nullptr;
static Image (*_LoadImageFromMemory)(const char *fileType, const unsigned char *fileData, int dataSize) = nullptr;
static Image (*_LoadImageFromTexture)(Texture2D texture) = nullptr;
static Image (*_LoadImageFromScreen)() = nullptr;
static bool (*_IsImageReady)(Image image) = nullptr;
static void (*_UnloadImage)(Image image) = nullptr;
static bool (*_ExportImage)(Image image, const char *fileName) = nullptr;
static bool (*_ExportImageAsCode)(Image image, const char *fileName) = nullptr;
static Image (*_GenImageColor)(int width, int height, uint32_t color) = nullptr;
static Image (*_GenImageGradientV)(int width, int height, uint32_t top, uint32_t bottom) = nullptr;
static Image (*_GenImageGradientH)(int width, int height, uint32_t left, uint32_t right) = nullptr;
static Image (*_GenImageGradientRadial)(int width, int height, float density, uint32_t inner, uint32_t outer) = nullptr;
static Image (*_GenImageChecked)(int width, int height, int checksX, int checksY, uint32_t col1, uint32_t col2) = nullptr;
static Image (*_GenImageWhiteNoise)(int width, int height, float factor) = nullptr;
static Image (*_GenImagePerlinNoise)(int width, int height, int offsetX, int offsetY, float scale) = nullptr;
static Image (*_GenImageCellular)(int width, int height, int tileSize) = nullptr;
static Image (*_GenImageText)(int width, int height, const char *text) = nullptr;
static Image (*_ImageCopy)(Image image) = nullptr;
static Image (*_ImageFromImage)(Image image, RRectangle rec) = nullptr;
static Image (*_ImageText)(const char *text, int fontSize, uint32_t color) = nullptr;
static Image (*_ImageTextEx)(Font font, const char *text, float fontSize, float spacing, uint32_t tint) = nullptr;
static void (*_ImageFormat)(Image *image, int newFormat) = nullptr;
static void (*_ImageToPOT)(Image *image, uint32_t fill) = nullptr;
static void (*_ImageCrop)(Image *image, RRectangle crop) = nullptr;
static void (*_ImageAlphaCrop)(Image *image, float threshold) = nullptr;
static void (*_ImageAlphaClear)(Image *image, uint32_t color, float threshold) = nullptr;
static void (*_ImageAlphaMask)(Image *image, Image alphaMask) = nullptr;
static void (*_ImageAlphaPremultiply)(Image *image) = nullptr;
static void (*_ImageBlurGaussian)(Image *image, int blurSize) = nullptr;
static void (*_ImageResize)(Image *image, int newWidth, int newHeight) = nullptr;
static void (*_ImageResizeNN)(Image *image, int newWidth, int newHeight) = nullptr;
static void (*_ImageResizeCanvas)(Image *image, int newWidth, int newHeight, int offsetX, int offsetY, uint32_t fill) = nullptr;
static void (*_ImageMipmaps)(Image *image) = nullptr;
static void (*_ImageDither)(Image *image, int rBpp, int gBpp, int bBpp, int aBpp) = nullptr;
static void (*_ImageFlipVertical)(Image *image) = nullptr;
static void (*_ImageFlipHorizontal)(Image *image) = nullptr;
static void (*_ImageRotateCW)(Image *image) = nullptr;
static void (*_ImageRotateCCW)(Image *image) = nullptr;
static void (*_ImageColorTint)(Image *image, uint32_t color) = nullptr;
static void (*_ImageColorInvert)(Image *image) = nullptr;
static void (*_ImageColorGrayscale)(Image *image) = nullptr;
static void (*_ImageColorContrast)(Image *image, float contrast) = nullptr;
static void (*_ImageColorBrightness)(Image *image, int brightness) = nullptr;
static void (*_ImageColorReplace)(Image *image, uint32_t color, uint32_t replace) = nullptr;
static uint32_t *(*_LoadImageColors)(Image image) = nullptr;
static uint32_t *(*_LoadImagePalette)(Image image, int maxPaletteSize, int *colorCount) = nullptr;
static void (*_UnloadImageColors)(uint32_t *colors) = nullptr;
static void (*_UnloadImagePalette)(uint32_t *colors) = nullptr;
static RRectangle (*_GetImageAlphaBorder)(Image image, float threshold) = nullptr;
static uint32_t (*_GetImageColor)(Image image, int x, int y) = nullptr;
static void (*_ImageClearBackground)(Image *dst, uint32_t color) = nullptr;
static void (*_ImageDrawPixel)(Image *dst, int posX, int posY, uint32_t color) = nullptr;
static void (*_ImageDrawPixelV)(Image *dst, Vector2 position, uint32_t color) = nullptr;
static void (*_ImageDrawLine)(Image *dst, int startPosX, int startPosY, int endPosX, int endPosY, uint32_t color) = nullptr;
static void (*_ImageDrawLineV)(Image *dst, Vector2 start, Vector2 end, uint32_t color) = nullptr;
static void (*_ImageDrawCircle)(Image *dst, int centerX, int centerY, int radius, uint32_t color) = nullptr;
static void (*_ImageDrawCircleV)(Image *dst, Vector2 center, int radius, uint32_t color) = nullptr;
static void (*_ImageDrawCircleLines)(Image *dst, int centerX, int centerY, int radius, uint32_t color) = nullptr;
static void (*_ImageDrawCircleLinesV)(Image *dst, Vector2 center, int radius, uint32_t color) = nullptr;
static void (*_ImageDrawRectangle)(Image *dst, int posX, int posY, int width, int height, uint32_t color) = nullptr;
static void (*_ImageDrawRectangleV)(Image *dst, Vector2 position, Vector2 size, uint32_t color) = nullptr;
static void (*_ImageDrawRectangleRec)(Image *dst, RRectangle rec, uint32_t color) = nullptr;
static void (*_ImageDrawRectangleLines)(Image *dst, RRectangle rec, int thick, uint32_t color) = nullptr;
static void (*_ImageDraw)(Image *dst, Image src, RRectangle srcRec, RRectangle dstRec, uint32_t tint) = nullptr;
static void (*_ImageDrawText)(Image *dst, const char *text, int posX, int posY, int fontSize, uint32_t color) = nullptr;
static void (*_ImageDrawTextEx)(Image *dst, Font font, const char *text, Vector2 position, float fontSize, float spacing, uint32_t tint) = nullptr;
static Texture2D (*_LoadTexture)(const char *fileName) = nullptr;
static Texture2D (*_LoadTextureFromImage)(Image image) = nullptr;
static TextureCubemap (*_LoadTextureCubemap)(Image image, int layout) = nullptr;
static RenderTexture2D (*_LoadRenderTexture)(int width, int height) = nullptr;
static bool (*_IsTextureReady)(Texture2D texture) = nullptr;
static void (*_UnloadTexture)(Texture2D texture) = nullptr;
static bool (*_IsRenderTextureReady)(RenderTexture2D target) = nullptr;
static void (*_UnloadRenderTexture)(RenderTexture2D target) = nullptr;
static void (*_UpdateTexture)(Texture2D texture, const void *pixels) = nullptr;
static void (*_UpdateTextureRec)(Texture2D texture, RRectangle rec, const void *pixels) = nullptr;
static void (*_GenTextureMipmaps)(Texture2D *texture) = nullptr;
static void (*_SetTextureFilter)(Texture2D texture, int filter) = nullptr;
static void (*_SetTextureWrap)(Texture2D texture, int wrap) = nullptr;
static void (*_DrawTexture)(Texture2D texture, int posX, int posY, uint32_t tint) = nullptr;
static void (*_DrawTextureV)(Texture2D texture, Vector2 position, uint32_t tint) = nullptr;
static void (*_DrawTextureEx)(Texture2D texture, Vector2 position, float rotation, float scale, uint32_t tint) = nullptr;
static void (*_DrawTextureRec)(Texture2D texture, RRectangle source, Vector2 position, uint32_t tint) = nullptr;
static void (*_DrawTexturePro)(Texture2D texture, RRectangle source, RRectangle dest, Vector2 origin, float rotation, uint32_t tint) = nullptr;
static void (*_DrawTextureNPatch)(Texture2D texture, NPatchInfo nPatchInfo, RRectangle dest, Vector2 origin, float rotation, uint32_t tint) = nullptr;
static uint32_t (*_Fade)(uint32_t color, float alpha) = nullptr;
static int (*_ColorToInt)(uint32_t color) = nullptr;
static Vector4 (*_ColorNormalize)(uint32_t color) = nullptr;
static uint32_t (*_ColorFromNormalized)(Vector4 normalized) = nullptr;
static Vector3 (*_ColorToHSV)(uint32_t color) = nullptr;
static uint32_t (*_ColorFromHSV)(float hue, float saturation, float value) = nullptr;
static uint32_t (*_ColorTint)(uint32_t color, uint32_t tint) = nullptr;
static uint32_t (*_ColorBrightness)(uint32_t color, float factor) = nullptr;
static uint32_t (*_ColorContrast)(uint32_t color, float contrast) = nullptr;
static uint32_t (*_ColorAlpha)(uint32_t color, float alpha) = nullptr;
static uint32_t (*_ColorAlphaBlend)(uint32_t dst, uint32_t src, uint32_t tint) = nullptr;
static uint32_t (*_GetColor)(unsigned int hexValue) = nullptr;
static uint32_t (*_GetPixelColor)(void *srcPtr, int format) = nullptr;
static void (*_SetPixelColor)(void *dstPtr, uint32_t color, int format) = nullptr;
static int (*_GetPixelDataSize)(int width, int height, int format) = nullptr;
static Font (*_GetFontDefault)(void) = nullptr;
static Font (*_LoadFont)(const char *fileName) = nullptr;
static Font (*_LoadFontEx)(const char *fileName, int fontSize, int *fontChars, int glyphCount) = nullptr;
static Font (*_LoadFontFromImage)(Image image, uint32_t key, int firstChar) = nullptr;
static Font (*_LoadFontFromMemory)(const char *fileType, const unsigned char *fileData, int dataSize, int fontSize, int *fontChars, int glyphCount) = nullptr;
static bool (*_IsFontReady)(Font font) = nullptr;
static GlyphInfo *(*_LoadFontData)(const unsigned char *fileData, int dataSize, int fontSize, int *fontChars, int glyphCount, int type) = nullptr;
static Image (*_GenImageFontAtlas)(const GlyphInfo *chars, RRectangle **recs, int glyphCount, int fontSize, int padding, int packMethod) = nullptr;
static void (*_UnloadFontData)(GlyphInfo *chars, int glyphCount) = nullptr;
static void (*_UnloadFont)(Font font) = nullptr;
static bool (*_ExportFontAsCode)(Font font, const char *fileName) = nullptr;
static void (*_DrawFPS)(int posX, int posY) = nullptr;
static void (*_DrawText)(const char *text, int posX, int posY, int fontSize, uint32_t color) = nullptr;
static void (*_DrawTextEx)(Font font, const char *text, Vector2 position, float fontSize, float spacing, uint32_t tint) = nullptr;
static void (*_DrawTextPro)(Font font, const char *text, Vector2 position, Vector2 origin, float rotation, float fontSize, float spacing, uint32_t tint) = nullptr;
static void (*_DrawTextCodepoint)(Font font, int codepoint, Vector2 position, float fontSize, uint32_t tint) = nullptr;
static void (*_DrawTextCodepoints)(Font font, const int *codepoints, int count, Vector2 position, float fontSize, float spacing, uint32_t tint) = nullptr;
static int (*_MeasureText)(const char *text, int fontSize) = nullptr;
static Vector2 (*_MeasureTextEx)(Font font, const char *text, float fontSize, float spacing) = nullptr;
static int (*_GetGlyphIndex)(Font font, int codepoint) = nullptr;
static GlyphInfo (*_GetGlyphInfo)(Font font, int codepoint) = nullptr;
static RRectangle (*_GetGlyphAtlasRec)(Font font, int codepoint) = nullptr;
static char *(*_LoadUTF8)(const int *codepoints, int length) = nullptr;
static void (*_UnloadUTF8)(char *text) = nullptr;
static int *(*_LoadCodepoints)(const char *text, int *count) = nullptr;
static void (*_UnloadCodepoints)(int *codepoints) = nullptr;
static int (*_GetCodepointCount)(const char *text) = nullptr;
static int (*_GetCodepoint)(const char *text, int *codepointSize) = nullptr;
static int (*_GetCodepointNext)(const char *text, int *codepointSize) = nullptr;
static int (*_GetCodepointPrevious)(const char *text, int *codepointSize) = nullptr;
static const char *(*_CodepointToUTF8)(int codepoint, int *utf8Size) = nullptr;
static int (*_TextCopy)(char *dst, const char *src) = nullptr;
static bool (*_TextIsEqual)(const char *text1, const char *text2) = nullptr;
static unsigned int (*_TextLength)(const char *text) = nullptr;
static const char *(*_TextFormat)(const char *text, ...) = nullptr;
static const char *(*_TextSubtext)(const char *text, int position, int length) = nullptr;
static char *(*_TextReplace)(char *text, const char *replace, const char *by) = nullptr;
static char *(*_TextInsert)(const char *text, const char *insert, int position) = nullptr;
static const char *(*_TextJoin)(const char **textList, int count, const char *delimiter) = nullptr;
static const char **(*_TextSplit)(const char *text, char delimiter, int *count) = nullptr;
static void (*_TextAppend)(char *text, const char *append, int *position) = nullptr;
static int (*_TextFindIndex)(const char *text, const char *find) = nullptr;
static const char *(*_TextToUpper)(const char *text) = nullptr;
static const char *(*_TextToLower)(const char *text) = nullptr;
static const char *(*_TextToPascal)(const char *text) = nullptr;
static int (*_TextToInteger)(const char *text) = nullptr;
static void (*_DrawLine3D)(Vector3 startPos, Vector3 endPos, uint32_t color) = nullptr;
static void (*_DrawPoint3D)(Vector3 position, uint32_t color) = nullptr;
static void (*_DrawCircle3D)(Vector3 center, float radius, Vector3 rotationAxis, float rotationAngle, uint32_t color) = nullptr;
static void (*_DrawTriangle3D)(Vector3 v1, Vector3 v2, Vector3 v3, uint32_t color) = nullptr;
static void (*_DrawTriangleStrip3D)(Vector3 *points, int pointCount, uint32_t color) = nullptr;
static void (*_DrawCube)(Vector3 position, float width, float height, float length, uint32_t color) = nullptr;
static void (*_DrawCubeV)(Vector3 position, Vector3 size, uint32_t color) = nullptr;
static void (*_DrawCubeWires)(Vector3 position, float width, float height, float length, uint32_t color) = nullptr;
static void (*_DrawCubeWiresV)(Vector3 position, Vector3 size, uint32_t color) = nullptr;
static void (*_DrawSphere)(Vector3 centerPos, float radius, uint32_t color) = nullptr;
static void (*_DrawSphereEx)(Vector3 centerPos, float radius, int rings, int slices, uint32_t color) = nullptr;
static void (*_DrawSphereWires)(Vector3 centerPos, float radius, int rings, int slices, uint32_t color) = nullptr;
static void (*_DrawCylinder)(Vector3 position, float radiusTop, float radiusBottom, float height, int slices, uint32_t color) = nullptr;
static void (*_DrawCylinderEx)(Vector3 startPos, Vector3 endPos, float startRadius, float endRadius, int sides, uint32_t color) = nullptr;
static void (*_DrawCylinderWires)(Vector3 position, float radiusTop, float radiusBottom, float height, int slices, uint32_t color) = nullptr;
static void (*_DrawCylinderWiresEx)(Vector3 startPos, Vector3 endPos, float startRadius, float endRadius, int sides, uint32_t color) = nullptr;
static void (*_DrawCapsule)(Vector3 startPos, Vector3 endPos, float radius, int slices, int rings, uint32_t color) = nullptr;
static void (*_DrawCapsuleWires)(Vector3 startPos, Vector3 endPos, float radius, int slices, int rings, uint32_t color) = nullptr;
static void (*_DrawPlane)(Vector3 centerPos, Vector2 size, uint32_t color) = nullptr;
static void (*_DrawRay)(Ray ray, uint32_t color) = nullptr;
static void (*_DrawGrid)(int slices, float spacing) = nullptr;
static Model (*_LoadModel)(const char *fileName) = nullptr;
static Model (*_LoadModelFromMesh)(Mesh mesh) = nullptr;
static bool (*_IsModelReady)(Model model) = nullptr;
static void (*_UnloadModel)(Model model) = nullptr;
static BoundingBox (*_GetModelBoundingBox)(Model model) = nullptr;
static void (*_DrawModel)(Model model, Vector3 position, float scale, uint32_t tint) = nullptr;
static void (*_DrawModelEx)(Model model, Vector3 position, Vector3 rotationAxis, float rotationAngle, Vector3 scale, uint32_t tint) = nullptr;
static void (*_DrawModelWires)(Model model, Vector3 position, float scale, uint32_t tint) = nullptr;
static void (*_DrawModelWiresEx)(Model model, Vector3 position, Vector3 rotationAxis, float rotationAngle, Vector3 scale, uint32_t tint) = nullptr;
static void (*_DrawBoundingBox)(BoundingBox box, uint32_t color) = nullptr;
static void (*_DrawBillboard)(Camera camera, Texture2D texture, Vector3 position, float size, uint32_t tint) = nullptr;
static void (*_DrawBillboardRec)(Camera camera, Texture2D texture, RRectangle source, Vector3 position, Vector2 size, uint32_t tint) = nullptr;
static void (*_DrawBillboardPro)(Camera camera, Texture2D texture, RRectangle source, Vector3 position, Vector3 up, Vector2 size, Vector2 origin, float rotation, uint32_t tint) = nullptr;
static void (*_UploadMesh)(Mesh *mesh, bool dynamic) = nullptr;
static void (*_UpdateMeshBuffer)(Mesh mesh, int index, const void *data, int dataSize, int offset) = nullptr;
static void (*_UnloadMesh)(Mesh mesh) = nullptr;
static void (*_DrawMesh)(Mesh mesh, Material material, Matrix transform) = nullptr;
static void (*_DrawMeshInstanced)(Mesh mesh, Material material, const Matrix *transforms, int instances) = nullptr;
static bool (*_ExportMesh)(Mesh mesh, const char *fileName) = nullptr;
static BoundingBox (*_GetMeshBoundingBox)(Mesh mesh) = nullptr;
static void (*_GenMeshTangents)(Mesh *mesh) = nullptr;
static Mesh (*_GenMeshPoly)(int sides, float radius) = nullptr;
static Mesh (*_GenMeshPlane)(float width, float length, int resX, int resZ) = nullptr;
static Mesh (*_GenMeshCube)(float width, float height, float length) = nullptr;
static Mesh (*_GenMeshSphere)(float radius, int rings, int slices) = nullptr;
static Mesh (*_GenMeshHemiSphere)(float radius, int rings, int slices) = nullptr;
static Mesh (*_GenMeshCylinder)(float radius, float height, int slices) = nullptr;
static Mesh (*_GenMeshCone)(float radius, float height, int slices) = nullptr;
static Mesh (*_GenMeshTorus)(float radius, float size, int radSeg, int sides) = nullptr;
static Mesh (*_GenMeshKnot)(float radius, float size, int radSeg, int sides) = nullptr;
static Mesh (*_GenMeshHeightmap)(Image heightmap, Vector3 size) = nullptr;
static Mesh (*_GenMeshCubicmap)(Image cubicmap, Vector3 cubeSize) = nullptr;
static Material *(*_LoadMaterials)(const char *fileName, int *materialCount) = nullptr;
static Material (*_LoadMaterialDefault)(void) = nullptr;
static bool (*_IsMaterialReady)(Material material) = nullptr;
static void (*_UnloadMaterial)(Material material) = nullptr;
static void (*_SetMaterialTexture)(Material *material, int mapType, Texture2D texture) = nullptr;
static void (*_SetModelMeshMaterial)(Model *model, int meshId, int materialId) = nullptr;
static ModelAnimation *(*_LoadModelAnimations)(const char *fileName, unsigned int *animCount) = nullptr;
static void (*_UpdateModelAnimation)(Model model, ModelAnimation anim, int frame) = nullptr;
static void (*_UnloadModelAnimation)(ModelAnimation anim) = nullptr;
static void (*_UnloadModelAnimations)(ModelAnimation *animations, unsigned int count) = nullptr;
static bool (*_IsModelAnimationValid)(Model model, ModelAnimation anim) = nullptr;
static bool (*_CheckCollisionSpheres)(Vector3 center1, float radius1, Vector3 center2, float radius2) = nullptr;
static bool (*_CheckCollisionBoxes)(BoundingBox box1, BoundingBox box2) = nullptr;
static bool (*_CheckCollisionBoxSphere)(BoundingBox box, Vector3 center, float radius) = nullptr;
static RayCollision (*_GetRayCollisionSphere)(Ray ray, Vector3 center, float radius) = nullptr;
static RayCollision (*_GetRayCollisionBox)(Ray ray, BoundingBox box) = nullptr;
static RayCollision (*_GetRayCollisionMesh)(Ray ray, Mesh mesh, Matrix transform) = nullptr;
static RayCollision (*_GetRayCollisionTriangle)(Ray ray, Vector3 p1, Vector3 p2, Vector3 p3) = nullptr;
static RayCollision (*_GetRayCollisionQuad)(Ray ray, Vector3 p1, Vector3 p2, Vector3 p3, Vector3 p4) = nullptr;
static void (*_InitAudioDevice)(void) = nullptr;
static void (*_CloseAudioDevice)(void) = nullptr;
static bool (*_IsAudioDeviceReady)(void) = nullptr;
static void (*_SetMasterVolume)(float volume) = nullptr;
static Wave (*_LoadWave)(const char *fileName) = nullptr;
static Wave (*_LoadWaveFromMemory)(const char *fileType, const unsigned char *fileData, int dataSize) = nullptr;
static bool (*_IsWaveReady)(Wave wave) = nullptr;
static Sound (*_LoadSound)(const char *fileName) = nullptr;
static Sound (*_LoadSoundFromWave)(Wave wave) = nullptr;
static bool (*_IsSoundReady)(Sound sound) = nullptr;
static void (*_UpdateSound)(Sound sound, const void *data, int sampleCount) = nullptr;
static void (*_UnloadWave)(Wave wave) = nullptr;
static void (*_UnloadSound)(Sound sound) = nullptr;
static bool (*_ExportWave)(Wave wave, const char *fileName) = nullptr;
static bool (*_ExportWaveAsCode)(Wave wave, const char *fileName) = nullptr;
static void (*_PlaySound)(Sound sound) = nullptr;
static void (*_StopSound)(Sound sound) = nullptr;
static void (*_PauseSound)(Sound sound) = nullptr;
static void (*_ResumeSound)(Sound sound) = nullptr;
static bool (*_IsSoundPlaying)(Sound sound) = nullptr;
static void (*_SetSoundVolume)(Sound sound, float volume) = nullptr;
static void (*_SetSoundPitch)(Sound sound, float pitch) = nullptr;
static void (*_SetSoundPan)(Sound sound, float pan) = nullptr;
static Wave (*_WaveCopy)(Wave wave) = nullptr;
static void (*_WaveCrop)(Wave *wave, int initSample, int finalSample) = nullptr;
static void (*_WaveFormat)(Wave *wave, int sampleRate, int sampleSize, int channels) = nullptr;
static float *(*_LoadWaveSamples)(Wave wave) = nullptr;
static void (*_UnloadWaveSamples)(float *samples) = nullptr;
static Music (*_LoadMusicStream)(const char *fileName) = nullptr;
static Music (*_LoadMusicStreamFromMemory)(const char *fileType, const unsigned char *data, int dataSize) = nullptr;
static bool (*_IsMusicReady)(Music music) = nullptr;
static void (*_UnloadMusicStream)(Music music) = nullptr;
static void (*_PlayMusicStream)(Music music) = nullptr;
static bool (*_IsMusicStreamPlaying)(Music music) = nullptr;
static void (*_UpdateMusicStream)(Music music) = nullptr;
static void (*_StopMusicStream)(Music music) = nullptr;
static void (*_PauseMusicStream)(Music music) = nullptr;
static void (*_ResumeMusicStream)(Music music) = nullptr;
static void (*_SeekMusicStream)(Music music, float position) = nullptr;
static void (*_SetMusicVolume)(Music music, float volume) = nullptr;
static void (*_SetMusicPitch)(Music music, float pitch) = nullptr;
static void (*_SetMusicPan)(Music music, float pan) = nullptr;
static float (*_GetMusicTimeLength)(Music music) = nullptr;
static float (*_GetMusicTimePlayed)(Music music) = nullptr;
static AudioStream (*_LoadAudioStream)(unsigned int sampleRate, unsigned int sampleSize, unsigned int channels) = nullptr;
static bool (*_IsAudioStreamReady)(AudioStream stream) = nullptr;
static void (*_UnloadAudioStream)(AudioStream stream) = nullptr;
static void (*_UpdateAudioStream)(AudioStream stream, const void *data, int frameCount) = nullptr;
static bool (*_IsAudioStreamProcessed)(AudioStream stream) = nullptr;
static void (*_PlayAudioStream)(AudioStream stream) = nullptr;
static void (*_PauseAudioStream)(AudioStream stream) = nullptr;
static void (*_ResumeAudioStream)(AudioStream stream) = nullptr;
static bool (*_IsAudioStreamPlaying)(AudioStream stream) = nullptr;
static void (*_StopAudioStream)(AudioStream stream) = nullptr;
static void (*_SetAudioStreamVolume)(AudioStream stream, float volume) = nullptr;
static void (*_SetAudioStreamPitch)(AudioStream stream, float pitch) = nullptr;
static void (*_SetAudioStreamPan)(AudioStream stream, float pan) = nullptr;
static void (*_SetAudioStreamBufferSizeDefault)(int size) = nullptr;
static void (*_SetAudioStreamCallback)(AudioStream stream, AudioCallback callback) = nullptr;
static void (*_AttachAudioStreamProcessor)(AudioStream stream, AudioCallback processor) = nullptr;
static void (*_DetachAudioStreamProcessor)(AudioStream stream, AudioCallback processor) = nullptr;
static void (*_AttachAudioMixedProcessor)(AudioCallback processor) = nullptr;
static void (*_DetachAudioMixedProcessor)(AudioCallback processor) = nullptr;
//----------------------------------------------------------------------------------------------------------------------

/// @brief [INTERNAL] This cleans up everything and closes the shared library object
static void __done_raylib()
{
    //------------------------------------------------------------------------------------------------------------------
    // Autogenerated cleanup
    //------------------------------------------------------------------------------------------------------------------
    _InitWindow = nullptr;
    _WindowShouldClose = nullptr;
    _CloseWindow = nullptr;
    _IsWindowReady = nullptr;
    _IsWindowFullscreen = nullptr;
    _IsWindowHidden = nullptr;
    _IsWindowMinimized = nullptr;
    _IsWindowMaximized = nullptr;
    _IsWindowFocused = nullptr;
    _IsWindowResized = nullptr;
    _IsWindowState = nullptr;
    _SetWindowState = nullptr;
    _ClearWindowState = nullptr;
    _ToggleFullscreen = nullptr;
    _MaximizeWindow = nullptr;
    _MinimizeWindow = nullptr;
    _RestoreWindow = nullptr;
    _SetWindowIcon = nullptr;
    _SetWindowIcons = nullptr;
    _SetWindowTitle = nullptr;
    _SetWindowPosition = nullptr;
    _SetWindowMonitor = nullptr;
    _SetWindowMinSize = nullptr;
    _SetWindowSize = nullptr;
    _SetWindowOpacity = nullptr;
    _GetWindowHandle = nullptr;
    _GetScreenWidth = nullptr;
    _GetScreenHeight = nullptr;
    _GetRenderWidth = nullptr;
    _GetRenderHeight = nullptr;
    _GetMonitorCount = nullptr;
    _GetCurrentMonitor = nullptr;
    _GetMonitorPosition = nullptr;
    _GetMonitorWidth = nullptr;
    _GetMonitorHeight = nullptr;
    _GetMonitorPhysicalWidth = nullptr;
    _GetMonitorPhysicalHeight = nullptr;
    _GetMonitorRefreshRate = nullptr;
    _GetWindowPosition = nullptr;
    _GetWindowScaleDPI = nullptr;
    _GetMonitorName = nullptr;
    _SetClipboardText = nullptr;
    _GetClipboardText = nullptr;
    _EnableEventWaiting = nullptr;
    _DisableEventWaiting = nullptr;
    _SwapScreenBuffer = nullptr;
    _PollInputEvents = nullptr;
    _WaitTime = nullptr;
    _ShowCursor = nullptr;
    _HideCursor = nullptr;
    _IsCursorHidden = nullptr;
    _EnableCursor = nullptr;
    _DisableCursor = nullptr;
    _IsCursorOnScreen = nullptr;
    _ClearBackground = nullptr;
    _BeginDrawing = nullptr;
    _EndDrawing = nullptr;
    _BeginMode2D = nullptr;
    _EndMode2D = nullptr;
    _BeginMode3D = nullptr;
    _EndMode3D = nullptr;
    _BeginTextureMode = nullptr;
    _EndTextureMode = nullptr;
    _BeginShaderMode = nullptr;
    _EndShaderMode = nullptr;
    _BeginBlendMode = nullptr;
    _EndBlendMode = nullptr;
    _BeginScissorMode = nullptr;
    _EndScissorMode = nullptr;
    _BeginVrStereoMode = nullptr;
    _EndVrStereoMode = nullptr;
    _LoadVrStereoConfig = nullptr;
    _UnloadVrStereoConfig = nullptr;
    _LoadShader = nullptr;
    _LoadShaderFromMemory = nullptr;
    _IsShaderReady = nullptr;
    _GetShaderLocation = nullptr;
    _GetShaderLocationAttrib = nullptr;
    _SetShaderValue = nullptr;
    _SetShaderValueV = nullptr;
    _SetShaderValueMatrix = nullptr;
    _SetShaderValueTexture = nullptr;
    _UnloadShader = nullptr;
    _GetMouseRay = nullptr;
    _GetCameraMatrix = nullptr;
    _GetCameraMatrix2D = nullptr;
    _GetWorldToScreen = nullptr;
    _GetScreenToWorld2D = nullptr;
    _GetWorldToScreenEx = nullptr;
    _GetWorldToScreen2D = nullptr;
    _SetTargetFPS = nullptr;
    _GetFPS = nullptr;
    _GetFrameTime = nullptr;
    _GetTime = nullptr;
    _GetRandomValue = nullptr;
    _SetRandomSeed = nullptr;
    _TakeScreenshot = nullptr;
    _SetConfigFlags = nullptr;
    _TraceLog = nullptr;
    _SetTraceLogLevel = nullptr;
    _MemAlloc = nullptr;
    _MemRealloc = nullptr;
    _MemFree = nullptr;
    _OpenURL = nullptr;
    _SetTraceLogCallback = nullptr;
    _SetLoadFileDataCallback = nullptr;
    _SetSaveFileDataCallback = nullptr;
    _SetLoadFileTextCallback = nullptr;
    _SetSaveFileTextCallback = nullptr;
    _LoadFileData = nullptr;
    _UnloadFileData = nullptr;
    _SaveFileData = nullptr;
    _ExportDataAsCode = nullptr;
    _LoadFileText = nullptr;
    _UnloadFileText = nullptr;
    _SaveFileText = nullptr;
    _FileExists = nullptr;
    _DirectoryExists = nullptr;
    _IsFileExtension = nullptr;
    _GetFileLength = nullptr;
    _GetFileExtension = nullptr;
    _GetFileName = nullptr;
    _GetFileNameWithoutExt = nullptr;
    _GetDirectoryPath = nullptr;
    _GetPrevDirectoryPath = nullptr;
    _GetWorkingDirectory = nullptr;
    _GetApplicationDirectory = nullptr;
    _ChangeDirectory = nullptr;
    _IsPathFile = nullptr;
    _LoadDirectoryFiles = nullptr;
    _LoadDirectoryFilesEx = nullptr;
    _UnloadDirectoryFiles = nullptr;
    _IsFileDropped = nullptr;
    _LoadDroppedFiles = nullptr;
    _UnloadDroppedFiles = nullptr;
    _GetFileModTime = nullptr;
    _CompressData = nullptr;
    _DecompressData = nullptr;
    _EncodeDataBase64 = nullptr;
    _DecodeDataBase64 = nullptr;
    _IsKeyPressed = nullptr;
    _IsKeyDown = nullptr;
    _IsKeyReleased = nullptr;
    _IsKeyUp = nullptr;
    _SetExitKey = nullptr;
    _GetKeyPressed = nullptr;
    _GetCharPressed = nullptr;
    _IsGamepadAvailable = nullptr;
    _GetGamepadName = nullptr;
    _IsGamepadButtonPressed = nullptr;
    _IsGamepadButtonDown = nullptr;
    _IsGamepadButtonReleased = nullptr;
    _IsGamepadButtonUp = nullptr;
    _GetGamepadButtonPressed = nullptr;
    _GetGamepadAxisCount = nullptr;
    _GetGamepadAxisMovement = nullptr;
    _SetGamepadMappings = nullptr;
    _IsMouseButtonPressed = nullptr;
    _IsMouseButtonDown = nullptr;
    _IsMouseButtonReleased = nullptr;
    _IsMouseButtonUp = nullptr;
    _GetMouseX = nullptr;
    _GetMouseY = nullptr;
    _GetMousePosition = nullptr;
    _GetMouseDelta = nullptr;
    _SetMousePosition = nullptr;
    _SetMouseOffset = nullptr;
    _SetMouseScale = nullptr;
    _GetMouseWheelMove = nullptr;
    _GetMouseWheelMoveV = nullptr;
    _SetMouseCursor = nullptr;
    _GetTouchX = nullptr;
    _GetTouchY = nullptr;
    _GetTouchPosition = nullptr;
    _GetTouchPointId = nullptr;
    _GetTouchPointCount = nullptr;
    _SetGesturesEnabled = nullptr;
    _IsGestureDetected = nullptr;
    _GetGestureDetected = nullptr;
    _GetGestureHoldDuration = nullptr;
    _GetGestureDragVector = nullptr;
    _GetGestureDragAngle = nullptr;
    _GetGesturePinchVector = nullptr;
    _GetGesturePinchAngle = nullptr;
    _UpdateCamera = nullptr;
    _UpdateCameraPro = nullptr;
    _SetShapesTexture = nullptr;
    _DrawPixel = nullptr;
    _DrawPixelV = nullptr;
    _DrawLine = nullptr;
    _DrawLineV = nullptr;
    _DrawLineEx = nullptr;
    _DrawLineBezier = nullptr;
    _DrawLineBezierQuad = nullptr;
    _DrawLineBezierCubic = nullptr;
    _DrawLineStrip = nullptr;
    _DrawCircle = nullptr;
    _DrawCircleSector = nullptr;
    _DrawCircleSectorLines = nullptr;
    _DrawCircleGradient = nullptr;
    _DrawCircleV = nullptr;
    _DrawCircleLines = nullptr;
    _DrawEllipse = nullptr;
    _DrawEllipseLines = nullptr;
    _DrawRing = nullptr;
    _DrawRingLines = nullptr;
    _DrawRectangle = nullptr;
    _DrawRectangleV = nullptr;
    _DrawRectangleRec = nullptr;
    _DrawRectanglePro = nullptr;
    _DrawRectangleGradientV = nullptr;
    _DrawRectangleGradientH = nullptr;
    _DrawRectangleGradientEx = nullptr;
    _DrawRectangleLines = nullptr;
    _DrawRectangleLinesEx = nullptr;
    _DrawRectangleRounded = nullptr;
    _DrawRectangleRoundedLines = nullptr;
    _DrawTriangle = nullptr;
    _DrawTriangleLines = nullptr;
    _DrawTriangleFan = nullptr;
    _DrawTriangleStrip = nullptr;
    _DrawPoly = nullptr;
    _DrawPolyLines = nullptr;
    _DrawPolyLinesEx = nullptr;
    _CheckCollisionRecs = nullptr;
    _CheckCollisionCircles = nullptr;
    _CheckCollisionCircleRec = nullptr;
    _CheckCollisionPointRec = nullptr;
    _CheckCollisionPointCircle = nullptr;
    _CheckCollisionPointTriangle = nullptr;
    _CheckCollisionPointPoly = nullptr;
    _CheckCollisionLines = nullptr;
    _CheckCollisionPointLine = nullptr;
    _GetCollisionRec = nullptr;
    _LoadImage = nullptr;
    _LoadImageRaw = nullptr;
    _LoadImageAnim = nullptr;
    _LoadImageFromMemory = nullptr;
    _LoadImageFromTexture = nullptr;
    _LoadImageFromScreen = nullptr;
    _IsImageReady = nullptr;
    _UnloadImage = nullptr;
    _ExportImage = nullptr;
    _ExportImageAsCode = nullptr;
    _GenImageColor = nullptr;
    _GenImageGradientV = nullptr;
    _GenImageGradientH = nullptr;
    _GenImageGradientRadial = nullptr;
    _GenImageChecked = nullptr;
    _GenImageWhiteNoise = nullptr;
    _GenImagePerlinNoise = nullptr;
    _GenImageCellular = nullptr;
    _GenImageText = nullptr;
    _ImageCopy = nullptr;
    _ImageFromImage = nullptr;
    _ImageText = nullptr;
    _ImageTextEx = nullptr;
    _ImageFormat = nullptr;
    _ImageToPOT = nullptr;
    _ImageCrop = nullptr;
    _ImageAlphaCrop = nullptr;
    _ImageAlphaClear = nullptr;
    _ImageAlphaMask = nullptr;
    _ImageAlphaPremultiply = nullptr;
    _ImageBlurGaussian = nullptr;
    _ImageResize = nullptr;
    _ImageResizeNN = nullptr;
    _ImageResizeCanvas = nullptr;
    _ImageMipmaps = nullptr;
    _ImageDither = nullptr;
    _ImageFlipVertical = nullptr;
    _ImageFlipHorizontal = nullptr;
    _ImageRotateCW = nullptr;
    _ImageRotateCCW = nullptr;
    _ImageColorTint = nullptr;
    _ImageColorInvert = nullptr;
    _ImageColorGrayscale = nullptr;
    _ImageColorContrast = nullptr;
    _ImageColorBrightness = nullptr;
    _ImageColorReplace = nullptr;
    _LoadImageColors = nullptr;
    _LoadImagePalette = nullptr;
    _UnloadImageColors = nullptr;
    _UnloadImagePalette = nullptr;
    _GetImageAlphaBorder = nullptr;
    _GetImageColor = nullptr;
    _ImageClearBackground = nullptr;
    _ImageDrawPixel = nullptr;
    _ImageDrawPixelV = nullptr;
    _ImageDrawLine = nullptr;
    _ImageDrawLineV = nullptr;
    _ImageDrawCircle = nullptr;
    _ImageDrawCircleV = nullptr;
    _ImageDrawCircleLines = nullptr;
    _ImageDrawCircleLinesV = nullptr;
    _ImageDrawRectangle = nullptr;
    _ImageDrawRectangleV = nullptr;
    _ImageDrawRectangleRec = nullptr;
    _ImageDrawRectangleLines = nullptr;
    _ImageDraw = nullptr;
    _ImageDrawText = nullptr;
    _ImageDrawTextEx = nullptr;
    _LoadTexture = nullptr;
    _LoadTextureFromImage = nullptr;
    _LoadTextureCubemap = nullptr;
    _LoadRenderTexture = nullptr;
    _IsTextureReady = nullptr;
    _UnloadTexture = nullptr;
    _IsRenderTextureReady = nullptr;
    _UnloadRenderTexture = nullptr;
    _UpdateTexture = nullptr;
    _UpdateTextureRec = nullptr;
    _GenTextureMipmaps = nullptr;
    _SetTextureFilter = nullptr;
    _SetTextureWrap = nullptr;
    _DrawTexture = nullptr;
    _DrawTextureV = nullptr;
    _DrawTextureEx = nullptr;
    _DrawTextureRec = nullptr;
    _DrawTexturePro = nullptr;
    _DrawTextureNPatch = nullptr;
    _Fade = nullptr;
    _ColorToInt = nullptr;
    _ColorNormalize = nullptr;
    _ColorFromNormalized = nullptr;
    _ColorToHSV = nullptr;
    _ColorFromHSV = nullptr;
    _ColorTint = nullptr;
    _ColorBrightness = nullptr;
    _ColorContrast = nullptr;
    _ColorAlpha = nullptr;
    _ColorAlphaBlend = nullptr;
    _GetColor = nullptr;
    _GetPixelColor = nullptr;
    _SetPixelColor = nullptr;
    _GetPixelDataSize = nullptr;
    _GetFontDefault = nullptr;
    _LoadFont = nullptr;
    _LoadFontEx = nullptr;
    _LoadFontFromImage = nullptr;
    _LoadFontFromMemory = nullptr;
    _IsFontReady = nullptr;
    _LoadFontData = nullptr;
    _GenImageFontAtlas = nullptr;
    _UnloadFontData = nullptr;
    _UnloadFont = nullptr;
    _ExportFontAsCode = nullptr;
    _DrawFPS = nullptr;
    _DrawText = nullptr;
    _DrawTextEx = nullptr;
    _DrawTextPro = nullptr;
    _DrawTextCodepoint = nullptr;
    _DrawTextCodepoints = nullptr;
    _MeasureText = nullptr;
    _MeasureTextEx = nullptr;
    _GetGlyphIndex = nullptr;
    _GetGlyphInfo = nullptr;
    _GetGlyphAtlasRec = nullptr;
    _LoadUTF8 = nullptr;
    _UnloadUTF8 = nullptr;
    _LoadCodepoints = nullptr;
    _UnloadCodepoints = nullptr;
    _GetCodepointCount = nullptr;
    _GetCodepoint = nullptr;
    _GetCodepointNext = nullptr;
    _GetCodepointPrevious = nullptr;
    _CodepointToUTF8 = nullptr;
    _TextCopy = nullptr;
    _TextIsEqual = nullptr;
    _TextLength = nullptr;
    _TextFormat = nullptr;
    _TextSubtext = nullptr;
    _TextReplace = nullptr;
    _TextInsert = nullptr;
    _TextJoin = nullptr;
    _TextSplit = nullptr;
    _TextAppend = nullptr;
    _TextFindIndex = nullptr;
    _TextToUpper = nullptr;
    _TextToLower = nullptr;
    _TextToPascal = nullptr;
    _TextToInteger = nullptr;
    _DrawLine3D = nullptr;
    _DrawPoint3D = nullptr;
    _DrawCircle3D = nullptr;
    _DrawTriangle3D = nullptr;
    _DrawTriangleStrip3D = nullptr;
    _DrawCube = nullptr;
    _DrawCubeV = nullptr;
    _DrawCubeWires = nullptr;
    _DrawCubeWiresV = nullptr;
    _DrawSphere = nullptr;
    _DrawSphereEx = nullptr;
    _DrawSphereWires = nullptr;
    _DrawCylinder = nullptr;
    _DrawCylinderEx = nullptr;
    _DrawCylinderWires = nullptr;
    _DrawCylinderWiresEx = nullptr;
    _DrawCapsule = nullptr;
    _DrawCapsuleWires = nullptr;
    _DrawPlane = nullptr;
    _DrawRay = nullptr;
    _DrawGrid = nullptr;
    _LoadModel = nullptr;
    _LoadModelFromMesh = nullptr;
    _IsModelReady = nullptr;
    _UnloadModel = nullptr;
    _GetModelBoundingBox = nullptr;
    _DrawModel = nullptr;
    _DrawModelEx = nullptr;
    _DrawModelWires = nullptr;
    _DrawModelWiresEx = nullptr;
    _DrawBoundingBox = nullptr;
    _DrawBillboard = nullptr;
    _DrawBillboardRec = nullptr;
    _DrawBillboardPro = nullptr;
    _UploadMesh = nullptr;
    _UpdateMeshBuffer = nullptr;
    _UnloadMesh = nullptr;
    _DrawMesh = nullptr;
    _DrawMeshInstanced = nullptr;
    _ExportMesh = nullptr;
    _GetMeshBoundingBox = nullptr;
    _GenMeshTangents = nullptr;
    _GenMeshPoly = nullptr;
    _GenMeshPlane = nullptr;
    _GenMeshCube = nullptr;
    _GenMeshSphere = nullptr;
    _GenMeshHemiSphere = nullptr;
    _GenMeshCylinder = nullptr;
    _GenMeshCone = nullptr;
    _GenMeshTorus = nullptr;
    _GenMeshKnot = nullptr;
    _GenMeshHeightmap = nullptr;
    _GenMeshCubicmap = nullptr;
    _LoadMaterials = nullptr;
    _LoadMaterialDefault = nullptr;
    _IsMaterialReady = nullptr;
    _UnloadMaterial = nullptr;
    _SetMaterialTexture = nullptr;
    _SetModelMeshMaterial = nullptr;
    _LoadModelAnimations = nullptr;
    _UpdateModelAnimation = nullptr;
    _UnloadModelAnimation = nullptr;
    _UnloadModelAnimations = nullptr;
    _IsModelAnimationValid = nullptr;
    _CheckCollisionSpheres = nullptr;
    _CheckCollisionBoxes = nullptr;
    _CheckCollisionBoxSphere = nullptr;
    _GetRayCollisionSphere = nullptr;
    _GetRayCollisionBox = nullptr;
    _GetRayCollisionMesh = nullptr;
    _GetRayCollisionTriangle = nullptr;
    _GetRayCollisionQuad = nullptr;
    _InitAudioDevice = nullptr;
    _CloseAudioDevice = nullptr;
    _IsAudioDeviceReady = nullptr;
    _SetMasterVolume = nullptr;
    _LoadWave = nullptr;
    _LoadWaveFromMemory = nullptr;
    _IsWaveReady = nullptr;
    _LoadSound = nullptr;
    _LoadSoundFromWave = nullptr;
    _IsSoundReady = nullptr;
    _UpdateSound = nullptr;
    _UnloadWave = nullptr;
    _UnloadSound = nullptr;
    _ExportWave = nullptr;
    _ExportWaveAsCode = nullptr;
    _PlaySound = nullptr;
    _StopSound = nullptr;
    _PauseSound = nullptr;
    _ResumeSound = nullptr;
    _IsSoundPlaying = nullptr;
    _SetSoundVolume = nullptr;
    _SetSoundPitch = nullptr;
    _SetSoundPan = nullptr;
    _WaveCopy = nullptr;
    _WaveCrop = nullptr;
    _WaveFormat = nullptr;
    _LoadWaveSamples = nullptr;
    _UnloadWaveSamples = nullptr;
    _LoadMusicStream = nullptr;
    _LoadMusicStreamFromMemory = nullptr;
    _IsMusicReady = nullptr;
    _UnloadMusicStream = nullptr;
    _PlayMusicStream = nullptr;
    _IsMusicStreamPlaying = nullptr;
    _UpdateMusicStream = nullptr;
    _StopMusicStream = nullptr;
    _PauseMusicStream = nullptr;
    _ResumeMusicStream = nullptr;
    _SeekMusicStream = nullptr;
    _SetMusicVolume = nullptr;
    _SetMusicPitch = nullptr;
    _SetMusicPan = nullptr;
    _GetMusicTimeLength = nullptr;
    _GetMusicTimePlayed = nullptr;
    _LoadAudioStream = nullptr;
    _IsAudioStreamReady = nullptr;
    _UnloadAudioStream = nullptr;
    _UpdateAudioStream = nullptr;
    _IsAudioStreamProcessed = nullptr;
    _PlayAudioStream = nullptr;
    _PauseAudioStream = nullptr;
    _ResumeAudioStream = nullptr;
    _IsAudioStreamPlaying = nullptr;
    _StopAudioStream = nullptr;
    _SetAudioStreamVolume = nullptr;
    _SetAudioStreamPitch = nullptr;
    _SetAudioStreamPan = nullptr;
    _SetAudioStreamBufferSizeDefault = nullptr;
    _SetAudioStreamCallback = nullptr;
    _AttachAudioStreamProcessor = nullptr;
    _DetachAudioStreamProcessor = nullptr;
    _AttachAudioMixedProcessor = nullptr;
    _DetachAudioMixedProcessor = nullptr;
    //------------------------------------------------------------------------------------------------------------------

    delete raylib;
    raylib = nullptr;

    RAYLIB_DEBUG_PRINT("Shared library closed");
}

/// @brief [INTERNAL] This is used to load the raylib shared library object and initialize all function pointers
/// @return True if everything went well. Else false.
qb_bool __init_raylib()
{
    if (raylib)
        return QB_TRUE;

    // Load the shared library
    try
    {
        raylib = new dylib("./", "raylib");
    }
    catch (dylib::load_error e)
    {
        RAYLIB_DEBUG_PRINT("Error: %s", e.what());
        try
        {
            raylib = new dylib("raylib");
        }
        catch (dylib::load_error e)
        {
            RAYLIB_DEBUG_PRINT("Error: %s", e.what());
            if (!raylib)
                return QB_FALSE;
        }
    }

    // Retrieve the function pointers
    try
    {
        //--------------------------------------------------------------------------------------------------------------
        // Autogenerated dylib::get_function calls
        //--------------------------------------------------------------------------------------------------------------
        _InitWindow = raylib->get_function<void(int, int, const char *)>("InitWindow");
        _WindowShouldClose = raylib->get_function<bool(void)>("WindowShouldClose");
        _CloseWindow = raylib->get_function<void(void)>("CloseWindow");
        _IsWindowReady = raylib->get_function<bool(void)>("IsWindowReady");
        _IsWindowFullscreen = raylib->get_function<bool(void)>("IsWindowFullscreen");
        _IsWindowHidden = raylib->get_function<bool(void)>("IsWindowHidden");
        _IsWindowMinimized = raylib->get_function<bool(void)>("IsWindowMinimized");
        _IsWindowMaximized = raylib->get_function<bool(void)>("IsWindowMaximized");
        _IsWindowFocused = raylib->get_function<bool(void)>("IsWindowFocused");
        _IsWindowResized = raylib->get_function<bool(void)>("IsWindowResized");
        _IsWindowState = raylib->get_function<bool(unsigned int)>("IsWindowState");
        _SetWindowState = raylib->get_function<void(unsigned int)>("SetWindowState");
        _ClearWindowState = raylib->get_function<void(unsigned int)>("ClearWindowState");
        _ToggleFullscreen = raylib->get_function<void(void)>("ToggleFullscreen");
        _MaximizeWindow = raylib->get_function<void(void)>("MaximizeWindow");
        _MinimizeWindow = raylib->get_function<void(void)>("MinimizeWindow");
        _RestoreWindow = raylib->get_function<void(void)>("RestoreWindow");
        _SetWindowIcon = raylib->get_function<void(Image)>("SetWindowIcon");
        _SetWindowIcons = raylib->get_function<void(Image *, int)>("SetWindowIcons");
        _SetWindowTitle = raylib->get_function<void(const char *)>("SetWindowTitle");
        _SetWindowPosition = raylib->get_function<void(int, int)>("SetWindowPosition");
        _SetWindowMonitor = raylib->get_function<void(int)>("SetWindowMonitor");
        _SetWindowMinSize = raylib->get_function<void(int, int)>("SetWindowMinSize");
        _SetWindowSize = raylib->get_function<void(int, int)>("SetWindowSize");
        _SetWindowOpacity = raylib->get_function<void(float)>("SetWindowOpacity");
        _GetWindowHandle = raylib->get_function<void *(void)>("GetWindowHandle");
        _GetScreenWidth = raylib->get_function<int(void)>("GetScreenWidth");
        _GetScreenHeight = raylib->get_function<int(void)>("GetScreenHeight");
        _GetRenderWidth = raylib->get_function<int(void)>("GetRenderWidth");
        _GetRenderHeight = raylib->get_function<int(void)>("GetRenderHeight");
        _GetMonitorCount = raylib->get_function<int(void)>("GetMonitorCount");
        _GetCurrentMonitor = raylib->get_function<int(void)>("GetCurrentMonitor");
        _GetMonitorPosition = raylib->get_function<Vector2(int)>("GetMonitorPosition");
        _GetMonitorWidth = raylib->get_function<int(int)>("GetMonitorWidth");
        _GetMonitorHeight = raylib->get_function<int(int)>("GetMonitorHeight");
        _GetMonitorPhysicalWidth = raylib->get_function<int(int)>("GetMonitorPhysicalWidth");
        _GetMonitorPhysicalHeight = raylib->get_function<int(int)>("GetMonitorPhysicalHeight");
        _GetMonitorRefreshRate = raylib->get_function<int(int)>("GetMonitorRefreshRate");
        _GetWindowPosition = raylib->get_function<Vector2(void)>("GetWindowPosition");
        _GetWindowScaleDPI = raylib->get_function<Vector2(void)>("GetWindowScaleDPI");
        _GetMonitorName = raylib->get_function<const char *(int)>("GetMonitorName");
        _SetClipboardText = raylib->get_function<void(const char *)>("SetClipboardText");
        _GetClipboardText = raylib->get_function<const char *(void)>("GetClipboardText");
        _EnableEventWaiting = raylib->get_function<void(void)>("EnableEventWaiting");
        _DisableEventWaiting = raylib->get_function<void(void)>("DisableEventWaiting");
        _SwapScreenBuffer = raylib->get_function<void(void)>("SwapScreenBuffer");
        _PollInputEvents = raylib->get_function<void(void)>("PollInputEvents");
        _WaitTime = raylib->get_function<void(double)>("WaitTime");
        _ShowCursor = raylib->get_function<void(void)>("ShowCursor");
        _HideCursor = raylib->get_function<void(void)>("HideCursor");
        _IsCursorHidden = raylib->get_function<bool(void)>("IsCursorHidden");
        _EnableCursor = raylib->get_function<void(void)>("EnableCursor");
        _DisableCursor = raylib->get_function<void(void)>("DisableCursor");
        _IsCursorOnScreen = raylib->get_function<bool(void)>("IsCursorOnScreen");
        _ClearBackground = raylib->get_function<void(uint32_t)>("ClearBackground");
        _BeginDrawing = raylib->get_function<void(void)>("BeginDrawing");
        _EndDrawing = raylib->get_function<void(void)>("EndDrawing");
        _BeginMode2D = raylib->get_function<void(Camera2D)>("BeginMode2D");
        _EndMode2D = raylib->get_function<void(void)>("EndMode2D");
        _BeginMode3D = raylib->get_function<void(Camera3D)>("BeginMode3D");
        _EndMode3D = raylib->get_function<void(void)>("EndMode3D");
        _BeginTextureMode = raylib->get_function<void(RenderTexture2D)>("BeginTextureMode");
        _EndTextureMode = raylib->get_function<void(void)>("EndTextureMode");
        _BeginShaderMode = raylib->get_function<void(Shader)>("BeginShaderMode");
        _EndShaderMode = raylib->get_function<void(void)>("EndShaderMode");
        _BeginBlendMode = raylib->get_function<void(int)>("BeginBlendMode");
        _EndBlendMode = raylib->get_function<void(void)>("EndBlendMode");
        _BeginScissorMode = raylib->get_function<void(int, int, int, int)>("BeginScissorMode");
        _EndScissorMode = raylib->get_function<void(void)>("EndScissorMode");
        _BeginVrStereoMode = raylib->get_function<void(VrStereoConfig)>("BeginVrStereoMode");
        _EndVrStereoMode = raylib->get_function<void(void)>("EndVrStereoMode");
        _LoadVrStereoConfig = raylib->get_function<VrStereoConfig(VrDeviceInfo)>("LoadVrStereoConfig");
        _UnloadVrStereoConfig = raylib->get_function<void(VrStereoConfig)>("UnloadVrStereoConfig");
        _LoadShader = raylib->get_function<Shader(const char *, const char *)>("LoadShader");
        _LoadShaderFromMemory = raylib->get_function<Shader(const char *, const char *)>("LoadShaderFromMemory");
        _IsShaderReady = raylib->get_function<bool(Shader)>("IsShaderReady");
        _GetShaderLocation = raylib->get_function<int(Shader, const char *)>("GetShaderLocation");
        _GetShaderLocationAttrib = raylib->get_function<int(Shader, const char *)>("GetShaderLocationAttrib");
        _SetShaderValue = raylib->get_function<void(Shader, int, const void *, int)>("SetShaderValue");
        _SetShaderValueV = raylib->get_function<void(Shader, int, const void *, int, int)>("SetShaderValueV");
        _SetShaderValueMatrix = raylib->get_function<void(Shader, int, Matrix)>("SetShaderValueMatrix");
        _SetShaderValueTexture = raylib->get_function<void(Shader, int, Texture2D)>("SetShaderValueTexture");
        _UnloadShader = raylib->get_function<void(Shader)>("UnloadShader");
        _GetMouseRay = raylib->get_function<Ray(Vector2, Camera)>("GetMouseRay");
        _GetCameraMatrix = raylib->get_function<Matrix(Camera)>("GetCameraMatrix");
        _GetCameraMatrix2D = raylib->get_function<Matrix(Camera2D)>("GetCameraMatrix2D");
        _GetWorldToScreen = raylib->get_function<Vector2(Vector3, Camera)>("GetWorldToScreen");
        _GetScreenToWorld2D = raylib->get_function<Vector2(Vector2, Camera2D)>("GetScreenToWorld2D");
        _GetWorldToScreenEx = raylib->get_function<Vector2(Vector3, Camera, int, int)>("GetWorldToScreenEx");
        _GetWorldToScreen2D = raylib->get_function<Vector2(Vector2, Camera2D)>("GetWorldToScreen2D");
        _SetTargetFPS = raylib->get_function<void(int)>("SetTargetFPS");
        _GetFPS = raylib->get_function<int(void)>("GetFPS");
        _GetFrameTime = raylib->get_function<float(void)>("GetFrameTime");
        _GetTime = raylib->get_function<double(void)>("GetTime");
        _GetRandomValue = raylib->get_function<int(int, int)>("GetRandomValue");
        _SetRandomSeed = raylib->get_function<void(unsigned int)>("SetRandomSeed");
        _TakeScreenshot = raylib->get_function<void(const char *)>("TakeScreenshot");
        _SetConfigFlags = raylib->get_function<void(unsigned int)>("SetConfigFlags");
        _TraceLog = raylib->get_function<void(int, const char *, ...)>("TraceLog");
        _SetTraceLogLevel = raylib->get_function<void(int)>("SetTraceLogLevel");
        _MemAlloc = raylib->get_function<void *(unsigned int)>("MemAlloc");
        _MemRealloc = raylib->get_function<void *(void *, unsigned int)>("MemRealloc");
        _MemFree = raylib->get_function<void(void *)>("MemFree");
        _OpenURL = raylib->get_function<void(const char *)>("OpenURL");
        _SetTraceLogCallback = raylib->get_function<void(TraceLogCallback)>("SetTraceLogCallback");
        _SetLoadFileDataCallback = raylib->get_function<void(LoadFileDataCallback)>("SetLoadFileDataCallback");
        _SetSaveFileDataCallback = raylib->get_function<void(SaveFileDataCallback)>("SetSaveFileDataCallback");
        _SetLoadFileTextCallback = raylib->get_function<void(LoadFileTextCallback)>("SetLoadFileTextCallback");
        _SetSaveFileTextCallback = raylib->get_function<void(SaveFileTextCallback)>("SetSaveFileTextCallback");
        _LoadFileData = raylib->get_function<unsigned char *(const char *, unsigned int *)>("LoadFileData");
        _UnloadFileData = raylib->get_function<void(unsigned char *)>("UnloadFileData");
        _SaveFileData = raylib->get_function<bool(const char *, void *, unsigned int)>("SaveFileData");
        _ExportDataAsCode = raylib->get_function<bool(const unsigned char *, unsigned int, const char *)>("ExportDataAsCode");
        _LoadFileText = raylib->get_function<char *(const char *)>("LoadFileText");
        _UnloadFileText = raylib->get_function<void(char *)>("UnloadFileText");
        _SaveFileText = raylib->get_function<bool(const char *, char *)>("SaveFileText");
        _FileExists = raylib->get_function<bool(const char *)>("FileExists");
        _DirectoryExists = raylib->get_function<bool(const char *)>("DirectoryExists");
        _IsFileExtension = raylib->get_function<bool(const char *, const char *)>("IsFileExtension");
        _GetFileLength = raylib->get_function<int(const char *)>("GetFileLength");
        _GetFileExtension = raylib->get_function<const char *(const char *)>("GetFileExtension");
        _GetFileName = raylib->get_function<const char *(const char *)>("GetFileName");
        _GetFileNameWithoutExt = raylib->get_function<const char *(const char *)>("GetFileNameWithoutExt");
        _GetDirectoryPath = raylib->get_function<const char *(const char *)>("GetDirectoryPath");
        _GetPrevDirectoryPath = raylib->get_function<const char *(const char *)>("GetPrevDirectoryPath");
        _GetWorkingDirectory = raylib->get_function<const char *(void)>("GetWorkingDirectory");
        _GetApplicationDirectory = raylib->get_function<const char *(void)>("GetApplicationDirectory");
        _ChangeDirectory = raylib->get_function<bool(const char *)>("ChangeDirectory");
        _IsPathFile = raylib->get_function<bool(const char *)>("IsPathFile");
        _LoadDirectoryFiles = raylib->get_function<FilePathList(const char *)>("LoadDirectoryFiles");
        _LoadDirectoryFilesEx = raylib->get_function<FilePathList(const char *, const char *, bool)>("LoadDirectoryFilesEx");
        _UnloadDirectoryFiles = raylib->get_function<void(FilePathList)>("UnloadDirectoryFiles");
        _IsFileDropped = raylib->get_function<bool(void)>("IsFileDropped");
        _LoadDroppedFiles = raylib->get_function<FilePathList(void)>("LoadDroppedFiles");
        _UnloadDroppedFiles = raylib->get_function<void(FilePathList)>("UnloadDroppedFiles");
        _GetFileModTime = raylib->get_function<long(const char *)>("GetFileModTime");
        _CompressData = raylib->get_function<unsigned char *(const unsigned char *, int, int *)>("CompressData");
        _DecompressData = raylib->get_function<unsigned char *(const unsigned char *, int, int *)>("DecompressData");
        _EncodeDataBase64 = raylib->get_function<char *(const unsigned char *, int, int *)>("EncodeDataBase64");
        _DecodeDataBase64 = raylib->get_function<unsigned char *(const unsigned char *, int *)>("DecodeDataBase64");
        _IsKeyPressed = raylib->get_function<bool(int)>("IsKeyPressed");
        _IsKeyDown = raylib->get_function<bool(int)>("IsKeyDown");
        _IsKeyReleased = raylib->get_function<bool(int)>("IsKeyReleased");
        _IsKeyUp = raylib->get_function<bool(int)>("IsKeyUp");
        _SetExitKey = raylib->get_function<void(int)>("SetExitKey");
        _GetKeyPressed = raylib->get_function<int(void)>("GetKeyPressed");
        _GetCharPressed = raylib->get_function<int(void)>("GetCharPressed");
        _IsGamepadAvailable = raylib->get_function<bool(int)>("IsGamepadAvailable");
        _GetGamepadName = raylib->get_function<const char *(int)>("GetGamepadName");
        _IsGamepadButtonPressed = raylib->get_function<bool(int, int)>("IsGamepadButtonPressed");
        _IsGamepadButtonDown = raylib->get_function<bool(int, int)>("IsGamepadButtonDown");
        _IsGamepadButtonReleased = raylib->get_function<bool(int, int)>("IsGamepadButtonReleased");
        _IsGamepadButtonUp = raylib->get_function<bool(int, int)>("IsGamepadButtonUp");
        _GetGamepadButtonPressed = raylib->get_function<int(void)>("GetGamepadButtonPressed");
        _GetGamepadAxisCount = raylib->get_function<int(int)>("GetGamepadAxisCount");
        _GetGamepadAxisMovement = raylib->get_function<float(int, int)>("GetGamepadAxisMovement");
        _SetGamepadMappings = raylib->get_function<int(const char *)>("SetGamepadMappings");
        _IsMouseButtonPressed = raylib->get_function<bool(int)>("IsMouseButtonPressed");
        _IsMouseButtonDown = raylib->get_function<bool(int)>("IsMouseButtonDown");
        _IsMouseButtonReleased = raylib->get_function<bool(int)>("IsMouseButtonReleased");
        _IsMouseButtonUp = raylib->get_function<bool(int)>("IsMouseButtonUp");
        _GetMouseX = raylib->get_function<int(void)>("GetMouseX");
        _GetMouseY = raylib->get_function<int(void)>("GetMouseY");
        _GetMousePosition = raylib->get_function<Vector2(void)>("GetMousePosition");
        _GetMouseDelta = raylib->get_function<Vector2(void)>("GetMouseDelta");
        _SetMousePosition = raylib->get_function<void(int, int)>("SetMousePosition");
        _SetMouseOffset = raylib->get_function<void(int, int)>("SetMouseOffset");
        _SetMouseScale = raylib->get_function<void(float, float)>("SetMouseScale");
        _GetMouseWheelMove = raylib->get_function<float(void)>("GetMouseWheelMove");
        _GetMouseWheelMoveV = raylib->get_function<Vector2(void)>("GetMouseWheelMoveV");
        _SetMouseCursor = raylib->get_function<void(int)>("SetMouseCursor");
        _GetTouchX = raylib->get_function<int(void)>("GetTouchX");
        _GetTouchY = raylib->get_function<int(void)>("GetTouchY");
        _GetTouchPosition = raylib->get_function<Vector2(int)>("GetTouchPosition");
        _GetTouchPointId = raylib->get_function<int(int)>("GetTouchPointId");
        _GetTouchPointCount = raylib->get_function<int(void)>("GetTouchPointCount");
        _SetGesturesEnabled = raylib->get_function<void(unsigned int)>("SetGesturesEnabled");
        _IsGestureDetected = raylib->get_function<bool(int)>("IsGestureDetected");
        _GetGestureDetected = raylib->get_function<int(void)>("GetGestureDetected");
        _GetGestureHoldDuration = raylib->get_function<float(void)>("GetGestureHoldDuration");
        _GetGestureDragVector = raylib->get_function<Vector2(void)>("GetGestureDragVector");
        _GetGestureDragAngle = raylib->get_function<float(void)>("GetGestureDragAngle");
        _GetGesturePinchVector = raylib->get_function<Vector2(void)>("GetGesturePinchVector");
        _GetGesturePinchAngle = raylib->get_function<float(void)>("GetGesturePinchAngle");
        _UpdateCamera = raylib->get_function<void(Camera *, int)>("UpdateCamera");
        _UpdateCameraPro = raylib->get_function<void(Camera *, Vector3, Vector3, float)>("UpdateCameraPro");
        _SetShapesTexture = raylib->get_function<void(Texture2D, RRectangle)>("SetShapesTexture");
        _DrawPixel = raylib->get_function<void(int, int, uint32_t)>("DrawPixel");
        _DrawPixelV = raylib->get_function<void(Vector2, uint32_t)>("DrawPixelV");
        _DrawLine = raylib->get_function<void(int, int, int, int, uint32_t)>("DrawLine");
        _DrawLineV = raylib->get_function<void(Vector2, Vector2, uint32_t)>("DrawLineV");
        _DrawLineEx = raylib->get_function<void(Vector2, Vector2, float, uint32_t)>("DrawLineEx");
        _DrawLineBezier = raylib->get_function<void(Vector2, Vector2, float, uint32_t)>("DrawLineBezier");
        _DrawLineBezierQuad = raylib->get_function<void(Vector2, Vector2, Vector2, float, uint32_t)>("DrawLineBezierQuad");
        _DrawLineBezierCubic = raylib->get_function<void(Vector2, Vector2, Vector2, Vector2, float, uint32_t)>("DrawLineBezierCubic");
        _DrawLineStrip = raylib->get_function<void(Vector2 *, int, uint32_t)>("DrawLineStrip");
        _DrawCircle = raylib->get_function<void(int, int, float, uint32_t)>("DrawCircle");
        _DrawCircleSector = raylib->get_function<void(Vector2, float, float, float, int, uint32_t)>("DrawCircleSector");
        _DrawCircleSectorLines = raylib->get_function<void(Vector2, float, float, float, int, uint32_t)>("DrawCircleSectorLines");
        _DrawCircleGradient = raylib->get_function<void(int, int, float, uint32_t, uint32_t)>("DrawCircleGradient");
        _DrawCircleV = raylib->get_function<void(Vector2, float, uint32_t)>("DrawCircleV");
        _DrawCircleLines = raylib->get_function<void(int, int, float, uint32_t)>("DrawCircleLines");
        _DrawEllipse = raylib->get_function<void(int, int, float, float, uint32_t)>("DrawEllipse");
        _DrawEllipseLines = raylib->get_function<void(int, int, float, float, uint32_t)>("DrawEllipseLines");
        _DrawRing = raylib->get_function<void(Vector2, float, float, float, float, int, uint32_t)>("DrawRing");
        _DrawRingLines = raylib->get_function<void(Vector2, float, float, float, float, int, uint32_t)>("DrawRingLines");
        _DrawRectangle = raylib->get_function<void(int, int, int, int, uint32_t)>("DrawRectangle");
        _DrawRectangleV = raylib->get_function<void(Vector2, Vector2, uint32_t)>("DrawRectangleV");
        _DrawRectangleRec = raylib->get_function<void(RRectangle, uint32_t)>("DrawRectangleRec");
        _DrawRectanglePro = raylib->get_function<void(RRectangle, Vector2, float, uint32_t)>("DrawRectanglePro");
        _DrawRectangleGradientV = raylib->get_function<void(int, int, int, int, uint32_t, uint32_t)>("DrawRectangleGradientV");
        _DrawRectangleGradientH = raylib->get_function<void(int, int, int, int, uint32_t, uint32_t)>("DrawRectangleGradientH");
        _DrawRectangleGradientEx = raylib->get_function<void(RRectangle, uint32_t, uint32_t, uint32_t, uint32_t)>("DrawRectangleGradientEx");
        _DrawRectangleLines = raylib->get_function<void(int, int, int, int, uint32_t)>("DrawRectangleLines");
        _DrawRectangleLinesEx = raylib->get_function<void(RRectangle, float, uint32_t)>("DrawRectangleLinesEx");
        _DrawRectangleRounded = raylib->get_function<void(RRectangle, float, int, uint32_t)>("DrawRectangleRounded");
        _DrawRectangleRoundedLines = raylib->get_function<void(RRectangle, float, int, float, uint32_t)>("DrawRectangleRoundedLines");
        _DrawTriangle = raylib->get_function<void(Vector2, Vector2, Vector2, uint32_t)>("DrawTriangle");
        _DrawTriangleLines = raylib->get_function<void(Vector2, Vector2, Vector2, uint32_t)>("DrawTriangleLines");
        _DrawTriangleFan = raylib->get_function<void(Vector2 *, int, uint32_t)>("DrawTriangleFan");
        _DrawTriangleStrip = raylib->get_function<void(Vector2 *, int, uint32_t)>("DrawTriangleStrip");
        _DrawPoly = raylib->get_function<void(Vector2, int, float, float, uint32_t)>("DrawPoly");
        _DrawPolyLines = raylib->get_function<void(Vector2, int, float, float, uint32_t)>("DrawPolyLines");
        _DrawPolyLinesEx = raylib->get_function<void(Vector2, int, float, float, float, uint32_t)>("DrawPolyLinesEx");
        _CheckCollisionRecs = raylib->get_function<bool(RRectangle, RRectangle)>("CheckCollisionRecs");
        _CheckCollisionCircles = raylib->get_function<bool(Vector2, float, Vector2, float)>("CheckCollisionCircles");
        _CheckCollisionCircleRec = raylib->get_function<bool(Vector2, float, RRectangle)>("CheckCollisionCircleRec");
        _CheckCollisionPointRec = raylib->get_function<bool(Vector2, RRectangle)>("CheckCollisionPointRec");
        _CheckCollisionPointCircle = raylib->get_function<bool(Vector2, Vector2, float)>("CheckCollisionPointCircle");
        _CheckCollisionPointTriangle = raylib->get_function<bool(Vector2, Vector2, Vector2, Vector2)>("CheckCollisionPointTriangle");
        _CheckCollisionPointPoly = raylib->get_function<bool(Vector2, Vector2 *, int)>("CheckCollisionPointPoly");
        _CheckCollisionLines = raylib->get_function<bool(Vector2, Vector2, Vector2, Vector2, Vector2 *)>("CheckCollisionLines");
        _CheckCollisionPointLine = raylib->get_function<bool(Vector2, Vector2, Vector2, int)>("CheckCollisionPointLine");
        _GetCollisionRec = raylib->get_function<RRectangle(RRectangle, RRectangle)>("GetCollisionRec");
        _LoadImage = raylib->get_function<Image(const char *)>("LoadImage");
        _LoadImageRaw = raylib->get_function<Image(const char *, int, int, int, int)>("LoadImageRaw");
        _LoadImageAnim = raylib->get_function<Image(const char *, int *)>("LoadImageAnim");
        _LoadImageFromMemory = raylib->get_function<Image(const char *, const unsigned char *, int)>("LoadImageFromMemory");
        _LoadImageFromTexture = raylib->get_function<Image(Texture2D)>("LoadImageFromTexture");
        _LoadImageFromScreen = raylib->get_function<Image()>("LoadImageFromScreen");
        _IsImageReady = raylib->get_function<bool(Image)>("IsImageReady");
        _UnloadImage = raylib->get_function<void(Image)>("UnloadImage");
        _ExportImage = raylib->get_function<bool(Image, const char *)>("ExportImage");
        _ExportImageAsCode = raylib->get_function<bool(Image, const char *)>("ExportImageAsCode");
        _GenImageColor = raylib->get_function<Image(int, int, uint32_t)>("GenImageColor");
        _GenImageGradientV = raylib->get_function<Image(int, int, uint32_t, uint32_t)>("GenImageGradientV");
        _GenImageGradientH = raylib->get_function<Image(int, int, uint32_t, uint32_t)>("GenImageGradientH");
        _GenImageGradientRadial = raylib->get_function<Image(int, int, float, uint32_t, uint32_t)>("GenImageGradientRadial");
        _GenImageChecked = raylib->get_function<Image(int, int, int, int, uint32_t, uint32_t)>("GenImageChecked");
        _GenImageWhiteNoise = raylib->get_function<Image(int, int, float)>("GenImageWhiteNoise");
        _GenImagePerlinNoise = raylib->get_function<Image(int, int, int, int, float)>("GenImagePerlinNoise");
        _GenImageCellular = raylib->get_function<Image(int, int, int)>("GenImageCellular");
        _GenImageText = raylib->get_function<Image(int, int, const char *)>("GenImageText");
        _ImageCopy = raylib->get_function<Image(Image)>("ImageCopy");
        _ImageFromImage = raylib->get_function<Image(Image, RRectangle)>("ImageFromImage");
        _ImageText = raylib->get_function<Image(const char *, int, uint32_t)>("ImageText");
        _ImageTextEx = raylib->get_function<Image(Font, const char *, float, float, uint32_t)>("ImageTextEx");
        _ImageFormat = raylib->get_function<void(Image *, int)>("ImageFormat");
        _ImageToPOT = raylib->get_function<void(Image *, uint32_t)>("ImageToPOT");
        _ImageCrop = raylib->get_function<void(Image *, RRectangle)>("ImageCrop");
        _ImageAlphaCrop = raylib->get_function<void(Image *, float)>("ImageAlphaCrop");
        _ImageAlphaClear = raylib->get_function<void(Image *, uint32_t, float)>("ImageAlphaClear");
        _ImageAlphaMask = raylib->get_function<void(Image *, Image)>("ImageAlphaMask");
        _ImageAlphaPremultiply = raylib->get_function<void(Image *)>("ImageAlphaPremultiply");
        _ImageBlurGaussian = raylib->get_function<void(Image *, int)>("ImageBlurGaussian");
        _ImageResize = raylib->get_function<void(Image *, int, int)>("ImageResize");
        _ImageResizeNN = raylib->get_function<void(Image *, int, int)>("ImageResizeNN");
        _ImageResizeCanvas = raylib->get_function<void(Image *, int, int, int, int, uint32_t)>("ImageResizeCanvas");
        _ImageMipmaps = raylib->get_function<void(Image *)>("ImageMipmaps");
        _ImageDither = raylib->get_function<void(Image *, int, int, int, int)>("ImageDither");
        _ImageFlipVertical = raylib->get_function<void(Image *)>("ImageFlipVertical");
        _ImageFlipHorizontal = raylib->get_function<void(Image *)>("ImageFlipHorizontal");
        _ImageRotateCW = raylib->get_function<void(Image *)>("ImageRotateCW");
        _ImageRotateCCW = raylib->get_function<void(Image *)>("ImageRotateCCW");
        _ImageColorTint = raylib->get_function<void(Image *, uint32_t)>("ImageColorTint");
        _ImageColorInvert = raylib->get_function<void(Image *)>("ImageColorInvert");
        _ImageColorGrayscale = raylib->get_function<void(Image *)>("ImageColorGrayscale");
        _ImageColorContrast = raylib->get_function<void(Image *, float)>("ImageColorContrast");
        _ImageColorBrightness = raylib->get_function<void(Image *, int)>("ImageColorBrightness");
        _ImageColorReplace = raylib->get_function<void(Image *, uint32_t, uint32_t)>("ImageColorReplace");
        _LoadImageColors = raylib->get_function<uint32_t *(Image)>("LoadImageColors");
        _LoadImagePalette = raylib->get_function<uint32_t *(Image, int, int *)>("LoadImagePalette");
        _UnloadImageColors = raylib->get_function<void(uint32_t *)>("UnloadImageColors");
        _UnloadImagePalette = raylib->get_function<void(uint32_t *)>("UnloadImagePalette");
        _GetImageAlphaBorder = raylib->get_function<RRectangle(Image, float)>("GetImageAlphaBorder");
        _GetImageColor = raylib->get_function<uint32_t(Image, int, int)>("GetImageColor");
        _ImageClearBackground = raylib->get_function<void(Image *, uint32_t)>("ImageClearBackground");
        _ImageDrawPixel = raylib->get_function<void(Image *, int, int, uint32_t)>("ImageDrawPixel");
        _ImageDrawPixelV = raylib->get_function<void(Image *, Vector2, uint32_t)>("ImageDrawPixelV");
        _ImageDrawLine = raylib->get_function<void(Image *, int, int, int, int, uint32_t)>("ImageDrawLine");
        _ImageDrawLineV = raylib->get_function<void(Image *, Vector2, Vector2, uint32_t)>("ImageDrawLineV");
        _ImageDrawCircle = raylib->get_function<void(Image *, int, int, int, uint32_t)>("ImageDrawCircle");
        _ImageDrawCircleV = raylib->get_function<void(Image *, Vector2, int, uint32_t)>("ImageDrawCircleV");
        _ImageDrawCircleLines = raylib->get_function<void(Image *, int, int, int, uint32_t)>("ImageDrawCircleLines");
        _ImageDrawCircleLinesV = raylib->get_function<void(Image *, Vector2, int, uint32_t)>("ImageDrawCircleLinesV");
        _ImageDrawRectangle = raylib->get_function<void(Image *, int, int, int, int, uint32_t)>("ImageDrawRectangle");
        _ImageDrawRectangleV = raylib->get_function<void(Image *, Vector2, Vector2, uint32_t)>("ImageDrawRectangleV");
        _ImageDrawRectangleRec = raylib->get_function<void(Image *, RRectangle, uint32_t)>("ImageDrawRectangleRec");
        _ImageDrawRectangleLines = raylib->get_function<void(Image *, RRectangle, int, uint32_t)>("ImageDrawRectangleLines");
        _ImageDraw = raylib->get_function<void(Image *, Image, RRectangle, RRectangle, uint32_t)>("ImageDraw");
        _ImageDrawText = raylib->get_function<void(Image *, const char *, int, int, int, uint32_t)>("ImageDrawText");
        _ImageDrawTextEx = raylib->get_function<void(Image *, Font, const char *, Vector2, float, float, uint32_t)>("ImageDrawTextEx");
        _LoadTexture = raylib->get_function<Texture2D(const char *)>("LoadTexture");
        _LoadTextureFromImage = raylib->get_function<Texture2D(Image)>("LoadTextureFromImage");
        _LoadTextureCubemap = raylib->get_function<TextureCubemap(Image, int)>("LoadTextureCubemap");
        _LoadRenderTexture = raylib->get_function<RenderTexture2D(int, int)>("LoadRenderTexture");
        _IsTextureReady = raylib->get_function<bool(Texture2D)>("IsTextureReady");
        _UnloadTexture = raylib->get_function<void(Texture2D)>("UnloadTexture");
        _IsRenderTextureReady = raylib->get_function<bool(RenderTexture2D)>("IsRenderTextureReady");
        _UnloadRenderTexture = raylib->get_function<void(RenderTexture2D)>("UnloadRenderTexture");
        _UpdateTexture = raylib->get_function<void(Texture2D, const void *)>("UpdateTexture");
        _UpdateTextureRec = raylib->get_function<void(Texture2D, RRectangle, const void *)>("UpdateTextureRec");
        _GenTextureMipmaps = raylib->get_function<void(Texture2D *)>("GenTextureMipmaps");
        _SetTextureFilter = raylib->get_function<void(Texture2D, int)>("SetTextureFilter");
        _SetTextureWrap = raylib->get_function<void(Texture2D, int)>("SetTextureWrap");
        _DrawTexture = raylib->get_function<void(Texture2D, int, int, uint32_t)>("DrawTexture");
        _DrawTextureV = raylib->get_function<void(Texture2D, Vector2, uint32_t)>("DrawTextureV");
        _DrawTextureEx = raylib->get_function<void(Texture2D, Vector2, float, float, uint32_t)>("DrawTextureEx");
        _DrawTextureRec = raylib->get_function<void(Texture2D, RRectangle, Vector2, uint32_t)>("DrawTextureRec");
        _DrawTexturePro = raylib->get_function<void(Texture2D, RRectangle, RRectangle, Vector2, float, uint32_t)>("DrawTexturePro");
        _DrawTextureNPatch = raylib->get_function<void(Texture2D, NPatchInfo, RRectangle, Vector2, float, uint32_t)>("DrawTextureNPatch");
        _Fade = raylib->get_function<uint32_t(uint32_t, float)>("Fade");
        _ColorToInt = raylib->get_function<int(uint32_t)>("ColorToInt");
        _ColorNormalize = raylib->get_function<Vector4(uint32_t)>("ColorNormalize");
        _ColorFromNormalized = raylib->get_function<uint32_t(Vector4)>("ColorFromNormalized");
        _ColorToHSV = raylib->get_function<Vector3(uint32_t)>("ColorToHSV");
        _ColorFromHSV = raylib->get_function<uint32_t(float, float, float)>("ColorFromHSV");
        _ColorTint = raylib->get_function<uint32_t(uint32_t, uint32_t)>("ColorTint");
        _ColorBrightness = raylib->get_function<uint32_t(uint32_t, float)>("ColorBrightness");
        _ColorContrast = raylib->get_function<uint32_t(uint32_t, float)>("ColorContrast");
        _ColorAlpha = raylib->get_function<uint32_t(uint32_t, float)>("ColorAlpha");
        _ColorAlphaBlend = raylib->get_function<uint32_t(uint32_t, uint32_t, uint32_t)>("ColorAlphaBlend");
        _GetColor = raylib->get_function<uint32_t(unsigned int)>("GetColor");
        _GetPixelColor = raylib->get_function<uint32_t(void *, int)>("GetPixelColor");
        _SetPixelColor = raylib->get_function<void(void *, uint32_t, int)>("SetPixelColor");
        _GetPixelDataSize = raylib->get_function<int(int, int, int)>("GetPixelDataSize");
        _GetFontDefault = raylib->get_function<Font(void)>("GetFontDefault");
        _LoadFont = raylib->get_function<Font(const char *)>("LoadFont");
        _LoadFontEx = raylib->get_function<Font(const char *, int, int *, int)>("LoadFontEx");
        _LoadFontFromImage = raylib->get_function<Font(Image, uint32_t, int)>("LoadFontFromImage");
        _LoadFontFromMemory = raylib->get_function<Font(const char *, const unsigned char *, int, int, int *, int)>("LoadFontFromMemory");
        _IsFontReady = raylib->get_function<bool(Font)>("IsFontReady");
        _LoadFontData = raylib->get_function<GlyphInfo *(const unsigned char *, int, int, int *, int, int)>("LoadFontData");
        _GenImageFontAtlas = raylib->get_function<Image(const GlyphInfo *, RRectangle **, int, int, int, int)>("GenImageFontAtlas");
        _UnloadFontData = raylib->get_function<void(GlyphInfo *, int)>("UnloadFontData");
        _UnloadFont = raylib->get_function<void(Font)>("UnloadFont");
        _ExportFontAsCode = raylib->get_function<bool(Font, const char *)>("ExportFontAsCode");
        _DrawFPS = raylib->get_function<void(int, int)>("DrawFPS");
        _DrawText = raylib->get_function<void(const char *, int, int, int, uint32_t)>("DrawText");
        _DrawTextEx = raylib->get_function<void(Font, const char *, Vector2, float, float, uint32_t)>("DrawTextEx");
        _DrawTextPro = raylib->get_function<void(Font, const char *, Vector2, Vector2, float, float, float, uint32_t)>("DrawTextPro");
        _DrawTextCodepoint = raylib->get_function<void(Font, int, Vector2, float, uint32_t)>("DrawTextCodepoint");
        _DrawTextCodepoints = raylib->get_function<void(Font, const int *, int, Vector2, float, float, uint32_t)>("DrawTextCodepoints");
        _MeasureText = raylib->get_function<int(const char *, int)>("MeasureText");
        _MeasureTextEx = raylib->get_function<Vector2(Font, const char *, float, float)>("MeasureTextEx");
        _GetGlyphIndex = raylib->get_function<int(Font, int)>("GetGlyphIndex");
        _GetGlyphInfo = raylib->get_function<GlyphInfo(Font, int)>("GetGlyphInfo");
        _GetGlyphAtlasRec = raylib->get_function<RRectangle(Font, int)>("GetGlyphAtlasRec");
        _LoadUTF8 = raylib->get_function<char *(const int *, int)>("LoadUTF8");
        _UnloadUTF8 = raylib->get_function<void(char *)>("UnloadUTF8");
        _LoadCodepoints = raylib->get_function<int *(const char *, int *)>("LoadCodepoints");
        _UnloadCodepoints = raylib->get_function<void(int *)>("UnloadCodepoints");
        _GetCodepointCount = raylib->get_function<int(const char *)>("GetCodepointCount");
        _GetCodepoint = raylib->get_function<int(const char *, int *)>("GetCodepoint");
        _GetCodepointNext = raylib->get_function<int(const char *, int *)>("GetCodepointNext");
        _GetCodepointPrevious = raylib->get_function<int(const char *, int *)>("GetCodepointPrevious");
        _CodepointToUTF8 = raylib->get_function<const char *(int, int *)>("CodepointToUTF8");
        _TextCopy = raylib->get_function<int(char *, const char *)>("TextCopy");
        _TextIsEqual = raylib->get_function<bool(const char *, const char *)>("TextIsEqual");
        _TextLength = raylib->get_function<unsigned int(const char *)>("TextLength");
        _TextFormat = raylib->get_function<const char *(const char *, ...)>("TextFormat");
        _TextSubtext = raylib->get_function<const char *(const char *, int, int)>("TextSubtext");
        _TextReplace = raylib->get_function<char *(char *, const char *, const char *)>("TextReplace");
        _TextInsert = raylib->get_function<char *(const char *, const char *, int)>("TextInsert");
        _TextJoin = raylib->get_function<const char *(const char **, int, const char *)>("TextJoin");
        _TextSplit = raylib->get_function<const char **(const char *, char, int *)>("TextSplit");
        _TextAppend = raylib->get_function<void(char *, const char *, int *)>("TextAppend");
        _TextFindIndex = raylib->get_function<int(const char *, const char *)>("TextFindIndex");
        _TextToUpper = raylib->get_function<const char *(const char *)>("TextToUpper");
        _TextToLower = raylib->get_function<const char *(const char *)>("TextToLower");
        _TextToPascal = raylib->get_function<const char *(const char *)>("TextToPascal");
        _TextToInteger = raylib->get_function<int(const char *)>("TextToInteger");
        _DrawLine3D = raylib->get_function<void(Vector3, Vector3, uint32_t)>("DrawLine3D");
        _DrawPoint3D = raylib->get_function<void(Vector3, uint32_t)>("DrawPoint3D");
        _DrawCircle3D = raylib->get_function<void(Vector3, float, Vector3, float, uint32_t)>("DrawCircle3D");
        _DrawTriangle3D = raylib->get_function<void(Vector3, Vector3, Vector3, uint32_t)>("DrawTriangle3D");
        _DrawTriangleStrip3D = raylib->get_function<void(Vector3 *, int, uint32_t)>("DrawTriangleStrip3D");
        _DrawCube = raylib->get_function<void(Vector3, float, float, float, uint32_t)>("DrawCube");
        _DrawCubeV = raylib->get_function<void(Vector3, Vector3, uint32_t)>("DrawCubeV");
        _DrawCubeWires = raylib->get_function<void(Vector3, float, float, float, uint32_t)>("DrawCubeWires");
        _DrawCubeWiresV = raylib->get_function<void(Vector3, Vector3, uint32_t)>("DrawCubeWiresV");
        _DrawSphere = raylib->get_function<void(Vector3, float, uint32_t)>("DrawSphere");
        _DrawSphereEx = raylib->get_function<void(Vector3, float, int, int, uint32_t)>("DrawSphereEx");
        _DrawSphereWires = raylib->get_function<void(Vector3, float, int, int, uint32_t)>("DrawSphereWires");
        _DrawCylinder = raylib->get_function<void(Vector3, float, float, float, int, uint32_t)>("DrawCylinder");
        _DrawCylinderEx = raylib->get_function<void(Vector3, Vector3, float, float, int, uint32_t)>("DrawCylinderEx");
        _DrawCylinderWires = raylib->get_function<void(Vector3, float, float, float, int, uint32_t)>("DrawCylinderWires");
        _DrawCylinderWiresEx = raylib->get_function<void(Vector3, Vector3, float, float, int, uint32_t)>("DrawCylinderWiresEx");
        _DrawCapsule = raylib->get_function<void(Vector3, Vector3, float, int, int, uint32_t)>("DrawCapsule");
        _DrawCapsuleWires = raylib->get_function<void(Vector3, Vector3, float, int, int, uint32_t)>("DrawCapsuleWires");
        _DrawPlane = raylib->get_function<void(Vector3, Vector2, uint32_t)>("DrawPlane");
        _DrawRay = raylib->get_function<void(Ray, uint32_t)>("DrawRay");
        _DrawGrid = raylib->get_function<void(int, float)>("DrawGrid");
        _LoadModel = raylib->get_function<Model(const char *)>("LoadModel");
        _LoadModelFromMesh = raylib->get_function<Model(Mesh)>("LoadModelFromMesh");
        _IsModelReady = raylib->get_function<bool(Model)>("IsModelReady");
        _UnloadModel = raylib->get_function<void(Model)>("UnloadModel");
        _GetModelBoundingBox = raylib->get_function<BoundingBox(Model)>("GetModelBoundingBox");
        _DrawModel = raylib->get_function<void(Model, Vector3, float, uint32_t)>("DrawModel");
        _DrawModelEx = raylib->get_function<void(Model, Vector3, Vector3, float, Vector3, uint32_t)>("DrawModelEx");
        _DrawModelWires = raylib->get_function<void(Model, Vector3, float, uint32_t)>("DrawModelWires");
        _DrawModelWiresEx = raylib->get_function<void(Model, Vector3, Vector3, float, Vector3, uint32_t)>("DrawModelWiresEx");
        _DrawBoundingBox = raylib->get_function<void(BoundingBox, uint32_t)>("DrawBoundingBox");
        _DrawBillboard = raylib->get_function<void(Camera, Texture2D, Vector3, float, uint32_t)>("DrawBillboard");
        _DrawBillboardRec = raylib->get_function<void(Camera, Texture2D, RRectangle, Vector3, Vector2, uint32_t)>("DrawBillboardRec");
        _DrawBillboardPro = raylib->get_function<void(Camera, Texture2D, RRectangle, Vector3, Vector3, Vector2, Vector2, float, uint32_t)>("DrawBillboardPro");
        _UploadMesh = raylib->get_function<void(Mesh *, bool)>("UploadMesh");
        _UpdateMeshBuffer = raylib->get_function<void(Mesh, int, const void *, int, int)>("UpdateMeshBuffer");
        _UnloadMesh = raylib->get_function<void(Mesh)>("UnloadMesh");
        _DrawMesh = raylib->get_function<void(Mesh, Material, Matrix)>("DrawMesh");
        _DrawMeshInstanced = raylib->get_function<void(Mesh, Material, const Matrix *, int)>("DrawMeshInstanced");
        _ExportMesh = raylib->get_function<bool(Mesh, const char *)>("ExportMesh");
        _GetMeshBoundingBox = raylib->get_function<BoundingBox(Mesh)>("GetMeshBoundingBox");
        _GenMeshTangents = raylib->get_function<void(Mesh *)>("GenMeshTangents");
        _GenMeshPoly = raylib->get_function<Mesh(int, float)>("GenMeshPoly");
        _GenMeshPlane = raylib->get_function<Mesh(float, float, int, int)>("GenMeshPlane");
        _GenMeshCube = raylib->get_function<Mesh(float, float, float)>("GenMeshCube");
        _GenMeshSphere = raylib->get_function<Mesh(float, int, int)>("GenMeshSphere");
        _GenMeshHemiSphere = raylib->get_function<Mesh(float, int, int)>("GenMeshHemiSphere");
        _GenMeshCylinder = raylib->get_function<Mesh(float, float, int)>("GenMeshCylinder");
        _GenMeshCone = raylib->get_function<Mesh(float, float, int)>("GenMeshCone");
        _GenMeshTorus = raylib->get_function<Mesh(float, float, int, int)>("GenMeshTorus");
        _GenMeshKnot = raylib->get_function<Mesh(float, float, int, int)>("GenMeshKnot");
        _GenMeshHeightmap = raylib->get_function<Mesh(Image, Vector3)>("GenMeshHeightmap");
        _GenMeshCubicmap = raylib->get_function<Mesh(Image, Vector3)>("GenMeshCubicmap");
        _LoadMaterials = raylib->get_function<Material *(const char *, int *)>("LoadMaterials");
        _LoadMaterialDefault = raylib->get_function<Material(void)>("LoadMaterialDefault");
        _IsMaterialReady = raylib->get_function<bool(Material)>("IsMaterialReady");
        _UnloadMaterial = raylib->get_function<void(Material)>("UnloadMaterial");
        _SetMaterialTexture = raylib->get_function<void(Material *, int, Texture2D)>("SetMaterialTexture");
        _SetModelMeshMaterial = raylib->get_function<void(Model *, int, int)>("SetModelMeshMaterial");
        _LoadModelAnimations = raylib->get_function<ModelAnimation *(const char *, unsigned int *)>("LoadModelAnimations");
        _UpdateModelAnimation = raylib->get_function<void(Model, ModelAnimation, int)>("UpdateModelAnimation");
        _UnloadModelAnimation = raylib->get_function<void(ModelAnimation)>("UnloadModelAnimation");
        _UnloadModelAnimations = raylib->get_function<void(ModelAnimation *, unsigned int)>("UnloadModelAnimations");
        _IsModelAnimationValid = raylib->get_function<bool(Model, ModelAnimation)>("IsModelAnimationValid");
        _CheckCollisionSpheres = raylib->get_function<bool(Vector3, float, Vector3, float)>("CheckCollisionSpheres");
        _CheckCollisionBoxes = raylib->get_function<bool(BoundingBox, BoundingBox)>("CheckCollisionBoxes");
        _CheckCollisionBoxSphere = raylib->get_function<bool(BoundingBox, Vector3, float)>("CheckCollisionBoxSphere");
        _GetRayCollisionSphere = raylib->get_function<RayCollision(Ray, Vector3, float)>("GetRayCollisionSphere");
        _GetRayCollisionBox = raylib->get_function<RayCollision(Ray, BoundingBox)>("GetRayCollisionBox");
        _GetRayCollisionMesh = raylib->get_function<RayCollision(Ray, Mesh, Matrix)>("GetRayCollisionMesh");
        _GetRayCollisionTriangle = raylib->get_function<RayCollision(Ray, Vector3, Vector3, Vector3)>("GetRayCollisionTriangle");
        _GetRayCollisionQuad = raylib->get_function<RayCollision(Ray, Vector3, Vector3, Vector3, Vector3)>("GetRayCollisionQuad");
        _InitAudioDevice = raylib->get_function<void(void)>("InitAudioDevice");
        _CloseAudioDevice = raylib->get_function<void(void)>("CloseAudioDevice");
        _IsAudioDeviceReady = raylib->get_function<bool(void)>("IsAudioDeviceReady");
        _SetMasterVolume = raylib->get_function<void(float)>("SetMasterVolume");
        _LoadWave = raylib->get_function<Wave(const char *)>("LoadWave");
        _LoadWaveFromMemory = raylib->get_function<Wave(const char *, const unsigned char *, int)>("LoadWaveFromMemory");
        _IsWaveReady = raylib->get_function<bool(Wave)>("IsWaveReady");
        _LoadSound = raylib->get_function<Sound(const char *)>("LoadSound");
        _LoadSoundFromWave = raylib->get_function<Sound(Wave)>("LoadSoundFromWave");
        _IsSoundReady = raylib->get_function<bool(Sound)>("IsSoundReady");
        _UpdateSound = raylib->get_function<void(Sound, const void *, int)>("UpdateSound");
        _UnloadWave = raylib->get_function<void(Wave)>("UnloadWave");
        _UnloadSound = raylib->get_function<void(Sound)>("UnloadSound");
        _ExportWave = raylib->get_function<bool(Wave, const char *)>("ExportWave");
        _ExportWaveAsCode = raylib->get_function<bool(Wave, const char *)>("ExportWaveAsCode");
        _PlaySound = raylib->get_function<void(Sound)>("PlaySound");
        _StopSound = raylib->get_function<void(Sound)>("StopSound");
        _PauseSound = raylib->get_function<void(Sound)>("PauseSound");
        _ResumeSound = raylib->get_function<void(Sound)>("ResumeSound");
        _IsSoundPlaying = raylib->get_function<bool(Sound)>("IsSoundPlaying");
        _SetSoundVolume = raylib->get_function<void(Sound, float)>("SetSoundVolume");
        _SetSoundPitch = raylib->get_function<void(Sound, float)>("SetSoundPitch");
        _SetSoundPan = raylib->get_function<void(Sound, float)>("SetSoundPan");
        _WaveCopy = raylib->get_function<Wave(Wave)>("WaveCopy");
        _WaveCrop = raylib->get_function<void(Wave *, int, int)>("WaveCrop");
        _WaveFormat = raylib->get_function<void(Wave *, int, int, int)>("WaveFormat");
        _LoadWaveSamples = raylib->get_function<float *(Wave)>("LoadWaveSamples");
        _UnloadWaveSamples = raylib->get_function<void(float *)>("UnloadWaveSamples");
        _LoadMusicStream = raylib->get_function<Music(const char *)>("LoadMusicStream");
        _LoadMusicStreamFromMemory = raylib->get_function<Music(const char *, const unsigned char *, int)>("LoadMusicStreamFromMemory");
        _IsMusicReady = raylib->get_function<bool(Music)>("IsMusicReady");
        _UnloadMusicStream = raylib->get_function<void(Music)>("UnloadMusicStream");
        _PlayMusicStream = raylib->get_function<void(Music)>("PlayMusicStream");
        _IsMusicStreamPlaying = raylib->get_function<bool(Music)>("IsMusicStreamPlaying");
        _UpdateMusicStream = raylib->get_function<void(Music)>("UpdateMusicStream");
        _StopMusicStream = raylib->get_function<void(Music)>("StopMusicStream");
        _PauseMusicStream = raylib->get_function<void(Music)>("PauseMusicStream");
        _ResumeMusicStream = raylib->get_function<void(Music)>("ResumeMusicStream");
        _SeekMusicStream = raylib->get_function<void(Music, float)>("SeekMusicStream");
        _SetMusicVolume = raylib->get_function<void(Music, float)>("SetMusicVolume");
        _SetMusicPitch = raylib->get_function<void(Music, float)>("SetMusicPitch");
        _SetMusicPan = raylib->get_function<void(Music, float)>("SetMusicPan");
        _GetMusicTimeLength = raylib->get_function<float(Music)>("GetMusicTimeLength");
        _GetMusicTimePlayed = raylib->get_function<float(Music)>("GetMusicTimePlayed");
        _LoadAudioStream = raylib->get_function<AudioStream(unsigned int, unsigned int, unsigned int)>("LoadAudioStream");
        _IsAudioStreamReady = raylib->get_function<bool(AudioStream)>("IsAudioStreamReady");
        _UnloadAudioStream = raylib->get_function<void(AudioStream)>("UnloadAudioStream");
        _UpdateAudioStream = raylib->get_function<void(AudioStream, const void *, int)>("UpdateAudioStream");
        _IsAudioStreamProcessed = raylib->get_function<bool(AudioStream)>("IsAudioStreamProcessed");
        _PlayAudioStream = raylib->get_function<void(AudioStream)>("PlayAudioStream");
        _PauseAudioStream = raylib->get_function<void(AudioStream)>("PauseAudioStream");
        _ResumeAudioStream = raylib->get_function<void(AudioStream)>("ResumeAudioStream");
        _IsAudioStreamPlaying = raylib->get_function<bool(AudioStream)>("IsAudioStreamPlaying");
        _StopAudioStream = raylib->get_function<void(AudioStream)>("StopAudioStream");
        _SetAudioStreamVolume = raylib->get_function<void(AudioStream, float)>("SetAudioStreamVolume");
        _SetAudioStreamPitch = raylib->get_function<void(AudioStream, float)>("SetAudioStreamPitch");
        _SetAudioStreamPan = raylib->get_function<void(AudioStream, float)>("SetAudioStreamPan");
        _SetAudioStreamBufferSizeDefault = raylib->get_function<void(int)>("SetAudioStreamBufferSizeDefault");
        _SetAudioStreamCallback = raylib->get_function<void(AudioStream, AudioCallback)>("SetAudioStreamCallback");
        _AttachAudioStreamProcessor = raylib->get_function<void(AudioStream, AudioCallback)>("AttachAudioStreamProcessor");
        _DetachAudioStreamProcessor = raylib->get_function<void(AudioStream, AudioCallback)>("DetachAudioStreamProcessor");
        _AttachAudioMixedProcessor = raylib->get_function<void(AudioCallback)>("AttachAudioMixedProcessor");
        _DetachAudioMixedProcessor = raylib->get_function<void(AudioCallback)>("DetachAudioMixedProcessor");
        //--------------------------------------------------------------------------------------------------------------
    }
    catch (dylib::symbol_error e)
    {
        RAYLIB_DEBUG_PRINT("Error: %s", e.what());
        __done_raylib();
        return QB_FALSE;
    }

    atexit(__done_raylib); // cleanup before the program ends

    RAYLIB_DEBUG_PRINT("Shared library loaded");

    return QB_TRUE;
}

// Various interop functions that make life easy when working with external libs

/// @brief Returns QB style bool
/// @param x Any number
/// @return 0 when x is 0 and -1 when x is non-zero
inline qb_bool ToQBBool(int32_t x)
{
    return TO_QB_BOOL(x);
}

/// @brief Returns C style bool
/// @param x Any number
/// @return 0 when x is 0 and 1 when x is non-zero
inline bool ToCBool(int32_t x)
{
    return TO_C_BOOL(x);
}

/// @brief Casts a QB64 _OFFSET to an unsigned integer. Needed because QB64 does not allow converting or using _OFFSET in expressions (fully :()
/// @param p A pointer (_OFFSET)
/// @return Pointer value (uintptr_t)
inline uintptr_t CLngPtr(uintptr_t p)
{
    return p;
}

/// @brief Casts a QB64 _OFFSET to a C string. QB64 does the right thing to convert this to a QB64 string
/// @param p A pointer (_OFFSET)
/// @return A C string (char ptr)
inline const uint8_t *CStr(uintptr_t p)
{
    return (const uint8_t *)p;
}

/// @brief Peeks a BYTE (8-bits) value at p + o
/// @param p Pointer base
/// @param o Offset from base
/// @return BYTE value
inline uint8_t PeekByte(uintptr_t p, uintptr_t o)
{
    return *((uint8_t *)p + o);
}

/// @brief Poke a BYTE (8-bits) value at p + o
/// @param p Pointer base
/// @param o Offset from base
/// @param n BYTE value
inline void PokeByte(uintptr_t p, uintptr_t o, uint8_t n)
{
    *((uint8_t *)p + o) = n;
}

/// @brief Peek an INTEGER (16-bits) value at p + o
/// @param p Pointer base
/// @param o Offset from base
/// @return INTEGER value
inline uint16_t PeekInteger(uintptr_t p, uintptr_t o)
{
    return *((uint16_t *)p + o);
}

/// @brief Poke an INTEGER (16-bits) value at p + o
/// @param p Pointer base
/// @param o Offset from base
/// @param n INTEGER value
inline void PokeInteger(uintptr_t p, uintptr_t o, uint16_t n)
{
    *((uint16_t *)p + o) = n;
}

/// @brief Peek a LONG (32-bits) value at p + o
/// @param p Pointer base
/// @param o Offset from base
/// @return LONG value
inline uint32_t PeekLong(uintptr_t p, uintptr_t o)
{
    return *((uint32_t *)p + o);
}

/// @brief Poke a LONG (32-bits) value at p + o
/// @param p Pointer base
/// @param o Offset from base
/// @param n LONG value
inline void PokeLong(uintptr_t p, uintptr_t o, uint32_t n)
{
    *((uint32_t *)p + o) = n;
}

/// @brief Peek a INTEGER64 (64-bits) value at p + o
/// @param p Pointer base
/// @param o Offset from base
/// @return INTEGER64 value
inline uint64_t PeekInteger64(uintptr_t p, uintptr_t o)
{
    return *((uint64_t *)p + o);
}

/// @brief Poke a INTEGER64 (64-bits) value at p + o
/// @param p Pointer base
/// @param o Offset from base
/// @param n INTEGER64 value
inline void PokeInteger64(uintptr_t p, uintptr_t o, uint64_t n)
{
    *((uint64_t *)p + o) = n;
}

/// @brief Peek a SINGLE (32-bits) value at p + o
/// @param p Pointer base
/// @param o Offset from base
/// @return SINGLE value
inline float PeekSingle(uintptr_t p, uintptr_t o)
{
    return *((float *)p + o);
}

/// @brief Poke a SINGLE (32-bits) value at p + o
/// @param p Pointer base
/// @param o Offset from base
/// @param n SINGLE value
inline void PokeSingle(uintptr_t p, uintptr_t o, float n)
{
    *((float *)p + o) = n;
}

/// @brief Peek a DOUBLE (64-bits) value at p + o
/// @param p Pointer base
/// @param o Offset from base
/// @return DOUBLE value
inline double PeekDouble(uintptr_t p, uintptr_t o)
{
    return *((double *)p + o);
}

/// @brief Poke a DOUBLE (64-bits) value at p + o
/// @param p Pointer base
/// @param o Offset from base
/// @param n DOUBLE value
inline void PokeDouble(uintptr_t p, uintptr_t o, double n)
{
    *((double *)p + o) = n;
}

/// @brief Peek an OFFSET (32/64-bits) value at p + o
/// @param p Pointer base
/// @param o Offset from base
/// @return DOUBLE value
inline uintptr_t PeekOffset(uintptr_t p, uintptr_t o)
{
    return *((uintptr_t *)p + o);
}

/// @brief Poke an OFFSET (32/64-bits) value at p + o
/// @param p Pointer base
/// @param o Offset from base
/// @param n DOUBLE value
inline void PokeOffset(uintptr_t p, uintptr_t o, uintptr_t n)
{
    *((uintptr_t *)p + o) = n;
}

/// @brief Gets a UDT value from a pointer positon offset by o. Same as t = p[o]
/// @param p The base pointer
/// @param o Offset from base (each offset is t_size bytes)
/// @param t A pointer to the UDT variable
/// @param t_size The size of the UTD variable in bytes
inline void PeekType(uintptr_t p, uintptr_t o, uintptr_t t, size_t t_size)
{
    memcpy((void *)t, (const uint8_t *)p + (o * t_size), t_size);
}

/// @brief Sets a UDT value to a pointer position offset by o. Same as p[o] = t
/// @param p The base pointer
/// @param o Offset from base (each offset is t_size bytes)
/// @param t A pointer to the UDT variable
/// @param t_size The size of the UTD variable in bytes
inline void PokeType(uintptr_t p, uintptr_t o, uintptr_t t, size_t t_size)
{
    memcpy((uint8_t *)p + (o * t_size), (void *)t, t_size);
}

/// @brief Peek a character value in a string. Zero based, faster and unsafe than ASC
/// @param s A QB64 string
/// @param o Offset from base (zero based)
/// @return The ASCII character at position o
inline int8_t PeekStringByte(const char *s, uintptr_t o)
{
    return s[o];
}

/// @brief Poke a character value in a string. Zero based, faster and unsafe than ASC
/// @param s A QB64 string
/// @param o Offset from base (zero based)
/// @param n The ASCII character at position o
inline void PokeStringByte(char *s, uintptr_t o, int8_t n)
{
    s[o] = n;
}

/// @brief Peek an integer value in a string
/// @param s A QB64 string
/// @param o Offset from base (zero based)
/// @return The integer at position o
inline int16_t PeekStringInteger(const char *s, uintptr_t o)
{
    return *reinterpret_cast<const int16_t *>(&s[o * sizeof(int16_t)]);
}

/// @brief Poke an integer value in a string
/// @param s A QB64 string
/// @param o Offset from base (zero based)
/// @param n The integer at position o
inline void PokeStringInteger(char *s, uintptr_t o, int16_t n)
{
    *reinterpret_cast<int16_t *>(&s[o * sizeof(int16_t)]) = n;
}

/// @brief Peek a long value in a string
/// @param s A QB64 string
/// @param o Offset from base (zero based)
/// @return The long at position o
inline int32_t PeekStringLong(const char *s, uintptr_t o)
{
    return *reinterpret_cast<const int32_t *>(&s[o * sizeof(int32_t)]);
}

/// @brief Poke an long value in a string
/// @param s A QB64 string
/// @param o Offset from base (zero based)
/// @param n The long at position o
inline void PokeStringLong(char *s, uintptr_t o, int32_t n)
{
    *reinterpret_cast<int32_t *>(&s[o * sizeof(int32_t)]) = n;
}

/// @brief Peek an integer64 value in a string
/// @param s A QB64 string
/// @param o Offset from base (zero based)
/// @return The integer64 at position o
inline int64_t PeekStringInteger64(const char *s, uintptr_t o)
{
    return *reinterpret_cast<const int64_t *>(&s[o * sizeof(int64_t)]);
}

/// @brief Poke an integer64 value in a string
/// @param s A QB64 string
/// @param o Offset from base (zero based)
/// @param n The integer64 at position o
inline void PokeStringInteger64(char *s, uintptr_t o, int64_t n)
{
    *reinterpret_cast<int64_t *>(&s[o * sizeof(int64_t)]) = n;
}

/// @brief Peek a single value in a string
/// @param s A QB64 string
/// @param o Offset from base (zero based)
/// @return The single at position o
inline float PeekStringSingle(const char *s, uintptr_t o)
{
    return *reinterpret_cast<const float *>(&s[o * sizeof(float)]);
}

/// @brief Poke a single value in a string
/// @param s A QB64 string
/// @param o Offset from base (zero based)
/// @param n The single at position o
inline void PokeStringSingle(char *s, uintptr_t o, float n)
{
    *reinterpret_cast<float *>(&s[o * sizeof(float)]) = n;
}

/// @brief Peek a double value in a string
/// @param s A QB64 string
/// @param o Offset from base (zero based)
/// @return The double at position o
inline double PeekStringDouble(const char *s, uintptr_t o)
{
    return *reinterpret_cast<const double *>(&s[o * sizeof(double)]);
}

/// @brief Poke a double value in a string
/// @param s A QB64 string
/// @param o Offset from base (zero based)
/// @param n The double at position o
inline void PokeStringDouble(char *s, uintptr_t o, double n)
{
    *reinterpret_cast<double *>(&s[o * sizeof(double)]) = n;
}

/// @brief Peek an Offset value in a string
/// @param s A QB64 string
/// @param o Offset from base (zero based)
/// @return The Offset at position o
inline uintptr_t PeekStringOffset(const char *s, uintptr_t o)
{
    return *reinterpret_cast<const uintptr_t *>(&s[o * sizeof(uint64_t)]);
}

/// @brief Poke an Offset value in a string
/// @param s A QB64 string
/// @param o Offset from base (zero based)
/// @param n The Offset at position o
inline void PokeStringOffset(char *s, uintptr_t o, uintptr_t n)
{
    *reinterpret_cast<uintptr_t *>(&s[o * sizeof(uint64_t)]) = n;
}

/// @brief Gets a UDT value from a string offset
/// @param s A QB64 string
/// @param o Offset from base (zero based)
/// @param t A pointer to the UDT variable
/// @param t_size The size of the UTD variable in bytes
inline void PeekStringType(const char *s, uintptr_t o, uintptr_t t, size_t t_size)
{
    memcpy((void *)t, s + (o * t_size), t_size);
}

/// @brief Sets a UDT value to a string offset
/// @param s A QB64 string
/// @param o Offset from base (zero based)
/// @param t A pointer to the UDT variable
/// @param t_size The size of the UTD variable in bytes
inline void PokeStringType(char *s, uintptr_t o, uintptr_t t, size_t t_size)
{
    memcpy(s + (o * t_size), (void *)t, t_size);
}

/// @brief Makes a RGBA color from RGBA components (the return value is the same as raylib Color in memory)
/// @param r Red (0 - 255)
/// @param g Green (0 - 255)
/// @param b Blue (0 - 255)
/// @param a Alpha (0 - 255)
/// @return Returns an RGBA color
inline uint32_t ToRGBA(uint8_t r, uint8_t g, uint8_t b, uint8_t a)
{
    return ((uint32_t)a << 24) | ((uint32_t)b << 16) | ((uint32_t)g << 8) | (uint32_t)(r);
}

/// @brief Returns the Red component
/// @param rgba An RGBA color
/// @return Red
inline uint8_t GetRed(uint32_t rgba)
{
    return (uint8_t)(rgba & 0xFF);
}

/// @brief Returns the Green component
/// @param rgba An RGBA color
/// @return Green
inline uint8_t GetGreen(uint32_t rgba)
{
    return (uint8_t)((rgba >> 8) & 0xFF);
}

/// @brief Returns the Blue component
/// @param rgba An RGBA color
/// @return Blue
inline uint8_t GetBlue(uint32_t rgba)
{
    return (uint8_t)((rgba >> 16) & 0xFF);
}

/// @brief Returns the Alpha value
/// @param rgba An RGBA color
/// @return Alpha
inline uint8_t GetAlpha(uint32_t rgba)
{
    return (uint8_t)(rgba >> 24);
}

/// @brief Gets the RGB value without the alpha
/// @param rgba An RGBA color
/// @return RGB value
inline uint32_t GetRGB(uint32_t rgba)
{
    return rgba & 0xFFFFFF;
}

/// @brief Helps convert a BGRA color to an RGBA color and back
/// @param bgra A BGRA color or an RGBA color
/// @return An RGBA color or a BGRA color
inline uint32_t SwapRedBlue(uint32_t clr)
{
    return (clr & 0xFF00FF00) | ((clr & 0x00FF0000) >> 16) | ((clr & 0x000000FF) << 16);
}

//----------------------------------------------------------------------------------------------------------------------
// Autogenerated QB64-PE compatible wrapper functions
//----------------------------------------------------------------------------------------------------------------------
inline void InitWindow(int width, int height, const char *title)
{
    _InitWindow(width, height, title);
}

inline qb_bool WindowShouldClose(void)
{
    return TO_QB_BOOL(_WindowShouldClose());
}

inline void CloseWindow(void)
{
    _CloseWindow();
}

inline qb_bool IsWindowReady(void)
{
    return TO_QB_BOOL(_IsWindowReady());
}

inline qb_bool IsWindowFullscreen(void)
{
    return TO_QB_BOOL(_IsWindowFullscreen());
}

inline qb_bool IsWindowHidden(void)
{
    return TO_QB_BOOL(_IsWindowHidden());
}

inline qb_bool IsWindowMinimized(void)
{
    return TO_QB_BOOL(_IsWindowMinimized());
}

inline qb_bool IsWindowMaximized(void)
{
    return TO_QB_BOOL(_IsWindowMaximized());
}

inline qb_bool IsWindowFocused(void)
{
    return TO_QB_BOOL(_IsWindowFocused());
}

inline qb_bool IsWindowResized(void)
{
    return TO_QB_BOOL(_IsWindowResized());
}

inline qb_bool IsWindowState(unsigned int flag)
{
    return TO_QB_BOOL(_IsWindowState(flag));
}

inline void SetWindowState(unsigned int flags)
{
    _SetWindowState(flags);
}

inline void ClearWindowState(unsigned int flags)
{
    _ClearWindowState(flags);
}

inline void ToggleFullscreen(void)
{
    _ToggleFullscreen();
}

inline void MaximizeWindow(void)
{
    _MaximizeWindow();
}

inline void MinimizeWindow(void)
{
    _MinimizeWindow();
}

inline void RestoreWindow(void)
{
    _RestoreWindow();
}

inline void SetWindowIcon(void *image)
{
    _SetWindowIcon(*(Image *)image);
}

inline void SetWindowIcons(void *images, int count)
{
    _SetWindowIcons((Image *)images, count);
}

inline void SetWindowTitle(const char *title)
{
    _SetWindowTitle(title);
}

inline void SetWindowPosition(int x, int y)
{
    _SetWindowPosition(x, y);
}

inline void SetWindowMonitor(int monitor)
{
    _SetWindowMonitor(monitor);
}

inline void SetWindowMinSize(int width, int height)
{
    _SetWindowMinSize(width, height);
}

inline void SetWindowSize(int width, int height)
{
    _SetWindowSize(width, height);
}

inline void SetWindowOpacity(float opacity)
{
    _SetWindowOpacity(opacity);
}

inline void *GetWindowHandle(void)
{
    return _GetWindowHandle();
}

inline int GetScreenWidth(void)
{
    return _GetScreenWidth();
}

inline int GetScreenHeight(void)
{
    return _GetScreenHeight();
}

inline int GetRenderWidth(void)
{
    return _GetRenderWidth();
}

inline int GetRenderHeight(void)
{
    return _GetRenderHeight();
}

inline int GetMonitorCount(void)
{
    return _GetMonitorCount();
}

inline int GetCurrentMonitor(void)
{
    return _GetCurrentMonitor();
}

inline void GetMonitorPosition(int monitor, void *ret)
{
    *(Vector2 *)ret = _GetMonitorPosition(monitor);
}

inline int GetMonitorWidth(int monitor)
{
    return _GetMonitorWidth(monitor);
}

inline int GetMonitorHeight(int monitor)
{
    return _GetMonitorHeight(monitor);
}

inline int GetMonitorPhysicalWidth(int monitor)
{
    return _GetMonitorPhysicalWidth(monitor);
}

inline int GetMonitorPhysicalHeight(int monitor)
{
    return _GetMonitorPhysicalHeight(monitor);
}

inline int GetMonitorRefreshRate(int monitor)
{
    return _GetMonitorRefreshRate(monitor);
}

inline void GetWindowPosition(void *ret)
{
    *(Vector2 *)ret = _GetWindowPosition();
}

inline void GetWindowScaleDPI(void *ret)
{
    *(Vector2 *)ret = _GetWindowScaleDPI();
}

inline const char *GetMonitorName(int monitor)
{
    return _GetMonitorName(monitor);
}

inline void SetClipboardText(const char *text)
{
    _SetClipboardText(text);
}

inline const char *GetClipboardText(void)
{
    return _GetClipboardText();
}

inline void EnableEventWaiting(void)
{
    _EnableEventWaiting();
}

inline void DisableEventWaiting(void)
{
    _DisableEventWaiting();
}

inline void SwapScreenBuffer(void)
{
    _SwapScreenBuffer();
}

inline void PollInputEvents(void)
{
    _PollInputEvents();
}

inline void WaitTime(double seconds)
{
    _WaitTime(seconds);
}

inline void ShowCursor(void)
{
    _ShowCursor();
}

inline void HideCursor(void)
{
    _HideCursor();
}

inline qb_bool IsCursorHidden(void)
{
    return TO_QB_BOOL(_IsCursorHidden());
}

inline void EnableCursor(void)
{
    _EnableCursor();
}

inline void DisableCursor(void)
{
    _DisableCursor();
}

inline qb_bool IsCursorOnScreen(void)
{
    return TO_QB_BOOL(_IsCursorOnScreen());
}

inline void ClearBackground(uint32_t color)
{
    _ClearBackground(color);
}

inline void BeginDrawing(void)
{
    _BeginDrawing();
}

inline void EndDrawing(void)
{
    _EndDrawing();
}

inline void BeginMode2D(void *camera)
{
    _BeginMode2D(*(Camera2D *)camera);
}

inline void EndMode2D(void)
{
    _EndMode2D();
}

inline void BeginMode3D(void *camera)
{
    _BeginMode3D(*(Camera3D *)camera);
}

inline void EndMode3D(void)
{
    _EndMode3D();
}

inline void BeginTextureMode(void *target)
{
    _BeginTextureMode(*(RenderTexture2D *)target);
}

inline void EndTextureMode(void)
{
    _EndTextureMode();
}

inline void BeginShaderMode(void *shader)
{
    _BeginShaderMode(*(Shader *)shader);
}

inline void EndShaderMode(void)
{
    _EndShaderMode();
}

inline void BeginBlendMode(int mode)
{
    _BeginBlendMode(mode);
}

inline void EndBlendMode(void)
{
    _EndBlendMode();
}

inline void BeginScissorMode(int x, int y, int width, int height)
{
    _BeginScissorMode(x, y, width, height);
}

inline void EndScissorMode(void)
{
    _EndScissorMode();
}

inline void BeginVrStereoMode(void *config)
{
    _BeginVrStereoMode(*(VrStereoConfig *)config);
}

inline void EndVrStereoMode(void)
{
    _EndVrStereoMode();
}

inline void LoadVrStereoConfig(void *device, void *ret)
{
    *(VrStereoConfig *)ret = _LoadVrStereoConfig(*(VrDeviceInfo *)device);
}

inline void UnloadVrStereoConfig(void *config)
{
    _UnloadVrStereoConfig(*(VrStereoConfig *)config);
}

inline void LoadShader(const char *vsFileName, const char *fsFileName, void *ret)
{
    *(Shader *)ret = _LoadShader(vsFileName, fsFileName);
}

inline void LoadShaderFromMemory(const char *vsCode, const char *fsCode, void *ret)
{
    *(Shader *)ret = _LoadShaderFromMemory(vsCode, fsCode);
}

inline qb_bool IsShaderReady(void *shader)
{
    return TO_QB_BOOL(_IsShaderReady(*(Shader *)shader));
}

inline int GetShaderLocation(void *shader, const char *uniformName)
{
    return _GetShaderLocation(*(Shader *)shader, uniformName);
}

inline int GetShaderLocationAttrib(void *shader, const char *attribName)
{
    return _GetShaderLocationAttrib(*(Shader *)shader, attribName);
}

inline void SetShaderValue(void *shader, int locIndex, uintptr_t value, int uniformType)
{
    _SetShaderValue(*(Shader *)shader, locIndex, (const void *)value, uniformType);
}

inline void SetShaderValueV(void *shader, int locIndex, uintptr_t value, int uniformType, int count)
{
    _SetShaderValueV(*(Shader *)shader, locIndex, (const void *)value, uniformType, count);
}

inline void SetShaderValueMatrix(void *shader, int locIndex, void *mat)
{
    _SetShaderValueMatrix(*(Shader *)shader, locIndex, *(Matrix *)mat);
}

inline void SetShaderValueTexture(void *shader, int locIndex, void *texture)
{
    _SetShaderValueTexture(*(Shader *)shader, locIndex, *(Texture2D *)texture);
}

inline void UnloadShader(void *shader)
{
    _UnloadShader(*(Shader *)shader);
}

inline void GetMouseRay(void *mousePosition, void *camera, void *ret)
{
    *(Ray *)ret = _GetMouseRay(*(Vector2 *)mousePosition, *(Camera *)camera);
}

inline void GetCameraMatrix(void *camera, void *ret)
{
    *(Matrix *)ret = _GetCameraMatrix(*(Camera *)camera);
}

inline void GetCameraMatrix2D(void *camera, void *ret)
{
    *(Matrix *)ret = _GetCameraMatrix2D(*(Camera2D *)camera);
}

inline void GetWorldToScreen(void *position, void *camera, void *ret)
{
    *(Vector2 *)ret = _GetWorldToScreen(*(Vector3 *)position, *(Camera *)camera);
}

inline void GetScreenToWorld2D(void *position, void *camera, void *ret)
{
    *(Vector2 *)ret = _GetScreenToWorld2D(*(Vector2 *)position, *(Camera2D *)camera);
}

inline void GetWorldToScreenEx(void *position, void *camera, int width, int height, void *ret)
{
    *(Vector2 *)ret = _GetWorldToScreenEx(*(Vector3 *)position, *(Camera *)camera, width, height);
}

inline void GetWorldToScreen2D(void *position, void *camera, void *ret)
{
    *(Vector2 *)ret = _GetWorldToScreen2D(*(Vector2 *)position, *(Camera2D *)camera);
}

inline void SetTargetFPS(int fps)
{
    _SetTargetFPS(fps);
}

inline int GetFPS(void)
{
    return _GetFPS();
}

inline float GetFrameTime(void)
{
    return _GetFrameTime();
}

inline double GetTime(void)
{
    return _GetTime();
}

inline int GetRandomValue(int min, int max)
{
    return _GetRandomValue(min, max);
}

inline void SetRandomSeed(unsigned int seed)
{
    _SetRandomSeed(seed);
}

inline void TakeScreenshot(const char *fileName)
{
    _TakeScreenshot(fileName);
}

inline void SetConfigFlags(unsigned int flags)
{
    _SetConfigFlags(flags);
}

inline void TraceLog(int logLevel, const char *text)
{
    _TraceLog(logLevel, text);
}

inline void TraceLog(int logLevel, const char *text, const char *s)
{
    _TraceLog(logLevel, text, s);
}

inline void TraceLog(int logLevel, const char *text, int i)
{
    _TraceLog(logLevel, text, i);
}

inline void TraceLog(int logLevel, const char *text, float f)
{
    _TraceLog(logLevel, text, f);
}

inline void SetTraceLogLevel(int logLevel)
{
    _SetTraceLogLevel(logLevel);
}

inline void *MemAlloc(unsigned int size)
{
    return _MemAlloc(size);
}

inline void *MemRealloc(void *ptr, unsigned int size)
{
    return _MemRealloc(ptr, size);
}

inline void MemFree(void *ptr)
{
    _MemFree(ptr);
}

inline void OpenURL(const char *url)
{
    _OpenURL(url);
}

inline void SetTraceLogCallback(void *callback)
{
    _SetTraceLogCallback((TraceLogCallback)callback);
}

inline void SetLoadFileDataCallback(void *callback)
{
    _SetLoadFileDataCallback((LoadFileDataCallback)callback);
}

inline void SetSaveFileDataCallback(void *callback)
{
    _SetSaveFileDataCallback((SaveFileDataCallback)callback);
}

inline void SetLoadFileTextCallback(void *callback)
{
    _SetLoadFileTextCallback((LoadFileTextCallback)callback);
}

inline void SetSaveFileTextCallback(void *callback)
{
    _SetSaveFileTextCallback((SaveFileTextCallback)callback);
}

inline unsigned char *LoadFileData(const char *fileName, unsigned int *bytesRead)
{
    return _LoadFileData(fileName, bytesRead);
}

inline void UnloadFileData(uintptr_t data)
{
    _UnloadFileData((unsigned char *)data);
}

inline qb_bool SaveFileData(const char *fileName, void *data, unsigned int bytesToWrite)
{
    return TO_QB_BOOL(_SaveFileData(fileName, data, bytesToWrite));
}

inline qb_bool ExportDataAsCode(const unsigned char *data, unsigned int size, const char *fileName)
{
    return TO_QB_BOOL(_ExportDataAsCode(data, size, fileName));
}

inline char *LoadFileText(const char *fileName)
{
    return _LoadFileText(fileName);
}

inline void UnloadFileText(char *text)
{
    _UnloadFileText(text);
}

inline qb_bool SaveFileText(const char *fileName, char *text)
{
    return TO_QB_BOOL(_SaveFileText(fileName, text));
}

inline qb_bool FileExists(const char *fileName)
{
    return TO_QB_BOOL(_FileExists(fileName));
}

inline qb_bool DirectoryExists(const char *dirPath)
{
    return TO_QB_BOOL(_DirectoryExists(dirPath));
}

inline qb_bool IsFileExtension(const char *fileName, const char *ext)
{
    return TO_QB_BOOL(_IsFileExtension(fileName, ext));
}

inline int GetFileLength(const char *fileName)
{
    return _GetFileLength(fileName);
}

inline const char *GetFileExtension(const char *fileName)
{
    return _GetFileExtension(fileName);
}

inline const char *GetFileName(const char *filePath)
{
    return _GetFileName(filePath);
}

inline const char *GetFileNameWithoutExt(const char *filePath)
{
    return _GetFileNameWithoutExt(filePath);
}

inline const char *GetDirectoryPath(const char *filePath)
{
    return _GetDirectoryPath(filePath);
}

inline const char *GetPrevDirectoryPath(const char *dirPath)
{
    return _GetPrevDirectoryPath(dirPath);
}

inline const char *GetWorkingDirectory(void)
{
    return _GetWorkingDirectory();
}

inline const char *GetApplicationDirectory(void)
{
    return _GetApplicationDirectory();
}

inline qb_bool ChangeDirectory(const char *dir)
{
    return TO_QB_BOOL(_ChangeDirectory(dir));
}

inline qb_bool IsPathFile(const char *path)
{
    return TO_QB_BOOL(_IsPathFile(path));
}

inline void LoadDirectoryFiles(const char *dirPath, void *ret)
{
    *(FilePathList *)ret = _LoadDirectoryFiles(dirPath);
}

inline void LoadDirectoryFilesEx(const char *basePath, const char *filter, int8_t scanSubdirs, void *ret)
{
    *(FilePathList *)ret = _LoadDirectoryFilesEx(basePath, filter, TO_C_BOOL(scanSubdirs));
}

inline void UnloadDirectoryFiles(void *files)
{
    _UnloadDirectoryFiles(*(FilePathList *)files);
}

inline qb_bool IsFileDropped(void)
{
    return TO_QB_BOOL(_IsFileDropped());
}

inline void LoadDroppedFiles(void *ret)
{
    *(FilePathList *)ret = _LoadDroppedFiles();
}

inline void UnloadDroppedFiles(void *files)
{
    _UnloadDroppedFiles(*(FilePathList *)files);
}

inline long GetFileModTime(const char *fileName)
{
    return _GetFileModTime(fileName);
}

inline unsigned char *CompressData(const unsigned char *data, int dataSize, int *compDataSize)
{
    return _CompressData(data, dataSize, compDataSize);
}

inline unsigned char *DecompressData(const unsigned char *compData, int compDataSize, int *dataSize)
{
    return _DecompressData(compData, compDataSize, dataSize);
}

inline char *EncodeDataBase64(const unsigned char *data, int dataSize, int *outputSize)
{
    return _EncodeDataBase64(data, dataSize, outputSize);
}

inline unsigned char *DecodeDataBase64(const unsigned char *data, int *outputSize)
{
    return _DecodeDataBase64(data, outputSize);
}

inline qb_bool IsKeyPressed(int key)
{
    return TO_QB_BOOL(_IsKeyPressed(key));
}

inline qb_bool IsKeyDown(int key)
{
    return TO_QB_BOOL(_IsKeyDown(key));
}

inline qb_bool IsKeyReleased(int key)
{
    return TO_QB_BOOL(_IsKeyReleased(key));
}

inline qb_bool IsKeyUp(int key)
{
    return TO_QB_BOOL(_IsKeyUp(key));
}

inline void SetExitKey(int key)
{
    _SetExitKey(key);
}

inline int GetKeyPressed(void)
{
    return _GetKeyPressed();
}

inline int GetCharPressed(void)
{
    return _GetCharPressed();
}

inline qb_bool IsGamepadAvailable(int gamepad)
{
    return TO_QB_BOOL(_IsGamepadAvailable(gamepad));
}

inline const char *GetGamepadName(int gamepad)
{
    return _GetGamepadName(gamepad);
}

inline qb_bool IsGamepadButtonPressed(int gamepad, int button)
{
    return TO_QB_BOOL(_IsGamepadButtonPressed(gamepad, button));
}

inline qb_bool IsGamepadButtonDown(int gamepad, int button)
{
    return TO_QB_BOOL(_IsGamepadButtonDown(gamepad, button));
}

inline qb_bool IsGamepadButtonReleased(int gamepad, int button)
{
    return TO_QB_BOOL(_IsGamepadButtonReleased(gamepad, button));
}

inline qb_bool IsGamepadButtonUp(int gamepad, int button)
{
    return TO_QB_BOOL(_IsGamepadButtonUp(gamepad, button));
}

inline int GetGamepadButtonPressed(void)
{
    return _GetGamepadButtonPressed();
}

inline int GetGamepadAxisCount(int gamepad)
{
    return _GetGamepadAxisCount(gamepad);
}

inline float GetGamepadAxisMovement(int gamepad, int axis)
{
    return _GetGamepadAxisMovement(gamepad, axis);
}

inline int SetGamepadMappings(const char *mappings)
{
    return _SetGamepadMappings(mappings);
}

inline qb_bool IsMouseButtonPressed(int button)
{
    return TO_QB_BOOL(_IsMouseButtonPressed(button));
}

inline qb_bool IsMouseButtonDown(int button)
{
    return TO_QB_BOOL(_IsMouseButtonDown(button));
}

inline qb_bool IsMouseButtonReleased(int button)
{
    return TO_QB_BOOL(_IsMouseButtonReleased(button));
}

inline qb_bool IsMouseButtonUp(int button)
{
    return TO_QB_BOOL(_IsMouseButtonUp(button));
}

inline int GetMouseX(void)
{
    return _GetMouseX();
}

inline int GetMouseY(void)
{
    return _GetMouseY();
}

inline void GetMousePosition(void *ret)
{
    *(Vector2 *)ret = _GetMousePosition();
}

inline void GetMouseDelta(void *ret)
{
    *(Vector2 *)ret = _GetMouseDelta();
}

inline void SetMousePosition(int x, int y)
{
    _SetMousePosition(x, y);
}

inline void SetMouseOffset(int offsetX, int offsetY)
{
    _SetMouseOffset(offsetX, offsetY);
}

inline void SetMouseScale(float scaleX, float scaleY)
{
    _SetMouseScale(scaleX, scaleY);
}

inline float GetMouseWheelMove(void)
{
    return _GetMouseWheelMove();
}

inline void GetMouseWheelMoveV(void *ret)
{
    *(Vector2 *)ret = _GetMouseWheelMoveV();
}

inline void SetMouseCursor(int cursor)
{
    _SetMouseCursor(cursor);
}

inline int GetTouchX(void)
{
    return _GetTouchX();
}

inline int GetTouchY(void)
{
    return _GetTouchY();
}

inline void GetTouchPosition(int index, void *ret)
{
    *(Vector2 *)ret = _GetTouchPosition(index);
}

inline int GetTouchPointId(int index)
{
    return _GetTouchPointId(index);
}

inline int GetTouchPointCount(void)
{
    return _GetTouchPointCount();
}

inline void SetGesturesEnabled(unsigned int flags)
{
    _SetGesturesEnabled(flags);
}

inline qb_bool IsGestureDetected(int gesture)
{
    return TO_QB_BOOL(_IsGestureDetected(gesture));
}

inline int GetGestureDetected(void)
{
    return _GetGestureDetected();
}

inline float GetGestureHoldDuration(void)
{
    return _GetGestureHoldDuration();
}

inline void GetGestureDragVector(void *ret)
{
    *(Vector2 *)ret = _GetGestureDragVector();
}

inline float GetGestureDragAngle(void)
{
    return _GetGestureDragAngle();
}

inline void GetGesturePinchVector(void *ret)
{
    *(Vector2 *)ret = _GetGesturePinchVector();
}

inline float GetGesturePinchAngle(void)
{
    return _GetGesturePinchAngle();
}

inline void UpdateCamera(void *camera, int mode)
{
    _UpdateCamera((Camera *)camera, mode);
}

inline void UpdateCameraPro(void *camera, void *movement, void *rotation, float zoom)
{
    _UpdateCameraPro((Camera *)camera, *(Vector3 *)movement, *(Vector3 *)rotation, zoom);
}

inline void SetShapesTexture(void *texture, void *source)
{
    _SetShapesTexture(*(Texture2D *)texture, *(RRectangle *)source);
}

inline void DrawPixel(int posX, int posY, uint32_t color)
{
    _DrawPixel(posX, posY, color);
}

inline void DrawPixelV(void *position, uint32_t color)
{
    _DrawPixelV(*(Vector2 *)position, color);
}

inline void DrawLine(int startPosX, int startPosY, int endPosX, int endPosY, uint32_t color)
{
    _DrawLine(startPosX, startPosY, endPosX, endPosY, color);
}

inline void DrawLineV(void *startPos, void *endPos, uint32_t color)
{
    _DrawLineV(*(Vector2 *)startPos, *(Vector2 *)endPos, color);
}

inline void DrawLineEx(void *startPos, void *endPos, float thick, uint32_t color)
{
    _DrawLineEx(*(Vector2 *)startPos, *(Vector2 *)endPos, thick, color);
}

inline void DrawLineBezier(void *startPos, void *endPos, float thick, uint32_t color)
{
    _DrawLineBezier(*(Vector2 *)startPos, *(Vector2 *)endPos, thick, color);
}

inline void DrawLineBezierQuad(void *startPos, void *endPos, void *controlPos, float thick, uint32_t color)
{
    _DrawLineBezierQuad(*(Vector2 *)startPos, *(Vector2 *)endPos, *(Vector2 *)controlPos, thick, color);
}

inline void DrawLineBezierCubic(void *startPos, void *endPos, void *startControlPos, void *endControlPos, float thick, uint32_t color)
{
    _DrawLineBezierCubic(*(Vector2 *)startPos, *(Vector2 *)endPos, *(Vector2 *)startControlPos, *(Vector2 *)endControlPos, thick, color);
}

inline void DrawLineStrip(void *points, int pointCount, uint32_t color)
{
    _DrawLineStrip((Vector2 *)points, pointCount, color);
}

inline void DrawCircle(int centerX, int centerY, float radius, uint32_t color)
{
    _DrawCircle(centerX, centerY, radius, color);
}

inline void DrawCircleSector(void *center, float radius, float startAngle, float endAngle, int segments, uint32_t color)
{
    _DrawCircleSector(*(Vector2 *)center, radius, startAngle, endAngle, segments, color);
}

inline void DrawCircleSectorLines(void *center, float radius, float startAngle, float endAngle, int segments, uint32_t color)
{
    _DrawCircleSectorLines(*(Vector2 *)center, radius, startAngle, endAngle, segments, color);
}

inline void DrawCircleGradient(int centerX, int centerY, float radius, uint32_t color1, uint32_t color2)
{
    _DrawCircleGradient(centerX, centerY, radius, color1, color2);
}

inline void DrawCircleV(void *center, float radius, uint32_t color)
{
    _DrawCircleV(*(Vector2 *)center, radius, color);
}

inline void DrawCircleLines(int centerX, int centerY, float radius, uint32_t color)
{
    _DrawCircleLines(centerX, centerY, radius, color);
}

inline void DrawEllipse(int centerX, int centerY, float radiusH, float radiusV, uint32_t color)
{
    _DrawEllipse(centerX, centerY, radiusH, radiusV, color);
}

inline void DrawEllipseLines(int centerX, int centerY, float radiusH, float radiusV, uint32_t color)
{
    _DrawEllipseLines(centerX, centerY, radiusH, radiusV, color);
}

inline void DrawRing(void *center, float innerRadius, float outerRadius, float startAngle, float endAngle, int segments, uint32_t color)
{
    _DrawRing(*(Vector2 *)center, innerRadius, outerRadius, startAngle, endAngle, segments, color);
}

inline void DrawRingLines(void *center, float innerRadius, float outerRadius, float startAngle, float endAngle, int segments, uint32_t color)
{
    _DrawRingLines(*(Vector2 *)center, innerRadius, outerRadius, startAngle, endAngle, segments, color);
}

inline void DrawRectangle(int posX, int posY, int width, int height, uint32_t color)
{
    _DrawRectangle(posX, posY, width, height, color);
}

inline void DrawRectangleV(void *position, void *size, uint32_t color)
{
    _DrawRectangleV(*(Vector2 *)position, *(Vector2 *)size, color);
}

inline void DrawRectangleRec(void *rec, uint32_t color)
{
    _DrawRectangleRec(*(RRectangle *)rec, color);
}

inline void DrawRectanglePro(void *rec, void *origin, float rotation, uint32_t color)
{
    _DrawRectanglePro(*(RRectangle *)rec, *(Vector2 *)origin, rotation, color);
}

inline void DrawRectangleGradientV(int posX, int posY, int width, int height, uint32_t color1, uint32_t color2)
{
    _DrawRectangleGradientV(posX, posY, width, height, color1, color2);
}

inline void DrawRectangleGradientH(int posX, int posY, int width, int height, uint32_t color1, uint32_t color2)
{
    _DrawRectangleGradientH(posX, posY, width, height, color1, color2);
}

inline void DrawRectangleGradientEx(void *rec, uint32_t col1, uint32_t col2, uint32_t col3, uint32_t col4)
{
    _DrawRectangleGradientEx(*(RRectangle *)rec, col1, col2, col3, col4);
}

inline void DrawRectangleLines(int posX, int posY, int width, int height, uint32_t color)
{
    _DrawRectangleLines(posX, posY, width, height, color);
}

inline void DrawRectangleLinesEx(void *rec, float lineThick, uint32_t color)
{
    _DrawRectangleLinesEx(*(RRectangle *)rec, lineThick, color);
}

inline void DrawRectangleRounded(void *rec, float roundness, int segments, uint32_t color)
{
    _DrawRectangleRounded(*(RRectangle *)rec, roundness, segments, color);
}

inline void DrawRectangleRoundedLines(void *rec, float roundness, int segments, float lineThick, uint32_t color)
{
    _DrawRectangleRoundedLines(*(RRectangle *)rec, roundness, segments, lineThick, color);
}

inline void DrawTriangle(void *v1, void *v2, void *v3, uint32_t color)
{
    _DrawTriangle(*(Vector2 *)v1, *(Vector2 *)v2, *(Vector2 *)v3, color);
}

inline void DrawTriangleLines(void *v1, void *v2, void *v3, uint32_t color)
{
    _DrawTriangleLines(*(Vector2 *)v1, *(Vector2 *)v2, *(Vector2 *)v3, color);
}

inline void DrawTriangleFan(void *points, int pointCount, uint32_t color)
{
    _DrawTriangleFan((Vector2 *)points, pointCount, color);
}

inline void DrawTriangleStrip(void *points, int pointCount, uint32_t color)
{
    _DrawTriangleStrip((Vector2 *)points, pointCount, color);
}

inline void DrawPoly(void *center, int sides, float radius, float rotation, uint32_t color)
{
    _DrawPoly(*(Vector2 *)center, sides, radius, rotation, color);
}

inline void DrawPolyLines(void *center, int sides, float radius, float rotation, uint32_t color)
{
    _DrawPolyLines(*(Vector2 *)center, sides, radius, rotation, color);
}

inline void DrawPolyLinesEx(void *center, int sides, float radius, float rotation, float lineThick, uint32_t color)
{
    _DrawPolyLinesEx(*(Vector2 *)center, sides, radius, rotation, lineThick, color);
}

inline qb_bool CheckCollisionRecs(void *rec1, void *rec2)
{
    return TO_QB_BOOL(_CheckCollisionRecs(*(RRectangle *)rec1, *(RRectangle *)rec2));
}

inline qb_bool CheckCollisionCircles(void *center1, float radius1, void *center2, float radius2)
{
    return TO_QB_BOOL(_CheckCollisionCircles(*(Vector2 *)center1, radius1, *(Vector2 *)center2, radius2));
}

inline qb_bool CheckCollisionCircleRec(void *center, float radius, void *rec)
{
    return TO_QB_BOOL(_CheckCollisionCircleRec(*(Vector2 *)center, radius, *(RRectangle *)rec));
}

inline qb_bool CheckCollisionPointRec(void *point, void *rec)
{
    return TO_QB_BOOL(_CheckCollisionPointRec(*(Vector2 *)point, *(RRectangle *)rec));
}

inline qb_bool CheckCollisionPointCircle(void *point, void *center, float radius)
{
    return TO_QB_BOOL(_CheckCollisionPointCircle(*(Vector2 *)point, *(Vector2 *)center, radius));
}

inline qb_bool CheckCollisionPointTriangle(void *point, void *p1, void *p2, void *p3)
{
    return TO_QB_BOOL(_CheckCollisionPointTriangle(*(Vector2 *)point, *(Vector2 *)p1, *(Vector2 *)p2, *(Vector2 *)p3));
}

inline qb_bool CheckCollisionPointPoly(void *point, void *points, int pointCount)
{
    return TO_QB_BOOL(_CheckCollisionPointPoly(*(Vector2 *)point, (Vector2 *)points, pointCount));
}

inline qb_bool CheckCollisionLines(void *startPos1, void *endPos1, void *startPos2, void *endPos2, void *collisionPoint)
{
    return TO_QB_BOOL(_CheckCollisionLines(*(Vector2 *)startPos1, *(Vector2 *)endPos1, *(Vector2 *)startPos2, *(Vector2 *)endPos2, (Vector2 *)collisionPoint));
}

inline qb_bool CheckCollisionPointLine(void *point, void *p1, void *p2, int threshold)
{
    return TO_QB_BOOL(_CheckCollisionPointLine(*(Vector2 *)point, *(Vector2 *)p1, *(Vector2 *)p2, threshold));
}

inline void GetCollisionRec(void *rec1, void *rec2, void *ret)
{
    *(RRectangle *)ret = _GetCollisionRec(*(RRectangle *)rec1, *(RRectangle *)rec2);
}

inline void LoadImage(const char *fileName, void *ret)
{
    *(Image *)ret = _LoadImage(fileName);
}

inline void LoadImageRaw(const char *fileName, int width, int height, int format, int headerSize, void *ret)
{
    *(Image *)ret = _LoadImageRaw(fileName, width, height, format, headerSize);
}

inline void LoadImageAnim(const char *fileName, int *frames, void *ret)
{
    *(Image *)ret = _LoadImageAnim(fileName, frames);
}

inline void LoadImageFromMemory(const char *fileType, const unsigned char *fileData, int dataSize, void *ret)
{
    *(Image *)ret = _LoadImageFromMemory(fileType, fileData, dataSize);
}

inline void LoadImageFromTexture(void *texture, void *ret)
{
    *(Image *)ret = _LoadImageFromTexture(*(Texture2D *)texture);
}

inline void LoadImageFromScreen(void *ret)
{
    *(Image *)ret = _LoadImageFromScreen();
}

inline qb_bool IsImageReady(void *image)
{
    return TO_QB_BOOL(_IsImageReady(*(Image *)image));
}

inline void UnloadImage(void *image)
{
    _UnloadImage(*(Image *)image);
}

inline qb_bool ExportImage(void *image, const char *fileName)
{
    return TO_QB_BOOL(_ExportImage(*(Image *)image, fileName));
}

inline qb_bool ExportImageAsCode(void *image, const char *fileName)
{
    return TO_QB_BOOL(_ExportImageAsCode(*(Image *)image, fileName));
}

inline void GenImageColor(int width, int height, uint32_t color, void *ret)
{
    *(Image *)ret = _GenImageColor(width, height, color);
}

inline void GenImageGradientV(int width, int height, uint32_t top, uint32_t bottom, void *ret)
{
    *(Image *)ret = _GenImageGradientV(width, height, top, bottom);
}

inline void GenImageGradientH(int width, int height, uint32_t left, uint32_t right, void *ret)
{
    *(Image *)ret = _GenImageGradientH(width, height, left, right);
}

inline void GenImageGradientRadial(int width, int height, float density, uint32_t inner, uint32_t outer, void *ret)
{
    *(Image *)ret = _GenImageGradientRadial(width, height, density, inner, outer);
}

inline void GenImageChecked(int width, int height, int checksX, int checksY, uint32_t col1, uint32_t col2, void *ret)
{
    *(Image *)ret = _GenImageChecked(width, height, checksX, checksY, col1, col2);
}

inline void GenImageWhiteNoise(int width, int height, float factor, void *ret)
{
    *(Image *)ret = _GenImageWhiteNoise(width, height, factor);
}

inline void GenImagePerlinNoise(int width, int height, int offsetX, int offsetY, float scale, void *ret)
{
    *(Image *)ret = _GenImagePerlinNoise(width, height, offsetX, offsetY, scale);
}

inline void GenImageCellular(int width, int height, int tileSize, void *ret)
{
    *(Image *)ret = _GenImageCellular(width, height, tileSize);
}

inline void GenImageText(int width, int height, const char *text, void *ret)
{
    *(Image *)ret = _GenImageText(width, height, text);
}

inline void ImageCopy(void *image, void *ret)
{
    *(Image *)ret = _ImageCopy(*(Image *)image);
}

inline void ImageFromImage(void *image, void *rec, void *ret)
{
    *(Image *)ret = _ImageFromImage(*(Image *)image, *(RRectangle *)rec);
}

inline void ImageText(const char *text, int fontSize, uint32_t color, void *ret)
{
    *(Image *)ret = _ImageText(text, fontSize, color);
}

inline void ImageTextEx(void *font, const char *text, float fontSize, float spacing, uint32_t tint, void *ret)
{
    *(Image *)ret = _ImageTextEx(*(Font *)font, text, fontSize, spacing, tint);
}

inline void ImageFormat(void *image, int newFormat)
{
    _ImageFormat((Image *)image, newFormat);
}

inline void ImageToPOT(void *image, uint32_t fill)
{
    _ImageToPOT((Image *)image, fill);
}

inline void ImageCrop(void *image, void *crop)
{
    _ImageCrop((Image *)image, *(RRectangle *)crop);
}

inline void ImageAlphaCrop(void *image, float threshold)
{
    _ImageAlphaCrop((Image *)image, threshold);
}

inline void ImageAlphaClear(void *image, uint32_t color, float threshold)
{
    _ImageAlphaClear((Image *)image, color, threshold);
}

inline void ImageAlphaMask(void *image, void *alphaMask)
{
    _ImageAlphaMask((Image *)image, *(Image *)alphaMask);
}

inline void ImageAlphaPremultiply(void *image)
{
    _ImageAlphaPremultiply((Image *)image);
}

inline void ImageBlurGaussian(void *image, int blurSize)
{
    _ImageBlurGaussian((Image *)image, blurSize);
}

inline void ImageResize(void *image, int newWidth, int newHeight)
{
    _ImageResize((Image *)image, newWidth, newHeight);
}

inline void ImageResizeNN(void *image, int newWidth, int newHeight)
{
    _ImageResizeNN((Image *)image, newWidth, newHeight);
}

inline void ImageResizeCanvas(void *image, int newWidth, int newHeight, int offsetX, int offsetY, uint32_t fill)
{
    _ImageResizeCanvas((Image *)image, newWidth, newHeight, offsetX, offsetY, fill);
}

inline void ImageMipmaps(void *image)
{
    _ImageMipmaps((Image *)image);
}

inline void ImageDither(void *image, int rBpp, int gBpp, int bBpp, int aBpp)
{
    _ImageDither((Image *)image, rBpp, gBpp, bBpp, aBpp);
}

inline void ImageFlipVertical(void *image)
{
    _ImageFlipVertical((Image *)image);
}

inline void ImageFlipHorizontal(void *image)
{
    _ImageFlipHorizontal((Image *)image);
}

inline void ImageRotateCW(void *image)
{
    _ImageRotateCW((Image *)image);
}

inline void ImageRotateCCW(void *image)
{
    _ImageRotateCCW((Image *)image);
}

inline void ImageColorTint(void *image, uint32_t color)
{
    _ImageColorTint((Image *)image, color);
}

inline void ImageColorInvert(void *image)
{
    _ImageColorInvert((Image *)image);
}

inline void ImageColorGrayscale(void *image)
{
    _ImageColorGrayscale((Image *)image);
}

inline void ImageColorContrast(void *image, float contrast)
{
    _ImageColorContrast((Image *)image, contrast);
}

inline void ImageColorBrightness(void *image, int brightness)
{
    _ImageColorBrightness((Image *)image, brightness);
}

inline void ImageColorReplace(void *image, uint32_t color, uint32_t replace)
{
    _ImageColorReplace((Image *)image, color, replace);
}

inline uintptr_t LoadImageColors(void *image)
{
    return (uintptr_t)_LoadImageColors(*(Image *)image);
}

inline uintptr_t LoadImagePalette(void *image, int maxPaletteSize, int *colorCount)
{
    return (uintptr_t)_LoadImagePalette(*(Image *)image, maxPaletteSize, colorCount);
}

inline void UnloadImageColors(uintptr_t colors)
{
    _UnloadImageColors((uint32_t *)colors);
}

inline void UnloadImagePalette(uintptr_t colors)
{
    _UnloadImagePalette((uint32_t *)colors);
}

inline void GetImageAlphaBorder(void *image, float threshold, void *ret)
{
    *(RRectangle *)ret = _GetImageAlphaBorder(*(Image *)image, threshold);
}

inline uint32_t GetImageColor(void *image, int x, int y)
{
    return _GetImageColor(*(Image *)image, x, y);
}

inline void ImageClearBackground(void *dst, uint32_t color)
{
    _ImageClearBackground((Image *)dst, color);
}

inline void ImageDrawPixel(void *dst, int posX, int posY, uint32_t color)
{
    _ImageDrawPixel((Image *)dst, posX, posY, color);
}

inline void ImageDrawPixelV(void *dst, void *position, uint32_t color)
{
    _ImageDrawPixelV((Image *)dst, *(Vector2 *)position, color);
}

inline void ImageDrawLine(void *dst, int startPosX, int startPosY, int endPosX, int endPosY, uint32_t color)
{
    _ImageDrawLine((Image *)dst, startPosX, startPosY, endPosX, endPosY, color);
}

inline void ImageDrawLineV(void *dst, void *start, void *end, uint32_t color)
{
    _ImageDrawLineV((Image *)dst, *(Vector2 *)start, *(Vector2 *)end, color);
}

inline void ImageDrawCircle(void *dst, int centerX, int centerY, int radius, uint32_t color)
{
    _ImageDrawCircle((Image *)dst, centerX, centerY, radius, color);
}

inline void ImageDrawCircleV(void *dst, void *center, int radius, uint32_t color)
{
    _ImageDrawCircleV((Image *)dst, *(Vector2 *)center, radius, color);
}

inline void ImageDrawCircleLines(void *dst, int centerX, int centerY, int radius, uint32_t color)
{
    _ImageDrawCircleLines((Image *)dst, centerX, centerY, radius, color);
}

inline void ImageDrawCircleLinesV(void *dst, void *center, int radius, uint32_t color)
{
    _ImageDrawCircleLinesV((Image *)dst, *(Vector2 *)center, radius, color);
}

inline void ImageDrawRectangle(void *dst, int posX, int posY, int width, int height, uint32_t color)
{
    _ImageDrawRectangle((Image *)dst, posX, posY, width, height, color);
}

inline void ImageDrawRectangleV(void *dst, void *position, void *size, uint32_t color)
{
    _ImageDrawRectangleV((Image *)dst, *(Vector2 *)position, *(Vector2 *)size, color);
}

inline void ImageDrawRectangleRec(void *dst, void *rec, uint32_t color)
{
    _ImageDrawRectangleRec((Image *)dst, *(RRectangle *)rec, color);
}

inline void ImageDrawRectangleLines(void *dst, void *rec, int thick, uint32_t color)
{
    _ImageDrawRectangleLines((Image *)dst, *(RRectangle *)rec, thick, color);
}

inline void ImageDraw(void *dst, void *src, void *srcRec, void *dstRec, uint32_t tint)
{
    _ImageDraw((Image *)dst, *(Image *)src, *(RRectangle *)srcRec, *(RRectangle *)dstRec, tint);
}

inline void ImageDrawText(void *dst, const char *text, int posX, int posY, int fontSize, uint32_t color)
{
    _ImageDrawText((Image *)dst, text, posX, posY, fontSize, color);
}

inline void ImageDrawTextEx(void *dst, void *font, const char *text, void *position, float fontSize, float spacing, uint32_t tint)
{
    _ImageDrawTextEx((Image *)dst, *(Font *)font, text, *(Vector2 *)position, fontSize, spacing, tint);
}

inline void LoadTexture(const char *fileName, void *ret)
{
    *(Texture2D *)ret = _LoadTexture(fileName);
}

inline void LoadTextureFromImage(void *image, void *ret)
{
    *(Texture2D *)ret = _LoadTextureFromImage(*(Image *)image);
}

inline void LoadTextureCubemap(void *image, int layout, void *ret)
{
    *(TextureCubemap *)ret = _LoadTextureCubemap(*(Image *)image, layout);
}

inline void LoadRenderTexture(int width, int height, void *ret)
{
    *(RenderTexture2D *)ret = _LoadRenderTexture(width, height);
}

inline qb_bool IsTextureReady(void *texture)
{
    return TO_QB_BOOL(_IsTextureReady(*(Texture2D *)texture));
}

inline void UnloadTexture(void *texture)
{
    _UnloadTexture(*(Texture2D *)texture);
}

inline qb_bool IsRenderTextureReady(void *target)
{
    return TO_QB_BOOL(_IsRenderTextureReady(*(RenderTexture2D *)target));
}

inline void UnloadRenderTexture(void *target)
{
    _UnloadRenderTexture(*(RenderTexture2D *)target);
}

inline void UpdateTexture(void *texture, const void *pixels)
{
    _UpdateTexture(*(Texture2D *)texture, pixels);
}

inline void UpdateTextureRec(void *texture, void *rec, const void *pixels)
{
    _UpdateTextureRec(*(Texture2D *)texture, *(RRectangle *)rec, pixels);
}

inline void GenTextureMipmaps(void *texture)
{
    _GenTextureMipmaps((Texture2D *)texture);
}

inline void SetTextureFilter(void *texture, int filter)
{
    _SetTextureFilter(*(Texture2D *)texture, filter);
}

inline void SetTextureWrap(void *texture, int wrap)
{
    _SetTextureWrap(*(Texture2D *)texture, wrap);
}

inline void DrawTexture(void *texture, int posX, int posY, uint32_t tint)
{
    _DrawTexture(*(Texture2D *)texture, posX, posY, tint);
}

inline void DrawTextureV(void *texture, void *position, uint32_t tint)
{
    _DrawTextureV(*(Texture2D *)texture, *(Vector2 *)position, tint);
}

inline void DrawTextureEx(void *texture, void *position, float rotation, float scale, uint32_t tint)
{
    _DrawTextureEx(*(Texture2D *)texture, *(Vector2 *)position, rotation, scale, tint);
}

inline void DrawTextureRec(void *texture, void *source, void *position, uint32_t tint)
{
    _DrawTextureRec(*(Texture2D *)texture, *(RRectangle *)source, *(Vector2 *)position, tint);
}

inline void DrawTexturePro(void *texture, void *source, void *dest, void *origin, float rotation, uint32_t tint)
{
    _DrawTexturePro(*(Texture2D *)texture, *(RRectangle *)source, *(RRectangle *)dest, *(Vector2 *)origin, rotation, tint);
}

inline void DrawTextureNPatch(void *texture, void *nPatchInfo, void *dest, void *origin, float rotation, uint32_t tint)
{
    _DrawTextureNPatch(*(Texture2D *)texture, *(NPatchInfo *)nPatchInfo, *(RRectangle *)dest, *(Vector2 *)origin, rotation, tint);
}

inline uint32_t Fade(uint32_t color, float alpha)
{
    return _Fade(color, alpha);
}

inline int ColorToInt(uint32_t color)
{
    return _ColorToInt(color);
}

inline void ColorNormalize(uint32_t color, void *ret)
{
    *(Vector4 *)ret = _ColorNormalize(color);
}

inline uint32_t ColorFromNormalized(void *normalized)
{
    return _ColorFromNormalized(*(Vector4 *)normalized);
}

inline void ColorToHSV(uint32_t color, void *ret)
{
    *(Vector3 *)ret = _ColorToHSV(color);
}

inline uint32_t ColorFromHSV(float hue, float saturation, float value)
{
    return _ColorFromHSV(hue, saturation, value);
}

inline uint32_t ColorTint(uint32_t color, uint32_t tint)
{
    return _ColorTint(color, tint);
}

inline uint32_t ColorBrightness(uint32_t color, float factor)
{
    return _ColorBrightness(color, factor);
}

inline uint32_t ColorContrast(uint32_t color, float contrast)
{
    return _ColorContrast(color, contrast);
}

inline uint32_t ColorAlpha(uint32_t color, float alpha)
{
    return _ColorAlpha(color, alpha);
}

inline uint32_t ColorAlphaBlend(uint32_t dst, uint32_t src, uint32_t tint)
{
    return _ColorAlphaBlend(dst, src, tint);
}

inline uint32_t GetColor(unsigned int hexValue)
{
    return _GetColor(hexValue);
}

inline uint32_t GetPixelColor(void *srcPtr, int format)
{
    return _GetPixelColor(srcPtr, format);
}

inline void SetPixelColor(void *dstPtr, uint32_t color, int format)
{
    _SetPixelColor(dstPtr, color, format);
}

inline int GetPixelDataSize(int width, int height, int format)
{
    return _GetPixelDataSize(width, height, format);
}

inline void GetFontDefault(void *ret)
{
    *(Font *)ret = _GetFontDefault();
}

inline void LoadFont(const char *fileName, void *ret)
{
    *(Font *)ret = _LoadFont(fileName);
}

inline void LoadFontEx(const char *fileName, int fontSize, uintptr_t fontChars, int glyphCount, void *ret)
{
    *(Font *)ret = _LoadFontEx(fileName, fontSize, (int *)fontChars, glyphCount);
}

inline void LoadFontFromImage(void *image, uint32_t key, int firstChar, void *ret)
{
    *(Font *)ret = _LoadFontFromImage(*(Image *)image, key, firstChar);
}

inline void LoadFontFromMemory(const char *fileType, const unsigned char *fileData, int dataSize, int fontSize, uintptr_t fontChars, int glyphCount, void *ret)
{
    *(Font *)ret = _LoadFontFromMemory(fileType, fileData, dataSize, fontSize, (int *)fontChars, glyphCount);
}

inline qb_bool IsFontReady(void *font)
{
    return TO_QB_BOOL(_IsFontReady(*(Font *)font));
}

inline uintptr_t LoadFontData(uintptr_t fileData, int dataSize, int fontSize, uintptr_t fontChars, int glyphCount, int type)
{
    return (uintptr_t)_LoadFontData((const unsigned char *)fileData, dataSize, fontSize, (int *)fontChars, glyphCount, type);
}

inline void GenImageFontAtlas(uintptr_t chars, uintptr_t *recs, int glyphCount, int fontSize, int padding, int packMethod, void *ret)
{
    *(Image *)ret = _GenImageFontAtlas((const GlyphInfo *)chars, (RRectangle **)recs, glyphCount, fontSize, padding, packMethod);
}

inline void UnloadFontData(uintptr_t chars, int glyphCount)
{
    _UnloadFontData((GlyphInfo *)chars, glyphCount);
}

inline void UnloadFont(void *font)
{
    _UnloadFont(*(Font *)font);
}

inline qb_bool ExportFontAsCode(void *font, const char *fileName)
{
    return TO_QB_BOOL(_ExportFontAsCode(*(Font *)font, fileName));
}

inline void DrawFPS(int posX, int posY)
{
    _DrawFPS(posX, posY);
}

inline void DrawText(const char *text, int posX, int posY, int fontSize, uint32_t color)
{
    _DrawText(text, posX, posY, fontSize, color);
}

inline void DrawTextEx(void *font, const char *text, void *position, float fontSize, float spacing, uint32_t tint)
{
    _DrawTextEx(*(Font *)font, text, *(Vector2 *)position, fontSize, spacing, tint);
}

inline void DrawTextPro(void *font, const char *text, void *position, void *origin, float rotation, float fontSize, float spacing, uint32_t tint)
{
    _DrawTextPro(*(Font *)font, text, *(Vector2 *)position, *(Vector2 *)origin, rotation, fontSize, spacing, tint);
}

inline void DrawTextCodepoint(void *font, int codepoint, void *position, float fontSize, uint32_t tint)
{
    _DrawTextCodepoint(*(Font *)font, codepoint, *(Vector2 *)position, fontSize, tint);
}

inline void DrawTextCodepoints(void *font, const int *codepoints, int count, void *position, float fontSize, float spacing, uint32_t tint)
{
    _DrawTextCodepoints(*(Font *)font, codepoints, count, *(Vector2 *)position, fontSize, spacing, tint);
}

inline int MeasureText(const char *text, int fontSize)
{
    return _MeasureText(text, fontSize);
}

inline void MeasureTextEx(void *font, const char *text, float fontSize, float spacing, void *ret)
{
    *(Vector2 *)ret = _MeasureTextEx(*(Font *)font, text, fontSize, spacing);
}

inline int GetGlyphIndex(void *font, int codepoint)
{
    return _GetGlyphIndex(*(Font *)font, codepoint);
}

inline void GetGlyphInfo(void *font, int codepoint, void *ret)
{
    *(GlyphInfo *)ret = _GetGlyphInfo(*(Font *)font, codepoint);
}

inline void GetGlyphAtlasRec(void *font, int codepoint, void *ret)
{
    *(RRectangle *)ret = _GetGlyphAtlasRec(*(Font *)font, codepoint);
}

inline char *LoadUTF8(const int *codepoints, int length)
{
    return _LoadUTF8(codepoints, length);
}

inline void UnloadUTF8(char *text)
{
    _UnloadUTF8(text);
}

inline int *LoadCodepoints(const char *text, int *count)
{
    return _LoadCodepoints(text, count);
}

inline void UnloadCodepoints(int *codepoints)
{
    _UnloadCodepoints(codepoints);
}

inline int GetCodepointCount(const char *text)
{
    return _GetCodepointCount(text);
}

inline int GetCodepoint(const char *text, int *codepointSize)
{
    return _GetCodepoint(text, codepointSize);
}

inline int GetCodepointNext(const char *text, int *codepointSize)
{
    return _GetCodepointNext(text, codepointSize);
}

inline int GetCodepointPrevious(const char *text, int *codepointSize)
{
    return _GetCodepointPrevious(text, codepointSize);
}

inline const char *CodepointToUTF8(int codepoint, int *utf8Size)
{
    return _CodepointToUTF8(codepoint, utf8Size);
}

inline int TextCopy(char *dst, const char *src)
{
    return _TextCopy(dst, src);
}

inline qb_bool TextIsEqual(const char *text1, const char *text2)
{
    return TO_QB_BOOL(_TextIsEqual(text1, text2));
}

inline unsigned int TextLength(const char *text)
{
    return _TextLength(text);
}

inline const char *TextFormat(const char *text, const char *s)
{
    return _TextFormat(text, s);
}

inline const char *TextFormat(const char *text, int i)
{
    return _TextFormat(text, i);
}

inline const char *TextFormat(const char *text, float f)
{
    return _TextFormat(text, f);
}

inline const char *TextSubtext(const char *text, int position, int length)
{
    return _TextSubtext(text, position, length);
}

inline char *TextReplace(char *text, const char *replace, const char *by)
{
    return _TextReplace(text, replace, by);
}

inline char *TextInsert(const char *text, const char *insert, int position)
{
    return _TextInsert(text, insert, position);
}

inline const char *TextJoin(const char **textList, int count, const char *delimiter)
{
    return _TextJoin(textList, count, delimiter);
}

inline const char **TextSplit(const char *text, char delimiter, int *count)
{
    return _TextSplit(text, delimiter, count);
}

inline void TextAppend(char *text, const char *append, int *position)
{
    _TextAppend(text, append, position);
}

inline int TextFindIndex(const char *text, const char *find)
{
    return _TextFindIndex(text, find);
}

inline const char *TextToUpper(const char *text)
{
    return _TextToUpper(text);
}

inline const char *TextToLower(const char *text)
{
    return _TextToLower(text);
}

inline const char *TextToPascal(const char *text)
{
    return _TextToPascal(text);
}

inline int TextToInteger(const char *text)
{
    return _TextToInteger(text);
}

inline void DrawLine3D(void *startPos, void *endPos, uint32_t color)
{
    _DrawLine3D(*(Vector3 *)startPos, *(Vector3 *)endPos, color);
}

inline void DrawPoint3D(void *position, uint32_t color)
{
    _DrawPoint3D(*(Vector3 *)position, color);
}

inline void DrawCircle3D(void *center, float radius, void *rotationAxis, float rotationAngle, uint32_t color)
{
    _DrawCircle3D(*(Vector3 *)center, radius, *(Vector3 *)rotationAxis, rotationAngle, color);
}

inline void DrawTriangle3D(void *v1, void *v2, void *v3, uint32_t color)
{
    _DrawTriangle3D(*(Vector3 *)v1, *(Vector3 *)v2, *(Vector3 *)v3, color);
}

inline void DrawTriangleStrip3D(void *points, int pointCount, uint32_t color)
{
    _DrawTriangleStrip3D((Vector3 *)points, pointCount, color);
}

inline void DrawCube(void *position, float width, float height, float length, uint32_t color)
{
    _DrawCube(*(Vector3 *)position, width, height, length, color);
}

inline void DrawCubeV(void *position, void *size, uint32_t color)
{
    _DrawCubeV(*(Vector3 *)position, *(Vector3 *)size, color);
}

inline void DrawCubeWires(void *position, float width, float height, float length, uint32_t color)
{
    _DrawCubeWires(*(Vector3 *)position, width, height, length, color);
}

inline void DrawCubeWiresV(void *position, void *size, uint32_t color)
{
    _DrawCubeWiresV(*(Vector3 *)position, *(Vector3 *)size, color);
}

inline void DrawSphere(void *centerPos, float radius, uint32_t color)
{
    _DrawSphere(*(Vector3 *)centerPos, radius, color);
}

inline void DrawSphereEx(void *centerPos, float radius, int rings, int slices, uint32_t color)
{
    _DrawSphereEx(*(Vector3 *)centerPos, radius, rings, slices, color);
}

inline void DrawSphereWires(void *centerPos, float radius, int rings, int slices, uint32_t color)
{
    _DrawSphereWires(*(Vector3 *)centerPos, radius, rings, slices, color);
}

inline void DrawCylinder(void *position, float radiusTop, float radiusBottom, float height, int slices, uint32_t color)
{
    _DrawCylinder(*(Vector3 *)position, radiusTop, radiusBottom, height, slices, color);
}

inline void DrawCylinderEx(void *startPos, void *endPos, float startRadius, float endRadius, int sides, uint32_t color)
{
    _DrawCylinderEx(*(Vector3 *)startPos, *(Vector3 *)endPos, startRadius, endRadius, sides, color);
}

inline void DrawCylinderWires(void *position, float radiusTop, float radiusBottom, float height, int slices, uint32_t color)
{
    _DrawCylinderWires(*(Vector3 *)position, radiusTop, radiusBottom, height, slices, color);
}

inline void DrawCylinderWiresEx(void *startPos, void *endPos, float startRadius, float endRadius, int sides, uint32_t color)
{
    _DrawCylinderWiresEx(*(Vector3 *)startPos, *(Vector3 *)endPos, startRadius, endRadius, sides, color);
}

inline void DrawCapsule(void *startPos, void *endPos, float radius, int slices, int rings, uint32_t color)
{
    _DrawCapsule(*(Vector3 *)startPos, *(Vector3 *)endPos, radius, slices, rings, color);
}

inline void DrawCapsuleWires(void *startPos, void *endPos, float radius, int slices, int rings, uint32_t color)
{
    _DrawCapsuleWires(*(Vector3 *)startPos, *(Vector3 *)endPos, radius, slices, rings, color);
}

inline void DrawPlane(void *centerPos, void *size, uint32_t color)
{
    _DrawPlane(*(Vector3 *)centerPos, *(Vector2 *)size, color);
}

inline void DrawRay(void *ray, uint32_t color)
{
    _DrawRay(*(Ray *)ray, color);
}

inline void DrawGrid(int slices, float spacing)
{
    _DrawGrid(slices, spacing);
}

inline void LoadModel(const char *fileName, void *ret)
{
    *(Model *)ret = _LoadModel(fileName);
}

inline void LoadModelFromMesh(void *mesh, void *ret)
{
    *(Model *)ret = _LoadModelFromMesh(*(Mesh *)mesh);
}

inline qb_bool IsModelReady(void *model)
{
    return TO_QB_BOOL(_IsModelReady(*(Model *)model));
}

inline void UnloadModel(void *model)
{
    _UnloadModel(*(Model *)model);
}

inline void GetModelBoundingBox(void *model, void *ret)
{
    *(BoundingBox *)ret = _GetModelBoundingBox(*(Model *)model);
}

inline void DrawModel(void *model, void *position, float scale, uint32_t tint)
{
    _DrawModel(*(Model *)model, *(Vector3 *)position, scale, tint);
}

inline void DrawModelEx(void *model, void *position, void *rotationAxis, float rotationAngle, void *scale, uint32_t tint)
{
    _DrawModelEx(*(Model *)model, *(Vector3 *)position, *(Vector3 *)rotationAxis, rotationAngle, *(Vector3 *)scale, tint);
}

inline void DrawModelWires(void *model, void *position, float scale, uint32_t tint)
{
    _DrawModelWires(*(Model *)model, *(Vector3 *)position, scale, tint);
}

inline void DrawModelWiresEx(void *model, void *position, void *rotationAxis, float rotationAngle, void *scale, uint32_t tint)
{
    _DrawModelWiresEx(*(Model *)model, *(Vector3 *)position, *(Vector3 *)rotationAxis, rotationAngle, *(Vector3 *)scale, tint);
}

inline void DrawBoundingBox(void *box, uint32_t color)
{
    _DrawBoundingBox(*(BoundingBox *)box, color);
}

inline void DrawBillboard(void *camera, void *texture, void *position, float size, uint32_t tint)
{
    _DrawBillboard(*(Camera *)camera, *(Texture2D *)texture, *(Vector3 *)position, size, tint);
}

inline void DrawBillboardRec(void *camera, void *texture, void *source, void *position, void *size, uint32_t tint)
{
    _DrawBillboardRec(*(Camera *)camera, *(Texture2D *)texture, *(RRectangle *)source, *(Vector3 *)position, *(Vector2 *)size, tint);
}

inline void DrawBillboardPro(void *camera, void *texture, void *source, void *position, void *up, void *size, void *origin, float rotation, uint32_t tint)
{
    _DrawBillboardPro(*(Camera *)camera, *(Texture2D *)texture, *(RRectangle *)source, *(Vector3 *)position, *(Vector3 *)up, *(Vector2 *)size, *(Vector2 *)origin, rotation, tint);
}

inline void UploadMesh(void *mesh, int8_t dynamic)
{
    _UploadMesh((Mesh *)mesh, TO_C_BOOL(dynamic));
}

inline void UpdateMeshBuffer(void *mesh, int index, const void *data, int dataSize, int offset)
{
    _UpdateMeshBuffer(*(Mesh *)mesh, index, data, dataSize, offset);
}

inline void UnloadMesh(void *mesh)
{
    _UnloadMesh(*(Mesh *)mesh);
}

inline void DrawMesh(void *mesh, void *material, void *transform)
{
    _DrawMesh(*(Mesh *)mesh, *(Material *)material, *(Matrix *)transform);
}

inline void DrawMeshInstanced(void *mesh, void *material, void *transforms, int instances)
{
    _DrawMeshInstanced(*(Mesh *)mesh, *(Material *)material, (const Matrix *)transforms, instances);
}

inline qb_bool ExportMesh(void *mesh, const char *fileName)
{
    return TO_QB_BOOL(_ExportMesh(*(Mesh *)mesh, fileName));
}

inline void GetMeshBoundingBox(void *mesh, void *ret)
{
    *(BoundingBox *)ret = _GetMeshBoundingBox(*(Mesh *)mesh);
}

inline void GenMeshTangents(void *mesh)
{
    _GenMeshTangents((Mesh *)mesh);
}

inline void GenMeshPoly(int sides, float radius, void *ret)
{
    *(Mesh *)ret = _GenMeshPoly(sides, radius);
}

inline void GenMeshPlane(float width, float length, int resX, int resZ, void *ret)
{
    *(Mesh *)ret = _GenMeshPlane(width, length, resX, resZ);
}

inline void GenMeshCube(float width, float height, float length, void *ret)
{
    *(Mesh *)ret = _GenMeshCube(width, height, length);
}

inline void GenMeshSphere(float radius, int rings, int slices, void *ret)
{
    *(Mesh *)ret = _GenMeshSphere(radius, rings, slices);
}

inline void GenMeshHemiSphere(float radius, int rings, int slices, void *ret)
{
    *(Mesh *)ret = _GenMeshHemiSphere(radius, rings, slices);
}

inline void GenMeshCylinder(float radius, float height, int slices, void *ret)
{
    *(Mesh *)ret = _GenMeshCylinder(radius, height, slices);
}

inline void GenMeshCone(float radius, float height, int slices, void *ret)
{
    *(Mesh *)ret = _GenMeshCone(radius, height, slices);
}

inline void GenMeshTorus(float radius, float size, int radSeg, int sides, void *ret)
{
    *(Mesh *)ret = _GenMeshTorus(radius, size, radSeg, sides);
}

inline void GenMeshKnot(float radius, float size, int radSeg, int sides, void *ret)
{
    *(Mesh *)ret = _GenMeshKnot(radius, size, radSeg, sides);
}

inline void GenMeshHeightmap(void *heightmap, void *size, void *ret)
{
    *(Mesh *)ret = _GenMeshHeightmap(*(Image *)heightmap, *(Vector3 *)size);
}

inline void GenMeshCubicmap(void *cubicmap, void *cubeSize, void *ret)
{
    *(Mesh *)ret = _GenMeshCubicmap(*(Image *)cubicmap, *(Vector3 *)cubeSize);
}

inline void *LoadMaterials(const char *fileName, int *materialCount)
{
    return (void *)_LoadMaterials(fileName, materialCount);
}

inline void LoadMaterialDefault(void *ret)
{
    *(Material *)ret = _LoadMaterialDefault();
}

inline qb_bool IsMaterialReady(void *material)
{
    return TO_QB_BOOL(_IsMaterialReady(*(Material *)material));
}

inline void UnloadMaterial(void *material)
{
    _UnloadMaterial(*(Material *)material);
}

inline void SetMaterialTexture(void *material, int mapType, void *texture)
{
    _SetMaterialTexture((Material *)material, mapType, *(Texture2D *)texture);
}

inline void SetModelMeshMaterial(void *model, int meshId, int materialId)
{
    _SetModelMeshMaterial((Model *)model, meshId, materialId);
}

inline void *LoadModelAnimations(const char *fileName, unsigned int *animCount)
{
    return (void *)_LoadModelAnimations(fileName, animCount);
}

inline void UpdateModelAnimation(void *model, void *anim, int frame)
{
    _UpdateModelAnimation(*(Model *)model, *(ModelAnimation *)anim, frame);
}

inline void UnloadModelAnimation(void *anim)
{
    _UnloadModelAnimation(*(ModelAnimation *)anim);
}

inline void UnloadModelAnimations(void *animations, unsigned int count)
{
    _UnloadModelAnimations((ModelAnimation *)animations, count);
}

inline qb_bool IsModelAnimationValid(void *model, void *anim)
{
    return TO_QB_BOOL(_IsModelAnimationValid(*(Model *)model, *(ModelAnimation *)anim));
}

inline qb_bool CheckCollisionSpheres(void *center1, float radius1, void *center2, float radius2)
{
    return TO_QB_BOOL(_CheckCollisionSpheres(*(Vector3 *)center1, radius1, *(Vector3 *)center2, radius2));
}

inline qb_bool CheckCollisionBoxes(void *box1, void *box2)
{
    return TO_QB_BOOL(_CheckCollisionBoxes(*(BoundingBox *)box1, *(BoundingBox *)box2));
}

inline qb_bool CheckCollisionBoxSphere(void *box, void *center, float radius)
{
    return TO_QB_BOOL(_CheckCollisionBoxSphere(*(BoundingBox *)box, *(Vector3 *)center, radius));
}

inline void GetRayCollisionSphere(void *ray, void *center, float radius, void *ret)
{
    *(RayCollision *)ret = _GetRayCollisionSphere(*(Ray *)ray, *(Vector3 *)center, radius);
}

inline void GetRayCollisionBox(void *ray, void *box, void *ret)
{
    *(RayCollision *)ret = _GetRayCollisionBox(*(Ray *)ray, *(BoundingBox *)box);
}

inline void GetRayCollisionMesh(void *ray, void *mesh, void *transform, void *ret)
{
    *(RayCollision *)ret = _GetRayCollisionMesh(*(Ray *)ray, *(Mesh *)mesh, *(Matrix *)transform);
}

inline void GetRayCollisionTriangle(void *ray, void *p1, void *p2, void *p3, void *ret)
{
    *(RayCollision *)ret = _GetRayCollisionTriangle(*(Ray *)ray, *(Vector3 *)p1, *(Vector3 *)p2, *(Vector3 *)p3);
}

inline void GetRayCollisionQuad(void *ray, void *p1, void *p2, void *p3, void *p4, void *ret)
{
    *(RayCollision *)ret = _GetRayCollisionQuad(*(Ray *)ray, *(Vector3 *)p1, *(Vector3 *)p2, *(Vector3 *)p3, *(Vector3 *)p4);
}

inline void InitAudioDevice(void)
{
    _InitAudioDevice();
}

inline void CloseAudioDevice(void)
{
    _CloseAudioDevice();
}

inline qb_bool IsAudioDeviceReady(void)
{
    return TO_QB_BOOL(_IsAudioDeviceReady());
}

inline void SetMasterVolume(float volume)
{
    _SetMasterVolume(volume);
}

inline void LoadWave(const char *fileName, void *ret)
{
    *(Wave *)ret = _LoadWave(fileName);
}

inline void LoadWaveFromMemory(const char *fileType, const unsigned char *fileData, int dataSize, void *ret)
{
    *(Wave *)ret = _LoadWaveFromMemory(fileType, fileData, dataSize);
}

inline qb_bool IsWaveReady(void *wave)
{
    return TO_QB_BOOL(_IsWaveReady(*(Wave *)wave));
}

inline void LoadSound(const char *fileName, void *ret)
{
    *(Sound *)ret = _LoadSound(fileName);
}

inline void LoadSoundFromWave(void *wave, void *ret)
{
    *(Sound *)ret = _LoadSoundFromWave(*(Wave *)wave);
}

inline qb_bool IsSoundReady(void *sound)
{
    return TO_QB_BOOL(_IsSoundReady(*(Sound *)sound));
}

inline void UpdateSound(void *sound, const void *data, int sampleCount)
{
    _UpdateSound(*(Sound *)sound, data, sampleCount);
}

inline void UnloadWave(void *wave)
{
    _UnloadWave(*(Wave *)wave);
}

inline void UnloadSound(void *sound)
{
    _UnloadSound(*(Sound *)sound);
}

inline qb_bool ExportWave(void *wave, const char *fileName)
{
    return TO_QB_BOOL(_ExportWave(*(Wave *)wave, fileName));
}

inline qb_bool ExportWaveAsCode(void *wave, const char *fileName)
{
    return TO_QB_BOOL(_ExportWaveAsCode(*(Wave *)wave, fileName));
}

inline void PlaySound(void *sound)
{
    _PlaySound(*(Sound *)sound);
}

inline void StopSound(void *sound)
{
    _StopSound(*(Sound *)sound);
}

inline void PauseSound(void *sound)
{
    _PauseSound(*(Sound *)sound);
}

inline void ResumeSound(void *sound)
{
    _ResumeSound(*(Sound *)sound);
}

inline qb_bool IsSoundPlaying(void *sound)
{
    return TO_QB_BOOL(_IsSoundPlaying(*(Sound *)sound));
}

inline void SetSoundVolume(void *sound, float volume)
{
    _SetSoundVolume(*(Sound *)sound, volume);
}

inline void SetSoundPitch(void *sound, float pitch)
{
    _SetSoundPitch(*(Sound *)sound, pitch);
}

inline void SetSoundPan(void *sound, float pan)
{
    _SetSoundPan(*(Sound *)sound, pan);
}

inline void WaveCopy(void *wave, void *ret)
{
    *(Wave *)ret = _WaveCopy(*(Wave *)wave);
}

inline void WaveCrop(void *wave, int initSample, int finalSample)
{
    _WaveCrop((Wave *)wave, initSample, finalSample);
}

inline void WaveFormat(void *wave, int sampleRate, int sampleSize, int channels)
{
    _WaveFormat((Wave *)wave, sampleRate, sampleSize, channels);
}

inline float *LoadWaveSamples(void *wave)
{
    return _LoadWaveSamples(*(Wave *)wave);
}

inline void UnloadWaveSamples(float *samples)
{
    _UnloadWaveSamples(samples);
}

inline void LoadMusicStream(const char *fileName, void *ret)
{
    *(Music *)ret = _LoadMusicStream(fileName);
}

inline void LoadMusicStreamFromMemory(const char *fileType, const unsigned char *data, int dataSize, void *ret)
{
    *(Music *)ret = _LoadMusicStreamFromMemory(fileType, data, dataSize);
}

inline qb_bool IsMusicReady(void *music)
{
    return TO_QB_BOOL(_IsMusicReady(*(Music *)music));
}

inline void UnloadMusicStream(void *music)
{
    _UnloadMusicStream(*(Music *)music);
}

inline void PlayMusicStream(void *music)
{
    _PlayMusicStream(*(Music *)music);
}

inline qb_bool IsMusicStreamPlaying(void *music)
{
    return TO_QB_BOOL(_IsMusicStreamPlaying(*(Music *)music));
}

inline void UpdateMusicStream(void *music)
{
    _UpdateMusicStream(*(Music *)music);
}

inline void StopMusicStream(void *music)
{
    _StopMusicStream(*(Music *)music);
}

inline void PauseMusicStream(void *music)
{
    _PauseMusicStream(*(Music *)music);
}

inline void ResumeMusicStream(void *music)
{
    _ResumeMusicStream(*(Music *)music);
}

inline void SeekMusicStream(void *music, float position)
{
    _SeekMusicStream(*(Music *)music, position);
}

inline void SetMusicVolume(void *music, float volume)
{
    _SetMusicVolume(*(Music *)music, volume);
}

inline void SetMusicPitch(void *music, float pitch)
{
    _SetMusicPitch(*(Music *)music, pitch);
}

inline void SetMusicPan(void *music, float pan)
{
    _SetMusicPan(*(Music *)music, pan);
}

inline float GetMusicTimeLength(void *music)
{
    return _GetMusicTimeLength(*(Music *)music);
}

inline float GetMusicTimePlayed(void *music)
{
    return _GetMusicTimePlayed(*(Music *)music);
}

inline void LoadAudioStream(unsigned int sampleRate, unsigned int sampleSize, unsigned int channels, void *ret)
{
    *(AudioStream *)ret = _LoadAudioStream(sampleRate, sampleSize, channels);
}

inline qb_bool IsAudioStreamReady(void *stream)
{
    return TO_QB_BOOL(_IsAudioStreamReady(*(AudioStream *)stream));
}

inline void UnloadAudioStream(void *stream)
{
    _UnloadAudioStream(*(AudioStream *)stream);
}

inline void UpdateAudioStream(void *stream, const void *data, int frameCount)
{
    _UpdateAudioStream(*(AudioStream *)stream, data, frameCount);
}

inline qb_bool IsAudioStreamProcessed(void *stream)
{
    return TO_QB_BOOL(_IsAudioStreamProcessed(*(AudioStream *)stream));
}

inline void PlayAudioStream(void *stream)
{
    _PlayAudioStream(*(AudioStream *)stream);
}

inline void PauseAudioStream(void *stream)
{
    _PauseAudioStream(*(AudioStream *)stream);
}

inline void ResumeAudioStream(void *stream)
{
    _ResumeAudioStream(*(AudioStream *)stream);
}

inline qb_bool IsAudioStreamPlaying(void *stream)
{
    return TO_QB_BOOL(_IsAudioStreamPlaying(*(AudioStream *)stream));
}

inline void StopAudioStream(void *stream)
{
    _StopAudioStream(*(AudioStream *)stream);
}

inline void SetAudioStreamVolume(void *stream, float volume)
{
    _SetAudioStreamVolume(*(AudioStream *)stream, volume);
}

inline void SetAudioStreamPitch(void *stream, float pitch)
{
    _SetAudioStreamPitch(*(AudioStream *)stream, pitch);
}

inline void SetAudioStreamPan(void *stream, float pan)
{
    _SetAudioStreamPan(*(AudioStream *)stream, pan);
}

inline void SetAudioStreamBufferSizeDefault(int size)
{
    _SetAudioStreamBufferSizeDefault(size);
}

inline void SetAudioStreamCallback(void *stream, void *callback)
{
    _SetAudioStreamCallback(*(AudioStream *)stream, (AudioCallback)callback);
}

inline void AttachAudioStreamProcessor(void *stream, void *processor)
{
    _AttachAudioStreamProcessor(*(AudioStream *)stream, (AudioCallback)processor);
}

inline void DetachAudioStreamProcessor(void *stream, void *processor)
{
    _DetachAudioStreamProcessor(*(AudioStream *)stream, (AudioCallback)processor);
}

inline void AttachAudioMixedProcessor(void *processor)
{
    _AttachAudioMixedProcessor((AudioCallback)processor);
}

inline void DetachAudioMixedProcessor(void *processor)
{
    _DetachAudioMixedProcessor((AudioCallback)processor);
}
//----------------------------------------------------------------------------------------------------------------------