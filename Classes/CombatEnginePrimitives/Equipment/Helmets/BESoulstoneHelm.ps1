using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE SOULSTONE HELM
#
###############################################################################

Class BESoulstoneHelm : BEHelmet {
	BESoulstoneHelm() : base() {
		$this.Name               = 'Soulstone Helm'
		$this.MapObjName         = 'soulstonehelm'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm with an embedded soulstone, capable of absorbing stray souls for power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
