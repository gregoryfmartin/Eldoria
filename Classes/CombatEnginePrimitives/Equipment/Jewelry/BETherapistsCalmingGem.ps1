using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETHERAPISTSCALMINGGEM
#
###############################################################################

Class BETherapistsCalmingGem : BEJewelry {
	BETherapistsCalmingGem() : base() {
		$this.Name               = 'Therapist''s Calming Gem'
		$this.MapObjName         = 'therapistscalminggem'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A gem that emits a soothing aura, for mental peace.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
