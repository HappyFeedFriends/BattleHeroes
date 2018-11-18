"use strict";
var AbilityCostTable = {
	"special_bonus_unique_faceless_void_4": 20,
	"special_bonus_unique_slardar": 12,
	"special_bonus_unique_sniper_3": 12,
	"special_bonus_unique_furion_3": 12,
	"special_bonus_unique_medusa_4": 14,
	"special_bonus_unique_spirit_breaker_1": 10,
	"special_bonus_unique_lifestealer_3": 8,
	"special_bonus_unique_silencer_3": 8,
	"special_bonus_unique_tusk_4": 11,
	"special_bonus_unique_mirana_4": 9,
	"special_bonus_unique_centaur_1": 9,
	"special_bonus_unique_riki_5": 11,
	"special_bonus_unique_wraith_king_4": 9,
	"special_bonus_unique_wisp_4": 8,
	"special_bonus_unique_alchemist_3": 12,
	"alchemist_chemical_rage": 6,
} 

var DATA_PLAYER =
{
	DEVS: {
		"76561198271575954": {
			PREFIX: "[DEV]",
		},
	},
}

var _ = GameUI.CustomUIConfig()._;
var DOTA_TEAM_SPECTATOR = 1;
var PlayerTables = GameUI.CustomUIConfig().PlayerTables;
var RUNES_TOOLTIP = 
{
	0: {
		color: '82CAFF',
		localize: $.Localize('Custom_toast_rune_double_damage'),
	},
	1: {
		color: 'F62817',
		localize: $.Localize('Custom_toast_rune_haste'),
	},
	2: {
		color: 'FFD700',
		localize: $.Localize('Custom_toast_rune_iillusion'),
	},
	3: {
		color: '8B008B',
		localize: $.Localize('Custom_toast_rune_invisibility'),
	},
	4: {
		color:'7FFF00', 
		localize: $.Localize('Custom_toast_rune_regeneration'),
	},
	5:{
		color:'FF7800',
		localize: $.Localize('Custom_toast_rune_bounty'),
	},
};

var MAP_INFO =
{
	RandomOMG: "BattleHeroes_RandomOMG",
	CreateHero: "battleheroes_createhero",
};
function IsRandomOMGMap()
{
	return Game.GetMapInfo().map_display_name == MAP_INFO.RandomOMG
}
  
function IsCreateHeroMap()
{
	return Game.GetMapInfo().map_display_name == MAP_INFO.CreateHero
}

function GetRandomInt( min, max )
{
	return Math.floor( Math.random() * ( max - min + 1 ) ) + min;
}

function FormatComma (value) {
  try {
    return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
  } catch (e) {}
}

function FormatGold (gold) {
  var formatted = FormatComma(gold);
  if (gold.toString().length > 7) {
    return FormatGold(gold.toString().substring(0, gold.toString().length - 5) / 10) + 'M';
  } else if (gold.toString().length > 5) {
    return FormatGold(gold.toString().substring(0, gold.toString().length - 3)) + 'k';
  } else {
    return formatted;
  }
}

function HidePanelClass(panel){
	panel.SetHasClass("hidden",true);
}
function UnHidePanelClass(panel){
	panel.SetHasClass("hidden",false);
}

function HidePanel(panel) {
	panel.style.visibility = "collapse;";
	panel.hittest = false;
	panel.enabled = false;
	panel.hidden_custom = true;
}

function UnHiddenPanel(panel) {
	panel.style.visibility = "visible;";
	panel.hittest = true;
	panel.enabled = true;
	panel.hidden_custom = false;
}

function IsHiddenPanel(panel){
	return panel.hidden_custom
}

function LengthTable(table){
	var k = 0;
	for (i in table)
		k++
	return k
} 

function CountArrayKey(array)
{
	var count = 0;
	for(var i = 0; i < array.length; ++i)
	{
		count++;
	}
	return count
}

function ShowText(panel,description,title)
{
	return function(){
		if (title) 
		{
			$.DispatchEvent("DOTAShowTitleTextTooltip",panel, title, description);
		} 
		else
		{
			$.DispatchEvent("DOTAShowTextTooltip", panel, description);
		}
	}
};

function HideText(title) 
{
	return function (){
		if (title) {
			$.DispatchEvent("DOTAHideTitleTextTooltip");
		} 
		else 
		{
			$.DispatchEvent("DOTAHideTextTooltip");
		}
	}
}

function SetAllAbilityUnabled(abPanel,maxAbilitySlotNo)
{
	for (var i = 1 ;i <= maxAbilitySlotNo; i++) 
	{
		var abButtonId = "AbilityHero_"+ i;
		var abButton = abPanel.GetParent().GetParent().FindChild(abButtonId);
		if (abButton)
		{
			abButton.enabled = false;
		}
	}
}
function GetAbilityCost(abilityName){
	return AbilityCostTable[abilityName] || CustomNetTables.GetTableValue( "GetCostShops", "Cost")[abilityName] || abilityName.match("special_bonus_") && 6 ||  1; 
}
function nearestOrLowerKey(t, key){
	if (!t){ return false}
	var selectedKey
	for (var k in t){
		if (k <= key && (!selectedKey || Math.abs(k - key) < Math.abs(selectedKey - key))){
			selectedKey = k
		}
	}
	return t[selectedKey]
}


