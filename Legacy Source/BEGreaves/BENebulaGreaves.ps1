using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENEBULAGREAVES
#
###############################################################################

Class BENebulaGreaves : BEGreaves {
	BENebulaGreaves() : base() {
		$this.Name               = 'Nebula Greaves'
		$this.MapObjName         = 'nebulagreaves'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 60
			[StatId]::MagicDefense = 55
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves shimmering with cosmic dust.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
