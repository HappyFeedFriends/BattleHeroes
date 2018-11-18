
"use strict";
  
var config = {
	"cmHeroesGroup" : "file://{resources}/layout/custom_game/custom_shopes/ability/heroes_group.xml",
	"radiobutton" : "file://{resources}/layout/custom_game/custom_shopes/ability/radiobutton.xml", 
	"heroAbilityList" : "file://{resources}/layout/custom_game/custom_shopes/ability/hero_ability_list.xml", 
};     
var NO_PRICE_SELL = {
	"ember_spirit_activate_fire_remnant":true,
	"shadow_demon_shadow_poison":true,
}
var hideAbility = {
	"shredder_return_chakram_2" : true,
	"necrolyte_heartstopper_aura" : true,
	"monkey_king_jingu_mastery" : true,
	"rubick_spell_steal" : true,
	"legion_commander_moment_of_courage" : true,
	"lina_fiery_soul" : true,
	"nyx_assassin_burrow" : true,
	"shadow_demon_shadow_poison_release" : true,
	"wisp_tether_break" : true,
	"treant_eyes_in_the_forest" : true,
	"alchemist_unstable_concoction_throw" : true,
	"rubick_hidden1": true,
	"morphling_morph": true,
	"troll_warlord_berserkers_rage": true,
	"rubick_hidden2": true,
	"rubick_hidden3": true,
	"rubick_telekinesis_land": true,
	"phoenix_sun_ray_stop" : true,
	"wisp_spirits_in" : true, 
	"tiny_toss_tree" : true,
	"shredder_chakram_2" : true,
	"shredder_return_chakram" : true,
	"kunkka_return" : true,
	"abyssal_underlord_cancel_dark_rift" : true,
	"life_stealer_assimilate_eject" : true,
	"life_stealer_control" : true,
	"life_stealer_consume" : true,
	"life_stealer_assimilate" : true,
	"tusk_walrus_kick" : true,
	"tusk_launch_snowball" : true,
	"doom_bringer_empty1" : true,
	"doom_bringer_empty2" : true,
	"earth_spirit_petrify" : true,
	"lone_druid_true_form_druid" : true,
	"lone_druid_true_form_battle_cry" : true,
	"morphling_morph_replicate" : true,
	"morphling_replicate" : true,
	"morphling_morph_agi" : true,
	"morphling_morph_str" : true,
	"monkey_king_untransform" : true,
	"monkey_king_primal_spring_early" : true,
	"templar_assassin_trap" : true,
	"pangolier_gyroshell_stop" : true,
	"nyx_assassin_unburrow" : true,
	"elder_titan_return_spirit" : true,
	"ogre_magi_unrefined_fireblast" : true,
	"keeper_of_the_light_spirit_form_illuminate" : true,
	"keeper_of_the_light_spirit_form_illuminate_end" : true,
	"phoenix_icarus_dive_stop" : true,
	"phoenix_launch_fire_spirit" : true,
	"phoenix_sun_ray_toggle_move" : true,
	"naga_siren_song_of_the_siren_cancel" : true,
	"spectre_reality" : true,
	"keeper_of_the_light_illuminate_end" : true,
	"bane_nightmare_end" : true,
	"ancient_apparition_ice_blast_release" : true,
	"visage_stone_form_self_cast" : true,
	"zuus_cloud" : true,
	"puck_ethereal_jaunt" : true,
	"invoker_cold_snap" : true,
	"invoker_ghost_walk" : true,
	"invoker_tornado" : true,
	"invoker_emp" : true,
	"invoker_alacrity" : true,
	"invoker_chaos_meteor" : true,
	"invoker_sun_strike" : true,
	"invoker_forge_spirit" : true,
	"invoker_ice_wall" : true,
	"invoker_deafening_blast" : true,
	"techies_focused_detonate" : true,
	"meepo_divided_we_stand" : true,
};
     
var maxAbilitySlotNo = 6;  
var buySpellLocking=false;
var freeToSellAbility=false;
var CurrentHero = ["","","","","","","","","",""]
var previousHeroRadio = null;
//var AllBuyAbility = {}

function SetPanelText( parentPanel, childPanelId, text ) {
	if ( !parentPanel )
	{
		return;
	}

	var childPanel = parentPanel.FindChildInLayoutFile( childPanelId );
	if ( !childPanel )
	{
		return;
	}

	childPanel.text = text;
}
 
