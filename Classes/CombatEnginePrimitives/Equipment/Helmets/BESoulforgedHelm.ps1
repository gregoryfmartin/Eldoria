using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESOULFORGEDHELM
#
###############################################################################

Class BESoulforgedHelm : BEHelmet {
	BESoulforgedHelm() : base() {
		$this.Name               = 'Soulforged Helm'
		$this.MapObjName         = 'soulforgedhelm'
		$this.PurchasePrice      = 3300
		$this.SellPrice          = 1650
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm forged from captured souls, granting immense dark power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
