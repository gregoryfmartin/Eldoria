using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHIVALRYGREAVES
#
###############################################################################

Class BEChivalryGreaves : BEGreaves {
	BEChivalryGreaves() : base() {
		$this.Name               = 'Chivalry Greaves'
		$this.MapObjName         = 'chivalrygreaves'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 48
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves upholding the ideals of knighthood.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
