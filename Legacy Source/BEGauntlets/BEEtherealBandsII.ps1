using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEETHEREALBANDSII
#
###############################################################################

Class BEEtherealBandsII : BEGauntlets {
	BEEtherealBandsII() : base() {
		$this.Name               = 'Ethereal Bands II'
		$this.MapObjName         = 'etherealbandsii'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 60
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More pure Ethereal Bands, granting greater magical prowess.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
