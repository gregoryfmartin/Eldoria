using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEENIGMAROBE
#
###############################################################################

Class BEEnigmaRobe : BEArmor {
	BEEnigmaRobe() : base() {
		$this.Name               = 'Enigma Robe'
		$this.MapObjName         = 'enigmarobe'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 37
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that constantly changes its magical properties.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
