using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTONETOOTHFISTS
#
###############################################################################

Class BEStonetoothFists : BEGauntlets {
	BEStonetoothFists() : base() {
		$this.Name               = 'Stonetooth Fists'
		$this.MapObjName         = 'stonetoothfists'
		$this.PurchasePrice      = 480
		$this.SellPrice          = 240
		$this.TargetStats        = @{
			[StatId]::Defense = 24
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets with jagged, stone-like knuckles.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
