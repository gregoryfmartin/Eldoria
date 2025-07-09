using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE AETHERIAL VEIL
#
###############################################################################

Class BEAetherialVeil : BEHelmet {
	BEAetherialVeil() : base() {
		$this.Name               = 'Aetherial Veil'
		$this.MapObjName         = 'aetherialveil'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A translucent veil that grants partial etherealness, making the wearer harder to hit.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
