using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESIRENSGLOVES
#
###############################################################################

Class BESirensGloves : BEGauntlets {
	BESirensGloves() : base() {
		$this.Name               = 'Siren''s Gloves'
		$this.MapObjName         = 'sirensgloves'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves with a captivating aura, charming adversaries.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
