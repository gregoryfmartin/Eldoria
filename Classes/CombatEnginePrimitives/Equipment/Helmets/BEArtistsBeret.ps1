using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE ARTIST'S BERET
#
###############################################################################

Class BEArtistsBeret : BEHelmet {
	BEArtistsBeret() : base() {
		$this.Name               = 'Artist''s Beret'
		$this.MapObjName         = 'artistsberet'
		$this.PurchasePrice      = 60
		$this.SellPrice          = 30
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A classic beret worn by artists, inspiring creativity and vision.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
