using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWRAITHTOUCHGLOVES
#
###############################################################################

Class BEWraithtouchGloves : BEGauntlets {
	BEWraithtouchGloves() : base() {
		$this.Name               = 'Wraithtouch Gloves'
		$this.MapObjName         = 'wraithtouchgloves'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves that pass through enemies, leaving a chilling effect.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
