CREEP_UPGRADE_FUNCTIONS = {
			   --[[ Gold       hp        damage      attackspeed movespeed   armor       xpbounty         PER MINUTES]]--
	easy = {
		[0]     = { 15,          20,         1,          1,          0.8,        0.1,	    23          }, 
		[5]     = { 15,          20,         1,          1,          1,          0.2,        26          },
		[10]    = { 20,          25,         2,          2,          1.0,        0.5,        36          },
		[15]    = { 25,          25,         3,          2,          1.0,        0.5,        45          },
		[20]    = { 30,          30,         4,          0.4,        1.3,        0.5,        55          },
		[30]    = { 35,          45,         6,          0.45,       0.45,       0.5,        95          },
		[40]    = { 44,          60,         10,         0.6,        0.5,        0.5,        155         },
		[60]    = { 55,          80.5,       15,         0.5,        0.5,        0.5,        305         },
	},
	medium = {
		[0]     = { 21,          25,         2,          0,          2.5,          0,        9           },
		[5]     = { 24,          30,         2,          0,          2.5,          0,        12          },
		[10]    = { 28,          50,         3,          0.2,        2,          0.2,        14          },
		[15]    = { 34,          60,         4,          0.3,        2,          0.2,        20          },
		[20]    = { 39,          70,         5,          0.3,        2,          0.2,        35          },
		[30]    = { 44,          90,         7,          0.4,        2,          0.3,        75          },
		[40]    = { 55,          120,        10,         0.4,        2,          0.4,        135         },
		[60]    = { 68,          200,        20,         0.5,        2,          0.4,        255         },
	},
	hard = {
		[0]     = { 35,          55,         2.3,        0,          2,          0.1,        5           },
		[10]    = { 37,          70,         6,          0.5,        2,          0.1,        10          },
		[15]    = { 41,          90,         7,          0.5,        2,          0.1,        20          },
		[20]    = { 48,          120,        8,          0.6,        2,          0.2,        35          },
		[30]    = { 55,          180,        11,         0.7,        2,          0.3,        75          },
		[40]    = { 62,          230,        16,         0.7,        2,          0.4,        125         },
		[60]    = { 76,          400,        25,         0.8,        2,          0.4,        200         },
	},
}

