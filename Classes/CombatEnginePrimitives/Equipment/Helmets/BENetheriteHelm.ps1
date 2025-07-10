using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENETHERITEHELM
#
###############################################################################

Class BENetheriteHelm : BEHelmet {
	BENetheriteHelm() : base() {
		$this.Name               = 'Netherite Helm'
		$this.MapObjName         = 'netheritehelm'
		$this.PurchasePrice      = 4800
		$this.SellPrice          = 2400
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm forged from netherite, resistant to fire and powerful in the nether.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
