using namespace System

Set-StrictMode -Version Latest



###############################################################################
#
# CONSOLE COLOR 24
#
###############################################################################

Class ConsoleColor24 {
    [ValidateRange(0, 255)][Int]$Red
    [ValidateRange(0, 255)][Int]$Green
    [ValidateRange(0, 255)][Int]$Blue

    ConsoleColor24(
        [Int]$Red,
        [Int]$Green,
        [Int]$Blue
    ) {
        $this.Red   = $Red
        $this.Green = $Green
        $this.Blue  = $Blue
    }
}



###############################################################################
#
# CC APPLE BLUE DARK 24
#
# INHERITS:
#   CONSOLECOLOR24
#
###############################################################################

Class CCAppleBlueDark24 : ConsoleColor24 {
    CCAppleBlueDark24() : base(10, 132, 255) {}
}



###############################################################################
#
# CC APPLE BLUE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleBlueLight24 : ConsoleColor24 {
    CCAppleBlueLight24() : base(0, 122, 255) {}
}



###############################################################################
#
# CC APPLE BROWN DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleBrownDark24 : ConsoleColor24 {
    CCAppleBrownDark24() : base(172, 142, 104) {}
}



###############################################################################
#
# CC APPLE BROWN LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleBrownLight24 : ConsoleColor24 {
    CCAppleBrownLight24() : base(162, 132, 94) {}
}



###############################################################################
#
# CC APPLE CYAN DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleCyanDark24 : ConsoleColor24 {
    CCAppleCyanDark24() : base(100, 210, 255) {}
}



###############################################################################
#
# CC APPLE CYAN LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleCyanLight24 : ConsoleColor24 {
    CCAppleCyanLight24() : base(50, 173, 230) {}
}



###############################################################################
#
# CC APPLE GREEN DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleGreenDark24 : ConsoleColor24 {
    CCAppleGreenDark24() : base(48, 209, 88) {}
}



###############################################################################
#
# CC APPLE GREEN LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleGreenLight24 : ConsoleColor24 {
    CCAppleGreenLight24() : base(52, 199, 89) {}
}



###############################################################################
#
# CC APPLE GREY 1 DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleGrey1Dark24 : ConsoleColor24 {
    CCAppleGrey1Dark24() : base(142, 142, 147) {}
}



###############################################################################
#
# CC APPLE GREY 1 LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleGrey1Light24 : ConsoleColor24 {
    CCAppleGrey1Light24() : base(142, 142, 147) {}
}



###############################################################################
#
# CC APPLE GREY 2 DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleGrey2Dark24 : ConsoleColor24 {
    CCAppleGrey2Dark24() : base(99, 99, 102) {}
}



###############################################################################
#
# CC APPLE GREY 2 LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleGrey2Light24 : ConsoleColor24 {
    CCAppleGrey2Light24() : base(174, 174, 178) {}
}



###############################################################################
#
# CC APPLE GREY 3 DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleGrey3Dark24 : ConsoleColor24 {
    CCAppleGrey3Dark24() : base(72, 72, 74) {}
}



###############################################################################
#
# CC APPLE GREY 3 LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleGrey3Light24 : ConsoleColor24 {
    CCAppleGrey3Light24() : base(199, 199, 204) {}
}



###############################################################################
#
# CC APPLE GREY 4 DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleGrey4Dark24 : ConsoleColor24 {
    CCAppleGrey4Dark24() : base(58, 58, 60) {}
}



###############################################################################
#
# CC APPLE GREY 4 LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleGrey4Light24 : ConsoleColor24 {
    CCAppleGrey4Light24() : base(209, 209, 214) {}
}



###############################################################################
#
# CC APPLE GREY 5 DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleGrey5Dark24 : ConsoleColor24 {
    CCAppleGrey5Dark24() : base(44, 44, 46) {}
}



###############################################################################
#
# CC APPLE GREY 5 LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleGrey5Light24 : ConsoleColor24 {
    CCAppleGrey5Light24() : base(229, 229, 234) {}
}



###############################################################################
#
# CC APPLE GREY 6 DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleGrey6Dark24 : ConsoleColor24 {
    CCAppleGrey6Dark24() : base(28, 28, 30) {}
}



###############################################################################
#
# CC APPLE GREY 6 LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleGrey6Light24 : ConsoleColor24 {
    CCAppleGrey6Light24() : base(242, 242, 247) {}
}



###############################################################################
#
# CC APPLE INDIGO DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleIndigoDark24 : ConsoleColor24 {
    CCAppleIndigoDark24() : base(94, 92, 230) {}
}



