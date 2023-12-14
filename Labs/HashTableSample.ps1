using namespace System
using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation.Host

[Flags()] Enum GlobalGameState {
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

$SampleStateTable = @{
    [GlobalGameState]::SplashScreenAStarting = {
        Write-Host 'Game State is Splash Screen A Starting'
    }
    
    [GlobalGameState]::SplashScreenARunning = {
        Write-Host 'Game State is Splash Screen A Running'
    }
    
    [GlobalGameState]::SplashScreenAEnding = {
        Write-Host 'Game State is Splash Screen A Ending'
    }
}

foreach($v in $SampleStateTable.Values) {
    Invoke-Command $v
}