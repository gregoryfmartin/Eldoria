using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEKNIGHTBOOTS
#
###############################################################################

Class BEKnightBoots : BEBoots {
	BEKnightBoots() : base() {
		$this.Name               = 'Knight Boots'
		$this.MapObjName         = 'knightboots'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 27
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots fit for a noble knight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