###############################################################################
#
# CC APPLE INDIGO LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleIndigoLight24 : ConsoleColor24 {
    CCAppleIndigoLight24() : base(88, 86, 214) {}
}



###############################################################################
#
# CC APPLE MINT DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleMintDark24 : ConsoleColor24 {
    CCAppleMintDark24() : base(99, 230, 226) {}
}



###############################################################################
#
# CC APPLE MINT LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleMintLight24 : ConsoleColor24 {
    CCAppleMintLight24() : base(0, 199, 190) {}
}



###############################################################################
#
# CC APPLE NEUTRAL BLUE ACCESSIBLE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNBlueADark24 : ConsoleColor24 {
    CCAppleNBlueADark24() : base(64, 156, 255) {}
}



###############################################################################
#
# CC APPLE NEUTRAL BLUE ACCESSIBLE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNBlueALight24 : ConsoleColor24 {
    CCAppleNBlueALight24() : base(0, 64, 221) {}
}



###############################################################################
#
# CC APPLE NEUTRAL BLUE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNBlueDark24 : ConsoleColor24 {
    CCAppleNBlueDark24() : base(10, 132, 255) {}
}



###############################################################################
#
# CC APPLE NEUTRAL BLUE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNBlueLight24 : ConsoleColor24 {
    CCAppleNBlueLight24() : base(0, 122, 255) {}
}



###############################################################################
#
# CC APPLE NEUTRAL BROWN ACCESSIBLE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNBrownADark24 : ConsoleColor24 {
    CCAppleNBrownADark24() : base(181, 148, 105) {}
}



###############################################################################
#
# CC APPLE NEUTRAL BROWN ACCESSIBLE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNBrownALight24 : ConsoleColor24 {
    CCAppleNBrownALight24() : base(127, 101, 69) {}
}



###############################################################################
#
# CC APPLE NEUTRAL BROWN DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNBrownDark24 : ConsoleColor24 {
    CCAppleNBrownDark24() : base(172, 142, 104) {}
}



###############################################################################
#
# CC APPLE NEUTRAL BROWN LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNBrownLight24 : ConsoleColor24 {
    CCAppleNBrownLight24() : base(162, 132, 94) {}
}



###############################################################################
#
# CC APPLE NEUTRAL CYAN ACCESSIBLE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNCyanADark24 : ConsoleColor24 {
    CCAppleNCyanADark24() : base(112, 215, 255) {}
}



###############################################################################
#
# CC APPLE NEUTRAL CYAN ACCESSIBLE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNCyanALight24 : ConsoleColor24 {
    CCAppleNCyanALight24() : base(0, 113, 164) {}
}



###############################################################################
#
# CC APPLE NEUTRAL CYAN DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNCyanDark24 : ConsoleColor24 {
    CCAppleNCyanDark24() : base(100, 210, 255) {}
}



###############################################################################
#
# CC APPLE NEUTRAL CYAN LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNCyanLight24 : ConsoleColor24 {
    CCAppleNCyanLight24() : base(50, 173, 230) {}
}



###############################################################################
#
# CC APPLE NEUTRAL GREEN ACCESSIBLE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNGreenADark24 : ConsoleColor24 {
    CCAppleNGreenADark24() : base(48, 219, 91) {}
}



###############################################################################
#
# CC APPLE NEUTRAL GREEN ACCESSIBLE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNGreenALight24 : ConsoleColor24 {
    CCAppleNGreenALight24() : base(36, 138, 61) {}
}



###############################################################################
#
# CC APPLE NEUTRAL GREEN DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNGreenDark24 : ConsoleColor24 {
    CCAppleNGreenDark24() : base(48, 209, 88) {}
}



###############################################################################
#
# CC APPLE NEUTRAL GREEN LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNGreenLight24 : ConsoleColor24 {
    CCAppleNGreenLight24() : base(52, 199, 89) {}
}



###############################################################################
#
# CC APPLE NEUTRAL GREY 2 ACCESSIBLE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNGrey2ADark24 : ConsoleColor24 {
    CCAppleNGrey2ADark24() : base(124, 124, 128) {}
}



###############################################################################
#
# CC APPLE NEUTRAL GREY 2 ACCESSIBLE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNGrey2ALight24 : ConsoleColor24 {
    CCAppleNGrey2ALight24() : base(142, 142, 147) {}
}



###############################################################################
#
# CC APPLE NEUTRAL GREY 2 DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNGrey2Dark24 : ConsoleColor24 {
    CCAppleNGrey2Dark24() : base(99, 99, 102) {}
}



