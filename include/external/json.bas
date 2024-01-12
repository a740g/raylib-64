
' Internal types

Type jsontok
    typ As _Byte
    primType As _Byte

    ' For keys, this is the name of the key. For strings, this is the value of the string.
    ' This value is UTF-8
    value As _Mem

    ' These three parts represent a JSON number
    ' intPart also holds true/false value for bools
    intPart As _Integer64
    fracPart As Double
    expPart As _Integer64

    ' Index of parent token.
    ' If token is FREE, then this is the index of the next free token
    '
    ' Note: ParentIdx is not filled-in for manually created tokens, so it
    ' should not be relied upon.
    ParentIdx As Long

    ' Array of Long's indicating indxes of child tokens
    ChildrenIdxs As _Mem
End Type

Type JsonTokenBlock
    m As _Mem
End Type

Sub ___JsonResetError()
    JsonHadError = JSON_ERR_SUCCESS
    JsonError = ""
End Sub

Function ___JsonIsInitialized&(j As Json)
    If j.IsInitialized Then ___JsonIsInitialized& = -1: Exit Function
    JsonHadError = JSON_ERR_NotInitialized
    JsonError = "Json object was not initialized. Make sure to call JsonInit before using a Json object"
    ___JsonIsInitialized& = 0
End Function

Function ___JsonIsRightType&(j As Json, idx As Long, typ As Long)
    If JsonTokenGetType&(j, idx) = typ Then ___JsonIsRightType& = -1: Exit Function
    JsonError = "Json Token was passed to function requiring type '" + ___JsonTokenTypeString$(typ) + "' but is actually type: '" + ___JsonTokenTypeString$(JsonTokenGetType&(j, idx))
    JsonHadError = JSON_ERR_TokenWrongType
    ___JsonIsRightType& = 0
End Function

Function ___JsonIsRightPrimType&(j As Json, idx As Long, primType As Long)
    If JsonTokenGetType&(j, idx) = JSONTOK_TYPE_VALUE And JsonTokenGetPrimType&(j, idx) = primType Then ___JsonIsRightPrimType& = -1: Exit Function
    JsonError = "Json Token was passed to function requiring type '" + ___JsonTokenPrimTypeString$(primType) + "' but is actually type: '" + ___JsonTokenPrimTypeString$(JsonTokenGetPrimType&(j, idx))
    JsonHadError = JSON_ERR_TokenWrongType
    ___JsonIsRightPrimType& = 0
End Function

Function ___JsonIsValidToken&(j As Json, idx As Long)
    Dim t As jsontok

    If idx <= 0 Then GoTo retErr
    If idx >= (_Shl(1, JSON_BLOCK_SHIFT) * j.TotalBlocks) Then GoTo retErr

    ___JsonGetToken j, idx, t
    If t.typ = JSONTOK_TYPE_FREE Then GoTo retErr

    ___JsonIsValidToken& = -1
    Exit Function

retErr:
    JsonHadError = JSON_ERR_TokenInvalid
    JsonError = "Json Token index" + Str$(idx) + " is not a valid token"
    ___JsonIsValidToken& = 0
End Function

Sub JsonInit(json As Json)
    ___JsonResetError

    json.RootToken = -1
    json.TotalBlocks = 0
    json.NextFree = -1

    ' Dummy _Mem, makes things a bit easier since there is no NULL
    json.TokenBlocks = _MemNew(1)

    json.IsInitialized = -1
End Sub

Sub JsonClear(j As Json)
    Dim b As JsonTokenBlock, i As Long
    ___JsonResetError
    If Not ___JsonIsInitialized&(j) Then Exit Sub

    For i = 0 To j.TotalBlocks - 1
        _MemGet j.TokenBlocks, j.TokenBlocks.OFFSET + i * Len(b), b

        ___JsonTokenBlockClear b
    Next

    _MemFree j.TokenBlocks
    j.IsInitialized = 0
End Sub

' Initializes a new JsonTokenBlock, including the space for tokens and free list 
'
' blockIdx is this block's index in the block list
Sub ___JsonTokenBlockInit(b As JsonTokenBlock, blockIdxCpy As Long, nextFree As Long)
    Dim i As Long, tokCount As Long, t As jsontok, blockIdx As Long

    tokCount = _Shl(1, JSON_BLOCK_SHIFT)
    blockIdx = _Shl(blockIdxCpy, JSON_BLOCK_SHIFT)

    ' Don't need to zero it, as we're going to _MemPut the zero'd jsontok into
    ' it anyway
    b.m = _MemNew(tokCount * Len(t))

    For i = tokCount - 1 To 0 Step -1
        ' Special case, the "zero token" is not used to prevent common errors
        ' (variables default to zero, so Ex. misnamed variables results in
        ' using token zero by mistake)
        If blockIdx = 0 And i = 0 Then t.ParentIdx = 0: _MemPut b.m, b.m.OFFSET + i * Len(t), t: _Continue

        t.ParentIdx = nextFree

        _MemPut b.m, b.m.OFFSET + i * Len(t), t

        nextFree = blockIdx Or i
    Next
End Sub

Sub ___JsonTokenBlockClear(b As JsonTokenBlock)
    Dim i As Long, t As jsontok, count As Long

    count = _Shl(1, JSON_BLOCK_SHIFT)

    For i = 0 To count - 1
        _MemGet b.m, b.m.OFFSET + i * Len(t), t
        ___JsonTokenClear t
    Next

    _MemFree b.m
End Sub

Sub ___JsonTokenClear(t As jsontok)
    If t.value.OFFSET <> 0 Then _MemFree t.value
    If t.ChildrenIdxs.OFFSET <> 0 Then _MemFree t.ChildrenIdxs
End Sub

Sub ___JsonTokenAddChild(t As jsontok, child As Long)
    Dim m As _Mem, childCount As _Offset

    If t.ChildrenIdxs.OFFSET <> 0 Then
        childCount = t.ChildrenIdxs.SIZE / 4 + 1

        m = _MemNew(childCount * Len(child))
        _MemCopy t.ChildrenIdxs, t.ChildrenIdxs.OFFSET, t.ChildrenIdxs.SIZE To m, m.OFFSET
        _memFree t.ChildrenIdxs

        _MemPut m, m.OFFSET + (childCount - 1) * Len(child), child
        t.ChildrenIdxs = m
    Else
        t.ChildrenIdxs = _MemNew(Len(child))

        _MemPut t.ChildrenIdxs, t.ChildrenIdxs.OFFSET, child
    End If
End Sub

Function ___JsonTokenGetChild&(t As jsontok, idx As _Offset)
    Dim l As Long
    ___JsonTokenGetChild& = _MemGet(t.ChildrenIdxs, t.ChildrenIdxs.OFFSET + idx * Len(l), Long)
End Function

Function ___JsonTokenGetChildCount%&(t As jsontok)
    ___JsonTokenGetChildCount%& = t.ChildrenIdxs.SIZE / 4
End Function

