using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEREAPERSGRASP
#
###############################################################################

Class BEReapersGrasp : BEGauntlets {
	BEReapersGrasp() : base() {
		$this.Name               = 'Reaper''s Grasp'
		$this.MapObjName         = 'reapersgrasp'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that chill the soul, wielding spectral power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
