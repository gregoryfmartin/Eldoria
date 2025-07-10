using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGRAVECALLERGAUNTLETS
#
###############################################################################

Class BEGravecallerGauntlets : BEGauntlets {
	BEGravecallerGauntlets() : base() {
		$this.Name               = 'Gravecaller Gauntlets'
		$this.MapObjName         = 'gravecallergauntlets'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that hum with the whispers of the deceased, aiding necromancy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
