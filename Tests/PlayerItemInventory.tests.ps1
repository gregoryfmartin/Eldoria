Describe 'PlayerItemInventory' {
    BeforeAll {
        . $PSScriptRoot\..\Enums\ItemRemovalStatus.ps1
        . $PSScriptRoot\..\Classes\Mapping\MapTileObject.ps1
        . $PSScriptRoot\..\Classes\Mapping\MapTileObjects\MTOApple.ps1
        . $PSScriptRoot\..\Classes\Mapping\MapTileObjects\MTORock.ps1
        . $PSScriptRoot\..\Classes\CombatEnginePrimitives\PlayerItemInventory.ps1
    }

    BeforeEach {
        $SampleInventory = [PlayerItemInventory]::new()
    }

    Context 'Initialization' {
        It 'Should create an empty inventory' {
            $SampleInventory.Count | Should -Be 0
        }
    }

    Context 'Item Management' {
        BeforeEach {
            [MTOApple]$Apple = [MTOApple]::new()
            [MTORock]$Rock = [MTORock]::new()
        }

        AfterEach {
            $SampleInventory.Clear()
        }

        It 'Should add item successfully' {
            $SampleInventory.AddItem($Apple, 10)
            $SampleInventory.Count | Should -Be 1
            $SampleInventory[0].Item1.Name | Should -Be 'Apple'
        }

        It 'Should cap item adds greater than 99 at 99' {
            $SampleInventory.AddItem($Apple, 100)
            $SampleInventory.GetItemQuantity($Apple) | Should -Be 99
        }

        It 'Should cap quantities of items if the add results in greater than 99' {
            $SampleInventory.AddItem($Apple, 98)
            $SampleInventory.AddItem($Apple, 10)
            $SampleInventory.GetItemQuantity($Apple) | Should -Be 99
        }

        It 'Should remove item completely' {
            $SampleInventory.AddItem($Apple, 10)
            $SampleInventory.RemoveItem($Apple, 10)
            $SampleInventory.Count | Should -Be 0
        }

        It 'Should remove only the specified quantity' {
            $SampleInventory.AddItem($Apple, 10)
            $SampleInventory.RemoveItem($Apple, 5)

            $SampleInventory.HasItem($Apple) | Should -Be $true
            $SampleInventory.GetItemQuantity($Apple) | Should -Be 5
        }

        It 'Should check if item exists' {
            $SampleInventory.AddItem($Rock, 10)
            $SampleInventory.HasItem($Rock) | Should -Be $true
            $SampleInventory.HasItem($Apple) | Should -Be $false
        }
    }

    Context 'Inventory Operations' {
        BeforeEach {
            [MTOApple]$Apple = [MTOApple]::new()
            [MTORock]$Rock = [MTORock]::new()
        }

        AfterEach {
            $SampleInventory.Clear()
        }

        It 'Should sort items by name' {
            $SampleInventory.AddItem($Rock, 10)
            $SampleInventory.AddItem($Apple, 10)
            $SampleInventory.Sort()

            $SampleInventory[0].Item1.MapObjName | Should -Be 'apple'
        }
    }
}