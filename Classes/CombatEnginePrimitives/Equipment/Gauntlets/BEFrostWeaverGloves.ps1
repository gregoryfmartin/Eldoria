using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFROSTWEAVERGLOVES
#
###############################################################################

Class BEFrostWeaverGloves : BEGauntlets {
	BEFrostWeaverGloves() : base() {
		$this.Name               = 'Frost Weaver Gloves'
		$this.MapObjName         = 'frostweavergloves'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves that manipulate ice, weaving chilling spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
