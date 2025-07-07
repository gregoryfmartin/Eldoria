using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BRONZE SPEAR
#
###############################################################################

Class BEBronzeSpear : BEWeapon {
	BEBronzeSpear() : base() {
		$this.Name          = 'Bronze Spear'
		$this.MapObjName    = 'bronzespear'
		$this.PurchasePrice = 130
		$this.SellPrice     = 65
		$this.TargetStats   = @{
			[StatId]::Attack = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A spear with a bronze tip, offering good reach.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