function Update_Heroes_Table()
{
	HeroesUpdate( $( "#heroesTableAgi" ),"agility" ); 
	HeroesUpdate( $( "#heroesTableStr" ),"strength" );  
	HeroesUpdate( $("#heroesTableInt"),"intellect" ); 
}

function HeroesUpdate( container,type )
{
	if (!container){
		return false
	}
	var parentPanelId = type + "_heroes"; 
	var parentPanel = container.FindChild( parentPanelId );
	if ( !parentPanel )
	{
		parentPanel = $.CreatePanel( "Panel", container, parentPanelId );   
		parentPanel.BLoadLayout( config.cmHeroesGroup, false, false );       
		parentPanel.SetHasClass( type, true );
	}
	var className = "Title_" + type;
	var groupNamePanel = parentPanel.FindChildInLayoutFile( "GroupName" );
	groupNamePanel.text = $.Localize(type);             
	groupNamePanel.SetHasClass( className, true );                      
	var groupTable = parentPanel.FindChildInLayoutFile( "GroupTable" );
	var groupKV = CustomNetTables.GetTableValue( "heroes", type ); 
	groupTable = $.CreatePanel( "Panel", groupTable, "heroes_group_"+ type );
	groupTable.SetHasClass( "cm_heroes_group", true );
	UpgradeGroup( groupKV, groupTable, type);
}

function UpgradeGroup( groupKV, groupPanel, groupName)
{
	var groupContainerId = "hero_container_" + groupName;
	var groupContainer = groupPanel.FindChild( groupContainerId );
	groupPanel.SetHasClass( "cm_heroes_group_container", true );  
	groupPanel.SetHasClass( "hBlock", true );
	for ( var heroId in groupKV )
	{
		for ( var name in groupKV )
		{
			var heroPanel = groupPanel.FindChild( name );
			if ( !heroPanel )
			{
				heroPanel = $.CreatePanel( "Panel", groupPanel, name );
				heroPanel.BLoadLayout( config.radiobutton, false, false );
				heroPanel.SetHasClass( "cm_heroes_heropanel", true );
			}		
			_cm_Heroes_UpdateHero( groupKV, heroPanel, groupName, heroId, name);
	 	}
	}
}

function _cm_Heroes_UpdateHero( groupKV, heroPanel, groupName, heroId, name)
{
	var rButton = heroPanel.FindChildInLayoutFile( "RadioButton" );
	rButton.group = "Heroes";
	rButton.SetHasClass( "hBlock", true );
	var isEnabled = groupKV[ name ];
	if ( isEnabled == 0 )
	{
		rButton.enabled = false;
	}
	rButton.data = {
		heroName: name,
		heroId: heroId,
		heroGroup: groupName
	};
	var pID = Game.GetLocalPlayerInfo().player_id;    
	rButton.SetPanelEvent( "onselect", PreviewHero( rButton ) );  
	var childImage = heroPanel.FindChildInLayoutFile( "RadioImage" );
	childImage.heroname = name;
}



function HeroAbilityListUpdate(heroName,playerId,isButtonEvent)
{
 
	var container = $("#buyPanel")
	if (container){
		if (isButtonEvent) 
		 {
		  ChangeToBuyPanel(true);
		 }
		var parentPanelId = "_ability_list"
		var parentPanel = container.FindChild( parentPanelId );
		if ( !parentPanel )
		{
			parentPanel = $.CreatePanel( "Panel", container, parentPanelId );   
			parentPanel.BLoadLayout( config.heroAbilityList, false, false );     
			parentPanel.AddClass( "player" );
		}
		var childImage = parentPanel.FindChildInLayoutFile( "HeroImage" );
		var abilityList =  parentPanel.FindChildInLayoutFile( "Abilities" );
		if ( heroName != "" )
		{     
			var a = $("#heronames")
			a.SetHasClass( "HeroesNames", true );
			a.text = $.Localize(heroName) 
			childImage.heroname = heroName; 
			var slotNumber = Object.keys(CustomNetTables.GetTableValue( "abilities", heroName )).length;
			if (!abilityList.maxslot || abilityList.maxslot < slotNumber )
			{
			   abilityList.maxslot = slotNumber;
			}
			for ( var slot = 1; slot <= abilityList.maxslot; slot++ )                     
			{
			 InvisibleAbilityList(abilityList,slot);
			}
			for ( var slot = 1; slot <= slotNumber; slot++ )                               
			{
				var abi = CustomNetTables.GetTableValue( "abilities", heroName )[ slot ];
				if (!hideAbility[abi])
				{
					UpdateAbility( abilityList, heroName, slot ,playerId);
				}
			}
		}
	}
}

