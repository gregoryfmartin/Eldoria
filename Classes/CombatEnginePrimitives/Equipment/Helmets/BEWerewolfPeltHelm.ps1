using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE WEREWOLF PELT HELM
#
###############################################################################

Class BEWerewolfPeltHelm : BEHelmet {
	BEWerewolfPeltHelm() : base() {
		$this.Name               = 'Werewolf Pelt Helm'
		$this.MapObjName         = 'werewolfpelthelm'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rugged helm made from werewolf pelt, granting increased strength under the moon.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
