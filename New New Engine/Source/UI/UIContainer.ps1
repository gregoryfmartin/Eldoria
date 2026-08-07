using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# UI CONTAINER
#
# A DERIVATION OF A LONG-STANDING LEGACY CLASS NAMED WINDOWBASE.
#
# A UI CONTAINER IS EXACTLY THAT: A CONTAINER. EXCEPT IT'S A CONTAINER IN A
# SPIRITUAL SENSE. IT DOESN'T CONFORM CHILD ELEMENTS TO ITS BOUNDARIES AND
# DOESN'T REALLY CARE ABOUT LAYING ELEMENTS OUT IN WHATEVER FASHION YOU MIGHT
# CONCEIVE. IT'S REALLY A MEANS OF PLACING A MEASURED BORDER ON THE BUFFER
# IN A SPECIFIC LOCATION.
#
# THE VERSION SHOWN HERE IS DERIVED FROM BURNT LATTE. IT EXTENDS THE ORIGINAL
# DESIGN BY ADDING SUPPORT FOR INDEPENDENT LEFT AND RIGHT BORDER CHARACTERS,
# AS WELL AS ADDING A TITLE. LEGACY DERIVED CLASSES WILL BE REQUIRED TO CHANGE
# CERTAIN INITIALIZATION PROCESSES TO FACILITATE DERIVATION FROM THIS VERSION.
#
# NEWER ADDITIONS TO THIS CODE ARE INTENDED TO ADD CORNER CHARACTERS TO THE
# SPEC. THIS IS A DERIVATIVE OF PWSHSPECTRECONSOLE (THANKS TO TRACKD FOR THIS).
# I WASN'T DOING THIS ORIGINALLY, AND IT SEEMS LIKE IT MAY GIVE A BIT OF A
# BETTER VISUAL EXPERIENCE, ESPECIALLY SINCE I MAY NOT BE ABLE TO USE SAID
# LIBRARY TO RENDER THE GAME AFTER TALKING WTIH HIM. THE BORDERS DON'T CARRY
# WITH THEM DEDICATED DIRTY FLAGS.
#
###############################################################################

Class UIContainer {
    [Int]$Width
    [Int]$Height
    [Boolean]$UseTitle
    [Boolean]$TitleDirty
    [Boolean]$ComplexTitle
    [Boolean[]]$BorderDrawDirty
    [ATCoordinates]$LeftTop
    [ATCoordinates]$RightBottom
    [TrueColor]$TitleColor
    [TrueColor[]]$BorderDrawColors
    [String]$Title

    UIContainer() {
        $this.LeftTop          = [ATCoordinatesNone]::new()
        $this.RightBottom      = [ATCoordinatesNone]::new()
        $this.BorderDrawColors = [TrueColor[]](
            [ColorLibrary]::WindowBorderColor,
            [ColorLibrary]::WindowBorderColor,
            [ColorLibrary]::WindowBorderColor,
            [ColorLibrary]::WindowBorderColor,
            [ColorLibrary]::WindowBorderColor,
            [ColorLibrary]::WindowBorderColor,
            [ColorLibrary]::WindowBorderColor,
            [ColorLibrary]::WindowBorderColor
        )
        $this.BorderDrawDirty = [Boolean[]](
            $true,
            $true,
            $true,
            $true
        )
        $this.Title        = ''
        $this.UseTitle     = $false
        $this.TitleDirty   = $false
        $this.ComplexTitle = $false
        $this.TitleColor   = [ColorLibrary]::TextColorß
    }

    [Void]UpdateDimensions() {
        $this.Width = $this.RightBottom.Column - $this.LeftTop.Column
        $this.Height = $this.RightBottom.Row - $this.LeftTop.Row
    }
}
