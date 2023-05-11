'-----------------------------------------------------------------------------------------------------
' raylib bindings for QB64-PE
' Copyright (c) 2023 Samuel Gomes
'
' This file contains wrapper functions for stuff that cannot be used directly in QB64-PE
'-----------------------------------------------------------------------------------------------------

'$INCLUDE:'raylib.bi'

$IF RAYLIB_BAS = UNDEFINED THEN
    $LET RAYLIB_BAS = TRUE

    $CHECKING:OFF

    SUB GetMonitorPositionVector2 (monitor AS LONG, v AS Vector2)
        DIM tmp AS _UNSIGNED _INTEGER64: tmp = __GetMonitorPosition(monitor)
        __internal_memcpy _OFFSET(v), _OFFSET(tmp), LEN(v)
    END SUB

    SUB GetWindowPositionVector2 (v AS Vector2)
        DIM tmp AS _UNSIGNED _INTEGER64: tmp = __GetWindowPosition
        __internal_memcpy _OFFSET(v), _OFFSET(tmp), LEN(v)
    END SUB

    SUB GetWindowScaleDPIVector2 (v AS Vector2)
        DIM tmp AS _UNSIGNED _INTEGER64: tmp = __GetWindowScaleDPI
        __internal_memcpy _OFFSET(v), _OFFSET(tmp), LEN(v)
    END SUB

    $CHECKING:ON

$END IF

