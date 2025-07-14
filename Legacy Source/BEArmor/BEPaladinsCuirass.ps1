using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPALADINSCUIRASS
#
###############################################################################

Class BEPaladinsCuirass : BEArmor {
	BEPaladinsCuirass() : base() {
		$this.Name               = 'Paladin''s Cuirass'
		$this.MapObjName         = 'paladinscuirass'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A blessed cuirass, offering both defense and spiritual resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
