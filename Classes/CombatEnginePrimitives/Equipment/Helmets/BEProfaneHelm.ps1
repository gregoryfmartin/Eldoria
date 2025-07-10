using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPROFANEHELM
#
###############################################################################

Class BEProfaneHelm : BEHelmet {
	BEProfaneHelm() : base() {
		$this.Name               = 'Profane Helm'
		$this.MapObjName         = 'profanehelm'
		$this.PurchasePrice      = 2600
		$this.SellPrice          = 1300
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm cursed by dark powers, granting immense destructive capabilities.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
