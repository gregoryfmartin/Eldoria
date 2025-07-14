using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVALKYRIESVAMBRACES
#
###############################################################################

Class BEValkyriesVambraces : BEGauntlets {
	BEValkyriesVambraces() : base() {
		$this.Name               = 'Valkyrie''s Vambraces'
		$this.MapObjName         = 'valkyriesvambraces'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 68
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Vambraces adorned with wings, lighter than air yet strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
