'-----------------------------------------------------------------------------------------------------------------------
' QB64-PE bindings for reasings - raylib easings library, based on Robert Penner library
' Copyright (c) 2023 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$If REASINGS_BI = UNDEFINED Then
    $Let REASINGS_BI = TRUE
    '-------------------------------------------------------------------------------------------------------------------
    ' EXTERNAL LIBRARIES
    '-------------------------------------------------------------------------------------------------------------------
    Declare Library "reasings"
        Function EaseBackIn! (ByVal t As Single, Byval b As Single, Byval c As Single, Byval d As Single)
        Function EaseBackInOut! (ByVal t As Single, Byval b As Single, Byval c As Single, Byval d As Single)
        Function EaseBackOut! (ByVal t As Single, Byval b As Single, Byval c As Single, Byval d As Single)
        Function EaseBounceIn! (ByVal t As Single, Byval b As Single, Byval c As Single, Byval d As Single)
        Function EaseBounceInOut! (ByVal t As Single, Byval b As Single, Byval c As Single, Byval d As Single)
        Function EaseBounceOut! (ByVal t As Single, Byval b As Single, Byval c As Single, Byval d As Single)
        Function EaseCircIn! (ByVal t As Single, Byval b As Single, Byval c As Single, Byval d As Single)
        Function EaseCircInOut! (ByVal t As Single, Byval b As Single, Byval c As Single, Byval d As Single)
        Function EaseCircOut! (ByVal t As Single, Byval b As Single, Byval c As Single, Byval d As Single)
        Function EaseCubicIn! (ByVal t As Single, Byval b As Single, Byval c As Single, Byval d As Single)
        Function EaseCubicInOut! (ByVal t As Single, Byval b As Single, Byval c As Single, Byval d As Single)
        Function EaseCubicOut! (ByVal t As Single, Byval b As Single, Byval c As Single, Byval d As Single)
        Function EaseElasticIn! (ByVal t As Single, Byval b As Single, Byval c As Single, Byval d As Single)
        Function EaseElasticInOut! (ByVal t As Single, Byval b As Single, Byval c As Single, Byval d As Single)
        Function EaseElasticOut! (ByVal t As Single, Byval b As Single, Byval c As Single, Byval d As Single)
        Function EaseExpoIn! (ByVal t As Single, Byval b As Single, Byval c As Single, Byval d As Single)
        Function EaseExpoInOut! (ByVal t As Single, Byval b As Single, Byval c As Single, Byval d As Single)
        Function EaseExpoOut! (ByVal t As Single, Byval b As Single, Byval c As Single, Byval d As Single)
        Function EaseLinearIn! (ByVal t As Single, Byval b As Single, Byval c As Single, Byval d As Single)
        Function EaseLinearInOut! (ByVal t As Single, Byval b As Single, Byval c As Single, Byval d As Single)
        Function EaseLinearNone! (ByVal t As Single, Byval b As Single, Byval c As Single, Byval d As Single)
        Function EaseLinearOut! (ByVal t As Single, Byval b As Single, Byval c As Single, Byval d As Single)
        Function EaseQuadIn! (ByVal t As Single, Byval b As Single, Byval c As Single, Byval d As Single)
        Function EaseQuadInOut! (ByVal t As Single, Byval b As Single, Byval c As Single, Byval d As Single)
        Function EaseQuadOut! (ByVal t As Single, Byval b As Single, Byval c As Single, Byval d As Single)
        Function EaseSineIn! (ByVal t As Single, Byval b As Single, Byval c As Single, Byval d As Single)
        Function EaseSineInOut! (ByVal t As Single, Byval b As Single, Byval c As Single, Byval d As Single)
        Function EaseSineOut! (ByVal t As Single, Byval b As Single, Byval c As Single, Byval d As Single)
    End Declare
    '-------------------------------------------------------------------------------------------------------------------
$End If
'-----------------------------------------------------------------------------------------------------------------------
