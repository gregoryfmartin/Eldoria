using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVOIDCALLERSCUFFS
#
###############################################################################

Class BEVoidcallersCuffs : BEGauntlets {
	BEVoidcallersCuffs() : base() {
		$this.Name               = 'Voidcaller''s Cuffs'
		$this.MapObjName         = 'voidcallerscuffs'
		$this.PurchasePrice      = 1350
		$this.SellPrice          = 675
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Cuffs that resonate with the void, amplifying dark spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
