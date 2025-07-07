using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE LIGHT CROSSBOW
#
###############################################################################

Class BELightCrossbow : BEWeapon {
	BELightCrossbow() : base() {
		$this.Name          = 'Light Crossbow'
		$this.MapObjName    = 'lightcrossbow'
		$this.PurchasePrice = 200
		$this.SellPrice     = 100
		$this.TargetStats   = @{
			[StatId]::Attack = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A compact crossbow, easier to reload than a full-sized one.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