function SortTable(a, b) {  
		var value1 = Number.parseInt(a.split("_").pop());
		var value2 = Number.parseInt(b.split("_").pop());	
		 if (value1 > value2){
			return 1;
		 }else if (value1 < value2){
			return -1;
		 }else{
			return 0;
		 }
}

function HideAbilityTooltip ( ability )
{
	return function()
	{
		$.DispatchEvent( "DOTAHideAbilityTooltip", ability );
	}
};

function ShowItemTooltip (itemImage) {
    $.DispatchEvent("DOTAShowAbilityTooltip",itemImage,itemImage.itemname)
}

function HideItemTooltip (itemImage) {
     $.DispatchEvent("DOTAHideAbilityTooltip",itemImage);
}
function ShowAbilityTooltip( ability )
{
	return function()
	{
		$.DispatchEvent( "DOTAShowAbilityTooltip", ability, ability.abilityname );
	}
};

function isArray(obj) {
    return Object.prototype.toString.call(obj) === '[object Array]';
}

function isNonEmptyArrayLike(obj) {
    try {
        return obj.length > 0 && '0' in Object(obj);
    }
    catch(e) {
        return false;
    }
}


function FormatText(text,value){
	switch (text) {
		case "special_bonus_magic_damage_bh_":
		case "special_bonus_magic_resistance_bh_":
			return "+ " + value + "% " + $.Localize("Dota_tooltip_ability_" + text)  
		case "special_bonus_cooldown_reduction_bh_":
			return "- " + value + "% " + $.Localize("Dota_tooltip_ability_" + text)
		default:
			return "+ " + value + " " + $.Localize("Dota_tooltip_ability_" + text);
	}	
}

function GetDotaHud() {
	var rootUI = $.GetContextPanel();
	while (rootUI.id != "Hud" && rootUI.GetParent() != null) {
		rootUI = rootUI.GetParent();
	}
	return rootUI;
}

function SearchValueByTable(value,table){
	for (i in table){
		if (table[i] == value)
			return true
	}
	return false
}

function FindDotaHudElement(id){
  return GetDotaHud().FindChildTraverse(id);
}
function GetPlayerID(){
	return Game.GetLocalPlayerInfo().player_id;
}

function SetPanelEnabled(abPanel)
{
	if (abPanel)
	{
		abPanel.enabled = true;
	}
}
function SetPanelDisabled(abPanel)
{
	if (abPanel)
	{
		abPanel.enabled = false;
	}
}

function value_talent(talentName)
{
	return Number.parseInt(talentName.split("_").pop());
}

function AbilityPointEnough(abilityCost,playerId)
{	
       var playerHeroIndex = Players.GetPlayerHeroEntityIndex(playerId) ;
       if (abilityCost <= Entities.GetAbilityPoints( playerHeroIndex ))
       {
       	  return true;
       }else{
       	  return false;
       }
}

function isInt(n) {
   return n % 1 === 0;
}

function FormattingDutySymbolText(sDescription,talent_name,panel){
  var sDuty = '%';
  var sRes = '';
  var nOpen;
  var nClose;

  var nCursor = 0;
  while(true){
    nOpen = sDescription.indexOf(sDuty, nCursor)  
    if(nOpen == -1){break}                      
    nClose = sDescription.indexOf(sDuty, nOpen+1) 
    if(nClose == -1){break}                     
    
    sRes += sDescription.substr(nCursor, nOpen-nCursor)
    if(nOpen+1 == nClose){
      sRes = sRes + "<font color='#ffffff'>"+ sDuty + "</font>"
    }else{
		var slovo = sDescription.substr(nOpen + 1, nClose-nOpen- 1)
		var t = GetAbilitySpecial(talent_name,slovo)
		t = isInt(t) && t || t.toFixed(2)
		sRes = sRes + "<font color='#f52500'>" + t + "</font>" 
    }
    nCursor = nClose + 1
  }
	sRes = sRes + sDescription.substr(nClose+1) 
  return sRes    
}

function GetAbilitySpecial(name, key,table)
{
	table = CustomNetTables.GetTableValue( "abilityKV", name  + "_KV");
	if (table) {
		var AbilitySpecial = table["AbilitySpecial"]
		if (AbilitySpecial){
			if ( key ) {
				for (var values in AbilitySpecial){
					if (AbilitySpecial[values][key]) 
					{
						return AbilitySpecial[values][key]
					}
				}
			}
		}
	}
	return "NO FOUND: " + key + " "
}

 
function IsDev(id){
	return Game.GetPlayerInfo(id).player_steamid == DATA_PLAYER.DEVS[Game.GetPlayerInfo(id).player_steamid];
}
function PrefixPlayer(id) {
	return DATA_PLAYER.DEVS[(Game.GetPlayerInfo(Number(id)).player_steamid)] && DATA_PLAYER.DEVS[(Game.GetPlayerInfo(Number(id)).player_steamid)].PREFIX && DATA_PLAYER.DEVS[(Game.GetPlayerInfo(Number(id)).player_steamid)].PREFIX || ""
}

