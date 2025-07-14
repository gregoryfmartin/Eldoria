using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEKNOWLEDGEGREAVES
#
###############################################################################

Class BEKnowledgeGreaves : BEGreaves {
	BEKnowledgeGreaves() : base() {
		$this.Name               = 'Knowledge Greaves'
		$this.MapObjName         = 'knowledgegreaves'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves that hold vast information.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
