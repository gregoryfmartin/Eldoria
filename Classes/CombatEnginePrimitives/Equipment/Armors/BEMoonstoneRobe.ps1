using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMOONSTONEROBE
#
###############################################################################

Class BEMoonstoneRobe : BEArmor {
	BEMoonstoneRobe() : base() {
		$this.Name               = 'Moonstone Robe'
		$this.MapObjName         = 'moonstonerobe'
		$this.PurchasePrice      = 1150
		$this.SellPrice          = 575
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 29
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe adorned with glowing moonstones, boosting lunar magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
