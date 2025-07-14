using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENIRVANAHELM
#
###############################################################################

Class BENirvanaHelm : BEHelmet {
	BENirvanaHelm() : base() {
		$this.Name               = 'Nirvana Helm'
		$this.MapObjName         = 'nirvanahelm'
		$this.PurchasePrice      = 3000
		$this.SellPrice          = 1500
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that grants the wearer a state of ultimate peace and detachment.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
