using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECRYSTALINEBREASTPLATE
#
###############################################################################

Class BECrystalineBreastplate : BEArmor {
	BECrystalineBreastplate() : base() {
		$this.Name               = 'Crystaline Breastplate'
		$this.MapObjName         = 'crystalinebreastplate'
		$this.PurchasePrice      = 1850
		$this.SellPrice          = 925
		$this.TargetStats        = @{
			[StatId]::Defense = 27
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A breastplate forged from compressed magical crystals, very durable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
