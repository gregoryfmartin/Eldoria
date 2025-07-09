using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE GORGON HAIR HELM
#
###############################################################################

Class BEGorgonHairHelm : BEHelmet {
	BEGorgonHairHelm() : base() {
		$this.Name               = 'Gorgon Hair Helm'
		$this.MapObjName         = 'gorgonhairhelm'
		$this.PurchasePrice      = 1650
		$this.SellPrice          = 825
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A chilling helm adorned with gorgon hair, capable of partially paralyzing foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
