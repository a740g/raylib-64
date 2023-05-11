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

    FUNCTION InitWindow%% (w AS LONG, h AS LONG, title AS STRING)
        IF __init_raylib THEN
            __InitWindow w, h, BStrToCStr(title)
            InitWindow = TRUE
        END IF
    END FUNCTION

    SUB CloseWindow
        __CloseWindow
        __done_raylib
    END SUB

    SUB SetWindowTitle (title AS STRING)
        __SetWindowTitle BStrToCStr(title)
    END SUB

    SUB SetClipboardText (text AS STRING)
        __SetClipboardText BStrToCStr(text)
    END SUB

    $CHECKING:ON

$END IF

