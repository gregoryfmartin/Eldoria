using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEMERALDCIRCLET
#
###############################################################################

Class BEEmeraldCirclet : BEHelmet {
	BEEmeraldCirclet() : base() {
		$this.Name               = 'Emerald Circlet'
		$this.MapObjName         = 'emeraldcirclet'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A circlet with a gleaming emerald, boosting nature-based magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
