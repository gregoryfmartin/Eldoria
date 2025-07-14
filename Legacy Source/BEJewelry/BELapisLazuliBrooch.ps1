using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELAPISLAZULIBROOCH
#
###############################################################################

Class BELapisLazuliBrooch : BEJewelry {
	BELapisLazuliBrooch() : base() {
		$this.Name               = 'Lapis Lazuli Brooch'
		$this.MapObjName         = 'lapislazulibrooch'
		$this.PurchasePrice      = 460
		$this.SellPrice          = 230
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A deep blue lapis lazuli brooch, for inner peace.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
