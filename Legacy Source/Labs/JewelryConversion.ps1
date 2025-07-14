Class BECopperRing : BEJewelry {
	BECopperRing() : base() {
		$this.Name               = 'Copper Ring'
		$this.MapObjName         = 'copperring'
		$this.PurchasePrice      = 50
		$this.SellPrice          = 25
		$this.TargetStats        = @{
			[StatId]::Defense = 1
			[StatId]::MagicDefense = 1
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple, unadorned copper ring.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEIronPendant : BEJewelry {
	BEIronPendant() : base() {
		$this.Name               = 'Iron Pendant'
		$this.MapObjName         = 'ironpendant'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy iron pendant, often worn by warriors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESilverBracelet : BEJewelry {
	BESilverBracelet() : base() {
		$this.Name               = 'Silver Bracelet'
		$this.MapObjName         = 'silverbracelet'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A delicate silver bracelet, popular among magic users.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEGoldNecklace : BEJewelry {
	BEGoldNecklace() : base() {
		$this.Name               = 'Gold Necklace'
		$this.MapObjName         = 'goldnecklace'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{
			[StatId]::Luck = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A gleaming gold necklace, a sign of wealth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBronzeBrooch : BEJewelry {
	BEBronzeBrooch() : base() {
		$this.Name               = 'Bronze Brooch'
		$this.MapObjName         = 'bronzebrooch'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small bronze brooch, often used to fasten cloaks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWoodenBeads : BEJewelry {
	BEWoodenBeads() : base() {
		$this.Name               = 'Wooden Beads'
		$this.MapObjName         = 'woodenbeads'
		$this.PurchasePrice      = 60
		$this.SellPrice          = 30
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Simple wooden beads, sometimes used in rituals.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELeatherCharm : BEJewelry {
	BELeatherCharm() : base() {
		$this.Name               = 'Leather Charm'
		$this.MapObjName         = 'leathercharm'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small leather charm, believed to ward off evil.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBoneEarring : BEJewelry {
	BEBoneEarring() : base() {
		$this.Name               = 'Bone Earring'
		$this.MapObjName         = 'boneearring'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Accuracy = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An earring crafted from polished bone.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEPearlTiara : BEJewelry {
	BEPearlTiara() : base() {
		$this.Name               = 'Pearl Tiara'
		$this.MapObjName         = 'pearltiara'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 1
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A beautiful tiara adorned with lustrous pearls.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BERubyRing : BEJewelry {
	BERubyRing() : base() {
		$this.Name               = 'Ruby Ring'
		$this.MapObjName         = 'rubyring'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 1
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A gold ring set with a sparkling ruby.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESapphirePendant : BEJewelry {
	BESapphirePendant() : base() {
		$this.Name               = 'Sapphire Pendant'
		$this.MapObjName         = 'sapphirependant'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A silver pendant featuring a deep blue sapphire.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEmeraldBracelet : BEJewelry {
	BEEmeraldBracelet() : base() {
		$this.Name               = 'Emerald Bracelet'
		$this.MapObjName         = 'emeraldbracelet'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 1
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A verdant emerald bracelet, granting a touch of nature''s magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEDiamondNecklace : BEJewelry {
	BEDiamondNecklace() : base() {
		$this.Name               = 'Diamond Necklace'
		$this.MapObjName         = 'diamondnecklace'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Luck = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dazzling diamond necklace, exuding prestige.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAmethystBrooch : BEJewelry {
	BEAmethystBrooch() : base() {
		$this.Name               = 'Amethyst Brooch'
		$this.MapObjName         = 'amethystbrooch'
		$this.PurchasePrice      = 380
		$this.SellPrice          = 190
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A purple amethyst brooch, known to enhance wisdom.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEOpalRing : BEJewelry {
	BEOpalRing() : base() {
		$this.Name               = 'Opal Ring'
		$this.MapObjName         = 'opalring'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
			[StatId]::Luck = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An iridescent opal ring, rumored to bring good fortune.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETopazCirclet : BEJewelry {
	BETopazCirclet() : base() {
		$this.Name               = 'Topaz Circlet'
		$this.MapObjName         = 'topazcirclet'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::Defense = 1
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A golden circlet set with a bright topaz gem.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEGarnetAmulet : BEJewelry {
	BEGarnetAmulet() : base() {
		$this.Name               = 'Garnet Amulet'
		$this.MapObjName         = 'garnetamulet'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark red garnet amulet, radiating fortitude.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEJadeAnklet : BEJewelry {
	BEJadeAnklet() : base() {
		$this.Name               = 'Jade Anklet'
		$this.MapObjName         = 'jadeanklet'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 1
			[StatId]::Speed = 1
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A serene jade anklet, promoting calm and focus.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD  +$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BECoralBrooch : BEJewelry {
	BECoralBrooch() : base() {
		$this.Name               = 'Coral Brooch'
		$this.MapObjName         = 'coralbrooch'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A delicate coral brooch, whispering of ocean depths.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEOnyxRing : BEJewelry {
	BEOnyxRing() : base() {
		$this.Name               = 'Onyx Ring'
		$this.MapObjName         = 'onyxring'
		$this.PurchasePrice      = 420
		$this.SellPrice          = 210
		$this.TargetStats        = @{
			[StatId]::Defense = 1
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A jet black onyx ring, absorbing negative energies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEQuartzPendant : BEJewelry {
	BEQuartzPendant() : base() {
		$this.Name               = 'Quartz Pendant'
		$this.MapObjName         = 'quartzpendant'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A clear quartz pendant, amplifying magical energies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESunstoneRing : BEJewelry {
	BESunstoneRing() : base() {
		$this.Name               = 'Sunstone Ring'
		$this.MapObjName         = 'sunstonering'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vibrant sunstone ring, imbued with solar warmth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMoonstoneCirclet : BEJewelry {
	BEMoonstoneCirclet() : base() {
		$this.Name               = 'Moonstone Circlet'
		$this.MapObjName         = 'moonstonecirclet'
		$this.PurchasePrice      = 620
		$this.SellPrice          = 310
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A luminous moonstone circlet, connected to lunar magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEStarSapphireBrooch : BEJewelry {
	BEStarSapphireBrooch() : base() {
		$this.Name               = 'Star Sapphire Brooch'
		$this.MapObjName         = 'starsapphirebrooch'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 3
			[StatId]::MagicDefense = 3
			[StatId]::Luck = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rare star sapphire brooch, said to grant wishes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEDragonScaleNecklace : BEJewelry {
	BEDragonScaleNecklace() : base() {
		$this.Name               = 'Dragon Scale Necklace'
		$this.MapObjName         = 'dragonscalenecklace'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Attack = 2
			[StatId]::Defense = 3
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A necklace made of hardened dragon scales, very protective.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEPhoenixFeatherEarring : BEJewelry {
	BEPhoenixFeatherEarring() : base() {
		$this.Name               = 'Phoenix Feather Earring'
		$this.MapObjName         = 'phoenixfeatherearring'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Speed = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An earring with a vibrant phoenix feather, granting swiftness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEUnicornHornCharm : BEJewelry {
	BEUnicornHornCharm() : base() {
		$this.Name               = 'Unicorn Horn Charm'
		$this.MapObjName         = 'unicornhorncharm'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 1
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm crafted from a fragment of unicorn horn, for purity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEGriffinClawPendant : BEJewelry {
	BEGriffinClawPendant() : base() {
		$this.Name               = 'Griffin Claw Pendant'
		$this.MapObjName         = 'griffinclawpendant'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Attack = 2
			[StatId]::Defense = 1
			[StatId]::Accuracy = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A fierce griffin claw pendant, enhancing predatory instincts.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEVampireFangNecklace : BEJewelry {
	BEVampireFangNecklace() : base() {
		$this.Name               = 'Vampire Fang Necklace'
		$this.MapObjName         = 'vampirefangnecklace'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark necklace adorned with a vampire fang, siphoning life.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWerewolfClawRing : BEJewelry {
	BEWerewolfClawRing() : base() {
		$this.Name               = 'Werewolf Claw Ring'
		$this.MapObjName         = 'werewolfclawring'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Attack = 2
			[StatId]::Speed = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ring with a werewolf claw, granting ferocity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BELichPhylactery : BEJewelry {
	BELichPhylactery() : base() {
		$this.Name               = 'Lich Phylactery'
		$this.MapObjName         = 'lichphylactery'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 2
			[StatId]::MagicAttack = 4
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark, pulsating phylactery, containing a lich''s essence.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEElementalOrb : BEJewelry {
	BEElementalOrb() : base() {
		$this.Name               = 'Elemental Orb'
		$this.MapObjName         = 'elementalorb'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 1
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A glowing orb containing elemental power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEChaosEmerald : BEJewelry {
	BEChaosEmerald() : base() {
		$this.Name               = 'Chaos Emerald'
		$this.MapObjName         = 'chaosemerald'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Attack = 2
			[StatId]::Defense = 2
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
			[StatId]::Speed = 2
			[StatId]::Luck = 2
			[StatId]::Accuracy = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A chaotic emerald, distorting reality.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD  +$($this.TargetStats[[StatId]::Luck]) LCK  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOrderGem : BEJewelry {
	BEOrderGem() : base() {
		$this.Name               = 'Order Gem'
		$this.MapObjName         = 'ordergem'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 1
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
			[StatId]::Speed = 1
			[StatId]::Luck = 1
			[StatId]::Accuracy = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A perfectly balanced gem, promoting harmony.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD  +$($this.TargetStats[[StatId]::Luck]) LCK  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELightCrystal : BEJewelry {
	BELightCrystal() : base() {
		$this.Name               = 'Light Crystal'
		$this.MapObjName         = 'lightcrystal'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 3
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A radiant crystal, emitting pure light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDarkShard : BEJewelry {
	BEDarkShard() : base() {
		$this.Name               = 'Dark Shard'
		$this.MapObjName         = 'darkshard'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::MagicAttack = 4
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A jagged dark shard, filled with malevolence.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEStarfallFragment : BEJewelry {
	BEStarfallFragment() : base() {
		$this.Name               = 'Starfall Fragment'
		$this.MapObjName         = 'starfallfragment'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Speed = 3
			[StatId]::Luck = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A fragment of a fallen star, shimmering with cosmic energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD  +$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVoidStone : BEJewelry {
	BEVoidStone() : base() {
		$this.Name               = 'Void Stone'
		$this.MapObjName         = 'voidstone'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 2
			[StatId]::MagicAttack = 3
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A stone that absorbs all light, connected to the void.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESpiritEssence : BEJewelry {
	BESpiritEssence() : base() {
		$this.Name               = 'Spirit Essence'
		$this.MapObjName         = 'spiritessence'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vial containing a concentrated spirit essence.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESoulGem : BEJewelry {
	BESoulGem() : base() {
		$this.Name               = 'Soul Gem'
		$this.MapObjName         = 'soulgem'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::MagicAttack = 3
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A gem that holds a captured soul, eerie but powerful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELifebloodAmulet : BEJewelry {
	BELifebloodAmulet() : base() {
		$this.Name               = 'Lifeblood Amulet'
		$this.MapObjName         = 'lifebloodamulet'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An amulet pulsating with life energy, granting vitality.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDeathwhisperRing : BEJewelry {
	BEDeathwhisperRing() : base() {
		$this.Name               = 'Deathwhisper Ring'
		$this.MapObjName         = 'deathwhisperring'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ring that whispers of death, chilling to the touch.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETimeBenderChronometer : BEJewelry {
	BETimeBenderChronometer() : base() {
		$this.Name               = 'Time Bender Chronometer'
		$this.MapObjName         = 'timebenderchronometer'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::Speed = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A complex chronometer, subtly altering the flow of time.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESpaceWarpCube : BEJewelry {
	BESpaceWarpCube() : base() {
		$this.Name               = 'Space Warp Cube'
		$this.MapObjName         = 'spacewarpcube'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::Accuracy = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small cube that momentarily bends space.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERealityAnchor : BEJewelry {
	BERealityAnchor() : base() {
		$this.Name               = 'Reality Anchor'
		$this.MapObjName         = 'realityanchor'
		$this.PurchasePrice      = 2300
		$this.SellPrice          = 1150
		$this.TargetStats        = @{
			[StatId]::Defense = 3
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy anchor that stabilizes reality.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDreamcatcherBrooch : BEJewelry {
	BEDreamcatcherBrooch() : base() {
		$this.Name               = 'Dreamcatcher Brooch'
		$this.MapObjName         = 'dreamcatcherbrooch'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A delicate brooch woven to capture pleasant dreams.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BENightmareShard : BEJewelry {
	BENightmareShard() : base() {
		$this.Name               = 'Nightmare Shard'
		$this.MapObjName         = 'nightmareshard'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A jagged shard that induces terrifying nightmares.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BERainbowPrism : BEJewelry {
	BERainbowPrism() : base() {
		$this.Name               = 'Rainbow Prism'
		$this.MapObjName         = 'rainbowprism'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A faceted prism that refracts light into a rainbow.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEclipsePendant : BEJewelry {
	BEEclipsePendant() : base() {
		$this.Name               = 'Eclipse Pendant'
		$this.MapObjName         = 'eclipsependant'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 1
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark pendant resembling an eclipse, symbolizing balance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAuroraCirclet : BEJewelry {
	BEAuroraCirclet() : base() {
		$this.Name               = 'Aurora Circlet'
		$this.MapObjName         = 'auroracirclet'
		$this.PurchasePrice      = 720
		$this.SellPrice          = 360
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shimmering circlet that glows with aurora colors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BECometTailEarring : BEJewelry {
	BECometTailEarring() : base() {
		$this.Name               = 'Comet Tail Earring'
		$this.MapObjName         = 'comettailearring'
		$this.PurchasePrice      = 680
		$this.SellPrice          = 340
		$this.TargetStats        = @{
			[StatId]::Speed = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An earring with a fragment resembling a comet''s tail, increasing speed.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEMeteoriteFragment : BEJewelry {
	BEMeteoriteFragment() : base() {
		$this.Name               = 'Meteorite Fragment'
		$this.MapObjName         = 'meteoritefragment'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rough meteorite fragment, strangely heavy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBlackHoleCore : BEJewelry {
	BEBlackHoleCore() : base() {
		$this.Name               = 'Black Hole Core'
		$this.MapObjName         = 'blackholecore'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 5
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiny, dense core that draws in surrounding energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESupernovaGem : BEJewelry {
	BESupernovaGem() : base() {
		$this.Name               = 'Supernova Gem'
		$this.MapObjName         = 'supernovagem'
		$this.PurchasePrice      = 2300
		$this.SellPrice          = 1150
		$this.TargetStats        = @{
			[StatId]::Attack = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A gem that pulses with immense destructive energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BECosmicDustVial : BEJewelry {
	BECosmicDustVial() : base() {
		$this.Name               = 'Cosmic Dust Vial'
		$this.MapObjName         = 'cosmicdustvial'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 3
			[StatId]::MagicDefense = 3
			[StatId]::Luck = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vial filled with shimmering cosmic dust.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BENebulaCloudPin : BEJewelry {
	BENebulaCloudPin() : base() {
		$this.Name               = 'Nebula Cloud Pin'
		$this.MapObjName         = 'nebulacloudpin'
		$this.PurchasePrice      = 1750
		$this.SellPrice          = 875
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 3
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pin with a swirling nebula trapped within.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGalaxyPearl : BEJewelry {
	BEGalaxyPearl() : base() {
		$this.Name               = 'Galaxy Pearl'
		$this.MapObjName         = 'galaxypearl'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Luck = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pearl that reflects entire galaxies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDimensionShifter : BEJewelry {
	BEDimensionShifter() : base() {
		$this.Name               = 'Dimension Shifter'
		$this.MapObjName         = 'dimensionshifter'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
			[StatId]::Speed = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small device that can momentarily shift dimensions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESoulboundToken : BEJewelry {
	BESoulboundToken() : base() {
		$this.Name               = 'Soulbound Token'
		$this.MapObjName         = 'soulboundtoken'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Attack = 2
			[StatId]::Defense = 2
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A token bound to a powerful soul, granting shared power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAncestralRing : BEJewelry {
	BEAncestralRing() : base() {
		$this.Name               = 'Ancestral Ring'
		$this.MapObjName         = 'ancestralring'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 1
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ring passed down through generations, holding ancient wisdom.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHeirloomBrooch : BEJewelry {
	BEHeirloomBrooch() : base() {
		$this.Name               = 'Heirloom Brooch'
		$this.MapObjName         = 'heirloombrooch'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A family heirloom, imbued with sentimental value.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERelicMedallion : BEJewelry {
	BERelicMedallion() : base() {
		$this.Name               = 'Relic Medallion'
		$this.MapObjName         = 'relicmedallion'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Attack = 2
			[StatId]::Defense = 2
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A powerful medallion from a forgotten age.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESacredTear : BEJewelry {
	BESacredTear() : base() {
		$this.Name               = 'Sacred Tear'
		$this.MapObjName         = 'sacredtear'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A drop of solidified sacred tear, offering healing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEProfaneMark : BEJewelry {
	BEProfaneMark() : base() {
		$this.Name               = 'Profane Mark'
		$this.MapObjName         = 'profanemark'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Attack = 2
			[StatId]::MagicAttack = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark mark, radiating unholy energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEBlessedCharm : BEJewelry {
	BEBlessedCharm() : base() {
		$this.Name               = 'Blessed Charm'
		$this.MapObjName         = 'blessedcharm'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 1
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small charm blessed by a deity, granting protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECursedAmulet : BEJewelry {
	BECursedAmulet() : base() {
		$this.Name               = 'Cursed Amulet'
		$this.MapObjName         = 'cursedamulet'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 1
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An amulet that brings misfortune to its wearer.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFortuneCoin : BEJewelry {
	BEFortuneCoin() : base() {
		$this.Name               = 'Fortune Coin'
		$this.MapObjName         = 'fortunecoin'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Luck = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A coin that seems to always land on its desired side.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMisfortuneToken : BEJewelry {
	BEMisfortuneToken() : base() {
		$this.Name               = 'Misfortune Token'
		$this.MapObjName         = 'misfortunetoken'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A token that brings bad luck.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWhisperwindEarring : BEJewelry {
	BEWhisperwindEarring() : base() {
		$this.Name               = 'Whisperwind Earring'
		$this.MapObjName         = 'whisperwindearring'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Accuracy = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An earring that carries whispers on the wind, granting insight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEThunderclapBracelet : BEJewelry {
	BEThunderclapBracelet() : base() {
		$this.Name               = 'Thunderclap Bracelet'
		$this.MapObjName         = 'thunderclapbracelet'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::MagicAttack = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bracelet that hums with static, occasionally discharging electricity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEFirestormNecklace : BEJewelry {
	BEFirestormNecklace() : base() {
		$this.Name               = 'Firestorm Necklace'
		$this.MapObjName         = 'firestormnecklace'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Attack = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A necklace that feels warm to the touch, capable of igniting minor flames.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFrostbiteRing : BEJewelry {
	BEFrostbiteRing() : base() {
		$this.Name               = 'Frostbite Ring'
		$this.MapObjName         = 'frostbitering'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ring that chills the finger, capable of producing ice.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEarthbindAmulet : BEJewelry {
	BEEarthbindAmulet() : base() {
		$this.Name               = 'Earthbind Amulet'
		$this.MapObjName         = 'earthbindamulet'
		$this.PurchasePrice      = 780
		$this.SellPrice          = 390
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An amulet made of rough stone, rooting the wearer to the ground.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWaterflowBrooch : BEJewelry {
	BEWaterflowBrooch() : base() {
		$this.Name               = 'Waterflow Brooch'
		$this.MapObjName         = 'waterflowbrooch'
		$this.PurchasePrice      = 720
		$this.SellPrice          = 360
		$this.TargetStats        = @{
			[StatId]::Speed = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A brooch that seems to flow like water, granting agility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEAirtwistCirclet : BEJewelry {
	BEAirtwistCirclet() : base() {
		$this.Name               = 'Airtwist Circlet'
		$this.MapObjName         = 'airtwistcirclet'
		$this.PurchasePrice      = 680
		$this.SellPrice          = 340
		$this.TargetStats        = @{
			[StatId]::Speed = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light circlet that allows the wearer to feel air currents.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEShadowgraspGauntlet : BEJewelry {
	BEShadowgraspGauntlet() : base() {
		$this.Name               = 'Shadowgrasp Gauntlet'
		$this.MapObjName         = 'shadowgraspgauntlet'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 1
			[StatId]::Speed = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A gauntlet designed to blend into shadows, enhancing stealth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BELightbringerCharm : BEJewelry {
	BELightbringerCharm() : base() {
		$this.Name               = 'Lightbringer Charm'
		$this.MapObjName         = 'lightbringercharm'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm that emits a soft glow, dispelling darkness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVenomthornRing : BEJewelry {
	BEVenomthornRing() : base() {
		$this.Name               = 'Venomthorn Ring'
		$this.MapObjName         = 'venomthornring'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Attack = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ring with a sharp, poisoned thorn.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBlazeHeart : BEJewelry {
	BEBlazeHeart() : base() {
		$this.Name               = 'Blaze Heart'
		$this.MapObjName         = 'blazeheart'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Attack = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small, pulsating gem that burns with intense heat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGlacierCore : BEJewelry {
	BEGlacierCore() : base() {
		$this.Name               = 'Glacier Core'
		$this.MapObjName         = 'glaciercore'
		$this.PurchasePrice      = 1350
		$this.SellPrice          = 675
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shard of eternal ice, chilling to the bone.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETempestTear : BEJewelry {
	BETempestTear() : base() {
		$this.Name               = 'Tempest Tear'
		$this.MapObjName         = 'tempesttear'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A solidified tear from a storm, granting control over wind.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEQuakeStone : BEJewelry {
	BEQuakeStone() : base() {
		$this.Name               = 'Quake Stone'
		$this.MapObjName         = 'quakestone'
		$this.PurchasePrice      = 1450
		$this.SellPrice          = 725
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy stone that resonates with seismic energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETidalCurrentPearl : BEJewelry {
	BETidalCurrentPearl() : base() {
		$this.Name               = 'Tidal Current Pearl'
		$this.MapObjName         = 'tidalcurrentpearl'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{
			[StatId]::Speed = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pearl that gently pulls and pushes, aiding movement.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEIroncladRing : BEJewelry {
	BEIroncladRing() : base() {
		$this.Name               = 'Ironclad Ring'
		$this.MapObjName         = 'ironcladring'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sturdy iron ring, offering basic defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESteelHeartMedallion : BEJewelry {
	BESteelHeartMedallion() : base() {
		$this.Name               = 'Steel Heart Medallion'
		$this.MapObjName         = 'steelheartmedallion'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy steel medallion, for unwavering resolve.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESilverthreadChain : BEJewelry {
	BESilverthreadChain() : base() {
		$this.Name               = 'Silverthread Chain'
		$this.MapObjName         = 'silverthreadchain'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A finely woven silver chain, for subtle magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEGoldweaveBrooch : BEJewelry {
	BEGoldweaveBrooch() : base() {
		$this.Name               = 'Goldweave Brooch'
		$this.MapObjName         = 'goldweavebrooch'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A brooch woven with gold threads, enhancing beauty.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEPlatinumAmulet : BEJewelry {
	BEPlatinumAmulet() : base() {
		$this.Name               = 'Platinum Amulet'
		$this.MapObjName         = 'platinumamulet'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 1
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sleek platinum amulet, radiating sophistication.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETitaniumRing : BEJewelry {
	BETitaniumRing() : base() {
		$this.Name               = 'Titanium Ring'
		$this.MapObjName         = 'titaniumring'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A lightweight but incredibly strong titanium ring.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEMythrilCirclet : BEJewelry {
	BEMythrilCirclet() : base() {
		$this.Name               = 'Mythril Circlet'
		$this.MapObjName         = 'mythrilcirclet'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shimmering mythril circlet, for adept spellcasters.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEAdamantitePendant : BEJewelry {
	BEAdamantitePendant() : base() {
		$this.Name               = 'Adamantite Pendant'
		$this.MapObjName         = 'adamantitependant'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark, heavy adamantite pendant, for ultimate defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEObsidianCharm : BEJewelry {
	BEObsidianCharm() : base() {
		$this.Name               = 'Obsidian Charm'
		$this.MapObjName         = 'obsidiancharm'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 1
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A black obsidian charm, absorbing dark energies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECrystalTear : BEJewelry {
	BECrystalTear() : base() {
		$this.Name               = 'Crystal Tear'
		$this.MapObjName         = 'crystaltear'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A single, perfectly formed crystal tear.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEGeodeFragment : BEJewelry {
	BEGeodeFragment() : base() {
		$this.Name               = 'Geode Fragment'
		$this.MapObjName         = 'geodefragment'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rough geode fragment, sparkling with hidden crystals.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAmberEarring : BEJewelry {
	BEAmberEarring() : base() {
		$this.Name               = 'Amber Earring'
		$this.MapObjName         = 'amberearring'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A warm amber earring, preserving ancient energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEJetBracelet : BEJewelry {
	BEJetBracelet() : base() {
		$this.Name               = 'Jet Bracelet'
		$this.MapObjName         = 'jetbracelet'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A glossy black jet bracelet, for subtle power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BETurquoiseNecklace : BEJewelry {
	BETurquoiseNecklace() : base() {
		$this.Name               = 'Turquoise Necklace'
		$this.MapObjName         = 'turquoisenecklace'
		$this.PurchasePrice      = 480
		$this.SellPrice          = 240
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vibrant turquoise necklace, connecting to the sky.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEPeridotRing : BEJewelry {
	BEPeridotRing() : base() {
		$this.Name               = 'Peridot Ring'
		$this.MapObjName         = 'peridotring'
		$this.PurchasePrice      = 470
		$this.SellPrice          = 235
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bright green peridot ring, radiating freshness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBloodstoneAmulet : BEJewelry {
	BEBloodstoneAmulet() : base() {
		$this.Name               = 'Bloodstone Amulet'
		$this.MapObjName         = 'bloodstoneamulet'
		$this.PurchasePrice      = 520
		$this.SellPrice          = 260
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark green bloodstone amulet, rumored to stop bleeding.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BELapisLazuliBrooch : BEJewelry {
	BELapisLazuliBrooch() : base() {
		$this.Name               = 'Lapis Lazuli Brooch'
		$this.MapObjName         = 'lapislazulibrooch'
		$this.PurchasePrice      = 460
		$this.SellPrice          = 230
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A deep blue lapis lazuli brooch, for inner peace.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEMalachiteRing : BEJewelry {
	BEMalachiteRing() : base() {
		$this.Name               = 'Malachite Ring'
		$this.MapObjName         = 'malachitering'
		$this.PurchasePrice      = 490
		$this.SellPrice          = 245
		$this.TargetStats        = @{
			[StatId]::Defense = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A patterned malachite ring, for grounding energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMoonpetalCharm : BEJewelry {
	BEMoonpetalCharm() : base() {
		$this.Name               = 'Moonpetal Charm'
		$this.MapObjName         = 'moonpetalcharm'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm made from a petal bathed in moonlight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BESunpetalBrooch : BEJewelry {
	BESunpetalBrooch() : base() {
		$this.Name               = 'Sunpetal Brooch'
		$this.MapObjName         = 'sunpetalbrooch'
		$this.PurchasePrice      = 620
		$this.SellPrice          = 310
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A brooch made from a petal warmed by sunlight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStarflakeEarring : BEJewelry {
	BEStarflakeEarring() : base() {
		$this.Name               = 'Starflake Earring'
		$this.MapObjName         = 'starflakeearring'
		$this.PurchasePrice      = 580
		$this.SellPrice          = 290
		$this.TargetStats        = @{
			[StatId]::Speed = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A delicate earring resembling a starflake, for swiftness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BECloudspunThread : BEJewelry {
	BECloudspunThread() : base() {
		$this.Name               = 'Cloudspun Thread'
		$this.MapObjName         = 'cloudspunthread'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Speed = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A strand of thread woven from clouds, incredibly light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMistveilShawl : BEJewelry {
	BEMistveilShawl() : base() {
		$this.Name               = 'Mistveil Shawl'
		$this.MapObjName         = 'mistveilshawl'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 1
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shimmering shawl that creates a light mist.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEGossamerFilament : BEJewelry {
	BEGossamerFilament() : base() {
		$this.Name               = 'Gossamer Filament'
		$this.MapObjName         = 'gossamerfilament'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Speed = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An almost invisible filament, for subtle movements.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEZephyrFeather : BEJewelry {
	BEZephyrFeather() : base() {
		$this.Name               = 'Zephyr Feather'
		$this.MapObjName         = 'zephyrfeather'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Speed = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A feather from the swift zephyr bird, granting speed.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDewdropPendant : BEJewelry {
	BEDewdropPendant() : base() {
		$this.Name               = 'Dewdrop Pendant'
		$this.MapObjName         = 'dewdroppendant'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pendant with a perpetual dewdrop, refreshing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BERiverstoneRing : BEJewelry {
	BERiverstoneRing() : base() {
		$this.Name               = 'Riverstone Ring'
		$this.MapObjName         = 'riverstonering'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A smooth riverstone ring, providing calm.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWaterfallGem : BEJewelry {
	BEWaterfallGem() : base() {
		$this.Name               = 'Waterfall Gem'
		$this.MapObjName         = 'waterfallgem'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A gem that constantly reflects flowing water.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEMountainheartMedallion : BEJewelry {
	BEMountainheartMedallion() : base() {
		$this.Name               = 'Mountainheart Medallion'
		$this.MapObjName         = 'mountainheartmedallion'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rough medallion from the heart of a mountain, unyielding.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEForestwhisperCharm : BEJewelry {
	BEForestwhisperCharm() : base() {
		$this.Name               = 'Forestwhisper Charm'
		$this.MapObjName         = 'forestwhispercharm'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm that seems to hum with the sounds of the forest.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEDesertRoseBrooch : BEJewelry {
	BEDesertRoseBrooch() : base() {
		$this.Name               = 'Desert Rose Brooch'
		$this.MapObjName         = 'desertrosebrooch'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A delicate brooch resembling a desert rose, enduring.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEIceboundShard : BEJewelry {
	BEIceboundShard() : base() {
		$this.Name               = 'Icebound Shard'
		$this.MapObjName         = 'iceboundshard'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 1
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shard of perpetually frozen ice, chilling to the touch.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVolcanoEmber : BEJewelry {
	BEVolcanoEmber() : base() {
		$this.Name               = 'Volcano Ember'
		$this.MapObjName         = 'volcanoember'
		$this.PurchasePrice      = 1150
		$this.SellPrice          = 575
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::MagicAttack = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small ember from a volcano, radiating heat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStormcloudEarring : BEJewelry {
	BEStormcloudEarring() : base() {
		$this.Name               = 'Stormcloud Earring'
		$this.MapObjName         = 'stormcloudearring'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An earring that crackles with faint static electricity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEQuicksandHourglass : BEJewelry {
	BEQuicksandHourglass() : base() {
		$this.Name               = 'Quicksand Hourglass'
		$this.MapObjName         = 'quicksandhourglass'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiny hourglass with perpetually shifting sand.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMirageDustVial : BEJewelry {
	BEMirageDustVial() : base() {
		$this.Name               = 'Mirage Dust Vial'
		$this.MapObjName         = 'miragedustvial'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vial of shimmering dust that creates illusions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEchoingConch : BEJewelry {
	BEEchoingConch() : base() {
		$this.Name               = 'Echoing Conch'
		$this.MapObjName         = 'echoingconch'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A conch shell that echoes faint sounds of the past.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWhisperingWillowAmulet : BEJewelry {
	BEWhisperingWillowAmulet() : base() {
		$this.Name               = 'Whispering Willow Amulet'
		$this.MapObjName         = 'whisperingwillowamulet'
		$this.PurchasePrice      = 680
		$this.SellPrice          = 340
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An amulet carved from whispering willow wood.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEThornsEmbraceRing : BEJewelry {
	BEThornsEmbraceRing() : base() {
		$this.Name               = 'Thorns Embrace Ring'
		$this.MapObjName         = 'thornsembracering'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ring resembling thorny vines, protective.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPetalfallNecklace : BEJewelry {
	BEPetalfallNecklace() : base() {
		$this.Name               = 'Petalfall Necklace'
		$this.MapObjName         = 'petalfallnecklace'
		$this.PurchasePrice      = 720
		$this.SellPrice          = 360
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A necklace adorned with perpetually falling petals, ethereal.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BECinderstoneBracelet : BEJewelry {
	BECinderstoneBracelet() : base() {
		$this.Name               = 'Cinderstone Bracelet'
		$this.MapObjName         = 'cinderstonebracelet'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bracelet made of cooled volcanic cinder.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEBramblethornBrooch : BEJewelry {
	BEBramblethornBrooch() : base() {
		$this.Name               = 'Bramblethorn Brooch'
		$this.MapObjName         = 'bramblethornbrooch'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A brooch shaped like thorny brambles, deterring.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStarlightCirclet : BEJewelry {
	BEStarlightCirclet() : base() {
		$this.Name               = 'Starlight Circlet'
		$this.MapObjName         = 'starlightcirclet'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 3
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A circlet that seems to gather starlight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEMoonglowPendant : BEJewelry {
	BEMoonglowPendant() : base() {
		$this.Name               = 'Moonglow Pendant'
		$this.MapObjName         = 'moonglowpendant'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pendant that emits a soft, ethereal glow.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BESunbeamBrooch : BEJewelry {
	BESunbeamBrooch() : base() {
		$this.Name               = 'Sunbeam Brooch'
		$this.MapObjName         = 'sunbeambrooch'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A brooch that captures a single, perpetual sunbeam.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAuroraBorealisGem : BEJewelry {
	BEAuroraBorealisGem() : base() {
		$this.Name               = 'Aurora Borealis Gem'
		$this.MapObjName         = 'auroraborealisgem'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 3
			[StatId]::MagicDefense = 3
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A gem that shimmers with the colors of the aurora.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECometDustVial : BEJewelry {
	BECometDustVial() : base() {
		$this.Name               = 'Comet Dust Vial'
		$this.MapObjName         = 'cometdustvial'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Speed = 2
			[StatId]::Luck = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vial filled with the dust of a passing comet.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD  +$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMeteorShowerFragment : BEJewelry {
	BEMeteorShowerFragment() : base() {
		$this.Name               = 'Meteor Shower Fragment'
		$this.MapObjName         = 'meteorshowerfragment'
		$this.PurchasePrice      = 1450
		$this.SellPrice          = 725
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A fragment from a spectacular meteor shower.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPlanetaryRing : BEJewelry {
	BEPlanetaryRing() : base() {
		$this.Name               = 'Planetary Ring'
		$this.MapObjName         = 'planetaryring'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ring that has miniature planets orbiting it.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECelestialSphereEarring : BEJewelry {
	BECelestialSphereEarring() : base() {
		$this.Name               = 'Celestial Sphere Earring'
		$this.MapObjName         = 'celestialsphereearring'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 3
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An earring with a tiny celestial sphere.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEAndromedaCharm : BEJewelry {
	BEAndromedaCharm() : base() {
		$this.Name               = 'Andromeda Charm'
		$this.MapObjName         = 'andromedacharm'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Accuracy = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm depicting the Andromeda galaxy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMilkyWayBracelet : BEJewelry {
	BEMilkyWayBracelet() : base() {
		$this.Name               = 'Milky Way Bracelet'
		$this.MapObjName         = 'milkywaybracelet'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 4
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bracelet that seems to swirl with countless stars.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BENebulaHeart : BEJewelry {
	BENebulaHeart() : base() {
		$this.Name               = 'Nebula Heart'
		$this.MapObjName         = 'nebulaheart'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 4
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pulsating gem that resembles a distant nebula.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEQuasarShard : BEJewelry {
	BEQuasarShard() : base() {
		$this.Name               = 'Quasar Shard'
		$this.MapObjName         = 'quasarshard'
		$this.PurchasePrice      = 2400
		$this.SellPrice          = 1200
		$this.TargetStats        = @{
			[StatId]::Attack = 3
			[StatId]::MagicAttack = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shard from a quasar, radiating immense energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPulsarCore : BEJewelry {
	BEPulsarCore() : base() {
		$this.Name               = 'Pulsar Core'
		$this.MapObjName         = 'pulsarcore'
		$this.PurchasePrice      = 2300
		$this.SellPrice          = 1150
		$this.TargetStats        = @{
			[StatId]::Speed = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rapidly spinning core, generating powerful magnetic fields.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECosmicStringFragment : BEJewelry {
	BECosmicStringFragment() : base() {
		$this.Name               = 'Cosmic String Fragment'
		$this.MapObjName         = 'cosmicstringfragment'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::Accuracy = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A fragment of an infinitely thin cosmic string.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMultiverseKey : BEJewelry {
	BEMultiverseKey() : base() {
		$this.Name               = 'Multiverse Key'
		$this.MapObjName         = 'multiversekey'
		$this.PurchasePrice      = 2600
		$this.SellPrice          = 1300
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A key rumored to unlock doors between dimensions.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDreamWeaverLoom : BEJewelry {
	BEDreamWeaverLoom() : base() {
		$this.Name               = 'Dream Weaver Loom'
		$this.MapObjName         = 'dreamweaverloom'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiny loom that subtly influences dreams.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BENightWalkerShroud : BEJewelry {
	BENightWalkerShroud() : base() {
		$this.Name               = 'Night Walker Shroud'
		$this.MapObjName         = 'nightwalkershroud'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Speed = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small piece of shroud that aids in moving unseen.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEDaybreakPendant : BEJewelry {
	BEDaybreakPendant() : base() {
		$this.Name               = 'Daybreak Pendant'
		$this.MapObjName         = 'daybreakpendant'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pendant that always seems to catch the first rays of dawn.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETwilightBrooch : BEJewelry {
	BETwilightBrooch() : base() {
		$this.Name               = 'Twilight Brooch'
		$this.MapObjName         = 'twilightbrooch'
		$this.PurchasePrice      = 920
		$this.SellPrice          = 460
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A brooch that shimmers with the colors of dusk.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDuskpetalEarring : BEJewelry {
	BEDuskpetalEarring() : base() {
		$this.Name               = 'Duskpetal Earring'
		$this.MapObjName         = 'duskpetalearring'
		$this.PurchasePrice      = 880
		$this.SellPrice          = 440
		$this.TargetStats        = @{
			[StatId]::Speed = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An earring made from a petal that blooms only at dusk.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEDawnfeatherCharm : BEJewelry {
	BEDawnfeatherCharm() : base() {
		$this.Name               = 'Dawnfeather Charm'
		$this.MapObjName         = 'dawnfeathercharm'
		$this.PurchasePrice      = 870
		$this.SellPrice          = 435
		$this.TargetStats        = @{
			[StatId]::Speed = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm with a feather from a bird that sings at dawn.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEGlimmergemRing : BEJewelry {
	BEGlimmergemRing() : base() {
		$this.Name               = 'Glimmergem Ring'
		$this.MapObjName         = 'glimmergemring'
		$this.PurchasePrice      = 780
		$this.SellPrice          = 390
		$this.TargetStats        = @{
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ring with a gem that always seems to glimmer.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFlickerflamePendant : BEJewelry {
	BEFlickerflamePendant() : base() {
		$this.Name               = 'Flickerflame Pendant'
		$this.MapObjName         = 'flickerflamependant'
		$this.PurchasePrice      = 820
		$this.SellPrice          = 410
		$this.TargetStats        = @{
			[StatId]::Attack = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pendant with a perpetual, tiny flame.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESparklightCirclet : BEJewelry {
	BESparklightCirclet() : base() {
		$this.Name               = 'Sparklight Circlet'
		$this.MapObjName         = 'sparklightcirclet'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A circlet that emits tiny, harmless sparks of light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEShimmerstoneBracelet : BEJewelry {
	BEShimmerstoneBracelet() : base() {
		$this.Name               = 'Shimmerstone Bracelet'
		$this.MapObjName         = 'shimmerstonebracelet'
		$this.PurchasePrice      = 730
		$this.SellPrice          = 365
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bracelet made of stones that subtly shimmer.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGlowwormLamp : BEJewelry {
	BEGlowwormLamp() : base() {
		$this.Name               = 'Glowworm Lamp'
		$this.MapObjName         = 'glowwormlamp'
		$this.PurchasePrice      = 680
		$this.SellPrice          = 340
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiny lamp containing a perpetual glowworm.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFireflyJar : BEJewelry {
	BEFireflyJar() : base() {
		$this.Name               = 'Firefly Jar'
		$this.MapObjName         = 'fireflyjar'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A miniature jar containing perpetually glowing fireflies.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWillothewispOrb : BEJewelry {
	BEWillothewispOrb() : base() {
		$this.Name               = 'Willothewisp Orb'
		$this.MapObjName         = 'willothewisporb'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small orb that floats and bobs like a will-o-the-wisp.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFadingEmber : BEJewelry {
	BEFadingEmber() : base() {
		$this.Name               = 'Fading Ember'
		$this.MapObjName         = 'fadingember'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dying ember that occasionally flares.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEternalFlameMedallion : BEJewelry {
	BEEternalFlameMedallion() : base() {
		$this.Name               = 'Eternal Flame Medallion'
		$this.MapObjName         = 'eternalflamemedallion'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Attack = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A medallion with a small, perpetual flame.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEPermafrostShard : BEJewelry {
	BEPermafrostShard() : base() {
		$this.Name               = 'Permafrost Shard'
		$this.MapObjName         = 'permafrostshard'
		$this.PurchasePrice      = 1350
		$this.SellPrice          = 675
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shard of ice that never melts.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEverflowingDrop : BEJewelry {
	BEEverflowingDrop() : base() {
		$this.Name               = 'Everflowing Drop'
		$this.MapObjName         = 'everflowingdrop'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A drop of water that never dries.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBoundlessAirCirclet : BEJewelry {
	BEBoundlessAirCirclet() : base() {
		$this.Name               = 'Boundless Air Circlet'
		$this.MapObjName         = 'boundlessaircirclet'
		$this.PurchasePrice      = 1150
		$this.SellPrice          = 575
		$this.TargetStats        = @{
			[StatId]::Speed = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A circlet that allows the wearer to breathe freely.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEUnyieldingEarthRing : BEJewelry {
	BEUnyieldingEarthRing() : base() {
		$this.Name               = 'Unyielding Earth Ring'
		$this.MapObjName         = 'unyieldingearthring'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ring made of solid earth, incredibly durable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESilentStepAnklet : BEJewelry {
	BESilentStepAnklet() : base() {
		$this.Name               = 'Silent Step Anklet'
		$this.MapObjName         = 'silentstepanklet'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Speed = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An anklet that muffles footsteps, for stealth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETrueSightLens : BEJewelry {
	BETrueSightLens() : base() {
		$this.Name               = 'True Sight Lens'
		$this.MapObjName         = 'truesightlens'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Accuracy = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A monocle that allows the wearer to see hidden things.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFortressHeartstone : BEJewelry {
	BEFortressHeartstone() : base() {
		$this.Name               = 'Fortress Heartstone'
		$this.MapObjName         = 'fortressheartstone'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heart shaped stone that provides immense defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESorcerersEye : BEJewelry {
	BESorcerersEye() : base() {
		$this.Name               = 'Sorcerer''s Eye'
		$this.MapObjName         = 'sorcererseye'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An ominous eye shaped gem, enhancing dark magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESagesMindstone : BEJewelry {
	BESagesMindstone() : base() {
		$this.Name               = 'Sage''s Mindstone'
		$this.MapObjName         = 'sagesmindstone'
		$this.PurchasePrice      = 1650
		$this.SellPrice          = 825
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A smooth, polished stone that enhances intellect.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAcrobatsCharm : BEJewelry {
	BEAcrobatsCharm() : base() {
		$this.Name               = 'Acrobat''s Charm'
		$this.MapObjName         = 'acrobatscharm'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Speed = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small charm that aids in agility and balance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMarksmansScope : BEJewelry {
	BEMarksmansScope() : base() {
		$this.Name               = 'Marksman''s Scope'
		$this.MapObjName         = 'marksmansscope'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Accuracy = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A miniature scope that enhances accuracy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEBerserkersRageGem : BEJewelry {
	BEBerserkersRageGem() : base() {
		$this.Name               = 'Berserker''s Rage Gem'
		$this.MapObjName         = 'berserkersragegem'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Attack = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A volatile gem that pulses with raw anger.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEGuardiansAegis : BEJewelry {
	BEGuardiansAegis() : base() {
		$this.Name               = 'Guardian''s Aegis'
		$this.MapObjName         = 'guardiansaegis'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small shield shaped amulet, for staunch defenders.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEPaladinsVowRing : BEJewelry {
	BEPaladinsVowRing() : base() {
		$this.Name               = 'Paladin''s Vow Ring'
		$this.MapObjName         = 'paladinsvowring'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 1
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ring that glows faintly, symbolizing a holy vow.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEPriestesssBlessingBead : BEJewelry {
	BEPriestesssBlessingBead() : base() {
		$this.Name               = 'Priestess''s Blessing Bead'
		$this.MapObjName         = 'priestesssblessingbead'
		$this.PurchasePrice      = 1350
		$this.SellPrice          = 675
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A single bead imbued with divine blessing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEWitchsBrewVial : BEJewelry {
	BEWitchsBrewVial() : base() {
		$this.Name               = 'Witch''s Brew Vial'
		$this.MapObjName         = 'witchsbrewvial'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small vial containing a bubbling, potent brew.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BENecromancersTotem : BEJewelry {
	BENecromancersTotem() : base() {
		$this.Name               = 'Necromancer''s Totem'
		$this.MapObjName         = 'necromancerstotem'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark totem crafted from bone and shadows.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEBardsLyrePin : BEJewelry {
	BEBardsLyrePin() : base() {
		$this.Name               = 'Bard''s Lyre Pin'
		$this.MapObjName         = 'bardslyrepin'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small pin shaped like a lyre, enhancing charm.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERoguesDaggerClip : BEJewelry {
	BERoguesDaggerClip() : base() {
		$this.Name               = 'Rogue''s Dagger Clip'
		$this.MapObjName         = 'roguesdaggerclip'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Speed = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A clip shaped like a small dagger, for quick action.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWarriorsCrest : BEJewelry {
	BEWarriorsCrest() : base() {
		$this.Name               = 'Warrior''s Crest'
		$this.MapObjName         = 'warriorscrest'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Attack = 2
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small crest, symbolizing strength and courage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEArchersQuiverPin : BEJewelry {
	BEArchersQuiverPin() : base() {
		$this.Name               = 'Archer''s Quiver Pin'
		$this.MapObjName         = 'archersquiverpin'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Accuracy = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pin shaped like a small quiver, enhancing precision.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEThiefsLockpickCharm : BEJewelry {
	BEThiefsLockpickCharm() : base() {
		$this.Name               = 'Thief''s Lockpick Charm'
		$this.MapObjName         = 'thiefslockpickcharm'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Speed = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm resembling a tiny lockpick, for nimble fingers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAssassinsPoisonVial : BEJewelry {
	BEAssassinsPoisonVial() : base() {
		$this.Name               = 'Assassin''s Poison Vial'
		$this.MapObjName         = 'assassinspoisonvial'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiny vial of potent, slow acting poison.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHealersAnkh : BEJewelry {
	BEHealersAnkh() : base() {
		$this.Name               = 'Healer''s Ankh'
		$this.MapObjName         = 'healersankh'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An ankh symbol, for rapid recovery.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEArtificersCogwheel : BEJewelry {
	BEArtificersCogwheel() : base() {
		$this.Name               = 'Artificer''s Cogwheel'
		$this.MapObjName         = 'artificerscogwheel'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiny, perpetually turning cogwheel.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEScholarsQuillBrooch : BEJewelry {
	BEScholarsQuillBrooch() : base() {
		$this.Name               = 'Scholar''s Quill Brooch'
		$this.MapObjName         = 'scholarsquillbrooch'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A brooch shaped like a quill, enhancing learning.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMerchantsScaleCharm : BEJewelry {
	BEMerchantsScaleCharm() : base() {
		$this.Name               = 'Merchant''s Scale Charm'
		$this.MapObjName         = 'merchantsscalecharm'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Luck = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm shaped like a tiny balance scale, for good deals.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFarmersScythePin : BEJewelry {
	BEFarmersScythePin() : base() {
		$this.Name               = 'Farmer''s Scythe Pin'
		$this.MapObjName         = 'farmersscythepin'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pin shaped like a miniature scythe, for good harvests.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFishermansHookPendant : BEJewelry {
	BEFishermansHookPendant() : base() {
		$this.Name               = 'Fisherman''s Hook Pendant'
		$this.MapObjName         = 'fishermanshookpendant'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pendant shaped like a fish hook, for bountiful catches.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEHuntersTrapBadge : BEJewelry {
	BEHuntersTrapBadge() : base() {
		$this.Name               = 'Hunter''s Trap Badge'
		$this.MapObjName         = 'hunterstrapbadge'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Accuracy = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A badge resembling a small trap, for tracking.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECooksLadlePin : BEJewelry {
	BECooksLadlePin() : base() {
		$this.Name               = 'Cook''s Ladle Pin'
		$this.MapObjName         = 'cooksladlepin'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pin shaped like a small ladle, for culinary prowess.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBlacksmithsHammerCharm : BEJewelry {
	BEBlacksmithsHammerCharm() : base() {
		$this.Name               = 'Blacksmith''s Hammer Charm'
		$this.MapObjName         = 'blacksmithshammercharm'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Attack = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm shaped like a tiny hammer, for crafting.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BETailorsNeedleBrooch : BEJewelry {
	BETailorsNeedleBrooch() : base() {
		$this.Name               = 'Tailor''s Needle Brooch'
		$this.MapObjName         = 'tailorsneedlebrooch'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A brooch shaped like a needle, for fine stitching.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Female
	}
}

Class BECarpentersSawPendant : BEJewelry {
	BECarpentersSawPendant() : base() {
		$this.Name               = 'Carpenter''s Saw Pendant'
		$this.MapObjName         = 'carpenterssawpendant'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Attack = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pendant shaped like a small saw, for construction.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEJewelersLoupeRing : BEJewelry {
	BEJewelersLoupeRing() : base() {
		$this.Name               = 'Jeweler''s Loupe Ring'
		$this.MapObjName         = 'jewelersloupering'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Accuracy = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ring with a tiny magnifying glass, for discerning details.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAlchemistsMortarPin : BEJewelry {
	BEAlchemistsMortarPin() : base() {
		$this.Name               = 'Alchemist''s Mortar Pin'
		$this.MapObjName         = 'alchemistsmortarpin'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pin shaped like a mortar and pestle, for potions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBrewersTankardCharm : BEJewelry {
	BEBrewersTankardCharm() : base() {
		$this.Name               = 'Brewer''s Tankard Charm'
		$this.MapObjName         = 'brewerstankardcharm'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm shaped like a miniature tankard, for hearty drinks.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEGamblersDice : BEJewelry {
	BEGamblersDice() : base() {
		$this.Name               = 'Gambler''s Dice'
		$this.MapObjName         = 'gamblersdice'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Luck = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiny pair of perpetually tumbling dice.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEJestersBell : BEJewelry {
	BEJestersBell() : base() {
		$this.Name               = 'Jester''s Bell'
		$this.MapObjName         = 'jestersbell'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Speed = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small, perpetually jingling bell.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDancersRibbon : BEJewelry {
	BEDancersRibbon() : base() {
		$this.Name               = 'Dancer''s Ribbon'
		$this.MapObjName         = 'dancersribbon'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Speed = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A delicate ribbon that flows gracefully.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BESingersVoiceCharm : BEJewelry {
	BESingersVoiceCharm() : base() {
		$this.Name               = 'Singer''s Voice Charm'
		$this.MapObjName         = 'singersvoicecharm'
		$this.PurchasePrice      = 620
		$this.SellPrice          = 310
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm that subtly enhances the voice.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEActorsMaskPin : BEJewelry {
	BEActorsMaskPin() : base() {
		$this.Name               = 'Actor''s Mask Pin'
		$this.MapObjName         = 'actorsmaskpin'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pin shaped like a theatrical mask, for performance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEArtistsBrushBrooch : BEJewelry {
	BEArtistsBrushBrooch() : base() {
		$this.Name               = 'Artist''s Brush Brooch'
		$this.MapObjName         = 'artistsbrushbrooch'
		$this.PurchasePrice      = 680
		$this.SellPrice          = 340
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A brooch shaped like a paint brush, for creativity.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESculptorsChiselPendant : BEJewelry {
	BESculptorsChiselPendant() : base() {
		$this.Name               = 'Sculptor''s Chisel Pendant'
		$this.MapObjName         = 'sculptorschiselpendant'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Attack = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pendant shaped like a tiny chisel, for precision.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWritersInkwellCharm : BEJewelry {
	BEWritersInkwellCharm() : base() {
		$this.Name               = 'Writer''s Inkwell Charm'
		$this.MapObjName         = 'writersinkwellcharm'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm shaped like an inkwell, for inspiration.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMusiciansClefPin : BEJewelry {
	BEMusiciansClefPin() : base() {
		$this.Name               = 'Musician''s Clef Pin'
		$this.MapObjName         = 'musiciansclefpin'
		$this.PurchasePrice      = 620
		$this.SellPrice          = 310
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pin shaped like a musical clef, for harmony.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEExplorersCompass : BEJewelry {
	BEExplorersCompass() : base() {
		$this.Name               = 'Explorer''s Compass'
		$this.MapObjName         = 'explorerscompass'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Accuracy = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiny compass that always points true.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BENavigatorsSextantCharm : BEJewelry {
	BENavigatorsSextantCharm() : base() {
		$this.Name               = 'Navigator''s Sextant Charm'
		$this.MapObjName         = 'navigatorssextantcharm'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Accuracy = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm shaped like a miniature sextant, for guidance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECartographersScroll : BEJewelry {
	BECartographersScroll() : base() {
		$this.Name               = 'Cartographer''s Scroll'
		$this.MapObjName         = 'cartographersscroll'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A miniature scroll that always unrolls to a map.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEArchaeologistsTrowel : BEJewelry {
	BEArchaeologistsTrowel() : base() {
		$this.Name               = 'Archaeologist''s Trowel'
		$this.MapObjName         = 'archaeologiststrowel'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiny trowel for uncovering ancient secrets.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELinguistsRosettaStone : BEJewelry {
	BELinguistsRosettaStone() : base() {
		$this.Name               = 'Linguist''s Rosetta Stone'
		$this.MapObjName         = 'linguistsrosettastone'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small fragment resembling the Rosetta Stone, for understanding languages.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBotanistsLeafBrooch : BEJewelry {
	BEBotanistsLeafBrooch() : base() {
		$this.Name               = 'Botanist''s Leaf Brooch'
		$this.MapObjName         = 'botanistsleafbrooch'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A brooch shaped like a perfect leaf, for plant growth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEZoologistsPawPrint : BEJewelry {
	BEZoologistsPawPrint() : base() {
		$this.Name               = 'Zoologist''s Paw Print'
		$this.MapObjName         = 'zoologistspawprint'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm with a delicate paw print, for animal empathy.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGeologistsPickaxePin : BEJewelry {
	BEGeologistsPickaxePin() : base() {
		$this.Name               = 'Geologist''s Pickaxe Pin'
		$this.MapObjName         = 'geologistspickaxepin'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pin shaped like a tiny pickaxe, for mineral detection.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEAstronomersTelescope : BEJewelry {
	BEAstronomersTelescope() : base() {
		$this.Name               = 'Astronomer''s Telescope'
		$this.MapObjName         = 'astronomerstelescope'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiny telescope that reveals distant stars.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOceanographersWaveCharm : BEJewelry {
	BEOceanographersWaveCharm() : base() {
		$this.Name               = 'Oceanographer''s Wave Charm'
		$this.MapObjName         = 'oceanographerswavecharm'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm shaped like a perfect wave, for navigating seas.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEClimatologistsCloudPin : BEJewelry {
	BEClimatologistsCloudPin() : base() {
		$this.Name               = 'Climatologist''s Cloud Pin'
		$this.MapObjName         = 'climatologistscloudpin'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pin shaped like a small cloud, for predicting weather.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

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

Class BEPhilosophersStoneFragment : BEJewelry {
	BEPhilosophersStoneFragment() : base() {
		$this.Name               = 'Philosopher''s Stone Fragment'
		$this.MapObjName         = 'philosophersstonefragment'
		$this.PurchasePrice      = 2800
		$this.SellPrice          = 1400
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 1
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
			[StatId]::Luck = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiny fragment of the legendary Philosopher''s Stone.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWanderersBootsCharm : BEJewelry {
	BEWanderersBootsCharm() : base() {
		$this.Name               = 'Wanderer''s Boots Charm'
		$this.MapObjName         = 'wanderersbootscharm'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Speed = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm shaped like a tiny boot, for long journeys.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPilgrimsScallopShell : BEJewelry {
	BEPilgrimsScallopShell() : base() {
		$this.Name               = 'Pilgrim''s Scallop Shell'
		$this.MapObjName         = 'pilgrimsscallopshell'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small scallop shell, symbolizing a completed journey.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHermitsLanternPin : BEJewelry {
	BEHermitsLanternPin() : base() {
		$this.Name               = 'Hermit''s Lantern Pin'
		$this.MapObjName         = 'hermitslanternpin'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pin shaped like a small lantern, for solitary exploration.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAsceticsSimpleCord : BEJewelry {
	BEAsceticsSimpleCord() : base() {
		$this.Name               = 'Ascetic''s Simple Cord'
		$this.MapObjName         = 'asceticssimplecord'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A plain cord, representing simplicity and detachment.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMonksPrayerBeads : BEJewelry {
	BEMonksPrayerBeads() : base() {
		$this.Name               = 'Monk''s Prayer Beads'
		$this.MapObjName         = 'monksprayerbeads'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small string of prayer beads, for meditation.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWarriorMonksFistCharm : BEJewelry {
	BEWarriorMonksFistCharm() : base() {
		$this.Name               = 'Warrior Monk''s Fist Charm'
		$this.MapObjName         = 'warriormonksfistcharm'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm shaped like a clenched fist, for martial discipline.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BERogueMonksShadowStep : BEJewelry {
	BERogueMonksShadowStep() : base() {
		$this.Name               = 'Rogue Monk''s Shadow Step'
		$this.MapObjName         = 'roguemonksshadowstep'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Speed = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small shadow-like charm, aiding in silent movement.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPaladinsOathScroll : BEJewelry {
	BEPaladinsOathScroll() : base() {
		$this.Name               = 'Paladin''s Oath Scroll'
		$this.MapObjName         = 'paladinsoathscroll'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A miniature scroll inscribed with a holy oath.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEClericsDivineSymbol : BEJewelry {
	BEClericsDivineSymbol() : base() {
		$this.Name               = 'Cleric''s Divine Symbol'
		$this.MapObjName         = 'clericsdivinesymbol'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small, glowing divine symbol.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEDruidsVineCharm : BEJewelry {
	BEDruidsVineCharm() : base() {
		$this.Name               = 'Druid''s Vine Charm'
		$this.MapObjName         = 'druidsvinecharm'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm woven from living vines, connecting to nature.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEBardsHarmonyGem : BEJewelry {
	BEBardsHarmonyGem() : base() {
		$this.Name               = 'Bard''s Harmony Gem'
		$this.MapObjName         = 'bardsharmonygem'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A gem that resonates with perfect harmony.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESorcerersFocusCrystal : BEJewelry {
	BESorcerersFocusCrystal() : base() {
		$this.Name               = 'Sorcerer''s Focus Crystal'
		$this.MapObjName         = 'sorcerersfocuscrystal'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crystal that enhances magical concentration.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWarlocksPactSigil : BEJewelry {
	BEWarlocksPactSigil() : base() {
		$this.Name               = 'Warlock''s Pact Sigil'
		$this.MapObjName         = 'warlockspactsigil'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark sigil representing a forbidden pact.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BENecromancersBoneDust : BEJewelry {
	BENecromancersBoneDust() : base() {
		$this.Name               = 'Necromancer''s Bone Dust'
		$this.MapObjName         = 'necromancersbonedust'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small pouch of fine bone dust, for raising the dead.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESummonersBindingCircle : BEJewelry {
	BESummonersBindingCircle() : base() {
		$this.Name               = 'Summoner''s Binding Circle'
		$this.MapObjName         = 'summonersbindingcircle'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A miniature binding circle, for controlling summoned beings.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEnchantersGlyph : BEJewelry {
	BEEnchantersGlyph() : base() {
		$this.Name               = 'Enchanter''s Glyph'
		$this.MapObjName         = 'enchantersglyph'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 3
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small, glowing glyph, for imbuing items.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEIllusionistsMirrorShard : BEJewelry {
	BEIllusionistsMirrorShard() : base() {
		$this.Name               = 'Illusionist''s Mirror Shard'
		$this.MapObjName         = 'illusionistsmirrorshard'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A fragment of a mirror that reflects illusions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDivinersPendulum : BEJewelry {
	BEDivinersPendulum() : base() {
		$this.Name               = 'Diviner''s Pendulum'
		$this.MapObjName         = 'divinerspendulum'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Luck = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small pendulum that sways to reveal truths.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAbjurersWardingCircle : BEJewelry {
	BEAbjurersWardingCircle() : base() {
		$this.Name               = 'Abjurer''s Warding Circle'
		$this.MapObjName         = 'abjurerswardingcircle'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiny warding circle, for defensive spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEConjurersOrb : BEJewelry {
	BEConjurersOrb() : base() {
		$this.Name               = 'Conjurer''s Orb'
		$this.MapObjName         = 'conjurersorb'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small orb that can manifest minor objects.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETransmutersCatalyst : BEJewelry {
	BETransmutersCatalyst() : base() {
		$this.Name               = 'Transmuter''s Catalyst'
		$this.MapObjName         = 'transmuterscatalyst'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small, heavy catalyst that aids in transformations.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEvokersFocusGem : BEJewelry {
	BEEvokersFocusGem() : base() {
		$this.Name               = 'Evoker''s Focus Gem'
		$this.MapObjName         = 'evokersfocusgem'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A gem that intensifies elemental spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEConjurationBell : BEJewelry {
	BEConjurationBell() : base() {
		$this.Name               = 'Conjuration Bell'
		$this.MapObjName         = 'conjurationbell'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiny bell that rings to summon familiars.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMysticsThirdEye : BEJewelry {
	BEMysticsThirdEye() : base() {
		$this.Name               = 'Mystic''s Third Eye'
		$this.MapObjName         = 'mysticsthirdeye'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Accuracy = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An eye-shaped gem, for enhanced perception.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERunemastersStone : BEJewelry {
	BERunemastersStone() : base() {
		$this.Name               = 'Runemaster''s Stone'
		$this.MapObjName         = 'runemastersstone'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 1
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A stone engraved with powerful runes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEArtificersGoggles : BEJewelry {
	BEArtificersGoggles() : base() {
		$this.Name               = 'Artificer''s Goggles'
		$this.MapObjName         = 'artificersgoggles'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Accuracy = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Tiny goggles with intricate lenses, for mechanical insight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEInventorsBlueprintFragment : BEJewelry {
	BEInventorsBlueprintFragment() : base() {
		$this.Name               = 'Inventor''s Blueprint Fragment'
		$this.MapObjName         = 'inventorsblueprintfragment'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A fragment of an ingenious blueprint.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGolemCoreFragment : BEJewelry {
	BEGolemCoreFragment() : base() {
		$this.Name               = 'Golem Core Fragment'
		$this.MapObjName         = 'golemcorefragment'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A piece of a golem''s core, slightly humming.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAutomatonGear : BEJewelry {
	BEAutomatonGear() : base() {
		$this.Name               = 'Automaton Gear'
		$this.MapObjName         = 'automatongear'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A perfectly crafted gear from an ancient automaton.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEClockworkHeart : BEJewelry {
	BEClockworkHeart() : base() {
		$this.Name               = 'Clockwork Heart'
		$this.MapObjName         = 'clockworkheart'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Speed = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A miniature clockwork heart, ticking softly.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESteamValvePin : BEJewelry {
	BESteamValvePin() : base() {
		$this.Name               = 'Steam Valve Pin'
		$this.MapObjName         = 'steamvalvepin'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pin shaped like a tiny steam valve, for mechanical control.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMagitechBattery : BEJewelry {
	BEMagitechBattery() : base() {
		$this.Name               = 'Magitech Battery'
		$this.MapObjName         = 'magitechbattery'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 3
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small battery that stores both magic and electricity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEArcaniteShard : BEJewelry {
	BEArcaniteShard() : base() {
		$this.Name               = 'Arcanite Shard'
		$this.MapObjName         = 'arcaniteshard'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 4
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shimmering shard of pure arcanite.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEtherealWeaveBracelet : BEJewelry {
	BEEtherealWeaveBracelet() : base() {
		$this.Name               = 'Ethereal Weave Bracelet'
		$this.MapObjName         = 'etherealweavebracelet'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Speed = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bracelet woven from ethereal threads, making the wearer less corporeal.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAstralCompass : BEJewelry {
	BEAstralCompass() : base() {
		$this.Name               = 'Astral Compass'
		$this.MapObjName         = 'astralcompass'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A compass that points to different astral planes.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECosmicWhisperPearl : BEJewelry {
	BECosmicWhisperPearl() : base() {
		$this.Name               = 'Cosmic Whisper Pearl'
		$this.MapObjName         = 'cosmicwhisperpearl'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pearl that seems to hum with the sounds of the cosmos.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDimensionKnot : BEJewelry {
	BEDimensionKnot() : base() {
		$this.Name               = 'Dimension Knot'
		$this.MapObjName         = 'dimensionknot'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tangled knot of dimensional threads.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERealityThread : BEJewelry {
	BERealityThread() : base() {
		$this.Name               = 'Reality Thread'
		$this.MapObjName         = 'realitythread'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A single, unbroken thread of reality.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEQuantumFluxCrystal : BEJewelry {
	BEQuantumFluxCrystal() : base() {
		$this.Name               = 'Quantum Flux Crystal'
		$this.MapObjName         = 'quantumfluxcrystal'
		$this.PurchasePrice      = 2300
		$this.SellPrice          = 1150
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crystal that vibrates with quantum fluctuations.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETemporalAnomalyShard : BEJewelry {
	BETemporalAnomalyShard() : base() {
		$this.Name               = 'Temporal Anomaly Shard'
		$this.MapObjName         = 'temporalanomalyshard'
		$this.PurchasePrice      = 2400
		$this.SellPrice          = 1200
		$this.TargetStats        = @{
			[StatId]::Speed = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shard that seems to slightly distort time around it.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGravitonCoil : BEJewelry {
	BEGravitonCoil() : base() {
		$this.Name               = 'Graviton Coil'
		$this.MapObjName         = 'gravitoncoil'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small coil that subtly alters gravity.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
