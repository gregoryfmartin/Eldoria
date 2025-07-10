using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFORENSICBOOTS
#
###############################################################################

Class BEForensicBoots : BEBoots {
	BEForensicBoots() : base() {
		$this.Name               = 'Forensic Boots'
		$this.MapObjName         = 'forensicboots'
		$this.PurchasePrice      = 390
		$this.SellPrice          = 195
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for crime scene analysis.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
