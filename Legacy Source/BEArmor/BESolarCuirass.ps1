using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESOLARCUIRASS
#
###############################################################################

Class BESolarCuirass : BEArmor {
	BESolarCuirass() : base() {
		$this.Name               = 'Solar Cuirass'
		$this.MapObjName         = 'solarcuirass'
		$this.PurchasePrice      = 920
		$this.SellPrice          = 460
		$this.TargetStats        = @{
			[StatId]::Defense = 17
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass that radiates a gentle warmth, offering minor fire resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
