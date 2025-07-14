using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAMETHYSTHELM
#
###############################################################################

Class BEAmethystHelm : BEHelmet {
	BEAmethystHelm() : base() {
		$this.Name               = 'Amethyst Helm'
		$this.MapObjName         = 'amethysthelm'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm with an amethyst, enhancing mental clarity and resistance to mind-control.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
