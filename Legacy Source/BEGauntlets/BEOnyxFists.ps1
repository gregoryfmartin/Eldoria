using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEONYXFISTS
#
###############################################################################

Class BEOnyxFists : BEGauntlets {
	BEOnyxFists() : base() {
		$this.Name               = 'Onyx Fists'
		$this.MapObjName         = 'onyxfists'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 60
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets crafted from dark onyx, absorbing negative energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
