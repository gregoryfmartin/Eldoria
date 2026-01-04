using namespace System

Set-StrictMode -Version Latest

#//////////////////////////////////////////////////////////////////////////////
#
# GAME STATE PRIMARY
#
# SPLASH SCREEN A
#    THE FIRST SPLASH SCREEN THAT'S SHOWN TO THE PLAYER - ENTIRELY DECORATIVE.
#
# SPLASH SCREEN B
#    THE SECOND SPLASH SCREEN THAT'S SHOWN TO THE PLAYER - ENTIRELY DECORATIVE.
#
# TITLE SCREEN
#    THE TITLE SCREEN, SHOWS THE ELDORIA NAME.
#
# PLAYER SETUP SCREEN
#    SHOWS THE PLAYER SETUP PROCESS.
#
# GAME PLAY SCREEN
#    TERRIBLE NAME, THE SCREEN THE PLAYER NAVIGATES THE WORLD WITH.
#
# INVENTORY SCREEN
#    THE SCREEN THE PLAYER INTERACTS WITH THEIR ITEM INVENTORY IN.
#
# BATTLE SCREEN
#    THE SCREEN USED FOR THE BATTLE PROGRAM.
#
# PLAYER STATUS SCREEN
#    SHOWS THE STATUS OF THE PLAYER, ALLOWS EQUIPMENT CHANGING.
#
# CLEANUP
#    REMOVE GAME RESOURCES.
#
#//////////////////////////////////////////////////////////////////////////////

Enum GameStatePrimary {
    SplashScreenA
    SplashScreenB
    TitleScreen
    PlayerSetupScreen
    GamePlayScreen
    InventoryScreen
    BattleScreen
    PlayerStatusScreen
    Cleanup
}
