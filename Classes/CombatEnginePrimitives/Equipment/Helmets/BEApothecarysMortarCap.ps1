using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAPOTHECARYSMORTARCAP
#
###############################################################################

Class BEApothecarysMortarCap : BEHelmet {
	BEApothecarysMortarCap() : base() {
		$this.Name               = 'Apothecary''s Mortar Cap'
		$this.MapObjName         = 'apothecarysmortarcap'
		$this.PurchasePrice      = 130
		$this.SellPrice          = 65
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cap worn by apothecaries, aiding in the creation of potent concoctions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
