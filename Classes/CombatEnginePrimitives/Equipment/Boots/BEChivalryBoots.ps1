using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHIVALRYBOOTS
#
###############################################################################

Class BEChivalryBoots : BEBoots {
	BEChivalryBoots() : base() {
		$this.Name               = 'Chivalry Boots'
		$this.MapObjName         = 'chivalryboots'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots upholding the ideals of knighthood.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
