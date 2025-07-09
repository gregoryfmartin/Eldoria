using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE ELDRITCH VISAGE
#
###############################################################################

Class BEEldritchVisage : BEHelmet {
	BEEldritchVisage() : base() {
		$this.Name               = 'Eldritch Visage'
		$this.MapObjName         = 'eldritchvisage'
		$this.PurchasePrice      = 4500
		$this.SellPrice          = 2250
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm of disturbing appearance, granting maddening powers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
