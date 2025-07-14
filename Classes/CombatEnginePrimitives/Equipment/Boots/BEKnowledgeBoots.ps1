using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEKNOWLEDGEBOOTS
#
###############################################################################

Class BEKnowledgeBoots : BEBoots {
	BEKnowledgeBoots() : base() {
		$this.Name               = 'Knowledge Boots'
		$this.MapObjName         = 'knowledgeboots'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 19
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that hold vast information.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
