using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESHADOWGUARDHELM
#
###############################################################################

Class BEShadowGuardHelm : BEHelmet {
	BEShadowGuardHelm() : base() {
		$this.Name               = 'Shadow Guard Helm'
		$this.MapObjName         = 'shadowguardhelm'
		$this.PurchasePrice      = 1350
		$this.SellPrice          = 675
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark helm worn by shadow guards, aiding in stealth and ambush.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
