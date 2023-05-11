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

    ' Just a convenience function for use when calling external libraries
    FUNCTION BStrToCStr$ (s AS STRING)
        BStrToCStr = s + CHR$(NULL)
    END FUNCTION

    SUB InitWindow (w AS LONG, h AS LONG, title AS STRING)
        __InitWindow w, h, BStrToCStr(title)
    END SUB

    SUB GetMonitorPositionVector2 (monitor AS LONG, v AS Vector2)
        DIM tmp AS _UNSIGNED _INTEGER64: tmp = __GetMonitorPosition(monitor)
        MemCpy _OFFSET(v), _OFFSET(tmp), LEN(v)
    END SUB

    SUB GetWindowPositionVector2 (v AS Vector2)
        DIM tmp AS _UNSIGNED _INTEGER64: tmp = __GetWindowPosition
        MemCpy _OFFSET(v), _OFFSET(tmp), LEN(v)
    END SUB

    SUB GetWindowScaleDPIVector2 (v AS Vector2)
        DIM tmp AS _UNSIGNED _INTEGER64: tmp = __GetWindowScaleDPI
        MemCpy _OFFSET(v), _OFFSET(tmp), LEN(v)
    END SUB

    SUB SetClipboardText (text AS STRING)
        __SetClipboardText BStrToCStr(text)
    END SUB

    $CHECKING:ON

$END IF