###############################################################################
#
# CC APPLE NEUTRAL GREY 2 LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNGrey2Light24 : ConsoleColor24 {
    CCAppleNGrey2Light24() : base(174, 174, 178) {}
}



###############################################################################
#
# CC APPLE NEUTRAL GREY 3 DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNGrey3Dark24 : ConsoleColor24 {
    CCAppleNGrey3Dark24() : base(72, 72, 74) {}
}



###############################################################################
#
# CC APPLE NEUTRAL GREY 3 LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNGrey3Light24 : ConsoleColor24 {
    CCAppleNGrey3Light24() : base(199, 199, 204) {}
}



###############################################################################
#
# CC APPLE NEUTRAL GREY 4 ACCESSIBLE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNGrey4ADark24 : ConsoleColor24 {
    CCAppleNGrey4ADark24() : base(68, 68, 70) {}
}



###############################################################################
#
# CC APPLE NEUTRAL GREY 4 ACCESSIBLE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNGrey4ALight24 : ConsoleColor24 {
    CCAppleNGrey4ALight24() : base(188, 188, 192) {}
}



###############################################################################
#
# CC APPLE NEUTRAL GREY 5 ACCESSIBLE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNGrey5ADark24 : ConsoleColor24 {
    CCAppleNGrey5ADark24() : base(54, 54, 56) {}
}



###############################################################################
#
# CC APPLE NEUTRAL GREY 5 ACCESIBLE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNGrey5ALight24 : ConsoleColor24 {
    CCAppleNGrey5ALight24() : base(216, 216, 220) {}
}



###############################################################################
#
# CC APPLE NEUTRAL GREY 5 DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNGrey5Dark24 : ConsoleColor24 {
    CCAppleNGrey5Dark24() : base(44, 44, 46) {}
}



###############################################################################
#
# CC APPLE NEUTRAL GREY 5 LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNGrey5Light24 : ConsoleColor24 {
    CCAppleNGrey5Light24() : base(229, 229, 234) {}
}



###############################################################################
#
# CC APPLE NEUTRAL GREY 6 ACCESSIBLE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNGrey6ADark24 : ConsoleColor24 {
    CCAppleNGrey6ADark24() : base(36, 36, 38) {}
}



###############################################################################
#
# CC APPLE NEUTRAL GREY 6 ACCESSIBLE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNGrey6ALight24 : ConsoleColor24 {
    CCAppleNGrey6ALight24() : base(235, 235, 240) {}
}



###############################################################################
#
# CC APPLE NEUTRAL GREY 6 DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNGrey6Dark24 : ConsoleColor24 {
    CCAppleNGrey6Dark24() : base(28, 28, 30) {}
}



###############################################################################
#
# CC APPLE NEUTRAL GREY 6 LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNGrey6Light24 : ConsoleColor24 {
    CCAppleNGrey6Light24() : base(242, 242, 247) {}
}



###############################################################################
#
# CC APPLE NEUTRAL GREY ACCESSIBLE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNGreyADark24 : ConsoleColor24 {
    CCAppleNGreyADark24() : base(174, 174, 178) {}
}



###############################################################################
#
# CC APPLE NEUTRAL GREY ACCESSIBLE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNGreyALight24 : ConsoleColor24 {
    CCAppleNGreyALight24() : base(108, 108, 112) {}
}



###############################################################################
#
# CC APPLE NEUTRAL GREY DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNGreyDark24 : ConsoleColor24 {
    CCAppleNGreyDark24() : base(142, 142, 147) {}
}



###############################################################################
#
# CC APPLE NEUTRAL GREY LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNGreyLight24 : ConsoleColor24 {
    CCAppleNGreyLight24() : base(142, 142, 147) {}
}



###############################################################################
#
# CC APPLE NEUTRAL INDIGO ACCESSIBLE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNIndigoADark24 : ConsoleColor24 {
    CCAppleNIndigoADark24() : base(125, 122, 255) {}
}



###############################################################################
#
# CC APPLE NEUTRAL INDIGO ACCESSIBLE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNIndigoALight24 : ConsoleColor24 {
    CCAppleNIndigoALight24() : base(54, 52, 163) {}
}



###############################################################################
#
# CC APPLE NEUTRAL INDIGO DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNIndigoDark24 : ConsoleColor24 {
    CCAppleNIndigoDark24() : base(94, 92, 230) {}
}



