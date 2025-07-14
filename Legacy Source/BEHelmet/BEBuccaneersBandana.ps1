using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBUCCANEERSBANDANA
#
###############################################################################

Class BEBuccaneersBandana : BEHelmet {
	BEBuccaneersBandana() : base() {
		$this.Name               = 'Buccaneer''s Bandana'
		$this.MapObjName         = 'buccaneersbandana'
		$this.PurchasePrice      = 50
		$this.SellPrice          = 25
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A colorful bandana worn by buccaneers, signifying their adventurous spirit.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
