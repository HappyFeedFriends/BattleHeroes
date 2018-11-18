var TalentConfing = {
	"talentgroup" : "file://{resources}/layout/custom_game/custom_shopes/talent/talent_group.xml",
};

var ARRPANEL = {}
var playerModifiers = ["","","","","","","","","","","","","","","","","","","","","","","","",""];
//var data = CustomNetTables.GetTableValue( "talents", "data")
//var MAXTALENTS = data["MAXTALENTS"] 

function Update_Talent_Tables()   
{     
	/*CreateContainerTalents( $( "#talent_hp" ),"hp","special_bonus_hp_bh_" );    
	CreateContainerTalents( $( "#talent_mp" ),"mp","special_bonus_mp_bh_" ); 
	CreateContainerTalents( $( "#talent_agility" ),"agility","special_bonus_agility_bh_" ); 
	CreateContainerTalents( $( "#talent_strength" ),"strength","special_bonus_strength_bh_" ); 
	CreateContainerTalents( $( "#talent_intellect" ),"intellect","special_bonus_intellect_bh_" ); 
	CreateContainerTalents( $( "#talent_all" ),"all","special_bonus_all_stats_bh_" );  
	CreateContainerTalents( $( "#talent_attack_speed" ),"attack_speed","special_bonus_attack_speed_bh_" ); 
	CreateContainerTalents( $( "#talent_damage" ),"damage","special_bonus_attack_damage_bh_" );  
	CreateContainerTalents( $( "#talent_magic_resistance" ),"magic_resistance","special_bonus_magic_resistance_bh_" ); 
	CreateContainerTalents( $( "#talent_armor" ),"armor","special_bonus_armor_bh_" );  
	CreateContainerTalents( $( "#talent_cooldown_reduction" ),"cooldown_reduction","special_bonus_cooldown_reduction_bh_" ); 
	CreateContainerTalents( $( "#talent_magic_damage" ),"magic_damage","special_bonus_magic_damage_bh_" ); 
	CreateContainerTalents( $( "#talent_gold_bonus" ),"gold_bonus","special_bonus_gold_bonus_bh_" ); 
	CreateContainerTalents( $( "#talent_xp_bonus" ),"xp_bonus","special_bonus_xp_bonus_bh_" );  */
	CreateContainerTalents( $( "#talent_heroes" ),"talents","talent_hero" );  
	HeroLevelUpTalent();
	/*button = $("#num_page");
	if (GetPage())
	{
		button.text = GetPage() + " / " + NumberPages();
	};	*/
}
  
function ShowTalentShop()   
{
	var button = $( "#TalentShops" );  
	if (button){
		var block = button.GetParent().GetParent().GetParent().FindChild("TalentShop").FindChild("TalentMainShop");
		if (block.invisible == null || block.invisible == true)
		{
			block.invisible = false;
			block.SetHasClass("hidden", false);
			Game.EmitSound("Shop.PanelUp");		 
		}
		else
		{
			block.invisible = true;
			block.SetHasClass("hidden", true);
			Game.EmitSound("Shop.PanelDown");
		}
		Game.EmitSound("Shop.PanelUp");
	 }
} 

function CreateContainerTalents( container,stat,special_bonus )      
{
	if (special_bonus == "talent_hero")
	{
		var a;
		for (var name in CustomNetTables.GetTableValue( "heroes", "FullHeroes")){
			if (!name.match("invoker")){
			var primary = CustomNetTables.GetTableValue( "heroes", "FullHeroes")[name]
			if (primary == "DOTA_ATTRIBUTE_INTELLECT"){
				a = $("#int_hero"); 
			}else if(primary == "DOTA_ATTRIBUTE_AGILITY"){
				a = $("#agi_hero");
			}else{
				a = $("#str_hero");
			}
			CreateTalentHero(a,name)
		}}
	}
	else if (container && special_bonus ){ 
		var parentPanelId = "talent_" + stat + "_id"; 
		var groupPanel = container.FindChild( stat );
		if ( !groupPanel )
		{ 
			groupPanel = $.CreatePanel( "Panel", container, stat );
			groupPanel.BLoadLayout( TalentConfing.talentgroup, false, false );
			groupPanel.SetHasClass( "talents_group", true ); 
			groupPanel.SetHasClass( "talents_group_container", true );
			groupPanel.SetHasClass( "FullBlock", true );
			
		}
		var points = $("#ability_points"); 
		var playerHeroIndex = Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerInfo().player_id)
		points.text = $.Localize("empty_points: ") + Entities.GetAbilityPoints( playerHeroIndex )
		TalentUpgradeGroup( special_bonus, groupPanel, parentPanelId,stat);
	}
}

