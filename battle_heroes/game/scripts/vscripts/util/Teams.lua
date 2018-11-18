Teams = Teams or class({})
Teams.Data = Teams.Data or {
	[DOTA_TEAM_GOODGUYS] = {
		color = {0, 128, 0},
		name = "#DOTA_GoodGuys",
		playerColors = {
			{51, 117, 255},
			{102, 255, 191},
			{191, 0, 191},
			{243, 240, 11},
			{255, 107, 0},
			{130, 129, 178}
		}
	},
	[DOTA_TEAM_BADGUYS] = {
		color = {255, 0, 0},
		name = "#DOTA_BadGuys",
		playerColors = {
			{254, 134, 194},
			{161, 180, 71},
			{101, 217, 247},
			{0, 131, 33},
			{164, 105, 0},
			{204, 139, 85}
		}
	},
}

function Teams:GetColor(team)
	return Teams.Data[team].color
end

function Teams:GetName(team)
	return Teams.Data[team].name
end

function Teams:PlayerColor(team,playerid)
	return Teams.Data[team][playerColors].playerid
end