using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBEARHELMET
#
###############################################################################

Class BEBearHelmet : BEHelmet {
    BEBearHelmet() : base() {
        $this.Name               = 'Bear Helmet'
        $this.MapObjName         = 'bearhelmet'
        $this.PurchasePrice      = 0
        $this.SellPrice          = 0
        $this.TargetStats        = @{
            [StatId]::Defense      = 999
            [StatId]::MagicDefense = 999
        }
        $this.CanAddToInventory  = $true
        $this.ExamineString      = 'The ultimate in fuzzy headwear.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
        $this.TargetGender       = [Gender]::Unisex
    }
}
