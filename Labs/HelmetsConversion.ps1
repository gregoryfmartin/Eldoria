Class BELeatherCap : BEHelmet {
	BELeatherCap() : base() {
		$this.Name               = 'Leather Cap'
		$this.MapObjName         = 'leathercap'
		$this.PurchasePrice      = 50
		$this.SellPrice          = 25
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple cap made from hardened leather, offering basic protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEIronHelm : BEHelmet {
	BEIronHelm() : base() {
		$this.Name               = 'Iron Helm'
		$this.MapObjName         = 'ironhelm'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{
			[StatId]::Defense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sturdy iron helmet, common among foot soldiers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESteelHelmet : BEHelmet {
	BESteelHelmet() : base() {
		$this.Name               = 'Steel Helmet'
		$this.MapObjName         = 'steelhelmet'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Forged from resilient steel, providing superior defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMythrilCoif : BEHelmet {
	BEMythrilCoif() : base() {
		$this.Name               = 'Mythril Coif'
		$this.MapObjName         = 'mythrilcoif'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A lightweight and strong coif made from mythril, favored by adventurers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDragonhideHelm : BEHelmet {
	BEDragonhideHelm() : base() {
		$this.Name               = 'Dragonhide Helm'
		$this.MapObjName         = 'dragonhidehelm'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crafted from the scales of a dragon, offering exceptional protection against fire.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECrownofHeroes : BEHelmet {
	BECrownofHeroes() : base() {
		$this.Name               = 'Crown of Heroes'
		$this.MapObjName         = 'crownofheroes'
		$this.PurchasePrice      = 5000
		$this.SellPrice          = 2500
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A legendary crown worn by ancient heroes, said to inspire courage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERoyalCirclet : BEHelmet {
	BERoyalCirclet() : base() {
		$this.Name               = 'Royal Circlet'
		$this.MapObjName         = 'royalcirclet'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An elegant circlet adorned with jewels, worn by royalty.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEWarriorsGreathelm : BEHelmet {
	BEWarriorsGreathelm() : base() {
		$this.Name               = 'Warrior''s Greathelm'
		$this.MapObjName         = 'warriorsgreathelm'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy greathelm designed for powerful warriors, offering maximum frontal defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEArchersHood : BEHelmet {
	BEArchersHood() : base() {
		$this.Name               = 'Archer''s Hood'
		$this.MapObjName         = 'archershood'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light hood that provides camouflage and enhances an archer''s precision.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMagesHat : BEHelmet {
	BEMagesHat() : base() {
		$this.Name               = 'Mage''s Hat'
		$this.MapObjName         = 'mageshat'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pointed hat worn by mages, rumored to amplify magical energies.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHelmofWisdom : BEHelmet {
	BEHelmofWisdom() : base() {
		$this.Name               = 'Helm of Wisdom'
		$this.MapObjName         = 'helmofwisdom'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helmet imbued with ancient knowledge, boosting a mage''s intellect.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPaladinsHelm : BEHelmet {
	BEPaladinsHelm() : base() {
		$this.Name               = 'Paladin''s Helm'
		$this.MapObjName         = 'paladinshelm'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A gleaming helmet worn by holy warriors, radiating divine protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEDarkKnightsVisor : BEHelmet {
	BEDarkKnightsVisor() : base() {
		$this.Name               = 'Dark Knight''s Visor'
		$this.MapObjName         = 'darkknightsvisor'
		$this.PurchasePrice      = 1750
		$this.SellPrice          = 875
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A menacing visor worn by dark knights, instilling fear in enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEThiefsBandana : BEHelmet {
	BEThiefsBandana() : base() {
		$this.Name               = 'Thief''s Bandana'
		$this.MapObjName         = 'thiefsbandana'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A discreet bandana that aids stealth and agility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAssassinsCowl : BEHelmet {
	BEAssassinsCowl() : base() {
		$this.Name               = 'Assassin''s Cowl'
		$this.MapObjName         = 'assassinscowl'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark cowl that grants the wearer enhanced senses and deadly precision.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHuntersCap : BEHelmet {
	BEHuntersCap() : base() {
		$this.Name               = 'Hunter''s Cap'
		$this.MapObjName         = 'hunterscap'
		$this.PurchasePrice      = 110
		$this.SellPrice          = 55
		$this.TargetStats        = @{
			[StatId]::Defense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A practical cap for hunters, designed for wilderness survival.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBerserkersHeadpiece : BEHelmet {
	BEBerserkersHeadpiece() : base() {
		$this.Name               = 'Berserker''s Headpiece'
		$this.MapObjName         = 'berserkersheadpiece'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::Defense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A brutal headpiece that amplifies a warrior''s raw strength.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEGuardiansHelm : BEHelmet {
	BEGuardiansHelm() : base() {
		$this.Name               = 'Guardian''s Helm'
		$this.MapObjName         = 'guardianshelm'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy, defensive helmet worn by guardians, deflecting blows.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHealersTiara : BEHelmet {
	BEHealersTiara() : base() {
		$this.Name               = 'Healer''s Tiara'
		$this.MapObjName         = 'healerstiara'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A delicate tiara that enhances healing spells and provides comfort.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEScholarsMortarboard : BEHelmet {
	BEScholarsMortarboard() : base() {
		$this.Name               = 'Scholar''s Mortarboard'
		$this.MapObjName         = 'scholarsmortarboard'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A traditional academic hat, said to improve focus and memory.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGladiatorsHelmet : BEHelmet {
	BEGladiatorsHelmet() : base() {
		$this.Name               = 'Gladiator''s Helmet'
		$this.MapObjName         = 'gladiatorshelmet'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A fearsome helmet worn by gladiators, designed for arena combat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESorceresssVeil : BEHelmet {
	BESorceresssVeil() : base() {
		$this.Name               = 'Sorceress''s Veil'
		$this.MapObjName         = 'sorceresssveil'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A mysterious veil that conceals the wearer''s identity and enhances dark magic.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BECrusadersHelm : BEHelmet {
	BECrusadersHelm() : base() {
		$this.Name               = 'Crusader''s Helm'
		$this.MapObjName         = 'crusadershelm'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cross-emblazoned helm worn by crusaders, symbolizing faith and might.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEBarbariansSkullcap : BEHelmet {
	BEBarbariansSkullcap() : base() {
		$this.Name               = 'Barbarian''s Skullcap'
		$this.MapObjName         = 'barbariansskullcap'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::Defense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crude skullcap fashioned from animal hide, favored by fierce barbarians.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEKnightsBascinet : BEHelmet {
	BEKnightsBascinet() : base() {
		$this.Name               = 'Knight''s Bascinet'
		$this.MapObjName         = 'knightsbascinet'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A classic knight''s helmet with a pointed visor, offering good protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEEnchantersHood : BEHelmet {
	BEEnchantersHood() : base() {
		$this.Name               = 'Enchanter''s Hood'
		$this.MapObjName         = 'enchantershood'
		$this.PurchasePrice      = 130
		$this.SellPrice          = 65
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A mystical hood that aids in the art of enchantment.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVikingsHelmet : BEHelmet {
	BEVikingsHelmet() : base() {
		$this.Name               = 'Viking''s Helmet'
		$this.MapObjName         = 'vikingshelmet'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 11
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A horned helmet worn by fierce Viking warriors, inspiring dread.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDruidsCirclet : BEHelmet {
	BEDruidsCirclet() : base() {
		$this.Name               = 'Druid''s Circlet'
		$this.MapObjName         = 'druidscirclet'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A nature-infused circlet that boosts connection to the earth''s magic.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEScoutsHat : BEHelmet {
	BEScoutsHat() : base() {
		$this.Name               = 'Scout''s Hat'
		$this.MapObjName         = 'scoutshat'
		$this.PurchasePrice      = 60
		$this.SellPrice          = 30
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A lightweight hat for scouts, providing good visibility and protection from elements.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBrigandineHelmet : BEHelmet {
	BEBrigandineHelmet() : base() {
		$this.Name               = 'Brigandine Helmet'
		$this.MapObjName         = 'brigandinehelmet'
		$this.PurchasePrice      = 220
		$this.SellPrice          = 110
		$this.TargetStats        = @{
			[StatId]::Defense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helmet reinforced with metal plates, offering improved defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

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

Class BENinjaHood : BEHelmet {
	BENinjaHood() : base() {
		$this.Name               = 'Ninja Hood'
		$this.MapObjName         = 'ninjahood'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A stealthy hood worn by ninjas, aiding in clandestine operations.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPriestsMitre : BEHelmet {
	BEPriestsMitre() : base() {
		$this.Name               = 'Priest''s Mitre'
		$this.MapObjName         = 'priestsmitre'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ceremonial mitre worn by priests, enhancing divine blessings.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEClericsCoif : BEHelmet {
	BEClericsCoif() : base() {
		$this.Name               = 'Cleric''s Coif'
		$this.MapObjName         = 'clericscoif'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple coif worn by clerics, providing modest protection and spiritual focus.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESpellweaversTiara : BEHelmet {
	BESpellweaversTiara() : base() {
		$this.Name               = 'Spellweaver''s Tiara'
		$this.MapObjName         = 'spellweaverstiara'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sparkling tiara that amplifies the power of complex spells.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEWarlordsHelm : BEHelmet {
	BEWarlordsHelm() : base() {
		$this.Name               = 'Warlord''s Helm'
		$this.MapObjName         = 'warlordshelm'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A formidable helm worn by military commanders, inspiring loyalty and fear.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESentinelsHelmet : BEHelmet {
	BESentinelsHelmet() : base() {
		$this.Name               = 'Sentinel''s Helmet'
		$this.MapObjName         = 'sentinelshelmet'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 11
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy, defensive helmet worn by vigilant sentinels, guarding key locations.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMinstrelsCap : BEHelmet {
	BEMinstrelsCap() : base() {
		$this.Name               = 'Minstrel''s Cap'
		$this.MapObjName         = 'minstrelscap'
		$this.PurchasePrice      = 40
		$this.SellPrice          = 20
		$this.TargetStats        = @{
			[StatId]::Defense = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A whimsical cap worn by minstrels, adding charm to their performances.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDancersHeadpiece : BEHelmet {
	BEDancersHeadpiece() : base() {
		$this.Name               = 'Dancer''s Headpiece'
		$this.MapObjName         = 'dancersheadpiece'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An elaborate headpiece that complements a dancer''s movements and grace.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEJestersHat : BEHelmet {
	BEJestersHat() : base() {
		$this.Name               = 'Jester''s Hat'
		$this.MapObjName         = 'jestershat'
		$this.PurchasePrice      = 30
		$this.SellPrice          = 15
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A colorful, three-pointed hat worn by jesters, spreading mirth.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAlchemistsGoggles : BEHelmet {
	BEAlchemistsGoggles() : base() {
		$this.Name               = 'Alchemist''s Goggles'
		$this.MapObjName         = 'alchemistsgoggles'
		$this.PurchasePrice      = 50
		$this.SellPrice          = 25
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Goggles designed to protect the eyes of alchemists during experiments.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEngineersHardHat : BEHelmet {
	BEEngineersHardHat() : base() {
		$this.Name               = 'Engineer''s Hard Hat'
		$this.MapObjName         = 'engineershardhat'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::Defense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A durable hard hat worn by engineers, providing protection in hazardous environments.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEArtisansBeret : BEHelmet {
	BEArtisansBeret() : base() {
		$this.Name               = 'Artisan''s Beret'
		$this.MapObjName         = 'artisansberet'
		$this.PurchasePrice      = 60
		$this.SellPrice          = 30
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A stylish beret worn by artisans, inspiring creativity.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMonksHeadband : BEHelmet {
	BEMonksHeadband() : base() {
		$this.Name               = 'Monk''s Headband'
		$this.MapObjName         = 'monksheadband'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
			[StatId]::Defense = 2
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple headband worn by monks, aiding in focus and meditation.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAcolytesHood : BEHelmet {
	BEAcolytesHood() : base() {
		$this.Name               = 'Acolyte''s Hood'
		$this.MapObjName         = 'acolyteshood'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A humble hood worn by acolytes, signifying their dedication.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESagesTurban : BEHelmet {
	BESagesTurban() : base() {
		$this.Name               = 'Sage''s Turban'
		$this.MapObjName         = 'sagesturban'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A wise turban worn by sages, imbued with ancient knowledge.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BENecromancersHood : BEHelmet {
	BENecromancersHood() : base() {
		$this.Name               = 'Necromancer''s Hood'
		$this.MapObjName         = 'necromancershood'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark, tattered hood worn by necromancers, enhancing their control over the undead.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWarlocksHelm : BEHelmet {
	BEWarlocksHelm() : base() {
		$this.Name               = 'Warlock''s Helm'
		$this.MapObjName         = 'warlockshelm'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A menacing helm favored by warlocks, amplifying their dark powers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEShamansHeaddress : BEHelmet {
	BEShamansHeaddress() : base() {
		$this.Name               = 'Shaman''s Headdress'
		$this.MapObjName         = 'shamansheaddress'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 4
			[StatId]::MagicDefense = 11
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A feathered headdress worn by shamans, connecting them to ancestral spirits.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBeastmastersCap : BEHelmet {
	BEBeastmastersCap() : base() {
		$this.Name               = 'Beastmaster''s Cap'
		$this.MapObjName         = 'beastmasterscap'
		$this.PurchasePrice      = 170
		$this.SellPrice          = 85
		$this.TargetStats        = @{
			[StatId]::Defense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rugged cap worn by beastmasters, aiding in animal taming.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEInquisitorsHood : BEHelmet {
	BEInquisitorsHood() : base() {
		$this.Name               = 'Inquisitor''s Hood'
		$this.MapObjName         = 'inquisitorshood'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A somber hood worn by inquisitors, projecting authority and sternness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOraclesCirclet : BEHelmet {
	BEOraclesCirclet() : base() {
		$this.Name               = 'Oracle''s Circlet'
		$this.MapObjName         = 'oraclescirclet'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shimmering circlet worn by oracles, granting glimpses of the future.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEProphetsHeadwrap : BEHelmet {
	BEProphetsHeadwrap() : base() {
		$this.Name               = 'Prophet''s Headwrap'
		$this.MapObjName         = 'prophetsheadwrap'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple headwrap worn by prophets, aiding in divine communication.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEChampionsHelm : BEHelmet {
	BEChampionsHelm() : base() {
		$this.Name               = 'Champion''s Helm'
		$this.MapObjName         = 'championshelm'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A grand helmet worn by champions, symbolizing their triumphs.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEValkyriesHelm : BEHelmet {
	BEValkyriesHelm() : base() {
		$this.Name               = 'Valkyrie''s Helm'
		$this.MapObjName         = 'valkyrieshelm'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 17
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A winged helm worn by valkyries, granting them courage and strength.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEDreadnoughtHelm : BEHelmet {
	BEDreadnoughtHelm() : base() {
		$this.Name               = 'Dreadnought Helm'
		$this.MapObjName         = 'dreadnoughthelm'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::Defense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A massive, heavily armored helm designed for ultimate defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGhostlyVisage : BEHelmet {
	BEGhostlyVisage() : base() {
		$this.Name               = 'Ghostly Visage'
		$this.MapObjName         = 'ghostlyvisage'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A spectral helm that grants the wearer ethereal properties.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESunstoneCirclet : BEHelmet {
	BESunstoneCirclet() : base() {
		$this.Name               = 'Sunstone Circlet'
		$this.MapObjName         = 'sunstonecirclet'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A radiant circlet made of sunstone, imbued with healing light.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEMoonlightTiara : BEHelmet {
	BEMoonlightTiara() : base() {
		$this.Name               = 'Moonlight Tiara'
		$this.MapObjName         = 'moonlighttiara'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A luminous tiara that glows with moonlight, enhancing nocturnal magic.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEStarfallHelm : BEHelmet {
	BEStarfallHelm() : base() {
		$this.Name               = 'Starfall Helm'
		$this.MapObjName         = 'starfallhelm'
		$this.PurchasePrice      = 3000
		$this.SellPrice          = 1500
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm said to be forged from fallen stars, possessing cosmic power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOceanicHelmet : BEHelmet {
	BEOceanicHelmet() : base() {
		$this.Name               = 'Oceanic Helmet'
		$this.MapObjName         = 'oceanichelmet'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helmet crafted from deep-sea materials, providing protection against water-based attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVolcanicHelm : BEHelmet {
	BEVolcanicHelm() : base() {
		$this.Name               = 'Volcanic Helm'
		$this.MapObjName         = 'volcanichelm'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm forged in volcanic fire, granting resistance to heat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEForestDwellersHood : BEHelmet {
	BEForestDwellersHood() : base() {
		$this.Name               = 'Forest Dweller''s Hood'
		$this.MapObjName         = 'forestdwellershood'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{
			[StatId]::Defense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A hood woven from leaves and vines, providing camouflage in forests.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDesertNomadsTurban : BEHelmet {
	BEDesertNomadsTurban() : base() {
		$this.Name               = 'Desert Nomad''s Turban'
		$this.MapObjName         = 'desertnomadsturban'
		$this.PurchasePrice      = 130
		$this.SellPrice          = 65
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A practical turban for desert dwellers, protecting against sand and sun.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFrostbiteHelm : BEHelmet {
	BEFrostbiteHelm() : base() {
		$this.Name               = 'Frostbite Helm'
		$this.MapObjName         = 'frostbitehelm'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm enchanted with ice magic, chilling enemies upon impact.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEThunderclapHelm : BEHelmet {
	BEThunderclapHelm() : base() {
		$this.Name               = 'Thunderclap Helm'
		$this.MapObjName         = 'thunderclaphelm'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm infused with storm energy, allowing the wearer to channel lightning.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEarthshakerHelm : BEHelmet {
	BEEarthshakerHelm() : base() {
		$this.Name               = 'Earthshaker Helm'
		$this.MapObjName         = 'earthshakerhelm'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy helm that resonates with the power of the earth, increasing physical might.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESkywalkerHelm : BEHelmet {
	BESkywalkerHelm() : base() {
		$this.Name               = 'Skywalker Helm'
		$this.MapObjName         = 'skywalkerhelm'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A lightweight helm that seems to defy gravity, aiding in agility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESpiritwalkerMask : BEHelmet {
	BESpiritwalkerMask() : base() {
		$this.Name               = 'Spiritwalker Mask'
		$this.MapObjName         = 'spiritwalkermask'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ceremonial mask that allows communion with spirits.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEShadowWeaversHood : BEHelmet {
	BEShadowWeaversHood() : base() {
		$this.Name               = 'Shadow Weaver''s Hood'
		$this.MapObjName         = 'shadowweavershood'
		$this.PurchasePrice      = 1450
		$this.SellPrice          = 725
		$this.TargetStats        = @{
			[StatId]::Defense = 6
			[StatId]::MagicDefense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark hood that allows the wearer to manipulate shadows.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDreamCatchersTiara : BEHelmet {
	BEDreamCatchersTiara() : base() {
		$this.Name               = 'Dream Catcher''s Tiara'
		$this.MapObjName         = 'dreamcatcherstiara'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 11
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A mystical tiara that protects against nightmares and enhances lucid dreaming.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BENightfallHelm : BEHelmet {
	BENightfallHelm() : base() {
		$this.Name               = 'Nightfall Helm'
		$this.MapObjName         = 'nightfallhelm'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm as dark as night, granting stealth and improved vision in darkness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDaybreakCirclet : BEHelmet {
	BEDaybreakCirclet() : base() {
		$this.Name               = 'Daybreak Circlet'
		$this.MapObjName         = 'daybreakcirclet'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A radiant circlet that harnesses the power of the rising sun, dispelling darkness.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEGolemsHeadpiece : BEHelmet {
	BEGolemsHeadpiece() : base() {
		$this.Name               = 'Golem''s Headpiece'
		$this.MapObjName         = 'golemsheadpiece'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sturdy headpiece made from golem fragments, offering immense durability.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFairysGarland : BEHelmet {
	BEFairysGarland() : base() {
		$this.Name               = 'Fairy''s Garland'
		$this.MapObjName         = 'fairysgarland'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A delicate garland woven from enchanted flowers, granting subtle magical abilities.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEGnomesHelmet : BEHelmet {
	BEGnomesHelmet() : base() {
		$this.Name               = 'Gnome''s Helmet'
		$this.MapObjName         = 'gnomeshelmet'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{
			[StatId]::Defense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small, sturdy helmet crafted by gnomes, surprisingly resilient.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDwarvenHelmet : BEHelmet {
	BEDwarvenHelmet() : base() {
		$this.Name               = 'Dwarven Helmet'
		$this.MapObjName         = 'dwarvenhelmet'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A finely crafted, heavy helmet made by master dwarven smiths.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEElvenCirclet : BEHelmet {
	BEElvenCirclet() : base() {
		$this.Name               = 'Elven Circlet'
		$this.MapObjName         = 'elvencirclet'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An exquisitely crafted circlet worn by elves, enhancing their natural grace.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEOrcishWarhelm : BEHelmet {
	BEOrcishWarhelm() : base() {
		$this.Name               = 'Orcish Warhelm'
		$this.MapObjName         = 'orcishwarhelm'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::Defense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crude but brutal warhelm, favored by orcish warriors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGoblinsPotHelm : BEHelmet {
	BEGoblinsPotHelm() : base() {
		$this.Name               = 'Goblin''s Pot Helm'
		$this.MapObjName         = 'goblinspothelm'
		$this.PurchasePrice      = 30
		$this.SellPrice          = 15
		$this.TargetStats        = @{
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A makeshift helmet fashioned from a cooking pot, offering minimal protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEKoboldsHelmet : BEHelmet {
	BEKoboldsHelmet() : base() {
		$this.Name               = 'Kobold''s Helmet'
		$this.MapObjName         = 'koboldshelmet'
		$this.PurchasePrice      = 40
		$this.SellPrice          = 20
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small, spiky helmet worn by kobolds.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGriffinRidersHelm : BEHelmet {
	BEGriffinRidersHelm() : base() {
		$this.Name               = 'Griffin Rider''s Helm'
		$this.MapObjName         = 'griffinridershelm'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A specialized helm for riders of griffins, designed for aerial combat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHippogriffTrainersCap : BEHelmet {
	BEHippogriffTrainersCap() : base() {
		$this.Name               = 'Hippogriff Trainer''s Cap'
		$this.MapObjName         = 'hippogrifftrainerscap'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A practical cap worn by hippogriff trainers, aiding in communication with the creatures.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHarpysFeatheredHelm : BEHelmet {
	BEHarpysFeatheredHelm() : base() {
		$this.Name               = 'Harpy''s Feathered Helm'
		$this.MapObjName         = 'harpysfeatheredhelm'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light helm adorned with harpy feathers, granting enhanced senses.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BESirensHeadband : BEHelmet {
	BESirensHeadband() : base() {
		$this.Name               = 'Siren''s Headband'
		$this.MapObjName         = 'sirensheadband'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shimmering headband worn by sirens, subtly enhancing their enchanting voices.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEMinotaursHornedHelm : BEHelmet {
	BEMinotaursHornedHelm() : base() {
		$this.Name               = 'Minotaur''s Horned Helm'
		$this.MapObjName         = 'minotaurshornedhelm'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A massive, horned helm that mimics a minotaur''s might.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BECentaursHeadguard : BEHelmet {
	BECentaursHeadguard() : base() {
		$this.Name               = 'Centaur''s Headguard'
		$this.MapObjName         = 'centaursheadguard'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A protective headguard designed for centaur warriors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDryadsWreath : BEHelmet {
	BEDryadsWreath() : base() {
		$this.Name               = 'Dryad''s Wreath'
		$this.MapObjName         = 'dryadswreath'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A beautiful wreath of living plants worn by dryads, connecting them to nature.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BENagasHeadpiece : BEHelmet {
	BENagasHeadpiece() : base() {
		$this.Name               = 'Naga''s Headpiece'
		$this.MapObjName         = 'nagasheadpiece'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A serpentine headpiece worn by naga, enhancing their aquatic abilities.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESphinxsMask : BEHelmet {
	BESphinxsMask() : base() {
		$this.Name               = 'Sphinx''s Mask'
		$this.MapObjName         = 'sphinxsmask'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 19
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An enigmatic mask that grants cryptic wisdom and a connection to ancient riddles.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPhoenixFeatherCrown : BEHelmet {
	BEPhoenixFeatherCrown() : base() {
		$this.Name               = 'Phoenix Feather Crown'
		$this.MapObjName         = 'phoenixfeathercrown'
		$this.PurchasePrice      = 2800
		$this.SellPrice          = 1400
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vibrant crown adorned with phoenix feathers, granting regenerative powers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEUnicornHornCirclet : BEHelmet {
	BEUnicornHornCirclet() : base() {
		$this.Name               = 'Unicorn Horn Circlet'
		$this.MapObjName         = 'unicornhorncirclet'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pure circlet with a small unicorn horn, enhancing healing and purity.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEBasiliskScaleHelm : BEHelmet {
	BEBasiliskScaleHelm() : base() {
		$this.Name               = 'Basilisk Scale Helm'
		$this.MapObjName         = 'basiliskscalehelm'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm made from basilisk scales, offering resistance to petrification.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGriffinScaleHelm : BEHelmet {
	BEGriffinScaleHelm() : base() {
		$this.Name               = 'Griffin Scale Helm'
		$this.MapObjName         = 'griffinscalehelm'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 11
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm made from griffin scales, offering light yet sturdy protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECockatricePlumeHelm : BEHelmet {
	BECockatricePlumeHelm() : base() {
		$this.Name               = 'Cockatrice Plume Helm'
		$this.MapObjName         = 'cockatriceplumehelm'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm adorned with cockatrice plumes, offering minor protection against petrification.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWyvernBoneHelm : BEHelmet {
	BEWyvernBoneHelm() : base() {
		$this.Name               = 'Wyvern Bone Helm'
		$this.MapObjName         = 'wyvernbonehelm'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rugged helm fashioned from wyvern bones, imparting a primal ferocity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERocFeatherHelm : BEHelmet {
	BERocFeatherHelm() : base() {
		$this.Name               = 'Roc Feather Helm'
		$this.MapObjName         = 'rocfeatherhelm'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light helm adorned with roc feathers, granting keen eyesight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEKrakenTentacleHelm : BEHelmet {
	BEKrakenTentacleHelm() : base() {
		$this.Name               = 'Kraken Tentacle Helm'
		$this.MapObjName         = 'krakententaclehelm'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A strange helm made from kraken tentacles, allowing some control over water.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELeviathanScaleHelm : BEHelmet {
	BELeviathanScaleHelm() : base() {
		$this.Name               = 'Leviathan Scale Helm'
		$this.MapObjName         = 'leviathanscalehelm'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A massive helm made from leviathan scales, offering immense protection in water.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHydraHeadHelm : BEHelmet {
	BEHydraHeadHelm() : base() {
		$this.Name               = 'Hydra Head Helm'
		$this.MapObjName         = 'hydraheadhelm'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A monstrous helm adorned with a hydra head, granting multiple perspectives.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEChimeraHornHelm : BEHelmet {
	BEChimeraHornHelm() : base() {
		$this.Name               = 'Chimera Horn Helm'
		$this.MapObjName         = 'chimerahornhelm'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm adorned with chimera horns, embodying the ferocity of multiple beasts.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEManticoreSpikeHelm : BEHelmet {
	BEManticoreSpikeHelm() : base() {
		$this.Name               = 'Manticore Spike Helm'
		$this.MapObjName         = 'manticorespikehelm'
		$this.PurchasePrice      = 1750
		$this.SellPrice          = 875
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A spiky helm made from manticore spikes, inflicting poison on attackers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGorgonHairHelm : BEHelmet {
	BEGorgonHairHelm() : base() {
		$this.Name               = 'Gorgon Hair Helm'
		$this.MapObjName         = 'gorgonhairhelm'
		$this.PurchasePrice      = 1650
		$this.SellPrice          = 825
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A chilling helm adorned with gorgon hair, capable of partially paralyzing foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BECerberusSkullHelm : BEHelmet {
	BECerberusSkullHelm() : base() {
		$this.Name               = 'Cerberus Skull Helm'
		$this.MapObjName         = 'cerberusskullhelm'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
			[StatId]::Defense = 19
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A fearsome helm made from a cerberus skull, instilling terror.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BELichsPhylacteryHelm : BEHelmet {
	BELichsPhylacteryHelm() : base() {
		$this.Name               = 'Lich''s Phylactery Helm'
		$this.MapObjName         = 'lichsphylacteryhelm'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cursed helm containing a lich''s phylactery, granting dark powers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAngelsHalo : BEHelmet {
	BEAngelsHalo() : base() {
		$this.Name               = 'Angel''s Halo'
		$this.MapObjName         = 'angelshalo'
		$this.PurchasePrice      = 3000
		$this.SellPrice          = 1500
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shimmering halo radiating divine energy, protecting against evil.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDemonsHornedHelm : BEHelmet {
	BEDemonsHornedHelm() : base() {
		$this.Name               = 'Demon''s Horned Helm'
		$this.MapObjName         = 'demonshornedhelm'
		$this.PurchasePrice      = 2800
		$this.SellPrice          = 1400
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark, horned helm imbued with demonic power, granting destructive capabilities.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESpectersShroudHelm : BEHelmet {
	BESpectersShroudHelm() : base() {
		$this.Name               = 'Specter''s Shroud Helm'
		$this.MapObjName         = 'spectersshroudhelm'
		$this.PurchasePrice      = 2300
		$this.SellPrice          = 1150
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ghostly helm that allows the wearer to phase through solid objects.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVampiresCoffinLidHelm : BEHelmet {
	BEVampiresCoffinLidHelm() : base() {
		$this.Name               = 'Vampire''s Coffin Lid Helm'
		$this.MapObjName         = 'vampirescoffinlidhelm'
		$this.PurchasePrice      = 2400
		$this.SellPrice          = 1200
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A macabre helm fashioned from a coffin lid, granting life-draining abilities.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWerewolfPeltHelm : BEHelmet {
	BEWerewolfPeltHelm() : base() {
		$this.Name               = 'Werewolf Pelt Helm'
		$this.MapObjName         = 'werewolfpelthelm'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rugged helm made from werewolf pelt, granting increased strength under the moon.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGoblinShamansSkullcap : BEHelmet {
	BEGoblinShamansSkullcap() : base() {
		$this.Name               = 'Goblin Shaman''s Skullcap'
		$this.MapObjName         = 'goblinshamansskullcap'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crude skullcap adorned with goblin shaman trinkets, enhancing their rudimentary magic.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOgresClubHelm : BEHelmet {
	BEOgresClubHelm() : base() {
		$this.Name               = 'Ogre''s Club Helm'
		$this.MapObjName         = 'ogresclubhelm'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A massive helm fashioned from an ogre''s club, offering blunt force protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETrollhideCap : BEHelmet {
	BETrollhideCap() : base() {
		$this.Name               = 'Trollhide Cap'
		$this.MapObjName         = 'trollhidecap'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{
			[StatId]::Defense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A thick cap made from troll hide, offering good regeneration.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGiantsKettleHelm : BEHelmet {
	BEGiantsKettleHelm() : base() {
		$this.Name               = 'Giant''s Kettle Helm'
		$this.MapObjName         = 'giantskettlehelm'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A colossal helm made from a giant''s kettle, providing immense defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESpritesLeafHat : BEHelmet {
	BESpritesLeafHat() : base() {
		$this.Name               = 'Sprite''s Leaf Hat'
		$this.MapObjName         = 'spritesleafhat'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiny hat woven from magical leaves, granting illusionary abilities.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBrowniesAcornCap : BEHelmet {
	BEBrowniesAcornCap() : base() {
		$this.Name               = 'Brownie''s Acorn Cap'
		$this.MapObjName         = 'browniesacorncap'
		$this.PurchasePrice      = 50
		$this.SellPrice          = 25
		$this.TargetStats        = @{
			[StatId]::Defense = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small cap made from an acorn, offering minor protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELeprechaunsTopHat : BEHelmet {
	BELeprechaunsTopHat() : base() {
		$this.Name               = 'Leprechaun''s Top Hat'
		$this.MapObjName         = 'leprechaunstophat'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charming top hat that brings good luck.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBansheesWailMask : BEHelmet {
	BEBansheesWailMask() : base() {
		$this.Name               = 'Banshee''s Wail Mask'
		$this.MapObjName         = 'bansheeswailmask'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A haunting mask that amplifies a banshee''s terrifying scream.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEGhoulsGraveShroud : BEHelmet {
	BEGhoulsGraveShroud() : base() {
		$this.Name               = 'Ghoul''s Grave Shroud'
		$this.MapObjName         = 'ghoulsgraveshroud'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 6
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tattered shroud that grants the wearer partial invisibility in darkness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEZombiesBrainBucket : BEHelmet {
	BEZombiesBrainBucket() : base() {
		$this.Name               = 'Zombie''s Brain Bucket'
		$this.MapObjName         = 'zombiesbrainbucket'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A gruesome bucket worn by zombies, protecting their brains.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMummysLinenWrap : BEHelmet {
	BEMummysLinenWrap() : base() {
		$this.Name               = 'Mummy''s Linen Wrap'
		$this.MapObjName         = 'mummyslinenwrap'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An ancient linen wrap that offers minor protection against curses.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFrankensteinsMonsterHeadpiece : BEHelmet {
	BEFrankensteinsMonsterHeadpiece() : base() {
		$this.Name               = 'Frankenstein''s Monster Headpiece'
		$this.MapObjName         = 'frankensteinsmonsterheadpiece'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 19
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A patched-together headpiece that offers immense resilience.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGargoyleStoneHelm : BEHelmet {
	BEGargoyleStoneHelm() : base() {
		$this.Name               = 'Gargoyle Stone Helm'
		$this.MapObjName         = 'gargoylestonehelm'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm carved from gargoyle stone, offering resistance to physical damage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDragonTurtleShellHelm : BEHelmet {
	BEDragonTurtleShellHelm() : base() {
		$this.Name               = 'Dragon Turtle Shell Helm'
		$this.MapObjName         = 'dragonturtleshellhelm'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{
			[StatId]::Defense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A massive helm made from a dragon turtle''s shell, offering exceptional defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFireElementalCoreHelm : BEHelmet {
	BEFireElementalCoreHelm() : base() {
		$this.Name               = 'Fire Elemental Core Helm'
		$this.MapObjName         = 'fireelementalcorehelm'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm infused with a fire elemental core, granting fire immunity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWaterElementalCoreHelm : BEHelmet {
	BEWaterElementalCoreHelm() : base() {
		$this.Name               = 'Water Elemental Core Helm'
		$this.MapObjName         = 'waterelementalcorehelm'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm infused with a water elemental core, granting water breathing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAirElementalCoreHelm : BEHelmet {
	BEAirElementalCoreHelm() : base() {
		$this.Name               = 'Air Elemental Core Helm'
		$this.MapObjName         = 'airelementalcorehelm'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm infused with an air elemental core, granting enhanced agility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEarthElementalCoreHelm : BEHelmet {
	BEEarthElementalCoreHelm() : base() {
		$this.Name               = 'Earth Elemental Core Helm'
		$this.MapObjName         = 'earthelementalcorehelm'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm infused with an earth elemental core, granting increased fortitude.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELightElementalCoreHelm : BEHelmet {
	BELightElementalCoreHelm() : base() {
		$this.Name               = 'Light Elemental Core Helm'
		$this.MapObjName         = 'lightelementalcorehelm'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm infused with a light elemental core, radiating holy energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDarkElementalCoreHelm : BEHelmet {
	BEDarkElementalCoreHelm() : base() {
		$this.Name               = 'Dark Elemental Core Helm'
		$this.MapObjName         = 'darkelementalcorehelm'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm infused with a dark elemental core, manipulating shadows.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEArcaneOrbHelm : BEHelmet {
	BEArcaneOrbHelm() : base() {
		$this.Name               = 'Arcane Orb Helm'
		$this.MapObjName         = 'arcaneorbhelm'
		$this.PurchasePrice      = 2800
		$this.SellPrice          = 1400
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm with a floating arcane orb, significantly boosting magical power.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEChaosFragmentHelm : BEHelmet {
	BEChaosFragmentHelm() : base() {
		$this.Name               = 'Chaos Fragment Helm'
		$this.MapObjName         = 'chaosfragmenthelm'
		$this.PurchasePrice      = 3200
		$this.SellPrice          = 1600
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A chaotic helm formed from fragments of pure chaos, granting unpredictable power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVoidGazeHelm : BEHelmet {
	BEVoidGazeHelm() : base() {
		$this.Name               = 'Void Gaze Helm'
		$this.MapObjName         = 'voidgazehelm'
		$this.PurchasePrice      = 2700
		$this.SellPrice          = 1350
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 23
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that allows the wearer to glimpse into the void, potentially driving them mad.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAstralProjectionHelm : BEHelmet {
	BEAstralProjectionHelm() : base() {
		$this.Name               = 'Astral Projection Helm'
		$this.MapObjName         = 'astralprojectionhelm'
		$this.PurchasePrice      = 2600
		$this.SellPrice          = 1300
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that aids in astral projection, allowing the wearer to explore beyond their body.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEChronosHelm : BEHelmet {
	BEChronosHelm() : base() {
		$this.Name               = 'Chronos Helm'
		$this.MapObjName         = 'chronoshelm'
		$this.PurchasePrice      = 3500
		$this.SellPrice          = 1750
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm infused with the power of time, allowing minor temporal manipulation.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAetherialVeil : BEHelmet {
	BEAetherialVeil() : base() {
		$this.Name               = 'Aetherial Veil'
		$this.MapObjName         = 'aetherialveil'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A translucent veil that grants partial etherealness, making the wearer harder to hit.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BECelestialDiadem : BEHelmet {
	BECelestialDiadem() : base() {
		$this.Name               = 'Celestial Diadem'
		$this.MapObjName         = 'celestialdiadem'
		$this.PurchasePrice      = 3100
		$this.SellPrice          = 1550
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 26
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A diadem adorned with fragments of starlight, radiating divine protection.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEAbyssalCrown : BEHelmet {
	BEAbyssalCrown() : base() {
		$this.Name               = 'Abyssal Crown'
		$this.MapObjName         = 'abyssalcrown'
		$this.PurchasePrice      = 2900
		$this.SellPrice          = 1450
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 19
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark crown from the abyss, granting control over deep-sea creatures.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEtherealHood : BEHelmet {
	BEEtherealHood() : base() {
		$this.Name               = 'Ethereal Hood'
		$this.MapObjName         = 'etherealhood'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shimmering hood that makes the wearer nearly invisible to the naked eye.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESoulforgedHelm : BEHelmet {
	BESoulforgedHelm() : base() {
		$this.Name               = 'Soulforged Helm'
		$this.MapObjName         = 'soulforgedhelm'
		$this.PurchasePrice      = 3300
		$this.SellPrice          = 1650
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm forged from captured souls, granting immense dark power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESpiritbondCirclet : BEHelmet {
	BESpiritbondCirclet() : base() {
		$this.Name               = 'Spiritbond Circlet'
		$this.MapObjName         = 'spiritbondcirclet'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A circlet that creates a strong bond with a companion spirit.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDreamthornHelm : BEHelmet {
	BEDreamthornHelm() : base() {
		$this.Name               = 'Dreamthorn Helm'
		$this.MapObjName         = 'dreamthornhelm'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm with sharp, dream-infused thorns, inflicting nightmares on enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWispwoodHelm : BEHelmet {
	BEWispwoodHelm() : base() {
		$this.Name               = 'Wispwood Helm'
		$this.MapObjName         = 'wispwoodhelm'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light helm made from wispwood, granting improved awareness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECrystalBloomTiara : BEHelmet {
	BECrystalBloomTiara() : base() {
		$this.Name               = 'Crystal Bloom Tiara'
		$this.MapObjName         = 'crystalbloomtiara'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiara made of blossoming crystals, enhancing natural magic.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEStoneGolemHelm : BEHelmet {
	BEStoneGolemHelm() : base() {
		$this.Name               = 'Stone Golem Helm'
		$this.MapObjName         = 'stonegolemhelm'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy helm made from golem stone, offering robust defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEObsidianHelm : BEHelmet {
	BEObsidianHelm() : base() {
		$this.Name               = 'Obsidian Helm'
		$this.MapObjName         = 'obsidianhelm'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm carved from dark obsidian, absorbing magical attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEJadeCrown : BEHelmet {
	BEJadeCrown() : base() {
		$this.Name               = 'Jade Crown'
		$this.MapObjName         = 'jadecrown'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crown made of pure jade, enhancing wisdom and longevity.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

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

Class BESapphireTiara : BEHelmet {
	BESapphireTiara() : base() {
		$this.Name               = 'Sapphire Tiara'
		$this.MapObjName         = 'sapphiretiara'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiara with a brilliant sapphire, enhancing water and ice magic.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEEmeraldCirclet : BEHelmet {
	BEEmeraldCirclet() : base() {
		$this.Name               = 'Emerald Circlet'
		$this.MapObjName         = 'emeraldcirclet'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A circlet with a gleaming emerald, boosting nature-based magic.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEDiamondCrown : BEHelmet {
	BEDiamondCrown() : base() {
		$this.Name               = 'Diamond Crown'
		$this.MapObjName         = 'diamondcrown'
		$this.PurchasePrice      = 3800
		$this.SellPrice          = 1900
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crown encrusted with diamonds, offering unparalleled defense and prestige.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAmethystHelm : BEHelmet {
	BEAmethystHelm() : base() {
		$this.Name               = 'Amethyst Helm'
		$this.MapObjName         = 'amethysthelm'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm with an amethyst, enhancing mental clarity and resistance to mind-control.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETopazCirclet : BEHelmet {
	BETopazCirclet() : base() {
		$this.Name               = 'Topaz Circlet'
		$this.MapObjName         = 'topazcirclet'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A circlet with a golden topaz, enhancing agility and swiftness.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEGarnetHelm : BEHelmet {
	BEGarnetHelm() : base() {
		$this.Name               = 'Garnet Helm'
		$this.MapObjName         = 'garnethelm'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm with a deep red garnet, boosting vitality and inner strength.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPearlTiara : BEHelmet {
	BEPearlTiara() : base() {
		$this.Name               = 'Pearl Tiara'
		$this.MapObjName         = 'pearltiara'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A delicate tiara with lustrous pearls, enhancing healing and purity.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEOpalHelm : BEHelmet {
	BEOpalHelm() : base() {
		$this.Name               = 'Opal Helm'
		$this.MapObjName         = 'opalhelm'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shimmering helm with an opal, granting minor illusionary abilities.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETourmalineCrown : BEHelmet {
	BETourmalineCrown() : base() {
		$this.Name               = 'Tourmaline Crown'
		$this.MapObjName         = 'tourmalinecrown'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 19
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crown with a multi-colored tourmaline, granting resistance to various elemental attacks.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBloodstoneHelm : BEHelmet {
	BEBloodstoneHelm() : base() {
		$this.Name               = 'Bloodstone Helm'
		$this.MapObjName         = 'bloodstonehelm'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A grim helm with bloodstone, enhancing offensive capabilities at a cost to health.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMoonstoneCirclet : BEHelmet {
	BEMoonstoneCirclet() : base() {
		$this.Name               = 'Moonstone Circlet'
		$this.MapObjName         = 'moonstonecirclet'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A circlet with moonstone, granting enhanced intuition and nocturnal magic.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BESunstoneHelm : BEHelmet {
	BESunstoneHelm() : base() {
		$this.Name               = 'Sunstone Helm'
		$this.MapObjName         = 'sunstonehelm'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm with sunstone, radiating warmth and light, countering darkness.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAdamantiteHelm : BEHelmet {
	BEAdamantiteHelm() : base() {
		$this.Name               = 'Adamantite Helm'
		$this.MapObjName         = 'adamantitehelm'
		$this.PurchasePrice      = 4500
		$this.SellPrice          = 2250
		$this.TargetStats        = @{
			[StatId]::Defense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A supremely strong helm made from adamantite, offering near-invincible defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOrichalcumCirclet : BEHelmet {
	BEOrichalcumCirclet() : base() {
		$this.Name               = 'Orichalcum Circlet'
		$this.MapObjName         = 'orichalcumcirclet'
		$this.PurchasePrice      = 4200
		$this.SellPrice          = 2100
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A legendary circlet made from orichalcum, amplifying all magical abilities.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETitaniumHelm : BEHelmet {
	BETitaniumHelm() : base() {
		$this.Name               = 'Titanium Helm'
		$this.MapObjName         = 'titaniumhelm'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A lightweight yet incredibly strong helm made from titanium.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMithrilChainCoif : BEHelmet {
	BEMithrilChainCoif() : base() {
		$this.Name               = 'Mithril Chain Coif'
		$this.MapObjName         = 'mithrilchaincoif'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light and flexible coif made of mithril chain, offering good protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVibraniumHelm : BEHelmet {
	BEVibraniumHelm() : base() {
		$this.Name               = 'Vibranium Helm'
		$this.MapObjName         = 'vibraniumhelm'
		$this.PurchasePrice      = 5000
		$this.SellPrice          = 2500
		$this.TargetStats        = @{
			[StatId]::Defense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm made from vibranium, absorbing kinetic energy and returning it as force.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BENetheriteHelm : BEHelmet {
	BENetheriteHelm() : base() {
		$this.Name               = 'Netherite Helm'
		$this.MapObjName         = 'netheritehelm'
		$this.PurchasePrice      = 4800
		$this.SellPrice          = 2400
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm forged from netherite, resistant to fire and powerful in the nether.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEtheriumHelm : BEHelmet {
	BEEtheriumHelm() : base() {
		$this.Name               = 'Etherium Helm'
		$this.MapObjName         = 'etheriumhelm'
		$this.PurchasePrice      = 4000
		$this.SellPrice          = 2000
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm made of ethereal material, granting resistance to magical effects.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEQuantumHelm : BEHelmet {
	BEQuantumHelm() : base() {
		$this.Name               = 'Quantum Helm'
		$this.MapObjName         = 'quantumhelm'
		$this.PurchasePrice      = 6000
		$this.SellPrice          = 3000
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm incorporating quantum technology, allowing minor reality manipulation.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStardustCirclet : BEHelmet {
	BEStardustCirclet() : base() {
		$this.Name               = 'Stardust Circlet'
		$this.MapObjName         = 'stardustcirclet'
		$this.PurchasePrice      = 3500
		$this.SellPrice          = 1750
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A circlet crafted from condensed stardust, granting cosmic awareness.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BECometTailHelm : BEHelmet {
	BECometTailHelm() : base() {
		$this.Name               = 'Comet Tail Helm'
		$this.MapObjName         = 'comettailhelm'
		$this.PurchasePrice      = 3400
		$this.SellPrice          = 1700
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm with a streaking comet tail effect, enhancing speed and agility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBlackHoleHelm : BEHelmet {
	BEBlackHoleHelm() : base() {
		$this.Name               = 'Black Hole Helm'
		$this.MapObjName         = 'blackholehelm'
		$this.PurchasePrice      = 7000
		$this.SellPrice          = 3500
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that seems to absorb light, granting control over gravitational forces.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGalaxyHelm : BEHelmet {
	BEGalaxyHelm() : base() {
		$this.Name               = 'Galaxy Helm'
		$this.MapObjName         = 'galaxyhelm'
		$this.PurchasePrice      = 8000
		$this.SellPrice          = 4000
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that contains a swirling galaxy within, granting immense power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BENebulaCrown : BEHelmet {
	BENebulaCrown() : base() {
		$this.Name               = 'Nebula Crown'
		$this.MapObjName         = 'nebulacrown'
		$this.PurchasePrice      = 7500
		$this.SellPrice          = 3750
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crown that shimmers with the colors of a nebula, granting astral powers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BESolarFlareHelm : BEHelmet {
	BESolarFlareHelm() : base() {
		$this.Name               = 'Solar Flare Helm'
		$this.MapObjName         = 'solarflarehelm'
		$this.PurchasePrice      = 6500
		$this.SellPrice          = 3250
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that bursts with solar energy, incinerating foes with light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELunarEclipseHelm : BEHelmet {
	BELunarEclipseHelm() : base() {
		$this.Name               = 'Lunar Eclipse Helm'
		$this.MapObjName         = 'lunareclipsehelm'
		$this.PurchasePrice      = 6500
		$this.SellPrice          = 3250
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm shrouded in the darkness of a lunar eclipse, granting shadowy powers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECosmicHelm : BEHelmet {
	BECosmicHelm() : base() {
		$this.Name               = 'Cosmic Helm'
		$this.MapObjName         = 'cosmichelm'
		$this.PurchasePrice      = 9000
		$this.SellPrice          = 4500
		$this.TargetStats        = @{
			[StatId]::Defense = 60
			[StatId]::MagicDefense = 60
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that seems to transcend dimensions, granting omnipotent abilities.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVoidwalkerHelm : BEHelmet {
	BEVoidwalkerHelm() : base() {
		$this.Name               = 'Voidwalker Helm'
		$this.MapObjName         = 'voidwalkerhelm'
		$this.PurchasePrice      = 5500
		$this.SellPrice          = 2750
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm for those who walk the void, granting protection from its horrors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETimeWeaversHood : BEHelmet {
	BETimeWeaversHood() : base() {
		$this.Name               = 'Time Weaver''s Hood'
		$this.MapObjName         = 'timeweavershood'
		$this.PurchasePrice      = 5000
		$this.SellPrice          = 2500
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A hood that allows the wearer to subtly manipulate the flow of time.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERealityBendersTiara : BEHelmet {
	BERealityBendersTiara() : base() {
		$this.Name               = 'Reality Bender''s Tiara'
		$this.MapObjName         = 'realitybenderstiara'
		$this.PurchasePrice      = 6000
		$this.SellPrice          = 3000
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiara that allows the wearer to bend reality to their will, within limits.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEDimensionShiftersHelm : BEHelmet {
	BEDimensionShiftersHelm() : base() {
		$this.Name               = 'Dimension Shifter''s Helm'
		$this.MapObjName         = 'dimensionshiftershelm'
		$this.PurchasePrice      = 5800
		$this.SellPrice          = 2900
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that allows the wearer to shift between dimensions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGravitonHelm : BEHelmet {
	BEGravitonHelm() : base() {
		$this.Name               = 'Graviton Helm'
		$this.MapObjName         = 'gravitonhelm'
		$this.PurchasePrice      = 5200
		$this.SellPrice          = 2600
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that manipulates gravity, allowing the wearer to float or crush foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAnti-MatterHelm : BEHelmet {
	BEAntiMatterHelm() : base() {
		$this.Name               = 'Anti-Matter Helm'
		$this.MapObjName         = 'antimatterhelm'
		$this.PurchasePrice      = 7000
		$this.SellPrice          = 3500
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm crafted from anti-matter, highly destructive but dangerous to wear.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESingularityHelm : BEHelmet {
	BESingularityHelm() : base() {
		$this.Name               = 'Singularity Helm'
		$this.MapObjName         = 'singularityhelm'
		$this.PurchasePrice      = 8500
		$this.SellPrice          = 4250
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 55
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that creates a miniature singularity, pulling enemies in.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEldritchVisage : BEHelmet {
	BEEldritchVisage() : base() {
		$this.Name               = 'Eldritch Visage'
		$this.MapObjName         = 'eldritchvisage'
		$this.PurchasePrice      = 4500
		$this.SellPrice          = 2250
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm of disturbing appearance, granting maddening powers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECrystallineHelm : BEHelmet {
	BECrystallineHelm() : base() {
		$this.Name               = 'Crystalline Helm'
		$this.MapObjName         = 'crystallinehelm'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm made of pure crystal, offering excellent protection and magic amplification.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEForgeLordsHelm : BEHelmet {
	BEForgeLordsHelm() : base() {
		$this.Name               = 'Forge Lord''s Helm'
		$this.MapObjName         = 'forgelordshelm'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy helm worn by master blacksmiths, radiating immense heat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEArtificersGoggles : BEHelmet {
	BEArtificersGoggles() : base() {
		$this.Name               = 'Artificer''s Goggles'
		$this.MapObjName         = 'artificersgoggles'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Goggles designed for artificers, enhancing their crafting precision.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERunesmithsHelmet : BEHelmet {
	BERunesmithsHelmet() : base() {
		$this.Name               = 'Runesmith''s Helmet'
		$this.MapObjName         = 'runesmithshelmet'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helmet inscribed with powerful runes, enhancing runic magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGlimmersteelHelm : BEHelmet {
	BEGlimmersteelHelm() : base() {
		$this.Name               = 'Glimmersteel Helm'
		$this.MapObjName         = 'glimmersteelhelm'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm made of glimmersteel, reflecting light and dazzling enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESoulstoneHelm : BEHelmet {
	BESoulstoneHelm() : base() {
		$this.Name               = 'Soulstone Helm'
		$this.MapObjName         = 'soulstonehelm'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm with an embedded soulstone, capable of absorbing stray souls for power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESpiritWardensHelm : BEHelmet {
	BESpiritWardensHelm() : base() {
		$this.Name               = 'Spirit Warden''s Helm'
		$this.MapObjName         = 'spiritwardenshelm'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm worn by those who guard spirits, offering protection from malevolent entities.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAbjurersHood : BEHelmet {
	BEAbjurersHood() : base() {
		$this.Name               = 'Abjurer''s Hood'
		$this.MapObjName         = 'abjurershood'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A hood worn by abjurers, specializing in defensive magic.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEConjurersCap : BEHelmet {
	BEConjurersCap() : base() {
		$this.Name               = 'Conjurer''s Cap'
		$this.MapObjName         = 'conjurerscap'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cap worn by conjurers, aiding in summoning creatures.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDivinersHeadband : BEHelmet {
	BEDivinersHeadband() : base() {
		$this.Name               = 'Diviner''s Headband'
		$this.MapObjName         = 'divinersheadband'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A headband worn by diviners, enhancing their foresight.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEnchantresssCirclet : BEHelmet {
	BEEnchantresssCirclet() : base() {
		$this.Name               = 'Enchantress''s Circlet'
		$this.MapObjName         = 'enchantressscirclet'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A circlet worn by enchantresses, boosting charming spells.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEIllusionistsMask : BEHelmet {
	BEIllusionistsMask() : base() {
		$this.Name               = 'Illusionist''s Mask'
		$this.MapObjName         = 'illusionistsmask'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 19
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A mask worn by illusionists, making their illusions more convincing.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEvokersHelm : BEHelmet {
	BEEvokersHelm() : base() {
		$this.Name               = 'Evoker''s Helm'
		$this.MapObjName         = 'evokershelm'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm worn by evokers, amplifying their destructive spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETransmutersHood : BEHelmet {
	BETransmutersHood() : base() {
		$this.Name               = 'Transmuter''s Hood'
		$this.MapObjName         = 'transmutershood'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 21
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A hood worn by transmuters, aiding in altering physical properties.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BENecromancersSkullMask : BEHelmet {
	BENecromancersSkullMask() : base() {
		$this.Name               = 'Necromancer''s Skull Mask'
		$this.MapObjName         = 'necromancersskullmask'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A chilling skull mask worn by necromancers, granting greater control over the undead.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWarlordsGreathelm : BEHelmet {
	BEWarlordsGreathelm() : base() {
		$this.Name               = 'Warlord''s Greathelm'
		$this.MapObjName         = 'warlordsgreathelm'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::Defense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A massive greathelm worn by powerful warlords, dominating the battlefield.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEConquerorsCrown : BEHelmet {
	BEConquerorsCrown() : base() {
		$this.Name               = 'Conqueror''s Crown'
		$this.MapObjName         = 'conquerorscrown'
		$this.PurchasePrice      = 2700
		$this.SellPrice          = 1350
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A magnificent crown worn by conquerors, inspiring loyalty and fear in their armies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEEmperorsLaurel : BEHelmet {
	BEEmperorsLaurel() : base() {
		$this.Name               = 'Emperor''s Laurel'
		$this.MapObjName         = 'emperorslaurel'
		$this.PurchasePrice      = 2900
		$this.SellPrice          = 1450
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A golden laurel wreath worn by emperors, symbolizing absolute power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEmpresssTiara : BEHelmet {
	BEEmpresssTiara() : base() {
		$this.Name               = 'Empress''s Tiara'
		$this.MapObjName         = 'empressstiara'
		$this.PurchasePrice      = 2800
		$this.SellPrice          = 1400
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A regal tiara worn by empresses, radiating grace and authority.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEKingsCrown : BEHelmet {
	BEKingsCrown() : base() {
		$this.Name               = 'King''s Crown'
		$this.MapObjName         = 'kingscrown'
		$this.PurchasePrice      = 2600
		$this.SellPrice          = 1300
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A noble crown worn by kings, inspiring bravery in their subjects.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEQueensDiadem : BEHelmet {
	BEQueensDiadem() : base() {
		$this.Name               = 'Queen''s Diadem'
		$this.MapObjName         = 'queensdiadem'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A beautiful diadem worn by queens, symbolizing wisdom and benevolence.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEBaronsHelmet : BEHelmet {
	BEBaronsHelmet() : base() {
		$this.Name               = 'Baron''s Helmet'
		$this.MapObjName         = 'baronshelmet'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::Defense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sturdy helmet worn by barons, providing protection in battle.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEBaronesssCirclet : BEHelmet {
	BEBaronesssCirclet() : base() {
		$this.Name               = 'Baroness''s Circlet'
		$this.MapObjName         = 'baronessscirclet'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An elegant circlet worn by baronesses, suitable for court.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEDukesGreathelm : BEHelmet {
	BEDukesGreathelm() : base() {
		$this.Name               = 'Duke''s Greathelm'
		$this.MapObjName         = 'dukesgreathelm'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A grand greathelm worn by dukes, signifying their martial prowess.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEDuchesssTiara : BEHelmet {
	BEDuchesssTiara() : base() {
		$this.Name               = 'Duchess''s Tiara'
		$this.MapObjName         = 'duchessstiara'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sophisticated tiara worn by duchesses, befitting their noble status.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BECountsHelmet : BEHelmet {
	BECountsHelmet() : base() {
		$this.Name               = 'Count''s Helmet'
		$this.MapObjName         = 'countshelmet'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A finely crafted helmet worn by counts, symbolizing their standing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BECountesssHeadband : BEHelmet {
	BECountesssHeadband() : base() {
		$this.Name               = 'Countess''s Headband'
		$this.MapObjName         = 'countesssheadband'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A stylish headband worn by countesses, adorned with minor jewels.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEKnight-CaptainsHelm : BEHelmet {
	BEKnightCaptainsHelm() : base() {
		$this.Name               = 'Knight-Captain''s Helm'
		$this.MapObjName         = 'knightcaptainshelm'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A distinguished helm worn by knight-captains, leading their brethren.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESergeantsHelmet : BEHelmet {
	BESergeantsHelmet() : base() {
		$this.Name               = 'Sergeant''s Helmet'
		$this.MapObjName         = 'sergeantshelmet'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::Defense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A practical helmet worn by sergeants, designed for frontline leadership.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERecruitsCap : BEHelmet {
	BERecruitsCap() : base() {
		$this.Name               = 'Recruit''s Cap'
		$this.MapObjName         = 'recruitscap'
		$this.PurchasePrice      = 20
		$this.SellPrice          = 10
		$this.TargetStats        = @{
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A basic cap given to new recruits, offering minimal protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVeteransHelm : BEHelmet {
	BEVeteransHelm() : base() {
		$this.Name               = 'Veteran''s Helm'
		$this.MapObjName         = 'veteranshelm'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A battle-scarred helm worn by veterans, showing their experience.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEliteGuardHelm : BEHelmet {
	BEEliteGuardHelm() : base() {
		$this.Name               = 'Elite Guard Helm'
		$this.MapObjName         = 'eliteguardhelm'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A polished helm worn by elite guards, offering superior defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERoyalGuardHelm : BEHelmet {
	BERoyalGuardHelm() : base() {
		$this.Name               = 'Royal Guard Helm'
		$this.MapObjName         = 'royalguardhelm'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A highly ornate helm worn by royal guards, signifying their loyalty.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETempleGuardHelm : BEHelmet {
	BETempleGuardHelm() : base() {
		$this.Name               = 'Temple Guard Helm'
		$this.MapObjName         = 'templeguardhelm'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sacred helm worn by temple guards, imbued with divine protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEShadowGuardHelm : BEHelmet {
	BEShadowGuardHelm() : base() {
		$this.Name               = 'Shadow Guard Helm'
		$this.MapObjName         = 'shadowguardhelm'
		$this.PurchasePrice      = 1350
		$this.SellPrice          = 675
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark helm worn by shadow guards, aiding in stealth and ambush.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEArenaChampionsHelm : BEHelmet {
	BEArenaChampionsHelm() : base() {
		$this.Name               = 'Arena Champion''s Helm'
		$this.MapObjName         = 'arenachampionshelm'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A fearsome helm worn by arena champions, inspiring awe and fear.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGrandmastersHelm : BEHelmet {
	BEGrandmastersHelm() : base() {
		$this.Name               = 'Grandmaster''s Helm'
		$this.MapObjName         = 'grandmastershelm'
		$this.PurchasePrice      = 2800
		$this.SellPrice          = 1400
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A legendary helm worn by grandmasters of a martial art or order.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESacredHelm : BEHelmet {
	BESacredHelm() : base() {
		$this.Name               = 'Sacred Helm'
		$this.MapObjName         = 'sacredhelm'
		$this.PurchasePrice      = 2700
		$this.SellPrice          = 1350
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm blessed by ancient deities, offering immense spiritual protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEProfaneHelm : BEHelmet {
	BEProfaneHelm() : base() {
		$this.Name               = 'Profane Helm'
		$this.MapObjName         = 'profanehelm'
		$this.PurchasePrice      = 2600
		$this.SellPrice          = 1300
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm cursed by dark powers, granting immense destructive capabilities.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBlessedCirclet : BEHelmet {
	BEBlessedCirclet() : base() {
		$this.Name               = 'Blessed Circlet'
		$this.MapObjName         = 'blessedcirclet'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple circlet blessed by a cleric, offering minor protection.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BECursedHeadband : BEHelmet {
	BECursedHeadband() : base() {
		$this.Name               = 'Cursed Headband'
		$this.MapObjName         = 'cursedheadband'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A headband imbued with a minor curse, granting some power at a cost.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDemonicCirclet : BEHelmet {
	BEDemonicCirclet() : base() {
		$this.Name               = 'Demonic Circlet'
		$this.MapObjName         = 'demoniccirclet'
		$this.PurchasePrice      = 2300
		$this.SellPrice          = 1150
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A circlet forged in hellfire, granting control over minor demons.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAngelicHalo : BEHelmet {
	BEAngelicHalo() : base() {
		$this.Name               = 'Angelic Halo'
		$this.MapObjName         = 'angelichalo'
		$this.PurchasePrice      = 2400
		$this.SellPrice          = 1200
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A luminous halo of pure light, granting divine blessings.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFieryHelm : BEHelmet {
	BEFieryHelm() : base() {
		$this.Name               = 'Fiery Helm'
		$this.MapObjName         = 'fieryhelm'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm wreathed in eternal flames, burning enemies on contact.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEIcyHelm : BEHelmet {
	BEIcyHelm() : base() {
		$this.Name               = 'Icy Helm'
		$this.MapObjName         = 'icyhelm'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm covered in permafrost, freezing enemies with each blow.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEShockingHelm : BEHelmet {
	BEShockingHelm() : base() {
		$this.Name               = 'Shocking Helm'
		$this.MapObjName         = 'shockinghelm'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm crackling with electricity, paralyzing foes with lightning.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPoisonousHelm : BEHelmet {
	BEPoisonousHelm() : base() {
		$this.Name               = 'Poisonous Helm'
		$this.MapObjName         = 'poisonoushelm'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm dripping with venom, poisoning enemies upon contact.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStoneSkinHelm : BEHelmet {
	BEStoneSkinHelm() : base() {
		$this.Name               = 'Stone Skin Helm'
		$this.MapObjName         = 'stoneskinhelm'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that turns the wearer''s skin to stone, providing immense defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWindsEmbraceHelm : BEHelmet {
	BEWindsEmbraceHelm() : base() {
		$this.Name               = 'Wind''s Embrace Helm'
		$this.MapObjName         = 'windsembracehelm'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light helm that allows the wearer to move with the swiftness of wind.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVoidTouchedHelm : BEHelmet {
	BEVoidTouchedHelm() : base() {
		$this.Name               = 'Void Touched Helm'
		$this.MapObjName         = 'voidtouchedhelm'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that has touched the void, granting resistance to void energies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELightforgedHelm : BEHelmet {
	BELightforgedHelm() : base() {
		$this.Name               = 'Lightforged Helm'
		$this.MapObjName         = 'lightforgedhelm'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm forged with holy light, devastating to dark creatures.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDarkforgedHelm : BEHelmet {
	BEDarkforgedHelm() : base() {
		$this.Name               = 'Darkforged Helm'
		$this.MapObjName         = 'darkforgedhelm'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm forged in darkness, powerful against light creatures.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERuneofStrengthHelm : BEHelmet {
	BERuneofStrengthHelm() : base() {
		$this.Name               = 'Rune of Strength Helm'
		$this.MapObjName         = 'runeofstrengthhelm'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm inscribed with a rune of strength, greatly boosting physical power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BERuneofMagicHelm : BEHelmet {
	BERuneofMagicHelm() : base() {
		$this.Name               = 'Rune of Magic Helm'
		$this.MapObjName         = 'runeofmagichelm'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm inscribed with a rune of magic, greatly boosting magical power.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERuneofProtectionHelm : BEHelmet {
	BERuneofProtectionHelm() : base() {
		$this.Name               = 'Rune of Protection Helm'
		$this.MapObjName         = 'runeofprotectionhelm'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm inscribed with a rune of protection, significantly increasing defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERuneofSpeedHelm : BEHelmet {
	BERuneofSpeedHelm() : base() {
		$this.Name               = 'Rune of Speed Helm'
		$this.MapObjName         = 'runeofspeedhelm'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm inscribed with a rune of speed, increasing agility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERuneofWisdomHelm : BEHelmet {
	BERuneofWisdomHelm() : base() {
		$this.Name               = 'Rune of Wisdom Helm'
		$this.MapObjName         = 'runeofwisdomhelm'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm inscribed with a rune of wisdom, boosting intellect.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERuneofVitalityHelm : BEHelmet {
	BERuneofVitalityHelm() : base() {
		$this.Name               = 'Rune of Vitality Helm'
		$this.MapObjName         = 'runeofvitalityhelm'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm inscribed with a rune of vitality, increasing health.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERuneofFuryHelm : BEHelmet {
	BERuneofFuryHelm() : base() {
		$this.Name               = 'Rune of Fury Helm'
		$this.MapObjName         = 'runeoffuryhelm'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm inscribed with a rune of fury, increasing attack at low health.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BERuneofSerenityHelm : BEHelmet {
	BERuneofSerenityHelm() : base() {
		$this.Name               = 'Rune of Serenity Helm'
		$this.MapObjName         = 'runeofserenityhelm'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm inscribed with a rune of serenity, calming the mind and boosting magic.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHeroicHelm : BEHelmet {
	BEHeroicHelm() : base() {
		$this.Name               = 'Heroic Helm'
		$this.MapObjName         = 'heroichelm'
		$this.PurchasePrice      = 3000
		$this.SellPrice          = 1500
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm of ancient heroes, inspiring allies and striking fear in foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BELegendaryHelm : BEHelmet {
	BELegendaryHelm() : base() {
		$this.Name               = 'Legendary Helm'
		$this.MapObjName         = 'legendaryhelm'
		$this.PurchasePrice      = 3500
		$this.SellPrice          = 1750
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm from forgotten legends, imbued with immense, mysterious power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMythicHelm : BEHelmet {
	BEMythicHelm() : base() {
		$this.Name               = 'Mythic Helm'
		$this.MapObjName         = 'mythichelm'
		$this.PurchasePrice      = 4000
		$this.SellPrice          = 2000
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm from the age of myths, possessing unparalleled power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDivineHelm : BEHelmet {
	BEDivineHelm() : base() {
		$this.Name               = 'Divine Helm'
		$this.MapObjName         = 'divinehelm'
		$this.PurchasePrice      = 4500
		$this.SellPrice          = 2250
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm of divine origin, granting godly powers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAbyssalHelm : BEHelmet {
	BEAbyssalHelm() : base() {
		$this.Name               = 'Abyssal Helm'
		$this.MapObjName         = 'abyssalhelm'
		$this.PurchasePrice      = 4300
		$this.SellPrice          = 2150
		$this.TargetStats        = @{
			[StatId]::Defense = 38
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm from the darkest depths of the abyss, granting unholy power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECelestialHelm : BEHelmet {
	BECelestialHelm() : base() {
		$this.Name               = 'Celestial Helm'
		$this.MapObjName         = 'celestialhelm'
		$this.PurchasePrice      = 4200
		$this.SellPrice          = 2100
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm descended from the heavens, radiating pure light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDreamersVeil : BEHelmet {
	BEDreamersVeil() : base() {
		$this.Name               = 'Dreamer''s Veil'
		$this.MapObjName         = 'dreamersveil'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A veil that allows the wearer to enter and manipulate dreams.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEWanderersCap : BEHelmet {
	BEWanderersCap() : base() {
		$this.Name               = 'Wanderer''s Cap'
		$this.MapObjName         = 'wandererscap'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A practical cap for a long journey, providing comfort and minor protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPioneersHat : BEHelmet {
	BEPioneersHat() : base() {
		$this.Name               = 'Pioneer''s Hat'
		$this.MapObjName         = 'pioneershat'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sturdy hat for pioneers, essential for exploration.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPathfindersHelm : BEHelmet {
	BEPathfindersHelm() : base() {
		$this.Name               = 'Pathfinder''s Helm'
		$this.MapObjName         = 'pathfindershelm'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::Defense = 4
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that helps pathfinders navigate treacherous terrain.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEExplorersGoggles : BEHelmet {
	BEExplorersGoggles() : base() {
		$this.Name               = 'Explorer''s Goggles'
		$this.MapObjName         = 'explorersgoggles'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Goggles that aid explorers in spotting hidden details.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAdventurersHelmet : BEHelmet {
	BEAdventurersHelmet() : base() {
		$this.Name               = 'Adventurer''s Helmet'
		$this.MapObjName         = 'adventurershelmet'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::Defense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A reliable helmet for any adventurer, offering balanced protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERelicHuntersHeadband : BEHelmet {
	BERelicHuntersHeadband() : base() {
		$this.Name               = 'Relic Hunter''s Headband'
		$this.MapObjName         = 'relichuntersheadband'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A headband that subtly hums when near ancient relics.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETreasureSeekersHelm : BEHelmet {
	BETreasureSeekersHelm() : base() {
		$this.Name               = 'Treasure Seeker''s Helm'
		$this.MapObjName         = 'treasureseekershelm'
		$this.PurchasePrice      = 220
		$this.SellPrice          = 110
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that occasionally gleams when hidden treasure is nearby.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGraveRobbersMask : BEHelmet {
	BEGraveRobbersMask() : base() {
		$this.Name               = 'Grave Robber''s Mask'
		$this.MapObjName         = 'graverobbersmask'
		$this.PurchasePrice      = 160
		$this.SellPrice          = 80
		$this.TargetStats        = @{
			[StatId]::Defense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark mask worn by grave robbers, aiding in stealth in tombs.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDungeonDelversHelm : BEHelmet {
	BEDungeonDelversHelm() : base() {
		$this.Name               = 'Dungeon Delver''s Helm'
		$this.MapObjName         = 'dungeondelvershelm'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robust helm for dungeon delvers, protecting against traps.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDragonSlayersHelm : BEHelmet {
	BEDragonSlayersHelm() : base() {
		$this.Name               = 'Dragon Slayer''s Helm'
		$this.MapObjName         = 'dragonslayershelm'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm specifically designed for slaying dragons, enhancing anti-dragon abilities.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEGiantKillersHelm : BEHelmet {
	BEGiantKillersHelm() : base() {
		$this.Name               = 'Giant Killer''s Helm'
		$this.MapObjName         = 'giantkillershelm'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that enhances the wearer''s ability to fight giants.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEMonsterHuntersHelm : BEHelmet {
	BEMonsterHuntersHelm() : base() {
		$this.Name               = 'Monster Hunter''s Helm'
		$this.MapObjName         = 'monsterhuntershelm'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A general-purpose helm for hunting all manner of monsters.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBeastTamersBridleHelm : BEHelmet {
	BEBeastTamersBridleHelm() : base() {
		$this.Name               = 'Beast Tamer''s Bridle Helm'
		$this.MapObjName         = 'beasttamersbridlehelm'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A unique helm that aids in taming wild beasts.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFamiliarsBondHelm : BEHelmet {
	BEFamiliarsBondHelm() : base() {
		$this.Name               = 'Familiar''s Bond Helm'
		$this.MapObjName         = 'familiarsbondhelm'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that strengthens the bond with a magical familiar.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESummonersCrown : BEHelmet {
	BESummonersCrown() : base() {
		$this.Name               = 'Summoner''s Crown'
		$this.MapObjName         = 'summonerscrown'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 21
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crown that amplifies summoning magic, allowing for more powerful summons.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

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

Class BEGolemCommandersHelm : BEHelmet {
	BEGolemCommandersHelm() : base() {
		$this.Name               = 'Golem Commander''s Helm'
		$this.MapObjName         = 'golemcommandershelm'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 19
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that allows direct mental control over nearby golems.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAutomatonPilotsHelm : BEHelmet {
	BEAutomatonPilotsHelm() : base() {
		$this.Name               = 'Automaton Pilot''s Helm'
		$this.MapObjName         = 'automatonpilotshelm'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm for piloting large automatons, providing necessary controls.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEClockworkEngineersGoggles : BEHelmet {
	BEClockworkEngineersGoggles() : base() {
		$this.Name               = 'Clockwork Engineer''s Goggles'
		$this.MapObjName         = 'clockworkengineersgoggles'
		$this.PurchasePrice      = 170
		$this.SellPrice          = 85
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Goggles that aid in precise clockwork construction and repair.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEArtificersCrown : BEHelmet {
	BEArtificersCrown() : base() {
		$this.Name               = 'Artificer''s Crown'
		$this.MapObjName         = 'artificerscrown'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crown worn by master artificers, greatly enhancing their creations.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEInventorsHelm : BEHelmet {
	BEInventorsHelm() : base() {
		$this.Name               = 'Inventor''s Helm'
		$this.MapObjName         = 'inventorshelm'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that inspires grand inventions and complex designs.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMadScientistsHeadgear : BEHelmet {
	BEMadScientistsHeadgear() : base() {
		$this.Name               = 'Mad Scientist''s Headgear'
		$this.MapObjName         = 'madscientistsheadgear'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Erratic headgear that amplifies chaotic experiments.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEApothecarysMortarCap : BEHelmet {
	BEApothecarysMortarCap() : base() {
		$this.Name               = 'Apothecary''s Mortar Cap'
		$this.MapObjName         = 'apothecarysmortarcap'
		$this.PurchasePrice      = 130
		$this.SellPrice          = 65
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cap worn by apothecaries, aiding in the creation of potent concoctions.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHerbalistsWovenHat : BEHelmet {
	BEHerbalistsWovenHat() : base() {
		$this.Name               = 'Herbalist''s Woven Hat'
		$this.MapObjName         = 'herbalistswovenhat'
		$this.PurchasePrice      = 110
		$this.SellPrice          = 55
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A hat woven from herbs, enhancing knowledge of plants.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEChefsToqueHelm : BEHelmet {
	BEChefsToqueHelm() : base() {
		$this.Name               = 'Chef''s Toque Helm'
		$this.MapObjName         = 'chefstoquehelm'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::Defense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A surprisingly sturdy helm designed for battle-chefs, offering a surprising amount of protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFishermansHat : BEHelmet {
	BEFishermansHat() : base() {
		$this.Name               = 'Fisherman''s Hat'
		$this.MapObjName         = 'fishermanshat'
		$this.PurchasePrice      = 50
		$this.SellPrice          = 25
		$this.TargetStats        = @{
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A wide-brimmed hat that protects fishermen from the elements.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFarmersStrawHat : BEHelmet {
	BEFarmersStrawHat() : base() {
		$this.Name               = 'Farmer''s Straw Hat'
		$this.MapObjName         = 'farmersstrawhat'
		$this.PurchasePrice      = 30
		$this.SellPrice          = 15
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple straw hat, offering basic sun protection.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMinersHardHat : BEHelmet {
	BEMinersHardHat() : base() {
		$this.Name               = 'Miner''s Hard Hat'
		$this.MapObjName         = 'minershardhat'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A hard hat with a lamp, essential for mining.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELumberjacksCap : BEHelmet {
	BELumberjacksCap() : base() {
		$this.Name               = 'Lumberjack''s Cap'
		$this.MapObjName         = 'lumberjackscap'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rugged cap for lumberjacks, offering protection from falling debris.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHuntersFurHood : BEHelmet {
	BEHuntersFurHood() : base() {
		$this.Name               = 'Hunter''s Fur Hood'
		$this.MapObjName         = 'huntersfurhood'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::Defense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A warm fur hood for hunters, providing warmth and stealth in cold climates.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFishermansKnitCap : BEHelmet {
	BEFishermansKnitCap() : base() {
		$this.Name               = 'Fisherman''s Knit Cap'
		$this.MapObjName         = 'fishermansknitcap'
		$this.PurchasePrice      = 60
		$this.SellPrice          = 30
		$this.TargetStats        = @{
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A warm knit cap for fishermen, warding off the cold.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEShepherdsWoolCap : BEHelmet {
	BEShepherdsWoolCap() : base() {
		$this.Name               = 'Shepherd''s Wool Cap'
		$this.MapObjName         = 'shepherdswoolcap'
		$this.PurchasePrice      = 40
		$this.SellPrice          = 20
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple wool cap worn by shepherds, providing warmth.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFarmersSunHat : BEHelmet {
	BEFarmersSunHat() : base() {
		$this.Name               = 'Farmer''s Sun Hat'
		$this.MapObjName         = 'farmerssunhat'
		$this.PurchasePrice      = 35
		$this.SellPrice          = 17
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A wide sun hat for farmers, protecting from the sun''s glare.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBrewersCap : BEHelmet {
	BEBrewersCap() : base() {
		$this.Name               = 'Brewer''s Cap'
		$this.MapObjName         = 'brewerscap'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A traditional cap worn by brewers, ensuring good spirits.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBakersToque : BEHelmet {
	BEBakersToque() : base() {
		$this.Name               = 'Baker''s Toque'
		$this.MapObjName         = 'bakerstoque'
		$this.PurchasePrice      = 60
		$this.SellPrice          = 30
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tall white hat worn by bakers, protecting their hair and symbolizing their craft.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEInnkeepersHeadband : BEHelmet {
	BEInnkeepersHeadband() : base() {
		$this.Name               = 'Innkeeper''s Headband'
		$this.MapObjName         = 'innkeepersheadband'
		$this.PurchasePrice      = 40
		$this.SellPrice          = 20
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple headband worn by innkeepers, offering a welcoming demeanor.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMerchantsTurban : BEHelmet {
	BEMerchantsTurban() : base() {
		$this.Name               = 'Merchant''s Turban'
		$this.MapObjName         = 'merchantsturban'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A practical turban worn by merchants, suitable for travel.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECaravanMastersHelm : BEHelmet {
	BECaravanMastersHelm() : base() {
		$this.Name               = 'Caravan Master''s Helm'
		$this.MapObjName         = 'caravanmastershelm'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::Defense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sturdy helm worn by caravan masters, protecting during long journeys.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESailorsSouwester : BEHelmet {
	BESailorsSouwester() : base() {
		$this.Name               = 'Sailor''s Sou''wester'
		$this.MapObjName         = 'sailorssouwester'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A waterproof hat worn by sailors, protecting from spray and rain.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPirateCaptainsTricorne : BEHelmet {
	BEPirateCaptainsTricorne() : base() {
		$this.Name               = 'Pirate Captain''s Tricorne'
		$this.MapObjName         = 'piratecaptainstricorne'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A classic pirate captain''s hat, inspiring fear and loyalty.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

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

Class BEExplorersPithHelmet : BEHelmet {
	BEExplorersPithHelmet() : base() {
		$this.Name               = 'Explorer''s Pith Helmet'
		$this.MapObjName         = 'explorerspithhelmet'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A classic pith helmet for explorers, offering sun protection in exotic lands.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBigGameHuntersHat : BEHelmet {
	BEBigGameHuntersHat() : base() {
		$this.Name               = 'Big Game Hunter''s Hat'
		$this.MapObjName         = 'biggamehuntershat'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::Defense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A distinctive hat worn by big game hunters, indicating their prowess.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESafariHat : BEHelmet {
	BESafariHat() : base() {
		$this.Name               = 'Safari Hat'
		$this.MapObjName         = 'safarihat'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A practical hat for safaris, providing sun protection and camouflage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEForestersCap : BEHelmet {
	BEForestersCap() : base() {
		$this.Name               = 'Forester''s Cap'
		$this.MapObjName         = 'foresterscap'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cap for foresters, blending in with nature and providing light protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGardenersHat : BEHelmet {
	BEGardenersHat() : base() {
		$this.Name               = 'Gardener''s Hat'
		$this.MapObjName         = 'gardenershat'
		$this.PurchasePrice      = 30
		$this.SellPrice          = 15
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A wide-brimmed hat for gardeners, protecting from the sun.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFloristsGarland : BEHelmet {
	BEFloristsGarland() : base() {
		$this.Name               = 'Florist''s Garland'
		$this.MapObjName         = 'floristsgarland'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A delicate garland of flowers worn by florists, imbued with subtle nature magic.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEZoologistsHeadband : BEHelmet {
	BEZoologistsHeadband() : base() {
		$this.Name               = 'Zoologist''s Headband'
		$this.MapObjName         = 'zoologistsheadband'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A headband that aids zoologists in understanding animal behavior.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBotanistsCirclet : BEHelmet {
	BEBotanistsCirclet() : base() {
		$this.Name               = 'Botanist''s Circlet'
		$this.MapObjName         = 'botanistscirclet'
		$this.PurchasePrice      = 110
		$this.SellPrice          = 55
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A circlet that enhances a botanist''s knowledge of plants and their properties.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGeologistsHardHat : BEHelmet {
	BEGeologistsHardHat() : base() {
		$this.Name               = 'Geologist''s Hard Hat'
		$this.MapObjName         = 'geologistshardhat'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A hard hat used by geologists, protecting from falling rocks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAstronomersHood : BEHelmet {
	BEAstronomersHood() : base() {
		$this.Name               = 'Astronomer''s Hood'
		$this.MapObjName         = 'astronomershood'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A hood that aids astronomers in observing the night sky.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHistoriansSpectacles : BEHelmet {
	BEHistoriansSpectacles() : base() {
		$this.Name               = 'Historian''s Spectacles'
		$this.MapObjName         = 'historiansspectacles'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Spectacles that aid historians in deciphering ancient texts.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELibrariansEye-shade : BEHelmet {
	BELibrariansEyeshade() : base() {
		$this.Name               = 'Librarian''s Eye-shade'
		$this.MapObjName         = 'librarianseyeshade'
		$this.PurchasePrice      = 50
		$this.SellPrice          = 25
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An eye-shade that helps librarians focus on their reading.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECartographersCompassHelm : BEHelmet {
	BECartographersCompassHelm() : base() {
		$this.Name               = 'Cartographer''s Compass Helm'
		$this.MapObjName         = 'cartographerscompasshelm'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm with an integrated compass, aiding cartographers in mapping.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMusiciansHeadband : BEHelmet {
	BEMusiciansHeadband() : base() {
		$this.Name               = 'Musician''s Headband'
		$this.MapObjName         = 'musiciansheadband'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A headband that helps musicians maintain rhythm and harmony.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPoetsLaurelWreath : BEHelmet {
	BEPoetsLaurelWreath() : base() {
		$this.Name               = 'Poet''s Laurel Wreath'
		$this.MapObjName         = 'poetslaurelwreath'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A laurel wreath worn by poets, inspiring eloquence.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWritersQuillCap : BEHelmet {
	BEWritersQuillCap() : base() {
		$this.Name               = 'Writer''s Quill Cap'
		$this.MapObjName         = 'writersquillcap'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cap with a quill, aiding writers in their craft.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOratorsHeadpiece : BEHelmet {
	BEOratorsHeadpiece() : base() {
		$this.Name               = 'Orator''s Headpiece'
		$this.MapObjName         = 'oratorsheadpiece'
		$this.PurchasePrice      = 130
		$this.SellPrice          = 65
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A stately headpiece worn by orators, enhancing their persuasive abilities.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDiplomatsHat : BEHelmet {
	BEDiplomatsHat() : base() {
		$this.Name               = 'Diplomat''s Hat'
		$this.MapObjName         = 'diplomatshat'
		$this.PurchasePrice      = 140
		$this.SellPrice          = 70
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A refined hat worn by diplomats, conveying respect and authority.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BENegotiatorsHeadband : BEHelmet {
	BENegotiatorsHeadband() : base() {
		$this.Name               = 'Negotiator''s Headband'
		$this.MapObjName         = 'negotiatorsheadband'
		$this.PurchasePrice      = 110
		$this.SellPrice          = 55
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A headband that aids negotiators in finding common ground.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESpysDisguiseHat : BEHelmet {
	BESpysDisguiseHat() : base() {
		$this.Name               = 'Spy''s Disguise Hat'
		$this.MapObjName         = 'spysdisguisehat'
		$this.PurchasePrice      = 40
		$this.SellPrice          = 20
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple hat used by spies to blend into crowds.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEInfiltratorsMask : BEHelmet {
	BEInfiltratorsMask() : base() {
		$this.Name               = 'Infiltrator''s Mask'
		$this.MapObjName         = 'infiltratorsmask'
		$this.PurchasePrice      = 160
		$this.SellPrice          = 80
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark mask worn by infiltrators, aiding in covert operations.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESentrysHelmet : BEHelmet {
	BESentrysHelmet() : base() {
		$this.Name               = 'Sentry''s Helmet'
		$this.MapObjName         = 'sentryshelmet'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{
			[StatId]::Defense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A standard helmet for sentries, providing reliable protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBodyguardsHelm : BEHelmet {
	BEBodyguardsHelm() : base() {
		$this.Name               = 'Bodyguard''s Helm'
		$this.MapObjName         = 'bodyguardshelm'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::Defense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy helm for bodyguards, ensuring the protection of their charge.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEExecutionersHood : BEHelmet {
	BEExecutionersHood() : base() {
		$this.Name               = 'Executioner''s Hood'
		$this.MapObjName         = 'executionershood'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A grim hood worn by executioners, concealing their identity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEJailersHelmet : BEHelmet {
	BEJailersHelmet() : base() {
		$this.Name               = 'Jailer''s Helmet'
		$this.MapObjName         = 'jailershelmet'
		$this.PurchasePrice      = 190
		$this.SellPrice          = 95
		$this.TargetStats        = @{
			[StatId]::Defense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sturdy helmet for jailers, protecting them from inmates.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEJudgesWig : BEHelmet {
	BEJudgesWig() : base() {
		$this.Name               = 'Judge''s Wig'
		$this.MapObjName         = 'judgeswig'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A formal wig worn by judges, symbolizing justice and authority.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELawyersHeadband : BEHelmet {
	BELawyersHeadband() : base() {
		$this.Name               = 'Lawyer''s Headband'
		$this.MapObjName         = 'lawyersheadband'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A modest headband for lawyers, aiding in quick thinking.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDoctorsHeadMirror : BEHelmet {
	BEDoctorsHeadMirror() : base() {
		$this.Name               = 'Doctor''s Head Mirror'
		$this.MapObjName         = 'doctorsheadmirror'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A reflective mirror worn by doctors, aiding in examinations.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BENursesCap : BEHelmet {
	BENursesCap() : base() {
		$this.Name               = 'Nurse''s Cap'
		$this.MapObjName         = 'nursescap'
		$this.PurchasePrice      = 50
		$this.SellPrice          = 25
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple cap worn by nurses, symbolizing care and dedication.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEPatientsHeadwrap : BEHelmet {
	BEPatientsHeadwrap() : base() {
		$this.Name               = 'Patient''s Headwrap'
		$this.MapObjName         = 'patientsheadwrap'
		$this.PurchasePrice      = 20
		$this.SellPrice          = 10
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A soft headwrap for patients, offering comfort.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEApothecarysGoggles : BEHelmet {
	BEApothecarysGoggles() : base() {
		$this.Name               = 'Apothecary''s Goggles'
		$this.MapObjName         = 'apothecarysgoggles'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Protective goggles worn by apothecaries, for handling volatile concoctions.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEUndertakersTopHat : BEHelmet {
	BEUndertakersTopHat() : base() {
		$this.Name               = 'Undertaker''s Top Hat'
		$this.MapObjName         = 'undertakerstophat'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A solemn top hat worn by undertakers, reflecting their profession.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGravekeepersLanternHelm : BEHelmet {
	BEGravekeepersLanternHelm() : base() {
		$this.Name               = 'Gravekeeper''s Lantern Helm'
		$this.MapObjName         = 'gravekeeperslanternhelm'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::Defense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm with an integrated lantern, aiding gravekeepers at night.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFuneralDirectorsBowlerHat : BEHelmet {
	BEFuneralDirectorsBowlerHat() : base() {
		$this.Name               = 'Funeral Director''s Bowler Hat'
		$this.MapObjName         = 'funeraldirectorsbowlerhat'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A formal bowler hat worn by funeral directors, conveying professionalism.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMournersVeil : BEHelmet {
	BEMournersVeil() : base() {
		$this.Name               = 'Mourner''s Veil'
		$this.MapObjName         = 'mournersveil'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark veil worn by mourners, symbolizing grief.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Female
	}
}

Class BESpiritMediumsHeadband : BEHelmet {
	BESpiritMediumsHeadband() : base() {
		$this.Name               = 'Spirit Medium''s Headband'
		$this.MapObjName         = 'spiritmediumsheadband'
		$this.PurchasePrice      = 160
		$this.SellPrice          = 80
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A headband that aids spirit mediums in communicating with the deceased.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEExorcistsHeadpiece : BEHelmet {
	BEExorcistsHeadpiece() : base() {
		$this.Name               = 'Exorcist''s Headpiece'
		$this.MapObjName         = 'exorcistsheadpiece'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A holy headpiece worn by exorcists, warding off demonic influence.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEInquisitorsBlindfold : BEHelmet {
	BEInquisitorsBlindfold() : base() {
		$this.Name               = 'Inquisitor''s Blindfold'
		$this.MapObjName         = 'inquisitorsblindfold'
		$this.PurchasePrice      = 170
		$this.SellPrice          = 85
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A blindfold worn by certain inquisitors, allowing them to focus on inner vision.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEZealotsHeadwrap : BEHelmet {
	BEZealotsHeadwrap() : base() {
		$this.Name               = 'Zealot''s Headwrap'
		$this.MapObjName         = 'zealotsheadwrap'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple headwrap worn by zealots, signifying their fervent devotion.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFanaticsMask : BEHelmet {
	BEFanaticsMask() : base() {
		$this.Name               = 'Fanatic''s Mask'
		$this.MapObjName         = 'fanaticsmask'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::Defense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A terrifying mask worn by fanatics, inspiring fear and unwavering loyalty.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHereticsMarkHeadband : BEHelmet {
	BEHereticsMarkHeadband() : base() {
		$this.Name               = 'Heretic''s Mark Headband'
		$this.MapObjName         = 'hereticsmarkheadband'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cursed headband that marks the wearer as a heretic.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEApostatesHood : BEHelmet {
	BEApostatesHood() : base() {
		$this.Name               = 'Apostate''s Hood'
		$this.MapObjName         = 'apostateshood'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark hood worn by apostates, symbolizing their rejection of faith.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESacrificesShroud : BEHelmet {
	BESacrificesShroud() : base() {
		$this.Name               = 'Sacrifice''s Shroud'
		$this.MapObjName         = 'sacrificesshroud'
		$this.PurchasePrice      = 10
		$this.SellPrice          = 5
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple shroud for ritual sacrifices, offering no protection.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERitualistsMask : BEHelmet {
	BERitualistsMask() : base() {
		$this.Name               = 'Ritualist''s Mask'
		$this.MapObjName         = 'ritualistsmask'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ceremonial mask worn by ritualists, enhancing their arcane ceremonies.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDivinationOrbHelm : BEHelmet {
	BEDivinationOrbHelm() : base() {
		$this.Name               = 'Divination Orb Helm'
		$this.MapObjName         = 'divinationorbhelm'
		$this.PurchasePrice      = 220
		$this.SellPrice          = 110
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 11
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm with a scrying orb, aiding in divination.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESeersEyepatch : BEHelmet {
	BESeersEyepatch() : base() {
		$this.Name               = 'Seer''s Eyepatch'
		$this.MapObjName         = 'seerseyepatch'
		$this.PurchasePrice      = 130
		$this.SellPrice          = 65
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An eyepatch worn by seers, sometimes to focus their prophetic visions.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMysticsHeadband : BEHelmet {
	BEMysticsHeadband() : base() {
		$this.Name               = 'Mystic''s Headband'
		$this.MapObjName         = 'mysticsheadband'
		$this.PurchasePrice      = 140
		$this.SellPrice          = 70
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple headband worn by mystics, aiding in meditation and enlightenment.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEnlightenedOnesCrown : BEHelmet {
	BEEnlightenedOnesCrown() : base() {
		$this.Name               = 'Enlightened One''s Crown'
		$this.MapObjName         = 'enlightenedonescrown'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crown worn by those who have achieved enlightenment, radiating inner peace.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAscendantsHalo : BEHelmet {
	BEAscendantsHalo() : base() {
		$this.Name               = 'Ascendant''s Halo'
		$this.MapObjName         = 'ascendantshalo'
		$this.PurchasePrice      = 2800
		$this.SellPrice          = 1400
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A halo that signifies ascension to a higher plane of existence.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BENirvanaHelm : BEHelmet {
	BENirvanaHelm() : base() {
		$this.Name               = 'Nirvana Helm'
		$this.MapObjName         = 'nirvanahelm'
		$this.PurchasePrice      = 3000
		$this.SellPrice          = 1500
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that grants the wearer a state of ultimate peace and detachment.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESagesCircletofAges : BEHelmet {
	BESagesCircletofAges() : base() {
		$this.Name               = 'Sage''s Circlet of Ages'
		$this.MapObjName         = 'sagescircletofages'
		$this.PurchasePrice      = 3200
		$this.SellPrice          = 1600
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A circlet that grants access to the wisdom of all ages.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEProphetsCrownofForetelling : BEHelmet {
	BEProphetsCrownofForetelling() : base() {
		$this.Name               = 'Prophet''s Crown of Foretelling'
		$this.MapObjName         = 'prophetscrownofforetelling'
		$this.PurchasePrice      = 3500
		$this.SellPrice          = 1750
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crown that grants glimpses of future events, both good and ill.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOraclesDivineSightOrb : BEHelmet {
	BEOraclesDivineSightOrb() : base() {
		$this.Name               = 'Oracle''s Divine Sight Orb'
		$this.MapObjName         = 'oraclesdivinesightorb'
		$this.PurchasePrice      = 3800
		$this.SellPrice          = 1900
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An orb integrated into a helm, granting omniscient vision.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECosmicWanderersHood : BEHelmet {
	BECosmicWanderersHood() : base() {
		$this.Name               = 'Cosmic Wanderer''s Hood'
		$this.MapObjName         = 'cosmicwanderershood'
		$this.PurchasePrice      = 4000
		$this.SellPrice          = 2000
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A hood that aids wanderers across the cosmos, protecting them from stellar energies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStarlightHelm : BEHelmet {
	BEStarlightHelm() : base() {
		$this.Name               = 'Starlight Helm'
		$this.MapObjName         = 'starlighthelm'
		$this.PurchasePrice      = 4200
		$this.SellPrice          = 2100
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that gathers starlight, empowering the wearer with celestial energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BENebulaVeil : BEHelmet {
	BENebulaVeil() : base() {
		$this.Name               = 'Nebula Veil'
		$this.MapObjName         = 'nebulaveil'
		$this.PurchasePrice      = 4500
		$this.SellPrice          = 2250
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A veil that shimmers with the colors of a nebula, concealing the wearer''s true form.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BESolarFlareDiadem : BEHelmet {
	BESolarFlareDiadem() : base() {
		$this.Name               = 'Solar Flare Diadem'
		$this.MapObjName         = 'solarflarediadem'
		$this.PurchasePrice      = 4800
		$this.SellPrice          = 2400
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A diadem that radiates solar energy, providing protection and offensive power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BELunarEmbraceTiara : BEHelmet {
	BELunarEmbraceTiara() : base() {
		$this.Name               = 'Lunar Embrace Tiara'
		$this.MapObjName         = 'lunarembracetiara'
		$this.PurchasePrice      = 4700
		$this.SellPrice          = 2350
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 37
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiara that glows with moonlight, enhancing nocturnal abilities and grace.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEGalacticCoreHelm : BEHelmet {
	BEGalacticCoreHelm() : base() {
		$this.Name               = 'Galactic Core Helm'
		$this.MapObjName         = 'galacticcorehelm'
		$this.PurchasePrice      = 5000
		$this.SellPrice          = 2500
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm infused with the power of a galactic core, granting immense cosmic power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEUniverseShardHelm : BEHelmet {
	BEUniverseShardHelm() : base() {
		$this.Name               = 'Universe Shard Helm'
		$this.MapObjName         = 'universeshardhelm'
		$this.PurchasePrice      = 5500
		$this.SellPrice          = 2750
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm made from fragments of the universe itself, granting unimaginable power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERealityAnchorHelm : BEHelmet {
	BERealityAnchorHelm() : base() {
		$this.Name               = 'Reality Anchor Helm'
		$this.MapObjName         = 'realityanchorhelm'
		$this.PurchasePrice      = 6000
		$this.SellPrice          = 3000
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that anchors the wearer to reality, preventing temporal or dimensional displacement.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDreamWeaversTiara : BEHelmet {
	BEDreamWeaversTiara() : base() {
		$this.Name               = 'Dream Weaver''s Tiara'
		$this.MapObjName         = 'dreamweaverstiara'
		$this.PurchasePrice      = 6500
		$this.SellPrice          = 3250
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 55
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiara that allows the wearer to weave dreams into reality.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BENightmareKingsCrown : BEHelmet {
	BENightmareKingsCrown() : base() {
		$this.Name               = 'Nightmare King''s Crown'
		$this.MapObjName         = 'nightmarekingscrown'
		$this.PurchasePrice      = 7000
		$this.SellPrice          = 3500
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 60
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crown that harnesses nightmares, turning them into tangible fear for enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEEternalSlumberHelm : BEHelmet {
	BEEternalSlumberHelm() : base() {
		$this.Name               = 'Eternal Slumber Helm'
		$this.MapObjName         = 'eternalslumberhelm'
		$this.PurchasePrice      = 7500
		$this.SellPrice          = 3750
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 65
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that puts enemies into an eternal slumber, rendering them harmless.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVoidGazersCrown : BEHelmet {
	BEVoidGazersCrown() : base() {
		$this.Name               = 'Void Gazer''s Crown'
		$this.MapObjName         = 'voidgazerscrown'
		$this.PurchasePrice      = 8000
		$this.SellPrice          = 4000
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 70
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crown that allows deep gazes into the void, granting forbidden knowledge.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEChaosLordsHelm : BEHelmet {
	BEChaosLordsHelm() : base() {
		$this.Name               = 'Chaos Lord''s Helm'
		$this.MapObjName         = 'chaoslordshelm'
		$this.PurchasePrice      = 8500
		$this.SellPrice          = 4250
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 75
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm of pure chaos, granting unpredictable and devastating power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEOrderKeepersHelm : BEHelmet {
	BEOrderKeepersHelm() : base() {
		$this.Name               = 'Order Keeper''s Helm'
		$this.MapObjName         = 'orderkeepershelm'
		$this.PurchasePrice      = 9000
		$this.SellPrice          = 4500
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 80
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that imposes order on chaos, suppressing unruly energies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBalanceKeepersHelm : BEHelmet {
	BEBalanceKeepersHelm() : base() {
		$this.Name               = 'Balance Keeper''s Helm'
		$this.MapObjName         = 'balancekeepershelm'
		$this.PurchasePrice      = 9500
		$this.SellPrice          = 4750
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 85
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that maintains the balance between light and darkness, good and evil.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETruthSeekersHelm : BEHelmet {
	BETruthSeekersHelm() : base() {
		$this.Name               = 'Truth Seeker''s Helm'
		$this.MapObjName         = 'truthseekershelm'
		$this.PurchasePrice      = 10000
		$this.SellPrice          = 5000
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 90
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that reveals the truth, cutting through illusions and lies.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEKnowledgeBringersCrown : BEHelmet {
	BEKnowledgeBringersCrown() : base() {
		$this.Name               = 'Knowledge Bringer''s Crown'
		$this.MapObjName         = 'knowledgebringerscrown'
		$this.PurchasePrice      = 10500
		$this.SellPrice          = 5250
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 95
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crown that bestows immense knowledge upon the wearer.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWisdomGiversHelm : BEHelmet {
	BEWisdomGiversHelm() : base() {
		$this.Name               = 'Wisdom Giver''s Helm'
		$this.MapObjName         = 'wisdomgivershelm'
		$this.PurchasePrice      = 11000
		$this.SellPrice          = 5500
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 100
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that grants profound wisdom, allowing the wearer to see beyond.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDestructionHelm : BEHelmet {
	BEDestructionHelm() : base() {
		$this.Name               = 'Destruction Helm'
		$this.MapObjName         = 'destructionhelm'
		$this.PurchasePrice      = 12000
		$this.SellPrice          = 6000
		$this.TargetStats        = @{
			[StatId]::Defense = 100
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that embodies pure destruction, increasing offensive power exponentially.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BECreationHelm : BEHelmet {
	BECreationHelm() : base() {
		$this.Name               = 'Creation Helm'
		$this.MapObjName         = 'creationhelm'
		$this.PurchasePrice      = 12000
		$this.SellPrice          = 6000
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 100
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that embodies pure creation, allowing for the manifestation of wonders.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BELifeBringersCirclet : BEHelmet {
	BELifeBringersCirclet() : base() {
		$this.Name               = 'Life Bringer''s Circlet'
		$this.MapObjName         = 'lifebringerscirclet'
		$this.PurchasePrice      = 11500
		$this.SellPrice          = 5750
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 98
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A circlet that radiates life energy, healing all around the wearer.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEDeathGiversHelm : BEHelmet {
	BEDeathGiversHelm() : base() {
		$this.Name               = 'Death Giver''s Helm'
		$this.MapObjName         = 'deathgivershelm'
		$this.PurchasePrice      = 11500
		$this.SellPrice          = 5750
		$this.TargetStats        = @{
			[StatId]::Defense = 98
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that radiates death energy, bringing ruin to enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BELightsBeaconHelm : BEHelmet {
	BELightsBeaconHelm() : base() {
		$this.Name               = 'Light''s Beacon Helm'
		$this.MapObjName         = 'lightsbeaconhelm'
		$this.PurchasePrice      = 13000
		$this.SellPrice          = 6500
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 105
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that acts as a beacon of pure light, dispelling all darkness.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEShadowsEmbraceHelm : BEHelmet {
	BEShadowsEmbraceHelm() : base() {
		$this.Name               = 'Shadow''s Embrace Helm'
		$this.MapObjName         = 'shadowsembracehelm'
		$this.PurchasePrice      = 13000
		$this.SellPrice          = 6500
		$this.TargetStats        = @{
			[StatId]::Defense = 105
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that embodies pure shadow, allowing the wearer to command darkness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEElementalLordsCrown : BEHelmet {
	BEElementalLordsCrown() : base() {
		$this.Name               = 'Elemental Lord''s Crown'
		$this.MapObjName         = 'elementallordscrown'
		$this.PurchasePrice      = 14000
		$this.SellPrice          = 7000
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crown that grants mastery over all four classical elements.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETimeLordsHelm : BEHelmet {
	BETimeLordsHelm() : base() {
		$this.Name               = 'Time Lord''s Helm'
		$this.MapObjName         = 'timelordshelm'
		$this.PurchasePrice      = 15000
		$this.SellPrice          = 7500
		$this.TargetStats        = @{
			[StatId]::Defense = 75
			[StatId]::MagicDefense = 75
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that grants absolute control over time itself, allowing reality rewriting.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESpaceLordsHelm : BEHelmet {
	BESpaceLordsHelm() : base() {
		$this.Name               = 'Space Lord''s Helm'
		$this.MapObjName         = 'spacelordshelm'
		$this.PurchasePrice      = 15000
		$this.SellPrice          = 7500
		$this.TargetStats        = @{
			[StatId]::Defense = 75
			[StatId]::MagicDefense = 75
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that grants absolute control over space, allowing teleportation and reality warping.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECosmicLordsHelm : BEHelmet {
	BECosmicLordsHelm() : base() {
		$this.Name               = 'Cosmic Lord''s Helm'
		$this.MapObjName         = 'cosmiclordshelm'
		$this.PurchasePrice      = 20000
		$this.SellPrice          = 10000
		$this.TargetStats        = @{
			[StatId]::Defense = 100
			[StatId]::MagicDefense = 100
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that grants dominion over both time and space, truly omnipotent.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