Function JsonTokenTotalChildren&(j As Json, idx As Long)
    Dim t As jsontok
    ___JsonResetError
    If Not ___JsonIsInitialized&(j) Then JsonTokenTotalChildren& = JsonHadError: Exit Function
    If Not ___JsonIsValidToken&(j, idx) Then JsonTokenTotalChildren& = JsonHadError: Exit Function

    ___JsonGetToken j, idx, t

$If 32BIT Then
    JsonTokenTotalChildren& = _CV(Long, _MK$(_Offset, t.ChildrenIdxs.SIZE / 4))
$Else
    JsonTokenTotalChildren& = _CV(_Integer64, _MK$(_Offset, t.ChildrenIdxs.SIZE / 4))
$End If
End Function

Function JsonTokenGetChild&(j As Json, idx As Long, childIdx As Long)
    Dim t As jsontok
    ___JsonResetError
    If Not ___JsonIsInitialized&(j) Then JsonTokenGetChild& = JsonHadError: Exit Function
    If Not ___JsonIsValidToken&(j, idx) Then JsonTokenGetChild& = JsonHadError: Exit Function

    If childIdx < 0 Or childIdx >= JsonTokenTotalChildren&(j, idx) Then
        ___JsonSetError JSON_ERR_OutOfRange, "Child index was out-of-bound of the array"
        JsonTokenGetChild& = JSON_ERR_OutOfRange
        Exit Function
    End If

    ___JsonGetToken j, idx, t

    JsonTokenGetChild& = ___JsonTokenGetChild&(t, childIdx)
End function

Function JsonTokenGetType&(j As Json, idx As Long)
    Dim t As jsontok
    ___JsonResetError
    If Not ___JsonIsInitialized&(j) Then JsonTokenGetType& = JsonHadError: Exit Function
    If Not ___JsonIsValidToken&(j, idx) Then JsonTokenGetType& = JsonHadError: Exit Function

    ___JsonGetToken j, idx, t

    JsonTokenGetType& = t.typ
End Function

Function JsonTokenGetPrimType&(j As Json, idx As Long)
    Dim t As jsontok
    ___JsonResetError
    If Not ___JsonIsInitialized&(j) Then JsonTokenGetPrimType& = JsonHadError: Exit Function
    If Not ___JsonIsValidToken&(j, idx) Then JsonTokenGetPrimType& = JsonHadError: Exit Function

    ___JsonGetToken j, idx, t

    JsonTokenGetPrimType& = t.primType
End Function

Function ___JsonGetEmptyToken&(j As Json)
    Dim b As JsonTokenBlock, t As jsontok
    ___JsonResetError
    If Not ___JsonIsInitialized&(j) Then ___JsonGetEmptyToken& = JsonHadError: Exit Function

    If j.NextFree = -1 Then
        Dim m As _Mem
        j.TotalBlocks = j.TotalBlocks + 1

        m = _MemNew(j.TotalBlocks * Len(b))
        _MemCopy j.TokenBlocks, j.TokenBlocks.OFFSET, j.TokenBlocks.SIZE To m, m.OFFSET

        _MemFree j.TokenBlocks
        j.TokenBlocks = m

        ___JsonTokenBlockInit b, j.TotalBlocks - 1, j.NextFree
        _MemPut j.TokenBlocks, j.TokenBlocks.OFFSET + (j.TotalBlocks - 1) * Len(b), b
    End If

    Dim res As Long
    res = j.NextFree

    ___JsonGetToken j, j.NextFree, t

    j.NextFree = t.ParentIdx
    t.ParentIdx = 0

    ___JsonPutToken j, res, t

    ___JsonGetEmptyToken& = res
End Function

Sub JsonTokenFree(j As Json, idx As Long)
    Dim child As Long
    ___JsonResetError
    If Not ___JsonIsInitialized&(j) Then Exit Sub
    If Not ___JsonIsValidToken&(j, idx) Then Exit Function

    For child = 0 To JsonTokenTotalChildren&(j, idx) - 1
        JsonTokenFree j, JsonTokenGetChild&(j, idx, child)
    Next

    JsonTokenFreeShallow j, idx
End Sub

Sub JsonTokenFreeShallow(j As Json, idx As Long)
    Dim t As jsontok ', child As Long
    ___JsonResetError
    If Not ___JsonIsInitialized&(j) Then Exit Sub
    If Not ___JsonIsValidToken&(j, idx) Then Exit Function

    ___JsonGetToken j, idx, t

    t.typ = JSONTOK_TYPE_FREE
    t.ParentIdx = j.NextFree

    ___JsonTokenClear t
    ___JsonPutToken j, idx, t

    j.NextFree = idx
End Sub

Sub ___JsonGetToken(j As Json, idx As Long, t As jsontok)
    Dim b As JsonTokenBlock
    _MemGet j.TokenBlocks, j.TokenBlocks.OFFSET + _Shr(idx, JSON_BLOCK_SHIFT) * Len(b), b
    _MemGet b.m, b.m.OFFSET + (idx And (_Shl(1, JSON_BLOCK_SHIFT) - 1)) * Len(t), t
End Sub

Sub ___JsonPutToken(j As Json, idx As Long, t As jsontok)
    Dim b As JsonTokenBlock
    _MemGet j.TokenBlocks, j.TokenBlocks.OFFSET + _Shr(idx, JSON_BLOCK_SHIFT) * Len(b), b
    _MemPut b.m, b.m.OFFSET + (idx And (_Shl(1, JSON_BLOCK_SHIFT) - 1)) * Len(t), t
End Sub

