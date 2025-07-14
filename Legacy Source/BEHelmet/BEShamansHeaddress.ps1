using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESHAMANSHEADDRESS
#
###############################################################################

Class BEShamansHeaddress : BEHelmet {
	BEShamansHeaddress() : base() {
		$this.Name               = 'Shaman''s Headdress'
		$this.MapObjName         = 'shamansheaddress'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 4
			[StatId]::MagicDefense = 11
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A feathered headdress worn by shamans, connecting them to ancestral spirits.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
