Function New-VtSgr24FgColorString {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(0, 255)]
        [Int]$Red,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(0, 255)]
        [Int]$Green,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(0, 255)]
        [Int]$Blue
    )

    Process {
        Return "`e[38;2;$($Red);$($Green);$($Blue)m"
    }
}

Function New-VtSgr24BgColorString {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(0, 255)]
        [Int]$Red,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(0, 255)]
        [Int]$Green,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(0, 255)]
        [Int]$Blue
    )

    Process {
        Return "`e[48;2;$($Red);$($Green);$($Blue)m"
    }
}

Function New-VtSgr24ColorNoneString {
    [CmdletBinding()]
    Param()

    Process {
        Return ''
    }
}

[Hashtable]$Script:CCBlack24 = @{
    Red   = 0
    Green = 0
    Blue  = 0
}
[Hashtable]$Script:CCWhite24 = @{
    Red   = 255
    Green = 255
    Blue  = 255
}
[Hashtable]$Script:CCRed24 = @{
    Red   = 255
    Green = 0
    Blue  = 0
}
[Hashtable]$Script:CCGreen24 = @{
    Red   = 0
    Green = 255
    Blue  = 0
}
[Hashtable]$Script:CCBlue24 = @{
    Red   = 0
    Green = 0
    Blue  = 255
}
[Hashtable]$Script:CCYellow24 = @{
    Red   = 255
    Green = 255
    Blue  = 0
}
[Hashtable]$Script:CCDarkYellow24 = @{
    Red   = 255
    Green = 204
    Blue  = 0
}
[Hashtable]$Script:CCDarkCyan24 = @{
    Red   = 0
    Green = 139
    Blue  = 139
}
[Hashtable]$Script:CCDarkGrey24 = @{
    Red   = 45
    Green = 45
    Blue  = 45
}
[Hashtable]$Script:CCRandom24 = @{
    Red   = $(Get-Random -Minimum 0 -Maximum 255)
    Green = $(Get-Random -Minimum 0 -Maximum 255)
    Blue  = $(Get-Random -Minimum 0 -Maximum 255)
}
[Hashtable]$Script:CCBlack24 = @{
    Red   = 0
    Green = 0
    Blue  = 0
}
[Hashtable]$Script:CCAppleNRedLight24 = @{
    Red   = 255
    Green = 59
    Blue  = 48
}
[Hashtable]$Script:CCAppleNRedDark2424 = @{
    Red   = 255
    Green = 69
    Blue  = 58
}
[Hashtable]$Script:CCAppleNRedALight24 = @{
    Red   = 215
    Green = 0
    Blue  = 21
}
[Hashtable]$Script:CCAppleNRedADark24 = @{
    Red   = 255
    Green = 105
    Blue  = 97
}
[Hashtable]$Script:CCAppleNOrangeLight24 = @{
    Red   = 255
    Green = 149
    Blue  = 0
}
[Hashtable]$Script:CCAppleNOrangeDark24 = @{
    Red   = 255
    Green = 159
    Blue  = 10
}
[Hashtable]$Script:CCAppleNOrangeALight24 = @{
    Red   = 201
    Green = 52
    Blue  = 0
}
[Hashtable]$Script:CCAppleNOrangeADark24 = @{
    Red   = 255
    Green = 179
    Blue  = 64
}
[Hashtable]$Script:CCAppleNYellowLight24 = @{
    Red   = 255
    Green = 214
    Blue  = 10
}
[Hashtable]$Script:CCAppleNYellowDark2424 = @{
    Red   = 255
    Green = 214
    Blue  = 10
}
[Hashtable]$Script:CCAppleNYellowALight24 = @{
    Red   = 178
    Green = 80
    Blue  = 0
}
[Hashtable]$Script:CCAppleNYellowADark24 = @{
    Red   = 255
    Green = 212
    Blue  = 38
}
[Hashtable]$Script:CCAppleNGreenLight24 = @{
    Red   = 52
    Green = 199
    Blue  = 89
}
[Hashtable]$Script:CCAppleNGreenDark24 = @{
    Red   = 48
    Green = 209
    Blue  = 88
}
[Hashtable]$Script:CCAppleNGreenALight24 = @{
    Red   = 36
    Green = 138
    Blue  = 61
}
[Hashtable]$Script:CCAppleNGreenADark24 = @{
    Red   = 48
    Green = 219
    Blue  = 91
}
[Hashtable]$Script:CCAppleNMintLight24 = @{
    Red   = 0
    Green = 199
    Blue  = 190
}
[Hashtable]$Script:CCAppleNMintDark24 = @{
    Red   = 99
    Green = 230
    Blue  = 226
}
[Hashtable]$Script:CCAppleNMintALight24 = @{
    Red   = 12
    Green = 129
    Blue  = 123
}
[Hashtable]$Script:CCAppleNMintADark24 = @{
    Red   = 102
    Green = 212
    Blue  = 207
}
[Hashtable]$Script:CCAppleNTealLight24 = @{
    Red   = 48
    Green = 176
    Blue  = 199
}
[Hashtable]$Script:CCAppleNTealDark24 = @{
    Red   = 64
    Green = 200
    Blue  = 224
}
[Hashtable]$Script:CCAppleNTealALight24 = @{
    Red   = 0
    Green = 130
    Blue  = 153
}
[Hashtable]$Script:CCAppleNTealADark24 = @{
    Red   = 93
    Green = 230
    Blue  = 255
}
[Hashtable]$Script:CCAppleNCyanLight24 = @{
    Red   = 50
    Green = 173
    Blue  = 230
}
[Hashtable]$Script:CCAppleNCyanDark24 = @{
    Red   = 100
    Green = 210
    Blue  = 255
}
[Hashtable]$Script:CCAppleNCyanALight24 = @{
    Red   = 0
    Green = 113
    Blue  = 164
}
[Hashtable]$Script:CCAppleNCyanADark24 = @{
    Red   = 112
    Green = 215
    Blue  = 255
}
[Hashtable]$Script:CCAppleNBlueLight24 = @{
    Red   = 0
    Green = 122
    Blue  = 255
}
[Hashtable]$Script:CCAppleNBlueDark24 = @{
    Red   = 10
    Green = 132
    Blue  = 255
}
[Hashtable]$Script:CCAppleNBlueALight24 = @{
    Red   = 0
    Green = 64
    Blue  = 221
}
[Hashtable]$Script:CCAppleNBlueADark24 = @{
    Red   = 64
    Green = 156
    Blue  = 255
}
[Hashtable]$Script:CCAppleNIndigoLight24 = @{
    Red   = 88
    Green = 86
    Blue  = 214
}
[Hashtable]$Script:CCAppleNIndigoDark24 = @{
    Red   = 94
    Green = 92
    Blue  = 230
}
[Hashtable]$Script:CCAppleNIndigoALight24 = @{
    Red   = 54
    Green = 52
    Blue  = 163
}
[Hashtable]$Script:CCAppleNIndigoADark24 = @{
    Red   = 125
    Green = 122
    Blue  = 255
}
[Hashtable]$Script:CCAppleNPurpleLight24 = @{
    Red   = 175
    Green = 82
    Blue  = 222
}
[Hashtable]$Script:CCAppleNPurpleDark24 = @{
    Red   = 191
    Green = 90
    Blue  = 242
}
[Hashtable]$Script:CCAppleNPurpleALight24 = @{
    Red   = 137
    Green = 68
    Blue  = 171
}
[Hashtable]$Script:CCAppleNPurpleADark24 = @{
    Red   = 218
    Green = 143
    Blue  = 255
}
[Hashtable]$Script:CCAppleNPinkLight24 = @{
    Red   = 255
    Green = 45
    Blue  = 85
}
[Hashtable]$Script:CCAppleNPinkDark24 = @{
    Red   = 255
    Green = 55
    Blue  = 95
}
[Hashtable]$Script:CCAppleNPinkALight24 = @{
    Red   = 211
    Green = 15
    Blue  = 69
}
[Hashtable]$Script:CCAppleNPinkADark24 = @{
    Red   = 255
    Green = 100
    Blue  = 130
}
[Hashtable]$Script:CCAppleNBrownLight24 = @{
    Red   = 162
    Green = 132
    Blue  = 94
}
[Hashtable]$Script:CCAppleNBrownDark24 = @{
    Red   = 172
    Green = 142
    Blue  = 104
}
[Hashtable]$Script:CCAppleNBrownALight24 = @{
    Red   = 127
    Green = 101
    Blue  = 69
}
[Hashtable]$Script:CCAppleNBrownADark24 = @{
    Red   = 181
    Green = 148
    Blue  = 105
}
[Hashtable]$Script:CCAppleNGreyLight24 = @{
    Red   = 142
    Green = 142
    Blue  = 147
}
[Hashtable]$Script:CCAppleNGreyDark24 = @{
    Red   = 142
    Green = 142
    Blue  = 147
}
[Hashtable]$Script:CCAppleNGreyALight24 = @{
    Red   = 108
    Green = 108
    Blue  = 112
}
[Hashtable]$Script:CCAppleNGreyADark24 = @{
    Red   = 174
    Green = 174
    Blue  = 178
}
[Hashtable]$Script:CCAppleNGrey2Light24 = @{
    Red   = 174
    Green = 174
    Blue  = 178
}
[Hashtable]$Script:CCAppleNGrey2Dark24 = @{
    Red   = 99
    Green = 99
    Blue  = 102
}
[Hashtable]$Script:CCAppleNGrey2ALight24 = @{
    Red   = 142
    Green = 142
    Blue  = 147
}
[Hashtable]$Script:CCAppleNGrey2ADark24 = @{
    Red   = 124
    Green = 124
    Blue  = 128
}
[Hashtable]$Script:CCAppleNGrey3Light24 = @{
    Red   = 199
    Green = 199
    Blue  = 204
}
[Hashtable]$Script:CCAppleNGrey3Dark24 = @{
    Red   = 72
    Green = 72
    Blue  = 74
}
[Hashtable]$Script:CCAppleNGrey4ALight24 = @{
    Red   = 188
    Green = 188
    Blue  = 192
}
[Hashtable]$Script:CCAppleNGrey4ADark24 = @{
    Red   = 68
    Green = 68
    Blue  = 70
}
[Hashtable]$Script:CCAppleNGrey5Light24 = @{
    Red   = 229
    Green = 229
    Blue  = 234
}
[Hashtable]$Script:CCAppleNGrey5Dark24 = @{
    Red   = 44
    Green = 44
    Blue  = 46
}
[Hashtable]$Script:CCAppleNGrey5ALight24 = @{
    Red   = 216
    Green = 216
    Blue  = 220
}
[Hashtable]$Script:CCAppleNGrey5ADark24 = @{
    Red   = 54
    Green = 54
    Blue  = 56
}
[Hashtable]$Script:CCAppleNGrey6Light24 = @{
    Red   = 242
    Green = 242
    Blue  = 247
}
[Hashtable]$Script:CCAppleNGrey6Dark24 = @{
    Red   = 28
    Green = 28
    Blue  = 30
}
[Hashtable]$Script:CCAppleNGrey6ALight24 = @{
    Red   = 235
    Green = 235
    Blue  = 240
}
[Hashtable]$Script:CCAppleNGrey6ADark24 = @{
    Red   = 36
    Green = 36
    Blue  = 38
}
[Hashtable]$Script:CCAppleVRedLight24 = @{
    Red   = 255
    Green = 49
    Blue  = 38
}
[Hashtable]$Script:CCAppleVRedDark24 = @{
    Red   = 255
    Green = 79
    Blue  = 68
}
[Hashtable]$Script:CCAppleVRedALight24 = @{
    Red   = 194
    Green = 6
    Blue  = 24
}
[Hashtable]$Script:CCAppleVRedADark24 = @{
    Red   = 255
    Green = 65
    Blue  = 54
}
[Hashtable]$Script:CCAppleVOrangeLight24 = @{
    Red   = 245
    Green = 139
    Blue  = 0
}
[Hashtable]$Script:CCAppleVOrangeDark24 = @{
    Red   = 255
    Green = 169
    Blue  = 20
}
[Hashtable]$Script:CCAppleVOrangeALight24 = @{
    Red   = 173
    Green = 58
    Blue  = 0
}
[Hashtable]$Script:CCAppleVOrangeADark24 = @{
    Red   = 255
    Green = 179
    Blue  = 64
}
[Hashtable]$Script:CCAppleVYellowLight24 = @{
    Red   = 245
    Green = 194
    Blue  = 0
}
[Hashtable]$Script:CCAppleVYellowDark24 = @{
    Red   = 255
    Green = 224
    Blue  = 20
}
[Hashtable]$Script:CCAppleVYellowALight24 = @{
    Red   = 146
    Green = 81
    Blue  = 0
}
[Hashtable]$Script:CCAppleVYellowADark24 = @{
    Red   = 255
    Green = 212
    Blue  = 38
}
[Hashtable]$Script:CCAppleVGreenLight24 = @{
    Red   = 30
    Green = 195
    Blue  = 55
}
[Hashtable]$Script:CCAppleVGreenDark24 = @{
    Red   = 60
    Green = 225
    Blue  = 85
}
[Hashtable]$Script:CCAppleVGreenALight24 = @{
    Red   = 0
    Green = 112
    Blue  = 24
}
[Hashtable]$Script:CCAppleVGreenADark24 = @{
    Red   = 49
    Green = 222
    Blue  = 75
}
[Hashtable]$Script:CCAppleVMintLight24 = @{
    Red   = 0
    Green = 189
    Blue  = 180
}
[Hashtable]$Script:CCAppleVMintDark24 = @{
    Red   = 108
    Green = 224
    Blue  = 219
}
[Hashtable]$Script:CCAppleVMintALight24 = @{
    Red   = 11
    Green = 117
    Blue  = 112
}
[Hashtable]$Script:CCAppleVMintADark24 = @{
    Red   = 49
    Green = 222
    Blue  = 75
}
[Hashtable]$Script:CCAppleVTealLight24 = @{
    Red   = 46
    Green = 167
    Blue  = 189
}
[Hashtable]$Script:CCAppleVTealDark24 = @{
    Red   = 68
    Green = 212
    Blue  = 237
}
[Hashtable]$Script:CCAppleVTealALight24 = @{
    Red   = 0
    Green = 119
    Blue  = 140
}
[Hashtable]$Script:CCAppleVTealADark24 = @{
    Red   = 93
    Green = 230
    Blue  = 255
}
[Hashtable]$Script:CCAppleVCyanLight24 = @{
    Red   = 65
    Green = 175
    Blue  = 220
}
[Hashtable]$Script:CCAppleVCyanDark24 = @{
    Red   = 90
    Green = 205
    Blue  = 250
}
[Hashtable]$Script:CCAppleVCyanALight24 = @{
    Red   = 0
    Green = 103
    Blue  = 150
}
[Hashtable]$Script:CCAppleVCyanADark24 = @{
    Red   = 112
    Green = 215
    Blue  = 255
}
[Hashtable]$Script:CCAppleVBlueLight24 = @{
    Red   = 0
    Green = 122
    Blue  = 245
}
[Hashtable]$Script:CCAppleVBlueDark24 = @{
    Red   = 20
    Green = 142
    Blue  = 255
}
[Hashtable]$Script:CCAppleVBlueALight24 = @{
    Red   = 0
    Green = 64
    Blue  = 221
}
[Hashtable]$Script:CCAppleVBlueADark24 = @{
    Red   = 64
    Green = 156
    Blue  = 255
}
[Hashtable]$Script:CCAppleVIndigoLight24 = @{
    Red   = 84
    Green = 82
    Blue  = 204
}
[Hashtable]$Script:CCAppleVIndigoDark24 = @{
    Red   = 99
    Green = 97
    Blue  = 242
}
[Hashtable]$Script:CCAppleVIndigoALight24 = @{
    Red   = 54
    Green = 52
    Blue  = 163
}
[Hashtable]$Script:CCAppleVIndigoADark24 = @{
    Red   = 125
    Green = 122
    Blue  = 255
}
[Hashtable]$Script:CCAppleVPurpleLight24 = @{
    Red   = 159
    Green = 75
    Blue  = 201
}
[Hashtable]$Script:CCAppleVPurpleDark24 = @{
    Red   = 204
    Green = 101
    Blue  = 255
}
[Hashtable]$Script:CCAppleVPurpleALight24 = @{
    Red   = 173
    Green = 68
    Blue  = 171
}
[Hashtable]$Script:CCAppleVPurpleADark24 = @{
    Red   = 218
    Green = 143
    Blue  = 255
}
[Hashtable]$Script:CCAppleVPinkLight24 = @{
    Red   = 245
    Green = 35
    Blue  = 75
}
[Hashtable]$Script:CCAppleVPinkDark24 = @{
    Red   = 255
    Green = 65
    Blue  = 105
}
[Hashtable]$Script:CCAppleVPinkALight24 = @{
    Red   = 193
    Green = 16
    Blue  = 50
}
[Hashtable]$Script:CCAppleVPinkADark24 = @{
    Red   = 255
    Green = 58
    Blue  = 95
}
[Hashtable]$Script:CCAppleVBrownLight24 = @{
    Red   = 152
    Green = 122
    Blue  = 84
}
[Hashtable]$Script:CCAppleVBrownDark24 = @{
    Red   = 182
    Green = 152
    Blue  = 114
}
[Hashtable]$Script:CCAppleVBrownALight24 = @{
    Red   = 119
    Green = 93
    Blue  = 59
}
[Hashtable]$Script:CCAppleVGreyLight24 = @{
    Red   = 132
    Green = 132
    Blue  = 137
}
[Hashtable]$Script:CCAppleVGreyDark24 = @{
    Red   = 162
    Green = 162
    Blue  = 167
}
[Hashtable]$Script:CCAppleVGreyALight24 = @{
    Red   = 97
    Green = 97
    Blue  = 101
}
[Hashtable]$Script:CCAppleVGreyADark24 = @{
    Red   = 152
    Green = 152
    Blue  = 157
}
[Hashtable]$Script:CCTextDefault24 = $Script:CCAppleNGrey5Light24
[Hashtable]$Script:CCListHighlightColor24 = $Script:CCAppleNPinkLight24
