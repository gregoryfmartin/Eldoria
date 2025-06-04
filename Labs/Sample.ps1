Class BEWoodenSword : BEWeapon {
	BEWoodenSword() : base() {
		$this.Name               = 'Wooden Sword'
		$this.MapObjName         = 'woodensword'
		$this.PurchasePrice      = 50
		$this.SellPrice          = 25
		$this.TargetStats        = @{ [StatId]::Attack = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple, crudely carved wooden sword. Ideal for beginners.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDagger : BEWeapon {
	BEDagger() : base() {
		$this.Name               = 'Dagger'
		$this.MapObjName         = 'dagger'
		$this.PurchasePrice      = 75
		$this.SellPrice          = 37
		$this.TargetStats        = @{ [StatId]::Attack = 8 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small, sharp blade for quick attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEShortSword : BEWeapon {
	BEShortSword() : base() {
		$this.Name               = 'Short Sword'
		$this.MapObjName         = 'shortsword'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{ [StatId]::Attack = 12 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A standard one-handed sword, good for basic combat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEIronAxe : BEWeapon {
	BEIronAxe() : base() {
		$this.Name               = 'Iron Axe'
		$this.MapObjName         = 'ironaxe'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{ [StatId]::Attack = 15 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy iron axe, effective against armored foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStaff : BEWeapon {
	BEStaff() : base() {
		$this.Name               = 'Staff'
		$this.MapObjName         = 'staff'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{ [StatId]::Attack = 3; [StatId]::MagicAttack = 10 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A plain wooden staff, often used by mages.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBronzeSpear : BEWeapon {
	BEBronzeSpear() : base() {
		$this.Name               = 'Bronze Spear'
		$this.MapObjName         = 'bronzespear'
		$this.PurchasePrice      = 130
		$this.SellPrice          = 65
		$this.TargetStats        = @{ [StatId]::Attack = 10 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A spear with a bronze tip, offering good reach.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESling : BEWeapon {
	BESling() : base() {
		$this.Name               = 'Sling'
		$this.MapObjName         = 'sling'
		$this.PurchasePrice      = 40
		$this.SellPrice          = 20
		$this.TargetStats        = @{ [StatId]::Attack = 4 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple projectile weapon, uses small stones as ammo.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBow : BEWeapon {
	BEBow() : base() {
		$this.Name               = 'Bow'
		$this.MapObjName         = 'bow'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{ [StatId]::Attack = 14 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A basic wooden bow, requires arrows.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELeatherWhip : BEWeapon {
	BELeatherWhip() : base() {
		$this.Name               = 'Leather Whip'
		$this.MapObjName         = 'leatherwhip'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{ [StatId]::Attack = 7 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A flexible whip made of leather, good for crowd control.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEClub : BEWeapon {
	BEClub() : base() {
		$this.Name               = 'Club'
		$this.MapObjName         = 'club'
		$this.PurchasePrice      = 60
		$this.SellPrice          = 30
		$this.TargetStats        = @{ [StatId]::Attack = 6 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy, blunt instrument.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECopperKnuckles : BEWeapon {
	BECopperKnuckles() : base() {
		$this.Name               = 'Copper Knuckles'
		$this.MapObjName         = 'copperknuckles'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{ [StatId]::Attack = 9 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Metal plates worn over the knuckles to enhance punches.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELightCrossbow : BEWeapon {
	BELightCrossbow() : base() {
		$this.Name               = 'Light Crossbow'
		$this.MapObjName         = 'lightcrossbow'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{ [StatId]::Attack = 16 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A compact crossbow, easier to reload than a full-sized one.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEApprenticeWand : BEWeapon {
	BEApprenticeWand() : base() {
		$this.Name               = 'Apprentice Wand'
		$this.MapObjName         = 'apprenticewand'
		$this.PurchasePrice      = 110
		$this.SellPrice          = 55
		$this.TargetStats        = @{ [StatId]::Attack = 2; [StatId]::MagicAttack = 12 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A basic wand for novice spellcasters.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHuntingKnife : BEWeapon {
	BEHuntingKnife() : base() {
		$this.Name               = 'Hunting Knife'
		$this.MapObjName         = 'huntingknife'
		$this.PurchasePrice      = 65
		$this.SellPrice          = 32
		$this.TargetStats        = @{ [StatId]::Attack = 7 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A versatile knife for hunting and survival.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStuddedClub : BEWeapon {
	BEStuddedClub() : base() {
		$this.Name               = 'Studded Club'
		$this.MapObjName         = 'studdedclub'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{ [StatId]::Attack = 11 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A club embedded with metal studs.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStoneAxe : BEWeapon {
	BEStoneAxe() : base() {
		$this.Name               = 'Stone Axe'
		$this.MapObjName         = 'stoneaxe'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{ [StatId]::Attack = 8 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rudimentary axe with a stone head.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFishingRod : BEWeapon {
	BEFishingRod() : base() {
		$this.Name               = 'Fishing Rod'
		$this.MapObjName         = 'fishingrod'
		$this.PurchasePrice      = 30
		$this.SellPrice          = 15
		$this.TargetStats        = @{ [StatId]::Attack = 2 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Not truly a weapon, but can be used in a pinch.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERustySword : BEWeapon {
	BERustySword() : base() {
		$this.Name               = 'Rusty Sword'
		$this.MapObjName         = 'rustysword'
		$this.PurchasePrice      = 45
		$this.SellPrice          = 22
		$this.TargetStats        = @{ [StatId]::Attack = 4 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An old, neglected sword. Not very effective.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPracticeStaff : BEWeapon {
	BEPracticeStaff() : base() {
		$this.Name               = 'Practice Staff'
		$this.MapObjName         = 'practicestaff'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{ [StatId]::Attack = 1; [StatId]::MagicAttack = 8 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A lightweight staff designed for training.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESmallShield : BEWeapon {
	BESmallShield() : base() {
		$this.Name               = 'Small Shield'
		$this.MapObjName         = 'smallshield'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{  }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A very small shield, offers minimal protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEThrowingDaggers : BEWeapon {
	BEThrowingDaggers() : base() {
		$this.Name               = 'Throwing Daggers'
		$this.MapObjName         = 'throwingdaggers'
		$this.PurchasePrice      = 110
		$this.SellPrice          = 55
		$this.TargetStats        = @{ [StatId]::Attack = 9 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A set of small daggers designed for throwing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELongBow : BEWeapon {
	BELongBow() : base() {
		$this.Name               = 'Long Bow'
		$this.MapObjName         = 'longbow'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{ [StatId]::Attack = 18 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A more powerful bow, requiring greater strength.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEIronSword : BEWeapon {
	BEIronSword() : base() {
		$this.Name               = 'Iron Sword'
		$this.MapObjName         = 'ironsword'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{ [StatId]::Attack = 20 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A well-forged iron sword, more durable than bronze.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBattleAxe : BEWeapon {
	BEBattleAxe() : base() {
		$this.Name               = 'Battle Axe'
		$this.MapObjName         = 'battleaxe'
		$this.PurchasePrice      = 320
		$this.SellPrice          = 160
		$this.TargetStats        = @{ [StatId]::Attack = 25 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A large, two-handed axe, devastating in combat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMagicStaff : BEWeapon {
	BEMagicStaff() : base() {
		$this.Name               = 'Magic Staff'
		$this.MapObjName         = 'magicstaff'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{ [StatId]::Attack = 5; [StatId]::MagicAttack = 18 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff imbued with minor magical properties.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESteelSpear : BEWeapon {
	BESteelSpear() : base() {
		$this.Name               = 'Steel Spear'
		$this.MapObjName         = 'steelspear'
		$this.PurchasePrice      = 260
		$this.SellPrice          = 130
		$this.TargetStats        = @{ [StatId]::Attack = 18 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sharp and sturdy spear made of steel.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEShortBow : BEWeapon {
	BEShortBow() : base() {
		$this.Name               = 'Short Bow'
		$this.MapObjName         = 'shortbow'
		$this.PurchasePrice      = 160
		$this.SellPrice          = 80
		$this.TargetStats        = @{ [StatId]::Attack = 12 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A compact bow, good for quick shots.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWarHammer : BEWeapon {
	BEWarHammer() : base() {
		$this.Name               = 'War Hammer'
		$this.MapObjName         = 'warhammer'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{ [StatId]::Attack = 23 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy, blunt weapon designed to crush armor.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGrindingStone : BEWeapon {
	BEGrindingStone() : base() {
		$this.Name               = 'Grinding Stone'
		$this.MapObjName         = 'grindingstone'
		$this.PurchasePrice      = 50
		$this.SellPrice          = 25
		$this.TargetStats        = @{ [StatId]::Attack = 7 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy stone used for grinding. Surprisingly effective.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESimpleWand : BEWeapon {
	BESimpleWand() : base() {
		$this.Name               = 'Simple Wand'
		$this.MapObjName         = 'simplewand'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{ [StatId]::Attack = 3; [StatId]::MagicAttack = 15 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A basic wand for casting simple spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELeatherGloves : BEWeapon {
	BELeatherGloves() : base() {
		$this.Name               = 'Leather Gloves'
		$this.MapObjName         = 'leathergloves'
		$this.PurchasePrice      = 60
		$this.SellPrice          = 30
		$this.TargetStats        = @{ [StatId]::Attack = 6 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves reinforced with leather, can be used for fisticuffs.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESlingShot : BEWeapon {
	BESlingShot() : base() {
		$this.Name               = 'Sling Shot'
		$this.MapObjName         = 'slingshot'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{ [StatId]::Attack = 6 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A more powerful version of a sling.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESpikedClub : BEWeapon {
	BESpikedClub() : base() {
		$this.Name               = 'Spiked Club'
		$this.MapObjName         = 'spikedclub'
		$this.PurchasePrice      = 130
		$this.SellPrice          = 65
		$this.TargetStats        = @{ [StatId]::Attack = 14 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A club covered in sharp spikes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWornDagger : BEWeapon {
	BEWornDagger() : base() {
		$this.Name               = 'Worn Dagger'
		$this.MapObjName         = 'worndagger'
		$this.PurchasePrice      = 35
		$this.SellPrice          = 17
		$this.TargetStats        = @{ [StatId]::Attack = 3 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A used and dulled dagger.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEApprenticeStaff : BEWeapon {
	BEApprenticeStaff() : base() {
		$this.Name               = 'Apprentice Staff'
		$this.MapObjName         = 'apprenticestaff'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{ [StatId]::Attack = 4; [StatId]::MagicAttack = 13 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff suitable for an apprentice mage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWoodcuttersAxe : BEWeapon {
	BEWoodcuttersAxe() : base() {
		$this.Name               = 'Woodcutter''s Axe'
		$this.MapObjName         = 'woodcuttersaxe'
		$this.PurchasePrice      = 140
		$this.SellPrice          = 70
		$this.TargetStats        = @{ [StatId]::Attack = 13 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An axe primarily for chopping wood, but sharp.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBlowgun : BEWeapon {
	BEBlowgun() : base() {
		$this.Name               = 'Blowgun'
		$this.MapObjName         = 'blowgun'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{ [StatId]::Attack = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A long tube for shooting darts. Requires darts.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStoneHammer : BEWeapon {
	BEStoneHammer() : base() {
		$this.Name               = 'Stone Hammer'
		$this.MapObjName         = 'stonehammer'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{ [StatId]::Attack = 9 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A primitive hammer with a stone head.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERustyKnife : BEWeapon {
	BERustyKnife() : base() {
		$this.Name               = 'Rusty Knife'
		$this.MapObjName         = 'rustyknife'
		$this.PurchasePrice      = 30
		$this.SellPrice          = 15
		$this.TargetStats        = @{ [StatId]::Attack = 2 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A corroded and dull knife.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFryingPan : BEWeapon {
	BEFryingPan() : base() {
		$this.Name               = 'Frying Pan'
		$this.MapObjName         = 'fryingpan'
		$this.PurchasePrice      = 40
		$this.SellPrice          = 20
		$this.TargetStats        = @{ [StatId]::Attack = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A common kitchen item. Surprisingly sturdy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETorch : BEWeapon {
	BETorch() : base() {
		$this.Name               = 'Torch'
		$this.MapObjName         = 'torch'
		$this.PurchasePrice      = 20
		$this.SellPrice          = 10
		$this.TargetStats        = @{ [StatId]::Attack = 1 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A burning stick. Can be used to ward off some creatures.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECarvingKnife : BEWeapon {
	BECarvingKnife() : base() {
		$this.Name               = 'Carving Knife'
		$this.MapObjName         = 'carvingknife'
		$this.PurchasePrice      = 50
		$this.SellPrice          = 25
		$this.TargetStats        = @{ [StatId]::Attack = 6 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A very sharp knife used for preparing food.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFarmersScythe : BEWeapon {
	BEFarmersScythe() : base() {
		$this.Name               = 'Farmer''s Scythe'
		$this.MapObjName         = 'farmersscythe'
		$this.PurchasePrice      = 160
		$this.SellPrice          = 80
		$this.TargetStats        = @{ [StatId]::Attack = 16 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tool for harvesting crops, dangerous in combat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBrokenBottle : BEWeapon {
	BEBrokenBottle() : base() {
		$this.Name               = 'Broken Bottle'
		$this.MapObjName         = 'brokenbottle'
		$this.PurchasePrice      = 25
		$this.SellPrice          = 12
		$this.TargetStats        = @{ [StatId]::Attack = 3 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shattered bottle. Very sharp, but fragile.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECandlestick : BEWeapon {
	BECandlestick() : base() {
		$this.Name               = 'Candlestick'
		$this.MapObjName         = 'candlestick'
		$this.PurchasePrice      = 50
		$this.SellPrice          = 25
		$this.TargetStats        = @{ [StatId]::Attack = 7 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy metal candlestick.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGardeningHoe : BEWeapon {
	BEGardeningHoe() : base() {
		$this.Name               = 'Gardening Hoe'
		$this.MapObjName         = 'gardeninghoe'
		$this.PurchasePrice      = 60
		$this.SellPrice          = 30
		$this.TargetStats        = @{ [StatId]::Attack = 8 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tool for digging and weeding. Can be swung.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESturdyStick : BEWeapon {
	BESturdyStick() : base() {
		$this.Name               = 'Sturdy Stick'
		$this.MapObjName         = 'sturdystick'
		$this.PurchasePrice      = 30
		$this.SellPrice          = 15
		$this.TargetStats        = @{ [StatId]::Attack = 4 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A thick, durable branch.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESewerPipe : BEWeapon {
	BESewerPipe() : base() {
		$this.Name               = 'Sewer Pipe'
		$this.MapObjName         = 'sewerpipe'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{ [StatId]::Attack = 9 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A discarded pipe from the sewers. Surprisingly robust.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOldBroom : BEWeapon {
	BEOldBroom() : base() {
		$this.Name               = 'Old Broom'
		$this.MapObjName         = 'oldbroom'
		$this.PurchasePrice      = 20
		$this.SellPrice          = 10
		$this.TargetStats        = @{ [StatId]::Attack = 2 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A worn-out broom. Not very effective.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEToySword : BEWeapon {
	BEToySword() : base() {
		$this.Name               = 'Toy Sword'
		$this.MapObjName         = 'toysword'
		$this.PurchasePrice      = 10
		$this.SellPrice          = 5
		$this.TargetStats        = @{ [StatId]::Attack = 1 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A harmless replica of a sword.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMythrilSword : BEWeapon {
	BEMythrilSword() : base() {
		$this.Name               = 'Mythril Sword'
		$this.MapObjName         = 'mythrilsword'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{ [StatId]::Attack = 45 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A finely crafted sword made from rare mythril, light and sharp.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESilverDagger : BEWeapon {
	BESilverDagger() : base() {
		$this.Name               = 'Silver Dagger'
		$this.MapObjName         = 'silverdagger'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{ [StatId]::Attack = 40; [StatId]::MagicAttack = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dagger made of pure silver, effective against supernatural foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGreatSword : BEWeapon {
	BEGreatSword() : base() {
		$this.Name               = 'Great Sword'
		$this.MapObjName         = 'greatsword'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{ [StatId]::Attack = 55 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A massive two-handed sword, capable of cleaving through enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDragonAxe : BEWeapon {
	BEDragonAxe() : base() {
		$this.Name               = 'Dragon Axe'
		$this.MapObjName         = 'dragonaxe'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{ [StatId]::Attack = 60; [StatId]::MagicAttack = 10 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An axe forged in dragonfire, capable of burning foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWizardsStaff : BEWeapon {
	BEWizardsStaff() : base() {
		$this.Name               = 'Wizard''s Staff'
		$this.MapObjName         = 'wizardsstaff'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{ [StatId]::Attack = 10; [StatId]::MagicAttack = 50 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff crackling with magical energy, favored by powerful mages.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHolyLance : BEWeapon {
	BEHolyLance() : base() {
		$this.Name               = 'Holy Lance'
		$this.MapObjName         = 'holylance'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{ [StatId]::Attack = 50; [StatId]::MagicAttack = 15 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A blessed spear said to smite evil.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERepeatingCrossbow : BEWeapon {
	BERepeatingCrossbow() : base() {
		$this.Name               = 'Repeating Crossbow'
		$this.MapObjName         = 'repeatingcrossbow'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{ [StatId]::Attack = 58 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A complex crossbow capable of rapid firing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEElvenBow : BEWeapon {
	BEElvenBow() : base() {
		$this.Name               = 'Elven Bow'
		$this.MapObjName         = 'elvenbow'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{ [StatId]::Attack = 62 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A gracefully crafted bow, known for its incredible accuracy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEScourgeWhip : BEWeapon {
	BEScourgeWhip() : base() {
		$this.Name               = 'Scourge Whip'
		$this.MapObjName         = 'scourgewhip'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{ [StatId]::Attack = 35; [StatId]::MagicAttack = 20 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A whip enchanted with dark magic, draining foes'' vitality.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMeteorHammer : BEWeapon {
	BEMeteorHammer() : base() {
		$this.Name               = 'Meteor Hammer'
		$this.MapObjName         = 'meteorhammer'
		$this.PurchasePrice      = 880
		$this.SellPrice          = 440
		$this.TargetStats        = @{ [StatId]::Attack = 52 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy ball and chain, strikes with incredible force.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAdamantKnuckles : BEWeapon {
	BEAdamantKnuckles() : base() {
		$this.Name               = 'Adamant Knuckles'
		$this.MapObjName         = 'adamantknuckles'
		$this.PurchasePrice      = 920
		$this.SellPrice          = 460
		$this.TargetStats        = @{ [StatId]::Attack = 56 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Knuckles crafted from the legendary adamant, virtually unbreakable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFlameBlade : BEWeapon {
	BEFlameBlade() : base() {
		$this.Name               = 'Flame Blade'
		$this.MapObjName         = 'flameblade'
		$this.PurchasePrice      = 780
		$this.SellPrice          = 390
		$this.TargetStats        = @{ [StatId]::Attack = 48; [StatId]::MagicAttack = 8 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword wreathed in fire, dealing burn damage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEIceBrand : BEWeapon {
	BEIceBrand() : base() {
		$this.Name               = 'Ice Brand'
		$this.MapObjName         = 'icebrand'
		$this.PurchasePrice      = 780
		$this.SellPrice          = 390
		$this.TargetStats        = @{ [StatId]::Attack = 48; [StatId]::MagicAttack = 8 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword imbued with the essence of ice, capable of freezing enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEThunderRod : BEWeapon {
	BEThunderRod() : base() {
		$this.Name               = 'Thunder Rod'
		$this.MapObjName         = 'thunderrod'
		$this.PurchasePrice      = 720
		$this.SellPrice          = 360
		$this.TargetStats        = @{ [StatId]::Attack = 8; [StatId]::MagicAttack = 45 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rod that can summon lightning bolts.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVenomDagger : BEWeapon {
	BEVenomDagger() : base() {
		$this.Name               = 'Venom Dagger'
		$this.MapObjName         = 'venomdagger'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{ [StatId]::Attack = 38 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dagger coated in potent poison, inflicting continuous damage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGiantClub : BEWeapon {
	BEGiantClub() : base() {
		$this.Name               = 'Giant Club'
		$this.MapObjName         = 'giantclub'
		$this.PurchasePrice      = 820
		$this.SellPrice          = 410
		$this.TargetStats        = @{ [StatId]::Attack = 50 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A colossal club, wielded by only the strongest warriors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEShadowBow : BEWeapon {
	BEShadowBow() : base() {
		$this.Name               = 'Shadow Bow'
		$this.MapObjName         = 'shadowbow'
		$this.PurchasePrice      = 1050
		$this.SellPrice          = 525
		$this.TargetStats        = @{ [StatId]::Attack = 55; [StatId]::MagicAttack = 10 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bow that fires arrows of pure shadow, piercing defenses.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESpiritStaff : BEWeapon {
	BESpiritStaff() : base() {
		$this.Name               = 'Spirit Staff'
		$this.MapObjName         = 'spiritstaff'
		$this.PurchasePrice      = 780
		$this.SellPrice          = 390
		$this.TargetStats        = @{ [StatId]::Attack = 5; [StatId]::MagicAttack = 48 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff that amplifies the wielder''s connection to the spirit world.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBarrierBlade : BEWeapon {
	BEBarrierBlade() : base() {
		$this.Name               = 'Barrier Blade'
		$this.MapObjName         = 'barrierblade'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{ [StatId]::Attack = 42; [StatId]::MagicAttack = 12 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword that can temporarily create a magical shield.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFrostAxe : BEWeapon {
	BEFrostAxe() : base() {
		$this.Name               = 'Frost Axe'
		$this.MapObjName         = 'frostaxe'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{ [StatId]::Attack = 53; [StatId]::MagicAttack = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An axe that emanates a chilling aura, slowing enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESolarStaff : BEWeapon {
	BESolarStaff() : base() {
		$this.Name               = 'Solar Staff'
		$this.MapObjName         = 'solarstaff'
		$this.PurchasePrice      = 920
		$this.SellPrice          = 460
		$this.TargetStats        = @{ [StatId]::Attack = 12; [StatId]::MagicAttack = 55 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff that harnesses the power of the sun, radiating healing energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBladeofTruth : BEWeapon {
	BEBladeofTruth() : base() {
		$this.Name               = 'Blade of Truth'
		$this.MapObjName         = 'bladeoftruth'
		$this.PurchasePrice      = 1150
		$this.SellPrice          = 575
		$this.TargetStats        = @{ [StatId]::Attack = 60 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A legendary sword said to reveal hidden weaknesses.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDragonsBreath : BEWeapon {
	BEDragonsBreath() : base() {
		$this.Name               = 'Dragon''s Breath'
		$this.MapObjName         = 'dragonsbreath'
		$this.PurchasePrice      = 980
		$this.SellPrice          = 490
		$this.TargetStats        = @{ [StatId]::Attack = 50; [StatId]::MagicAttack = 25 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A short, fiery weapon that can unleash a burst of flames.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVoidScepter : BEWeapon {
	BEVoidScepter() : base() {
		$this.Name               = 'Void Scepter'
		$this.MapObjName         = 'voidscepter'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{ [StatId]::Attack = 15; [StatId]::MagicAttack = 60 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A scepter that can manipulate spatial anomalies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGriffinBow : BEWeapon {
	BEGriffinBow() : base() {
		$this.Name               = 'Griffin Bow'
		$this.MapObjName         = 'griffinbow'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{ [StatId]::Attack = 65 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bow crafted from griffin feathers, offering incredible range and speed.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESerpentStaff : BEWeapon {
	BESerpentStaff() : base() {
		$this.Name               = 'Serpent Staff'
		$this.MapObjName         = 'serpentstaff'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{ [StatId]::Attack = 7; [StatId]::MagicAttack = 47 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff topped with a coiling serpent, capable of charming foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEChaosBlade : BEWeapon {
	BEChaosBlade() : base() {
		$this.Name               = 'Chaos Blade'
		$this.MapObjName         = 'chaosblade'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{ [StatId]::Attack = 58; [StatId]::MagicAttack = 20 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword that possesses unpredictable magical effects.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStarMace : BEWeapon {
	BEStarMace() : base() {
		$this.Name               = 'Star Mace'
		$this.MapObjName         = 'starmace'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{ [StatId]::Attack = 54; [StatId]::MagicAttack = 10 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A mace studded with celestial fragments, glittering with cosmic energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESoulHarvester : BEWeapon {
	BESoulHarvester() : base() {
		$this.Name               = 'Soul Harvester'
		$this.MapObjName         = 'soulharvester'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{ [StatId]::Attack = 56; [StatId]::MagicAttack = 18 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A scythe said to reap the souls of the fallen, restoring vitality to the wielder.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECrystalWand : BEWeapon {
	BECrystalWand() : base() {
		$this.Name               = 'Crystal Wand'
		$this.MapObjName         = 'crystalwand'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{ [StatId]::Attack = 10; [StatId]::MagicAttack = 42 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A wand made of pure crystal, focusing magical energies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEObsidianGreatsword : BEWeapon {
	BEObsidianGreatsword() : base() {
		$this.Name               = 'Obsidian Greatsword'
		$this.MapObjName         = 'obsidiangreatsword'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{ [StatId]::Attack = 57 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A massive sword forged from volcanic glass, incredibly sharp.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWindAxe : BEWeapon {
	BEWindAxe() : base() {
		$this.Name               = 'Wind Axe'
		$this.MapObjName         = 'windaxe'
		$this.PurchasePrice      = 920
		$this.SellPrice          = 460
		$this.TargetStats        = @{ [StatId]::Attack = 54; [StatId]::MagicAttack = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An axe that cuts through the air with ease, creating gusts of wind.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERuneStaff : BEWeapon {
	BERuneStaff() : base() {
		$this.Name               = 'Rune Staff'
		$this.MapObjName         = 'runestaff'
		$this.PurchasePrice      = 880
		$this.SellPrice          = 440
		$this.TargetStats        = @{ [StatId]::Attack = 8; [StatId]::MagicAttack = 52 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff inscribed with ancient runes, enhancing spellcasting.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELightbringer : BEWeapon {
	BELightbringer() : base() {
		$this.Name               = 'Lightbringer'
		$this.MapObjName         = 'lightbringer'
		$this.PurchasePrice      = 1050
		$this.SellPrice          = 525
		$this.TargetStats        = @{ [StatId]::Attack = 55; [StatId]::MagicAttack = 15 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword that glows with holy light, banishing darkness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDarknessBow : BEWeapon {
	BEDarknessBow() : base() {
		$this.Name               = 'Darkness Bow'
		$this.MapObjName         = 'darknessbow'
		$this.PurchasePrice      = 980
		$this.SellPrice          = 490
		$this.TargetStats        = @{ [StatId]::Attack = 52; [StatId]::MagicAttack = 10 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bow that fires arrows of pure shadow, obscuring vision.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEmeraldRod : BEWeapon {
	BEEmeraldRod() : base() {
		$this.Name               = 'Emerald Rod'
		$this.MapObjName         = 'emeraldrod'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{ [StatId]::Attack = 10; [StatId]::MagicAttack = 44 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rod adorned with a shimmering emerald, boosting earth magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPoisonedWhip : BEWeapon {
	BEPoisonedWhip() : base() {
		$this.Name               = 'Poisoned Whip'
		$this.MapObjName         = 'poisonedwhip'
		$this.PurchasePrice      = 680
		$this.SellPrice          = 340
		$this.TargetStats        = @{ [StatId]::Attack = 36 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A whip with a barbed tip, coated in a fast-acting poison.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESpikedGauntlets : BEWeapon {
	BESpikedGauntlets() : base() {
		$this.Name               = 'Spiked Gauntlets'
		$this.MapObjName         = 'spikedgauntlets'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{ [StatId]::Attack = 51 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy gauntlets with protruding spikes, ideal for brutal close combat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAetherBlade : BEWeapon {
	BEAetherBlade() : base() {
		$this.Name               = 'Aether Blade'
		$this.MapObjName         = 'aetherblade'
		$this.PurchasePrice      = 1120
		$this.SellPrice          = 560
		$this.TargetStats        = @{ [StatId]::Attack = 59; [StatId]::MagicAttack = 22 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword that hums with ethereal energy, able to phase through some defenses.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOceanScepter : BEWeapon {
	BEOceanScepter() : base() {
		$this.Name               = 'Ocean Scepter'
		$this.MapObjName         = 'oceanscepter'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{ [StatId]::Attack = 12; [StatId]::MagicAttack = 50 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A scepter that can control water, summoning tidal waves.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPhoenixBow : BEWeapon {
	BEPhoenixBow() : base() {
		$this.Name               = 'Phoenix Bow'
		$this.MapObjName         = 'phoenixbow'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{ [StatId]::Attack = 63; [StatId]::MagicAttack = 10 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bow adorned with phoenix feathers, allowing arrows to ignite upon impact.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGolemAxe : BEWeapon {
	BEGolemAxe() : base() {
		$this.Name               = 'Golem Axe'
		$this.MapObjName         = 'golemaxe'
		$this.PurchasePrice      = 1020
		$this.SellPrice          = 510
		$this.TargetStats        = @{ [StatId]::Attack = 61 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An axe designed to shatter stone and metal, incredibly heavy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEManaRod : BEWeapon {
	BEManaRod() : base() {
		$this.Name               = 'Mana Rod'
		$this.MapObjName         = 'manarod'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{ [StatId]::Attack = 5; [StatId]::MagicAttack = 30 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple rod that helps regenerate mana.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDreamWeaverStaff : BEWeapon {
	BEDreamWeaverStaff() : base() {
		$this.Name               = 'Dream Weaver Staff'
		$this.MapObjName         = 'dreamweaverstaff'
		$this.PurchasePrice      = 820
		$this.SellPrice          = 410
		$this.TargetStats        = @{ [StatId]::Attack = 6; [StatId]::MagicAttack = 49 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff that can induce sleep or vivid illusions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVampireSword : BEWeapon {
	BEVampireSword() : base() {
		$this.Name               = 'Vampire Sword'
		$this.MapObjName         = 'vampiresword'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{ [StatId]::Attack = 48; [StatId]::MagicAttack = 10 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword that siphons health from enemies with each strike.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGuardianShield : BEWeapon {
	BEGuardianShield() : base() {
		$this.Name               = 'Guardian Shield'
		$this.MapObjName         = 'guardianshield'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{ [StatId]::Attack = 30 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shield that can also be used as a blunt weapon.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMoonlightBow : BEWeapon {
	BEMoonlightBow() : base() {
		$this.Name               = 'Moonlight Bow'
		$this.MapObjName         = 'moonlightbow'
		$this.PurchasePrice      = 1180
		$this.SellPrice          = 590
		$this.TargetStats        = @{ [StatId]::Attack = 60; [StatId]::MagicAttack = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bow that glows softly, guiding arrows even in darkness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESunstoneStaff : BEWeapon {
	BESunstoneStaff() : base() {
		$this.Name               = 'Sunstone Staff'
		$this.MapObjName         = 'sunstonestaff'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{ [StatId]::Attack = 10; [StatId]::MagicAttack = 53 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff topped with a radiant sunstone, bolstering healing spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETitanAxe : BEWeapon {
	BETitanAxe() : base() {
		$this.Name               = 'Titan Axe'
		$this.MapObjName         = 'titanaxe'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{ [StatId]::Attack = 68 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A colossal axe, said to be wielded by giants.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESpiritBlade : BEWeapon {
	BESpiritBlade() : base() {
		$this.Name               = 'Spirit Blade'
		$this.MapObjName         = 'spiritblade'
		$this.PurchasePrice      = 1080
		$this.SellPrice          = 540
		$this.TargetStats        = @{ [StatId]::Attack = 54; [StatId]::MagicAttack = 18 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword that can harm incorporeal beings.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEExcalibur : BEWeapon {
	BEExcalibur() : base() {
		$this.Name               = 'Excalibur'
		$this.MapObjName         = 'excalibur'
		$this.PurchasePrice      = 5000
		$this.SellPrice          = 2500
		$this.TargetStats        = @{ [StatId]::Attack = 120; [StatId]::MagicAttack = 50 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A legendary sword said to be forged by the gods, grants immense power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGungnir : BEWeapon {
	BEGungnir() : base() {
		$this.Name               = 'Gungnir'
		$this.MapObjName         = 'gungnir'
		$this.PurchasePrice      = 4800
		$this.SellPrice          = 2400
		$this.TargetStats        = @{ [StatId]::Attack = 115; [StatId]::MagicAttack = 40 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A divine spear that never misses its target, piercing any defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMjolnir : BEWeapon {
	BEMjolnir() : base() {
		$this.Name               = 'Mjolnir'
		$this.MapObjName         = 'mjolnir'
		$this.PurchasePrice      = 5200
		$this.SellPrice          = 2600
		$this.TargetStats        = @{ [StatId]::Attack = 130; [StatId]::MagicAttack = 60 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A mythical hammer that calls down lightning, only wieldable by the worthy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMasamune : BEWeapon {
	BEMasamune() : base() {
		$this.Name               = 'Masamune'
		$this.MapObjName         = 'masamune'
		$this.PurchasePrice      = 4500
		$this.SellPrice          = 2250
		$this.TargetStats        = @{ [StatId]::Attack = 110; [StatId]::MagicAttack = 30 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A katana of unparalleled sharpness, whispered to be cursed.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAsclepius : BEWeapon {
	BEAsclepius() : base() {
		$this.Name               = 'Asclepius'
		$this.MapObjName         = 'asclepius'
		$this.PurchasePrice      = 4000
		$this.SellPrice          = 2000
		$this.TargetStats        = @{ [StatId]::Attack = 20; [StatId]::MagicAttack = 100 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff with healing powers, capable of curing all ailments.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEYewBow : BEWeapon {
	BEYewBow() : base() {
		$this.Name               = 'Yew Bow'
		$this.MapObjName         = 'yewbow'
		$this.PurchasePrice      = 4200
		$this.SellPrice          = 2100
		$this.TargetStats        = @{ [StatId]::Attack = 105; [StatId]::MagicAttack = 20 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bow carved from ancient yew, its arrows seek out vital points.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAegisShield : BEWeapon {
	BEAegisShield() : base() {
		$this.Name               = 'Aegis Shield'
		$this.MapObjName         = 'aegisshield'
		$this.PurchasePrice      = 3500
		$this.SellPrice          = 1750
		$this.TargetStats        = @{  }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A divine shield that reflects all magical attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEValhallaAxe : BEWeapon {
	BEValhallaAxe() : base() {
		$this.Name               = 'Valhalla Axe'
		$this.MapObjName         = 'valhallaaxe'
		$this.PurchasePrice      = 4700
		$this.SellPrice          = 2350
		$this.TargetStats        = @{ [StatId]::Attack = 125; [StatId]::MagicAttack = 10 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An axe that sings in battle, inspiring allies and striking fear into foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESoulEdge : BEWeapon {
	BESoulEdge() : base() {
		$this.Name               = 'Soul Edge'
		$this.MapObjName         = 'souledge'
		$this.PurchasePrice      = 4900
		$this.SellPrice          = 2450
		$this.TargetStats        = @{ [StatId]::Attack = 140 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cursed sword that feeds on the wielder''s soul, but grants incredible power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDragonClaw : BEWeapon {
	BEDragonClaw() : base() {
		$this.Name               = 'Dragon Claw'
		$this.MapObjName         = 'dragonclaw'
		$this.PurchasePrice      = 4600
		$this.SellPrice          = 2300
		$this.TargetStats        = @{ [StatId]::Attack = 118 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A gauntlet designed to mimic a dragon''s claw, crushing foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERuneblade : BEWeapon {
	BERuneblade() : base() {
		$this.Name               = 'Runeblade'
		$this.MapObjName         = 'runeblade'
		$this.PurchasePrice      = 3800
		$this.SellPrice          = 1900
		$this.TargetStats        = @{ [StatId]::Attack = 90; [StatId]::MagicAttack = 35 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword inscribed with powerful runes, dealing elemental damage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOrbofSouls : BEWeapon {
	BEOrbofSouls() : base() {
		$this.Name               = 'Orb of Souls'
		$this.MapObjName         = 'orbofsouls'
		$this.PurchasePrice      = 3600
		$this.SellPrice          = 1800
		$this.TargetStats        = @{ [StatId]::Attack = 10; [StatId]::MagicAttack = 90 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An orb that can summon spirits to aid in battle.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEChaosBow : BEWeapon {
	BEChaosBow() : base() {
		$this.Name               = 'Chaos Bow'
		$this.MapObjName         = 'chaosbow'
		$this.PurchasePrice      = 4000
		$this.SellPrice          = 2000
		$this.TargetStats        = @{ [StatId]::Attack = 95; [StatId]::MagicAttack = 30 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bow that fires unpredictable magical arrows, sometimes devastating.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWorldBreaker : BEWeapon {
	BEWorldBreaker() : base() {
		$this.Name               = 'World Breaker'
		$this.MapObjName         = 'worldbreaker'
		$this.PurchasePrice      = 5500
		$this.SellPrice          = 2750
		$this.TargetStats        = @{ [StatId]::Attack = 150 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A colossal hammer said to shatter mountains.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEtherealStaff : BEWeapon {
	BEEtherealStaff() : base() {
		$this.Name               = 'Ethereal Staff'
		$this.MapObjName         = 'etherealstaff'
		$this.PurchasePrice      = 4300
		$this.SellPrice          = 2150
		$this.TargetStats        = @{ [StatId]::Attack = 15; [StatId]::MagicAttack = 110 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff made of pure arcane energy, granting mastery over magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPhoenixFeatherDagger : BEWeapon {
	BEPhoenixFeatherDagger() : base() {
		$this.Name               = 'Phoenix Feather Dagger'
		$this.MapObjName         = 'phoenixfeatherdagger'
		$this.PurchasePrice      = 3900
		$this.SellPrice          = 1950
		$this.TargetStats        = @{ [StatId]::Attack = 90; [StatId]::MagicAttack = 25 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dagger made with a phoenix feather, allowing revival once per battle.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGravityAxe : BEWeapon {
	BEGravityAxe() : base() {
		$this.Name               = 'Gravity Axe'
		$this.MapObjName         = 'gravityaxe'
		$this.PurchasePrice      = 4400
		$this.SellPrice          = 2200
		$this.TargetStats        = @{ [StatId]::Attack = 110; [StatId]::MagicAttack = 15 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An axe that can manipulate gravity, crushing enemies under immense weight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDreamcatcherStaff : BEWeapon {
	BEDreamcatcherStaff() : base() {
		$this.Name               = 'Dreamcatcher Staff'
		$this.MapObjName         = 'dreamcatcherstaff'
		$this.PurchasePrice      = 3700
		$this.SellPrice          = 1850
		$this.TargetStats        = @{ [StatId]::Attack = 10; [StatId]::MagicAttack = 85 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff that can put enemies into a deep sleep or manipulate their dreams.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHolyAvenger : BEWeapon {
	BEHolyAvenger() : base() {
		$this.Name               = 'Holy Avenger'
		$this.MapObjName         = 'holyavenger'
		$this.PurchasePrice      = 4100
		$this.SellPrice          = 2050
		$this.TargetStats        = @{ [StatId]::Attack = 100; [StatId]::MagicAttack = 40 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword that blazes with holy light, dealing extra damage to undead and demons.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStormbringer : BEWeapon {
	BEStormbringer() : base() {
		$this.Name               = 'Stormbringer'
		$this.MapObjName         = 'stormbringer'
		$this.PurchasePrice      = 4300
		$this.SellPrice          = 2150
		$this.TargetStats        = @{ [StatId]::Attack = 105; [StatId]::MagicAttack = 30 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword that can summon gusts of wind and lightning.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESunforgedBlade : BEWeapon {
	BESunforgedBlade() : base() {
		$this.Name               = 'Sunforged Blade'
		$this.MapObjName         = 'sunforgedblade'
		$this.PurchasePrice      = 4200
		$this.SellPrice          = 2100
		$this.TargetStats        = @{ [StatId]::Attack = 102; [StatId]::MagicAttack = 28 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword crafted in the heart of a volcano, radiating immense heat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMoonpetalBow : BEWeapon {
	BEMoonpetalBow() : base() {
		$this.Name               = 'Moonpetal Bow'
		$this.MapObjName         = 'moonpetalbow'
		$this.PurchasePrice      = 3900
		$this.SellPrice          = 1950
		$this.TargetStats        = @{ [StatId]::Attack = 98; [StatId]::MagicAttack = 22 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bow strung with moonpetal fibers, firing arrows of pure moonlight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEChronoStaff : BEWeapon {
	BEChronoStaff() : base() {
		$this.Name               = 'Chrono Staff'
		$this.MapObjName         = 'chronostaff'
		$this.PurchasePrice      = 4500
		$this.SellPrice          = 2250
		$this.TargetStats        = @{ [StatId]::Attack = 18; [StatId]::MagicAttack = 120 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff that can manipulate time, slowing enemies or speeding up allies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDragonboneAxe : BEWeapon {
	BEDragonboneAxe() : base() {
		$this.Name               = 'Dragonbone Axe'
		$this.MapObjName         = 'dragonboneaxe'
		$this.PurchasePrice      = 4600
		$this.SellPrice          = 2300
		$this.TargetStats        = @{ [StatId]::Attack = 112 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An axe made from the bone of an ancient dragon, incredibly durable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStarfallRod : BEWeapon {
	BEStarfallRod() : base() {
		$this.Name               = 'Starfall Rod'
		$this.MapObjName         = 'starfallrod'
		$this.PurchasePrice      = 4700
		$this.SellPrice          = 2350
		$this.TargetStats        = @{ [StatId]::Attack = 25; [StatId]::MagicAttack = 130 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rod that can call down meteors from the sky.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVoidwalkerBlade : BEWeapon {
	BEVoidwalkerBlade() : base() {
		$this.Name               = 'Voidwalker Blade'
		$this.MapObjName         = 'voidwalkerblade'
		$this.PurchasePrice      = 4000
		$this.SellPrice          = 2000
		$this.TargetStats        = @{ [StatId]::Attack = 95; [StatId]::MagicAttack = 35 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword that allows the wielder to briefly teleport.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWhisperwindBow : BEWeapon {
	BEWhisperwindBow() : base() {
		$this.Name               = 'Whisperwind Bow'
		$this.MapObjName         = 'whisperwindbow'
		$this.PurchasePrice      = 3800
		$this.SellPrice          = 1900
		$this.TargetStats        = @{ [StatId]::Attack = 92; [StatId]::MagicAttack = 18 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bow whose arrows are carried by invisible winds, striking silently.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEmberStaff : BEWeapon {
	BEEmberStaff() : base() {
		$this.Name               = 'Ember Staff'
		$this.MapObjName         = 'emberstaff'
		$this.PurchasePrice      = 3700
		$this.SellPrice          = 1850
		$this.TargetStats        = @{ [StatId]::Attack = 12; [StatId]::MagicAttack = 88 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff constantly aglow with embers, dealing fire damage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGlacialBlade : BEWeapon {
	BEGlacialBlade() : base() {
		$this.Name               = 'Glacial Blade'
		$this.MapObjName         = 'glacialblade'
		$this.PurchasePrice      = 4100
		$this.SellPrice          = 2050
		$this.TargetStats        = @{ [StatId]::Attack = 100; [StatId]::MagicAttack = 30 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword that emanates freezing cold, slowing and chilling enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETempestSpear : BEWeapon {
	BETempestSpear() : base() {
		$this.Name               = 'Tempest Spear'
		$this.MapObjName         = 'tempestspear'
		$this.PurchasePrice      = 3900
		$this.SellPrice          = 1950
		$this.TargetStats        = @{ [StatId]::Attack = 98; [StatId]::MagicAttack = 25 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A spear that can conjure small whirlwinds.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOraclesStaff : BEWeapon {
	BEOraclesStaff() : base() {
		$this.Name               = 'Oracle''s Staff'
		$this.MapObjName         = 'oraclesstaff'
		$this.PurchasePrice      = 4200
		$this.SellPrice          = 2100
		$this.TargetStats        = @{ [StatId]::Attack = 15; [StatId]::MagicAttack = 105 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff that grants glimpses of the future, aiding in critical hits.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEInfernoAxe : BEWeapon {
	BEInfernoAxe() : base() {
		$this.Name               = 'Inferno Axe'
		$this.MapObjName         = 'infernoaxe'
		$this.PurchasePrice      = 4800
		$this.SellPrice          = 2400
		$this.TargetStats        = @{ [StatId]::Attack = 120; [StatId]::MagicAttack = 20 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An axe wreathed in eternal flames, burning all it touches.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEShadowfangDagger : BEWeapon {
	BEShadowfangDagger() : base() {
		$this.Name               = 'Shadowfang Dagger'
		$this.MapObjName         = 'shadowfangdagger'
		$this.PurchasePrice      = 3500
		$this.SellPrice          = 1750
		$this.TargetStats        = @{ [StatId]::Attack = 85; [StatId]::MagicAttack = 30 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dagger that drains shadows from enemies, making them vulnerable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAuraBlade : BEWeapon {
	BEAuraBlade() : base() {
		$this.Name               = 'Aura Blade'
		$this.MapObjName         = 'aurablade'
		$this.PurchasePrice      = 4400
		$this.SellPrice          = 2200
		$this.TargetStats        = @{ [StatId]::Attack = 108; [StatId]::MagicAttack = 10 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword that projects a protective aura, reducing incoming damage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESoulbinderStaff : BEWeapon {
	BESoulbinderStaff() : base() {
		$this.Name               = 'Soulbinder Staff'
		$this.MapObjName         = 'soulbinderstaff'
		$this.PurchasePrice      = 4600
		$this.SellPrice          = 2300
		$this.TargetStats        = @{ [StatId]::Attack = 18; [StatId]::MagicAttack = 115 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff that can temporarily bind an enemy''s soul, preventing actions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEThunderclapHammer : BEWeapon {
	BEThunderclapHammer() : base() {
		$this.Name               = 'Thunderclap Hammer'
		$this.MapObjName         = 'thunderclaphammer'
		$this.PurchasePrice      = 4900
		$this.SellPrice          = 2450
		$this.TargetStats        = @{ [StatId]::Attack = 128; [StatId]::MagicAttack = 15 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A hammer that emits a concussive shockwave upon impact.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEmeraldBow : BEWeapon {
	BEEmeraldBow() : base() {
		$this.Name               = 'Emerald Bow'
		$this.MapObjName         = 'emeraldbow'
		$this.PurchasePrice      = 4100
		$this.SellPrice          = 2050
		$this.TargetStats        = @{ [StatId]::Attack = 102; [StatId]::MagicAttack = 15 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bow adorned with gleaming emeralds, increasing precision.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECrimsonScythe : BEWeapon {
	BECrimsonScythe() : base() {
		$this.Name               = 'Crimson Scythe'
		$this.MapObjName         = 'crimsonscythe'
		$this.PurchasePrice      = 4700
		$this.SellPrice          = 2350
		$this.TargetStats        = @{ [StatId]::Attack = 115; [StatId]::MagicAttack = 20 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A scythe stained crimson, rumored to drink blood.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEZephyrBow : BEWeapon {
	BEZephyrBow() : base() {
		$this.Name               = 'Zephyr Bow'
		$this.MapObjName         = 'zephyrbow'
		$this.PurchasePrice      = 4300
		$this.SellPrice          = 2150
		$this.TargetStats        = @{ [StatId]::Attack = 105; [StatId]::MagicAttack = 10 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bow that allows arrows to travel at incredible speeds, almost instantly.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStoneGolemHammer : BEWeapon {
	BEStoneGolemHammer() : base() {
		$this.Name               = 'Stone Golem Hammer'
		$this.MapObjName         = 'stonegolemhammer'
		$this.PurchasePrice      = 5000
		$this.SellPrice          = 2500
		$this.TargetStats        = @{ [StatId]::Attack = 135 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A massive hammer crafted from a golem''s remains, incredibly heavy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStarfallStaff : BEWeapon {
	BEStarfallStaff() : base() {
		$this.Name               = 'Starfall Staff'
		$this.MapObjName         = 'starfallstaff'
		$this.PurchasePrice      = 4800
		$this.SellPrice          = 2400
		$this.TargetStats        = @{ [StatId]::Attack = 22; [StatId]::MagicAttack = 125 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff that can call down small celestial bodies, dealing area damage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAbyssalBlade : BEWeapon {
	BEAbyssalBlade() : base() {
		$this.Name               = 'Abyssal Blade'
		$this.MapObjName         = 'abyssalblade'
		$this.PurchasePrice      = 4500
		$this.SellPrice          = 2250
		$this.TargetStats        = @{ [StatId]::Attack = 110; [StatId]::MagicAttack = 40 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword from the depths of the abyss, dealing dark damage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESeraphicBlade : BEWeapon {
	BESeraphicBlade() : base() {
		$this.Name               = 'Seraphic Blade'
		$this.MapObjName         = 'seraphicblade'
		$this.PurchasePrice      = 4900
		$this.SellPrice          = 2450
		$this.TargetStats        = @{ [StatId]::Attack = 118; [StatId]::MagicAttack = 45 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword of celestial origin, imbued with divine light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEInfernalAxe : BEWeapon {
	BEInfernalAxe() : base() {
		$this.Name               = 'Infernal Axe'
		$this.MapObjName         = 'infernalaxe'
		$this.PurchasePrice      = 5100
		$this.SellPrice          = 2550
		$this.TargetStats        = @{ [StatId]::Attack = 130; [StatId]::MagicAttack = 25 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An axe burning with hellfire, capable of melting armor.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVortexStaff : BEWeapon {
	BEVortexStaff() : base() {
		$this.Name               = 'Vortex Staff'
		$this.MapObjName         = 'vortexstaff'
		$this.PurchasePrice      = 4400
		$this.SellPrice          = 2200
		$this.TargetStats        = @{ [StatId]::Attack = 20; [StatId]::MagicAttack = 110 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff that can create small localized vortices, pulling enemies in.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGolemSlayer : BEWeapon {
	BEGolemSlayer() : base() {
		$this.Name               = 'Golem Slayer'
		$this.MapObjName         = 'golemslayer'
		$this.PurchasePrice      = 3600
		$this.SellPrice          = 1800
		$this.TargetStats        = @{ [StatId]::Attack = 90 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A specialized weapon designed to destroy constructs and golems.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDivineRod : BEWeapon {
	BEDivineRod() : base() {
		$this.Name               = 'Divine Rod'
		$this.MapObjName         = 'divinerod'
		$this.PurchasePrice      = 3800
		$this.SellPrice          = 1900
		$this.TargetStats        = @{ [StatId]::Attack = 10; [StatId]::MagicAttack = 95 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rod imbued with holy power, granting blessings to allies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBehemothClub : BEWeapon {
	BEBehemothClub() : base() {
		$this.Name               = 'Behemoth Club'
		$this.MapObjName         = 'behemothclub'
		$this.PurchasePrice      = 5200
		$this.SellPrice          = 2600
		$this.TargetStats        = @{ [StatId]::Attack = 145 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A gigantic club, requiring immense strength to wield.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESoulrend : BEWeapon {
	BESoulrend() : base() {
		$this.Name               = 'Soulrend'
		$this.MapObjName         = 'soulrend'
		$this.PurchasePrice      = 5300
		$this.SellPrice          = 2650
		$this.TargetStats        = @{ [StatId]::Attack = 138; [StatId]::MagicAttack = 30 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword that tears at the very fabric of an enemy''s being.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGrimoireStaff : BEWeapon {
	BEGrimoireStaff() : base() {
		$this.Name               = 'Grimoire Staff'
		$this.MapObjName         = 'grimoirestaff'
		$this.PurchasePrice      = 5000
		$this.SellPrice          = 2500
		$this.TargetStats        = @{ [StatId]::Attack = 25; [StatId]::MagicAttack = 140 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff with an attached grimoire, granting access to powerful spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEArcaneScepter : BEWeapon {
	BEArcaneScepter() : base() {
		$this.Name               = 'Arcane Scepter'
		$this.MapObjName         = 'arcanescepter'
		$this.PurchasePrice      = 5500
		$this.SellPrice          = 2750
		$this.TargetStats        = @{ [StatId]::Attack = 30; [StatId]::MagicAttack = 150 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A scepter humming with raw arcane energy, amplifying all spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBladeofAges : BEWeapon {
	BEBladeofAges() : base() {
		$this.Name               = 'Blade of Ages'
		$this.MapObjName         = 'bladeofages'
		$this.PurchasePrice      = 5800
		$this.SellPrice          = 2900
		$this.TargetStats        = @{ [StatId]::Attack = 140; [StatId]::MagicAttack = 60 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword said to have witnessed the dawn of time, granting wisdom.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWorldTreeBow : BEWeapon {
	BEWorldTreeBow() : base() {
		$this.Name               = 'World Tree Bow'
		$this.MapObjName         = 'worldtreebow'
		$this.PurchasePrice      = 6000
		$this.SellPrice          = 3000
		$this.TargetStats        = @{ [StatId]::Attack = 130; [StatId]::MagicAttack = 40 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bow carved from a branch of the World Tree, its arrows carry life energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDragonheartAxe : BEWeapon {
	BEDragonheartAxe() : base() {
		$this.Name               = 'Dragonheart Axe'
		$this.MapObjName         = 'dragonheartaxe'
		$this.PurchasePrice      = 6200
		$this.SellPrice          = 3100
		$this.TargetStats        = @{ [StatId]::Attack = 155; [StatId]::MagicAttack = 30 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An axe embedded with a dragon''s heart, pulsating with power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStaffofCreation : BEWeapon {
	BEStaffofCreation() : base() {
		$this.Name               = 'Staff of Creation'
		$this.MapObjName         = 'staffofcreation'
		$this.PurchasePrice      = 5700
		$this.SellPrice          = 2850
		$this.TargetStats        = @{ [StatId]::Attack = 35; [StatId]::MagicAttack = 160 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff capable of minor creation, shaping the environment.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStarforgedSword : BEWeapon {
	BEStarforgedSword() : base() {
		$this.Name               = 'Starforged Sword'
		$this.MapObjName         = 'starforgedsword'
		$this.PurchasePrice      = 6100
		$this.SellPrice          = 3050
		$this.TargetStats        = @{ [StatId]::Attack = 145; [StatId]::MagicAttack = 70 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword forged from a fallen star, shimmering with cosmic energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPhoenixAshDagger : BEWeapon {
	BEPhoenixAshDagger() : base() {
		$this.Name               = 'Phoenix Ash Dagger'
		$this.MapObjName         = 'phoenixashdagger'
		$this.PurchasePrice      = 5400
		$this.SellPrice          = 2700
		$this.TargetStats        = @{ [StatId]::Attack = 125; [StatId]::MagicAttack = 50 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dagger made from the ashes of a phoenix, capable of burning foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHammerofJudgment : BEWeapon {
	BEHammerofJudgment() : base() {
		$this.Name               = 'Hammer of Judgment'
		$this.MapObjName         = 'hammerofjudgment'
		$this.PurchasePrice      = 6300
		$this.SellPrice          = 3150
		$this.TargetStats        = @{ [StatId]::Attack = 165; [StatId]::MagicAttack = 20 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A colossal hammer that delivers righteous judgment, capable of stunning.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEternitysEmbrace : BEWeapon {
	BEEternitysEmbrace() : base() {
		$this.Name               = 'Eternity''s Embrace'
		$this.MapObjName         = 'eternitysembrace'
		$this.PurchasePrice      = 5900
		$this.SellPrice          = 2950
		$this.TargetStats        = @{ [StatId]::Attack = 40; [StatId]::MagicAttack = 170 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff that can briefly halt the flow of time around the wielder.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESoulflameScythe : BEWeapon {
	BESoulflameScythe() : base() {
		$this.Name               = 'Soulflame Scythe'
		$this.MapObjName         = 'soulflamescythe'
		$this.PurchasePrice      = 6500
		$this.SellPrice          = 3250
		$this.TargetStats        = @{ [StatId]::Attack = 150; [StatId]::MagicAttack = 80 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A scythe that burns with an ethereal flame, consuming enemy souls.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECelestialBow : BEWeapon {
	BECelestialBow() : base() {
		$this.Name               = 'Celestial Bow'
		$this.MapObjName         = 'celestialbow'
		$this.PurchasePrice      = 6400
		$this.SellPrice          = 3200
		$this.TargetStats        = @{ [StatId]::Attack = 135; [StatId]::MagicAttack = 55 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bow that fires arrows of pure starlight, illuminating and striking foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAbyssalStaff : BEWeapon {
	BEAbyssalStaff() : base() {
		$this.Name               = 'Abyssal Staff'
		$this.MapObjName         = 'abyssalstaff'
		$this.PurchasePrice      = 5600
		$this.SellPrice          = 2800
		$this.TargetStats        = @{ [StatId]::Attack = 32; [StatId]::MagicAttack = 155 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff that channels dark energies from the abyss, powerful but corrupting.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDragonsRoarAxe : BEWeapon {
	BEDragonsRoarAxe() : base() {
		$this.Name               = 'Dragon''s Roar Axe'
		$this.MapObjName         = 'dragonsroaraxe'
		$this.PurchasePrice      = 6000
		$this.SellPrice          = 3000
		$this.TargetStats        = @{ [StatId]::Attack = 148; [StatId]::MagicAttack = 25 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An axe that can unleash a sonic roar, disorienting enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELightweaveBlade : BEWeapon {
	BELightweaveBlade() : base() {
		$this.Name               = 'Lightweave Blade'
		$this.MapObjName         = 'lightweaveblade'
		$this.PurchasePrice      = 5700
		$this.SellPrice          = 2850
		$this.TargetStats        = @{ [StatId]::Attack = 138; [StatId]::MagicAttack = 65 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword woven from pure light, incredibly fast and precise.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDoomBringer : BEWeapon {
	BEDoomBringer() : base() {
		$this.Name               = 'Doom Bringer'
		$this.MapObjName         = 'doombringer'
		$this.PurchasePrice      = 6600
		$this.SellPrice          = 3300
		$this.TargetStats        = @{ [StatId]::Attack = 170 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A terrifying weapon that instills fear and despair in all who face it.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESpiritKingsStaff : BEWeapon {
	BESpiritKingsStaff() : base() {
		$this.Name               = 'Spirit King''s Staff'
		$this.MapObjName         = 'spiritkingsstaff'
		$this.PurchasePrice      = 6200
		$this.SellPrice          = 3100
		$this.TargetStats        = @{ [StatId]::Attack = 45; [StatId]::MagicAttack = 175 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff once wielded by a king of spirits, commanding spectral allies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBladeofRuin : BEWeapon {
	BEBladeofRuin() : base() {
		$this.Name               = 'Blade of Ruin'
		$this.MapObjName         = 'bladeofruin'
		$this.PurchasePrice      = 6800
		$this.SellPrice          = 3400
		$this.TargetStats        = @{ [StatId]::Attack = 160; [StatId]::MagicAttack = 75 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword that leaves destruction in its wake, shattering defenses.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEThousandCutsDagger : BEWeapon {
	BEThousandCutsDagger() : base() {
		$this.Name               = 'Thousand Cuts Dagger'
		$this.MapObjName         = 'thousandcutsdagger'
		$this.PurchasePrice      = 5300
		$this.SellPrice          = 2650
		$this.TargetStats        = @{ [StatId]::Attack = 120; [StatId]::MagicAttack = 45 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dagger so sharp it feels like a thousand blades at once.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHammeroftheAncients : BEWeapon {
	BEHammeroftheAncients() : base() {
		$this.Name               = 'Hammer of the Ancients'
		$this.MapObjName         = 'hammeroftheancients'
		$this.PurchasePrice      = 6700
		$this.SellPrice          = 3350
		$this.TargetStats        = @{ [StatId]::Attack = 175; [StatId]::MagicAttack = 10 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A prehistoric hammer of immense power, vibrating with ancient magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWorldEnder : BEWeapon {
	BEWorldEnder() : base() {
		$this.Name               = 'World Ender'
		$this.MapObjName         = 'worldender'
		$this.PurchasePrice      = 7000
		$this.SellPrice          = 3500
		$this.TargetStats        = @{ [StatId]::Attack = 200; [StatId]::MagicAttack = 100 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A legendary weapon capable of cataclysmic destruction, forbidden to wield.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESunstoneBow : BEWeapon {
	BESunstoneBow() : base() {
		$this.Name               = 'Sunstone Bow'
		$this.MapObjName         = 'sunstonebow'
		$this.PurchasePrice      = 5800
		$this.SellPrice          = 2900
		$this.TargetStats        = @{ [StatId]::Attack = 128; [StatId]::MagicAttack = 50 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bow that gathers solar energy, firing explosive arrows.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVoidEdge : BEWeapon {
	BEVoidEdge() : base() {
		$this.Name               = 'Void Edge'
		$this.MapObjName         = 'voidedge'
		$this.PurchasePrice      = 5900
		$this.SellPrice          = 2950
		$this.TargetStats        = @{ [StatId]::Attack = 142; [StatId]::MagicAttack = 68 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A blade that tears open small rifts in space, causing disorientation.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStaffoftheCosmos : BEWeapon {
	BEStaffoftheCosmos() : base() {
		$this.Name               = 'Staff of the Cosmos'
		$this.MapObjName         = 'staffofthecosmos'
		$this.PurchasePrice      = 6300
		$this.SellPrice          = 3150
		$this.TargetStats        = @{ [StatId]::Attack = 48; [StatId]::MagicAttack = 180 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff that channels cosmic energies, capable of summoning minor celestial events.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDragonsToothSword : BEWeapon {
	BEDragonsToothSword() : base() {
		$this.Name               = 'Dragon''s Tooth Sword'
		$this.MapObjName         = 'dragonstoothsword'
		$this.PurchasePrice      = 6500
		$this.SellPrice          = 3250
		$this.TargetStats        = @{ [StatId]::Attack = 152; [StatId]::MagicAttack = 72 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword fashioned from a dragon''s tooth, incredibly sharp and resilient.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BENetherblade : BEWeapon {
	BENetherblade() : base() {
		$this.Name               = 'Netherblade'
		$this.MapObjName         = 'netherblade'
		$this.PurchasePrice      = 6700
		$this.SellPrice          = 3350
		$this.TargetStats        = @{ [StatId]::Attack = 160; [StatId]::MagicAttack = 85 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword forged in the nether, dealing immense fire and shadow damage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStormforgedAxe : BEWeapon {
	BEStormforgedAxe() : base() {
		$this.Name               = 'Stormforged Axe'
		$this.MapObjName         = 'stormforgedaxe'
		$this.PurchasePrice      = 6100
		$this.SellPrice          = 3050
		$this.TargetStats        = @{ [StatId]::Attack = 150; [StatId]::MagicAttack = 35 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An axe crackling with electricity, capable of calling down lightning.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESoulreaverStaff : BEWeapon {
	BESoulreaverStaff() : base() {
		$this.Name               = 'Soulreaver Staff'
		$this.MapObjName         = 'soulreaverstaff'
		$this.PurchasePrice      = 6400
		$this.SellPrice          = 3200
		$this.TargetStats        = @{ [StatId]::Attack = 50; [StatId]::MagicAttack = 190 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff that rips souls from bodies, draining life force.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPhoenixFireSword : BEWeapon {
	BEPhoenixFireSword() : base() {
		$this.Name               = 'Phoenix Fire Sword'
		$this.MapObjName         = 'phoenixfiresword'
		$this.PurchasePrice      = 6600
		$this.SellPrice          = 3300
		$this.TargetStats        = @{ [StatId]::Attack = 155; [StatId]::MagicAttack = 78 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword that perpetually burns with phoenix fire, igniting foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBlazeofGloryBow : BEWeapon {
	BEBlazeofGloryBow() : base() {
		$this.Name               = 'Blaze of Glory Bow'
		$this.MapObjName         = 'blazeofglorybow'
		$this.PurchasePrice      = 5700
		$this.SellPrice          = 2850
		$this.TargetStats        = @{ [StatId]::Attack = 125; [StatId]::MagicAttack = 48 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bow that sets arrows aflame, creating a trail of fire.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWintersChillStaff : BEWeapon {
	BEWintersChillStaff() : base() {
		$this.Name               = 'Winter''s Chill Staff'
		$this.MapObjName         = 'winterschillstaff'
		$this.PurchasePrice      = 6000
		$this.SellPrice          = 3000
		$this.TargetStats        = @{ [StatId]::Attack = 42; [StatId]::MagicAttack = 165 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff that freezes anything it touches, creating icy blasts.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHammerofCreation : BEWeapon {
	BEHammerofCreation() : base() {
		$this.Name               = 'Hammer of Creation'
		$this.MapObjName         = 'hammerofcreation'
		$this.PurchasePrice      = 6900
		$this.SellPrice          = 3450
		$this.TargetStats        = @{ [StatId]::Attack = 180; [StatId]::MagicAttack = 90 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A hammer said to have helped shape the world, capable of mending.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDragonsBane : BEWeapon {
	BEDragonsBane() : base() {
		$this.Name               = 'Dragon''s Bane'
		$this.MapObjName         = 'dragonsbane'
		$this.PurchasePrice      = 6200
		$this.SellPrice          = 3100
		$this.TargetStats        = @{ [StatId]::Attack = 148; [StatId]::MagicAttack = 60 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword specifically designed to hunt and slay dragons.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWandoftheArchmage : BEWeapon {
	BEWandoftheArchmage() : base() {
		$this.Name               = 'Wand of the Archmage'
		$this.MapObjName         = 'wandofthearchmage'
		$this.PurchasePrice      = 6800
		$this.SellPrice          = 3400
		$this.TargetStats        = @{ [StatId]::Attack = 55; [StatId]::MagicAttack = 200 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A wand of immense power, reserved for only the most skilled mages.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAegisDefender : BEWeapon {
	BEAegisDefender() : base() {
		$this.Name               = 'Aegis Defender'
		$this.MapObjName         = 'aegisdefender'
		$this.PurchasePrice      = 5500
		$this.SellPrice          = 2750
		$this.TargetStats        = @{ [StatId]::Attack = 130 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A weaponized shield capable of powerful bash attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStarcallerAxe : BEWeapon {
	BEStarcallerAxe() : base() {
		$this.Name               = 'Starcaller Axe'
		$this.MapObjName         = 'starcalleraxe'
		$this.PurchasePrice      = 6300
		$this.SellPrice          = 3150
		$this.TargetStats        = @{ [StatId]::Attack = 150; [StatId]::MagicAttack = 40 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An axe that when swung creates small, sparkling constellations.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEChronosBlade : BEWeapon {
	BEChronosBlade() : base() {
		$this.Name               = 'Chronos Blade'
		$this.MapObjName         = 'chronosblade'
		$this.PurchasePrice      = 6500
		$this.SellPrice          = 3250
		$this.TargetStats        = @{ [StatId]::Attack = 158; [StatId]::MagicAttack = 70 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A blade that can slightly alter the flow of time, granting extra attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESoulbinderBlade : BEWeapon {
	BESoulbinderBlade() : base() {
		$this.Name               = 'Soulbinder Blade'
		$this.MapObjName         = 'soulbinderblade'
		$this.PurchasePrice      = 5800
		$this.SellPrice          = 2900
		$this.TargetStats        = @{ [StatId]::Attack = 135; [StatId]::MagicAttack = 55 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A blade that can temporarily bind an enemy''s movements.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESeraphimStaff : BEWeapon {
	BESeraphimStaff() : base() {
		$this.Name               = 'Seraphim Staff'
		$this.MapObjName         = 'seraphimstaff'
		$this.PurchasePrice      = 6700
		$this.SellPrice          = 3350
		$this.TargetStats        = @{ [StatId]::Attack = 45; [StatId]::MagicAttack = 195 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff of pure light, used for healing and banishing evil.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDragonfireBow : BEWeapon {
	BEDragonfireBow() : base() {
		$this.Name               = 'Dragonfire Bow'
		$this.MapObjName         = 'dragonfirebow'
		$this.PurchasePrice      = 6000
		$this.SellPrice          = 3000
		$this.TargetStats        = @{ [StatId]::Attack = 132; [StatId]::MagicAttack = 52 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bow that imbues arrows with dragonfire, causing explosive impacts.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFrostbiteAxe : BEWeapon {
	BEFrostbiteAxe() : base() {
		$this.Name               = 'Frostbite Axe'
		$this.MapObjName         = 'frostbiteaxe'
		$this.PurchasePrice      = 6400
		$this.SellPrice          = 3200
		$this.TargetStats        = @{ [StatId]::Attack = 153; [StatId]::MagicAttack = 38 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An axe that inflicts severe frostbite, slowing enemies to a crawl.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWhisperoftheAncients : BEWeapon {
	BEWhisperoftheAncients() : base() {
		$this.Name               = 'Whisper of the Ancients'
		$this.MapObjName         = 'whisperoftheancients'
		$this.PurchasePrice      = 5400
		$this.SellPrice          = 2700
		$this.TargetStats        = @{ [StatId]::Attack = 122; [StatId]::MagicAttack = 46 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dagger that carries ancient whispers, confusing enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEThunderfury : BEWeapon {
	BEThunderfury() : base() {
		$this.Name               = 'Thunderfury'
		$this.MapObjName         = 'thunderfury'
		$this.PurchasePrice      = 6900
		$this.SellPrice          = 3450
		$this.TargetStats        = @{ [StatId]::Attack = 165; [StatId]::MagicAttack = 80 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A legendary sword that roars with lightning, striking multiple foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAstralScepter : BEWeapon {
	BEAstralScepter() : base() {
		$this.Name               = 'Astral Scepter'
		$this.MapObjName         = 'astralscepter'
		$this.PurchasePrice      = 6100
		$this.SellPrice          = 3050
		$this.TargetStats        = @{ [StatId]::Attack = 40; [StatId]::MagicAttack = 170 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A scepter that can project astral forms, distracting enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDivineRetribution : BEWeapon {
	BEDivineRetribution() : base() {
		$this.Name               = 'Divine Retribution'
		$this.MapObjName         = 'divineretribution'
		$this.PurchasePrice      = 7000
		$this.SellPrice          = 3500
		$this.TargetStats        = @{ [StatId]::Attack = 170; [StatId]::MagicAttack = 95 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A mace that delivers divine punishment, smiting the wicked.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEmberheartStaff : BEWeapon {
	BEEmberheartStaff() : base() {
		$this.Name               = 'Emberheart Staff'
		$this.MapObjName         = 'emberheartstaff'
		$this.PurchasePrice      = 5600
		$this.SellPrice          = 2800
		$this.TargetStats        = @{ [StatId]::Attack = 30; [StatId]::MagicAttack = 140 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff containing a burning ember, radiating warmth and minor fire magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETitansMight : BEWeapon {
	BETitansMight() : base() {
		$this.Name               = 'Titan''s Might'
		$this.MapObjName         = 'titansmight'
		$this.PurchasePrice      = 6800
		$this.SellPrice          = 3400
		$this.TargetStats        = @{ [StatId]::Attack = 185 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A massive two-handed weapon, only usable by those with immense strength.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECelestialHammer : BEWeapon {
	BECelestialHammer() : base() {
		$this.Name               = 'Celestial Hammer'
		$this.MapObjName         = 'celestialhammer'
		$this.PurchasePrice      = 6600
		$this.SellPrice          = 3300
		$this.TargetStats        = @{ [StatId]::Attack = 160; [StatId]::MagicAttack = 80 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A hammer made from celestial ore, glowing with soft light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESpectralBlade : BEWeapon {
	BESpectralBlade() : base() {
		$this.Name               = 'Spectral Blade'
		$this.MapObjName         = 'spectralblade'
		$this.PurchasePrice      = 5900
		$this.SellPrice          = 2950
		$this.TargetStats        = @{ [StatId]::Attack = 140; [StatId]::MagicAttack = 60 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A blade that can pass through physical objects, harming spirits.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHeartwoodStaff : BEWeapon {
	BEHeartwoodStaff() : base() {
		$this.Name               = 'Heartwood Staff'
		$this.MapObjName         = 'heartwoodstaff'
		$this.PurchasePrice      = 6500
		$this.SellPrice          = 3250
		$this.TargetStats        = @{ [StatId]::Attack = 48; [StatId]::MagicAttack = 185 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A staff carved from the heart of a living tree, deeply connected to nature.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
