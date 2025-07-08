using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE SAMURAI KABUTO
#
###############################################################################

Class BESamuraiKabuto : BEHelmet {
	BESamuraiKabuto() : base() {
		$this.Name               = 'Samurai Kabuto'
		$this.MapObjName         = 'samuraikabuto'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A traditional samurai helmet, symbolizing honor and discipline.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
