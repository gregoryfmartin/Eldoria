using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFORENSICGREAVES
#
###############################################################################

Class BEForensicGreaves : BEGreaves {
	BEForensicGreaves() : base() {
		$this.Name               = 'Forensic Greaves'
		$this.MapObjName         = 'forensicgreaves'
		$this.PurchasePrice      = 420
		$this.SellPrice          = 210
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for crime scene analysis.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
