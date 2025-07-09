using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE GRAVE ROBBER'S MASK
#
###############################################################################

Class BEGraveRobbersMask : BEHelmet {
	BEGraveRobbersMask() : base() {
		$this.Name               = 'Grave Robber''s Mask'
		$this.MapObjName         = 'graverobbersmask'
		$this.PurchasePrice      = 160
		$this.SellPrice          = 80
		$this.TargetStats        = @{
			[StatId]::Defense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark mask worn by grave robbers, aiding in stealth in tombs.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