###############################################################################
#
# CC APPLE NEUTRAL INDIGO LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNIndigoLight24 : ConsoleColor24 {
    CCAppleNIndigoLight24() : base(88, 86, 214) {}
}



###############################################################################
#
# CC APPLE NEUTRAL MINT ACCESSIBLE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNMintADark24 : ConsoleColor24 {
    CCAppleNMintADark24() : base(102, 212, 207) {}
}



###############################################################################
#
# CC APPLE NEUTRAL MINT ACCESSIBLE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNMintALight24 : ConsoleColor24 {
    CCAppleNMintALight24() : base(12, 129, 123) {}
}



###############################################################################
#
# CC APPLE NEUTRAL MINT DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNMintDark24 : ConsoleColor24 {
    CCAppleNMintDark24() : base(99, 230, 226) {}
}



###############################################################################
#
# CC APPLE NEUTRAL MINT LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNMintLight24 : ConsoleColor24 {
    CCAppleNMintLight24() : base(0, 199, 190) {}
}



###############################################################################
#
# CC APPLE NEUTRAL ORANGE ACCESSIBLE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNOrangeADark24 : ConsoleColor24 {
    CCAppleNOrangeADark24() : base(255, 179, 64) {}
}



###############################################################################
#
# CC APPLE NEUTRAL ORANGE ACCESSIBLE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNOrangeALight24 : ConsoleColor24 {
    CCAppleNOrangeALight24() : base(201, 52, 0) {}
}



###############################################################################
#
# CC APPLE NEUTRAL ORANGE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNOrangeDark24 : ConsoleColor24 {
    CCAppleNOrangeDark24() : base(255, 159, 10) {}
}



###############################################################################
#
# CC APPLE NEUTRAL ORANGE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNOrangeLight24 : ConsoleColor24 {
    CCAppleNOrangeLight24() : base(255, 149, 0) {}
}



###############################################################################
#
# CC APPLE NEUTRAL PINK ACCESSIBLE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNPinkADark24 : ConsoleColor24 {
    CCAppleNPinkADark24() : base(255, 100, 130) {}
}



###############################################################################
#
# CC APPLE NEUTRAL PINK ACCESSIBLE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNPinkALight24 : ConsoleColor24 {
    CCAppleNPinkALight24() : base(211, 15, 69) {}
}



###############################################################################
#
# CC APPLE NEUTRAL PINK DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNPinkDark24 : ConsoleColor24 {
    CCAppleNPinkDark24() : base(255, 55, 95) {}
}



###############################################################################
#
# CC APPLE NEUTRAL PINK LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNPinkLight24 : ConsoleColor24 {
    CCAppleNPinkLight24() : base(255, 45, 85) {}
}



###############################################################################
#
# CC APPLE NEUTRAL PURPLE ACCESSIBLE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNPurpleADark24 : ConsoleColor24 {
    CCAppleNPurpleADark24() : base(218, 143, 255) {}
}



###############################################################################
#
# CC APPLE NEUTRAL PURPLE ACCESSIBLE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNPurpleALight24 : ConsoleColor24 {
    CCAppleNPurpleALight24() : base(137, 68, 171) {}
}



###############################################################################
#
# CC APPLE NEUTRAL PURPLE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNPurpleDark24 : ConsoleColor24 {
    CCAppleNPurpleDark24() : base(191, 90, 242) {}
}



###############################################################################
#
# CC APPLE NEUTRAL PURPLE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNPurpleLight24 : ConsoleColor24 {
    CCAppleNPurpleLight24() : base(175, 82, 222) {}
}



###############################################################################
#
# CC APPLE NEUTRAL RED ACCESSIBLE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNRedADark24 : ConsoleColor24 {
    CCAppleNRedADark24() : base(255, 105, 97) {}
}



###############################################################################
#
# CC APPLE NEUTRAL RED ACCESSIBLE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNRedALight24 : ConsoleColor24 {
    CCAppleNRedALight24() : base(215, 0, 21) {}
}



###############################################################################
#
# CC APPLE NEUTRAL RED DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNRedDark24 : ConsoleColor24 {
    CCAppleNRedDark24() : base(255, 69, 58) {}
}



###############################################################################
#
# CC APPLE NEUTRAL RED LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNRedLight24 : ConsoleColor24 {
    CCAppleNRedLight24() : base(255, 59, 48) {}
}



###############################################################################
#
# CC APPLE NEUTRAL TEAL ACCESSIBLE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNTealADark24 : ConsoleColor24 {
    CCAppleNTealADark24() : base(93, 230, 255) {}
}



