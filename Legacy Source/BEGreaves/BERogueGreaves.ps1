using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEROGUEGREAVES
#
###############################################################################

Class BERogueGreaves : BEGreaves {
	BERogueGreaves() : base() {
		$this.Name               = 'Rogue Greaves'
		$this.MapObjName         = 'roguegreaves'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 10
			[StatId]::Speed = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for cunning and agile adventurers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
