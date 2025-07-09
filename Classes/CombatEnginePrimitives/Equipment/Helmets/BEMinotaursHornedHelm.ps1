using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE MINOTAUR'S HORNED HELM
#
###############################################################################

Class BEMinotaursHornedHelm : BEHelmet {
	BEMinotaursHornedHelm() : base() {
		$this.Name               = 'Minotaur''s Horned Helm'
		$this.MapObjName         = 'minotaurshornedhelm'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A massive, horned helm that mimics a minotaur''s might.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
