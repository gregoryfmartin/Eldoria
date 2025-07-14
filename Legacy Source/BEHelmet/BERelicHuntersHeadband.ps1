using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERELICHUNTERSHEADBAND
#
###############################################################################

Class BERelicHuntersHeadband : BEHelmet {
	BERelicHuntersHeadband() : base() {
		$this.Name               = 'Relic Hunter''s Headband'
		$this.MapObjName         = 'relichuntersheadband'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A headband that subtly hums when near ancient relics.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
