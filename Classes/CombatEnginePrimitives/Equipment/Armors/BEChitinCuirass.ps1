using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHITINCUIRASS
#
###############################################################################

Class BEChitinCuirass : BEArmor {
	BEChitinCuirass() : base() {
		$this.Name               = 'Chitin Cuirass'
		$this.MapObjName         = 'chitincuirass'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass made from the hard exoskeleton of a giant insect.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