function InvisibleAbilityList(abilityList,slot)
{
     var abButtonId = "AbilityHero_"+ slot;
     var abButton = abilityList.FindChild( abButtonId );
     if ( abButton )
	 {
		abButton.SetHasClass( "hidden", true );
	 }
}

function UpdateAbility(abilityList,heroName,slot,playerId)
{
	var abButtonId = "AbilityHero_"+ slot;
	var abButton = abilityList.FindChild( abButtonId );
	if ( !abButton )
	{
		abButton = $.CreatePanel( "Button", abilityList, abButtonId );
	}
	var abPanelId = "_ability_image_"+ slot;
	var abPanel = abButton.FindChild( abPanelId );
	var abCostLabelId = "_ability_cost_"+ slot;
	var abCostLabel = abButton.FindChild( abCostLabelId );
	var abilityName = CustomNetTables.GetTableValue( "abilities", heroName )[ slot ]; 
	abButton.SetHasClass( "hidden", false );
	if ( !abPanel)
	{
			abPanel = $.CreatePanel( "DOTAAbilityImage", abButton, abPanelId );
			abPanel.SetHasClass( "FullBlock", true );
			abButton.SetHasClass( "hidden", false );
			abPanel.data = {
				abilityName: abPanel.abilityname,
				heroName: heroName,
				position: slot,
				playerId: playerId,
				abilityCost: GetAbilityCost(abilityName),
				enough: true,
			}
			abCostLabel = $.CreatePanel( "Label", abButton, abCostLabelId );
			ResetPanelData(abPanel,abCostLabel,abilityName,heroName,playerId);
			abButton.SetPanelEvent( "onmouseover", ShowAbilityTooltip( abPanel ) );
			abButton.SetPanelEvent( "onmouseout", HideAbilityTooltip( abPanel ) );
			abButton.SetPanelEvent( "onactivate", AddAbility( abPanel ) );
	}else{
		ResetPanelData(abPanel,abCostLabel,abilityName,heroName,playerId);
	}
}

function ResetPanelData(abPanel,abCostLabel,abilityName,heroName,playerId)
{
	abPanel.abilityname = abilityName; 
	abPanel.data.abilityName = abilityName; 
	abPanel.data.heroName = heroName;
	var abilityCost = GetAbilityCost(abilityName);
	abCostLabel.text = abilityCost;
	abPanel.data.abilityCost = abilityCost;
	if (!AbilityPointEnough(abilityCost,playerId) /*|| AllBuyAbility[abilityName]*/)    
	{
		abPanel.data.enough = false;
		abPanel.SetHasClass( "notEnoughDark", true );
	} 
	else  
	{
		abPanel.data.enough = true;
		abPanel.SetHasClass( "notEnoughDark", false );
	}
	CheckAbilityButtonAvailable(abPanel.GetParent(),abilityName,playerId)
}

function GetPlayerAbilityNumber(playerId)
{
	var abilityNumber = 0;
	var playerHeroIndex=Players.GetPlayerHeroEntityIndex(playerId) ;
    for (var i = 0 ; i <= 23; i++) 
    {
       var abilityName = Abilities.GetAbilityName(Entities.GetAbility(playerHeroIndex,i));
       if(abilityName != "" && !hideAbility[abilityName] && abilityName.substring(0,14) != "special_bonus_" && abilityName.substring(0,6) != "empty_")
        {
           abilityNumber = abilityNumber + 1;
        }
    }  
    return abilityNumber;
}

function ChangeToBuyPanel(isButtonEvent)
{
    var buyPanel= $("#buyPanel")
    buyPanel.SetHasClass( "hidden", false);
    if (isButtonEvent) 
    {
       Game.EmitSound("ui.switchview");
    }
}


