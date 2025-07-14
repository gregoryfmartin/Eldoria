using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFROSTBITEHELM
#
###############################################################################

Class BEFrostbiteHelm : BEHelmet {
	BEFrostbiteHelm() : base() {
		$this.Name               = 'Frostbite Helm'
		$this.MapObjName         = 'frostbitehelm'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm enchanted with ice magic, chilling enemies upon impact.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
