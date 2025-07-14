using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPOISONOUSHELM
#
###############################################################################

Class BEPoisonousHelm : BEHelmet {
	BEPoisonousHelm() : base() {
		$this.Name               = 'Poisonous Helm'
		$this.MapObjName         = 'poisonoushelm'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm dripping with venom, poisoning enemies upon contact.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
