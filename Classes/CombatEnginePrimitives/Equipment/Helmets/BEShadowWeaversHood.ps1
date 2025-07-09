using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE SHADOW WEAVERS HOOD
#
###############################################################################

Class BEShadowWeaversHood : BEHelmet {
	BEShadowWeaversHood() : base() {
		$this.Name               = 'Shadow Weaver''s Hood'
		$this.MapObjName         = 'shadowweavershood'
		$this.PurchasePrice      = 1450
		$this.SellPrice          = 725
		$this.TargetStats        = @{
			[StatId]::Defense = 6
			[StatId]::MagicDefense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark hood that allows the wearer to manipulate shadows.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
