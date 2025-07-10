using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESUCCUBUSBOOTS
#
###############################################################################

Class BESuccubusBoots : BEBoots {
	BESuccubusBoots() : base() {
		$this.Name               = 'Succubus Boots'
		$this.MapObjName         = 'succubusboots'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 29
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a seductive demon.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