// Thank You Ark. Devoloper Angel Arena Black Star (^_^)
function TransformTextureToPath(texture, optPanelImageStyle) {
	if (IsHeroName(texture)) {
		return optPanelImageStyle === 'portrait' ?
			'file://{images}/heroes/selection/' + texture + '.png' :
			optPanelImageStyle === 'icon' ?
				'file://{images}/heroes/icons/' + texture + '.png' :
				'file://{images}/heroes/' + texture + '.png';
	} /*else if (IsBossName(texture)) {
		return bossesMap[texture] || 'file://{images}/custom_game/units/' + texture + '.png';
	}*/ else if (texture.lastIndexOf('npc_') === 0) {
		return optPanelImageStyle === 'portrait' ?
			'file://{images}/custom_game/units/portraits/' + texture + '.png' :
			'file://{images}/custom_game/units/' + texture + '.png';
	} else if (optPanelImageStyle === 'Ability') {
		return 'file://{images}/spellicons/' + texture + '.png'
	} else if (optPanelImageStyle === 'Rune'){
			return 'file://{images}/rune/rune_' + texture + '.png'
	}else if (optPanelImageStyle === 'custom_icon') {
		return 'file://{images}/custom_game/custom_icon/' + texture + '.png' 
	}else {
		return optPanelImageStyle === 'item' ?
			'raw://resource/flash3/images/items/' + texture + '.png' :
			'raw://resource/flash3/images/spellicons/' + texture + '.png';
	}
}
 
function IsHeroName(str) {
	return IsDotaHeroName(str) || IsCustomHeroName(str);
}

function IsBossName(str) {
	return str.lastIndexOf('npc_battle_heroes_boss') === 0;
}

function IsDotaHeroName(str) {
	return str.lastIndexOf('npc_dota_hero_') === 0;
}

function IsCustomHeroName(str) {
	return str.lastIndexOf('npc_bh_hero_') === 0;
}

 
function GetHEXPlayerColor(playerId) {
	var playerColor = Players.GetPlayerColor(playerId).toString(16);;
	return playerColor == null ? '#000000' : ('#' + playerColor.substring(6, 8) + playerColor.substring(4, 6) + playerColor.substring(2, 4) + playerColor.substring(0, 2));
}

function GetHeroName(unit) {
	return Entities.GetUnitName(unit);
}

function SafeGetPlayerHeroEntityIndex(playerId) {
	var clientEnt = Players.GetPlayerHeroEntityIndex(playerId);
	return clientEnt === -1 ? (Number(PlayerTables.GetTableValue('player_hero_indexes', playerId)) || -1) : clientEnt;
}

function GetPlayerHeroName(playerId) {
	if (Players.IsValidPlayerID(playerId)) {
		return GetHeroName(SafeGetPlayerHeroEntityIndex(playerId));
	}
	return '';
}


function SortPanelChildren(panel, sortFunc, compareFunc) {
	var tlc = panel.Children().sort(sortFunc);
	$.Each(tlc, function(child) {
		for (var k in tlc) {
			var child2 = tlc[k];
			if (child !== child2 && compareFunc(child, child2)) {
				panel.MoveChildBefore(child, child2);
				break;
			} 
		}
	});
};

function GetTeamInfo(team) {
	var t = PlayerTables.GetTableValue('teams', team) || {};
	return {
		score: t.score || Game.GetTeamDetails(team).team_score || 0,
	};
}
function dynamicSort(property) {
	var sortOrder = 1;
	if (property[0] === '-') {
		sortOrder = -1;
		property = property.substr(1);
	}
	return function(a, b) {
		var result = (a[property] < b[property]) ? -1 : (a[property] > b[property]) ? 1 : 0;
		return result * sortOrder;
	};
}

function testScoreBoard(){
	{
		var cfg = GameUI.CustomUIConfig().multiteam_top_scoreboard;
		if ( cfg )
		{
			if ( cfg.TeamOverlayXMLFile )
			{
				var teamId = $.GetContextPanel().GetAttributeInt( "team_id", -1 );
				$( "#TeamOverlayXMLFile" ).SetAttributeInt( "team_id", teamId );

				$( "#TeamOverlayXMLFile" ).BLoadLayout( cfg.TeamOverlayXMLFile, false, false );
			}
		}
	}
}

function secondsToMS(seconds, bTwoChars) {
	var sec_num = parseInt(seconds, 10);
	var minutes = Math.floor(sec_num / 60);
	var seconds = Math.floor(sec_num - minutes * 60);

	if (bTwoChars && minutes < 10)
		minutes = '0' + minutes;
	if (seconds < 10)
		seconds = '0' + seconds;
	return minutes + ':' + seconds;
}