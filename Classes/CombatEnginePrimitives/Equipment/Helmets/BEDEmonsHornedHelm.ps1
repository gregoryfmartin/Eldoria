using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDEMONSHORNEDHELM
#
###############################################################################

Class BEDemonsHornedHelm : BEHelmet {
	BEDemonsHornedHelm() : base() {
		$this.Name               = 'Demon''s Horned Helm'
		$this.MapObjName         = 'demonshornedhelm'
		$this.PurchasePrice      = 2800
		$this.SellPrice          = 1400
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark, horned helm imbued with demonic power, granting destructive capabilities.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
