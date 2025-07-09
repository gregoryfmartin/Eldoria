using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE PUPPET MASTERS VISAGE
#
###############################################################################

Class BEPuppetMastersVisage : BEHelmet {
	BEPuppetMastersVisage() : base() {
		$this.Name               = 'Puppet Master''s Visage'
		$this.MapObjName         = 'puppetmastersvisage'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A grim visage that allows control over puppets and constructs.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