###############################################################################
#
# CC APPLE NEUTRAL TEAL ACCESSIBLE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNTealALight24 : ConsoleColor24 {
    CCAppleNTealALight24() : base(0, 130, 153) {}
}



###############################################################################
#
# CC APPLE NEUTRAL TEAL DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNTealDark24 : ConsoleColor24 {
    CCAppleNTealDark24() : base(64, 200, 224) {}
}



###############################################################################
#
# CC APPLE NEUTRAL TEAL LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNTealLight24 : ConsoleColor24 {
    CCAppleNTealLight24() : base(48, 176, 199) {}
}



###############################################################################
#
# CC APPLE NEUTRAL YELLOW ACCESSIBLE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNYellowADark24 : ConsoleColor24 {
    CCAppleNYellowADark24() : base(255, 212, 38) {}
}



###############################################################################
#
# CC APPLE NEUTRAL YELLOW ACCESSIBLE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNYellowALight24 : ConsoleColor24 {
    CCAppleNYellowALight24() : base(178, 80, 0) {}
}



###############################################################################
#
# CC APPLE NEUTRAL YELLOW DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNYellowDark24 : ConsoleColor24 {
    CCAppleNYellowDark24() : base(255, 214, 10) {}
}



###############################################################################
#
# CC APPLE NEUTRAL YELLOW LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleNYellowLight24 : ConsoleColor24 {
    CCAppleNYellowLight24() : base(255, 179, 64) {}
}



###############################################################################
#
# CC APPLE ORANGE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleOrangeDark24 : ConsoleColor24 {
    CCAppleOrangeDark24() : base(255, 159, 10) {}
}



###############################################################################
#
# CC APPLE ORANGE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleOrangeLight24 : ConsoleColor24 {
    CCAppleOrangeLight24() : base(255, 149, 0) {}
}



###############################################################################
#
# CC APPLE PINK DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCApplePinkDark24 : ConsoleColor24 {
    CCApplePinkDark24() : base(255, 55, 95) {}
}



###############################################################################
#
# CC APPLE PINK LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCApplePinkLight24 : ConsoleColor24 {
    CCApplePinkLight24() : base(255, 45, 85) {}
}



###############################################################################
#
# CC APPLE PURPLE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCApplePurpleDark24 : ConsoleColor24 {
    CCApplePurpleDark24() : base(191, 90, 242) {}
}



###############################################################################
#
# CC APPLE PURPLE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCApplePurpleLight24 : ConsoleColor24 {
    CCApplePurpleLight24() : base(175, 82, 222) {}
}



###############################################################################
#
# CC APPLE RED DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleRedDark24 : ConsoleColor24 {
    CCAppleRedDark24() : base(255, 69, 58) {}
}



###############################################################################
#
# CC APPLE RED LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleRedLight24 : ConsoleColor24 {
    CCAppleRedLight24() : base(255, 59, 48) {}
}



###############################################################################
#
# CC APPLE TEAL DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleTealDark24 : ConsoleColor24 {
    CCAppleTealDark24() : base(64, 200, 224) {}
}



###############################################################################
#
# CC APPLE TEAL LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleTealLight24 : ConsoleColor24 {
    CCAppleTealLight24() : base(48, 176, 199) {}
}



###############################################################################
#
# CC APPLE VIBRANT BLUE ACCESSIBLE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVBlueADark24 : ConsoleColor24 {
    CCAppleVBlueADark24() : base(64, 156, 255) {}
}



###############################################################################
#
# CC APPLE VIBRANT BLUE ACCESSIBLE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVBlueALight24 : ConsoleColor24 {
    CCAppleVBlueALight24() : base(0, 64, 221) {}
}



###############################################################################
#
# CC APPLE VIBRANT BLUE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVBlueDark24 : ConsoleColor24 {
    CCAppleVBlueDark24() : base(20, 142, 255) {}
}



###############################################################################
#
# CC APPLE VIBRANT BLUE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVBlueLight24 : ConsoleColor24 {
    CCAppleVBlueLight24() : base(0, 122, 245) {}
}



###############################################################################
#
# CC APPLE VIBRANT BROWN ACESSIBLE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVBrownALight24 : ConsoleColor24 {
    CCAppleVBrownALight24() : base(119, 93, 59) {}
}



###############################################################################
#
# CC APPLE VIBRANT BROWN DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVBrownDark24 : ConsoleColor24 {
    CCAppleVBrownDark24() : base(182, 152, 114) {}
}