Function ___JsonEscapeString$(s As String)
    Dim res As String, i As Long

    For i = 1 To Len(s)
        Select Case Asc(s, i)
            Case 13: ' new line
                res = res + "\n"

            Case 10: ' Carriage Return
                res = res + "\r"

            Case 34: ' Double quote character
                res = res + "\" + Chr$(34)

            Case Asc("\"):
                res = res + "\\"

            Case 9: ' Tab
                res = res + "\t"

            Case 12: ' formfeed
                res = res + "\f"

            Case 8: ' Backspace
                res = res + "\b"

            Case Else:
                res = res + Chr$(Asc(s, i))
        End Select
    Next

    ___JsonEscapeString$ = res
End Function

Function ___JsonUnescapeString$(s As String)
    Dim res As String, i As Long, curIdx As Long
    curIdx = 1

    ' FIXME: Handle badly formatted strings
    Do
        i = Instr(curIdx, s, "\")
        If i = 0 Then
            res = res + MID$(s, curIdx)
            Exit Do
        End If

        res = res + MID$(s, curIdx, i - curIdx)

        Select Case Asc(s, i + 1)
            Case Asc("n"):
                res = res + Chr$(13)

            Case Asc("r"):
                res = res + Chr$(10)

            Case 34: ' Double quote
                res = res + chr$(34)

            Case Asc("\"):
                res = res + "\"

            Case Asc("t"):
                res = res + Chr$(9)

            Case Asc("f"):
                res = res + Chr$(12)

            Case Asc("b"):
                res = res + Chr$(8)

            Case Asc("/"):
                res = res + "/"

            Case Asc("u"):
                ' FIXME: Decode hex into UTF-8 sequence
        End Select

        curIdx = i + 2
    Loop

    ___JsonUnescapeString$ = res
End Function

Sub ___JsonStringToMem(s As String, m As _Mem)
    m = _MemNew(Len(s))
    _MemPut m, m.OFFSET, s
End Sub

Function ___JsonTokenCreatePrim&(j As Json, s As String, primTyp As _Byte)
    Dim idx As Long, t As jsontok
    idx = ___JsonGetEmptyToken&(j)

    ___JsonGetToken j, idx, t

    t.typ = JSONTOK_TYPE_VALUE
    t.primType = primTyp

    ___JsonStringToMem s, t.value

    ___JsonPutToken j, idx, t

    ___JsonTokenCreatePrim& = idx
End Function

Function JsonTokenCreateString&(j As Json, s As String)
    ___JsonResetError
    If Not ___JsonIsInitialized&(j) Then JsonTokenCreateString& = JsonHadError: Exit Function

    JsonTokenCreateString& = ___JsonTokenCreatePrim&(j, s, JSONTOK_PRIM_STRING)
End Function

Function JsonTokenCreateBool&(j As Json, b As _Byte)
    Dim idx As Long, t As jsontok
    ___JsonResetError
    If Not ___JsonIsInitialized&(j) Then JsonTokenCreateBool& = JsonHadError: Exit Function
    idx = ___JsonGetEmptyToken&(j)

    ___JsonGetToken j, idx, t

    t.typ = JSONTOK_TYPE_VALUE
    t.primType = JSONTOK_PRIM_BOOL
    t.intPart = b

    ___JsonPutToken j, idx, t
    JsonTokenCreateBool& = idx
End Function

Function JsonTokenCreateInteger&(j As Json, i As _Integer64)
    Dim idx As Long, t As jsontok
    ___JsonResetError
    If Not ___JsonIsInitialized&(j) Then JsonTokenCreateInteger& = JsonHadError: Exit Function
    idx = ___JsonGetEmptyToken&(j)

    ___JsonGetToken j, idx, t

    t.typ = JSONTOK_TYPE_VALUE
    t.primType = JSONTOK_PRIM_NUMBER
    t.intPart = i

    ___JsonPutToken j, idx, t
    JsonTokenCreateInteger& = idx
End Function

Function JsonTokenCreateNumber&(j As Json, intPart As _Integer64, fracPart As Double, expPart As _Integer64)
    Dim idx As Long, t As jsontok
    ___JsonResetError
    If Not ___JsonIsInitialized&(j) Then JsonTokenCreateNumber& = JsonHadError: Exit Function
    idx = ___JsonGetEmptyToken&(j)

    ___JsonGetToken j, idx, t

    t.typ = JSONTOK_TYPE_VALUE
    t.primType = JSONTOK_PRIM_NUMBER
    t.intPart = intPart
    t.fracPart = fracPart
    t.expPart = expPart

    ___JsonPutToken j, idx, t
    JsonTokenCreateNumber& = idx
End Function

Function JsonTokenCreateDouble&(j As Json, s As Double)
    Dim idx As Long, t As jsontok
    ___JsonResetError
    If Not ___JsonIsInitialized&(j) Then JsonTokenCreateDouble& = JsonHadError: Exit Function
    idx = ___JsonGetEmptyToken&(j)

    ___JsonGetToken j, idx, t

    t.typ = JSONTOK_TYPE_VALUE
    t.primType = JSONTOK_PRIM_NUMBER
    t.intPart = FIX(s)
    t.fracPart = ABS(s) - ABS(t.intPart)

    ___JsonPutToken j, idx, t
    JsonTokenCreateDouble& = idx
End Function

Function JsonTokenCreateNull&(j As Json)
    Dim idx As Long, t As jsontok
    ___JsonResetError
    If Not ___JsonIsInitialized&(j) Then JsonTokenCreateNull& = JsonHadError: Exit Function

    idx = ___JsonGetEmptyToken&(j)

    ___JsonGetToken j, idx, t

    t.typ = JSONTOK_TYPE_VALUE
    t.primType = JSONTOK_PRIM_NULL

    ___JsonPutToken j, idx, t

    JsonTokenCreateNull& = idx
End Function

Function JsonTokenCreateKey&(j As Json, k As String, inner As Long)
    Dim idx As Long, t As jsontok
    ___JsonResetError
    If Not ___JsonIsInitialized&(j) Then JsonTokenCreateKey& = JsonHadError: Exit Function
    If Not ___JsonIsValidToken&(j, inner) Then JsonTokenCreateKey& = JsonHadError: Exit Function

    If JsonTokenGetType&(j, inner) = JSONTOK_TYPE_KEY Then
        JsonHadError = JSON_ERR_TokenWrongType
        JsonError = "A Json Token of type Key was passed as the value token for a key, this is invalid"
        JsonTokenCreateKey& = JsonHadError
        Exit Function
    End If

    idx = ___JsonGetEmptyToken&(j)

    ___JsonGetToken j, idx, t

    t.typ = JSONTOK_TYPE_KEY

    t.value = _MemNew(Len(k))
    _MemPut t.value, t.value.OFFSET, k

    ___JsonTokenAddChild t, inner

    ___JsonPutToken j, idx, t

    JsonTokenCreateKey& = idx
End Function

Function JsonTokenCreateArray&(j As Json)
    Dim idx As Long, t As jsontok
    ___JsonResetError
    If Not ___JsonIsInitialized&(j) Then JsonTokenCreateArray& = JsonHadError: Exit Function

    idx = ___JsonGetEmptyToken&(j)

    ___JsonGetToken j, idx, t

    t.typ = JSONTOK_TYPE_ARRAY

    ___JsonPutToken j, idx, t

    JsonTokenCreateArray& = idx
End Function

Sub JsonTokenArrayAdd(j As Json, arrayIdx As Long, childidx As Long)
    Dim t As jsontok
    ___JsonResetError
    If Not ___JsonIsInitialized&(j) Then Exit Sub

    If Not ___JsonIsValidToken&(j, arrayIdx) Then Exit Sub
    If Not ___JsonIsRightType&(j, arrayIdx, JSONTOK_TYPE_ARRAY) Then Exit Sub

    If Not ___JsonIsValidToken&(j, childidx) Then Exit Sub
    If JsonTokenGetType&(j, childidx) = JSONTOK_TYPE_KEY Then
        JsonHadError = JSON_ERR_TokenWrongType
        JsonError = "A Json Token of type Key was passed to ArrayAdd. Array's cannot contain Key tokens"
        Exit Sub
    End If

    ___JsonGetToken j, arrayIdx, t
    ___JsonTokenAddChild t, childidx
    ___JsonPutToken j, arrayIdx, t
End Sub

Sub JsonTokenArrayAddAll(j As Json, arrayIdx As Long, childidx() As Long)
    Dim i As Long
    For i = LBOUND(childidx) To UBOUND(childidx)
        JsonTokenArrayAdd j, arrayIdx, childidx(i)
        If JsonHadError Then Exit Sub
    Next
End Sub

Function JsonTokenCreateObject&(j As Json)
    Dim idx As Long, t As jsontok
    ___JsonResetError
    If Not ___JsonIsInitialized&(j) Then JsonTokenCreateObject& = JsonHadError: Exit Function

    idx = ___JsonGetEmptyToken&(j)

    ___JsonGetToken j, idx, t
    t.typ = JSONTOK_TYPE_OBJECT
    ___JsonPutToken j, idx, t

    JsonTokenCreateObject& = idx
End Function

Sub JsonTokenObjectAdd(j As Json, objectIdx As Long, childidx As Long)
    Dim t As jsontok
    ___JsonResetError
    If Not ___JsonIsInitialized&(j) Then Exit Sub

    If Not ___JsonIsValidToken&(j, objectIdx) Then Exit Sub
    If Not ___JsonIsRightType&(j, objectIdx, JSONTOK_TYPE_OBJECT) Then Exit Sub

    If Not ___JsonIsValidToken&(j, childidx) Then Exit Sub
    If Not ___JsonIsRightType&(j, childidx, JSONTOK_TYPE_KEY) Then Exit Sub

    ___JsonGetToken j, objectIdx, t
    ___JsonTokenAddChild t, childidx
    ___JsonPutToken j, objectIdx, t
End Sub

Sub JsonTokenObjectAddAll(j As Json, objectIdx As Long, childidx() As Long)
    Dim i As Long
    For i = LBOUND(childidx) To UBOUND(childidx)
        JsonTokenObjectAdd j, objectIdx, childidx(i)
        If JsonHadError Then Exit Sub
    Next
End Sub

Sub JsonSetRootToken(j As json, idx As Long)
    ___JsonResetError
    If Not ___JsonIsInitialized&(j) Then Exit Sub
    If Not ___JsonIsValidToken&(j, idx) Then Exit Sub

    j.RootToken = idx
End Sub

Function JsonGetRootToken&(j As Json)
    ___JsonResetError
    If Not ___JsonIsInitialized&(j) Then JsonGetRootToken& = JsonHadError: Exit Function

    JsonGetRootToken& = j.RootToken
End Function

Type ___JsonFmtState
    format As JsonFormat
    indent As Long
End Type

Function ___JsonRenderInternal$(j As Json, idx As Long, state As ___JsonFmtState)
    Dim res As String, count As _Offset, i As _Offset, t As jsontok
    ___JsonResetError
    If Not ___JsonIsInitialized&(j) Then Exit Function
    If Not ___JsonIsValidToken&(j, idx) Then Exit Function

    ___JsonGetToken j, idx, t

    SELECT CASE t.typ
        CASE JSONTOK_TYPE_OBJECT:
            res = res + "{"
            If state.format.Indented Then res = res + Chr$(10)

            state.indent = state.indent + 1

            count = ___JsonTokenGetChildCount%&(t)
            While i < count
                If state.format.Indented Then res = res + Space$(state.indent * 2)
                res = res + ___JsonRenderInternal$(j, ___JsonTokenGetChild&(t, i), state)

                i = i + 1
                If i < count Then res = res + ","
                If state.format.Indented Then res = res + Chr$(10)
            Wend
            state.indent = state.indent - 1

            If state.format.Indented Then res = res + Space$(state.indent * 2)
            res = res + "}"

        CASE JSONTOK_TYPE_ARRAY:
            res = res + "["
            If state.format.Indented Then res = res + Chr$(10)

            state.indent = state.indent + 1

            count = ___JsonTokenGetChildCount%&(t)
            While i < count
                If state.format.Indented Then res = res + Space$(state.indent * 2)
                res = res + ___JsonRenderInternal$(j, ___JsonTokenGetChild&(t, i), state)

                i = i + 1
                If i < count Then res = res + ","
                If state.format.Indented Then res = res + Chr$(10)
            Wend
            state.indent = state.indent - 1

            If state.format.Indented Then res = res + Space$(state.indent * 2)
            res = res + "]"

        CASE JSONTOK_TYPE_VALUE:
            SELECT CASE t.primType
                CASE JSONTOK_PRIM_STRING:
                    res = ___JsonAddQuotes$(___JsonEscapeString$(___JsonGetRawStrValue$(j, t)))

                CASE JSONTOK_PRIM_NULL:
                    res = "null"

                CASE JSONTOK_PRIM_NUMBER:
                    res = _TRIM$(STR$(t.intPart))
                    if t.fracPart <> 0 Then res = res + _TRIM$(STR$(t.fracPart))
                    If t.expPart <> 0 Then res = res + "e" + _TRIM$(STR$(t.expPart))

                CASE JSONTOK_PRIM_BOOL:
                    If t.intPart Then res = "true" Else res = "false"

                CASE ELSE:
                    ' FIXME: This is very unlikely, but we should have better error reporting here
                    res = "UNKNOWN"

            END SELECT

        CASE JSONTOK_TYPE_KEY:
            res = ___JsonAddQuotes$(___JsonEscapeString$(___JsonGetRawStrValue$(j, t))) + ":"
            If state.format.Indented Then res = res + " "
            res = res + ___JsonRenderInternal$(j, ___JsonTokenGetChild&(t, 0), state)

    END SELECT

    ___JsonRenderInternal$ = res
End Function

Function JsonRender$(j As json)
    Dim state As ___JsonFmtState

    JsonRender$ = ___JsonRenderInternal$(j, j.RootToken, state)
End Function

Function JsonRenderToken$(j As json, idx As Long)
    Dim state As ___JsonFmtState
    state.format.Indented = -1

    JsonRenderToken$ = ___JsonRenderInternal$(j, idx, state)
End Function

Function JsonRenderFormatted$(j As json, format As JsonFormat)
    Dim state As ___JsonFmtState
    state.format = format

    JsonRenderFormatted$ = ___JsonRenderInternal$(j, j.RootToken, state)
End Function

Function JsonRenderTokenFormatted$(j As json, idx As Long, format As JsonFormat)
    Dim state As ___JsonFmtState
    state.format = format

    JsonRenderTokenFormatted$ = ___JsonRenderInternal$(j, idx, state)
End Function

Function ___JsonGetRawStrValue$(j As json, t As jsontok)
    If t.value.OFFSET <> 0 Then
        Dim res as String

        res = Space$(t.value.SIZE)
        _MemGet t.value, t.value.OFFSET, res
        ___JsonGetRawStrValue$ = res
    End If
End Function

Function JsonTokenGetValueStr$(j As json, idx As Long)
    Dim t As jsontok
    ___JsonResetError
    If Not ___JsonIsInitialized&(j) Then Exit Function
    If Not ___JsonIsValidToken&(j, idx) Then Exit Function

    If JsonTokenGetType&(j, idx) <> JSONTOK_TYPE_VALUE And JsonTokenGetType&(j, idx) <> JSONTOK_TYPE_KEY Then
        JsonHadError = JSON_ERR_TokenWrongType
        JsonError = "Json Token was passed to function requiring type 'Key' Or 'Value' but is actually type: '" + ___JsonTokenTypeString$(JsonTokenGetType&(j, idx))
        Exit Function
    End If

    ___JsonGetToken j, idx, t

    If t.typ = JSONTOK_TYPE_KEY Then
        JsonTokenGetValueStr$ = ___JsonGetRawStrValue$(j, t)
    ElseIf t.typ = JSONTOK_TYPE_VALUE Then
        Select Case t.primType
            Case JSONTOK_PRIM_STRING:
                JsonTokenGetValueStr$ = ___JsonGetRawStrValue$(j, t)

            Case JSONTOK_PRIM_NUMBER:
                If t.fracPart = 0 Then
                    JsonTokenGetValueStr$ = _TRIM$(STR$(t.intPart))
                Else
                    JsonTokenGetValueStr$ = _TRIM$(STR$(JsonTokenGetValueDouble#(j, idx)))
                End If

            Case JSONTOK_PRIM_BOOL:
                If t.intPart Then
                    JsonTokenGetValueStr$ = "true"
                Else
                    JsonTokenGetValueStr$ = "false"
                End If

            Case JSONTOK_PRIM_NULL:
                JsonTokenGetValueStr$ = "null"
        End Select
    End If
End Function

Function JsonTokenGetValueBool&(j As Json, idx As Long)
    Dim t As jsontok
    ___JsonResetError
    If Not ___JsonIsInitialized&(j) Then Exit Function
    If Not ___JsonIsValidToken&(j, idx) Then Exit Function
    If Not ___JsonIsRightPrimType&(j, idx, JSONTOK_PRIM_BOOL) Then Exit Function

    ___JsonGetToken j, idx, t

    JsonTokenGetValueBool& = t.intPart
End Function

Function JsonTokenGetValueInteger&&(j As Json, idx As Long)
    Dim t As jsontok
    ___JsonResetError
    If Not ___JsonIsInitialized&(j) Then Exit Function
    If Not ___JsonIsValidToken&(j, idx) Then Exit Function
    If Not ___JsonIsRightPrimType&(j, idx, JSONTOK_PRIM_NUMBER) Then Exit Function

    ___JsonGetToken j, idx, t

    JsonTokenGetValueInteger&& = t.intPart
End Function

Function JsonTokenGetValueDouble#(j As Json, idx As Long)
    Dim t As jsontok
    ___JsonResetError
    If Not ___JsonIsInitialized&(j) Then Exit Function
    If Not ___JsonIsValidToken&(j, idx) Then Exit Function
    If Not ___JsonIsRightPrimType&(j, idx, JSONTOK_PRIM_NUMBER) Then Exit Function

    ___JsonGetToken j, idx, t

    JsonTokenGetValueDouble# = t.intPart + t.fracPart
End Function

Type ___JsonQLex
    curIdx As Long

    index As Long
    keyName As String
End Type

Function ___JsonQueryLex&(query As String, lex As ___JsonQLex)
    Dim startIdx As Long

    If lex.curIdx > Len(query) Then
        ___JsonQueryLex& = ___JSON_QLEX_End
        Exit Function
    End If

    If Asc(query, lex.curIdx) = Asc(".") Then
        ___JsonQueryLex& = ___JSON_QLEX_Dot
        lex.curIdx = lex.curIdx + 1
        Exit Function
    End If

    If Asc(query, lex.curIdx) = Asc("(") Then
        Dim missingEndParen As Long

        lex.curIdx = lex.curIdx + 1
        startIdx = lex.curIdx

        While lex.curIdx <= Len(query)
            If Not ___JsonIsDigit(Asc(query, lex.curIdx)) Then Exit While
            lex.curIdx = lex.curIdx + 1
        Wend

        If startIdx = lex.curIdx Then
            ___JsonSetError JSON_ERR_BADQUERY, "Expected digit at position:" + Str$(lex.curIdx)
            Exit Function
        End If

        If lex.curIdx > Len(query) Then
            missingEndParen = -1
        ElseIf Asc(query, lex.curIdx) <> Asc(")") Then
            missingEndParen = -1
        End If

        If missingEndParen Then
            ___JsonSetError JSON_ERR_BADQUERY, "Expected ')' at position:" + Str$(lex.curIdx)
            Exit Function
        End If

        lex.index = Val(Mid$(query, startIdx, lex.curIdx - startIdx))
        ___JsonQueryLex& = ___JSON_QLEX_Index
        lex.curIdx = lex.curIdx + 1
        Exit Function
    End If

    If Asc(query, lex.curIdx) = Asc("'") Then
        Dim keyName As String

        Do While Asc(query, lex.curIdx) <> Asc("'") Or lex.curIdx > Len(query)
            If Asc(query, lex.curIdx) = Asc("\") Then
                lex.curIdx = lex.curIdx + 1
                If lex.curIdx > Len(query) Then Exit Do

                If Asc(query, lex.curIdx) <> Asc("'") Then
                    ___JsonSetError JSON_ERR_BADQUERY, "Unexpected escape character at postion:" + Str$(lex.curIdx)
                    Exit Function
                End If

                keyName = keyName + "'"
            Else
                keyName = keyName + Chr$(Asc(query, lex.curIdx))
            End If

            lex.curIdx = lex.curIdx + 1
        Loop

        If lex.curIdx > Len(query) Then
            ___JsonSetError JSON_ERR_BADQUERY, "Missing ending ' quote at position:" + Str$(lex.curIdx)
            Exit Function
        End If

        lex.keyName = keyName
        ___JsonQueryLex& = ___JSON_QLEX_Key
        Exit Function
    End If

    ' unquoted key name
    startIdx = lex.curIdx
    Do While lex.curIdx <= Len(query)
        If Asc(query, lex.curIdx) = Asc(".") Or Asc(query, lex.curIdx) = Asc("(") Then Exit Do

        lex.curIdx = lex.curIdx + 1
    Loop

    lex.keyName = Mid$(query, startIdx, lex.curIdx - startIdx)
    ___JsonQueryLex& = ___JSON_QLEX_Key
End Function

Function JsonQueryFrom&(j As Json, startToken As Long, query As String)
    Dim lex As ___JsonQLex, curTok As Long, first As Long
    ___JsonResetError
    If Not ___JsonIsInitialized&(j) Then JsonQueryFrom& = JsonHadError: Exit Function
    If Not ___JsonIsValidToken&(j, startToken) Then JsonQueryFrom& = JsonHadError: Exit Function

    lex.curIdx = 1
    curTok = startToken
    first = -1

    Dim tok As Long
    tok = ___JsonQueryLex&(query, lex)
    If JsonHadError Then JsonQueryFrom& = JsonHadError: Exit FUnction
    Do
        ' Array tokens can come one after another
        While tok = ___JSON_QLEX_Index
            If JsonTokenGetType&(j, curTok) <> JSONTOK_TYPE_ARRAY Then
                ___JsonSetError JSON_ERR_BADQUERY, "Array bounds were used on a non-array token, at position:" + Str$(lex.curIdx)
                JsonQueryFrom& = JSON_ERR_BADQUERY
                Exit Function
            End If

            curTok = JsonTokenGetChild&(j, curTok, lex.index)
            If JsonHadError Then JsonQueryFrom& = JsonHadError: Exit FUnction
            tok = ___JsonQueryLex&(query, lex)
            If JsonHadError Then JsonQueryFrom& = JsonHadError: Exit FUnction
            first = 0
        Wend

        If tok = ___JSON_QLEX_End Then Exit Do

        ' Dot must separate array/key
        If Not first Then
            If tok <> ___JSON_QLEX_Dot Then
                 ___JsonSetError JSON_ERR_BADQUERY, "Expected dot before key name, at position:" + Str$(lex.curIdx)
                 JsonQueryFrom& = JSON_ERR_BADQUERY
                 Exit Function
            End If

            ' Token after dot must be a key, not array
            tok = ___JsonQueryLex&(query, lex)
            If JsonHadError Then JsonQueryFrom& = JsonHadError: Exit FUnction
            If tok <> ___JSON_QLEX_Key Then
                 ___JsonSetError JSON_ERR_BADQUERY, "Expected key name after dot, at position:" + Str$(lex.curIdx)
                 JsonQueryFrom& = JSON_ERR_BADQUERY
                 Exit Function
            End If
        End If
        first = 0

        ' Key's cannot follow each other, they need to either be separated by a dot, or edn with an array index
        While tok = ___JSON_QLEX_Key
            Dim found As Long, child As Long
            found = -1

            For child = 0 To JsonTokenTotalChildren&(j, curTok) - 1
                Dim c As Long ', typ As Long
                c = JsonTokenGetChild&(j, curTok, child)

                If JsonTokenGetType&(j, c) <> JSONTOK_TYPE_KEY Then _Continue

                If JsonTokenGetValueStr$(j, c) = lex.keyName Then
                    found = JsonTokenGetChild&(j, c, 0) ' Get the child of the key node
                    Exit For
                End If
            Next

            If found = -1 Then
                ___JsonSetError JSON_ERR_KEYNOTFOUND, "Key " + ___JsonAddQuotes$(lex.keyName) + " not found!"
                JsonQueryFrom& = JSON_ERR_KeyNotFound
                Exit Function
            End If

            curTok = found

            tok = ___JsonQueryLex&(query, lex)
            If JsonHadError Then JsonQueryFrom& = JsonHadError: Exit FUnction
            If tok = ___JSON_QLEX_Key Then
                 ___JsonSetError JSON_ERR_BADQUERY, "Unexpected key, at position:" + Str$(lex.curIdx)
                 JsonQueryFrom& = JSON_ERR_BADQUERY
                 Exit Function
            End If
        Wend
    Loop

    JsonQueryFrom& = curTok
End Function

Function JsonQuery&(j As Json, query As String)
    JsonQuery& = JsonQueryFrom&(j, j.RootToken, query)
End Function

' Returns the value of the token the query refers too
Function jsonQueryFromValue$ (j As Json, startToken As Long, query As String)
    Dim t As Long
    t = JsonQueryFrom&(j, startToken, query)

    If JsonHadError Then Exit Function

    jsonQueryFromValue$ = JsonTokenGetValueStr$(j, t)
End Function

' Returns the value of the token the query refers too
Function JsonQueryValue$ (j As Json, query As String)
    Dim t As Long
    t = JsonQuery&(j, query)

    If JsonHadError Then Exit Function

    JsonQueryValue$ = JsonTokenGetValueStr$(j, t)
End Function

Function ___JsonTokenTypeString$(typ As _Byte)
    Select Case typ
        Case JSONTOK_TYPE_OBJECT: ___JsonTokenTypeString$ = "Object"
        Case JSONTOK_TYPE_ARRAY: ___JsonTokenTypeString$ = "Array"
        Case JSONTOK_TYPE_KEY: ___JsonTokenTypeString$ = "Key"
        Case JSONTOK_TYPE_VALUE: ___JsonTokenTypeString$ = "Value"
    End Select
End Function

Function ___JsonTokenPrimTypeString$(primType As _Byte)
    Select Case primType
        Case JSONTOK_PRIM_STRING: ___JsonTokenPrimTypeString$ = "String"
        Case JSONTOK_PRIM_BOOL: ___JsonTokenPrimTypeString$ = "Bool"
        Case JSONTOK_PRIM_NUMBER: ___JsonTokenPrimTypeString$ = "Number"
        Case JSONTOK_PRIM_NULL: ___JsonTokenPrimTypeString$ = "Null"
    End Select
End Function

Function ___JsonIsDigit&(chr As Long)
    ___JsonIsDigit& = chr >= Asc("0") And chr <= Asc("9")
End Function

Sub ___JsonSetError(ero As Long, txt As String)
    JsonHadError = ero
    JsonError = txt
End Sub

Function ___JsonIsWhiteSpace&(chr As _Byte)
    ___JsonIsWhiteSpace& = chr = &h20 Or chr = &h09 Or chr = &h0A Or chr = &h0D
End Function

Type ___JsonLexer
    prevNextIdx As Long
    nextIdx As Long

    startIdx As Long
    endIdx As Long

    intPart As _Integer64
    fracPart As Double
    expPart As _Integer64

    bool As _Byte
End Type

Function ___JsonLexString&(json As String, lexer As ___JsonLexer)
    Dim stringEnd As Long

    stringEnd = lexer.nextIdx

    ' FIXME: The string can have UTF-8 characters, we need to skip them
    While stringEnd < Len(json)
        Dim chr As _Byte
        stringEnd = stringEnd + 1
        chr = Asc(json, stringEnd)

        If chr = 34 Then
            lexer.startIdx = lexer.nextIdx + 1
            lexer.endIdx = stringEnd - 1
            lexer.nextIdx = lexer.endIdx + 2

            ___JsonLexString& = ___JSON_LEX_String
            Exit Function
        End If

        If chr = Asc("\") Then
            stringEnd = stringEnd + 1
            ' FIXME: Verify escaped character is allowed
        End If
    Wend

    ___JsonSetError JSON_ERR_Invalid, "Missing end quote for string starting at position" + Str$(lexer.nextIdx)
    ___JsonLexString& = ___JSON_LEX_End
End Function

Function ___JsonLexNull&(json As String, lexer As ___JsonLexer)
    If Mid$(json, lexer.nextIdx, 4) = "null" Then
        lexer.nextIdx = lexer.nextIdx + 4
        ___JsonLexNull& = ___JSON_LEX_Null
        Exit Function
    End If

    ___JsonSetError JSON_ERR_Invalid, "Expected 'null' at position" + Str$(lexer.nextIdx)
    ___JsonLexNull& = ___JSON_LEX_End
End Function

Function ___JsonLexNumber&(json As String, lexer As ___JsonLexer)
    Dim curIdx As Long, isNegative As _Byte, valStart As Long
    curIdx = lexer.nextIdx
    lexer.intPart = 0
    lexer.fracPart = 0
    lexer.expPart = 0

    ' Leading minus
    If Asc(json, curIdx) = Asc("-") Then curIdx = curIdx + 1: isNegative = -1

    ' Make sure there's a digit after the minus sign
    If Not ___JsonIsDigit(Asc(json, curIdx)) Then
        ___JsonSetError JSON_ERR_Invalid, "Expected digit at" + Str$(curIdx)
        ___JsonLexNumber& = ___JSON_LEX_End
        Exit Function
    End If

    ' Skip all digits in the integer part
    valStart = curIdx
    While curIdx <= Len(json)
        If Not ___JsonIsDigit(Asc(json, curIdx)) Then Exit While
        curIdx = curIdx + 1
    Wend

    If curIdx > Len(json) Then GoTo returnNumber

    lexer.intPart = Val(Mid$(json, valStart, curIdx - valStart))
    if isNegative Then lexer.intPart = -lexer.intPart

    ' Decimal part
    If Asc(json, curIdx) = Asc(".") Then
        valStart = curIdx
        curIdx = curIdx + 1

        If Not ___JsonIsDigit(Asc(json, curIdx)) Then
            ___JsonSetError JSON_ERR_Invalid, "Expected digit after decimal point at" + Str$(curIdx - 1)
            ___JsonLexNumber& = ___JSON_LEX_End
            Exit Function
        End If

        ' Skip all digits in the decimal part
        While curIdx <= Len(json)
            If Not ___JsonIsDigit(Asc(json, curIdx)) Then Exit While
            curIdx = curIdx + 1
        Wend

        If curIdx > Len(json) Then GoTo returnNumber

        ' The decimal point is included, so this produces a floating point value
        lexer.fracPart = Val(Mid$(json, valStart, curIdx - valStart))
    End If

    ' Exponent part
    If Asc(json, curIdx) = Asc("e") Or Asc(json, curIdx) = Asc("E") Then
        curIdx = curIdx + 1

        ' The exponent can be positive or negative
        isNegative = 0
        If Asc(json, curIdx) = Asc("+") Then curIdx = curIdx + 1
        If Asc(json, curIdx) = Asc("-") Then curIdx = curIdx + 1: isNegative = -1

        If Not ___JsonIsDigit(Asc(json, curIdx)) Then
            ___JsonSetError JSON_ERR_Invalid, "Expected digit at" + Str$(curIdx)
            ___JsonLexNumber& = ___JSON_LEX_End
            Exit Function
        End If

        ' Skip all digits in the decimal part
        valStart = curIdx
        While curIdx <= Len(json)
            If Not ___JsonIsDigit(Asc(json, curIdx)) Then Exit While
            curIdx = curIdx + 1
        Wend

        If curIdx > Len(json) Then GoTo returnNumber

        lexer.expPart = Val(Mid$(json, valStart, curIdx - valStart))
        If isNegative Then lexer.expPart = -lexer.expPart
    End If

returnNumber:
    lexer.startIdx = lexer.nextIdx
    lexer.endIdx = curIdx - 1
    lexer.nextIdx = curIdx

    ___JsonLexNumber& = ___JSON_LEX_Number
End Function

' endIdx indicates the value of the bool, not the ending index (since it's more
' useful to know the actual value rather than the string)
Function ___JsonLexBool&(json As String, lexer As ___JsonLexer)
    lexer.startIdx = lexer.nextIdx

    If Mid$(json, lexer.nextIdx, 4) = "true" Then
        lexer.bool = -1
        lexer.endIdx = lexer.startIdx + 3
        lexer.nextIdx = lexer.nextIdx + 4
        ___JsonLexBool& = ___JSON_LEX_Bool
        Exit Function
    End If

    If Mid$(json, lexer.nextIdx, 5) = "false" Then
        lexer.bool = 0
        lexer.endIdx = lexer.startIdx + 4
        lexer.nextIdx = lexer.nextIdx + 5
        ___JsonLexBool& = ___JSON_LEX_Bool
        Exit Function
    End If

    ___JsonSetError JSON_ERR_Invalid, "Unexpected character at position" + Str$(lexer.nextIdx + 1)
    ___JsonLexBool& = ___JSON_LEX_End
End Function

' Returns the next token starting at nextIdx, skipping whitespace
Function ___JsonLex&(json As String, lexer As ___JsonLexer)
    lexer.prevNextIdx = lexer.nextIdx
    If lexer.nextIdx > Len(json) Then lexer.startIdx = lexer.nextIdx: ___JsonLex& = ___JSON_LEX_End: Exit Function

    ' Skip to next non-whitespace character
    While ___JsonIsWhiteSpace&(Asc(json, lexer.nextIdx))
        lexer.nextIdx = lexer.nextIdx + 1
        If lexer.nextIdx > Len(json) Then lexer.startIdx = lexer.nextIdx: ___JsonLex& = ___JSON_LEX_End: Exit Function
    Wend

    Dim chr As _Byte
    chr = Asc(json, lexer.nextIdx)

    ' String
    If chr = 34 Then ___JsonLex& = ___JsonLexString&(json, lexer): Exit Function
    If chr = Asc("n") Then ___JsonLex& = ___JsonLexNull&(json, lexer): Exit Function
    If chr = Asc("t") Or chr = Asc("f") Then ___JsonLex& = ___JsonLexBool&(json, lexer): Exit Function
    if ___JsonIsDigit(chr) Or chr = Asc("-") Then ___JsonLex& = ___JsonLexNumber&(json, lexer): Exit Function

    If chr = Asc(",") Then
        lexer.startIdx = lexer.nextIdx: lexer.endIdx = lexer.nextIdx: lexer.nextIdx = lexer.nextIdx + 1
        ___JsonLex& = ___JSON_LEX_Comma
        Exit Function
    End If

    If chr = Asc(":") Then
        lexer.startIdx = lexer.nextIdx: lexer.endIdx = lexer.nextIdx: lexer.nextIdx = lexer.nextIdx + 1
        ___JsonLex& = ___JSON_LEX_Colon
        Exit Function
    End If

    If chr = Asc("{") Then
        lexer.startIdx = lexer.nextIdx: lexer.endIdx = lexer.nextIdx: lexer.nextIdx = lexer.nextIdx + 1
        ___JsonLex& = ___JSON_LEX_LeftBrace
        Exit Function
    End If

    If chr = Asc("[") Then
        lexer.startIdx = lexer.nextIdx: lexer.endIdx = lexer.nextIdx: lexer.nextIdx = lexer.nextIdx + 1
        ___JsonLex& = ___JSON_LEX_LeftBracket
        Exit Function
    End If

    If chr = Asc("}") Then
        lexer.startIdx = lexer.nextIdx: lexer.endIdx = lexer.nextIdx: lexer.nextIdx = lexer.nextIdx + 1
        ___JsonLex& = ___JSON_LEX_RightBrace
        Exit Function
    End If

    If chr = Asc("]") Then
        lexer.startIdx = lexer.nextIdx: lexer.endIdx = lexer.nextIdx: lexer.nextIdx = lexer.nextIdx + 1
        ___JsonLex& = ___JSON_LEX_RightBracket
        Exit Function
    End If

    ___JsonSetError JSON_ERR_Invalid, "Unexpected character at position" + Str$(lexer.nextIdx) + ": '" + Chr$(chr) + "'"
    ___JsonLex& = ___JSON_LEX_End
End Function

Function ___JsonParseValue&(json As String, j As Json, lexer As ___JsonLexer, curTok As Long)
    'Dim currentToken As Long

    Select Case curTok
        Case ___JSON_LEX_LeftBrace:
            ___JsonParseValue& = ___JsonParseObject(json, j, lexer, curTok)

        Case ___JSON_LEX_LeftBracket:
            ___JsonParseValue& = ___JsonParseArray(json, j, lexer, curTok)

        Case ___JSON_LEX_Null:
            ___JsonParseValue& = JsonTokenCreateNull&(j)

        Case ___JSON_LEX_Number:
            ___JsonParseValue& = JsonTokenCreateNumber&(j, lexer.intPart, lexer.fracPart, lexer.expPart)

        Case ___JSON_LEX_Bool:
            ___JsonParseValue& = JsonTokenCreateBool&(j, lexer.bool)

        Case ___JSON_LEX_String:
            ___JsonParseValue& = JsonTokenCreateString&(j, ___JsonUnescapeString$(Mid$(json, lexer.startIdx, lexer.endIdx - lexer.startIdx + 1)))

        Case Else:
            If JsonHadError = JSON_ERR_Success Then ___JsonSetError JSON_ERR_Invalid, "Unexpected token at position" + Str$(lexer.startIdx)
            ___JsonParseValue& = JSON_ERR_Invalid
    End Select
End Function

Function ___JsonParseObject&(json As String, j As Json, lexer As ___JsonLexer, curTok As Long)
    Dim objToken As Long, first As Long ', t As jsontok
    If curTok <> ___JSON_LEX_LeftBrace Then
        If JsonHadError = JSON_ERR_Success Then ___JsonSetError JSON_ERR_Invalid, "Unexpected character at position:" + Str$(lexer.startIdx)
        ___JsonParseObject& = JSON_ERR_Invalid
        Exit Function
    End If

    objToken = JsonTokenCreateObject&(j)
    first = -1

    Do
        curTok = ___JsonLex&(json, lexer)

        If curTok = ___JSON_LEX_RightBrace Then Exit Do

        If Not first Then
            If curTok <> ___JSON_LEX_Comma Then
                If JsonHadError = JSON_ERR_Success Then ___JsonSetError JSON_ERR_Invalid, "Unexpected character at position:" + Str$(lexer.startIdx)
                ___JsonParseObject& = JSON_ERR_Invalid
                Exit Function
            End If
            curTok = ___JsonLex&(json, lexer)
        End If
        first = 0

        If curTok <> ___JSON_LEX_String Then
            If JsonHadError = JSON_ERR_Success Then ___JsonSetError JSON_ERR_Invalid, "Expected key name at position:" + Str$(lexer.startIdx)
            ___JsonParseObject& = JSON_ERR_Invalid
            Exit Function
        End If

        Dim keyToken As Long, valueToken As Long ', k As jsontok
        Dim keyName As String
        keyName = ___JsonUnescapeString$(Mid$(json, lexer.startIdx, lexer.endIdx - lexer.startIdx + 1))

        curTok = ___JsonLex&(json, lexer)
        If curTok <> ___JSON_LEX_Colon Then
            ___JsonSetError JSON_ERR_Invalid, "Expected colon at position:" + Str$(lexer.prevNextIdx)
             ___JsonParseObject& = JSON_ERR_Invalid
            Exit Function
        End If

        curTok = ___JsonLex&(json, lexer)
        valueToken = ___JsonParseValue&(json, j, lexer, curTok)
        If valueToken = JSON_ERR_Invalid Then ___JsonParseObject& = JSON_ERR_Invalid: Exit Function

        keyToken = JsonTokenCreateKey&(j, keyName, valueToken)
        JsonTokenObjectAdd j, objToken, keyToken
    Loop

    ___JsonParseObject& = objToken
End Function

Function ___JsonParseArray&(json As String, j As Json, lexer As ___JsonLexer, curTok As Long)
    Dim arrToken As Long, first As Long ', t As jsontok
    If curTok <> ___JSON_LEX_LeftBracket Then ___JsonParseArray& = JSON_ERR_Invalid: Exit Function

    arrToken = JsonTokenCreateArray&(j)

    first = -1
    Do
        curTok = ___JsonLex&(json, lexer)
        If curTok = ___JSON_LEX_RightBracket Then Exit Do

        If Not first Then
            If curTok <> ___JSON_LEX_Comma Then
                ___JsonSetError JSON_ERR_Invalid, "Expected comma at position:" + Str$(lexer.startIdx)
                ___JsonParseArray& = JSON_ERR_Invalid
                Exit Function
            End If
            curTok = ___JsonLex&(json, lexer)
        End If
        first = 0

        Dim valueToken As Long
        valueToken = ___JsonParseValue&(json, j, lexer, curTok)
        if valueToken = JSON_ERR_Invalid Then ___JsonParseArray& = JSON_ERR_Invalid: Exit Function

        JsonTokenArrayAdd j, arrToken, valueToken
    Loop

    ___JsonParseArray& = arrToken
End Function

Function JsonParse&(j As Json, json As String)
    Dim lexer As ___JsonLexer, curTok As Long, result As Long, lastPos As Long
    lexer.nextIdx = 1

    ___JsonResetError
    If Not ___JsonIsInitialized&(j) Then JsonParse& = JSON_ERR_NotInitialized: Exit Function

    curTok = ___JsonLex&(json, lexer)
    result = ___JsonParseValue&(json, j, lexer, curTok)

    If result = JSON_ERR_Invalid Then JsonParse& = JsonHadError: Exit Function

    lastPos = lexer.nextIdx
    curTok = ___JsonLex&(json, lexer)

    If curTok <> ___JSON_LEX_End Then
        ___JsonSetError JSON_ERR_Invalid, "Unexpected characters after end of JSON at position:" + Str$(lastPos)
        JsonParse& = JSON_ERR_Invalid
        Exit Function
    End If

    JsonSetRootToken j, result
    JsonParse& = JSON_ERR_Success
End Function

Function ___JsonAddQuotes$ (s As String)
    ___JsonAddQuotes$ = Chr$(34) + s + Chr$(34)
End Function
