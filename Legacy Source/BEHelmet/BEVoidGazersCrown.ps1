using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVOIDGAZERSCROWN
#
###############################################################################

Class BEVoidGazersCrown : BEHelmet {
	BEVoidGazersCrown() : base() {
		$this.Name               = 'Void Gazer''s Crown'
		$this.MapObjName         = 'voidgazerscrown'
		$this.PurchasePrice      = 8000
		$this.SellPrice          = 4000
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 70
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crown that allows deep gazes into the void, granting forbidden knowledge.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
