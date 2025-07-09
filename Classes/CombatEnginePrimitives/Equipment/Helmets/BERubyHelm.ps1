using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE RUBY HELM
#
###############################################################################

Class BERubyHelm : BEHelmet {
	BERubyHelm() : base() {
		$this.Name               = 'Ruby Helm'
		$this.MapObjName         = 'rubyhelm'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 11
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm adorned with a large ruby, radiating fiery energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
