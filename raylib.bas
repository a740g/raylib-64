'-----------------------------------------------------------------------------------------------------
' raylib bindings for QB64-PE
' Copyright (c) 2023 Samuel Gomes
'
' This file contains wrapper functions for stuff that cannot be used directly in QB64-PE
'-----------------------------------------------------------------------------------------------------

'$INCLUDE:'raylib.bi'

$IF RAYLIB_BAS = UNDEFINED THEN
    $LET RAYLIB_BAS = TRUE

$END IF

