using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE ADAMANT KNUCKLES
#
###############################################################################

Class BEAdamantKnuckles : BEWeapon {
	BEAdamantKnuckles() : base() {
		$this.Name          = 'Adamant Knuckles'
		$this.MapObjName    = 'adamantknuckles'
		$this.PurchasePrice = 920
		$this.SellPrice     = 460
		$this.TargetStats   = @{
			[StatId]::Attack = 56
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Knuckles crafted from the legendary adamant, virtually unbreakable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
