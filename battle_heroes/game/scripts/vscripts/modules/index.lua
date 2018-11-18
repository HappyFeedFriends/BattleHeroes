local MODULES =
{
	"spawners",
	"dynamic_minimap",
	"shopes",
	"duel",
	"events",
	"bosses",
	"gold",
	"fountain",
	"kills",
	"randomOMG",
	"mutation",
	"HeroSelection",
}

for k,v in pairs(MODULES) do

	ModuleRequire(...,v .. "/" .. v )
end 