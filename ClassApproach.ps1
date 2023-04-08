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
        $this.Image = New-Object 'ATSceneImageString[,]' ([Int32]([SceneImage]::Height)), ([Int32]([SceneImage]::Width))
    }
    
    SceneImage(
        [ATSceneImageString[,]]$Image
    ) {
        $this.Image = $Image
    }

    [Void]CreateSceneImageATString([ATBackgroundColor24[]]$ImageColorMap) {
        For($r = 0; $r -LT [SceneImage]::Height; $r++) {
            For($c = 0; $c -LT [SceneImage]::Width; $c++) {
                $rf                 = ($r * [SceneImage]::Width) + $c
                $this.Image[$r, $c] = [ATSceneImageString]::new(
                    $ImageColorMap[$rf],
                    [ATCoordinates]::new(([SceneWindow]::ImageDrawRowOffset + $r), ([SceneWindow]::ImageDrawColumnOffset + $c))
                )
            }
        }
    }

    [String]ToAnsiControlSequenceString() {
        [String]$a = ''

        For($r = 0; $r -LT [SceneImage]::Height; $r++) {
            For($c = 0; $c -LT [SceneImage]::Width; $c++) {
                $a += $this.Image[$r, $c].ToAnsiControlSequenceString()
            }
        }

        Return $a
    }
}