var PreviewHero = ( function( rButton )
{
	return function()
	{
		var heroInfo = rButton.data; 
        var playerId = Game.GetLocalPlayerInfo().player_id;
		//Update_Heroes_Table();
		HeroAbilityListUpdate( heroInfo.heroName,playerId,true);
		CurrentHero[playerId] = heroInfo.heroName;
		if (previousHeroRadio != null)
		{
		    previousHeroRadio.checked = false; 
		}
		previousHeroRadio = rButton;       
	}
});

function AddAbility(abPanel )
{
	return function()
	{
		if (abPanel.data.enough)
		{
			abPanel.GetParent().enabled = false;         
			//SetAllAbilityUnabled(abPanel,maxAbilitySlotNo);
			buySpellLocking = true;
		}
		GameEvents.SendCustomGameEventToServer( "AddAbilityShop", abPanel.data );
	}
};

function UpdateAbilityList(keys)
{
	var isButtonEvent = true;
	buySpellLocking = false;
	keys.heroName = CurrentHero[keys.playerId];
	if (keys.heroName == false)
	{
		keys.heroName = CurrentHero[keys.playerId];  
		isButtonEvent = false;
	}
	if (keys.maxSlotNumber != null && keys.maxSlotNumber > maxAbilitySlotNo)
	{   
		maxAbilitySlotNo = keys.maxSlotNumber;
	}
	if (GetPlayerAbilityNumber(keys.playerId) <= maxAbilitySlotNo) 
	{			
		SetAllAbilityEnabled();
	}
	HeroAbilityListUpdate(keys.heroName,keys.playerId,isButtonEvent);
	//AllBuyAbility[keys.abilityName] = true;
}

function heroLevelup()
{
	var id = Game.GetLocalPlayerInfo().player_id;
	var keys = 
	{
		heroName: CurrentHero[id],
		playerId: Game.GetLocalPlayerInfo().player_id,
	}
	UpdateAbilityList(keys)
}

function HideMainBlock()
{
	var mainBlock = $("#mainShop");
	if (mainBlock)
	{
		mainBlock.invisible = true;
		mainBlock.SetHasClass("hidden", true);
	}
	var shop = $("#SellShop");
	if (shop)
	{
		mainBlock.invisible = true;
		mainBlock.SetHasClass("hidden", true);
	}
}

function SetAllAbilityEnabled()
{
	for (var i = 1 ;i <= maxAbilitySlotNo; i++) 
	{
		var abButtonId = "#AbilityHero_"+ i;
		var abButton = $(abButtonId)
		if (abButton)
		{
			abButton.enabled = true;
		}
	}
}


function CheckAbilityButtonAvailable (Button,abilityName,playerId)
{
	var playerHeroIndex = Players.GetPlayerHeroEntityIndex(playerId);
	var abilityIndex = Entities.GetAbilityByName(playerHeroIndex, abilityName );	    
	if (!buySpellLocking) 
	{
		if (abilityIndex == -1){
			Button.enabled = true; 
		}
		else{
			Button.enabled = false;  					 
		}
		if (GetPlayerAbilityNumber(playerId) >= maxAbilitySlotNo){
			Button.enabled = false; 
		}
	}
}
function ButtonHidden(button,Shop){
	if (!button.neactivate){
		button.neactivate = true; 
		button.SetHasClass("hidden", true);
		if (Shop && !Shop.activation){
			Shop.activation = true; 
			Shop.SetHasClass("hidden", false);
		}
	}else{
		button.neactivate = false;
		button.SetHasClass("hidden", false);
		if (Shop && Shop.activation){
			Shop.activation = false;
			Shop.SetHasClass("hidden", true);
		}
	}
}
function SwapLocalizeText(Wrapper,button){
	if (!Wrapper.swap){
		Wrapper.swap = true;
		Wrapper.text = $.Localize("#buy_ability");
		button.text = $.Localize("#ButtonBuy");
	}else{
		Wrapper.swap = false;
		Wrapper.text = $.Localize("#spell_shop");
		button.text = $.Localize("#ButtonSell");
	}
}
function ShowSellMain()
{
	var left = $("#spellShopLeft");
	var mid = $("#spellShopMiddle");
	var right = $("#spellShopRight");
	var Wrapper = $("#cmWrapperText");
	var button = $("#Sellbutton");
	var Shop = $("#SellShop");
	if (GetPlayerAbilityNumber(Game.GetLocalPlayerInfo().player_id) > 0 || Shop.activation){
		ButtonHidden(left);
		ButtonHidden(mid);
		ButtonHidden(right,Shop);
		SwapLocalizeText(Wrapper,button);
	}
	if (Shop.activation)
	SellShopMain(Shop);
}

