using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMYTHICHELM
#
###############################################################################

Class BEMythicHelm : BEHelmet {
	BEMythicHelm() : base() {
		$this.Name               = 'Mythic Helm'
		$this.MapObjName         = 'mythichelm'
		$this.PurchasePrice      = 4000
		$this.SellPrice          = 2000
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm from the age of myths, possessing unparalleled power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
