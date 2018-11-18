"use strict";

function HideTalentShop()
{ 
	var block = $( "#triggerButton" ).GetParent().GetParent().GetParent().FindChild("TalentShop").FindChild("TalentMainShop");
	if (block.invisible == false)
	{
		 block.invisible = true;
		 block.SetHasClass("hidden", true);
	}
}

function ShowMainBlock()
{
	var button = $( "#triggerButton" );

	var block = button.GetParent().GetParent().GetParent().FindChild("spellShop").FindChild("mainShop");
	if (block.invisible==null || block.invisible==true)
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
	HideTalentShop()
}

function FixSpellShopPosition()
{
    var width =Game.GetScreenWidth()
    var height =Game.GetScreenHeight()
    var radio=width/height
    if (2.0<radio)
    {
        $("#triggerButtonPanel").style.position="1450px 1000px 0"
    }
	if ( 1.5<radio&&radio<1.7)
    {
    	$("#triggerButtonPanel").style.position="1450px 1000px 0"
    }
    if ( radio<1.4 )
    {

    	$("#triggerButtonPanel").style.position="1450px 1000px 0"
    }
}
 

function ShowTooltip()
{
      $.DispatchEvent("DOTAShowTitleTextTooltip",$("#triggerButtonPanel"), "#spell_trigger_notice_title", "#spell_trigger_notice_detail");
}

function HideTooltip()
{
       $.DispatchEvent( "DOTAHideTitleTextTooltip",$("#triggerButtonPanel") );
}

function OpenAndHidePanel()
{
	ShowMainBlock()
}
(function()
{
	if (!IsCreateHeroMap()) {
		$("#triggerButtonPanel").SetHasClass("hidden", true);
	}else{
		 FixSpellShopPosition();
		 Game.AddCommand( "+OpenMainBlock", ShowMainBlock, "", 0 );
	}
})();
