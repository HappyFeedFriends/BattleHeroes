
var cfg = {
	"TalentList": "file://{resources}/layout/custom_game/custom_shopes/talent/talent_list.xml",
};
var numbers = {}

function HeroClick( Button )
{
	return function()
	{
		var buyPanel = $("#BuyPanelTalentHeroes")
		var data = Button.data;
		buyPanel.SetHasClass( "hidden", false );
		if (buyPanel){
			var parentPanel = buyPanel.FindChild( "ParentLists" );
			if ( !parentPanel )
			{
				parentPanel = $.CreatePanel( "Panel", buyPanel, "ParentLists" );   
				parentPanel.BLoadLayout( cfg.TalentList, false, false );     
				parentPanel.SetHasClass( "FullBlock", true );
			}   
			var abilityList =  parentPanel.FindChildInLayoutFile( "HeroTalentList" ); 
			var slotNumber = Object.keys(data.TalentList).length;
			abilityList.style.width = (slotNumber * 68) + "px";
			if ( data.heroName != "" )
			{     
				if (numbers[1] && numbers[1] != undefined && numbers[1] > 1){
					for (var i = 1; i <= numbers[1]; i++){
						InvisibleTalents(abilityList,i);
					}
				}
				numbers[1] = slotNumber;
				numbers[2] = data.TalentList;
				numbers[3] = data.heroName;
				for ( var i = 1; i <= slotNumber; i++ )                               
				{
					UpdateTalent( abilityList, data.heroName, i ,data.PlayerId,data.TalentList[i]);
				}
			}
		}
	}
};

function UpdateTalentHeroes()
{
	var playerHeroIndex = Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerInfo().player_id)
	var points = $("#ability_points");
	var empty_ability = $("#ability_number");
	if (points)
		points.text = $.Localize("empty_points: ") + Entities.GetAbilityPoints( playerHeroIndex )
	if (empty_ability)
		empty_ability.text = $.Localize("empty_talents: ") + (GetPlayerTalentNumber(Game.GetLocalPlayerInfo().player_id) - MAXTALENTS) * (-1) + " " + $.Localize("talents")
	var buyPanel = $("#BuyPanelTalentHeroes")
	if (buyPanel){
		var parentPanel = buyPanel.FindChild( "ParentLists" );
		if (parentPanel){
		var abilityList =  parentPanel.FindChild( "HeroTalentList" ); 
			for ( var i = 1; i <= numbers[1]; i++ )                               
			{
				UpdateTalent( abilityList, numbers[3], i ,Game.GetLocalPlayerInfo().player_id,numbers[2][i] );
			}
		}
	}
}

function UpdateTalent(abilityList,heroName,slot,playerId,abilityName)
{ 
	var abButtonId = "Talent_"+ slot;
	var abButton = abilityList.FindChild( abButtonId );
	if ( !abButton )
	{
		abButton = $.CreatePanel( "Button", abilityList, abButtonId );
	}
	var abPanelId = "talent_image_" + slot;
	var abPanel = abButton.FindChild( abPanelId );
	var abCostLabelId = "talent_cost_" + slot;
	var abCostLabel = abButton.FindChild( abCostLabelId );
	abButton.SetHasClass( "hidden", false );
	if ( !abPanel)
	{
		var data = 
		{
			abilityName: abilityName,
			heroName: heroName,
			position: slot,
			playerId: playerId,
			abilityCost: GetAbilityCost(abilityName),
			enough: true,
		}
			abPanel = CreateNewPanelTalent(abButton,abPanelId,"Image",data)
			abCostLabel = $.CreatePanel( "Label", abButton, abCostLabelId );
			RefreshPanelTalent(abPanel,abCostLabel,abilityName,heroName,playerId);
	}else{
		RefreshPanelTalent(abPanel,abCostLabel,abilityName,heroName,playerId);
	}
}  
function RefreshPanelTalent(abPanel,abCostLabel,abilityName,heroName,playerId)
{
	abPanel.data.abilityName = abilityName; 
	abPanel.data.heroName = heroName; 
	var abilityCost = GetAbilityCost(abilityName);
	abCostLabel.text = abilityCost;
	abPanel.data.abilityCost = abilityCost;
	abPanel.SetImage(TransformTextureToPath(GetTextureTalent(abilityName) && GetTextureTalent(abilityName) || heroName ,!GetTextureTalent(abilityName) && "icon" || "Ability"));
	var hero = Players.GetLocalPlayerPortraitUnit();
	var ability = Entities.GetAbilityByName( hero, abilityName );
	if (!AbilityPointEnough(abilityCost,playerId) || ability >= 0)    
	{  
		abPanel.data.enough = false;
		abPanel.SetHasClass( "notEnoughDark", true );
	} 
	else  
	{
		abPanel.data.enough = true;
		abPanel.SetHasClass( "notEnoughDark", false );
	}
	if ( ability >= 0 ){
		abPanel.GetParent().enabled = false; 
	}else{
		abPanel.GetParent().enabled = true; 
	}
	var abilityTitle = "DOTA_Tooltip_ability_" + abilityName;
	var description = "DOTA_Tooltip_ability_" + abilityName + "_Description";
	abilityTitle = $.Localize(description) != description && abilityTitle || "";
	description = $.Localize(description) != description && $.Localize(abilityTitle + "_description") || $.Localize("DOTA_Tooltip_ability_" + abilityName);
	description = FormattingDutySymbolText(description,abilityName,abPanel)
	var abButton = abPanel.GetParent()
	abButton.SetPanelEvent( "onmouseover", ShowText(abButton,description,abilityTitle) );
	abButton.SetPanelEvent( "onmouseout", HideText( abilityTitle ));
	abButton.SetPanelEvent( "onactivate", AddTalentHero( abPanel ));
}

function AddTalentHero( abPanel )
{
	return function()
	{
		if (abPanel.data.enough)
		{
			abPanel.GetParent().enabled = false;         
		}
		GameEvents.SendCustomGameEventToServer( "AddTalentHeroShop", abPanel.data );      
	}
};
function GetTextureTalent(TalentName)
{
	return CustomNetTables.GetTableValue( "talent_icon","linked") && CustomNetTables.GetTableValue( "talent_icon","linked")[TalentName] ||  false;
}

function CreateNewPanelTalent(abButton,abPanelId,type,data,heroName,slot,abilityName,playerId)
{
	abPanel = $.CreatePanel( type, abButton, abPanelId );
	abPanel.SetHasClass( "FullBlock", true ); 
	abPanel.SetHasClass( "hidden", false );
	abPanel.data = data ||  
	{
		abilityName: abilityName,
		heroName: heroName,
		position: slot,
		playerId: playerId,
		abilityCost: GetAbilityCost(abilityName),
		enough: true,
	}
	return abPanel
}

function InvisibleTalents(abilityList,slot)
{
     var ButtonId = "Talent_"+ slot;
     var Button = abilityList.FindChild( ButtonId );
     if ( Button )
	 {
		Button.SetHasClass( "hidden", true );
	 }
}

(function() 
{
	var buyPanel = $("#BuyPanelTalentHeroes");
	buyPanel.SetHasClass( "hidden", true );
	if (IsCreateHeroMap()) {
		GameEvents.Subscribe("UpdateTalentHero", UpdateTalentHeroes );
		GameEvents.Subscribe("dota_player_gained_level", UpdateTalentHeroes );
		GameEvents.Subscribe("dota_player_learned_ability", UpdateTalentHeroes );
	}
})();