function GetPage(){
	for (var i = 1; i <= NumberPages(); i++){
		var button = $( "#TalentMainShop" ).FindChild( "Page_" + i );
		if (i == NumberPages()){
			$( "#TalentMainShop" ).style.height = "70%";
		}else{
			$( "#TalentMainShop" ).style.height = "60%";
			$( "#Ability_info" ).style.visibility = "visible";
		}
		if (button){
			if (button.visible == true){
				return i
			}			
		}
	}
}
 
function HidePage(page)
{
	var button = $( "#TalentMainShop" ).FindChild( "Page_" + page );
	if (button){	
			button.visible = false;
			button.SetHasClass("Hidden", true);
			return true
		}
	return false
}
function OpenPage(page)
{
	var button = $( "#TalentMainShop" ).FindChild( "Page_" + page );
	if (button){	
			button.visible = true;
			button.SetHasClass("Hidden", false);
			return true
		}
	return false
}
function HideFullPage() 
{
	for (var i = 1; i <= NumberPages(); i++){
		HidePage(i)
	}
}
function HidePageStart(start) 
{
	for (var i = start; i <= NumberPages(); i++){
		HidePage(i)
	}
}
function OpenFullPage() 
{
	for (var i = 1; i <= NumberPages(); i++){
		OpenPage(i)
	}
} 

function SwapPageRight(){	
	if (GetPage())
	{
		if (GetPage() < NumberPages()){ 
			OpenPage(GetPage() + 1)
			HidePage(GetPage())
		}
		button = $("#num_page");
		button.text = GetPage() + " / " + NumberPages()
	}
}
OpenPage(1)
function SwapPageLeft(){
	if (GetPage())
	{
		if (GetPage() > 1){
			OpenPage(GetPage() - 1)
		}
		HidePage(GetPage() + 1) 
		button = $("#num_page");
		button.text = GetPage() + " / " + NumberPages()
	}
}

	
function NumberPages()
{
	var i = 0
	while ($( "#TalentMainShop" ).FindChild( "Page_" + (i + 1) ) != null){
		i++
	}
	return i
}