function GetAbilityNameHero(PlayerId,i){
	var hero = Players.GetPlayerHeroEntityIndex(PlayerId);
	return  Abilities.GetAbilityName(Entities.GetAbility(hero,i));
}
function SellShopMain(Shop)
{	
	if (Shop){
		if (!Shop.activation) return;
		var Ability,AbilityID,AbilityButton,ButtonID,AbilityCostLabel,AbilityName;
		var pID = Game.GetLocalPlayerInfo().player_id; 
		var Shops = Shop.FindChild( "Shops" );
		var playerHeroIndex = Players.GetPlayerHeroEntityIndex(pID);
		if (!Shops){
			Shops = $.CreatePanel( "Button", Shop, "Shops" );
			Shops.SetHasClass("Shops", true);
		}
		for ( var i = 0; i <= GetPlayerAbilityNumber(pID) - 1; i++) {
			AbilityID = "Ability_"+ i;
			ButtonID = "Button_"+ i;
			AbilityButton = Shops.FindChild( ButtonID );
			AbilityName = GetAbilityNameHero(pID,i);
			$.Msg(AbilityName)
			if (!AbilityName.match("empty_slot")){
				if (!AbilityButton) 
					AbilityButton = $.CreatePanel( "Button", Shops, ButtonID );
				AbilityCostLabel = AbilityButton.FindChild( AbilityID + "_cost");
				Ability = AbilityButton.FindChild( AbilityID );
				if (!Ability){
					Ability = $.CreatePanel( "DOTAAbilityImage", AbilityButton, AbilityID ); 
					Ability.SetHasClass("FullBlock", true); 
					AbilityButton.SetPanelEvent( "onmouseover", ShowAbilityTooltip( Ability ) );  
					AbilityButton.SetPanelEvent( "onmouseout", HideAbilityTooltip( Ability ) );
					Ability.data = {
						AbilityName: AbilityName,
						playerId: pID,
						abilityCost: NO_PRICE_SELL[AbilityName] && "0" ||  (GetAbilityCost(AbilityName) + (Abilities.GetLevel(Entities.GetAbility(playerHeroIndex,i)) - 1)),
					}
					AbilityButton.SetPanelEvent( "onactivate", SellAbility( Ability ) );
				}
				if (!AbilityCostLabel) 
					AbilityCostLabel = $.CreatePanel( "Label", AbilityButton, AbilityID + "_cost" );
				RefreshSellingAbility(Ability,AbilityCostLabel,pID,AbilityName,i);
			}
		}
	}
}

function RefreshSellingAbility(Ability,AbilityCostLabel,pID,AbilityName,i){
	Ability.GetParent().SetHasClass("hidden", false);
	var playerHeroIndex = Players.GetPlayerHeroEntityIndex(pID);
	var cost = NO_PRICE_SELL[AbilityName] && "0" ||  (GetAbilityCost(AbilityName) + (Abilities.GetLevel(Entities.GetAbility(playerHeroIndex,i)) - 1));
	Ability.abilityname = AbilityName;
	AbilityCostLabel.text = cost;
	Ability.data = {
		AbilityName: AbilityName,
		position: i,
		playerId: pID,
		abilityCost: cost,
	}
}
function SellAbility(Panel)
{
	return function()
	{
		Panel.GetParent().SetHasClass("hidden", true);
		GameEvents.SendCustomGameEventToServer( "SellingAbility", Panel.data );
	}
}
function UpdateCheck(keys){
	SellShopMain($("#SellShop"));
}
(function() 
{
	if (IsCreateHeroMap()) {
		Update_Heroes_Table();
		GameEvents.Subscribe( "UpdateAbilityList", UpdateAbilityList );
		GameEvents.Subscribe("dota_player_gained_level", heroLevelup );
		GameEvents.Subscribe("dota_player_learned_ability", UpdateCheck );
	}
	HideMainBlock();
})();