###############################################################################
#
# CC APPLE VIBRANT BROWN LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVBrownLight24 : ConsoleColor24 {
    CCAppleVBrownLight24() : base(152, 122, 84) {}
}



###############################################################################
#
# CC APPLE VIBRANT CYAN ACCESSIBLE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVCyanADark24 : ConsoleColor24 {
    CCAppleVCyanADark24() : base(112, 215, 255) {}
}



###############################################################################
#
# CC APPLE VIBRANT CYAN ACCESSIBLE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVCyanALight24 : ConsoleColor24 {
    CCAppleVCyanALight24() : base(0, 103, 150) {}
}



###############################################################################
#
# CC APPLE VIBRANT CYAN DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVCyanDark24 : ConsoleColor24 {
    CCAppleVCyanDark24() : base(90, 205, 250) {}
}



###############################################################################
#
# CC APPLE VIBRANT CYAN LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVCyanLight24 : ConsoleColor24 {
    CCAppleVCyanLight24() : base(65, 175, 220) {}
}



###############################################################################
#
# CC APPLE VIBRANT GREEN ACCESSIBLE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVGreenADark24 : ConsoleColor24 {
    CCAppleVGreenADark24() : base(49, 222, 75) {}
}



###############################################################################
#
# CC APPLE VIBRANT GREEN ACCESSIBLE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVGreenALight24 : ConsoleColor24 {
    CCAppleVGreenALight24() : base(0, 112, 24) {}
}



###############################################################################
#
# CC APPLE VIBRANT GREEN DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVGreenDark24 : ConsoleColor24 {
    CCAppleVGreenDark24() : base(60, 225, 85) {}
}



###############################################################################
#
# CC APPLE VIBRANT GREEN LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVGreenLight24 : ConsoleColor24 {
    CCAppleVGreenLight24() : base(30, 195, 55) {}
}



###############################################################################
#
# CC APPLE VIBRANT GREY ACCESSIBLE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVGreyADark24 : ConsoleColor24 {
    CCAppleVGreyADark24() : base(152, 152, 157) {}
}



###############################################################################
#
# CC APPLE VIBRANT GREY ACCESSIBLE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVGreyALight24 : ConsoleColor24 {
    CCAppleVGreyALight24() : base(97, 97, 101) {}
}



###############################################################################
#
# CC APPLE VIBRANT GREY DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVGreyDark24 : ConsoleColor24 {
    CCAppleVGreyDark24() : base(162, 162, 167) {}
}



###############################################################################
#
# CC APPLE VIBRANT GREY LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVGreyLight24 : ConsoleColor24 {
    CCAppleVGreyLight24() : base(132, 132, 137) {}
}



###############################################################################
#
# CC APPLE VIBRANT INDIGO ACCESSIBLE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVIndigoADark24 : ConsoleColor24 {
    CCAppleVIndigoADark24() : base(125, 122, 255) {}
}



###############################################################################
#
# CC APPLE VIBRANT INDIGO ACCESSIBLE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVIndigoALight24 : ConsoleColor24 {
    CCAppleVIndigoALight24() : base(54, 52, 163) {}
}



###############################################################################
#
# CC APPLE VIBRANT INDIGO DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVIndigoDark24 : ConsoleColor24 {
    CCAppleVIndigoDark24() : base(99, 97, 242) {}
}



###############################################################################
#
# CC APPLE VIBRANT INDIGO LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVIndigoLight24 : ConsoleColor24 {
    CCAppleVIndigoLight24() : base(84, 82, 204) {}
}



###############################################################################
#
# CC APPLE VIBRANT MINT ACCESSIBLE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVMintADark24 : ConsoleColor24 {
    CCAppleVMintADark24() : base(49, 222, 75) {}
}



###############################################################################
#
# CC APPLE VIBRANT MINT ACCESSIBLE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVMintALight24 : ConsoleColor24 {
    CCAppleVMintALight24() : base(11, 117, 112) {}
}



###############################################################################
#
# CC APPLE VIBRANT MINT DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVMintDark24 : ConsoleColor24 {
    CCAppleVMintDark24() : base(108, 224, 219) {}
}



###############################################################################
#
# CC APPLE VIBRANT MINT LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVMintLight24 : ConsoleColor24 {
    CCAppleVMintLight24() : base(0, 189, 180) {}
}



###############################################################################
#
# CC APPLE VIBRANT ORANGE ACCESSIBLE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVOrangeADark24 : ConsoleColor24 {
    CCAppleVOrangeADark24() : base(255, 179, 64) {}
}



