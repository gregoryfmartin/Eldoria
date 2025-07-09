using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE OBSIDIAN HELM
#
###############################################################################

Class BEObsidianHelm : BEHelmet {
	BEObsidianHelm() : base() {
		$this.Name               = 'Obsidian Helm'
		$this.MapObjName         = 'obsidianhelm'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm carved from dark obsidian, absorbing magical attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
