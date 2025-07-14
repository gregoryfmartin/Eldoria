using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHEFSTOQUEHELM
#
###############################################################################

Class BEChefsToqueHelm : BEHelmet {
	BEChefsToqueHelm() : base() {
		$this.Name               = 'Chef''s Toque Helm'
		$this.MapObjName         = 'chefstoquehelm'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::Defense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A surprisingly sturdy helm designed for battle-chefs, offering a surprising amount of protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
