using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEJADEANKLET
#
###############################################################################

Class BEJadeAnklet : BEJewelry {
	BEJadeAnklet() : base() {
		$this.Name               = 'Jade Anklet'
		$this.MapObjName         = 'jadeanklet'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 1
			[StatId]::Speed = 1
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A serene jade anklet, promoting calm and focus.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD  +$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Female
	}
}
