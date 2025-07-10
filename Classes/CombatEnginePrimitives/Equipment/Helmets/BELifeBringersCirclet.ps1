using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELIFEBRINGERSCIRCLET
#
###############################################################################

Class BELifeBringersCirclet : BEHelmet {
	BELifeBringersCirclet() : base() {
		$this.Name               = 'Life Bringer''s Circlet'
		$this.MapObjName         = 'lifebringerscirclet'
		$this.PurchasePrice      = 11500
		$this.SellPrice          = 5750
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 98
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A circlet that radiates life energy, healing all around the wearer.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
