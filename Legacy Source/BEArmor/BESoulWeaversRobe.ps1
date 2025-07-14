using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESOULWEAVERSROBE
#
###############################################################################

Class BESoulWeaversRobe : BEArmor {
	BESoulWeaversRobe() : base() {
		$this.Name               = 'Soul Weaver''s Robe'
		$this.MapObjName         = 'soulweaversrobe'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 36
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark robe allowing manipulation of souls, boosts dark magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
