using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEMPERORSCUIRASS
#
###############################################################################

Class BEEmperorsCuirass : BEArmor {
	BEEmperorsCuirass() : base() {
		$this.Name               = 'Emperor''s Cuirass'
		$this.MapObjName         = 'emperorscuirass'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ceremonial cuirass, intricately decorated.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
