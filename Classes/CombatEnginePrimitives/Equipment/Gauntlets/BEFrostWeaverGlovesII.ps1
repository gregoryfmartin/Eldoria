using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFROSTWEAVERGLOVESII
#
###############################################################################

Class BEFrostWeaverGlovesII : BEGauntlets {
	BEFrostWeaverGlovesII() : base() {
		$this.Name               = 'Frost Weaver Gloves II'
		$this.MapObjName         = 'frostweaverglovesii'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Improved Frost Weaver Gloves, manipulating ice with greater skill.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
