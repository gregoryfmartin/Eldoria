using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVOIDWALKERHELM
#
###############################################################################

Class BEVoidwalkerHelm : BEHelmet {
	BEVoidwalkerHelm() : base() {
		$this.Name               = 'Voidwalker Helm'
		$this.MapObjName         = 'voidwalkerhelm'
		$this.PurchasePrice      = 5500
		$this.SellPrice          = 2750
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm for those who walk the void, granting protection from its horrors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
