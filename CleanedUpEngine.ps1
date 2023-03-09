using namespace System
using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation.Host

# GAME STATE DEFINITIONS

Enum GlobalGameState {
    Initialize
    SplashScreenAStarting
    SplashScreenARunning
    SplashScreenAEnding
    SplashScreenBStarting
    SplashScreenBRunning
    SplashScreenBEnding
    TitleScreenStarting
    TitleScreenRunning
    TitleScreenEnding
    PlayerSetupScreenStarting
    PlayerSetupScreenRunning
    PlayerSetupScreenEnding
    GamePlayScreenStarting
    GamePlayScreenRunning
    GamePlayScreenEnding
    InventoryScreenStarting
    InventoryScreenRunning
    InventoryScreenEnding
    Cleanup
}

Enum GamePlayState {
    Normal
    Battle
    Shop
    Inn
    Inventory
}

Enum PlayerStatNumState {
    Normal
    Caution
    Danger
}

# PLAYER VARIABLES
[String]             $Script:PlayerName                 = ''
[Int]                $Script:PlayerCurrentHitPoints     = 0
[Int]                $Script:PlayerMaxHitPoints         = 0
[Int]                $Script:PlayerCurrentMagicPoints   = 0
[Int]                $Script:PlayerMaxMagicPoints       = 0
[Int]                $Script:PlayerCurrentGold          = 0
[Int]                $Script:PlayerMaxGold              = 0
[Single]             $Script:PlayerStatNumTCaution      = 0.6D
[Single]             $Script:PlayerStatNumTDanger       = 0.2D
[PlayerStatNumState] $Script:PlayerHitPointsState       = [PlayerStatNumState]::Normal
[PlayerStatNumState] $Script:PlayerMagicPointsState     = [PlayerStatNumState]::Normal
[ConsoleColor]       $Script:PlayerStatDrawColorName    = 9
[ConsoleColor]       $Script:PlayerStatDrawColorSafe    = 10
[ConsoleColor]       $Script:PlayerStatDrawColorCaution = 14
[ConsoleColor]       $Script:PlayerStatDrawColorDanger  = 12
[ConsoleColor]       $Script:PlayerStatDrawColorGold    = 6
[ConsoleColor]       $Script:PlayerAsideColor           = 3
[Coordinates]        $Script:PlayerMapCoordinates       = [Coordainates]::new(0, 0) # Origin coordinates apply for Maps
[List[MapTileObject]]$Script:PlayerInventory            = [List[MapTileObject]]::new()

# SCENE IMAGE VARIABLES

[Int]        $Script:SceneImageWidth      = 46
[Int]        $Script:SceneImageHeight     = 18
[Coordinates]$Script:SceneImageDrawOrigin = [Coordinates]::new(32, 2)

# STATUS WINDOW VARIABLES
[String]      $Script:UiStatusindowBorderHorizontal      = '@--~---~---~---~---@'
[String]      $Script:UiStatusWindowBorderVertical       = '|'
[ConsoleColor]$Script:UiStatusWindowBorderColor          = 15
[Int]         $Script:UiStatusWindowWidth                = 19
[Int]         $Script:UiStatusWindowHeight               = 11
[Coordinates] $Script:UiStatusWindowDrawOrigin           = [Coordinates]::new(1, 1)
[Coordinates] $Script:UiStatusWindowPlayerNameDrawOrigin = [Coordinates]::new(2, 2)
[Coordinates] $Script:UiStatusWindowPlayerHpDrawOrigin   = [Coordinates]::new(2, 4)
[Coordinates] $Script:UiStatusWindowPlayerMpDrawOrigin   = [Coordinates]::new(2, 6)
[Coordinates] $Script:UiStatusWindowPlayerGoldDrawOiring = [Coordinates]::new(2, 9)

# COMMAND WINDOW VARIABLES
[String]      $Script:UiCommandWindowBorderHorizontal = '@--~---~---~---~---@'
[String]      $Script:UiCommandWindowBorderVertical   = '|'
[String]      $Script:UiCommandWindowCmdDiv           = '``````````````````'
[String]      $Script:UiCommandWindowCmdActual        = ''
[String]      $Script:UiCommandWindowCmdBlank         = '                  '
[String]      $Script:UiCommandWindowHistStrA         = ''
[String]      $Script:UiCommandWindowHistStrB         = ''
[String]      $Script:UiCommandWindowHistStrC         = ''
[String]      $Script:UiCommandWindowHistStrD         = ''
[ConsoleColor]$Script:UiCommandWindowBorderColor      = 15
[ConsoleColor]$Script:UiCommandWindowCmdValid         = 10
[ConsoleColor]$Script:UiCommandWindowCmdErr           = 12
[ConsoleColor]$Script:UiCommandWindowBlankFgColor     = 0
[ConsoleColor]$Script:UiCommandWindowHistColA         = 15
[ConsoleColor]$Script:UiCommandWindowHistColB         = 15
[ConsoleColor]$Script:UiCommandWindowHistColC         = 15
[ConsoleColor]$Script:UiCommandWindowHistColD         = 15
[Int]         $Script:UiCommandWindowWidth            = 19
[Int]         $Script:UiCommandWindowHeight           = 7
[Coordinates] $Script:UiCommandWindowDrawOrigin       = [Coordinates]::new(1, 12)
[Coordinates] $Script:UiCommandWindowDivDrawOrigin    = [Coordinates]::new(($Script:UiCommandWindowDrawOrigin.X + 1), (($Script:UiCommandWindowDrawOrigin.Y + $Script:UiCommandWindowHeight) - 2))
[Coordinates] $Script:UiCommandWindowHistDDrawOrigin  = [Coordinates]::new(($Script:UiCommandWindowDrawOrigin.X + 1), (($Script:UiCommandWindowDrawOrigin.Y + $Script:UiCommandWindowHeight) - 3))
[Coordinates] $Script:UiCommandWindowHistCDrawOrigin  = [Coordinates]::new(($Script:UiCommandWindowDrawOrigin.X + 1), (($Script:UiCommandWindowDrawOrigin.Y + $Script:UiCommandWindowHeight) - 4))
[Coordinates] $Script:UiCommandWindowHistBDrawOrigin  = [Coordinates]::new(($Script:UiCommandWindowDrawOrigin.X + 1), (($Script:UiCommandWindowDrawOrigin.Y + $Script:UiCommandWindowHeight) - 5))
[Coordinates] $Script:UICommandWindowHistADrawOrigin  = [Coordinates]::new(($Script:UiCommandWindowDrawOrigin.X + 1), (($Script:UiCommandWindowDrawOrigin.Y + $Script:UiCommandWindowHeight) - 6))

# SCENE WINDOW VARIABLES
[String]       $Script:UiSceneWindowBorderHorizontal = '@-<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>-@'
[String]       $Script:UiSceneWindowBorderVertical   = '|'
[ConsoleColor]$Script:UiSceneWindowBorderColor       = 15
[Int]          $Script:UiSceneWindowWidth            = 50
[Int]          $Script:UiSceneWindowHeight           = 19
[Coordinates]  $Script:UiSceneWindowDrawOrigin       = [Coordinates]::new(30, 1)
