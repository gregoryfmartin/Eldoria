#//////////////////////////////////////////////////////////////////////////////
#
# AT SCENE IMAGE STRING
#
# AN ABSTRACTION OF AT STRING INTENDED TO BE USED FOR GENERATING "IMAGES". THIS
# CLASS SHORTCUTS MOST PROPERTIES OF AT STRING AND AT STRING PREFIX EXCEPT FOR
# BACKGROUND COLOR AND COORDINATES.
#
#//////////////////////////////////////////////////////////////////////////////
Class ATSceneImageString : ATString {
    Static [String]$SceneImageBlank = ' '

    ATSceneImageString(
        [ATBackgroundColor24]$BackgroundColor,
        [ATCoordinates]$Coordinates
    ) : base() {
        $this.Prefix = [ATStringPrefix]::new(
            [ATForegroundColor24None]::new(),
            $BackgroundColor,
            [ATDecorationNone]::new(),
            $Coordinates
        )
        $this.UserData   = [ATSceneImageString]::SceneImageBlank
        $this.UseATReset = $true
    }
}
