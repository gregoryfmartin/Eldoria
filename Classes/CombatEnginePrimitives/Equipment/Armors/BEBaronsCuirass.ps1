using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBARONSCUIRASS
#
###############################################################################

Class BEBaronsCuirass : BEArmor {
	BEBaronsCuirass() : base() {
		$this.Name               = 'Baron''s Cuirass'
		$this.MapObjName         = 'baronscuirass'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A fancy cuirass, symbolizing minor nobility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
