using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEROGUEBOOTS
#
###############################################################################

Class BERogueBoots : BEBoots {
	BERogueBoots() : base() {
		$this.Name               = 'Rogue Boots'
		$this.MapObjName         = 'rogueboots'
		$this.PurchasePrice      = 370
		$this.SellPrice          = 185
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 9
			[StatId]::Speed = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for cunning and agile adventurers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
