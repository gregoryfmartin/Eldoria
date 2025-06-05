Class BEWovenPauldron : BEPauldron {
	BEWovenPauldron() : base() {
		$this.Name               = 'Woven Pauldron'
		$this.MapObjName         = 'wovenpauldron'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{ [StatId]::Defense = 2 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple pauldron woven from sturdy fibers. Offers basic protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELeatherPauldron : BEPauldron {
	BELeatherPauldron() : base() {
		$this.Name               = 'Leather Pauldron'
		$this.MapObjName         = 'leatherpauldron'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{ [StatId]::Defense = 3 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crafted from cured leather, providing light defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStuddedPauldron : BEPauldron {
	BEStuddedPauldron() : base() {
		$this.Name               = 'Studded Pauldron'
		$this.MapObjName         = 'studdedpauldron'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{ [StatId]::Defense = 4 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Leather pauldron reinforced with metal studs for added protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEChainPauldron : BEPauldron {
	BEChainPauldron() : base() {
		$this.Name               = 'Chain Pauldron'
		$this.MapObjName         = 'chainpauldron'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{ [StatId]::Defense = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Interlocking metal rings form a flexible and protective pauldron.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEScalePauldron : BEPauldron {
	BEScalePauldron() : base() {
		$this.Name               = 'Scale Pauldron'
		$this.MapObjName         = 'scalepauldron'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{ [StatId]::Defense = 6 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Overlapping metal scales provide good defense against various attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBronzePauldron : BEPauldron {
	BEBronzePauldron() : base() {
		$this.Name               = 'Bronze Pauldron'
		$this.MapObjName         = 'bronzepauldron'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{ [StatId]::Defense = 7 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Solid bronze pauldron offering decent protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEIronPauldron : BEPauldron {
	BEIronPauldron() : base() {
		$this.Name               = 'Iron Pauldron'
		$this.MapObjName         = 'ironpauldron'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{ [StatId]::Defense = 8 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy iron pauldron, providing substantial physical defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESteelPauldron : BEPauldron {
	BESteelPauldron() : base() {
		$this.Name               = 'Steel Pauldron'
		$this.MapObjName         = 'steelpauldron'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{ [StatId]::Defense = 9 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Forged from strong steel, a reliable choice for warriors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMithrilPauldron : BEPauldron {
	BEMithrilPauldron() : base() {
		$this.Name               = 'Mithril Pauldron'
		$this.MapObjName         = 'mithrilpauldron'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{ [StatId]::Defense = 10 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Lightweight yet incredibly strong, favored by agile fighters.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAdamantPauldron : BEPauldron {
	BEAdamantPauldron() : base() {
		$this.Name               = 'Adamant Pauldron'
		$this.MapObjName         = 'adamantpauldron'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{ [StatId]::Defense = 11 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Legendary metal pauldron, offering immense protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDragonhidePauldron : BEPauldron {
	BEDragonhidePauldron() : base() {
		$this.Name               = 'Dragonhide Pauldron'
		$this.MapObjName         = 'dragonhidepauldron'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{ [StatId]::Defense = 12 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crafted from the tough hide of a dragon, resistant to many elements.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERunedPauldron : BEPauldron {
	BERunedPauldron() : base() {
		$this.Name               = 'Runed Pauldron'
		$this.MapObjName         = 'runedpauldron'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{ [StatId]::Defense = 13; [StatId]::MagicDefense = 1 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Etched with ancient runes, granting minor magical resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHeroicPauldron : BEPauldron {
	BEHeroicPauldron() : base() {
		$this.Name               = 'Heroic Pauldron'
		$this.MapObjName         = 'heroicpauldron'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{ [StatId]::Defense = 14 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pauldron worn by heroes of old, imbued with fighting spirit.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEValiantPauldron : BEPauldron {
	BEValiantPauldron() : base() {
		$this.Name               = 'Valiant Pauldron'
		$this.MapObjName         = 'valiantpauldron'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{ [StatId]::Defense = 15 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Signifies courage and strength, often worn by knights.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEGloriousPauldron : BEPauldron {
	BEGloriousPauldron() : base() {
		$this.Name               = 'Glorious Pauldron'
		$this.MapObjName         = 'gloriouspauldron'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{ [StatId]::Defense = 16 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shining pauldron, symbolizing victory and honor.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEChampionsPauldron : BEPauldron {
	BEChampionsPauldron() : base() {
		$this.Name               = 'Champion''s Pauldron'
		$this.MapObjName         = 'championspauldron'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{ [StatId]::Defense = 17 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by the undefeated champions of the arena.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BECommandersPauldron : BEPauldron {
	BECommandersPauldron() : base() {
		$this.Name               = 'Commander''s Pauldron'
		$this.MapObjName         = 'commanderspauldron'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{ [StatId]::Defense = 18 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Grants authority and inspires allies on the battlefield.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEWarlordsPauldron : BEPauldron {
	BEWarlordsPauldron() : base() {
		$this.Name               = 'Warlord''s Pauldron'
		$this.MapObjName         = 'warlordspauldron'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{ [StatId]::Defense = 19 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy and menacing, favored by fierce military leaders.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BERoyalGuardPauldron : BEPauldron {
	BERoyalGuardPauldron() : base() {
		$this.Name               = 'Royal Guard Pauldron'
		$this.MapObjName         = 'royalguardpauldron'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{ [StatId]::Defense = 20 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Issued to the elite protectors of the monarchy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESacredPauldron : BEPauldron {
	BESacredPauldron() : base() {
		$this.Name               = 'Sacred Pauldron'
		$this.MapObjName         = 'sacredpauldron'
		$this.PurchasePrice      = 1050
		$this.SellPrice          = 525
		$this.TargetStats        = @{ [StatId]::Defense = 21; [StatId]::MagicDefense = 1 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Blessed by divine power, offering protection against evil.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEPaladinPauldron : BEPauldron {
	BEPaladinPauldron() : base() {
		$this.Name               = 'Paladin Pauldron'
		$this.MapObjName         = 'paladinpauldron'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{ [StatId]::Defense = 22; [StatId]::MagicDefense = 2 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by holy warriors dedicated to justice.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BECrusaderPauldron : BEPauldron {
	BECrusaderPauldron() : base() {
		$this.Name               = 'Crusader Pauldron'
		$this.MapObjName         = 'crusaderpauldron'
		$this.PurchasePrice      = 1150
		$this.SellPrice          = 575
		$this.TargetStats        = @{ [StatId]::Defense = 23 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy and imposing, a symbol of unwavering faith.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESentinelPauldron : BEPauldron {
	BESentinelPauldron() : base() {
		$this.Name               = 'Sentinel Pauldron'
		$this.MapObjName         = 'sentinelpauldron'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{ [StatId]::Defense = 24 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Designed for vigilant guardians, offering superior defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEGuardiansPauldron : BEPauldron {
	BEGuardiansPauldron() : base() {
		$this.Name               = 'Guardian''s Pauldron'
		$this.MapObjName         = 'guardianspauldron'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{ [StatId]::Defense = 25; [StatId]::MagicDefense = 3 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Imbued with protective magic, shielding its wearer from harm.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEDragonbonePauldron : BEPauldron {
	BEDragonbonePauldron() : base() {
		$this.Name               = 'Dragonbone Pauldron'
		$this.MapObjName         = 'dragonbonepauldron'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{ [StatId]::Defense = 26 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Forged from the bones of a fallen dragon, incredibly durable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESoulboundPauldron : BEPauldron {
	BESoulboundPauldron() : base() {
		$this.Name               = 'Soulbound Pauldron'
		$this.MapObjName         = 'soulboundpauldron'
		$this.PurchasePrice      = 1350
		$this.SellPrice          = 675
		$this.TargetStats        = @{ [StatId]::Defense = 27 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Binds to its wearer, enhancing their fighting prowess.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEVanguardPauldron : BEPauldron {
	BEVanguardPauldron() : base() {
		$this.Name               = 'Vanguard Pauldron'
		$this.MapObjName         = 'vanguardpauldron'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{ [StatId]::Defense = 28 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Leads the charge, offering robust protection in the front lines.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEBulwarkPauldron : BEPauldron {
	BEBulwarkPauldron() : base() {
		$this.Name               = 'Bulwark Pauldron'
		$this.MapObjName         = 'bulwarkpauldron'
		$this.PurchasePrice      = 1450
		$this.SellPrice          = 725
		$this.TargetStats        = @{ [StatId]::Defense = 29 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An impenetrable defense, almost impossible to breach.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEFortressPauldron : BEPauldron {
	BEFortressPauldron() : base() {
		$this.Name               = 'Fortress Pauldron'
		$this.MapObjName         = 'fortresspauldron'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{ [StatId]::Defense = 30 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Turns its wearer into a walking fortress, unyielding.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BETitansPauldron : BEPauldron {
	BETitansPauldron() : base() {
		$this.Name               = 'Titan''s Pauldron'
		$this.MapObjName         = 'titanspauldron'
		$this.PurchasePrice      = 1550
		$this.SellPrice          = 775
		$this.TargetStats        = @{ [StatId]::Defense = 31 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Said to have been worn by a Titan, incredibly powerful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEWarriorMaidenPauldron : BEPauldron {
	BEWarriorMaidenPauldron() : base() {
		$this.Name               = 'Warrior Maiden Pauldron'
		$this.MapObjName         = 'warriormaidenpauldron'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{ [StatId]::Defense = 14 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Designed for courageous female warriors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEAmazonianPauldron : BEPauldron {
	BEAmazonianPauldron() : base() {
		$this.Name               = 'Amazonian Pauldron'
		$this.MapObjName         = 'amazonianpauldron'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{ [StatId]::Defense = 15 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by the legendary Amazons, light yet strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEValkyriePauldron : BEPauldron {
	BEValkyriePauldron() : base() {
		$this.Name               = 'Valkyrie Pauldron'
		$this.MapObjName         = 'valkyriepauldron'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{ [StatId]::Defense = 16 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Shines with divine light, granting protection to its wearer.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEHuntressPauldron : BEPauldron {
	BEHuntressPauldron() : base() {
		$this.Name               = 'Huntress Pauldron'
		$this.MapObjName         = 'huntresspauldron'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{ [StatId]::Defense = 17 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Allows for agile movement while offering decent protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEShieldmaidensPauldron : BEPauldron {
	BEShieldmaidensPauldron() : base() {
		$this.Name               = 'Shieldmaiden''s Pauldron'
		$this.MapObjName         = 'shieldmaidenspauldron'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{ [StatId]::Defense = 18 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by fierce shieldmaidens, providing robust defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEDaughteroftheForestPauldron : BEPauldron {
	BEDaughteroftheForestPauldron() : base() {
		$this.Name               = 'Daughter of the Forest Pauldron'
		$this.MapObjName         = 'daughteroftheforestpauldron'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{ [StatId]::Defense = 19 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Blends with nature, offering subtle protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEQueensGuardPauldron : BEPauldron {
	BEQueensGuardPauldron() : base() {
		$this.Name               = 'Queen''s Guard Pauldron'
		$this.MapObjName         = 'queensguardpauldron'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{ [StatId]::Defense = 20 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Elegant yet strong, worn by the elite protectors of the queen.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEDivineMaidenPauldron : BEPauldron {
	BEDivineMaidenPauldron() : base() {
		$this.Name               = 'Divine Maiden Pauldron'
		$this.MapObjName         = 'divinemaidenpauldron'
		$this.PurchasePrice      = 1050
		$this.SellPrice          = 525
		$this.TargetStats        = @{ [StatId]::Defense = 21; [StatId]::MagicDefense = 1 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Blessed by ancient goddesses, warding off malevolent forces.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEPriestessPauldron : BEPauldron {
	BEPriestessPauldron() : base() {
		$this.Name               = 'Priestess Pauldron'
		$this.MapObjName         = 'priestesspauldron'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{ [StatId]::Defense = 22; [StatId]::MagicDefense = 2 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by holy priestesses, offering both defense and spiritual aid.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEMysticPauldron : BEPauldron {
	BEMysticPauldron() : base() {
		$this.Name               = 'Mystic Pauldron'
		$this.MapObjName         = 'mysticpauldron'
		$this.PurchasePrice      = 1150
		$this.SellPrice          = 575
		$this.TargetStats        = @{ [StatId]::Defense = 23; [StatId]::MagicDefense = 4 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Imbued with arcane energies, enhancing magical defenses.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESorcerersPauldron : BEPauldron {
	BESorcerersPauldron() : base() {
		$this.Name               = 'Sorcerer''s Pauldron'
		$this.MapObjName         = 'sorcererspauldron'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{ [StatId]::Defense = 24; [StatId]::MagicDefense = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Favored by powerful sorcerers, enhancing their spellcasting.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEArchmagePauldron : BEPauldron {
	BEArchmagePauldron() : base() {
		$this.Name               = 'Archmage Pauldron'
		$this.MapObjName         = 'archmagepauldron'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{ [StatId]::Defense = 25; [StatId]::MagicDefense = 6 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pauldron of immense magical power, worn by master mages.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWarlockPauldron : BEPauldron {
	BEWarlockPauldron() : base() {
		$this.Name               = 'Warlock Pauldron'
		$this.MapObjName         = 'warlockpauldron'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{ [StatId]::Defense = 26; [StatId]::MagicDefense = 7 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Dark and potent, for those who wield forbidden magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEnchantersPauldron : BEPauldron {
	BEEnchantersPauldron() : base() {
		$this.Name               = 'Enchanter''s Pauldron'
		$this.MapObjName         = 'enchanterspauldron'
		$this.PurchasePrice      = 1350
		$this.SellPrice          = 675
		$this.TargetStats        = @{ [StatId]::Defense = 27; [StatId]::MagicDefense = 8 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Enhances enchantments and magical effects.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESagesPauldron : BEPauldron {
	BESagesPauldron() : base() {
		$this.Name               = 'Sage''s Pauldron'
		$this.MapObjName         = 'sagespauldron'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{ [StatId]::Defense = 28; [StatId]::MagicDefense = 9 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by wise sages, granting insight and magical prowess.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BENecromancerPauldron : BEPauldron {
	BENecromancerPauldron() : base() {
		$this.Name               = 'Necromancer Pauldron'
		$this.MapObjName         = 'necromancerpauldron'
		$this.PurchasePrice      = 1450
		$this.SellPrice          = 725
		$this.TargetStats        = @{ [StatId]::Defense = 29; [StatId]::MagicDefense = 10 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Allows for manipulation of the undead, dark and chilling.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELichPauldron : BEPauldron {
	BELichPauldron() : base() {
		$this.Name               = 'Lich Pauldron'
		$this.MapObjName         = 'lichpauldron'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{ [StatId]::Defense = 30; [StatId]::MagicDefense = 11 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A relic of immense power, brimming with dark magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEElementalPauldron : BEPauldron {
	BEElementalPauldron() : base() {
		$this.Name               = 'Elemental Pauldron'
		$this.MapObjName         = 'elementalpauldron'
		$this.PurchasePrice      = 1550
		$this.SellPrice          = 775
		$this.TargetStats        = @{ [StatId]::Defense = 31; [StatId]::MagicDefense = 12 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Channels the power of the elements, offering varied resistances.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAstralPauldron : BEPauldron {
	BEAstralPauldron() : base() {
		$this.Name               = 'Astral Pauldron'
		$this.MapObjName         = 'astralpauldron'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{ [StatId]::Defense = 32; [StatId]::MagicDefense = 13 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Said to be woven from starlight, offering cosmic protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEShadowPauldron : BEPauldron {
	BEShadowPauldron() : base() {
		$this.Name               = 'Shadow Pauldron'
		$this.MapObjName         = 'shadowpauldron'
		$this.PurchasePrice      = 1650
		$this.SellPrice          = 825
		$this.TargetStats        = @{ [StatId]::Defense = 33; [StatId]::MagicDefense = 14 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Grants concealment and enhances stealth, for those who walk in shadows.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAssassinsPauldron : BEPauldron {
	BEAssassinsPauldron() : base() {
		$this.Name               = 'Assassin''s Pauldron'
		$this.MapObjName         = 'assassinspauldron'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{ [StatId]::Defense = 34 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light and agile, perfect for striking from the shadows.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BERoguePauldron : BEPauldron {
	BERoguePauldron() : base() {
		$this.Name               = 'Rogue Pauldron'
		$this.MapObjName         = 'roguepauldron'
		$this.PurchasePrice      = 1750
		$this.SellPrice          = 875
		$this.TargetStats        = @{ [StatId]::Defense = 35 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Designed for cunning rogues, offering minimal hindrance to movement.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEThiefsPauldron : BEPauldron {
	BEThiefsPauldron() : base() {
		$this.Name               = 'Thief''s Pauldron'
		$this.MapObjName         = 'thiefspauldron'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{ [StatId]::Defense = 36 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Allows for quick escapes and silent movement.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEScoutPauldron : BEPauldron {
	BEScoutPauldron() : base() {
		$this.Name               = 'Scout Pauldron'
		$this.MapObjName         = 'scoutpauldron'
		$this.PurchasePrice      = 1850
		$this.SellPrice          = 925
		$this.TargetStats        = @{ [StatId]::Defense = 37 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Lightweight and practical for long journeys and reconnaissance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEHuntersPauldron : BEPauldron {
	BEHuntersPauldron() : base() {
		$this.Name               = 'Hunter''s Pauldron'
		$this.MapObjName         = 'hunterspauldron'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{ [StatId]::Defense = 38 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Provides decent protection without sacrificing mobility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEBrigandsPauldron : BEPauldron {
	BEBrigandsPauldron() : base() {
		$this.Name               = 'Brigand''s Pauldron'
		$this.MapObjName         = 'brigandspauldron'
		$this.PurchasePrice      = 1950
		$this.SellPrice          = 975
		$this.TargetStats        = @{ [StatId]::Defense = 39 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Roughly made but effective for those who live by their wits.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEOutlawPauldron : BEPauldron {
	BEOutlawPauldron() : base() {
		$this.Name               = 'Outlaw Pauldron'
		$this.MapObjName         = 'outlawpauldron'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{ [StatId]::Defense = 40 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Favored by those who operate outside the law.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEMaraudersPauldron : BEPauldron {
	BEMaraudersPauldron() : base() {
		$this.Name               = 'Marauder''s Pauldron'
		$this.MapObjName         = 'marauderspauldron'
		$this.PurchasePrice      = 2050
		$this.SellPrice          = 1025
		$this.TargetStats        = @{ [StatId]::Defense = 41 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Aggressive and functional, for those who take what they want.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BENomadPauldron : BEPauldron {
	BENomadPauldron() : base() {
		$this.Name               = 'Nomad Pauldron'
		$this.MapObjName         = 'nomadpauldron'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{ [StatId]::Defense = 42 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Practical and durable for endless journeys.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEWanderersPauldron : BEPauldron {
	BEWanderersPauldron() : base() {
		$this.Name               = 'Wanderer''s Pauldron'
		$this.MapObjName         = 'wandererspauldron'
		$this.PurchasePrice      = 2150
		$this.SellPrice          = 1075
		$this.TargetStats        = @{ [StatId]::Defense = 43 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by those who roam the wilderness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEPathfinderPauldron : BEPauldron {
	BEPathfinderPauldron() : base() {
		$this.Name               = 'Pathfinder Pauldron'
		$this.MapObjName         = 'pathfinderpauldron'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{ [StatId]::Defense = 44 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Aids in navigating difficult terrain and evading threats.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEExplorersPauldron : BEPauldron {
	BEExplorersPauldron() : base() {
		$this.Name               = 'Explorer''s Pauldron'
		$this.MapObjName         = 'explorerspauldron'
		$this.PurchasePrice      = 2250
		$this.SellPrice          = 1125
		$this.TargetStats        = @{ [StatId]::Defense = 45 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'For venturing into uncharted territories, offering decent protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BETravelersPauldron : BEPauldron {
	BETravelersPauldron() : base() {
		$this.Name               = 'Traveler''s Pauldron'
		$this.MapObjName         = 'travelerspauldron'
		$this.PurchasePrice      = 2300
		$this.SellPrice          = 1150
		$this.TargetStats        = @{ [StatId]::Defense = 46 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Comfortable and reliable for long expeditions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESurvivorsPauldron : BEPauldron {
	BESurvivorsPauldron() : base() {
		$this.Name               = 'Survivor''s Pauldron'
		$this.MapObjName         = 'survivorspauldron'
		$this.PurchasePrice      = 2350
		$this.SellPrice          = 1175
		$this.TargetStats        = @{ [StatId]::Defense = 47 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Shows signs of wear but has endured countless hardships.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEFrontierPauldron : BEPauldron {
	BEFrontierPauldron() : base() {
		$this.Name               = 'Frontier Pauldron'
		$this.MapObjName         = 'frontierpauldron'
		$this.PurchasePrice      = 2400
		$this.SellPrice          = 1200
		$this.TargetStats        = @{ [StatId]::Defense = 48 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Suited for the untamed wilds, offering rugged defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEWastelandPauldron : BEPauldron {
	BEWastelandPauldron() : base() {
		$this.Name               = 'Wasteland Pauldron'
		$this.MapObjName         = 'wastelandpauldron'
		$this.PurchasePrice      = 2450
		$this.SellPrice          = 1225
		$this.TargetStats        = @{ [StatId]::Defense = 49 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Salvaged and reinforced, offering protection in desolate lands.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BERebelPauldron : BEPauldron {
	BERebelPauldron() : base() {
		$this.Name               = 'Rebel Pauldron'
		$this.MapObjName         = 'rebelpauldron'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{ [StatId]::Defense = 50 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A symbol of defiance, for those who fight against oppression.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEDesertWalkerPauldron : BEPauldron {
	BEDesertWalkerPauldron() : base() {
		$this.Name               = 'Desert Walker Pauldron'
		$this.MapObjName         = 'desertwalkerpauldron'
		$this.PurchasePrice      = 2550
		$this.SellPrice          = 1275
		$this.TargetStats        = @{ [StatId]::Defense = 51 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Designed for endurance in arid environments.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEMountainClimberPauldron : BEPauldron {
	BEMountainClimberPauldron() : base() {
		$this.Name               = 'Mountain Climber Pauldron'
		$this.MapObjName         = 'mountainclimberpauldron'
		$this.PurchasePrice      = 2600
		$this.SellPrice          = 1300
		$this.TargetStats        = @{ [StatId]::Defense = 52 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Aids in scaling peaks and offers protection against falling debris.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEGlacierPauldron : BEPauldron {
	BEGlacierPauldron() : base() {
		$this.Name               = 'Glacier Pauldron'
		$this.MapObjName         = 'glacierpauldron'
		$this.PurchasePrice      = 2650
		$this.SellPrice          = 1325
		$this.TargetStats        = @{ [StatId]::Defense = 53 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Provides warmth and protection in freezing conditions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESwamplandPauldron : BEPauldron {
	BESwamplandPauldron() : base() {
		$this.Name               = 'Swampland Pauldron'
		$this.MapObjName         = 'swamplandpauldron'
		$this.PurchasePrice      = 2700
		$this.SellPrice          = 1350
		$this.TargetStats        = @{ [StatId]::Defense = 54 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Resistant to moisture and disease, for traversing murky waters.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEDeepSeaPauldron : BEPauldron {
	BEDeepSeaPauldron() : base() {
		$this.Name               = 'Deep Sea Pauldron'
		$this.MapObjName         = 'deepseapauldron'
		$this.PurchasePrice      = 2750
		$this.SellPrice          = 1375
		$this.TargetStats        = @{ [StatId]::Defense = 55 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Offers protection against the pressures of the ocean depths.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESkyfarerPauldron : BEPauldron {
	BESkyfarerPauldron() : base() {
		$this.Name               = 'Skyfarer Pauldron'
		$this.MapObjName         = 'skyfarerpauldron'
		$this.PurchasePrice      = 2800
		$this.SellPrice          = 1400
		$this.TargetStats        = @{ [StatId]::Defense = 56 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Lightweight and aerodynamic, for those who travel the skies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BECloudWalkerPauldron : BEPauldron {
	BECloudWalkerPauldron() : base() {
		$this.Name               = 'Cloud Walker Pauldron'
		$this.MapObjName         = 'cloudwalkerpauldron'
		$this.PurchasePrice      = 2850
		$this.SellPrice          = 1425
		$this.TargetStats        = @{ [StatId]::Defense = 57 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Allows for graceful movement across aerial platforms.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEStormforgedPauldron : BEPauldron {
	BEStormforgedPauldron() : base() {
		$this.Name               = 'Stormforged Pauldron'
		$this.MapObjName         = 'stormforgedpauldron'
		$this.PurchasePrice      = 2900
		$this.SellPrice          = 1450
		$this.TargetStats        = @{ [StatId]::Defense = 58; [StatId]::MagicDefense = 15 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Forged in the heart of a storm, crackling with energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETempestPauldron : BEPauldron {
	BETempestPauldron() : base() {
		$this.Name               = 'Tempest Pauldron'
		$this.MapObjName         = 'tempestpauldron'
		$this.PurchasePrice      = 2950
		$this.SellPrice          = 1475
		$this.TargetStats        = @{ [StatId]::Defense = 59; [StatId]::MagicDefense = 16 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Embodies the fury of a storm, enhancing elemental resistances.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEZephyrPauldron : BEPauldron {
	BEZephyrPauldron() : base() {
		$this.Name               = 'Zephyr Pauldron'
		$this.MapObjName         = 'zephyrpauldron'
		$this.PurchasePrice      = 3000
		$this.SellPrice          = 1500
		$this.TargetStats        = @{ [StatId]::Defense = 60 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light as a feather, granting incredible agility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGalePauldron : BEPauldron {
	BEGalePauldron() : base() {
		$this.Name               = 'Gale Pauldron'
		$this.MapObjName         = 'galepauldron'
		$this.PurchasePrice      = 3050
		$this.SellPrice          = 1525
		$this.TargetStats        = @{ [StatId]::Defense = 61 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Channels the power of the wind, offering protection against air currents.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECyclonePauldron : BEPauldron {
	BECyclonePauldron() : base() {
		$this.Name               = 'Cyclone Pauldron'
		$this.MapObjName         = 'cyclonepauldron'
		$this.PurchasePrice      = 3100
		$this.SellPrice          = 1550
		$this.TargetStats        = @{ [StatId]::Defense = 62; [StatId]::MagicDefense = 17 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by masters of wind magic, creating defensive gusts.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEarthenPauldron : BEPauldron {
	BEEarthenPauldron() : base() {
		$this.Name               = 'Earthen Pauldron'
		$this.MapObjName         = 'earthenpauldron'
		$this.PurchasePrice      = 3150
		$this.SellPrice          = 1575
		$this.TargetStats        = @{ [StatId]::Defense = 63 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Made from compressed earth, offering unparalleled physical defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStonePauldron : BEPauldron {
	BEStonePauldron() : base() {
		$this.Name               = 'Stone Pauldron'
		$this.MapObjName         = 'stonepauldron'
		$this.PurchasePrice      = 3200
		$this.SellPrice          = 1600
		$this.TargetStats        = @{ [StatId]::Defense = 64 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy and unyielding, providing immense protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGoliathPauldron : BEPauldron {
	BEGoliathPauldron() : base() {
		$this.Name               = 'Goliath Pauldron'
		$this.MapObjName         = 'goliathpauldron'
		$this.PurchasePrice      = 3250
		$this.SellPrice          = 1625
		$this.TargetStats        = @{ [StatId]::Defense = 65 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Named after the giants of old, granting incredible resilience.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEDwarvenPauldron : BEPauldron {
	BEDwarvenPauldron() : base() {
		$this.Name               = 'Dwarven Pauldron'
		$this.MapObjName         = 'dwarvenpauldron'
		$this.PurchasePrice      = 3300
		$this.SellPrice          = 1650
		$this.TargetStats        = @{ [StatId]::Defense = 66 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Masterfully crafted by dwarves, incredibly sturdy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEOgrePauldron : BEPauldron {
	BEOgrePauldron() : base() {
		$this.Name               = 'Ogre Pauldron'
		$this.MapObjName         = 'ogrepauldron'
		$this.PurchasePrice      = 3350
		$this.SellPrice          = 1675
		$this.TargetStats        = @{ [StatId]::Defense = 67 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crude but effective, worn by large, brutish fighters.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEGolemPauldron : BEPauldron {
	BEGolemPauldron() : base() {
		$this.Name               = 'Golem Pauldron'
		$this.MapObjName         = 'golempauldron'
		$this.PurchasePrice      = 3400
		$this.SellPrice          = 1700
		$this.TargetStats        = @{ [StatId]::Defense = 68 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Imbued with the spirit of a golem, unmoving and strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMagmaPauldron : BEPauldron {
	BEMagmaPauldron() : base() {
		$this.Name               = 'Magma Pauldron'
		$this.MapObjName         = 'magmapauldron'
		$this.PurchasePrice      = 3450
		$this.SellPrice          = 1725
		$this.TargetStats        = @{ [StatId]::Defense = 69; [StatId]::MagicDefense = 18 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Radiates intense heat, offering fire resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVolcanicPauldron : BEPauldron {
	BEVolcanicPauldron() : base() {
		$this.Name               = 'Volcanic Pauldron'
		$this.MapObjName         = 'volcanicpauldron'
		$this.PurchasePrice      = 3500
		$this.SellPrice          = 1750
		$this.TargetStats        = @{ [StatId]::Defense = 70 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Forged in volcanic fires, resistant to extreme temperatures.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAshPauldron : BEPauldron {
	BEAshPauldron() : base() {
		$this.Name               = 'Ash Pauldron'
		$this.MapObjName         = 'ashpauldron'
		$this.PurchasePrice      = 3550
		$this.SellPrice          = 1775
		$this.TargetStats        = @{ [StatId]::Defense = 71 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Coated in volcanic ash, offering protection from heat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECinderPauldron : BEPauldron {
	BECinderPauldron() : base() {
		$this.Name               = 'Cinder Pauldron'
		$this.MapObjName         = 'cinderpauldron'
		$this.PurchasePrice      = 3600
		$this.SellPrice          = 1800
		$this.TargetStats        = @{ [StatId]::Defense = 72 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Still smoldering from its creation, radiates warmth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEInfernoPauldron : BEPauldron {
	BEInfernoPauldron() : base() {
		$this.Name               = 'Inferno Pauldron'
		$this.MapObjName         = 'infernopauldron'
		$this.PurchasePrice      = 3650
		$this.SellPrice          = 1825
		$this.TargetStats        = @{ [StatId]::Defense = 73; [StatId]::MagicDefense = 19 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Blazes with infernal fire, empowering fire defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGlacialPauldron : BEPauldron {
	BEGlacialPauldron() : base() {
		$this.Name               = 'Glacial Pauldron'
		$this.MapObjName         = 'glacialpauldron'
		$this.PurchasePrice      = 3700
		$this.SellPrice          = 1850
		$this.TargetStats        = @{ [StatId]::Defense = 74; [StatId]::MagicDefense = 20 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Freezes anything that touches it, offering resistance to ice.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFrostPauldron : BEPauldron {
	BEFrostPauldron() : base() {
		$this.Name               = 'Frost Pauldron'
		$this.MapObjName         = 'frostpauldron'
		$this.PurchasePrice      = 3750
		$this.SellPrice          = 1875
		$this.TargetStats        = @{ [StatId]::Defense = 75; [StatId]::MagicDefense = 21 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Covered in perpetual frost, enhancing ice-based defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBorealPauldron : BEPauldron {
	BEBorealPauldron() : base() {
		$this.Name               = 'Boreal Pauldron'
		$this.MapObjName         = 'borealpauldron'
		$this.PurchasePrice      = 3800
		$this.SellPrice          = 1900
		$this.TargetStats        = @{ [StatId]::Defense = 76 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Woven with threads of ice, offering chilling protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBlizzardPauldron : BEPauldron {
	BEBlizzardPauldron() : base() {
		$this.Name               = 'Blizzard Pauldron'
		$this.MapObjName         = 'blizzardpauldron'
		$this.PurchasePrice      = 3850
		$this.SellPrice          = 1925
		$this.TargetStats        = @{ [StatId]::Defense = 77; [StatId]::MagicDefense = 22 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Summons icy winds to buffet foes, enhancing cold defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOceanicPauldron : BEPauldron {
	BEOceanicPauldron() : base() {
		$this.Name               = 'Oceanic Pauldron'
		$this.MapObjName         = 'oceanicpauldron'
		$this.PurchasePrice      = 3900
		$this.SellPrice          = 1950
		$this.TargetStats        = @{ [StatId]::Defense = 78 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Shimmers with the colors of the deep sea, resistant to water.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECoralPauldron : BEPauldron {
	BECoralPauldron() : base() {
		$this.Name               = 'Coral Pauldron'
		$this.MapObjName         = 'coralpauldron'
		$this.PurchasePrice      = 3950
		$this.SellPrice          = 1975
		$this.TargetStats        = @{ [StatId]::Defense = 79 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Made from hardened coral, surprisingly durable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETidalPauldron : BEPauldron {
	BETidalPauldron() : base() {
		$this.Name               = 'Tidal Pauldron'
		$this.MapObjName         = 'tidalpauldron'
		$this.PurchasePrice      = 4000
		$this.SellPrice          = 2000
		$this.TargetStats        = @{ [StatId]::Defense = 80; [StatId]::MagicDefense = 23 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Channels the power of the tides, enhancing water defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAbyssalPauldron : BEPauldron {
	BEAbyssalPauldron() : base() {
		$this.Name               = 'Abyssal Pauldron'
		$this.MapObjName         = 'abyssalpauldron'
		$this.PurchasePrice      = 4050
		$this.SellPrice          = 2025
		$this.TargetStats        = @{ [StatId]::Defense = 81; [StatId]::MagicDefense = 24 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Pulled from the deepest trenches, exuding an ancient power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESunkenPauldron : BEPauldron {
	BESunkenPauldron() : base() {
		$this.Name               = 'Sunken Pauldron'
		$this.MapObjName         = 'sunkenpauldron'
		$this.PurchasePrice      = 4100
		$this.SellPrice          = 2050
		$this.TargetStats        = @{ [StatId]::Defense = 82 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Waterlogged but incredibly resilient, carries the scent of the ocean.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEElectricPauldron : BEPauldron {
	BEElectricPauldron() : base() {
		$this.Name               = 'Electric Pauldron'
		$this.MapObjName         = 'electricpauldron'
		$this.PurchasePrice      = 4150
		$this.SellPrice          = 2075
		$this.TargetStats        = @{ [StatId]::Defense = 83; [StatId]::MagicDefense = 25 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crackles with static electricity, shocking nearby enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEThunderPauldron : BEPauldron {
	BEThunderPauldron() : base() {
		$this.Name               = 'Thunder Pauldron'
		$this.MapObjName         = 'thunderpauldron'
		$this.PurchasePrice      = 4200
		$this.SellPrice          = 2100
		$this.TargetStats        = @{ [StatId]::Defense = 84; [StatId]::MagicDefense = 26 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Resonates with the roar of thunder, empowering lightning defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESparkPauldron : BEPauldron {
	BESparkPauldron() : base() {
		$this.Name               = 'Spark Pauldron'
		$this.MapObjName         = 'sparkpauldron'
		$this.PurchasePrice      = 4250
		$this.SellPrice          = 2125
		$this.TargetStats        = @{ [StatId]::Defense = 85 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Emits small sparks, offering minor electrical resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPlasmaPauldron : BEPauldron {
	BEPlasmaPauldron() : base() {
		$this.Name               = 'Plasma Pauldron'
		$this.MapObjName         = 'plasmapauldron'
		$this.PurchasePrice      = 4300
		$this.SellPrice          = 2150
		$this.TargetStats        = @{ [StatId]::Defense = 86; [StatId]::MagicDefense = 27 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Generates a field of superheated plasma, for advanced warriors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERadiantPauldron : BEPauldron {
	BERadiantPauldron() : base() {
		$this.Name               = 'Radiant Pauldron'
		$this.MapObjName         = 'radiantpauldron'
		$this.PurchasePrice      = 4350
		$this.SellPrice          = 2175
		$this.TargetStats        = @{ [StatId]::Defense = 87; [StatId]::MagicDefense = 28 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Glows with a warm light, warding off darkness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELunarPauldron : BEPauldron {
	BELunarPauldron() : base() {
		$this.Name               = 'Lunar Pauldron'
		$this.MapObjName         = 'lunarpauldron'
		$this.PurchasePrice      = 4400
		$this.SellPrice          = 2200
		$this.TargetStats        = @{ [StatId]::Defense = 88; [StatId]::MagicDefense = 29 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Shimmers with moonlight, enhancing night-based defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESolarPauldron : BEPauldron {
	BESolarPauldron() : base() {
		$this.Name               = 'Solar Pauldron'
		$this.MapObjName         = 'solarpauldron'
		$this.PurchasePrice      = 4450
		$this.SellPrice          = 2225
		$this.TargetStats        = @{ [StatId]::Defense = 89; [StatId]::MagicDefense = 30 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Blazes with the power of the sun, enhancing fire and light defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStarlightPauldron : BEPauldron {
	BEStarlightPauldron() : base() {
		$this.Name               = 'Starlight Pauldron'
		$this.MapObjName         = 'starlightpauldron'
		$this.PurchasePrice      = 4500
		$this.SellPrice          = 2250
		$this.TargetStats        = @{ [StatId]::Defense = 90; [StatId]::MagicDefense = 31 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Embedded with shimmering stardust, for celestial magic users.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECosmicPauldron : BEPauldron {
	BECosmicPauldron() : base() {
		$this.Name               = 'Cosmic Pauldron'
		$this.MapObjName         = 'cosmicpauldron'
		$this.PurchasePrice      = 4550
		$this.SellPrice          = 2275
		$this.TargetStats        = @{ [StatId]::Defense = 91; [StatId]::MagicDefense = 32 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Connects to the vastness of the cosmos, granting immense power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVoidPauldron : BEPauldron {
	BEVoidPauldron() : base() {
		$this.Name               = 'Void Pauldron'
		$this.MapObjName         = 'voidpauldron'
		$this.PurchasePrice      = 4600
		$this.SellPrice          = 2300
		$this.TargetStats        = @{ [StatId]::Defense = 92; [StatId]::MagicDefense = 33 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Woven from the fabric of the void, absorbing all light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEShadowPauldron : BEPauldron {
	BEShadowPauldron() : base() {
		$this.Name               = 'Shadow Pauldron'
		$this.MapObjName         = 'shadowpauldron'
		$this.PurchasePrice      = 4650
		$this.SellPrice          = 2325
		$this.TargetStats        = @{ [StatId]::Defense = 93; [StatId]::MagicDefense = 34 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Grants concealment and enhances stealth, for those who walk in shadows.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BENightfallPauldron : BEPauldron {
	BENightfallPauldron() : base() {
		$this.Name               = 'Nightfall Pauldron'
		$this.MapObjName         = 'nightfallpauldron'
		$this.PurchasePrice      = 4700
		$this.SellPrice          = 2350
		$this.TargetStats        = @{ [StatId]::Defense = 94 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Enshrouds its wearer in perpetual twilight, aiding stealth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEclipsePauldron : BEPauldron {
	BEEclipsePauldron() : base() {
		$this.Name               = 'Eclipse Pauldron'
		$this.MapObjName         = 'eclipsepauldron'
		$this.PurchasePrice      = 4750
		$this.SellPrice          = 2375
		$this.TargetStats        = @{ [StatId]::Defense = 95; [StatId]::MagicDefense = 35 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Combines light and shadow, offering balanced protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDreamWeaverPauldron : BEPauldron {
	BEDreamWeaverPauldron() : base() {
		$this.Name               = 'Dream Weaver Pauldron'
		$this.MapObjName         = 'dreamweaverpauldron'
		$this.PurchasePrice      = 4800
		$this.SellPrice          = 2400
		$this.TargetStats        = @{ [StatId]::Defense = 96; [StatId]::MagicDefense = 36 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Grants access to dreams, allowing for illusory defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESpiritPauldron : BEPauldron {
	BESpiritPauldron() : base() {
		$this.Name               = 'Spirit Pauldron'
		$this.MapObjName         = 'spiritpauldron'
		$this.PurchasePrice      = 4850
		$this.SellPrice          = 2425
		$this.TargetStats        = @{ [StatId]::Defense = 97; [StatId]::MagicDefense = 37 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Allows communication with spirits, enhancing spiritual defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPhantomPauldron : BEPauldron {
	BEPhantomPauldron() : base() {
		$this.Name               = 'Phantom Pauldron'
		$this.MapObjName         = 'phantompauldron'
		$this.PurchasePrice      = 4900
		$this.SellPrice          = 2450
		$this.TargetStats        = @{ [StatId]::Defense = 98 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Makes its wearer semi-corporeal, allowing them to phase through attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGhostPauldron : BEPauldron {
	BEGhostPauldron() : base() {
		$this.Name               = 'Ghost Pauldron'
		$this.MapObjName         = 'ghostpauldron'
		$this.PurchasePrice      = 4950
		$this.SellPrice          = 2475
		$this.TargetStats        = @{ [StatId]::Defense = 99 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by spectral beings, offering ethereal protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESpecterPauldron : BEPauldron {
	BESpecterPauldron() : base() {
		$this.Name               = 'Specter Pauldron'
		$this.MapObjName         = 'specterpauldron'
		$this.PurchasePrice      = 5000
		$this.SellPrice          = 2500
		$this.TargetStats        = @{ [StatId]::Defense = 100; [StatId]::MagicDefense = 38 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A chilling relic, enhancing fear-inducing defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVampirePauldron : BEPauldron {
	BEVampirePauldron() : base() {
		$this.Name               = 'Vampire Pauldron'
		$this.MapObjName         = 'vampirepauldron'
		$this.PurchasePrice      = 5050
		$this.SellPrice          = 2525
		$this.TargetStats        = @{ [StatId]::Defense = 101; [StatId]::MagicDefense = 39 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Feeds on the life force of enemies, restoring health to the wearer.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWerewolfPauldron : BEPauldron {
	BEWerewolfPauldron() : base() {
		$this.Name               = 'Werewolf Pauldron'
		$this.MapObjName         = 'werewolfpauldron'
		$this.PurchasePrice      = 5100
		$this.SellPrice          = 2550
		$this.TargetStats        = @{ [StatId]::Defense = 102 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Enhances bestial resistance and ferocity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGargoylePauldron : BEPauldron {
	BEGargoylePauldron() : base() {
		$this.Name               = 'Gargoyle Pauldron'
		$this.MapObjName         = 'gargoylepauldron'
		$this.PurchasePrice      = 5150
		$this.SellPrice          = 2575
		$this.TargetStats        = @{ [StatId]::Defense = 103 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Made from hardened stone, incredibly tough and unyielding.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBasiliskPauldron : BEPauldron {
	BEBasiliskPauldron() : base() {
		$this.Name               = 'Basilisk Pauldron'
		$this.MapObjName         = 'basiliskpauldron'
		$this.PurchasePrice      = 5200
		$this.SellPrice          = 2600
		$this.TargetStats        = @{ [StatId]::Defense = 104 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Petrifies attackers with its gaze, offering unique defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGriffinPauldron : BEPauldron {
	BEGriffinPauldron() : base() {
		$this.Name               = 'Griffin Pauldron'
		$this.MapObjName         = 'griffinpauldron'
		$this.PurchasePrice      = 5250
		$this.SellPrice          = 2625
		$this.TargetStats        = @{ [StatId]::Defense = 105 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light and regal, allowing for swift aerial maneuvers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPhoenixPauldron : BEPauldron {
	BEPhoenixPauldron() : base() {
		$this.Name               = 'Phoenix Pauldron'
		$this.MapObjName         = 'phoenixpauldron'
		$this.PurchasePrice      = 5300
		$this.SellPrice          = 2650
		$this.TargetStats        = @{ [StatId]::Defense = 106; [StatId]::MagicDefense = 40 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Blazes with eternal flame, granting resistance to fire.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEUnicornPauldron : BEPauldron {
	BEUnicornPauldron() : base() {
		$this.Name               = 'Unicorn Pauldron'
		$this.MapObjName         = 'unicornpauldron'
		$this.PurchasePrice      = 5350
		$this.SellPrice          = 2675
		$this.TargetStats        = @{ [StatId]::Defense = 107; [StatId]::MagicDefense = 41 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Pure and benevolent, warding off evil and healing wounds.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDragonKingPauldron : BEPauldron {
	BEDragonKingPauldron() : base() {
		$this.Name               = 'Dragon King Pauldron'
		$this.MapObjName         = 'dragonkingpauldron'
		$this.PurchasePrice      = 5400
		$this.SellPrice          = 2700
		$this.TargetStats        = @{ [StatId]::Defense = 108; [StatId]::MagicDefense = 42 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by ancient dragon kings, embodying immense power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESerpentPauldron : BEPauldron {
	BESerpentPauldron() : base() {
		$this.Name               = 'Serpent Pauldron'
		$this.MapObjName         = 'serpentpauldron'
		$this.PurchasePrice      = 5450
		$this.SellPrice          = 2725
		$this.TargetStats        = @{ [StatId]::Defense = 109 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Slithers with subtle power, enhancing poison resistance and agility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESpiderPauldron : BEPauldron {
	BESpiderPauldron() : base() {
		$this.Name               = 'Spider Pauldron'
		$this.MapObjName         = 'spiderpauldron'
		$this.PurchasePrice      = 5500
		$this.SellPrice          = 2750
		$this.TargetStats        = @{ [StatId]::Defense = 110 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Allows for agile movement and offers venom resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEScorpionPauldron : BEPauldron {
	BEScorpionPauldron() : base() {
		$this.Name               = 'Scorpion Pauldron'
		$this.MapObjName         = 'scorpionpauldron'
		$this.PurchasePrice      = 5550
		$this.SellPrice          = 2775
		$this.TargetStats        = @{ [StatId]::Defense = 111 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Sharp and deadly, enhancing critical resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBeetlePauldron : BEPauldron {
	BEBeetlePauldron() : base() {
		$this.Name               = 'Beetle Pauldron'
		$this.MapObjName         = 'beetlepauldron'
		$this.PurchasePrice      = 5600
		$this.SellPrice          = 2800
		$this.TargetStats        = @{ [StatId]::Defense = 112 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Hardened carapace provides exceptional defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEChitinPauldron : BEPauldron {
	BEChitinPauldron() : base() {
		$this.Name               = 'Chitin Pauldron'
		$this.MapObjName         = 'chitinpauldron'
		$this.PurchasePrice      = 5650
		$this.SellPrice          = 2825
		$this.TargetStats        = @{ [StatId]::Defense = 113 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Made from the exoskeleton of a giant insect, surprisingly durable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFeyPauldron : BEPauldron {
	BEFeyPauldron() : base() {
		$this.Name               = 'Fey Pauldron'
		$this.MapObjName         = 'feypauldron'
		$this.PurchasePrice      = 5700
		$this.SellPrice          = 2850
		$this.TargetStats        = @{ [StatId]::Defense = 114; [StatId]::MagicDefense = 43 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Woven from moonlight and forest magic, offering subtle protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEElvenPauldron : BEPauldron {
	BEElvenPauldron() : base() {
		$this.Name               = 'Elven Pauldron'
		$this.MapObjName         = 'elvenpauldron'
		$this.PurchasePrice      = 5750
		$this.SellPrice          = 2875
		$this.TargetStats        = @{ [StatId]::Defense = 115 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Graceful and light, crafted with ancient elven techniques.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDrowPauldron : BEPauldron {
	BEDrowPauldron() : base() {
		$this.Name               = 'Drow Pauldron'
		$this.MapObjName         = 'drowpauldron'
		$this.PurchasePrice      = 5800
		$this.SellPrice          = 2900
		$this.TargetStats        = @{ [StatId]::Defense = 116 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Dark and menacing, crafted by the drow of the underworld.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGnomishPauldron : BEPauldron {
	BEGnomishPauldron() : base() {
		$this.Name               = 'Gnomish Pauldron'
		$this.MapObjName         = 'gnomishpauldron'
		$this.PurchasePrice      = 5850
		$this.SellPrice          = 2925
		$this.TargetStats        = @{ [StatId]::Defense = 117 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Ingeniously crafted with hidden compartments and mechanisms.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGoblinPauldron : BEPauldron {
	BEGoblinPauldron() : base() {
		$this.Name               = 'Goblin Pauldron'
		$this.MapObjName         = 'goblinpauldron'
		$this.PurchasePrice      = 5900
		$this.SellPrice          = 2950
		$this.TargetStats        = @{ [StatId]::Defense = 118 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crudely assembled but surprisingly effective in a pinch.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOrcPauldron : BEPauldron {
	BEOrcPauldron() : base() {
		$this.Name               = 'Orc Pauldron'
		$this.MapObjName         = 'orcpauldron'
		$this.PurchasePrice      = 5950
		$this.SellPrice          = 2975
		$this.TargetStats        = @{ [StatId]::Defense = 119 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy and brutal, designed for sheer destructive power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEGiantPauldron : BEPauldron {
	BEGiantPauldron() : base() {
		$this.Name               = 'Giant Pauldron'
		$this.MapObjName         = 'giantpauldron'
		$this.PurchasePrice      = 6000
		$this.SellPrice          = 3000
		$this.TargetStats        = @{ [StatId]::Defense = 120 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Scaled for immense warriors, offering formidable defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEDemonPauldron : BEPauldron {
	BEDemonPauldron() : base() {
		$this.Name               = 'Demon Pauldron'
		$this.MapObjName         = 'demonpauldron'
		$this.PurchasePrice      = 6050
		$this.SellPrice          = 3025
		$this.TargetStats        = @{ [StatId]::Defense = 121; [StatId]::MagicDefense = 44 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Forged in the depths of hell, imbued with dark, corrupting power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDevilPauldron : BEPauldron {
	BEDevilPauldron() : base() {
		$this.Name               = 'Devil Pauldron'
		$this.MapObjName         = 'devilpauldron'
		$this.PurchasePrice      = 6100
		$this.SellPrice          = 3050
		$this.TargetStats        = @{ [StatId]::Defense = 122; [StatId]::MagicDefense = 45 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A relic of immense evil, granting unholy strength.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAngelPauldron : BEPauldron {
	BEAngelPauldron() : base() {
		$this.Name               = 'Angel Pauldron'
		$this.MapObjName         = 'angelpauldron'
		$this.PurchasePrice      = 6150
		$this.SellPrice          = 3075
		$this.TargetStats        = @{ [StatId]::Defense = 123; [StatId]::MagicDefense = 46 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Shines with divine light, warding off all evil and healing wounds.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECherubPauldron : BEPauldron {
	BECherubPauldron() : base() {
		$this.Name               = 'Cherub Pauldron'
		$this.MapObjName         = 'cherubpauldron'
		$this.PurchasePrice      = 6200
		$this.SellPrice          = 3100
		$this.TargetStats        = @{ [StatId]::Defense = 124; [StatId]::MagicDefense = 47 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light and angelic, bestowing blessings upon its wearer.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESeraphPauldron : BEPauldron {
	BESeraphPauldron() : base() {
		$this.Name               = 'Seraph Pauldron'
		$this.MapObjName         = 'seraphpauldron'
		$this.PurchasePrice      = 6250
		$this.SellPrice          = 3125
		$this.TargetStats        = @{ [StatId]::Defense = 125; [StatId]::MagicDefense = 48 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pauldron of the highest angels, granting incredible divine power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDivinePauldron : BEPauldron {
	BEDivinePauldron() : base() {
		$this.Name               = 'Divine Pauldron'
		$this.MapObjName         = 'divinepauldron'
		$this.PurchasePrice      = 6300
		$this.SellPrice          = 3150
		$this.TargetStats        = @{ [StatId]::Defense = 126; [StatId]::MagicDefense = 49 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Imbued with the essence of a god, granting ultimate protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAegisPauldron : BEPauldron {
	BEAegisPauldron() : base() {
		$this.Name               = 'Aegis Pauldron'
		$this.MapObjName         = 'aegispauldron'
		$this.PurchasePrice      = 6350
		$this.SellPrice          = 3175
		$this.TargetStats        = @{ [StatId]::Defense = 127; [StatId]::MagicDefense = 50 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A legendary shield, offering unparalleled defense against all threats.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAdamantinePauldron : BEPauldron {
	BEAdamantinePauldron() : base() {
		$this.Name               = 'Adamantine Pauldron'
		$this.MapObjName         = 'adamantinepauldron'
		$this.PurchasePrice      = 6400
		$this.SellPrice          = 3200
		$this.TargetStats        = @{ [StatId]::Defense = 128 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'One of the strongest materials known, virtually indestructible.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOrichalcumPauldron : BEPauldron {
	BEOrichalcumPauldron() : base() {
		$this.Name               = 'Orichalcum Pauldron'
		$this.MapObjName         = 'orichalcumpauldron'
		$this.PurchasePrice      = 6450
		$this.SellPrice          = 3225
		$this.TargetStats        = @{ [StatId]::Defense = 129; [StatId]::MagicDefense = 51 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A mythical metal, offering incredible magical resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEtheriumPauldron : BEPauldron {
	BEEtheriumPauldron() : base() {
		$this.Name               = 'Etherium Pauldron'
		$this.MapObjName         = 'etheriumpauldron'
		$this.PurchasePrice      = 6500
		$this.SellPrice          = 3250
		$this.TargetStats        = @{ [StatId]::Defense = 130; [StatId]::MagicDefense = 52 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Woven from pure magical energy, incredibly light and potent.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVoidweavePauldron : BEPauldron {
	BEVoidweavePauldron() : base() {
		$this.Name               = 'Voidweave Pauldron'
		$this.MapObjName         = 'voidweavepauldron'
		$this.PurchasePrice      = 6550
		$this.SellPrice          = 3275
		$this.TargetStats        = @{ [StatId]::Defense = 131; [StatId]::MagicDefense = 53 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crafted from the threads of nothingness, absorbing all magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETimelessPauldron : BEPauldron {
	BETimelessPauldron() : base() {
		$this.Name               = 'Timeless Pauldron'
		$this.MapObjName         = 'timelesspauldron'
		$this.PurchasePrice      = 6600
		$this.SellPrice          = 3300
		$this.TargetStats        = @{ [StatId]::Defense = 132 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Unaffected by the flow of time, granting immense durability.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEInfinityPauldron : BEPauldron {
	BEInfinityPauldron() : base() {
		$this.Name               = 'Infinity Pauldron'
		$this.MapObjName         = 'infinitypauldron'
		$this.PurchasePrice      = 6650
		$this.SellPrice          = 3325
		$this.TargetStats        = @{ [StatId]::Defense = 133; [StatId]::MagicDefense = 54 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Embodies infinite possibilities, granting varied resistances.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECosmicForgePauldron : BEPauldron {
	BECosmicForgePauldron() : base() {
		$this.Name               = 'Cosmic Forge Pauldron'
		$this.MapObjName         = 'cosmicforgepauldron'
		$this.PurchasePrice      = 6700
		$this.SellPrice          = 3350
		$this.TargetStats        = @{ [StatId]::Defense = 134; [StatId]::MagicDefense = 55 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Forged at the birth of the universe, incredibly powerful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGenesisPauldron : BEPauldron {
	BEGenesisPauldron() : base() {
		$this.Name               = 'Genesis Pauldron'
		$this.MapObjName         = 'genesispauldron'
		$this.PurchasePrice      = 6750
		$this.SellPrice          = 3375
		$this.TargetStats        = @{ [StatId]::Defense = 135; [StatId]::MagicDefense = 56 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pauldron of creation, capable of altering reality.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEApocalypsePauldron : BEPauldron {
	BEApocalypsePauldron() : base() {
		$this.Name               = 'Apocalypse Pauldron'
		$this.MapObjName         = 'apocalypsepauldron'
		$this.PurchasePrice      = 6800
		$this.SellPrice          = 3400
		$this.TargetStats        = @{ [StatId]::Defense = 136; [StatId]::MagicDefense = 57 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn during the end of times, immense destructive resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOblivionPauldron : BEPauldron {
	BEOblivionPauldron() : base() {
		$this.Name               = 'Oblivion Pauldron'
		$this.MapObjName         = 'oblivionpauldron'
		$this.PurchasePrice      = 6850
		$this.SellPrice          = 3425
		$this.TargetStats        = @{ [StatId]::Defense = 137; [StatId]::MagicDefense = 58 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Drifts from beyond existence, absorbing all it touches.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESingularityPauldron : BEPauldron {
	BESingularityPauldron() : base() {
		$this.Name               = 'Singularity Pauldron'
		$this.MapObjName         = 'singularitypauldron'
		$this.PurchasePrice      = 6900
		$this.SellPrice          = 3450
		$this.TargetStats        = @{ [StatId]::Defense = 138; [StatId]::MagicDefense = 59 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Contains the power of a collapsing star, incredibly potent.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEParadoxPauldron : BEPauldron {
	BEParadoxPauldron() : base() {
		$this.Name               = 'Paradox Pauldron'
		$this.MapObjName         = 'paradoxpauldron'
		$this.PurchasePrice      = 6950
		$this.SellPrice          = 3475
		$this.TargetStats        = @{ [StatId]::Defense = 139; [StatId]::MagicDefense = 60 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Defies the laws of physics, offering unpredictable defensive effects.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERunicKnightPauldron : BEPauldron {
	BERunicKnightPauldron() : base() {
		$this.Name               = 'Runic Knight Pauldron'
		$this.MapObjName         = 'runicknightpauldron'
		$this.PurchasePrice      = 7000
		$this.SellPrice          = 3500
		$this.TargetStats        = @{ [StatId]::Defense = 140; [StatId]::MagicDefense = 61 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Covered in ancient runes, granting both physical and magical defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEBattleMagePauldron : BEPauldron {
	BEBattleMagePauldron() : base() {
		$this.Name               = 'Battle Mage Pauldron'
		$this.MapObjName         = 'battlemagepauldron'
		$this.PurchasePrice      = 7050
		$this.SellPrice          = 3525
		$this.TargetStats        = @{ [StatId]::Defense = 141; [StatId]::MagicDefense = 62 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Allows full mobility for spellcasting while offering protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEArcaneWarriorPauldron : BEPauldron {
	BEArcaneWarriorPauldron() : base() {
		$this.Name               = 'Arcane Warrior Pauldron'
		$this.MapObjName         = 'arcanewarriorpauldron'
		$this.PurchasePrice      = 7100
		$this.SellPrice          = 3550
		$this.TargetStats        = @{ [StatId]::Defense = 142; [StatId]::MagicDefense = 63 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Blends magical and physical defense, for versatile fighters.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESpellbladePauldron : BEPauldron {
	BESpellbladePauldron() : base() {
		$this.Name               = 'Spellblade Pauldron'
		$this.MapObjName         = 'spellbladepauldron'
		$this.PurchasePrice      = 7150
		$this.SellPrice          = 3575
		$this.TargetStats        = @{ [StatId]::Defense = 143; [StatId]::MagicDefense = 64 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Enhances both swordplay and spellcasting defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWitchHunterPauldron : BEPauldron {
	BEWitchHunterPauldron() : base() {
		$this.Name               = 'Witch Hunter Pauldron'
		$this.MapObjName         = 'witchhunterpauldron'
		$this.PurchasePrice      = 7200
		$this.SellPrice          = 3600
		$this.TargetStats        = @{ [StatId]::Defense = 144; [StatId]::MagicDefense = 65 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Specifically designed to combat magic users, with innate resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEInquisitorPauldron : BEPauldron {
	BEInquisitorPauldron() : base() {
		$this.Name               = 'Inquisitor Pauldron'
		$this.MapObjName         = 'inquisitorpauldron'
		$this.PurchasePrice      = 7250
		$this.SellPrice          = 3625
		$this.TargetStats        = @{ [StatId]::Defense = 145; [StatId]::MagicDefense = 66 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by those who seek out and destroy evil, often associated with divine power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEExorcistPauldron : BEPauldron {
	BEExorcistPauldron() : base() {
		$this.Name               = 'Exorcist Pauldron'
		$this.MapObjName         = 'exorcistpauldron'
		$this.PurchasePrice      = 7300
		$this.SellPrice          = 3650
		$this.TargetStats        = @{ [StatId]::Defense = 146; [StatId]::MagicDefense = 67 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Designed to ward off demonic entities and evil spirits.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BETemplarPauldron : BEPauldron {
	BETemplarPauldron() : base() {
		$this.Name               = 'Templar Pauldron'
		$this.MapObjName         = 'templarpauldron'
		$this.PurchasePrice      = 7350
		$this.SellPrice          = 3675
		$this.TargetStats        = @{ [StatId]::Defense = 147; [StatId]::MagicDefense = 68 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A symbol of unwavering faith and military might.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEOraclePauldron : BEPauldron {
	BEOraclePauldron() : base() {
		$this.Name               = 'Oracle Pauldron'
		$this.MapObjName         = 'oraclepauldron'
		$this.PurchasePrice      = 7400
		$this.SellPrice          = 3700
		$this.TargetStats        = @{ [StatId]::Defense = 148; [StatId]::MagicDefense = 69 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Allows glimpses into the future, enhancing foresight and wisdom.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESeerPauldron : BEPauldron {
	BESeerPauldron() : base() {
		$this.Name               = 'Seer Pauldron'
		$this.MapObjName         = 'seerpauldron'
		$this.PurchasePrice      = 7450
		$this.SellPrice          = 3725
		$this.TargetStats        = @{ [StatId]::Defense = 149; [StatId]::MagicDefense = 70 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Enhances perception and allows for detection of hidden truths.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEProphetPauldron : BEPauldron {
	BEProphetPauldron() : base() {
		$this.Name               = 'Prophet Pauldron'
		$this.MapObjName         = 'prophetpauldron'
		$this.PurchasePrice      = 7500
		$this.SellPrice          = 3750
		$this.TargetStats        = @{ [StatId]::Defense = 150; [StatId]::MagicDefense = 71 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by those who deliver divine messages, granting profound insight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVisionaryPauldron : BEPauldron {
	BEVisionaryPauldron() : base() {
		$this.Name               = 'Visionary Pauldron'
		$this.MapObjName         = 'visionarypauldron'
		$this.PurchasePrice      = 7550
		$this.SellPrice          = 3775
		$this.TargetStats        = @{ [StatId]::Defense = 151; [StatId]::MagicDefense = 72 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Inspires allies and reveals weaknesses in enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDreamersPauldron : BEPauldron {
	BEDreamersPauldron() : base() {
		$this.Name               = 'Dreamer''s Pauldron'
		$this.MapObjName         = 'dreamerspauldron'
		$this.PurchasePrice      = 7600
		$this.SellPrice          = 3800
		$this.TargetStats        = @{ [StatId]::Defense = 152; [StatId]::MagicDefense = 73 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Allows one to traverse dreams and access subconscious powers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMindWeaverPauldron : BEPauldron {
	BEMindWeaverPauldron() : base() {
		$this.Name               = 'Mind Weaver Pauldron'
		$this.MapObjName         = 'mindweaverpauldron'
		$this.PurchasePrice      = 7650
		$this.SellPrice          = 3825
		$this.TargetStats        = @{ [StatId]::Defense = 153; [StatId]::MagicDefense = 74 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Allows for subtle manipulation of thoughts and emotions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETelepathPauldron : BEPauldron {
	BETelepathPauldron() : base() {
		$this.Name               = 'Telepath Pauldron'
		$this.MapObjName         = 'telepathpauldron'
		$this.PurchasePrice      = 7700
		$this.SellPrice          = 3850
		$this.TargetStats        = @{ [StatId]::Defense = 154; [StatId]::MagicDefense = 75 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Grants the power of telepathy, for mental communication.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEIllusionistPauldron : BEPauldron {
	BEIllusionistPauldron() : base() {
		$this.Name               = 'Illusionist Pauldron'
		$this.MapObjName         = 'illusionistpauldron'
		$this.PurchasePrice      = 7750
		$this.SellPrice          = 3875
		$this.TargetStats        = @{ [StatId]::Defense = 155; [StatId]::MagicDefense = 76 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Creates convincing illusions and disorients foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETricksterPauldron : BEPauldron {
	BETricksterPauldron() : base() {
		$this.Name               = 'Trickster Pauldron'
		$this.MapObjName         = 'tricksterpauldron'
		$this.PurchasePrice      = 7800
		$this.SellPrice          = 3900
		$this.TargetStats        = @{ [StatId]::Defense = 156 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Allows for agile evasions and cunning deceptions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEJesterPauldron : BEPauldron {
	BEJesterPauldron() : base() {
		$this.Name               = 'Jester Pauldron'
		$this.MapObjName         = 'jesterpauldron'
		$this.PurchasePrice      = 7850
		$this.SellPrice          = 3925
		$this.TargetStats        = @{ [StatId]::Defense = 157; [StatId]::MagicDefense = 77 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Provides unexpected defenses and chaotic effects.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBardPauldron : BEPauldron {
	BEBardPauldron() : base() {
		$this.Name               = 'Bard Pauldron'
		$this.MapObjName         = 'bardpauldron'
		$this.PurchasePrice      = 7900
		$this.SellPrice          = 3950
		$this.TargetStats        = @{ [StatId]::Defense = 158; [StatId]::MagicDefense = 78 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Inspires allies and demoralizes enemies through song.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDancersPauldron : BEPauldron {
	BEDancersPauldron() : base() {
		$this.Name               = 'Dancer''s Pauldron'
		$this.MapObjName         = 'dancerspauldron'
		$this.PurchasePrice      = 7950
		$this.SellPrice          = 3975
		$this.TargetStats        = @{ [StatId]::Defense = 159 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light and flexible, allowing for graceful movement and evasion.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEAcrobatPauldron : BEPauldron {
	BEAcrobatPauldron() : base() {
		$this.Name               = 'Acrobat Pauldron'
		$this.MapObjName         = 'acrobatpauldron'
		$this.PurchasePrice      = 8000
		$this.SellPrice          = 4000
		$this.TargetStats        = @{ [StatId]::Defense = 160 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Provides protection without hindering agility and balance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGymnastPauldron : BEPauldron {
	BEGymnastPauldron() : base() {
		$this.Name               = 'Gymnast Pauldron'
		$this.MapObjName         = 'gymnastpauldron'
		$this.PurchasePrice      = 8050
		$this.SellPrice          = 4025
		$this.TargetStats        = @{ [StatId]::Defense = 161 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Lightweight and ergonomic, for maximum flexibility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDuelistPauldron : BEPauldron {
	BEDuelistPauldron() : base() {
		$this.Name               = 'Duelist Pauldron'
		$this.MapObjName         = 'duelistpauldron'
		$this.PurchasePrice      = 8100
		$this.SellPrice          = 4050
		$this.TargetStats        = @{ [StatId]::Defense = 162 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Designed for swift, precise movements and countering.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEFencerPauldron : BEPauldron {
	BEFencerPauldron() : base() {
		$this.Name               = 'Fencer Pauldron'
		$this.MapObjName         = 'fencerpauldron'
		$this.PurchasePrice      = 8150
		$this.SellPrice          = 4075
		$this.TargetStats        = @{ [StatId]::Defense = 163 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light and unrestrictive, for rapid thrusts and parries.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESwashbucklerPauldron : BEPauldron {
	BESwashbucklerPauldron() : base() {
		$this.Name               = 'Swashbuckler Pauldron'
		$this.MapObjName         = 'swashbucklerpauldron'
		$this.PurchasePrice      = 8200
		$this.SellPrice          = 4100
		$this.TargetStats        = @{ [StatId]::Defense = 164 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Stylish yet practical, for those who fight with flair.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEGladiatorPauldron : BEPauldron {
	BEGladiatorPauldron() : base() {
		$this.Name               = 'Gladiator Pauldron'
		$this.MapObjName         = 'gladiatorpauldron'
		$this.PurchasePrice      = 8250
		$this.SellPrice          = 4125
		$this.TargetStats        = @{ [StatId]::Defense = 165 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Built for the arena, offering robust protection and intimidation.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEBerserkerPauldron : BEPauldron {
	BEBerserkerPauldron() : base() {
		$this.Name               = 'Berserker Pauldron'
		$this.MapObjName         = 'berserkerpauldron'
		$this.PurchasePrice      = 8300
		$this.SellPrice          = 4150
		$this.TargetStats        = @{ [StatId]::Defense = 166 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Infuses its wearer with uncontrolled rage, boosting defense at a cost.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEBrutePauldron : BEPauldron {
	BEBrutePauldron() : base() {
		$this.Name               = 'Brute Pauldron'
		$this.MapObjName         = 'brutepauldron'
		$this.PurchasePrice      = 8350
		$this.SellPrice          = 4175
		$this.TargetStats        = @{ [StatId]::Defense = 167 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy and unforgiving, for overwhelming opponents with raw strength.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESavagePauldron : BEPauldron {
	BESavagePauldron() : base() {
		$this.Name               = 'Savage Pauldron'
		$this.MapObjName         = 'savagepauldron'
		$this.PurchasePrice      = 8400
		$this.SellPrice          = 4200
		$this.TargetStats        = @{ [StatId]::Defense = 168 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Made from raw materials, for those who embrace primal combat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBarbarianPauldron : BEPauldron {
	BEBarbarianPauldron() : base() {
		$this.Name               = 'Barbarian Pauldron'
		$this.MapObjName         = 'barbarianpauldron'
		$this.PurchasePrice      = 8450
		$this.SellPrice          = 4225
		$this.TargetStats        = @{ [StatId]::Defense = 169 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Minimal but effective, allowing for swift, powerful strikes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BENomadicWarlordPauldron : BEPauldron {
	BENomadicWarlordPauldron() : base() {
		$this.Name               = 'Nomadic Warlord Pauldron'
		$this.MapObjName         = 'nomadicwarlordpauldron'
		$this.PurchasePrice      = 8500
		$this.SellPrice          = 4250
		$this.TargetStats        = @{ [StatId]::Defense = 170 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Combines mobility with imposing presence, for fierce tribal leaders.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEDesertTyrantPauldron : BEPauldron {
	BEDesertTyrantPauldron() : base() {
		$this.Name               = 'Desert Tyrant Pauldron'
		$this.MapObjName         = 'deserttyrantpauldron'
		$this.PurchasePrice      = 8550
		$this.SellPrice          = 4275
		$this.TargetStats        = @{ [StatId]::Defense = 171 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by rulers of arid lands, exuding oppressive power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEJungleHunterPauldron : BEPauldron {
	BEJungleHunterPauldron() : base() {
		$this.Name               = 'Jungle Hunter Pauldron'
		$this.MapObjName         = 'junglehunterpauldron'
		$this.PurchasePrice      = 8600
		$this.SellPrice          = 4300
		$this.TargetStats        = @{ [StatId]::Defense = 172 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Blends seamlessly with dense foliage, aiding ambushes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEForestProtectorPauldron : BEPauldron {
	BEForestProtectorPauldron() : base() {
		$this.Name               = 'Forest Protector Pauldron'
		$this.MapObjName         = 'forestprotectorpauldron'
		$this.PurchasePrice      = 8650
		$this.SellPrice          = 4325
		$this.TargetStats        = @{ [StatId]::Defense = 173 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Offers defense while allowing swift movement through woodlands.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEIceWardenPauldron : BEPauldron {
	BEIceWardenPauldron() : base() {
		$this.Name               = 'Ice Warden Pauldron'
		$this.MapObjName         = 'icewardenpauldron'
		$this.PurchasePrice      = 8700
		$this.SellPrice          = 4350
		$this.TargetStats        = @{ [StatId]::Defense = 174; [StatId]::MagicDefense = 79 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Wards off the bitter cold and enhances ice-based defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMountainKingPauldron : BEPauldron {
	BEMountainKingPauldron() : base() {
		$this.Name               = 'Mountain King Pauldron'
		$this.MapObjName         = 'mountainkingpauldron'
		$this.PurchasePrice      = 8750
		$this.SellPrice          = 4375
		$this.TargetStats        = @{ [StatId]::Defense = 175 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by dwarven royalty, imbued with the strength of the mountains.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESeaCaptainPauldron : BEPauldron {
	BESeaCaptainPauldron() : base() {
		$this.Name               = 'Sea Captain Pauldron'
		$this.MapObjName         = 'seacaptainpauldron'
		$this.PurchasePrice      = 8800
		$this.SellPrice          = 4400
		$this.TargetStats        = @{ [StatId]::Defense = 176 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Durable and water-resistant, for those who command the seas.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESkySovereignPauldron : BEPauldron {
	BESkySovereignPauldron() : base() {
		$this.Name               = 'Sky Sovereign Pauldron'
		$this.MapObjName         = 'skysovereignpauldron'
		$this.PurchasePrice      = 8850
		$this.SellPrice          = 4425
		$this.TargetStats        = @{ [StatId]::Defense = 177; [StatId]::MagicDefense = 80 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Allows effortless flight and control over aerial forces.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEUrbanRangerPauldron : BEPauldron {
	BEUrbanRangerPauldron() : base() {
		$this.Name               = 'Urban Ranger Pauldron'
		$this.MapObjName         = 'urbanrangerpauldron'
		$this.PurchasePrice      = 8900
		$this.SellPrice          = 4450
		$this.TargetStats        = @{ [StatId]::Defense = 178 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Blends into city environments, aiding stealth and surveillance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWastelandScavengerPauldron : BEPauldron {
	BEWastelandScavengerPauldron() : base() {
		$this.Name               = 'Wasteland Scavenger Pauldron'
		$this.MapObjName         = 'wastelandscavengerpauldron'
		$this.PurchasePrice      = 8950
		$this.SellPrice          = 4475
		$this.TargetStats        = @{ [StatId]::Defense = 179 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Patchwork but resilient, for surviving harsh, desolate lands.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPilgrimsPauldron : BEPauldron {
	BEPilgrimsPauldron() : base() {
		$this.Name               = 'Pilgrim''s Pauldron'
		$this.MapObjName         = 'pilgrimspauldron'
		$this.PurchasePrice      = 9000
		$this.SellPrice          = 4500
		$this.TargetStats        = @{ [StatId]::Defense = 180 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Simple yet enduring, for those on sacred journeys.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAsceticPauldron : BEPauldron {
	BEAsceticPauldron() : base() {
		$this.Name               = 'Ascetic Pauldron'
		$this.MapObjName         = 'asceticpauldron'
		$this.PurchasePrice      = 9050
		$this.SellPrice          = 4525
		$this.TargetStats        = @{ [StatId]::Defense = 181 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Minimizes distractions, allowing for heightened focus and discipline.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHermitsPauldron : BEPauldron {
	BEHermitsPauldron() : base() {
		$this.Name               = 'Hermit''s Pauldron'
		$this.MapObjName         = 'hermitspauldron'
		$this.PurchasePrice      = 9100
		$this.SellPrice          = 4550
		$this.TargetStats        = @{ [StatId]::Defense = 182; [StatId]::MagicDefense = 81 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by reclusive sages, offering subtle, ancient protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMonkPauldron : BEPauldron {
	BEMonkPauldron() : base() {
		$this.Name               = 'Monk Pauldron'
		$this.MapObjName         = 'monkpauldron'
		$this.PurchasePrice      = 9150
		$this.SellPrice          = 4575
		$this.TargetStats        = @{ [StatId]::Defense = 183; [StatId]::MagicDefense = 82 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Allows for agile, unarmed combat while offering spiritual defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEZenMasterPauldron : BEPauldron {
	BEZenMasterPauldron() : base() {
		$this.Name               = 'Zen Master Pauldron'
		$this.MapObjName         = 'zenmasterpauldron'
		$this.PurchasePrice      = 9200
		$this.SellPrice          = 4600
		$this.TargetStats        = @{ [StatId]::Defense = 184; [StatId]::MagicDefense = 83 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Channels inner peace into powerful, disciplined defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESamuraiPauldron : BEPauldron {
	BESamuraiPauldron() : base() {
		$this.Name               = 'Samurai Pauldron'
		$this.MapObjName         = 'samuraipauldron'
		$this.PurchasePrice      = 9250
		$this.SellPrice          = 4625
		$this.TargetStats        = @{ [StatId]::Defense = 185 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Refined and honorable, offering balanced defense and attack.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BENinjaPauldron : BEPauldron {
	BENinjaPauldron() : base() {
		$this.Name               = 'Ninja Pauldron'
		$this.MapObjName         = 'ninjapauldron'
		$this.PurchasePrice      = 9300
		$this.SellPrice          = 4650
		$this.TargetStats        = @{ [StatId]::Defense = 186 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light and stealthy, designed for silent infiltration and swift strikes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEKunoichiPauldron : BEPauldron {
	BEKunoichiPauldron() : base() {
		$this.Name               = 'Kunoichi Pauldron'
		$this.MapObjName         = 'kunoichipauldron'
		$this.PurchasePrice      = 9350
		$this.SellPrice          = 4675
		$this.TargetStats        = @{ [StatId]::Defense = 187 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Allows for incredibly agile and precise movements in combat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BERoninPauldron : BEPauldron {
	BERoninPauldron() : base() {
		$this.Name               = 'Ronin Pauldron'
		$this.MapObjName         = 'roninpauldron'
		$this.PurchasePrice      = 9400
		$this.SellPrice          = 4700
		$this.TargetStats        = @{ [StatId]::Defense = 188 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by masterless warriors, showing signs of many battles.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEShogunPauldron : BEPauldron {
	BEShogunPauldron() : base() {
		$this.Name               = 'Shogun Pauldron'
		$this.MapObjName         = 'shogunpauldron'
		$this.PurchasePrice      = 9450
		$this.SellPrice          = 4725
		$this.TargetStats        = @{ [StatId]::Defense = 189 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A symbol of ultimate military authority and power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEEmperorsPauldron : BEPauldron {
	BEEmperorsPauldron() : base() {
		$this.Name               = 'Emperor''s Pauldron'
		$this.MapObjName         = 'emperorspauldron'
		$this.PurchasePrice      = 9500
		$this.SellPrice          = 4750
		$this.TargetStats        = @{ [StatId]::Defense = 190 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Fit for a true ruler, bestowing regal authority and immense protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEEmpresssPauldron : BEPauldron {
	BEEmpresssPauldron() : base() {
		$this.Name               = 'Empress''s Pauldron'
		$this.MapObjName         = 'empressspauldron'
		$this.PurchasePrice      = 9550
		$this.SellPrice          = 4775
		$this.TargetStats        = @{ [StatId]::Defense = 191 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Elegant and formidable, worn by powerful female monarchs.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEScholarPauldron : BEPauldron {
	BEScholarPauldron() : base() {
		$this.Name               = 'Scholar Pauldron'
		$this.MapObjName         = 'scholarpauldron'
		$this.PurchasePrice      = 9600
		$this.SellPrice          = 4800
		$this.TargetStats        = @{ [StatId]::Defense = 192; [StatId]::MagicDefense = 84 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Enhances knowledge and understanding, aiding in magical research.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEArchivistPauldron : BEPauldron {
	BEArchivistPauldron() : base() {
		$this.Name               = 'Archivist Pauldron'
		$this.MapObjName         = 'archivistpauldron'
		$this.PurchasePrice      = 9650
		$this.SellPrice          = 4825
		$this.TargetStats        = @{ [StatId]::Defense = 193; [StatId]::MagicDefense = 85 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Protects ancient knowledge and grants access to forgotten lore.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELibrarianPauldron : BEPauldron {
	BELibrarianPauldron() : base() {
		$this.Name               = 'Librarian Pauldron'
		$this.MapObjName         = 'librarianpauldron'
		$this.PurchasePrice      = 9700
		$this.SellPrice          = 4850
		$this.TargetStats        = @{ [StatId]::Defense = 194; [StatId]::MagicDefense = 86 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Allows for quick access to vast amounts of information.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECuratorPauldron : BEPauldron {
	BECuratorPauldron() : base() {
		$this.Name               = 'Curator Pauldron'
		$this.MapObjName         = 'curatorpauldron'
		$this.PurchasePrice      = 9750
		$this.SellPrice          = 4875
		$this.TargetStats        = @{ [StatId]::Defense = 195; [StatId]::MagicDefense = 87 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Preserves precious artifacts and enhances identification abilities.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHistorianPauldron : BEPauldron {
	BEHistorianPauldron() : base() {
		$this.Name               = 'Historian Pauldron'
		$this.MapObjName         = 'historianpauldron'
		$this.PurchasePrice      = 9800
		$this.SellPrice          = 4900
		$this.TargetStats        = @{ [StatId]::Defense = 196; [StatId]::MagicDefense = 88 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Grants insight into the past, revealing hidden truths.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDiplomatPauldron : BEPauldron {
	BEDiplomatPauldron() : base() {
		$this.Name               = 'Diplomat Pauldron'
		$this.MapObjName         = 'diplomatpauldron'
		$this.PurchasePrice      = 9850
		$this.SellPrice          = 4925
		$this.TargetStats        = @{ [StatId]::Defense = 197 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Enhances charisma and negotiation skills, aiding in peaceful resolutions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMediatorPauldron : BEPauldron {
	BEMediatorPauldron() : base() {
		$this.Name               = 'Mediator Pauldron'
		$this.MapObjName         = 'mediatorpauldron'
		$this.PurchasePrice      = 9900
		$this.SellPrice          = 4950
		$this.TargetStats        = @{ [StatId]::Defense = 198 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Promotes understanding and de-escalation in conflicts.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPeacemakerPauldron : BEPauldron {
	BEPeacemakerPauldron() : base() {
		$this.Name               = 'Peacemaker Pauldron'
		$this.MapObjName         = 'peacemakerpauldron'
		$this.PurchasePrice      = 9950
		$this.SellPrice          = 4975
		$this.TargetStats        = @{ [StatId]::Defense = 199 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A symbol of hope and unity, capable of calming volatile situations.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWardenofOrderPauldron : BEPauldron {
	BEWardenofOrderPauldron() : base() {
		$this.Name               = 'Warden of Order Pauldron'
		$this.MapObjName         = 'wardenoforderpauldron'
		$this.PurchasePrice      = 10000
		$this.SellPrice          = 5000
		$this.TargetStats        = @{ [StatId]::Defense = 200 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Upholds justice and maintains balance, with unwavering resolve.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEChaosBringerPauldron : BEPauldron {
	BEChaosBringerPauldron() : base() {
		$this.Name               = 'Chaos Bringer Pauldron'
		$this.MapObjName         = 'chaosbringerpauldron'
		$this.PurchasePrice      = 10050
		$this.SellPrice          = 5025
		$this.TargetStats        = @{ [StatId]::Defense = 201; [StatId]::MagicDefense = 89 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Embodies pure chaos, creating unpredictable and destructive effects.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

