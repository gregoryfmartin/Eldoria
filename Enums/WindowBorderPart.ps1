using namespace System

Set-StrictMode -Version Latest

#//////////////////////////////////////////////////////////////////////////////
#
# WINDOW BORDER PART
#
# AN ENUMERATION INSPIRED BY SPECTRE CONSOLE AND PWSHSPECTRECONSOLE.
# THANKS TO SHAWN LAWRIE AND TRACKD!
#
# SPECIFIES THE COMPONENTS OF A WINDOW'S BORDER. EACH REFERS TO A SPECIFIC CHARACTER
# USED TO CREATE THAT PORTION.
#
#//////////////////////////////////////////////////////////////////////////////

Enum WindowBorderPart {
    LeftTop
    Top
    RightTop
    Right
    RightBottom
    Bottom
    LeftBottom
    Left
}