function TalentUpgradeGroup( name, groupPanel, groupName,stat)
{
		var Panel = groupPanel.FindChild( name );
		if ( !Panel ) 
		{
			var fullAbility = name    
			for (i = 1; i <= data[stat]["MAX_SLOTS"]; i++){
				var names = FormatText(fullAbility,(i * data[stat]["BONUS_PER_BUTTON"]))
				var talent_name = name + (i * data[stat]["BONUS_PER_BUTTON"])
				Panel = $.CreatePanel( "Panel", groupPanel, talent_name );
				var cost = $.CreatePanel( "Label", Panel, talent_name + "_cost" );
				var text_label = $.CreatePanel( "Label", Panel, talent_name + "_text" );
				Panel.SetHasClass( "talent_class", true );
				cost.SetHasClass( "talent_class_cost", true );
				cost.text = data[stat]["PRICE_PER_BUTTON"] * i; 
				text_label.SetHasClass( "talent_class_text", true );
				text_label.text = names;
				var value = data[stat]["BONUS_PER_BUTTON"] * i
				var price = data[stat]["PRICE_PER_BUTTON"] * i
				UpdateTalentList(talent_name,Game.GetLocalPlayerInfo().player_id,price,Panel,value,fullAbility)
			}
		}		
}

function GetPlayerTalentNumber(playerId)
{
	return playerModifiers[playerId] && playerModifiers[playerId] || 0;
}

function SetAllPanelDisable()
{
	for (var i in ARRPANEL){
		if (i.match("special_bonus_"))
		{ 
			SetPanelDisabled(ARRPANEL[i])
		}
	}
}

function UpdateTalentTable(keys)
{
	if (keys.TalentBuy == 1)
	{
		if (playerModifiers[keys.playerId]) {
			playerModifiers[keys.playerId] = playerModifiers[keys.playerId] + 1
		}
		else if (!playerModifiers[keys.playerId]) {
			playerModifiers[keys.playerId] = 1
		}
		var panel = ARRPANEL[keys.ability + keys.value]
		if (GetPlayerTalentNumber(keys.playerId) >= MAXTALENTS) 
		{	
			SetAllPanelDisable();
		}
	}
	HeroLevelUpTalent();
}
 
function ResetPanelDataTalent(abPanel,cost,abilityName,playerId)
{
	if (!AbilityPointEnough(cost,playerId))    
	{
		abPanel.data.enough = false;
		SetPanelDisabled(abPanel); 
	}
	else
	{ 
		abPanel.data.enough = true;
		SetPanelEnabled(abPanel);
	}
}

function UpdateTalentList(TalentName,playerId,cost,panel,value,ability)
{
	if ( panel)  
	{
		panel.data = {
			playerId: playerId,
			abilityCost: cost,
			enough: true,
			value: value,
			ability: ability,
		}
		if (!ARRPANEL[TalentName]){ 
				ARRPANEL[TalentName] = panel
		}
		ResetPanelDataTalent(panel,cost,TalentName,playerId);
		panel.SetPanelEvent( "onactivate", AddTalent( panel ) );    
	}
} 
function AddTalent( Panel )
{
	return function()
	{
		if (Panel.data.enough)
		{
			Panel.enabled = false;         
			buySpellLocking = true;
			ARRPANEL[ Panel.data.ability + Panel.data.value ].enabled = false
		}
		GameEvents.SendCustomGameEventToServer( "AddTalentShop", Panel.data );
	}
};
 

function HideMainBlockTalent()
{
	var button = $( "#TalentMainShop" ); 
	if (button){
		button.invisible = true;
		button.SetHasClass("hidden", true);
	}
}

