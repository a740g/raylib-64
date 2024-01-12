
' QB64-PE Json library, version QB64PE_JSON_VERSION
'
' This library is designed to allow easy usage of JSON structures with QB64-PE
' code. It can be used to both parse existing JSON and create new JSON structures.

Const JSON_ERR_Success = 0
Const JSON_ERR_BadQuery = -1
Const JSON_ERR_OutOfRange = -2
Const JSON_ERR_KeyNotFound = -3
Const JSON_ERR_NotInitialized = -4
Const JSON_ERR_Invalid = -5
Const JSON_ERR_TokenWrongType = -6
Const JSON_ERR_TokenInvalid = -7

Const JSONTOK_TYPE_FREE = 0
Const JSONTOK_TYPE_OBJECT = 1
Const JSONTOK_TYPE_ARRAY = 2
Const JSONTOK_TYPE_VALUE = 3
Const JSONTOK_TYPE_KEY = 4

Const JSONTOK_PRIM_STRING = 1
Const JSONTOK_PRIM_NUMBER = 2
Const JSONTOK_PRIM_BOOL = 3
Const JSONTOK_PRIM_NULL = 4

' If a Json procedure has an error, the error code will be stored in
' JsonHadError and a text version of the error will be in JsonError. The error
' code will be any of the defined JSON_ERR_* constants.
'
' On success JsonHadError will be set to zero, which is JSON_ERR_Success
Dim Shared JsonError As String, JsonHadError As Long

' !!! Do not touch anything in the Json object directly !!!
' Manipulate it using the provided Subs and Functions
Type Json
    RootToken As Long
    TotalBlocks As Long

    NextFree As Long
    TokenBlocks As _Mem
    IsInitialized As Long
End Type

' Required to be called on an Json object prior to its use by any function.
' This is checked and will produce a JSON_ERR_NotInitialized if you forget to
' do this.
Declare Sub      JsonInit(json As Json)

' You should call JsonClear on any Json object when you are done using it.
' Failure to do this will result in memory leaks.
Declare Sub      JsonClear(json As Json)

' Parses a JSON string into a json object. The json object should already be initialized.
'
' Return value indicates whether the parse was a success (JSON_ERR_Success).
' JsonHadError can also be checked. On success the RootToken will be set to the
' result of the parse.
Declare Function JsonParse&(j As Json, json As String)

' These functions create new Json tokens which can be used to create a new Json
' structure or modify an existing one. They return a Long which is an index
' referring to the token, the index can then be passed to the other functions
' to make use of this token.
Declare Function JsonTokenCreateBool&(j As Json, b As _Byte)
Declare Function JsonTokenCreateInteger&(j As Json, i As _Integer64)
Declare Function JsonTokenCreateDouble&(j As Json, s As Double)
Declare Function JsonTokenCreateNumber&(j As Json, intPart As _Integer64, fracPart As Double, expPart As _Integer64)
Declare Function JsonTokenCreateNull&(j As Json)

Declare Function JsonTokenCreateArray&(j As Json)
Declare Function JsonTokenCreateObject&(j As Json)

' String contents HAVE to be valid UTF-8
Declare Function JsonTokenCreateString&(j As Json, s As String)

' The key name HAS to be valid UTF-8. inner is the token holding the value
' associated with this key.
Declare Function JsonTokenCreateKey&(j As Json, k As String, inner As Long)

' Add tokens to a given array
Declare Sub      JsonTokenArrayAdd(j As Json, arrayIdx As Long, childidx As Long)
Declare Sub      JsonTokenArrayAddAll(j As Json, arrayIdx As Long, childIdxs() As Long)

' Add tokens to a given object
Declare Sub      JsonTokenObjectAdd(j As Json, objectIdx As Long, childIdx As Long)
Declare Sub      JsonTokenObjectAddAll(j As Json, objectIdx As Long, childIdxs() As Long)

' Set the token representing the root of the json structure. This is not
' required, but allows you to use convience functions like JsonRender() and
' JsonQuery() rather than JsonRenderIndex() and JsonQueryFrom()
Declare Sub      JsonSetRootToken(j As json, idx As Long)
Declare Function JsonGetRootToken&(j As Json)

' Takes a Json object and "renders" the JSON string it represents.
'
' JsonRender$ creates the JSON starting at the root token.
' JsonRenderToken$ creates the JSON starting at the provided token.
Declare Function JsonRender$(j As json)
Declare Function JsonRenderToken$(j As json, idx As Long)

Type JsonFormat
    Indented As _Byte
End Type

' Renders the Json with the given formatting options
Declare Function JsonRenderFormatted$(j As Json, format As JsonFormat)
Declare Function JsonRenderTokenFormatted$(j As Json, idx As Long, format As JsonFormat)

' Returns the token's value in string form:
'
'    Key:    Key name
'    Value:  String version of the value itself. Bools are "true" or "false". Strings are UTF-8. Null is Error
'    Array:  Error
'    Object: Error
'
' To convert a token into a JSON string, use JsonRender$()
Declare Function JsonTokenGetValueStr$(j As json, idx As Long)

' These functions return the coresponding primitive's value in the normal QB64
' type (rather than as a string)
Declare Function JsonTokenGetValueBool&(j As Json, idx, As Long)
Declare Function JsonTokenGetValueInteger&&(j As Json, idx As Long)
Declare Function JsonTokenGetValueDouble#(j As Json, idx As Long)


