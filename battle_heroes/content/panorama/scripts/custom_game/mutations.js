"use strict";


function MutationInit(data){
	$.Msg(data)
	$.Schedule(4, function(){
		$("#MutationSpinner").SetHasClass( "hidden", true );
		for (var i = 1;i <= 3;i++){
			MutationNewText($("#MutationName" + i),data[i]);
		}
		$("#MainMutation").SetHasClass( "hidden", false );
	});
}
function MutationNewText(panel,data){
	if (data.negative)
		panel.SetHasClass( "negative_mutation", true );
	else
		panel.SetHasClass( "negative_mutation", false );
	var t = data.text
	panel.text = $.Localize(FormattingText(t,data));
	panel.SetPanelEvent( "onmouseover", ShowText(panel,$.Localize(FormattingText(t + "_Description",data)),$.Localize(FormattingText(t,data))) );
	panel.SetPanelEvent( "onmouseout", HideText( $.Localize(FormattingText(t,data)) ));
}

function RuneElement(RuneType)
{
	return "<img src='" + TransformTextureToPath(RuneType, 'Rune') + "' class='RuneIconDescription'/>";
}
function RuneColorDescription(t){
	var r;
	if (t.match("invis"))
		r = 3;
	if (t.match("double_damage"))
		r = 0;
	if (t.match("haste"))
		r = 1;
	if (t.match("illusion"))
		r = 2;
	if (t.match("regen"))
		r = 4;	
	if (t.match("bounty"))
		r = 5;
	return RUNES_TOOLTIP[r].color
}
function FormattingText(text,data){
	var t  = $.Localize(text);
	if (data.gold)
	t = t.replace('{gold}',data.gold)
	if (data.time)
	t = t.replace('{time}',data.time)
	if (data.damage)
	t = t.replace('{damage}',data.damage)	
	if (data.num)
	t = t.replace('{num}',data.num)	
	if (data.power)
	t = t.replace('{power}',data.power)	
	if (data.speed)
	t = t.replace('{speed}',data.speed)	
	if (data.heroes)
	t = t.replace('{heroes}',data.heroes)		
	if (data.heal)
	t = t.replace('{heal}',data.heal)	
	if (data.time_active)
	t = t.replace('{time_active}',data.time_active)	
	if (data.bonus_stats)
	t = t.replace('{bonus_stats}',data.bonus_stats)		
	if (data.reduction_stats)
	t = t.replace('{reduction_stats}',data.reduction_stats)		
	if (data.text_description){
		for (var k in data.text_description){
			t = t.replace(k, "<font color='#"+ RuneColorDescription(data.text_description[k]) +"'>" + $.Localize(data.text_description[k]) + "</font>");
		}
	}
	return t;
}

(function() {
	$("#MutationSpinner").SetHasClass( "hidden", false );
	$("#MainMutation").SetHasClass( "hidden", true );
	GameEvents.Subscribe('CreateMutations', MutationInit);
})();
 