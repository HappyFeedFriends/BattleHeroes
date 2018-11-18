
'use strict';

function GetDotaHud() {
	var rootUI = $.GetContextPanel();
	while (rootUI.id != "Hud" && rootUI.GetParent() != null) {
		rootUI = rootUI.GetParent();
	}
	return rootUI;
}

function FindDotaHudElement(id){
  return GetDotaHud().FindChildTraverse(id);
}

// settings
var useFormatting = 'half';

// subscribe only after the game start (fix loading problems)
/*var eventHandler = GameEvents.Subscribe('state_change', function (args) {
  if (args.newState >= DOTA_GameState.DOTA_GAMERULES_STATE_PRE_GAME) {
    PlayerTables.SubscribeNetTableListener('gold', onGoldChange);
    GameEvents.Subscribe('dota_player_update_query_unit', onQueryChange);
    GameEvents.Subscribe('dota_player_update_selected_unit', onQueryChange);
    GameEvents.Unsubscribe(eventHandler);
  }
});  */

function onQueryChange () {
  onGoldChange('gold', PlayerTables.GetAllTableValues('gold'));
}

function onGoldChange (table, data) {
  var unit = Players.GetLocalPlayerPortraitUnit();
  var localPlayerID = Game.GetLocalPlayerID();
  var playerID = Entities.GetPlayerOwnerID(unit);

  if (playerID === -1 || Entities.GetTeamNumber(unit) !== Players.GetTeam(localPlayerID)) {
    playerID = localPlayerID;
  }

  var gold = data.gold[playerID];
  if (gold && gold != undefined) {
	  if (gold.toString().length > 6)
	  {
		  useFormatting = "full";
	  }else{
		  useFormatting = "half";
	  }
  UpdateGoldHud(gold);
  UpdateGoldTooltip(gold);
  }
}

function UpdateGoldHud (gold) {
  var GoldLabel = FindDotaHudElement('ShopButton').FindChildTraverse('GoldLabel');

  if (useFormatting === 'full') {
    GoldLabel.text = FormatGold(gold);
  } else if (useFormatting === 'half') {
    GoldLabel.text = FormatComma(gold);
  } else {
    GoldLabel.text = gold;
  }
}

function UpdateGoldTooltip (gold) {
  // HACK this spews error when attempting to change the tooltip if it is not visible
  try {
    var tooltipLabels = FindDotaHudElement('DOTAHUDGoldTooltip').FindChildTraverse('Contents');

    var label = tooltipLabels.GetChild(0);
    label.text = label.text.replace(/: [0-9]+/, ': ' + gold);

    label = tooltipLabels.GetChild(1);
    label.style.visibility = 'collapse';
  } catch (e) {}
}

(function (){
	PlayerTables.SubscribeNetTableListener('gold', onGoldChange);
    GameEvents.Subscribe('dota_player_update_query_unit', onQueryChange);
    GameEvents.Subscribe('dota_player_update_selected_unit', onQueryChange);
})();