using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEADAMANTINEPAULDRON
#
###############################################################################

Class BEAdamantinePauldron : BEPauldron {
	BEAdamantinePauldron() : base() {
		$this.Name               = 'Adamantine Pauldron'
		$this.MapObjName         = 'adamantinepauldron'
		$this.PurchasePrice      = 6400
		$this.SellPrice          = 3200
		$this.TargetStats        = @{
			[StatId]::Defense = 128
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'One of the strongest materials known, virtually indestructible.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
