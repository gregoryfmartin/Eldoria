using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVALKYRIESWINGSGLOVES
#
###############################################################################

Class BEValkyriesWingsGloves : BEGauntlets {
	BEValkyriesWingsGloves() : base() {
		$this.Name               = 'Valkyrie''s Wings Gloves'
		$this.MapObjName         = 'valkyrieswingsgloves'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 45
			[StatId]::Accuracy = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves with feather-like lightness, allowing swift movement.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}
