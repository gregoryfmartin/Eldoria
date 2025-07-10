using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMOONSTONEBOOTS
#
###############################################################################

Class BEMoonstoneBoots : BEBoots {
	BEMoonstoneBoots() : base() {
		$this.Name               = 'Moonstone Boots'
		$this.MapObjName         = 'moonstoneboots'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 33
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that glow with lunar power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
