using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETRUTHSEEKERSHELM
#
###############################################################################

Class BETruthSeekersHelm : BEHelmet {
	BETruthSeekersHelm() : base() {
		$this.Name               = 'Truth Seeker''s Helm'
		$this.MapObjName         = 'truthseekershelm'
		$this.PurchasePrice      = 10000
		$this.SellPrice          = 5000
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 90
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that reveals the truth, cutting through illusions and lies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