###############################################################################
#
# CC APPLE VIBRANT ORANGE ACCESSIBLE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVOrangeALight24 : ConsoleColor24 {
    CCAppleVOrangeALight24() : base(173, 58, 0) {}
}



###############################################################################
#
# CC APPLE VIBRANT ORANGE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVOrangeDark24 : ConsoleColor24 {
    CCAppleVOrangeDark24() : base(255, 169, 20) {}
}



###############################################################################
#
# CC APPLE VIBRANT ORANGE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVOrangeLight24 : ConsoleColor24 {
    CCAppleVOrangeLight24() : base(245, 139, 0) {}
}



###############################################################################
#
# CC APPLE VIBRANT PINK ACCESSIBLE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVPinkADark24 : ConsoleColor24 {
    CCAppleVPinkADark24() : base(255, 58, 95) {}
}



###############################################################################
#
# CC APPLE VIBRANT PINK ACCESSIBLE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVPinkALight24 : ConsoleColor24 {
    CCAppleVPinkALight24() : base(193, 16, 50) {}
}



###############################################################################
#
# CC APPLE VIBRANT PINK DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVPinkDark24 : ConsoleColor24 {
    CCAppleVPinkDark24() : base(255, 65, 105) {}
}



###############################################################################
#
# CC APPLE VIBRANT PINK LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVPinkLight24 : ConsoleColor24 {
    CCAppleVPinkLight24() : base(245, 35, 75) {}
}



###############################################################################
#
# CC APPLE VIBRANT PURPLE ACCESSIBLE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVPurpleADark24 : ConsoleColor24 {
    CCAppleVPurpleADark24() : base(218, 143, 255) {}
}



###############################################################################
#
# CC APPLE VIBRANT PURPLE ACCESSIBLE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVPurpleALight24 : ConsoleColor24 {
    CCAppleVPurpleALight24() : base(173, 68, 171) {}
}



###############################################################################
#
# CC APPLE VIBRANT PURPLE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVPurpleDark24 : ConsoleColor24 {
    CCAppleVPurpleDark24() : base(204, 101, 255) {}
}



###############################################################################
#
# CC APPLE VIBRANT PURPLE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVPurpleLight24 : ConsoleColor24 {
    CCAppleVPurpleLight24() : base(159, 75, 201) {}
}



###############################################################################
#
# CC APPLE VIBRANT RED ACCESSIBLE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVRedADark24 : ConsoleColor24 {
    CCAppleVRedADark24() : base(255, 65, 54) {}
}



###############################################################################
#
# CC APPLE VIBRANT RED ACCESSIBLE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVRedALight24 : ConsoleColor24 {
    CCAppleVRedALight24() : base(194, 6, 24) {}
}



###############################################################################
#
# CC APPLE VIBRANT RED DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVRedDark24 : ConsoleColor24 {
    CCAppleVRedDark24() : base(255, 79, 68) {}
}



###############################################################################
#
# CC APPLE VIBRANT RED LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVRedLight24 : ConsoleColor24 {
    CCAppleVRedLight24() : base(255, 49, 38) {}
}



###############################################################################
#
# CC APPLE VIBRANT TEAL ACCESSIBLE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVTealADark24 : ConsoleColor24 {
    CCAppleVTealADark24() : base(93, 230, 255) {}
}



###############################################################################
#
# CC APPLE VIBRANT TEAL ACCESSIBLE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVTealALight24 : ConsoleColor24 {
    CCAppleVTealALight24() : base(0, 119, 140) {}
}



###############################################################################
#
# CC APPLE VIBRANT TEAL DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVTealDark24 : ConsoleColor24 {
    CCAppleVTealDark24() : base(68, 212, 237) {}
}



###############################################################################
#
# CC APPLE VIBRANT TEAL LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVTealLight24 : ConsoleColor24 {
    CCAppleVTealLight24() : base(46, 167, 189) {}
}



###############################################################################
#
# CC APPLE VIBRANT YELLOW ACCESSIBLE DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVYellowADark24 : ConsoleColor24 {
    CCAppleVYellowADark24() : base(255, 212, 38) {}
}



###############################################################################
#
# CC APPLE VIBRANT YELLOW ACCESSIBLE LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVYellowALight24 : ConsoleColor24 {
    CCAppleVYellowALight24() : base(146, 81, 0) {}
}



###############################################################################
#
# CC APPLE VIBRANT YELLOW DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVYellowDark24 : ConsoleColor24 {
    CCAppleVYellowDark24() : base(255, 224, 20) {}
}



