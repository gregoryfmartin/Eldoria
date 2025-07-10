using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGOLDENCUIRASS
#
###############################################################################

Class BEGoldenCuirass : BEArmor {
	BEGoldenCuirass() : base() {
		$this.Name               = 'Golden Cuirass'
		$this.MapObjName         = 'goldencuirass'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A polished gold-plated cuirass, more for show than defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
