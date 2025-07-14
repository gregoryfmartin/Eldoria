using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESHOCKINGHELM
#
###############################################################################

Class BEShockingHelm : BEHelmet {
	BEShockingHelm() : base() {
		$this.Name               = 'Shocking Helm'
		$this.MapObjName         = 'shockinghelm'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm crackling with electricity, paralyzing foes with lightning.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
