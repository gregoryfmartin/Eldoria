using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMINSTRELSCAP
#
###############################################################################

Class BEMinstrelsCap : BEHelmet {
	BEMinstrelsCap() : base() {
		$this.Name               = 'Minstrel''s Cap'
		$this.MapObjName         = 'minstrelscap'
		$this.PurchasePrice      = 40
		$this.SellPrice          = 20
		$this.TargetStats        = @{
			[StatId]::Defense = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A whimsical cap worn by minstrels, adding charm to their performances.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
