using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE CRYSTAL BLOOM TIARA
#
###############################################################################

Class BECrystalBloomTiara : BEHelmet {
	BECrystalBloomTiara() : base() {
		$this.Name               = 'Crystal Bloom Tiara'
		$this.MapObjName         = 'crystalbloomtiara'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiara made of blossoming crystals, enhancing natural magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
