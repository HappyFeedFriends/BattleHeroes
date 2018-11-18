	--[[
	tusk =
	{
		GoldDrop = 14000,
		RespawnTime = 300,
		["STATS"] = 
		{	    --[[Armor  Magic   HP	   XP	  GOLD	  DAMAGE  ATTACK SPEED]]--
			[0] =  { 80,	75,	 145000,   1600,    20000,   12000,   500},
			[10] = { 100,	75,	 165000,   2000,    23000,   16000,   500},
			[30] = { 100,	75,	 185000,   2700,    26000,   19000,   500},
			[50] = { 120,	75,	 215000,   2900,    29000,   21000,   500},
			[60] = { 140,	75,	 225000,   3400,    34000,   24000,   500},
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
					chance = 50,
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
	treant =
	{
		GoldDrop = 14000,
		RespawnTime = 250,
		["STATS"] = 
		{	    --[[Armor  Magic   HP	   XP	  GOLD[OFF]	  DAMAGE  ATTACK SPEED]]--
			[0] =  { 80,	75,	 145000,   1600,    20000,   12000,   500},
			[10] = { 100,	75,	 165000,   2000,    23000,   16000,   500},
			[30] = { 100,	75,	 185000,   2700,    26000,   19000,   500},
			[50] = { 120,	75,	 215000,   2900,    29000,   21000,   500},
			[60] = { 140,	75,	 225000,   3400,    34000,   24000,   500},
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
	druid =
	{
		GoldDrop = 11000,
		RespawnTime = 250,
		["STATS"] = 
		{	    --[[Armor  Magic   HP	   XP	  GOLD	  DAMAGE  ATTACK SPEED]]--
			[0] =  { 50,	75,	 180000,    1000,    4500,     6000,    400},
			[10] = { 50,	75,	 199000,    1000,    7500,     8000,    400},
			[30] = { 65,	75,	 205000,    1000,    12000,    9000,    400},
			[50] = { 75,	75,	 218000,    1000,    16000,    10000,   400},
			[60] = { 100,	75,	 275000,   	1200,    19000,    12000,   400},
		},
		["ITEMDROP"] = 
		{
			["item_god_blood"] = 
			{
					chance = 60,
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
	]]