using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGALACTICCOREHELM
#
###############################################################################

Class BEGalacticCoreHelm : BEHelmet {
	BEGalacticCoreHelm() : base() {
		$this.Name               = 'Galactic Core Helm'
		$this.MapObjName         = 'galacticcorehelm'
		$this.PurchasePrice      = 5000
		$this.SellPrice          = 2500
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm infused with the power of a galactic core, granting immense cosmic power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
