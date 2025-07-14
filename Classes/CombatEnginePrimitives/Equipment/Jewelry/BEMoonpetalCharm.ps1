using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMOONPETALCHARM
#
###############################################################################

Class BEMoonpetalCharm : BEJewelry {
	BEMoonpetalCharm() : base() {
		$this.Name               = 'Moonpetal Charm'
		$this.MapObjName         = 'moonpetalcharm'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm made from a petal bathed in moonlight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
