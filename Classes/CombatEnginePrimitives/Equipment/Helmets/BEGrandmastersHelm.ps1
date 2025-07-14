using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGRANDMASTERSHELM
#
###############################################################################

Class BEGrandmastersHelm : BEHelmet {
	BEGrandmastersHelm() : base() {
		$this.Name               = 'Grandmaster''s Helm'
		$this.MapObjName         = 'grandmastershelm'
		$this.PurchasePrice      = 2800
		$this.SellPrice          = 1400
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A legendary helm worn by grandmasters of a martial art or order.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
