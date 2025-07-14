using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECORALCUIRASS
#
###############################################################################

Class BECoralCuirass : BEArmor {
	BECoralCuirass() : base() {
		$this.Name               = 'Coral Cuirass'
		$this.MapObjName         = 'coralcuirass'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass made from hardened coral, offers water resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
