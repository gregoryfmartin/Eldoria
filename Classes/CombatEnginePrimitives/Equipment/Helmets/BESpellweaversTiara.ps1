using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE SPELLWEAVERS TIARA
#
###############################################################################

Class BESpellweaversTiara : BEHelmet {
	BESpellweaversTiara() : base() {
		$this.Name               = 'Spellweaver''s Tiara'
		$this.MapObjName         = 'spellweaverstiara'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sparkling tiara that amplifies the power of complex spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
