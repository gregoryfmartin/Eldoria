using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEORICHALCUMCIRCLET
#
###############################################################################

Class BEOrichalcumCirclet : BEHelmet {
	BEOrichalcumCirclet() : base() {
		$this.Name               = 'Orichalcum Circlet'
		$this.MapObjName         = 'orichalcumcirclet'
		$this.PurchasePrice      = 4200
		$this.SellPrice          = 2100
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A legendary circlet made from orichalcum, amplifying all magical abilities.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
