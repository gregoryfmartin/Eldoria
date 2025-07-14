using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEADEPTGREAVES
#
###############################################################################

Class BEAdeptGreaves : BEGreaves {
	BEAdeptGreaves() : base() {
		$this.Name               = 'Adept Greaves'
		$this.MapObjName         = 'adeptgreaves'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves worn by skilled practitioners.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
