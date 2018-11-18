LOCKED_USE_ABILITY = 
{
	"midas",
	"ghost",
	"sheepstick",
	"cyclone",
	"doom_bringer_devour",
}

DATA_BOSSES = 
{
	-- Middle
	nian =
	{
		GoldDrop = 30000,
		RespawnTime = 600,
		["STATS"] = 
		{	    --[[Armor  Magic   HP	    XP	   GOLD	  DAMAGE  ATTACK SPEED]]--
			[0] =  { 120,	75,	 180000,    4000,    0,    16000,    400},
			[10] = { 140,	75,	 200000,    4000,    0,    18000,    400},
			[30] = { 160,	75,	 250000,    4000,    0,    20000,    400},
			[50] = { 180,	75,	 250000,    4000,    0,    22000,    400},
			[60] = { 200,	75,	 250000,    4000,    0,    25000,    400},
		},
		["ITEMDROP"] = 
		{
			["item_god_blood"] = 
			{
				chance = 50,
				minimum = 1,
				maximum = 2,
			},
			["item_frozen_soul"] = 
			{
				chance = 50,
				minimum = 1,
				maximum = 2,
			},
			
			["item_fire_soul"] = 
			{
				chance = 40,
				minimum = 1,
				maximum = 2,
			},
			["item_demonic_hearth"] = 
			{
				chance = 90,
				minimum = 1,
				maximum = 2,
			},
		},
	},
	-- Ranged Bosses
	dragon =
	{
		GoldDrop = 15000,
		RespawnTime = 300,
		["STATS"] = 
		{	    --[[Armor  Magic   HP	     XP	     GOLD	 DAMAGE   ATTACK SPEED]]--
			[0] =  { 80,	75,	 125000,    1000,    0,    10000,    400},
			[10] = { 100,	75,	 145000,    1000,    0,    12000,    400},
			[30] = { 120,	75,	 165000,    1000,    0,    15000,    400},
			[50] = { 140,	75,	 185000,    1000,    0,    17000,   400},
			[60] = { 165,	75,	 205000,    1200,    0,    19000,   400},
		},
		["ITEMDROP"] = 
		{
			["item_frozen_soul"] = 
			{
				chance = 50,
				minimum = 1,
				maximum = 2,
			},
			
			["item_fire_soul"] = 
			{
				chance = 70,
				minimum = 1,
				maximum = 2,
			},
			
			["item_demonic_hearth"] = 
			{
				chance = 60,
				minimum = 1,
				maximum = 2,
			},
		},
	},
	-- Melee Bosses
	doom =
	{
		GoldDrop = 15000,
		RespawnTime = 300,
		["STATS"] = 
		{	    --[[Armor  Magic   HP	    XP	  GOLD	 DAMAGE  ATTACK SPEED]]--
			[0] =  { 100,	75,	 145000,   1600,    0,   12000,    500},
			[10] = { 120,	75,	 215000,   2000,    0,   16000,   500},
			[30] = { 140,	75,	 225000,   2500,    0,   19000,   500},
			[50] = { 160,	75,	 235000,   2900,    0,   21000,   500},
			[60] = { 190,	75,	 265000,   3400,    0,   24000,   500},
		},
		["ITEMDROP"] = 
		{
			["item_god_blood"] = 
			{
				chance = 30,
				minimum = 1,
				maximum = 3,
			},
			["item_frozen_soul"] = 
			{
				chance = 40,
				minimum = 1,
				maximum = 2,
			},
			["item_demonic_hearth"] = 
			{
				chance = 40,
				minimum = 1,
				maximum = 2,
			},
		},
	},	
	golem =
	{
		GoldDrop = 15000,
		RespawnTime = 350,
		["STATS"] = 
		{	    --[[Armor  Magic   HP	   XP	  GOLD	  DAMAGE  ATTACK SPEED]]--
			[0] =  { 80,	75,	 145000,   1600,    0,   12000,   500},
			[10] = { 100,	75,	 165000,   2000,    0,   16000,   500},
			[30] = { 100,	75,	 185000,   2700,    0,   19000,   500},
			[50] = { 120,	75,	 215000,   2900,    0,   21000,   500},
			[60] = { 140,	75,	 225000,   3400,    0,   24000,   500},
		},
		["ITEMDROP"] = 
		{
			["item_god_blood"] = 
			{
				chance = 30,
				minimum = 1,
				maximum = 3,
			},
			["item_frozen_soul"] = 
			{
				chance = 50,
				minimum = 1,
				maximum = 2,
			},
			
			["item_fire_soul"] = 
			{
				chance = 70,
				minimum = 1,
				maximum = 2,
			},
			
			["item_demonic_hearth"] = 
			{
				chance = 60,
				minimum = 1,
				maximum = 2,
			},
		},
	},
}
DATA_BOSSES.dragon_1 = DATA_BOSSES.dragon