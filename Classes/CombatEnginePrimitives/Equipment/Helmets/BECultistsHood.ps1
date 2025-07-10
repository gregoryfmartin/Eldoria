using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECULTISTSHOOD
#
###############################################################################

Class BECultistsHood : BEHelmet {
	BECultistsHood() : base() {
		$this.Name               = 'Cultist''s Hood'
		$this.MapObjName         = 'cultistshood'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sinister hood worn by cultists, aiding in dark rituals.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
