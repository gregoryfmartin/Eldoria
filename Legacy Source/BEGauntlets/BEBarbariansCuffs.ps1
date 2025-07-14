using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBARBARIANSCUFFS
#
###############################################################################

Class BEBarbariansCuffs : BEGauntlets {
	BEBarbariansCuffs() : base() {
		$this.Name               = 'Barbarian''s Cuffs'
		$this.MapObjName         = 'barbarianscuffs'
		$this.PurchasePrice      = 160
		$this.SellPrice          = 80
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Rough, leather cuffs for a primal warrior.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
