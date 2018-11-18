
function UpdateKillLimit(keys)
{
	var limit = keys.limit
	$.Msg(limit)
	var panel = $( "#ScoreBoard" )
	panel.text = limit
}
(function() 
{
	GameEvents.Subscribe("update_kill_limit", UpdateKillLimit );
})();