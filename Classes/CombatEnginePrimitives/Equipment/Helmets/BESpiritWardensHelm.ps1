using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE SPIRIT WARDEN'S HELM
#
###############################################################################

Class BESpiritWardensHelm : BEHelmet {
	BESpiritWardensHelm() : base() {
		$this.Name               = 'Spirit Warden''s Helm'
		$this.MapObjName         = 'spiritwardenshelm'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm worn by those who guard spirits, offering protection from malevolent entities.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