Declare Function JsonTokenTotalChildren&(j As json, idx As Long)

' Returns the token for a paticular child of this Json token.
' Children are numbered from _zero_
Declare Function JsonTokenGetChild&(j As json, idx As Long, childIdx As Long)

' Returns a JSONTOK_TYPE_* value
Declare Function JsonTokenGetType&(j As Json, idx As Long)

' Only works if the token is a JSONTOK_TYPE_VALUE. Returns a JSONTOK_PRIM_* value
Declare Function JsonTokenGetPrimType&(j As Json, idx As Long)

' Takes a JSON query string and finds the JSON token that it refers too.
'
' Queries take the form of key identifiers and array indexes, separated by
' periods. Key identifiers can be in single or double quotes. Array indexes are
' parenthesis. The result of a query is the token which is the value associated
' with the target key. This can be a primitive value, but can also be an object
' if you target keys earlier in the chain. Ex:
'
'    Example Json:  {
'                       "key1": {
'                           "key2": {
'                               "key3": [
'                                   30,
'                                   40,
'                                   50,
'                                   { "key4": 50 },
'                                   [ 100, 200, 300 ]
'                               ],
'                               "key5": 50
'                           },
'                           "key.6": "foobar",
'                           "key'7": 60
'                       }
'                   }
'
'    Query: key1.key2.key3.key5
'    Result: The token for the '50' value associated with key5
'
'    Query: 'key1'.'key2'.'key3'.'key5'
'    Result: Same as previous result, quoting doesn't change the query.
'
'    Query: key1.'key.6'
'    Result: The token for "foobar". Quotes here are necessary to ensure the
'            '.' is understood to be part of a key name. Also, quoted and
'            unquoted keys can be mixed in the same query.
'
'    Query: key1.'key\'7'
'    Result: The token for 60. In this case, the single quote in the key name
'            should be escaped with backslash.
'
'    Query: key1
'    Result: The token for the object containing key2, key.6, and key'7
'
'    Query: key1.key2.key3
'    Result: The token for the array.
'
'    Query: key1.key2.key3(0)
'    Result: The token for 30, the first element in the array.
'
'    Query: key1.key2.key3(5)
'    Result: Error, the array starts at index 0 so the last valid index is 4.
'            Attempting to access an index outside the bounds of the array
'            generates an error.
'
'    Query: key1.key2.key3(3).key4
'    Result: The token for 50. More keys can be specified after an array index.
'
'    Query: key1.key2.key3(4)(1)
'    Result: The token for 200. Multiple array bounds can be used to query nested arrays.
'
' The regular JsonQuery& and JsonQueryFrom& return the token index of the query
' result. The `*Value$` versions are a convinence that return the string
' representation of the queried token. JsonTokenGetValueStr() is used to get the
' string value, so the Value$ versions will only return results for primitives
' and keys.
Declare Function JsonQuery&(j As Json, query As String)
Declare Function JsonQueryValue$(j As Json, query As String)

' These work the same as their `JsonQuery&()` counterparts but do not start at
' the root token, instead starting at token 'startToken'
'
' You can either recieve the value directly with `Value$`, or recieve the token
' index via `Token&`
Declare Function JsonQueryFrom&(j As Json, startToken As Long, query As String)
Declare Function JsonQueryFromValue$(j As Json, startToken As Long, query As String)

' Controls how many Json tokens are allocated at a single time. The total
' number of tokens allocated is _Shl(1, JSON_BLOCK_SHIFT). A higher value means
' better performance for large JSON structures, but higher memory usage for
' smaller ones.
'
' 8 gives 256 tokens allocated at a time.
Const JSON_BLOCK_SHIFT = 8

' Tells the Json object that the token at the given index is no longer used and
' its memory can be reused or free'd.
'
' NOTE: This is _NOT_ necessary for typical usage of Json objects, as JsonClear
'       will release the memory of any created Json tokens for you. It is
'       really only useful if you are modifying the structure of an existing
'       Json object and want to manually cleanup the tokens that are no longer
'       needed.
'
' NOTE: This will also free any children tokens associated with this token.
'       Typically this is what you want as normal Json behavior will not reuse
'       tokens in the Json tree.
Declare Sub      JsonTokenFree(j As Json, idx As Long)

' Same as JsonTokenFree(), but children tokens are _NOT_ free'd. This can very
' easily leak tokens. AGain, like JsonTokenFree, such a leak would only exist
' until JsonClear is called.
Declare Sub      JsonTokenFreeShallow(j As Json, idx As Long)

' Internal Constants
Const ___JSON_LEX_None = 0
Const ___JSON_LEX_Null = 1
Const ___JSON_LEX_String = 2
Const ___JSON_LEX_Number = 3
Const ___JSON_LEX_Bool = 4
Const ___JSON_LEX_LeftBrace = 5
Const ___JSON_LEX_RightBrace = 6
Const ___JSON_LEX_LeftBracket = 7
Const ___JSON_LEX_RightBracket = 8
Const ___JSON_LEX_Comma = 9
Const ___JSON_LEX_Colon = 10
Const ___JSON_LEX_End = 11

Const ___JSON_QLEX_Key = 1
Const ___JSON_QLEX_Index = 2
Const ___JSON_QLEX_Dot = 3
Const ___JSON_QLEX_End = 4
