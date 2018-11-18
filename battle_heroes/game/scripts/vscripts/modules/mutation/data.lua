MUTATION_LIST = {
	"BONUS_GOLD_CREEP", -- ++
	"UPGRADE_RUNE", -- ++
	"ABILITY_PURE_DAMAGE",  --++
	--"BOSSES_KILL_ONE_HERO",
	"RESPAWN_HERO", -- ++
	"MAX_SPEED", -- +
	"SUNSTRIKES", -- +
	--"COURIER_ALL",
	--"UPGRADE_CREEP",
	"HEALING_KILL",  -- ++
	"KILLED_BONUS_STATS", -- ++
}

MUTATION_SETTINGS = {
	MAX_MUTATION = RandomInt(3,3),
	["BONUS_GOLD_CREEP"] = {
		text = "custom_mutation_gold_creep",
		gold = 7,
	},
	["UPGRADE_RUNE"] = {
		text = "custom_mutation_upgrade_rune",
		text_description = {
			["{upgrade_rune_healing}"] = "Custom_toast_rune_regeneration",
			["{upgrade_rune_haste}"] = "Custom_toast_rune_haste",
			["{upgrade_rune_double_damage}"] = "Custom_toast_rune_double_damage",
			["{upgrade_rune_invisibility}"] = "Custom_toast_rune_invisibility",
		},
		BONUS_EFFECTS = {
			[1] = {"modifier_rune_invis",20},
			[2] = {"modifier_rune_haste",15},
			[3] = {"modifier_rune_regen",19},
			[4] = {"modifier_rune_doubledamage",32},
		},
	},
	["ABILITY_PURE_DAMAGE"] = {
		text = "custom_mutation_ability_pure_damage",
		damage = 25,
	},
	["BOSSES_KILL_ONE_HERO"] = {
		text = "custom_mutation_kill_heroes",
		heroes = 1,
		time = 30,
	},
	["RESPAWN_HERO"] = {
		text = "custom_mutation_respawn_hero",
		time = 100,
	},	
	["MAX_SPEED"] = {
		text = "custom_mutation_max_movespeed",
		speed = 900,
	},	
	["SUNSTRIKES"] = {
		text = "custom_mutation_sunstrikes",
		damage = 250,
		time = 15,
		time_active = 5,
		delay = 5,
		radius = 200,
		negative = true,
	},	
	["COURIER_ALL"] = {
		text = "custom_mutation_courier_all",
	},	
	["UPGRADE_CREEP"] = {
		text = "custom_mutation_upgrade_creep",
		power = 2.5,
		
	},	
	["HEALING_KILL"] = {
		text = "custom_mutation_healing_kill",
		heal = 15,
		
	},		
	["KILLED_BONUS_STATS"] = {
		text = "custom_mutation_killed_hero_add_stats",
		bonus_stats = 2,
		reduction_stats = 2,
		
	},	
	["KILLED_BONUS_STREAK_EFFECTS"] = {
		text = "custom_mutation_killed_hero_add_stats",
		bonus_stats = 2,
		reduction_stats = 2,
		
	},	
}