Class SIEmpty : SceneImage {
    SIEmpty(): base() {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}

Class SIInternalBase : SceneImage {
    [ATBackgroundColor24[]]$ColorMap

    SIInternalBase(): base() {
        $this.ColorMap = New-Object 'ATBackgroundColor24[]' ([Int32](([Int32]([SceneImage]::Width)) * ([Int32]([SceneImage]::Height))))
    }
}

Class SIRandomNoise : SceneImage {
    [ATBackgroundColor24[]]$ColorMap

    SIRandomNoise(): base() {
        $this.ColorMap = New-Object 'ATBackgroundColor24[]' ([Int32](([Int32]([SceneImage]::Width)) * ([Int32]([SceneImage]::Height))))

        For($a = 0; $a -LT $this.ColorMap.Count; $a++) {
            $this.ColorMap[$a] = [CCRandom24]::new()
        }

        $this.CreateSceneImageATString($this.ColorMap)
        $this.ColorMap = $null
    }
}

Class SIFieldNorthRoad : SIInternalBase {
    SIFieldNorthRoad(): base() {
        Write-Progress -Activity 'Creating Scene Images      ' -Id 3 -Status 'Creating SIFieldNorthRoad' -PercentComplete -1
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

        $this.CreateSceneImageATString($this.ColorMap)
        $this.ColorMap = $null
    }
}

Class SIFieldNorthEastRoad : SIInternalBase {
    SIFieldNorthEastRoad(): base() {
        Write-Progress -Activity 'Creating Scene Images      ' -Id 3 -Status 'Creating SIFieldNorthEastRoad' -PercentComplete -1
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

        $this.CreateSceneImageATString($this.ColorMap)
        $this.ColorMap = $null
    }
}

Class SIFieldNorthWestRoad : SIInternalBase {
    SIFieldNorthWestRoad(): base() {
        Write-Progress -Activity 'Creating Scene Images      ' -Id 3 -Status 'Creating SIFieldNorthWestRoad' -PercentComplete -1
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

        $this.CreateSceneImageATString($this.ColorMap)
        $this.ColorMap = $null
    }
}

Class SIFieldNorthEastWestRoad : SIInternalBase {
    SIFieldNorthEastWestRoad(): base() {
        Write-Progress -Activity 'Creating Scene Images      ' -Id 3 -Status 'Creating SIFieldNorthEastWestRoad' -PercentComplete -1
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

        $this.CreateSceneImageATString($this.ColorMap)
        $this.ColorMap = $null
    }
}

Class SIFieldSouthRoad : SIInternalBase {
    SIFieldSouthRoad(): base() {
        Write-Progress -Activity 'Creating Scene Images      ' -Id 3 -Status 'Creating SIFieldSouthRoad' -PercentComplete -1
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

        $this.CreateSceneImageATString($this.ColorMap)
        $this.ColorMap = $null
    }
}

Class SIFieldSouthEastRoad : SIInternalBase {
    SIFieldSouthEastRoad(): base() {
        Write-Progress -Activity 'Creating Scene Images      ' -Id 3 -Status 'Creating SIFieldSouthEastRoad' -PercentComplete -1
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

        $this.CreateSceneImageATString($this.ColorMap)
        $this.ColorMap = $null
    }
}

Class SIFieldSouthWestRoad : SIInternalBase {
    SIFieldSouthWestRoad(): base() {
        Write-Progress -Activity 'Creating Scene Images      ' -Id 3 -Status 'Creating SIFieldSouthWestRoad' -PercentComplete -1
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

        $this.CreateSceneImageATString($this.ColorMap)
        $this.ColorMap = $null
    }
}

Class SIFieldSouthEastWestRoad : SIInternalBase {
    SIFieldSouthEastWestRoad(): base() {
        Write-Progress -Activity 'Creating Scene Images      ' -Id 3 -Status 'Creating SIFieldSouthEastWestRoad' -PercentComplete -1
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

        $this.CreateSceneImageATString($this.ColorMap)
        $this.ColorMap = $null
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
    }

    MapTileObject(
        [String]$Name,
        [String]$MapObjName,
        [Boolean]$CanAddToInventory,
        [String]$ExamineString,
        [ScriptBlock]$Effect,
        [String[]]$TargetOfFilter
    ) {
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
    }

    [Boolean]ValidateSourceInFilter([String]$SourceItemClass) {
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
        $this.BackgroundImage = $BackgroundImage
        $this.ObjectListing   = [List[MapTileObject]]::new()
        $this.Exits           = $Exits
        
        Foreach($a In $ObjectListing) {
            $this.ObjectListing.Add($a) | Out-Null
        }
    }

    [Boolean]IsItemInTile([String]$ItemName) {
        Foreach($a in $this.ObjectListing) {
            If($a.Name -IEQ $ItemName) {
                Return $true
            }
        }

        Return $false
    }

    [MapTileObject]GetItemReference([String]$ItemName) {
        Foreach($a in $this.ObjectListing) {
            If($a.Name -IEQ $ItemName) {
                Return $a
            }
        }

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
        Write-Progress -Activity 'Creating Maps              ' -Id 2 -Status 'Creating a map' -PercentComplete -1
        $this.Name         = $Name
        $this.MapWidth     = $MapWidth
        $this.MapHeight    = $MapHeight
        $this.BoundaryWrap = $BoundaryWrap
        $this.Tiles = New-Object 'MapTile[,]' $this.MapHeight, $this.MapWidth
    }

    [MapTile]GetTileAtPlayerCoordinates() {
        Return $this.Tiles[$Script:ThePlayer.MapCoordinates.Y, $Script:ThePlayer.MapCoordinates.X]
    }
}

Class MTOTree : MapTileObject {
    MTOTree(): base('Tree', 'tree', $false, 'It''s a tree. Looks like all the other ones.', {
        Param([MapTileObject]$Source)

        "MTOTree::Effect - Starting the block." | Out-File -FilePath $Script:LogFileName -Append
        "MTOTree::Effect - Checking to see what item passed the filter." | Out-File -FilePath $Script:LogFileName -Append
        Switch($Source.PSTypeNames[0]) {
            'MTORope' {
                "MTOTree::Effect - A Rope is being used on the Tree." | Out-File -FilePath $Script:LogFileName -Append
                "MTOTree::Effect - Write a message to the Message Window that the Rope has been tied to the Tree." | Out-File -FilePath $Script:LogFileName -Append
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

                "MTOTree::Effect - Removing the Rope from the Player's Inventory." | Out-File -FilePath $Script:LogFileName -Append
                $Script:ThePlayer.RemoveItemFromInventory($Source.Name)
            }
        }
    },
    @('MTORope')) {}
}

Class MTOLadder : MapTileObject {
    MTOLadder():  base('Ladder', 'ladder', $false, 'Used to climb things. Just don''t walk under one.', {}) {}
}

Class MTORope : MapTileObject {
    MTORope(): base('Rope', 'rope', $false, 'It''s not a snake. Hopefully.', {}) {}
}

Class MTOStairs : MapTileObject {
    MTOStairs(): base('Stairs', 'stairs', $false, 'A faithful ally for elevating one''s position.', {}) {}
}

Class MTOPole : MapTileObject {
    MTOPole(): base('Pole', 'pole', $false, 'Not the north or the south one.', {}) {}
}

Class MTOBacon : MapTileObject {
    MTOBacon(): base('Bacon', 'bacon', $false, 'Shredded swine flesh. Cholesterol never tasted so good.', {}) {}
}

Class MTOApple : MapTileObject {
    MTOApple(): base('Apple', 'apple', $true, 'A big, juicy, red apple. Worm not included.', {}) {}
}

Class MTOStick : MapTileObject {
    MTOStick(): base('Stick', 'stick', $false, 'Be careful not to poke your eye out with it.', {}) {}
}

Class MTOYogurt : MapTileObject {
    MTOYogurt(): base('Yogurt', 'yogurt', $false, 'For some reason, people enjoy this spoiled milk.', {}) {}
}

Class MTORock : MapTileObject {
    MTORock(): base('Rock', 'rock', $false, 'A garden variety rock. Good for taunting raccoons with.', {}) {}
}

Class MTOMilk : MapTileObject {
    MTOMilk(): base('Milk', 'milk', $false, '2%. We don''t take kindly to whole milk ''round here.', {}) {}
}

Class BufferManager {
    [BufferCell[,]]$ScreenBufferA
    [BufferCell[,]]$ScreenBufferB

    BufferManager() {
        Write-Progress -Activity 'Creating ''global'' variables' -Id 1 -Status 'Creating the Buffer Manager' -PercentComplete -1
        $this.ScreenBufferA = New-Object 'BufferCell[,]' 80, 80
        $this.ScreenBufferB = New-Object 'BufferCell[,]' 80, 80
    }

    [Void]CopyActiveToBufferA() {
        $this.ScreenBufferA = $Script:Rui.GetBufferContents([Rectangle]::new(0, 0, 80, 80))
    }
    
    [Void]CopyActiveToBufferAWithWipe() {
        $this.ScreenBufferA = $Script:Rui.GetBufferContents([Rectangle]::new(0, 0, 80, 80))
        Clear-Host
    }

    [Void]CopyActiveToBufferB() {
        $this.ScreenBufferB = $Script:Rui.GetBufferContents([Rectangle]::new(0, 0, 80, 80))
    }

    [Void]CopyActiveToBufferBWithWipe() {
        $this.ScreenBufferB = $Script:Rui.GetBufferContents([Rectangle]::new(0, 0, 80, 80))
        Clear-Host
    }

    [Void]SwapAToB() {
        $this.ScreenBufferB = $this.ScreenBufferA
    }

    [Void]SwapBToA() {
        $this.ScreenBufferA = $this.ScreenBufferB
    }

    [Void]RestoreBufferAToActive() {
        Clear-Host
        $Script:Rui.SetBufferContents([Coordinates]::new(0, 0), $this.ScreenBufferA)
        $this.ScreenBufferA = New-Object 'BufferCell[,]' 80, 80
    }

    [Void]RestoreBufferBToActive() {
        Clear-Host
        $Script:Rui.SetBufferContents([Coordinates]::new(0, 0), $this.ScreenBufferB)
        $this.ScreenBufferB = New-Object 'BufferCell[,]' 80, 80
    }
}

Class LogManager {
    Static [String]$LogFileName = '.\Log.log'

    LogManager() {
        'WELCOME TO THE DANGER ZONE!!!' | Out-File -FilePath [LogManager]::LogFileName
    }

    [Void]WriteToLog(
        [String]$ClassName,
        [String]$Function,
        [String]$MessageContent
    ) {
        "$($ClassName)::$($Function) - $($MessageContent)" | Out-File -FilePath [LogManager]::LogFileName -Append
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
    }
    
    WindowBase(
        [ATCoordinates]$LeftTop,
        [ATCoordinates]$RightBottom,
        [ConsoleColor24[]]$BorderDrawColors,
        [String[]]$BorderStrings,
        [Boolean[]]$BorderDrawDirty
    ) {
        $this.LeftTop          = $LeftTop
        $this.RightBottom      = $RightBottom
        $this.BorderDrawColors = $BorderDrawColors
        $this.BorderStrings    = $BorderStrings
        $this.BorderDrawDirty  = $BorderDrawDirty
        $this.UpdateDimensions()
    }
    
    [Void]Draw() {
        Switch($(Test-GfmOs)) {
            { ($_ -EQ $Script:OsCheckLinux) -OR ($_ -EQ $Script:OsCheckMac) } {
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

                
                Write-Host "$($bt.ToAnsiControlSequenceString())$($bb.ToAnsiControlSequenceString())$($bl.ToAnsiControlSequenceString())$($br.ToAnsiControlSequenceString())"
            }
            
            { $_ -EQ $Script:OsCheckWindows } {
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

                
                Write-Host "$($bt.ToAnsiControlSequenceString())$($bb.ToAnsiControlSequenceString())$($bl.ToAnsiControlSequenceString())$($br.ToAnsiControlSequenceString())"
            }
            
            Default {}
        }
    }

    [Void]UpdateDimensions() {
        # $this.Width  = $this.LeftTop.Column + $this.RightBottom.Column
        # $this.Height = $this.LeftTop.Row + $this.RightBottom.Row
        $this.Width  = $this.RightBottom.Column - $this.LeftTop.Column
        $this.Height = $this.RightBottom.Row - $this.LeftTop.Row
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
        Write-Progress -Activity 'Creating ''global'' variables' -Id 1 -Status 'Creating Status Window' -PercentComplete -1
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
        $this.PlayerNameDrawDirty = $true
        $this.PlayerHpDrawDirty   = $true
        $this.PlayerMpDrawDirty   = $true
        $this.PlayerGoldDrawDirty = $true
        # $this.PlayerAilDrawDirty  = $true
    }
    
    [Void]Draw() {
        ([WindowBase]$this).Draw()
        
        Switch($(Test-GfmOs)) {
            { ($_ -EQ $Script:OsCheckLinux) -OR ($_ -EQ $Script:OsCheckMac) } {
                If($this.PlayerNameDrawDirty) {
                    Write-Host $Script:ThePlayer.GetFormattedNameString([StatusWindow]::PlayerNameDrawCoordinates)
                    $this.PlayerNameDrawDirty = $false
                }
                If($this.PlayerHpDrawDirty) {
                    Write-Host $Script:ThePlayer.GetFormattedHitPointsString([StatusWindow]::PlayerHpDrawCoordinates)
                    $this.PlayerHpDrawDirty = $false
                }
                If($this.PlayerMpDrawDirty) {
                    Write-Host $Script:ThePlayer.GetFormattedMagicPointsString([StatusWindow]::PlayerMpDrawCoordinates)
                    $this.PlayerMpDrawDirty = $false
                }
                If($this.PlayerGoldDrawDirty) {
                    Write-Host $Script:ThePlayer.GetFormattedGoldString([StatusWindow]::PlayerGoldDrawCoordinates)
                    $this.PlayerGoldDrawDirty = $false
                }
            }
            
            { $_ -EQ $Script:OsCheckWindows } {
                If($this.PlayerNameDrawDirty) {
                    Write-Host $Script:ThePlayer.GetFormattedNameString([StatusWindow]::PlayerNameDrawCoordinates)
                    $this.PlayerNameDrawDirty = $false
                }
                If($this.PlayerHpDrawDirty) {
                    Write-Host $Script:ThePlayer.GetFormattedHitPointsString([StatusWindow]::PlayerHpDrawCoordinates)
                    $this.PlayerHpDrawDirty = $false
                }
                If($this.PlayerMpDrawDirty) {
                    Write-Host $Script:ThePlayer.GetFormattedMagicPointsString([StatusWindow]::PlayerMpDrawCoordinates)
                    $this.PlayerMpDrawDirty = $false
                }
                If($this.PlayerGoldDrawDirty) {
                    Write-Host $Script:ThePlayer.GetFormattedGoldString([StatusWindow]::PlayerGoldDrawCoordinates)
                    $this.PlayerGoldDrawDirty = $false
                }
            }
            
            Default {}
        }
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
        Write-Progress -Activity 'Creating ''global'' variables' -Id 1 -Status 'Creating the Command Window' -PercentComplete -1
        "CommandWindow::Constructor - Starting the constructor." | Out-File -FilePath $Script:LogFileName -Append
        
        "CommandWindow::Constructor - `tSetting LeftTop and BottomRight relative to the desired window position." | Out-File -FilePath $Script:LogFileName -Append
        $this.LeftTop     = [ATCoordinates]::new([CommandWindow]::WindowLTRow, [CommandWindow]::WindowLTColumn)
        $this.RightBottom = [ATCoordinates]::new([CommandWindow]::WindowRBRow, [CommandWindow]::WindowRBColumn)
        
        "CommandWindow::Constructor - `tSetting the BorderDrawColors relative to the desired effect for this window (all sides CCWhite24)." | Out-File -FilePath $Script:LogFileName -Append
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new()
        )

        "CommandWindow::Constructor - `tSettings BorderStrings relative to the desired strings for this window." | Out-File -FilePath $Script:LogFileName -Append
        $this.BorderStrings = [String[]](
            [CommandWindow]::WindowBorderHorizontal,
            [CommandWindow]::WindowBorderVertical
        )

        "CommandWindow::Constructor - `tCalling UpdateDimensions to ensure that measurements are correct." | Out-File -FilePath $Script:LogFileName -Append
        $this.UpdateDimensions()

        "CommandWindow::Constructor - `tCommandDivDirty to true and CommandHistoryDirty to false." | Out-File -FilePath $Script:LogFileName -Append
        $this.CommandDivDirty     = $true
        $this.CommandHistoryDirty = $false

        "CommandWindow::Constructor - `tDefining rowBase to $($this.RightBottom.Row) and columnBase to $($this.LeftTop.Column + [CommandWindow]::DrawColumnOffset)." | Out-File -FilePath $Script:LogFileName -Append
        [Int]$rowBase    = $this.RightBottom.Row
        [Int]$columnBase = $this.LeftTop.Column + [CommandWindow]::DrawColumnOffset

        "CommandWindow::Constructor - `tCalculating History String Drawing Coordinates." | Out-File -FilePath $Script:LogFileName -Append
        [CommandWindow]::CommandDivDrawCoordinates      = [ATCoordinates]::new($rowBase - [CommandWindow]::DrawDivRowOffset, $columnBase)
        [CommandWindow]::CommandHistoryEDrawCoordinates = [ATCoordinates]::new($rowBase - [CommandWindow]::DrawHistoryERowOffset, $columnBase)
        [CommandWindow]::CommandHistoryDDrawCoordinates = [ATCoordinates]::new($rowBase - [CommandWindow]::DrawHistoryDRowOffset, $columnBase)
        [CommandWindow]::CommandHistoryCDrawCoordinates = [ATCoordinates]::new($rowBase - [CommandWindow]::DrawHistoryCRowOffset, $columnBase)
        [CommandWindow]::CommandHistoryBDrawCoordinates = [ATCoordinates]::new($rowBase - [CommandWindow]::DrawHistoryBRowOffset, $columnBase)
        [CommandWindow]::CommandHistoryADrawCoordinates = [ATCoordinates]::new($rowBase - [CommandWindow]::DrawHistoryARowOffset, $columnBase)

        "CommandWindow::Constructor - `tHistory String Drawing Coordinates have been calculated as follows:" | Out-File -FilePath $Script:LogFileName -Append
        "CommandWindow::Constructor - `t`tDiv: (R$([CommandWindow]::CommandDivDrawCoordinates.Row), C$([CommandWindow]::CommandDivDrawCoordinates.Column))" | Out-File -FilePath $Script:LogFileName -Append
        "CommandWindow::Constructor - `t`tE: (R$([CommandWindow]::CommandHistoryEDrawCoordinates.Row), C$([CommandWindow]::CommandHistoryEDrawCoordinates.Column))" | Out-File -FilePath $Script:LogFileName -Append
        "CommandWindow::Constructor - `t`tD: (R$([CommandWindow]::CommandHistoryDDrawCoordinates.Row), C$([CommandWindow]::CommandHistoryDDrawCoordinates.Column))" | Out-File -FilePath $Script:LogFileName -Append
        "CommandWindow::Constructor - `t`tC: (R$([CommandWindow]::CommandHistoryCDrawCoordinates.Row), C$([CommandWindow]::CommandHistoryCDrawCoordinates.Column))" | Out-File -FilePath $Script:LogFileName -Append
        "CommandWindow::Constructor - `t`tB: (R$([CommandWindow]::CommandHistoryBDrawCoordinates.Row), C$([CommandWindow]::CommandHistoryBDrawCoordinates.Column))" | Out-File -FilePath $Script:LogFileName -Append
        "CommandWindow::Constructor - `t`tA: (R$([CommandWindow]::CommandHistoryADrawCoordinates.Row), C$([CommandWindow]::CommandHistoryADrawCoordinates.Column))" | Out-File -FilePath $Script:LogFileName -Append

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
    }

    [Void]Draw() {
        "CommandWindow::Draw - Starting the Draw function." | Out-File -FilePath $Script:LogFileName -Append
        "CommandWindow::Draw - Calling base class Draw function." | Out-File -FilePath $Script:LogFileName -Append
        ([WindowBase]$this).Draw()

        "CommandWindow::Draw - Checking to see if the CommandDivDirty flag is true." | Out-File -FilePath $Script:LogFileName -Append
        If($this.CommandDivDirty -EQ $true) {
            "CommandWindow::Draw - `tCommandDivDirty is true, draw the Command Div to the console." | Out-File -FilePath $Script:LogFileName -Append
            Write-Host "$([CommandWindow]::CommandDiv.ToAnsiControlSequenceString())"

            "CommandWindow::Draw - `tSetting CommandDivDirty to false to avoid overdraws." | Out-File -FilePath $Script:LogFileName -Append
            $this.CommandDivDirty = $false
        }

        "CommandWindow::Draw - Checking to see if the CommandHistoryDirty flag is true." | Out-File -FilePath $Script:LogFileName -Append
        If($this.CommandHistoryDirty -EQ $true) {
            "CommandWindow::Draw - `tCommandHistoryDirty is true, draw the Command History strings to the console." | Out-File -FilePath $Script:LogFileName -Append
            
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

            # Foreach($cmd in $this.CommandHistory) {
            #     "CommandWindow::Draw - `t`tCurrent CMD iteration values: (R$($cmd.Prefix.Coordinates.Row), C$($cmd.Prefix.Coordinates.Column))." | Out-File -FilePath $Script:LogFileName -Append

            #     "CommandWindow::Draw - `t`tUpdating the Blank's Coordinates to match the current iteration." | Out-File -FilePath $Script:LogFileName -Append
            #     [CommandWindow]::CommandBlank.Prefix.Coordinates = $cmd.Prefix.Coordinates
            #     "CommandWindow::Draw - `t`tThe blank's current coordinates are (R$([CommandWindow]::CommandBlank.Prefix.Coordinates.Row), C$([CommandWindow]::CommandBlank.Prefix.Coordinates.Column))." | Out-File -FilePath $Script:LogFileName -Append
                
            #     "CommandWindow::Draw - `t`tDrawing the Command Blank first to clear out the line." | Out-File -FilePath $Script:LogFileName -Append
            #     Write-Host "$([CommandWindow]::CommandBlank.ToAnsiControlSequenceString())"

            #     "CommandWindow::Draw - `t`tDrawing the Command itself ($($cmd.ToAnsiControlSequenceString()))." | Out-File -FilePath $Script:LogFileName -Append
            #     Write-Host "$($cmd.ToAnsiControlSequenceString())"
            # }

            "CommandWindow::Draw - `tSetting the CommandHistoryDirty flag to false." | Out-File -FilePath $Script:LogFileName -Append
            $this.CommandHistoryDirty = $false
        }
    }

    [Void]HandleInput() {
        $Script:Rui.CursorPosition = $Script:DefaultCursorCoordinates.ToAutomationCoordinates()
        
        $keyCap = $Script:Rui.ReadKey('IncludeKeyDown')

        While($keyCap.VirtualKeyCode -NE 13) {
            $cpx = $Script:Rui.CursorPosition.X
            
            If($cpx -GE 19) {
                $this.InvokeCommandParser()
            }
            
            Switch($keyCap.VirtualKeyCode) {
                8 { # Backspace
                    "CommandWindow::HandleInput - Backspace Key has been pressed. Virtual Key Code value is $($keyCap.VirtualKeyCode)" | Out-File -FilePath $Script:LogFileName -Append
                    
                    $fpx = $Script:Rui.CursorPosition.X
                    "CommandWindow::HandleInput - `tObtaining current Cursor Position X (Row) Value as FPX. The current value is $($fpx)" | Out-File -FilePath $Script:LogFileName -Append

                    "CommandWindow::HandleInput - `tComparing FPX against the Default Coordinates X (Row). The default value is $($Script:DefaultCursorCoordinates.Row), and FPX is $($fpx)." | Out-File -FilePath $Script:LogFileName -Append
                    If($fpx -GT $Script:DefaultCursorCoordinates.Row) {
                        "CommandWindow::HandleInput - `t`tFPX is GREATER THAN the Default Coordinates X (Row)." | Out-File -FilePath $Script:LogFileName -Append
                        "CommandWindow::HandleInput - `t`tThe character that would be deleted here is $($this.CommandActual.UserData[$fpx - 1])." | Out-File -FilePath $Script:LogFileName -Append
                        "CommandWindow::HandleInput - `t`tPerforming character deletion from console window." | Out-File -FilePath $Script:LogFileName -Append
                        Write-Host " `b" -NoNewLine

                        "CommandWindow::HandleInput - `t`tThe current value of Command Actual is $($this.CommandActual.UserData). Attempting to delete the last character." | Out-File -FilePath $Script:LogFileName -Append
                        If($this.CommandActual.UserData.Length -GT 0) {
                            $this.CommandActual.UserData = $this.CommandActual.UserData.Remove($this.CommandActual.UserData.Length - 1, 1)
                            "CommandWindow::HandleInput - `t`tThe last character has been deleted. The current value of Command Actual is $($this.CommandActual.UserData)." | Out-File -FilePath $Script:LogFileName -Append
                        } Else {
                            "CommandWindow::HandleInput - `t`tCommand Actual has no data in it; there's nothing to delete." | Out-File -FilePath $Script:LogFileName -Append
                        }
                    } Elseif($fpx -LT $Script:DefaultCursorCoordinates.Row) {
                        "CommandWindow::HandleInput - `t`tFPX is LESS THAN the Default Coordinates X (Row)." | Out-File -FilePath $Script:LogFileName -Append
                        "CommandWindow::HandleInput - `t`tThis character can't be deleted because it's part of the window. Resetting the Cursor X (Row) position to the default." | Out-File -FilePath $Script:LogFileName -Append
                        $Script:Rui.CursorPosition = $Script:DefaultCursorCoordinates.ToAutomationCoordinates()
                        # Write-Host "`b " -NoNewLine
                    } Elseif($fpx -EQ $Script:DefaultCursorCoordinates.Row) {
                        "CommandWindow::HandleInput - `t`tFPX is EQUAL TO the Default Coordinates X (Row)."                                       | Out-File -FilePath $Script:LogFileName -Append
                        "CommandWindow::HandleInput - `t`tThe character that would be deleted here is $($this.CommandActual.UserData[$fpx - 1])." | Out-File -FilePath $Script:LogFileName -Append
                        Write-Host " `b" -NoNewline

                        "CommandWindow::HandleInput - `t`tThe current value of Command Actual is $($this.CommandActual.UserData). Attempting to delete the last character." | Out-File -FilePath $Script:LogFileName -Append
                        If($this.CommandActual.UserData.Length -GT 0) {
                            $this.CommandActual.UserData = $this.CommandActual.UserData.Remove($this.CommandActual.UserData.Length - 1, 1)
                            "CommandWindow::HandleInput - `t`tThe last character has been deleted. The current value of Command Actual is $($this.CommandActual.UserData)." | Out-File -FilePath $Script:LogFileName -Append
                        } Else {
                            "CommandWindow::HandleInput - `t`tCommand Actual has no data in it; there's nothing to delete." | Out-File -FilePath $Script:LogFileName -Append
                        }
                    }
                }
    
                Default {
                    "CommandWindow::HandleInput - A regular keypress has been detected. Adding $($keyCap.Character) to Command Actual." | Out-File -FilePath $Script:LogFileName -Append
                    $this.CommandActual.UserData += $keyCap.Character
                    "CommandWindow::HandleInput - `tThe current value of Command Actual is $($this.CommandActual.UserData)." | Out-File -FilePath $Script:LogFileName -Append
                }
            }

            $keyCap = $Script:Rui.ReadKey('IncludeKeyDown')
        }

        $this.InvokeCommandParser()
    }

    [Void]InvokeCommandParser() {
        "CommandWindow::InvokeCommandParser - Starting the CommandParser." | Out-File -FilePath $Script:LogFileName -Append
        "CommandWindow::InvokeCommandParser - `tWriting the Command Blank." | Out-File -FilePath $Script:LogFileName -Append
        $Script:Rui.CursorPosition = $Script:DefaultCursorCoordinates.ToAutomationCoordinates()
        Write-Host "$([CommandWindow]::CommandBlank.ToAnsiControlSequenceString())" -NoNewline
        $Script:Rui.CursorPosition = $Script:DefaultCursorCoordinates.ToAutomationCoordinates()
        "CommandWindow::InvokeCommandParser - `tCommand Blank has been written." | Out-File -FilePath $Script:LogFileName -Append

        "CommandWindow::InvokeCommandParser - `tChecking to see if Command Actual contains anything." | Out-File -FilePath $Script:LogFileName -Append
        If([String]::IsNullOrEmpty($this.CommandActual.UserData)) {
            "CommandWindow::InvokeCommandParser - `t`tIt doesn't. Exiting." | Out-File -FilePath $Script:LogFileName -Append
            Return
        } Else {
            "CommandWindow::InvokeCommandParser - `t`tIt contains data. The current data is $($this.CommandActual.UserData). Attempting to split the string." | Out-File -FilePath $Script:LogFileName -Append
            $cmdactSplit = -SPLIT $this.CommandActual.UserData
            "CommandWindow::InvokeCommandParser - `t`tSplit is successful. The split data is $({Foreach($a in $cmdactSplit){"$a, "}})." | Out-File -FilePath $Script:LogFileName -Append
            
            "CommandWindow::InvokeCommandParser - `t`tAttempting to find the root command in the Command Table." | Out-File -FilePath $Script:LogFileName -Append
            $rootFound = $Script:TheCommandTable.GetEnumerator() | Where-Object { $_.Name -IEQ $cmdactSplit[0] }
            
            If($null -NE $rootFound) {
                "CommandWindow::InvokeCommandParser - `t`tA root command has been identified as '$($cmdactSplit[0])' Now checking the length of the split to determine the ScriptBlock invocation style." | Out-File -FilePath $Script:LogFileName -Append
                Switch($cmdactSplit.Length) {
                    1 {
                        "CommandWindow::InvokeCommandParser - `t`t`tSplit length is 1, invoking the root command '$($cmdactSplit[0])' without arguments." | Out-File -FilePath $Script:LogFileName -Append
                        Invoke-Command $rootFound.Value
                    }

                    2 {
                        "CommandWindow::InvokeCommandParser - `t`t`tSplit length is 2, invoking the root command '$($cmdactSplit[0])' with one argument '$($cmdactSplit[1])'." | Out-File -FilePath $Script:LogFileName -Append
                        Invoke-Command $rootFound.Value -ArgumentList $cmdactSplit[1]
                    }

                    3 {
                        "CommandWindow::InvokeCommandParser - `t`t`tSplit length is 3, invoking the root command '$($cmdactSplit[0])' with two arguments, '$($cmdactSplit[1])' and '$($cmdactSplit[2])'." | Out-File -FilePath $Script:LogFileName -Append
                        Invoke-Command $rootFound.Value -ArgumentList $cmdactSplit[1], $cmdactSplit[2]
                    }

                    Default {
                        "CommandWindow::InvokeCommandParser - `t`t`tAn unknown exceptional case has occurred." | Out-File -FilePath $Script:LogFileName -Append
                        $Script:TheCommandWindow.UpdateCommandHistory($false)
                        # TODO: This is an exceptional case
                    }
                }
            } Else {
                "CommandWindow::InvokeCommandParser - `t`tAn invalid command has been typed in. Asking the Command Window to update the history." | Out-File -FilePath $Script:LogFileName -Append
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
        $a = $Script:CurrentMap.GetTileAtPlayerCoordinates().ObjectListing
        $b = 78
        $c = ''
        $f = ''
        $z = 0
        $y = $false

        If($a.Count -LE 0) {
            $Script:TheMessageWindow.WriteMapNoItemsFoundMessage()
            Return
        }

        Foreach($d in $a) {
            If($z -EQ $a.Count - 1) {
                $c += $d.Name
            } Else {
                $c += $d.Name + ', '
            }
            $z++
        }
        $e = $c.Length

        If($e -GT $b) {
            $y = $true
            $c -MATCH '([\s,]+\w+){5}$' | Out-Null
            If($_ -EQ $true) {
                $c = $c -REPLACE '([\s,]+\w+){5}$', ''
                $f = $matches[0].Remove(0, 2)
            }
        }

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

        If($y -EQ $true) {
            $Script:TheMessageWindow.WriteMessage(
                $f,
                [CCApplePinkDark24]::new(),
                [ATDecorationNone]::new()
            )
        }
    }

    [Void]InvokeExamineAction(
        [String]$ItemName
    ) {
        "CommandWindow::InvokeExamineAction - Starting the function." | Out-File -FilePath $Script:LogFileName -Append
        "CommandWindow::InvokeExamineAction - Iterating through the current tile's Object Listing to find an Item Name match." | Out-File -FilePath $Script:LogFileName -Append
        "CommandWindow::InvokeExamineAction - The Item Name we're looking for is $($ItemName)." | Out-File -FilePath $Script:LogFileName -Append
        Foreach($a in $Script:CurrentMap.GetTileAtPlayerCoordinates().ObjectListing) {
            "CommandWindow::InvokeExamineAction - The iterator Item Name is $($a.Name)." | Out-File -FilePath $Script:LogFileName -Append
            If($a.Name -IEQ $ItemName) {
                "CommandWindow::InvokeExamineAction - Match has been found. Updating the Command Window History with success." | Out-File -FilePath $Script:LogFileName -Append
                $Script:TheCommandWindow.UpdateCommandHistory($true)
                "CommandWindow::InvokeExamineAction - Writing the Item's ExamineString to the Message Window History." | Out-File -FilePath $Script:LogFileName -Append
                $Script:TheMessageWindow.WriteMessage(
                    "$($a.ExamineString)",
                    [CCAppleMintDark24]::new(),
                    [ATDecorationNone]::new()
                )
                "CommandWindow::InvokeExamineAction - Leaving the function." | Out-File -FilePath $Script:LogFileName -Append
                Return
            }
        }

        "CommandWindow::InvokeExamineAction - Match has NOT been found. Updating the Command Window History with failure." | Out-File -FilePath $Script:LogFileName -Append
        $Script:TheCommandWindow.UpdateCommandHistory($false)
        "CommandWindow::InvokeExamineAction - Writing the error message to the Message Window History." | Out-File -FilePath $Script:LogFileName -Append
        $Script:TheMessageWindow.WriteMapInvalidItemMessage($ItemName)
        "CommandWindow::InvokeExamineAction - Leaving the function." | Out-File -FilePath $Script:LogFileName -Append
        Return
    }

    [Void]InvokeGetAction(
        [String]$ItemName
    ) {
        "CommandWindow::InvokeGetAction - Starting the function." | Out-File -FilePath $Script:LogFileName -Append
        "CommandWindow::InvokeGetAction - Getting a reference to the current Map Tile's Object Listing." | Out-File -FilePath $Script:LogFileName -Append
        $a = $Script:CurrentMap.GetTileAtPlayerCoordinates().ObjectListing
        
        "CommandWindow::InvokeGetAction - Checking to see if the length of the reference is LESS THAN OR EQUAL TO zero." | Out-File -FilePath $Script:LogFileName -Append
        If($a.Count -LE 0) {
            "CommandWindow::InvokeGetAction - It is, meaning that there's nothing on this tile." | Out-File -FilePath $Script:LogFileName -Append
            "CommandWindow::InvokeGetAction - Updating the Command Window History and Message Window History." | Out-File -FilePath $Script:LogFileName -Append
            $Script:TheCommandWindow.UpdateCommandHistory($false)
            $Script:TheMessageWindow.WriteMapNoItemsFoundMessage()
            "CommandWindow::InvokeGetAction - Leaving the function." | Out-File -FilePath $Script:LogFileName -Append
            Return
        }
        "CommandWindow::InvokeGetAction - The length of the reference is at least 1." | Out-File -FilePath $Script:LogFileName -Append
        "CommandWindow::InvokeGetAction - Iterating through the reference collection to see if we can find a name match." | Out-File -FilePath $Script:LogFileName -Append
        Foreach($b in $a) {
            "CommandWindow::InvokeGetAction - The Item Name we're looking for is $($ItemName)." | Out-File -FilePath $Script:LogFileName -Append
            "CommandWindow::InvokeGetAction - The current iteration's name is $($b.Name)." | Out-File -FilePath $Script:LogFileName -Append
            "CommandWindow::InvokeGetAction - Checking to see if these match." | Out-File -FilePath $Script:LogFileName -Append
            If($b.Name -IEQ $ItemName) {
                "CommandWindow::InvokeGetAction - A match has been found." | Out-File -FilePath $Script:LogFileName -Append
                "CommandWindow::InvokeGetAction - Checking to see if this Item can be added to the Player's Inventory." | Out-File -FilePath $Script:LogFileName -Append
                If($b.CanAddToInventory -EQ $true) {
                    "CommandWindow::InvokeGetAction - It can. Copying the current item into the Player's Inventory collection." | Out-File -FilePath $Script:LogFileName -Append
                    $Script:ThePlayer.Inventory.Add($b) | Out-Null
                    "CommandWindow::InvokeGetAction - Attempting to remove this item from the current Map Tile's Object Listing." | Out-File -FilePath $Script:LogFileName -Append
                    $c = $a.Remove($b) | Out-Null
                    "CommandWindow::InvokeGetAction - Checking to see if the removal was successful or not." | Out-File -FilePath $Script:LogFileName -Append
                    If($c -EQ $false) {
                        "CommandWindow::InvokeGetAction - The removal failed." | Out-File -FilePath $Script:LogFileName -Append
                        "CommandWindow::InvokeGetAction - THIS IS A CRITICAL ERROR - PREMATURELY TERMINATING THE PROGRAM!" | Out-File -FilePath $Script:LogFileName -Append
                        Write-Error 'Failed to remove an item from the Map Tile!'
                        Exit
                    } Else {
                        "CommandWindow::InvokeGetAction - The removal was successful." | Out-File -FilePath $Script:LogFileName -Append
                        "CommandWindow::InvokeGetAction - Updating the Command Window History and Message Window History." | Out-File -FilePath $Script:LogFileName -Append
                        $Script:TheCommandWindow.UpdateCommandHistory($true)
                        $Script:TheMessageWindow.WriteItemTakenMessage($ItemName)
                        "CommandWindow::InvokeGetAction - Leaving the function." | Out-File -FilePath $Script:LogFileName -Append
                        Return
                    }
                } Else {
                    "CommandWindow::InvokeGetAction - It can't. Updating the Command Window History and Message Window History." | Out-File -FilePath $Script:LogFileName -Append
                    $Script:TheCommandWindow.UpdateCommandHistory($true)
                    $Script:TheMessageWindow.WriteItemCantTakeMessage($ItemName)
                    "CommandWindow::InvokeGetAction - Leaving the function." | Out-File -FilePath $Script:LogFileName -Append
                    Return
                }
            }
        }

        "CommandWindow::InvokeGetAction - Although there are Items in the reference collection, none of them match the terms." | Out-File -FilePath $Script:LogFileName -Append
        "CommandWindow::InvokeGetAction - Updating the Command Window History and Message Window History." | Out-File -FilePath $Script:LogFileName -Append
        $Script:TheCommandWindow.UpdateCommandHistory($false)
        $Script:TheMessageWindow.WriteMapInvalidItemMessage($ItemName)
        "CommandWindow::InvokeGetAction - Leaving the function." | Out-File -FilePath $Script:LogFileName -Append
        Return
    }

    [Void]UpdateCommandHistory(
        [Boolean]$CmdValid
    ) {
        "CommandWindow::UpdateCommandHistory - Starting to shuffle the Command History around." | Out-File -FilePath $Script:LogFileName -Append
        
        "CommandWindow::UpdateCommandHistory - Setting History E ('$($this.CommandHistory[[CommandWindow]::CommandHistoryERef].UserData)') to History A ('$($this.CommandHistory[[CommandWindow]::CommandHistoryARef].UserData)')." | Out-File -FilePath $Script:LogFileName -Append
        $this.CommandHistory[[CommandWindow]::CommandHistoryERef].UserData               = $this.CommandHistory[[CommandWindow]::CommandHistoryARef].UserData
        $this.CommandHistory[[CommandWindow]::CommandHistoryERef].Prefix.Decorations     = $this.CommandHistory[[CommandWindow]::CommandHistoryARef].Prefix.Decorations
        $this.CommandHistory[[CommandWindow]::CommandHistoryERef].Prefix.ForegroundColor = $this.CommandHistory[[CommandWindow]::CommandHistoryARef].Prefix.ForegroundColor

        "CommandWindow::UpdateCommandHistory - Setting History A ('$($this.CommandHistory[[CommandWindow]::CommandHistoryARef].UserData)') to History B ('$($this.CommandHistory[[CommandWindow]::CommandHistoryBRef].UserData)')." | Out-File -FilePath $Script:LogFileName -Append
        $this.CommandHistory[[CommandWindow]::CommandHistoryARef].UserData               = $this.CommandHistory[[CommandWindow]::CommandHistoryBRef].UserData
        $this.CommandHistory[[CommandWindow]::CommandHistoryARef].Prefix.Decorations     = $this.CommandHistory[[CommandWindow]::CommandHistoryBRef].Prefix.Decorations
        $this.CommandHistory[[CommandWindow]::CommandHistoryARef].Prefix.ForegroundColor = $this.CommandHistory[[CommandWindow]::CommandHistoryBRef].Prefix.ForegroundColor
        
        "CommandWindow::UpdateCommandHistory - Setting History B ('$($this.CommandHistory[[CommandWindow]::CommandHistoryBRef].UserData)') to History C ('$($this.CommandHistory[[CommandWindow]::CommandHistoryCRef].UserData)')." | Out-File -FilePath $Script:LogFileName -Append
        $this.CommandHistory[[CommandWindow]::CommandHistoryBRef].UserData               = $this.CommandHistory[[CommandWindow]::CommandHistoryCRef].UserData
        $this.CommandHistory[[CommandWindow]::CommandHistoryBRef].Prefix.Decorations     = $this.CommandHistory[[CommandWindow]::CommandHistoryCRef].Prefix.Decorations
        $this.CommandHistory[[CommandWindow]::CommandHistoryBRef].Prefix.ForegroundColor = $this.CommandHistory[[CommandWindow]::CommandHistoryCRef].Prefix.ForegroundColor
        
        "CommandWindow::UpdateCommandHistory - Setting History C ('$($this.CommandHistory[[CommandWindow]::CommandHistoryCRef].UserData)') to History D ('$($this.CommandHistory[[CommandWindow]::CommandHistoryDRef].UserData)')." | Out-File -FilePath $Script:LogFileName -Append
        $this.CommandHistory[[CommandWindow]::CommandHistoryCRef].UserData               = $this.CommandHistory[[CommandWindow]::CommandHistoryDRef].UserData
        $this.CommandHistory[[CommandWindow]::CommandHistoryCRef].Prefix.Decorations     = $this.CommandHistory[[CommandWindow]::CommandHistoryDRef].Prefix.Decorations
        $this.CommandHistory[[CommandWindow]::CommandHistoryCRef].Prefix.ForegroundColor = $this.CommandHistory[[CommandWindow]::CommandHistoryDRef].Prefix.ForegroundColor
        
        "CommandWindow::UpdateCommandHistory - Setting History D ('$($this.CommandHistory[[CommandWindow]::CommandHistoryDRef].UserData)') to Command Actual ('$($this.CommandActual.UserData)')." | Out-File -FilePath $Script:LogFileName -Append
        $this.CommandHistory[[CommandWindow]::CommandHistoryDRef].UserData = $this.CommandActual.UserData

        "CommandWindow::UpdateCommandHistory - The current layout of the history is as follows: E: $($this.CommandHistory[[CommandWindow]::CommandHistoryERef].UserData), A: $($this.CommandHistory[[CommandWindow]::CommandHistoryARef].UserData), B: $($this.CommandHistory[[CommandWindow]::CommandHistoryBRef].UserData), C: $($this.CommandHistory[[CommandWindow]::CommandHistoryCRef].UserData), D: $($this.CommandHistory[[CommandWindow]::CommandHistoryDRef].UserData)" | Out-File -FilePath $Script:LogFileName -Append

        "CommandWindow::UpdateCommandHistory - Checking to see if the Command Valid flag is true or false." | Out-File -FilePath $Script:LogFileName -Append
        If($CmdValid -EQ $true) {
            "CommandWindow::UpdateCommandHistory - `tThe Command Valid Flag is true. Set the Foreground Color to HistoryEntryValid." | Out-File -FilePath $Script:LogFileName -Append
            $this.CommandHistory[[CommandWindow]::CommandHistoryDRef].Prefix.ForegroundColor = [CommandWindow]::HistoryEntryValid
            $this.CommandHistory[[CommandWindow]::CommandHistoryDRef].Prefix.Decorations     = [ATDecorationNone]::new()
        } Else {
            "CommandWindow::UpdateCommandHistory - `tThe Command Valid Flag is false. Set the Foreground Color to HistoryEntryError and set the Decoration to Blink." | Out-File -FilePath $Script:LogFileName -Append
            $this.CommandHistory[[CommandWindow]::CommandHistoryDRef].Prefix.ForegroundColor = [CommandWindow]::HistoryEntryError
            $this.CommandHistory[[CommandWindow]::CommandHistoryDRef].Prefix.Decorations = [ATDecoration]::new($true)
        }

        "CommandWindow::UpdateCommandHistory - `tClearing the Command Actual." | Out-File -FilePath $Script:LogFileName -Append
        $this.CommandActual.UserData = ''

        "CommandWindow::UpdateCommandHistory - Set the CommandHistoryDirty flag to true so the Draw function will draw the strings to the console." | Out-File -FilePath $Script:LogFileName -Append
        $this.CommandHistoryDirty = $true
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
        Write-Progress -Activity 'Creating ''global'' variables' -Id 1 -Status 'Creating the Scene Window' -PercentComplete -1
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

        #[SceneWindow]::SceneImageDrawCoordinates = [ATCoordinates]::new($this.LeftTop.Row + [SceneWindow]::ImageDrawRowOffset, $this.LeftTop.Column + [SceneWindow]::ImageDrawColumnOffset)
        [SceneWindow]::SceneImageDrawCoordinates = [ATCoordinates]::new([SceneWindow]::ImageDrawRowOffset, [SceneWindow]::ImageDrawColumnOffset)
    }
    
    [Void]Draw() {
        ([WindowBase]$this).Draw()

        If($this.SceneImageDirty) {
            Write-Host "$($this.Image.ToAnsiControlSequenceString())"
            $this.SceneImageDirty = $false
        }
    }

    [Void]UpdateCurrentImage([SceneImage]$NewImage) {
        $this.Image           = $NewImage
        $this.SceneImageDirty = $true
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
        Write-Progress -Activity 'Creating ''global'' variables' -Id 1 -Status 'Creating the Message Window' -PercentComplete -1
        "MessageWindow::Constructor - Starting the constructor." | Out-File -FilePath $Script:LogFileName -Append
        
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

        "MessageWindow::Constructor - Calculating the Message Draw Coordinates." | Out-File -FilePath $Script:LogFileName -Append

        [MessageWindow]::MessageCDrawCoordinates = [ATCoordinates]::new(($this.RightBottom.Row - 1), ($this.LeftTop.Column + 1))
        [MessageWindow]::MessageBDrawCoordinates = [ATCoordinates]::new(([MessageWindow]::MessageCDrawCoordinates.Row - 1), ($this.LeftTop.Column + 1))
        [MessageWindow]::MessageADrawCoordinates = [ATCoordinates]::new(([MessageWindow]::MessageBDrawCoordinates.Row - 1), ($this.LeftTop.Column + 1))

        "MessageWindow::Constructor - The calculated coordinates are as follows:" | Out-File -FilePath $Script:LogFileName -Append
        "MessageWindow::Constructor - Message A: (R$([MessageWindow]::MessageADrawCoordinates.Row), C$([MessageWindow]::MessageADrawCoordinates.Column))." | Out-File -FilePath $Script:LogFileName -Append
        "MessageWindow::Constructor - Message B: (R$([MessageWindow]::MessageBDrawCoordinates.Row), C$([MessageWindow]::MessageBDrawCoordinates.Column))." | Out-File -FilePath $Script:LogFileName -Append
        "MessageWindow::Constructor - Message C: (R$([MessageWindow]::MessageCDrawCoordinates.Row), C$([MessageWindow]::MessageCDrawCoordinates.Column))." | Out-File -FilePath $Script:LogFileName -Append

        "MessageWindow::Constructor - Creating the MessageWindowBlank ATString." | Out-File -FilePath $Script:LogFileName -Append

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

        "MessageWindow::Constructor - Creating the MessageHistory ATString array with a size of 3." | Out-File -FilePath $Script:LogFileName -Append

        $this.MessageHistory = New-Object 'ATString[]' 3
        
        "MessageWindow::Constructor - Creating new ATString instances in the MessageHistory array using the appropriate draw coorinates and the MessageWindowBlank UserData as models." | Out-File -FilePath $Script:LogFileName -Append

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

        "MessageWindow::Constructor - Leaving the constructor." | Out-File -FilePath $Script:LogFileName -Append
    }

    [Void]Draw() {
        "MessageWindow::Draw - Entering the Draw method." | Out-File -FilePath $Script:LogFileName -Append

        "MessageWindow::Draw - Calling the base class Draw method." | Out-File -FilePath $Script:LogFileName -Append
        
        ([WindowBase]$this).Draw()

        "MessageWindow::Draw - Checking to see if MessageADirty is true." | Out-File -FilePath $Script:LogFileName -Append

        If($this.MessageADirty -EQ $true) {
            "MessageWindow::Draw - MessageADirty is true, redrawing Message A to the window at its predefined coordinates (blank first, then string)." | Out-File -FilePath $Script:LogFileName -Append
            [MessageWindow]::MessageWindowBlank.Prefix.Coordinates = $this.MessageHistory[[MessageWindow]::MessageHistoryARef].Prefix.Coordinates
            Write-Host "$([MessageWindow]::MessageWindowBlank.ToAnsiControlSequenceString())"
            Write-Host "$($this.MessageHistory[[MessageWindow]::MessageHistoryARef].ToAnsiControlSequenceString())"

            "MessageWindow::Draw - Setting MessageADirty to false." | Out-File -FilePath $Script:LogFileName -Append
            $this.MessageADirty = $false
        }

        "MessageWindow::Draw - Checking to see if MessageBDirty is true." | Out-File -FilePath $Script:LogFileName -Append
        If($this.MessageBDirty -EQ $true) {
            "MessageWindow::Draw - MessageBDirty is true, redrawing Message B to the window at its predefined coordinates (blank first, then string)." | Out-File -FilePath $Script:LogFileName -Append
            [MessageWindow]::MessageWindowBlank.Prefix.Coordinates = $this.MessageHistory[[MessageWindow]::MessageHistoryBRef].Prefix.Coordinates
            Write-Host "$([MessageWindow]::MessageWindowBlank.ToAnsiControlSequenceString())"
            Write-Host "$($this.MessageHistory[[MessageWindow]::MessageHistoryBRef].ToAnsiControlSequenceString())"

            "MessageWindow::Draw - Setting MessageBDirty to false." | Out-File -FilePath $Script:LogFileName -Append
            $this.MessageBDirty = $false
        }

        "MessageWindow::Draw - Checking to see if MessageCDirty is true." | Out-File -FilePath $Script:LogFileName -Append
        If($this.MessageCDirty -EQ $true) {
            "MessageWindow::Draw - MessageCDirty is true, redrawing Message C to the window at its predefined coordinates (blank first, then string)." | Out-File -FilePath $Script:LogFileName -Append
            [MessageWindow]::MessageWindowBlank.Prefix.Coordinates = $this.MessageHistory[[MessageWindow]::MessageHistoryCRef].Prefix.Coordinates
            Write-Host "$([MessageWindow]::MessageWindowBlank.ToAnsiControlSequenceString())"
            Write-Host "$($this.MessageHistory[[MessageWindow]::MessageHistoryCRef].ToAnsiControlSequenceString())"

            "MessageWindow::Draw - Setting MessageCDirty to false." | Out-File -FilePath $Script:LogFileName -Append
            $this.MessageCDirty = $false
        }

        "MessageWindow::Draw - Leaving the Draw method." | Out-File -FilePath $Script:LogFileName -Append
    }

    [Void]WriteMessage([String]$Message, [ATForegroundColor24]$ForegroundColor, [ATDecoration]$Decoration) {
        "MessageWindow::Draw - Entering the WriteMessage method." | Out-File -FilePath $Script:LogFileName -Append
        "MessageWindow::Draw - Parameter Values: Message: ($($Message)), ForegroundColor: ($($ForegroundColor)), and Decoration: ($($Decoration))." | Out-File -FilePath $Script:LogFileName -Append

        "MessageWindow::Draw - Setting Message A UserData, Prefix.Decorations, and Prefix.ForegroundColor to those of Message B." | Out-File -FilePath $Script:LogFileName -Append
        $this.MessageHistory[[MessageWindow]::MessageHistoryARef].UserData               = $this.MessageHistory[[MessageWindow]::MessageHistoryBRef].UserData
        $this.MessageHistory[[MessageWindow]::MessageHistoryARef].Prefix.Decorations     = $this.MessageHistory[[MessageWindow]::MessageHistoryBRef].Prefix.Decorations
        $this.MessageHistory[[MessageWindow]::MessageHistoryARef].Prefix.ForegroundColor = $this.MessageHistory[[MessageWindow]::MessageHistoryBRef].Prefix.ForegroundColor

        "MessageWindow::Draw - Setting Message B UserData, Prefix.Decorations, and Prefix.ForegroundColor to those of Message C." | Out-File -FilePath $Script:LogFileName -Append
        $this.MessageHistory[[MessageWindow]::MessageHistoryBRef].UserData               = $this.MessageHistory[[MessageWindow]::MessageHistoryCRef].UserData
        $this.MessageHistory[[MessageWindow]::MessageHistoryBRef].Prefix.Decorations     = $this.MessageHistory[[MessageWindow]::MessageHistoryCRef].Prefix.Decorations
        $this.MessageHistory[[MessageWindow]::MessageHistoryBRef].Prefix.ForegroundColor = $this.MessageHistory[[MessageWindow]::MessageHistoryCRef].Prefix.ForegroundColor
        
        "MessageWindow::Draw - Setting Message C UserData, Prefix.Decorations, and Prefix.ForegroundColor to those of the parameters passed to this method." | Out-File -FilePath $Script:LogFileName -Append
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

        "MessageWindow::Draw - Settings the Message Dirty Flags to true to force redraws." | Out-File -FilePath $Script:LogFileName -Append
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

        "MessageWindow::Draw - Leaving the WriteMessage method." | Out-File -FilePath $Script:LogFileName -Append
    }

    [Void]WriteBadCommandMessage([String]$Command) {
        $this.WriteMessage(
            "$($Command) isn't a valid command.",
            [CCAppleRedDark24]::new(),
            [ATDecoration]::new($true)
        )
    }

    [Void]WriteBadArg0Message([String]$Command, [String]$Arg0) {
        $this.WriteMessage(
            "We can't $($Command) with a(n) $($Arg0).",
            [CCAppleYellowDark24]::new(),
            [ATDecorationNone]::new()
        )
    }

    [Void]WriteBadArg1Message([String]$Command, [String]$Arg0, [String]$Arg1) {
        $this.WriteMessage(
            "We can't $($Command) with a(n) $(Arg0) and a(n) $($Arg1).",
            [CCAppleYellowDark24]::new(),
            [ATDecorationNone]::new()
        )
    }

    [Void]WriteSomethingBadMessage() {
        $this.WriteMessage(
            'I''m God, and even I don''t know what just happened...',
            [CCAppleIndigoDark24]::new(),
            [ATDecorationNone]::new()
        )
    }

    [Void]WriteInvisibleWallEncounteredMessage() {
        $this.WriteMessage(
            'The invisible wall blocks your path...',
            [CCAppleIndigoDark24]::new(),
            [ATDecorationNone]::new()
        )
    }

    [Void]WriteYouShallNotPassMessage() {
        $this.WriteMessage(
            'The path you asked for is impossible...',
            [CCAppleIndigoDark24]::new(),
            [ATDecorationNone]::new()
        )
    }

    [Void]WriteMapNoItemsFoundMessage() {
        $this.WriteMessage(
            'There''s nothing of interest here.',
            [CCAppleIndigoDark24]::new(),
            [ATDecorationNone]::new()
        )
    }

    [Void]WriteMapInvalidItemMessage([String]$ItemName) {
        $this.WriteMessage(
            "There's no $($ItemName) here.",
            [CCAppleIndigoDark24]::new(),
            [ATDecorationNone]::new()
        )
    }

    [Void]WriteItemTakenMessage([String]$ItemName) {
        $this.WriteMessage(
            "I've taken the $($ItemName) and put it in my pocket.",
            [CCAppleIndigoDark24]::new(),
            [ATDecorationNone]::new()
        )
    }

    [Void]WriteItemCantTakeMessage(
        [String]$ItemName
    ) {
        $this.WriteMessage(
            "It's not possible to take the $($ItemName).",
            [CCAppleIndigoDark24]::new(),
            [ATDecorationNone]::new()
        )
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

        $this.PageRefs = [List[MapTileObject]]::new()

        $this.CreateIChevrons()
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()

        If($this.BookDirty -EQ $true) {
            $this.CalculateNumPages()
            $this.BookDirty = $false
        }

        If($this.CurrentPageDirty -EQ $true) {
            $this.PopulatePage()
        }

        If($this.ZeroPageActive -EQ $true) {
            If($this.MoronPageActive -EQ $true) {
                $this.WriteMoronPage()
            } Else {
                $this.WriteZeroInventoryPage()
            }
        } Else {
            If($this.DivLineDirty -EQ $true) {
                Write-Host "$([InventoryWindow]::DivLineHorizontal.ToAnsiControlSequenceString())"
                $this.DivLineDirty = $false
            }

            If($this.PlayerChevronVisible -EQ $true -AND $this.PlayerChevronDirty -EQ $true) {
                Foreach($ic in $this.IChevrons) {
                    Write-Host "$($ic.Item1.ToAnsiControlSequenceString())"
                }
                $this.PlayerChevronDirty = $false
            }

            If($this.NumPages -GT 1) {
                If($this.CurrentPage -EQ 1) {
                    If($this.PagingChevronLeftVisible -EQ $true) {
                        Write-Host "$([InventoryWindow]::PagingChevronLeftBlank.ToAnsiControlSequenceString())"
                        $this.PagingChevronLeftVisible = $false
                        $this.PagingChevronLeftDirty = $true
                    }
                    If($this.PagingChevronRightVisible -EQ $false) {
                        $this.PagingChevronRightVisible = $true
                    }
                    If($this.PagingChevronRightVisible -EQ $true -AND $this.PagingChevronRightDirty -EQ $true) {
                        Write-Host "$([InventoryWindow]::PagingChevronRight.ToAnsiControlSequenceString())"
                        $this.PagingChevronRightDirty = $false
                    }
                } Elseif($this.CurrentPage -GT 1 -AND $this.CurrentPage -LT $this.NumPages) {
                    If($this.PagingChevronLeftVisible -EQ $false) {
                        $this.PagingChevronLeftVisible = $true
                    }
                    If($this.PagingChevronRightVisible -EQ $false) {
                        $this.PagingChevronRightVisible = $true
                    }
                    If($this.PagingChevronRightVisible -EQ $true -AND $this.PagingChevronRightDirty -EQ $true) {
                        Write-Host "$([InventoryWindow]::PagingChevronRight.ToAnsiControlSequenceString())"
                        $this.PagingChevronRightDirty = $false
                    }
                    If($this.PagingChevronLeftVisible -EQ $true -AND $this.PagingChevronLeftDirty -EQ $true) {
                        Write-Host "$([InventoryWindow]::PagingChevronLeft.ToAnsiControlSequenceString())"
                        $this.PagingChevronLeftDirty = $false
                    }
                } Elseif($this.CurrentPage -GE $this.NumPages) {
                    If($this.PagingChevronRightVisible -EQ $true) {
                        Write-Host "$([InventoryWindow]::PagingChevronRightBlank.ToAnsiControlSequenceString())"
                        $this.PagingChevronRightVisible = $false
                        $this.PagingChevronRightDirty = $true
                    }
                    If($this.PagingChevronLeftVisible -EQ $false) {
                        $this.PagingChevronLeftVisible = $true
                    }
                    If($this.PagingChevronLeftVisible -EQ $true -AND $this.PagingChevronLeftDirty -EQ $true) {
                        Write-Host "$([InventoryWindow]::PagingChevronLeft.ToAnsiControlSequenceString())"
                        $this.PagingChevronLeftDirty = $false
                    }
                }
            }

            # Try to make the "active" Item Label blink
            If($this.ActiveItemBlinking -EQ $false) {
                $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]::new($true)
                $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()

                $this.ItemsListDirty     = $true
                $this.ActiveItemBlinking = $true
            }

            If($this.ItemsListDirty -EQ $true) {
                $this.WriteItemLabels()
                Write-Host "$([ATControlSequences]::CursorHide)"
                $this.ItemsListDirty = $false
            }

            If($this.ItemDescDirty -EQ $true) {
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

                Write-Host "$($b.ToAnsiControlSequenceString())"
                Write-Host "$($d.ToAnsiControlSequenceString())"
            }
        }
    }

    [Void]CreateIChevrons() {
        $this.IChevrons = [List[ValueTuple[[ATString], [Boolean]]]]::new()
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
    }

    [Void]CreateItemLabels() {
        $this.ItemLabels = [List[ATString]]::new()
        [Int]$c          = 0
        
        Foreach($i in $this.PageRefs) {
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

        $this.ResetIChevronPosition()
        $this.CreateItemLabelBlanks()
    }

    [Void]CreateItemLabelBlanks() {
        $this.ItemLabelBlanks = [List[ATString]]::new()
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
    }

    [Void]CalculateNumPages() {
        $pp = $Script:ThePlayer.Inventory.Count / $this.ItemsPerPage
        If($pp -LT 1) {
            $this.NumPages = 1
        } Else {
            $this.NumPages = [Math]::Ceiling($pp)
        }
    }

    [Void]TurnPageForward() {
        If(($this.CurrentPage + 1) -LE $this.NumPages) {
            $this.CurrentPage++
            $this.CurrentPageDirty   = $true
            $this.ActiveItemBlinking = $false
            $this.ItemDescDirty      = $true
        }
    }

    [Void]TurnPageBackward() {
        If(($this.CurrentPage - 1) -GE 1) {
            $this.CurrentPage--
            $this.CurrentPageDirty   = $true
            $this.ActiveItemBlinking = $false
            $this.ItemDescDirty      = $true
        }
    }

    [Void]PopulatePage() {
        If($Script:ThePlayer.Inventory.Count -LE 0) {
            $this.ZeroPageActive   = $true
            $this.CurrentPageDirty = $false
            
            If([InventoryWindow]::MoronCounter -LT 20) {
                [InventoryWindow]::MoronCounter++
            } Else {
                $this.MoronPageActive = $true
            }
        } Else {
            $this.PageRefs        = [List[MapTileObject]]::new()
            $this.ZeroPageActive  = $false
            $this.MoronPageActive = $false
            $rs                   = (($this.CurrentPage * $this.ItemsPerPage) - $this.ItemsPerPage) - 1
            $rs                   = [Math]::Clamp($rs, 0, [Int]::MaxValue)
            $re                   = 10
            #$re                   = $this.CurrentPage * $this.ItemsPerPage

            Try {
                $this.PageRefs = $Script:ThePlayer.Inventory.GetRange($rs, $re)
            } Catch {
                $this.PageRefs = $Script:ThePlayer.Inventory.GetRange($rs, ($Script:ThePlayer.Inventory.Count - $rs))
            }

            $this.CreateItemLabels()

            # $this.ResetIChevronPosition()

            $this.ItemsListDirty   = $true
            $this.CurrentPageDirty = $false
        }
    }

    [Void]WriteItemLabels() {
        Foreach($i in $this.ItemLabelBlanks) {
            Write-Host "$($i.ToAnsiControlSequenceString())"
        }
        Foreach($i in $this.ItemLabels) {
            Write-Host "$($i.ToAnsiControlSequenceString())"
        }
    }

    [ATString]GetActiveIChevron() {
        $this.ActiveIChevronIndex = 0

        Foreach($a in $this.IChevrons) {
            If($a.Item2 -EQ $true) {
                Return $a.Item1
            }
            $this.ActiveIChevronIndex++
        }

        $this.ActiveIChevronIndex = 0
        $this.IChevrons[$this.ActiveIChevronIndex].Item2 = $true
        Return $this.IChevrons[$this.ActiveIChevronIndex].Item1
    }

    [Void]WriteZeroInventoryPage() {
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
    }

    [Void]WriteMoronPage() {}

    [Void]ResetIChevronPosition() {
        $this.IChevrons[$this.ActiveIChevronIndex].Item2          = $false
        $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData = [InventoryWindow]::IChevronBlankCharacter
        
        # This seems to be the only way to deal with this reliably since the ActiveIChevronIndex can't be
        # reset to zero yet.
        Try {
            $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecorationNone]::new()
            $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCTextDefault24]::new()
        } Catch {
        }
        
        $this.ActiveIChevronIndex                                          = 0
        $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $true
        $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [InventoryWindow]::IChevronCharacter
        $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]::new($true)
        $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()
        
        $this.PlayerChevronDirty = $true
        $this.ActiveItemBlinking = $false
        $this.ItemDescDirty      = $true
    }

    [Void]HandleInput() {
        $keyCap = $(Get-Host).UI.RawUI.ReadKey('IncludeKeyDown, NoEcho')
        Switch($keyCap.VirtualKeyCode) {
            27 {
                $Script:ThePreviousGlobalGameState = $Script:TheGlobalGameState
                $Script:TheGlobalGameState         = [GameStatePrimary]::GamePlayScreen
            }

            38 {
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

            40 {
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

            39 {
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

            37 {
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

            68 {
                $this.TurnPageForward()
            }

            65 {
                $this.TurnPageBackward()
            }
        }
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
        Write-Progress -Activity 'Creating ''global'' variables' -Id 1 -Status 'Creating the Game Core' -PercentComplete -1
        "GameCore::Constructor - Starting the constructor." | Out-File -FilePath $Script:LogFileName -Append
        "GameCore::Constructor - Setting up variables." | Out-File -FilePath $Script:LogFileName -Append
        
        $this.TargetFrameRate      = 30
        $this.MsPerFrame           = 1000 / $this.TargetFrameRate
        $this.GameRunning          = $true
        $this.LastFrameTime        = 0D
        $this.CurrentFrameTime     = 0D
        $this.FpsDelta             = [TimeSpan]::Zero
        $Script:TheGlobalGameState = [GameStatePrimary]::GamePlayScreen
        
        "GameCore::Constructor - Leaving the constructor." | Out-File -FilePath $Script:LogFileName -Append
    }

    [Void]Run() {
        "GameCore::Run - Starting the Run method." | Out-File -FilePath $Script:LogFileName -Append
        "GameCore::Run - Checking to see if the GameRunning flag is true or not." | Out-File -FilePath $Script:LogFileName -Append

        While($this.GameRunning -EQ $true) {
            "GameCore::Run - GameRunning is true." | Out-File -FilePath $Script:LogFileName -Append
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
    }

    [Void]Logic() {
        "GameCore::Logic - Starting the Logic method." | Out-File -FilePath $Script:LogFileName -Append
        "GameCore::Logic - Invoking the ScriptBlock for the game state $($Script:TheGlobalGameState)" | Out-File -FilePath $Script:LogFileName -Append
        Invoke-Command $Script:TheGlobalStateBlockTable[$Script:TheGlobalGameState]
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

Read-Host
