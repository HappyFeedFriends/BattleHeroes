MAP_INFO = {
	["CreateHero"] = {
		map = "battleheroes_createhero",
	},	
	["RandomOMG"] = {
		map = "battleheroes_randomomg",
	},
}

if not GLOBAL_DUMMY then
	GLOBAL_DUMMY = CreateUnitByName("npc_dummy_unit", Vector(0, 0, 0), false, nil, nil, DOTA_TEAM_NEUTRALS)
end