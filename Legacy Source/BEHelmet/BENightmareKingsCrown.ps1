using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENIGHTMAREKINGSCROWN
#
###############################################################################

Class BENightmareKingsCrown : BEHelmet {
	BENightmareKingsCrown() : base() {
		$this.Name               = 'Nightmare King''s Crown'
		$this.MapObjName         = 'nightmarekingscrown'
		$this.PurchasePrice      = 7000
		$this.SellPrice          = 3500
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 60
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crown that harnesses nightmares, turning them into tangible fear for enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
