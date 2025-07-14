using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESERAPHIMSEMBRACE
#
###############################################################################

Class BESeraphimsEmbrace : BEGauntlets {
	BESeraphimsEmbrace() : base() {
		$this.Name               = 'Seraphim''s Embrace'
		$this.MapObjName         = 'seraphimsembrace'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 48
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Feathery gloves that feel like an angelic embrace.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
