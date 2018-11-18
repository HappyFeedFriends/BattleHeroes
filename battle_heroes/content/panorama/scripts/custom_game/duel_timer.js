"use strict";

function UpdateDuelText(data)
{
	var temp_text = ""
	temp_text += data.string
	$( "#DuelTextBlock").text = $.Localize(temp_text) + " " + data.time_string
	$( "#DuelTextBlock").style.color = data.color
	$( "#Block").style.visibility = "visible"
}

function Attension_update(data)
{
	$( "#Attension").visible = true
	var temp_text = "";
	temp_text+=data.string;
	$( "#Attension").text = $.Localize(temp_text)
}
function Attension_close()
{
	$( "#Attension").visible = false
}

function OnTimerClick()
{
	// todo: attension to chat
	//if(GameUI.IsAltDown())
		
}

(function()
{
	GameEvents.Subscribe( "duel_text_update", UpdateDuelText)
})();

