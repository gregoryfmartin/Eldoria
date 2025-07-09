using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE ETHERIUM HELM
#
###############################################################################

Class BEEtheriumHelm : BEHelmet {
	BEEtheriumHelm() : base() {
		$this.Name               = 'Etherium Helm'
		$this.MapObjName         = 'etheriumhelm'
		$this.PurchasePrice      = 4000
		$this.SellPrice          = 2000
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm made of ethereal material, granting resistance to magical effects.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
