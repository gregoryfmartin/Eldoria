using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEKNOWLEDGEBRINGERSCROWN
#
###############################################################################

Class BEKnowledgeBringersCrown : BEHelmet {
	BEKnowledgeBringersCrown() : base() {
		$this.Name               = 'Knowledge Bringer''s Crown'
		$this.MapObjName         = 'knowledgebringerscrown'
		$this.PurchasePrice      = 10500
		$this.SellPrice          = 5250
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 95
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crown that bestows immense knowledge upon the wearer.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
