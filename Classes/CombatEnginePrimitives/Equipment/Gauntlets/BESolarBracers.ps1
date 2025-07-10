using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESOLARBRACERS
#
###############################################################################

Class BESolarBracers : BEGauntlets {
	BESolarBracers() : base() {
		$this.Name               = 'Solar Bracers'
		$this.MapObjName         = 'solarbracers'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 19
			[StatId]::MagicDefense = 26
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Bracers that pulse with sun''s energy, healing allies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
