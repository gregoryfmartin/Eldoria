using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE DEMONIC CIRCLET
#
###############################################################################

Class BEDemonicCirclet : BEHelmet {
	BEDemonicCirclet() : base() {
		$this.Name               = 'Demonic Circlet'
		$this.MapObjName         = 'demoniccirclet'
		$this.PurchasePrice      = 2300
		$this.SellPrice          = 1150
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A circlet forged in hellfire, granting control over minor demons.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
