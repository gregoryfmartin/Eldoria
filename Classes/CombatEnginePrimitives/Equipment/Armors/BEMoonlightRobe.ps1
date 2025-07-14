using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMOONLIGHTROBE
#
###############################################################################

Class BEMoonlightRobe : BEArmor {
	BEMoonlightRobe() : base() {
		$this.Name               = 'Moonlight Robe'
		$this.MapObjName         = 'moonlightrobe'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 26
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that glows faintly in the dark, enhancing lunar magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
