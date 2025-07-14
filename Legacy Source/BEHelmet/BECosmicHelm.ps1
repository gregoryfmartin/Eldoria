using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECOSMICHELM
#
###############################################################################

Class BECosmicHelm : BEHelmet {
	BECosmicHelm() : base() {
		$this.Name               = 'Cosmic Helm'
		$this.MapObjName         = 'cosmichelm'
		$this.PurchasePrice      = 9000
		$this.SellPrice          = 4500
		$this.TargetStats        = @{
			[StatId]::Defense = 60
			[StatId]::MagicDefense = 60
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that seems to transcend dimensions, granting omnipotent abilities.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
