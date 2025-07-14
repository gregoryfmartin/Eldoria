using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGODDESSSHANDGUARDS
#
###############################################################################

Class BEGoddesssHandguards : BEGauntlets {
	BEGoddesssHandguards() : base() {
		$this.Name               = 'Goddess''s Handguards'
		$this.MapObjName         = 'goddessshandguards'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 95
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Handguards said to be touched by a deity, offering ultimate defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
