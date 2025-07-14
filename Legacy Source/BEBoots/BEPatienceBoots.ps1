using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPATIENCEBOOTS
#
###############################################################################

Class BEPatienceBoots : BEBoots {
	BEPatienceBoots() : base() {
		$this.Name               = 'Patience Boots'
		$this.MapObjName         = 'patienceboots'
		$this.PurchasePrice      = 320
		$this.SellPrice          = 160
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that foster endurance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
