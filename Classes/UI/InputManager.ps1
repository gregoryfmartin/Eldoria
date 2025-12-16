using namespace System

Set-StrictMode -Version Latest


Class InputManager {
    InputManager() {}
    
    [Void]HandleInput() {
        # THE BEHAVIOR OF THIS METHOD WILL HAVE TO CHANGE BASED ON THE CURRENT STATE
        # OF THE GAME. FOR RIGHT NOW, ALL I CARE ABOUT IS THAT THE GPS LOGIC IS
        # HANDLED.
        Switch($Script:TheGlobalGameState) {
            ([GameStatePrimary]::GamePlayScreen) {
                If([Console]::KeyAvailable -EQ $true) {
                    [ConsoleKeyInfo]$PressedKey = [Console]::ReadKey($true)
                    Switch($PressedKey.Key) {
                        ([ConsoleKey]::RightArrow) {
                            Invoke-Command $Script:TheMoveCommand -ArgumentList 'East'
                            $Script:GpsDrawnAlready = $false
                            
                            Break
                        }
                        
                        ([ConsoleKey]::LeftArrow) {
                            Invoke-Command $Script:TheMoveCommand -ArgumentList 'West'
                            $Script:GpsDrawnAlready = $false
                            
                            Break
                        }
                        
                        ([ConsoleKey]::UpArrow) {
                            Invoke-Command $Script:TheMoveCommand -ArgumentList 'North'
                            $Script:GpsDrawnAlready = $false
                            
                            Break
                        }
                        
                        ([ConsoleKey]::DownArrow) {
                            Invoke-Command $Script:TheMoveCommand -ArgumentList 'South'
                            $Script:GpsDrawnAlready = $false
                            
                            Break
                        }
                        
                        ([ConsoleKey]::A) {
                            Invoke-Command $Script:TheStatusCommand
                            $Script:GpsDrawnAlready = $false
                            
                            Break
                        }
                        
                        ([ConsoleKey]::S) {
                            Invoke-Command $Script:TheLookCommand
                            $Script:GpsDrawnAlready = $false
                            
                            Break
                        }
                        
                        ([ConsoleKey]::D) {
                            Break
                        }
                        
                        ([ConsoleKey]::F) {
                            Break
                        }
                        
                        ([ConsoleKey]::V) {
                            Break
                        }
                        
                        ([ConsoleKey]::G) {
                            Invoke-Command $Script:TheEnterCommand
                            $Script:GpsDrawnAlready = $false
                            
                            Break
                        }
                    
                        Default {
                            Break
                        }
                    }
                }
            
                Break
            }
            
            Default {
                Break
            }
        }
    }
}
