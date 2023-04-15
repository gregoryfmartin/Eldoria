using namespace System
using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation.Host

# LOGGING FILE CREATION
# [String]$Script:LogFileName = '.\Log.log'
# 'WELCOME TO THE DANGER ZONE!!!' | Out-File -FilePath $Script:LogFileName

# GLOBAL VARIABLE DEFINITIONS

Write-Progress -Activity 'Creating ''global'' variables' -Id 1 -Status 'Working' -PercentComplete -1

[LogManager]          $Script:TheLogManager            = [LogManager]::new()
[String]              $Script:OsCheckLinux             = 'OsLinux'
[String]              $Script:OsCheckMac               = 'OsMac'
[String]              $Script:OsCheckWindows           = 'OsWindows'
[String]              $Script:OsCheckUnknown           = 'OsUnknown'
[Player]              $Script:ThePlayer                = [Player]::new('Steve', 500, 500, 25, 25, 5000, 5000)
[StatusWindow]        $Script:TheStatusWindow          = [StatusWindow]::new()
[CommandWindow]       $Script:TheCommandWindow         = [CommandWindow]::new()
[SceneWindow]         $Script:TheSceneWindow           = [SceneWindow]::new()
[MessageWindow]       $Script:TheMessageWindow         = [MessageWindow]::new()
[InventoryWindow]     $Script:TheInventoryWindow       = $null
#[SceneImage]          $Script:SampleSi                 = [SceneImage]::new($null)
[ATCoordinatesDefault]$Script:DefaultCursorCoordinates = [ATCoordinatesDefault]::new()
[BufferManager]       $Script:TheBufferManager         = [BufferManager]::new()
[GameCore]            $Script:TheGameCore              = [GameCore]::new()

#[SIRandomNoise]$Script:SampleSiRandom = [SIRandomNoise]::new()

Write-Progress -Activity 'Creating ''global'' variables' -Id 1 -Status 'Complete' -PercentComplete -1

Write-Progress -Activity 'Creating Maps              ' -Id 2 -Status 'Working' -PercentComplete -1

[Map]$Script:SampleMap   = [Map]::new('Sample Map', 2, 2, $true)
[Map]$Script:CurrentMap  = $Script:SampleMap
[Map]$Script:PreviousMap = $null

Write-Progress -Activity 'Creating Maps              ' -Id 2 -Status 'Complete' -PercentComplete -1

Write-Progress -Activity 'Creating Scene Images      ' -Id 3 -Status 'Working' -PercentComplete -1

[SIFieldNorthRoad]        $Script:FieldNorthRoadImage         = [SIFieldNorthRoad]::new()
[SIFieldNorthEastRoad]    $Script:FieldNorthEastRoadImage     = [SIFieldNorthEastRoad]::new()
[SIFieldNorthWestRoad]    $Script:FieldNorthWestRoadImage     = [SIFieldNorthWestRoad]::new()
[SIFieldNorthEastWestRoad]$Script:FieldNorthEastWestRoadImage = [SIFieldNorthEastWestRoad]::new()
[SIFieldSouthRoad]        $Script:FieldSouthRoadImage         = [SIFieldSouthRoad]::new()
[SIFieldSouthEastRoad]    $Script:FieldSouthEastRoadImage     = [SIFieldSouthEastRoad]::new()
[SIFieldSouthWestRoad]    $Script:FieldSouthWestRoadImage     = [SIFieldSouthWestRoad]::new()
[SIFieldSouthEastWestRoad]$Script:FieldSouthEastWestRoadImage = [SIFieldSouthEastWestRoad]::new()

Write-Progress -Activity 'Creating ''global'' variables' -Id 1 -Completed
Write-Progress -Activity 'Creating Maps              ' -Id 2 -Completed
Write-Progress -Activity 'Creating Scene Images      ' -Id 3 -Completed

$Script:TheSceneWindow.Image = $Script:FieldNorthRoadImage

$Script:Rui = $(Get-Host).UI.RawUI

[Boolean]$Script:GpsRestoredFromInvBackup = $true

# ENUMERATION DEFINITIONS

Enum GameStatePrimary {
    SplashScreenA
    SplashScreenB
    TitleScreen
    PlayerSetupScreen
    GamePlayScreen
    InventoryScreen
    Cleanup
}

Enum GameStateSecondary {
    Normal
    Battle
    Shop
    Inn
}

Enum StatNumberState {
    Normal
    Caution
    Danger
}

Enum CommonVirtualKeyCodes {
    Escape     = 27
    LeftArrow  = 37
    RightArrow = 39
    UpArrow    = 38
    DownArrow  = 40
    A          = 65
    D          = 68
}

# COMMAND TABLE DEFINITION
$Script:TheCommandTable = @{
    'move' = {
        Param([String]$a0)

        Switch($a0) {
            { $_ -IEQ 'north' -OR $_ -IEQ 'n' } {
                #$Script:ThePlayer.MapMoveNorth()
            }
        }
    }

    'm' = {}

    'look' = {
        $Script:TheCommandWindow.UpdateCommandHistory($true)
        $Script:TheCommandWindow.InvokeLookAction()
        Return
    }

    'l' = {
        $Script:TheCommandWindow.UpdateCommandHistory($true)
        $Script:TheCommandWindow.InvokeLookAction()
        Return
    }

    'inventory' = {
        $Script:TheLogManager.WriteToLog('TheCommandTable', 'inventory', 'Entered the block')
        
        $Script:TheLogManager.WriteToLog('TheCommandTable', 'inventory', 'Calling TheCommandWindow.UpdateCommandHistory method with true as an argument.')
        $Script:TheCommandWindow.UpdateCommandHistory($true)
        
        $Script:TheLogManager.WriteToLog('TheCommandTable', 'inventory', 'Calling TheBufferManager.CopyActiveToBufferAWithWipe method.')
        $Script:TheBufferManager.CopyActiveToBufferAWithWipe()
        
        $Script:TheLogManager.WriteToLog('TheCommandTable', 'inventory', "Setting ThePreviousGlobalGameState ($($Script:ThePreviousGlobalGameState)) to TheGlobalGameState ($($Script:TheGlobalGameState)).")
        $Script:TheLogManager.WriteToLog('TheCommandTable', 'inventory', 'Setting TheGlobalGameState to InventoryScreen.')
        $Script:ThePreviousGlobalGameState = $Script:TheGlobalGameState
        $Script:TheGlobalGameState         = [GameStatePrimary]::InventoryScreen

        $Script:TheLogManager.WriteToLog('TheCommandTable', 'inventory', 'Leaving the block')
        Return
    }

    'i' = {
        $Script:TheLogManager.WriteToLog('TheCommandTable', 'i', 'Entered the block')
        
        $Script:TheLogManager.WriteToLog('TheCommandTable', 'i', 'Calling TheCommandWindow.UpdateCommandHistory method with true as an argument.')
        $Script:TheCommandWindow.UpdateCommandHistory($true)
        
        $Script:TheLogManager.WriteToLog('TheCommandTable', 'i', 'Calling TheBufferManager.CopyActiveToBufferAWithWipe method.')
        $Script:TheBufferManager.CopyActiveToBufferAWithWipe()
        
        $Script:TheLogManager.WriteToLog('TheCommandTable', 'i', "Setting ThePreviousGlobalGameState ($($Script:ThePreviousGlobalGameState)) to TheGlobalGameState ($($Script:TheGlobalGameState)).")
        $Script:TheLogManager.WriteToLog('TheCommandTable', 'i', 'Setting TheGlobalGameState to InventoryScreen.')
        $Script:ThePreviousGlobalGameState = $Script:TheGlobalGameState
        $Script:TheGlobalGameState         = [GameStatePrimary]::InventoryScreen

        $Script:TheLogManager.WriteToLog('TheCommandTable', 'i', 'Leaving the block')
        Return
    }

    'examine' = {
        Param([String]$a0)

        $Script:TheLogManager.WriteToLog('TheCommandTable', 'examine', 'Entered the block')
        
        $Script:TheLogManager.WriteToLog('TheCommandTable', 'examine', 'Because of the nature of this block, we''re just going to call the function on the Command Window.')
        $Script:TheCommandWindow.InvokeExamineAction($a0)
        
        $Script:TheLogManager.WriteToLog('TheCommandTable', 'examine', 'Leaving the block')
        Return
    }

    'exa' = {
        Param([String]$a0)

        $Script:TheLogManager.WriteToLog('TheCommandTable', 'exa', 'Entered the block')
        
        $Script:TheLogManager.WriteToLog('TheCommandTable', 'exa', 'Because of the nature of this block, we''re just going to call the function on the Command Window.')
        $Script:TheCommandWindow.InvokeExamineAction($a0)
        
        $Script:TheLogManager.WriteToLog('TheCommandTable', 'exa', 'Leaving the block')
        Return
    }

    'get' = {
        Param([String]$a0)

        $Script:TheLogManager.WriteToLog('TheCommandTable', 'get', 'Entered the block')

        $Script:TheLogManager.WriteToLog('TheCommandTable', 'get', 'Because of the nature of this block, we''re just going to call the function on the Command Window.')
        $Script:TheCommandWindow.InvokeGetAction($a0)
        
        $Script:TheLogManager.WriteToLog('TheCommandTable', 'get', 'Leaving the block')
        Return
    }

    'g' = {
        Param([String]$a0)

        $Script:TheLogManager.WriteToLog('TheCommandTable', 'g', 'Entered the block')

        $Script:TheLogManager.WriteToLog('TheCommandTable', 'g', 'Because of the nature of this block, we''re just going to call the function on the Command Window.')
        $Script:TheCommandWindow.InvokeGetAction($a0)
        
        $Script:TheLogManager.WriteToLog('TheCommandTable', 'g', 'Leaving the block')
        Return
    }

    'take' = {
        Param([String]$a0)

        $Script:TheLogManager.WriteToLog('TheCommandTable', 'take', 'Entered the block')

        $Script:TheLogManager.WriteToLog('TheCommandTable', 'take', 'Because of the nature of this block, we''re just going to call the function on the Command Window.')
        $Script:TheCommandWindow.InvokeGetAction($a0)
        
        $Script:TheLogManager.WriteToLog('TheCommandTable', 'take', 'Leaving the block')
        Return
    }

    't' = {
        Param([String]$a0)

        $Script:TheLogManager.WriteToLog('TheCommandTable', 't', 'Entered the block')

        $Script:TheLogManager.WriteToLog('TheCommandTable', 't', 'Because of the nature of this block, we''re just going to call the function on the Command Window.')
        $Script:TheCommandWindow.InvokeGetAction($a0)
        
        $Script:TheLogManager.WriteToLog('TheCommandTable', 't', 'Leaving the block')
        Return
    }

    'use' = {
        Param(
            [String]$a0,
            [String]$a1
        )

        $Script:TheLogManager.WriteToLog('TheCommandTable', 'use', 'Entered the block')
        
        $Script:TheLogManager.WriteToLog('TheCommandTable', 'use', 'Checking to see if we have the necessary parameters.')
        If($PSBoundParameters.ContainsKey('a0') -AND $PSBoundParameters.ContainsKey('a1')) {
            $Script:TheLogManager.WriteToLog('TheCommandTable', 'use', 'The necessary parameters exist. Continuing the function call.')
            $Script:TheLogManager.WriteToLog('TheCommandTable', 'use', 'Checking to see if the first item exists in the Player''s Inventory.')
            If($Script:ThePlayer.IsItemInInventory($a0)) {
                $Script:TheLogManager.WriteToLog('TheCommandTable', 'use', "$($a0) has been found in the Player's Inventory")
                $Script:TheLogManager.WriteToLog('TheCommandTable', 'use', 'Checking to see if the second item exists in the Current Map Tile''s Object Listing.')
                If($Script:CurrentMap.GetTileAtPlayerCoordinates().IsItemInTile($a1)) {
                    $Script:TheLogManager.WriteToLog('TheCommandTable', 'use', "$($a1) has been found in the Current Map Tile's Object Listing.")
                    $Script:TheLogManager.WriteToLog('TheCommandTable', 'use', 'Getting references to actuals expressed in both the Player''s Inventory and the Current Map Tile''s Object Listing.')
                    [MapTileObject]$pi = $Script:ThePlayer.GetItemReference($a0)
                    [MapTileObject]$mti = $Script:CurrentMap.GetTileAtPlayerCoordinates().GetItemReference($a1)
                    
                    $Script:TheLogManager.WriteToLog('TheCommandTable', 'use', "Checking the Item Use Filter on $($a1) to see if $($a0) is a valid item to use on it.")
                    If($mti.ValidateSourceInFilter($pi.PSTypeNames[0])) {
                        $Script:TheLogManager.WriteToLog('TheCommandTable', 'use', "Filter check has passed; $($a0) can be used on $($a1).")
                        $Script:TheLogManager.WriteToLog('TheCommandTable', 'use', 'Updating the Command History in the Command Window.')
                        $Script:TheCommandWindow.UpdateCommandHistory($true)

                        $Script:TheLogManager.WriteToLog('TheCommandTable', 'use', "Using $($a0) on $($a1).")
                        Invoke-Command $mti.Effect -ArgumentList $pi
                    } Else {
                        $Script:TheLogManager.WriteToLog('TheCommandTable', 'use', "Filter check has FAILED; $($a0) can't be used on $($a1).")
                        $Script:TheLogManager.WriteToLog('TheCommandTable', 'use', 'Updating the Command History in the Command Window.')
                        $Script:TheCommandWindow.UpdateCommandHistory($false)
                        
                        $Script:TheLogManager.WriteToLog('TheCommandTable', 'use', 'Write a message to the Message Window.')
                        $Script:TheMessageWindow.WriteMessage(
                            "Can't use a(n) $($a0) on a $($a1).",
                            [CCAppleRedDark24]::new(),
                            [ATDecoration]::new($true)
                        )
                    }
                } Else {
                    $Script:TheLogManager.WriteToLog('TheCommandTable', 'use', "$($a1) has NOT been found in the Current Map Tile's Object Listing.")
                    $Script:TheLogManager.WriteToLog('TheCommandTable', 'use', 'Checking to see if the second term is ''self''.')
                    If($a1 -IEQ 'self') {
                        $Script:TheLogManager.WriteToLog('TheCommandTable', 'use', "$($a1) is the term 'self'.")
                    } Else {
                        $Script:TheLogManager.WriteToLog('TheCommandTable', 'use', 'The second term is neither a valid map item or ''self''; this is an invalid command structure.')
                        $Script:TheLogManager.WriteToLog('TheCommandTable', 'use', 'Updating the Command History in the Command Window.')
                        $Script:TheCommandWindow.UpdateCommandHistory($false)
                        
                        $Script:TheLogManager.WriteToLog('TheCommandTable', 'use', 'Write a message to the Message Window.')
                        $Script:TheMessageWindow.WriteMessage(
                            'Whatever you typed doesn''t make any sense.',
                            [CCAppleRedDark24]::new(),
                            [ATDecoration]::new($true)
                        )
                    }
                }
            }
        } Elseif($PSBoundParameters.ContainsKey('a0') -AND (-NOT $PSBoundParameters.ContainsKey('a1'))) {
            $Script:TheLogManager.WriteToLog('TheCommandTable', 'use', 'Parameter a0 is available but a1 is NOT.')
            $Script:TheLogManager.WriteToLog('TheCommandTable', 'use', 'This is an invalid command structure error.')
            $Script:TheLogManager.WriteToLog('TheCommandTable', 'use', 'Updating the Command History in the Command Window.')
            $Script:TheCommandWindow.UpdateCommandHistory($false)
            
            $Script:TheLogManager.WriteToLog('TheCommandTable', 'use', "Checking to see if $($a0) is in the Player's Inventory.")
            If($Script:ThePlayer.IsItemInInventory($a0)) {
                $Script:TheLogManager.WriteToLog('TheCommandTable', 'use', 'It''s in the Player''s Inventory.')
                $Script:TheLogManager.WriteToLog('TheCommandTable', 'use', 'Writing a specific message to the Message Window.')
                $Script:TheMessageWindow.WriteMessage(
                    "You need to tell me what you want to use the $($a0) on.",
                    [CCAppleYellowDark24]::new(),
                    [ATDecorationNone]::new()
                )
            } Else {
                $Script:TheLogManager.WriteToLog('TheCommandTable', 'use', 'It''s not in the Player''s Inventory.')
                $Script:TheLogManager.WriteToLog('TheCommandTable', 'use', 'Writing a specific message to the Message Window.')
                $Script:TheMessageWindow.WriteMessage(
                    "I have no idea how to use a(n) $($a0).",
                    [CCAppleYellowDark24]::new(),
                    [ATDecorationNone]::new()
                )
            }
        }
    }

    'u' = {
        Param(
            [String]$a0,
            [String]$a1
        )

        $Script:TheLogManager.WriteToLog('TheCommandTable', 'u', 'Entered the block')
        
        $Script:TheLogManager.WriteToLog('TheCommandTable', 'u', 'Checking to see if we have the necessary parameters.')
        If($PSBoundParameters.ContainsKey('a0') -AND $PSBoundParameters.ContainsKey('a1')) {
            $Script:TheLogManager.WriteToLog('TheCommandTable', 'u', 'The necessary parameters exist. Continuing the function call.')
            $Script:TheLogManager.WriteToLog('TheCommandTable', 'u', 'Checking to see if the first item exists in the Player''s Inventory.')
            If($Script:ThePlayer.IsItemInInventory($a0)) {
                $Script:TheLogManager.WriteToLog('TheCommandTable', 'u', "$($a0) has been found in the Player's Inventory.")
                $Script:TheLogManager.WriteToLog('TheCommandTable', 'u', 'Checking to see if the second item exists in the Current Map Tile''s Object Listing.')
                If($Script:CurrentMap.GetTileAtPlayerCoordinates().IsItemInTile($a1)) {
                    $Script:TheLogManager.WriteToLog('TheCommandTable', 'u', "$($a1) has been found in the Current Map Tile's Object Listing.")
                    $Script:TheLogManager.WriteToLog('TheCommandTable', 'u', 'Getting references to actuals expressed in the Player''s Inventory and the Current Map Tile''s Object Listing.')
                    [MapTileObject]$pi = $Script:ThePlayer.GetItemReference($a0)
                    [MapTileObject]$mti = $Script:CurrentMap.GetTileAtPlayerCoordinates().GetItemReference($a1)
                    
                    $Script:TheLogManager.WriteToLog('TheCommandTable', 'u', "Checking the Item Use Filter on $($a1) to see if $($a0) is a valid item to use on it.")
                    If($mti.ValidateSourceInFilter($pi.PSTypeNames[0])) {
                        $Script:TheLogManager.WriteToLog('TheCommandTable', 'u', "Filter check has passed; $($a0) can be used on $($a1).")
                        $Script:TheLogManager.WriteToLog('TheCommandTable', 'u', 'Updating the Command History in the Command Window.')
                        $Script:TheCommandWindow.UpdateCommandHistory($true)

                        $Script:TheLogManager.WriteToLog('TheCommandTable', 'u', "Using $($a0) on $($a1).")
                        Invoke-Command $mti.Effect -ArgumentList $pi
                    } Else {
                        $Script:TheLogManager.WriteToLog('TheCommandTable', 'u', "Filter check has FAILED; $($a0) can't be used on $($a1).")
                        $Script:TheLogManager.WriteToLog('TheCommandTable', 'u', 'Updating the Command History in the Command Window.')
                        $Script:TheCommandWindow.UpdateCommandHistory($false)
                        
                        $Script:TheLogManager.WriteToLog('TheCommandTable', 'u', 'Write a message to the Message Window.')
                        $Script:TheMessageWindow.WriteMessage(
                            "Can't use a(n) $($a0) on a $($a1).",
                            [CCAppleRedDark24]::new(),
                            [ATDecoration]::new($true)
                        )
                    }
                } Else {
                    $Script:TheLogManager.WriteToLog('TheCommandTable', 'u', "$($a1) has NOT been found in the Current Map Tile's Object Listing.")
                    $Script:TheLogManager.WriteToLog('TheCommandTable', 'u', 'Checking to see if the second term is ''self''.')
                    If($a1 -IEQ 'self') {
                        $Script:TheLogManager.WriteToLog('TheCommandTable', 'u', "$($a1) is the term 'self'.")
                    } Else {
                        $Script:TheLogManager.WriteToLog('TheCommandTable', 'u', 'The second term is neither a valid map item or ''self''; this is an invalid command structure.')
                        $Script:TheLogManager.WriteToLog('TheCommandTable', 'u', 'Updating the Command History in the Command Window.')
                        $Script:TheCommandWindow.UpdateCommandHistory($false)
                        
                        $Script:TheLogManager.WriteToLog('TheCommandTable', 'u', 'Write a message to the Message Window.')
                        $Script:TheMessageWindow.WriteMessage(
                            'Whatever you typed doesn''t make any sense.',
                            [CCAppleRedDark24]::new(),
                            [ATDecoration]::new($true)
                        )
                    }
                }
            }
        } Elseif($PSBoundParameters.ContainsKey('a0') -AND (-NOT $PSBoundParameters.ContainsKey('a1'))) {
            $Script:TheLogManager.WriteToLog('TheCommandTable', 'u', 'Parameter a0 is available but a1 is NOT.')
            $Script:TheLogManager.WriteToLog('TheCommandTable', 'u', 'This is an invalid command structure error.')
            $Script:TheLogManager.WriteToLog('TheCommandTable', 'u', 'Updating the Command History in the Command Window.')
            $Script:TheCommandWindow.UpdateCommandHistory($false)
            
            $Script:TheLogManager.WriteToLog('TheCommandTable', 'u', "Checking to see if $($a0) is in the Player's Inventory.")
            If($Script:ThePlayer.IsItemInInventory($a0)) {
                $Script:TheLogManager.WriteToLog('TheCommandTable', 'u', 'It''s in the Player''s Inventory.')
                $Script:TheLogManager.WriteToLog('TheCommandTable', 'u', 'Writing a specific message to the Message Window.')
                $Script:TheMessageWindow.WriteMessage(
                    "You need to tell me what you want to use the $($a0) on.",
                    [CCAppleYellowDark24]::new(),
                    [ATDecorationNone]::new()
                )
            } Else {
                $Script:TheLogManager.WriteToLog('TheCommandTable', 'u', 'It''s NOT in the Player''s Inventory.')
                $Script:TheLogManager.WriteToLog('TheCommandTable', 'u', 'Writing a specific message to the Message Window.')
                $Script:TheMessageWindow.WriteMessage(
                    "I have no idea how to use a(n) $($a0).",
                    [CCAppleYellowDark24]::new(),
                    [ATDecorationNone]::new()
                )
            }
        }
    }

    'drop' = {
        Param(
            [String]$a0
        )

        $Script:TheLogManager.WriteToLog('TheCommandTable', 'drop', 'Starting the block.')

        $Script:TheLogManager.WriteToLog('TheCommandTable', 'drop', 'Checking to see if we have the correct parameters.')
        If($args.Length -GE 1) {
            $Script:TheLogManager.WriteToLog('TheCommandTable', 'drop', 'There were too many parameters given to the drop function.')
            $Script:TheLogManager.WriteToLog('TheCommandTable', 'drop', 'Update the Command History in the Command Window.')
            $Script:TheCommandWindow.UpdateCommandHistory($false)
            
            $Script:TheLogManager.WriteToLog('TheCommandTable', 'drop', 'Write a message to the Message Window.')
            $Script:TheMessageWindow.WriteMessage(
                'Can''t drop all those items at once, bruh.',
                [CCAppleYellowDark24]::new(),
                [ATDecorationNone]::new()
            )

            Return
        }
        
        If($PSBoundParameters.Count -EQ 1) {
            $Script:TheLogManager.WriteToLog('TheCommandTable', 'drop', 'We have the correct number of parameters.')
            If($PSBoundParameters.ContainsKey('a0')) {
                $Script:TheLogManager.WriteToLog('TheCommandTable', 'drop', 'First, we need to see if this item exists in the Player''s Inventory.')
                If($Script:ThePlayer.IsItemInInventory($a0)) {
                    $Script:TheLogManager.WriteToLog('TheCommandTable', 'drop', "We've found the $($a0) in the Player's Inventory.")
                    $Script:TheLogManager.WriteToLog('TheCommandTable', 'drop', "Attempting to drop the $($a0) from the Player's Inventory.")
                    If($Script:ThePlayer.RemoveItemFromInventory($a0)) {
                        $Script:TheLogManager.WriteToLog('TheCommandTable', 'drop', "The $() was successfully removed from the Player's Inventory.")
                        $Script:TheLogManager.WriteToLog('TheCommandTable', 'drop', 'Update the Command History in the Command Window.')
                        $Script:TheCommandWindow.UpdateCommandHistory($true)
                        
                        $Script:TheLogManager.WriteToLog('TheCommandTable', 'drop', 'Write a message to the Message Window.')
                        $Script:TheMessageWindow.WriteMessage(
                            "Dropped $($a0) from your inventory.",
                            [CCAppleYellowDark24]::new(),
                            [ATDecorationNone]::new()
                        )
                    } Else {
                        $Script:TheLogManager.WriteToLog('TheCommandTable', 'drop', "Although the $($a0) was found in the Player's Inventory, something happened that prevented its removal.")
                        $Script:TheLogManager.WriteToLog('TheCommandTable', 'drop', 'THIS IS A FATAL ERROR - EXITING!')
                        Exit
                    }
                } Else {
                    $Script:TheLogManager.WriteToLog('TheCommandTable', 'drop', "The $($a0) wasn't found in the Player's Inventory.")
                    $Script:TheLogManager.WriteToLog('TheCommandTable', 'drop', 'Since we can''t find it there, there''s nothing to drop.')
                    $Script:TheLogManager.WriteToLog('TheCommandTable', 'drop', 'Updating the Command History in the Command Window.')
                    $Script:TheCommandWindow.UpdateCommandHistory($false)
                    
                    $Script:TheLogManager.WriteToLog('TheCommandTable', 'drop', 'Writing a message to the Message Window.')
                    $Script:TheMessageWindow.WriteMessage(
                        "There ain't no $($a0) in your pockets gov'.",
                        [CCAppleYellowDark24]::new(),
                        [ATDecorationNone]::new()
                    )
                }
            }
        } Elseif($PSBoundParameters.Count -LE 0) {
            $Script:TheLogManager.WriteToLog('TheCommandTable', 'drop', 'There weren''t enough parameters given to the drop command.')
            $Script:TheLogManager.WriteToLog('TheCommandTable', 'drop', 'Updating the Command History in the Command Window.')
            $Script:TheCommandWindow.UpdateCommandHistory($false)
            
            $Script:TheLogManager.WriteToLog('TheCommandTable', 'drop', 'Writing a message to the Message Window.')
            $Script:TheMessageWindow.WriteMessage(
                'I don''t know what to drop...',
                [CCAppleRedDark24]::new(),
                [ATDecoration]::new($true)
            )
        }
    }
}

# GLOBAL STATE BLOCK TABLE DEFINITION
$Script:TheGlobalStateBlockTable = @{
    [GameStatePrimary]::SplashScreenA = {}

    [GameStatePrimary]::SplashScreenB = {}

    [GameStatePrimary]::TitleScreen = {}

    [GameStatePrimary]::PlayerSetupScreen = {}

    [GameStatePrimary]::GamePlayScreen = {
        $Script:TheLogManager.WriteToLog('TheGlobalStateBlockTable', '[GameStatePrimary]::GamePlayScreen', 'Starting the block.')
        
        $Script:TheLogManager.WriteToLog('TheGlobalStateBlockTable', '[GameStatePrimary]::GamePlayScreen', 'Checking to see if the Inventory Window instance isn''t null.')
        If($null -NE $Script:TheInventoryWindow) {
            $Script:TheLogManager.WriteToLog('TheGlobalStateBlockTable', '[GameStatePrimary]::GamePlayScreen', 'It isn''t null, setting to null.')
            $Script:TheInventoryWindow = $null
        } Else {
            $Script:TheLogManager.WriteToLog('TheGlobalStateBlockTable', '[GameStatePrimary]::GamePlayScreen', 'The instance is already null, skipping.')
        }

        $Script:TheLogManager.WriteToLog('TheGlobalStateBlockTable', '[GameStatePrimary]::GamePlayScreen', 'Checking to see if the GPS can be restored from a buffer backup.')
        If($Script:ThePreviousGlobalGameState -EQ [GameStatePrimary]::InventoryScreen -AND $Script:GpsRestoredFromInvBackup -EQ $false) {
            $Script:TheLogManager.WriteToLog('TheGlobalStateBlockTable', '[GameStatePrimary]::GamePlayScreen', 'GPS can be restored from a backup.')
            $Script:TheBufferManager.RestoreBufferAToActive()
            
            $Script:TheLogManager.WriteToLog('TheGlobalStateBlockTable', '[GameStatePrimary]::GamePlayScreen', 'Force all of the elements in the GPS to redraw. This is because 24-bit color information doesn''t get retained in Buffer Cell backups with the Windows API.')
            $Script:GpsRestoredFromInvBackup             = $true
            $Script:TheSceneWindow.SceneImageDirty       = $true
            $Script:TheStatusWindow.PlayerNameDrawDirty  = $true
            $Script:TheStatusWindow.PlayerHpDrawDirty    = $true
            $Script:TheStatusWindow.PlayerMpDrawDirty    = $true
            $Script:TheStatusWindow.PlayerGoldDrawDirty  = $true
            $Script:TheCommandWindow.CommandHistoryDirty = $true
            $Script:TheMessageWindow.MessageADirty       = $true
            $Script:TheMessageWindow.MessageBDirty       = $true
            $Script:TheMessageWindow.MessageCDirty       = $true

            $Script:TheLogManager.WriteToLog('TheGlobalStateBlockTable', '[GameStatePrimary]::GamePlayScreen', 'Restore the cursor visibility.')
            Write-Host "$([ATControlSequences]::CursorShow)"
        }

        $Script:TheLogManager.WriteToLog('TheGlobalStateBlockTable', '[GameStatePrimary]::GamePlayScreen', 'Calling TheStatusWindow.Draw method.')
        $Script:TheStatusWindow.Draw()
        
        $Script:TheLogManager.WriteToLog('TheGlobalStateBlockTable', '[GameStatePrimary]::GamePlayScreen', 'Calling TheCommandWindow.Draw method.')
        $Script:TheCommandWindow.Draw()
        
        $Script:TheLogManager.WriteToLog('TheGlobalStateBlockTable', '[GameStatePrimary]::GamePlayScreen', 'Calling TheSceneWindow.Draw method.')
        $Script:TheSceneWindow.Draw()
        
        $Script:TheLogManager.WriteToLog('TheGlobalStateBlockTable', '[GameStatePrimary]::GamePlayScreen', 'Calling TheMessageWindow.Draw method.')
        $Script:TheMessageWindow.Draw()
        
        $Script:TheLogManager.WriteToLog('TheGlobalStateBlockTable', '[GameStatePrimary]::GamePlayScreen', 'Calling TheCommandWindow.HandleInput method.')
        $Script:TheCommandWindow.HandleInput()
        
        $Script:TheLogManager.WriteToLog('TheGlobalStateBlockTable', '[GameStatePrimary]::GamePlayScreen', 'Leaving the block.')
    }

    [GameStatePrimary]::InventoryScreen = {
        $Script:TheLogManager.WriteToLog('TheGlobalStateBlockTable', '[GameStatePrimary]::InventoryScreen', 'Starting the block.')

        $Script:TheLogManager.WriteToLog('TheGlobalStateBlockTable', '[GameStatePrimary]::InventoryScreen', 'Checking to see if the Inventory Window instance is null.')
        If($null -EQ $Script:TheInventoryWindow) {
            $Script:TheLogManager.WriteToLog('TheGlobalStateBlockTable', '[GameStatePrimary]::InventoryScreen', 'It is - creating a new instance.')
            $Script:TheInventoryWindow = [InventoryWindow]::new()
        } Else {
            $Script:TheLogManager.WriteToLog('TheGlobalStateBlockTable', '[GameStatePrimary]::InventoryScreen', 'It isn''t, skipping.')
        }

        $Script:TheLogManager.WriteToLog('TheGlobalStateBlockTable', '[GameStatePrimary]::InventoryScreen', 'Checking to see if the GPS Buffer Backup Restore Flag is true to turn it off.')
        If($Script:GpsRestoredFromInvBackup -EQ $true) {
            $Script:TheLogManager.WriteToLog('TheGlobalStateBlockTable', '[GameStatePrimary]::InventoryScreen', 'Buffer backup was true, setting to false.')
            $Script:GpsRestoredFromInvBackup = $false
        }

        $Script:TheLogManager.WriteToLog('TheGlobalStateBlockTable', '[GameStatePrimary]::InventoryScreen', 'Calling TheInventoryWindow.Draw method.')
        $Script:TheInventoryWindow.Draw()
        
        $Script:TheLogManager.WriteToLog('TheGlobalStateBlockTable', '[GameStatePrimary]::InventoryScreen', 'Calling TheInventoryWindow.HandleInput method.')
        $Script:TheInventoryWindow.HandleInput()
        
        $Script:TheLogManager.WriteToLog('TheGlobalStateBlockTable', '[GameStatePrimary]::InventoryScreen', 'Leaving the block.')
    }

    [GameStatePrimary]::Cleanup = {}
}

[GameStatePrimary]$Script:TheGlobalGameState         = [GameStatePrimary]::GamePlayScreen
[GameStatePrimary]$Script:ThePreviousGlobalGameState = $Script:TheGlobalGameState

# CLASS DEFINITIONS

Class EmojiBank {
    Static [String]$SmileyNormal             = "`u{1F600}"
    Static [String]$SimleyRofl               = "`u{1F606}"
    Static [String]$SmileySweat              = "`u{1F605}"
    Static [String]$SmileyMelting            = "`u{1FAE0}"
    Static [String]$AffectionNormal          = "`u{1F970}"
    Static [String]$AffectionHeartEyes       = "`u{1F60D}"
    Static [String]$AffectionBlowingKiss     = "`u{1F618}"
    Static [String]$TongueNormal             = "`u{1F61B}"
    Static [String]$TongueZany               = "`u{1F92A}"
    Static [String]$HandOverMouthSmile       = "`u{1F92D}"
    Static [String]$HandOverMouth            = "`u{1FAE2}"
    Static [String]$HandPeeking              = "`u{1FAE3}"
    Static [String]$HandShush                = "`u{1F92B}"
    Static [String]$HandThinking             = "`u{1F914}"
    Static [String]$HandSalute               = "`u{1FAE1}"
    Static [String]$SkepticRaisedEyebrow     = "`u{1F928}"
    Static [String]$SkepticNeutral           = "`u{1F610}"
    Static [String]$SkepticDottedFace        = "`u{1FAE5}"
    Static [String]$SkepticSmirk             = "`u{1F60F}"
    Static [String]$SkepticUnamused          = "`u{1F612}"
    Static [String]$SkepticRollingEyes       = "`u{1F644}"
    Static [String]$SkepticExhale            = "`u{1F62E}"
    Static [String]$SleepyRelieved           = "`u{1F60C}"
    Static [String]$SleepyPensive            = "`u{1F614}"
    Static [String]$SleepySleepy             = "`u{1F62A}"
    Static [String]$SleepyDrooling           = "`u{1F924}"
    Static [String]$SleepyAsleep             = "`u{1F634}"
    Static [String]$UnwellMedicalMask        = "`u{1F637}"
    Static [String]$UnwellThermometer        = "`u{1F912}"
    Static [String]$UnwellHeadBandage        = "`u{1F915}"
    Static [String]$UnwellNausea             = "`u{1F922}"
    Static [String]$UnwellVomiting           = "`u{1F92E}"
    Static [String]$UnwellSneezing           = "`u{1F927}"
    Static [String]$UnwellFever              = "`u{1F975}"
    Static [String]$UnwellChill              = "`u{1F976}"
    Static [String]$UnwellWoozy              = "`u{1F974}"
    Static [String]$UnwellDead               = "`u{1F635}"
    Static [String]$UnwellHeadExplode        = "`u{1F92F}"
    Static [String]$HatCowboy                = "`u{1F920}"
    Static [String]$HatParty                 = "`u{1F973}"
    Static [String]$HatDisgusied             = "`u{1F978}"
    Static [String]$GlassesSunglasses        = "`u{1F60E}"
    Static [String]$GlassesNerd              = "`u{1F913}"
    Static [String]$GlassesMonocle           = "`u{1F9D0}"
    Static [String]$ConcernedConfused        = "`u{1F615}"
    Static [String]$ConcernedDiagMouth       = "`u{1FAE4}"
    Static [String]$ConcernedWorried         = "`u{1F61F}"
    Static [String]$ConcernedSlightFrown     = "`u{1F641}"
    Static [String]$ConcernedOpenMouth       = "`u{1F62E}"
    Static [String]$ConcernedHushed          = "`u{1F62F}"
    Static [String]$ConcernedAstonished      = "`u{1F632}"
    Static [String]$ConcernedFlushed         = "`u{1F633}"
    Static [String]$ConcernedPleading        = "`u{1F97A}"
    Static [String]$ConcernedHoldingTears    = "`u{1F979}"
    Static [String]$ConcernedFearful         = "`u{1F628}"
    Static [String]$ConcernedAnxious         = "`u{1F630}"
    Static [String]$ConcernedCrying          = "`u{1F622}"
    Static [String]$ConcernedWailing         = "`u{1F63D}"
    Static [String]$ConcernedScreaming       = "`u{1F631}"
    Static [String]$NegativeNoseSteam        = "`u{1F624}"
    Static [String]$NegativeEnraged          = "`u{1F621}"
    Static [String]$NegativeAngry            = "`u{1F620}"
    Static [String]$NegativeExplitive        = "`u{1F92C}"
    Static [String]$NegativeSkull            = "`u{1F480}"
    Static [String]$CostumePoop              = "`u{1F4A9}"
    Static [String]$CostumeClown             = "`u{1F921}"
    Static [String]$CostumeOgre              = "`u{1F479}"
    Static [String]$CostumeGoblin            = "`u{1F47A}"
    Static [String]$CostumeGhost             = "`u{1F47B}"
    Static [String]$CostumeAlien             = "`u{1F47D}"
    Static [String]$CostumeInvaders          = "`u{1F47E}"
    Static [String]$CostumeRobot             = "`u{1F916}"
    Static [String]$CatGrinning              = "`u{1F63A}"
    Static [String]$CatHeartEyes             = "`u{1F63B}"
    Static [String]$CatWrySmile              = "`u{1F63C}"
    Static [String]$CatCrying                = "`u{1F63F}"
    Static [String]$CatAngry                 = "`u{1F63E}"
    Static [String]$MiscLoveLetter           = "`u{1F48C}"
    Static [String]$MiscBrokenHeart          = "`u{1F494}"
    Static [String]$MiscOrangeHeart          = "`u{1F9E1}"
    Static [String]$MiscYellowHeart          = "`u{1F49B}"
    Static [String]$MiscGreenHeart           = "`u{1F49A}"
    Static [String]$MiscBlueHeart            = "`u{1F499}"
    Static [String]$MiscLightBlueHeart       = "`u{1FA75}"
    Static [String]$MiscPurpleHeart          = "`u{1F49C}"
    Static [String]$MiscBrownHeart           = "`u{1F90E}"
    Static [String]$MiscBlackHeart           = "`u{1F5A4}"
    Static [String]$MiscGreyHeart            = "`u{1FA76}"
    Static [String]$MiscWhiteHeart           = "`u{1F90D}"
    Static [String]$MiscKissMark             = "`u{1F48B}"
    Static [String]$MiscHundredPoints        = "`u{1F4AF}"
    Static [String]$MiscAngerSymbol          = "`u{1F4A2}"
    Static [String]$MiscCollisionSymbol      = "`u{1F4A5}"
    Static [String]$MiscSweatDroplets        = "`u{1F4A6}"
    Static [String]$MiscDashingAway          = "`u{1F4A8}"
    Static [String]$MiscHole                 = "`u{1F573}"
    Static [String]$MiscSpeechBubble         = "`u{1F4AC}"
    Static [String]$MiscTripleZ              = "`u{1F4A4}"
    Static [String]$PersonBaby               = "`u{1F476}"
    Static [String]$PersonChild              = "`u{1F9D2}"
    Static [String]$PersonBoy                = "`u{1F466}"
    Static [String]$PersonGirl               = "`u{1F467}"
    Static [String]$PersonPerson             = "`u{1F9D1}"
    Static [String]$PersonBlondeHair         = "`u{1F471}"
    Static [String]$PersonMan                = "`u{1F468}"
    Static [String]$PersonManBeard           = "`u{1F9D4}"
    Static [String]$PersonWoman              = "`u{1F469}"
    Static [String]$PersonOldMan             = "`u{1F474}"
    Static [String]$PersonOldWoman           = "`u{1F475}"
    Static [String]$PersonGestureFrowning    = "`u{1F64D}"
    Static [String]$PersonGesturePouting     = "`u{1F64E}"
    Static [String]$PersonGestureNo          = "`u{1F645}"
    Static [String]$PersonGestureOkay        = "`u{1F646}"
    Static [String]$PersonGestureRaiseHand   = "`u{1F64B}"
    Static [String]$PersonGestureBowing      = "`u{1F647}"
    Static [String]$PersonGestureFacepalming = "`u{1F926}"
    Static [String]$PersonGestureShrugging   = "`u{1F937}"
}

<#
Defines a 24-bit color to be used in ANSI-based terminals. Each channel is clamped to appropriate unsigned integer values.
#>
Class ConsoleColor24 {
    [ValidateRange(0, 255)][Int]$Red
    [ValidateRange(0, 255)][Int]$Green
    [ValidateRange(0, 255)][Int]$Blue
    
    ConsoleColor24(
        [Int]$Red,
        [Int]$Green,
        [Int]$Blue
    ) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', "Color values passed here are as follows: R$($Red), G$($Green), B$($Blue).")
        $this.Red   = $Red
        $this.Green = $Green
        $this.Blue  = $Blue
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }

    ConsoleColor24(
        [PSCustomObject]$JsonData
    ) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor 2', 'Entered the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor 2', 'Creating the color values from a JSON object.')
        $psoProps   = $JsonData.PSObject.Properties
        $this.Red   = [Int]$psoProps['Red'].Value
        $this.Green = [Int]$psoProps['Green'].Value
        $this.Blue  = [Int]$psoProps['Blue'].Value
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor 2', 'Leaving the constructor.')
    }
}

Class ATControlSequences {
    Static [String]$ForegroundColor24Prefix = "`e[38;2;"
    Static [String]$BackgroundColor24Prefix = "`e[48;2;"
    Static [String]$DecorationBlink         = "`e[5m"
    Static [String]$ModifierReset           = "`e[0m"
    Static [String]$CursorHide              = "`e[?25l"
    Static [String]$CursorShow              = "`e[?25h"
    
    Static [String]GenerateFG24String([ConsoleColor24]$Color) {
        $Script:TheLogManager.WriteToLog('ATControlSequences', '[Static] GenerateFG24String', 'Entered the function.')
        'ATControlSequences::GenerateFG24String - Entered the function' | Out-File -FilePath $Script:LogFileName
        Return "$([ATControlSequences]::ForegroundColor24Prefix)$($Color.Red.ToString());$($Color.Green.ToString());$($Color.Blue.ToString())m"
    }
    
    Static [String]GenerateBG24String([ConsoleColor24]$Color) {
        $Script:TheLogManager.WriteToLog('ATControlSequences', '[Static] GenerateBG24String', 'Entered the function.')
        Return "$([ATControlSequences]::BackgroundColor24Prefix)$($Color.Red.ToString());$($Color.Green.ToString());$($Color.Blue.ToString())m"
    }
    
    Static [String]GenerateCoordinateString([Int]$Row, [Int]$Column) {
        $Script:TheLogManager.WriteToLog('ATControlSequences', '[Static] GenerateCoordinateString', 'Entered the function.')
        Return "`e[$($Row.ToString());$($Column.ToString())H"
    }
}

<#
Defines an ANSI Buffer Cell Foreground Color modifier in 24-bit color. This class leverages ConsoleColor24 to accomplish this.
#>
Class ATForegroundColor24 {
    [ValidateNotNullOrEmpty()][ConsoleColor24]$Color
    
    ATForegroundColor24(
        [ConsoleColor24]$Color
    ) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
        $this.Color = $Color
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }

    ATForegroundColor24(
        [PSCustomObject]$JsonData
    ) {
        $this.Color = [ConsoleColor24]::new($JsonData)
    }
    
    [String]ToAnsiControlSequenceString() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'ToAnsiControlSequence', 'Entered the function.')
        Return [ATControlSequences]::GenerateFG24String($this.Color)
    }
}

<#
Defines an ANSI Buffer Cell Background Color modifier in 24-bit color. This class leverages ConsoleColor24 to accomplish this.
#>
Class ATBackgroundColor24 {
    [ValidateNotNullOrEmpty()][ConsoleColor24]$Color
    
    ATBackgroundColor24(
        [ConsoleColor24]$Color
    ) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
        $this.Color = $Color
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }

    ATBackgroundColor24(
        [PSObject]$JsonData
    ) {
        $this.Color = [ConsoleColor24]::new($JsonData)
    }
    
    [String]ToAnsiControlSequenceString() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'ToAnsiControlSequenceString', 'Entered the function.')
        Return [ATControlSequences]::GenerateBG24String($this.Color)
    }
}

<#
Defines a collection of potential ANSI Buffer Cell decorators.
#>
Class ATDecoration {
    [ValidateNotNullOrEmpty()][Boolean]$Blink
    
    ATDecoration(
        [Boolean]$Blink
    ) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', "Are we using the blink decoration? $($Blink)")
        $this.Blink = $Blink
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }

    ATDecoration(
        [PSObject]$JsonData
    ) {
        $psoProps = $JsonData.PSObject.Properties
        $this.Blink = [Boolean]$psoProps['Blink'].Value
    }
    
    [String]ToAnsiControlSequenceString() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'ToAnsiControlSequenceString', 'Entered the function.')
        [String]$a = ''
        
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'ToAnsiControlSequenceString', 'Are we using the blink decoration?')
        If($this.Blink) {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'ToAnsiControlSequenceString', 'Yes - adding it to the sequence.')
            $a += [ATControlSequences]::DecorationBlink
        } Else {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'ToAnsiControlSequenceString', 'No - Skipping')
        }
        
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'ToAnsiControlSequenceString', 'Leaving the function.')
        Return $a
    }
}

Class ATCoordinates {
    [ValidateNotNullOrEmpty()][Int]$Row
    [ValidateNotNullOrEmpty()][Int]$Column
    
    ATCoordinates(
        [Int]$Row,
        [Int]$Column
    ) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', "Values assigned are as follows: Row $($Row), Column $($Column).")
        $this.Row    = $Row
        $this.Column = $Column
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }
    
    ATCoordinates(
        [Coordinates]$AutomationCoordinates
    ) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor 2', 'Entered the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor 2', 'Transposing values from Automation Coordinates to ATCoordinates.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor 2', "Transposed values are X $($AutomationCoordinates.X), Y $($AutomationCoordinates.Y).")
        $this.Row    = $AutomationCoordinates.X
        $this.Column = $AutomationCoordinates.Y
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor 2', 'Leaving the constructor.')
    }

    ATCoordinates(
        [PSObject]$JsonData
    ) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor 3', 'Entered the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor 3', 'Populating the values from a JSON object.')
        $psoProps    = $JsonData.PSObject.Properties
        $this.Row    = [Int]$psoProps['Row'].Value
        $this.Column = [Int]$psoProps['Column'].Value
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor 3', 'Leaving the constructor.')
    }
    
    [String]ToAnsiControlSequenceString() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'ToAnsiControlSequenceString', 'Entered the function.')
        Return [ATControlSequences]::GenerateCoordinateString($this.Row, $this.Column)
    }

    [Coordinates]ToAutomationCoordinates() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'ToAutomationCoordinates', 'Entered the function.')
        Return [Coordinates]::new($this.Row, $this.Column)
    }
}

Class CCBlack24 : ConsoleColor24 {
    CCBlack24() : base(0, 0, 0) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCWhite24 : ConsoleColor24 {
    CCWhite24() : base(255, 255, 255) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCRed24 : ConsoleColor24 {
    CCRed24() : base(255, 0, 0) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCGreen24 : ConsoleColor24 {
    CCGreen24() : base(0, 255, 0) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCBlue24 : ConsoleColor24 {
    CCBlue24() : base (0, 0, 255) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCYellow24 : ConsoleColor24 {
    CCYellow24() : base(255, 255, 0) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCDarkYellow24 : ConsoleColor24 {
    CCDarkYellow24() : base(255, 204, 0) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCDarkCyan24 : ConsoleColor24 {
    CCDarkCyan24() : base(0, 139, 139) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCDarkGrey24 : ConsoleColor24 {
    CCDarkGrey24() : base(45, 45, 45) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCRandom24 : ConsoleColor24 {
    CCRandom24() : base($(Get-Random -Maximum 255 -Minimum 0), $(Get-Random -Maximum 255 -Minimum 0), $(Get-Random -Maximum 255 -Minimum 0)) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCAppleRedLight24 : ConsoleColor24 {
    CCAppleRedLight24(): base(255, 59, 48) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCAppleRedDark24 : ConsoleColor24 {
    CCAppleRedDark24(): base(255, 69, 58) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCAppleOrangeLight24 : ConsoleColor24 {
    CCAppleOrangeLight24(): base(255, 149, 0) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCAppleOrangeDark24 : ConsoleColor24 {
    CCAppleOrangeDark24(): base(255, 159, 10) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCAppleYellowLight24 : ConsoleColor24 {
    CCAppleYellowLight24(): base(255, 204, 0) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCAppleYellowDark24 : ConsoleColor24 {
    CCAppleYellowDark24(): base(255, 214, 10) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCAppleGreenLight24 : ConsoleColor24 {
    CCAppleGreenLight24(): base(52, 199, 89) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCAppleGreenDark24 : ConsoleColor24 {
    CCAppleGreenDark24(): base(48, 209, 88) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCAppleMintLight24 : ConsoleColor24 {
    CCAppleMintLight24(): base(0, 199, 190) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCAppleMintDark24 : ConsoleColor24 {
    CCAppleMintDark24(): base(99, 230, 226) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCAppleTealLight24 : ConsoleColor24 {
    CCAppleTealLight24(): base(48, 176, 199) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCAppleTealDark24 : ConsoleColor24 {
    CCAppleTealDark24(): base(64, 200, 224) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCAppleCyanLight24 : ConsoleColor24 {
    CCAppleCyanLight24(): base(50, 173, 230) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCAppleCyanDark24 : ConsoleColor24 {
    CCAppleCyanDark24(): base(100, 210, 255) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCAppleBlueLight24 : ConsoleColor24 {
    CCAppleBlueLight24(): base(0, 122, 255) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCAppleBlueDark24 : ConsoleColor24 {
    CCAppleBlueDark24(): base(10, 132, 255) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCAppleIndigoLight24 : ConsoleColor24 {
    CCAppleIndigoLight24(): base(88, 86, 214) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCAppleIndigoDark24 : ConsoleColor24 {
    CCAppleIndigoDark24(): base(94, 92, 230) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCApplePurpleLight24 : ConsoleColor24 {
    CCApplePurpleLight24(): base(175, 82, 222) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCApplePurpleDark24 : ConsoleColor24 {
    CCApplePurpleDark24(): base(191, 90, 242) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCApplePinkLight24 : ConsoleColor24 {
    CCApplePinkLight24(): base(255, 45, 85) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCApplePinkDark24 : ConsoleColor24 {
    CCApplePinkDark24(): base(255, 55, 95) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCAppleBrownLight24 : ConsoleColor24 {
    CCAppleBrownLight24(): base(162, 132, 94) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCAppleBrownDark24 : ConsoleColor24 {
    CCAppleBrownDark24(): base(172, 142, 104) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCAppleGrey1Light24 : ConsoleColor24 {
    CCAppleGrey1Light24(): base(142, 142, 147) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCAppleGrey1Dark24 : ConsoleColor24 {
    CCAppleGrey1Dark24(): base(142, 142, 147) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCAppleGrey2Light24 : ConsoleColor24 {
    CCAppleGrey2Light24(): base(174, 174, 178) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCAppleGrey2Dark24 : ConsoleColor24 {
    CCAppleGrey2Dark24(): base(99, 99, 102) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCAppleGrey3Light24 : ConsoleColor24 {
    CCAppleGrey3Light24(): base(199, 199, 204) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCAppleGrey3Dark24 : ConsoleColor24 {
    CCAppleGrey3Dark24(): base(72, 72, 74) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCAppleGrey4Light24 : ConsoleColor24 {
    CCAppleGrey4Light24(): base(209, 209, 214) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCAppleGrey4Dark24 : ConsoleColor24 {
    CCAppleGrey4Dark24(): base(58, 58, 60) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCAppleGrey5Light24 : ConsoleColor24 {
    CCAppleGrey5Light24(): base(229, 229, 234) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCAppleGrey5Dark24 : ConsoleColor24 {
    CCAppleGrey5Dark24(): base(44, 44, 46) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCAppleGrey6Light24 : ConsoleColor24 {
    CCAppleGrey6Light24(): base(242, 242, 247) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCAppleGrey6Dark24 : ConsoleColor24 {
    CCAppleGrey6Dark24(): base(28, 28, 30) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

# https://www.pantone.com/connect/14-4318-TCX
Class CCPantoneSkyBlue24 : ConsoleColor24 {
    CCPantoneSkyBlue24(): base(54, 73, 83) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

# https://www.pantone.com/connect/15-6322-TPX
Class CCPantoneLightGrassGreen24 : ConsoleColor24 {
    CCPantoneLightGrassGreen24(): base(49, 70, 53) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

# https://www.pantone.com/connect/19-1218-TCX
Class CCPantonePottingSoil24 : ConsoleColor24 {
    CCPantonePottingSoil24(): base(33, 22, 18) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class CCTextDefault24 : CCAppleGrey5Light24 {
    CCTextDefault24() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class ATForegroundColor24None : ATForegroundColor24 {
    ATForegroundColor24None(): base([CCBlack24]::new()) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
    
    [String]ToAnsiControlSequenceString() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'ToAnsiControlSequenceString', 'Entered the function.')
        Return ''
    }
}

Class ATBackgroundColor24None : ATBackgroundColor24 {
    ATBackgroundColor24None() : base([CCBlack24]::new()) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
    
    [String]ToAnsiControlSequenceString() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'ToAnsiControlSequenceString', 'Entered the function.')
        Return ''
    }
}

Class ATCoordinatesNone : ATCoordinates {
    ATCoordinatesNone(): base(0, 0) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
    
    [String]ToAnsiControlSequenceString() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'ToAnsiControlSequenceString', 'Entered the function.')
        Return ''
    }
}

Class ATCoordinatesDefault : ATCoordinates {
    ATCoordinatesDefault() : base(1, 18) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
}

Class ATDecorationNone : ATDecoration {
    ATDecorationNone(): base($false) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
    
    [String]ToAnsiControlSequenceString() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'ToAnsiControlSequenceString', 'Entered the function.')
        Return ''
    }
}

Class ATStringPrefix {
    [ValidateNotNullOrEmpty()][ATForegroundColor24]$ForegroundColor
    [ValidateNotNullOrEmpty()][ATBackgroundColor24]$BackgroundColor
    [ValidateNotNullOrEmpty()][ATDecoration]$Decorations
    [ValidateNotNullOrEmpty()][ATCoordinates]$Coordinates
    
    ATStringPrefix() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
        $this.ForegroundColor = [ATForegroundColor24None]::new()
        $this.BackgroundColor = [ATBackgroundColor24None]::new()
        $this.Decorations     = [ATDecorationNone]::new()
        $this.Coordinates     = [ATCoordinatesNone]::new()
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }
    
    ATStringPrefix(
        [ATForegroundColor24]$ForegroundColor,
        [ATBackgroundColor24]$BackgroundColor,
        [ATDecoration]$Decorations,
        [ATCoordinates]$Coordinates
    ) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor 2', 'Entered the constructor.')
        $this.ForegroundColor = $ForegroundColor
        $this.BackgroundColor = $BackgroundColor
        $this.Decorations     = $Decorations
        $this.Coordinates     = $Coordinates
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor 2', 'Leaving the constructor.')
    }
    
    [String]ToAnsiControlSequenceString() {
        Return "$($this.Coordinates.ToAnsiControlSequenceString())$($this.Decorations.ToAnsiControlSequenceString())$($this.ForegroundColor.ToAnsiControlSequenceString())$($this.BackgroundColor.ToAnsiControlSequenceString())"
    }
}

Class ATStringPrefixNone : ATStringPrefix {
    ATStringPrefixNone() : base() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
    
    [String]ToAnsiControlSequenceString() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'ToAnsiControlSequenceString', 'Entered the function.')
        Return ''
    }
}

Class ATString {
    [ValidateNotNullOrEmpty()][ATStringPrefix]$Prefix
    [ValidateNotNull()][String]$UserData
    [ValidateNotNullOrEmpty()][Boolean]$UseATReset
    
    ATString() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
        $this.Prefix     = [ATStringPrefixNone]::new()
        $this.UserData   = ''
        $this.UseATReset = $false
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }
    
    ATString(
        [ATStringPrefix]$Prefix,
        [String]$UserData,
        [Boolean]$UseATReset
    ) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
        $this.Prefix     = $Prefix
        $this.UserData   = $UserData
        $this.UseATReset = $UseATReset
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }
    
    [String]ToAnsiControlSequenceString() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'ToAnsiControlSequenceString', 'Entered the function.')
        [String]$a = "$($this.Prefix.ToAnsiControlSequenceString())$($this.UserData)"
        
        If($this.UseATReset) {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'ToAnsiControlSequenceString', "Are we using the reset modifier? $($this.UseATReset)")
            $a += [ATControlSequences]::ModifierReset
        }
        
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'ToAnsiControlSequenceString', 'Leaving the function.')
        Return $a
    }
}

Class ATStringNone : ATString {
    ATStringNone() : base() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }
    
    [String]ToAnsiControlSequenceString() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'ToAnsiControlSequenceString', 'Entered the function.')
        Return ''
    }
}

Class ATSceneImageString : ATString {
    Static [String]$SceneImageBlank = ' '

    ATSceneImageString(
        [ATBackgroundColor24]$BackgroundColor,
        [ATCoordinates]$Coordinates
    ): base() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
        $this.Prefix = [ATStringPrefix]::new(
            [ATForegroundColor24None]::new(),
            $BackgroundColor,
            [ATDecorationNone]::new(),
            $Coordinates
        )
        $this.UserData   = [ATSceneImageString]::SceneImageBlank
        $this.UseATReset = $true
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }
}

Class CollectionInspectionFrame {
    [Int]$Start
    [Int]$End
    [Int]$Width

    CollectionInspectionFrame(
        [Int]$Start,
        [Int]$Width
    ) {
        $this.Start = $Start
        $this.Width = $Width
        $this.End   = $this.Start + $this.Width
    }

    [Void]ShiftUp() {
        $this.Start = $this.End
        $this.End   = $this.Start + $this.Width
    }

    [Void]ShiftDown() {
        $this.Start -= $this.Width
        $this.End    = $this.Start + $this.Width
    }
}

Class Player {
    [String]$Name
    [Int]$CurrentHitPoints
    [Int]$MaxHitPoints
    [Int]$CurrentMagicPoints
    [Int]$MaxMagicPoints
    [Int]$CurrentGold
    [Int]$MaxGold
    [StatNumberState]$HitPointsState
    [StatNumberState]$MagicPointsState
    [Coordinates]$MapCoordinates
    [List[MapTileObject]]$Inventory
    
    Static [Single]$StatNumThresholdCaution         = 0.6D
    Static [Single]$StatNumThresholdDanger          = 0.2D
    Static [ConsoleColor24]$StatNameDrawColor       = [CCAppleBlueLight24]::new()
    Static [ConsoleColor24]$StatNumDrawColorSafe    = [CCAppleGreenLight24]::new()
    Static [ConsoleColor24]$StatNumDrawColorCaution = [CCAppleYellowLight24]::new()
    Static [ConsoleColor24]$StatNumDrawColorDanger  = [CCAppleRedLight24]::new()
    Static [ConsoleColor24]$StatGoldDrawColor       = [CCAppleYellowDark24]::new()
    Static [ConsoleColor24]$AsideDrawColor          = [CCAppleIndigoLight24]::new()
    
    Player(
        [String]$Name,
        [Int]$CurrentHitPoints,
        [Int]$MaxHitPoints,
        [Int]$CurrentMagicPoints,
        [Int]$MaxMagicPoints,
        [Int]$CurrentGold,
        [Int]$MaxGold
    ) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
        $this.Name               = $Name
        $this.CurrentHitPoints   = $CurrentHitPoints
        $this.MaxHitPoints       = $MaxHitPoints
        $this.CurrentMagicPoints = $CurrentMagicPoints
        $this.MaxMagicPoints     = $MaxMagicPoints
        $this.CurrentGold        = $CurrentGold
        $this.MaxGold            = $MaxGold
        $this.HitPointsState     = [StatNumberState]::Normal
        $this.MagicPointsState   = [StatNumberState]::Normal
        $this.MapCoordinates     = [Coordinates]::new(0, 0)
        $this.Inventory          = [List[MapTileObject]]::new()
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }
    
    [String]GetFormattedNameString([ATCoordinates]$Coordinates) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetFormattedNameString', 'Entered the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetFormattedNameString', "Passed in coordinates are: Row $($Coordinates.Row), Column $($Coordinates.Column)")
        [ATString]$p1 = [ATString]::new(
            [ATStringPrefix]::new(
                [Player]::StatNameDrawColor,
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                $Coordinates
            ),
            $this.Name,
            $true
        )
        
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetFormattedNameString', "Returning the following ATString: $($p1.ToAnsiControlSequenceString())")
        Return "$($p1.ToAnsiControlSequenceString())"
    }
    
    [String]GetFormattedHitPointsString([ATCoordinates]$Coordinates) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetFormattedHitPointsString', 'Entered the function.')
        [String]$a = ''
        
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetFormattedHitPointsString', 'Checking the value of HitPointsState.')
        Switch($this.HitPointsState) {
            Normal {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetFormattedHitPointsString', 'The value is Normal.')
                [ATString]$p1 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCTextDefault24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        $Coordinates
                    ),
                    'H ',
                    $false
                )
                [ATString]$p2 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [Player]::StatNumDrawColorSafe,
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    "$($this.CurrentHitPoints) `n`t",
                    $false
                )
                [ATString]$p3 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCTextDefault24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    '/ ',
                    $false
                )
                [ATString]$p4 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [Player]::StatNumDrawColorSafe,
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    "$($this.MaxHitPoints)",
                    $true
                )
                
                $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetFormattedHitPointsString', "The temporary string is now set to the following value: $($a)")
            }
            
            Caution {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetFormattedHitPointsString', 'The value is Caution.')
                [ATString]$p1 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCTextDefault24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        $Coordinates
                    ),
                    'H ',
                    $false
                )
                [ATString]$p2 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [Player]::StatNumDrawColorCaution,
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    "$($this.CurrentHitPoints) `n`t",
                    $false
                )
                [ATString]$p3 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCTextDefault24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    '/ ',
                    $false
                )
                [ATString]$p4 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [Player]::StatNumDrawColorCaution,
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    "$($this.MaxHitPoints)",
                    $true
                )
                
                $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetFormattedHitPointsString', "The temporary string is now set to the following value: $($a)")
            }
            
            Danger {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetFormattedHitPointsString', 'The value is Danger.')
                [ATString]$p1 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCTextDefault24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        $Coordinates
                    ),
                    'H ',
                    $false
                )
                [ATString]$p2 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [Player]::StatNumDrawColorDanger,
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    "$($this.CurrentHitPoints) `n`t",
                    $false
                )
                [ATString]$p3 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCTextDefault24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    '/ ',
                    $false
                )
                [ATString]$p4 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [Player]::StatNumDrawColorDanger,
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    "$($this.MaxHitPoints)",
                    $true
                )
                
                $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetFormattedHitPointsString', "The temporary string is now set to the following value: $($a)")
            }
            
            Default {}
        }
        
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetFormattedHitPointsString', "Returning the following value to the caller: $($a)")
        Return $a
    }
    
    [String]GetFormattedMagicPointsString([ATCoordinates]$Coordinates) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetFormattedMagicPointsString', 'Entering the function.')
        [String]$a = ''
        
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetFormattedMagicPointsString', 'Checking the value of MagicPointsState.')
        Switch($this.MagicPointsState) {
            Normal {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetFormattedMagicPointsString', 'The value is Normal.')
                [ATString]$p1 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCTextDefault24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        $Coordinates
                    ),
                    'M ',
                    $false
                )
                [ATString]$p2 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [Player]::StatNumDrawColorSafe,
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    "$($this.CurrentMagicPoints) `n`t",
                    $false
                )
                [ATString]$p3 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCTextDefault24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    '/ ',
                    $false
                )
                [ATString]$p4 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [Player]::StatNumDrawColorSafe,
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    "$($this.MaxMagicPoints)",
                    $true
                )
                
                $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetFormattedMagicPointsString', "The temporary string is now set to the following value: $($a)")
            }
            
            Caution {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetFormattedMagicPointsString', 'The value is Caution.')
                [ATString]$p1 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCTextDefault24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        $Coordinates
                    ),
                    'M ',
                    $false
                )
                [ATString]$p2 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [Player]::StatNumDrawColorCaution,
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    "$($this.CurrentMagicPoints) `n`t",
                    $false
                )
                [ATString]$p3 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCTextDefault24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    '/ ',
                    $false
                )
                [ATString]$p4 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [Player]::StatNumDrawColorCaution,
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    "$($this.MaxMagicPoints)",
                    $true
                )
                
                $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetFormattedMagicPointsString', "The temporary string is now set to the following value: $($a)")
            }
            
            Danger {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetFormattedMagicPointsString', 'The value is Danger.')
                [ATString]$p1 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCTextDefault24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        $Coordinates
                    ),
                    'M ',
                    $false
                )
                [ATString]$p2 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [Player]::StatNumDrawColorDanger,
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    "$($this.CurrentMagicPoints) `n`t",
                    $false
                )
                [ATString]$p3 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCTextDefault24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    '/ ',
                    $false
                )
                [ATString]$p4 = [ATString]::new(
                    [ATStringPrefix]::new(
                        [Player]::StatNumDrawColorDanger,
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinatesNone]::new()
                    ),
                    "$($this.MaxMagicPoints)",
                    $true
                )
                
                $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetFormattedMagicPointsString', "The temporary string is now set to the following value: $($a)")
            }
            
            Default {}
        }
        
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetFormattedMagicPointsString', "Returning the following value to the caller: $($a)")
        Return $a
    }
    
    [String]GetFormattedGoldString([ATCoordinates]$Coordinates) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetFormattedGoldString', 'Entering the function.')
        [ATString]$p1 = [ATString]::new(
            [ATStringPrefix]::new(
                [Player]::StatGoldDrawColor,
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                $Coordinates
            ),
            "$($this.CurrentGold)",
            $false
        )
        [ATString]$p2 = [ATString]::new(
            [ATStringPrefix]::new(
                [CCTextDefault24]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinatesNone]::new()
            ),
            'G',
            $true
        )
        
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetFormattedGoldString', "Returning the following value to the caller: $($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())")
        Return "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())"
    }
    
    [Void]TestCurrentHpState() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'TestCurrentHpState', 'Entered the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'TestCurrentHpState', 'Checking to see what the current value of CurrentHitPoints is.')
        Switch($this.CurrentHitPoints) {
            { $_ -GT ($this.MaxHitPoints * [Player]::StatNumThresholdCaution) } {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'TestCurrentHpState', 'CurrentHitPoints are greater than 60% of MaxHitPoints. Setting HitPointsState to Normal.')
                $this.HitPointsState = [StatNumberState]::Normal
            }
            
            { ($_ -GT ($this.MaxHitPoints * [Player]::StatNumThresholdDanger)) -AND ($_ -LT ($this.MaxHitPoints * [Player]::StatNumThresholdCaution)) } {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'TestCurrentHpState', 'CurrentHitPoints are greater than 20% of MaxHitPoints and less than 60% of MaxHitPoints. Setting HitPointsState to Caution.')
                $this.HitPointsState = [StatNumberState]::Caution
            }
            
            { $_ -LT ($this.MaxHitPoints * [Player]::StatNumThresholdDanger) } {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'TestCurrentHpState', 'CurrentHitPoints are less than 20% of MaxHitPoints. Setting HitPointsState to Danger.')
                $this.HitPointsState = [StatNumberState]::Danger
            }
            
            Default {}
        }
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'TestCurrentHpState', 'Leaving the function.')
    }

    [Void]TestCurrentMpState() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'TestCurrentMpState', 'Entered the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'TestCurrentMpState', 'Checking to see what the current value of CurrentMagicPoints is.')
        Switch($this.CurrentMagicPoints) {
            { $_ -GT ($this.MaxMagicPoints * [Player]::StatNumThresholdCaution) } {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'TestCurrentMpState', 'CurrentMagicPoints are greater than 60% of MaxMagicPoints. Setting MagicPointsState to Normal.')
                $this.MagicPointsState = [StatNumberState]::Normal
            }
            
            { ($_ -GT ($this.MaxMagicPoints * [Player]::StatNumThresholdDanger)) -AND ($_ -LT ($this.MaxMagicPoints * [Player]::StatNumThresholdCaution)) } {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'TestCurrentMpState', 'CurrentMagicPoints are greater than 20% of MaxMagicPoints and less than 60% of MaxMagicPoints. Setting MagicPointsState to Caution.')
                $this.MagicPointsState = [StatNumberState]::Caution
            }
            
            { $_ -LT ($this.MaxMagicPoints * [Player]::StatNumThresholdDanger) } {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'TestCurrentMpState', 'CurrentMagicPoints are less than 20% of MaxMagicPoints. Setting MagicPointsState to Danger.')
                $this.MagicPointsState = [StatNumberState]::Danger
            }
            
            Default {}
        }
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'TestCurrentMpState', 'Leaving the function.')
    }

    [Boolean]IsItemInInventory([String]$ItemName) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'IsItemInInventory', 'Entered the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'IsItemInInventory', "Checking to see if we can find a $($ItemName) in the Player's Inventory.")
        Foreach($a in $this.Inventory) {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'IsItemInInventory', "The current item being checked is $($a.Name). Does it match $($ItemName)?")
            If($a.Name -IEQ $ItemName) {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'IsItemInInventory', 'Yes - returning true to the caller.')
                Return $true
            }
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'IsItemInInventory', 'No - continuing to check more items.')
        }

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'IsItemInInventory', 'We couldn''t find the item in the Player''s Inventory. Returning false to the caller.')
        Return $false
    }

    [MapTileObject]GetItemReference([String]$ItemName) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetItemReference', 'Entered the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetItemReference', "Checking to see if we can find a $($ItemName) in the Player's Inventory.")
        Foreach($a in $this.Inventory) {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetItemReference', "The current item being checked is $($a.Name). Does it match $($ItemName)?")
            If($a.Name -IEQ $ItemName) {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetItemReference', 'Yes - returning a reference of this item to the caller.')
                Return $a
            }
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetItemReference', 'No - continuing to check more items.')
        }

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetItemReference', 'We couldn''t find the item in the Player''s Inventory. Returning null to the caller.')
        Return $null
    }

    [Boolean]RemoveItemFromInventory([String]$ItemName) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'RemoveItemFromInventory', 'Entered the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'RemoveItemFromInventory', 'Initializing the probe.')
        $c = 0

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'RemoveItemFromInventory', "Checking to see if we can find a $($ItemName) in the Player's Inventory.")
        Foreach($a in $this.Inventory) {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'RemoveItemFromInventory', "The current item being checked is $($a.Name). Does it match $($ItemName)?")
            If($a.Name -IEQ $ItemName) {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'RemoveItemFromInventory', 'Yes - removing the item from the inventory at the current probe index.')
                $this.Inventory.RemoveAt($c)
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'RemoveItemFromInventory', 'Returning true to the caller.')
                Return $true
            }
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'RemoveItemFromInventory', 'No - incrementing the probe and continuing to check more items.')
            $c++
        }

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'RemoveItemFromInventory', 'We couldn''t find the item in the Player''s Inventory. Returning false to the caller.')
        Return $false
    }

    [Void]MapMoveNorth() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'MapMoveNorth', 'Entered the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'MapMoveNorth', 'Checking the Current Map Tile to see if North is a valid exit.')
        If($Script:CurrentMap.GetTileAtPlayerCoordinates().Exits[[MapTile]::TileExitNorth] -EQ $true) {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'MapMoveNorth', 'North is a valid exit direction.')
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'MapMoveNorth', 'Checking to see if Boundary Wrap is enabled for the Current Map.')
            If($Script:CurrentMap.BoundaryWrap -EQ $true) {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'MapMoveNorth', 'Boundary Wrap is enabled.')
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'MapMoveNorth', 'Since BW is enabled, we need to see if moving North will exceed the ''natural'' north boundary to place the player back at the bottom.')
                $a = $Script:CurrentMap.MapHeight - 1
                $b = $this.MapCoordinates.Y + 1
                $c = $a % $b

                If($c -EQ $a) {
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'MapMoveNorth', 'Moving North exceeds the north boundary - wrapping to zero.')
                    $this.MapCoordinates.Y = 0
                } Else {
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'MapMoveNorth', 'Moving North doesn''t exceed the north boundary - incrementing by one.')
                    $this.MapCoordinates.Y++
                }

                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'MapMoveNorth', 'Notify TheSceneWindow about the change in the player''s position.')
                $Script:TheSceneWindow.UpdateCurrentImage($Script:CurrentMap.GetTileAtPlayerCoordinates().BackgroundImage)
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'MapMoveNorth', 'Update the Command History in the Command Window.')
                $Script:TheCommandWindow.UpdateCommandHistory($true)
                Return
            } Else {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'MapMoveNorth', 'Boundary Wrap is disabled.')
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'MapMoveNorth', 'Since BW is disabled, we need to see if moving North will exceed the ''natural'' north boundary and prohibit the player from moving further in this direction.')
                $a = $Script:CurrentMap.MapHeight - 1
                $b = $this.MapCoordinates.Y + 1
                $c = $a % $b

                If($c -EQ $a) {
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'MapMoveNorth', 'Moving North exceeds the boundary - invoking the invisible wall.')
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'MapMoveNorth', 'Update the Command History in the Command Window.')
                    $Script:TheCommandWindow.UpdateCommandHistory($true)
                    # TODO: Write a message to the Message Window that the Invisible Wall has been encountered
                } Else {
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'MapMoveNorth', 'Moving North doesn''t exceed the north boundary - increment by one.')
                    $this.MapCoordinates.Y++

                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'MapMoveNorth', 'Notify TheSceneWindow about the change in the player''s position.')
                    $Script:TheSceneWindow.UpdateCurrentImage($Script:CurrentMap.GetTileAtPlayerCoordinates().BackgroundImage)
                    
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'MapMoveNorth', 'Update the Command History in the Command Window.')
                    $Script:TheCommandWindow.UpdateCommandHistory($true)
                    Return
                }
            }
        } Else {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'MapMoveNorth', 'It''s not possible to exit the Current Map Tile from the North direction.')
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'MapMoveNorth', 'Update the Command History in the Command Window.')
            $Script:TheCommandWindow.UpdateCommandHistory($true)
            # TODO: Write a message to the Message Window that it's not possible to exit in this direction on this tile
            Return
        }
    }
}

Class SceneImage {
    Static [Int]$Width  = 48
    Static [Int]$Height = 18
    
    [ATSceneImageString[,]]$Image
    
    SceneImage() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
        $this.Image = New-Object 'ATSceneImageString[,]' ([Int32]([SceneImage]::Height)), ([Int32]([SceneImage]::Width))
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }
    
    SceneImage(
        [ATSceneImageString[,]]$Image
    ) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor 2', 'Entered the constructor.')
        $this.Image = $Image
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor 2', 'Leaving the constructor.')
    }

    [Void]CreateSceneImageATString([ATBackgroundColor24[]]$ImageColorMap) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CreateSceneImageATString', 'Entered the function.')
        For($r = 0; $r -LT [SceneImage]::Height; $r++) {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CreateSceneImageATString', "Current R iteration is $($r).")
            For($c = 0; $c -LT [SceneImage]::Width; $c++) {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CreateSceneImageATString', "Current C iteration is $($c).")
                $rf = ($r * [SceneImage]::Width) + $c
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CreateSceneImageATString', "RF has been calculated to $($rf).")
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CreateSceneImageATString', "Creating a new ATSceneImageString at Image Coordinates ($($r), $($c)) with color $($ImageColorMap[$rf]) and offset location ($(([SceneWindow]::ImageDrawRowOffset + $r)), $(([SceneWindow]::ImageDrawColumnOffset + $c))).")
                $this.Image[$r, $c] = [ATSceneImageString]::new(
                    $ImageColorMap[$rf],
                    [ATCoordinates]::new(([SceneWindow]::ImageDrawRowOffset + $r), ([SceneWindow]::ImageDrawColumnOffset + $c))
                )
            }
        }
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CreateSceneImageATString', 'Leaving the function.')
    }

    [String]ToAnsiControlSequenceString() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'ToAnsiControlSequenceString', 'Entered the function.')
        [String]$a = ''

        For($r = 0; $r -LT [SceneImage]::Height; $r++) {
            For($c = 0; $c -LT [SceneImage]::Width; $c++) {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'ToAnsiControlSequenceString', "Appending $($this.Image[$r, $c].ToAnsiControlSequenceString()) to the temporary string.")
                $a += $this.Image[$r, $c].ToAnsiControlSequenceString()
            }
        }

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CreateSceneImageATString', "Returning $($a) to the caller.")
        Return $a
    }
}

Class SIEmpty : SceneImage {
    SIEmpty(): base() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
    }

    [String]ToAnsiControlSequenceString() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'ToAnsiControlSequenceString', 'Entered the function.')
        Return ''
    }
}

Class SIInternalBase : SceneImage {
    [ATBackgroundColor24[]]$ColorMap

    SIInternalBase(): base() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', "Creating a new Color Map with the size of $([SceneImage]::Width), $([SceneImage]::Height).")
        $this.ColorMap = New-Object 'ATBackgroundColor24[]' ([Int32](([Int32]([SceneImage]::Width)) * ([Int32]([SceneImage]::Height))))
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }
}

Class SIRandomNoise : SceneImage {
    [ATBackgroundColor24[]]$ColorMap

    SIRandomNoise(): base() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', "Creating a new Color Map with the size of $([SceneImage]::Width), $([SceneImage]::Height).")
        $this.ColorMap = New-Object 'ATBackgroundColor24[]' ([Int32](([Int32]([SceneImage]::Width)) * ([Int32]([SceneImage]::Height))))

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Filling the new Color Map with CCRandom24 color instances.')
        For($a = 0; $a -LT $this.ColorMap.Count; $a++) {
            $this.ColorMap[$a] = [CCRandom24]::new()
        }

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Calling CreateSceneImageATString with the Color Map.')
        $this.CreateSceneImageATString($this.ColorMap)
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Nulling th Color Map.')
        $this.ColorMap = $null
    }
}

Class SIFieldNorthRoad : SIInternalBase {
    SIFieldNorthRoad(): base() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Updating the Progress Bar for the Scene Image Progress.')
        Write-Progress -Activity 'Creating Scene Images      ' -Id 3 -Status 'Creating SIFieldNorthRoad' -PercentComplete -1
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Filling the Color Map.')
        $this.ColorMap[0]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[1]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[2]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[3]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[4]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[5]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[6]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[7]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[8]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[9]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[10]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[11]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[12]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[13]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[14]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[15]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[16]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[17]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[18]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[19]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[20]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[21]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[22]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[23]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[24]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[25]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[26]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[27]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[28]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[29]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[30]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[31]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[32]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[33]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[34]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[35]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[36]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[37]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[38]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[39]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[40]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[41]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[42]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[43]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[44]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[45]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[46]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[47]  = [CCAppleBlueLight24]::new() # End Row 0
        $this.ColorMap[48]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[49]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[50]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[51]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[52]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[53]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[54]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[55]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[56]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[57]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[58]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[59]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[60]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[61]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[62]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[63]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[64]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[65]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[66]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[67]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[68]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[69]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[70]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[71]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[72]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[73]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[74]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[75]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[76]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[77]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[78]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[79]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[80]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[81]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[82]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[83]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[84]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[85]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[86]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[87]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[88]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[89]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[90]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[91]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[92]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[93]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[94]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[95]  = [CCAppleBlueLight24]::new() # End Row 1
        $this.ColorMap[96]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[97]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[98]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[99]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[100] = [CCAppleBlueLight24]::new()
        $this.ColorMap[101] = [CCAppleBlueLight24]::new()
        $this.ColorMap[102] = [CCAppleBlueLight24]::new()
        $this.ColorMap[103] = [CCAppleBlueLight24]::new()
        $this.ColorMap[104] = [CCAppleBlueLight24]::new()
        $this.ColorMap[105] = [CCAppleBlueLight24]::new()
        $this.ColorMap[106] = [CCAppleBlueLight24]::new()
        $this.ColorMap[107] = [CCAppleBlueLight24]::new()
        $this.ColorMap[108] = [CCAppleBlueLight24]::new()
        $this.ColorMap[109] = [CCAppleBlueLight24]::new()
        $this.ColorMap[110] = [CCAppleBlueLight24]::new()
        $this.ColorMap[111] = [CCAppleBlueLight24]::new()
        $this.ColorMap[112] = [CCAppleBlueLight24]::new()
        $this.ColorMap[113] = [CCAppleBlueLight24]::new()
        $this.ColorMap[114] = [CCAppleBlueLight24]::new()
        $this.ColorMap[115] = [CCAppleBlueLight24]::new()
        $this.ColorMap[116] = [CCAppleBlueLight24]::new()
        $this.ColorMap[117] = [CCAppleBlueLight24]::new()
        $this.ColorMap[118] = [CCAppleBlueLight24]::new()
        $this.ColorMap[119] = [CCAppleBlueLight24]::new()
        $this.ColorMap[120] = [CCAppleBlueLight24]::new()
        $this.ColorMap[121] = [CCAppleBlueLight24]::new()
        $this.ColorMap[122] = [CCAppleBlueLight24]::new()
        $this.ColorMap[123] = [CCAppleBlueLight24]::new()
        $this.ColorMap[124] = [CCAppleBlueLight24]::new()
        $this.ColorMap[125] = [CCAppleBlueLight24]::new()
        $this.ColorMap[126] = [CCAppleBlueLight24]::new()
        $this.ColorMap[127] = [CCAppleBlueLight24]::new()
        $this.ColorMap[128] = [CCAppleBlueLight24]::new()
        $this.ColorMap[129] = [CCAppleBlueLight24]::new()
        $this.ColorMap[130] = [CCAppleBlueLight24]::new()
        $this.ColorMap[131] = [CCAppleBlueLight24]::new()
        $this.ColorMap[132] = [CCAppleBlueLight24]::new()
        $this.ColorMap[133] = [CCAppleBlueLight24]::new()
        $this.ColorMap[134] = [CCAppleBlueLight24]::new()
        $this.ColorMap[135] = [CCAppleBlueLight24]::new()
        $this.ColorMap[136] = [CCAppleBlueLight24]::new()
        $this.ColorMap[137] = [CCAppleBlueLight24]::new()
        $this.ColorMap[138] = [CCAppleBlueLight24]::new()
        $this.ColorMap[139] = [CCAppleBlueLight24]::new()
        $this.ColorMap[140] = [CCAppleBlueLight24]::new()
        $this.ColorMap[141] = [CCAppleBlueLight24]::new()
        $this.ColorMap[142] = [CCAppleBlueLight24]::new()
        $this.ColorMap[143] = [CCAppleBlueLight24]::new() # End Row 2
        $this.ColorMap[144] = [CCAppleBlueLight24]::new()
        $this.ColorMap[145] = [CCAppleBlueLight24]::new()
        $this.ColorMap[146] = [CCAppleBlueLight24]::new()
        $this.ColorMap[147] = [CCAppleBlueLight24]::new()
        $this.ColorMap[148] = [CCAppleBlueLight24]::new()
        $this.ColorMap[149] = [CCAppleBlueLight24]::new()
        $this.ColorMap[150] = [CCAppleBlueLight24]::new()
        $this.ColorMap[151] = [CCAppleBlueLight24]::new()
        $this.ColorMap[152] = [CCAppleBlueLight24]::new()
        $this.ColorMap[153] = [CCAppleBlueLight24]::new()
        $this.ColorMap[154] = [CCAppleBlueLight24]::new()
        $this.ColorMap[155] = [CCAppleBlueLight24]::new()
        $this.ColorMap[156] = [CCAppleBlueLight24]::new()
        $this.ColorMap[157] = [CCAppleBlueLight24]::new()
        $this.ColorMap[158] = [CCAppleBlueLight24]::new()
        $this.ColorMap[159] = [CCAppleBlueLight24]::new()
        $this.ColorMap[160] = [CCAppleBlueLight24]::new()
        $this.ColorMap[161] = [CCAppleBlueLight24]::new()
        $this.ColorMap[162] = [CCAppleBlueLight24]::new()
        $this.ColorMap[163] = [CCAppleBlueLight24]::new()
        $this.ColorMap[164] = [CCAppleBlueLight24]::new()
        $this.ColorMap[165] = [CCAppleBlueLight24]::new()
        $this.ColorMap[166] = [CCAppleBlueLight24]::new()
        $this.ColorMap[167] = [CCAppleBlueLight24]::new()
        $this.ColorMap[168] = [CCAppleBlueLight24]::new()
        $this.ColorMap[169] = [CCAppleBlueLight24]::new()
        $this.ColorMap[170] = [CCAppleBlueLight24]::new()
        $this.ColorMap[171] = [CCAppleBlueLight24]::new()
        $this.ColorMap[172] = [CCAppleBlueLight24]::new()
        $this.ColorMap[173] = [CCAppleBlueLight24]::new()
        $this.ColorMap[174] = [CCAppleBlueLight24]::new()
        $this.ColorMap[175] = [CCAppleBlueLight24]::new()
        $this.ColorMap[176] = [CCAppleBlueLight24]::new()
        $this.ColorMap[177] = [CCAppleBlueLight24]::new()
        $this.ColorMap[178] = [CCAppleBlueLight24]::new()
        $this.ColorMap[179] = [CCAppleBlueLight24]::new()
        $this.ColorMap[180] = [CCAppleBlueLight24]::new()
        $this.ColorMap[181] = [CCAppleBlueLight24]::new()
        $this.ColorMap[182] = [CCAppleBlueLight24]::new()
        $this.ColorMap[183] = [CCAppleBlueLight24]::new()
        $this.ColorMap[184] = [CCAppleBlueLight24]::new()
        $this.ColorMap[185] = [CCAppleBlueLight24]::new()
        $this.ColorMap[186] = [CCAppleBlueLight24]::new()
        $this.ColorMap[187] = [CCAppleBlueLight24]::new()
        $this.ColorMap[188] = [CCAppleBlueLight24]::new()
        $this.ColorMap[189] = [CCAppleBlueLight24]::new()
        $this.ColorMap[190] = [CCAppleBlueLight24]::new()
        $this.ColorMap[191] = [CCAppleBlueLight24]::new() # End Row 3
        $this.ColorMap[192] = [CCAppleBlueLight24]::new()
        $this.ColorMap[193] = [CCAppleBlueLight24]::new()
        $this.ColorMap[194] = [CCAppleBlueLight24]::new()
        $this.ColorMap[195] = [CCAppleBlueLight24]::new()
        $this.ColorMap[196] = [CCAppleBlueLight24]::new()
        $this.ColorMap[197] = [CCAppleBlueLight24]::new()
        $this.ColorMap[198] = [CCAppleBlueLight24]::new()
        $this.ColorMap[199] = [CCAppleBlueLight24]::new()
        $this.ColorMap[200] = [CCAppleBlueLight24]::new()
        $this.ColorMap[201] = [CCAppleBlueLight24]::new()
        $this.ColorMap[202] = [CCAppleBlueLight24]::new()
        $this.ColorMap[203] = [CCAppleBlueLight24]::new()
        $this.ColorMap[204] = [CCAppleBlueLight24]::new()
        $this.ColorMap[205] = [CCAppleBlueLight24]::new()
        $this.ColorMap[206] = [CCAppleBlueLight24]::new()
        $this.ColorMap[207] = [CCAppleBlueLight24]::new()
        $this.ColorMap[208] = [CCAppleBlueLight24]::new()
        $this.ColorMap[209] = [CCAppleBlueLight24]::new()
        $this.ColorMap[210] = [CCAppleBlueLight24]::new()
        $this.ColorMap[211] = [CCAppleBlueLight24]::new()
        $this.ColorMap[212] = [CCAppleBlueLight24]::new()
        $this.ColorMap[213] = [CCAppleBlueLight24]::new()
        $this.ColorMap[214] = [CCAppleBlueLight24]::new()
        $this.ColorMap[215] = [CCAppleBlueLight24]::new()
        $this.ColorMap[216] = [CCAppleBlueLight24]::new()
        $this.ColorMap[217] = [CCAppleBlueLight24]::new()
        $this.ColorMap[218] = [CCAppleBlueLight24]::new()
        $this.ColorMap[219] = [CCAppleBlueLight24]::new()
        $this.ColorMap[220] = [CCAppleBlueLight24]::new()
        $this.ColorMap[221] = [CCAppleBlueLight24]::new()
        $this.ColorMap[222] = [CCAppleBlueLight24]::new()
        $this.ColorMap[223] = [CCAppleBlueLight24]::new()
        $this.ColorMap[224] = [CCAppleBlueLight24]::new()
        $this.ColorMap[225] = [CCAppleBlueLight24]::new()
        $this.ColorMap[226] = [CCAppleBlueLight24]::new()
        $this.ColorMap[227] = [CCAppleBlueLight24]::new()
        $this.ColorMap[228] = [CCAppleBlueLight24]::new()
        $this.ColorMap[229] = [CCAppleBlueLight24]::new()
        $this.ColorMap[230] = [CCAppleBlueLight24]::new()
        $this.ColorMap[231] = [CCAppleBlueLight24]::new()
        $this.ColorMap[232] = [CCAppleBlueLight24]::new()
        $this.ColorMap[233] = [CCAppleBlueLight24]::new()
        $this.ColorMap[234] = [CCAppleBlueLight24]::new()
        $this.ColorMap[235] = [CCAppleBlueLight24]::new()
        $this.ColorMap[236] = [CCAppleBlueLight24]::new()
        $this.ColorMap[237] = [CCAppleBlueLight24]::new()
        $this.ColorMap[238] = [CCAppleBlueLight24]::new()
        $this.ColorMap[239] = [CCAppleBlueLight24]::new() # End Row 4
        $this.ColorMap[240] = [CCAppleGreenLight24]::new()
        $this.ColorMap[241] = [CCAppleGreenLight24]::new()
        $this.ColorMap[242] = [CCAppleGreenLight24]::new()
        $this.ColorMap[243] = [CCAppleGreenLight24]::new()
        $this.ColorMap[244] = [CCAppleGreenLight24]::new()
        $this.ColorMap[245] = [CCAppleGreenLight24]::new()
        $this.ColorMap[246] = [CCAppleGreenLight24]::new()
        $this.ColorMap[247] = [CCAppleGreenLight24]::new()
        $this.ColorMap[248] = [CCAppleGreenLight24]::new()
        $this.ColorMap[249] = [CCAppleGreenLight24]::new()
        $this.ColorMap[250] = [CCAppleGreenLight24]::new()
        $this.ColorMap[251] = [CCAppleGreenLight24]::new()
        $this.ColorMap[252] = [CCAppleGreenLight24]::new()
        $this.ColorMap[253] = [CCAppleGreenLight24]::new()
        $this.ColorMap[254] = [CCAppleGreenLight24]::new()
        $this.ColorMap[255] = [CCAppleGreenLight24]::new()
        $this.ColorMap[256] = [CCAppleGreenLight24]::new()
        $this.ColorMap[257] = [CCAppleGreenLight24]::new()
        $this.ColorMap[258] = [CCAppleGreenLight24]::new()
        $this.ColorMap[259] = [CCAppleGreenLight24]::new()
        $this.ColorMap[260] = [CCAppleGreenLight24]::new()
        $this.ColorMap[261] = [CCAppleGreenLight24]::new()
        $this.ColorMap[262] = [CCAppleGreenLight24]::new()
        $this.ColorMap[263] = [CCAppleGreenLight24]::new()
        $this.ColorMap[264] = [CCAppleBrownLight24]::new()
        $this.ColorMap[265] = [CCAppleGreenLight24]::new()
        $this.ColorMap[266] = [CCAppleGreenLight24]::new()
        $this.ColorMap[267] = [CCAppleGreenLight24]::new()
        $this.ColorMap[268] = [CCAppleGreenLight24]::new()
        $this.ColorMap[269] = [CCAppleGreenLight24]::new()
        $this.ColorMap[270] = [CCAppleGreenLight24]::new()
        $this.ColorMap[271] = [CCAppleGreenLight24]::new()
        $this.ColorMap[272] = [CCAppleGreenLight24]::new()
        $this.ColorMap[273] = [CCAppleGreenLight24]::new()
        $this.ColorMap[274] = [CCAppleGreenLight24]::new()
        $this.ColorMap[275] = [CCAppleGreenLight24]::new()
        $this.ColorMap[276] = [CCAppleGreenLight24]::new()
        $this.ColorMap[277] = [CCAppleGreenLight24]::new()
        $this.ColorMap[278] = [CCAppleGreenLight24]::new()
        $this.ColorMap[279] = [CCAppleGreenLight24]::new()
        $this.ColorMap[280] = [CCAppleGreenLight24]::new()
        $this.ColorMap[281] = [CCAppleGreenLight24]::new()
        $this.ColorMap[282] = [CCAppleGreenLight24]::new()
        $this.ColorMap[283] = [CCAppleGreenLight24]::new()
        $this.ColorMap[284] = [CCAppleGreenLight24]::new()
        $this.ColorMap[285] = [CCAppleGreenLight24]::new()
        $this.ColorMap[286] = [CCAppleGreenLight24]::new()
        $this.ColorMap[287] = [CCAppleGreenLight24]::new() # End Row 5
        $this.ColorMap[288] = [CCAppleGreenLight24]::new()
        $this.ColorMap[289] = [CCAppleGreenLight24]::new()
        $this.ColorMap[290] = [CCAppleGreenLight24]::new()
        $this.ColorMap[291] = [CCAppleGreenLight24]::new()
        $this.ColorMap[292] = [CCAppleGreenLight24]::new()
        $this.ColorMap[293] = [CCAppleGreenLight24]::new()
        $this.ColorMap[294] = [CCAppleGreenLight24]::new()
        $this.ColorMap[295] = [CCAppleGreenLight24]::new()
        $this.ColorMap[296] = [CCAppleGreenLight24]::new()
        $this.ColorMap[297] = [CCAppleGreenLight24]::new()
        $this.ColorMap[298] = [CCAppleGreenLight24]::new()
        $this.ColorMap[299] = [CCAppleGreenLight24]::new()
        $this.ColorMap[300] = [CCAppleGreenLight24]::new()
        $this.ColorMap[301] = [CCAppleGreenLight24]::new()
        $this.ColorMap[302] = [CCAppleGreenLight24]::new()
        $this.ColorMap[303] = [CCAppleGreenLight24]::new()
        $this.ColorMap[304] = [CCAppleGreenLight24]::new()
        $this.ColorMap[305] = [CCAppleGreenLight24]::new()
        $this.ColorMap[306] = [CCAppleGreenLight24]::new()
        $this.ColorMap[307] = [CCAppleGreenLight24]::new()
        $this.ColorMap[308] = [CCAppleGreenLight24]::new()
        $this.ColorMap[309] = [CCAppleGreenLight24]::new()
        $this.ColorMap[310] = [CCAppleGreenLight24]::new()
        $this.ColorMap[311] = [CCAppleGreenLight24]::new()
        $this.ColorMap[312] = [CCAppleBrownLight24]::new()
        $this.ColorMap[313] = [CCAppleGreenLight24]::new()
        $this.ColorMap[314] = [CCAppleGreenLight24]::new()
        $this.ColorMap[315] = [CCAppleGreenLight24]::new()
        $this.ColorMap[316] = [CCAppleGreenLight24]::new()
        $this.ColorMap[317] = [CCAppleGreenLight24]::new()
        $this.ColorMap[318] = [CCAppleGreenLight24]::new()
        $this.ColorMap[319] = [CCAppleGreenLight24]::new()
        $this.ColorMap[320] = [CCAppleGreenLight24]::new()
        $this.ColorMap[321] = [CCAppleGreenLight24]::new()
        $this.ColorMap[322] = [CCAppleGreenLight24]::new()
        $this.ColorMap[323] = [CCAppleGreenLight24]::new()
        $this.ColorMap[324] = [CCAppleGreenLight24]::new()
        $this.ColorMap[325] = [CCAppleGreenLight24]::new()
        $this.ColorMap[326] = [CCAppleGreenLight24]::new()
        $this.ColorMap[327] = [CCAppleGreenLight24]::new()
        $this.ColorMap[328] = [CCAppleGreenLight24]::new()
        $this.ColorMap[329] = [CCAppleGreenLight24]::new()
        $this.ColorMap[330] = [CCAppleGreenLight24]::new()
        $this.ColorMap[331] = [CCAppleGreenLight24]::new()
        $this.ColorMap[332] = [CCAppleGreenLight24]::new()
        $this.ColorMap[333] = [CCAppleGreenLight24]::new()
        $this.ColorMap[334] = [CCAppleGreenLight24]::new()
        $this.ColorMap[335] = [CCAppleGreenLight24]::new() # End Row 6
        $this.ColorMap[336] = [CCAppleGreenLight24]::new()
        $this.ColorMap[337] = [CCAppleGreenLight24]::new()
        $this.ColorMap[338] = [CCAppleGreenLight24]::new()
        $this.ColorMap[339] = [CCAppleGreenLight24]::new()
        $this.ColorMap[340] = [CCAppleGreenLight24]::new()
        $this.ColorMap[341] = [CCAppleGreenLight24]::new()
        $this.ColorMap[342] = [CCAppleGreenLight24]::new()
        $this.ColorMap[343] = [CCAppleGreenLight24]::new()
        $this.ColorMap[344] = [CCAppleGreenLight24]::new()
        $this.ColorMap[345] = [CCAppleGreenLight24]::new()
        $this.ColorMap[346] = [CCAppleGreenLight24]::new()
        $this.ColorMap[347] = [CCAppleGreenLight24]::new()
        $this.ColorMap[348] = [CCAppleGreenLight24]::new()
        $this.ColorMap[349] = [CCAppleGreenLight24]::new()
        $this.ColorMap[350] = [CCAppleGreenLight24]::new()
        $this.ColorMap[351] = [CCAppleGreenLight24]::new()
        $this.ColorMap[352] = [CCAppleGreenLight24]::new()
        $this.ColorMap[353] = [CCAppleGreenLight24]::new()
        $this.ColorMap[354] = [CCAppleGreenLight24]::new()
        $this.ColorMap[355] = [CCAppleGreenLight24]::new()
        $this.ColorMap[356] = [CCAppleGreenLight24]::new()
        $this.ColorMap[357] = [CCAppleGreenLight24]::new()
        $this.ColorMap[358] = [CCAppleGreenLight24]::new()
        $this.ColorMap[359] = [CCAppleBrownLight24]::new()
        $this.ColorMap[360] = [CCAppleBrownLight24]::new()
        $this.ColorMap[361] = [CCAppleBrownLight24]::new()
        $this.ColorMap[362] = [CCAppleGreenLight24]::new()
        $this.ColorMap[363] = [CCAppleGreenLight24]::new()
        $this.ColorMap[364] = [CCAppleGreenLight24]::new()
        $this.ColorMap[365] = [CCAppleGreenLight24]::new()
        $this.ColorMap[366] = [CCAppleGreenLight24]::new()
        $this.ColorMap[367] = [CCAppleGreenLight24]::new()
        $this.ColorMap[368] = [CCAppleGreenLight24]::new()
        $this.ColorMap[369] = [CCAppleGreenLight24]::new()
        $this.ColorMap[370] = [CCAppleGreenLight24]::new()
        $this.ColorMap[371] = [CCAppleGreenLight24]::new()
        $this.ColorMap[372] = [CCAppleGreenLight24]::new()
        $this.ColorMap[373] = [CCAppleGreenLight24]::new()
        $this.ColorMap[374] = [CCAppleGreenLight24]::new()
        $this.ColorMap[375] = [CCAppleGreenLight24]::new()
        $this.ColorMap[376] = [CCAppleGreenLight24]::new()
        $this.ColorMap[377] = [CCAppleGreenLight24]::new()
        $this.ColorMap[378] = [CCAppleGreenLight24]::new()
        $this.ColorMap[379] = [CCAppleGreenLight24]::new()
        $this.ColorMap[380] = [CCAppleGreenLight24]::new()
        $this.ColorMap[381] = [CCAppleGreenLight24]::new()
        $this.ColorMap[382] = [CCAppleGreenLight24]::new()
        $this.ColorMap[383] = [CCAppleGreenLight24]::new() # End Row 7
        $this.ColorMap[384] = [CCAppleGreenLight24]::new()
        $this.ColorMap[385] = [CCAppleGreenLight24]::new()
        $this.ColorMap[386] = [CCAppleGreenLight24]::new()
        $this.ColorMap[387] = [CCAppleGreenLight24]::new()
        $this.ColorMap[388] = [CCAppleGreenLight24]::new()
        $this.ColorMap[389] = [CCAppleGreenLight24]::new()
        $this.ColorMap[390] = [CCAppleGreenLight24]::new()
        $this.ColorMap[391] = [CCAppleGreenLight24]::new()
        $this.ColorMap[392] = [CCAppleGreenLight24]::new()
        $this.ColorMap[393] = [CCAppleGreenLight24]::new()
        $this.ColorMap[394] = [CCAppleGreenLight24]::new()
        $this.ColorMap[395] = [CCAppleGreenLight24]::new()
        $this.ColorMap[396] = [CCAppleGreenLight24]::new()
        $this.ColorMap[397] = [CCAppleGreenLight24]::new()
        $this.ColorMap[398] = [CCAppleGreenLight24]::new()
        $this.ColorMap[399] = [CCAppleGreenLight24]::new()
        $this.ColorMap[400] = [CCAppleGreenLight24]::new()
        $this.ColorMap[401] = [CCAppleGreenLight24]::new()
        $this.ColorMap[402] = [CCAppleGreenLight24]::new()
        $this.ColorMap[403] = [CCAppleGreenLight24]::new()
        $this.ColorMap[404] = [CCAppleGreenLight24]::new()
        $this.ColorMap[405] = [CCAppleGreenLight24]::new()
        $this.ColorMap[406] = [CCAppleBrownLight24]::new()
        $this.ColorMap[407] = [CCAppleBrownLight24]::new()
        $this.ColorMap[408] = [CCAppleBrownLight24]::new()
        $this.ColorMap[409] = [CCAppleBrownLight24]::new()
        $this.ColorMap[410] = [CCAppleBrownLight24]::new()
        $this.ColorMap[411] = [CCAppleGreenLight24]::new()
        $this.ColorMap[412] = [CCAppleGreenLight24]::new()
        $this.ColorMap[413] = [CCAppleGreenLight24]::new()
        $this.ColorMap[414] = [CCAppleGreenLight24]::new()
        $this.ColorMap[415] = [CCAppleGreenLight24]::new()
        $this.ColorMap[416] = [CCAppleGreenLight24]::new()
        $this.ColorMap[417] = [CCAppleGreenLight24]::new()
        $this.ColorMap[418] = [CCAppleGreenLight24]::new()
        $this.ColorMap[419] = [CCAppleGreenLight24]::new()
        $this.ColorMap[420] = [CCAppleGreenLight24]::new()
        $this.ColorMap[421] = [CCAppleGreenLight24]::new()
        $this.ColorMap[422] = [CCAppleGreenLight24]::new()
        $this.ColorMap[423] = [CCAppleGreenLight24]::new()
        $this.ColorMap[424] = [CCAppleGreenLight24]::new()
        $this.ColorMap[425] = [CCAppleGreenLight24]::new()
        $this.ColorMap[426] = [CCAppleGreenLight24]::new()
        $this.ColorMap[427] = [CCAppleGreenLight24]::new()
        $this.ColorMap[428] = [CCAppleGreenLight24]::new()
        $this.ColorMap[429] = [CCAppleGreenLight24]::new()
        $this.ColorMap[430] = [CCAppleGreenLight24]::new()
        $this.ColorMap[431] = [CCAppleGreenLight24]::new() # End Row 8
        $this.ColorMap[432] = [CCAppleGreenLight24]::new()
        $this.ColorMap[433] = [CCAppleGreenLight24]::new()
        $this.ColorMap[434] = [CCAppleGreenLight24]::new()
        $this.ColorMap[435] = [CCAppleGreenLight24]::new()
        $this.ColorMap[436] = [CCAppleGreenLight24]::new()
        $this.ColorMap[437] = [CCAppleGreenLight24]::new()
        $this.ColorMap[438] = [CCAppleGreenLight24]::new()
        $this.ColorMap[439] = [CCAppleGreenLight24]::new()
        $this.ColorMap[440] = [CCAppleGreenLight24]::new()
        $this.ColorMap[441] = [CCAppleGreenLight24]::new()
        $this.ColorMap[442] = [CCAppleGreenLight24]::new()
        $this.ColorMap[443] = [CCAppleGreenLight24]::new()
        $this.ColorMap[444] = [CCAppleGreenLight24]::new()
        $this.ColorMap[445] = [CCAppleGreenLight24]::new()
        $this.ColorMap[446] = [CCAppleGreenLight24]::new()
        $this.ColorMap[447] = [CCAppleGreenLight24]::new()
        $this.ColorMap[448] = [CCAppleGreenLight24]::new()
        $this.ColorMap[449] = [CCAppleGreenLight24]::new()
        $this.ColorMap[450] = [CCAppleGreenLight24]::new()
        $this.ColorMap[451] = [CCAppleGreenLight24]::new()
        $this.ColorMap[452] = [CCAppleGreenLight24]::new()
        $this.ColorMap[453] = [CCAppleGreenLight24]::new()
        $this.ColorMap[454] = [CCAppleBrownLight24]::new()
        $this.ColorMap[455] = [CCAppleBrownLight24]::new()
        $this.ColorMap[456] = [CCAppleBrownLight24]::new()
        $this.ColorMap[457] = [CCAppleBrownLight24]::new()
        $this.ColorMap[458] = [CCAppleBrownLight24]::new()
        $this.ColorMap[459] = [CCAppleGreenLight24]::new()
        $this.ColorMap[460] = [CCAppleGreenLight24]::new()
        $this.ColorMap[461] = [CCAppleGreenLight24]::new()
        $this.ColorMap[462] = [CCAppleGreenLight24]::new()
        $this.ColorMap[463] = [CCAppleGreenLight24]::new()
        $this.ColorMap[464] = [CCAppleGreenLight24]::new()
        $this.ColorMap[465] = [CCAppleGreenLight24]::new()
        $this.ColorMap[466] = [CCAppleGreenLight24]::new()
        $this.ColorMap[467] = [CCAppleGreenLight24]::new()
        $this.ColorMap[468] = [CCAppleGreenLight24]::new()
        $this.ColorMap[469] = [CCAppleGreenLight24]::new()
        $this.ColorMap[470] = [CCAppleGreenLight24]::new()
        $this.ColorMap[471] = [CCAppleGreenLight24]::new()
        $this.ColorMap[472] = [CCAppleGreenLight24]::new()
        $this.ColorMap[473] = [CCAppleGreenLight24]::new()
        $this.ColorMap[474] = [CCAppleGreenLight24]::new()
        $this.ColorMap[475] = [CCAppleGreenLight24]::new()
        $this.ColorMap[476] = [CCAppleGreenLight24]::new()
        $this.ColorMap[477] = [CCAppleGreenLight24]::new()
        $this.ColorMap[478] = [CCAppleGreenLight24]::new()
        $this.ColorMap[479] = [CCAppleGreenLight24]::new() # End Row 9
        $this.ColorMap[480] = [CCAppleGreenLight24]::new()
        $this.ColorMap[481] = [CCAppleGreenLight24]::new()
        $this.ColorMap[482] = [CCAppleGreenLight24]::new()
        $this.ColorMap[483] = [CCAppleGreenLight24]::new()
        $this.ColorMap[484] = [CCAppleGreenLight24]::new()
        $this.ColorMap[485] = [CCAppleGreenLight24]::new()
        $this.ColorMap[486] = [CCAppleGreenLight24]::new()
        $this.ColorMap[487] = [CCAppleGreenLight24]::new()
        $this.ColorMap[488] = [CCAppleGreenLight24]::new()
        $this.ColorMap[489] = [CCAppleGreenLight24]::new()
        $this.ColorMap[490] = [CCAppleGreenLight24]::new()
        $this.ColorMap[491] = [CCAppleGreenLight24]::new()
        $this.ColorMap[492] = [CCAppleGreenLight24]::new()
        $this.ColorMap[493] = [CCAppleGreenLight24]::new()
        $this.ColorMap[494] = [CCAppleGreenLight24]::new()
        $this.ColorMap[495] = [CCAppleGreenLight24]::new()
        $this.ColorMap[496] = [CCAppleGreenLight24]::new()
        $this.ColorMap[497] = [CCAppleGreenLight24]::new()
        $this.ColorMap[498] = [CCAppleGreenLight24]::new()
        $this.ColorMap[499] = [CCAppleGreenLight24]::new()
        $this.ColorMap[500] = [CCAppleGreenLight24]::new()
        $this.ColorMap[501] = [CCAppleBrownLight24]::new()
        $this.ColorMap[502] = [CCAppleBrownLight24]::new()
        $this.ColorMap[503] = [CCAppleBrownLight24]::new()
        $this.ColorMap[504] = [CCAppleBrownLight24]::new()
        $this.ColorMap[505] = [CCAppleBrownLight24]::new()
        $this.ColorMap[506] = [CCAppleBrownLight24]::new()
        $this.ColorMap[507] = [CCAppleBrownLight24]::new()
        $this.ColorMap[508] = [CCAppleGreenLight24]::new()
        $this.ColorMap[509] = [CCAppleGreenLight24]::new()
        $this.ColorMap[510] = [CCAppleGreenLight24]::new()
        $this.ColorMap[511] = [CCAppleGreenLight24]::new()
        $this.ColorMap[512] = [CCAppleGreenLight24]::new()
        $this.ColorMap[513] = [CCAppleGreenLight24]::new()
        $this.ColorMap[514] = [CCAppleGreenLight24]::new()
        $this.ColorMap[515] = [CCAppleGreenLight24]::new()
        $this.ColorMap[516] = [CCAppleGreenLight24]::new()
        $this.ColorMap[517] = [CCAppleGreenLight24]::new()
        $this.ColorMap[518] = [CCAppleGreenLight24]::new()
        $this.ColorMap[519] = [CCAppleGreenLight24]::new()
        $this.ColorMap[520] = [CCAppleGreenLight24]::new()
        $this.ColorMap[521] = [CCAppleGreenLight24]::new()
        $this.ColorMap[522] = [CCAppleGreenLight24]::new()
        $this.ColorMap[523] = [CCAppleGreenLight24]::new()
        $this.ColorMap[524] = [CCAppleGreenLight24]::new()
        $this.ColorMap[525] = [CCAppleGreenLight24]::new()
        $this.ColorMap[526] = [CCAppleGreenLight24]::new()
        $this.ColorMap[527] = [CCAppleGreenLight24]::new() # End Row 10
        $this.ColorMap[528] = [CCAppleGreenLight24]::new()
        $this.ColorMap[529] = [CCAppleGreenLight24]::new()
        $this.ColorMap[530] = [CCAppleGreenLight24]::new()
        $this.ColorMap[531] = [CCAppleGreenLight24]::new()
        $this.ColorMap[532] = [CCAppleGreenLight24]::new()
        $this.ColorMap[533] = [CCAppleGreenLight24]::new()
        $this.ColorMap[534] = [CCAppleGreenLight24]::new()
        $this.ColorMap[535] = [CCAppleGreenLight24]::new()
        $this.ColorMap[536] = [CCAppleGreenLight24]::new()
        $this.ColorMap[537] = [CCAppleGreenLight24]::new()
        $this.ColorMap[538] = [CCAppleGreenLight24]::new()
        $this.ColorMap[539] = [CCAppleGreenLight24]::new()
        $this.ColorMap[540] = [CCAppleGreenLight24]::new()
        $this.ColorMap[541] = [CCAppleGreenLight24]::new()
        $this.ColorMap[542] = [CCAppleGreenLight24]::new()
        $this.ColorMap[543] = [CCAppleGreenLight24]::new()
        $this.ColorMap[544] = [CCAppleGreenLight24]::new()
        $this.ColorMap[545] = [CCAppleGreenLight24]::new()
        $this.ColorMap[546] = [CCAppleGreenLight24]::new()
        $this.ColorMap[547] = [CCAppleGreenLight24]::new()
        $this.ColorMap[548] = [CCAppleGreenLight24]::new()
        $this.ColorMap[549] = [CCAppleBrownLight24]::new()
        $this.ColorMap[550] = [CCAppleBrownLight24]::new()
        $this.ColorMap[551] = [CCAppleBrownLight24]::new()
        $this.ColorMap[552] = [CCAppleBrownLight24]::new()
        $this.ColorMap[553] = [CCAppleBrownLight24]::new()
        $this.ColorMap[554] = [CCAppleBrownLight24]::new()
        $this.ColorMap[555] = [CCAppleBrownLight24]::new()
        $this.ColorMap[556] = [CCAppleGreenLight24]::new()
        $this.ColorMap[557] = [CCAppleGreenLight24]::new()
        $this.ColorMap[558] = [CCAppleGreenLight24]::new()
        $this.ColorMap[559] = [CCAppleGreenLight24]::new()
        $this.ColorMap[560] = [CCAppleGreenLight24]::new()
        $this.ColorMap[561] = [CCAppleGreenLight24]::new()
        $this.ColorMap[562] = [CCAppleGreenLight24]::new()
        $this.ColorMap[563] = [CCAppleGreenLight24]::new()
        $this.ColorMap[564] = [CCAppleGreenLight24]::new()
        $this.ColorMap[565] = [CCAppleGreenLight24]::new()
        $this.ColorMap[566] = [CCAppleGreenLight24]::new()
        $this.ColorMap[567] = [CCAppleGreenLight24]::new()
        $this.ColorMap[568] = [CCAppleGreenLight24]::new()
        $this.ColorMap[569] = [CCAppleGreenLight24]::new()
        $this.ColorMap[570] = [CCAppleGreenLight24]::new()
        $this.ColorMap[571] = [CCAppleGreenLight24]::new()
        $this.ColorMap[572] = [CCAppleGreenLight24]::new()
        $this.ColorMap[573] = [CCAppleGreenLight24]::new()
        $this.ColorMap[574] = [CCAppleGreenLight24]::new()
        $this.ColorMap[575] = [CCAppleGreenLight24]::new() # End Row 11
        $this.ColorMap[576] = [CCAppleGreenLight24]::new()
        $this.ColorMap[577] = [CCAppleGreenLight24]::new()
        $this.ColorMap[578] = [CCAppleGreenLight24]::new()
        $this.ColorMap[579] = [CCAppleGreenLight24]::new()
        $this.ColorMap[580] = [CCAppleGreenLight24]::new()
        $this.ColorMap[581] = [CCAppleGreenLight24]::new()
        $this.ColorMap[582] = [CCAppleGreenLight24]::new()
        $this.ColorMap[583] = [CCAppleGreenLight24]::new()
        $this.ColorMap[584] = [CCAppleGreenLight24]::new()
        $this.ColorMap[585] = [CCAppleGreenLight24]::new()
        $this.ColorMap[586] = [CCAppleGreenLight24]::new()
        $this.ColorMap[587] = [CCAppleGreenLight24]::new()
        $this.ColorMap[588] = [CCAppleGreenLight24]::new()
        $this.ColorMap[589] = [CCAppleGreenLight24]::new()
        $this.ColorMap[590] = [CCAppleGreenLight24]::new()
        $this.ColorMap[591] = [CCAppleGreenLight24]::new()
        $this.ColorMap[592] = [CCAppleGreenLight24]::new()
        $this.ColorMap[593] = [CCAppleGreenLight24]::new()
        $this.ColorMap[594] = [CCAppleGreenLight24]::new()
        $this.ColorMap[595] = [CCAppleGreenLight24]::new()
        $this.ColorMap[596] = [CCAppleGreenLight24]::new()
        $this.ColorMap[597] = [CCAppleBrownLight24]::new()
        $this.ColorMap[598] = [CCAppleBrownLight24]::new()
        $this.ColorMap[599] = [CCAppleBrownLight24]::new()
        $this.ColorMap[600] = [CCAppleBrownLight24]::new()
        $this.ColorMap[601] = [CCAppleBrownLight24]::new()
        $this.ColorMap[602] = [CCAppleBrownLight24]::new()
        $this.ColorMap[603] = [CCAppleBrownLight24]::new()
        $this.ColorMap[604] = [CCAppleGreenLight24]::new()
        $this.ColorMap[605] = [CCAppleGreenLight24]::new()
        $this.ColorMap[606] = [CCAppleGreenLight24]::new()
        $this.ColorMap[607] = [CCAppleGreenLight24]::new()
        $this.ColorMap[608] = [CCAppleGreenLight24]::new()
        $this.ColorMap[609] = [CCAppleGreenLight24]::new()
        $this.ColorMap[610] = [CCAppleGreenLight24]::new()
        $this.ColorMap[611] = [CCAppleGreenLight24]::new()
        $this.ColorMap[612] = [CCAppleGreenLight24]::new()
        $this.ColorMap[613] = [CCAppleGreenLight24]::new()
        $this.ColorMap[614] = [CCAppleGreenLight24]::new()
        $this.ColorMap[615] = [CCAppleGreenLight24]::new()
        $this.ColorMap[616] = [CCAppleGreenLight24]::new()
        $this.ColorMap[617] = [CCAppleGreenLight24]::new()
        $this.ColorMap[618] = [CCAppleGreenLight24]::new()
        $this.ColorMap[619] = [CCAppleGreenLight24]::new()
        $this.ColorMap[620] = [CCAppleGreenLight24]::new()
        $this.ColorMap[621] = [CCAppleGreenLight24]::new()
        $this.ColorMap[622] = [CCAppleGreenLight24]::new()
        $this.ColorMap[623] = [CCAppleGreenLight24]::new() # End Row 12
        $this.ColorMap[624] = [CCAppleGreenLight24]::new()
        $this.ColorMap[625] = [CCAppleGreenLight24]::new()
        $this.ColorMap[626] = [CCAppleGreenLight24]::new()
        $this.ColorMap[627] = [CCAppleGreenLight24]::new()
        $this.ColorMap[628] = [CCAppleGreenLight24]::new()
        $this.ColorMap[629] = [CCAppleGreenLight24]::new()
        $this.ColorMap[630] = [CCAppleGreenLight24]::new()
        $this.ColorMap[631] = [CCAppleGreenLight24]::new()
        $this.ColorMap[632] = [CCAppleGreenLight24]::new()
        $this.ColorMap[633] = [CCAppleGreenLight24]::new()
        $this.ColorMap[634] = [CCAppleGreenLight24]::new()
        $this.ColorMap[635] = [CCAppleGreenLight24]::new()
        $this.ColorMap[636] = [CCAppleGreenLight24]::new()
        $this.ColorMap[637] = [CCAppleGreenLight24]::new()
        $this.ColorMap[638] = [CCAppleGreenLight24]::new()
        $this.ColorMap[639] = [CCAppleGreenLight24]::new()
        $this.ColorMap[640] = [CCAppleGreenLight24]::new()
        $this.ColorMap[641] = [CCAppleGreenLight24]::new()
        $this.ColorMap[642] = [CCAppleGreenLight24]::new()
        $this.ColorMap[643] = [CCAppleGreenLight24]::new()
        $this.ColorMap[644] = [CCAppleGreenLight24]::new()
        $this.ColorMap[645] = [CCAppleBrownLight24]::new()
        $this.ColorMap[646] = [CCAppleBrownLight24]::new()
        $this.ColorMap[647] = [CCAppleBrownLight24]::new()
        $this.ColorMap[648] = [CCAppleBrownLight24]::new()
        $this.ColorMap[649] = [CCAppleBrownLight24]::new()
        $this.ColorMap[650] = [CCAppleBrownLight24]::new()
        $this.ColorMap[651] = [CCAppleBrownLight24]::new()
        $this.ColorMap[652] = [CCAppleGreenLight24]::new()
        $this.ColorMap[653] = [CCAppleGreenLight24]::new()
        $this.ColorMap[654] = [CCAppleGreenLight24]::new()
        $this.ColorMap[655] = [CCAppleGreenLight24]::new()
        $this.ColorMap[656] = [CCAppleGreenLight24]::new()
        $this.ColorMap[657] = [CCAppleGreenLight24]::new()
        $this.ColorMap[658] = [CCAppleGreenLight24]::new()
        $this.ColorMap[659] = [CCAppleGreenLight24]::new()
        $this.ColorMap[660] = [CCAppleGreenLight24]::new()
        $this.ColorMap[661] = [CCAppleGreenLight24]::new()
        $this.ColorMap[662] = [CCAppleGreenLight24]::new()
        $this.ColorMap[663] = [CCAppleGreenLight24]::new()
        $this.ColorMap[664] = [CCAppleGreenLight24]::new()
        $this.ColorMap[665] = [CCAppleGreenLight24]::new()
        $this.ColorMap[666] = [CCAppleGreenLight24]::new()
        $this.ColorMap[667] = [CCAppleGreenLight24]::new()
        $this.ColorMap[668] = [CCAppleGreenLight24]::new()
        $this.ColorMap[669] = [CCAppleGreenLight24]::new()
        $this.ColorMap[670] = [CCAppleGreenLight24]::new()
        $this.ColorMap[671] = [CCAppleGreenLight24]::new() # End Row 13
        $this.ColorMap[672] = [CCAppleGreenLight24]::new()
        $this.ColorMap[673] = [CCAppleGreenLight24]::new()
        $this.ColorMap[674] = [CCAppleGreenLight24]::new()
        $this.ColorMap[675] = [CCAppleGreenLight24]::new()
        $this.ColorMap[676] = [CCAppleGreenLight24]::new()
        $this.ColorMap[677] = [CCAppleGreenLight24]::new()
        $this.ColorMap[678] = [CCAppleGreenLight24]::new()
        $this.ColorMap[679] = [CCAppleGreenLight24]::new()
        $this.ColorMap[680] = [CCAppleGreenLight24]::new()
        $this.ColorMap[681] = [CCAppleGreenLight24]::new()
        $this.ColorMap[682] = [CCAppleGreenLight24]::new()
        $this.ColorMap[683] = [CCAppleGreenLight24]::new()
        $this.ColorMap[684] = [CCAppleGreenLight24]::new()
        $this.ColorMap[685] = [CCAppleGreenLight24]::new()
        $this.ColorMap[686] = [CCAppleGreenLight24]::new()
        $this.ColorMap[687] = [CCAppleGreenLight24]::new()
        $this.ColorMap[688] = [CCAppleGreenLight24]::new()
        $this.ColorMap[689] = [CCAppleGreenLight24]::new()
        $this.ColorMap[690] = [CCAppleGreenLight24]::new()
        $this.ColorMap[691] = [CCAppleGreenLight24]::new()
        $this.ColorMap[692] = [CCAppleGreenLight24]::new()
        $this.ColorMap[693] = [CCAppleBrownLight24]::new()
        $this.ColorMap[694] = [CCAppleBrownLight24]::new()
        $this.ColorMap[695] = [CCAppleBrownLight24]::new()
        $this.ColorMap[696] = [CCAppleBrownLight24]::new()
        $this.ColorMap[697] = [CCAppleBrownLight24]::new()
        $this.ColorMap[698] = [CCAppleBrownLight24]::new()
        $this.ColorMap[699] = [CCAppleBrownLight24]::new()
        $this.ColorMap[700] = [CCAppleGreenLight24]::new()
        $this.ColorMap[701] = [CCAppleGreenLight24]::new()
        $this.ColorMap[702] = [CCAppleGreenLight24]::new()
        $this.ColorMap[703] = [CCAppleGreenLight24]::new()
        $this.ColorMap[704] = [CCAppleGreenLight24]::new()
        $this.ColorMap[705] = [CCAppleGreenLight24]::new()
        $this.ColorMap[706] = [CCAppleGreenLight24]::new()
        $this.ColorMap[707] = [CCAppleGreenLight24]::new()
        $this.ColorMap[708] = [CCAppleGreenLight24]::new()
        $this.ColorMap[709] = [CCAppleGreenLight24]::new()
        $this.ColorMap[710] = [CCAppleGreenLight24]::new()
        $this.ColorMap[711] = [CCAppleGreenLight24]::new()
        $this.ColorMap[712] = [CCAppleGreenLight24]::new()
        $this.ColorMap[713] = [CCAppleGreenLight24]::new()
        $this.ColorMap[714] = [CCAppleGreenLight24]::new()
        $this.ColorMap[715] = [CCAppleGreenLight24]::new()
        $this.ColorMap[716] = [CCAppleGreenLight24]::new()
        $this.ColorMap[717] = [CCAppleGreenLight24]::new()
        $this.ColorMap[718] = [CCAppleGreenLight24]::new()
        $this.ColorMap[719] = [CCAppleGreenLight24]::new() # End Row 14
        $this.ColorMap[720] = [CCAppleGreenLight24]::new()
        $this.ColorMap[721] = [CCAppleGreenLight24]::new()
        $this.ColorMap[722] = [CCAppleGreenLight24]::new()
        $this.ColorMap[723] = [CCAppleGreenLight24]::new()
        $this.ColorMap[724] = [CCAppleGreenLight24]::new()
        $this.ColorMap[725] = [CCAppleGreenLight24]::new()
        $this.ColorMap[726] = [CCAppleGreenLight24]::new()
        $this.ColorMap[727] = [CCAppleGreenLight24]::new()
        $this.ColorMap[728] = [CCAppleGreenLight24]::new()
        $this.ColorMap[729] = [CCAppleGreenLight24]::new()
        $this.ColorMap[730] = [CCAppleGreenLight24]::new()
        $this.ColorMap[731] = [CCAppleGreenLight24]::new()
        $this.ColorMap[732] = [CCAppleGreenLight24]::new()
        $this.ColorMap[733] = [CCAppleGreenLight24]::new()
        $this.ColorMap[734] = [CCAppleGreenLight24]::new()
        $this.ColorMap[735] = [CCAppleGreenLight24]::new()
        $this.ColorMap[736] = [CCAppleGreenLight24]::new()
        $this.ColorMap[737] = [CCAppleGreenLight24]::new()
        $this.ColorMap[738] = [CCAppleGreenLight24]::new()
        $this.ColorMap[739] = [CCAppleGreenLight24]::new()
        $this.ColorMap[740] = [CCAppleGreenLight24]::new()
        $this.ColorMap[741] = [CCAppleBrownLight24]::new()
        $this.ColorMap[742] = [CCAppleBrownLight24]::new()
        $this.ColorMap[743] = [CCAppleBrownLight24]::new()
        $this.ColorMap[744] = [CCAppleBrownLight24]::new()
        $this.ColorMap[745] = [CCAppleBrownLight24]::new()
        $this.ColorMap[746] = [CCAppleBrownLight24]::new()
        $this.ColorMap[747] = [CCAppleBrownLight24]::new()
        $this.ColorMap[748] = [CCAppleGreenLight24]::new()
        $this.ColorMap[749] = [CCAppleGreenLight24]::new()
        $this.ColorMap[750] = [CCAppleGreenLight24]::new()
        $this.ColorMap[751] = [CCAppleGreenLight24]::new()
        $this.ColorMap[752] = [CCAppleGreenLight24]::new()
        $this.ColorMap[753] = [CCAppleGreenLight24]::new()
        $this.ColorMap[754] = [CCAppleGreenLight24]::new()
        $this.ColorMap[755] = [CCAppleGreenLight24]::new()
        $this.ColorMap[756] = [CCAppleGreenLight24]::new()
        $this.ColorMap[757] = [CCAppleGreenLight24]::new()
        $this.ColorMap[758] = [CCAppleGreenLight24]::new()
        $this.ColorMap[759] = [CCAppleGreenLight24]::new()
        $this.ColorMap[760] = [CCAppleGreenLight24]::new()
        $this.ColorMap[761] = [CCAppleGreenLight24]::new()
        $this.ColorMap[762] = [CCAppleGreenLight24]::new()
        $this.ColorMap[763] = [CCAppleGreenLight24]::new()
        $this.ColorMap[764] = [CCAppleGreenLight24]::new()
        $this.ColorMap[765] = [CCAppleGreenLight24]::new()
        $this.ColorMap[766] = [CCAppleGreenLight24]::new()
        $this.ColorMap[767] = [CCAppleGreenLight24]::new() # End Row 15
        $this.ColorMap[768] = [CCAppleGreenLight24]::new()
        $this.ColorMap[769] = [CCAppleGreenLight24]::new()
        $this.ColorMap[770] = [CCAppleGreenLight24]::new()
        $this.ColorMap[771] = [CCAppleGreenLight24]::new()
        $this.ColorMap[772] = [CCAppleGreenLight24]::new()
        $this.ColorMap[773] = [CCAppleGreenLight24]::new()
        $this.ColorMap[774] = [CCAppleGreenLight24]::new()
        $this.ColorMap[775] = [CCAppleGreenLight24]::new()
        $this.ColorMap[776] = [CCAppleGreenLight24]::new()
        $this.ColorMap[777] = [CCAppleGreenLight24]::new()
        $this.ColorMap[778] = [CCAppleGreenLight24]::new()
        $this.ColorMap[779] = [CCAppleGreenLight24]::new()
        $this.ColorMap[780] = [CCAppleGreenLight24]::new()
        $this.ColorMap[781] = [CCAppleGreenLight24]::new()
        $this.ColorMap[782] = [CCAppleGreenLight24]::new()
        $this.ColorMap[783] = [CCAppleGreenLight24]::new()
        $this.ColorMap[784] = [CCAppleGreenLight24]::new()
        $this.ColorMap[785] = [CCAppleGreenLight24]::new()
        $this.ColorMap[786] = [CCAppleGreenLight24]::new()
        $this.ColorMap[787] = [CCAppleGreenLight24]::new()
        $this.ColorMap[788] = [CCAppleGreenLight24]::new()
        $this.ColorMap[789] = [CCAppleBrownLight24]::new()
        $this.ColorMap[790] = [CCAppleBrownLight24]::new()
        $this.ColorMap[791] = [CCAppleBrownLight24]::new()
        $this.ColorMap[792] = [CCAppleBrownLight24]::new()
        $this.ColorMap[793] = [CCAppleBrownLight24]::new()
        $this.ColorMap[794] = [CCAppleBrownLight24]::new()
        $this.ColorMap[795] = [CCAppleBrownLight24]::new()
        $this.ColorMap[796] = [CCAppleGreenLight24]::new()
        $this.ColorMap[797] = [CCAppleGreenLight24]::new()
        $this.ColorMap[798] = [CCAppleGreenLight24]::new()
        $this.ColorMap[799] = [CCAppleGreenLight24]::new()
        $this.ColorMap[800] = [CCAppleGreenLight24]::new()
        $this.ColorMap[801] = [CCAppleGreenLight24]::new()
        $this.ColorMap[802] = [CCAppleGreenLight24]::new()
        $this.ColorMap[803] = [CCAppleGreenLight24]::new()
        $this.ColorMap[804] = [CCAppleGreenLight24]::new()
        $this.ColorMap[805] = [CCAppleGreenLight24]::new()
        $this.ColorMap[806] = [CCAppleGreenLight24]::new()
        $this.ColorMap[807] = [CCAppleGreenLight24]::new()
        $this.ColorMap[808] = [CCAppleGreenLight24]::new()
        $this.ColorMap[809] = [CCAppleGreenLight24]::new()
        $this.ColorMap[810] = [CCAppleGreenLight24]::new()
        $this.ColorMap[811] = [CCAppleGreenLight24]::new()
        $this.ColorMap[812] = [CCAppleGreenLight24]::new()
        $this.ColorMap[813] = [CCAppleGreenLight24]::new()
        $this.ColorMap[814] = [CCAppleGreenLight24]::new()
        $this.ColorMap[815] = [CCAppleGreenLight24]::new() # End Row 16
        $this.ColorMap[816] = [CCAppleGreenLight24]::new()
        $this.ColorMap[817] = [CCAppleGreenLight24]::new()
        $this.ColorMap[818] = [CCAppleGreenLight24]::new()
        $this.ColorMap[819] = [CCAppleGreenLight24]::new()
        $this.ColorMap[820] = [CCAppleGreenLight24]::new()
        $this.ColorMap[821] = [CCAppleGreenLight24]::new()
        $this.ColorMap[822] = [CCAppleGreenLight24]::new()
        $this.ColorMap[823] = [CCAppleGreenLight24]::new()
        $this.ColorMap[824] = [CCAppleGreenLight24]::new()
        $this.ColorMap[825] = [CCAppleGreenLight24]::new()
        $this.ColorMap[826] = [CCAppleGreenLight24]::new()
        $this.ColorMap[827] = [CCAppleGreenLight24]::new()
        $this.ColorMap[828] = [CCAppleGreenLight24]::new()
        $this.ColorMap[829] = [CCAppleGreenLight24]::new()
        $this.ColorMap[830] = [CCAppleGreenLight24]::new()
        $this.ColorMap[831] = [CCAppleGreenLight24]::new()
        $this.ColorMap[832] = [CCAppleGreenLight24]::new()
        $this.ColorMap[833] = [CCAppleGreenLight24]::new()
        $this.ColorMap[834] = [CCAppleGreenLight24]::new()
        $this.ColorMap[835] = [CCAppleGreenLight24]::new()
        $this.ColorMap[836] = [CCAppleGreenLight24]::new()
        $this.ColorMap[837] = [CCAppleBrownLight24]::new()
        $this.ColorMap[838] = [CCAppleBrownLight24]::new()
        $this.ColorMap[839] = [CCAppleBrownLight24]::new()
        $this.ColorMap[840] = [CCAppleBrownLight24]::new()
        $this.ColorMap[841] = [CCAppleBrownLight24]::new()
        $this.ColorMap[842] = [CCAppleBrownLight24]::new()
        $this.ColorMap[843] = [CCAppleBrownLight24]::new()
        $this.ColorMap[844] = [CCAppleGreenLight24]::new()
        $this.ColorMap[845] = [CCAppleGreenLight24]::new()
        $this.ColorMap[846] = [CCAppleGreenLight24]::new()
        $this.ColorMap[847] = [CCAppleGreenLight24]::new()
        $this.ColorMap[848] = [CCAppleGreenLight24]::new()
        $this.ColorMap[849] = [CCAppleGreenLight24]::new()
        $this.ColorMap[850] = [CCAppleGreenLight24]::new()
        $this.ColorMap[851] = [CCAppleGreenLight24]::new()
        $this.ColorMap[852] = [CCAppleGreenLight24]::new()
        $this.ColorMap[853] = [CCAppleGreenLight24]::new()
        $this.ColorMap[854] = [CCAppleGreenLight24]::new()
        $this.ColorMap[855] = [CCAppleGreenLight24]::new()
        $this.ColorMap[856] = [CCAppleGreenLight24]::new()
        $this.ColorMap[857] = [CCAppleGreenLight24]::new()
        $this.ColorMap[858] = [CCAppleGreenLight24]::new()
        $this.ColorMap[859] = [CCAppleGreenLight24]::new()
        $this.ColorMap[860] = [CCAppleGreenLight24]::new()
        $this.ColorMap[861] = [CCAppleGreenLight24]::new()
        $this.ColorMap[862] = [CCAppleGreenLight24]::new()
        $this.ColorMap[863] = [CCAppleGreenLight24]::new() # End Row 17
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Finished filling the Color Map.')

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Calling CreateSceneImageATString.')
        $this.CreateSceneImageATString($this.ColorMap)
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Nulling the Color Map.')
        $this.ColorMap = $null
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }
}

Class SIFieldNorthEastRoad : SIInternalBase {
    SIFieldNorthEastRoad(): base() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Updating the Progress Bar for the Scene Image Progress.')
        Write-Progress -Activity 'Creating Scene Images      ' -Id 3 -Status 'Creating SIFieldNorthEastRoad' -PercentComplete -1
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Filling the Color Map.')
        $this.ColorMap[0]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[1]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[2]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[3]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[4]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[5]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[6]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[7]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[8]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[9]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[10]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[11]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[12]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[13]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[14]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[15]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[16]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[17]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[18]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[19]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[20]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[21]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[22]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[23]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[24]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[25]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[26]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[27]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[28]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[29]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[30]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[31]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[32]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[33]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[34]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[35]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[36]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[37]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[38]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[39]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[40]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[41]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[42]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[43]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[44]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[45]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[46]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[47]  = [CCAppleBlueLight24]::new() # End Row 0
        $this.ColorMap[48]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[49]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[50]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[51]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[52]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[53]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[54]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[55]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[56]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[57]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[58]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[59]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[60]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[61]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[62]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[63]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[64]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[65]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[66]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[67]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[68]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[69]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[70]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[71]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[72]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[73]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[74]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[75]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[76]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[77]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[78]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[79]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[80]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[81]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[82]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[83]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[84]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[85]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[86]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[87]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[88]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[89]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[90]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[91]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[92]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[93]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[94]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[95]  = [CCAppleBlueLight24]::new() # End Row 1
        $this.ColorMap[96]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[97]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[98]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[99]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[100] = [CCAppleBlueLight24]::new()
        $this.ColorMap[101] = [CCAppleBlueLight24]::new()
        $this.ColorMap[102] = [CCAppleBlueLight24]::new()
        $this.ColorMap[103] = [CCAppleBlueLight24]::new()
        $this.ColorMap[104] = [CCAppleBlueLight24]::new()
        $this.ColorMap[105] = [CCAppleBlueLight24]::new()
        $this.ColorMap[106] = [CCAppleBlueLight24]::new()
        $this.ColorMap[107] = [CCAppleBlueLight24]::new()
        $this.ColorMap[108] = [CCAppleBlueLight24]::new()
        $this.ColorMap[109] = [CCAppleBlueLight24]::new()
        $this.ColorMap[110] = [CCAppleBlueLight24]::new()
        $this.ColorMap[111] = [CCAppleBlueLight24]::new()
        $this.ColorMap[112] = [CCAppleBlueLight24]::new()
        $this.ColorMap[113] = [CCAppleBlueLight24]::new()
        $this.ColorMap[114] = [CCAppleBlueLight24]::new()
        $this.ColorMap[115] = [CCAppleBlueLight24]::new()
        $this.ColorMap[116] = [CCAppleBlueLight24]::new()
        $this.ColorMap[117] = [CCAppleBlueLight24]::new()
        $this.ColorMap[118] = [CCAppleBlueLight24]::new()
        $this.ColorMap[119] = [CCAppleBlueLight24]::new()
        $this.ColorMap[120] = [CCAppleBlueLight24]::new()
        $this.ColorMap[121] = [CCAppleBlueLight24]::new()
        $this.ColorMap[122] = [CCAppleBlueLight24]::new()
        $this.ColorMap[123] = [CCAppleBlueLight24]::new()
        $this.ColorMap[124] = [CCAppleBlueLight24]::new()
        $this.ColorMap[125] = [CCAppleBlueLight24]::new()
        $this.ColorMap[126] = [CCAppleBlueLight24]::new()
        $this.ColorMap[127] = [CCAppleBlueLight24]::new()
        $this.ColorMap[128] = [CCAppleBlueLight24]::new()
        $this.ColorMap[129] = [CCAppleBlueLight24]::new()
        $this.ColorMap[130] = [CCAppleBlueLight24]::new()
        $this.ColorMap[131] = [CCAppleBlueLight24]::new()
        $this.ColorMap[132] = [CCAppleBlueLight24]::new()
        $this.ColorMap[133] = [CCAppleBlueLight24]::new()
        $this.ColorMap[134] = [CCAppleBlueLight24]::new()
        $this.ColorMap[135] = [CCAppleBlueLight24]::new()
        $this.ColorMap[136] = [CCAppleBlueLight24]::new()
        $this.ColorMap[137] = [CCAppleBlueLight24]::new()
        $this.ColorMap[138] = [CCAppleBlueLight24]::new()
        $this.ColorMap[139] = [CCAppleBlueLight24]::new()
        $this.ColorMap[140] = [CCAppleBlueLight24]::new()
        $this.ColorMap[141] = [CCAppleBlueLight24]::new()
        $this.ColorMap[142] = [CCAppleBlueLight24]::new()
        $this.ColorMap[143] = [CCAppleBlueLight24]::new() # End Row 2
        $this.ColorMap[144] = [CCAppleBlueLight24]::new()
        $this.ColorMap[145] = [CCAppleBlueLight24]::new()
        $this.ColorMap[146] = [CCAppleBlueLight24]::new()
        $this.ColorMap[147] = [CCAppleBlueLight24]::new()
        $this.ColorMap[148] = [CCAppleBlueLight24]::new()
        $this.ColorMap[149] = [CCAppleBlueLight24]::new()
        $this.ColorMap[150] = [CCAppleBlueLight24]::new()
        $this.ColorMap[151] = [CCAppleBlueLight24]::new()
        $this.ColorMap[152] = [CCAppleBlueLight24]::new()
        $this.ColorMap[153] = [CCAppleBlueLight24]::new()
        $this.ColorMap[154] = [CCAppleBlueLight24]::new()
        $this.ColorMap[155] = [CCAppleBlueLight24]::new()
        $this.ColorMap[156] = [CCAppleBlueLight24]::new()
        $this.ColorMap[157] = [CCAppleBlueLight24]::new()
        $this.ColorMap[158] = [CCAppleBlueLight24]::new()
        $this.ColorMap[159] = [CCAppleBlueLight24]::new()
        $this.ColorMap[160] = [CCAppleBlueLight24]::new()
        $this.ColorMap[161] = [CCAppleBlueLight24]::new()
        $this.ColorMap[162] = [CCAppleBlueLight24]::new()
        $this.ColorMap[163] = [CCAppleBlueLight24]::new()
        $this.ColorMap[164] = [CCAppleBlueLight24]::new()
        $this.ColorMap[165] = [CCAppleBlueLight24]::new()
        $this.ColorMap[166] = [CCAppleBlueLight24]::new()
        $this.ColorMap[167] = [CCAppleBlueLight24]::new()
        $this.ColorMap[168] = [CCAppleBlueLight24]::new()
        $this.ColorMap[169] = [CCAppleBlueLight24]::new()
        $this.ColorMap[170] = [CCAppleBlueLight24]::new()
        $this.ColorMap[171] = [CCAppleBlueLight24]::new()
        $this.ColorMap[172] = [CCAppleBlueLight24]::new()
        $this.ColorMap[173] = [CCAppleBlueLight24]::new()
        $this.ColorMap[174] = [CCAppleBlueLight24]::new()
        $this.ColorMap[175] = [CCAppleBlueLight24]::new()
        $this.ColorMap[176] = [CCAppleBlueLight24]::new()
        $this.ColorMap[177] = [CCAppleBlueLight24]::new()
        $this.ColorMap[178] = [CCAppleBlueLight24]::new()
        $this.ColorMap[179] = [CCAppleBlueLight24]::new()
        $this.ColorMap[180] = [CCAppleBlueLight24]::new()
        $this.ColorMap[181] = [CCAppleBlueLight24]::new()
        $this.ColorMap[182] = [CCAppleBlueLight24]::new()
        $this.ColorMap[183] = [CCAppleBlueLight24]::new()
        $this.ColorMap[184] = [CCAppleBlueLight24]::new()
        $this.ColorMap[185] = [CCAppleBlueLight24]::new()
        $this.ColorMap[186] = [CCAppleBlueLight24]::new()
        $this.ColorMap[187] = [CCAppleBlueLight24]::new()
        $this.ColorMap[188] = [CCAppleBlueLight24]::new()
        $this.ColorMap[189] = [CCAppleBlueLight24]::new()
        $this.ColorMap[190] = [CCAppleBlueLight24]::new()
        $this.ColorMap[191] = [CCAppleBlueLight24]::new() # End Row 3
        $this.ColorMap[192] = [CCAppleBlueLight24]::new()
        $this.ColorMap[193] = [CCAppleBlueLight24]::new()
        $this.ColorMap[194] = [CCAppleBlueLight24]::new()
        $this.ColorMap[195] = [CCAppleBlueLight24]::new()
        $this.ColorMap[196] = [CCAppleBlueLight24]::new()
        $this.ColorMap[197] = [CCAppleBlueLight24]::new()
        $this.ColorMap[198] = [CCAppleBlueLight24]::new()
        $this.ColorMap[199] = [CCAppleBlueLight24]::new()
        $this.ColorMap[200] = [CCAppleBlueLight24]::new()
        $this.ColorMap[201] = [CCAppleBlueLight24]::new()
        $this.ColorMap[202] = [CCAppleBlueLight24]::new()
        $this.ColorMap[203] = [CCAppleBlueLight24]::new()
        $this.ColorMap[204] = [CCAppleBlueLight24]::new()
        $this.ColorMap[205] = [CCAppleBlueLight24]::new()
        $this.ColorMap[206] = [CCAppleBlueLight24]::new()
        $this.ColorMap[207] = [CCAppleBlueLight24]::new()
        $this.ColorMap[208] = [CCAppleBlueLight24]::new()
        $this.ColorMap[209] = [CCAppleBlueLight24]::new()
        $this.ColorMap[210] = [CCAppleBlueLight24]::new()
        $this.ColorMap[211] = [CCAppleBlueLight24]::new()
        $this.ColorMap[212] = [CCAppleBlueLight24]::new()
        $this.ColorMap[213] = [CCAppleBlueLight24]::new()
        $this.ColorMap[214] = [CCAppleBlueLight24]::new()
        $this.ColorMap[215] = [CCAppleBlueLight24]::new()
        $this.ColorMap[216] = [CCAppleBlueLight24]::new()
        $this.ColorMap[217] = [CCAppleBlueLight24]::new()
        $this.ColorMap[218] = [CCAppleBlueLight24]::new()
        $this.ColorMap[219] = [CCAppleBlueLight24]::new()
        $this.ColorMap[220] = [CCAppleBlueLight24]::new()
        $this.ColorMap[221] = [CCAppleBlueLight24]::new()
        $this.ColorMap[222] = [CCAppleBlueLight24]::new()
        $this.ColorMap[223] = [CCAppleBlueLight24]::new()
        $this.ColorMap[224] = [CCAppleBlueLight24]::new()
        $this.ColorMap[225] = [CCAppleBlueLight24]::new()
        $this.ColorMap[226] = [CCAppleBlueLight24]::new()
        $this.ColorMap[227] = [CCAppleBlueLight24]::new()
        $this.ColorMap[228] = [CCAppleBlueLight24]::new()
        $this.ColorMap[229] = [CCAppleBlueLight24]::new()
        $this.ColorMap[230] = [CCAppleBlueLight24]::new()
        $this.ColorMap[231] = [CCAppleBlueLight24]::new()
        $this.ColorMap[232] = [CCAppleBlueLight24]::new()
        $this.ColorMap[233] = [CCAppleBlueLight24]::new()
        $this.ColorMap[234] = [CCAppleBlueLight24]::new()
        $this.ColorMap[235] = [CCAppleBlueLight24]::new()
        $this.ColorMap[236] = [CCAppleBlueLight24]::new()
        $this.ColorMap[237] = [CCAppleBlueLight24]::new()
        $this.ColorMap[238] = [CCAppleBlueLight24]::new()
        $this.ColorMap[239] = [CCAppleBlueLight24]::new() # End Row 4
        $this.ColorMap[240] = [CCAppleGreenLight24]::new()
        $this.ColorMap[241] = [CCAppleGreenLight24]::new()
        $this.ColorMap[242] = [CCAppleGreenLight24]::new()
        $this.ColorMap[243] = [CCAppleGreenLight24]::new()
        $this.ColorMap[244] = [CCAppleGreenLight24]::new()
        $this.ColorMap[245] = [CCAppleGreenLight24]::new()
        $this.ColorMap[246] = [CCAppleGreenLight24]::new()
        $this.ColorMap[247] = [CCAppleGreenLight24]::new()
        $this.ColorMap[248] = [CCAppleGreenLight24]::new()
        $this.ColorMap[249] = [CCAppleGreenLight24]::new()
        $this.ColorMap[250] = [CCAppleGreenLight24]::new()
        $this.ColorMap[251] = [CCAppleGreenLight24]::new()
        $this.ColorMap[252] = [CCAppleGreenLight24]::new()
        $this.ColorMap[253] = [CCAppleGreenLight24]::new()
        $this.ColorMap[254] = [CCAppleGreenLight24]::new()
        $this.ColorMap[255] = [CCAppleGreenLight24]::new()
        $this.ColorMap[256] = [CCAppleGreenLight24]::new()
        $this.ColorMap[257] = [CCAppleGreenLight24]::new()
        $this.ColorMap[258] = [CCAppleGreenLight24]::new()
        $this.ColorMap[259] = [CCAppleGreenLight24]::new()
        $this.ColorMap[260] = [CCAppleGreenLight24]::new()
        $this.ColorMap[261] = [CCAppleGreenLight24]::new()
        $this.ColorMap[262] = [CCAppleGreenLight24]::new()
        $this.ColorMap[263] = [CCAppleGreenLight24]::new()
        $this.ColorMap[264] = [CCAppleBrownLight24]::new()
        $this.ColorMap[265] = [CCAppleGreenLight24]::new()
        $this.ColorMap[266] = [CCAppleGreenLight24]::new()
        $this.ColorMap[267] = [CCAppleGreenLight24]::new()
        $this.ColorMap[268] = [CCAppleGreenLight24]::new()
        $this.ColorMap[269] = [CCAppleGreenLight24]::new()
        $this.ColorMap[270] = [CCAppleGreenLight24]::new()
        $this.ColorMap[271] = [CCAppleGreenLight24]::new()
        $this.ColorMap[272] = [CCAppleGreenLight24]::new()
        $this.ColorMap[273] = [CCAppleGreenLight24]::new()
        $this.ColorMap[274] = [CCAppleGreenLight24]::new()
        $this.ColorMap[275] = [CCAppleGreenLight24]::new()
        $this.ColorMap[276] = [CCAppleGreenLight24]::new()
        $this.ColorMap[277] = [CCAppleGreenLight24]::new()
        $this.ColorMap[278] = [CCAppleGreenLight24]::new()
        $this.ColorMap[279] = [CCAppleGreenLight24]::new()
        $this.ColorMap[280] = [CCAppleGreenLight24]::new()
        $this.ColorMap[281] = [CCAppleGreenLight24]::new()
        $this.ColorMap[282] = [CCAppleGreenLight24]::new()
        $this.ColorMap[283] = [CCAppleGreenLight24]::new()
        $this.ColorMap[284] = [CCAppleGreenLight24]::new()
        $this.ColorMap[285] = [CCAppleGreenLight24]::new()
        $this.ColorMap[286] = [CCAppleGreenLight24]::new()
        $this.ColorMap[287] = [CCAppleGreenLight24]::new() # End Row 5
        $this.ColorMap[288] = [CCAppleGreenLight24]::new()
        $this.ColorMap[289] = [CCAppleGreenLight24]::new()
        $this.ColorMap[290] = [CCAppleGreenLight24]::new()
        $this.ColorMap[291] = [CCAppleGreenLight24]::new()
        $this.ColorMap[292] = [CCAppleGreenLight24]::new()
        $this.ColorMap[293] = [CCAppleGreenLight24]::new()
        $this.ColorMap[294] = [CCAppleGreenLight24]::new()
        $this.ColorMap[295] = [CCAppleGreenLight24]::new()
        $this.ColorMap[296] = [CCAppleGreenLight24]::new()
        $this.ColorMap[297] = [CCAppleGreenLight24]::new()
        $this.ColorMap[298] = [CCAppleGreenLight24]::new()
        $this.ColorMap[299] = [CCAppleGreenLight24]::new()
        $this.ColorMap[300] = [CCAppleGreenLight24]::new()
        $this.ColorMap[301] = [CCAppleGreenLight24]::new()
        $this.ColorMap[302] = [CCAppleGreenLight24]::new()
        $this.ColorMap[303] = [CCAppleGreenLight24]::new()
        $this.ColorMap[304] = [CCAppleGreenLight24]::new()
        $this.ColorMap[305] = [CCAppleGreenLight24]::new()
        $this.ColorMap[306] = [CCAppleGreenLight24]::new()
        $this.ColorMap[307] = [CCAppleGreenLight24]::new()
        $this.ColorMap[308] = [CCAppleGreenLight24]::new()
        $this.ColorMap[309] = [CCAppleGreenLight24]::new()
        $this.ColorMap[310] = [CCAppleGreenLight24]::new()
        $this.ColorMap[311] = [CCAppleGreenLight24]::new()
        $this.ColorMap[312] = [CCAppleBrownLight24]::new()
        $this.ColorMap[313] = [CCAppleGreenLight24]::new()
        $this.ColorMap[314] = [CCAppleGreenLight24]::new()
        $this.ColorMap[315] = [CCAppleGreenLight24]::new()
        $this.ColorMap[316] = [CCAppleGreenLight24]::new()
        $this.ColorMap[317] = [CCAppleGreenLight24]::new()
        $this.ColorMap[318] = [CCAppleGreenLight24]::new()
        $this.ColorMap[319] = [CCAppleGreenLight24]::new()
        $this.ColorMap[320] = [CCAppleGreenLight24]::new()
        $this.ColorMap[321] = [CCAppleGreenLight24]::new()
        $this.ColorMap[322] = [CCAppleGreenLight24]::new()
        $this.ColorMap[323] = [CCAppleGreenLight24]::new()
        $this.ColorMap[324] = [CCAppleGreenLight24]::new()
        $this.ColorMap[325] = [CCAppleGreenLight24]::new()
        $this.ColorMap[326] = [CCAppleGreenLight24]::new()
        $this.ColorMap[327] = [CCAppleGreenLight24]::new()
        $this.ColorMap[328] = [CCAppleGreenLight24]::new()
        $this.ColorMap[329] = [CCAppleGreenLight24]::new()
        $this.ColorMap[330] = [CCAppleGreenLight24]::new()
        $this.ColorMap[331] = [CCAppleGreenLight24]::new()
        $this.ColorMap[332] = [CCAppleGreenLight24]::new()
        $this.ColorMap[333] = [CCAppleGreenLight24]::new()
        $this.ColorMap[334] = [CCAppleGreenLight24]::new()
        $this.ColorMap[335] = [CCAppleGreenLight24]::new() # End Row 6
        $this.ColorMap[336] = [CCAppleGreenLight24]::new()
        $this.ColorMap[337] = [CCAppleGreenLight24]::new()
        $this.ColorMap[338] = [CCAppleGreenLight24]::new()
        $this.ColorMap[339] = [CCAppleGreenLight24]::new()
        $this.ColorMap[340] = [CCAppleGreenLight24]::new()
        $this.ColorMap[341] = [CCAppleGreenLight24]::new()
        $this.ColorMap[342] = [CCAppleGreenLight24]::new()
        $this.ColorMap[343] = [CCAppleGreenLight24]::new()
        $this.ColorMap[344] = [CCAppleGreenLight24]::new()
        $this.ColorMap[345] = [CCAppleGreenLight24]::new()
        $this.ColorMap[346] = [CCAppleGreenLight24]::new()
        $this.ColorMap[347] = [CCAppleGreenLight24]::new()
        $this.ColorMap[348] = [CCAppleGreenLight24]::new()
        $this.ColorMap[349] = [CCAppleGreenLight24]::new()
        $this.ColorMap[350] = [CCAppleGreenLight24]::new()
        $this.ColorMap[351] = [CCAppleGreenLight24]::new()
        $this.ColorMap[352] = [CCAppleGreenLight24]::new()
        $this.ColorMap[353] = [CCAppleGreenLight24]::new()
        $this.ColorMap[354] = [CCAppleGreenLight24]::new()
        $this.ColorMap[355] = [CCAppleGreenLight24]::new()
        $this.ColorMap[356] = [CCAppleGreenLight24]::new()
        $this.ColorMap[357] = [CCAppleGreenLight24]::new()
        $this.ColorMap[358] = [CCAppleGreenLight24]::new()
        $this.ColorMap[359] = [CCAppleBrownLight24]::new()
        $this.ColorMap[360] = [CCAppleBrownLight24]::new()
        $this.ColorMap[361] = [CCAppleBrownLight24]::new()
        $this.ColorMap[362] = [CCAppleGreenLight24]::new()
        $this.ColorMap[363] = [CCAppleGreenLight24]::new()
        $this.ColorMap[364] = [CCAppleGreenLight24]::new()
        $this.ColorMap[365] = [CCAppleGreenLight24]::new()
        $this.ColorMap[366] = [CCAppleGreenLight24]::new()
        $this.ColorMap[367] = [CCAppleGreenLight24]::new()
        $this.ColorMap[368] = [CCAppleGreenLight24]::new()
        $this.ColorMap[369] = [CCAppleGreenLight24]::new()
        $this.ColorMap[370] = [CCAppleGreenLight24]::new()
        $this.ColorMap[371] = [CCAppleGreenLight24]::new()
        $this.ColorMap[372] = [CCAppleGreenLight24]::new()
        $this.ColorMap[373] = [CCAppleGreenLight24]::new()
        $this.ColorMap[374] = [CCAppleGreenLight24]::new()
        $this.ColorMap[375] = [CCAppleGreenLight24]::new()
        $this.ColorMap[376] = [CCAppleGreenLight24]::new()
        $this.ColorMap[377] = [CCAppleGreenLight24]::new()
        $this.ColorMap[378] = [CCAppleGreenLight24]::new()
        $this.ColorMap[379] = [CCAppleGreenLight24]::new()
        $this.ColorMap[380] = [CCAppleGreenLight24]::new()
        $this.ColorMap[381] = [CCAppleGreenLight24]::new()
        $this.ColorMap[382] = [CCAppleGreenLight24]::new()
        $this.ColorMap[383] = [CCAppleGreenLight24]::new() # End Row 7
        $this.ColorMap[384] = [CCAppleGreenLight24]::new()
        $this.ColorMap[385] = [CCAppleGreenLight24]::new()
        $this.ColorMap[386] = [CCAppleGreenLight24]::new()
        $this.ColorMap[387] = [CCAppleGreenLight24]::new()
        $this.ColorMap[388] = [CCAppleGreenLight24]::new()
        $this.ColorMap[389] = [CCAppleGreenLight24]::new()
        $this.ColorMap[390] = [CCAppleGreenLight24]::new()
        $this.ColorMap[391] = [CCAppleGreenLight24]::new()
        $this.ColorMap[392] = [CCAppleGreenLight24]::new()
        $this.ColorMap[393] = [CCAppleGreenLight24]::new()
        $this.ColorMap[394] = [CCAppleGreenLight24]::new()
        $this.ColorMap[395] = [CCAppleGreenLight24]::new()
        $this.ColorMap[396] = [CCAppleGreenLight24]::new()
        $this.ColorMap[397] = [CCAppleGreenLight24]::new()
        $this.ColorMap[398] = [CCAppleGreenLight24]::new()
        $this.ColorMap[399] = [CCAppleGreenLight24]::new()
        $this.ColorMap[400] = [CCAppleGreenLight24]::new()
        $this.ColorMap[401] = [CCAppleGreenLight24]::new()
        $this.ColorMap[402] = [CCAppleGreenLight24]::new()
        $this.ColorMap[403] = [CCAppleGreenLight24]::new()
        $this.ColorMap[404] = [CCAppleGreenLight24]::new()
        $this.ColorMap[405] = [CCAppleGreenLight24]::new()
        $this.ColorMap[406] = [CCAppleBrownLight24]::new()
        $this.ColorMap[407] = [CCAppleBrownLight24]::new()
        $this.ColorMap[408] = [CCAppleBrownLight24]::new()
        $this.ColorMap[409] = [CCAppleBrownLight24]::new()
        $this.ColorMap[410] = [CCAppleBrownLight24]::new()
        $this.ColorMap[411] = [CCAppleGreenLight24]::new()
        $this.ColorMap[412] = [CCAppleGreenLight24]::new()
        $this.ColorMap[413] = [CCAppleGreenLight24]::new()
        $this.ColorMap[414] = [CCAppleGreenLight24]::new()
        $this.ColorMap[415] = [CCAppleGreenLight24]::new()
        $this.ColorMap[416] = [CCAppleGreenLight24]::new()
        $this.ColorMap[417] = [CCAppleGreenLight24]::new()
        $this.ColorMap[418] = [CCAppleGreenLight24]::new()
        $this.ColorMap[419] = [CCAppleGreenLight24]::new()
        $this.ColorMap[420] = [CCAppleGreenLight24]::new()
        $this.ColorMap[421] = [CCAppleGreenLight24]::new()
        $this.ColorMap[422] = [CCAppleGreenLight24]::new()
        $this.ColorMap[423] = [CCAppleGreenLight24]::new()
        $this.ColorMap[424] = [CCAppleGreenLight24]::new()
        $this.ColorMap[425] = [CCAppleGreenLight24]::new()
        $this.ColorMap[426] = [CCAppleGreenLight24]::new()
        $this.ColorMap[427] = [CCAppleGreenLight24]::new()
        $this.ColorMap[428] = [CCAppleGreenLight24]::new()
        $this.ColorMap[429] = [CCAppleGreenLight24]::new()
        $this.ColorMap[430] = [CCAppleGreenLight24]::new()
        $this.ColorMap[431] = [CCAppleGreenLight24]::new() # End Row 8
        $this.ColorMap[432] = [CCAppleGreenLight24]::new()
        $this.ColorMap[433] = [CCAppleGreenLight24]::new()
        $this.ColorMap[434] = [CCAppleGreenLight24]::new()
        $this.ColorMap[435] = [CCAppleGreenLight24]::new()
        $this.ColorMap[436] = [CCAppleGreenLight24]::new()
        $this.ColorMap[437] = [CCAppleGreenLight24]::new()
        $this.ColorMap[438] = [CCAppleGreenLight24]::new()
        $this.ColorMap[439] = [CCAppleGreenLight24]::new()
        $this.ColorMap[440] = [CCAppleGreenLight24]::new()
        $this.ColorMap[441] = [CCAppleGreenLight24]::new()
        $this.ColorMap[442] = [CCAppleGreenLight24]::new()
        $this.ColorMap[443] = [CCAppleGreenLight24]::new()
        $this.ColorMap[444] = [CCAppleGreenLight24]::new()
        $this.ColorMap[445] = [CCAppleGreenLight24]::new()
        $this.ColorMap[446] = [CCAppleGreenLight24]::new()
        $this.ColorMap[447] = [CCAppleGreenLight24]::new()
        $this.ColorMap[448] = [CCAppleGreenLight24]::new()
        $this.ColorMap[449] = [CCAppleGreenLight24]::new()
        $this.ColorMap[450] = [CCAppleGreenLight24]::new()
        $this.ColorMap[451] = [CCAppleGreenLight24]::new()
        $this.ColorMap[452] = [CCAppleGreenLight24]::new()
        $this.ColorMap[453] = [CCAppleGreenLight24]::new()
        $this.ColorMap[454] = [CCAppleBrownLight24]::new()
        $this.ColorMap[455] = [CCAppleBrownLight24]::new()
        $this.ColorMap[456] = [CCAppleBrownLight24]::new()
        $this.ColorMap[457] = [CCAppleBrownLight24]::new()
        $this.ColorMap[458] = [CCAppleBrownLight24]::new()
        $this.ColorMap[459] = [CCAppleGreenLight24]::new()
        $this.ColorMap[460] = [CCAppleGreenLight24]::new()
        $this.ColorMap[461] = [CCAppleGreenLight24]::new()
        $this.ColorMap[462] = [CCAppleGreenLight24]::new()
        $this.ColorMap[463] = [CCAppleGreenLight24]::new()
        $this.ColorMap[464] = [CCAppleGreenLight24]::new()
        $this.ColorMap[465] = [CCAppleGreenLight24]::new()
        $this.ColorMap[466] = [CCAppleGreenLight24]::new()
        $this.ColorMap[467] = [CCAppleGreenLight24]::new()
        $this.ColorMap[468] = [CCAppleGreenLight24]::new()
        $this.ColorMap[469] = [CCAppleGreenLight24]::new()
        $this.ColorMap[470] = [CCAppleGreenLight24]::new()
        $this.ColorMap[471] = [CCAppleGreenLight24]::new()
        $this.ColorMap[472] = [CCAppleGreenLight24]::new()
        $this.ColorMap[473] = [CCAppleGreenLight24]::new()
        $this.ColorMap[474] = [CCAppleGreenLight24]::new()
        $this.ColorMap[475] = [CCAppleGreenLight24]::new()
        $this.ColorMap[476] = [CCAppleGreenLight24]::new()
        $this.ColorMap[477] = [CCAppleGreenLight24]::new()
        $this.ColorMap[478] = [CCAppleGreenLight24]::new()
        $this.ColorMap[479] = [CCAppleGreenLight24]::new() # End Row 9
        $this.ColorMap[480] = [CCAppleGreenLight24]::new()
        $this.ColorMap[481] = [CCAppleGreenLight24]::new()
        $this.ColorMap[482] = [CCAppleGreenLight24]::new()
        $this.ColorMap[483] = [CCAppleGreenLight24]::new()
        $this.ColorMap[484] = [CCAppleGreenLight24]::new()
        $this.ColorMap[485] = [CCAppleGreenLight24]::new()
        $this.ColorMap[486] = [CCAppleGreenLight24]::new()
        $this.ColorMap[487] = [CCAppleGreenLight24]::new()
        $this.ColorMap[488] = [CCAppleGreenLight24]::new()
        $this.ColorMap[489] = [CCAppleGreenLight24]::new()
        $this.ColorMap[490] = [CCAppleGreenLight24]::new()
        $this.ColorMap[491] = [CCAppleGreenLight24]::new()
        $this.ColorMap[492] = [CCAppleGreenLight24]::new()
        $this.ColorMap[493] = [CCAppleGreenLight24]::new()
        $this.ColorMap[494] = [CCAppleGreenLight24]::new()
        $this.ColorMap[495] = [CCAppleGreenLight24]::new()
        $this.ColorMap[496] = [CCAppleGreenLight24]::new()
        $this.ColorMap[497] = [CCAppleGreenLight24]::new()
        $this.ColorMap[498] = [CCAppleGreenLight24]::new()
        $this.ColorMap[499] = [CCAppleGreenLight24]::new()
        $this.ColorMap[500] = [CCAppleGreenLight24]::new()
        $this.ColorMap[501] = [CCAppleBrownLight24]::new()
        $this.ColorMap[502] = [CCAppleBrownLight24]::new()
        $this.ColorMap[503] = [CCAppleBrownLight24]::new()
        $this.ColorMap[504] = [CCAppleBrownLight24]::new()
        $this.ColorMap[505] = [CCAppleBrownLight24]::new()
        $this.ColorMap[506] = [CCAppleBrownLight24]::new()
        $this.ColorMap[507] = [CCAppleBrownLight24]::new()
        $this.ColorMap[508] = [CCAppleGreenLight24]::new()
        $this.ColorMap[509] = [CCAppleGreenLight24]::new()
        $this.ColorMap[510] = [CCAppleGreenLight24]::new()
        $this.ColorMap[511] = [CCAppleGreenLight24]::new()
        $this.ColorMap[512] = [CCAppleGreenLight24]::new()
        $this.ColorMap[513] = [CCAppleGreenLight24]::new()
        $this.ColorMap[514] = [CCAppleGreenLight24]::new()
        $this.ColorMap[515] = [CCAppleGreenLight24]::new()
        $this.ColorMap[516] = [CCAppleGreenLight24]::new()
        $this.ColorMap[517] = [CCAppleGreenLight24]::new()
        $this.ColorMap[518] = [CCAppleGreenLight24]::new()
        $this.ColorMap[519] = [CCAppleGreenLight24]::new()
        $this.ColorMap[520] = [CCAppleGreenLight24]::new()
        $this.ColorMap[521] = [CCAppleGreenLight24]::new()
        $this.ColorMap[522] = [CCAppleGreenLight24]::new()
        $this.ColorMap[523] = [CCAppleGreenLight24]::new()
        $this.ColorMap[524] = [CCAppleGreenLight24]::new()
        $this.ColorMap[525] = [CCAppleGreenLight24]::new()
        $this.ColorMap[526] = [CCAppleGreenLight24]::new()
        $this.ColorMap[527] = [CCAppleGreenLight24]::new() # End Row 10
        $this.ColorMap[528] = [CCAppleGreenLight24]::new()
        $this.ColorMap[529] = [CCAppleGreenLight24]::new()
        $this.ColorMap[530] = [CCAppleGreenLight24]::new()
        $this.ColorMap[531] = [CCAppleGreenLight24]::new()
        $this.ColorMap[532] = [CCAppleGreenLight24]::new()
        $this.ColorMap[533] = [CCAppleGreenLight24]::new()
        $this.ColorMap[534] = [CCAppleGreenLight24]::new()
        $this.ColorMap[535] = [CCAppleGreenLight24]::new()
        $this.ColorMap[536] = [CCAppleGreenLight24]::new()
        $this.ColorMap[537] = [CCAppleGreenLight24]::new()
        $this.ColorMap[538] = [CCAppleGreenLight24]::new()
        $this.ColorMap[539] = [CCAppleGreenLight24]::new()
        $this.ColorMap[540] = [CCAppleGreenLight24]::new()
        $this.ColorMap[541] = [CCAppleGreenLight24]::new()
        $this.ColorMap[542] = [CCAppleGreenLight24]::new()
        $this.ColorMap[543] = [CCAppleGreenLight24]::new()
        $this.ColorMap[544] = [CCAppleGreenLight24]::new()
        $this.ColorMap[545] = [CCAppleGreenLight24]::new()
        $this.ColorMap[546] = [CCAppleGreenLight24]::new()
        $this.ColorMap[547] = [CCAppleGreenLight24]::new()
        $this.ColorMap[548] = [CCAppleGreenLight24]::new()
        $this.ColorMap[549] = [CCAppleBrownLight24]::new()
        $this.ColorMap[550] = [CCAppleBrownLight24]::new()
        $this.ColorMap[551] = [CCAppleBrownLight24]::new()
        $this.ColorMap[552] = [CCAppleBrownLight24]::new()
        $this.ColorMap[553] = [CCAppleBrownLight24]::new()
        $this.ColorMap[554] = [CCAppleBrownLight24]::new()
        $this.ColorMap[555] = [CCAppleBrownLight24]::new()
        $this.ColorMap[556] = [CCAppleGreenLight24]::new()
        $this.ColorMap[557] = [CCAppleGreenLight24]::new()
        $this.ColorMap[558] = [CCAppleGreenLight24]::new()
        $this.ColorMap[559] = [CCAppleGreenLight24]::new()
        $this.ColorMap[560] = [CCAppleGreenLight24]::new()
        $this.ColorMap[561] = [CCAppleGreenLight24]::new()
        $this.ColorMap[562] = [CCAppleGreenLight24]::new()
        $this.ColorMap[563] = [CCAppleGreenLight24]::new()
        $this.ColorMap[564] = [CCAppleGreenLight24]::new()
        $this.ColorMap[565] = [CCAppleGreenLight24]::new()
        $this.ColorMap[566] = [CCAppleGreenLight24]::new()
        $this.ColorMap[567] = [CCAppleGreenLight24]::new()
        $this.ColorMap[568] = [CCAppleGreenLight24]::new()
        $this.ColorMap[569] = [CCAppleGreenLight24]::new()
        $this.ColorMap[570] = [CCAppleGreenLight24]::new()
        $this.ColorMap[571] = [CCAppleGreenLight24]::new()
        $this.ColorMap[572] = [CCAppleGreenLight24]::new()
        $this.ColorMap[573] = [CCAppleGreenLight24]::new()
        $this.ColorMap[574] = [CCAppleGreenLight24]::new()
        $this.ColorMap[575] = [CCAppleGreenLight24]::new() # End Row 11
        $this.ColorMap[576] = [CCAppleGreenLight24]::new()
        $this.ColorMap[577] = [CCAppleGreenLight24]::new()
        $this.ColorMap[578] = [CCAppleGreenLight24]::new()
        $this.ColorMap[579] = [CCAppleGreenLight24]::new()
        $this.ColorMap[580] = [CCAppleGreenLight24]::new()
        $this.ColorMap[581] = [CCAppleGreenLight24]::new()
        $this.ColorMap[582] = [CCAppleGreenLight24]::new()
        $this.ColorMap[583] = [CCAppleGreenLight24]::new()
        $this.ColorMap[584] = [CCAppleGreenLight24]::new()
        $this.ColorMap[585] = [CCAppleGreenLight24]::new()
        $this.ColorMap[586] = [CCAppleGreenLight24]::new()
        $this.ColorMap[587] = [CCAppleGreenLight24]::new()
        $this.ColorMap[588] = [CCAppleGreenLight24]::new()
        $this.ColorMap[589] = [CCAppleGreenLight24]::new()
        $this.ColorMap[590] = [CCAppleGreenLight24]::new()
        $this.ColorMap[591] = [CCAppleGreenLight24]::new()
        $this.ColorMap[592] = [CCAppleGreenLight24]::new()
        $this.ColorMap[593] = [CCAppleGreenLight24]::new()
        $this.ColorMap[594] = [CCAppleGreenLight24]::new()
        $this.ColorMap[595] = [CCAppleGreenLight24]::new()
        $this.ColorMap[596] = [CCAppleGreenLight24]::new()
        $this.ColorMap[597] = [CCAppleBrownLight24]::new()
        $this.ColorMap[598] = [CCAppleBrownLight24]::new()
        $this.ColorMap[599] = [CCAppleBrownLight24]::new()
        $this.ColorMap[600] = [CCAppleBrownLight24]::new()
        $this.ColorMap[601] = [CCAppleBrownLight24]::new()
        $this.ColorMap[602] = [CCAppleBrownLight24]::new()
        $this.ColorMap[603] = [CCAppleBrownLight24]::new()
        $this.ColorMap[604] = [CCAppleGreenLight24]::new()
        $this.ColorMap[605] = [CCAppleGreenLight24]::new()
        $this.ColorMap[606] = [CCAppleGreenLight24]::new()
        $this.ColorMap[607] = [CCAppleGreenLight24]::new()
        $this.ColorMap[608] = [CCAppleGreenLight24]::new()
        $this.ColorMap[609] = [CCAppleGreenLight24]::new()
        $this.ColorMap[610] = [CCAppleGreenLight24]::new()
        $this.ColorMap[611] = [CCAppleGreenLight24]::new()
        $this.ColorMap[612] = [CCAppleGreenLight24]::new()
        $this.ColorMap[613] = [CCAppleGreenLight24]::new()
        $this.ColorMap[614] = [CCAppleGreenLight24]::new()
        $this.ColorMap[615] = [CCAppleGreenLight24]::new()
        $this.ColorMap[616] = [CCAppleGreenLight24]::new()
        $this.ColorMap[617] = [CCAppleGreenLight24]::new()
        $this.ColorMap[618] = [CCAppleGreenLight24]::new()
        $this.ColorMap[619] = [CCAppleGreenLight24]::new()
        $this.ColorMap[620] = [CCAppleGreenLight24]::new()
        $this.ColorMap[621] = [CCAppleGreenLight24]::new()
        $this.ColorMap[622] = [CCAppleGreenLight24]::new()
        $this.ColorMap[623] = [CCAppleGreenLight24]::new() # End Row 12
        $this.ColorMap[624] = [CCAppleGreenLight24]::new()
        $this.ColorMap[625] = [CCAppleGreenLight24]::new()
        $this.ColorMap[626] = [CCAppleGreenLight24]::new()
        $this.ColorMap[627] = [CCAppleGreenLight24]::new()
        $this.ColorMap[628] = [CCAppleGreenLight24]::new()
        $this.ColorMap[629] = [CCAppleGreenLight24]::new()
        $this.ColorMap[630] = [CCAppleGreenLight24]::new()
        $this.ColorMap[631] = [CCAppleGreenLight24]::new()
        $this.ColorMap[632] = [CCAppleGreenLight24]::new()
        $this.ColorMap[633] = [CCAppleGreenLight24]::new()
        $this.ColorMap[634] = [CCAppleGreenLight24]::new()
        $this.ColorMap[635] = [CCAppleGreenLight24]::new()
        $this.ColorMap[636] = [CCAppleGreenLight24]::new()
        $this.ColorMap[637] = [CCAppleGreenLight24]::new()
        $this.ColorMap[638] = [CCAppleGreenLight24]::new()
        $this.ColorMap[639] = [CCAppleGreenLight24]::new()
        $this.ColorMap[640] = [CCAppleGreenLight24]::new()
        $this.ColorMap[641] = [CCAppleGreenLight24]::new()
        $this.ColorMap[642] = [CCAppleGreenLight24]::new()
        $this.ColorMap[643] = [CCAppleGreenLight24]::new()
        $this.ColorMap[644] = [CCAppleGreenLight24]::new()
        $this.ColorMap[645] = [CCAppleBrownLight24]::new()
        $this.ColorMap[646] = [CCAppleBrownLight24]::new()
        $this.ColorMap[647] = [CCAppleBrownLight24]::new()
        $this.ColorMap[648] = [CCAppleBrownLight24]::new()
        $this.ColorMap[649] = [CCAppleBrownLight24]::new()
        $this.ColorMap[650] = [CCAppleBrownLight24]::new()
        $this.ColorMap[651] = [CCAppleBrownLight24]::new()
        $this.ColorMap[652] = [CCAppleGreenLight24]::new()
        $this.ColorMap[653] = [CCAppleGreenLight24]::new()
        $this.ColorMap[654] = [CCAppleGreenLight24]::new()
        $this.ColorMap[655] = [CCAppleGreenLight24]::new()
        $this.ColorMap[656] = [CCAppleGreenLight24]::new()
        $this.ColorMap[657] = [CCAppleGreenLight24]::new()
        $this.ColorMap[658] = [CCAppleGreenLight24]::new()
        $this.ColorMap[659] = [CCAppleGreenLight24]::new()
        $this.ColorMap[660] = [CCAppleGreenLight24]::new()
        $this.ColorMap[661] = [CCAppleGreenLight24]::new()
        $this.ColorMap[662] = [CCAppleGreenLight24]::new()
        $this.ColorMap[663] = [CCAppleGreenLight24]::new()
        $this.ColorMap[664] = [CCAppleGreenLight24]::new()
        $this.ColorMap[665] = [CCAppleGreenLight24]::new()
        $this.ColorMap[666] = [CCAppleGreenLight24]::new()
        $this.ColorMap[667] = [CCAppleGreenLight24]::new()
        $this.ColorMap[668] = [CCAppleGreenLight24]::new()
        $this.ColorMap[669] = [CCAppleGreenLight24]::new()
        $this.ColorMap[670] = [CCAppleGreenLight24]::new()
        $this.ColorMap[671] = [CCAppleGreenLight24]::new() # End Row 13
        $this.ColorMap[672] = [CCAppleGreenLight24]::new()
        $this.ColorMap[673] = [CCAppleGreenLight24]::new()
        $this.ColorMap[674] = [CCAppleGreenLight24]::new()
        $this.ColorMap[675] = [CCAppleGreenLight24]::new()
        $this.ColorMap[676] = [CCAppleGreenLight24]::new()
        $this.ColorMap[677] = [CCAppleGreenLight24]::new()
        $this.ColorMap[678] = [CCAppleGreenLight24]::new()
        $this.ColorMap[679] = [CCAppleGreenLight24]::new()
        $this.ColorMap[680] = [CCAppleGreenLight24]::new()
        $this.ColorMap[681] = [CCAppleGreenLight24]::new()
        $this.ColorMap[682] = [CCAppleGreenLight24]::new()
        $this.ColorMap[683] = [CCAppleGreenLight24]::new()
        $this.ColorMap[684] = [CCAppleGreenLight24]::new()
        $this.ColorMap[685] = [CCAppleGreenLight24]::new()
        $this.ColorMap[686] = [CCAppleGreenLight24]::new()
        $this.ColorMap[687] = [CCAppleGreenLight24]::new()
        $this.ColorMap[688] = [CCAppleGreenLight24]::new()
        $this.ColorMap[689] = [CCAppleGreenLight24]::new()
        $this.ColorMap[690] = [CCAppleGreenLight24]::new()
        $this.ColorMap[691] = [CCAppleGreenLight24]::new()
        $this.ColorMap[692] = [CCAppleGreenLight24]::new()
        $this.ColorMap[693] = [CCAppleBrownLight24]::new()
        $this.ColorMap[694] = [CCAppleBrownLight24]::new()
        $this.ColorMap[695] = [CCAppleBrownLight24]::new()
        $this.ColorMap[696] = [CCAppleBrownLight24]::new()
        $this.ColorMap[697] = [CCAppleBrownLight24]::new()
        $this.ColorMap[698] = [CCAppleBrownLight24]::new()
        $this.ColorMap[699] = [CCAppleBrownLight24]::new()
        $this.ColorMap[700] = [CCAppleGreenLight24]::new()
        $this.ColorMap[701] = [CCAppleGreenLight24]::new()
        $this.ColorMap[702] = [CCAppleGreenLight24]::new()
        $this.ColorMap[703] = [CCAppleGreenLight24]::new()
        $this.ColorMap[704] = [CCAppleGreenLight24]::new()
        $this.ColorMap[705] = [CCAppleGreenLight24]::new()
        $this.ColorMap[706] = [CCAppleGreenLight24]::new()
        $this.ColorMap[707] = [CCAppleGreenLight24]::new()
        $this.ColorMap[708] = [CCAppleGreenLight24]::new()
        $this.ColorMap[709] = [CCAppleGreenLight24]::new()
        $this.ColorMap[710] = [CCAppleGreenLight24]::new()
        $this.ColorMap[711] = [CCAppleGreenLight24]::new()
        $this.ColorMap[712] = [CCAppleGreenLight24]::new()
        $this.ColorMap[713] = [CCAppleGreenLight24]::new()
        $this.ColorMap[714] = [CCAppleGreenLight24]::new()
        $this.ColorMap[715] = [CCAppleGreenLight24]::new()
        $this.ColorMap[716] = [CCAppleGreenLight24]::new()
        $this.ColorMap[717] = [CCAppleGreenLight24]::new()
        $this.ColorMap[718] = [CCAppleGreenLight24]::new()
        $this.ColorMap[719] = [CCAppleGreenLight24]::new() # End Row 14
        $this.ColorMap[720] = [CCAppleGreenLight24]::new()
        $this.ColorMap[721] = [CCAppleGreenLight24]::new()
        $this.ColorMap[722] = [CCAppleGreenLight24]::new()
        $this.ColorMap[723] = [CCAppleGreenLight24]::new()
        $this.ColorMap[724] = [CCAppleGreenLight24]::new()
        $this.ColorMap[725] = [CCAppleGreenLight24]::new()
        $this.ColorMap[726] = [CCAppleGreenLight24]::new()
        $this.ColorMap[727] = [CCAppleGreenLight24]::new()
        $this.ColorMap[728] = [CCAppleGreenLight24]::new()
        $this.ColorMap[729] = [CCAppleGreenLight24]::new()
        $this.ColorMap[730] = [CCAppleGreenLight24]::new()
        $this.ColorMap[731] = [CCAppleGreenLight24]::new()
        $this.ColorMap[732] = [CCAppleGreenLight24]::new()
        $this.ColorMap[733] = [CCAppleGreenLight24]::new()
        $this.ColorMap[734] = [CCAppleGreenLight24]::new()
        $this.ColorMap[735] = [CCAppleGreenLight24]::new()
        $this.ColorMap[736] = [CCAppleGreenLight24]::new()
        $this.ColorMap[737] = [CCAppleGreenLight24]::new()
        $this.ColorMap[738] = [CCAppleGreenLight24]::new()
        $this.ColorMap[739] = [CCAppleGreenLight24]::new()
        $this.ColorMap[740] = [CCAppleGreenLight24]::new()
        $this.ColorMap[741] = [CCAppleBrownLight24]::new()
        $this.ColorMap[742] = [CCAppleBrownLight24]::new()
        $this.ColorMap[743] = [CCAppleBrownLight24]::new()
        $this.ColorMap[744] = [CCAppleBrownLight24]::new()
        $this.ColorMap[745] = [CCAppleBrownLight24]::new()
        $this.ColorMap[746] = [CCAppleBrownLight24]::new()
        $this.ColorMap[747] = [CCAppleBrownLight24]::new()
        $this.ColorMap[748] = [CCAppleGreenLight24]::new()
        $this.ColorMap[749] = [CCAppleGreenLight24]::new()
        $this.ColorMap[750] = [CCAppleGreenLight24]::new()
        $this.ColorMap[751] = [CCAppleGreenLight24]::new()
        $this.ColorMap[752] = [CCAppleGreenLight24]::new()
        $this.ColorMap[753] = [CCAppleGreenLight24]::new()
        $this.ColorMap[754] = [CCAppleGreenLight24]::new()
        $this.ColorMap[755] = [CCAppleGreenLight24]::new()
        $this.ColorMap[756] = [CCAppleGreenLight24]::new()
        $this.ColorMap[757] = [CCAppleGreenLight24]::new()
        $this.ColorMap[758] = [CCAppleGreenLight24]::new()
        $this.ColorMap[759] = [CCAppleGreenLight24]::new()
        $this.ColorMap[760] = [CCAppleGreenLight24]::new()
        $this.ColorMap[761] = [CCAppleGreenLight24]::new()
        $this.ColorMap[762] = [CCAppleGreenLight24]::new()
        $this.ColorMap[763] = [CCAppleGreenLight24]::new()
        $this.ColorMap[764] = [CCAppleGreenLight24]::new()
        $this.ColorMap[765] = [CCAppleGreenLight24]::new()
        $this.ColorMap[766] = [CCAppleGreenLight24]::new()
        $this.ColorMap[767] = [CCAppleGreenLight24]::new() # End Row 15
        $this.ColorMap[768] = [CCAppleGreenLight24]::new()
        $this.ColorMap[769] = [CCAppleGreenLight24]::new()
        $this.ColorMap[770] = [CCAppleGreenLight24]::new()
        $this.ColorMap[771] = [CCAppleGreenLight24]::new()
        $this.ColorMap[772] = [CCAppleGreenLight24]::new()
        $this.ColorMap[773] = [CCAppleGreenLight24]::new()
        $this.ColorMap[774] = [CCAppleGreenLight24]::new()
        $this.ColorMap[775] = [CCAppleGreenLight24]::new()
        $this.ColorMap[776] = [CCAppleGreenLight24]::new()
        $this.ColorMap[777] = [CCAppleGreenLight24]::new()
        $this.ColorMap[778] = [CCAppleGreenLight24]::new()
        $this.ColorMap[779] = [CCAppleGreenLight24]::new()
        $this.ColorMap[780] = [CCAppleGreenLight24]::new()
        $this.ColorMap[781] = [CCAppleGreenLight24]::new()
        $this.ColorMap[782] = [CCAppleGreenLight24]::new()
        $this.ColorMap[783] = [CCAppleGreenLight24]::new()
        $this.ColorMap[784] = [CCAppleGreenLight24]::new()
        $this.ColorMap[785] = [CCAppleGreenLight24]::new()
        $this.ColorMap[786] = [CCAppleGreenLight24]::new()
        $this.ColorMap[787] = [CCAppleGreenLight24]::new()
        $this.ColorMap[788] = [CCAppleGreenLight24]::new()
        $this.ColorMap[789] = [CCAppleBrownLight24]::new()
        $this.ColorMap[790] = [CCAppleBrownLight24]::new()
        $this.ColorMap[791] = [CCAppleBrownLight24]::new()
        $this.ColorMap[792] = [CCAppleBrownLight24]::new()
        $this.ColorMap[793] = [CCAppleBrownLight24]::new()
        $this.ColorMap[794] = [CCAppleBrownLight24]::new()
        $this.ColorMap[795] = [CCAppleBrownLight24]::new()
        $this.ColorMap[796] = [CCAppleBrownLight24]::new()
        $this.ColorMap[797] = [CCAppleBrownLight24]::new()
        $this.ColorMap[798] = [CCAppleBrownLight24]::new()
        $this.ColorMap[799] = [CCAppleBrownLight24]::new()
        $this.ColorMap[800] = [CCAppleBrownLight24]::new()
        $this.ColorMap[801] = [CCAppleBrownLight24]::new()
        $this.ColorMap[802] = [CCAppleBrownLight24]::new()
        $this.ColorMap[803] = [CCAppleBrownLight24]::new()
        $this.ColorMap[804] = [CCAppleBrownLight24]::new()
        $this.ColorMap[805] = [CCAppleBrownLight24]::new()
        $this.ColorMap[806] = [CCAppleBrownLight24]::new()
        $this.ColorMap[807] = [CCAppleBrownLight24]::new()
        $this.ColorMap[808] = [CCAppleBrownLight24]::new()
        $this.ColorMap[809] = [CCAppleBrownLight24]::new()
        $this.ColorMap[810] = [CCAppleBrownLight24]::new()
        $this.ColorMap[811] = [CCAppleBrownLight24]::new()
        $this.ColorMap[812] = [CCAppleBrownLight24]::new()
        $this.ColorMap[813] = [CCAppleBrownLight24]::new()
        $this.ColorMap[814] = [CCAppleBrownLight24]::new()
        $this.ColorMap[815] = [CCAppleBrownLight24]::new() # End Row 16
        $this.ColorMap[816] = [CCAppleGreenLight24]::new()
        $this.ColorMap[817] = [CCAppleGreenLight24]::new()
        $this.ColorMap[818] = [CCAppleGreenLight24]::new()
        $this.ColorMap[819] = [CCAppleGreenLight24]::new()
        $this.ColorMap[820] = [CCAppleGreenLight24]::new()
        $this.ColorMap[821] = [CCAppleGreenLight24]::new()
        $this.ColorMap[822] = [CCAppleGreenLight24]::new()
        $this.ColorMap[823] = [CCAppleGreenLight24]::new()
        $this.ColorMap[824] = [CCAppleGreenLight24]::new()
        $this.ColorMap[825] = [CCAppleGreenLight24]::new()
        $this.ColorMap[826] = [CCAppleGreenLight24]::new()
        $this.ColorMap[827] = [CCAppleGreenLight24]::new()
        $this.ColorMap[828] = [CCAppleGreenLight24]::new()
        $this.ColorMap[829] = [CCAppleGreenLight24]::new()
        $this.ColorMap[830] = [CCAppleGreenLight24]::new()
        $this.ColorMap[831] = [CCAppleGreenLight24]::new()
        $this.ColorMap[832] = [CCAppleGreenLight24]::new()
        $this.ColorMap[833] = [CCAppleGreenLight24]::new()
        $this.ColorMap[834] = [CCAppleGreenLight24]::new()
        $this.ColorMap[835] = [CCAppleGreenLight24]::new()
        $this.ColorMap[836] = [CCAppleGreenLight24]::new()
        $this.ColorMap[837] = [CCAppleBrownLight24]::new()
        $this.ColorMap[838] = [CCAppleBrownLight24]::new()
        $this.ColorMap[839] = [CCAppleBrownLight24]::new()
        $this.ColorMap[840] = [CCAppleBrownLight24]::new()
        $this.ColorMap[841] = [CCAppleBrownLight24]::new()
        $this.ColorMap[842] = [CCAppleBrownLight24]::new()
        $this.ColorMap[843] = [CCAppleBrownLight24]::new()
        $this.ColorMap[844] = [CCAppleBrownLight24]::new()
        $this.ColorMap[845] = [CCAppleBrownLight24]::new()
        $this.ColorMap[846] = [CCAppleBrownLight24]::new()
        $this.ColorMap[847] = [CCAppleBrownLight24]::new()
        $this.ColorMap[848] = [CCAppleBrownLight24]::new()
        $this.ColorMap[849] = [CCAppleBrownLight24]::new()
        $this.ColorMap[850] = [CCAppleBrownLight24]::new()
        $this.ColorMap[851] = [CCAppleBrownLight24]::new()
        $this.ColorMap[852] = [CCAppleBrownLight24]::new()
        $this.ColorMap[853] = [CCAppleBrownLight24]::new()
        $this.ColorMap[854] = [CCAppleBrownLight24]::new()
        $this.ColorMap[855] = [CCAppleBrownLight24]::new()
        $this.ColorMap[856] = [CCAppleBrownLight24]::new()
        $this.ColorMap[857] = [CCAppleBrownLight24]::new()
        $this.ColorMap[858] = [CCAppleBrownLight24]::new()
        $this.ColorMap[859] = [CCAppleBrownLight24]::new()
        $this.ColorMap[860] = [CCAppleBrownLight24]::new()
        $this.ColorMap[861] = [CCAppleBrownLight24]::new()
        $this.ColorMap[862] = [CCAppleBrownLight24]::new()
        $this.ColorMap[863] = [CCAppleBrownLight24]::new() # End Row 17
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Finished filling the Color Map.')

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Calling CreateSceneImageATString.')
        $this.CreateSceneImageATString($this.ColorMap)
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Nulling the Color Map.')
        $this.ColorMap = $null
    }
}

Class SIFieldNorthWestRoad : SIInternalBase {
    SIFieldNorthWestRoad(): base() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Updating the Progress Bar for the Scene Image Progress.')
        Write-Progress -Activity 'Creating Scene Images      ' -Id 3 -Status 'Creating SIFieldNorthWestRoad' -PercentComplete -1
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Filling the Color Map.')
        $this.ColorMap[0]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[1]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[2]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[3]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[4]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[5]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[6]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[7]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[8]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[9]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[10]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[11]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[12]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[13]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[14]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[15]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[16]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[17]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[18]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[19]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[20]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[21]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[22]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[23]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[24]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[25]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[26]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[27]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[28]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[29]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[30]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[31]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[32]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[33]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[34]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[35]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[36]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[37]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[38]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[39]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[40]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[41]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[42]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[43]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[44]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[45]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[46]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[47]  = [CCAppleBlueLight24]::new() # End Row 0
        $this.ColorMap[48]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[49]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[50]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[51]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[52]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[53]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[54]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[55]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[56]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[57]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[58]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[59]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[60]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[61]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[62]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[63]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[64]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[65]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[66]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[67]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[68]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[69]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[70]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[71]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[72]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[73]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[74]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[75]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[76]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[77]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[78]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[79]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[80]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[81]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[82]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[83]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[84]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[85]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[86]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[87]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[88]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[89]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[90]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[91]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[92]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[93]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[94]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[95]  = [CCAppleBlueLight24]::new() # End Row 1
        $this.ColorMap[96]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[97]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[98]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[99]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[100] = [CCAppleBlueLight24]::new()
        $this.ColorMap[101] = [CCAppleBlueLight24]::new()
        $this.ColorMap[102] = [CCAppleBlueLight24]::new()
        $this.ColorMap[103] = [CCAppleBlueLight24]::new()
        $this.ColorMap[104] = [CCAppleBlueLight24]::new()
        $this.ColorMap[105] = [CCAppleBlueLight24]::new()
        $this.ColorMap[106] = [CCAppleBlueLight24]::new()
        $this.ColorMap[107] = [CCAppleBlueLight24]::new()
        $this.ColorMap[108] = [CCAppleBlueLight24]::new()
        $this.ColorMap[109] = [CCAppleBlueLight24]::new()
        $this.ColorMap[110] = [CCAppleBlueLight24]::new()
        $this.ColorMap[111] = [CCAppleBlueLight24]::new()
        $this.ColorMap[112] = [CCAppleBlueLight24]::new()
        $this.ColorMap[113] = [CCAppleBlueLight24]::new()
        $this.ColorMap[114] = [CCAppleBlueLight24]::new()
        $this.ColorMap[115] = [CCAppleBlueLight24]::new()
        $this.ColorMap[116] = [CCAppleBlueLight24]::new()
        $this.ColorMap[117] = [CCAppleBlueLight24]::new()
        $this.ColorMap[118] = [CCAppleBlueLight24]::new()
        $this.ColorMap[119] = [CCAppleBlueLight24]::new()
        $this.ColorMap[120] = [CCAppleBlueLight24]::new()
        $this.ColorMap[121] = [CCAppleBlueLight24]::new()
        $this.ColorMap[122] = [CCAppleBlueLight24]::new()
        $this.ColorMap[123] = [CCAppleBlueLight24]::new()
        $this.ColorMap[124] = [CCAppleBlueLight24]::new()
        $this.ColorMap[125] = [CCAppleBlueLight24]::new()
        $this.ColorMap[126] = [CCAppleBlueLight24]::new()
        $this.ColorMap[127] = [CCAppleBlueLight24]::new()
        $this.ColorMap[128] = [CCAppleBlueLight24]::new()
        $this.ColorMap[129] = [CCAppleBlueLight24]::new()
        $this.ColorMap[130] = [CCAppleBlueLight24]::new()
        $this.ColorMap[131] = [CCAppleBlueLight24]::new()
        $this.ColorMap[132] = [CCAppleBlueLight24]::new()
        $this.ColorMap[133] = [CCAppleBlueLight24]::new()
        $this.ColorMap[134] = [CCAppleBlueLight24]::new()
        $this.ColorMap[135] = [CCAppleBlueLight24]::new()
        $this.ColorMap[136] = [CCAppleBlueLight24]::new()
        $this.ColorMap[137] = [CCAppleBlueLight24]::new()
        $this.ColorMap[138] = [CCAppleBlueLight24]::new()
        $this.ColorMap[139] = [CCAppleBlueLight24]::new()
        $this.ColorMap[140] = [CCAppleBlueLight24]::new()
        $this.ColorMap[141] = [CCAppleBlueLight24]::new()
        $this.ColorMap[142] = [CCAppleBlueLight24]::new()
        $this.ColorMap[143] = [CCAppleBlueLight24]::new() # End Row 2
        $this.ColorMap[144] = [CCAppleBlueLight24]::new()
        $this.ColorMap[145] = [CCAppleBlueLight24]::new()
        $this.ColorMap[146] = [CCAppleBlueLight24]::new()
        $this.ColorMap[147] = [CCAppleBlueLight24]::new()
        $this.ColorMap[148] = [CCAppleBlueLight24]::new()
        $this.ColorMap[149] = [CCAppleBlueLight24]::new()
        $this.ColorMap[150] = [CCAppleBlueLight24]::new()
        $this.ColorMap[151] = [CCAppleBlueLight24]::new()
        $this.ColorMap[152] = [CCAppleBlueLight24]::new()
        $this.ColorMap[153] = [CCAppleBlueLight24]::new()
        $this.ColorMap[154] = [CCAppleBlueLight24]::new()
        $this.ColorMap[155] = [CCAppleBlueLight24]::new()
        $this.ColorMap[156] = [CCAppleBlueLight24]::new()
        $this.ColorMap[157] = [CCAppleBlueLight24]::new()
        $this.ColorMap[158] = [CCAppleBlueLight24]::new()
        $this.ColorMap[159] = [CCAppleBlueLight24]::new()
        $this.ColorMap[160] = [CCAppleBlueLight24]::new()
        $this.ColorMap[161] = [CCAppleBlueLight24]::new()
        $this.ColorMap[162] = [CCAppleBlueLight24]::new()
        $this.ColorMap[163] = [CCAppleBlueLight24]::new()
        $this.ColorMap[164] = [CCAppleBlueLight24]::new()
        $this.ColorMap[165] = [CCAppleBlueLight24]::new()
        $this.ColorMap[166] = [CCAppleBlueLight24]::new()
        $this.ColorMap[167] = [CCAppleBlueLight24]::new()
        $this.ColorMap[168] = [CCAppleBlueLight24]::new()
        $this.ColorMap[169] = [CCAppleBlueLight24]::new()
        $this.ColorMap[170] = [CCAppleBlueLight24]::new()
        $this.ColorMap[171] = [CCAppleBlueLight24]::new()
        $this.ColorMap[172] = [CCAppleBlueLight24]::new()
        $this.ColorMap[173] = [CCAppleBlueLight24]::new()
        $this.ColorMap[174] = [CCAppleBlueLight24]::new()
        $this.ColorMap[175] = [CCAppleBlueLight24]::new()
        $this.ColorMap[176] = [CCAppleBlueLight24]::new()
        $this.ColorMap[177] = [CCAppleBlueLight24]::new()
        $this.ColorMap[178] = [CCAppleBlueLight24]::new()
        $this.ColorMap[179] = [CCAppleBlueLight24]::new()
        $this.ColorMap[180] = [CCAppleBlueLight24]::new()
        $this.ColorMap[181] = [CCAppleBlueLight24]::new()
        $this.ColorMap[182] = [CCAppleBlueLight24]::new()
        $this.ColorMap[183] = [CCAppleBlueLight24]::new()
        $this.ColorMap[184] = [CCAppleBlueLight24]::new()
        $this.ColorMap[185] = [CCAppleBlueLight24]::new()
        $this.ColorMap[186] = [CCAppleBlueLight24]::new()
        $this.ColorMap[187] = [CCAppleBlueLight24]::new()
        $this.ColorMap[188] = [CCAppleBlueLight24]::new()
        $this.ColorMap[189] = [CCAppleBlueLight24]::new()
        $this.ColorMap[190] = [CCAppleBlueLight24]::new()
        $this.ColorMap[191] = [CCAppleBlueLight24]::new() # End Row 3
        $this.ColorMap[192] = [CCAppleBlueLight24]::new()
        $this.ColorMap[193] = [CCAppleBlueLight24]::new()
        $this.ColorMap[194] = [CCAppleBlueLight24]::new()
        $this.ColorMap[195] = [CCAppleBlueLight24]::new()
        $this.ColorMap[196] = [CCAppleBlueLight24]::new()
        $this.ColorMap[197] = [CCAppleBlueLight24]::new()
        $this.ColorMap[198] = [CCAppleBlueLight24]::new()
        $this.ColorMap[199] = [CCAppleBlueLight24]::new()
        $this.ColorMap[200] = [CCAppleBlueLight24]::new()
        $this.ColorMap[201] = [CCAppleBlueLight24]::new()
        $this.ColorMap[202] = [CCAppleBlueLight24]::new()
        $this.ColorMap[203] = [CCAppleBlueLight24]::new()
        $this.ColorMap[204] = [CCAppleBlueLight24]::new()
        $this.ColorMap[205] = [CCAppleBlueLight24]::new()
        $this.ColorMap[206] = [CCAppleBlueLight24]::new()
        $this.ColorMap[207] = [CCAppleBlueLight24]::new()
        $this.ColorMap[208] = [CCAppleBlueLight24]::new()
        $this.ColorMap[209] = [CCAppleBlueLight24]::new()
        $this.ColorMap[210] = [CCAppleBlueLight24]::new()
        $this.ColorMap[211] = [CCAppleBlueLight24]::new()
        $this.ColorMap[212] = [CCAppleBlueLight24]::new()
        $this.ColorMap[213] = [CCAppleBlueLight24]::new()
        $this.ColorMap[214] = [CCAppleBlueLight24]::new()
        $this.ColorMap[215] = [CCAppleBlueLight24]::new()
        $this.ColorMap[216] = [CCAppleBlueLight24]::new()
        $this.ColorMap[217] = [CCAppleBlueLight24]::new()
        $this.ColorMap[218] = [CCAppleBlueLight24]::new()
        $this.ColorMap[219] = [CCAppleBlueLight24]::new()
        $this.ColorMap[220] = [CCAppleBlueLight24]::new()
        $this.ColorMap[221] = [CCAppleBlueLight24]::new()
        $this.ColorMap[222] = [CCAppleBlueLight24]::new()
        $this.ColorMap[223] = [CCAppleBlueLight24]::new()
        $this.ColorMap[224] = [CCAppleBlueLight24]::new()
        $this.ColorMap[225] = [CCAppleBlueLight24]::new()
        $this.ColorMap[226] = [CCAppleBlueLight24]::new()
        $this.ColorMap[227] = [CCAppleBlueLight24]::new()
        $this.ColorMap[228] = [CCAppleBlueLight24]::new()
        $this.ColorMap[229] = [CCAppleBlueLight24]::new()
        $this.ColorMap[230] = [CCAppleBlueLight24]::new()
        $this.ColorMap[231] = [CCAppleBlueLight24]::new()
        $this.ColorMap[232] = [CCAppleBlueLight24]::new()
        $this.ColorMap[233] = [CCAppleBlueLight24]::new()
        $this.ColorMap[234] = [CCAppleBlueLight24]::new()
        $this.ColorMap[235] = [CCAppleBlueLight24]::new()
        $this.ColorMap[236] = [CCAppleBlueLight24]::new()
        $this.ColorMap[237] = [CCAppleBlueLight24]::new()
        $this.ColorMap[238] = [CCAppleBlueLight24]::new()
        $this.ColorMap[239] = [CCAppleBlueLight24]::new() # End Row 4
        $this.ColorMap[240] = [CCAppleGreenLight24]::new()
        $this.ColorMap[241] = [CCAppleGreenLight24]::new()
        $this.ColorMap[242] = [CCAppleGreenLight24]::new()
        $this.ColorMap[243] = [CCAppleGreenLight24]::new()
        $this.ColorMap[244] = [CCAppleGreenLight24]::new()
        $this.ColorMap[245] = [CCAppleGreenLight24]::new()
        $this.ColorMap[246] = [CCAppleGreenLight24]::new()
        $this.ColorMap[247] = [CCAppleGreenLight24]::new()
        $this.ColorMap[248] = [CCAppleGreenLight24]::new()
        $this.ColorMap[249] = [CCAppleGreenLight24]::new()
        $this.ColorMap[250] = [CCAppleGreenLight24]::new()
        $this.ColorMap[251] = [CCAppleGreenLight24]::new()
        $this.ColorMap[252] = [CCAppleGreenLight24]::new()
        $this.ColorMap[253] = [CCAppleGreenLight24]::new()
        $this.ColorMap[254] = [CCAppleGreenLight24]::new()
        $this.ColorMap[255] = [CCAppleGreenLight24]::new()
        $this.ColorMap[256] = [CCAppleGreenLight24]::new()
        $this.ColorMap[257] = [CCAppleGreenLight24]::new()
        $this.ColorMap[258] = [CCAppleGreenLight24]::new()
        $this.ColorMap[259] = [CCAppleGreenLight24]::new()
        $this.ColorMap[260] = [CCAppleGreenLight24]::new()
        $this.ColorMap[261] = [CCAppleGreenLight24]::new()
        $this.ColorMap[262] = [CCAppleGreenLight24]::new()
        $this.ColorMap[263] = [CCAppleGreenLight24]::new()
        $this.ColorMap[264] = [CCAppleBrownLight24]::new()
        $this.ColorMap[265] = [CCAppleGreenLight24]::new()
        $this.ColorMap[266] = [CCAppleGreenLight24]::new()
        $this.ColorMap[267] = [CCAppleGreenLight24]::new()
        $this.ColorMap[268] = [CCAppleGreenLight24]::new()
        $this.ColorMap[269] = [CCAppleGreenLight24]::new()
        $this.ColorMap[270] = [CCAppleGreenLight24]::new()
        $this.ColorMap[271] = [CCAppleGreenLight24]::new()
        $this.ColorMap[272] = [CCAppleGreenLight24]::new()
        $this.ColorMap[273] = [CCAppleGreenLight24]::new()
        $this.ColorMap[274] = [CCAppleGreenLight24]::new()
        $this.ColorMap[275] = [CCAppleGreenLight24]::new()
        $this.ColorMap[276] = [CCAppleGreenLight24]::new()
        $this.ColorMap[277] = [CCAppleGreenLight24]::new()
        $this.ColorMap[278] = [CCAppleGreenLight24]::new()
        $this.ColorMap[279] = [CCAppleGreenLight24]::new()
        $this.ColorMap[280] = [CCAppleGreenLight24]::new()
        $this.ColorMap[281] = [CCAppleGreenLight24]::new()
        $this.ColorMap[282] = [CCAppleGreenLight24]::new()
        $this.ColorMap[283] = [CCAppleGreenLight24]::new()
        $this.ColorMap[284] = [CCAppleGreenLight24]::new()
        $this.ColorMap[285] = [CCAppleGreenLight24]::new()
        $this.ColorMap[286] = [CCAppleGreenLight24]::new()
        $this.ColorMap[287] = [CCAppleGreenLight24]::new() # End Row 5
        $this.ColorMap[288] = [CCAppleGreenLight24]::new()
        $this.ColorMap[289] = [CCAppleGreenLight24]::new()
        $this.ColorMap[290] = [CCAppleGreenLight24]::new()
        $this.ColorMap[291] = [CCAppleGreenLight24]::new()
        $this.ColorMap[292] = [CCAppleGreenLight24]::new()
        $this.ColorMap[293] = [CCAppleGreenLight24]::new()
        $this.ColorMap[294] = [CCAppleGreenLight24]::new()
        $this.ColorMap[295] = [CCAppleGreenLight24]::new()
        $this.ColorMap[296] = [CCAppleGreenLight24]::new()
        $this.ColorMap[297] = [CCAppleGreenLight24]::new()
        $this.ColorMap[298] = [CCAppleGreenLight24]::new()
        $this.ColorMap[299] = [CCAppleGreenLight24]::new()
        $this.ColorMap[300] = [CCAppleGreenLight24]::new()
        $this.ColorMap[301] = [CCAppleGreenLight24]::new()
        $this.ColorMap[302] = [CCAppleGreenLight24]::new()
        $this.ColorMap[303] = [CCAppleGreenLight24]::new()
        $this.ColorMap[304] = [CCAppleGreenLight24]::new()
        $this.ColorMap[305] = [CCAppleGreenLight24]::new()
        $this.ColorMap[306] = [CCAppleGreenLight24]::new()
        $this.ColorMap[307] = [CCAppleGreenLight24]::new()
        $this.ColorMap[308] = [CCAppleGreenLight24]::new()
        $this.ColorMap[309] = [CCAppleGreenLight24]::new()
        $this.ColorMap[310] = [CCAppleGreenLight24]::new()
        $this.ColorMap[311] = [CCAppleGreenLight24]::new()
        $this.ColorMap[312] = [CCAppleBrownLight24]::new()
        $this.ColorMap[313] = [CCAppleGreenLight24]::new()
        $this.ColorMap[314] = [CCAppleGreenLight24]::new()
        $this.ColorMap[315] = [CCAppleGreenLight24]::new()
        $this.ColorMap[316] = [CCAppleGreenLight24]::new()
        $this.ColorMap[317] = [CCAppleGreenLight24]::new()
        $this.ColorMap[318] = [CCAppleGreenLight24]::new()
        $this.ColorMap[319] = [CCAppleGreenLight24]::new()
        $this.ColorMap[320] = [CCAppleGreenLight24]::new()
        $this.ColorMap[321] = [CCAppleGreenLight24]::new()
        $this.ColorMap[322] = [CCAppleGreenLight24]::new()
        $this.ColorMap[323] = [CCAppleGreenLight24]::new()
        $this.ColorMap[324] = [CCAppleGreenLight24]::new()
        $this.ColorMap[325] = [CCAppleGreenLight24]::new()
        $this.ColorMap[326] = [CCAppleGreenLight24]::new()
        $this.ColorMap[327] = [CCAppleGreenLight24]::new()
        $this.ColorMap[328] = [CCAppleGreenLight24]::new()
        $this.ColorMap[329] = [CCAppleGreenLight24]::new()
        $this.ColorMap[330] = [CCAppleGreenLight24]::new()
        $this.ColorMap[331] = [CCAppleGreenLight24]::new()
        $this.ColorMap[332] = [CCAppleGreenLight24]::new()
        $this.ColorMap[333] = [CCAppleGreenLight24]::new()
        $this.ColorMap[334] = [CCAppleGreenLight24]::new()
        $this.ColorMap[335] = [CCAppleGreenLight24]::new() # End Row 6
        $this.ColorMap[336] = [CCAppleGreenLight24]::new()
        $this.ColorMap[337] = [CCAppleGreenLight24]::new()
        $this.ColorMap[338] = [CCAppleGreenLight24]::new()
        $this.ColorMap[339] = [CCAppleGreenLight24]::new()
        $this.ColorMap[340] = [CCAppleGreenLight24]::new()
        $this.ColorMap[341] = [CCAppleGreenLight24]::new()
        $this.ColorMap[342] = [CCAppleGreenLight24]::new()
        $this.ColorMap[343] = [CCAppleGreenLight24]::new()
        $this.ColorMap[344] = [CCAppleGreenLight24]::new()
        $this.ColorMap[345] = [CCAppleGreenLight24]::new()
        $this.ColorMap[346] = [CCAppleGreenLight24]::new()
        $this.ColorMap[347] = [CCAppleGreenLight24]::new()
        $this.ColorMap[348] = [CCAppleGreenLight24]::new()
        $this.ColorMap[349] = [CCAppleGreenLight24]::new()
        $this.ColorMap[350] = [CCAppleGreenLight24]::new()
        $this.ColorMap[351] = [CCAppleGreenLight24]::new()
        $this.ColorMap[352] = [CCAppleGreenLight24]::new()
        $this.ColorMap[353] = [CCAppleGreenLight24]::new()
        $this.ColorMap[354] = [CCAppleGreenLight24]::new()
        $this.ColorMap[355] = [CCAppleGreenLight24]::new()
        $this.ColorMap[356] = [CCAppleGreenLight24]::new()
        $this.ColorMap[357] = [CCAppleGreenLight24]::new()
        $this.ColorMap[358] = [CCAppleGreenLight24]::new()
        $this.ColorMap[359] = [CCAppleBrownLight24]::new()
        $this.ColorMap[360] = [CCAppleBrownLight24]::new()
        $this.ColorMap[361] = [CCAppleBrownLight24]::new()
        $this.ColorMap[362] = [CCAppleGreenLight24]::new()
        $this.ColorMap[363] = [CCAppleGreenLight24]::new()
        $this.ColorMap[364] = [CCAppleGreenLight24]::new()
        $this.ColorMap[365] = [CCAppleGreenLight24]::new()
        $this.ColorMap[366] = [CCAppleGreenLight24]::new()
        $this.ColorMap[367] = [CCAppleGreenLight24]::new()
        $this.ColorMap[368] = [CCAppleGreenLight24]::new()
        $this.ColorMap[369] = [CCAppleGreenLight24]::new()
        $this.ColorMap[370] = [CCAppleGreenLight24]::new()
        $this.ColorMap[371] = [CCAppleGreenLight24]::new()
        $this.ColorMap[372] = [CCAppleGreenLight24]::new()
        $this.ColorMap[373] = [CCAppleGreenLight24]::new()
        $this.ColorMap[374] = [CCAppleGreenLight24]::new()
        $this.ColorMap[375] = [CCAppleGreenLight24]::new()
        $this.ColorMap[376] = [CCAppleGreenLight24]::new()
        $this.ColorMap[377] = [CCAppleGreenLight24]::new()
        $this.ColorMap[378] = [CCAppleGreenLight24]::new()
        $this.ColorMap[379] = [CCAppleGreenLight24]::new()
        $this.ColorMap[380] = [CCAppleGreenLight24]::new()
        $this.ColorMap[381] = [CCAppleGreenLight24]::new()
        $this.ColorMap[382] = [CCAppleGreenLight24]::new()
        $this.ColorMap[383] = [CCAppleGreenLight24]::new() # End Row 7
        $this.ColorMap[384] = [CCAppleGreenLight24]::new()
        $this.ColorMap[385] = [CCAppleGreenLight24]::new()
        $this.ColorMap[386] = [CCAppleGreenLight24]::new()
        $this.ColorMap[387] = [CCAppleGreenLight24]::new()
        $this.ColorMap[388] = [CCAppleGreenLight24]::new()
        $this.ColorMap[389] = [CCAppleGreenLight24]::new()
        $this.ColorMap[390] = [CCAppleGreenLight24]::new()
        $this.ColorMap[391] = [CCAppleGreenLight24]::new()
        $this.ColorMap[392] = [CCAppleGreenLight24]::new()
        $this.ColorMap[393] = [CCAppleGreenLight24]::new()
        $this.ColorMap[394] = [CCAppleGreenLight24]::new()
        $this.ColorMap[395] = [CCAppleGreenLight24]::new()
        $this.ColorMap[396] = [CCAppleGreenLight24]::new()
        $this.ColorMap[397] = [CCAppleGreenLight24]::new()
        $this.ColorMap[398] = [CCAppleGreenLight24]::new()
        $this.ColorMap[399] = [CCAppleGreenLight24]::new()
        $this.ColorMap[400] = [CCAppleGreenLight24]::new()
        $this.ColorMap[401] = [CCAppleGreenLight24]::new()
        $this.ColorMap[402] = [CCAppleGreenLight24]::new()
        $this.ColorMap[403] = [CCAppleGreenLight24]::new()
        $this.ColorMap[404] = [CCAppleGreenLight24]::new()
        $this.ColorMap[405] = [CCAppleGreenLight24]::new()
        $this.ColorMap[406] = [CCAppleBrownLight24]::new()
        $this.ColorMap[407] = [CCAppleBrownLight24]::new()
        $this.ColorMap[408] = [CCAppleBrownLight24]::new()
        $this.ColorMap[409] = [CCAppleBrownLight24]::new()
        $this.ColorMap[410] = [CCAppleBrownLight24]::new()
        $this.ColorMap[411] = [CCAppleGreenLight24]::new()
        $this.ColorMap[412] = [CCAppleGreenLight24]::new()
        $this.ColorMap[413] = [CCAppleGreenLight24]::new()
        $this.ColorMap[414] = [CCAppleGreenLight24]::new()
        $this.ColorMap[415] = [CCAppleGreenLight24]::new()
        $this.ColorMap[416] = [CCAppleGreenLight24]::new()
        $this.ColorMap[417] = [CCAppleGreenLight24]::new()
        $this.ColorMap[418] = [CCAppleGreenLight24]::new()
        $this.ColorMap[419] = [CCAppleGreenLight24]::new()
        $this.ColorMap[420] = [CCAppleGreenLight24]::new()
        $this.ColorMap[421] = [CCAppleGreenLight24]::new()
        $this.ColorMap[422] = [CCAppleGreenLight24]::new()
        $this.ColorMap[423] = [CCAppleGreenLight24]::new()
        $this.ColorMap[424] = [CCAppleGreenLight24]::new()
        $this.ColorMap[425] = [CCAppleGreenLight24]::new()
        $this.ColorMap[426] = [CCAppleGreenLight24]::new()
        $this.ColorMap[427] = [CCAppleGreenLight24]::new()
        $this.ColorMap[428] = [CCAppleGreenLight24]::new()
        $this.ColorMap[429] = [CCAppleGreenLight24]::new()
        $this.ColorMap[430] = [CCAppleGreenLight24]::new()
        $this.ColorMap[431] = [CCAppleGreenLight24]::new() # End Row 8
        $this.ColorMap[432] = [CCAppleGreenLight24]::new()
        $this.ColorMap[433] = [CCAppleGreenLight24]::new()
        $this.ColorMap[434] = [CCAppleGreenLight24]::new()
        $this.ColorMap[435] = [CCAppleGreenLight24]::new()
        $this.ColorMap[436] = [CCAppleGreenLight24]::new()
        $this.ColorMap[437] = [CCAppleGreenLight24]::new()
        $this.ColorMap[438] = [CCAppleGreenLight24]::new()
        $this.ColorMap[439] = [CCAppleGreenLight24]::new()
        $this.ColorMap[440] = [CCAppleGreenLight24]::new()
        $this.ColorMap[441] = [CCAppleGreenLight24]::new()
        $this.ColorMap[442] = [CCAppleGreenLight24]::new()
        $this.ColorMap[443] = [CCAppleGreenLight24]::new()
        $this.ColorMap[444] = [CCAppleGreenLight24]::new()
        $this.ColorMap[445] = [CCAppleGreenLight24]::new()
        $this.ColorMap[446] = [CCAppleGreenLight24]::new()
        $this.ColorMap[447] = [CCAppleGreenLight24]::new()
        $this.ColorMap[448] = [CCAppleGreenLight24]::new()
        $this.ColorMap[449] = [CCAppleGreenLight24]::new()
        $this.ColorMap[450] = [CCAppleGreenLight24]::new()
        $this.ColorMap[451] = [CCAppleGreenLight24]::new()
        $this.ColorMap[452] = [CCAppleGreenLight24]::new()
        $this.ColorMap[453] = [CCAppleGreenLight24]::new()
        $this.ColorMap[454] = [CCAppleBrownLight24]::new()
        $this.ColorMap[455] = [CCAppleBrownLight24]::new()
        $this.ColorMap[456] = [CCAppleBrownLight24]::new()
        $this.ColorMap[457] = [CCAppleBrownLight24]::new()
        $this.ColorMap[458] = [CCAppleBrownLight24]::new()
        $this.ColorMap[459] = [CCAppleGreenLight24]::new()
        $this.ColorMap[460] = [CCAppleGreenLight24]::new()
        $this.ColorMap[461] = [CCAppleGreenLight24]::new()
        $this.ColorMap[462] = [CCAppleGreenLight24]::new()
        $this.ColorMap[463] = [CCAppleGreenLight24]::new()
        $this.ColorMap[464] = [CCAppleGreenLight24]::new()
        $this.ColorMap[465] = [CCAppleGreenLight24]::new()
        $this.ColorMap[466] = [CCAppleGreenLight24]::new()
        $this.ColorMap[467] = [CCAppleGreenLight24]::new()
        $this.ColorMap[468] = [CCAppleGreenLight24]::new()
        $this.ColorMap[469] = [CCAppleGreenLight24]::new()
        $this.ColorMap[470] = [CCAppleGreenLight24]::new()
        $this.ColorMap[471] = [CCAppleGreenLight24]::new()
        $this.ColorMap[472] = [CCAppleGreenLight24]::new()
        $this.ColorMap[473] = [CCAppleGreenLight24]::new()
        $this.ColorMap[474] = [CCAppleGreenLight24]::new()
        $this.ColorMap[475] = [CCAppleGreenLight24]::new()
        $this.ColorMap[476] = [CCAppleGreenLight24]::new()
        $this.ColorMap[477] = [CCAppleGreenLight24]::new()
        $this.ColorMap[478] = [CCAppleGreenLight24]::new()
        $this.ColorMap[479] = [CCAppleGreenLight24]::new() # End Row 9
        $this.ColorMap[480] = [CCAppleGreenLight24]::new()
        $this.ColorMap[481] = [CCAppleGreenLight24]::new()
        $this.ColorMap[482] = [CCAppleGreenLight24]::new()
        $this.ColorMap[483] = [CCAppleGreenLight24]::new()
        $this.ColorMap[484] = [CCAppleGreenLight24]::new()
        $this.ColorMap[485] = [CCAppleGreenLight24]::new()
        $this.ColorMap[486] = [CCAppleGreenLight24]::new()
        $this.ColorMap[487] = [CCAppleGreenLight24]::new()
        $this.ColorMap[488] = [CCAppleGreenLight24]::new()
        $this.ColorMap[489] = [CCAppleGreenLight24]::new()
        $this.ColorMap[490] = [CCAppleGreenLight24]::new()
        $this.ColorMap[491] = [CCAppleGreenLight24]::new()
        $this.ColorMap[492] = [CCAppleGreenLight24]::new()
        $this.ColorMap[493] = [CCAppleGreenLight24]::new()
        $this.ColorMap[494] = [CCAppleGreenLight24]::new()
        $this.ColorMap[495] = [CCAppleGreenLight24]::new()
        $this.ColorMap[496] = [CCAppleGreenLight24]::new()
        $this.ColorMap[497] = [CCAppleGreenLight24]::new()
        $this.ColorMap[498] = [CCAppleGreenLight24]::new()
        $this.ColorMap[499] = [CCAppleGreenLight24]::new()
        $this.ColorMap[500] = [CCAppleGreenLight24]::new()
        $this.ColorMap[501] = [CCAppleBrownLight24]::new()
        $this.ColorMap[502] = [CCAppleBrownLight24]::new()
        $this.ColorMap[503] = [CCAppleBrownLight24]::new()
        $this.ColorMap[504] = [CCAppleBrownLight24]::new()
        $this.ColorMap[505] = [CCAppleBrownLight24]::new()
        $this.ColorMap[506] = [CCAppleBrownLight24]::new()
        $this.ColorMap[507] = [CCAppleBrownLight24]::new()
        $this.ColorMap[508] = [CCAppleGreenLight24]::new()
        $this.ColorMap[509] = [CCAppleGreenLight24]::new()
        $this.ColorMap[510] = [CCAppleGreenLight24]::new()
        $this.ColorMap[511] = [CCAppleGreenLight24]::new()
        $this.ColorMap[512] = [CCAppleGreenLight24]::new()
        $this.ColorMap[513] = [CCAppleGreenLight24]::new()
        $this.ColorMap[514] = [CCAppleGreenLight24]::new()
        $this.ColorMap[515] = [CCAppleGreenLight24]::new()
        $this.ColorMap[516] = [CCAppleGreenLight24]::new()
        $this.ColorMap[517] = [CCAppleGreenLight24]::new()
        $this.ColorMap[518] = [CCAppleGreenLight24]::new()
        $this.ColorMap[519] = [CCAppleGreenLight24]::new()
        $this.ColorMap[520] = [CCAppleGreenLight24]::new()
        $this.ColorMap[521] = [CCAppleGreenLight24]::new()
        $this.ColorMap[522] = [CCAppleGreenLight24]::new()
        $this.ColorMap[523] = [CCAppleGreenLight24]::new()
        $this.ColorMap[524] = [CCAppleGreenLight24]::new()
        $this.ColorMap[525] = [CCAppleGreenLight24]::new()
        $this.ColorMap[526] = [CCAppleGreenLight24]::new()
        $this.ColorMap[527] = [CCAppleGreenLight24]::new() # End Row 10
        $this.ColorMap[528] = [CCAppleGreenLight24]::new()
        $this.ColorMap[529] = [CCAppleGreenLight24]::new()
        $this.ColorMap[530] = [CCAppleGreenLight24]::new()
        $this.ColorMap[531] = [CCAppleGreenLight24]::new()
        $this.ColorMap[532] = [CCAppleGreenLight24]::new()
        $this.ColorMap[533] = [CCAppleGreenLight24]::new()
        $this.ColorMap[534] = [CCAppleGreenLight24]::new()
        $this.ColorMap[535] = [CCAppleGreenLight24]::new()
        $this.ColorMap[536] = [CCAppleGreenLight24]::new()
        $this.ColorMap[537] = [CCAppleGreenLight24]::new()
        $this.ColorMap[538] = [CCAppleGreenLight24]::new()
        $this.ColorMap[539] = [CCAppleGreenLight24]::new()
        $this.ColorMap[540] = [CCAppleGreenLight24]::new()
        $this.ColorMap[541] = [CCAppleGreenLight24]::new()
        $this.ColorMap[542] = [CCAppleGreenLight24]::new()
        $this.ColorMap[543] = [CCAppleGreenLight24]::new()
        $this.ColorMap[544] = [CCAppleGreenLight24]::new()
        $this.ColorMap[545] = [CCAppleGreenLight24]::new()
        $this.ColorMap[546] = [CCAppleGreenLight24]::new()
        $this.ColorMap[547] = [CCAppleGreenLight24]::new()
        $this.ColorMap[548] = [CCAppleGreenLight24]::new()
        $this.ColorMap[549] = [CCAppleBrownLight24]::new()
        $this.ColorMap[550] = [CCAppleBrownLight24]::new()
        $this.ColorMap[551] = [CCAppleBrownLight24]::new()
        $this.ColorMap[552] = [CCAppleBrownLight24]::new()
        $this.ColorMap[553] = [CCAppleBrownLight24]::new()
        $this.ColorMap[554] = [CCAppleBrownLight24]::new()
        $this.ColorMap[555] = [CCAppleBrownLight24]::new()
        $this.ColorMap[556] = [CCAppleGreenLight24]::new()
        $this.ColorMap[557] = [CCAppleGreenLight24]::new()
        $this.ColorMap[558] = [CCAppleGreenLight24]::new()
        $this.ColorMap[559] = [CCAppleGreenLight24]::new()
        $this.ColorMap[560] = [CCAppleGreenLight24]::new()
        $this.ColorMap[561] = [CCAppleGreenLight24]::new()
        $this.ColorMap[562] = [CCAppleGreenLight24]::new()
        $this.ColorMap[563] = [CCAppleGreenLight24]::new()
        $this.ColorMap[564] = [CCAppleGreenLight24]::new()
        $this.ColorMap[565] = [CCAppleGreenLight24]::new()
        $this.ColorMap[566] = [CCAppleGreenLight24]::new()
        $this.ColorMap[567] = [CCAppleGreenLight24]::new()
        $this.ColorMap[568] = [CCAppleGreenLight24]::new()
        $this.ColorMap[569] = [CCAppleGreenLight24]::new()
        $this.ColorMap[570] = [CCAppleGreenLight24]::new()
        $this.ColorMap[571] = [CCAppleGreenLight24]::new()
        $this.ColorMap[572] = [CCAppleGreenLight24]::new()
        $this.ColorMap[573] = [CCAppleGreenLight24]::new()
        $this.ColorMap[574] = [CCAppleGreenLight24]::new()
        $this.ColorMap[575] = [CCAppleGreenLight24]::new() # End Row 11
        $this.ColorMap[576] = [CCAppleGreenLight24]::new()
        $this.ColorMap[577] = [CCAppleGreenLight24]::new()
        $this.ColorMap[578] = [CCAppleGreenLight24]::new()
        $this.ColorMap[579] = [CCAppleGreenLight24]::new()
        $this.ColorMap[580] = [CCAppleGreenLight24]::new()
        $this.ColorMap[581] = [CCAppleGreenLight24]::new()
        $this.ColorMap[582] = [CCAppleGreenLight24]::new()
        $this.ColorMap[583] = [CCAppleGreenLight24]::new()
        $this.ColorMap[584] = [CCAppleGreenLight24]::new()
        $this.ColorMap[585] = [CCAppleGreenLight24]::new()
        $this.ColorMap[586] = [CCAppleGreenLight24]::new()
        $this.ColorMap[587] = [CCAppleGreenLight24]::new()
        $this.ColorMap[588] = [CCAppleGreenLight24]::new()
        $this.ColorMap[589] = [CCAppleGreenLight24]::new()
        $this.ColorMap[590] = [CCAppleGreenLight24]::new()
        $this.ColorMap[591] = [CCAppleGreenLight24]::new()
        $this.ColorMap[592] = [CCAppleGreenLight24]::new()
        $this.ColorMap[593] = [CCAppleGreenLight24]::new()
        $this.ColorMap[594] = [CCAppleGreenLight24]::new()
        $this.ColorMap[595] = [CCAppleGreenLight24]::new()
        $this.ColorMap[596] = [CCAppleGreenLight24]::new()
        $this.ColorMap[597] = [CCAppleBrownLight24]::new()
        $this.ColorMap[598] = [CCAppleBrownLight24]::new()
        $this.ColorMap[599] = [CCAppleBrownLight24]::new()
        $this.ColorMap[600] = [CCAppleBrownLight24]::new()
        $this.ColorMap[601] = [CCAppleBrownLight24]::new()
        $this.ColorMap[602] = [CCAppleBrownLight24]::new()
        $this.ColorMap[603] = [CCAppleBrownLight24]::new()
        $this.ColorMap[604] = [CCAppleGreenLight24]::new()
        $this.ColorMap[605] = [CCAppleGreenLight24]::new()
        $this.ColorMap[606] = [CCAppleGreenLight24]::new()
        $this.ColorMap[607] = [CCAppleGreenLight24]::new()
        $this.ColorMap[608] = [CCAppleGreenLight24]::new()
        $this.ColorMap[609] = [CCAppleGreenLight24]::new()
        $this.ColorMap[610] = [CCAppleGreenLight24]::new()
        $this.ColorMap[611] = [CCAppleGreenLight24]::new()
        $this.ColorMap[612] = [CCAppleGreenLight24]::new()
        $this.ColorMap[613] = [CCAppleGreenLight24]::new()
        $this.ColorMap[614] = [CCAppleGreenLight24]::new()
        $this.ColorMap[615] = [CCAppleGreenLight24]::new()
        $this.ColorMap[616] = [CCAppleGreenLight24]::new()
        $this.ColorMap[617] = [CCAppleGreenLight24]::new()
        $this.ColorMap[618] = [CCAppleGreenLight24]::new()
        $this.ColorMap[619] = [CCAppleGreenLight24]::new()
        $this.ColorMap[620] = [CCAppleGreenLight24]::new()
        $this.ColorMap[621] = [CCAppleGreenLight24]::new()
        $this.ColorMap[622] = [CCAppleGreenLight24]::new()
        $this.ColorMap[623] = [CCAppleGreenLight24]::new() # End Row 12
        $this.ColorMap[624] = [CCAppleGreenLight24]::new()
        $this.ColorMap[625] = [CCAppleGreenLight24]::new()
        $this.ColorMap[626] = [CCAppleGreenLight24]::new()
        $this.ColorMap[627] = [CCAppleGreenLight24]::new()
        $this.ColorMap[628] = [CCAppleGreenLight24]::new()
        $this.ColorMap[629] = [CCAppleGreenLight24]::new()
        $this.ColorMap[630] = [CCAppleGreenLight24]::new()
        $this.ColorMap[631] = [CCAppleGreenLight24]::new()
        $this.ColorMap[632] = [CCAppleGreenLight24]::new()
        $this.ColorMap[633] = [CCAppleGreenLight24]::new()
        $this.ColorMap[634] = [CCAppleGreenLight24]::new()
        $this.ColorMap[635] = [CCAppleGreenLight24]::new()
        $this.ColorMap[636] = [CCAppleGreenLight24]::new()
        $this.ColorMap[637] = [CCAppleGreenLight24]::new()
        $this.ColorMap[638] = [CCAppleGreenLight24]::new()
        $this.ColorMap[639] = [CCAppleGreenLight24]::new()
        $this.ColorMap[640] = [CCAppleGreenLight24]::new()
        $this.ColorMap[641] = [CCAppleGreenLight24]::new()
        $this.ColorMap[642] = [CCAppleGreenLight24]::new()
        $this.ColorMap[643] = [CCAppleGreenLight24]::new()
        $this.ColorMap[644] = [CCAppleGreenLight24]::new()
        $this.ColorMap[645] = [CCAppleBrownLight24]::new()
        $this.ColorMap[646] = [CCAppleBrownLight24]::new()
        $this.ColorMap[647] = [CCAppleBrownLight24]::new()
        $this.ColorMap[648] = [CCAppleBrownLight24]::new()
        $this.ColorMap[649] = [CCAppleBrownLight24]::new()
        $this.ColorMap[650] = [CCAppleBrownLight24]::new()
        $this.ColorMap[651] = [CCAppleBrownLight24]::new()
        $this.ColorMap[652] = [CCAppleGreenLight24]::new()
        $this.ColorMap[653] = [CCAppleGreenLight24]::new()
        $this.ColorMap[654] = [CCAppleGreenLight24]::new()
        $this.ColorMap[655] = [CCAppleGreenLight24]::new()
        $this.ColorMap[656] = [CCAppleGreenLight24]::new()
        $this.ColorMap[657] = [CCAppleGreenLight24]::new()
        $this.ColorMap[658] = [CCAppleGreenLight24]::new()
        $this.ColorMap[659] = [CCAppleGreenLight24]::new()
        $this.ColorMap[660] = [CCAppleGreenLight24]::new()
        $this.ColorMap[661] = [CCAppleGreenLight24]::new()
        $this.ColorMap[662] = [CCAppleGreenLight24]::new()
        $this.ColorMap[663] = [CCAppleGreenLight24]::new()
        $this.ColorMap[664] = [CCAppleGreenLight24]::new()
        $this.ColorMap[665] = [CCAppleGreenLight24]::new()
        $this.ColorMap[666] = [CCAppleGreenLight24]::new()
        $this.ColorMap[667] = [CCAppleGreenLight24]::new()
        $this.ColorMap[668] = [CCAppleGreenLight24]::new()
        $this.ColorMap[669] = [CCAppleGreenLight24]::new()
        $this.ColorMap[670] = [CCAppleGreenLight24]::new()
        $this.ColorMap[671] = [CCAppleGreenLight24]::new() # End Row 13
        $this.ColorMap[672] = [CCAppleGreenLight24]::new()
        $this.ColorMap[673] = [CCAppleGreenLight24]::new()
        $this.ColorMap[674] = [CCAppleGreenLight24]::new()
        $this.ColorMap[675] = [CCAppleGreenLight24]::new()
        $this.ColorMap[676] = [CCAppleGreenLight24]::new()
        $this.ColorMap[677] = [CCAppleGreenLight24]::new()
        $this.ColorMap[678] = [CCAppleGreenLight24]::new()
        $this.ColorMap[679] = [CCAppleGreenLight24]::new()
        $this.ColorMap[680] = [CCAppleGreenLight24]::new()
        $this.ColorMap[681] = [CCAppleGreenLight24]::new()
        $this.ColorMap[682] = [CCAppleGreenLight24]::new()
        $this.ColorMap[683] = [CCAppleGreenLight24]::new()
        $this.ColorMap[684] = [CCAppleGreenLight24]::new()
        $this.ColorMap[685] = [CCAppleGreenLight24]::new()
        $this.ColorMap[686] = [CCAppleGreenLight24]::new()
        $this.ColorMap[687] = [CCAppleGreenLight24]::new()
        $this.ColorMap[688] = [CCAppleGreenLight24]::new()
        $this.ColorMap[689] = [CCAppleGreenLight24]::new()
        $this.ColorMap[690] = [CCAppleGreenLight24]::new()
        $this.ColorMap[691] = [CCAppleGreenLight24]::new()
        $this.ColorMap[692] = [CCAppleGreenLight24]::new()
        $this.ColorMap[693] = [CCAppleBrownLight24]::new()
        $this.ColorMap[694] = [CCAppleBrownLight24]::new()
        $this.ColorMap[695] = [CCAppleBrownLight24]::new()
        $this.ColorMap[696] = [CCAppleBrownLight24]::new()
        $this.ColorMap[697] = [CCAppleBrownLight24]::new()
        $this.ColorMap[698] = [CCAppleBrownLight24]::new()
        $this.ColorMap[699] = [CCAppleBrownLight24]::new()
        $this.ColorMap[700] = [CCAppleGreenLight24]::new()
        $this.ColorMap[701] = [CCAppleGreenLight24]::new()
        $this.ColorMap[702] = [CCAppleGreenLight24]::new()
        $this.ColorMap[703] = [CCAppleGreenLight24]::new()
        $this.ColorMap[704] = [CCAppleGreenLight24]::new()
        $this.ColorMap[705] = [CCAppleGreenLight24]::new()
        $this.ColorMap[706] = [CCAppleGreenLight24]::new()
        $this.ColorMap[707] = [CCAppleGreenLight24]::new()
        $this.ColorMap[708] = [CCAppleGreenLight24]::new()
        $this.ColorMap[709] = [CCAppleGreenLight24]::new()
        $this.ColorMap[710] = [CCAppleGreenLight24]::new()
        $this.ColorMap[711] = [CCAppleGreenLight24]::new()
        $this.ColorMap[712] = [CCAppleGreenLight24]::new()
        $this.ColorMap[713] = [CCAppleGreenLight24]::new()
        $this.ColorMap[714] = [CCAppleGreenLight24]::new()
        $this.ColorMap[715] = [CCAppleGreenLight24]::new()
        $this.ColorMap[716] = [CCAppleGreenLight24]::new()
        $this.ColorMap[717] = [CCAppleGreenLight24]::new()
        $this.ColorMap[718] = [CCAppleGreenLight24]::new()
        $this.ColorMap[719] = [CCAppleGreenLight24]::new() # End Row 14
        $this.ColorMap[720] = [CCAppleGreenLight24]::new()
        $this.ColorMap[721] = [CCAppleGreenLight24]::new()
        $this.ColorMap[722] = [CCAppleGreenLight24]::new()
        $this.ColorMap[723] = [CCAppleGreenLight24]::new()
        $this.ColorMap[724] = [CCAppleGreenLight24]::new()
        $this.ColorMap[725] = [CCAppleGreenLight24]::new()
        $this.ColorMap[726] = [CCAppleGreenLight24]::new()
        $this.ColorMap[727] = [CCAppleGreenLight24]::new()
        $this.ColorMap[728] = [CCAppleGreenLight24]::new()
        $this.ColorMap[729] = [CCAppleGreenLight24]::new()
        $this.ColorMap[730] = [CCAppleGreenLight24]::new()
        $this.ColorMap[731] = [CCAppleGreenLight24]::new()
        $this.ColorMap[732] = [CCAppleGreenLight24]::new()
        $this.ColorMap[733] = [CCAppleGreenLight24]::new()
        $this.ColorMap[734] = [CCAppleGreenLight24]::new()
        $this.ColorMap[735] = [CCAppleGreenLight24]::new()
        $this.ColorMap[736] = [CCAppleGreenLight24]::new()
        $this.ColorMap[737] = [CCAppleGreenLight24]::new()
        $this.ColorMap[738] = [CCAppleGreenLight24]::new()
        $this.ColorMap[739] = [CCAppleGreenLight24]::new()
        $this.ColorMap[740] = [CCAppleGreenLight24]::new()
        $this.ColorMap[741] = [CCAppleBrownLight24]::new()
        $this.ColorMap[742] = [CCAppleBrownLight24]::new()
        $this.ColorMap[743] = [CCAppleBrownLight24]::new()
        $this.ColorMap[744] = [CCAppleBrownLight24]::new()
        $this.ColorMap[745] = [CCAppleBrownLight24]::new()
        $this.ColorMap[746] = [CCAppleBrownLight24]::new()
        $this.ColorMap[747] = [CCAppleBrownLight24]::new()
        $this.ColorMap[748] = [CCAppleGreenLight24]::new()
        $this.ColorMap[749] = [CCAppleGreenLight24]::new()
        $this.ColorMap[750] = [CCAppleGreenLight24]::new()
        $this.ColorMap[751] = [CCAppleGreenLight24]::new()
        $this.ColorMap[752] = [CCAppleGreenLight24]::new()
        $this.ColorMap[753] = [CCAppleGreenLight24]::new()
        $this.ColorMap[754] = [CCAppleGreenLight24]::new()
        $this.ColorMap[755] = [CCAppleGreenLight24]::new()
        $this.ColorMap[756] = [CCAppleGreenLight24]::new()
        $this.ColorMap[757] = [CCAppleGreenLight24]::new()
        $this.ColorMap[758] = [CCAppleGreenLight24]::new()
        $this.ColorMap[759] = [CCAppleGreenLight24]::new()
        $this.ColorMap[760] = [CCAppleGreenLight24]::new()
        $this.ColorMap[761] = [CCAppleGreenLight24]::new()
        $this.ColorMap[762] = [CCAppleGreenLight24]::new()
        $this.ColorMap[763] = [CCAppleGreenLight24]::new()
        $this.ColorMap[764] = [CCAppleGreenLight24]::new()
        $this.ColorMap[765] = [CCAppleGreenLight24]::new()
        $this.ColorMap[766] = [CCAppleGreenLight24]::new()
        $this.ColorMap[767] = [CCAppleGreenLight24]::new() # End Row 15
        $this.ColorMap[768] = [CCAppleBrownLight24]::new()
        $this.ColorMap[769] = [CCAppleBrownLight24]::new()
        $this.ColorMap[770] = [CCAppleBrownLight24]::new()
        $this.ColorMap[771] = [CCAppleBrownLight24]::new()
        $this.ColorMap[772] = [CCAppleBrownLight24]::new()
        $this.ColorMap[773] = [CCAppleBrownLight24]::new()
        $this.ColorMap[774] = [CCAppleBrownLight24]::new()
        $this.ColorMap[775] = [CCAppleBrownLight24]::new()
        $this.ColorMap[776] = [CCAppleBrownLight24]::new()
        $this.ColorMap[777] = [CCAppleBrownLight24]::new()
        $this.ColorMap[778] = [CCAppleBrownLight24]::new()
        $this.ColorMap[779] = [CCAppleBrownLight24]::new()
        $this.ColorMap[780] = [CCAppleBrownLight24]::new()
        $this.ColorMap[781] = [CCAppleBrownLight24]::new()
        $this.ColorMap[782] = [CCAppleBrownLight24]::new()
        $this.ColorMap[783] = [CCAppleBrownLight24]::new()
        $this.ColorMap[784] = [CCAppleBrownLight24]::new()
        $this.ColorMap[785] = [CCAppleBrownLight24]::new()
        $this.ColorMap[786] = [CCAppleBrownLight24]::new()
        $this.ColorMap[787] = [CCAppleBrownLight24]::new()
        $this.ColorMap[788] = [CCAppleBrownLight24]::new()
        $this.ColorMap[789] = [CCAppleBrownLight24]::new()
        $this.ColorMap[790] = [CCAppleBrownLight24]::new()
        $this.ColorMap[791] = [CCAppleBrownLight24]::new()
        $this.ColorMap[792] = [CCAppleBrownLight24]::new()
        $this.ColorMap[793] = [CCAppleBrownLight24]::new()
        $this.ColorMap[794] = [CCAppleBrownLight24]::new()
        $this.ColorMap[795] = [CCAppleBrownLight24]::new()
        $this.ColorMap[796] = [CCAppleGreenLight24]::new()
        $this.ColorMap[797] = [CCAppleGreenLight24]::new()
        $this.ColorMap[798] = [CCAppleGreenLight24]::new()
        $this.ColorMap[799] = [CCAppleGreenLight24]::new()
        $this.ColorMap[800] = [CCAppleGreenLight24]::new()
        $this.ColorMap[801] = [CCAppleGreenLight24]::new()
        $this.ColorMap[802] = [CCAppleGreenLight24]::new()
        $this.ColorMap[803] = [CCAppleGreenLight24]::new()
        $this.ColorMap[804] = [CCAppleGreenLight24]::new()
        $this.ColorMap[805] = [CCAppleGreenLight24]::new()
        $this.ColorMap[806] = [CCAppleGreenLight24]::new()
        $this.ColorMap[807] = [CCAppleGreenLight24]::new()
        $this.ColorMap[808] = [CCAppleGreenLight24]::new()
        $this.ColorMap[809] = [CCAppleGreenLight24]::new()
        $this.ColorMap[810] = [CCAppleGreenLight24]::new()
        $this.ColorMap[811] = [CCAppleGreenLight24]::new()
        $this.ColorMap[812] = [CCAppleGreenLight24]::new()
        $this.ColorMap[813] = [CCAppleGreenLight24]::new()
        $this.ColorMap[814] = [CCAppleGreenLight24]::new()
        $this.ColorMap[815] = [CCAppleGreenLight24]::new() # End Row 16
        $this.ColorMap[816] = [CCAppleBrownLight24]::new()
        $this.ColorMap[817] = [CCAppleBrownLight24]::new()
        $this.ColorMap[818] = [CCAppleBrownLight24]::new()
        $this.ColorMap[819] = [CCAppleBrownLight24]::new()
        $this.ColorMap[820] = [CCAppleBrownLight24]::new()
        $this.ColorMap[821] = [CCAppleBrownLight24]::new()
        $this.ColorMap[822] = [CCAppleBrownLight24]::new()
        $this.ColorMap[823] = [CCAppleBrownLight24]::new()
        $this.ColorMap[824] = [CCAppleBrownLight24]::new()
        $this.ColorMap[825] = [CCAppleBrownLight24]::new()
        $this.ColorMap[826] = [CCAppleBrownLight24]::new()
        $this.ColorMap[827] = [CCAppleBrownLight24]::new()
        $this.ColorMap[828] = [CCAppleBrownLight24]::new()
        $this.ColorMap[829] = [CCAppleBrownLight24]::new()
        $this.ColorMap[830] = [CCAppleBrownLight24]::new()
        $this.ColorMap[831] = [CCAppleBrownLight24]::new()
        $this.ColorMap[832] = [CCAppleBrownLight24]::new()
        $this.ColorMap[833] = [CCAppleBrownLight24]::new()
        $this.ColorMap[834] = [CCAppleBrownLight24]::new()
        $this.ColorMap[835] = [CCAppleBrownLight24]::new()
        $this.ColorMap[836] = [CCAppleBrownLight24]::new()
        $this.ColorMap[837] = [CCAppleBrownLight24]::new()
        $this.ColorMap[838] = [CCAppleBrownLight24]::new()
        $this.ColorMap[839] = [CCAppleBrownLight24]::new()
        $this.ColorMap[840] = [CCAppleBrownLight24]::new()
        $this.ColorMap[841] = [CCAppleBrownLight24]::new()
        $this.ColorMap[842] = [CCAppleBrownLight24]::new()
        $this.ColorMap[843] = [CCAppleBrownLight24]::new()
        $this.ColorMap[844] = [CCAppleGreenLight24]::new()
        $this.ColorMap[845] = [CCAppleGreenLight24]::new()
        $this.ColorMap[846] = [CCAppleGreenLight24]::new()
        $this.ColorMap[847] = [CCAppleGreenLight24]::new()
        $this.ColorMap[848] = [CCAppleGreenLight24]::new()
        $this.ColorMap[849] = [CCAppleGreenLight24]::new()
        $this.ColorMap[850] = [CCAppleGreenLight24]::new()
        $this.ColorMap[851] = [CCAppleGreenLight24]::new()
        $this.ColorMap[852] = [CCAppleGreenLight24]::new()
        $this.ColorMap[853] = [CCAppleGreenLight24]::new()
        $this.ColorMap[854] = [CCAppleGreenLight24]::new()
        $this.ColorMap[855] = [CCAppleGreenLight24]::new()
        $this.ColorMap[856] = [CCAppleGreenLight24]::new()
        $this.ColorMap[857] = [CCAppleGreenLight24]::new()
        $this.ColorMap[858] = [CCAppleGreenLight24]::new()
        $this.ColorMap[859] = [CCAppleGreenLight24]::new()
        $this.ColorMap[860] = [CCAppleGreenLight24]::new()
        $this.ColorMap[861] = [CCAppleGreenLight24]::new()
        $this.ColorMap[862] = [CCAppleGreenLight24]::new()
        $this.ColorMap[863] = [CCAppleGreenLight24]::new() # End Row 17
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Finished filling the Color Map.')

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Calling CreateSceneImageATString.')
        $this.CreateSceneImageATString($this.ColorMap)
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Nulling the Color Map.')
        $this.ColorMap = $null
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }
}

Class SIFieldNorthEastWestRoad : SIInternalBase {
    SIFieldNorthEastWestRoad(): base() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Updating the Progress Bar for the Scene Image Progress.')
        Write-Progress -Activity 'Creating Scene Images      ' -Id 3 -Status 'Creating SIFieldNorthEastWestRoad' -PercentComplete -1
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Filling the Color Map.')
        $this.ColorMap[0]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[1]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[2]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[3]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[4]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[5]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[6]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[7]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[8]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[9]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[10]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[11]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[12]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[13]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[14]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[15]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[16]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[17]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[18]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[19]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[20]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[21]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[22]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[23]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[24]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[25]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[26]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[27]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[28]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[29]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[30]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[31]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[32]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[33]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[34]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[35]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[36]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[37]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[38]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[39]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[40]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[41]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[42]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[43]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[44]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[45]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[46]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[47]  = [CCAppleBlueLight24]::new() # End Row 0
        $this.ColorMap[48]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[49]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[50]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[51]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[52]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[53]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[54]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[55]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[56]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[57]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[58]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[59]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[60]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[61]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[62]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[63]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[64]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[65]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[66]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[67]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[68]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[69]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[70]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[71]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[72]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[73]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[74]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[75]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[76]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[77]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[78]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[79]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[80]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[81]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[82]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[83]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[84]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[85]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[86]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[87]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[88]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[89]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[90]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[91]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[92]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[93]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[94]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[95]  = [CCAppleBlueLight24]::new() # End Row 1
        $this.ColorMap[96]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[97]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[98]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[99]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[100] = [CCAppleBlueLight24]::new()
        $this.ColorMap[101] = [CCAppleBlueLight24]::new()
        $this.ColorMap[102] = [CCAppleBlueLight24]::new()
        $this.ColorMap[103] = [CCAppleBlueLight24]::new()
        $this.ColorMap[104] = [CCAppleBlueLight24]::new()
        $this.ColorMap[105] = [CCAppleBlueLight24]::new()
        $this.ColorMap[106] = [CCAppleBlueLight24]::new()
        $this.ColorMap[107] = [CCAppleBlueLight24]::new()
        $this.ColorMap[108] = [CCAppleBlueLight24]::new()
        $this.ColorMap[109] = [CCAppleBlueLight24]::new()
        $this.ColorMap[110] = [CCAppleBlueLight24]::new()
        $this.ColorMap[111] = [CCAppleBlueLight24]::new()
        $this.ColorMap[112] = [CCAppleBlueLight24]::new()
        $this.ColorMap[113] = [CCAppleBlueLight24]::new()
        $this.ColorMap[114] = [CCAppleBlueLight24]::new()
        $this.ColorMap[115] = [CCAppleBlueLight24]::new()
        $this.ColorMap[116] = [CCAppleBlueLight24]::new()
        $this.ColorMap[117] = [CCAppleBlueLight24]::new()
        $this.ColorMap[118] = [CCAppleBlueLight24]::new()
        $this.ColorMap[119] = [CCAppleBlueLight24]::new()
        $this.ColorMap[120] = [CCAppleBlueLight24]::new()
        $this.ColorMap[121] = [CCAppleBlueLight24]::new()
        $this.ColorMap[122] = [CCAppleBlueLight24]::new()
        $this.ColorMap[123] = [CCAppleBlueLight24]::new()
        $this.ColorMap[124] = [CCAppleBlueLight24]::new()
        $this.ColorMap[125] = [CCAppleBlueLight24]::new()
        $this.ColorMap[126] = [CCAppleBlueLight24]::new()
        $this.ColorMap[127] = [CCAppleBlueLight24]::new()
        $this.ColorMap[128] = [CCAppleBlueLight24]::new()
        $this.ColorMap[129] = [CCAppleBlueLight24]::new()
        $this.ColorMap[130] = [CCAppleBlueLight24]::new()
        $this.ColorMap[131] = [CCAppleBlueLight24]::new()
        $this.ColorMap[132] = [CCAppleBlueLight24]::new()
        $this.ColorMap[133] = [CCAppleBlueLight24]::new()
        $this.ColorMap[134] = [CCAppleBlueLight24]::new()
        $this.ColorMap[135] = [CCAppleBlueLight24]::new()
        $this.ColorMap[136] = [CCAppleBlueLight24]::new()
        $this.ColorMap[137] = [CCAppleBlueLight24]::new()
        $this.ColorMap[138] = [CCAppleBlueLight24]::new()
        $this.ColorMap[139] = [CCAppleBlueLight24]::new()
        $this.ColorMap[140] = [CCAppleBlueLight24]::new()
        $this.ColorMap[141] = [CCAppleBlueLight24]::new()
        $this.ColorMap[142] = [CCAppleBlueLight24]::new()
        $this.ColorMap[143] = [CCAppleBlueLight24]::new() # End Row 2
        $this.ColorMap[144] = [CCAppleBlueLight24]::new()
        $this.ColorMap[145] = [CCAppleBlueLight24]::new()
        $this.ColorMap[146] = [CCAppleBlueLight24]::new()
        $this.ColorMap[147] = [CCAppleBlueLight24]::new()
        $this.ColorMap[148] = [CCAppleBlueLight24]::new()
        $this.ColorMap[149] = [CCAppleBlueLight24]::new()
        $this.ColorMap[150] = [CCAppleBlueLight24]::new()
        $this.ColorMap[151] = [CCAppleBlueLight24]::new()
        $this.ColorMap[152] = [CCAppleBlueLight24]::new()
        $this.ColorMap[153] = [CCAppleBlueLight24]::new()
        $this.ColorMap[154] = [CCAppleBlueLight24]::new()
        $this.ColorMap[155] = [CCAppleBlueLight24]::new()
        $this.ColorMap[156] = [CCAppleBlueLight24]::new()
        $this.ColorMap[157] = [CCAppleBlueLight24]::new()
        $this.ColorMap[158] = [CCAppleBlueLight24]::new()
        $this.ColorMap[159] = [CCAppleBlueLight24]::new()
        $this.ColorMap[160] = [CCAppleBlueLight24]::new()
        $this.ColorMap[161] = [CCAppleBlueLight24]::new()
        $this.ColorMap[162] = [CCAppleBlueLight24]::new()
        $this.ColorMap[163] = [CCAppleBlueLight24]::new()
        $this.ColorMap[164] = [CCAppleBlueLight24]::new()
        $this.ColorMap[165] = [CCAppleBlueLight24]::new()
        $this.ColorMap[166] = [CCAppleBlueLight24]::new()
        $this.ColorMap[167] = [CCAppleBlueLight24]::new()
        $this.ColorMap[168] = [CCAppleBlueLight24]::new()
        $this.ColorMap[169] = [CCAppleBlueLight24]::new()
        $this.ColorMap[170] = [CCAppleBlueLight24]::new()
        $this.ColorMap[171] = [CCAppleBlueLight24]::new()
        $this.ColorMap[172] = [CCAppleBlueLight24]::new()
        $this.ColorMap[173] = [CCAppleBlueLight24]::new()
        $this.ColorMap[174] = [CCAppleBlueLight24]::new()
        $this.ColorMap[175] = [CCAppleBlueLight24]::new()
        $this.ColorMap[176] = [CCAppleBlueLight24]::new()
        $this.ColorMap[177] = [CCAppleBlueLight24]::new()
        $this.ColorMap[178] = [CCAppleBlueLight24]::new()
        $this.ColorMap[179] = [CCAppleBlueLight24]::new()
        $this.ColorMap[180] = [CCAppleBlueLight24]::new()
        $this.ColorMap[181] = [CCAppleBlueLight24]::new()
        $this.ColorMap[182] = [CCAppleBlueLight24]::new()
        $this.ColorMap[183] = [CCAppleBlueLight24]::new()
        $this.ColorMap[184] = [CCAppleBlueLight24]::new()
        $this.ColorMap[185] = [CCAppleBlueLight24]::new()
        $this.ColorMap[186] = [CCAppleBlueLight24]::new()
        $this.ColorMap[187] = [CCAppleBlueLight24]::new()
        $this.ColorMap[188] = [CCAppleBlueLight24]::new()
        $this.ColorMap[189] = [CCAppleBlueLight24]::new()
        $this.ColorMap[190] = [CCAppleBlueLight24]::new()
        $this.ColorMap[191] = [CCAppleBlueLight24]::new() # End Row 3
        $this.ColorMap[192] = [CCAppleBlueLight24]::new()
        $this.ColorMap[193] = [CCAppleBlueLight24]::new()
        $this.ColorMap[194] = [CCAppleBlueLight24]::new()
        $this.ColorMap[195] = [CCAppleBlueLight24]::new()
        $this.ColorMap[196] = [CCAppleBlueLight24]::new()
        $this.ColorMap[197] = [CCAppleBlueLight24]::new()
        $this.ColorMap[198] = [CCAppleBlueLight24]::new()
        $this.ColorMap[199] = [CCAppleBlueLight24]::new()
        $this.ColorMap[200] = [CCAppleBlueLight24]::new()
        $this.ColorMap[201] = [CCAppleBlueLight24]::new()
        $this.ColorMap[202] = [CCAppleBlueLight24]::new()
        $this.ColorMap[203] = [CCAppleBlueLight24]::new()
        $this.ColorMap[204] = [CCAppleBlueLight24]::new()
        $this.ColorMap[205] = [CCAppleBlueLight24]::new()
        $this.ColorMap[206] = [CCAppleBlueLight24]::new()
        $this.ColorMap[207] = [CCAppleBlueLight24]::new()
        $this.ColorMap[208] = [CCAppleBlueLight24]::new()
        $this.ColorMap[209] = [CCAppleBlueLight24]::new()
        $this.ColorMap[210] = [CCAppleBlueLight24]::new()
        $this.ColorMap[211] = [CCAppleBlueLight24]::new()
        $this.ColorMap[212] = [CCAppleBlueLight24]::new()
        $this.ColorMap[213] = [CCAppleBlueLight24]::new()
        $this.ColorMap[214] = [CCAppleBlueLight24]::new()
        $this.ColorMap[215] = [CCAppleBlueLight24]::new()
        $this.ColorMap[216] = [CCAppleBlueLight24]::new()
        $this.ColorMap[217] = [CCAppleBlueLight24]::new()
        $this.ColorMap[218] = [CCAppleBlueLight24]::new()
        $this.ColorMap[219] = [CCAppleBlueLight24]::new()
        $this.ColorMap[220] = [CCAppleBlueLight24]::new()
        $this.ColorMap[221] = [CCAppleBlueLight24]::new()
        $this.ColorMap[222] = [CCAppleBlueLight24]::new()
        $this.ColorMap[223] = [CCAppleBlueLight24]::new()
        $this.ColorMap[224] = [CCAppleBlueLight24]::new()
        $this.ColorMap[225] = [CCAppleBlueLight24]::new()
        $this.ColorMap[226] = [CCAppleBlueLight24]::new()
        $this.ColorMap[227] = [CCAppleBlueLight24]::new()
        $this.ColorMap[228] = [CCAppleBlueLight24]::new()
        $this.ColorMap[229] = [CCAppleBlueLight24]::new()
        $this.ColorMap[230] = [CCAppleBlueLight24]::new()
        $this.ColorMap[231] = [CCAppleBlueLight24]::new()
        $this.ColorMap[232] = [CCAppleBlueLight24]::new()
        $this.ColorMap[233] = [CCAppleBlueLight24]::new()
        $this.ColorMap[234] = [CCAppleBlueLight24]::new()
        $this.ColorMap[235] = [CCAppleBlueLight24]::new()
        $this.ColorMap[236] = [CCAppleBlueLight24]::new()
        $this.ColorMap[237] = [CCAppleBlueLight24]::new()
        $this.ColorMap[238] = [CCAppleBlueLight24]::new()
        $this.ColorMap[239] = [CCAppleBlueLight24]::new() # End Row 4
        $this.ColorMap[240] = [CCAppleGreenLight24]::new()
        $this.ColorMap[241] = [CCAppleGreenLight24]::new()
        $this.ColorMap[242] = [CCAppleGreenLight24]::new()
        $this.ColorMap[243] = [CCAppleGreenLight24]::new()
        $this.ColorMap[244] = [CCAppleGreenLight24]::new()
        $this.ColorMap[245] = [CCAppleGreenLight24]::new()
        $this.ColorMap[246] = [CCAppleGreenLight24]::new()
        $this.ColorMap[247] = [CCAppleGreenLight24]::new()
        $this.ColorMap[248] = [CCAppleGreenLight24]::new()
        $this.ColorMap[249] = [CCAppleGreenLight24]::new()
        $this.ColorMap[250] = [CCAppleGreenLight24]::new()
        $this.ColorMap[251] = [CCAppleGreenLight24]::new()
        $this.ColorMap[252] = [CCAppleGreenLight24]::new()
        $this.ColorMap[253] = [CCAppleGreenLight24]::new()
        $this.ColorMap[254] = [CCAppleGreenLight24]::new()
        $this.ColorMap[255] = [CCAppleGreenLight24]::new()
        $this.ColorMap[256] = [CCAppleGreenLight24]::new()
        $this.ColorMap[257] = [CCAppleGreenLight24]::new()
        $this.ColorMap[258] = [CCAppleGreenLight24]::new()
        $this.ColorMap[259] = [CCAppleGreenLight24]::new()
        $this.ColorMap[260] = [CCAppleGreenLight24]::new()
        $this.ColorMap[261] = [CCAppleGreenLight24]::new()
        $this.ColorMap[262] = [CCAppleGreenLight24]::new()
        $this.ColorMap[263] = [CCAppleGreenLight24]::new()
        $this.ColorMap[264] = [CCAppleBrownLight24]::new()
        $this.ColorMap[265] = [CCAppleGreenLight24]::new()
        $this.ColorMap[266] = [CCAppleGreenLight24]::new()
        $this.ColorMap[267] = [CCAppleGreenLight24]::new()
        $this.ColorMap[268] = [CCAppleGreenLight24]::new()
        $this.ColorMap[269] = [CCAppleGreenLight24]::new()
        $this.ColorMap[270] = [CCAppleGreenLight24]::new()
        $this.ColorMap[271] = [CCAppleGreenLight24]::new()
        $this.ColorMap[272] = [CCAppleGreenLight24]::new()
        $this.ColorMap[273] = [CCAppleGreenLight24]::new()
        $this.ColorMap[274] = [CCAppleGreenLight24]::new()
        $this.ColorMap[275] = [CCAppleGreenLight24]::new()
        $this.ColorMap[276] = [CCAppleGreenLight24]::new()
        $this.ColorMap[277] = [CCAppleGreenLight24]::new()
        $this.ColorMap[278] = [CCAppleGreenLight24]::new()
        $this.ColorMap[279] = [CCAppleGreenLight24]::new()
        $this.ColorMap[280] = [CCAppleGreenLight24]::new()
        $this.ColorMap[281] = [CCAppleGreenLight24]::new()
        $this.ColorMap[282] = [CCAppleGreenLight24]::new()
        $this.ColorMap[283] = [CCAppleGreenLight24]::new()
        $this.ColorMap[284] = [CCAppleGreenLight24]::new()
        $this.ColorMap[285] = [CCAppleGreenLight24]::new()
        $this.ColorMap[286] = [CCAppleGreenLight24]::new()
        $this.ColorMap[287] = [CCAppleGreenLight24]::new() # End Row 5
        $this.ColorMap[288] = [CCAppleGreenLight24]::new()
        $this.ColorMap[289] = [CCAppleGreenLight24]::new()
        $this.ColorMap[290] = [CCAppleGreenLight24]::new()
        $this.ColorMap[291] = [CCAppleGreenLight24]::new()
        $this.ColorMap[292] = [CCAppleGreenLight24]::new()
        $this.ColorMap[293] = [CCAppleGreenLight24]::new()
        $this.ColorMap[294] = [CCAppleGreenLight24]::new()
        $this.ColorMap[295] = [CCAppleGreenLight24]::new()
        $this.ColorMap[296] = [CCAppleGreenLight24]::new()
        $this.ColorMap[297] = [CCAppleGreenLight24]::new()
        $this.ColorMap[298] = [CCAppleGreenLight24]::new()
        $this.ColorMap[299] = [CCAppleGreenLight24]::new()
        $this.ColorMap[300] = [CCAppleGreenLight24]::new()
        $this.ColorMap[301] = [CCAppleGreenLight24]::new()
        $this.ColorMap[302] = [CCAppleGreenLight24]::new()
        $this.ColorMap[303] = [CCAppleGreenLight24]::new()
        $this.ColorMap[304] = [CCAppleGreenLight24]::new()
        $this.ColorMap[305] = [CCAppleGreenLight24]::new()
        $this.ColorMap[306] = [CCAppleGreenLight24]::new()
        $this.ColorMap[307] = [CCAppleGreenLight24]::new()
        $this.ColorMap[308] = [CCAppleGreenLight24]::new()
        $this.ColorMap[309] = [CCAppleGreenLight24]::new()
        $this.ColorMap[310] = [CCAppleGreenLight24]::new()
        $this.ColorMap[311] = [CCAppleGreenLight24]::new()
        $this.ColorMap[312] = [CCAppleBrownLight24]::new()
        $this.ColorMap[313] = [CCAppleGreenLight24]::new()
        $this.ColorMap[314] = [CCAppleGreenLight24]::new()
        $this.ColorMap[315] = [CCAppleGreenLight24]::new()
        $this.ColorMap[316] = [CCAppleGreenLight24]::new()
        $this.ColorMap[317] = [CCAppleGreenLight24]::new()
        $this.ColorMap[318] = [CCAppleGreenLight24]::new()
        $this.ColorMap[319] = [CCAppleGreenLight24]::new()
        $this.ColorMap[320] = [CCAppleGreenLight24]::new()
        $this.ColorMap[321] = [CCAppleGreenLight24]::new()
        $this.ColorMap[322] = [CCAppleGreenLight24]::new()
        $this.ColorMap[323] = [CCAppleGreenLight24]::new()
        $this.ColorMap[324] = [CCAppleGreenLight24]::new()
        $this.ColorMap[325] = [CCAppleGreenLight24]::new()
        $this.ColorMap[326] = [CCAppleGreenLight24]::new()
        $this.ColorMap[327] = [CCAppleGreenLight24]::new()
        $this.ColorMap[328] = [CCAppleGreenLight24]::new()
        $this.ColorMap[329] = [CCAppleGreenLight24]::new()
        $this.ColorMap[330] = [CCAppleGreenLight24]::new()
        $this.ColorMap[331] = [CCAppleGreenLight24]::new()
        $this.ColorMap[332] = [CCAppleGreenLight24]::new()
        $this.ColorMap[333] = [CCAppleGreenLight24]::new()
        $this.ColorMap[334] = [CCAppleGreenLight24]::new()
        $this.ColorMap[335] = [CCAppleGreenLight24]::new() # End Row 6
        $this.ColorMap[336] = [CCAppleGreenLight24]::new()
        $this.ColorMap[337] = [CCAppleGreenLight24]::new()
        $this.ColorMap[338] = [CCAppleGreenLight24]::new()
        $this.ColorMap[339] = [CCAppleGreenLight24]::new()
        $this.ColorMap[340] = [CCAppleGreenLight24]::new()
        $this.ColorMap[341] = [CCAppleGreenLight24]::new()
        $this.ColorMap[342] = [CCAppleGreenLight24]::new()
        $this.ColorMap[343] = [CCAppleGreenLight24]::new()
        $this.ColorMap[344] = [CCAppleGreenLight24]::new()
        $this.ColorMap[345] = [CCAppleGreenLight24]::new()
        $this.ColorMap[346] = [CCAppleGreenLight24]::new()
        $this.ColorMap[347] = [CCAppleGreenLight24]::new()
        $this.ColorMap[348] = [CCAppleGreenLight24]::new()
        $this.ColorMap[349] = [CCAppleGreenLight24]::new()
        $this.ColorMap[350] = [CCAppleGreenLight24]::new()
        $this.ColorMap[351] = [CCAppleGreenLight24]::new()
        $this.ColorMap[352] = [CCAppleGreenLight24]::new()
        $this.ColorMap[353] = [CCAppleGreenLight24]::new()
        $this.ColorMap[354] = [CCAppleGreenLight24]::new()
        $this.ColorMap[355] = [CCAppleGreenLight24]::new()
        $this.ColorMap[356] = [CCAppleGreenLight24]::new()
        $this.ColorMap[357] = [CCAppleGreenLight24]::new()
        $this.ColorMap[358] = [CCAppleGreenLight24]::new()
        $this.ColorMap[359] = [CCAppleBrownLight24]::new()
        $this.ColorMap[360] = [CCAppleBrownLight24]::new()
        $this.ColorMap[361] = [CCAppleBrownLight24]::new()
        $this.ColorMap[362] = [CCAppleGreenLight24]::new()
        $this.ColorMap[363] = [CCAppleGreenLight24]::new()
        $this.ColorMap[364] = [CCAppleGreenLight24]::new()
        $this.ColorMap[365] = [CCAppleGreenLight24]::new()
        $this.ColorMap[366] = [CCAppleGreenLight24]::new()
        $this.ColorMap[367] = [CCAppleGreenLight24]::new()
        $this.ColorMap[368] = [CCAppleGreenLight24]::new()
        $this.ColorMap[369] = [CCAppleGreenLight24]::new()
        $this.ColorMap[370] = [CCAppleGreenLight24]::new()
        $this.ColorMap[371] = [CCAppleGreenLight24]::new()
        $this.ColorMap[372] = [CCAppleGreenLight24]::new()
        $this.ColorMap[373] = [CCAppleGreenLight24]::new()
        $this.ColorMap[374] = [CCAppleGreenLight24]::new()
        $this.ColorMap[375] = [CCAppleGreenLight24]::new()
        $this.ColorMap[376] = [CCAppleGreenLight24]::new()
        $this.ColorMap[377] = [CCAppleGreenLight24]::new()
        $this.ColorMap[378] = [CCAppleGreenLight24]::new()
        $this.ColorMap[379] = [CCAppleGreenLight24]::new()
        $this.ColorMap[380] = [CCAppleGreenLight24]::new()
        $this.ColorMap[381] = [CCAppleGreenLight24]::new()
        $this.ColorMap[382] = [CCAppleGreenLight24]::new()
        $this.ColorMap[383] = [CCAppleGreenLight24]::new() # End Row 7
        $this.ColorMap[384] = [CCAppleGreenLight24]::new()
        $this.ColorMap[385] = [CCAppleGreenLight24]::new()
        $this.ColorMap[386] = [CCAppleGreenLight24]::new()
        $this.ColorMap[387] = [CCAppleGreenLight24]::new()
        $this.ColorMap[388] = [CCAppleGreenLight24]::new()
        $this.ColorMap[389] = [CCAppleGreenLight24]::new()
        $this.ColorMap[390] = [CCAppleGreenLight24]::new()
        $this.ColorMap[391] = [CCAppleGreenLight24]::new()
        $this.ColorMap[392] = [CCAppleGreenLight24]::new()
        $this.ColorMap[393] = [CCAppleGreenLight24]::new()
        $this.ColorMap[394] = [CCAppleGreenLight24]::new()
        $this.ColorMap[395] = [CCAppleGreenLight24]::new()
        $this.ColorMap[396] = [CCAppleGreenLight24]::new()
        $this.ColorMap[397] = [CCAppleGreenLight24]::new()
        $this.ColorMap[398] = [CCAppleGreenLight24]::new()
        $this.ColorMap[399] = [CCAppleGreenLight24]::new()
        $this.ColorMap[400] = [CCAppleGreenLight24]::new()
        $this.ColorMap[401] = [CCAppleGreenLight24]::new()
        $this.ColorMap[402] = [CCAppleGreenLight24]::new()
        $this.ColorMap[403] = [CCAppleGreenLight24]::new()
        $this.ColorMap[404] = [CCAppleGreenLight24]::new()
        $this.ColorMap[405] = [CCAppleGreenLight24]::new()
        $this.ColorMap[406] = [CCAppleBrownLight24]::new()
        $this.ColorMap[407] = [CCAppleBrownLight24]::new()
        $this.ColorMap[408] = [CCAppleBrownLight24]::new()
        $this.ColorMap[409] = [CCAppleBrownLight24]::new()
        $this.ColorMap[410] = [CCAppleBrownLight24]::new()
        $this.ColorMap[411] = [CCAppleGreenLight24]::new()
        $this.ColorMap[412] = [CCAppleGreenLight24]::new()
        $this.ColorMap[413] = [CCAppleGreenLight24]::new()
        $this.ColorMap[414] = [CCAppleGreenLight24]::new()
        $this.ColorMap[415] = [CCAppleGreenLight24]::new()
        $this.ColorMap[416] = [CCAppleGreenLight24]::new()
        $this.ColorMap[417] = [CCAppleGreenLight24]::new()
        $this.ColorMap[418] = [CCAppleGreenLight24]::new()
        $this.ColorMap[419] = [CCAppleGreenLight24]::new()
        $this.ColorMap[420] = [CCAppleGreenLight24]::new()
        $this.ColorMap[421] = [CCAppleGreenLight24]::new()
        $this.ColorMap[422] = [CCAppleGreenLight24]::new()
        $this.ColorMap[423] = [CCAppleGreenLight24]::new()
        $this.ColorMap[424] = [CCAppleGreenLight24]::new()
        $this.ColorMap[425] = [CCAppleGreenLight24]::new()
        $this.ColorMap[426] = [CCAppleGreenLight24]::new()
        $this.ColorMap[427] = [CCAppleGreenLight24]::new()
        $this.ColorMap[428] = [CCAppleGreenLight24]::new()
        $this.ColorMap[429] = [CCAppleGreenLight24]::new()
        $this.ColorMap[430] = [CCAppleGreenLight24]::new()
        $this.ColorMap[431] = [CCAppleGreenLight24]::new() # End Row 8
        $this.ColorMap[432] = [CCAppleGreenLight24]::new()
        $this.ColorMap[433] = [CCAppleGreenLight24]::new()
        $this.ColorMap[434] = [CCAppleGreenLight24]::new()
        $this.ColorMap[435] = [CCAppleGreenLight24]::new()
        $this.ColorMap[436] = [CCAppleGreenLight24]::new()
        $this.ColorMap[437] = [CCAppleGreenLight24]::new()
        $this.ColorMap[438] = [CCAppleGreenLight24]::new()
        $this.ColorMap[439] = [CCAppleGreenLight24]::new()
        $this.ColorMap[440] = [CCAppleGreenLight24]::new()
        $this.ColorMap[441] = [CCAppleGreenLight24]::new()
        $this.ColorMap[442] = [CCAppleGreenLight24]::new()
        $this.ColorMap[443] = [CCAppleGreenLight24]::new()
        $this.ColorMap[444] = [CCAppleGreenLight24]::new()
        $this.ColorMap[445] = [CCAppleGreenLight24]::new()
        $this.ColorMap[446] = [CCAppleGreenLight24]::new()
        $this.ColorMap[447] = [CCAppleGreenLight24]::new()
        $this.ColorMap[448] = [CCAppleGreenLight24]::new()
        $this.ColorMap[449] = [CCAppleGreenLight24]::new()
        $this.ColorMap[450] = [CCAppleGreenLight24]::new()
        $this.ColorMap[451] = [CCAppleGreenLight24]::new()
        $this.ColorMap[452] = [CCAppleGreenLight24]::new()
        $this.ColorMap[453] = [CCAppleGreenLight24]::new()
        $this.ColorMap[454] = [CCAppleBrownLight24]::new()
        $this.ColorMap[455] = [CCAppleBrownLight24]::new()
        $this.ColorMap[456] = [CCAppleBrownLight24]::new()
        $this.ColorMap[457] = [CCAppleBrownLight24]::new()
        $this.ColorMap[458] = [CCAppleBrownLight24]::new()
        $this.ColorMap[459] = [CCAppleGreenLight24]::new()
        $this.ColorMap[460] = [CCAppleGreenLight24]::new()
        $this.ColorMap[461] = [CCAppleGreenLight24]::new()
        $this.ColorMap[462] = [CCAppleGreenLight24]::new()
        $this.ColorMap[463] = [CCAppleGreenLight24]::new()
        $this.ColorMap[464] = [CCAppleGreenLight24]::new()
        $this.ColorMap[465] = [CCAppleGreenLight24]::new()
        $this.ColorMap[466] = [CCAppleGreenLight24]::new()
        $this.ColorMap[467] = [CCAppleGreenLight24]::new()
        $this.ColorMap[468] = [CCAppleGreenLight24]::new()
        $this.ColorMap[469] = [CCAppleGreenLight24]::new()
        $this.ColorMap[470] = [CCAppleGreenLight24]::new()
        $this.ColorMap[471] = [CCAppleGreenLight24]::new()
        $this.ColorMap[472] = [CCAppleGreenLight24]::new()
        $this.ColorMap[473] = [CCAppleGreenLight24]::new()
        $this.ColorMap[474] = [CCAppleGreenLight24]::new()
        $this.ColorMap[475] = [CCAppleGreenLight24]::new()
        $this.ColorMap[476] = [CCAppleGreenLight24]::new()
        $this.ColorMap[477] = [CCAppleGreenLight24]::new()
        $this.ColorMap[478] = [CCAppleGreenLight24]::new()
        $this.ColorMap[479] = [CCAppleGreenLight24]::new() # End Row 9
        $this.ColorMap[480] = [CCAppleGreenLight24]::new()
        $this.ColorMap[481] = [CCAppleGreenLight24]::new()
        $this.ColorMap[482] = [CCAppleGreenLight24]::new()
        $this.ColorMap[483] = [CCAppleGreenLight24]::new()
        $this.ColorMap[484] = [CCAppleGreenLight24]::new()
        $this.ColorMap[485] = [CCAppleGreenLight24]::new()
        $this.ColorMap[486] = [CCAppleGreenLight24]::new()
        $this.ColorMap[487] = [CCAppleGreenLight24]::new()
        $this.ColorMap[488] = [CCAppleGreenLight24]::new()
        $this.ColorMap[489] = [CCAppleGreenLight24]::new()
        $this.ColorMap[490] = [CCAppleGreenLight24]::new()
        $this.ColorMap[491] = [CCAppleGreenLight24]::new()
        $this.ColorMap[492] = [CCAppleGreenLight24]::new()
        $this.ColorMap[493] = [CCAppleGreenLight24]::new()
        $this.ColorMap[494] = [CCAppleGreenLight24]::new()
        $this.ColorMap[495] = [CCAppleGreenLight24]::new()
        $this.ColorMap[496] = [CCAppleGreenLight24]::new()
        $this.ColorMap[497] = [CCAppleGreenLight24]::new()
        $this.ColorMap[498] = [CCAppleGreenLight24]::new()
        $this.ColorMap[499] = [CCAppleGreenLight24]::new()
        $this.ColorMap[500] = [CCAppleGreenLight24]::new()
        $this.ColorMap[501] = [CCAppleBrownLight24]::new()
        $this.ColorMap[502] = [CCAppleBrownLight24]::new()
        $this.ColorMap[503] = [CCAppleBrownLight24]::new()
        $this.ColorMap[504] = [CCAppleBrownLight24]::new()
        $this.ColorMap[505] = [CCAppleBrownLight24]::new()
        $this.ColorMap[506] = [CCAppleBrownLight24]::new()
        $this.ColorMap[507] = [CCAppleBrownLight24]::new()
        $this.ColorMap[508] = [CCAppleGreenLight24]::new()
        $this.ColorMap[509] = [CCAppleGreenLight24]::new()
        $this.ColorMap[510] = [CCAppleGreenLight24]::new()
        $this.ColorMap[511] = [CCAppleGreenLight24]::new()
        $this.ColorMap[512] = [CCAppleGreenLight24]::new()
        $this.ColorMap[513] = [CCAppleGreenLight24]::new()
        $this.ColorMap[514] = [CCAppleGreenLight24]::new()
        $this.ColorMap[515] = [CCAppleGreenLight24]::new()
        $this.ColorMap[516] = [CCAppleGreenLight24]::new()
        $this.ColorMap[517] = [CCAppleGreenLight24]::new()
        $this.ColorMap[518] = [CCAppleGreenLight24]::new()
        $this.ColorMap[519] = [CCAppleGreenLight24]::new()
        $this.ColorMap[520] = [CCAppleGreenLight24]::new()
        $this.ColorMap[521] = [CCAppleGreenLight24]::new()
        $this.ColorMap[522] = [CCAppleGreenLight24]::new()
        $this.ColorMap[523] = [CCAppleGreenLight24]::new()
        $this.ColorMap[524] = [CCAppleGreenLight24]::new()
        $this.ColorMap[525] = [CCAppleGreenLight24]::new()
        $this.ColorMap[526] = [CCAppleGreenLight24]::new()
        $this.ColorMap[527] = [CCAppleGreenLight24]::new() # End Row 10
        $this.ColorMap[528] = [CCAppleGreenLight24]::new()
        $this.ColorMap[529] = [CCAppleGreenLight24]::new()
        $this.ColorMap[530] = [CCAppleGreenLight24]::new()
        $this.ColorMap[531] = [CCAppleGreenLight24]::new()
        $this.ColorMap[532] = [CCAppleGreenLight24]::new()
        $this.ColorMap[533] = [CCAppleGreenLight24]::new()
        $this.ColorMap[534] = [CCAppleGreenLight24]::new()
        $this.ColorMap[535] = [CCAppleGreenLight24]::new()
        $this.ColorMap[536] = [CCAppleGreenLight24]::new()
        $this.ColorMap[537] = [CCAppleGreenLight24]::new()
        $this.ColorMap[538] = [CCAppleGreenLight24]::new()
        $this.ColorMap[539] = [CCAppleGreenLight24]::new()
        $this.ColorMap[540] = [CCAppleGreenLight24]::new()
        $this.ColorMap[541] = [CCAppleGreenLight24]::new()
        $this.ColorMap[542] = [CCAppleGreenLight24]::new()
        $this.ColorMap[543] = [CCAppleGreenLight24]::new()
        $this.ColorMap[544] = [CCAppleGreenLight24]::new()
        $this.ColorMap[545] = [CCAppleGreenLight24]::new()
        $this.ColorMap[546] = [CCAppleGreenLight24]::new()
        $this.ColorMap[547] = [CCAppleGreenLight24]::new()
        $this.ColorMap[548] = [CCAppleGreenLight24]::new()
        $this.ColorMap[549] = [CCAppleBrownLight24]::new()
        $this.ColorMap[550] = [CCAppleBrownLight24]::new()
        $this.ColorMap[551] = [CCAppleBrownLight24]::new()
        $this.ColorMap[552] = [CCAppleBrownLight24]::new()
        $this.ColorMap[553] = [CCAppleBrownLight24]::new()
        $this.ColorMap[554] = [CCAppleBrownLight24]::new()
        $this.ColorMap[555] = [CCAppleBrownLight24]::new()
        $this.ColorMap[556] = [CCAppleGreenLight24]::new()
        $this.ColorMap[557] = [CCAppleGreenLight24]::new()
        $this.ColorMap[558] = [CCAppleGreenLight24]::new()
        $this.ColorMap[559] = [CCAppleGreenLight24]::new()
        $this.ColorMap[560] = [CCAppleGreenLight24]::new()
        $this.ColorMap[561] = [CCAppleGreenLight24]::new()
        $this.ColorMap[562] = [CCAppleGreenLight24]::new()
        $this.ColorMap[563] = [CCAppleGreenLight24]::new()
        $this.ColorMap[564] = [CCAppleGreenLight24]::new()
        $this.ColorMap[565] = [CCAppleGreenLight24]::new()
        $this.ColorMap[566] = [CCAppleGreenLight24]::new()
        $this.ColorMap[567] = [CCAppleGreenLight24]::new()
        $this.ColorMap[568] = [CCAppleGreenLight24]::new()
        $this.ColorMap[569] = [CCAppleGreenLight24]::new()
        $this.ColorMap[570] = [CCAppleGreenLight24]::new()
        $this.ColorMap[571] = [CCAppleGreenLight24]::new()
        $this.ColorMap[572] = [CCAppleGreenLight24]::new()
        $this.ColorMap[573] = [CCAppleGreenLight24]::new()
        $this.ColorMap[574] = [CCAppleGreenLight24]::new()
        $this.ColorMap[575] = [CCAppleGreenLight24]::new() # End Row 11
        $this.ColorMap[576] = [CCAppleGreenLight24]::new()
        $this.ColorMap[577] = [CCAppleGreenLight24]::new()
        $this.ColorMap[578] = [CCAppleGreenLight24]::new()
        $this.ColorMap[579] = [CCAppleGreenLight24]::new()
        $this.ColorMap[580] = [CCAppleGreenLight24]::new()
        $this.ColorMap[581] = [CCAppleGreenLight24]::new()
        $this.ColorMap[582] = [CCAppleGreenLight24]::new()
        $this.ColorMap[583] = [CCAppleGreenLight24]::new()
        $this.ColorMap[584] = [CCAppleGreenLight24]::new()
        $this.ColorMap[585] = [CCAppleGreenLight24]::new()
        $this.ColorMap[586] = [CCAppleGreenLight24]::new()
        $this.ColorMap[587] = [CCAppleGreenLight24]::new()
        $this.ColorMap[588] = [CCAppleGreenLight24]::new()
        $this.ColorMap[589] = [CCAppleGreenLight24]::new()
        $this.ColorMap[590] = [CCAppleGreenLight24]::new()
        $this.ColorMap[591] = [CCAppleGreenLight24]::new()
        $this.ColorMap[592] = [CCAppleGreenLight24]::new()
        $this.ColorMap[593] = [CCAppleGreenLight24]::new()
        $this.ColorMap[594] = [CCAppleGreenLight24]::new()
        $this.ColorMap[595] = [CCAppleGreenLight24]::new()
        $this.ColorMap[596] = [CCAppleGreenLight24]::new()
        $this.ColorMap[597] = [CCAppleBrownLight24]::new()
        $this.ColorMap[598] = [CCAppleBrownLight24]::new()
        $this.ColorMap[599] = [CCAppleBrownLight24]::new()
        $this.ColorMap[600] = [CCAppleBrownLight24]::new()
        $this.ColorMap[601] = [CCAppleBrownLight24]::new()
        $this.ColorMap[602] = [CCAppleBrownLight24]::new()
        $this.ColorMap[603] = [CCAppleBrownLight24]::new()
        $this.ColorMap[604] = [CCAppleGreenLight24]::new()
        $this.ColorMap[605] = [CCAppleGreenLight24]::new()
        $this.ColorMap[606] = [CCAppleGreenLight24]::new()
        $this.ColorMap[607] = [CCAppleGreenLight24]::new()
        $this.ColorMap[608] = [CCAppleGreenLight24]::new()
        $this.ColorMap[609] = [CCAppleGreenLight24]::new()
        $this.ColorMap[610] = [CCAppleGreenLight24]::new()
        $this.ColorMap[611] = [CCAppleGreenLight24]::new()
        $this.ColorMap[612] = [CCAppleGreenLight24]::new()
        $this.ColorMap[613] = [CCAppleGreenLight24]::new()
        $this.ColorMap[614] = [CCAppleGreenLight24]::new()
        $this.ColorMap[615] = [CCAppleGreenLight24]::new()
        $this.ColorMap[616] = [CCAppleGreenLight24]::new()
        $this.ColorMap[617] = [CCAppleGreenLight24]::new()
        $this.ColorMap[618] = [CCAppleGreenLight24]::new()
        $this.ColorMap[619] = [CCAppleGreenLight24]::new()
        $this.ColorMap[620] = [CCAppleGreenLight24]::new()
        $this.ColorMap[621] = [CCAppleGreenLight24]::new()
        $this.ColorMap[622] = [CCAppleGreenLight24]::new()
        $this.ColorMap[623] = [CCAppleGreenLight24]::new() # End Row 12
        $this.ColorMap[624] = [CCAppleGreenLight24]::new()
        $this.ColorMap[625] = [CCAppleGreenLight24]::new()
        $this.ColorMap[626] = [CCAppleGreenLight24]::new()
        $this.ColorMap[627] = [CCAppleGreenLight24]::new()
        $this.ColorMap[628] = [CCAppleGreenLight24]::new()
        $this.ColorMap[629] = [CCAppleGreenLight24]::new()
        $this.ColorMap[630] = [CCAppleGreenLight24]::new()
        $this.ColorMap[631] = [CCAppleGreenLight24]::new()
        $this.ColorMap[632] = [CCAppleGreenLight24]::new()
        $this.ColorMap[633] = [CCAppleGreenLight24]::new()
        $this.ColorMap[634] = [CCAppleGreenLight24]::new()
        $this.ColorMap[635] = [CCAppleGreenLight24]::new()
        $this.ColorMap[636] = [CCAppleGreenLight24]::new()
        $this.ColorMap[637] = [CCAppleGreenLight24]::new()
        $this.ColorMap[638] = [CCAppleGreenLight24]::new()
        $this.ColorMap[639] = [CCAppleGreenLight24]::new()
        $this.ColorMap[640] = [CCAppleGreenLight24]::new()
        $this.ColorMap[641] = [CCAppleGreenLight24]::new()
        $this.ColorMap[642] = [CCAppleGreenLight24]::new()
        $this.ColorMap[643] = [CCAppleGreenLight24]::new()
        $this.ColorMap[644] = [CCAppleGreenLight24]::new()
        $this.ColorMap[645] = [CCAppleBrownLight24]::new()
        $this.ColorMap[646] = [CCAppleBrownLight24]::new()
        $this.ColorMap[647] = [CCAppleBrownLight24]::new()
        $this.ColorMap[648] = [CCAppleBrownLight24]::new()
        $this.ColorMap[649] = [CCAppleBrownLight24]::new()
        $this.ColorMap[650] = [CCAppleBrownLight24]::new()
        $this.ColorMap[651] = [CCAppleBrownLight24]::new()
        $this.ColorMap[652] = [CCAppleGreenLight24]::new()
        $this.ColorMap[653] = [CCAppleGreenLight24]::new()
        $this.ColorMap[654] = [CCAppleGreenLight24]::new()
        $this.ColorMap[655] = [CCAppleGreenLight24]::new()
        $this.ColorMap[656] = [CCAppleGreenLight24]::new()
        $this.ColorMap[657] = [CCAppleGreenLight24]::new()
        $this.ColorMap[658] = [CCAppleGreenLight24]::new()
        $this.ColorMap[659] = [CCAppleGreenLight24]::new()
        $this.ColorMap[660] = [CCAppleGreenLight24]::new()
        $this.ColorMap[661] = [CCAppleGreenLight24]::new()
        $this.ColorMap[662] = [CCAppleGreenLight24]::new()
        $this.ColorMap[663] = [CCAppleGreenLight24]::new()
        $this.ColorMap[664] = [CCAppleGreenLight24]::new()
        $this.ColorMap[665] = [CCAppleGreenLight24]::new()
        $this.ColorMap[666] = [CCAppleGreenLight24]::new()
        $this.ColorMap[667] = [CCAppleGreenLight24]::new()
        $this.ColorMap[668] = [CCAppleGreenLight24]::new()
        $this.ColorMap[669] = [CCAppleGreenLight24]::new()
        $this.ColorMap[670] = [CCAppleGreenLight24]::new()
        $this.ColorMap[671] = [CCAppleGreenLight24]::new() # End Row 13
        $this.ColorMap[672] = [CCAppleGreenLight24]::new()
        $this.ColorMap[673] = [CCAppleGreenLight24]::new()
        $this.ColorMap[674] = [CCAppleGreenLight24]::new()
        $this.ColorMap[675] = [CCAppleGreenLight24]::new()
        $this.ColorMap[676] = [CCAppleGreenLight24]::new()
        $this.ColorMap[677] = [CCAppleGreenLight24]::new()
        $this.ColorMap[678] = [CCAppleGreenLight24]::new()
        $this.ColorMap[679] = [CCAppleGreenLight24]::new()
        $this.ColorMap[680] = [CCAppleGreenLight24]::new()
        $this.ColorMap[681] = [CCAppleGreenLight24]::new()
        $this.ColorMap[682] = [CCAppleGreenLight24]::new()
        $this.ColorMap[683] = [CCAppleGreenLight24]::new()
        $this.ColorMap[684] = [CCAppleGreenLight24]::new()
        $this.ColorMap[685] = [CCAppleGreenLight24]::new()
        $this.ColorMap[686] = [CCAppleGreenLight24]::new()
        $this.ColorMap[687] = [CCAppleGreenLight24]::new()
        $this.ColorMap[688] = [CCAppleGreenLight24]::new()
        $this.ColorMap[689] = [CCAppleGreenLight24]::new()
        $this.ColorMap[690] = [CCAppleGreenLight24]::new()
        $this.ColorMap[691] = [CCAppleGreenLight24]::new()
        $this.ColorMap[692] = [CCAppleGreenLight24]::new()
        $this.ColorMap[693] = [CCAppleBrownLight24]::new()
        $this.ColorMap[694] = [CCAppleBrownLight24]::new()
        $this.ColorMap[695] = [CCAppleBrownLight24]::new()
        $this.ColorMap[696] = [CCAppleBrownLight24]::new()
        $this.ColorMap[697] = [CCAppleBrownLight24]::new()
        $this.ColorMap[698] = [CCAppleBrownLight24]::new()
        $this.ColorMap[699] = [CCAppleBrownLight24]::new()
        $this.ColorMap[700] = [CCAppleGreenLight24]::new()
        $this.ColorMap[701] = [CCAppleGreenLight24]::new()
        $this.ColorMap[702] = [CCAppleGreenLight24]::new()
        $this.ColorMap[703] = [CCAppleGreenLight24]::new()
        $this.ColorMap[704] = [CCAppleGreenLight24]::new()
        $this.ColorMap[705] = [CCAppleGreenLight24]::new()
        $this.ColorMap[706] = [CCAppleGreenLight24]::new()
        $this.ColorMap[707] = [CCAppleGreenLight24]::new()
        $this.ColorMap[708] = [CCAppleGreenLight24]::new()
        $this.ColorMap[709] = [CCAppleGreenLight24]::new()
        $this.ColorMap[710] = [CCAppleGreenLight24]::new()
        $this.ColorMap[711] = [CCAppleGreenLight24]::new()
        $this.ColorMap[712] = [CCAppleGreenLight24]::new()
        $this.ColorMap[713] = [CCAppleGreenLight24]::new()
        $this.ColorMap[714] = [CCAppleGreenLight24]::new()
        $this.ColorMap[715] = [CCAppleGreenLight24]::new()
        $this.ColorMap[716] = [CCAppleGreenLight24]::new()
        $this.ColorMap[717] = [CCAppleGreenLight24]::new()
        $this.ColorMap[718] = [CCAppleGreenLight24]::new()
        $this.ColorMap[719] = [CCAppleGreenLight24]::new() # End Row 14
        $this.ColorMap[720] = [CCAppleGreenLight24]::new()
        $this.ColorMap[721] = [CCAppleGreenLight24]::new()
        $this.ColorMap[722] = [CCAppleGreenLight24]::new()
        $this.ColorMap[723] = [CCAppleGreenLight24]::new()
        $this.ColorMap[724] = [CCAppleGreenLight24]::new()
        $this.ColorMap[725] = [CCAppleGreenLight24]::new()
        $this.ColorMap[726] = [CCAppleGreenLight24]::new()
        $this.ColorMap[727] = [CCAppleGreenLight24]::new()
        $this.ColorMap[728] = [CCAppleGreenLight24]::new()
        $this.ColorMap[729] = [CCAppleGreenLight24]::new()
        $this.ColorMap[730] = [CCAppleGreenLight24]::new()
        $this.ColorMap[731] = [CCAppleGreenLight24]::new()
        $this.ColorMap[732] = [CCAppleGreenLight24]::new()
        $this.ColorMap[733] = [CCAppleGreenLight24]::new()
        $this.ColorMap[734] = [CCAppleGreenLight24]::new()
        $this.ColorMap[735] = [CCAppleGreenLight24]::new()
        $this.ColorMap[736] = [CCAppleGreenLight24]::new()
        $this.ColorMap[737] = [CCAppleGreenLight24]::new()
        $this.ColorMap[738] = [CCAppleGreenLight24]::new()
        $this.ColorMap[739] = [CCAppleGreenLight24]::new()
        $this.ColorMap[740] = [CCAppleGreenLight24]::new()
        $this.ColorMap[741] = [CCAppleBrownLight24]::new()
        $this.ColorMap[742] = [CCAppleBrownLight24]::new()
        $this.ColorMap[743] = [CCAppleBrownLight24]::new()
        $this.ColorMap[744] = [CCAppleBrownLight24]::new()
        $this.ColorMap[745] = [CCAppleBrownLight24]::new()
        $this.ColorMap[746] = [CCAppleBrownLight24]::new()
        $this.ColorMap[747] = [CCAppleBrownLight24]::new()
        $this.ColorMap[748] = [CCAppleGreenLight24]::new()
        $this.ColorMap[749] = [CCAppleGreenLight24]::new()
        $this.ColorMap[750] = [CCAppleGreenLight24]::new()
        $this.ColorMap[751] = [CCAppleGreenLight24]::new()
        $this.ColorMap[752] = [CCAppleGreenLight24]::new()
        $this.ColorMap[753] = [CCAppleGreenLight24]::new()
        $this.ColorMap[754] = [CCAppleGreenLight24]::new()
        $this.ColorMap[755] = [CCAppleGreenLight24]::new()
        $this.ColorMap[756] = [CCAppleGreenLight24]::new()
        $this.ColorMap[757] = [CCAppleGreenLight24]::new()
        $this.ColorMap[758] = [CCAppleGreenLight24]::new()
        $this.ColorMap[759] = [CCAppleGreenLight24]::new()
        $this.ColorMap[760] = [CCAppleGreenLight24]::new()
        $this.ColorMap[761] = [CCAppleGreenLight24]::new()
        $this.ColorMap[762] = [CCAppleGreenLight24]::new()
        $this.ColorMap[763] = [CCAppleGreenLight24]::new()
        $this.ColorMap[764] = [CCAppleGreenLight24]::new()
        $this.ColorMap[765] = [CCAppleGreenLight24]::new()
        $this.ColorMap[766] = [CCAppleGreenLight24]::new()
        $this.ColorMap[767] = [CCAppleGreenLight24]::new() # End Row 15
        $this.ColorMap[768] = [CCAppleBrownLight24]::new()
        $this.ColorMap[769] = [CCAppleBrownLight24]::new()
        $this.ColorMap[770] = [CCAppleBrownLight24]::new()
        $this.ColorMap[771] = [CCAppleBrownLight24]::new()
        $this.ColorMap[772] = [CCAppleBrownLight24]::new()
        $this.ColorMap[773] = [CCAppleBrownLight24]::new()
        $this.ColorMap[774] = [CCAppleBrownLight24]::new()
        $this.ColorMap[775] = [CCAppleBrownLight24]::new()
        $this.ColorMap[776] = [CCAppleBrownLight24]::new()
        $this.ColorMap[777] = [CCAppleBrownLight24]::new()
        $this.ColorMap[778] = [CCAppleBrownLight24]::new()
        $this.ColorMap[779] = [CCAppleBrownLight24]::new()
        $this.ColorMap[780] = [CCAppleBrownLight24]::new()
        $this.ColorMap[781] = [CCAppleBrownLight24]::new()
        $this.ColorMap[782] = [CCAppleBrownLight24]::new()
        $this.ColorMap[783] = [CCAppleBrownLight24]::new()
        $this.ColorMap[784] = [CCAppleBrownLight24]::new()
        $this.ColorMap[785] = [CCAppleBrownLight24]::new()
        $this.ColorMap[786] = [CCAppleBrownLight24]::new()
        $this.ColorMap[787] = [CCAppleBrownLight24]::new()
        $this.ColorMap[788] = [CCAppleBrownLight24]::new()
        $this.ColorMap[789] = [CCAppleBrownLight24]::new()
        $this.ColorMap[790] = [CCAppleBrownLight24]::new()
        $this.ColorMap[791] = [CCAppleBrownLight24]::new()
        $this.ColorMap[792] = [CCAppleBrownLight24]::new()
        $this.ColorMap[793] = [CCAppleBrownLight24]::new()
        $this.ColorMap[794] = [CCAppleBrownLight24]::new()
        $this.ColorMap[795] = [CCAppleBrownLight24]::new()
        $this.ColorMap[796] = [CCAppleBrownLight24]::new()
        $this.ColorMap[797] = [CCAppleBrownLight24]::new()
        $this.ColorMap[798] = [CCAppleBrownLight24]::new()
        $this.ColorMap[799] = [CCAppleBrownLight24]::new()
        $this.ColorMap[800] = [CCAppleBrownLight24]::new()
        $this.ColorMap[801] = [CCAppleBrownLight24]::new()
        $this.ColorMap[802] = [CCAppleBrownLight24]::new()
        $this.ColorMap[803] = [CCAppleBrownLight24]::new()
        $this.ColorMap[804] = [CCAppleBrownLight24]::new()
        $this.ColorMap[805] = [CCAppleBrownLight24]::new()
        $this.ColorMap[806] = [CCAppleBrownLight24]::new()
        $this.ColorMap[807] = [CCAppleBrownLight24]::new()
        $this.ColorMap[808] = [CCAppleBrownLight24]::new()
        $this.ColorMap[809] = [CCAppleBrownLight24]::new()
        $this.ColorMap[810] = [CCAppleBrownLight24]::new()
        $this.ColorMap[811] = [CCAppleBrownLight24]::new()
        $this.ColorMap[812] = [CCAppleBrownLight24]::new()
        $this.ColorMap[813] = [CCAppleBrownLight24]::new()
        $this.ColorMap[814] = [CCAppleBrownLight24]::new()
        $this.ColorMap[815] = [CCAppleBrownLight24]::new() # End Row 16
        $this.ColorMap[816] = [CCAppleBrownLight24]::new()
        $this.ColorMap[817] = [CCAppleBrownLight24]::new()
        $this.ColorMap[818] = [CCAppleBrownLight24]::new()
        $this.ColorMap[819] = [CCAppleBrownLight24]::new()
        $this.ColorMap[820] = [CCAppleBrownLight24]::new()
        $this.ColorMap[821] = [CCAppleBrownLight24]::new()
        $this.ColorMap[822] = [CCAppleBrownLight24]::new()
        $this.ColorMap[823] = [CCAppleBrownLight24]::new()
        $this.ColorMap[824] = [CCAppleBrownLight24]::new()
        $this.ColorMap[825] = [CCAppleBrownLight24]::new()
        $this.ColorMap[826] = [CCAppleBrownLight24]::new()
        $this.ColorMap[827] = [CCAppleBrownLight24]::new()
        $this.ColorMap[828] = [CCAppleBrownLight24]::new()
        $this.ColorMap[829] = [CCAppleBrownLight24]::new()
        $this.ColorMap[830] = [CCAppleBrownLight24]::new()
        $this.ColorMap[831] = [CCAppleBrownLight24]::new()
        $this.ColorMap[832] = [CCAppleBrownLight24]::new()
        $this.ColorMap[833] = [CCAppleBrownLight24]::new()
        $this.ColorMap[834] = [CCAppleBrownLight24]::new()
        $this.ColorMap[835] = [CCAppleBrownLight24]::new()
        $this.ColorMap[836] = [CCAppleBrownLight24]::new()
        $this.ColorMap[837] = [CCAppleBrownLight24]::new()
        $this.ColorMap[838] = [CCAppleBrownLight24]::new()
        $this.ColorMap[839] = [CCAppleBrownLight24]::new()
        $this.ColorMap[840] = [CCAppleBrownLight24]::new()
        $this.ColorMap[841] = [CCAppleBrownLight24]::new()
        $this.ColorMap[842] = [CCAppleBrownLight24]::new()
        $this.ColorMap[843] = [CCAppleBrownLight24]::new()
        $this.ColorMap[844] = [CCAppleBrownLight24]::new()
        $this.ColorMap[845] = [CCAppleBrownLight24]::new()
        $this.ColorMap[846] = [CCAppleBrownLight24]::new()
        $this.ColorMap[847] = [CCAppleBrownLight24]::new()
        $this.ColorMap[848] = [CCAppleBrownLight24]::new()
        $this.ColorMap[849] = [CCAppleBrownLight24]::new()
        $this.ColorMap[850] = [CCAppleBrownLight24]::new()
        $this.ColorMap[851] = [CCAppleBrownLight24]::new()
        $this.ColorMap[852] = [CCAppleBrownLight24]::new()
        $this.ColorMap[853] = [CCAppleBrownLight24]::new()
        $this.ColorMap[854] = [CCAppleBrownLight24]::new()
        $this.ColorMap[855] = [CCAppleBrownLight24]::new()
        $this.ColorMap[856] = [CCAppleBrownLight24]::new()
        $this.ColorMap[857] = [CCAppleBrownLight24]::new()
        $this.ColorMap[858] = [CCAppleBrownLight24]::new()
        $this.ColorMap[859] = [CCAppleBrownLight24]::new()
        $this.ColorMap[860] = [CCAppleBrownLight24]::new()
        $this.ColorMap[861] = [CCAppleBrownLight24]::new()
        $this.ColorMap[862] = [CCAppleBrownLight24]::new()
        $this.ColorMap[863] = [CCAppleBrownLight24]::new() # End Row 17
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Finished filling the Color Map.')

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Calling CreateSceneImageATString.')
        $this.CreateSceneImageATString($this.ColorMap)
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Nulling the Color Map.')
        $this.ColorMap = $null
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }
}

Class SIFieldSouthRoad : SIInternalBase {
    SIFieldSouthRoad(): base() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entering the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Updating the Progress Bar for the Scene Image Progress.')
        Write-Progress -Activity 'Creating Scene Images      ' -Id 3 -Status 'Creating SIFieldSouthRoad' -PercentComplete -1
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Filling the Color Map.')
        $this.ColorMap[0]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[1]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[2]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[3]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[4]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[5]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[6]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[7]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[8]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[9]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[10]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[11]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[12]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[13]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[14]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[15]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[16]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[17]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[18]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[19]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[20]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[21]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[22]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[23]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[24]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[25]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[26]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[27]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[28]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[29]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[30]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[31]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[32]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[33]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[34]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[35]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[36]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[37]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[38]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[39]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[40]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[41]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[42]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[43]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[44]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[45]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[46]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[47]  = [CCAppleBlueLight24]::new() # End Row 0
        $this.ColorMap[48]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[49]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[50]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[51]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[52]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[53]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[54]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[55]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[56]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[57]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[58]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[59]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[60]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[61]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[62]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[63]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[64]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[65]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[66]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[67]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[68]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[69]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[70]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[71]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[72]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[73]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[74]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[75]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[76]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[77]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[78]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[79]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[80]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[81]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[82]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[83]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[84]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[85]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[86]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[87]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[88]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[89]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[90]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[91]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[92]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[93]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[94]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[95]  = [CCAppleBlueLight24]::new() # End Row 1
        $this.ColorMap[96]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[97]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[98]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[99]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[100] = [CCAppleBlueLight24]::new()
        $this.ColorMap[101] = [CCAppleBlueLight24]::new()
        $this.ColorMap[102] = [CCAppleBlueLight24]::new()
        $this.ColorMap[103] = [CCAppleBlueLight24]::new()
        $this.ColorMap[104] = [CCAppleBlueLight24]::new()
        $this.ColorMap[105] = [CCAppleBlueLight24]::new()
        $this.ColorMap[106] = [CCAppleBlueLight24]::new()
        $this.ColorMap[107] = [CCAppleBlueLight24]::new()
        $this.ColorMap[108] = [CCAppleBlueLight24]::new()
        $this.ColorMap[109] = [CCAppleBlueLight24]::new()
        $this.ColorMap[110] = [CCAppleBlueLight24]::new()
        $this.ColorMap[111] = [CCAppleBlueLight24]::new()
        $this.ColorMap[112] = [CCAppleBlueLight24]::new()
        $this.ColorMap[113] = [CCAppleBlueLight24]::new()
        $this.ColorMap[114] = [CCAppleBlueLight24]::new()
        $this.ColorMap[115] = [CCAppleBlueLight24]::new()
        $this.ColorMap[116] = [CCAppleBlueLight24]::new()
        $this.ColorMap[117] = [CCAppleBlueLight24]::new()
        $this.ColorMap[118] = [CCAppleBlueLight24]::new()
        $this.ColorMap[119] = [CCAppleBlueLight24]::new()
        $this.ColorMap[120] = [CCAppleBlueLight24]::new()
        $this.ColorMap[121] = [CCAppleBlueLight24]::new()
        $this.ColorMap[122] = [CCAppleBlueLight24]::new()
        $this.ColorMap[123] = [CCAppleBlueLight24]::new()
        $this.ColorMap[124] = [CCAppleBlueLight24]::new()
        $this.ColorMap[125] = [CCAppleBlueLight24]::new()
        $this.ColorMap[126] = [CCAppleBlueLight24]::new()
        $this.ColorMap[127] = [CCAppleBlueLight24]::new()
        $this.ColorMap[128] = [CCAppleBlueLight24]::new()
        $this.ColorMap[129] = [CCAppleBlueLight24]::new()
        $this.ColorMap[130] = [CCAppleBlueLight24]::new()
        $this.ColorMap[131] = [CCAppleBlueLight24]::new()
        $this.ColorMap[132] = [CCAppleBlueLight24]::new()
        $this.ColorMap[133] = [CCAppleBlueLight24]::new()
        $this.ColorMap[134] = [CCAppleBlueLight24]::new()
        $this.ColorMap[135] = [CCAppleBlueLight24]::new()
        $this.ColorMap[136] = [CCAppleBlueLight24]::new()
        $this.ColorMap[137] = [CCAppleBlueLight24]::new()
        $this.ColorMap[138] = [CCAppleBlueLight24]::new()
        $this.ColorMap[139] = [CCAppleBlueLight24]::new()
        $this.ColorMap[140] = [CCAppleBlueLight24]::new()
        $this.ColorMap[141] = [CCAppleBlueLight24]::new()
        $this.ColorMap[142] = [CCAppleBlueLight24]::new()
        $this.ColorMap[143] = [CCAppleBlueLight24]::new() # End Row 2
        $this.ColorMap[144] = [CCAppleBlueLight24]::new()
        $this.ColorMap[145] = [CCAppleBlueLight24]::new()
        $this.ColorMap[146] = [CCAppleBlueLight24]::new()
        $this.ColorMap[147] = [CCAppleBlueLight24]::new()
        $this.ColorMap[148] = [CCAppleBlueLight24]::new()
        $this.ColorMap[149] = [CCAppleBlueLight24]::new()
        $this.ColorMap[150] = [CCAppleBlueLight24]::new()
        $this.ColorMap[151] = [CCAppleBlueLight24]::new()
        $this.ColorMap[152] = [CCAppleBlueLight24]::new()
        $this.ColorMap[153] = [CCAppleBlueLight24]::new()
        $this.ColorMap[154] = [CCAppleBlueLight24]::new()
        $this.ColorMap[155] = [CCAppleBlueLight24]::new()
        $this.ColorMap[156] = [CCAppleBlueLight24]::new()
        $this.ColorMap[157] = [CCAppleBlueLight24]::new()
        $this.ColorMap[158] = [CCAppleBlueLight24]::new()
        $this.ColorMap[159] = [CCAppleBlueLight24]::new()
        $this.ColorMap[160] = [CCAppleBlueLight24]::new()
        $this.ColorMap[161] = [CCAppleBlueLight24]::new()
        $this.ColorMap[162] = [CCAppleBlueLight24]::new()
        $this.ColorMap[163] = [CCAppleBlueLight24]::new()
        $this.ColorMap[164] = [CCAppleBlueLight24]::new()
        $this.ColorMap[165] = [CCAppleBlueLight24]::new()
        $this.ColorMap[166] = [CCAppleBlueLight24]::new()
        $this.ColorMap[167] = [CCAppleBlueLight24]::new()
        $this.ColorMap[168] = [CCAppleBlueLight24]::new()
        $this.ColorMap[169] = [CCAppleBlueLight24]::new()
        $this.ColorMap[170] = [CCAppleBlueLight24]::new()
        $this.ColorMap[171] = [CCAppleBlueLight24]::new()
        $this.ColorMap[172] = [CCAppleBlueLight24]::new()
        $this.ColorMap[173] = [CCAppleBlueLight24]::new()
        $this.ColorMap[174] = [CCAppleBlueLight24]::new()
        $this.ColorMap[175] = [CCAppleBlueLight24]::new()
        $this.ColorMap[176] = [CCAppleBlueLight24]::new()
        $this.ColorMap[177] = [CCAppleBlueLight24]::new()
        $this.ColorMap[178] = [CCAppleBlueLight24]::new()
        $this.ColorMap[179] = [CCAppleBlueLight24]::new()
        $this.ColorMap[180] = [CCAppleBlueLight24]::new()
        $this.ColorMap[181] = [CCAppleBlueLight24]::new()
        $this.ColorMap[182] = [CCAppleBlueLight24]::new()
        $this.ColorMap[183] = [CCAppleBlueLight24]::new()
        $this.ColorMap[184] = [CCAppleBlueLight24]::new()
        $this.ColorMap[185] = [CCAppleBlueLight24]::new()
        $this.ColorMap[186] = [CCAppleBlueLight24]::new()
        $this.ColorMap[187] = [CCAppleBlueLight24]::new()
        $this.ColorMap[188] = [CCAppleBlueLight24]::new()
        $this.ColorMap[189] = [CCAppleBlueLight24]::new()
        $this.ColorMap[190] = [CCAppleBlueLight24]::new()
        $this.ColorMap[191] = [CCAppleBlueLight24]::new() # End Row 3
        $this.ColorMap[192] = [CCAppleBlueLight24]::new()
        $this.ColorMap[193] = [CCAppleBlueLight24]::new()
        $this.ColorMap[194] = [CCAppleBlueLight24]::new()
        $this.ColorMap[195] = [CCAppleBlueLight24]::new()
        $this.ColorMap[196] = [CCAppleBlueLight24]::new()
        $this.ColorMap[197] = [CCAppleBlueLight24]::new()
        $this.ColorMap[198] = [CCAppleBlueLight24]::new()
        $this.ColorMap[199] = [CCAppleBlueLight24]::new()
        $this.ColorMap[200] = [CCAppleBlueLight24]::new()
        $this.ColorMap[201] = [CCAppleBlueLight24]::new()
        $this.ColorMap[202] = [CCAppleBlueLight24]::new()
        $this.ColorMap[203] = [CCAppleBlueLight24]::new()
        $this.ColorMap[204] = [CCAppleBlueLight24]::new()
        $this.ColorMap[205] = [CCAppleBlueLight24]::new()
        $this.ColorMap[206] = [CCAppleBlueLight24]::new()
        $this.ColorMap[207] = [CCAppleBlueLight24]::new()
        $this.ColorMap[208] = [CCAppleBlueLight24]::new()
        $this.ColorMap[209] = [CCAppleBlueLight24]::new()
        $this.ColorMap[210] = [CCAppleBlueLight24]::new()
        $this.ColorMap[211] = [CCAppleBlueLight24]::new()
        $this.ColorMap[212] = [CCAppleBlueLight24]::new()
        $this.ColorMap[213] = [CCAppleBlueLight24]::new()
        $this.ColorMap[214] = [CCAppleBlueLight24]::new()
        $this.ColorMap[215] = [CCAppleBlueLight24]::new()
        $this.ColorMap[216] = [CCAppleBlueLight24]::new()
        $this.ColorMap[217] = [CCAppleBlueLight24]::new()
        $this.ColorMap[218] = [CCAppleBlueLight24]::new()
        $this.ColorMap[219] = [CCAppleBlueLight24]::new()
        $this.ColorMap[220] = [CCAppleBlueLight24]::new()
        $this.ColorMap[221] = [CCAppleBlueLight24]::new()
        $this.ColorMap[222] = [CCAppleBlueLight24]::new()
        $this.ColorMap[223] = [CCAppleBlueLight24]::new()
        $this.ColorMap[224] = [CCAppleBlueLight24]::new()
        $this.ColorMap[225] = [CCAppleBlueLight24]::new()
        $this.ColorMap[226] = [CCAppleBlueLight24]::new()
        $this.ColorMap[227] = [CCAppleBlueLight24]::new()
        $this.ColorMap[228] = [CCAppleBlueLight24]::new()
        $this.ColorMap[229] = [CCAppleBlueLight24]::new()
        $this.ColorMap[230] = [CCAppleBlueLight24]::new()
        $this.ColorMap[231] = [CCAppleBlueLight24]::new()
        $this.ColorMap[232] = [CCAppleBlueLight24]::new()
        $this.ColorMap[233] = [CCAppleBlueLight24]::new()
        $this.ColorMap[234] = [CCAppleBlueLight24]::new()
        $this.ColorMap[235] = [CCAppleBlueLight24]::new()
        $this.ColorMap[236] = [CCAppleBlueLight24]::new()
        $this.ColorMap[237] = [CCAppleBlueLight24]::new()
        $this.ColorMap[238] = [CCAppleBlueLight24]::new()
        $this.ColorMap[239] = [CCAppleBlueLight24]::new() # End Row 4
        $this.ColorMap[240] = [CCAppleGreenLight24]::new()
        $this.ColorMap[241] = [CCAppleGreenLight24]::new()
        $this.ColorMap[242] = [CCAppleGreenLight24]::new()
        $this.ColorMap[243] = [CCAppleGreenLight24]::new()
        $this.ColorMap[244] = [CCAppleGreenLight24]::new()
        $this.ColorMap[245] = [CCAppleGreenLight24]::new()
        $this.ColorMap[246] = [CCAppleGreenLight24]::new()
        $this.ColorMap[247] = [CCAppleGreenLight24]::new()
        $this.ColorMap[248] = [CCAppleGreenLight24]::new()
        $this.ColorMap[249] = [CCAppleGreenLight24]::new()
        $this.ColorMap[250] = [CCAppleGreenLight24]::new()
        $this.ColorMap[251] = [CCAppleGreenLight24]::new()
        $this.ColorMap[252] = [CCAppleGreenLight24]::new()
        $this.ColorMap[253] = [CCAppleGreenLight24]::new()
        $this.ColorMap[254] = [CCAppleGreenLight24]::new()
        $this.ColorMap[255] = [CCAppleGreenLight24]::new()
        $this.ColorMap[256] = [CCAppleGreenLight24]::new()
        $this.ColorMap[257] = [CCAppleGreenLight24]::new()
        $this.ColorMap[258] = [CCAppleGreenLight24]::new()
        $this.ColorMap[259] = [CCAppleGreenLight24]::new()
        $this.ColorMap[260] = [CCAppleGreenLight24]::new()
        $this.ColorMap[261] = [CCAppleGreenLight24]::new()
        $this.ColorMap[262] = [CCAppleGreenLight24]::new()
        $this.ColorMap[263] = [CCAppleGreenLight24]::new()
        $this.ColorMap[264] = [CCAppleGreenLight24]::new()
        $this.ColorMap[265] = [CCAppleGreenLight24]::new()
        $this.ColorMap[266] = [CCAppleGreenLight24]::new()
        $this.ColorMap[267] = [CCAppleGreenLight24]::new()
        $this.ColorMap[268] = [CCAppleGreenLight24]::new()
        $this.ColorMap[269] = [CCAppleGreenLight24]::new()
        $this.ColorMap[270] = [CCAppleGreenLight24]::new()
        $this.ColorMap[271] = [CCAppleGreenLight24]::new()
        $this.ColorMap[272] = [CCAppleGreenLight24]::new()
        $this.ColorMap[273] = [CCAppleGreenLight24]::new()
        $this.ColorMap[274] = [CCAppleGreenLight24]::new()
        $this.ColorMap[275] = [CCAppleGreenLight24]::new()
        $this.ColorMap[276] = [CCAppleGreenLight24]::new()
        $this.ColorMap[277] = [CCAppleGreenLight24]::new()
        $this.ColorMap[278] = [CCAppleGreenLight24]::new()
        $this.ColorMap[279] = [CCAppleGreenLight24]::new()
        $this.ColorMap[280] = [CCAppleGreenLight24]::new()
        $this.ColorMap[281] = [CCAppleGreenLight24]::new()
        $this.ColorMap[282] = [CCAppleGreenLight24]::new()
        $this.ColorMap[283] = [CCAppleGreenLight24]::new()
        $this.ColorMap[284] = [CCAppleGreenLight24]::new()
        $this.ColorMap[285] = [CCAppleGreenLight24]::new()
        $this.ColorMap[286] = [CCAppleGreenLight24]::new()
        $this.ColorMap[287] = [CCAppleGreenLight24]::new() # End Row 5
        $this.ColorMap[288] = [CCAppleGreenLight24]::new()
        $this.ColorMap[289] = [CCAppleGreenLight24]::new()
        $this.ColorMap[290] = [CCAppleGreenLight24]::new()
        $this.ColorMap[291] = [CCAppleGreenLight24]::new()
        $this.ColorMap[292] = [CCAppleGreenLight24]::new()
        $this.ColorMap[293] = [CCAppleGreenLight24]::new()
        $this.ColorMap[294] = [CCAppleGreenLight24]::new()
        $this.ColorMap[295] = [CCAppleGreenLight24]::new()
        $this.ColorMap[296] = [CCAppleGreenLight24]::new()
        $this.ColorMap[297] = [CCAppleGreenLight24]::new()
        $this.ColorMap[298] = [CCAppleGreenLight24]::new()
        $this.ColorMap[299] = [CCAppleGreenLight24]::new()
        $this.ColorMap[300] = [CCAppleGreenLight24]::new()
        $this.ColorMap[301] = [CCAppleGreenLight24]::new()
        $this.ColorMap[302] = [CCAppleGreenLight24]::new()
        $this.ColorMap[303] = [CCAppleGreenLight24]::new()
        $this.ColorMap[304] = [CCAppleGreenLight24]::new()
        $this.ColorMap[305] = [CCAppleGreenLight24]::new()
        $this.ColorMap[306] = [CCAppleGreenLight24]::new()
        $this.ColorMap[307] = [CCAppleGreenLight24]::new()
        $this.ColorMap[308] = [CCAppleGreenLight24]::new()
        $this.ColorMap[309] = [CCAppleGreenLight24]::new()
        $this.ColorMap[310] = [CCAppleGreenLight24]::new()
        $this.ColorMap[311] = [CCAppleGreenLight24]::new()
        $this.ColorMap[312] = [CCAppleGreenLight24]::new()
        $this.ColorMap[313] = [CCAppleGreenLight24]::new()
        $this.ColorMap[314] = [CCAppleGreenLight24]::new()
        $this.ColorMap[315] = [CCAppleGreenLight24]::new()
        $this.ColorMap[316] = [CCAppleGreenLight24]::new()
        $this.ColorMap[317] = [CCAppleGreenLight24]::new()
        $this.ColorMap[318] = [CCAppleGreenLight24]::new()
        $this.ColorMap[319] = [CCAppleGreenLight24]::new()
        $this.ColorMap[320] = [CCAppleGreenLight24]::new()
        $this.ColorMap[321] = [CCAppleGreenLight24]::new()
        $this.ColorMap[322] = [CCAppleGreenLight24]::new()
        $this.ColorMap[323] = [CCAppleGreenLight24]::new()
        $this.ColorMap[324] = [CCAppleGreenLight24]::new()
        $this.ColorMap[325] = [CCAppleGreenLight24]::new()
        $this.ColorMap[326] = [CCAppleGreenLight24]::new()
        $this.ColorMap[327] = [CCAppleGreenLight24]::new()
        $this.ColorMap[328] = [CCAppleGreenLight24]::new()
        $this.ColorMap[329] = [CCAppleGreenLight24]::new()
        $this.ColorMap[330] = [CCAppleGreenLight24]::new()
        $this.ColorMap[331] = [CCAppleGreenLight24]::new()
        $this.ColorMap[332] = [CCAppleGreenLight24]::new()
        $this.ColorMap[333] = [CCAppleGreenLight24]::new()
        $this.ColorMap[334] = [CCAppleGreenLight24]::new()
        $this.ColorMap[335] = [CCAppleGreenLight24]::new() # End Row 6
        $this.ColorMap[336] = [CCAppleGreenLight24]::new()
        $this.ColorMap[337] = [CCAppleGreenLight24]::new()
        $this.ColorMap[338] = [CCAppleGreenLight24]::new()
        $this.ColorMap[339] = [CCAppleGreenLight24]::new()
        $this.ColorMap[340] = [CCAppleGreenLight24]::new()
        $this.ColorMap[341] = [CCAppleGreenLight24]::new()
        $this.ColorMap[342] = [CCAppleGreenLight24]::new()
        $this.ColorMap[343] = [CCAppleGreenLight24]::new()
        $this.ColorMap[344] = [CCAppleGreenLight24]::new()
        $this.ColorMap[345] = [CCAppleGreenLight24]::new()
        $this.ColorMap[346] = [CCAppleGreenLight24]::new()
        $this.ColorMap[347] = [CCAppleGreenLight24]::new()
        $this.ColorMap[348] = [CCAppleGreenLight24]::new()
        $this.ColorMap[349] = [CCAppleGreenLight24]::new()
        $this.ColorMap[350] = [CCAppleGreenLight24]::new()
        $this.ColorMap[351] = [CCAppleGreenLight24]::new()
        $this.ColorMap[352] = [CCAppleGreenLight24]::new()
        $this.ColorMap[353] = [CCAppleGreenLight24]::new()
        $this.ColorMap[354] = [CCAppleGreenLight24]::new()
        $this.ColorMap[355] = [CCAppleGreenLight24]::new()
        $this.ColorMap[356] = [CCAppleGreenLight24]::new()
        $this.ColorMap[357] = [CCAppleGreenLight24]::new()
        $this.ColorMap[358] = [CCAppleGreenLight24]::new()
        $this.ColorMap[359] = [CCAppleGreenLight24]::new()
        $this.ColorMap[360] = [CCAppleGreenLight24]::new()
        $this.ColorMap[361] = [CCAppleGreenLight24]::new()
        $this.ColorMap[362] = [CCAppleGreenLight24]::new()
        $this.ColorMap[363] = [CCAppleGreenLight24]::new()
        $this.ColorMap[364] = [CCAppleGreenLight24]::new()
        $this.ColorMap[365] = [CCAppleGreenLight24]::new()
        $this.ColorMap[366] = [CCAppleGreenLight24]::new()
        $this.ColorMap[367] = [CCAppleGreenLight24]::new()
        $this.ColorMap[368] = [CCAppleGreenLight24]::new()
        $this.ColorMap[369] = [CCAppleGreenLight24]::new()
        $this.ColorMap[370] = [CCAppleGreenLight24]::new()
        $this.ColorMap[371] = [CCAppleGreenLight24]::new()
        $this.ColorMap[372] = [CCAppleGreenLight24]::new()
        $this.ColorMap[373] = [CCAppleGreenLight24]::new()
        $this.ColorMap[374] = [CCAppleGreenLight24]::new()
        $this.ColorMap[375] = [CCAppleGreenLight24]::new()
        $this.ColorMap[376] = [CCAppleGreenLight24]::new()
        $this.ColorMap[377] = [CCAppleGreenLight24]::new()
        $this.ColorMap[378] = [CCAppleGreenLight24]::new()
        $this.ColorMap[379] = [CCAppleGreenLight24]::new()
        $this.ColorMap[380] = [CCAppleGreenLight24]::new()
        $this.ColorMap[381] = [CCAppleGreenLight24]::new()
        $this.ColorMap[382] = [CCAppleGreenLight24]::new()
        $this.ColorMap[383] = [CCAppleGreenLight24]::new() # End Row 7
        $this.ColorMap[384] = [CCAppleGreenLight24]::new()
        $this.ColorMap[385] = [CCAppleGreenLight24]::new()
        $this.ColorMap[386] = [CCAppleGreenLight24]::new()
        $this.ColorMap[387] = [CCAppleGreenLight24]::new()
        $this.ColorMap[388] = [CCAppleGreenLight24]::new()
        $this.ColorMap[389] = [CCAppleGreenLight24]::new()
        $this.ColorMap[390] = [CCAppleGreenLight24]::new()
        $this.ColorMap[391] = [CCAppleGreenLight24]::new()
        $this.ColorMap[392] = [CCAppleGreenLight24]::new()
        $this.ColorMap[393] = [CCAppleGreenLight24]::new()
        $this.ColorMap[394] = [CCAppleGreenLight24]::new()
        $this.ColorMap[395] = [CCAppleGreenLight24]::new()
        $this.ColorMap[396] = [CCAppleGreenLight24]::new()
        $this.ColorMap[397] = [CCAppleGreenLight24]::new()
        $this.ColorMap[398] = [CCAppleGreenLight24]::new()
        $this.ColorMap[399] = [CCAppleGreenLight24]::new()
        $this.ColorMap[400] = [CCAppleGreenLight24]::new()
        $this.ColorMap[401] = [CCAppleGreenLight24]::new()
        $this.ColorMap[402] = [CCAppleGreenLight24]::new()
        $this.ColorMap[403] = [CCAppleGreenLight24]::new()
        $this.ColorMap[404] = [CCAppleGreenLight24]::new()
        $this.ColorMap[405] = [CCAppleGreenLight24]::new()
        $this.ColorMap[406] = [CCAppleBrownLight24]::new()
        $this.ColorMap[407] = [CCAppleBrownLight24]::new()
        $this.ColorMap[408] = [CCAppleBrownLight24]::new()
        $this.ColorMap[409] = [CCAppleBrownLight24]::new()
        $this.ColorMap[410] = [CCAppleBrownLight24]::new()
        $this.ColorMap[411] = [CCAppleGreenLight24]::new()
        $this.ColorMap[412] = [CCAppleGreenLight24]::new()
        $this.ColorMap[413] = [CCAppleGreenLight24]::new()
        $this.ColorMap[414] = [CCAppleGreenLight24]::new()
        $this.ColorMap[415] = [CCAppleGreenLight24]::new()
        $this.ColorMap[416] = [CCAppleGreenLight24]::new()
        $this.ColorMap[417] = [CCAppleGreenLight24]::new()
        $this.ColorMap[418] = [CCAppleGreenLight24]::new()
        $this.ColorMap[419] = [CCAppleGreenLight24]::new()
        $this.ColorMap[420] = [CCAppleGreenLight24]::new()
        $this.ColorMap[421] = [CCAppleGreenLight24]::new()
        $this.ColorMap[422] = [CCAppleGreenLight24]::new()
        $this.ColorMap[423] = [CCAppleGreenLight24]::new()
        $this.ColorMap[424] = [CCAppleGreenLight24]::new()
        $this.ColorMap[425] = [CCAppleGreenLight24]::new()
        $this.ColorMap[426] = [CCAppleGreenLight24]::new()
        $this.ColorMap[427] = [CCAppleGreenLight24]::new()
        $this.ColorMap[428] = [CCAppleGreenLight24]::new()
        $this.ColorMap[429] = [CCAppleGreenLight24]::new()
        $this.ColorMap[430] = [CCAppleGreenLight24]::new()
        $this.ColorMap[431] = [CCAppleGreenLight24]::new() # End Row 8
        $this.ColorMap[432] = [CCAppleGreenLight24]::new()
        $this.ColorMap[433] = [CCAppleGreenLight24]::new()
        $this.ColorMap[434] = [CCAppleGreenLight24]::new()
        $this.ColorMap[435] = [CCAppleGreenLight24]::new()
        $this.ColorMap[436] = [CCAppleGreenLight24]::new()
        $this.ColorMap[437] = [CCAppleGreenLight24]::new()
        $this.ColorMap[438] = [CCAppleGreenLight24]::new()
        $this.ColorMap[439] = [CCAppleGreenLight24]::new()
        $this.ColorMap[440] = [CCAppleGreenLight24]::new()
        $this.ColorMap[441] = [CCAppleGreenLight24]::new()
        $this.ColorMap[442] = [CCAppleGreenLight24]::new()
        $this.ColorMap[443] = [CCAppleGreenLight24]::new()
        $this.ColorMap[444] = [CCAppleGreenLight24]::new()
        $this.ColorMap[445] = [CCAppleGreenLight24]::new()
        $this.ColorMap[446] = [CCAppleGreenLight24]::new()
        $this.ColorMap[447] = [CCAppleGreenLight24]::new()
        $this.ColorMap[448] = [CCAppleGreenLight24]::new()
        $this.ColorMap[449] = [CCAppleGreenLight24]::new()
        $this.ColorMap[450] = [CCAppleGreenLight24]::new()
        $this.ColorMap[451] = [CCAppleGreenLight24]::new()
        $this.ColorMap[452] = [CCAppleGreenLight24]::new()
        $this.ColorMap[453] = [CCAppleGreenLight24]::new()
        $this.ColorMap[454] = [CCAppleBrownLight24]::new()
        $this.ColorMap[455] = [CCAppleBrownLight24]::new()
        $this.ColorMap[456] = [CCAppleBrownLight24]::new()
        $this.ColorMap[457] = [CCAppleBrownLight24]::new()
        $this.ColorMap[458] = [CCAppleBrownLight24]::new()
        $this.ColorMap[459] = [CCAppleGreenLight24]::new()
        $this.ColorMap[460] = [CCAppleGreenLight24]::new()
        $this.ColorMap[461] = [CCAppleGreenLight24]::new()
        $this.ColorMap[462] = [CCAppleGreenLight24]::new()
        $this.ColorMap[463] = [CCAppleGreenLight24]::new()
        $this.ColorMap[464] = [CCAppleGreenLight24]::new()
        $this.ColorMap[465] = [CCAppleGreenLight24]::new()
        $this.ColorMap[466] = [CCAppleGreenLight24]::new()
        $this.ColorMap[467] = [CCAppleGreenLight24]::new()
        $this.ColorMap[468] = [CCAppleGreenLight24]::new()
        $this.ColorMap[469] = [CCAppleGreenLight24]::new()
        $this.ColorMap[470] = [CCAppleGreenLight24]::new()
        $this.ColorMap[471] = [CCAppleGreenLight24]::new()
        $this.ColorMap[472] = [CCAppleGreenLight24]::new()
        $this.ColorMap[473] = [CCAppleGreenLight24]::new()
        $this.ColorMap[474] = [CCAppleGreenLight24]::new()
        $this.ColorMap[475] = [CCAppleGreenLight24]::new()
        $this.ColorMap[476] = [CCAppleGreenLight24]::new()
        $this.ColorMap[477] = [CCAppleGreenLight24]::new()
        $this.ColorMap[478] = [CCAppleGreenLight24]::new()
        $this.ColorMap[479] = [CCAppleGreenLight24]::new() # End Row 9
        $this.ColorMap[480] = [CCAppleGreenLight24]::new()
        $this.ColorMap[481] = [CCAppleGreenLight24]::new()
        $this.ColorMap[482] = [CCAppleGreenLight24]::new()
        $this.ColorMap[483] = [CCAppleGreenLight24]::new()
        $this.ColorMap[484] = [CCAppleGreenLight24]::new()
        $this.ColorMap[485] = [CCAppleGreenLight24]::new()
        $this.ColorMap[486] = [CCAppleGreenLight24]::new()
        $this.ColorMap[487] = [CCAppleGreenLight24]::new()
        $this.ColorMap[488] = [CCAppleGreenLight24]::new()
        $this.ColorMap[489] = [CCAppleGreenLight24]::new()
        $this.ColorMap[490] = [CCAppleGreenLight24]::new()
        $this.ColorMap[491] = [CCAppleGreenLight24]::new()
        $this.ColorMap[492] = [CCAppleGreenLight24]::new()
        $this.ColorMap[493] = [CCAppleGreenLight24]::new()
        $this.ColorMap[494] = [CCAppleGreenLight24]::new()
        $this.ColorMap[495] = [CCAppleGreenLight24]::new()
        $this.ColorMap[496] = [CCAppleGreenLight24]::new()
        $this.ColorMap[497] = [CCAppleGreenLight24]::new()
        $this.ColorMap[498] = [CCAppleGreenLight24]::new()
        $this.ColorMap[499] = [CCAppleGreenLight24]::new()
        $this.ColorMap[500] = [CCAppleGreenLight24]::new()
        $this.ColorMap[501] = [CCAppleBrownLight24]::new()
        $this.ColorMap[502] = [CCAppleBrownLight24]::new()
        $this.ColorMap[503] = [CCAppleBrownLight24]::new()
        $this.ColorMap[504] = [CCAppleBrownLight24]::new()
        $this.ColorMap[505] = [CCAppleBrownLight24]::new()
        $this.ColorMap[506] = [CCAppleBrownLight24]::new()
        $this.ColorMap[507] = [CCAppleBrownLight24]::new()
        $this.ColorMap[508] = [CCAppleGreenLight24]::new()
        $this.ColorMap[509] = [CCAppleGreenLight24]::new()
        $this.ColorMap[510] = [CCAppleGreenLight24]::new()
        $this.ColorMap[511] = [CCAppleGreenLight24]::new()
        $this.ColorMap[512] = [CCAppleGreenLight24]::new()
        $this.ColorMap[513] = [CCAppleGreenLight24]::new()
        $this.ColorMap[514] = [CCAppleGreenLight24]::new()
        $this.ColorMap[515] = [CCAppleGreenLight24]::new()
        $this.ColorMap[516] = [CCAppleGreenLight24]::new()
        $this.ColorMap[517] = [CCAppleGreenLight24]::new()
        $this.ColorMap[518] = [CCAppleGreenLight24]::new()
        $this.ColorMap[519] = [CCAppleGreenLight24]::new()
        $this.ColorMap[520] = [CCAppleGreenLight24]::new()
        $this.ColorMap[521] = [CCAppleGreenLight24]::new()
        $this.ColorMap[522] = [CCAppleGreenLight24]::new()
        $this.ColorMap[523] = [CCAppleGreenLight24]::new()
        $this.ColorMap[524] = [CCAppleGreenLight24]::new()
        $this.ColorMap[525] = [CCAppleGreenLight24]::new()
        $this.ColorMap[526] = [CCAppleGreenLight24]::new()
        $this.ColorMap[527] = [CCAppleGreenLight24]::new() # End Row 10
        $this.ColorMap[528] = [CCAppleGreenLight24]::new()
        $this.ColorMap[529] = [CCAppleGreenLight24]::new()
        $this.ColorMap[530] = [CCAppleGreenLight24]::new()
        $this.ColorMap[531] = [CCAppleGreenLight24]::new()
        $this.ColorMap[532] = [CCAppleGreenLight24]::new()
        $this.ColorMap[533] = [CCAppleGreenLight24]::new()
        $this.ColorMap[534] = [CCAppleGreenLight24]::new()
        $this.ColorMap[535] = [CCAppleGreenLight24]::new()
        $this.ColorMap[536] = [CCAppleGreenLight24]::new()
        $this.ColorMap[537] = [CCAppleGreenLight24]::new()
        $this.ColorMap[538] = [CCAppleGreenLight24]::new()
        $this.ColorMap[539] = [CCAppleGreenLight24]::new()
        $this.ColorMap[540] = [CCAppleGreenLight24]::new()
        $this.ColorMap[541] = [CCAppleGreenLight24]::new()
        $this.ColorMap[542] = [CCAppleGreenLight24]::new()
        $this.ColorMap[543] = [CCAppleGreenLight24]::new()
        $this.ColorMap[544] = [CCAppleGreenLight24]::new()
        $this.ColorMap[545] = [CCAppleGreenLight24]::new()
        $this.ColorMap[546] = [CCAppleGreenLight24]::new()
        $this.ColorMap[547] = [CCAppleGreenLight24]::new()
        $this.ColorMap[548] = [CCAppleGreenLight24]::new()
        $this.ColorMap[549] = [CCAppleBrownLight24]::new()
        $this.ColorMap[550] = [CCAppleBrownLight24]::new()
        $this.ColorMap[551] = [CCAppleBrownLight24]::new()
        $this.ColorMap[552] = [CCAppleBrownLight24]::new()
        $this.ColorMap[553] = [CCAppleBrownLight24]::new()
        $this.ColorMap[554] = [CCAppleBrownLight24]::new()
        $this.ColorMap[555] = [CCAppleBrownLight24]::new()
        $this.ColorMap[556] = [CCAppleGreenLight24]::new()
        $this.ColorMap[557] = [CCAppleGreenLight24]::new()
        $this.ColorMap[558] = [CCAppleGreenLight24]::new()
        $this.ColorMap[559] = [CCAppleGreenLight24]::new()
        $this.ColorMap[560] = [CCAppleGreenLight24]::new()
        $this.ColorMap[561] = [CCAppleGreenLight24]::new()
        $this.ColorMap[562] = [CCAppleGreenLight24]::new()
        $this.ColorMap[563] = [CCAppleGreenLight24]::new()
        $this.ColorMap[564] = [CCAppleGreenLight24]::new()
        $this.ColorMap[565] = [CCAppleGreenLight24]::new()
        $this.ColorMap[566] = [CCAppleGreenLight24]::new()
        $this.ColorMap[567] = [CCAppleGreenLight24]::new()
        $this.ColorMap[568] = [CCAppleGreenLight24]::new()
        $this.ColorMap[569] = [CCAppleGreenLight24]::new()
        $this.ColorMap[570] = [CCAppleGreenLight24]::new()
        $this.ColorMap[571] = [CCAppleGreenLight24]::new()
        $this.ColorMap[572] = [CCAppleGreenLight24]::new()
        $this.ColorMap[573] = [CCAppleGreenLight24]::new()
        $this.ColorMap[574] = [CCAppleGreenLight24]::new()
        $this.ColorMap[575] = [CCAppleGreenLight24]::new() # End Row 11
        $this.ColorMap[576] = [CCAppleGreenLight24]::new()
        $this.ColorMap[577] = [CCAppleGreenLight24]::new()
        $this.ColorMap[578] = [CCAppleGreenLight24]::new()
        $this.ColorMap[579] = [CCAppleGreenLight24]::new()
        $this.ColorMap[580] = [CCAppleGreenLight24]::new()
        $this.ColorMap[581] = [CCAppleGreenLight24]::new()
        $this.ColorMap[582] = [CCAppleGreenLight24]::new()
        $this.ColorMap[583] = [CCAppleGreenLight24]::new()
        $this.ColorMap[584] = [CCAppleGreenLight24]::new()
        $this.ColorMap[585] = [CCAppleGreenLight24]::new()
        $this.ColorMap[586] = [CCAppleGreenLight24]::new()
        $this.ColorMap[587] = [CCAppleGreenLight24]::new()
        $this.ColorMap[588] = [CCAppleGreenLight24]::new()
        $this.ColorMap[589] = [CCAppleGreenLight24]::new()
        $this.ColorMap[590] = [CCAppleGreenLight24]::new()
        $this.ColorMap[591] = [CCAppleGreenLight24]::new()
        $this.ColorMap[592] = [CCAppleGreenLight24]::new()
        $this.ColorMap[593] = [CCAppleGreenLight24]::new()
        $this.ColorMap[594] = [CCAppleGreenLight24]::new()
        $this.ColorMap[595] = [CCAppleGreenLight24]::new()
        $this.ColorMap[596] = [CCAppleGreenLight24]::new()
        $this.ColorMap[597] = [CCAppleBrownLight24]::new()
        $this.ColorMap[598] = [CCAppleBrownLight24]::new()
        $this.ColorMap[599] = [CCAppleBrownLight24]::new()
        $this.ColorMap[600] = [CCAppleBrownLight24]::new()
        $this.ColorMap[601] = [CCAppleBrownLight24]::new()
        $this.ColorMap[602] = [CCAppleBrownLight24]::new()
        $this.ColorMap[603] = [CCAppleBrownLight24]::new()
        $this.ColorMap[604] = [CCAppleGreenLight24]::new()
        $this.ColorMap[605] = [CCAppleGreenLight24]::new()
        $this.ColorMap[606] = [CCAppleGreenLight24]::new()
        $this.ColorMap[607] = [CCAppleGreenLight24]::new()
        $this.ColorMap[608] = [CCAppleGreenLight24]::new()
        $this.ColorMap[609] = [CCAppleGreenLight24]::new()
        $this.ColorMap[610] = [CCAppleGreenLight24]::new()
        $this.ColorMap[611] = [CCAppleGreenLight24]::new()
        $this.ColorMap[612] = [CCAppleGreenLight24]::new()
        $this.ColorMap[613] = [CCAppleGreenLight24]::new()
        $this.ColorMap[614] = [CCAppleGreenLight24]::new()
        $this.ColorMap[615] = [CCAppleGreenLight24]::new()
        $this.ColorMap[616] = [CCAppleGreenLight24]::new()
        $this.ColorMap[617] = [CCAppleGreenLight24]::new()
        $this.ColorMap[618] = [CCAppleGreenLight24]::new()
        $this.ColorMap[619] = [CCAppleGreenLight24]::new()
        $this.ColorMap[620] = [CCAppleGreenLight24]::new()
        $this.ColorMap[621] = [CCAppleGreenLight24]::new()
        $this.ColorMap[622] = [CCAppleGreenLight24]::new()
        $this.ColorMap[623] = [CCAppleGreenLight24]::new() # End Row 12
        $this.ColorMap[624] = [CCAppleGreenLight24]::new()
        $this.ColorMap[625] = [CCAppleGreenLight24]::new()
        $this.ColorMap[626] = [CCAppleGreenLight24]::new()
        $this.ColorMap[627] = [CCAppleGreenLight24]::new()
        $this.ColorMap[628] = [CCAppleGreenLight24]::new()
        $this.ColorMap[629] = [CCAppleGreenLight24]::new()
        $this.ColorMap[630] = [CCAppleGreenLight24]::new()
        $this.ColorMap[631] = [CCAppleGreenLight24]::new()
        $this.ColorMap[632] = [CCAppleGreenLight24]::new()
        $this.ColorMap[633] = [CCAppleGreenLight24]::new()
        $this.ColorMap[634] = [CCAppleGreenLight24]::new()
        $this.ColorMap[635] = [CCAppleGreenLight24]::new()
        $this.ColorMap[636] = [CCAppleGreenLight24]::new()
        $this.ColorMap[637] = [CCAppleGreenLight24]::new()
        $this.ColorMap[638] = [CCAppleGreenLight24]::new()
        $this.ColorMap[639] = [CCAppleGreenLight24]::new()
        $this.ColorMap[640] = [CCAppleGreenLight24]::new()
        $this.ColorMap[641] = [CCAppleGreenLight24]::new()
        $this.ColorMap[642] = [CCAppleGreenLight24]::new()
        $this.ColorMap[643] = [CCAppleGreenLight24]::new()
        $this.ColorMap[644] = [CCAppleGreenLight24]::new()
        $this.ColorMap[645] = [CCAppleBrownLight24]::new()
        $this.ColorMap[646] = [CCAppleBrownLight24]::new()
        $this.ColorMap[647] = [CCAppleBrownLight24]::new()
        $this.ColorMap[648] = [CCAppleBrownLight24]::new()
        $this.ColorMap[649] = [CCAppleBrownLight24]::new()
        $this.ColorMap[650] = [CCAppleBrownLight24]::new()
        $this.ColorMap[651] = [CCAppleBrownLight24]::new()
        $this.ColorMap[652] = [CCAppleGreenLight24]::new()
        $this.ColorMap[653] = [CCAppleGreenLight24]::new()
        $this.ColorMap[654] = [CCAppleGreenLight24]::new()
        $this.ColorMap[655] = [CCAppleGreenLight24]::new()
        $this.ColorMap[656] = [CCAppleGreenLight24]::new()
        $this.ColorMap[657] = [CCAppleGreenLight24]::new()
        $this.ColorMap[658] = [CCAppleGreenLight24]::new()
        $this.ColorMap[659] = [CCAppleGreenLight24]::new()
        $this.ColorMap[660] = [CCAppleGreenLight24]::new()
        $this.ColorMap[661] = [CCAppleGreenLight24]::new()
        $this.ColorMap[662] = [CCAppleGreenLight24]::new()
        $this.ColorMap[663] = [CCAppleGreenLight24]::new()
        $this.ColorMap[664] = [CCAppleGreenLight24]::new()
        $this.ColorMap[665] = [CCAppleGreenLight24]::new()
        $this.ColorMap[666] = [CCAppleGreenLight24]::new()
        $this.ColorMap[667] = [CCAppleGreenLight24]::new()
        $this.ColorMap[668] = [CCAppleGreenLight24]::new()
        $this.ColorMap[669] = [CCAppleGreenLight24]::new()
        $this.ColorMap[670] = [CCAppleGreenLight24]::new()
        $this.ColorMap[671] = [CCAppleGreenLight24]::new() # End Row 13
        $this.ColorMap[672] = [CCAppleGreenLight24]::new()
        $this.ColorMap[673] = [CCAppleGreenLight24]::new()
        $this.ColorMap[674] = [CCAppleGreenLight24]::new()
        $this.ColorMap[675] = [CCAppleGreenLight24]::new()
        $this.ColorMap[676] = [CCAppleGreenLight24]::new()
        $this.ColorMap[677] = [CCAppleGreenLight24]::new()
        $this.ColorMap[678] = [CCAppleGreenLight24]::new()
        $this.ColorMap[679] = [CCAppleGreenLight24]::new()
        $this.ColorMap[680] = [CCAppleGreenLight24]::new()
        $this.ColorMap[681] = [CCAppleGreenLight24]::new()
        $this.ColorMap[682] = [CCAppleGreenLight24]::new()
        $this.ColorMap[683] = [CCAppleGreenLight24]::new()
        $this.ColorMap[684] = [CCAppleGreenLight24]::new()
        $this.ColorMap[685] = [CCAppleGreenLight24]::new()
        $this.ColorMap[686] = [CCAppleGreenLight24]::new()
        $this.ColorMap[687] = [CCAppleGreenLight24]::new()
        $this.ColorMap[688] = [CCAppleGreenLight24]::new()
        $this.ColorMap[689] = [CCAppleGreenLight24]::new()
        $this.ColorMap[690] = [CCAppleGreenLight24]::new()
        $this.ColorMap[691] = [CCAppleGreenLight24]::new()
        $this.ColorMap[692] = [CCAppleGreenLight24]::new()
        $this.ColorMap[693] = [CCAppleBrownLight24]::new()
        $this.ColorMap[694] = [CCAppleBrownLight24]::new()
        $this.ColorMap[695] = [CCAppleBrownLight24]::new()
        $this.ColorMap[696] = [CCAppleBrownLight24]::new()
        $this.ColorMap[697] = [CCAppleBrownLight24]::new()
        $this.ColorMap[698] = [CCAppleBrownLight24]::new()
        $this.ColorMap[699] = [CCAppleBrownLight24]::new()
        $this.ColorMap[700] = [CCAppleGreenLight24]::new()
        $this.ColorMap[701] = [CCAppleGreenLight24]::new()
        $this.ColorMap[702] = [CCAppleGreenLight24]::new()
        $this.ColorMap[703] = [CCAppleGreenLight24]::new()
        $this.ColorMap[704] = [CCAppleGreenLight24]::new()
        $this.ColorMap[705] = [CCAppleGreenLight24]::new()
        $this.ColorMap[706] = [CCAppleGreenLight24]::new()
        $this.ColorMap[707] = [CCAppleGreenLight24]::new()
        $this.ColorMap[708] = [CCAppleGreenLight24]::new()
        $this.ColorMap[709] = [CCAppleGreenLight24]::new()
        $this.ColorMap[710] = [CCAppleGreenLight24]::new()
        $this.ColorMap[711] = [CCAppleGreenLight24]::new()
        $this.ColorMap[712] = [CCAppleGreenLight24]::new()
        $this.ColorMap[713] = [CCAppleGreenLight24]::new()
        $this.ColorMap[714] = [CCAppleGreenLight24]::new()
        $this.ColorMap[715] = [CCAppleGreenLight24]::new()
        $this.ColorMap[716] = [CCAppleGreenLight24]::new()
        $this.ColorMap[717] = [CCAppleGreenLight24]::new()
        $this.ColorMap[718] = [CCAppleGreenLight24]::new()
        $this.ColorMap[719] = [CCAppleGreenLight24]::new() # End Row 14
        $this.ColorMap[720] = [CCAppleGreenLight24]::new()
        $this.ColorMap[721] = [CCAppleGreenLight24]::new()
        $this.ColorMap[722] = [CCAppleGreenLight24]::new()
        $this.ColorMap[723] = [CCAppleGreenLight24]::new()
        $this.ColorMap[724] = [CCAppleGreenLight24]::new()
        $this.ColorMap[725] = [CCAppleGreenLight24]::new()
        $this.ColorMap[726] = [CCAppleGreenLight24]::new()
        $this.ColorMap[727] = [CCAppleGreenLight24]::new()
        $this.ColorMap[728] = [CCAppleGreenLight24]::new()
        $this.ColorMap[729] = [CCAppleGreenLight24]::new()
        $this.ColorMap[730] = [CCAppleGreenLight24]::new()
        $this.ColorMap[731] = [CCAppleGreenLight24]::new()
        $this.ColorMap[732] = [CCAppleGreenLight24]::new()
        $this.ColorMap[733] = [CCAppleGreenLight24]::new()
        $this.ColorMap[734] = [CCAppleGreenLight24]::new()
        $this.ColorMap[735] = [CCAppleGreenLight24]::new()
        $this.ColorMap[736] = [CCAppleGreenLight24]::new()
        $this.ColorMap[737] = [CCAppleGreenLight24]::new()
        $this.ColorMap[738] = [CCAppleGreenLight24]::new()
        $this.ColorMap[739] = [CCAppleGreenLight24]::new()
        $this.ColorMap[740] = [CCAppleGreenLight24]::new()
        $this.ColorMap[741] = [CCAppleBrownLight24]::new()
        $this.ColorMap[742] = [CCAppleBrownLight24]::new()
        $this.ColorMap[743] = [CCAppleBrownLight24]::new()
        $this.ColorMap[744] = [CCAppleBrownLight24]::new()
        $this.ColorMap[745] = [CCAppleBrownLight24]::new()
        $this.ColorMap[746] = [CCAppleBrownLight24]::new()
        $this.ColorMap[747] = [CCAppleBrownLight24]::new()
        $this.ColorMap[748] = [CCAppleGreenLight24]::new()
        $this.ColorMap[749] = [CCAppleGreenLight24]::new()
        $this.ColorMap[750] = [CCAppleGreenLight24]::new()
        $this.ColorMap[751] = [CCAppleGreenLight24]::new()
        $this.ColorMap[752] = [CCAppleGreenLight24]::new()
        $this.ColorMap[753] = [CCAppleGreenLight24]::new()
        $this.ColorMap[754] = [CCAppleGreenLight24]::new()
        $this.ColorMap[755] = [CCAppleGreenLight24]::new()
        $this.ColorMap[756] = [CCAppleGreenLight24]::new()
        $this.ColorMap[757] = [CCAppleGreenLight24]::new()
        $this.ColorMap[758] = [CCAppleGreenLight24]::new()
        $this.ColorMap[759] = [CCAppleGreenLight24]::new()
        $this.ColorMap[760] = [CCAppleGreenLight24]::new()
        $this.ColorMap[761] = [CCAppleGreenLight24]::new()
        $this.ColorMap[762] = [CCAppleGreenLight24]::new()
        $this.ColorMap[763] = [CCAppleGreenLight24]::new()
        $this.ColorMap[764] = [CCAppleGreenLight24]::new()
        $this.ColorMap[765] = [CCAppleGreenLight24]::new()
        $this.ColorMap[766] = [CCAppleGreenLight24]::new()
        $this.ColorMap[767] = [CCAppleGreenLight24]::new() # End Row 15
        $this.ColorMap[768] = [CCAppleGreenLight24]::new()
        $this.ColorMap[769] = [CCAppleGreenLight24]::new()
        $this.ColorMap[770] = [CCAppleGreenLight24]::new()
        $this.ColorMap[771] = [CCAppleGreenLight24]::new()
        $this.ColorMap[772] = [CCAppleGreenLight24]::new()
        $this.ColorMap[773] = [CCAppleGreenLight24]::new()
        $this.ColorMap[774] = [CCAppleGreenLight24]::new()
        $this.ColorMap[775] = [CCAppleGreenLight24]::new()
        $this.ColorMap[776] = [CCAppleGreenLight24]::new()
        $this.ColorMap[777] = [CCAppleGreenLight24]::new()
        $this.ColorMap[778] = [CCAppleGreenLight24]::new()
        $this.ColorMap[779] = [CCAppleGreenLight24]::new()
        $this.ColorMap[780] = [CCAppleGreenLight24]::new()
        $this.ColorMap[781] = [CCAppleGreenLight24]::new()
        $this.ColorMap[782] = [CCAppleGreenLight24]::new()
        $this.ColorMap[783] = [CCAppleGreenLight24]::new()
        $this.ColorMap[784] = [CCAppleGreenLight24]::new()
        $this.ColorMap[785] = [CCAppleGreenLight24]::new()
        $this.ColorMap[786] = [CCAppleGreenLight24]::new()
        $this.ColorMap[787] = [CCAppleGreenLight24]::new()
        $this.ColorMap[788] = [CCAppleGreenLight24]::new()
        $this.ColorMap[789] = [CCAppleBrownLight24]::new()
        $this.ColorMap[790] = [CCAppleBrownLight24]::new()
        $this.ColorMap[791] = [CCAppleBrownLight24]::new()
        $this.ColorMap[792] = [CCAppleBrownLight24]::new()
        $this.ColorMap[793] = [CCAppleBrownLight24]::new()
        $this.ColorMap[794] = [CCAppleBrownLight24]::new()
        $this.ColorMap[795] = [CCAppleBrownLight24]::new()
        $this.ColorMap[796] = [CCAppleGreenLight24]::new()
        $this.ColorMap[797] = [CCAppleGreenLight24]::new()
        $this.ColorMap[798] = [CCAppleGreenLight24]::new()
        $this.ColorMap[799] = [CCAppleGreenLight24]::new()
        $this.ColorMap[800] = [CCAppleGreenLight24]::new()
        $this.ColorMap[801] = [CCAppleGreenLight24]::new()
        $this.ColorMap[802] = [CCAppleGreenLight24]::new()
        $this.ColorMap[803] = [CCAppleGreenLight24]::new()
        $this.ColorMap[804] = [CCAppleGreenLight24]::new()
        $this.ColorMap[805] = [CCAppleGreenLight24]::new()
        $this.ColorMap[806] = [CCAppleGreenLight24]::new()
        $this.ColorMap[807] = [CCAppleGreenLight24]::new()
        $this.ColorMap[808] = [CCAppleGreenLight24]::new()
        $this.ColorMap[809] = [CCAppleGreenLight24]::new()
        $this.ColorMap[810] = [CCAppleGreenLight24]::new()
        $this.ColorMap[811] = [CCAppleGreenLight24]::new()
        $this.ColorMap[812] = [CCAppleGreenLight24]::new()
        $this.ColorMap[813] = [CCAppleGreenLight24]::new()
        $this.ColorMap[814] = [CCAppleGreenLight24]::new()
        $this.ColorMap[815] = [CCAppleGreenLight24]::new() # End Row 16
        $this.ColorMap[816] = [CCAppleGreenLight24]::new()
        $this.ColorMap[817] = [CCAppleGreenLight24]::new()
        $this.ColorMap[818] = [CCAppleGreenLight24]::new()
        $this.ColorMap[819] = [CCAppleGreenLight24]::new()
        $this.ColorMap[820] = [CCAppleGreenLight24]::new()
        $this.ColorMap[821] = [CCAppleGreenLight24]::new()
        $this.ColorMap[822] = [CCAppleGreenLight24]::new()
        $this.ColorMap[823] = [CCAppleGreenLight24]::new()
        $this.ColorMap[824] = [CCAppleGreenLight24]::new()
        $this.ColorMap[825] = [CCAppleGreenLight24]::new()
        $this.ColorMap[826] = [CCAppleGreenLight24]::new()
        $this.ColorMap[827] = [CCAppleGreenLight24]::new()
        $this.ColorMap[828] = [CCAppleGreenLight24]::new()
        $this.ColorMap[829] = [CCAppleGreenLight24]::new()
        $this.ColorMap[830] = [CCAppleGreenLight24]::new()
        $this.ColorMap[831] = [CCAppleGreenLight24]::new()
        $this.ColorMap[832] = [CCAppleGreenLight24]::new()
        $this.ColorMap[833] = [CCAppleGreenLight24]::new()
        $this.ColorMap[834] = [CCAppleGreenLight24]::new()
        $this.ColorMap[835] = [CCAppleGreenLight24]::new()
        $this.ColorMap[836] = [CCAppleGreenLight24]::new()
        $this.ColorMap[837] = [CCAppleBrownLight24]::new()
        $this.ColorMap[838] = [CCAppleBrownLight24]::new()
        $this.ColorMap[839] = [CCAppleBrownLight24]::new()
        $this.ColorMap[840] = [CCAppleBrownLight24]::new()
        $this.ColorMap[841] = [CCAppleBrownLight24]::new()
        $this.ColorMap[842] = [CCAppleBrownLight24]::new()
        $this.ColorMap[843] = [CCAppleBrownLight24]::new()
        $this.ColorMap[844] = [CCAppleGreenLight24]::new()
        $this.ColorMap[845] = [CCAppleGreenLight24]::new()
        $this.ColorMap[846] = [CCAppleGreenLight24]::new()
        $this.ColorMap[847] = [CCAppleGreenLight24]::new()
        $this.ColorMap[848] = [CCAppleGreenLight24]::new()
        $this.ColorMap[849] = [CCAppleGreenLight24]::new()
        $this.ColorMap[850] = [CCAppleGreenLight24]::new()
        $this.ColorMap[851] = [CCAppleGreenLight24]::new()
        $this.ColorMap[852] = [CCAppleGreenLight24]::new()
        $this.ColorMap[853] = [CCAppleGreenLight24]::new()
        $this.ColorMap[854] = [CCAppleGreenLight24]::new()
        $this.ColorMap[855] = [CCAppleGreenLight24]::new()
        $this.ColorMap[856] = [CCAppleGreenLight24]::new()
        $this.ColorMap[857] = [CCAppleGreenLight24]::new()
        $this.ColorMap[858] = [CCAppleGreenLight24]::new()
        $this.ColorMap[859] = [CCAppleGreenLight24]::new()
        $this.ColorMap[860] = [CCAppleGreenLight24]::new()
        $this.ColorMap[861] = [CCAppleGreenLight24]::new()
        $this.ColorMap[862] = [CCAppleGreenLight24]::new()
        $this.ColorMap[863] = [CCAppleGreenLight24]::new() # End Row 17
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Finished filling the Color Map.')

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Calling CreateSceneImageATString.')
        $this.CreateSceneImageATString($this.ColorMap)
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Nulling the Color Map.')
        $this.ColorMap = $null
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }
}

Class SIFieldSouthEastRoad : SIInternalBase {
    SIFieldSouthEastRoad(): base() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entering the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Updating the Progress Bar for the Scene Image Progress.')
        Write-Progress -Activity 'Creating Scene Images      ' -Id 3 -Status 'Creating SIFieldSouthEastRoad' -PercentComplete -1
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Filling the Color Map.')
        $this.ColorMap[0]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[1]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[2]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[3]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[4]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[5]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[6]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[7]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[8]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[9]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[10]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[11]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[12]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[13]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[14]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[15]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[16]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[17]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[18]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[19]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[20]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[21]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[22]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[23]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[24]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[25]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[26]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[27]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[28]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[29]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[30]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[31]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[32]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[33]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[34]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[35]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[36]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[37]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[38]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[39]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[40]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[41]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[42]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[43]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[44]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[45]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[46]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[47]  = [CCAppleBlueLight24]::new() # End Row 0
        $this.ColorMap[48]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[49]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[50]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[51]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[52]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[53]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[54]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[55]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[56]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[57]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[58]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[59]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[60]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[61]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[62]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[63]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[64]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[65]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[66]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[67]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[68]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[69]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[70]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[71]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[72]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[73]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[74]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[75]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[76]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[77]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[78]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[79]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[80]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[81]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[82]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[83]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[84]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[85]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[86]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[87]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[88]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[89]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[90]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[91]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[92]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[93]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[94]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[95]  = [CCAppleBlueLight24]::new() # End Row 1
        $this.ColorMap[96]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[97]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[98]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[99]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[100] = [CCAppleBlueLight24]::new()
        $this.ColorMap[101] = [CCAppleBlueLight24]::new()
        $this.ColorMap[102] = [CCAppleBlueLight24]::new()
        $this.ColorMap[103] = [CCAppleBlueLight24]::new()
        $this.ColorMap[104] = [CCAppleBlueLight24]::new()
        $this.ColorMap[105] = [CCAppleBlueLight24]::new()
        $this.ColorMap[106] = [CCAppleBlueLight24]::new()
        $this.ColorMap[107] = [CCAppleBlueLight24]::new()
        $this.ColorMap[108] = [CCAppleBlueLight24]::new()
        $this.ColorMap[109] = [CCAppleBlueLight24]::new()
        $this.ColorMap[110] = [CCAppleBlueLight24]::new()
        $this.ColorMap[111] = [CCAppleBlueLight24]::new()
        $this.ColorMap[112] = [CCAppleBlueLight24]::new()
        $this.ColorMap[113] = [CCAppleBlueLight24]::new()
        $this.ColorMap[114] = [CCAppleBlueLight24]::new()
        $this.ColorMap[115] = [CCAppleBlueLight24]::new()
        $this.ColorMap[116] = [CCAppleBlueLight24]::new()
        $this.ColorMap[117] = [CCAppleBlueLight24]::new()
        $this.ColorMap[118] = [CCAppleBlueLight24]::new()
        $this.ColorMap[119] = [CCAppleBlueLight24]::new()
        $this.ColorMap[120] = [CCAppleBlueLight24]::new()
        $this.ColorMap[121] = [CCAppleBlueLight24]::new()
        $this.ColorMap[122] = [CCAppleBlueLight24]::new()
        $this.ColorMap[123] = [CCAppleBlueLight24]::new()
        $this.ColorMap[124] = [CCAppleBlueLight24]::new()
        $this.ColorMap[125] = [CCAppleBlueLight24]::new()
        $this.ColorMap[126] = [CCAppleBlueLight24]::new()
        $this.ColorMap[127] = [CCAppleBlueLight24]::new()
        $this.ColorMap[128] = [CCAppleBlueLight24]::new()
        $this.ColorMap[129] = [CCAppleBlueLight24]::new()
        $this.ColorMap[130] = [CCAppleBlueLight24]::new()
        $this.ColorMap[131] = [CCAppleBlueLight24]::new()
        $this.ColorMap[132] = [CCAppleBlueLight24]::new()
        $this.ColorMap[133] = [CCAppleBlueLight24]::new()
        $this.ColorMap[134] = [CCAppleBlueLight24]::new()
        $this.ColorMap[135] = [CCAppleBlueLight24]::new()
        $this.ColorMap[136] = [CCAppleBlueLight24]::new()
        $this.ColorMap[137] = [CCAppleBlueLight24]::new()
        $this.ColorMap[138] = [CCAppleBlueLight24]::new()
        $this.ColorMap[139] = [CCAppleBlueLight24]::new()
        $this.ColorMap[140] = [CCAppleBlueLight24]::new()
        $this.ColorMap[141] = [CCAppleBlueLight24]::new()
        $this.ColorMap[142] = [CCAppleBlueLight24]::new()
        $this.ColorMap[143] = [CCAppleBlueLight24]::new() # End Row 2
        $this.ColorMap[144] = [CCAppleBlueLight24]::new()
        $this.ColorMap[145] = [CCAppleBlueLight24]::new()
        $this.ColorMap[146] = [CCAppleBlueLight24]::new()
        $this.ColorMap[147] = [CCAppleBlueLight24]::new()
        $this.ColorMap[148] = [CCAppleBlueLight24]::new()
        $this.ColorMap[149] = [CCAppleBlueLight24]::new()
        $this.ColorMap[150] = [CCAppleBlueLight24]::new()
        $this.ColorMap[151] = [CCAppleBlueLight24]::new()
        $this.ColorMap[152] = [CCAppleBlueLight24]::new()
        $this.ColorMap[153] = [CCAppleBlueLight24]::new()
        $this.ColorMap[154] = [CCAppleBlueLight24]::new()
        $this.ColorMap[155] = [CCAppleBlueLight24]::new()
        $this.ColorMap[156] = [CCAppleBlueLight24]::new()
        $this.ColorMap[157] = [CCAppleBlueLight24]::new()
        $this.ColorMap[158] = [CCAppleBlueLight24]::new()
        $this.ColorMap[159] = [CCAppleBlueLight24]::new()
        $this.ColorMap[160] = [CCAppleBlueLight24]::new()
        $this.ColorMap[161] = [CCAppleBlueLight24]::new()
        $this.ColorMap[162] = [CCAppleBlueLight24]::new()
        $this.ColorMap[163] = [CCAppleBlueLight24]::new()
        $this.ColorMap[164] = [CCAppleBlueLight24]::new()
        $this.ColorMap[165] = [CCAppleBlueLight24]::new()
        $this.ColorMap[166] = [CCAppleBlueLight24]::new()
        $this.ColorMap[167] = [CCAppleBlueLight24]::new()
        $this.ColorMap[168] = [CCAppleBlueLight24]::new()
        $this.ColorMap[169] = [CCAppleBlueLight24]::new()
        $this.ColorMap[170] = [CCAppleBlueLight24]::new()
        $this.ColorMap[171] = [CCAppleBlueLight24]::new()
        $this.ColorMap[172] = [CCAppleBlueLight24]::new()
        $this.ColorMap[173] = [CCAppleBlueLight24]::new()
        $this.ColorMap[174] = [CCAppleBlueLight24]::new()
        $this.ColorMap[175] = [CCAppleBlueLight24]::new()
        $this.ColorMap[176] = [CCAppleBlueLight24]::new()
        $this.ColorMap[177] = [CCAppleBlueLight24]::new()
        $this.ColorMap[178] = [CCAppleBlueLight24]::new()
        $this.ColorMap[179] = [CCAppleBlueLight24]::new()
        $this.ColorMap[180] = [CCAppleBlueLight24]::new()
        $this.ColorMap[181] = [CCAppleBlueLight24]::new()
        $this.ColorMap[182] = [CCAppleBlueLight24]::new()
        $this.ColorMap[183] = [CCAppleBlueLight24]::new()
        $this.ColorMap[184] = [CCAppleBlueLight24]::new()
        $this.ColorMap[185] = [CCAppleBlueLight24]::new()
        $this.ColorMap[186] = [CCAppleBlueLight24]::new()
        $this.ColorMap[187] = [CCAppleBlueLight24]::new()
        $this.ColorMap[188] = [CCAppleBlueLight24]::new()
        $this.ColorMap[189] = [CCAppleBlueLight24]::new()
        $this.ColorMap[190] = [CCAppleBlueLight24]::new()
        $this.ColorMap[191] = [CCAppleBlueLight24]::new() # End Row 3
        $this.ColorMap[192] = [CCAppleBlueLight24]::new()
        $this.ColorMap[193] = [CCAppleBlueLight24]::new()
        $this.ColorMap[194] = [CCAppleBlueLight24]::new()
        $this.ColorMap[195] = [CCAppleBlueLight24]::new()
        $this.ColorMap[196] = [CCAppleBlueLight24]::new()
        $this.ColorMap[197] = [CCAppleBlueLight24]::new()
        $this.ColorMap[198] = [CCAppleBlueLight24]::new()
        $this.ColorMap[199] = [CCAppleBlueLight24]::new()
        $this.ColorMap[200] = [CCAppleBlueLight24]::new()
        $this.ColorMap[201] = [CCAppleBlueLight24]::new()
        $this.ColorMap[202] = [CCAppleBlueLight24]::new()
        $this.ColorMap[203] = [CCAppleBlueLight24]::new()
        $this.ColorMap[204] = [CCAppleBlueLight24]::new()
        $this.ColorMap[205] = [CCAppleBlueLight24]::new()
        $this.ColorMap[206] = [CCAppleBlueLight24]::new()
        $this.ColorMap[207] = [CCAppleBlueLight24]::new()
        $this.ColorMap[208] = [CCAppleBlueLight24]::new()
        $this.ColorMap[209] = [CCAppleBlueLight24]::new()
        $this.ColorMap[210] = [CCAppleBlueLight24]::new()
        $this.ColorMap[211] = [CCAppleBlueLight24]::new()
        $this.ColorMap[212] = [CCAppleBlueLight24]::new()
        $this.ColorMap[213] = [CCAppleBlueLight24]::new()
        $this.ColorMap[214] = [CCAppleBlueLight24]::new()
        $this.ColorMap[215] = [CCAppleBlueLight24]::new()
        $this.ColorMap[216] = [CCAppleBlueLight24]::new()
        $this.ColorMap[217] = [CCAppleBlueLight24]::new()
        $this.ColorMap[218] = [CCAppleBlueLight24]::new()
        $this.ColorMap[219] = [CCAppleBlueLight24]::new()
        $this.ColorMap[220] = [CCAppleBlueLight24]::new()
        $this.ColorMap[221] = [CCAppleBlueLight24]::new()
        $this.ColorMap[222] = [CCAppleBlueLight24]::new()
        $this.ColorMap[223] = [CCAppleBlueLight24]::new()
        $this.ColorMap[224] = [CCAppleBlueLight24]::new()
        $this.ColorMap[225] = [CCAppleBlueLight24]::new()
        $this.ColorMap[226] = [CCAppleBlueLight24]::new()
        $this.ColorMap[227] = [CCAppleBlueLight24]::new()
        $this.ColorMap[228] = [CCAppleBlueLight24]::new()
        $this.ColorMap[229] = [CCAppleBlueLight24]::new()
        $this.ColorMap[230] = [CCAppleBlueLight24]::new()
        $this.ColorMap[231] = [CCAppleBlueLight24]::new()
        $this.ColorMap[232] = [CCAppleBlueLight24]::new()
        $this.ColorMap[233] = [CCAppleBlueLight24]::new()
        $this.ColorMap[234] = [CCAppleBlueLight24]::new()
        $this.ColorMap[235] = [CCAppleBlueLight24]::new()
        $this.ColorMap[236] = [CCAppleBlueLight24]::new()
        $this.ColorMap[237] = [CCAppleBlueLight24]::new()
        $this.ColorMap[238] = [CCAppleBlueLight24]::new()
        $this.ColorMap[239] = [CCAppleBlueLight24]::new() # End Row 4
        $this.ColorMap[240] = [CCAppleGreenLight24]::new()
        $this.ColorMap[241] = [CCAppleGreenLight24]::new()
        $this.ColorMap[242] = [CCAppleGreenLight24]::new()
        $this.ColorMap[243] = [CCAppleGreenLight24]::new()
        $this.ColorMap[244] = [CCAppleGreenLight24]::new()
        $this.ColorMap[245] = [CCAppleGreenLight24]::new()
        $this.ColorMap[246] = [CCAppleGreenLight24]::new()
        $this.ColorMap[247] = [CCAppleGreenLight24]::new()
        $this.ColorMap[248] = [CCAppleGreenLight24]::new()
        $this.ColorMap[249] = [CCAppleGreenLight24]::new()
        $this.ColorMap[250] = [CCAppleGreenLight24]::new()
        $this.ColorMap[251] = [CCAppleGreenLight24]::new()
        $this.ColorMap[252] = [CCAppleGreenLight24]::new()
        $this.ColorMap[253] = [CCAppleGreenLight24]::new()
        $this.ColorMap[254] = [CCAppleGreenLight24]::new()
        $this.ColorMap[255] = [CCAppleGreenLight24]::new()
        $this.ColorMap[256] = [CCAppleGreenLight24]::new()
        $this.ColorMap[257] = [CCAppleGreenLight24]::new()
        $this.ColorMap[258] = [CCAppleGreenLight24]::new()
        $this.ColorMap[259] = [CCAppleGreenLight24]::new()
        $this.ColorMap[260] = [CCAppleGreenLight24]::new()
        $this.ColorMap[261] = [CCAppleGreenLight24]::new()
        $this.ColorMap[262] = [CCAppleGreenLight24]::new()
        $this.ColorMap[263] = [CCAppleGreenLight24]::new()
        $this.ColorMap[264] = [CCAppleGreenLight24]::new()
        $this.ColorMap[265] = [CCAppleGreenLight24]::new()
        $this.ColorMap[266] = [CCAppleGreenLight24]::new()
        $this.ColorMap[267] = [CCAppleGreenLight24]::new()
        $this.ColorMap[268] = [CCAppleGreenLight24]::new()
        $this.ColorMap[269] = [CCAppleGreenLight24]::new()
        $this.ColorMap[270] = [CCAppleGreenLight24]::new()
        $this.ColorMap[271] = [CCAppleGreenLight24]::new()
        $this.ColorMap[272] = [CCAppleGreenLight24]::new()
        $this.ColorMap[273] = [CCAppleGreenLight24]::new()
        $this.ColorMap[274] = [CCAppleGreenLight24]::new()
        $this.ColorMap[275] = [CCAppleGreenLight24]::new()
        $this.ColorMap[276] = [CCAppleGreenLight24]::new()
        $this.ColorMap[277] = [CCAppleGreenLight24]::new()
        $this.ColorMap[278] = [CCAppleGreenLight24]::new()
        $this.ColorMap[279] = [CCAppleGreenLight24]::new()
        $this.ColorMap[280] = [CCAppleGreenLight24]::new()
        $this.ColorMap[281] = [CCAppleGreenLight24]::new()
        $this.ColorMap[282] = [CCAppleGreenLight24]::new()
        $this.ColorMap[283] = [CCAppleGreenLight24]::new()
        $this.ColorMap[284] = [CCAppleGreenLight24]::new()
        $this.ColorMap[285] = [CCAppleGreenLight24]::new()
        $this.ColorMap[286] = [CCAppleGreenLight24]::new()
        $this.ColorMap[287] = [CCAppleGreenLight24]::new() # End Row 5
        $this.ColorMap[288] = [CCAppleGreenLight24]::new()
        $this.ColorMap[289] = [CCAppleGreenLight24]::new()
        $this.ColorMap[290] = [CCAppleGreenLight24]::new()
        $this.ColorMap[291] = [CCAppleGreenLight24]::new()
        $this.ColorMap[292] = [CCAppleGreenLight24]::new()
        $this.ColorMap[293] = [CCAppleGreenLight24]::new()
        $this.ColorMap[294] = [CCAppleGreenLight24]::new()
        $this.ColorMap[295] = [CCAppleGreenLight24]::new()
        $this.ColorMap[296] = [CCAppleGreenLight24]::new()
        $this.ColorMap[297] = [CCAppleGreenLight24]::new()
        $this.ColorMap[298] = [CCAppleGreenLight24]::new()
        $this.ColorMap[299] = [CCAppleGreenLight24]::new()
        $this.ColorMap[300] = [CCAppleGreenLight24]::new()
        $this.ColorMap[301] = [CCAppleGreenLight24]::new()
        $this.ColorMap[302] = [CCAppleGreenLight24]::new()
        $this.ColorMap[303] = [CCAppleGreenLight24]::new()
        $this.ColorMap[304] = [CCAppleGreenLight24]::new()
        $this.ColorMap[305] = [CCAppleGreenLight24]::new()
        $this.ColorMap[306] = [CCAppleGreenLight24]::new()
        $this.ColorMap[307] = [CCAppleGreenLight24]::new()
        $this.ColorMap[308] = [CCAppleGreenLight24]::new()
        $this.ColorMap[309] = [CCAppleGreenLight24]::new()
        $this.ColorMap[310] = [CCAppleGreenLight24]::new()
        $this.ColorMap[311] = [CCAppleGreenLight24]::new()
        $this.ColorMap[312] = [CCAppleGreenLight24]::new()
        $this.ColorMap[313] = [CCAppleGreenLight24]::new()
        $this.ColorMap[314] = [CCAppleGreenLight24]::new()
        $this.ColorMap[315] = [CCAppleGreenLight24]::new()
        $this.ColorMap[316] = [CCAppleGreenLight24]::new()
        $this.ColorMap[317] = [CCAppleGreenLight24]::new()
        $this.ColorMap[318] = [CCAppleGreenLight24]::new()
        $this.ColorMap[319] = [CCAppleGreenLight24]::new()
        $this.ColorMap[320] = [CCAppleGreenLight24]::new()
        $this.ColorMap[321] = [CCAppleGreenLight24]::new()
        $this.ColorMap[322] = [CCAppleGreenLight24]::new()
        $this.ColorMap[323] = [CCAppleGreenLight24]::new()
        $this.ColorMap[324] = [CCAppleGreenLight24]::new()
        $this.ColorMap[325] = [CCAppleGreenLight24]::new()
        $this.ColorMap[326] = [CCAppleGreenLight24]::new()
        $this.ColorMap[327] = [CCAppleGreenLight24]::new()
        $this.ColorMap[328] = [CCAppleGreenLight24]::new()
        $this.ColorMap[329] = [CCAppleGreenLight24]::new()
        $this.ColorMap[330] = [CCAppleGreenLight24]::new()
        $this.ColorMap[331] = [CCAppleGreenLight24]::new()
        $this.ColorMap[332] = [CCAppleGreenLight24]::new()
        $this.ColorMap[333] = [CCAppleGreenLight24]::new()
        $this.ColorMap[334] = [CCAppleGreenLight24]::new()
        $this.ColorMap[335] = [CCAppleGreenLight24]::new() # End Row 6
        $this.ColorMap[336] = [CCAppleGreenLight24]::new()
        $this.ColorMap[337] = [CCAppleGreenLight24]::new()
        $this.ColorMap[338] = [CCAppleGreenLight24]::new()
        $this.ColorMap[339] = [CCAppleGreenLight24]::new()
        $this.ColorMap[340] = [CCAppleGreenLight24]::new()
        $this.ColorMap[341] = [CCAppleGreenLight24]::new()
        $this.ColorMap[342] = [CCAppleGreenLight24]::new()
        $this.ColorMap[343] = [CCAppleGreenLight24]::new()
        $this.ColorMap[344] = [CCAppleGreenLight24]::new()
        $this.ColorMap[345] = [CCAppleGreenLight24]::new()
        $this.ColorMap[346] = [CCAppleGreenLight24]::new()
        $this.ColorMap[347] = [CCAppleGreenLight24]::new()
        $this.ColorMap[348] = [CCAppleGreenLight24]::new()
        $this.ColorMap[349] = [CCAppleGreenLight24]::new()
        $this.ColorMap[350] = [CCAppleGreenLight24]::new()
        $this.ColorMap[351] = [CCAppleGreenLight24]::new()
        $this.ColorMap[352] = [CCAppleGreenLight24]::new()
        $this.ColorMap[353] = [CCAppleGreenLight24]::new()
        $this.ColorMap[354] = [CCAppleGreenLight24]::new()
        $this.ColorMap[355] = [CCAppleGreenLight24]::new()
        $this.ColorMap[356] = [CCAppleGreenLight24]::new()
        $this.ColorMap[357] = [CCAppleGreenLight24]::new()
        $this.ColorMap[358] = [CCAppleGreenLight24]::new()
        $this.ColorMap[359] = [CCAppleGreenLight24]::new()
        $this.ColorMap[360] = [CCAppleGreenLight24]::new()
        $this.ColorMap[361] = [CCAppleGreenLight24]::new()
        $this.ColorMap[362] = [CCAppleGreenLight24]::new()
        $this.ColorMap[363] = [CCAppleGreenLight24]::new()
        $this.ColorMap[364] = [CCAppleGreenLight24]::new()
        $this.ColorMap[365] = [CCAppleGreenLight24]::new()
        $this.ColorMap[366] = [CCAppleGreenLight24]::new()
        $this.ColorMap[367] = [CCAppleGreenLight24]::new()
        $this.ColorMap[368] = [CCAppleGreenLight24]::new()
        $this.ColorMap[369] = [CCAppleGreenLight24]::new()
        $this.ColorMap[370] = [CCAppleGreenLight24]::new()
        $this.ColorMap[371] = [CCAppleGreenLight24]::new()
        $this.ColorMap[372] = [CCAppleGreenLight24]::new()
        $this.ColorMap[373] = [CCAppleGreenLight24]::new()
        $this.ColorMap[374] = [CCAppleGreenLight24]::new()
        $this.ColorMap[375] = [CCAppleGreenLight24]::new()
        $this.ColorMap[376] = [CCAppleGreenLight24]::new()
        $this.ColorMap[377] = [CCAppleGreenLight24]::new()
        $this.ColorMap[378] = [CCAppleGreenLight24]::new()
        $this.ColorMap[379] = [CCAppleGreenLight24]::new()
        $this.ColorMap[380] = [CCAppleGreenLight24]::new()
        $this.ColorMap[381] = [CCAppleGreenLight24]::new()
        $this.ColorMap[382] = [CCAppleGreenLight24]::new()
        $this.ColorMap[383] = [CCAppleGreenLight24]::new() # End Row 7
        $this.ColorMap[384] = [CCAppleGreenLight24]::new()
        $this.ColorMap[385] = [CCAppleGreenLight24]::new()
        $this.ColorMap[386] = [CCAppleGreenLight24]::new()
        $this.ColorMap[387] = [CCAppleGreenLight24]::new()
        $this.ColorMap[388] = [CCAppleGreenLight24]::new()
        $this.ColorMap[389] = [CCAppleGreenLight24]::new()
        $this.ColorMap[390] = [CCAppleGreenLight24]::new()
        $this.ColorMap[391] = [CCAppleGreenLight24]::new()
        $this.ColorMap[392] = [CCAppleGreenLight24]::new()
        $this.ColorMap[393] = [CCAppleGreenLight24]::new()
        $this.ColorMap[394] = [CCAppleGreenLight24]::new()
        $this.ColorMap[395] = [CCAppleGreenLight24]::new()
        $this.ColorMap[396] = [CCAppleGreenLight24]::new()
        $this.ColorMap[397] = [CCAppleGreenLight24]::new()
        $this.ColorMap[398] = [CCAppleGreenLight24]::new()
        $this.ColorMap[399] = [CCAppleGreenLight24]::new()
        $this.ColorMap[400] = [CCAppleGreenLight24]::new()
        $this.ColorMap[401] = [CCAppleGreenLight24]::new()
        $this.ColorMap[402] = [CCAppleGreenLight24]::new()
        $this.ColorMap[403] = [CCAppleGreenLight24]::new()
        $this.ColorMap[404] = [CCAppleGreenLight24]::new()
        $this.ColorMap[405] = [CCAppleGreenLight24]::new()
        $this.ColorMap[406] = [CCAppleBrownLight24]::new()
        $this.ColorMap[407] = [CCAppleBrownLight24]::new()
        $this.ColorMap[408] = [CCAppleBrownLight24]::new()
        $this.ColorMap[409] = [CCAppleBrownLight24]::new()
        $this.ColorMap[410] = [CCAppleBrownLight24]::new()
        $this.ColorMap[411] = [CCAppleGreenLight24]::new()
        $this.ColorMap[412] = [CCAppleGreenLight24]::new()
        $this.ColorMap[413] = [CCAppleGreenLight24]::new()
        $this.ColorMap[414] = [CCAppleGreenLight24]::new()
        $this.ColorMap[415] = [CCAppleGreenLight24]::new()
        $this.ColorMap[416] = [CCAppleGreenLight24]::new()
        $this.ColorMap[417] = [CCAppleGreenLight24]::new()
        $this.ColorMap[418] = [CCAppleGreenLight24]::new()
        $this.ColorMap[419] = [CCAppleGreenLight24]::new()
        $this.ColorMap[420] = [CCAppleGreenLight24]::new()
        $this.ColorMap[421] = [CCAppleGreenLight24]::new()
        $this.ColorMap[422] = [CCAppleGreenLight24]::new()
        $this.ColorMap[423] = [CCAppleGreenLight24]::new()
        $this.ColorMap[424] = [CCAppleGreenLight24]::new()
        $this.ColorMap[425] = [CCAppleGreenLight24]::new()
        $this.ColorMap[426] = [CCAppleGreenLight24]::new()
        $this.ColorMap[427] = [CCAppleGreenLight24]::new()
        $this.ColorMap[428] = [CCAppleGreenLight24]::new()
        $this.ColorMap[429] = [CCAppleGreenLight24]::new()
        $this.ColorMap[430] = [CCAppleGreenLight24]::new()
        $this.ColorMap[431] = [CCAppleGreenLight24]::new() # End Row 8
        $this.ColorMap[432] = [CCAppleGreenLight24]::new()
        $this.ColorMap[433] = [CCAppleGreenLight24]::new()
        $this.ColorMap[434] = [CCAppleGreenLight24]::new()
        $this.ColorMap[435] = [CCAppleGreenLight24]::new()
        $this.ColorMap[436] = [CCAppleGreenLight24]::new()
        $this.ColorMap[437] = [CCAppleGreenLight24]::new()
        $this.ColorMap[438] = [CCAppleGreenLight24]::new()
        $this.ColorMap[439] = [CCAppleGreenLight24]::new()
        $this.ColorMap[440] = [CCAppleGreenLight24]::new()
        $this.ColorMap[441] = [CCAppleGreenLight24]::new()
        $this.ColorMap[442] = [CCAppleGreenLight24]::new()
        $this.ColorMap[443] = [CCAppleGreenLight24]::new()
        $this.ColorMap[444] = [CCAppleGreenLight24]::new()
        $this.ColorMap[445] = [CCAppleGreenLight24]::new()
        $this.ColorMap[446] = [CCAppleGreenLight24]::new()
        $this.ColorMap[447] = [CCAppleGreenLight24]::new()
        $this.ColorMap[448] = [CCAppleGreenLight24]::new()
        $this.ColorMap[449] = [CCAppleGreenLight24]::new()
        $this.ColorMap[450] = [CCAppleGreenLight24]::new()
        $this.ColorMap[451] = [CCAppleGreenLight24]::new()
        $this.ColorMap[452] = [CCAppleGreenLight24]::new()
        $this.ColorMap[453] = [CCAppleGreenLight24]::new()
        $this.ColorMap[454] = [CCAppleBrownLight24]::new()
        $this.ColorMap[455] = [CCAppleBrownLight24]::new()
        $this.ColorMap[456] = [CCAppleBrownLight24]::new()
        $this.ColorMap[457] = [CCAppleBrownLight24]::new()
        $this.ColorMap[458] = [CCAppleBrownLight24]::new()
        $this.ColorMap[459] = [CCAppleGreenLight24]::new()
        $this.ColorMap[460] = [CCAppleGreenLight24]::new()
        $this.ColorMap[461] = [CCAppleGreenLight24]::new()
        $this.ColorMap[462] = [CCAppleGreenLight24]::new()
        $this.ColorMap[463] = [CCAppleGreenLight24]::new()
        $this.ColorMap[464] = [CCAppleGreenLight24]::new()
        $this.ColorMap[465] = [CCAppleGreenLight24]::new()
        $this.ColorMap[466] = [CCAppleGreenLight24]::new()
        $this.ColorMap[467] = [CCAppleGreenLight24]::new()
        $this.ColorMap[468] = [CCAppleGreenLight24]::new()
        $this.ColorMap[469] = [CCAppleGreenLight24]::new()
        $this.ColorMap[470] = [CCAppleGreenLight24]::new()
        $this.ColorMap[471] = [CCAppleGreenLight24]::new()
        $this.ColorMap[472] = [CCAppleGreenLight24]::new()
        $this.ColorMap[473] = [CCAppleGreenLight24]::new()
        $this.ColorMap[474] = [CCAppleGreenLight24]::new()
        $this.ColorMap[475] = [CCAppleGreenLight24]::new()
        $this.ColorMap[476] = [CCAppleGreenLight24]::new()
        $this.ColorMap[477] = [CCAppleGreenLight24]::new()
        $this.ColorMap[478] = [CCAppleGreenLight24]::new()
        $this.ColorMap[479] = [CCAppleGreenLight24]::new() # End Row 9
        $this.ColorMap[480] = [CCAppleGreenLight24]::new()
        $this.ColorMap[481] = [CCAppleGreenLight24]::new()
        $this.ColorMap[482] = [CCAppleGreenLight24]::new()
        $this.ColorMap[483] = [CCAppleGreenLight24]::new()
        $this.ColorMap[484] = [CCAppleGreenLight24]::new()
        $this.ColorMap[485] = [CCAppleGreenLight24]::new()
        $this.ColorMap[486] = [CCAppleGreenLight24]::new()
        $this.ColorMap[487] = [CCAppleGreenLight24]::new()
        $this.ColorMap[488] = [CCAppleGreenLight24]::new()
        $this.ColorMap[489] = [CCAppleGreenLight24]::new()
        $this.ColorMap[490] = [CCAppleGreenLight24]::new()
        $this.ColorMap[491] = [CCAppleGreenLight24]::new()
        $this.ColorMap[492] = [CCAppleGreenLight24]::new()
        $this.ColorMap[493] = [CCAppleGreenLight24]::new()
        $this.ColorMap[494] = [CCAppleGreenLight24]::new()
        $this.ColorMap[495] = [CCAppleGreenLight24]::new()
        $this.ColorMap[496] = [CCAppleGreenLight24]::new()
        $this.ColorMap[497] = [CCAppleGreenLight24]::new()
        $this.ColorMap[498] = [CCAppleGreenLight24]::new()
        $this.ColorMap[499] = [CCAppleGreenLight24]::new()
        $this.ColorMap[500] = [CCAppleGreenLight24]::new()
        $this.ColorMap[501] = [CCAppleBrownLight24]::new()
        $this.ColorMap[502] = [CCAppleBrownLight24]::new()
        $this.ColorMap[503] = [CCAppleBrownLight24]::new()
        $this.ColorMap[504] = [CCAppleBrownLight24]::new()
        $this.ColorMap[505] = [CCAppleBrownLight24]::new()
        $this.ColorMap[506] = [CCAppleBrownLight24]::new()
        $this.ColorMap[507] = [CCAppleBrownLight24]::new()
        $this.ColorMap[508] = [CCAppleGreenLight24]::new()
        $this.ColorMap[509] = [CCAppleGreenLight24]::new()
        $this.ColorMap[510] = [CCAppleGreenLight24]::new()
        $this.ColorMap[511] = [CCAppleGreenLight24]::new()
        $this.ColorMap[512] = [CCAppleGreenLight24]::new()
        $this.ColorMap[513] = [CCAppleGreenLight24]::new()
        $this.ColorMap[514] = [CCAppleGreenLight24]::new()
        $this.ColorMap[515] = [CCAppleGreenLight24]::new()
        $this.ColorMap[516] = [CCAppleGreenLight24]::new()
        $this.ColorMap[517] = [CCAppleGreenLight24]::new()
        $this.ColorMap[518] = [CCAppleGreenLight24]::new()
        $this.ColorMap[519] = [CCAppleGreenLight24]::new()
        $this.ColorMap[520] = [CCAppleGreenLight24]::new()
        $this.ColorMap[521] = [CCAppleGreenLight24]::new()
        $this.ColorMap[522] = [CCAppleGreenLight24]::new()
        $this.ColorMap[523] = [CCAppleGreenLight24]::new()
        $this.ColorMap[524] = [CCAppleGreenLight24]::new()
        $this.ColorMap[525] = [CCAppleGreenLight24]::new()
        $this.ColorMap[526] = [CCAppleGreenLight24]::new()
        $this.ColorMap[527] = [CCAppleGreenLight24]::new() # End Row 10
        $this.ColorMap[528] = [CCAppleGreenLight24]::new()
        $this.ColorMap[529] = [CCAppleGreenLight24]::new()
        $this.ColorMap[530] = [CCAppleGreenLight24]::new()
        $this.ColorMap[531] = [CCAppleGreenLight24]::new()
        $this.ColorMap[532] = [CCAppleGreenLight24]::new()
        $this.ColorMap[533] = [CCAppleGreenLight24]::new()
        $this.ColorMap[534] = [CCAppleGreenLight24]::new()
        $this.ColorMap[535] = [CCAppleGreenLight24]::new()
        $this.ColorMap[536] = [CCAppleGreenLight24]::new()
        $this.ColorMap[537] = [CCAppleGreenLight24]::new()
        $this.ColorMap[538] = [CCAppleGreenLight24]::new()
        $this.ColorMap[539] = [CCAppleGreenLight24]::new()
        $this.ColorMap[540] = [CCAppleGreenLight24]::new()
        $this.ColorMap[541] = [CCAppleGreenLight24]::new()
        $this.ColorMap[542] = [CCAppleGreenLight24]::new()
        $this.ColorMap[543] = [CCAppleGreenLight24]::new()
        $this.ColorMap[544] = [CCAppleGreenLight24]::new()
        $this.ColorMap[545] = [CCAppleGreenLight24]::new()
        $this.ColorMap[546] = [CCAppleGreenLight24]::new()
        $this.ColorMap[547] = [CCAppleGreenLight24]::new()
        $this.ColorMap[548] = [CCAppleGreenLight24]::new()
        $this.ColorMap[549] = [CCAppleBrownLight24]::new()
        $this.ColorMap[550] = [CCAppleBrownLight24]::new()
        $this.ColorMap[551] = [CCAppleBrownLight24]::new()
        $this.ColorMap[552] = [CCAppleBrownLight24]::new()
        $this.ColorMap[553] = [CCAppleBrownLight24]::new()
        $this.ColorMap[554] = [CCAppleBrownLight24]::new()
        $this.ColorMap[555] = [CCAppleBrownLight24]::new()
        $this.ColorMap[556] = [CCAppleGreenLight24]::new()
        $this.ColorMap[557] = [CCAppleGreenLight24]::new()
        $this.ColorMap[558] = [CCAppleGreenLight24]::new()
        $this.ColorMap[559] = [CCAppleGreenLight24]::new()
        $this.ColorMap[560] = [CCAppleGreenLight24]::new()
        $this.ColorMap[561] = [CCAppleGreenLight24]::new()
        $this.ColorMap[562] = [CCAppleGreenLight24]::new()
        $this.ColorMap[563] = [CCAppleGreenLight24]::new()
        $this.ColorMap[564] = [CCAppleGreenLight24]::new()
        $this.ColorMap[565] = [CCAppleGreenLight24]::new()
        $this.ColorMap[566] = [CCAppleGreenLight24]::new()
        $this.ColorMap[567] = [CCAppleGreenLight24]::new()
        $this.ColorMap[568] = [CCAppleGreenLight24]::new()
        $this.ColorMap[569] = [CCAppleGreenLight24]::new()
        $this.ColorMap[570] = [CCAppleGreenLight24]::new()
        $this.ColorMap[571] = [CCAppleGreenLight24]::new()
        $this.ColorMap[572] = [CCAppleGreenLight24]::new()
        $this.ColorMap[573] = [CCAppleGreenLight24]::new()
        $this.ColorMap[574] = [CCAppleGreenLight24]::new()
        $this.ColorMap[575] = [CCAppleGreenLight24]::new() # End Row 11
        $this.ColorMap[576] = [CCAppleGreenLight24]::new()
        $this.ColorMap[577] = [CCAppleGreenLight24]::new()
        $this.ColorMap[578] = [CCAppleGreenLight24]::new()
        $this.ColorMap[579] = [CCAppleGreenLight24]::new()
        $this.ColorMap[580] = [CCAppleGreenLight24]::new()
        $this.ColorMap[581] = [CCAppleGreenLight24]::new()
        $this.ColorMap[582] = [CCAppleGreenLight24]::new()
        $this.ColorMap[583] = [CCAppleGreenLight24]::new()
        $this.ColorMap[584] = [CCAppleGreenLight24]::new()
        $this.ColorMap[585] = [CCAppleGreenLight24]::new()
        $this.ColorMap[586] = [CCAppleGreenLight24]::new()
        $this.ColorMap[587] = [CCAppleGreenLight24]::new()
        $this.ColorMap[588] = [CCAppleGreenLight24]::new()
        $this.ColorMap[589] = [CCAppleGreenLight24]::new()
        $this.ColorMap[590] = [CCAppleGreenLight24]::new()
        $this.ColorMap[591] = [CCAppleGreenLight24]::new()
        $this.ColorMap[592] = [CCAppleGreenLight24]::new()
        $this.ColorMap[593] = [CCAppleGreenLight24]::new()
        $this.ColorMap[594] = [CCAppleGreenLight24]::new()
        $this.ColorMap[595] = [CCAppleGreenLight24]::new()
        $this.ColorMap[596] = [CCAppleGreenLight24]::new()
        $this.ColorMap[597] = [CCAppleBrownLight24]::new()
        $this.ColorMap[598] = [CCAppleBrownLight24]::new()
        $this.ColorMap[599] = [CCAppleBrownLight24]::new()
        $this.ColorMap[600] = [CCAppleBrownLight24]::new()
        $this.ColorMap[601] = [CCAppleBrownLight24]::new()
        $this.ColorMap[602] = [CCAppleBrownLight24]::new()
        $this.ColorMap[603] = [CCAppleBrownLight24]::new()
        $this.ColorMap[604] = [CCAppleGreenLight24]::new()
        $this.ColorMap[605] = [CCAppleGreenLight24]::new()
        $this.ColorMap[606] = [CCAppleGreenLight24]::new()
        $this.ColorMap[607] = [CCAppleGreenLight24]::new()
        $this.ColorMap[608] = [CCAppleGreenLight24]::new()
        $this.ColorMap[609] = [CCAppleGreenLight24]::new()
        $this.ColorMap[610] = [CCAppleGreenLight24]::new()
        $this.ColorMap[611] = [CCAppleGreenLight24]::new()
        $this.ColorMap[612] = [CCAppleGreenLight24]::new()
        $this.ColorMap[613] = [CCAppleGreenLight24]::new()
        $this.ColorMap[614] = [CCAppleGreenLight24]::new()
        $this.ColorMap[615] = [CCAppleGreenLight24]::new()
        $this.ColorMap[616] = [CCAppleGreenLight24]::new()
        $this.ColorMap[617] = [CCAppleGreenLight24]::new()
        $this.ColorMap[618] = [CCAppleGreenLight24]::new()
        $this.ColorMap[619] = [CCAppleGreenLight24]::new()
        $this.ColorMap[620] = [CCAppleGreenLight24]::new()
        $this.ColorMap[621] = [CCAppleGreenLight24]::new()
        $this.ColorMap[622] = [CCAppleGreenLight24]::new()
        $this.ColorMap[623] = [CCAppleGreenLight24]::new() # End Row 12
        $this.ColorMap[624] = [CCAppleGreenLight24]::new()
        $this.ColorMap[625] = [CCAppleGreenLight24]::new()
        $this.ColorMap[626] = [CCAppleGreenLight24]::new()
        $this.ColorMap[627] = [CCAppleGreenLight24]::new()
        $this.ColorMap[628] = [CCAppleGreenLight24]::new()
        $this.ColorMap[629] = [CCAppleGreenLight24]::new()
        $this.ColorMap[630] = [CCAppleGreenLight24]::new()
        $this.ColorMap[631] = [CCAppleGreenLight24]::new()
        $this.ColorMap[632] = [CCAppleGreenLight24]::new()
        $this.ColorMap[633] = [CCAppleGreenLight24]::new()
        $this.ColorMap[634] = [CCAppleGreenLight24]::new()
        $this.ColorMap[635] = [CCAppleGreenLight24]::new()
        $this.ColorMap[636] = [CCAppleGreenLight24]::new()
        $this.ColorMap[637] = [CCAppleGreenLight24]::new()
        $this.ColorMap[638] = [CCAppleGreenLight24]::new()
        $this.ColorMap[639] = [CCAppleGreenLight24]::new()
        $this.ColorMap[640] = [CCAppleGreenLight24]::new()
        $this.ColorMap[641] = [CCAppleGreenLight24]::new()
        $this.ColorMap[642] = [CCAppleGreenLight24]::new()
        $this.ColorMap[643] = [CCAppleGreenLight24]::new()
        $this.ColorMap[644] = [CCAppleGreenLight24]::new()
        $this.ColorMap[645] = [CCAppleBrownLight24]::new()
        $this.ColorMap[646] = [CCAppleBrownLight24]::new()
        $this.ColorMap[647] = [CCAppleBrownLight24]::new()
        $this.ColorMap[648] = [CCAppleBrownLight24]::new()
        $this.ColorMap[649] = [CCAppleBrownLight24]::new()
        $this.ColorMap[650] = [CCAppleBrownLight24]::new()
        $this.ColorMap[651] = [CCAppleBrownLight24]::new()
        $this.ColorMap[652] = [CCAppleGreenLight24]::new()
        $this.ColorMap[653] = [CCAppleGreenLight24]::new()
        $this.ColorMap[654] = [CCAppleGreenLight24]::new()
        $this.ColorMap[655] = [CCAppleGreenLight24]::new()
        $this.ColorMap[656] = [CCAppleGreenLight24]::new()
        $this.ColorMap[657] = [CCAppleGreenLight24]::new()
        $this.ColorMap[658] = [CCAppleGreenLight24]::new()
        $this.ColorMap[659] = [CCAppleGreenLight24]::new()
        $this.ColorMap[660] = [CCAppleGreenLight24]::new()
        $this.ColorMap[661] = [CCAppleGreenLight24]::new()
        $this.ColorMap[662] = [CCAppleGreenLight24]::new()
        $this.ColorMap[663] = [CCAppleGreenLight24]::new()
        $this.ColorMap[664] = [CCAppleGreenLight24]::new()
        $this.ColorMap[665] = [CCAppleGreenLight24]::new()
        $this.ColorMap[666] = [CCAppleGreenLight24]::new()
        $this.ColorMap[667] = [CCAppleGreenLight24]::new()
        $this.ColorMap[668] = [CCAppleGreenLight24]::new()
        $this.ColorMap[669] = [CCAppleGreenLight24]::new()
        $this.ColorMap[670] = [CCAppleGreenLight24]::new()
        $this.ColorMap[671] = [CCAppleGreenLight24]::new() # End Row 13
        $this.ColorMap[672] = [CCAppleGreenLight24]::new()
        $this.ColorMap[673] = [CCAppleGreenLight24]::new()
        $this.ColorMap[674] = [CCAppleGreenLight24]::new()
        $this.ColorMap[675] = [CCAppleGreenLight24]::new()
        $this.ColorMap[676] = [CCAppleGreenLight24]::new()
        $this.ColorMap[677] = [CCAppleGreenLight24]::new()
        $this.ColorMap[678] = [CCAppleGreenLight24]::new()
        $this.ColorMap[679] = [CCAppleGreenLight24]::new()
        $this.ColorMap[680] = [CCAppleGreenLight24]::new()
        $this.ColorMap[681] = [CCAppleGreenLight24]::new()
        $this.ColorMap[682] = [CCAppleGreenLight24]::new()
        $this.ColorMap[683] = [CCAppleGreenLight24]::new()
        $this.ColorMap[684] = [CCAppleGreenLight24]::new()
        $this.ColorMap[685] = [CCAppleGreenLight24]::new()
        $this.ColorMap[686] = [CCAppleGreenLight24]::new()
        $this.ColorMap[687] = [CCAppleGreenLight24]::new()
        $this.ColorMap[688] = [CCAppleGreenLight24]::new()
        $this.ColorMap[689] = [CCAppleGreenLight24]::new()
        $this.ColorMap[690] = [CCAppleGreenLight24]::new()
        $this.ColorMap[691] = [CCAppleGreenLight24]::new()
        $this.ColorMap[692] = [CCAppleGreenLight24]::new()
        $this.ColorMap[693] = [CCAppleBrownLight24]::new()
        $this.ColorMap[694] = [CCAppleBrownLight24]::new()
        $this.ColorMap[695] = [CCAppleBrownLight24]::new()
        $this.ColorMap[696] = [CCAppleBrownLight24]::new()
        $this.ColorMap[697] = [CCAppleBrownLight24]::new()
        $this.ColorMap[698] = [CCAppleBrownLight24]::new()
        $this.ColorMap[699] = [CCAppleBrownLight24]::new()
        $this.ColorMap[700] = [CCAppleGreenLight24]::new()
        $this.ColorMap[701] = [CCAppleGreenLight24]::new()
        $this.ColorMap[702] = [CCAppleGreenLight24]::new()
        $this.ColorMap[703] = [CCAppleGreenLight24]::new()
        $this.ColorMap[704] = [CCAppleGreenLight24]::new()
        $this.ColorMap[705] = [CCAppleGreenLight24]::new()
        $this.ColorMap[706] = [CCAppleGreenLight24]::new()
        $this.ColorMap[707] = [CCAppleGreenLight24]::new()
        $this.ColorMap[708] = [CCAppleGreenLight24]::new()
        $this.ColorMap[709] = [CCAppleGreenLight24]::new()
        $this.ColorMap[710] = [CCAppleGreenLight24]::new()
        $this.ColorMap[711] = [CCAppleGreenLight24]::new()
        $this.ColorMap[712] = [CCAppleGreenLight24]::new()
        $this.ColorMap[713] = [CCAppleGreenLight24]::new()
        $this.ColorMap[714] = [CCAppleGreenLight24]::new()
        $this.ColorMap[715] = [CCAppleGreenLight24]::new()
        $this.ColorMap[716] = [CCAppleGreenLight24]::new()
        $this.ColorMap[717] = [CCAppleGreenLight24]::new()
        $this.ColorMap[718] = [CCAppleGreenLight24]::new()
        $this.ColorMap[719] = [CCAppleGreenLight24]::new() # End Row 14
        $this.ColorMap[720] = [CCAppleGreenLight24]::new()
        $this.ColorMap[721] = [CCAppleGreenLight24]::new()
        $this.ColorMap[722] = [CCAppleGreenLight24]::new()
        $this.ColorMap[723] = [CCAppleGreenLight24]::new()
        $this.ColorMap[724] = [CCAppleGreenLight24]::new()
        $this.ColorMap[725] = [CCAppleGreenLight24]::new()
        $this.ColorMap[726] = [CCAppleGreenLight24]::new()
        $this.ColorMap[727] = [CCAppleGreenLight24]::new()
        $this.ColorMap[728] = [CCAppleGreenLight24]::new()
        $this.ColorMap[729] = [CCAppleGreenLight24]::new()
        $this.ColorMap[730] = [CCAppleGreenLight24]::new()
        $this.ColorMap[731] = [CCAppleGreenLight24]::new()
        $this.ColorMap[732] = [CCAppleGreenLight24]::new()
        $this.ColorMap[733] = [CCAppleGreenLight24]::new()
        $this.ColorMap[734] = [CCAppleGreenLight24]::new()
        $this.ColorMap[735] = [CCAppleGreenLight24]::new()
        $this.ColorMap[736] = [CCAppleGreenLight24]::new()
        $this.ColorMap[737] = [CCAppleGreenLight24]::new()
        $this.ColorMap[738] = [CCAppleGreenLight24]::new()
        $this.ColorMap[739] = [CCAppleGreenLight24]::new()
        $this.ColorMap[740] = [CCAppleGreenLight24]::new()
        $this.ColorMap[741] = [CCAppleBrownLight24]::new()
        $this.ColorMap[742] = [CCAppleBrownLight24]::new()
        $this.ColorMap[743] = [CCAppleBrownLight24]::new()
        $this.ColorMap[744] = [CCAppleBrownLight24]::new()
        $this.ColorMap[745] = [CCAppleBrownLight24]::new()
        $this.ColorMap[746] = [CCAppleBrownLight24]::new()
        $this.ColorMap[747] = [CCAppleBrownLight24]::new()
        $this.ColorMap[748] = [CCAppleGreenLight24]::new()
        $this.ColorMap[749] = [CCAppleGreenLight24]::new()
        $this.ColorMap[750] = [CCAppleGreenLight24]::new()
        $this.ColorMap[751] = [CCAppleGreenLight24]::new()
        $this.ColorMap[752] = [CCAppleGreenLight24]::new()
        $this.ColorMap[753] = [CCAppleGreenLight24]::new()
        $this.ColorMap[754] = [CCAppleGreenLight24]::new()
        $this.ColorMap[755] = [CCAppleGreenLight24]::new()
        $this.ColorMap[756] = [CCAppleGreenLight24]::new()
        $this.ColorMap[757] = [CCAppleGreenLight24]::new()
        $this.ColorMap[758] = [CCAppleGreenLight24]::new()
        $this.ColorMap[759] = [CCAppleGreenLight24]::new()
        $this.ColorMap[760] = [CCAppleGreenLight24]::new()
        $this.ColorMap[761] = [CCAppleGreenLight24]::new()
        $this.ColorMap[762] = [CCAppleGreenLight24]::new()
        $this.ColorMap[763] = [CCAppleGreenLight24]::new()
        $this.ColorMap[764] = [CCAppleGreenLight24]::new()
        $this.ColorMap[765] = [CCAppleGreenLight24]::new()
        $this.ColorMap[766] = [CCAppleGreenLight24]::new()
        $this.ColorMap[767] = [CCAppleGreenLight24]::new() # End Row 15
        $this.ColorMap[768] = [CCAppleGreenLight24]::new()
        $this.ColorMap[769] = [CCAppleGreenLight24]::new()
        $this.ColorMap[770] = [CCAppleGreenLight24]::new()
        $this.ColorMap[771] = [CCAppleGreenLight24]::new()
        $this.ColorMap[772] = [CCAppleGreenLight24]::new()
        $this.ColorMap[773] = [CCAppleGreenLight24]::new()
        $this.ColorMap[774] = [CCAppleGreenLight24]::new()
        $this.ColorMap[775] = [CCAppleGreenLight24]::new()
        $this.ColorMap[776] = [CCAppleGreenLight24]::new()
        $this.ColorMap[777] = [CCAppleGreenLight24]::new()
        $this.ColorMap[778] = [CCAppleGreenLight24]::new()
        $this.ColorMap[779] = [CCAppleGreenLight24]::new()
        $this.ColorMap[780] = [CCAppleGreenLight24]::new()
        $this.ColorMap[781] = [CCAppleGreenLight24]::new()
        $this.ColorMap[782] = [CCAppleGreenLight24]::new()
        $this.ColorMap[783] = [CCAppleGreenLight24]::new()
        $this.ColorMap[784] = [CCAppleGreenLight24]::new()
        $this.ColorMap[785] = [CCAppleGreenLight24]::new()
        $this.ColorMap[786] = [CCAppleGreenLight24]::new()
        $this.ColorMap[787] = [CCAppleGreenLight24]::new()
        $this.ColorMap[788] = [CCAppleGreenLight24]::new()
        $this.ColorMap[789] = [CCAppleBrownLight24]::new()
        $this.ColorMap[790] = [CCAppleBrownLight24]::new()
        $this.ColorMap[791] = [CCAppleBrownLight24]::new()
        $this.ColorMap[792] = [CCAppleBrownLight24]::new()
        $this.ColorMap[793] = [CCAppleBrownLight24]::new()
        $this.ColorMap[794] = [CCAppleBrownLight24]::new()
        $this.ColorMap[795] = [CCAppleBrownLight24]::new()
        $this.ColorMap[796] = [CCAppleBrownLight24]::new()
        $this.ColorMap[797] = [CCAppleBrownLight24]::new()
        $this.ColorMap[798] = [CCAppleBrownLight24]::new()
        $this.ColorMap[799] = [CCAppleBrownLight24]::new()
        $this.ColorMap[800] = [CCAppleBrownLight24]::new()
        $this.ColorMap[801] = [CCAppleBrownLight24]::new()
        $this.ColorMap[802] = [CCAppleBrownLight24]::new()
        $this.ColorMap[803] = [CCAppleBrownLight24]::new()
        $this.ColorMap[804] = [CCAppleBrownLight24]::new()
        $this.ColorMap[805] = [CCAppleBrownLight24]::new()
        $this.ColorMap[806] = [CCAppleBrownLight24]::new()
        $this.ColorMap[807] = [CCAppleBrownLight24]::new()
        $this.ColorMap[808] = [CCAppleBrownLight24]::new()
        $this.ColorMap[809] = [CCAppleBrownLight24]::new()
        $this.ColorMap[810] = [CCAppleBrownLight24]::new()
        $this.ColorMap[811] = [CCAppleBrownLight24]::new()
        $this.ColorMap[812] = [CCAppleBrownLight24]::new()
        $this.ColorMap[813] = [CCAppleBrownLight24]::new()
        $this.ColorMap[814] = [CCAppleBrownLight24]::new()
        $this.ColorMap[815] = [CCAppleGreenLight24]::new() # End Row 16
        $this.ColorMap[816] = [CCAppleGreenLight24]::new()
        $this.ColorMap[817] = [CCAppleGreenLight24]::new()
        $this.ColorMap[818] = [CCAppleGreenLight24]::new()
        $this.ColorMap[819] = [CCAppleGreenLight24]::new()
        $this.ColorMap[820] = [CCAppleGreenLight24]::new()
        $this.ColorMap[821] = [CCAppleGreenLight24]::new()
        $this.ColorMap[822] = [CCAppleGreenLight24]::new()
        $this.ColorMap[823] = [CCAppleGreenLight24]::new()
        $this.ColorMap[824] = [CCAppleGreenLight24]::new()
        $this.ColorMap[825] = [CCAppleGreenLight24]::new()
        $this.ColorMap[826] = [CCAppleGreenLight24]::new()
        $this.ColorMap[827] = [CCAppleGreenLight24]::new()
        $this.ColorMap[828] = [CCAppleGreenLight24]::new()
        $this.ColorMap[829] = [CCAppleGreenLight24]::new()
        $this.ColorMap[830] = [CCAppleGreenLight24]::new()
        $this.ColorMap[831] = [CCAppleGreenLight24]::new()
        $this.ColorMap[832] = [CCAppleGreenLight24]::new()
        $this.ColorMap[833] = [CCAppleGreenLight24]::new()
        $this.ColorMap[834] = [CCAppleGreenLight24]::new()
        $this.ColorMap[835] = [CCAppleGreenLight24]::new()
        $this.ColorMap[836] = [CCAppleGreenLight24]::new()
        $this.ColorMap[837] = [CCAppleBrownLight24]::new()
        $this.ColorMap[838] = [CCAppleBrownLight24]::new()
        $this.ColorMap[839] = [CCAppleBrownLight24]::new()
        $this.ColorMap[840] = [CCAppleBrownLight24]::new()
        $this.ColorMap[841] = [CCAppleBrownLight24]::new()
        $this.ColorMap[842] = [CCAppleBrownLight24]::new()
        $this.ColorMap[843] = [CCAppleBrownLight24]::new()
        $this.ColorMap[844] = [CCAppleBrownLight24]::new()
        $this.ColorMap[845] = [CCAppleBrownLight24]::new()
        $this.ColorMap[846] = [CCAppleBrownLight24]::new()
        $this.ColorMap[847] = [CCAppleBrownLight24]::new()
        $this.ColorMap[848] = [CCAppleBrownLight24]::new()
        $this.ColorMap[849] = [CCAppleBrownLight24]::new()
        $this.ColorMap[850] = [CCAppleBrownLight24]::new()
        $this.ColorMap[851] = [CCAppleBrownLight24]::new()
        $this.ColorMap[852] = [CCAppleBrownLight24]::new()
        $this.ColorMap[853] = [CCAppleBrownLight24]::new()
        $this.ColorMap[854] = [CCAppleBrownLight24]::new()
        $this.ColorMap[855] = [CCAppleBrownLight24]::new()
        $this.ColorMap[856] = [CCAppleBrownLight24]::new()
        $this.ColorMap[857] = [CCAppleBrownLight24]::new()
        $this.ColorMap[858] = [CCAppleBrownLight24]::new()
        $this.ColorMap[859] = [CCAppleBrownLight24]::new()
        $this.ColorMap[860] = [CCAppleBrownLight24]::new()
        $this.ColorMap[861] = [CCAppleBrownLight24]::new()
        $this.ColorMap[862] = [CCAppleBrownLight24]::new()
        $this.ColorMap[863] = [CCAppleBrownLight24]::new() # End Row 17
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Finished filling the Color Map.')

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Calling CreateSceneImageATString.')
        $this.CreateSceneImageATString($this.ColorMap)
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Nulling the Color Map.')
        $this.ColorMap = $null
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }
}

Class SIFieldSouthWestRoad : SIInternalBase {
    SIFieldSouthWestRoad(): base() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entering the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Updating the Progress Bar for the Scene Image Progress.')
        Write-Progress -Activity 'Creating Scene Images      ' -Id 3 -Status 'Creating SIFieldSouthWestRoad' -PercentComplete -1
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Filling the Color Map.')
        $this.ColorMap[0]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[1]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[2]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[3]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[4]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[5]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[6]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[7]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[8]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[9]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[10]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[11]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[12]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[13]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[14]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[15]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[16]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[17]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[18]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[19]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[20]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[21]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[22]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[23]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[24]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[25]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[26]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[27]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[28]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[29]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[30]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[31]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[32]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[33]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[34]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[35]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[36]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[37]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[38]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[39]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[40]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[41]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[42]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[43]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[44]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[45]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[46]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[47]  = [CCAppleBlueLight24]::new() # End Row 0
        $this.ColorMap[48]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[49]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[50]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[51]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[52]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[53]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[54]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[55]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[56]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[57]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[58]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[59]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[60]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[61]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[62]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[63]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[64]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[65]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[66]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[67]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[68]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[69]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[70]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[71]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[72]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[73]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[74]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[75]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[76]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[77]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[78]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[79]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[80]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[81]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[82]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[83]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[84]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[85]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[86]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[87]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[88]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[89]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[90]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[91]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[92]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[93]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[94]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[95]  = [CCAppleBlueLight24]::new() # End Row 1
        $this.ColorMap[96]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[97]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[98]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[99]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[100] = [CCAppleBlueLight24]::new()
        $this.ColorMap[101] = [CCAppleBlueLight24]::new()
        $this.ColorMap[102] = [CCAppleBlueLight24]::new()
        $this.ColorMap[103] = [CCAppleBlueLight24]::new()
        $this.ColorMap[104] = [CCAppleBlueLight24]::new()
        $this.ColorMap[105] = [CCAppleBlueLight24]::new()
        $this.ColorMap[106] = [CCAppleBlueLight24]::new()
        $this.ColorMap[107] = [CCAppleBlueLight24]::new()
        $this.ColorMap[108] = [CCAppleBlueLight24]::new()
        $this.ColorMap[109] = [CCAppleBlueLight24]::new()
        $this.ColorMap[110] = [CCAppleBlueLight24]::new()
        $this.ColorMap[111] = [CCAppleBlueLight24]::new()
        $this.ColorMap[112] = [CCAppleBlueLight24]::new()
        $this.ColorMap[113] = [CCAppleBlueLight24]::new()
        $this.ColorMap[114] = [CCAppleBlueLight24]::new()
        $this.ColorMap[115] = [CCAppleBlueLight24]::new()
        $this.ColorMap[116] = [CCAppleBlueLight24]::new()
        $this.ColorMap[117] = [CCAppleBlueLight24]::new()
        $this.ColorMap[118] = [CCAppleBlueLight24]::new()
        $this.ColorMap[119] = [CCAppleBlueLight24]::new()
        $this.ColorMap[120] = [CCAppleBlueLight24]::new()
        $this.ColorMap[121] = [CCAppleBlueLight24]::new()
        $this.ColorMap[122] = [CCAppleBlueLight24]::new()
        $this.ColorMap[123] = [CCAppleBlueLight24]::new()
        $this.ColorMap[124] = [CCAppleBlueLight24]::new()
        $this.ColorMap[125] = [CCAppleBlueLight24]::new()
        $this.ColorMap[126] = [CCAppleBlueLight24]::new()
        $this.ColorMap[127] = [CCAppleBlueLight24]::new()
        $this.ColorMap[128] = [CCAppleBlueLight24]::new()
        $this.ColorMap[129] = [CCAppleBlueLight24]::new()
        $this.ColorMap[130] = [CCAppleBlueLight24]::new()
        $this.ColorMap[131] = [CCAppleBlueLight24]::new()
        $this.ColorMap[132] = [CCAppleBlueLight24]::new()
        $this.ColorMap[133] = [CCAppleBlueLight24]::new()
        $this.ColorMap[134] = [CCAppleBlueLight24]::new()
        $this.ColorMap[135] = [CCAppleBlueLight24]::new()
        $this.ColorMap[136] = [CCAppleBlueLight24]::new()
        $this.ColorMap[137] = [CCAppleBlueLight24]::new()
        $this.ColorMap[138] = [CCAppleBlueLight24]::new()
        $this.ColorMap[139] = [CCAppleBlueLight24]::new()
        $this.ColorMap[140] = [CCAppleBlueLight24]::new()
        $this.ColorMap[141] = [CCAppleBlueLight24]::new()
        $this.ColorMap[142] = [CCAppleBlueLight24]::new()
        $this.ColorMap[143] = [CCAppleBlueLight24]::new() # End Row 2
        $this.ColorMap[144] = [CCAppleBlueLight24]::new()
        $this.ColorMap[145] = [CCAppleBlueLight24]::new()
        $this.ColorMap[146] = [CCAppleBlueLight24]::new()
        $this.ColorMap[147] = [CCAppleBlueLight24]::new()
        $this.ColorMap[148] = [CCAppleBlueLight24]::new()
        $this.ColorMap[149] = [CCAppleBlueLight24]::new()
        $this.ColorMap[150] = [CCAppleBlueLight24]::new()
        $this.ColorMap[151] = [CCAppleBlueLight24]::new()
        $this.ColorMap[152] = [CCAppleBlueLight24]::new()
        $this.ColorMap[153] = [CCAppleBlueLight24]::new()
        $this.ColorMap[154] = [CCAppleBlueLight24]::new()
        $this.ColorMap[155] = [CCAppleBlueLight24]::new()
        $this.ColorMap[156] = [CCAppleBlueLight24]::new()
        $this.ColorMap[157] = [CCAppleBlueLight24]::new()
        $this.ColorMap[158] = [CCAppleBlueLight24]::new()
        $this.ColorMap[159] = [CCAppleBlueLight24]::new()
        $this.ColorMap[160] = [CCAppleBlueLight24]::new()
        $this.ColorMap[161] = [CCAppleBlueLight24]::new()
        $this.ColorMap[162] = [CCAppleBlueLight24]::new()
        $this.ColorMap[163] = [CCAppleBlueLight24]::new()
        $this.ColorMap[164] = [CCAppleBlueLight24]::new()
        $this.ColorMap[165] = [CCAppleBlueLight24]::new()
        $this.ColorMap[166] = [CCAppleBlueLight24]::new()
        $this.ColorMap[167] = [CCAppleBlueLight24]::new()
        $this.ColorMap[168] = [CCAppleBlueLight24]::new()
        $this.ColorMap[169] = [CCAppleBlueLight24]::new()
        $this.ColorMap[170] = [CCAppleBlueLight24]::new()
        $this.ColorMap[171] = [CCAppleBlueLight24]::new()
        $this.ColorMap[172] = [CCAppleBlueLight24]::new()
        $this.ColorMap[173] = [CCAppleBlueLight24]::new()
        $this.ColorMap[174] = [CCAppleBlueLight24]::new()
        $this.ColorMap[175] = [CCAppleBlueLight24]::new()
        $this.ColorMap[176] = [CCAppleBlueLight24]::new()
        $this.ColorMap[177] = [CCAppleBlueLight24]::new()
        $this.ColorMap[178] = [CCAppleBlueLight24]::new()
        $this.ColorMap[179] = [CCAppleBlueLight24]::new()
        $this.ColorMap[180] = [CCAppleBlueLight24]::new()
        $this.ColorMap[181] = [CCAppleBlueLight24]::new()
        $this.ColorMap[182] = [CCAppleBlueLight24]::new()
        $this.ColorMap[183] = [CCAppleBlueLight24]::new()
        $this.ColorMap[184] = [CCAppleBlueLight24]::new()
        $this.ColorMap[185] = [CCAppleBlueLight24]::new()
        $this.ColorMap[186] = [CCAppleBlueLight24]::new()
        $this.ColorMap[187] = [CCAppleBlueLight24]::new()
        $this.ColorMap[188] = [CCAppleBlueLight24]::new()
        $this.ColorMap[189] = [CCAppleBlueLight24]::new()
        $this.ColorMap[190] = [CCAppleBlueLight24]::new()
        $this.ColorMap[191] = [CCAppleBlueLight24]::new() # End Row 3
        $this.ColorMap[192] = [CCAppleBlueLight24]::new()
        $this.ColorMap[193] = [CCAppleBlueLight24]::new()
        $this.ColorMap[194] = [CCAppleBlueLight24]::new()
        $this.ColorMap[195] = [CCAppleBlueLight24]::new()
        $this.ColorMap[196] = [CCAppleBlueLight24]::new()
        $this.ColorMap[197] = [CCAppleBlueLight24]::new()
        $this.ColorMap[198] = [CCAppleBlueLight24]::new()
        $this.ColorMap[199] = [CCAppleBlueLight24]::new()
        $this.ColorMap[200] = [CCAppleBlueLight24]::new()
        $this.ColorMap[201] = [CCAppleBlueLight24]::new()
        $this.ColorMap[202] = [CCAppleBlueLight24]::new()
        $this.ColorMap[203] = [CCAppleBlueLight24]::new()
        $this.ColorMap[204] = [CCAppleBlueLight24]::new()
        $this.ColorMap[205] = [CCAppleBlueLight24]::new()
        $this.ColorMap[206] = [CCAppleBlueLight24]::new()
        $this.ColorMap[207] = [CCAppleBlueLight24]::new()
        $this.ColorMap[208] = [CCAppleBlueLight24]::new()
        $this.ColorMap[209] = [CCAppleBlueLight24]::new()
        $this.ColorMap[210] = [CCAppleBlueLight24]::new()
        $this.ColorMap[211] = [CCAppleBlueLight24]::new()
        $this.ColorMap[212] = [CCAppleBlueLight24]::new()
        $this.ColorMap[213] = [CCAppleBlueLight24]::new()
        $this.ColorMap[214] = [CCAppleBlueLight24]::new()
        $this.ColorMap[215] = [CCAppleBlueLight24]::new()
        $this.ColorMap[216] = [CCAppleBlueLight24]::new()
        $this.ColorMap[217] = [CCAppleBlueLight24]::new()
        $this.ColorMap[218] = [CCAppleBlueLight24]::new()
        $this.ColorMap[219] = [CCAppleBlueLight24]::new()
        $this.ColorMap[220] = [CCAppleBlueLight24]::new()
        $this.ColorMap[221] = [CCAppleBlueLight24]::new()
        $this.ColorMap[222] = [CCAppleBlueLight24]::new()
        $this.ColorMap[223] = [CCAppleBlueLight24]::new()
        $this.ColorMap[224] = [CCAppleBlueLight24]::new()
        $this.ColorMap[225] = [CCAppleBlueLight24]::new()
        $this.ColorMap[226] = [CCAppleBlueLight24]::new()
        $this.ColorMap[227] = [CCAppleBlueLight24]::new()
        $this.ColorMap[228] = [CCAppleBlueLight24]::new()
        $this.ColorMap[229] = [CCAppleBlueLight24]::new()
        $this.ColorMap[230] = [CCAppleBlueLight24]::new()
        $this.ColorMap[231] = [CCAppleBlueLight24]::new()
        $this.ColorMap[232] = [CCAppleBlueLight24]::new()
        $this.ColorMap[233] = [CCAppleBlueLight24]::new()
        $this.ColorMap[234] = [CCAppleBlueLight24]::new()
        $this.ColorMap[235] = [CCAppleBlueLight24]::new()
        $this.ColorMap[236] = [CCAppleBlueLight24]::new()
        $this.ColorMap[237] = [CCAppleBlueLight24]::new()
        $this.ColorMap[238] = [CCAppleBlueLight24]::new()
        $this.ColorMap[239] = [CCAppleBlueLight24]::new() # End Row 4
        $this.ColorMap[240] = [CCAppleGreenLight24]::new()
        $this.ColorMap[241] = [CCAppleGreenLight24]::new()
        $this.ColorMap[242] = [CCAppleGreenLight24]::new()
        $this.ColorMap[243] = [CCAppleGreenLight24]::new()
        $this.ColorMap[244] = [CCAppleGreenLight24]::new()
        $this.ColorMap[245] = [CCAppleGreenLight24]::new()
        $this.ColorMap[246] = [CCAppleGreenLight24]::new()
        $this.ColorMap[247] = [CCAppleGreenLight24]::new()
        $this.ColorMap[248] = [CCAppleGreenLight24]::new()
        $this.ColorMap[249] = [CCAppleGreenLight24]::new()
        $this.ColorMap[250] = [CCAppleGreenLight24]::new()
        $this.ColorMap[251] = [CCAppleGreenLight24]::new()
        $this.ColorMap[252] = [CCAppleGreenLight24]::new()
        $this.ColorMap[253] = [CCAppleGreenLight24]::new()
        $this.ColorMap[254] = [CCAppleGreenLight24]::new()
        $this.ColorMap[255] = [CCAppleGreenLight24]::new()
        $this.ColorMap[256] = [CCAppleGreenLight24]::new()
        $this.ColorMap[257] = [CCAppleGreenLight24]::new()
        $this.ColorMap[258] = [CCAppleGreenLight24]::new()
        $this.ColorMap[259] = [CCAppleGreenLight24]::new()
        $this.ColorMap[260] = [CCAppleGreenLight24]::new()
        $this.ColorMap[261] = [CCAppleGreenLight24]::new()
        $this.ColorMap[262] = [CCAppleGreenLight24]::new()
        $this.ColorMap[263] = [CCAppleGreenLight24]::new()
        $this.ColorMap[264] = [CCAppleGreenLight24]::new()
        $this.ColorMap[265] = [CCAppleGreenLight24]::new()
        $this.ColorMap[266] = [CCAppleGreenLight24]::new()
        $this.ColorMap[267] = [CCAppleGreenLight24]::new()
        $this.ColorMap[268] = [CCAppleGreenLight24]::new()
        $this.ColorMap[269] = [CCAppleGreenLight24]::new()
        $this.ColorMap[270] = [CCAppleGreenLight24]::new()
        $this.ColorMap[271] = [CCAppleGreenLight24]::new()
        $this.ColorMap[272] = [CCAppleGreenLight24]::new()
        $this.ColorMap[273] = [CCAppleGreenLight24]::new()
        $this.ColorMap[274] = [CCAppleGreenLight24]::new()
        $this.ColorMap[275] = [CCAppleGreenLight24]::new()
        $this.ColorMap[276] = [CCAppleGreenLight24]::new()
        $this.ColorMap[277] = [CCAppleGreenLight24]::new()
        $this.ColorMap[278] = [CCAppleGreenLight24]::new()
        $this.ColorMap[279] = [CCAppleGreenLight24]::new()
        $this.ColorMap[280] = [CCAppleGreenLight24]::new()
        $this.ColorMap[281] = [CCAppleGreenLight24]::new()
        $this.ColorMap[282] = [CCAppleGreenLight24]::new()
        $this.ColorMap[283] = [CCAppleGreenLight24]::new()
        $this.ColorMap[284] = [CCAppleGreenLight24]::new()
        $this.ColorMap[285] = [CCAppleGreenLight24]::new()
        $this.ColorMap[286] = [CCAppleGreenLight24]::new()
        $this.ColorMap[287] = [CCAppleGreenLight24]::new() # End Row 5
        $this.ColorMap[288] = [CCAppleGreenLight24]::new()
        $this.ColorMap[289] = [CCAppleGreenLight24]::new()
        $this.ColorMap[290] = [CCAppleGreenLight24]::new()
        $this.ColorMap[291] = [CCAppleGreenLight24]::new()
        $this.ColorMap[292] = [CCAppleGreenLight24]::new()
        $this.ColorMap[293] = [CCAppleGreenLight24]::new()
        $this.ColorMap[294] = [CCAppleGreenLight24]::new()
        $this.ColorMap[295] = [CCAppleGreenLight24]::new()
        $this.ColorMap[296] = [CCAppleGreenLight24]::new()
        $this.ColorMap[297] = [CCAppleGreenLight24]::new()
        $this.ColorMap[298] = [CCAppleGreenLight24]::new()
        $this.ColorMap[299] = [CCAppleGreenLight24]::new()
        $this.ColorMap[300] = [CCAppleGreenLight24]::new()
        $this.ColorMap[301] = [CCAppleGreenLight24]::new()
        $this.ColorMap[302] = [CCAppleGreenLight24]::new()
        $this.ColorMap[303] = [CCAppleGreenLight24]::new()
        $this.ColorMap[304] = [CCAppleGreenLight24]::new()
        $this.ColorMap[305] = [CCAppleGreenLight24]::new()
        $this.ColorMap[306] = [CCAppleGreenLight24]::new()
        $this.ColorMap[307] = [CCAppleGreenLight24]::new()
        $this.ColorMap[308] = [CCAppleGreenLight24]::new()
        $this.ColorMap[309] = [CCAppleGreenLight24]::new()
        $this.ColorMap[310] = [CCAppleGreenLight24]::new()
        $this.ColorMap[311] = [CCAppleGreenLight24]::new()
        $this.ColorMap[312] = [CCAppleGreenLight24]::new()
        $this.ColorMap[313] = [CCAppleGreenLight24]::new()
        $this.ColorMap[314] = [CCAppleGreenLight24]::new()
        $this.ColorMap[315] = [CCAppleGreenLight24]::new()
        $this.ColorMap[316] = [CCAppleGreenLight24]::new()
        $this.ColorMap[317] = [CCAppleGreenLight24]::new()
        $this.ColorMap[318] = [CCAppleGreenLight24]::new()
        $this.ColorMap[319] = [CCAppleGreenLight24]::new()
        $this.ColorMap[320] = [CCAppleGreenLight24]::new()
        $this.ColorMap[321] = [CCAppleGreenLight24]::new()
        $this.ColorMap[322] = [CCAppleGreenLight24]::new()
        $this.ColorMap[323] = [CCAppleGreenLight24]::new()
        $this.ColorMap[324] = [CCAppleGreenLight24]::new()
        $this.ColorMap[325] = [CCAppleGreenLight24]::new()
        $this.ColorMap[326] = [CCAppleGreenLight24]::new()
        $this.ColorMap[327] = [CCAppleGreenLight24]::new()
        $this.ColorMap[328] = [CCAppleGreenLight24]::new()
        $this.ColorMap[329] = [CCAppleGreenLight24]::new()
        $this.ColorMap[330] = [CCAppleGreenLight24]::new()
        $this.ColorMap[331] = [CCAppleGreenLight24]::new()
        $this.ColorMap[332] = [CCAppleGreenLight24]::new()
        $this.ColorMap[333] = [CCAppleGreenLight24]::new()
        $this.ColorMap[334] = [CCAppleGreenLight24]::new()
        $this.ColorMap[335] = [CCAppleGreenLight24]::new() # End Row 6
        $this.ColorMap[336] = [CCAppleGreenLight24]::new()
        $this.ColorMap[337] = [CCAppleGreenLight24]::new()
        $this.ColorMap[338] = [CCAppleGreenLight24]::new()
        $this.ColorMap[339] = [CCAppleGreenLight24]::new()
        $this.ColorMap[340] = [CCAppleGreenLight24]::new()
        $this.ColorMap[341] = [CCAppleGreenLight24]::new()
        $this.ColorMap[342] = [CCAppleGreenLight24]::new()
        $this.ColorMap[343] = [CCAppleGreenLight24]::new()
        $this.ColorMap[344] = [CCAppleGreenLight24]::new()
        $this.ColorMap[345] = [CCAppleGreenLight24]::new()
        $this.ColorMap[346] = [CCAppleGreenLight24]::new()
        $this.ColorMap[347] = [CCAppleGreenLight24]::new()
        $this.ColorMap[348] = [CCAppleGreenLight24]::new()
        $this.ColorMap[349] = [CCAppleGreenLight24]::new()
        $this.ColorMap[350] = [CCAppleGreenLight24]::new()
        $this.ColorMap[351] = [CCAppleGreenLight24]::new()
        $this.ColorMap[352] = [CCAppleGreenLight24]::new()
        $this.ColorMap[353] = [CCAppleGreenLight24]::new()
        $this.ColorMap[354] = [CCAppleGreenLight24]::new()
        $this.ColorMap[355] = [CCAppleGreenLight24]::new()
        $this.ColorMap[356] = [CCAppleGreenLight24]::new()
        $this.ColorMap[357] = [CCAppleGreenLight24]::new()
        $this.ColorMap[358] = [CCAppleGreenLight24]::new()
        $this.ColorMap[359] = [CCAppleGreenLight24]::new()
        $this.ColorMap[360] = [CCAppleGreenLight24]::new()
        $this.ColorMap[361] = [CCAppleGreenLight24]::new()
        $this.ColorMap[362] = [CCAppleGreenLight24]::new()
        $this.ColorMap[363] = [CCAppleGreenLight24]::new()
        $this.ColorMap[364] = [CCAppleGreenLight24]::new()
        $this.ColorMap[365] = [CCAppleGreenLight24]::new()
        $this.ColorMap[366] = [CCAppleGreenLight24]::new()
        $this.ColorMap[367] = [CCAppleGreenLight24]::new()
        $this.ColorMap[368] = [CCAppleGreenLight24]::new()
        $this.ColorMap[369] = [CCAppleGreenLight24]::new()
        $this.ColorMap[370] = [CCAppleGreenLight24]::new()
        $this.ColorMap[371] = [CCAppleGreenLight24]::new()
        $this.ColorMap[372] = [CCAppleGreenLight24]::new()
        $this.ColorMap[373] = [CCAppleGreenLight24]::new()
        $this.ColorMap[374] = [CCAppleGreenLight24]::new()
        $this.ColorMap[375] = [CCAppleGreenLight24]::new()
        $this.ColorMap[376] = [CCAppleGreenLight24]::new()
        $this.ColorMap[377] = [CCAppleGreenLight24]::new()
        $this.ColorMap[378] = [CCAppleGreenLight24]::new()
        $this.ColorMap[379] = [CCAppleGreenLight24]::new()
        $this.ColorMap[380] = [CCAppleGreenLight24]::new()
        $this.ColorMap[381] = [CCAppleGreenLight24]::new()
        $this.ColorMap[382] = [CCAppleGreenLight24]::new()
        $this.ColorMap[383] = [CCAppleGreenLight24]::new() # End Row 7
        $this.ColorMap[384] = [CCAppleGreenLight24]::new()
        $this.ColorMap[385] = [CCAppleGreenLight24]::new()
        $this.ColorMap[386] = [CCAppleGreenLight24]::new()
        $this.ColorMap[387] = [CCAppleGreenLight24]::new()
        $this.ColorMap[388] = [CCAppleGreenLight24]::new()
        $this.ColorMap[389] = [CCAppleGreenLight24]::new()
        $this.ColorMap[390] = [CCAppleGreenLight24]::new()
        $this.ColorMap[391] = [CCAppleGreenLight24]::new()
        $this.ColorMap[392] = [CCAppleGreenLight24]::new()
        $this.ColorMap[393] = [CCAppleGreenLight24]::new()
        $this.ColorMap[394] = [CCAppleGreenLight24]::new()
        $this.ColorMap[395] = [CCAppleGreenLight24]::new()
        $this.ColorMap[396] = [CCAppleGreenLight24]::new()
        $this.ColorMap[397] = [CCAppleGreenLight24]::new()
        $this.ColorMap[398] = [CCAppleGreenLight24]::new()
        $this.ColorMap[399] = [CCAppleGreenLight24]::new()
        $this.ColorMap[400] = [CCAppleGreenLight24]::new()
        $this.ColorMap[401] = [CCAppleGreenLight24]::new()
        $this.ColorMap[402] = [CCAppleGreenLight24]::new()
        $this.ColorMap[403] = [CCAppleGreenLight24]::new()
        $this.ColorMap[404] = [CCAppleGreenLight24]::new()
        $this.ColorMap[405] = [CCAppleGreenLight24]::new()
        $this.ColorMap[406] = [CCAppleBrownLight24]::new()
        $this.ColorMap[407] = [CCAppleBrownLight24]::new()
        $this.ColorMap[408] = [CCAppleBrownLight24]::new()
        $this.ColorMap[409] = [CCAppleBrownLight24]::new()
        $this.ColorMap[410] = [CCAppleBrownLight24]::new()
        $this.ColorMap[411] = [CCAppleGreenLight24]::new()
        $this.ColorMap[412] = [CCAppleGreenLight24]::new()
        $this.ColorMap[413] = [CCAppleGreenLight24]::new()
        $this.ColorMap[414] = [CCAppleGreenLight24]::new()
        $this.ColorMap[415] = [CCAppleGreenLight24]::new()
        $this.ColorMap[416] = [CCAppleGreenLight24]::new()
        $this.ColorMap[417] = [CCAppleGreenLight24]::new()
        $this.ColorMap[418] = [CCAppleGreenLight24]::new()
        $this.ColorMap[419] = [CCAppleGreenLight24]::new()
        $this.ColorMap[420] = [CCAppleGreenLight24]::new()
        $this.ColorMap[421] = [CCAppleGreenLight24]::new()
        $this.ColorMap[422] = [CCAppleGreenLight24]::new()
        $this.ColorMap[423] = [CCAppleGreenLight24]::new()
        $this.ColorMap[424] = [CCAppleGreenLight24]::new()
        $this.ColorMap[425] = [CCAppleGreenLight24]::new()
        $this.ColorMap[426] = [CCAppleGreenLight24]::new()
        $this.ColorMap[427] = [CCAppleGreenLight24]::new()
        $this.ColorMap[428] = [CCAppleGreenLight24]::new()
        $this.ColorMap[429] = [CCAppleGreenLight24]::new()
        $this.ColorMap[430] = [CCAppleGreenLight24]::new()
        $this.ColorMap[431] = [CCAppleGreenLight24]::new() # End Row 8
        $this.ColorMap[432] = [CCAppleGreenLight24]::new()
        $this.ColorMap[433] = [CCAppleGreenLight24]::new()
        $this.ColorMap[434] = [CCAppleGreenLight24]::new()
        $this.ColorMap[435] = [CCAppleGreenLight24]::new()
        $this.ColorMap[436] = [CCAppleGreenLight24]::new()
        $this.ColorMap[437] = [CCAppleGreenLight24]::new()
        $this.ColorMap[438] = [CCAppleGreenLight24]::new()
        $this.ColorMap[439] = [CCAppleGreenLight24]::new()
        $this.ColorMap[440] = [CCAppleGreenLight24]::new()
        $this.ColorMap[441] = [CCAppleGreenLight24]::new()
        $this.ColorMap[442] = [CCAppleGreenLight24]::new()
        $this.ColorMap[443] = [CCAppleGreenLight24]::new()
        $this.ColorMap[444] = [CCAppleGreenLight24]::new()
        $this.ColorMap[445] = [CCAppleGreenLight24]::new()
        $this.ColorMap[446] = [CCAppleGreenLight24]::new()
        $this.ColorMap[447] = [CCAppleGreenLight24]::new()
        $this.ColorMap[448] = [CCAppleGreenLight24]::new()
        $this.ColorMap[449] = [CCAppleGreenLight24]::new()
        $this.ColorMap[450] = [CCAppleGreenLight24]::new()
        $this.ColorMap[451] = [CCAppleGreenLight24]::new()
        $this.ColorMap[452] = [CCAppleGreenLight24]::new()
        $this.ColorMap[453] = [CCAppleGreenLight24]::new()
        $this.ColorMap[454] = [CCAppleBrownLight24]::new()
        $this.ColorMap[455] = [CCAppleBrownLight24]::new()
        $this.ColorMap[456] = [CCAppleBrownLight24]::new()
        $this.ColorMap[457] = [CCAppleBrownLight24]::new()
        $this.ColorMap[458] = [CCAppleBrownLight24]::new()
        $this.ColorMap[459] = [CCAppleGreenLight24]::new()
        $this.ColorMap[460] = [CCAppleGreenLight24]::new()
        $this.ColorMap[461] = [CCAppleGreenLight24]::new()
        $this.ColorMap[462] = [CCAppleGreenLight24]::new()
        $this.ColorMap[463] = [CCAppleGreenLight24]::new()
        $this.ColorMap[464] = [CCAppleGreenLight24]::new()
        $this.ColorMap[465] = [CCAppleGreenLight24]::new()
        $this.ColorMap[466] = [CCAppleGreenLight24]::new()
        $this.ColorMap[467] = [CCAppleGreenLight24]::new()
        $this.ColorMap[468] = [CCAppleGreenLight24]::new()
        $this.ColorMap[469] = [CCAppleGreenLight24]::new()
        $this.ColorMap[470] = [CCAppleGreenLight24]::new()
        $this.ColorMap[471] = [CCAppleGreenLight24]::new()
        $this.ColorMap[472] = [CCAppleGreenLight24]::new()
        $this.ColorMap[473] = [CCAppleGreenLight24]::new()
        $this.ColorMap[474] = [CCAppleGreenLight24]::new()
        $this.ColorMap[475] = [CCAppleGreenLight24]::new()
        $this.ColorMap[476] = [CCAppleGreenLight24]::new()
        $this.ColorMap[477] = [CCAppleGreenLight24]::new()
        $this.ColorMap[478] = [CCAppleGreenLight24]::new()
        $this.ColorMap[479] = [CCAppleGreenLight24]::new() # End Row 9
        $this.ColorMap[480] = [CCAppleGreenLight24]::new()
        $this.ColorMap[481] = [CCAppleGreenLight24]::new()
        $this.ColorMap[482] = [CCAppleGreenLight24]::new()
        $this.ColorMap[483] = [CCAppleGreenLight24]::new()
        $this.ColorMap[484] = [CCAppleGreenLight24]::new()
        $this.ColorMap[485] = [CCAppleGreenLight24]::new()
        $this.ColorMap[486] = [CCAppleGreenLight24]::new()
        $this.ColorMap[487] = [CCAppleGreenLight24]::new()
        $this.ColorMap[488] = [CCAppleGreenLight24]::new()
        $this.ColorMap[489] = [CCAppleGreenLight24]::new()
        $this.ColorMap[490] = [CCAppleGreenLight24]::new()
        $this.ColorMap[491] = [CCAppleGreenLight24]::new()
        $this.ColorMap[492] = [CCAppleGreenLight24]::new()
        $this.ColorMap[493] = [CCAppleGreenLight24]::new()
        $this.ColorMap[494] = [CCAppleGreenLight24]::new()
        $this.ColorMap[495] = [CCAppleGreenLight24]::new()
        $this.ColorMap[496] = [CCAppleGreenLight24]::new()
        $this.ColorMap[497] = [CCAppleGreenLight24]::new()
        $this.ColorMap[498] = [CCAppleGreenLight24]::new()
        $this.ColorMap[499] = [CCAppleGreenLight24]::new()
        $this.ColorMap[500] = [CCAppleGreenLight24]::new()
        $this.ColorMap[501] = [CCAppleBrownLight24]::new()
        $this.ColorMap[502] = [CCAppleBrownLight24]::new()
        $this.ColorMap[503] = [CCAppleBrownLight24]::new()
        $this.ColorMap[504] = [CCAppleBrownLight24]::new()
        $this.ColorMap[505] = [CCAppleBrownLight24]::new()
        $this.ColorMap[506] = [CCAppleBrownLight24]::new()
        $this.ColorMap[507] = [CCAppleBrownLight24]::new()
        $this.ColorMap[508] = [CCAppleGreenLight24]::new()
        $this.ColorMap[509] = [CCAppleGreenLight24]::new()
        $this.ColorMap[510] = [CCAppleGreenLight24]::new()
        $this.ColorMap[511] = [CCAppleGreenLight24]::new()
        $this.ColorMap[512] = [CCAppleGreenLight24]::new()
        $this.ColorMap[513] = [CCAppleGreenLight24]::new()
        $this.ColorMap[514] = [CCAppleGreenLight24]::new()
        $this.ColorMap[515] = [CCAppleGreenLight24]::new()
        $this.ColorMap[516] = [CCAppleGreenLight24]::new()
        $this.ColorMap[517] = [CCAppleGreenLight24]::new()
        $this.ColorMap[518] = [CCAppleGreenLight24]::new()
        $this.ColorMap[519] = [CCAppleGreenLight24]::new()
        $this.ColorMap[520] = [CCAppleGreenLight24]::new()
        $this.ColorMap[521] = [CCAppleGreenLight24]::new()
        $this.ColorMap[522] = [CCAppleGreenLight24]::new()
        $this.ColorMap[523] = [CCAppleGreenLight24]::new()
        $this.ColorMap[524] = [CCAppleGreenLight24]::new()
        $this.ColorMap[525] = [CCAppleGreenLight24]::new()
        $this.ColorMap[526] = [CCAppleGreenLight24]::new()
        $this.ColorMap[527] = [CCAppleGreenLight24]::new() # End Row 10
        $this.ColorMap[528] = [CCAppleGreenLight24]::new()
        $this.ColorMap[529] = [CCAppleGreenLight24]::new()
        $this.ColorMap[530] = [CCAppleGreenLight24]::new()
        $this.ColorMap[531] = [CCAppleGreenLight24]::new()
        $this.ColorMap[532] = [CCAppleGreenLight24]::new()
        $this.ColorMap[533] = [CCAppleGreenLight24]::new()
        $this.ColorMap[534] = [CCAppleGreenLight24]::new()
        $this.ColorMap[535] = [CCAppleGreenLight24]::new()
        $this.ColorMap[536] = [CCAppleGreenLight24]::new()
        $this.ColorMap[537] = [CCAppleGreenLight24]::new()
        $this.ColorMap[538] = [CCAppleGreenLight24]::new()
        $this.ColorMap[539] = [CCAppleGreenLight24]::new()
        $this.ColorMap[540] = [CCAppleGreenLight24]::new()
        $this.ColorMap[541] = [CCAppleGreenLight24]::new()
        $this.ColorMap[542] = [CCAppleGreenLight24]::new()
        $this.ColorMap[543] = [CCAppleGreenLight24]::new()
        $this.ColorMap[544] = [CCAppleGreenLight24]::new()
        $this.ColorMap[545] = [CCAppleGreenLight24]::new()
        $this.ColorMap[546] = [CCAppleGreenLight24]::new()
        $this.ColorMap[547] = [CCAppleGreenLight24]::new()
        $this.ColorMap[548] = [CCAppleGreenLight24]::new()
        $this.ColorMap[549] = [CCAppleBrownLight24]::new()
        $this.ColorMap[550] = [CCAppleBrownLight24]::new()
        $this.ColorMap[551] = [CCAppleBrownLight24]::new()
        $this.ColorMap[552] = [CCAppleBrownLight24]::new()
        $this.ColorMap[553] = [CCAppleBrownLight24]::new()
        $this.ColorMap[554] = [CCAppleBrownLight24]::new()
        $this.ColorMap[555] = [CCAppleBrownLight24]::new()
        $this.ColorMap[556] = [CCAppleGreenLight24]::new()
        $this.ColorMap[557] = [CCAppleGreenLight24]::new()
        $this.ColorMap[558] = [CCAppleGreenLight24]::new()
        $this.ColorMap[559] = [CCAppleGreenLight24]::new()
        $this.ColorMap[560] = [CCAppleGreenLight24]::new()
        $this.ColorMap[561] = [CCAppleGreenLight24]::new()
        $this.ColorMap[562] = [CCAppleGreenLight24]::new()
        $this.ColorMap[563] = [CCAppleGreenLight24]::new()
        $this.ColorMap[564] = [CCAppleGreenLight24]::new()
        $this.ColorMap[565] = [CCAppleGreenLight24]::new()
        $this.ColorMap[566] = [CCAppleGreenLight24]::new()
        $this.ColorMap[567] = [CCAppleGreenLight24]::new()
        $this.ColorMap[568] = [CCAppleGreenLight24]::new()
        $this.ColorMap[569] = [CCAppleGreenLight24]::new()
        $this.ColorMap[570] = [CCAppleGreenLight24]::new()
        $this.ColorMap[571] = [CCAppleGreenLight24]::new()
        $this.ColorMap[572] = [CCAppleGreenLight24]::new()
        $this.ColorMap[573] = [CCAppleGreenLight24]::new()
        $this.ColorMap[574] = [CCAppleGreenLight24]::new()
        $this.ColorMap[575] = [CCAppleGreenLight24]::new() # End Row 11
        $this.ColorMap[576] = [CCAppleGreenLight24]::new()
        $this.ColorMap[577] = [CCAppleGreenLight24]::new()
        $this.ColorMap[578] = [CCAppleGreenLight24]::new()
        $this.ColorMap[579] = [CCAppleGreenLight24]::new()
        $this.ColorMap[580] = [CCAppleGreenLight24]::new()
        $this.ColorMap[581] = [CCAppleGreenLight24]::new()
        $this.ColorMap[582] = [CCAppleGreenLight24]::new()
        $this.ColorMap[583] = [CCAppleGreenLight24]::new()
        $this.ColorMap[584] = [CCAppleGreenLight24]::new()
        $this.ColorMap[585] = [CCAppleGreenLight24]::new()
        $this.ColorMap[586] = [CCAppleGreenLight24]::new()
        $this.ColorMap[587] = [CCAppleGreenLight24]::new()
        $this.ColorMap[588] = [CCAppleGreenLight24]::new()
        $this.ColorMap[589] = [CCAppleGreenLight24]::new()
        $this.ColorMap[590] = [CCAppleGreenLight24]::new()
        $this.ColorMap[591] = [CCAppleGreenLight24]::new()
        $this.ColorMap[592] = [CCAppleGreenLight24]::new()
        $this.ColorMap[593] = [CCAppleGreenLight24]::new()
        $this.ColorMap[594] = [CCAppleGreenLight24]::new()
        $this.ColorMap[595] = [CCAppleGreenLight24]::new()
        $this.ColorMap[596] = [CCAppleGreenLight24]::new()
        $this.ColorMap[597] = [CCAppleBrownLight24]::new()
        $this.ColorMap[598] = [CCAppleBrownLight24]::new()
        $this.ColorMap[599] = [CCAppleBrownLight24]::new()
        $this.ColorMap[600] = [CCAppleBrownLight24]::new()
        $this.ColorMap[601] = [CCAppleBrownLight24]::new()
        $this.ColorMap[602] = [CCAppleBrownLight24]::new()
        $this.ColorMap[603] = [CCAppleBrownLight24]::new()
        $this.ColorMap[604] = [CCAppleGreenLight24]::new()
        $this.ColorMap[605] = [CCAppleGreenLight24]::new()
        $this.ColorMap[606] = [CCAppleGreenLight24]::new()
        $this.ColorMap[607] = [CCAppleGreenLight24]::new()
        $this.ColorMap[608] = [CCAppleGreenLight24]::new()
        $this.ColorMap[609] = [CCAppleGreenLight24]::new()
        $this.ColorMap[610] = [CCAppleGreenLight24]::new()
        $this.ColorMap[611] = [CCAppleGreenLight24]::new()
        $this.ColorMap[612] = [CCAppleGreenLight24]::new()
        $this.ColorMap[613] = [CCAppleGreenLight24]::new()
        $this.ColorMap[614] = [CCAppleGreenLight24]::new()
        $this.ColorMap[615] = [CCAppleGreenLight24]::new()
        $this.ColorMap[616] = [CCAppleGreenLight24]::new()
        $this.ColorMap[617] = [CCAppleGreenLight24]::new()
        $this.ColorMap[618] = [CCAppleGreenLight24]::new()
        $this.ColorMap[619] = [CCAppleGreenLight24]::new()
        $this.ColorMap[620] = [CCAppleGreenLight24]::new()
        $this.ColorMap[621] = [CCAppleGreenLight24]::new()
        $this.ColorMap[622] = [CCAppleGreenLight24]::new()
        $this.ColorMap[623] = [CCAppleGreenLight24]::new() # End Row 12
        $this.ColorMap[624] = [CCAppleGreenLight24]::new()
        $this.ColorMap[625] = [CCAppleGreenLight24]::new()
        $this.ColorMap[626] = [CCAppleGreenLight24]::new()
        $this.ColorMap[627] = [CCAppleGreenLight24]::new()
        $this.ColorMap[628] = [CCAppleGreenLight24]::new()
        $this.ColorMap[629] = [CCAppleGreenLight24]::new()
        $this.ColorMap[630] = [CCAppleGreenLight24]::new()
        $this.ColorMap[631] = [CCAppleGreenLight24]::new()
        $this.ColorMap[632] = [CCAppleGreenLight24]::new()
        $this.ColorMap[633] = [CCAppleGreenLight24]::new()
        $this.ColorMap[634] = [CCAppleGreenLight24]::new()
        $this.ColorMap[635] = [CCAppleGreenLight24]::new()
        $this.ColorMap[636] = [CCAppleGreenLight24]::new()
        $this.ColorMap[637] = [CCAppleGreenLight24]::new()
        $this.ColorMap[638] = [CCAppleGreenLight24]::new()
        $this.ColorMap[639] = [CCAppleGreenLight24]::new()
        $this.ColorMap[640] = [CCAppleGreenLight24]::new()
        $this.ColorMap[641] = [CCAppleGreenLight24]::new()
        $this.ColorMap[642] = [CCAppleGreenLight24]::new()
        $this.ColorMap[643] = [CCAppleGreenLight24]::new()
        $this.ColorMap[644] = [CCAppleGreenLight24]::new()
        $this.ColorMap[645] = [CCAppleBrownLight24]::new()
        $this.ColorMap[646] = [CCAppleBrownLight24]::new()
        $this.ColorMap[647] = [CCAppleBrownLight24]::new()
        $this.ColorMap[648] = [CCAppleBrownLight24]::new()
        $this.ColorMap[649] = [CCAppleBrownLight24]::new()
        $this.ColorMap[650] = [CCAppleBrownLight24]::new()
        $this.ColorMap[651] = [CCAppleBrownLight24]::new()
        $this.ColorMap[652] = [CCAppleGreenLight24]::new()
        $this.ColorMap[653] = [CCAppleGreenLight24]::new()
        $this.ColorMap[654] = [CCAppleGreenLight24]::new()
        $this.ColorMap[655] = [CCAppleGreenLight24]::new()
        $this.ColorMap[656] = [CCAppleGreenLight24]::new()
        $this.ColorMap[657] = [CCAppleGreenLight24]::new()
        $this.ColorMap[658] = [CCAppleGreenLight24]::new()
        $this.ColorMap[659] = [CCAppleGreenLight24]::new()
        $this.ColorMap[660] = [CCAppleGreenLight24]::new()
        $this.ColorMap[661] = [CCAppleGreenLight24]::new()
        $this.ColorMap[662] = [CCAppleGreenLight24]::new()
        $this.ColorMap[663] = [CCAppleGreenLight24]::new()
        $this.ColorMap[664] = [CCAppleGreenLight24]::new()
        $this.ColorMap[665] = [CCAppleGreenLight24]::new()
        $this.ColorMap[666] = [CCAppleGreenLight24]::new()
        $this.ColorMap[667] = [CCAppleGreenLight24]::new()
        $this.ColorMap[668] = [CCAppleGreenLight24]::new()
        $this.ColorMap[669] = [CCAppleGreenLight24]::new()
        $this.ColorMap[670] = [CCAppleGreenLight24]::new()
        $this.ColorMap[671] = [CCAppleGreenLight24]::new() # End Row 13
        $this.ColorMap[672] = [CCAppleGreenLight24]::new()
        $this.ColorMap[673] = [CCAppleGreenLight24]::new()
        $this.ColorMap[674] = [CCAppleGreenLight24]::new()
        $this.ColorMap[675] = [CCAppleGreenLight24]::new()
        $this.ColorMap[676] = [CCAppleGreenLight24]::new()
        $this.ColorMap[677] = [CCAppleGreenLight24]::new()
        $this.ColorMap[678] = [CCAppleGreenLight24]::new()
        $this.ColorMap[679] = [CCAppleGreenLight24]::new()
        $this.ColorMap[680] = [CCAppleGreenLight24]::new()
        $this.ColorMap[681] = [CCAppleGreenLight24]::new()
        $this.ColorMap[682] = [CCAppleGreenLight24]::new()
        $this.ColorMap[683] = [CCAppleGreenLight24]::new()
        $this.ColorMap[684] = [CCAppleGreenLight24]::new()
        $this.ColorMap[685] = [CCAppleGreenLight24]::new()
        $this.ColorMap[686] = [CCAppleGreenLight24]::new()
        $this.ColorMap[687] = [CCAppleGreenLight24]::new()
        $this.ColorMap[688] = [CCAppleGreenLight24]::new()
        $this.ColorMap[689] = [CCAppleGreenLight24]::new()
        $this.ColorMap[690] = [CCAppleGreenLight24]::new()
        $this.ColorMap[691] = [CCAppleGreenLight24]::new()
        $this.ColorMap[692] = [CCAppleGreenLight24]::new()
        $this.ColorMap[693] = [CCAppleBrownLight24]::new()
        $this.ColorMap[694] = [CCAppleBrownLight24]::new()
        $this.ColorMap[695] = [CCAppleBrownLight24]::new()
        $this.ColorMap[696] = [CCAppleBrownLight24]::new()
        $this.ColorMap[697] = [CCAppleBrownLight24]::new()
        $this.ColorMap[698] = [CCAppleBrownLight24]::new()
        $this.ColorMap[699] = [CCAppleBrownLight24]::new()
        $this.ColorMap[700] = [CCAppleGreenLight24]::new()
        $this.ColorMap[701] = [CCAppleGreenLight24]::new()
        $this.ColorMap[702] = [CCAppleGreenLight24]::new()
        $this.ColorMap[703] = [CCAppleGreenLight24]::new()
        $this.ColorMap[704] = [CCAppleGreenLight24]::new()
        $this.ColorMap[705] = [CCAppleGreenLight24]::new()
        $this.ColorMap[706] = [CCAppleGreenLight24]::new()
        $this.ColorMap[707] = [CCAppleGreenLight24]::new()
        $this.ColorMap[708] = [CCAppleGreenLight24]::new()
        $this.ColorMap[709] = [CCAppleGreenLight24]::new()
        $this.ColorMap[710] = [CCAppleGreenLight24]::new()
        $this.ColorMap[711] = [CCAppleGreenLight24]::new()
        $this.ColorMap[712] = [CCAppleGreenLight24]::new()
        $this.ColorMap[713] = [CCAppleGreenLight24]::new()
        $this.ColorMap[714] = [CCAppleGreenLight24]::new()
        $this.ColorMap[715] = [CCAppleGreenLight24]::new()
        $this.ColorMap[716] = [CCAppleGreenLight24]::new()
        $this.ColorMap[717] = [CCAppleGreenLight24]::new()
        $this.ColorMap[718] = [CCAppleGreenLight24]::new()
        $this.ColorMap[719] = [CCAppleGreenLight24]::new() # End Row 14
        $this.ColorMap[720] = [CCAppleGreenLight24]::new()
        $this.ColorMap[721] = [CCAppleGreenLight24]::new()
        $this.ColorMap[722] = [CCAppleGreenLight24]::new()
        $this.ColorMap[723] = [CCAppleGreenLight24]::new()
        $this.ColorMap[724] = [CCAppleGreenLight24]::new()
        $this.ColorMap[725] = [CCAppleGreenLight24]::new()
        $this.ColorMap[726] = [CCAppleGreenLight24]::new()
        $this.ColorMap[727] = [CCAppleGreenLight24]::new()
        $this.ColorMap[728] = [CCAppleGreenLight24]::new()
        $this.ColorMap[729] = [CCAppleGreenLight24]::new()
        $this.ColorMap[730] = [CCAppleGreenLight24]::new()
        $this.ColorMap[731] = [CCAppleGreenLight24]::new()
        $this.ColorMap[732] = [CCAppleGreenLight24]::new()
        $this.ColorMap[733] = [CCAppleGreenLight24]::new()
        $this.ColorMap[734] = [CCAppleGreenLight24]::new()
        $this.ColorMap[735] = [CCAppleGreenLight24]::new()
        $this.ColorMap[736] = [CCAppleGreenLight24]::new()
        $this.ColorMap[737] = [CCAppleGreenLight24]::new()
        $this.ColorMap[738] = [CCAppleGreenLight24]::new()
        $this.ColorMap[739] = [CCAppleGreenLight24]::new()
        $this.ColorMap[740] = [CCAppleGreenLight24]::new()
        $this.ColorMap[741] = [CCAppleBrownLight24]::new()
        $this.ColorMap[742] = [CCAppleBrownLight24]::new()
        $this.ColorMap[743] = [CCAppleBrownLight24]::new()
        $this.ColorMap[744] = [CCAppleBrownLight24]::new()
        $this.ColorMap[745] = [CCAppleBrownLight24]::new()
        $this.ColorMap[746] = [CCAppleBrownLight24]::new()
        $this.ColorMap[747] = [CCAppleBrownLight24]::new()
        $this.ColorMap[748] = [CCAppleGreenLight24]::new()
        $this.ColorMap[749] = [CCAppleGreenLight24]::new()
        $this.ColorMap[750] = [CCAppleGreenLight24]::new()
        $this.ColorMap[751] = [CCAppleGreenLight24]::new()
        $this.ColorMap[752] = [CCAppleGreenLight24]::new()
        $this.ColorMap[753] = [CCAppleGreenLight24]::new()
        $this.ColorMap[754] = [CCAppleGreenLight24]::new()
        $this.ColorMap[755] = [CCAppleGreenLight24]::new()
        $this.ColorMap[756] = [CCAppleGreenLight24]::new()
        $this.ColorMap[757] = [CCAppleGreenLight24]::new()
        $this.ColorMap[758] = [CCAppleGreenLight24]::new()
        $this.ColorMap[759] = [CCAppleGreenLight24]::new()
        $this.ColorMap[760] = [CCAppleGreenLight24]::new()
        $this.ColorMap[761] = [CCAppleGreenLight24]::new()
        $this.ColorMap[762] = [CCAppleGreenLight24]::new()
        $this.ColorMap[763] = [CCAppleGreenLight24]::new()
        $this.ColorMap[764] = [CCAppleGreenLight24]::new()
        $this.ColorMap[765] = [CCAppleGreenLight24]::new()
        $this.ColorMap[766] = [CCAppleGreenLight24]::new()
        $this.ColorMap[767] = [CCAppleGreenLight24]::new() # End Row 15
        $this.ColorMap[768] = [CCAppleBrownLight24]::new()
        $this.ColorMap[769] = [CCAppleBrownLight24]::new()
        $this.ColorMap[770] = [CCAppleBrownLight24]::new()
        $this.ColorMap[771] = [CCAppleBrownLight24]::new()
        $this.ColorMap[772] = [CCAppleBrownLight24]::new()
        $this.ColorMap[773] = [CCAppleBrownLight24]::new()
        $this.ColorMap[774] = [CCAppleBrownLight24]::new()
        $this.ColorMap[775] = [CCAppleBrownLight24]::new()
        $this.ColorMap[776] = [CCAppleBrownLight24]::new()
        $this.ColorMap[777] = [CCAppleBrownLight24]::new()
        $this.ColorMap[778] = [CCAppleBrownLight24]::new()
        $this.ColorMap[779] = [CCAppleBrownLight24]::new()
        $this.ColorMap[780] = [CCAppleBrownLight24]::new()
        $this.ColorMap[781] = [CCAppleBrownLight24]::new()
        $this.ColorMap[782] = [CCAppleBrownLight24]::new()
        $this.ColorMap[783] = [CCAppleBrownLight24]::new()
        $this.ColorMap[784] = [CCAppleBrownLight24]::new()
        $this.ColorMap[785] = [CCAppleBrownLight24]::new()
        $this.ColorMap[786] = [CCAppleBrownLight24]::new()
        $this.ColorMap[787] = [CCAppleBrownLight24]::new()
        $this.ColorMap[788] = [CCAppleBrownLight24]::new()
        $this.ColorMap[789] = [CCAppleBrownLight24]::new()
        $this.ColorMap[790] = [CCAppleBrownLight24]::new()
        $this.ColorMap[791] = [CCAppleBrownLight24]::new()
        $this.ColorMap[792] = [CCAppleBrownLight24]::new()
        $this.ColorMap[793] = [CCAppleBrownLight24]::new()
        $this.ColorMap[794] = [CCAppleBrownLight24]::new()
        $this.ColorMap[795] = [CCAppleBrownLight24]::new()
        $this.ColorMap[796] = [CCAppleGreenLight24]::new()
        $this.ColorMap[797] = [CCAppleGreenLight24]::new()
        $this.ColorMap[798] = [CCAppleGreenLight24]::new()
        $this.ColorMap[799] = [CCAppleGreenLight24]::new()
        $this.ColorMap[800] = [CCAppleGreenLight24]::new()
        $this.ColorMap[801] = [CCAppleGreenLight24]::new()
        $this.ColorMap[802] = [CCAppleGreenLight24]::new()
        $this.ColorMap[803] = [CCAppleGreenLight24]::new()
        $this.ColorMap[804] = [CCAppleGreenLight24]::new()
        $this.ColorMap[805] = [CCAppleGreenLight24]::new()
        $this.ColorMap[806] = [CCAppleGreenLight24]::new()
        $this.ColorMap[807] = [CCAppleGreenLight24]::new()
        $this.ColorMap[808] = [CCAppleGreenLight24]::new()
        $this.ColorMap[809] = [CCAppleGreenLight24]::new()
        $this.ColorMap[810] = [CCAppleGreenLight24]::new()
        $this.ColorMap[811] = [CCAppleGreenLight24]::new()
        $this.ColorMap[812] = [CCAppleGreenLight24]::new()
        $this.ColorMap[813] = [CCAppleGreenLight24]::new()
        $this.ColorMap[814] = [CCAppleGreenLight24]::new()
        $this.ColorMap[815] = [CCAppleGreenLight24]::new() # End Row 16
        $this.ColorMap[816] = [CCAppleBrownLight24]::new()
        $this.ColorMap[817] = [CCAppleBrownLight24]::new()
        $this.ColorMap[818] = [CCAppleBrownLight24]::new()
        $this.ColorMap[819] = [CCAppleBrownLight24]::new()
        $this.ColorMap[820] = [CCAppleBrownLight24]::new()
        $this.ColorMap[821] = [CCAppleBrownLight24]::new()
        $this.ColorMap[822] = [CCAppleBrownLight24]::new()
        $this.ColorMap[823] = [CCAppleBrownLight24]::new()
        $this.ColorMap[824] = [CCAppleBrownLight24]::new()
        $this.ColorMap[825] = [CCAppleBrownLight24]::new()
        $this.ColorMap[826] = [CCAppleBrownLight24]::new()
        $this.ColorMap[827] = [CCAppleBrownLight24]::new()
        $this.ColorMap[828] = [CCAppleBrownLight24]::new()
        $this.ColorMap[829] = [CCAppleBrownLight24]::new()
        $this.ColorMap[830] = [CCAppleBrownLight24]::new()
        $this.ColorMap[831] = [CCAppleBrownLight24]::new()
        $this.ColorMap[832] = [CCAppleBrownLight24]::new()
        $this.ColorMap[833] = [CCAppleBrownLight24]::new()
        $this.ColorMap[834] = [CCAppleBrownLight24]::new()
        $this.ColorMap[835] = [CCAppleBrownLight24]::new()
        $this.ColorMap[836] = [CCAppleBrownLight24]::new()
        $this.ColorMap[837] = [CCAppleBrownLight24]::new()
        $this.ColorMap[838] = [CCAppleBrownLight24]::new()
        $this.ColorMap[839] = [CCAppleBrownLight24]::new()
        $this.ColorMap[840] = [CCAppleBrownLight24]::new()
        $this.ColorMap[841] = [CCAppleBrownLight24]::new()
        $this.ColorMap[842] = [CCAppleBrownLight24]::new()
        $this.ColorMap[843] = [CCAppleBrownLight24]::new()
        $this.ColorMap[844] = [CCAppleGreenLight24]::new()
        $this.ColorMap[845] = [CCAppleGreenLight24]::new()
        $this.ColorMap[846] = [CCAppleGreenLight24]::new()
        $this.ColorMap[847] = [CCAppleGreenLight24]::new()
        $this.ColorMap[848] = [CCAppleGreenLight24]::new()
        $this.ColorMap[849] = [CCAppleGreenLight24]::new()
        $this.ColorMap[850] = [CCAppleGreenLight24]::new()
        $this.ColorMap[851] = [CCAppleGreenLight24]::new()
        $this.ColorMap[852] = [CCAppleGreenLight24]::new()
        $this.ColorMap[853] = [CCAppleGreenLight24]::new()
        $this.ColorMap[854] = [CCAppleGreenLight24]::new()
        $this.ColorMap[855] = [CCAppleGreenLight24]::new()
        $this.ColorMap[856] = [CCAppleGreenLight24]::new()
        $this.ColorMap[857] = [CCAppleGreenLight24]::new()
        $this.ColorMap[858] = [CCAppleGreenLight24]::new()
        $this.ColorMap[859] = [CCAppleGreenLight24]::new()
        $this.ColorMap[860] = [CCAppleGreenLight24]::new()
        $this.ColorMap[861] = [CCAppleGreenLight24]::new()
        $this.ColorMap[862] = [CCAppleGreenLight24]::new()
        $this.ColorMap[863] = [CCAppleGreenLight24]::new() # End Row 17
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Finished filling the Color Map.')

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Calling CreateSceneImageATString.')
        $this.CreateSceneImageATString($this.ColorMap)
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Nulling the Color Map.')
        $this.ColorMap = $null
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }
}

Class SIFieldSouthEastWestRoad : SIInternalBase {
    SIFieldSouthEastWestRoad(): base() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Updating the Progress Bar for the Scene Image Progress.')
        Write-Progress -Activity 'Creating Scene Images      ' -Id 3 -Status 'Creating SIFieldSouthEastWestRoad' -PercentComplete -1
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Filling the Color Map.')
        $this.ColorMap[0]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[1]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[2]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[3]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[4]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[5]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[6]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[7]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[8]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[9]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[10]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[11]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[12]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[13]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[14]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[15]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[16]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[17]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[18]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[19]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[20]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[21]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[22]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[23]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[24]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[25]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[26]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[27]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[28]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[29]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[30]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[31]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[32]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[33]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[34]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[35]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[36]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[37]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[38]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[39]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[40]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[41]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[42]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[43]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[44]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[45]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[46]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[47]  = [CCAppleBlueLight24]::new() # End Row 0
        $this.ColorMap[48]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[49]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[50]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[51]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[52]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[53]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[54]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[55]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[56]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[57]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[58]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[59]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[60]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[61]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[62]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[63]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[64]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[65]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[66]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[67]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[68]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[69]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[70]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[71]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[72]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[73]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[74]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[75]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[76]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[77]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[78]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[79]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[80]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[81]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[82]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[83]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[84]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[85]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[86]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[87]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[88]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[89]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[90]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[91]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[92]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[93]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[94]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[95]  = [CCAppleBlueLight24]::new() # End Row 1
        $this.ColorMap[96]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[97]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[98]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[99]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[100] = [CCAppleBlueLight24]::new()
        $this.ColorMap[101] = [CCAppleBlueLight24]::new()
        $this.ColorMap[102] = [CCAppleBlueLight24]::new()
        $this.ColorMap[103] = [CCAppleBlueLight24]::new()
        $this.ColorMap[104] = [CCAppleBlueLight24]::new()
        $this.ColorMap[105] = [CCAppleBlueLight24]::new()
        $this.ColorMap[106] = [CCAppleBlueLight24]::new()
        $this.ColorMap[107] = [CCAppleBlueLight24]::new()
        $this.ColorMap[108] = [CCAppleBlueLight24]::new()
        $this.ColorMap[109] = [CCAppleBlueLight24]::new()
        $this.ColorMap[110] = [CCAppleBlueLight24]::new()
        $this.ColorMap[111] = [CCAppleBlueLight24]::new()
        $this.ColorMap[112] = [CCAppleBlueLight24]::new()
        $this.ColorMap[113] = [CCAppleBlueLight24]::new()
        $this.ColorMap[114] = [CCAppleBlueLight24]::new()
        $this.ColorMap[115] = [CCAppleBlueLight24]::new()
        $this.ColorMap[116] = [CCAppleBlueLight24]::new()
        $this.ColorMap[117] = [CCAppleBlueLight24]::new()
        $this.ColorMap[118] = [CCAppleBlueLight24]::new()
        $this.ColorMap[119] = [CCAppleBlueLight24]::new()
        $this.ColorMap[120] = [CCAppleBlueLight24]::new()
        $this.ColorMap[121] = [CCAppleBlueLight24]::new()
        $this.ColorMap[122] = [CCAppleBlueLight24]::new()
        $this.ColorMap[123] = [CCAppleBlueLight24]::new()
        $this.ColorMap[124] = [CCAppleBlueLight24]::new()
        $this.ColorMap[125] = [CCAppleBlueLight24]::new()
        $this.ColorMap[126] = [CCAppleBlueLight24]::new()
        $this.ColorMap[127] = [CCAppleBlueLight24]::new()
        $this.ColorMap[128] = [CCAppleBlueLight24]::new()
        $this.ColorMap[129] = [CCAppleBlueLight24]::new()
        $this.ColorMap[130] = [CCAppleBlueLight24]::new()
        $this.ColorMap[131] = [CCAppleBlueLight24]::new()
        $this.ColorMap[132] = [CCAppleBlueLight24]::new()
        $this.ColorMap[133] = [CCAppleBlueLight24]::new()
        $this.ColorMap[134] = [CCAppleBlueLight24]::new()
        $this.ColorMap[135] = [CCAppleBlueLight24]::new()
        $this.ColorMap[136] = [CCAppleBlueLight24]::new()
        $this.ColorMap[137] = [CCAppleBlueLight24]::new()
        $this.ColorMap[138] = [CCAppleBlueLight24]::new()
        $this.ColorMap[139] = [CCAppleBlueLight24]::new()
        $this.ColorMap[140] = [CCAppleBlueLight24]::new()
        $this.ColorMap[141] = [CCAppleBlueLight24]::new()
        $this.ColorMap[142] = [CCAppleBlueLight24]::new()
        $this.ColorMap[143] = [CCAppleBlueLight24]::new() # End Row 2
        $this.ColorMap[144] = [CCAppleBlueLight24]::new()
        $this.ColorMap[145] = [CCAppleBlueLight24]::new()
        $this.ColorMap[146] = [CCAppleBlueLight24]::new()
        $this.ColorMap[147] = [CCAppleBlueLight24]::new()
        $this.ColorMap[148] = [CCAppleBlueLight24]::new()
        $this.ColorMap[149] = [CCAppleBlueLight24]::new()
        $this.ColorMap[150] = [CCAppleBlueLight24]::new()
        $this.ColorMap[151] = [CCAppleBlueLight24]::new()
        $this.ColorMap[152] = [CCAppleBlueLight24]::new()
        $this.ColorMap[153] = [CCAppleBlueLight24]::new()
        $this.ColorMap[154] = [CCAppleBlueLight24]::new()
        $this.ColorMap[155] = [CCAppleBlueLight24]::new()
        $this.ColorMap[156] = [CCAppleBlueLight24]::new()
        $this.ColorMap[157] = [CCAppleBlueLight24]::new()
        $this.ColorMap[158] = [CCAppleBlueLight24]::new()
        $this.ColorMap[159] = [CCAppleBlueLight24]::new()
        $this.ColorMap[160] = [CCAppleBlueLight24]::new()
        $this.ColorMap[161] = [CCAppleBlueLight24]::new()
        $this.ColorMap[162] = [CCAppleBlueLight24]::new()
        $this.ColorMap[163] = [CCAppleBlueLight24]::new()
        $this.ColorMap[164] = [CCAppleBlueLight24]::new()
        $this.ColorMap[165] = [CCAppleBlueLight24]::new()
        $this.ColorMap[166] = [CCAppleBlueLight24]::new()
        $this.ColorMap[167] = [CCAppleBlueLight24]::new()
        $this.ColorMap[168] = [CCAppleBlueLight24]::new()
        $this.ColorMap[169] = [CCAppleBlueLight24]::new()
        $this.ColorMap[170] = [CCAppleBlueLight24]::new()
        $this.ColorMap[171] = [CCAppleBlueLight24]::new()
        $this.ColorMap[172] = [CCAppleBlueLight24]::new()
        $this.ColorMap[173] = [CCAppleBlueLight24]::new()
        $this.ColorMap[174] = [CCAppleBlueLight24]::new()
        $this.ColorMap[175] = [CCAppleBlueLight24]::new()
        $this.ColorMap[176] = [CCAppleBlueLight24]::new()
        $this.ColorMap[177] = [CCAppleBlueLight24]::new()
        $this.ColorMap[178] = [CCAppleBlueLight24]::new()
        $this.ColorMap[179] = [CCAppleBlueLight24]::new()
        $this.ColorMap[180] = [CCAppleBlueLight24]::new()
        $this.ColorMap[181] = [CCAppleBlueLight24]::new()
        $this.ColorMap[182] = [CCAppleBlueLight24]::new()
        $this.ColorMap[183] = [CCAppleBlueLight24]::new()
        $this.ColorMap[184] = [CCAppleBlueLight24]::new()
        $this.ColorMap[185] = [CCAppleBlueLight24]::new()
        $this.ColorMap[186] = [CCAppleBlueLight24]::new()
        $this.ColorMap[187] = [CCAppleBlueLight24]::new()
        $this.ColorMap[188] = [CCAppleBlueLight24]::new()
        $this.ColorMap[189] = [CCAppleBlueLight24]::new()
        $this.ColorMap[190] = [CCAppleBlueLight24]::new()
        $this.ColorMap[191] = [CCAppleBlueLight24]::new() # End Row 3
        $this.ColorMap[192] = [CCAppleBlueLight24]::new()
        $this.ColorMap[193] = [CCAppleBlueLight24]::new()
        $this.ColorMap[194] = [CCAppleBlueLight24]::new()
        $this.ColorMap[195] = [CCAppleBlueLight24]::new()
        $this.ColorMap[196] = [CCAppleBlueLight24]::new()
        $this.ColorMap[197] = [CCAppleBlueLight24]::new()
        $this.ColorMap[198] = [CCAppleBlueLight24]::new()
        $this.ColorMap[199] = [CCAppleBlueLight24]::new()
        $this.ColorMap[200] = [CCAppleBlueLight24]::new()
        $this.ColorMap[201] = [CCAppleBlueLight24]::new()
        $this.ColorMap[202] = [CCAppleBlueLight24]::new()
        $this.ColorMap[203] = [CCAppleBlueLight24]::new()
        $this.ColorMap[204] = [CCAppleBlueLight24]::new()
        $this.ColorMap[205] = [CCAppleBlueLight24]::new()
        $this.ColorMap[206] = [CCAppleBlueLight24]::new()
        $this.ColorMap[207] = [CCAppleBlueLight24]::new()
        $this.ColorMap[208] = [CCAppleBlueLight24]::new()
        $this.ColorMap[209] = [CCAppleBlueLight24]::new()
        $this.ColorMap[210] = [CCAppleBlueLight24]::new()
        $this.ColorMap[211] = [CCAppleBlueLight24]::new()
        $this.ColorMap[212] = [CCAppleBlueLight24]::new()
        $this.ColorMap[213] = [CCAppleBlueLight24]::new()
        $this.ColorMap[214] = [CCAppleBlueLight24]::new()
        $this.ColorMap[215] = [CCAppleBlueLight24]::new()
        $this.ColorMap[216] = [CCAppleBlueLight24]::new()
        $this.ColorMap[217] = [CCAppleBlueLight24]::new()
        $this.ColorMap[218] = [CCAppleBlueLight24]::new()
        $this.ColorMap[219] = [CCAppleBlueLight24]::new()
        $this.ColorMap[220] = [CCAppleBlueLight24]::new()
        $this.ColorMap[221] = [CCAppleBlueLight24]::new()
        $this.ColorMap[222] = [CCAppleBlueLight24]::new()
        $this.ColorMap[223] = [CCAppleBlueLight24]::new()
        $this.ColorMap[224] = [CCAppleBlueLight24]::new()
        $this.ColorMap[225] = [CCAppleBlueLight24]::new()
        $this.ColorMap[226] = [CCAppleBlueLight24]::new()
        $this.ColorMap[227] = [CCAppleBlueLight24]::new()
        $this.ColorMap[228] = [CCAppleBlueLight24]::new()
        $this.ColorMap[229] = [CCAppleBlueLight24]::new()
        $this.ColorMap[230] = [CCAppleBlueLight24]::new()
        $this.ColorMap[231] = [CCAppleBlueLight24]::new()
        $this.ColorMap[232] = [CCAppleBlueLight24]::new()
        $this.ColorMap[233] = [CCAppleBlueLight24]::new()
        $this.ColorMap[234] = [CCAppleBlueLight24]::new()
        $this.ColorMap[235] = [CCAppleBlueLight24]::new()
        $this.ColorMap[236] = [CCAppleBlueLight24]::new()
        $this.ColorMap[237] = [CCAppleBlueLight24]::new()
        $this.ColorMap[238] = [CCAppleBlueLight24]::new()
        $this.ColorMap[239] = [CCAppleBlueLight24]::new() # End Row 4
        $this.ColorMap[240] = [CCAppleGreenLight24]::new()
        $this.ColorMap[241] = [CCAppleGreenLight24]::new()
        $this.ColorMap[242] = [CCAppleGreenLight24]::new()
        $this.ColorMap[243] = [CCAppleGreenLight24]::new()
        $this.ColorMap[244] = [CCAppleGreenLight24]::new()
        $this.ColorMap[245] = [CCAppleGreenLight24]::new()
        $this.ColorMap[246] = [CCAppleGreenLight24]::new()
        $this.ColorMap[247] = [CCAppleGreenLight24]::new()
        $this.ColorMap[248] = [CCAppleGreenLight24]::new()
        $this.ColorMap[249] = [CCAppleGreenLight24]::new()
        $this.ColorMap[250] = [CCAppleGreenLight24]::new()
        $this.ColorMap[251] = [CCAppleGreenLight24]::new()
        $this.ColorMap[252] = [CCAppleGreenLight24]::new()
        $this.ColorMap[253] = [CCAppleGreenLight24]::new()
        $this.ColorMap[254] = [CCAppleGreenLight24]::new()
        $this.ColorMap[255] = [CCAppleGreenLight24]::new()
        $this.ColorMap[256] = [CCAppleGreenLight24]::new()
        $this.ColorMap[257] = [CCAppleGreenLight24]::new()
        $this.ColorMap[258] = [CCAppleGreenLight24]::new()
        $this.ColorMap[259] = [CCAppleGreenLight24]::new()
        $this.ColorMap[260] = [CCAppleGreenLight24]::new()
        $this.ColorMap[261] = [CCAppleGreenLight24]::new()
        $this.ColorMap[262] = [CCAppleGreenLight24]::new()
        $this.ColorMap[263] = [CCAppleGreenLight24]::new()
        $this.ColorMap[264] = [CCAppleGreenLight24]::new()
        $this.ColorMap[265] = [CCAppleGreenLight24]::new()
        $this.ColorMap[266] = [CCAppleGreenLight24]::new()
        $this.ColorMap[267] = [CCAppleGreenLight24]::new()
        $this.ColorMap[268] = [CCAppleGreenLight24]::new()
        $this.ColorMap[269] = [CCAppleGreenLight24]::new()
        $this.ColorMap[270] = [CCAppleGreenLight24]::new()
        $this.ColorMap[271] = [CCAppleGreenLight24]::new()
        $this.ColorMap[272] = [CCAppleGreenLight24]::new()
        $this.ColorMap[273] = [CCAppleGreenLight24]::new()
        $this.ColorMap[274] = [CCAppleGreenLight24]::new()
        $this.ColorMap[275] = [CCAppleGreenLight24]::new()
        $this.ColorMap[276] = [CCAppleGreenLight24]::new()
        $this.ColorMap[277] = [CCAppleGreenLight24]::new()
        $this.ColorMap[278] = [CCAppleGreenLight24]::new()
        $this.ColorMap[279] = [CCAppleGreenLight24]::new()
        $this.ColorMap[280] = [CCAppleGreenLight24]::new()
        $this.ColorMap[281] = [CCAppleGreenLight24]::new()
        $this.ColorMap[282] = [CCAppleGreenLight24]::new()
        $this.ColorMap[283] = [CCAppleGreenLight24]::new()
        $this.ColorMap[284] = [CCAppleGreenLight24]::new()
        $this.ColorMap[285] = [CCAppleGreenLight24]::new()
        $this.ColorMap[286] = [CCAppleGreenLight24]::new()
        $this.ColorMap[287] = [CCAppleGreenLight24]::new() # End Row 5
        $this.ColorMap[288] = [CCAppleGreenLight24]::new()
        $this.ColorMap[289] = [CCAppleGreenLight24]::new()
        $this.ColorMap[290] = [CCAppleGreenLight24]::new()
        $this.ColorMap[291] = [CCAppleGreenLight24]::new()
        $this.ColorMap[292] = [CCAppleGreenLight24]::new()
        $this.ColorMap[293] = [CCAppleGreenLight24]::new()
        $this.ColorMap[294] = [CCAppleGreenLight24]::new()
        $this.ColorMap[295] = [CCAppleGreenLight24]::new()
        $this.ColorMap[296] = [CCAppleGreenLight24]::new()
        $this.ColorMap[297] = [CCAppleGreenLight24]::new()
        $this.ColorMap[298] = [CCAppleGreenLight24]::new()
        $this.ColorMap[299] = [CCAppleGreenLight24]::new()
        $this.ColorMap[300] = [CCAppleGreenLight24]::new()
        $this.ColorMap[301] = [CCAppleGreenLight24]::new()
        $this.ColorMap[302] = [CCAppleGreenLight24]::new()
        $this.ColorMap[303] = [CCAppleGreenLight24]::new()
        $this.ColorMap[304] = [CCAppleGreenLight24]::new()
        $this.ColorMap[305] = [CCAppleGreenLight24]::new()
        $this.ColorMap[306] = [CCAppleGreenLight24]::new()
        $this.ColorMap[307] = [CCAppleGreenLight24]::new()
        $this.ColorMap[308] = [CCAppleGreenLight24]::new()
        $this.ColorMap[309] = [CCAppleGreenLight24]::new()
        $this.ColorMap[310] = [CCAppleGreenLight24]::new()
        $this.ColorMap[311] = [CCAppleGreenLight24]::new()
        $this.ColorMap[312] = [CCAppleGreenLight24]::new()
        $this.ColorMap[313] = [CCAppleGreenLight24]::new()
        $this.ColorMap[314] = [CCAppleGreenLight24]::new()
        $this.ColorMap[315] = [CCAppleGreenLight24]::new()
        $this.ColorMap[316] = [CCAppleGreenLight24]::new()
        $this.ColorMap[317] = [CCAppleGreenLight24]::new()
        $this.ColorMap[318] = [CCAppleGreenLight24]::new()
        $this.ColorMap[319] = [CCAppleGreenLight24]::new()
        $this.ColorMap[320] = [CCAppleGreenLight24]::new()
        $this.ColorMap[321] = [CCAppleGreenLight24]::new()
        $this.ColorMap[322] = [CCAppleGreenLight24]::new()
        $this.ColorMap[323] = [CCAppleGreenLight24]::new()
        $this.ColorMap[324] = [CCAppleGreenLight24]::new()
        $this.ColorMap[325] = [CCAppleGreenLight24]::new()
        $this.ColorMap[326] = [CCAppleGreenLight24]::new()
        $this.ColorMap[327] = [CCAppleGreenLight24]::new()
        $this.ColorMap[328] = [CCAppleGreenLight24]::new()
        $this.ColorMap[329] = [CCAppleGreenLight24]::new()
        $this.ColorMap[330] = [CCAppleGreenLight24]::new()
        $this.ColorMap[331] = [CCAppleGreenLight24]::new()
        $this.ColorMap[332] = [CCAppleGreenLight24]::new()
        $this.ColorMap[333] = [CCAppleGreenLight24]::new()
        $this.ColorMap[334] = [CCAppleGreenLight24]::new()
        $this.ColorMap[335] = [CCAppleGreenLight24]::new() # End Row 6
        $this.ColorMap[336] = [CCAppleGreenLight24]::new()
        $this.ColorMap[337] = [CCAppleGreenLight24]::new()
        $this.ColorMap[338] = [CCAppleGreenLight24]::new()
        $this.ColorMap[339] = [CCAppleGreenLight24]::new()
        $this.ColorMap[340] = [CCAppleGreenLight24]::new()
        $this.ColorMap[341] = [CCAppleGreenLight24]::new()
        $this.ColorMap[342] = [CCAppleGreenLight24]::new()
        $this.ColorMap[343] = [CCAppleGreenLight24]::new()
        $this.ColorMap[344] = [CCAppleGreenLight24]::new()
        $this.ColorMap[345] = [CCAppleGreenLight24]::new()
        $this.ColorMap[346] = [CCAppleGreenLight24]::new()
        $this.ColorMap[347] = [CCAppleGreenLight24]::new()
        $this.ColorMap[348] = [CCAppleGreenLight24]::new()
        $this.ColorMap[349] = [CCAppleGreenLight24]::new()
        $this.ColorMap[350] = [CCAppleGreenLight24]::new()
        $this.ColorMap[351] = [CCAppleGreenLight24]::new()
        $this.ColorMap[352] = [CCAppleGreenLight24]::new()
        $this.ColorMap[353] = [CCAppleGreenLight24]::new()
        $this.ColorMap[354] = [CCAppleGreenLight24]::new()
        $this.ColorMap[355] = [CCAppleGreenLight24]::new()
        $this.ColorMap[356] = [CCAppleGreenLight24]::new()
        $this.ColorMap[357] = [CCAppleGreenLight24]::new()
        $this.ColorMap[358] = [CCAppleGreenLight24]::new()
        $this.ColorMap[359] = [CCAppleGreenLight24]::new()
        $this.ColorMap[360] = [CCAppleGreenLight24]::new()
        $this.ColorMap[361] = [CCAppleGreenLight24]::new()
        $this.ColorMap[362] = [CCAppleGreenLight24]::new()
        $this.ColorMap[363] = [CCAppleGreenLight24]::new()
        $this.ColorMap[364] = [CCAppleGreenLight24]::new()
        $this.ColorMap[365] = [CCAppleGreenLight24]::new()
        $this.ColorMap[366] = [CCAppleGreenLight24]::new()
        $this.ColorMap[367] = [CCAppleGreenLight24]::new()
        $this.ColorMap[368] = [CCAppleGreenLight24]::new()
        $this.ColorMap[369] = [CCAppleGreenLight24]::new()
        $this.ColorMap[370] = [CCAppleGreenLight24]::new()
        $this.ColorMap[371] = [CCAppleGreenLight24]::new()
        $this.ColorMap[372] = [CCAppleGreenLight24]::new()
        $this.ColorMap[373] = [CCAppleGreenLight24]::new()
        $this.ColorMap[374] = [CCAppleGreenLight24]::new()
        $this.ColorMap[375] = [CCAppleGreenLight24]::new()
        $this.ColorMap[376] = [CCAppleGreenLight24]::new()
        $this.ColorMap[377] = [CCAppleGreenLight24]::new()
        $this.ColorMap[378] = [CCAppleGreenLight24]::new()
        $this.ColorMap[379] = [CCAppleGreenLight24]::new()
        $this.ColorMap[380] = [CCAppleGreenLight24]::new()
        $this.ColorMap[381] = [CCAppleGreenLight24]::new()
        $this.ColorMap[382] = [CCAppleGreenLight24]::new()
        $this.ColorMap[383] = [CCAppleGreenLight24]::new() # End Row 7
        $this.ColorMap[384] = [CCAppleGreenLight24]::new()
        $this.ColorMap[385] = [CCAppleGreenLight24]::new()
        $this.ColorMap[386] = [CCAppleGreenLight24]::new()
        $this.ColorMap[387] = [CCAppleGreenLight24]::new()
        $this.ColorMap[388] = [CCAppleGreenLight24]::new()
        $this.ColorMap[389] = [CCAppleGreenLight24]::new()
        $this.ColorMap[390] = [CCAppleGreenLight24]::new()
        $this.ColorMap[391] = [CCAppleGreenLight24]::new()
        $this.ColorMap[392] = [CCAppleGreenLight24]::new()
        $this.ColorMap[393] = [CCAppleGreenLight24]::new()
        $this.ColorMap[394] = [CCAppleGreenLight24]::new()
        $this.ColorMap[395] = [CCAppleGreenLight24]::new()
        $this.ColorMap[396] = [CCAppleGreenLight24]::new()
        $this.ColorMap[397] = [CCAppleGreenLight24]::new()
        $this.ColorMap[398] = [CCAppleGreenLight24]::new()
        $this.ColorMap[399] = [CCAppleGreenLight24]::new()
        $this.ColorMap[400] = [CCAppleGreenLight24]::new()
        $this.ColorMap[401] = [CCAppleGreenLight24]::new()
        $this.ColorMap[402] = [CCAppleGreenLight24]::new()
        $this.ColorMap[403] = [CCAppleGreenLight24]::new()
        $this.ColorMap[404] = [CCAppleGreenLight24]::new()
        $this.ColorMap[405] = [CCAppleGreenLight24]::new()
        $this.ColorMap[406] = [CCAppleBrownLight24]::new()
        $this.ColorMap[407] = [CCAppleBrownLight24]::new()
        $this.ColorMap[408] = [CCAppleBrownLight24]::new()
        $this.ColorMap[409] = [CCAppleBrownLight24]::new()
        $this.ColorMap[410] = [CCAppleBrownLight24]::new()
        $this.ColorMap[411] = [CCAppleGreenLight24]::new()
        $this.ColorMap[412] = [CCAppleGreenLight24]::new()
        $this.ColorMap[413] = [CCAppleGreenLight24]::new()
        $this.ColorMap[414] = [CCAppleGreenLight24]::new()
        $this.ColorMap[415] = [CCAppleGreenLight24]::new()
        $this.ColorMap[416] = [CCAppleGreenLight24]::new()
        $this.ColorMap[417] = [CCAppleGreenLight24]::new()
        $this.ColorMap[418] = [CCAppleGreenLight24]::new()
        $this.ColorMap[419] = [CCAppleGreenLight24]::new()
        $this.ColorMap[420] = [CCAppleGreenLight24]::new()
        $this.ColorMap[421] = [CCAppleGreenLight24]::new()
        $this.ColorMap[422] = [CCAppleGreenLight24]::new()
        $this.ColorMap[423] = [CCAppleGreenLight24]::new()
        $this.ColorMap[424] = [CCAppleGreenLight24]::new()
        $this.ColorMap[425] = [CCAppleGreenLight24]::new()
        $this.ColorMap[426] = [CCAppleGreenLight24]::new()
        $this.ColorMap[427] = [CCAppleGreenLight24]::new()
        $this.ColorMap[428] = [CCAppleGreenLight24]::new()
        $this.ColorMap[429] = [CCAppleGreenLight24]::new()
        $this.ColorMap[430] = [CCAppleGreenLight24]::new()
        $this.ColorMap[431] = [CCAppleGreenLight24]::new() # End Row 8
        $this.ColorMap[432] = [CCAppleGreenLight24]::new()
        $this.ColorMap[433] = [CCAppleGreenLight24]::new()
        $this.ColorMap[434] = [CCAppleGreenLight24]::new()
        $this.ColorMap[435] = [CCAppleGreenLight24]::new()
        $this.ColorMap[436] = [CCAppleGreenLight24]::new()
        $this.ColorMap[437] = [CCAppleGreenLight24]::new()
        $this.ColorMap[438] = [CCAppleGreenLight24]::new()
        $this.ColorMap[439] = [CCAppleGreenLight24]::new()
        $this.ColorMap[440] = [CCAppleGreenLight24]::new()
        $this.ColorMap[441] = [CCAppleGreenLight24]::new()
        $this.ColorMap[442] = [CCAppleGreenLight24]::new()
        $this.ColorMap[443] = [CCAppleGreenLight24]::new()
        $this.ColorMap[444] = [CCAppleGreenLight24]::new()
        $this.ColorMap[445] = [CCAppleGreenLight24]::new()
        $this.ColorMap[446] = [CCAppleGreenLight24]::new()
        $this.ColorMap[447] = [CCAppleGreenLight24]::new()
        $this.ColorMap[448] = [CCAppleGreenLight24]::new()
        $this.ColorMap[449] = [CCAppleGreenLight24]::new()
        $this.ColorMap[450] = [CCAppleGreenLight24]::new()
        $this.ColorMap[451] = [CCAppleGreenLight24]::new()
        $this.ColorMap[452] = [CCAppleGreenLight24]::new()
        $this.ColorMap[453] = [CCAppleGreenLight24]::new()
        $this.ColorMap[454] = [CCAppleBrownLight24]::new()
        $this.ColorMap[455] = [CCAppleBrownLight24]::new()
        $this.ColorMap[456] = [CCAppleBrownLight24]::new()
        $this.ColorMap[457] = [CCAppleBrownLight24]::new()
        $this.ColorMap[458] = [CCAppleBrownLight24]::new()
        $this.ColorMap[459] = [CCAppleGreenLight24]::new()
        $this.ColorMap[460] = [CCAppleGreenLight24]::new()
        $this.ColorMap[461] = [CCAppleGreenLight24]::new()
        $this.ColorMap[462] = [CCAppleGreenLight24]::new()
        $this.ColorMap[463] = [CCAppleGreenLight24]::new()
        $this.ColorMap[464] = [CCAppleGreenLight24]::new()
        $this.ColorMap[465] = [CCAppleGreenLight24]::new()
        $this.ColorMap[466] = [CCAppleGreenLight24]::new()
        $this.ColorMap[467] = [CCAppleGreenLight24]::new()
        $this.ColorMap[468] = [CCAppleGreenLight24]::new()
        $this.ColorMap[469] = [CCAppleGreenLight24]::new()
        $this.ColorMap[470] = [CCAppleGreenLight24]::new()
        $this.ColorMap[471] = [CCAppleGreenLight24]::new()
        $this.ColorMap[472] = [CCAppleGreenLight24]::new()
        $this.ColorMap[473] = [CCAppleGreenLight24]::new()
        $this.ColorMap[474] = [CCAppleGreenLight24]::new()
        $this.ColorMap[475] = [CCAppleGreenLight24]::new()
        $this.ColorMap[476] = [CCAppleGreenLight24]::new()
        $this.ColorMap[477] = [CCAppleGreenLight24]::new()
        $this.ColorMap[478] = [CCAppleGreenLight24]::new()
        $this.ColorMap[479] = [CCAppleGreenLight24]::new() # End Row 9
        $this.ColorMap[480] = [CCAppleGreenLight24]::new()
        $this.ColorMap[481] = [CCAppleGreenLight24]::new()
        $this.ColorMap[482] = [CCAppleGreenLight24]::new()
        $this.ColorMap[483] = [CCAppleGreenLight24]::new()
        $this.ColorMap[484] = [CCAppleGreenLight24]::new()
        $this.ColorMap[485] = [CCAppleGreenLight24]::new()
        $this.ColorMap[486] = [CCAppleGreenLight24]::new()
        $this.ColorMap[487] = [CCAppleGreenLight24]::new()
        $this.ColorMap[488] = [CCAppleGreenLight24]::new()
        $this.ColorMap[489] = [CCAppleGreenLight24]::new()
        $this.ColorMap[490] = [CCAppleGreenLight24]::new()
        $this.ColorMap[491] = [CCAppleGreenLight24]::new()
        $this.ColorMap[492] = [CCAppleGreenLight24]::new()
        $this.ColorMap[493] = [CCAppleGreenLight24]::new()
        $this.ColorMap[494] = [CCAppleGreenLight24]::new()
        $this.ColorMap[495] = [CCAppleGreenLight24]::new()
        $this.ColorMap[496] = [CCAppleGreenLight24]::new()
        $this.ColorMap[497] = [CCAppleGreenLight24]::new()
        $this.ColorMap[498] = [CCAppleGreenLight24]::new()
        $this.ColorMap[499] = [CCAppleGreenLight24]::new()
        $this.ColorMap[500] = [CCAppleGreenLight24]::new()
        $this.ColorMap[501] = [CCAppleBrownLight24]::new()
        $this.ColorMap[502] = [CCAppleBrownLight24]::new()
        $this.ColorMap[503] = [CCAppleBrownLight24]::new()
        $this.ColorMap[504] = [CCAppleBrownLight24]::new()
        $this.ColorMap[505] = [CCAppleBrownLight24]::new()
        $this.ColorMap[506] = [CCAppleBrownLight24]::new()
        $this.ColorMap[507] = [CCAppleBrownLight24]::new()
        $this.ColorMap[508] = [CCAppleGreenLight24]::new()
        $this.ColorMap[509] = [CCAppleGreenLight24]::new()
        $this.ColorMap[510] = [CCAppleGreenLight24]::new()
        $this.ColorMap[511] = [CCAppleGreenLight24]::new()
        $this.ColorMap[512] = [CCAppleGreenLight24]::new()
        $this.ColorMap[513] = [CCAppleGreenLight24]::new()
        $this.ColorMap[514] = [CCAppleGreenLight24]::new()
        $this.ColorMap[515] = [CCAppleGreenLight24]::new()
        $this.ColorMap[516] = [CCAppleGreenLight24]::new()
        $this.ColorMap[517] = [CCAppleGreenLight24]::new()
        $this.ColorMap[518] = [CCAppleGreenLight24]::new()
        $this.ColorMap[519] = [CCAppleGreenLight24]::new()
        $this.ColorMap[520] = [CCAppleGreenLight24]::new()
        $this.ColorMap[521] = [CCAppleGreenLight24]::new()
        $this.ColorMap[522] = [CCAppleGreenLight24]::new()
        $this.ColorMap[523] = [CCAppleGreenLight24]::new()
        $this.ColorMap[524] = [CCAppleGreenLight24]::new()
        $this.ColorMap[525] = [CCAppleGreenLight24]::new()
        $this.ColorMap[526] = [CCAppleGreenLight24]::new()
        $this.ColorMap[527] = [CCAppleGreenLight24]::new() # End Row 10
        $this.ColorMap[528] = [CCAppleGreenLight24]::new()
        $this.ColorMap[529] = [CCAppleGreenLight24]::new()
        $this.ColorMap[530] = [CCAppleGreenLight24]::new()
        $this.ColorMap[531] = [CCAppleGreenLight24]::new()
        $this.ColorMap[532] = [CCAppleGreenLight24]::new()
        $this.ColorMap[533] = [CCAppleGreenLight24]::new()
        $this.ColorMap[534] = [CCAppleGreenLight24]::new()
        $this.ColorMap[535] = [CCAppleGreenLight24]::new()
        $this.ColorMap[536] = [CCAppleGreenLight24]::new()
        $this.ColorMap[537] = [CCAppleGreenLight24]::new()
        $this.ColorMap[538] = [CCAppleGreenLight24]::new()
        $this.ColorMap[539] = [CCAppleGreenLight24]::new()
        $this.ColorMap[540] = [CCAppleGreenLight24]::new()
        $this.ColorMap[541] = [CCAppleGreenLight24]::new()
        $this.ColorMap[542] = [CCAppleGreenLight24]::new()
        $this.ColorMap[543] = [CCAppleGreenLight24]::new()
        $this.ColorMap[544] = [CCAppleGreenLight24]::new()
        $this.ColorMap[545] = [CCAppleGreenLight24]::new()
        $this.ColorMap[546] = [CCAppleGreenLight24]::new()
        $this.ColorMap[547] = [CCAppleGreenLight24]::new()
        $this.ColorMap[548] = [CCAppleGreenLight24]::new()
        $this.ColorMap[549] = [CCAppleBrownLight24]::new()
        $this.ColorMap[550] = [CCAppleBrownLight24]::new()
        $this.ColorMap[551] = [CCAppleBrownLight24]::new()
        $this.ColorMap[552] = [CCAppleBrownLight24]::new()
        $this.ColorMap[553] = [CCAppleBrownLight24]::new()
        $this.ColorMap[554] = [CCAppleBrownLight24]::new()
        $this.ColorMap[555] = [CCAppleBrownLight24]::new()
        $this.ColorMap[556] = [CCAppleGreenLight24]::new()
        $this.ColorMap[557] = [CCAppleGreenLight24]::new()
        $this.ColorMap[558] = [CCAppleGreenLight24]::new()
        $this.ColorMap[559] = [CCAppleGreenLight24]::new()
        $this.ColorMap[560] = [CCAppleGreenLight24]::new()
        $this.ColorMap[561] = [CCAppleGreenLight24]::new()
        $this.ColorMap[562] = [CCAppleGreenLight24]::new()
        $this.ColorMap[563] = [CCAppleGreenLight24]::new()
        $this.ColorMap[564] = [CCAppleGreenLight24]::new()
        $this.ColorMap[565] = [CCAppleGreenLight24]::new()
        $this.ColorMap[566] = [CCAppleGreenLight24]::new()
        $this.ColorMap[567] = [CCAppleGreenLight24]::new()
        $this.ColorMap[568] = [CCAppleGreenLight24]::new()
        $this.ColorMap[569] = [CCAppleGreenLight24]::new()
        $this.ColorMap[570] = [CCAppleGreenLight24]::new()
        $this.ColorMap[571] = [CCAppleGreenLight24]::new()
        $this.ColorMap[572] = [CCAppleGreenLight24]::new()
        $this.ColorMap[573] = [CCAppleGreenLight24]::new()
        $this.ColorMap[574] = [CCAppleGreenLight24]::new()
        $this.ColorMap[575] = [CCAppleGreenLight24]::new() # End Row 11
        $this.ColorMap[576] = [CCAppleGreenLight24]::new()
        $this.ColorMap[577] = [CCAppleGreenLight24]::new()
        $this.ColorMap[578] = [CCAppleGreenLight24]::new()
        $this.ColorMap[579] = [CCAppleGreenLight24]::new()
        $this.ColorMap[580] = [CCAppleGreenLight24]::new()
        $this.ColorMap[581] = [CCAppleGreenLight24]::new()
        $this.ColorMap[582] = [CCAppleGreenLight24]::new()
        $this.ColorMap[583] = [CCAppleGreenLight24]::new()
        $this.ColorMap[584] = [CCAppleGreenLight24]::new()
        $this.ColorMap[585] = [CCAppleGreenLight24]::new()
        $this.ColorMap[586] = [CCAppleGreenLight24]::new()
        $this.ColorMap[587] = [CCAppleGreenLight24]::new()
        $this.ColorMap[588] = [CCAppleGreenLight24]::new()
        $this.ColorMap[589] = [CCAppleGreenLight24]::new()
        $this.ColorMap[590] = [CCAppleGreenLight24]::new()
        $this.ColorMap[591] = [CCAppleGreenLight24]::new()
        $this.ColorMap[592] = [CCAppleGreenLight24]::new()
        $this.ColorMap[593] = [CCAppleGreenLight24]::new()
        $this.ColorMap[594] = [CCAppleGreenLight24]::new()
        $this.ColorMap[595] = [CCAppleGreenLight24]::new()
        $this.ColorMap[596] = [CCAppleGreenLight24]::new()
        $this.ColorMap[597] = [CCAppleBrownLight24]::new()
        $this.ColorMap[598] = [CCAppleBrownLight24]::new()
        $this.ColorMap[599] = [CCAppleBrownLight24]::new()
        $this.ColorMap[600] = [CCAppleBrownLight24]::new()
        $this.ColorMap[601] = [CCAppleBrownLight24]::new()
        $this.ColorMap[602] = [CCAppleBrownLight24]::new()
        $this.ColorMap[603] = [CCAppleBrownLight24]::new()
        $this.ColorMap[604] = [CCAppleGreenLight24]::new()
        $this.ColorMap[605] = [CCAppleGreenLight24]::new()
        $this.ColorMap[606] = [CCAppleGreenLight24]::new()
        $this.ColorMap[607] = [CCAppleGreenLight24]::new()
        $this.ColorMap[608] = [CCAppleGreenLight24]::new()
        $this.ColorMap[609] = [CCAppleGreenLight24]::new()
        $this.ColorMap[610] = [CCAppleGreenLight24]::new()
        $this.ColorMap[611] = [CCAppleGreenLight24]::new()
        $this.ColorMap[612] = [CCAppleGreenLight24]::new()
        $this.ColorMap[613] = [CCAppleGreenLight24]::new()
        $this.ColorMap[614] = [CCAppleGreenLight24]::new()
        $this.ColorMap[615] = [CCAppleGreenLight24]::new()
        $this.ColorMap[616] = [CCAppleGreenLight24]::new()
        $this.ColorMap[617] = [CCAppleGreenLight24]::new()
        $this.ColorMap[618] = [CCAppleGreenLight24]::new()
        $this.ColorMap[619] = [CCAppleGreenLight24]::new()
        $this.ColorMap[620] = [CCAppleGreenLight24]::new()
        $this.ColorMap[621] = [CCAppleGreenLight24]::new()
        $this.ColorMap[622] = [CCAppleGreenLight24]::new()
        $this.ColorMap[623] = [CCAppleGreenLight24]::new() # End Row 12
        $this.ColorMap[624] = [CCAppleGreenLight24]::new()
        $this.ColorMap[625] = [CCAppleGreenLight24]::new()
        $this.ColorMap[626] = [CCAppleGreenLight24]::new()
        $this.ColorMap[627] = [CCAppleGreenLight24]::new()
        $this.ColorMap[628] = [CCAppleGreenLight24]::new()
        $this.ColorMap[629] = [CCAppleGreenLight24]::new()
        $this.ColorMap[630] = [CCAppleGreenLight24]::new()
        $this.ColorMap[631] = [CCAppleGreenLight24]::new()
        $this.ColorMap[632] = [CCAppleGreenLight24]::new()
        $this.ColorMap[633] = [CCAppleGreenLight24]::new()
        $this.ColorMap[634] = [CCAppleGreenLight24]::new()
        $this.ColorMap[635] = [CCAppleGreenLight24]::new()
        $this.ColorMap[636] = [CCAppleGreenLight24]::new()
        $this.ColorMap[637] = [CCAppleGreenLight24]::new()
        $this.ColorMap[638] = [CCAppleGreenLight24]::new()
        $this.ColorMap[639] = [CCAppleGreenLight24]::new()
        $this.ColorMap[640] = [CCAppleGreenLight24]::new()
        $this.ColorMap[641] = [CCAppleGreenLight24]::new()
        $this.ColorMap[642] = [CCAppleGreenLight24]::new()
        $this.ColorMap[643] = [CCAppleGreenLight24]::new()
        $this.ColorMap[644] = [CCAppleGreenLight24]::new()
        $this.ColorMap[645] = [CCAppleBrownLight24]::new()
        $this.ColorMap[646] = [CCAppleBrownLight24]::new()
        $this.ColorMap[647] = [CCAppleBrownLight24]::new()
        $this.ColorMap[648] = [CCAppleBrownLight24]::new()
        $this.ColorMap[649] = [CCAppleBrownLight24]::new()
        $this.ColorMap[650] = [CCAppleBrownLight24]::new()
        $this.ColorMap[651] = [CCAppleBrownLight24]::new()
        $this.ColorMap[652] = [CCAppleGreenLight24]::new()
        $this.ColorMap[653] = [CCAppleGreenLight24]::new()
        $this.ColorMap[654] = [CCAppleGreenLight24]::new()
        $this.ColorMap[655] = [CCAppleGreenLight24]::new()
        $this.ColorMap[656] = [CCAppleGreenLight24]::new()
        $this.ColorMap[657] = [CCAppleGreenLight24]::new()
        $this.ColorMap[658] = [CCAppleGreenLight24]::new()
        $this.ColorMap[659] = [CCAppleGreenLight24]::new()
        $this.ColorMap[660] = [CCAppleGreenLight24]::new()
        $this.ColorMap[661] = [CCAppleGreenLight24]::new()
        $this.ColorMap[662] = [CCAppleGreenLight24]::new()
        $this.ColorMap[663] = [CCAppleGreenLight24]::new()
        $this.ColorMap[664] = [CCAppleGreenLight24]::new()
        $this.ColorMap[665] = [CCAppleGreenLight24]::new()
        $this.ColorMap[666] = [CCAppleGreenLight24]::new()
        $this.ColorMap[667] = [CCAppleGreenLight24]::new()
        $this.ColorMap[668] = [CCAppleGreenLight24]::new()
        $this.ColorMap[669] = [CCAppleGreenLight24]::new()
        $this.ColorMap[670] = [CCAppleGreenLight24]::new()
        $this.ColorMap[671] = [CCAppleGreenLight24]::new() # End Row 13
        $this.ColorMap[672] = [CCAppleGreenLight24]::new()
        $this.ColorMap[673] = [CCAppleGreenLight24]::new()
        $this.ColorMap[674] = [CCAppleGreenLight24]::new()
        $this.ColorMap[675] = [CCAppleGreenLight24]::new()
        $this.ColorMap[676] = [CCAppleGreenLight24]::new()
        $this.ColorMap[677] = [CCAppleGreenLight24]::new()
        $this.ColorMap[678] = [CCAppleGreenLight24]::new()
        $this.ColorMap[679] = [CCAppleGreenLight24]::new()
        $this.ColorMap[680] = [CCAppleGreenLight24]::new()
        $this.ColorMap[681] = [CCAppleGreenLight24]::new()
        $this.ColorMap[682] = [CCAppleGreenLight24]::new()
        $this.ColorMap[683] = [CCAppleGreenLight24]::new()
        $this.ColorMap[684] = [CCAppleGreenLight24]::new()
        $this.ColorMap[685] = [CCAppleGreenLight24]::new()
        $this.ColorMap[686] = [CCAppleGreenLight24]::new()
        $this.ColorMap[687] = [CCAppleGreenLight24]::new()
        $this.ColorMap[688] = [CCAppleGreenLight24]::new()
        $this.ColorMap[689] = [CCAppleGreenLight24]::new()
        $this.ColorMap[690] = [CCAppleGreenLight24]::new()
        $this.ColorMap[691] = [CCAppleGreenLight24]::new()
        $this.ColorMap[692] = [CCAppleGreenLight24]::new()
        $this.ColorMap[693] = [CCAppleBrownLight24]::new()
        $this.ColorMap[694] = [CCAppleBrownLight24]::new()
        $this.ColorMap[695] = [CCAppleBrownLight24]::new()
        $this.ColorMap[696] = [CCAppleBrownLight24]::new()
        $this.ColorMap[697] = [CCAppleBrownLight24]::new()
        $this.ColorMap[698] = [CCAppleBrownLight24]::new()
        $this.ColorMap[699] = [CCAppleBrownLight24]::new()
        $this.ColorMap[700] = [CCAppleGreenLight24]::new()
        $this.ColorMap[701] = [CCAppleGreenLight24]::new()
        $this.ColorMap[702] = [CCAppleGreenLight24]::new()
        $this.ColorMap[703] = [CCAppleGreenLight24]::new()
        $this.ColorMap[704] = [CCAppleGreenLight24]::new()
        $this.ColorMap[705] = [CCAppleGreenLight24]::new()
        $this.ColorMap[706] = [CCAppleGreenLight24]::new()
        $this.ColorMap[707] = [CCAppleGreenLight24]::new()
        $this.ColorMap[708] = [CCAppleGreenLight24]::new()
        $this.ColorMap[709] = [CCAppleGreenLight24]::new()
        $this.ColorMap[710] = [CCAppleGreenLight24]::new()
        $this.ColorMap[711] = [CCAppleGreenLight24]::new()
        $this.ColorMap[712] = [CCAppleGreenLight24]::new()
        $this.ColorMap[713] = [CCAppleGreenLight24]::new()
        $this.ColorMap[714] = [CCAppleGreenLight24]::new()
        $this.ColorMap[715] = [CCAppleGreenLight24]::new()
        $this.ColorMap[716] = [CCAppleGreenLight24]::new()
        $this.ColorMap[717] = [CCAppleGreenLight24]::new()
        $this.ColorMap[718] = [CCAppleGreenLight24]::new()
        $this.ColorMap[719] = [CCAppleGreenLight24]::new() # End Row 14
        $this.ColorMap[720] = [CCAppleGreenLight24]::new()
        $this.ColorMap[721] = [CCAppleGreenLight24]::new()
        $this.ColorMap[722] = [CCAppleGreenLight24]::new()
        $this.ColorMap[723] = [CCAppleGreenLight24]::new()
        $this.ColorMap[724] = [CCAppleGreenLight24]::new()
        $this.ColorMap[725] = [CCAppleGreenLight24]::new()
        $this.ColorMap[726] = [CCAppleGreenLight24]::new()
        $this.ColorMap[727] = [CCAppleGreenLight24]::new()
        $this.ColorMap[728] = [CCAppleGreenLight24]::new()
        $this.ColorMap[729] = [CCAppleGreenLight24]::new()
        $this.ColorMap[730] = [CCAppleGreenLight24]::new()
        $this.ColorMap[731] = [CCAppleGreenLight24]::new()
        $this.ColorMap[732] = [CCAppleGreenLight24]::new()
        $this.ColorMap[733] = [CCAppleGreenLight24]::new()
        $this.ColorMap[734] = [CCAppleGreenLight24]::new()
        $this.ColorMap[735] = [CCAppleGreenLight24]::new()
        $this.ColorMap[736] = [CCAppleGreenLight24]::new()
        $this.ColorMap[737] = [CCAppleGreenLight24]::new()
        $this.ColorMap[738] = [CCAppleGreenLight24]::new()
        $this.ColorMap[739] = [CCAppleGreenLight24]::new()
        $this.ColorMap[740] = [CCAppleGreenLight24]::new()
        $this.ColorMap[741] = [CCAppleBrownLight24]::new()
        $this.ColorMap[742] = [CCAppleBrownLight24]::new()
        $this.ColorMap[743] = [CCAppleBrownLight24]::new()
        $this.ColorMap[744] = [CCAppleBrownLight24]::new()
        $this.ColorMap[745] = [CCAppleBrownLight24]::new()
        $this.ColorMap[746] = [CCAppleBrownLight24]::new()
        $this.ColorMap[747] = [CCAppleBrownLight24]::new()
        $this.ColorMap[748] = [CCAppleGreenLight24]::new()
        $this.ColorMap[749] = [CCAppleGreenLight24]::new()
        $this.ColorMap[750] = [CCAppleGreenLight24]::new()
        $this.ColorMap[751] = [CCAppleGreenLight24]::new()
        $this.ColorMap[752] = [CCAppleGreenLight24]::new()
        $this.ColorMap[753] = [CCAppleGreenLight24]::new()
        $this.ColorMap[754] = [CCAppleGreenLight24]::new()
        $this.ColorMap[755] = [CCAppleGreenLight24]::new()
        $this.ColorMap[756] = [CCAppleGreenLight24]::new()
        $this.ColorMap[757] = [CCAppleGreenLight24]::new()
        $this.ColorMap[758] = [CCAppleGreenLight24]::new()
        $this.ColorMap[759] = [CCAppleGreenLight24]::new()
        $this.ColorMap[760] = [CCAppleGreenLight24]::new()
        $this.ColorMap[761] = [CCAppleGreenLight24]::new()
        $this.ColorMap[762] = [CCAppleGreenLight24]::new()
        $this.ColorMap[763] = [CCAppleGreenLight24]::new()
        $this.ColorMap[764] = [CCAppleGreenLight24]::new()
        $this.ColorMap[765] = [CCAppleGreenLight24]::new()
        $this.ColorMap[766] = [CCAppleGreenLight24]::new()
        $this.ColorMap[767] = [CCAppleGreenLight24]::new() # End Row 15
        $this.ColorMap[768] = [CCAppleBrownLight24]::new()
        $this.ColorMap[769] = [CCAppleBrownLight24]::new()
        $this.ColorMap[770] = [CCAppleBrownLight24]::new()
        $this.ColorMap[771] = [CCAppleBrownLight24]::new()
        $this.ColorMap[772] = [CCAppleBrownLight24]::new()
        $this.ColorMap[773] = [CCAppleBrownLight24]::new()
        $this.ColorMap[774] = [CCAppleBrownLight24]::new()
        $this.ColorMap[775] = [CCAppleBrownLight24]::new()
        $this.ColorMap[776] = [CCAppleBrownLight24]::new()
        $this.ColorMap[777] = [CCAppleBrownLight24]::new()
        $this.ColorMap[778] = [CCAppleBrownLight24]::new()
        $this.ColorMap[779] = [CCAppleBrownLight24]::new()
        $this.ColorMap[780] = [CCAppleBrownLight24]::new()
        $this.ColorMap[781] = [CCAppleBrownLight24]::new()
        $this.ColorMap[782] = [CCAppleBrownLight24]::new()
        $this.ColorMap[783] = [CCAppleBrownLight24]::new()
        $this.ColorMap[784] = [CCAppleBrownLight24]::new()
        $this.ColorMap[785] = [CCAppleBrownLight24]::new()
        $this.ColorMap[786] = [CCAppleBrownLight24]::new()
        $this.ColorMap[787] = [CCAppleBrownLight24]::new()
        $this.ColorMap[788] = [CCAppleBrownLight24]::new()
        $this.ColorMap[789] = [CCAppleBrownLight24]::new()
        $this.ColorMap[790] = [CCAppleBrownLight24]::new()
        $this.ColorMap[791] = [CCAppleBrownLight24]::new()
        $this.ColorMap[792] = [CCAppleBrownLight24]::new()
        $this.ColorMap[793] = [CCAppleBrownLight24]::new()
        $this.ColorMap[794] = [CCAppleBrownLight24]::new()
        $this.ColorMap[795] = [CCAppleBrownLight24]::new()
        $this.ColorMap[796] = [CCAppleBrownLight24]::new()
        $this.ColorMap[797] = [CCAppleBrownLight24]::new()
        $this.ColorMap[798] = [CCAppleBrownLight24]::new()
        $this.ColorMap[799] = [CCAppleBrownLight24]::new()
        $this.ColorMap[800] = [CCAppleBrownLight24]::new()
        $this.ColorMap[801] = [CCAppleBrownLight24]::new()
        $this.ColorMap[802] = [CCAppleBrownLight24]::new()
        $this.ColorMap[803] = [CCAppleBrownLight24]::new()
        $this.ColorMap[804] = [CCAppleBrownLight24]::new()
        $this.ColorMap[805] = [CCAppleBrownLight24]::new()
        $this.ColorMap[806] = [CCAppleBrownLight24]::new()
        $this.ColorMap[807] = [CCAppleBrownLight24]::new()
        $this.ColorMap[808] = [CCAppleBrownLight24]::new()
        $this.ColorMap[809] = [CCAppleBrownLight24]::new()
        $this.ColorMap[810] = [CCAppleBrownLight24]::new()
        $this.ColorMap[811] = [CCAppleBrownLight24]::new()
        $this.ColorMap[812] = [CCAppleBrownLight24]::new()
        $this.ColorMap[813] = [CCAppleBrownLight24]::new()
        $this.ColorMap[814] = [CCAppleBrownLight24]::new()
        $this.ColorMap[815] = [CCAppleBrownLight24]::new() # End Row 16
        $this.ColorMap[816] = [CCAppleBrownLight24]::new()
        $this.ColorMap[817] = [CCAppleBrownLight24]::new()
        $this.ColorMap[818] = [CCAppleBrownLight24]::new()
        $this.ColorMap[819] = [CCAppleBrownLight24]::new()
        $this.ColorMap[820] = [CCAppleBrownLight24]::new()
        $this.ColorMap[821] = [CCAppleBrownLight24]::new()
        $this.ColorMap[822] = [CCAppleBrownLight24]::new()
        $this.ColorMap[823] = [CCAppleBrownLight24]::new()
        $this.ColorMap[824] = [CCAppleBrownLight24]::new()
        $this.ColorMap[825] = [CCAppleBrownLight24]::new()
        $this.ColorMap[826] = [CCAppleBrownLight24]::new()
        $this.ColorMap[827] = [CCAppleBrownLight24]::new()
        $this.ColorMap[828] = [CCAppleBrownLight24]::new()
        $this.ColorMap[829] = [CCAppleBrownLight24]::new()
        $this.ColorMap[830] = [CCAppleBrownLight24]::new()
        $this.ColorMap[831] = [CCAppleBrownLight24]::new()
        $this.ColorMap[832] = [CCAppleBrownLight24]::new()
        $this.ColorMap[833] = [CCAppleBrownLight24]::new()
        $this.ColorMap[834] = [CCAppleBrownLight24]::new()
        $this.ColorMap[835] = [CCAppleBrownLight24]::new()
        $this.ColorMap[836] = [CCAppleBrownLight24]::new()
        $this.ColorMap[837] = [CCAppleBrownLight24]::new()
        $this.ColorMap[838] = [CCAppleBrownLight24]::new()
        $this.ColorMap[839] = [CCAppleBrownLight24]::new()
        $this.ColorMap[840] = [CCAppleBrownLight24]::new()
        $this.ColorMap[841] = [CCAppleBrownLight24]::new()
        $this.ColorMap[842] = [CCAppleBrownLight24]::new()
        $this.ColorMap[843] = [CCAppleBrownLight24]::new()
        $this.ColorMap[844] = [CCAppleBrownLight24]::new()
        $this.ColorMap[845] = [CCAppleBrownLight24]::new()
        $this.ColorMap[846] = [CCAppleBrownLight24]::new()
        $this.ColorMap[847] = [CCAppleBrownLight24]::new()
        $this.ColorMap[848] = [CCAppleBrownLight24]::new()
        $this.ColorMap[849] = [CCAppleBrownLight24]::new()
        $this.ColorMap[850] = [CCAppleBrownLight24]::new()
        $this.ColorMap[851] = [CCAppleBrownLight24]::new()
        $this.ColorMap[852] = [CCAppleBrownLight24]::new()
        $this.ColorMap[853] = [CCAppleBrownLight24]::new()
        $this.ColorMap[854] = [CCAppleBrownLight24]::new()
        $this.ColorMap[855] = [CCAppleBrownLight24]::new()
        $this.ColorMap[856] = [CCAppleBrownLight24]::new()
        $this.ColorMap[857] = [CCAppleBrownLight24]::new()
        $this.ColorMap[858] = [CCAppleBrownLight24]::new()
        $this.ColorMap[859] = [CCAppleBrownLight24]::new()
        $this.ColorMap[860] = [CCAppleBrownLight24]::new()
        $this.ColorMap[861] = [CCAppleBrownLight24]::new()
        $this.ColorMap[862] = [CCAppleBrownLight24]::new()
        $this.ColorMap[863] = [CCAppleBrownLight24]::new() # End Row 17
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Finished filling the Color Map.')

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Calling CreateSceneImageATString.')
        $this.CreateSceneImageATString($this.ColorMap)
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Nulling the Color Map.')
        $this.ColorMap = $null
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }
}

Class MapTileObject {
    [String]$Name
    [String]$MapObjName
    [ScriptBlock]$Effect
    [Boolean]$CanAddToInventory
    [String]$ExamineString
    [List[String]]$TargetOfFilter
    [ScriptBlock]$BaseEffectCall

    MapTileObject(
        [String]$Name,
        [String]$MapObjName,
        [Boolean]$CanAddToInventory,
        [String]$ExamineString,
        [ScriptBlock]$Effect
    ) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entering the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', "Values passed are as follows: Name = $($Name), MapObjName = $($MapObjName), CanAddToInventory = $($CanAddToInventory), ExamineString = $($ExamineString), Effect = $($Effect.ToString())")
        $this.Name              = $Name
        $this.MapObjName        = $MapObjName
        $this.Effect            = $Effect
        $this.CanAddToInventory = $CanAddToInventory
        $this.ExamineString     = $ExamineString
        $this.TargetOfFilter    = [List[String]]::new()
        $this.BaseEffectCall    = {
            Param(
                [ValidateNotNullOrEmpty()]
                [String]$a0
            )

            Return $this.ValidateSourceInFilter($a0)
        }
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }

    MapTileObject(
        [String]$Name,
        [String]$MapObjName,
        [Boolean]$CanAddToInventory,
        [String]$ExamineString,
        [ScriptBlock]$Effect,
        [String[]]$TargetOfFilter
    ) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entering the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', "Values passed are as follows: Name = $($Name), MapObjName = $($MapObjName), CanAddToInventory = $($CanAddToInventory), ExamineString = $($ExamineString), Effect = $($Effect.ToString()), TargetOfFilter = $($TargetOfFilter.ToString())")
        $this.Name              = $Name
        $this.MapObjName        = $MapObjName
        $this.Effect            = $Effect
        $this.CanAddToInventory = $CanAddToInventory
        $this.ExamineString     = $ExamineString
        $this.TargetOfFilter    = [List[String]]::new()
        $this.BaseEffectCall    = {
            Param(
                [ValidateNotNullOrEmpty()]
                [String]$a0
            )

            Return $this.ValidateSourceInFilter($a0)
        }

        Foreach($a in $TargetOfFilter) {
            $this.TargetOfFilter.Add($a) | Out-Null
        }
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }

    [Boolean]ValidateSourceInFilter([String]$SourceItemClass) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'ValidateSourceInFilter', 'Entering the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'ValidateSourceInFilter', "Is SourceItemClass in the Target Filter? $(($SourceItemClass -IN $this.TargetOfFilter) ? 'Yes' : 'No')")
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Returning this to the caller.')
        Return ($SourceItemClass -IN $this.TargetOfFilter)
    }
}

Class MapTile {
    Static [Int]$TileExitNorth = 0
    Static [Int]$TileExitSouth = 1
    Static [Int]$TileExitEast  = 2
    Static [Int]$TileExitWest  = 3

    [SceneImage]$BackgroundImage
    [List[MapTileObject]]$ObjectListing
    [Boolean[]]$Exits

    MapTile(
        [SceneImage]$BackgroundImage,
        [MapTileObject[]]$ObjectListing,
        [Boolean[]]$Exits
    ) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entering the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', "Values passed are as follows: BackgroundImage = $($BackgroundImage.ToAnsiControlSequenceString()), ObjectListing = $($ObjectListing.ToString()), Exits = $($Exits.ToString()).")
        $this.BackgroundImage = $BackgroundImage
        $this.ObjectListing   = [List[MapTileObject]]::new()
        $this.Exits           = $Exits
        
        Foreach($a In $ObjectListing) {
            $this.ObjectListing.Add($a) | Out-Null
        }
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }

    [Boolean]IsItemInTile([String]$ItemName) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'IsItemInTile', 'Entering the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'IsItemInTile', "Checking to see if $(ItemName) is in the ObjectListing of this Tile.")
        Foreach($a in $this.ObjectListing) {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'IsItemInTile', "Does $($ItemName) match $($a.Name)?")
            If($a.Name -IEQ $ItemName) {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'IsItemInTile', 'Yes - returning true to the caller.')
                Return $true
            }
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'IsItemInTile', 'No - continuing to check the remaining items.')
        }

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'IsItemInTile', "$(ItemName) wasn't found in the ObjectListing for this Tile. Returning false to the caller.")
        Return $false
    }

    [MapTileObject]GetItemReference([String]$ItemName) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetItemReference', 'Entering the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetItemReference', "Checking to see if $(ItemName) is in the ObjectListing of this Tile.")
        Foreach($a in $this.ObjectListing) {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetItemReference', "Does $(ItemName) match $($a.Name)?")
            If($a.Name -IEQ $ItemName) {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetItemReference', 'Yes - returning a reference to the caller.')
                Return $a
            }
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetItemReference', 'No - continuing the check the remaining items.')
        }

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetItemReference', "$(ItemName) wasn't found in the ObjectListing for this Tile. Returning null to the caller.")
        Return $null
    }
}

Class Map {
    [String]$Name
    [Int]$MapWidth
    [Int]$MapHeight
    [Boolean]$BoundaryWrap
    [MapTile[,]]$Tiles

    Map(
        [String]$Name,
        [Int]$MapWidth,
        [Int]$MapHeight,
        [Boolean]$BoundaryWrap
    ) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entering the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', "Values passed are as follows: Name = $($Name), MapWidth = $($MapWidth), MapHeight = $($MapHeight), BoundaryWrap = $($BoundaryWrap).")
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Updating the Progress Bar for creating Maps.')
        Write-Progress -Activity 'Creating Maps              ' -Id 2 -Status 'Creating a map' -PercentComplete -1
        $this.Name         = $Name
        $this.MapWidth     = $MapWidth
        $this.MapHeight    = $MapHeight
        $this.BoundaryWrap = $BoundaryWrap
        $this.Tiles        = New-Object 'MapTile[,]' $this.MapHeight, $this.MapWidth
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }

    [MapTile]GetTileAtPlayerCoordinates() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetTileAtPlayerCoordinates', 'Entering the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetTileAtPlayerCoordinates', "Returning the MapTile at Player Coordinates $($Script:ThePlayer.MapCoordinates.X), $($Script:ThePlayer.MapCoordinates.Y)")
        Return $this.Tiles[$Script:ThePlayer.MapCoordinates.Y, $Script:ThePlayer.MapCoordinates.X]
    }
}

Class MTOTree : MapTileObject {
    MTOTree(): base('Tree', 'tree', $false, 'It''s a tree. Looks like all the other ones.', {
        Param([MapTileObject]$Source)

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'EffectBlock', 'Entering the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'EffectBlock', "The following class was passed to the filter: $($Source.PSTypeNames[0]).")
        Switch($Source.PSTypeNames[0]) {
            'MTORope' {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'EffectBlock', 'MTORope is being used.')
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'EffectBlock', 'Write a message to the Message Window that the Rope has been tied to the Tree.')
                $Script:TheMessageWindow.WriteMessage(
                    'I''ve tied the Rope to the Tree',
                    [CCAppleIndigoDark24]::new(),
                    [ATDecorationNone]::new()
                )

                <#
                It's important to note that this action *SHOULD* cause a state change with this object. To be more specific,
                prior to running this action, it's assumed that the Tree did NOT have a Rope tied to it. After this action,
                it does. So the questions now are (A) can you tie another Rope to the Tree, and (B) what can you do with the Tree
                now that it has a Rope tied to it?

                Also, the Rope should be removed from the Player's Inventory, but I don't yet have that functionality in place.
                #>

                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'EffectBlock', 'Removing the Rope from the Player''s Inventory.')
                $Script:ThePlayer.RemoveItemFromInventory($Source.Name)
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'EffectBlock', 'Leaving the function.')
            }
        }
    },
    @('MTORope')) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entering the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }
}

Class MTOLadder : MapTileObject {
    MTOLadder():  base('Ladder', 'ladder', $false, 'Used to climb things. Just don''t walk under one.', {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'EffectBlock', 'Entering the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'EffectBlock', 'Leaving the function.')
    }) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entering the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }
}

Class MTORope : MapTileObject {
    MTORope(): base('Rope', 'rope', $false, 'It''s not a snake. Hopefully.', {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'EffectBlock', 'Entering the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'EffectBlock', 'Leaving the function.')
    }) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entering the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }
}

Class MTOStairs : MapTileObject {
    MTOStairs(): base('Stairs', 'stairs', $false, 'A faithful ally for elevating one''s position.', {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'EffectBlock', 'Entering the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'EffectBlock', 'Leaving the function.')
    }) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entering the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }
}

Class MTOPole : MapTileObject {
    MTOPole(): base('Pole', 'pole', $false, 'Not the north or the south one.', {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'EffectBlock', 'Entering the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'EffectBlock', 'Leaving the function.')
    }) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entering the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }
}

Class MTOBacon : MapTileObject {
    MTOBacon(): base('Bacon', 'bacon', $false, 'Shredded swine flesh. Cholesterol never tasted so good.', {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'EffectBlock', 'Entering the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'EffectBlock', 'Leaving the function.')
    }) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entering the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }
}

Class MTOApple : MapTileObject {
    MTOApple(): base('Apple', 'apple', $true, 'A big, juicy, red apple. Worm not included.', {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'EffectBlock', 'Entering the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'EffectBlock', 'Leaving the function.')
    }) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entering the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }
}

Class MTOStick : MapTileObject {
    MTOStick(): base('Stick', 'stick', $false, 'Be careful not to poke your eye out with it.', {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'EffectBlock', 'Entering the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'EffectBlock', 'Leaving the function.')
    }) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entering the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }
}

Class MTOYogurt : MapTileObject {
    MTOYogurt(): base('Yogurt', 'yogurt', $false, 'For some reason, people enjoy this spoiled milk.', {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'EffectBlock', 'Entering the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'EffectBlock', 'Leaving the function.')
    }) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entering the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }
}

Class MTORock : MapTileObject {
    MTORock(): base('Rock', 'rock', $false, 'A garden variety rock. Good for taunting raccoons with.', {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'EffectBlock', 'Entering the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'EffectBlock', 'Leaving the function.')
    }) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entering the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }
}

Class MTOMilk : MapTileObject {
    MTOMilk(): base('Milk', 'milk', $false, '2%. We don''t take kindly to whole milk ''round here.', {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'EffectBlock', 'Entering the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'EffectBlock', 'Leaving the function.')
    }) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entering the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }
}

Class BufferManager {
    [BufferCell[,]]$ScreenBufferA
    [BufferCell[,]]$ScreenBufferB

    BufferManager() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entering the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Updating the Progress Bar for globals.')
        Write-Progress -Activity 'Creating ''global'' variables' -Id 1 -Status 'Creating the Buffer Manager' -PercentComplete -1
        $this.ScreenBufferA = New-Object 'BufferCell[,]' 80, 80
        $this.ScreenBufferB = New-Object 'BufferCell[,]' 80, 80
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }

    [Void]CopyActiveToBufferA() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CopyActiveToBufferA', 'Entering the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CopyActiveToBufferA', 'Copying a 80x80 rectangle of BufferCells from the current buffer into Buffer A.')
        $this.ScreenBufferA = $Script:Rui.GetBufferContents([Rectangle]::new(0, 0, 80, 80))
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CopyActiveToBufferA', 'Leaving the function.')
    }
    
    [Void]CopyActiveToBufferAWithWipe() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CopyActiveToBufferAWithWipe', 'Entering the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CopyActiveToBufferAWithWipe', 'Copying a 80x80 rectangle of BufferCells from the current buffer into Buffer A.')
        $this.ScreenBufferA = $Script:Rui.GetBufferContents([Rectangle]::new(0, 0, 80, 80))
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CopyActiveToBufferAWithWipe', 'Clearing the current buffer.')
        Clear-Host
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CopyActiveToBufferAWithWipe', 'Leaving the function.')
    }

    [Void]CopyActiveToBufferB() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CopyActiveToBufferB', 'Entering the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CopyActiveToBufferB', 'Copying a 80x80 rectangle of BufferCells from the current buffer into Buffer B.')
        $this.ScreenBufferB = $Script:Rui.GetBufferContents([Rectangle]::new(0, 0, 80, 80))
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CopyActiveToBufferB', 'Leaving the function.')
    }

    [Void]CopyActiveToBufferBWithWipe() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CopyActiveToBufferBWithWipe', 'Entering the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CopyActiveToBufferBWithWipe', 'Copying a 80x80 rectangle of BufferCells from the current buffer into Buffer B.')
        $this.ScreenBufferB = $Script:Rui.GetBufferContents([Rectangle]::new(0, 0, 80, 80))
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CopyActiveToBufferBWithWipe', 'Clearing the current buffer.')
        Clear-Host
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CopyActiveToBufferBWithWipe', 'Leaving the function.')
    }

    [Void]SwapAToB() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'SwapAToB', 'Entering the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'SwapAToB', 'Copying Buffer A contents to Buffer B.')
        $this.ScreenBufferB = $this.ScreenBufferA
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'SwapAToB', 'Leaving the function.')
    }

    [Void]SwapBToA() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'SwapBToA', 'Entering the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'SwapBToA', 'Copying Buffer B contents to Buffer A.')
        $this.ScreenBufferA = $this.ScreenBufferB
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'SwapBToA', 'Leaving the function.')
    }

    [Void]RestoreBufferAToActive() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'RestoreBufferAToActive', 'Entering the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'RestoreBufferAToActive', 'Clearing the current buffer.')
        Clear-Host
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'RestoreBufferAToActive', 'Restoring Buffer A contents to the current buffer.')
        $Script:Rui.SetBufferContents([Coordinates]::new(0, 0), $this.ScreenBufferA)
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'RestoreBufferAToActive', 'Clearing Buffer A.')
        $this.ScreenBufferA = New-Object 'BufferCell[,]' 80, 80
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'RestoreBufferAToActive', 'Leaving the function.')
    }

    [Void]RestoreBufferBToActive() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'RestoreBufferBToActive', 'Entering the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'RestoreBufferBToActive', 'Clearing the current buffer.')
        Clear-Host
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'RestoreBufferBToActive', 'Restoring Buffer B contents to the current buffer.')
        $Script:Rui.SetBufferContents([Coordinates]::new(0, 0), $this.ScreenBufferB)
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'RestoreBufferBToActive', 'Clearing Buffer B.')
        $this.ScreenBufferB = New-Object 'BufferCell[,]' 80, 80
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'RestoreBufferBToActive', 'Leaving the function.')
    }
}

Class LogManager {
    Static [String]$LogFileName = '.\Log.log'

    LogManager() {
        'WELCOME TO THE DANGER ZONE!!!' | Out-File -FilePath $([LogManager]::LogFileName)
    }

    [Void]WriteToLog(
        [String]$ClassName,
        [String]$Function,
        [String]$MessageContent
    ) {
        "$($ClassName)::$($Function) - $($MessageContent)" | Out-File -FilePath $([LogManager]::LogFileName) -Append
    }
}

Class WindowBase {
    Static [Int]$BorderDrawColorTop     = 0
    Static [Int]$BorderDrawColorBottom  = 1
    Static [Int]$BorderDrawColorLeft    = 2
    Static [Int]$BorderDrawColorRight   = 3
    Static [Int]$BorderStringHorizontal = 0
    Static [Int]$BorderStringVertical   = 1
    Static [Int]$BorderDirtyTop         = 0
    Static [Int]$BorderDirtyBottom      = 1
    Static [Int]$BorderDirtyLeft        = 2
    Static [Int]$BorderDirtyRight       = 3
    
    [ATCoordinates]$LeftTop
    [ATCoordinates]$RightBottom
    [ConsoleColor24[]]$BorderDrawColors
    [String[]]$BorderStrings
    [Boolean[]]$BorderDrawDirty
    [Int]$Width
    [Int]$Height

    WindowBase() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entering the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Initializing members to defaults.')
        $this.LeftTop          = [ATCoordinatesNone]::new()
        $this.RightBottom      = [ATCoordinatesNone]::new()
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCBlack24]::new(),
            [CCBlack24]::new(),
            [CCBlack24]::new(),
            [CCBlack24]::new()
        )
        $this.BorderStrings = [String[]](
            '',
            ''
        )
        $this.BorderDrawDirty = [Boolean[]](
            $true,
            $true,
            $true,
            $true
        )
        $this.UpdateDimensions()
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }
    
    WindowBase(
        [ATCoordinates]$LeftTop,
        [ATCoordinates]$RightBottom,
        [ConsoleColor24[]]$BorderDrawColors,
        [String[]]$BorderStrings,
        [Boolean[]]$BorderDrawDirty
    ) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor 2', 'Entering the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor 2', "Values passed are as follows: LeftTop = $($LeftTop.ToAnsiControlSequenceString()), RightBottom = $($RightBottom.ToAnsiControlSequenceString()), BorderDrawColors = $($BorderDrawColors), BorderStrings = $($BorderStrings), BorderDrawDirty = $($BorderDrawDirty).")
        $this.LeftTop          = $LeftTop
        $this.RightBottom      = $RightBottom
        $this.BorderDrawColors = $BorderDrawColors
        $this.BorderStrings    = $BorderStrings
        $this.BorderDrawDirty  = $BorderDrawDirty
        $this.UpdateDimensions()
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor 2', 'Leaving the constructor.')
    }
    
    [Void]Draw() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Entering the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Checking to see what operating system the program is running on.')
        Switch($(Test-GfmOs)) {
            { ($_ -EQ $Script:OsCheckLinux) -OR ($_ -EQ $Script:OsCheckMac) } {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'The program is running on either Linux or Mac.')
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Instantiating the borders as ATStrings.')
                [ATString]$bt = [ATStringNone]::new()
                [ATString]$bb = [ATStringNone]::new()
                [ATString]$bl = [ATStringNone]::new()
                [ATString]$br = [ATStringNone]::new()
                
                If($this.BorderDrawDirty[[WindowBase]::BorderDirtyTop]) {
                    $bt = [ATString]::new(
                        [ATStringPrefix]::new(
                            $this.BorderDrawColors[[WindowBase]::BorderDrawColorTop],
                            [ATBackgroundColor24None]::new(),
                            [ATDecorationNone]::new(),
                            $this.LeftTop
                        ),
                        "$($this.BorderStrings[[WindowBase]::BorderStringHorizontal])",
                        $false
                    )
                    $this.BorderDrawDirty[[WindowBase]::BorderDirtyTop] = $false
                }
                If($this.BorderDrawDirty[[WindowBase]::BorderDirtyBottom]) {
                    $bb = [ATString]::new(
                        [ATStringPrefix]::new(
                            $this.BorderDrawColors[[WindowBase]::BorderDrawColorBottom],
                            [ATBackgroundColor24None]::new(),
                            [ATDecorationNone]::new(),
                            [ATCoordinates]::new($this.RightBottom.Row, $this.LeftTop.Column)
                        ),
                        "$($this.BorderStrings[[WindowBase]::BorderStringHorizontal])",
                        $false
                    )
                    $this.BorderDrawDirty[[WindowBase]::BorderDirtyBottom] = $false
                }
                If($this.BorderDrawDirty[[WindowBase]::BorderDirtyLeft]) {
                    $bl = [ATString]::new(
                        [ATStringPrefix]::new(
                            $this.BorderDrawColors[[WindowBase]::BorderDrawColorLeft],
                            [ATBackgroundColor24None]::new(),
                            [ATDecorationNone]::new(),
                            [ATCoordinates]::new($this.LeftTop.Row + 1, $this.LeftTop.Column)
                        ),
                        $(Invoke-Command -ScriptBlock {
                            [String]$temp = ''

                            For($a = 0; $a -LT $this.Height; $a++) {
                                $temp += "$($this.BorderStrings[[WindowBase]::BorderStringVertical])$([ATCoordinates]::new(($this.LeftTop.Row + 1) + $a, $this.LeftTop.Column).ToAnsiControlSequenceString())"
                            }
                            
                            Return $temp
                        }),
                        $false
                    )
                    $this.BorderDrawDirty[[WindowBase]::BorderDirtyLeft] = $false
                }
                If($this.BorderDrawDirty[[WindowBase]::BorderDirtyRight]) {
                    $br = [ATString]::new(
                        [ATStringPrefix]::new(
                            $this.BorderDrawColors[[WindowBase]::BorderDrawColorRight],
                            [ATBackgroundColor24None]::new(),
                            [ATDecorationNone]::new(),
                            [ATCoordinates]::new($this.LeftTop.Row + 1, $this.RightBottom.Column + 1)
                        ),
                        $(Invoke-Command -ScriptBlock {
                            [String]$temp = ''

                            For($a = 0; $a -LT $this.Height; $a++) {
                                $temp += "$($this.BorderStrings[[WindowBase]::BorderStringVertical])$([ATCoordinates]::new(($this.LeftTop.Row + 1) + $a, $this.RightBottom.Column + 1).ToAnsiControlSequenceString())"
                            }
                            
                            Return $temp
                        }),
                        $false
                    )
                    $this.BorderDrawDirty[[WindowBase]::BorderDirtyRight] = $false
                }

                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Writing the border strings to the current buffer.')
                Write-Host "$($bt.ToAnsiControlSequenceString())$($bb.ToAnsiControlSequenceString())$($bl.ToAnsiControlSequenceString())$($br.ToAnsiControlSequenceString())"
            }
            
            { $_ -EQ $Script:OsCheckWindows } {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'The program is running on Windows.')
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Instantiating the borders as ATStrings.')
                [ATString]$bt = [ATStringNone]::new()
                [ATString]$bb = [ATStringNone]::new()
                [ATString]$bl = [ATStringNone]::new()
                [ATString]$br = [ATStringNone]::new()
                
                If($this.BorderDrawDirty[[WindowBase]::BorderDirtyTop]) {
                    $bt = [ATString]::new(
                        [ATStringPrefix]::new(
                            $this.BorderDrawColors[[WindowBase]::BorderDrawColorTop],
                            [ATBackgroundColor24None]::new(),
                            [ATDecorationNone]::new(),
                            $this.LeftTop
                        ),
                        "$($this.BorderStrings[[WindowBase]::BorderStringHorizontal])",
                        $false
                    )
                    $this.BorderDrawDirty[[WindowBase]::BorderDirtyTop] = $false
                }
                If($this.BorderDrawDirty[[WindowBase]::BorderDirtyBottom]) {
                    $bb = [ATString]::new(
                        [ATStringPrefix]::new(
                            $this.BorderDrawColors[[WindowBase]::BorderDrawColorBottom],
                            [ATBackgroundColor24None]::new(),
                            [ATDecorationNone]::new(),
                            [ATCoordinates]::new($this.RightBottom.Row, $this.LeftTop.Column)
                        ),
                        "$($this.BorderStrings[[WindowBase]::BorderStringHorizontal])",
                        $false
                    )
                    $this.BorderDrawDirty[[WindowBase]::BorderDirtyBottom] = $false
                }
                If($this.BorderDrawDirty[[WindowBase]::BorderDirtyLeft]) {
                    $bl = [ATString]::new(
                        [ATStringPrefix]::new(
                            $this.BorderDrawColors[[WindowBase]::BorderDrawColorLeft],
                            [ATBackgroundColor24None]::new(),
                            [ATDecorationNone]::new(),
                            [ATCoordinates]::new($this.LeftTop.Row + 1, $this.LeftTop.Column)
                        ),
                        $(Invoke-Command -ScriptBlock {
                            [String]$temp = ''

                            For($a = 0; $a -LT $this.Height; $a++) {
                                $temp += "$($this.BorderStrings[[WindowBase]::BorderStringVertical])$([ATCoordinates]::new(($this.LeftTop.Row + 1) + $a, $this.LeftTop.Column).ToAnsiControlSequenceString())"
                            }
                            
                            Return $temp
                        }),
                        $false
                    )
                    $this.BorderDrawDirty[[WindowBase]::BorderDirtyLeft] = $false
                }
                If($this.BorderDrawDirty[[WindowBase]::BorderDirtyRight]) {
                    $br = [ATString]::new(
                        [ATStringPrefix]::new(
                            $this.BorderDrawColors[[WindowBase]::BorderDrawColorRight],
                            [ATBackgroundColor24None]::new(),
                            [ATDecorationNone]::new(),
                            [ATCoordinates]::new($this.LeftTop.Row + 1, $this.RightBottom.Column + 1)
                        ),
                        $(Invoke-Command -ScriptBlock {
                            [String]$temp = ''

                            For($a = 0; $a -LT $this.Height; $a++) {
                                $temp += "$($this.BorderStrings[[WindowBase]::BorderStringVertical])$([ATCoordinates]::new(($this.LeftTop.Row + 1) + $a, $this.RightBottom.Column + 1).ToAnsiControlSequenceString())"
                            }
                            
                            Return $temp
                        }),
                        $false
                    )
                    $this.BorderDrawDirty[[WindowBase]::BorderDirtyRight] = $false
                }

                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Writing the borders to the current buffer.')                
                Write-Host "$($bt.ToAnsiControlSequenceString())$($bb.ToAnsiControlSequenceString())$($bl.ToAnsiControlSequenceString())$($br.ToAnsiControlSequenceString())"
            }
            
            Default {}
        }
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Leaving the function.')
    }

    [Void]UpdateDimensions() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'UpdateDimensions', 'Entering the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'UpdateDimensions', 'Calculating Width and Height as differences between RightBottom and LeftTop.')
        # $this.Width  = $this.LeftTop.Column + $this.RightBottom.Column
        # $this.Height = $this.LeftTop.Row + $this.RightBottom.Row
        $this.Width  = $this.RightBottom.Column - $this.LeftTop.Column
        $this.Height = $this.RightBottom.Row - $this.LeftTop.Row
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'UpdateDimensions', 'Leaving the function.')
    }
}

Class StatusWindow : WindowBase {
    Static [Int]$PlayerStatDrawColumn = 3
    Static [Int]$PlayerNameDrawRow    = 2
    Static [Int]$PlayerHpDrawRow      = 4
    Static [Int]$PlayerMpDrawRow      = 6
    Static [Int]$PlayerGoldDrawRow    = 9
    Static [Int]$WindowLTRow          = 1
    Static [Int]$WindowLTColumn       = 1
    Static [Int]$WindowRBRow          = 10
    Static [Int]$WindowRBColumn       = 19

    Static  [String]$WindowBorderHorizontal = '@--~---~---~---~---@'
    #Static [String]$WindowBorderHorizontal = "`u{25fd}--~---~---~---~---`u{25fd}"
    Static  [String]$WindowBorderVertical   = '|'

    Static [ATCoordinates]$PlayerNameDrawCoordinates = [ATCoordinates]::new([StatusWindow]::PlayerNameDrawRow, [StatusWindow]::PlayerStatDrawColumn)
    Static [ATCoordinates]$PlayerHpDrawCoordinates   = [ATCoordinates]::new([StatusWindow]::PlayerHpDrawRow, [StatusWindow]::PlayerStatDrawColumn)
    Static [ATCoordinates]$PlayerMpDrawCoordinates   = [ATCoordinates]::new([StatusWindow]::PlayerMpDrawRow, [StatusWindow]::PlayerStatDrawColumn)
    Static [ATCoordinates]$PlayerGoldDrawCoordinates = [ATCoordinates]::new([StatusWindow]::PlayerGoldDrawRow, [StatusWindow]::PlayerStatDrawColumn)
    # Static [ATCoordinates]$PlayerAilDrawCoordinates  = [ATCoordinates]::new(2, 11)
    
    [Boolean]$PlayerNameDrawDirty
    [Boolean]$PlayerHpDrawDirty
    [Boolean]$PlayerMpDrawDirty
    [Boolean]$PlayerGoldDrawDirty
    # [Boolean]$PlayerAilDrawDirty
    
    StatusWindow() : base() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entering the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Updating the Progress Bar for globals.')
        Write-Progress -Activity 'Creating ''global'' variables' -Id 1 -Status 'Creating Status Window' -PercentComplete -1

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Initializing members with defaults.')
        $this.LeftTop          = [ATCoordinates]::new([StatusWindow]::WindowLTRow, [StatusWindow]::WindowLTColumn)
        $this.RightBottom      = [ATCoordinates]::new([StatusWindow]::WindowRBRow, [StatusWindow]::WindowRBColumn)
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new()
        )
        $this.BorderStrings = [String[]](
            [StatusWindow]::WindowBorderHorizontal,
            [StatusWindow]::WindowBorderVertical
        )
        $this.UpdateDimensions()

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Initializing StatusWindow-specific members with defaults.')
        $this.PlayerNameDrawDirty = $true
        $this.PlayerHpDrawDirty   = $true
        $this.PlayerMpDrawDirty   = $true
        $this.PlayerGoldDrawDirty = $true
        # $this.PlayerAilDrawDirty  = $true
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }
    
    [Void]Draw() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Entering the function.')
        ([WindowBase]$this).Draw()
        
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Checking to see what operating system the program is running on.')
        Switch($(Test-GfmOs)) {
            { ($_ -EQ $Script:OsCheckLinux) -OR ($_ -EQ $Script:OsCheckMac) } {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'The program is running on either Linux or Mac.')
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Checking to see if the PlayerNameDrawDirty flag has been set.')
                If($this.PlayerNameDrawDirty) {
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It is - redrawing the Player''s Name to the buffer.')
                    Write-Host $Script:ThePlayer.GetFormattedNameString([StatusWindow]::PlayerNameDrawCoordinates)
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Setting the PlayerNameDrawDirty flag to false.')
                    $this.PlayerNameDrawDirty = $false
                }
                
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Checking to see if the PlayerHpDrawDirty flag has been set.')
                If($this.PlayerHpDrawDirty) {
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It is - redrawing the Player''s HP to the buffer.')
                    Write-Host $Script:ThePlayer.GetFormattedHitPointsString([StatusWindow]::PlayerHpDrawCoordinates)
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Setting the PlayerHpDrawDirty flag to false.')
                    $this.PlayerHpDrawDirty = $false
                }

                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Checking to see if the PlayerMpDrawDirty flag has been set.')
                If($this.PlayerMpDrawDirty) {
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It is - redrawing the Player''s MP to the buffer.')
                    Write-Host $Script:ThePlayer.GetFormattedMagicPointsString([StatusWindow]::PlayerMpDrawCoordinates)
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Setting the PlayerMpDrawDirty flag to false.')
                    $this.PlayerMpDrawDirty = $false
                }

                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Checking to see if the PlayerGoldDrawDirty flag has been set.')
                If($this.PlayerGoldDrawDirty) {
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It is - redrawing the Player''s Gold to the buffer.')
                    Write-Host $Script:ThePlayer.GetFormattedGoldString([StatusWindow]::PlayerGoldDrawCoordinates)
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Setting the PlayerGoldDrawDirty flag to false.')
                    $this.PlayerGoldDrawDirty = $false
                }
            }
            
            { $_ -EQ $Script:OsCheckWindows } {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'The program is running on Windows.')
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Checking to see if the PlayerNameDrawDirty flag has been set.')
                If($this.PlayerNameDrawDirty) {
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It is - redrawing the Player''s Name to the buffer.')
                    Write-Host $Script:ThePlayer.GetFormattedNameString([StatusWindow]::PlayerNameDrawCoordinates)
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Setting the PlayerNameDrawDirty flag to false.')
                    $this.PlayerNameDrawDirty = $false
                }

                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Checking to see if the PlayerHpDrawDirty flag has been set.')
                If($this.PlayerHpDrawDirty) {
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It is - redrawing the Player''s HP to the buffer.')
                    Write-Host $Script:ThePlayer.GetFormattedHitPointsString([StatusWindow]::PlayerHpDrawCoordinates)
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Setting the PlayerHpDrawDirty flag to false.')
                    $this.PlayerHpDrawDirty = $false
                }

                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Checking to see if the PlayerMpDrawDirty flag has been set.')
                If($this.PlayerMpDrawDirty) {
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It is - redrawing the Player''s MP to the buffer.')
                    Write-Host $Script:ThePlayer.GetFormattedMagicPointsString([StatusWindow]::PlayerMpDrawCoordinates)
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Setting the PlayerMpDrawDirty flag to false.')
                    $this.PlayerMpDrawDirty = $false
                }

                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Checking to see if the PlayerGoldDrawDirty flag has been set.')
                If($this.PlayerGoldDrawDirty) {
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It is - redrawing th Player''s Gold to the buffer.')
                    Write-Host $Script:ThePlayer.GetFormattedGoldString([StatusWindow]::PlayerGoldDrawCoordinates)
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Setting the PlayerGoldDrawDirty flag to false.')
                    $this.PlayerGoldDrawDirty = $false
                }
            }
            
            Default {}
        }
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Leaving the function.')
    }
}

Class CommandWindow : WindowBase {
    Static [Int]$CommandHistoryARef    = 0
    Static [Int]$CommandHistoryBRef    = 1
    Static [Int]$CommandHistoryCRef    = 2
    Static [Int]$CommandHistoryDRef    = 3
    Static [Int]$CommandHistoryERef    = 4
    Static [Int]$WindowLTRow           = 12
    Static [Int]$WindowLTColumn        = 1
    Static [Int]$WindowRBRow           = 20
    Static [Int]$WindowRBColumn        = 19
    Static [Int]$DrawColumnOffset      = 1
    Static [Int]$DrawDivRowOffset      = 2
    Static [Int]$DrawHistoryDRowOffset = 3
    Static [Int]$DrawHistoryCRowOffset = 4
    Static [Int]$DrawHistoryBRowOffset = 5
    Static [Int]$DrawHistoryARowOffset = 6
    Static [Int]$DrawHistoryERowOffset = 7

    Static [String]$WindowBorderHorizontal = '@--~---~---~---~---@'
    Static [String]$WindowBorderVertical   = '|'
    Static [String]$WindowCommandDiv       = '``````````````````'

    Static [ATCoordinates]$CommandDivDrawCoordinates      = [ATCoordinatesNone]::new()
    Static [ATCoordinates]$CommandHistoryEDrawCoordinates = [ATCoordinatesNone]::new()
    Static [ATCoordinates]$CommandHistoryDDrawCoordinates = [ATCoordinatesNone]::new()
    Static [ATCoordinates]$CommandHistoryCDrawCoordinates = [ATCoordinatesNone]::new()
    Static [ATCoordinates]$CommandHistoryBDrawCoordinates = [ATCoordinatesNone]::new()
    Static [ATCoordinates]$CommandHistoryADrawCoordinates = [ATCoordinatesNone]::new()

    Static [ConsoleColor24]$HistoryEntryValid   = [CCGreen24]::new()
    Static [ConsoleColor24]$HistoryEntryError   = [CCRed24]::new()
    Static [ConsoleColor24]$HistoryBlankColor   = [CCBlack24]::new()
    Static [ConsoleColor24]$CommandDivDrawColor = [CCWhite24]::new()
    Static [ATString]$CommandDiv                = [ATStringNone]::new()
    Static [ATString]$CommandBlank              = [ATStringNone]::new()
    Static [ATString]$CommandHistBlank          = [ATStringNone]::new()

    [ATString]$CommandActual
    [ATString[]]$CommandHistory

    [Boolean]$CommandDivDirty
    [Boolean]$CommandHistoryDirty

    CommandWindow() : base() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entering the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Updating the Progress Bar for globals.')
        Write-Progress -Activity 'Creating ''global'' variables' -Id 1 -Status 'Creating the Command Window' -PercentComplete -1
        
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Initializing members to defaults.')
        $this.LeftTop     = [ATCoordinates]::new([CommandWindow]::WindowLTRow, [CommandWindow]::WindowLTColumn)
        $this.RightBottom = [ATCoordinates]::new([CommandWindow]::WindowRBRow, [CommandWindow]::WindowRBColumn)
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new()
        )
        $this.BorderStrings = [String[]](
            [CommandWindow]::WindowBorderHorizontal,
            [CommandWindow]::WindowBorderVertical
        )
        $this.UpdateDimensions()

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Setting CommandWindow-specific members to defaults.')
        $this.CommandDivDirty     = $true
        $this.CommandHistoryDirty = $false

        [Int]$rowBase    = $this.RightBottom.Row
        [Int]$columnBase = $this.LeftTop.Column + [CommandWindow]::DrawColumnOffset

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Calculating history draw coordinates.')
        [CommandWindow]::CommandDivDrawCoordinates      = [ATCoordinates]::new($rowBase - [CommandWindow]::DrawDivRowOffset, $columnBase)
        [CommandWindow]::CommandHistoryEDrawCoordinates = [ATCoordinates]::new($rowBase - [CommandWindow]::DrawHistoryERowOffset, $columnBase)
        [CommandWindow]::CommandHistoryDDrawCoordinates = [ATCoordinates]::new($rowBase - [CommandWindow]::DrawHistoryDRowOffset, $columnBase)
        [CommandWindow]::CommandHistoryCDrawCoordinates = [ATCoordinates]::new($rowBase - [CommandWindow]::DrawHistoryCRowOffset, $columnBase)
        [CommandWindow]::CommandHistoryBDrawCoordinates = [ATCoordinates]::new($rowBase - [CommandWindow]::DrawHistoryBRowOffset, $columnBase)
        [CommandWindow]::CommandHistoryADrawCoordinates = [ATCoordinates]::new($rowBase - [CommandWindow]::DrawHistoryARowOffset, $columnBase)

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Coordinates have been calculated as follows:')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', "Div: R$([CommandWindow]::CommandDivDrawCoordinates.Row), C$([CommandWindow]::CommandDivDrawCoordinates.Column).")
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', "E: R$([CommandWindow]::CommandHistoryEDrawCoordinates.Row), C$([CommandWindow]::CommandHistoryEDrawCoordinates.Column).")
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', "D: R$([CommandWindow]::CommandHistoryDDrawCoordinates.Row), C$([CommandWindow]::CommandHistoryDDrawCoordinates.Column).")
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', "C: R$([CommandWindow]::CommandHistoryCDrawCoordinates.Row), C$([CommandWindow]::CommandHistoryCDrawCoordinates.Column).")
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', "B: R$([CommandWindow]::CommandHistoryBDrawCoordinates.Row), C$([CommandWindow]::CommandHistoryBDrawCoordinates.Column).")
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', "A: R$([CommandWindow]::CommandHistoryADrawCoordinates.Row), C$([CommandWindow]::CommandHistoryADrawCoordinates.Column).")

        [CommandWindow]::CommandDiv = [ATString]::new(
            [ATStringPrefix]::new(
                [CommandWindow]::CommandDivDrawColor,
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [CommandWindow]::CommandDivDrawCoordinates
            ),
            [CommandWindow]::WindowCommandDiv,
            $true
        )
        [CommandWindow]::CommandBlank = [ATString]::new(
            [ATStringPrefix]::new(
                [CommandWindow]::HistoryBlankColor,
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinatesNone]::new() # These can't yet be specified
            ),
            '                  ',
            $true
        )
        [CommandWindow]::CommandHistBlank = [ATString]::new(
            [ATStringPrefix]::new(
                [CommandWindow]::HistoryBlankColor,
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinatesNone]::new() # These can't yet be specified
            ),
            '                  ',
            $true
        )

        $this.CommandActual                                       = [ATStringNone]::new()
        $this.CommandHistory                                      = New-Object 'ATString[]' 5 # This literal can't be codified; PS requires it be here
        $this.CommandHistory[[CommandWindow]::CommandHistoryARef] = [ATString]::new(
            [ATStringPrefix]::new(
                [CCTextDefault24]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [CommandWindow]::CommandHistoryADrawCoordinates
            ),
            [CommandWindow]::CommandBlank.UserData,
            $true
        )
        $this.CommandHistory[[CommandWindow]::CommandHistoryBRef] = [ATString]::new(
            [ATStringPrefix]::new(
                [CCTextDefault24]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [CommandWindow]::CommandHistoryBDrawCoordinates
            ),
            [CommandWindow]::CommandBlank.UserData,
            $true
        )
        $this.CommandHistory[[CommandWindow]::CommandHistoryCRef] = [ATString]::new(
            [ATStringPrefix]::new(
                [CCTextDefault24]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [CommandWindow]::CommandHistoryCDrawCoordinates
            ),
            [CommandWindow]::CommandBlank.UserData,
            $true
        )
        $this.CommandHistory[[CommandWindow]::CommandHistoryDRef] = [ATString]::new(
            [ATStringPrefix]::new(
                [CCTextDefault24]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [CommandWindow]::CommandHistoryDDrawCoordinates
            ),
            [CommandWindow]::CommandBlank.UserData,
            $true
        )
        $this.CommandHistory[[CommandWindow]::CommandHistoryERef] = [ATString]::new(
            [ATStringPrefix]::new(
                [CCTextDefault24]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [CommandWindow]::CommandHistoryEDrawCoordinates
            ),
            [CommandWindow]::CommandBlank.UserData,
            $true
        )
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }

    [Void]Draw() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Entering the function.')
        ([WindowBase]$this).Draw()

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Checking to see if the CommandDivDirty flag is set.')
        If($this.CommandDivDirty -EQ $true) {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It is - redrawing the div to the buffer.')
            Write-Host "$([CommandWindow]::CommandDiv.ToAnsiControlSequenceString())"
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Resetting the CommandDivDirty flag to false.')
            $this.CommandDivDirty = $false
        }

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Checking to see if the CommandHistoryDirty flag is set.')
        If($this.CommandHistoryDirty -EQ $true) {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It is - redrawing the history items to the buffer.')
            [CommandWindow]::CommandHistBlank.Prefix.Coordinates = [CommandWindow]::CommandHistoryDDrawCoordinates
            Write-Host "$([CommandWindow]::CommandHistBlank.ToAnsiControlSequenceString())"
            Write-Host "$($this.CommandHistory[[CommandWindow]::CommandHistoryDRef].ToAnsiControlSequenceString())"

            [CommandWindow]::CommandHistBlank.Prefix.Coordinates = [CommandWindow]::CommandHistoryCDrawCoordinates
            Write-Host "$([CommandWindow]::CommandHistBlank.ToAnsiControlSequenceString())"
            Write-Host "$($this.CommandHistory[[CommandWindow]::CommandHistoryCRef].ToAnsiControlSequenceString())"

            [CommandWindow]::CommandHistBlank.Prefix.Coordinates = [CommandWindow]::CommandHistoryBDrawCoordinates
            Write-Host "$([CommandWindow]::CommandHistBlank.ToAnsiControlSequenceString())"
            Write-Host "$($this.CommandHistory[[CommandWindow]::CommandHistoryBRef].ToAnsiControlSequenceString())"

            [CommandWindow]::CommandHistBlank.Prefix.Coordinates = [CommandWindow]::CommandHistoryADrawCoordinates
            Write-Host "$([CommandWindow]::CommandHistBlank.ToAnsiControlSequenceString())"
            Write-Host "$($this.CommandHistory[[CommandWindow]::CommandHistoryARef].ToAnsiControlSequenceString())"

            [CommandWindow]::CommandHistBlank.Prefix.Coordinates = [CommandWindow]::CommandHistoryEDrawCoordinates
            Write-Host "$([CommandWindow]::CommandHistBlank.ToAnsiControlSequenceString())"
            Write-Host "$($this.CommandHistory[[CommandWindow]::CommandHistoryERef].ToAnsiControlSequenceString())"

            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Resetting the CommandHistoryDirty flag to false.')
            $this.CommandHistoryDirty = $false
        }
    }

    [Void]HandleInput() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', 'Entering the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', 'Setting the Cursor Position to the default one.')
        $Script:Rui.CursorPosition = $Script:DefaultCursorCoordinates.ToAutomationCoordinates()
        
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', 'Start the initial ReadKey call and store the result.')
        $keyCap = $Script:Rui.ReadKey('IncludeKeyDown')

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', 'Starting to loop until the VirtualKeyCode of the key pressed is NOT EQUAL to 13 (Enter).')
        While($keyCap.VirtualKeyCode -NE 13) {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', 'Loop started.')
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', 'Getting the current X (Column) value of the current Cursor Position.')
            $cpx = $Script:Rui.CursorPosition.X
            
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', 'Checking to see if the current X (Column) value of the current Cursor Position is GREATER THAN OR EQUAL TO 19.')
            If($cpx -GE 19) {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', 'It is - automatically invoke the Command Parser as this is a command phrase length violation.')
                $this.InvokeCommandParser()
            }
            
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', 'Checking to see what the value of VirtualKeyCode is.')
            Switch($keyCap.VirtualKeyCode) {
                8 { # Backspace
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', 'Backspace Key has been pressed.')
                    
                    $fpx = $Script:Rui.CursorPosition.X
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', "Obtaining current Cursor Position X (Row) value. The current value is $(fpx).")

                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', "Comparing FPX against the Default Coordinates X (Row). The default value is $($Script:DefaultCursorCoordinates.Row), and FPX is $($fpx).")
                    If($fpx -GT $Script:DefaultCursorCoordinates.Row) {
                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', 'FPX is GREATER THAN the Default Coordinates X (Row).')
                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', "The character that would be deleted here is $($this.CommandActual.UserData[$fpx - 1]).")
                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', 'Performing character deletion from the Command Window.')
                        Write-Host " `b" -NoNewLine

                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', "The current value of Command Actual is $($this.CommandActual.UserData). Attempting to delete the last character.")
                        If($this.CommandActual.UserData.Length -GT 0) {
                            $this.CommandActual.UserData = $this.CommandActual.UserData.Remove($this.CommandActual.UserData.Length - 1, 1)
                            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', "The last character has been deleted. The current value of Command Actual is $($this.CommandActual.UserData).")
                        } Else {
                            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', 'Command Actual has no data in it; there''s nothing to delete.')
                        }
                    } Elseif($fpx -LT $Script:DefaultCursorCoordinates.Row) {
                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', 'FPX is LESS THAN the Default Coordinates X (Row).')
                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', 'This character can''t be deleted because it''s part of the window. Resetting the Cursor X (ROw) position to the default.')
                        $Script:Rui.CursorPosition = $Script:DefaultCursorCoordinates.ToAutomationCoordinates()
                        # Write-Host "`b " -NoNewLine
                    } Elseif($fpx -EQ $Script:DefaultCursorCoordinates.Row) {
                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', 'FPX is EQUAL TO the Default Coordinates X (Row).')
                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', "The character that would be deleted here is $($this.CommandActual.UserData[$fpx - 1]).")
                        Write-Host " `b" -NoNewline

                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', "The current value of Command Actual is $($this.CommandActual.UserData). Attempting to delete the last character.")
                        If($this.CommandActual.UserData.Length -GT 0) {
                            $this.CommandActual.UserData = $this.CommandActual.UserData.Remove($this.CommandActual.UserData.Length - 1, 1)
                            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', "The last character has been deleted. The current value of Command Actual is $($this.CommandActual.UserData).")
                        } Else {
                            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', 'Command Actual has no data in it; there''s nothing to delete.')
                        }
                    }
                }
    
                Default {
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', "A regular keypress has been detected. Adding $($keyCap.Character) to Command Actual.")
                    $this.CommandActual.UserData += $keyCap.Character
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', "The current value of Command Actual is $($this.CommandActual.UserData).")
                }
            }

            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', 'Starting the next iteration of ReadKey.')
            $keyCap = $Script:Rui.ReadKey('IncludeKeyDown')
        }

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', 'Invoking the Command Parser.')
        $this.InvokeCommandParser()
    }

    [Void]InvokeCommandParser() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeCommandParser', 'Starting the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeCommandParser', 'Writing the Command Blank in the default position.')
        $Script:Rui.CursorPosition = $Script:DefaultCursorCoordinates.ToAutomationCoordinates()
        Write-Host "$([CommandWindow]::CommandBlank.ToAnsiControlSequenceString())" -NoNewline
        $Script:Rui.CursorPosition = $Script:DefaultCursorCoordinates.ToAutomationCoordinates()

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeCommandParser', 'Checking to see if Command Actual contains anything.')
        If([String]::IsNullOrEmpty($this.CommandActual.UserData)) {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeCommandParser', 'It doesn''t. Exiting.')
            Return
        } Else {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeCommandParser', "It contains data. The current data is $($this.CommandActual.UserData). Attempting to split the string.")
            $cmdactSplit = -SPLIT $this.CommandActual.UserData
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeCommandParser', "Split is successful. The split data is $($cmdactSplit).")
            
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeCommandParser', 'Attempting to find the root command in the Command Table.')
            $rootFound = $Script:TheCommandTable.GetEnumerator() | Where-Object { $_.Name -IEQ $cmdactSplit[0] }
            
            If($null -NE $rootFound) {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeCommandParser', "A root command has been identified as $($cmdactSplit[0]). Now checking the length of the split to determine the ScriptBlock invocation style.")
                Switch($cmdactSplit.Length) {
                    1 {
                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeCommandParser', "Split length is 1, invoking the root command '$($cmdactSplit[0])' without arguments.")
                        Invoke-Command $rootFound.Value
                    }

                    2 {
                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeCommandParser', "Split length is 2, invoking the root command '$($cmdactSplit[0])' with one argument '$($cmdactSplit[1])'.")
                        Invoke-Command $rootFound.Value -ArgumentList $cmdactSplit[1]
                    }

                    3 {
                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeCommandParser', "Split length is 3, invoking the root comand '$($cmdactSplit[0])' with two arguments: '$($cmdactSplit[1])' and '$($cmdactSplit[2])'.")
                        Invoke-Command $rootFound.Value -ArgumentList $cmdactSplit[1], $cmdactSplit[2]
                    }

                    Default {
                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeCommandParser', 'An unknown exceptional case has occurred. Updating the Command History in the Command Window.')
                        $Script:TheCommandWindow.UpdateCommandHistory($false)
                        # TODO: This is an exceptional case
                    }
                }
            } Else {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeCommandParser', 'An invalid command has been typed in. Updating the Command History in the Command Window.')
                $Script:TheCommandWindow.UpdateCommandHistory($false)
                Return
            }
        }
    }

    [Void]InvokeItemReactor(
        [String]$ItemName
    ) {
        $a = $Script:CurrentMap.GetTileAtPlayerCoordinates().ObjectListing

        If($a.Count -EQ 0) {
            # There are no objects on this map tile
            # TODO: Update the Command History with a valid response
            # TODO: Write to the message window that there weren't any items found
        }
    }

    [Void]InvokeLookAction() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeLookAction', 'Starting the function.')
        $a = $Script:CurrentMap.GetTileAtPlayerCoordinates().ObjectListing
        $b = 78
        $c = ''
        $f = ''
        $z = 0
        $y = $false

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeLookAction', 'Checking to see if there are any objects in the Current Map Tile.')
        If($a.Count -LE 0) {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeLookAction', 'There aren''t any objects here. Notifying the Command Window.')
            $Script:TheMessageWindow.WriteMapNoItemsFoundMessage()
            Return
        }

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeLookAction', 'Building the string that will have all of the objects in the Current Map Tile.')
        Foreach($d in $a) {
            If($z -EQ $a.Count - 1) {
                $c += $d.Name
            } Else {
                $c += $d.Name + ', '
            }
            $z++
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeLookAction', "The current string value is $($c).")
        }
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeLookAction', "Getting the length of C. It's currently $($c.Length).")
        $e = $c.Length

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeLookAction', 'Checking to see if the length of C is GREATER THAN 78.')
        If($e -GT $b) {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeLookAction', 'The length of C is GREATER THAN 78.')
            $y = $true

            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeLookAction', 'Executing a regex to get the first five matches of the item string.')
            $c -MATCH '([\s,]+\w+){5}$' | Out-Null
            If($_ -EQ $true) {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeLookAction', 'There are more than five matches - split the remainder into a different string.')
                $c = $c -REPLACE '([\s,]+\w+){5}$', ''
                $f = $matches[0].Remove(0, 2)
            }
        }

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeLookAction', 'Writing the base messages to the Message Window.')
        $Script:TheMessageWindow.WriteMessage(
            'I can see the following things here:',
            [CCAppleIndigoDark24]::new(),
            [ATDecorationNone]::new()
        )
        $Script:TheMessageWindow.WriteMessage(
            $c,
            [CCApplePinkDark24]::new(),
            [ATDecorationNone]::new()
        )

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeLookAction', 'Checking to see if we have overflow.')
        If($y -EQ $true) {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeLookAction', 'We have overflow - writing the split string as well.')
            $Script:TheMessageWindow.WriteMessage(
                $f,
                [CCApplePinkDark24]::new(),
                [ATDecorationNone]::new()
            )
        }
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeLookAction', 'Leaving the function.')
    }

    [Void]InvokeExamineAction(
        [String]$ItemName
    ) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeExamineAction', 'Entered the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeExamineAction', 'Iterating through the current tile''s Object Listing to find an Item Name match.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeExamineAction', "The Item Name we're looking for is $($ItemName).")
        Foreach($a in $Script:CurrentMap.GetTileAtPlayerCoordinates().ObjectListing) {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeExamineAction', "The iterator Item Name is $($a.Name).")
            If($a.Name -IEQ $ItemName) {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeExamineAction', 'Match has been found. Updating the Command History in the Command Window.')
                $Script:TheCommandWindow.UpdateCommandHistory($true)
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeExamineAction', 'Writing the Item''s ExamineString to the Message Window History.')
                $Script:TheMessageWindow.WriteMessage(
                    "$($a.ExamineString)",
                    [CCAppleMintDark24]::new(),
                    [ATDecorationNone]::new()
                )
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeExamineAction', 'Leaving the function.')
                Return
            }
        }

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeExamineAction', 'Match has NOT been found. Updating the Command History in the Command Window.')
        $Script:TheCommandWindow.UpdateCommandHistory($false)
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeExamineAction', 'Writing a message to the Message Window.')
        $Script:TheMessageWindow.WriteMapInvalidItemMessage($ItemName)
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeExamineAction', 'Leaving the function.')
        Return
    }

    [Void]InvokeGetAction(
        [String]$ItemName
    ) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeGetAction', 'Entered the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeGetAction', 'Getting a reference to the current Map Tile''s Object Listing.')
        $a = $Script:CurrentMap.GetTileAtPlayerCoordinates().ObjectListing
        
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeGetAction', 'Checking to see if the length of the reference is LESS THAN OR EQUAL TO zero.')
        If($a.Count -LE 0) {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeGetAction', 'It is, meaning there''s nothing on this tile.')
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeGetAction', 'Updating the Command History and the Message Window History.')
            $Script:TheCommandWindow.UpdateCommandHistory($false)
            $Script:TheMessageWindow.WriteMapNoItemsFoundMessage()
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeGetAction', 'Leaving the function.')
            Return
        }

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeGetAction', 'The length of the reference is at least 1.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeGetAction', 'Iterating through the reference collection to see if we can find a name match.')
        Foreach($b in $a) {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeGetAction', "The Item Name we're looking for is $($ItemName).")
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeGetAction', "The current iteration's name is $($b.Name).")
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeGetAction', 'Checking to see if these match.')
            If($b.Name -IEQ $ItemName) {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeGetAction', 'A match has been found.')
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeGetAction', 'Checking to see if this Item can be added to the Player''s Inventory.')
                If($b.CanAddToInventory -EQ $true) {
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeGetAction', 'It can - copying the current Item into the Player''s Inventory collection.')
                    $Script:ThePlayer.Inventory.Add($b) | Out-Null
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeGetAction', 'Attempting to remove this Item from the Current Map Tile''s Object Listing.')
                    $c = $a.Remove($b) | Out-Null
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeGetAction', 'Checking to see if the removal was successful or not.')
                    If($c -EQ $false) {
                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeGetAction', 'The removal failed.')
                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeGetAction', 'THIS IS A CRITICAL ERROR - PREMATUREL TERMINATING THE PROGRAM!')
                        Write-Error 'Failed to remove an item from the Map Tile!'
                        Exit
                    } Else {
                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeGetAction', 'The removal was successful.')
                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeGetAction', 'Updating the Command History and the Message Window History.')
                        $Script:TheCommandWindow.UpdateCommandHistory($true)
                        $Script:TheMessageWindow.WriteItemTakenMessage($ItemName)
                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeGetAction', 'Leaving the function.')
                        Return
                    }
                } Else {
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeGetAction', 'It can''t. Updating the Command History and the Message History.')
                    $Script:TheCommandWindow.UpdateCommandHistory($true)
                    $Script:TheMessageWindow.WriteItemCantTakeMessage($ItemName)
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeGetAction', 'Leaving the function.')
                    Return
                }
            }
        }

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeGetAction', 'Although there are Items in the reference collection, none of them match the terms.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeGetAction', 'Updating the Command History and Message Window History.')
        $Script:TheCommandWindow.UpdateCommandHistory($false)
        $Script:TheMessageWindow.WriteMapInvalidItemMessage($ItemName)
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'InvokeGetAction', 'Leaving the function.')
        Return
    }

    [Void]UpdateCommandHistory(
        [Boolean]$CmdValid
    ) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'UpdateCommandHistory', 'Entered the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'UpdateCommandHistory', 'Starting to shuffle the Command History around.')
        
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'UpdateCommandHistory', "Setting History E ('$($this.CommandHistory[[CommandWindow]::CommandHistoryERef].UserData)') to History A ('$($this.CommandHistory[[CommandWindow]::CommandHistoryARef].UserData)').")
        $this.CommandHistory[[CommandWindow]::CommandHistoryERef].UserData               = $this.CommandHistory[[CommandWindow]::CommandHistoryARef].UserData
        $this.CommandHistory[[CommandWindow]::CommandHistoryERef].Prefix.Decorations     = $this.CommandHistory[[CommandWindow]::CommandHistoryARef].Prefix.Decorations
        $this.CommandHistory[[CommandWindow]::CommandHistoryERef].Prefix.ForegroundColor = $this.CommandHistory[[CommandWindow]::CommandHistoryARef].Prefix.ForegroundColor

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'UpdateCommandHistory', "Setting History A ('$($this.CommandHistory[[CommandWindow]::CommandHistoryARef].UserData)') to History B ('$($this.CommandHistory[[CommandWindow]::CommandHistoryBRef].UserData)').")
        $this.CommandHistory[[CommandWindow]::CommandHistoryARef].UserData               = $this.CommandHistory[[CommandWindow]::CommandHistoryBRef].UserData
        $this.CommandHistory[[CommandWindow]::CommandHistoryARef].Prefix.Decorations     = $this.CommandHistory[[CommandWindow]::CommandHistoryBRef].Prefix.Decorations
        $this.CommandHistory[[CommandWindow]::CommandHistoryARef].Prefix.ForegroundColor = $this.CommandHistory[[CommandWindow]::CommandHistoryBRef].Prefix.ForegroundColor
        
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'UpdateCommandHistory', "Setting History B ('$($this.CommandHistory[[CommandWindow]::CommandHistoryBRef].UserData)') to History C ('$($this.CommandHistory[[CommandWindow]::CommandHistoryCRef].UserData)').")
        $this.CommandHistory[[CommandWindow]::CommandHistoryBRef].UserData               = $this.CommandHistory[[CommandWindow]::CommandHistoryCRef].UserData
        $this.CommandHistory[[CommandWindow]::CommandHistoryBRef].Prefix.Decorations     = $this.CommandHistory[[CommandWindow]::CommandHistoryCRef].Prefix.Decorations
        $this.CommandHistory[[CommandWindow]::CommandHistoryBRef].Prefix.ForegroundColor = $this.CommandHistory[[CommandWindow]::CommandHistoryCRef].Prefix.ForegroundColor
        
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'UpdateCommandHistory', "CommandWindow::UpdateCommandHistory - Setting History C ('$($this.CommandHistory[[CommandWindow]::CommandHistoryCRef].UserData)') to History D ('$($this.CommandHistory[[CommandWindow]::CommandHistoryDRef].UserData)').")
        $this.CommandHistory[[CommandWindow]::CommandHistoryCRef].UserData               = $this.CommandHistory[[CommandWindow]::CommandHistoryDRef].UserData
        $this.CommandHistory[[CommandWindow]::CommandHistoryCRef].Prefix.Decorations     = $this.CommandHistory[[CommandWindow]::CommandHistoryDRef].Prefix.Decorations
        $this.CommandHistory[[CommandWindow]::CommandHistoryCRef].Prefix.ForegroundColor = $this.CommandHistory[[CommandWindow]::CommandHistoryDRef].Prefix.ForegroundColor
        
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'UpdateCommandHistory', "Setting History D ('$($this.CommandHistory[[CommandWindow]::CommandHistoryDRef].UserData)') to Command Actual ('$($this.CommandActual.UserData)').")
        $this.CommandHistory[[CommandWindow]::CommandHistoryDRef].UserData = $this.CommandActual.UserData

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'UpdateCommandHistory', "The current layout of the history is as follows: E: $($this.CommandHistory[[CommandWindow]::CommandHistoryERef].UserData), A: $($this.CommandHistory[[CommandWindow]::CommandHistoryARef].UserData), B: $($this.CommandHistory[[CommandWindow]::CommandHistoryBRef].UserData), C: $($this.CommandHistory[[CommandWindow]::CommandHistoryCRef].UserData), D: $($this.CommandHistory[[CommandWindow]::CommandHistoryDRef].UserData).")

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'UpdateCommandHistory', 'Checking to see if the Command Valid flag is true or false.')
        If($CmdValid -EQ $true) {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'UpdateCommandHistory', 'The Command Valid flag is true. Set the Foreground Color to HistoryEntryValid.')
            $this.CommandHistory[[CommandWindow]::CommandHistoryDRef].Prefix.ForegroundColor = [CommandWindow]::HistoryEntryValid
            $this.CommandHistory[[CommandWindow]::CommandHistoryDRef].Prefix.Decorations     = [ATDecorationNone]::new()
        } Else {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'UpdateCommandHistory', 'The Command Valid flag is false. Set the Foreground Color to HistoryEntryError and set the Decoration to Blink.')
            $this.CommandHistory[[CommandWindow]::CommandHistoryDRef].Prefix.ForegroundColor = [CommandWindow]::HistoryEntryError
            $this.CommandHistory[[CommandWindow]::CommandHistoryDRef].Prefix.Decorations = [ATDecoration]::new($true)
        }

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'UpdateCommandHistory', 'Clearing the Command Actual.')
        $this.CommandActual.UserData = ''

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'UpdateCommandHistory', 'Set the CommandHistoryDirty flag to true so the Draw function will draw the strings to the console.')
        $this.CommandHistoryDirty = $true

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'UpdateCommandHistory', 'Leaving the function.')
    }
}

Class SceneWindow : WindowBase {
    Static [Int]$WindowLTRow           = 1
    Static [Int]$WindowLTColumn        = 30
    Static [Int]$WindowRBRow           = 20
    Static [Int]$WindowRBColumn        = 78
    Static [Int]$ImageDrawRowOffset    = [SceneWindow]::WindowLTRow + 1
    Static [Int]$ImageDrawColumnOffset = [SceneWindow]::WindowLTColumn + 1
    

    Static [String]$WindowBorderHorizontal = '@-<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>-@'
    Static [String]$WindowBorderVertical   = '|'

    Static [ATCoordinates]$SceneImageDrawCoordinates = [ATCoordinatesNone]::new()

    [Boolean]$SceneImageDirty = $true
    [SceneImage]$Image        = [SIEmpty]::new()

    SceneWindow(): base() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entering the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Updating the Progress Bar for globals.')
        Write-Progress -Activity 'Creating ''global'' variables' -Id 1 -Status 'Creating the Scene Window' -PercentComplete -1

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Initializing the members to defaults.')
        $this.LeftTop          = [ATCoordinates]::new([SceneWindow]::WindowLTRow, [SceneWindow]::WindowLTColumn)
        $this.RightBottom      = [ATCoordinates]::new([SceneWindow]::WindowRBRow, [SceneWindow]::WindowRBColumn)
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new()
        )
        $this.BorderStrings = [String[]](
            [SceneWindow]::WindowBorderHorizontal,
            [SceneWindow]::WindowBorderVertical
        )
        $this.UpdateDimensions()

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Initializing the custom members to defaults.')
        #[SceneWindow]::SceneImageDrawCoordinates = [ATCoordinates]::new($this.LeftTop.Row + [SceneWindow]::ImageDrawRowOffset, $this.LeftTop.Column + [SceneWindow]::ImageDrawColumnOffset)
        [SceneWindow]::SceneImageDrawCoordinates = [ATCoordinates]::new([SceneWindow]::ImageDrawRowOffset, [SceneWindow]::ImageDrawColumnOffset)

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }
    
    [Void]Draw() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Entering the function.')
        ([WindowBase]$this).Draw()

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Checking to see if the SceneImageDirty flag is set.')
        If($this.SceneImageDirty) {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It is - redrawing the Scene Image.')
            Write-Host "$($this.Image.ToAnsiControlSequenceString())"
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Setting the SceneImageDirty flag to false.')
            $this.SceneImageDirty = $false
        }

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Leaving the function.')
    }

    [Void]UpdateCurrentImage([SceneImage]$NewImage) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'UpdateCurrentImage', 'Entering the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'UpdateCurrentImage', 'Updating the value of Image and setting the SceneImageDirty flag to true.')
        $this.Image           = $NewImage
        $this.SceneImageDirty = $true
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'UpdateCurrentImage', 'Leaving the function.')
    }
}

Class MessageWindow : WindowBase {
    Static [Int]$MessageHistoryARef = 0
    Static [Int]$MessageHistoryBRef = 1
    Static [Int]$MessageHistoryCRef = 2
    Static [Int]$WindowLTRow        = 21
    Static [Int]$WindowLTColumn     = 1
    Static [Int]$WindowBRRow        = 26
    Static [Int]$WindowBRColumn     = 80
    
    Static [String]$WindowBorderHorizontal = '-------------------------------------------------------------------------------'
    Static [String]$WindowBorderVertical   = '|'

    Static [ATCoordinates]$MessageADrawCoordinates = [ATCoordinatesNone]::new()
    Static [ATCoordinates]$MessageBDrawCoordinates = [ATCoordinatesNone]::new()
    Static [ATCoordinates]$MessageCDrawCoordinates = [ATCoordinatesNone]::new()

    Static [ATString]$MessageWindowBlank = [ATStringNone]::new()

    [ATString[]]$MessageHistory

    [Boolean]$MessageADirty = $false
    [Boolean]$MessageBDirty = $false
    [Boolean]$MessageCDirty = $false
    
    MessageWindow() : base() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entering the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Updating the Progress Bar for the globals.')
        Write-Progress -Activity 'Creating ''global'' variables' -Id 1 -Status 'Creating the Message Window' -PercentComplete -1

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Initializing the members to defaults.')
        $this.LeftTop          = [ATCoordinates]::new(21, 1)
        $this.RightBottom      = [ATCoordinates]::new(25, 78)
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new()
        )
        $this.BorderStrings = [String[]](
            [MessageWindow]::WindowBorderHorizontal,
            [MessageWindow]::WindowBorderVertical
        )
        $this.UpdateDimensions()

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Calculating the Message Draw Coordinates.')

        [MessageWindow]::MessageCDrawCoordinates = [ATCoordinates]::new(($this.RightBottom.Row - 1), ($this.LeftTop.Column + 1))
        [MessageWindow]::MessageBDrawCoordinates = [ATCoordinates]::new(([MessageWindow]::MessageCDrawCoordinates.Row - 1), ($this.LeftTop.Column + 1))
        [MessageWindow]::MessageADrawCoordinates = [ATCoordinates]::new(([MessageWindow]::MessageBDrawCoordinates.Row - 1), ($this.LeftTop.Column + 1))

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'The calculated coordinates are as follows:')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', "Message A: (R$([MessageWindow]::MessageADrawCoordinates.Row), C$([MessageWindow]::MessageADrawCoordinates.Column)).")
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', "Message B: (R$([MessageWindow]::MessageBDrawCoordinates.Row), C$([MessageWindow]::MessageBDrawCoordinates.Column)).")
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', "Message C: (R$([MessageWindow]::MessageCDrawCoordinates.Row), C$([MessageWindow]::MessageCDrawCoordinates.Column)).")

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Initialize the custom members with defaults.')
        [MessageWindow]::MessageWindowBlank = [ATString]::new(
            [ATStringPrefix]::new(
                [ATForegroundColor24None]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinatesNone]::new()
            ),
            '                                                                             ',
            $true
        )

        $this.MessageHistory = New-Object 'ATString[]' 3

        $this.MessageHistory[[MessageWindow]::MessageHistoryARef] = [ATString]::new(
            [ATStringPrefix]::new(
                [CCTextDefault24]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [MessageWindow]::MessageADrawCoordinates
            ),
            [MessageWindow]::MessageWindowBlank.UserData,
            $true
        )
        $this.MessageHistory[[MessageWindow]::MessageHistoryBRef] = [ATString]::new(
            [ATStringPrefix]::new(
                [CCTextDefault24]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [MessageWindow]::MessageBDrawCoordinates
            ),
            [MessageWindow]::MessageWindowBlank.UserData,
            $true
        )
        $this.MessageHistory[[MessageWindow]::MessageHistoryCRef] = [ATString]::new(
            [ATStringPrefix]::new(
                [CCTextDefault24]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [MessageWindow]::MessageCDrawCoordinates
            ),
            [MessageWindow]::MessageWindowBlank.UserData,
            $true
        )

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }

    [Void]Draw() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Entering the function.')
        ([WindowBase]$this).Draw()

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Checking to see if the MessageADirty flag is set.')
        If($this.MessageADirty -EQ $true) {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It''s set - redrawing Message A to the window at it''s predefined coordinates (blank first, then string).')
            [MessageWindow]::MessageWindowBlank.Prefix.Coordinates = $this.MessageHistory[[MessageWindow]::MessageHistoryARef].Prefix.Coordinates
            Write-Host "$([MessageWindow]::MessageWindowBlank.ToAnsiControlSequenceString())"
            Write-Host "$($this.MessageHistory[[MessageWindow]::MessageHistoryARef].ToAnsiControlSequenceString())"

            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Setting MessageADirty flag to false.')
            $this.MessageADirty = $false
        }

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Checking to see if the MessageBDirty flag is set.')
        If($this.MessageBDirty -EQ $true) {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It''s set - redrawing Message B to the window at it''s predeinfed coordinates (blank first, then string).')
            [MessageWindow]::MessageWindowBlank.Prefix.Coordinates = $this.MessageHistory[[MessageWindow]::MessageHistoryBRef].Prefix.Coordinates
            Write-Host "$([MessageWindow]::MessageWindowBlank.ToAnsiControlSequenceString())"
            Write-Host "$($this.MessageHistory[[MessageWindow]::MessageHistoryBRef].ToAnsiControlSequenceString())"

            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Setting MessageBDirty flag to false.')
            $this.MessageBDirty = $false
        }

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Checking to see if the MessageCDirty flag is set.')
        If($this.MessageCDirty -EQ $true) {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It''s set - redrawing Message C to the window at it''s predefined coordinates (blank first, then string).')
            [MessageWindow]::MessageWindowBlank.Prefix.Coordinates = $this.MessageHistory[[MessageWindow]::MessageHistoryCRef].Prefix.Coordinates
            Write-Host "$([MessageWindow]::MessageWindowBlank.ToAnsiControlSequenceString())"
            Write-Host "$($this.MessageHistory[[MessageWindow]::MessageHistoryCRef].ToAnsiControlSequenceString())"

            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Setting the MessageCDirty flag to false.')
            $this.MessageCDirty = $false
        }

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Leaving the function.')
    }

    [Void]WriteMessage([String]$Message, [ATForegroundColor24]$ForegroundColor, [ATDecoration]$Decoration) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteMessage', 'Entering the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteMessage', "Parameter Values: Message = $($Message), ForegroundColor = $($ForegroundColor), Decoration = $($Decoration).")

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteMessage', 'Setting Message A UserData, Prefix.Decorations, and Prefix.ForegroundColor to those of Message B.')
        $this.MessageHistory[[MessageWindow]::MessageHistoryARef].UserData               = $this.MessageHistory[[MessageWindow]::MessageHistoryBRef].UserData
        $this.MessageHistory[[MessageWindow]::MessageHistoryARef].Prefix.Decorations     = $this.MessageHistory[[MessageWindow]::MessageHistoryBRef].Prefix.Decorations
        $this.MessageHistory[[MessageWindow]::MessageHistoryARef].Prefix.ForegroundColor = $this.MessageHistory[[MessageWindow]::MessageHistoryBRef].Prefix.ForegroundColor

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteMessage', 'Setting Message B UserData, Prefix.Decorations, and Prefix.ForegroundColor to those of Message C.')
        $this.MessageHistory[[MessageWindow]::MessageHistoryBRef].UserData               = $this.MessageHistory[[MessageWindow]::MessageHistoryCRef].UserData
        $this.MessageHistory[[MessageWindow]::MessageHistoryBRef].Prefix.Decorations     = $this.MessageHistory[[MessageWindow]::MessageHistoryCRef].Prefix.Decorations
        $this.MessageHistory[[MessageWindow]::MessageHistoryBRef].Prefix.ForegroundColor = $this.MessageHistory[[MessageWindow]::MessageHistoryCRef].Prefix.ForegroundColor
        
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteMessage', 'Setting Message C UserData, Prefix.Decorations, and Prefix.ForegroundColor to those of the parameters passed to this method.')
        $this.MessageHistory[[MessageWindow]::MessageHistoryCRef].UserData               = $Message
        $this.MessageHistory[[MessageWindow]::MessageHistoryCRef].Prefix.ForegroundColor = $ForegroundColor
        $this.MessageHistory[[MessageWindow]::MessageHistoryCRef].Prefix.Decorations     = $Decoration
        
        # $this.MessageHistory[[MessageWindow]::MessageHistoryCRef] = [ATString]::new(
        #     [ATStringPrefix]::new(
        #         $ForegroundColor,
        #         [ATBackgroundColor24None]::new(),
        #         [ATDecorationNone]::new(),
        #         [MessageWindow]::MessageCDrawCoordinates
        #     ),
        #     $Message,
        #     $true
        # )

        # Write the messages to the window, first blanks and then the messages themselves

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteMessage', 'Setting the Message Dirty Flags to true to force redraws.')
        $this.MessageADirty = $true
        $this.MessageBDirty = $true
        $this.MessageCDirty = $true
        # [MessageWindow]::MessageWindowBlank.Prefix.Coordinates = $this.MessageHistory[[MessageWindow]::MessageHistoryARef].Prefix.Coordinates
        # Write-Host "$([MessageWindow]::MessageWindowBlank.ToAnsiControlSequenceString())"
        # Write-Host "$($this.MessageHistory[[MessageWindow]::MessageHistoryARef].ToAnsiControlSequenceString())"

        # [MessageWindow]::MessageWindowBlank.Prefix.Coordinates = $this.MessageHistory[[MessageWindow]::MessageHistoryBRef].Prefix.Coordinates
        # Write-Host "$([MessageWindow]::MessageWindowBlank.ToAnsiControlSequenceString())"
        # Write-Host "$($this.MessageHistory[[MessageWindow]::MessageHistoryBRef].ToAnsiControlSequenceString())"

        # [MessageWindow]::MessageWindowBlank.Prefix.Coordinates = $this.MessageHistory[[MessageWindow]::MessageHistoryCRef].Prefix.Coordinates
        # Write-Host "$([MessageWindow]::MessageWindowBlank.ToAnsiControlSequenceString())"
        # Write-Host "$($this.MessageHistory[[MessageWindow]::MessageHistoryCRef].ToAnsiControlSequenceString())"

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteMessage', 'Leaving the function.')
    }

    [Void]WriteBadCommandMessage(
        [String]$Command
    ) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteBadCommandMessage', 'Entering the function.')
        $this.WriteMessage(
            "$($Command) isn't a valid command.",
            [CCAppleRedDark24]::new(),
            [ATDecoration]::new($true)
        )
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteBadCommandMessage', 'Leaving the function.')
    }

    [Void]WriteBadArg0Message(
        [String]$Command,
        [String]$Arg0
    ) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteBadArg0Message', 'Entering the function.')
        $this.WriteMessage(
            "We can't $($Command) with a(n) $($Arg0).",
            [CCAppleYellowDark24]::new(),
            [ATDecorationNone]::new()
        )
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteBadArg0Message', 'Leaving the function.')
    }

    [Void]WriteBadArg1Message(
        [String]$Command,
        [String]$Arg0,
        [String]$Arg1
    ) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteBadArg1Message', 'Entering the function.')
        $this.WriteMessage(
            "We can't $($Command) with a(n) $(Arg0) and a(n) $($Arg1).",
            [CCAppleYellowDark24]::new(),
            [ATDecorationNone]::new()
        )
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteBadArg1Message', 'Leaving the function.')
    }

    [Void]WriteSomethingBadMessage() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteSomethingBadMessage', 'Entering the function.')
        $this.WriteMessage(
            'I''m God, and even I don''t know what just happened...',
            [CCAppleIndigoDark24]::new(),
            [ATDecorationNone]::new()
        )
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteSomethingBadMessage', 'Leaving the function.')
    }

    [Void]WriteInvisibleWallEncounteredMessage() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteInvisibleWallEncounteredMessage', 'Entering the function.')
        $this.WriteMessage(
            'The invisible wall blocks your path...',
            [CCAppleIndigoDark24]::new(),
            [ATDecorationNone]::new()
        )
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteInvisibleWallEncounteredMessage', 'Leaving the function.')
    }

    [Void]WriteYouShallNotPassMessage() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteYouShallNotPassMessage', 'Entering the function.')
        $this.WriteMessage(
            'The path you asked for is impossible...',
            [CCAppleIndigoDark24]::new(),
            [ATDecorationNone]::new()
        )
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteYouShallNotPassMessage', 'Leaving the function.')
    }

    [Void]WriteMapNoItemsFoundMessage() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteMapNoItemsFoundMessage', 'Entering the function.')
        $this.WriteMessage(
            'There''s nothing of interest here.',
            [CCAppleIndigoDark24]::new(),
            [ATDecorationNone]::new()
        )
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteMapNoItemsFoundMessage', 'Leaving the function.')
    }

    [Void]WriteMapInvalidItemMessage(
        [String]$ItemName
    ) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteMapInvalidItemMessage', 'Entering the function.')
        $this.WriteMessage(
            "There's no $($ItemName) here.",
            [CCAppleIndigoDark24]::new(),
            [ATDecorationNone]::new()
        )
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteMapInvalidItemMessage', 'Leaving the function.')
    }

    [Void]WriteItemTakenMessage(
        [String]$ItemName
    ) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteItemTakenMessage', 'Entering the function.')
        $this.WriteMessage(
            "I've taken the $($ItemName) and put it in my pocket.",
            [CCAppleIndigoDark24]::new(),
            [ATDecorationNone]::new()
        )
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteItemTakenMessage', 'Leaving the function.')
    }

    [Void]WriteItemCantTakeMessage(
        [String]$ItemName
    ) {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteItemCantTakeMessage', 'Entering the function.')
        $this.WriteMessage(
            "It's not possible to take the $($ItemName).",
            [CCAppleIndigoDark24]::new(),
            [ATDecorationNone]::new()
        )
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteItemCantTakeMessage', 'Leaving the function.')
    }
}

Class InventoryWindow : WindowBase {
    Static [Int]$WindowLTRow    = 1
    Static [Int]$WindowLTColumn = 1
    Static [Int]$WindowBRRow    = 20
    Static [Int]$WindowBRColumn = 79

    Static [String]$WindowBorderHorizontal = '********************************************************************************'
    Static [String]$WindowBorderVertical   = '*'
    
    Static [String]$IChevronCharacter           = '>'
    Static [String]$IChevronBlankCharacter      = ' '
    Static [String]$PagingChevronRightCharacter = '>'
    Static [String]$PagingChevronLeftCharacter  = '<'
    Static [String]$PagingChevronBlankCharater  = ' '

    Static [String]$DivLineHorizontalString = '----------------------------------------------------------------------------'

    Static [String]$DescLineBlank = '                                                                          '
    
    Static [ATString]$PagingChevronRight = [ATString]::new(
        [ATStringPrefix]::new(
            [CCAppleYellowLight24]::new(),
            [ATBackgroundColor24None]::new(),
            [ATDecorationNone]::new(),
            [ATCoordinates]::new(2, 78)
        ),
        [InventoryWindow]::PagingChevronRightCharacter,
        $true
    )
    Static [ATString]$PagingChevronLeft = [ATString]::new(
        [ATStringPrefix]::new(
            [CCAppleYellowLight24]::new(),
            [ATBackgroundColor24None]::new(),
            [ATDecorationNone]::new(),
            [ATCoordinates]::new(2, 3)
        ),
        [InventoryWindow]::PagingChevronLeftCharacter,
        $true
    )
    Static [ATString]$PagingChevronRightBlank = [ATString]::new(
        [ATStringPrefix]::new(
            [CCAppleMintLight24]::new(),
            [ATBackgroundColor24None]::new(),
            [ATDecorationNone]::new(),
            [ATCoordinates]::new(2, 78)
        ),
        [InventoryWindow]::PagingChevronBlankCharater,
        $true
    )
    Static [ATString]$PagingChevronLeftBlank = [ATString]::new(
        [ATStringPrefix]::new(
            [ATForegroundColor24None]::new(),
            [ATBackgroundColor24None]::new(),
            [ATDecorationNone]::new(),
            [ATCoordinates]::new(2, 3)
        ),
        [InventoryWindow]::PagingChevronBlankCharater,
        $true
    )

    Static [ATString]$DivLineHorizontal = [ATString]::new(
        [ATStringPrefix]::new(
            [CCTextDefault24]::new(),
            [ATBackgroundColor24None]::new(),
            [ATDecorationNone]::new(),
            [ATCoordinates]::new(13, 3)
        ),
        [InventoryWindow]::DivLineHorizontalString,
        $true
    )

    Static [Boolean]$DebugMode = $false

    Static [Int]$MoronCounter = 0

    Static [String]$ZeroPagePrompt = 'You have no items in your inventory.'

    [Boolean]$PlayerChevronDirty        = $true
    [Boolean]$PagingChevronRightDirty   = $true
    [Boolean]$PagingChevronLeftDirty    = $true
    [Boolean]$ItemsListDirty            = $true
    [Boolean]$CurrentPageDirty          = $true
    [Boolean]$PlayerChevronVisible      = $true
    [Boolean]$PagingChevronRightVisible = $false
    [Boolean]$PagingChevronLeftVisible  = $false
    [Boolean]$ZeroPageActive            = $false
    [Boolean]$MoronPageActive           = $false
    [Boolean]$BookDirty                 = $true
    [Boolean]$ActiveItemBlinking        = $false
    [Boolean]$DivLineDirty              = $true
    [Boolean]$ItemDescDirty             = $true
    
    [Int]$ItemsPerPage             = 10
    [Int]$NumPages                 = 1
    [Int]$CurrentPage              = 1
    [List[MapTileObject]]$PageRefs = $null
    
    [List[ValueTuple[[ATString], [Boolean]]]]$IChevrons
    [List[ATString]]$ItemLabels
    [List[ATString]]$ItemLabelBlanks

    [Int]$ActiveIChevronIndex = 0

    InventoryWindow(): base() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entering the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Initializing the members to defaults.')
        $this.LeftTop     = [ATCoordinates]::new([InventoryWindow]::WindowLTRow, [InventoryWindow]::WindowLTColumn)
        $this.RightBottom = [ATCoordinates]::new([InventoryWindow]::WindowBRRow, [InventoryWindow]::WindowBRColumn)
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new()
        )
        $this.BorderStrings = [String[]](
            [InventoryWindow]::WindowBorderHorizontal,
            [InventoryWindow]::WindowBorderVertical
        )
        $this.UpdateDimensions()

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Initializing custom members to defaults.')
        $this.PageRefs = [List[MapTileObject]]::new()

        $this.CreateIChevrons()
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }

    [Void]Draw() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Entering the function.')
        ([WindowBase]$this).Draw()

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Checking to see if the BookDirty flag has been set.')
        If($this.BookDirty -EQ $true) {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It is - (re)calculating the total number of pages for this book.')
            $this.CalculateNumPages()
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Setting the BookDirty flag to false.')
            $this.BookDirty = $false
        }

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Checking to see if the CurrentPageDirty flag has been set.')
        If($this.CurrentPageDirty -EQ $true) {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It is - populating the page contents.')
            $this.PopulatePage()
        }

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Checking to see if the ZeroPageActive flag has been set.')
        If($this.ZeroPageActive -EQ $true) {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It is - checking to see if the MoronPageActive flag has been set.')
            If($this.MoronPageActive -EQ $true) {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It is - writing the Moron Page.')
                $this.WriteMoronPage()
            } Else {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It isn''t - writing the Zero Inventory Page.')
                $this.WriteZeroInventoryPage()
            }
        } Else {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It isn''t - checking to see if the DivLineDirty flag has been set.')
            If($this.DivLineDirty -EQ $true) {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It is - drawing the Div Line to the window.')
                Write-Host "$([InventoryWindow]::DivLineHorizontal.ToAnsiControlSequenceString())"
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Setting the DivLineDirty flag to false.')
                $this.DivLineDirty = $false
            }

            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Checking to see if the PlayerChevronVisible flag is set AND if the PlayerChevronDirty flag has been set.')
            If($this.PlayerChevronVisible -EQ $true -AND $this.PlayerChevronDirty -EQ $true) {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'They are - Looping through the chevrons and drawing them to the window.')
                Foreach($ic in $this.IChevrons) {
                    Write-Host "$($ic.Item1.ToAnsiControlSequenceString())"
                }
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Setting the PlayerChevronDirty flag to false.')
                $this.PlayerChevronDirty = $false
            }

            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Checking to see if the NumPages is GREATER THAN 1.')
            If($this.NumPages -GT 1) {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It is - Checking to see if CurrentPage is EQUAL TO 1.')
                If($this.CurrentPage -EQ 1) {
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It is - Checking to see if the PagingChevronLeftVisible flag has been set.')
                    If($this.PagingChevronLeftVisible -EQ $true) {
                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It is - Drawing the Paging Left Chevron Blank to the predefined coordinates.')
                        Write-Host "$([InventoryWindow]::PagingChevronLeftBlank.ToAnsiControlSequenceString())"

                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Setting the PagingChevronLeftVisible flag to false and the PagingChevronLeftDirty flag to true.')
                        $this.PagingChevronLeftVisible = $false
                        $this.PagingChevronLeftDirty = $true
                    }

                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Checking to see if the PagingChevronRightVisible is NOT set.')
                    If($this.PagingChevronRightVisible -EQ $false) {
                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It isn''t set - setting it to true.')
                        $this.PagingChevronRightVisible = $true
                    }

                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Checking to see if the PagingChevronRightVisible flags is set AND if the PagingChevronRightDirty flag is set.')
                    If($this.PagingChevronRightVisible -EQ $true -AND $this.PagingChevronRightDirty -EQ $true) {
                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'They are - Drawing the Paging Right Chevron to the predefined coordinates.')
                        Write-Host "$([InventoryWindow]::PagingChevronRight.ToAnsiControlSequenceString())"
                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Setting the PagingChevronRightDirty flag to false.')
                        $this.PagingChevronRightDirty = $false
                    }
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It is - Checking to see if CurrentPage is GREATER THAN 1 AND CurrentPage is LESS THAN NumPages.')
                } Elseif($this.CurrentPage -GT 1 -AND $this.CurrentPage -LT $this.NumPages) {
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'CurrentPage is GREATER THAN 1 AND CurrentPage is LESS THAN NumPages.')
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Checking to see if PagingChevronLeftVisible is false.')
                    If($this.PagingChevronLeftVisible -EQ $false) {
                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It is - Setting PagingChevronLeftVisible to true.')
                        $this.PagingChevronLeftVisible = $true
                    }
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Checking to see if PagingChevronRightVisible is false.')
                    If($this.PagingChevronRightVisible -EQ $false) {
                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It is - Setting PagingChevronRightVisible to true.')
                        $this.PagingChevronRightVisible = $true
                    }
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Checking to see if PagingChevronRightVisible is true and if PagingChevronRightDirty is true.')
                    If($this.PagingChevronRightVisible -EQ $true -AND $this.PagingChevronRightDirty -EQ $true) {
                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'They are - writing the Paging Right Chevron to the predefined coordinates.')
                        Write-Host "$([InventoryWindow]::PagingChevronRight.ToAnsiControlSequenceString())"
                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Setting PagingChevronRightDirty to false.')
                        $this.PagingChevronRightDirty = $false
                    }
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Checking to see if PagingChevronLeftVisible is true AND if PagingChevronLeftDirty is true.')
                    If($this.PagingChevronLeftVisible -EQ $true -AND $this.PagingChevronLeftDirty -EQ $true) {
                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'They are - writing the Paging Left Chevron to the predefined coordinates.')
                        Write-Host "$([InventoryWindow]::PagingChevronLeft.ToAnsiControlSequenceString())"
                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Setting PagingChevronLeftDirty to false.')
                        $this.PagingChevronLeftDirty = $false
                    }
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It is - Checking to see if CurrentPage is GREATER THAN OR EQUAL TO NumPages.')
                } Elseif($this.CurrentPage -GE $this.NumPages) {
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It is - Checking to see if PagingChevronRightVisible is true.')
                    If($this.PagingChevronRightVisible -EQ $true) {
                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It is - Writing the PagingChevronRightBlank to the predefined coordinates.')
                        Write-Host "$([InventoryWindow]::PagingChevronRightBlank.ToAnsiControlSequenceString())"
                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Setting PagingChevronRightVisible to false.')
                        $this.PagingChevronRightVisible = $false
                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Setting PagingChevronRightDirty to true.')
                        $this.PagingChevronRightDirty = $true
                    }
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Checking to see if PagingChevronLeftVisible is false.')
                    If($this.PagingChevronLeftVisible -EQ $false) {
                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It is - setting PagingChevronLeftVisible to true.')
                        $this.PagingChevronLeftVisible = $true
                    }
                    $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Checking to see if PagingChevronLeftVisible is true AND if PagingChevronLeftDirty is true.')
                    If($this.PagingChevronLeftVisible -EQ $true -AND $this.PagingChevronLeftDirty -EQ $true) {
                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'They are - Writing the Paging Chevron Left to the predefined coordinates.')
                        Write-Host "$([InventoryWindow]::PagingChevronLeft.ToAnsiControlSequenceString())"
                        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Setting PagingChevronLeftDirty to false.')
                        $this.PagingChevronLeftDirty = $false
                    }
                }
            }

            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Checking to see if the ActiveItemBlinking flag is false.')
            If($this.ActiveItemBlinking -EQ $false) {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It is - Setting the decoration and foreground color of the active item.')
                $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]::new($true)
                $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()

                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Setting ItemsListDirty to true.')
                $this.ItemsListDirty = $true
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Setting ActiveItemBlinking to true.')
                $this.ActiveItemBlinking = $true
            }

            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Checking to see if ItemsListDirty is true.')
            If($this.ItemsListDirty -EQ $true) {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It is - Writing the Item Labels to the page.')
                $this.WriteItemLabels()
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Hiding the cursor.')
                Write-Host "$([ATControlSequences]::CursorHide)"
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Setting ItemsListDirty to false.')
                $this.ItemsListDirty = $false
            }

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Checking to see if ItemDescDirty is true.')
            If($this.ItemDescDirty -EQ $true) {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'It is - Creating an ATString Blank and Actual.')
                [ATString]$b = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCTextDefault24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinates]::new(15, 4)
                    ),
                    [InventoryWindow]::DescLineBlank,
                    $true
                )
                [ATString]$d = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCTextDefault24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinates]::new(15, 4)
                    ),
                    $this.PageRefs[$this.ActiveIChevronIndex].ExamineString,
                    $true
                )

                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Writing the Blank and Actual.')
                Write-Host "$($b.ToAnsiControlSequenceString())"
                Write-Host "$($d.ToAnsiControlSequenceString())"
            }
        }
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Draw', 'Leaving the function.')
    }

    [Void]CreateIChevrons() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CreateIChevrons', 'Entered the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CreateIChevrons', 'Resetting the IChevrons collection.')
        $this.IChevrons = [List[ValueTuple[[ATString], [Boolean]]]]::new()

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CreateIChevrons', 'Recreating the IChevron collection.')
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [CCAppleGreenLight24]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(3, 15)
                ),
                [InventoryWindow]::IChevronCharacter,
                $true
            ),
            $true
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [CCAppleGreenLight24]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(5, 15)
                ),
                [InventoryWindow]::IChevronBlankCharacter,
                $false
            ),
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [CCAppleGreenLight24]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(7, 15)
                ),
                [InventoryWindow]::IChevronBlankCharacter,
                $false
            ),
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [CCAppleGreenLight24]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(9, 15)
                ),
                [InventoryWindow]::IChevronBlankCharacter,
                $false
            ),
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [CCAppleGreenLight24]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(11, 15)
                ),
                [InventoryWindow]::IChevronBlankCharacter,
                $false
            ),
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [CCAppleGreenLight24]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(3, 50)
                ),
                [InventoryWindow]::IChevronBlankCharacter,
                $false
            ),
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [CCAppleGreenLight24]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(5, 50)
                ),
                [InventoryWindow]::IChevronBlankCharacter,
                $false
            ),
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [CCAppleGreenLight24]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(7, 50)
                ),
                [InventoryWindow]::IChevronBlankCharacter,
                $false
            ),
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [CCAppleGreenLight24]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(9, 50)
                ),
                [InventoryWindow]::IChevronBlankCharacter,
                $false
            ),
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [CCAppleGreenLight24]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(11, 50)
                ),
                [InventoryWindow]::IChevronBlankCharacter,
                $false
            ),
            $false
        ))
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CreateIChevrons', 'Leaving the function.')
    }

    [Void]CreateItemLabels() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CreateItemLabels', 'Entered the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CreateItemLabels', 'Resetting the ItemLabels collection.')
        $this.ItemLabels = [List[ATString]]::new()
        [Int]$c          = 0
        
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CreateItemLabels', 'Looping through the PageRefs collection to generate corresponding ItemLabels.')
        Foreach($i in $this.PageRefs) {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CreateItemLabels', 'Adding a new ItemLabel to the ItemLabels collection.')
            $this.ItemLabels.Add(
                [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCTextDefault24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinates]::new(
                            $this.IChevrons[$c].Item1.Prefix.Coordinates.Row,
                            $this.IChevrons[$c].Item1.Prefix.Coordinates.Column + 2
                        )
                    ),
                    $i.Name,
                    $true
                )
            )
            $c++ # FYI - This was intentional
        }

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CreateItemLabels', 'Resetting IChevron Positions and creating ItemLabelBlanks.')
        $this.ResetIChevronPosition()
        $this.CreateItemLabelBlanks()
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CreateItemLabels', 'Leaving the function.')
    }

    [Void]CreateItemLabelBlanks() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CreateItemLabelBlanks', 'Entered the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CreateItemLabelBlanks', 'Resetting the ItemLabelBlanks collection.')
        $this.ItemLabelBlanks = [List[ATString]]::new()

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CreateItemLabelBlanks', 'Recreating the ItemLabelBlanks collection.')
        $this.ItemLabelBlanks.Add(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [ATForegroundColor24None]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(3, 17)
                ),
                '               ',
                $true
            )
        )
        $this.ItemLabelBlanks.Add(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [ATForegroundColor24None]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(5, 17)
                ),
                '               ',
                $true
            )
        )
        $this.ItemLabelBlanks.Add(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [ATForegroundColor24None]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(7, 17)
                ),
                '               ',
                $true
            )
        )
        $this.ItemLabelBlanks.Add(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [ATForegroundColor24None]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(9, 17)
                ),
                '               ',
                $true
            )
        )
        $this.ItemLabelBlanks.Add(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [ATForegroundColor24None]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(11, 17)
                ),
                '               ',
                $true
            )
        )
        $this.ItemLabelBlanks.Add(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [ATForegroundColor24None]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(3, 52)
                ),
                '               ',
                $true
            )
        )
        $this.ItemLabelBlanks.Add(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [ATForegroundColor24None]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(5, 52)
                ),
                '               ',
                $true
            )
        )
        $this.ItemLabelBlanks.Add(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [ATForegroundColor24None]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(7, 52)
                ),
                '               ',
                $true
            )
        )
        $this.ItemLabelBlanks.Add(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [ATForegroundColor24None]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(9, 52)
                ),
                '               ',
                $true
            )
        )
        $this.ItemLabelBlanks.Add(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [ATForegroundColor24None]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(11, 52)
                ),
                '               ',
                $true
            )
        )
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CreateItemLabelBlanks', 'Leaving the function.')
    }

    [Void]CalculateNumPages() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CalculateNumPages', 'Entered the function.')
        $pp = $Script:ThePlayer.Inventory.Count / $this.ItemsPerPage
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CalculateNumPages', "NumPages has been calculated to be $($pp).")
        If($pp -LT 1) {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CalculateNumPages', 'Setting NumPages to 1.')
            $this.NumPages = 1
        } Else {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CalculateNumPages', "Setting NumPages to $([Math]::Ceiling($pp)).")
            $this.NumPages = [Math]::Ceiling($pp)
        }
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'CalculateNumPages', 'Leaving the function.')
    }

    [Void]TurnPageForward() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'TurnPageForward', 'Entered the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'TurnPageForward', 'Checking to see if a pre-increment of CurrentPage is LESS THAN OR EQUAL TO NumPages.')
        If(($this.CurrentPage + 1) -LE $this.NumPages) {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'TurnPageForward', 'This check passes - incrementing CurrentPage, setting CurrentPageDirty to true, setting ActiveItemBlinking to false, and setting ItemDescDirty to true.')
            $this.CurrentPage++
            $this.CurrentPageDirty   = $true
            $this.ActiveItemBlinking = $false
            $this.ItemDescDirty      = $true
        }
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'TurnPageForward', 'Leaving the function.')
    }

    [Void]TurnPageBackward() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'TurnPageBackward', 'Entered the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'TurnPageBackward', 'Checking to see if a pre-decrement of CurrentPage is GREATER THAN OR EQUAL TO 1.')
        If(($this.CurrentPage - 1) -GE 1) {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'TurnPageBackward', 'This check passes - decrementing CurrentPage, setting CurrentPageDirty to true, setting ActiveItemBlinking to false, and setting ItemDescDirty to true.')
            $this.CurrentPage--
            $this.CurrentPageDirty   = $true
            $this.ActiveItemBlinking = $false
            $this.ItemDescDirty      = $true
        }
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'TurnPageBackward', 'Leaving the function.')
    }

    [Void]PopulatePage() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'PopulatePage', 'Entered the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'PopulatePage', 'Checking to see if ThePlayer''s Inventory size is LESS THAN OR EQUAL TO 0.')
        If($Script:ThePlayer.Inventory.Count -LE 0) {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'PopulatePage', 'It is - Setting ZeroPageActive to true and CurrentPageDirty to false.')
            $this.ZeroPageActive   = $true
            $this.CurrentPageDirty = $false
            
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'PopulatePage', 'Checking to see if the MoronCounter is LESS THAN OR EQUAL TO 20.')
            If([InventoryWindow]::MoronCounter -LT 20) {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'PopulatePage', 'It is - increment the MoronCounter.')
                [InventoryWindow]::MoronCounter++
            } Else {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'PopulatePage', 'It isn''t - Setting MoronPageActive to true.')
                $this.MoronPageActive = $true
            }
        } Else {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'PopulatePage', 'It isn''t - resetting PageRefs and repopulating with a minimal scope of the Player''s Inventory.')
            $this.PageRefs        = [List[MapTileObject]]::new()
            $this.ZeroPageActive  = $false
            $this.MoronPageActive = $false
            $rs                   = (($this.CurrentPage * $this.ItemsPerPage) - $this.ItemsPerPage) - 1
            $rs                   = [Math]::Clamp($rs, 0, [Int]::MaxValue)
            $re                   = 10
            #$re                  = $this.CurrentPage * $this.ItemsPerPage
            
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'PopulatePage', "Range selection start index was calculated to be $($rs); Range selection end is always 10.")

            Try {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'PopulatePage', "Trying to select 10 items from index $($rs).")
                $this.PageRefs = $Script:ThePlayer.Inventory.GetRange($rs, $re)
            } Catch {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'PopulatePage', "This failed - trying to select $($Script:ThePlayer.Inventory.Count - $rs) items from $($rs).")
                $this.PageRefs = $Script:ThePlayer.Inventory.GetRange($rs, ($Script:ThePlayer.Inventory.Count - $rs))
            }

            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'PopulatePage', 'Creating the Item Labels.')
            $this.CreateItemLabels()

            # $this.ResetIChevronPosition()

            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'PopulatePage', 'Setting ItemsListDirty to true and CurrentPageDirty to false.')
            $this.ItemsListDirty   = $true
            $this.CurrentPageDirty = $false
        }
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'PopulatePage', 'Leaving the function.')
    }

    [Void]WriteItemLabels() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteItemLabels', 'Entered the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteItemLabels', 'Writing the Item Label Blanks.')
        Foreach($i in $this.ItemLabelBlanks) {
            Write-Host "$($i.ToAnsiControlSequenceString())"
        }
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteItemLabels', 'Writing the Item Labels.')
        Foreach($i in $this.ItemLabels) {
            Write-Host "$($i.ToAnsiControlSequenceString())"
        }
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteItemLabels', 'Leaving the function.')
    }

    [ATString]GetActiveIChevron() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetActiveIChevron', 'Entered the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetActiveIChevron', 'Setting ActiveIChevronIndex to 0.')
        $this.ActiveIChevronIndex = 0

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetActiveIChevron', 'Looping through the IChevon collection to find the ''active'' one.')
        Foreach($a in $this.IChevrons) {
            If($a.Item2 -EQ $true) {
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetActiveIChevron', "Found the Active IChevron at index $($this.ActiveIChevronIndex).")
                Return $a.Item1
            }
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetActiveIChevron', 'Not yet found - incrementing ActiveIChevronIndex.')
            $this.ActiveIChevronIndex++
        }

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetActiveIChevron', 'An active IChevron wasn''t found in the IChevron collection - setting the first element as the active.')
        $this.ActiveIChevronIndex = 0
        $this.IChevrons[$this.ActiveIChevronIndex].Item2 = $true
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'GetActiveIChevron', 'Leaving the function.')
        Return $this.IChevrons[$this.ActiveIChevronIndex].Item1
    }

    [Void]WriteZeroInventoryPage() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteZeroInventoryPage', 'Entered the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteZeroInventoryPage', 'Creating an ATString instance with a message and writing it to the window.')
        [ATString]$a = [ATString]::new(
            [ATStringPrefix]::new(
                [CCTextDefault24]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinates]::new(
                    $this.Height / 2,
                    ($this.Width / 2) - ([InventoryWindow]::ZeroPagePrompt.Length / 2)
                )
            ),
            [InventoryWindow]::ZeroPagePrompt,
            $true
        )

        Write-Host "$($a.ToAnsiControlSequenceString())"
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'WriteZeroInventoryPage', 'Leaving the function.')
    }

    [Void]WriteMoronPage() {}

    [Void]ResetIChevronPosition() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'ResetIChevronPosition', 'Entered the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'ResetIChevronPosition', 'Setting the currently active IChevron to inactive.')
        $this.IChevrons[$this.ActiveIChevronIndex].Item2          = $false
        $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData = [InventoryWindow]::IChevronBlankCharacter
        
        # This seems to be the only way to deal with this reliably since the ActiveIChevronIndex can't be
        # reset to zero yet.
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'ResetIChevronPosition', 'Attempting to clear the decoration settings of the Item Label in the ActiveIChevronIndex position.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'ResetIChevronPosition', 'Note that this can cause an intentional exception, which is captured and ignored.')
        Try {
            $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecorationNone]::new()
            $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCTextDefault24]::new()
        } Catch {
        }
        
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'ResetIChevronPosition', 'Setting the ActiveIChevronIndex to 0, and resetting the IChevron and Active Item Label Decorations.')
        $this.ActiveIChevronIndex                                          = 0
        $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $true
        $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [InventoryWindow]::IChevronCharacter
        $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]::new($true)
        $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()
        
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'ResetIChevronPosition', 'Setting PlayerChevronDirty to true, ActiveItemBlinking to false, and ItemDescDirty to true.')
        $this.PlayerChevronDirty = $true
        $this.ActiveItemBlinking = $false
        $this.ItemDescDirty      = $true
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'ResetIChevronPosition', 'Leaving the function.')
    }

    [Void]HandleInput() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', 'Entered the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', 'Calling ReadKey with NoEcho option.')
        $keyCap = $(Get-Host).UI.RawUI.ReadKey('IncludeKeyDown, NoEcho')

        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', 'Checking to see the value of VirtualKeyCode.')
        Switch($keyCap.VirtualKeyCode) {
            27 { # Escape
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', '27 (Escape) - Reverting the Global Game State back to the GamePlayScreen.')
                $Script:ThePreviousGlobalGameState = $Script:TheGlobalGameState
                $Script:TheGlobalGameState         = [GameStatePrimary]::GamePlayScreen
            }

            38 { # Up Arrow
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', '38 (Up Arrow) - If possible, move the Active IChevron ''up'' one (decrement the indexer).')
                If(($this.ActiveIChevronIndex - 1) -GE 0) {
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $false
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [InventoryWindow]::IChevronBlankCharacter
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecorationNone]::new()
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCTextDefault24]::new()
                    
                    $this.ActiveIChevronIndex--
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $true
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [InventoryWindow]::IChevronCharacter
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]::new($true)
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()
                }

                $this.PlayerChevronDirty = $true
                $this.ActiveItemBlinking = $false
                $this.ItemDescDirty      = $true
            }

            40 { # Down Arrow
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', '40 (Down Arrow) - If possible, move the Active IChevron ''down'' one (increment the indexer).')
                If(($this.ActiveIChevronIndex + 1) -LT $this.PageRefs.Count) {
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $false
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [InventoryWindow]::IChevronBlankCharacter
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecorationNone]::new()
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCTextDefault24]::new()
                    
                    $this.ActiveIChevronIndex++
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $true
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [InventoryWindow]::IChevronCharacter
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]::new($true)
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()
                }

                $this.PlayerChevronDirty = $true
                $this.ActiveItemBlinking = $false
                $this.ItemDescDirty      = $true
            }

            39 { # Right Arrow
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', '39 (Right Arrow) - If possible, move the Active IChevron ''right'' one (increment the indexer by 5).')
                If(($this.ActiveIChevronIndex + 5) -LT $this.PageRefs.Count) {
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $false
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [InventoryWindow]::IChevronBlankCharacter
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecorationNone]::new()
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCTextDefault24]::new()
                    
                    $this.ActiveIChevronIndex += 5

                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $true
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [InventoryWindow]::IChevronCharacter
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]::new($true)
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()
                }

                $this.PlayerChevronDirty = $true
                $this.ActiveItemBlinking = $false
                $this.ItemDescDirty      = $true
            }

            37 { # Left Arrow
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', '37 (Left Arrow) - If possible, move the Active IChevron ''left'' one (decrement the indexer by 5).')
                If(($this.ActiveIChevronIndex -5) -GE 0) {
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $false
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [InventoryWindow]::IChevronBlankCharacter
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecorationNone]::new()
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCTextDefault24]::new()
                    
                    $this.ActiveIChevronIndex -= 5
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $true
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [InventoryWindow]::IChevronCharacter
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]::new($true)
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()
                }

                $this.PlayerChevronDirty = $true
                $this.ActiveItemBlinking = $false
                $this.ItemDescDirty      = $true
            }

            68 { # D
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', '68 (D) - Turn the Inventory Page forward.')
                $this.TurnPageForward()
            }

            65 { # A
                $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', '65 (A) - Turn the Inventory Page backward.')
                $this.TurnPageBackward()
            }
        }
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'HandleInput', 'Leaving the function.')
    }
}

Class GameCore {
    [Int]$TargetFrameRate
    [Single]$MsPerFrame
    [Boolean]$GameRunning
    [Double]$LastFrameTime
    [Double]$CurrentFrameTime
    [TimeSpan]$FpsDelta

    GameCore() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Entered the constructor.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Updating the Progress Bar for globals.')
        Write-Progress -Activity 'Creating ''global'' variables' -Id 1 -Status 'Creating the Game Core' -PercentComplete -1
        
        $this.TargetFrameRate      = 30
        $this.MsPerFrame           = 1000 / $this.TargetFrameRate
        $this.GameRunning          = $true
        $this.LastFrameTime        = 0D
        $this.CurrentFrameTime     = 0D
        $this.FpsDelta             = [TimeSpan]::Zero
        $Script:TheGlobalGameState = [GameStatePrimary]::GamePlayScreen
        
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Constructor', 'Leaving the constructor.')
    }

    [Void]Run() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Run', 'Entered the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Run', 'Checking to see if GameRunning is true.')

        While($this.GameRunning -EQ $true) {
            $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Run', 'It is - calling to the Logic function.')
            $this.Logic()
            # "GameCore::Run - `t`tSetting LastFrameTime ($($this.LastFrameTime)) to CurrentFrameTime ($($this.CurrentFrameTime))." | Out-File -FilePath $Script:LogFileName -Append
            # $this.LastFrameTime = $this.CurrentFrameTime
            
            # "GameCore::Run - `t`tSetting CurrentFrameTime ($($this.CurrentFrameTime)) to the current time in ticks ($([DateTime]::Now.Ticks))." | Out-File -FilePath $Script:LogFileName -Append
            # $this.CurrentFrameTime = [DateTime]::Now.Ticks

            # "GameCore::Run - `t`tChecking to see if CurrentFrameTime ($($this.CurrentFrameTime)) minus LastFrameTime ($($this.LastFrameTime)) is GREATER THAN OR EQUAL TO MsPerFrame ($($this.MsPerFrame))." | Out-File -FilePath $Script:LogFileName -Append
            # "GameCore::Run - `t`tThe equation is $($this.CurrentFrameTime) - $($this.LastFrameTime) >= $($this.MsPerFrame)" | Out-File -FilePath $Script:LogFileName -Append
            # If(($this.CurrentFrameTime - $this.LastFrameTime) -GE $this.MsPerFrame) {
            #     "GameCore::Run - `t`t`tThe value is GREATER THAN OR EQUAL TO MsPerFrame." | Out-File -FilePath $Script:LogFileName -Append
            #     "GameCore::Run - `t`t`tSet FpsDelta to a new TimeSpan of CurrentFrameTime minus LastFrameTime." | Out-File -FilePath $Script:LogFileName -Append
            #     $this.FpsDelta = [TimeSpan]::new($this.CurrentFrameTime - $this.LastFrameTime)

            #     "GameCore::Run - `t`t`tCall the Logic method." | Out-File -FilePath $Script:LogFileName -Append
            #     $this.Logic()
            # }
        }
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Run', 'Leaving the function.')
    }

    [Void]Logic() {
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Logic', 'Entered the function.')
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Logic', "Invoking the ScriptBlock for the game state $($SCript:TheGlobalGameState).")
        Invoke-Command $Script:TheGlobalStateBlockTable[$Script:TheGlobalGameState]
        $Script:TheLogManager.WriteToLog("$($this.GetType().Name)", 'Logic', 'Leaving the function.')
    }
}

# FUNCTION DEFINITIONS

Function Test-GfmOs {
    [CmdletBinding()]
    Param ()

    Process {
        Get-PSDrive -Name Variable | Out-Null
        If ($?) {
            Get-ChildItem Variable:/IsLinux | Out-Null
            If ($?) {
                If ($(Get-ChildItem Variable:/IsLinux).Value -EQ $true) {
                    Return $Script:OsCheckLinux
                }
            }

            Get-ChildItem Variable:/IsMacOS | Out-Null
            If ($?) {
                If ($(Get-ChildItem Variable:/IsMacOS).Value -EQ $true) {
                    Return $Script:OsCheckMac
                }
            }

            Get-ChildItem Variable:/IsWindows | Out-Null
            If ($?) {
                If ($(Get-ChildItem Variable:/IsWindows).Value -EQ $true) {
                    Return $Script:OsCheckWindows
                }
            }
        }

        Return $Script:OsCheckUnknown
    }
}

# RUNNER
Clear-Host

#$Script:TheStatusWindow.Draw()
#$Script:TheCommandWindow.Draw()
#$Script:TheSceneWindow.Draw()
#$Script:TheMessageWindow.Draw()
#$Script:TheMessageWindow.WriteMessage('This is a sample message', [CCAppleGreenLight24]::new())
#$Script:TheMessageWindow.WriteMessage('This is a another message', [CCAppleMintLight24]::new())
#$Script:TheMessageWindow.WriteMessage('>> This is yet ANOTHER message', [CCAppleRedLight24]::new())

$Script:ThePlayer.Inventory.Add([MTOLadder]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTORope]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOStairs]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOPole]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOBacon]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOApple]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOStick]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOYogurt]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTORock]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTORope]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOPole]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOBacon]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOApple]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOStick]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOYogurt]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTORock]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTORope]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOLadder]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTORope]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOStairs]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOPole]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOBacon]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOApple]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOStick]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOYogurt]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTORock]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTORope]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOPole]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOBacon]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOApple]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOStick]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOYogurt]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTORock]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTORope]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOTree]::new()) | Out-Null

$Script:SampleMap.Tiles[0, 0] = [MapTile]::new(
    $Script:FieldNorthEastRoadImage,
    @(
        [MTOApple]::new(),
        [MTOTree]::new(),
        [MTOLadder]::new(),
        [MTORope]::new(),
        [MTOStairs]::new(),
        [MTOPole]::new()
    ),
    @(
        $true,
        $false,
        $true,
        $false
    )
)
$Script:SampleMap.Tiles[0, 1] = [MapTile]::new(
    $Script:FieldNorthWestRoadImage,
    @(),
    @(
        $true,
        $false,
        $false,
        $true
    )
)
$Script:SampleMap.Tiles[1, 0] = [MapTile]::new(
    $Script:FieldSouthEastWestRoadImage,
    @(),
    @(
        $false,
        $true,
        $true,
        $false
    )
)
$Script:SampleMap.Tiles[1, 1] = [MapTile]::new(
    $Script:FieldNorthRoadImage,
    @(),
    @(
        $false,
        $true,
        $false,
        $true
    )
)

$Script:TheGameCore.Run()

#$Script:TheInventoryWindow.Draw()

# While(1) {
#     $Script:TheStatusWindow.Draw()
#     $Script:TheCommandWindow.Draw()
#     $Script:TheSceneWindow.Draw()
#     $Script:TheMessageWindow.Draw()
#     $Script:TheCommandWindow.HandleInput()
# }

#$(Get-Host).UI.RawUI.CursorPosition = [ATCoordinatesDefault]::new().ToAutomationCoordinates()
# $(Get-Host).UI.RawUI.CursorPosition = [Coordinates]::new(5, 2); Write-Host '>' -NoNewline -ForegroundColor 12
# $(Get-Host).UI.RawUI.CursorPosition = [Coordinates]::new(5, 4); Write-Host '>' -NoNewline -ForegroundColor 12
# $(Get-Host).UI.RawUI.CursorPosition = [Coordinates]::new(5, 6); Write-Host '>' -NoNewline -ForegroundColor 12
# $(Get-Host).UI.RawUI.CursorPosition = [Coordinates]::new(5, 8); Write-Host '>' -NoNewline -ForegroundColor 12
# $(Get-Host).UI.RawUI.CursorPosition = [Coordinates]::new(5, 10); Write-Host '>' -NoNewline -ForegroundColor 12

# Read-Host