###############################################################################
#
# CC APPLE VIBRANT YELLOW LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleVYellowLight24 : ConsoleColor24 {
    CCAppleVYellowLight24() : base(245, 194, 0) {}
}



###############################################################################
#
# CC APPLE YELLOW DARK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleYellowDark24 : ConsoleColor24 {
    CCAppleYellowDark24() : base(255, 214, 10) {}
}



###############################################################################
#
# CC APPLE YELLOW LIGHT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCAppleYellowLight24 : ConsoleColor24 {
    CCAppleYellowLight24() : base(255, 204, 0) {}
}



###############################################################################
#
# CC BLACK 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCBlack24 : ConsoleColor24 {
    CCBlack24() : base(0, 0, 0) {}
}



###############################################################################
#
# CC BLUE 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCBlue24 : ConsoleColor24 {
    CCBlue24() : base (0, 0, 255) {}
}



###############################################################################
#
# CC DARK CYAN 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCDarkCyan24 : ConsoleColor24 {
    CCDarkCyan24() : base(0, 139, 139) {}
}



###############################################################################
#
# CC DARK GREY 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCDarkGrey24 : ConsoleColor24 {
    CCDarkGrey24() : base(45, 45, 45) {}
}



###############################################################################
#
# CC DARK YELLOW 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCDarkYellow24 : ConsoleColor24 {
    CCDarkYellow24() : base(255, 204, 0) {}
}



###############################################################################
#
# CC GREEN 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCGreen24 : ConsoleColor24 {
    CCGreen24() : base(0, 255, 0) {}
}



###############################################################################
#
# CC PANTONE LIGHT GRASS GREEN 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCPantoneLightGrassGreen24 : ConsoleColor24 {
    CCPantoneLightGrassGreen24() : base(49, 70, 53) {}
}



###############################################################################
#
# CC PANTONE POTTING SOIL 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCPantonePottingSoil24 : ConsoleColor24 {
    CCPantonePottingSoil24() : base(33, 22, 18) {}
}



###############################################################################
#
# CC PANTONE SKY BLUE 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCPantoneSkyBlue24 : ConsoleColor24 {
    CCPantoneSkyBlue24() : base(54, 73, 83) {}
}



###############################################################################
#
# CC PIXEN GRASS DARK GREEN 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCPixenGrassDarkGreen24 : ConsoleColor24 {
    CCPixenGrassDarkGreen24() : base(0, 165, 0) {}
}



###############################################################################
#
# CC PIXEN GRASS LIGHT GREEN 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCPixenGrassLightGreen24 : ConsoleColor24 {
    CCPixenGrassLightGreen24() : base(0, 209, 66) {}
}



###############################################################################
#
# CC PIXEN ROAD DARK BROWN 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCPixenRoadDarkBrown24 : ConsoleColor24 {
    CCPixenRoadDarkBrown24() : base(122, 67, 0) {}
}



###############################################################################
#
# CC PIXEN SKY BLUE 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCPixenSkyBlue24 : ConsoleColor24 {
    CCPixenSkyBlue24() : base(0, 253, 255) {}
}



###############################################################################
#
# CC RANDOM 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCRandom24 : ConsoleColor24 {
    CCRandom24() : base($(Get-Random -Maximum 255 -Minimum 0), $(Get-Random -Maximum 255 -Minimum 0), $(Get-Random -Maximum 255 -Minimum 0)) {}
}



###############################################################################
#
# CC RED 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCRed24 : ConsoleColor24 {
    CCRed24() : base(255, 0, 0) {}
}



###############################################################################
#
# CC WHITE 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCWhite24 : ConsoleColor24 {
    CCWhite24() : base(255, 255, 255) {}
}



###############################################################################
#
# CC YELLOW 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCYellow24 : ConsoleColor24 {
    CCYellow24() : base(255, 255, 0) {}
}



###############################################################################
#
# CC TEXT DEFAULT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCTextDefault24 : CCAppleGrey5Light24 {}



###############################################################################
#
# CC WINDOW BORDER DEFAULT 24
#
# INHERITS:
#   CONSOLE COLOR 24
#
###############################################################################

Class CCWindowBorderDefault24 : CCTextDefault24 {}



###############################################################################
#
# CC LIST ITEM CURRENT HIGHLIGHT 24
#
# INHERITS:
#   CC APPLE N PINK LIGHT 24 -> CONSOLE COLOR 24
#
###############################################################################

Class CCListItemCurrentHighlight24 : CCAppleNPinkLight24 {}