SPAWNER_SETTINGS = {
	Cooldown = 60,
	easy = {
		SpawnedPerSpawn = 5,
		MaxUnits = 50,
		SpawnTypes = {
			[0] ={
				{
					[-1] = "npc_dota_neutral_easy_melee",
					[0] = "models/creeps/neutral_creeps/n_creep_troll_skeleton/n_creep_skeleton_melee.vmdl",
					[15] = "models/creeps/neutral_creeps/n_creep_worg_large/n_creep_worg_large.vmdl",
					[30] = "models/creeps/item_creeps/i_creep_necro_warrior/necro_warrior.vmdl",
					[60] = "models/creeps/neutral_creeps/n_creep_eimermole/n_creep_eimermole.vmdl",
				}
			},
		},
	},
	medium = {
		SpawnedPerSpawn = 5,
		MaxUnits = 50,
		SpawnTypes = {
			[0] ={
				{
					[-1] = "npc_dota_neutral_medium_melee",
					[0] = "models/creeps/neutral_creeps/n_creep_beast/n_creep_beast.vmdl",
					[30] = "models/creeps/neutral_creeps/n_creep_centaur_med/n_creep_centaur_med.vmdl",
					[60] = "models/creeps/neutral_creeps/n_creep_golem_b/n_creep_golem_b.vmdl",
				}
			},
			[1] ={
				{
					[-1] = "npc_dota_neutral_medium_melee_2",
					[0] = "models/heroes/lycan/lycan_wolf.vmdl",
					[20] = "models/items/beastmaster/boar/fotw_wolf/fotw_wolf.vmdl",
					[30] = "models/items/lycan/wolves/blood_moon_hunter_wolves/blood_moon_hunter_wolves.vmdl",
					[40] = "models/items/lycan/wolves/hunter_kings_wolves/hunter_kings_wolves.vmdl",
					[50] = "models/items/lycan/ultimate/blood_moon_hunter_shapeshift_form/blood_moon_hunter_shapeshift_form.vmdl",
					[60] = "models/items/lycan/ultimate/hunter_kings_trueform/hunter_kings_trueform.vmdl",
				}
			},
		},
	},
	hard = {
		SpawnedPerSpawn = 5,
		MaxUnits = 50,
		SpawnTypes = {
			[0] ={
				{
					[-1] = "npc_dota_neutrals_hard_ranged",
					[0] = "models/heroes/dragon_knight/dragon_knight_dragon.vmdl",
					[10] = "models/creeps/neutral_creeps/n_creep_black_dragon/n_creep_black_dragon.vmdl",
					[20] = "models/items/dragon_knight/ti8_dk_third_awakening_dragon/ti8_dk_third_awakening_dragon.vmdl",
					[40] = "models/items/dragon_knight/legacy_of_the_winterwyrm_form_of_the_winterwyrm/legacy_of_the_winterwyrm_form_of_the_winterwyrm.vmdl",
					[50] = "models/items/dragon_knight/aurora_warrior_set_dragon_style2_aurora_warrior_set/aurora_warrior_set_dragon_style2_aurora_warrior_set.vmdl",
				}
			},
			[1] ={
				{
					[-1] = "npc_dota_neutrals_hard_melee",
					[0] = "models/creeps/neutral_creeps/n_creep_centaur_med/n_creep_centaur_med.vmdl",
					[30] = "models/creeps/neutral_creeps/n_creep_centaur_lrg/n_creep_centaur_lrg.vmdl",
					[60] = "models/heroes/centaur/centaur.vmdl",
				}
			},
			[2] ={
				{
					[-1] = "npc_dota_neutrals_hard_melee_big",
					[0] = "models/courier/baby_rosh/babyroshan.vmdl",
					[30] = "models/items/warlock/golem/doom_of_ithogoaki/doom_of_ithogoaki.vmdl",
				}
			},
		},
	},
}
ITEM_LOOT_SETTINGS =
{
	[0] = {
		easy = 
		{
			["chance"] = 9,
		},
		medium = 
		{
			["chance"] = 6,
		},		
		infinite = 
		{
			["chance"] = 6,
		},	
		hard = 
		{
			["chance"] = 8,
		},
		DROP_ITEMS = 
		{
			"item_slippers",
			"item_gauntlets",
			"item_stout_shield",
			"item_ring_of_protection",
			"item_wind_lace",
			"item_infused_raindrop",
			"item_faerie_fire",
			"item_quelling_blade",
		},
	},	
	[20] = {
		easy = {
			["chance"] = 9,
		},
		medium = {
			["chance"] = 6,
		},		
		infinite = {
			["chance"] = 6,
		},		
		hard = {
			["chance"] = 8,
		},
		DROP_ITEMS = 
		{
			"item_javelin",
			"item_helm_of_iron_will",
			"item_mithril_hammer",
			"item_platemail",
			"item_quarterstaff",
			"item_claymore",
			"item_broadsword",
			"item_blades_of_attack",
			"item_bracer",
		},
	},	
	[30] = {
		easy = {
			["chance"] = 4,
		},
		medium = {
			["chance"] = 4,
		},			
		infinite = {
			["chance"] = 4,
		},		
		hard = {
			["chance"] = 3,
		},
		DROP_ITEMS = 
		{
			"item_mekansm",
			"item_vladmir",
			"item_buckler",
			"item_pipe",
			"item_urn_of_shadows",
		},
	},
}

SPAWNER_SETTINGS.infinite = SPAWNER_SETTINGS.medium
CREEP_UPGRADE_FUNCTIONS.infinite = CREEP_UPGRADE_FUNCTIONS.medium