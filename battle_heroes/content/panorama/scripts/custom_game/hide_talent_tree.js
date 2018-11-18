function GetHUDRootUI() {
	var rootUI = $.GetContextPanel();
	while (rootUI.id != "Hud" && rootUI.GetParent() != null) {
		rootUI = rootUI.GetParent();
	}
	return rootUI;
}
function HidePanel(panel) {
	panel.style.visibility = "collapse;";
	panel.hittest = false;
	panel.enabled = false;
}
function HideDefaultDotaTalentWidgets() {
	//if (IsCreateHeroMap()) {
		HidePanel(GetHUDRootUI().FindChildTraverse("AbilitiesAndStatBranch").FindChildTraverse("StatBranch")); 
		HidePanel(GetHUDRootUI().FindChildTraverse("statbranchdialog")); 
		HidePanel(GetHUDRootUI().FindChildTraverse("level_stats_frame")); 
	//}
} 
 
$.Schedule(1, HideDefaultDotaTalentWidgets);