function HideAbilityShop()
{
	var button = $( "#TalentShops" );  
	if (button){
		var block = button.GetParent().GetParent().GetParent().FindChild("spellShop").FindChild("mainShop");
		if (block.invisible == false)
		{
			 block.invisible = true;
			 block.SetHasClass("hidden", true);
		}
	}
}

function ShowTalentMain()
{
	ShowTalentShop() 
	HideAbilityShop()
}

function HeroLevelUpTalent()
{
	var playerHeroIndex = Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerInfo().player_id)
	var points = $("#ability_points");
	//var empty_ability = $("#ability_number");
	if (points){
	points.SetHasClass("ability_points",true)
	points.text = $.Localize("empty_points: ") + Entities.GetAbilityPoints( playerHeroIndex )}
	/*if (empty_ability){
	empty_ability.SetHasClass("ability_points",true) 
	empty_ability.text = $.Localize("empty_talents: ") + (GetPlayerTalentNumber(Game.GetLocalPlayerInfo().player_id) - MAXTALENTS) * (-1) + " " + $.Localize("talents")}
	var id = Game.GetLocalPlayerInfo().player_id */
	for (var name in ARRPANEL){
		var panel = ARRPANEL[name]
		ResetPanelDataTalent(panel,panel.data.abilityCost,name,id)
	}
}

function TalentGroupHero( name, groupPanel, groupName)
{
	var Panel = groupPanel.FindChild( name );
	if ( !Panel ) 
	{  
		for (i = 1; i <= data[stat]["MAX_SLOTS"]; i++){
			var names = FormatText(name,(i * data[stat]["BONUS_PER_BUTTON"]))
			var talent_name = name + (i * data[stat]["BONUS_PER_BUTTON"])
			Panel = $.CreatePanel( "Panel", groupPanel, talent_name );
			var cost = $.CreatePanel( "Label", Panel, talent_name + "_cost" );
			var t = $.CreatePanel( "Label", Panel, talent_name + "_text" );
			Panel.SetHasClass( "talent_class", true );
			cost.SetHasClass( "talent_class_cost", true );
			cost.text = data[stat]["PRICE_PER_BUTTON"] * i; 
			t.SetHasClass( "talent_class_text", true );
			t.text = names;
			var value = data[stat]["BONUS_PER_BUTTON"] * i
			var price = data[stat]["PRICE_PER_BUTTON"] * i
			UpdateTalentList(talent_name,Game.GetLocalPlayerInfo().player_id,price,Panel,value,fullAbility)
		}
	}		
}

function CreateTalentHero(Hud,heroName){
	if (Hud){
		var talentPanel = Hud.FindChild( "talent_buttons" );
		var TalentArray = CustomNetTables.GetTableValue( "talents", heroName);
		if (!talentPanel){     
			talentPanel = $.CreatePanel( "Button", Hud, "talent_buttons"  ); 
			talentPanel.SetHasClass( "TalentPanel", true );
		}
		var TalentHeroBlock = talentPanel.FindChild( "talent_" + heroName  ); 
		if (!TalentHeroBlock){
			TalentHeroBlock = $.CreatePanel( "Panel", talentPanel, heroName  );
			TalentHeroBlock.SetHasClass( "HeroPanel_Talent", true );
			TalentHeroBlock.data = {
				TalentList: TalentArray,
				heroName: heroName,
				PlayerId: Game.GetLocalPlayerInfo().player_id,
			}
			TalentHeroBlock.SetPanelEvent( "onactivate", HeroClick(TalentHeroBlock));
			var panel = TalentHeroBlock.FindChild("ImagesTalent_" + heroName);
			if (!panel)
			{
				panel = $.CreatePanel( "DOTAHeroImage", TalentHeroBlock, "ImagesTalent_" + heroName );
				panel.heroname = heroName; 
			}
		}
	}
}

(function()
{
	if (IsCreateHeroMap()) {
		Update_Talent_Tables(); 
		Game.AddCommand( "+OpenTalentMenu", ShowTalentMain, "", 0 );
	}
	HideMainBlockTalent();  
	//HidePageStart(2); 	
	//GameEvents.Subscribe( "UpdateTalentTable", UpdateTalentTable );
	//GameEvents.Subscribe("dota_player_learned_ability", HeroLevelUpTalent );
	//GameEvents.Subscribe("dota_player_gained_level", HeroLevelUpTalent );
})();