<cfscript>

function startTable(string title =""){
	local.rv = '<table class="ui celled striped table"><thead><tr><th colspan="2">';
	local.rv &= arguments.title;
	local.rv &= '</th></tr></thead><tbody>';
	return local.rv;
}

function endTable(){
	return "</tbody></table>";
}

function startTab(string tab="", boolean active = false){
	local.rv = '<div class="ui bottom attached tab segment';
	if(arguments.active)
		local.rv &= ' active ';
	local.rv &= '" data-tab="';
	local.rv &= arguments.tab;
	local.rv &= '">'; 
	return local.rv;
}

function endTab(){
	return '</div>';
}

function outputSetting(array setting){
	local.rv = ""; 
	for (var i=1;i LTE ArrayLen(arguments.setting);i=i+1) { 
		local.rv &= '<tr><td class="four wide">';
		local.rv &= rereplace(rereplace(arguments.setting[i],"(^[a-z])","\u\1"),"([A-Z])"," \1","all");
		local.rv &= '</td><td class="eight wide">';
		local.rv &= formatSettingOutput( get(arguments.setting[i]) );
		local.rv &= '</td></tr>';
	}
	return local.rv;
}
function formatSettingOutput(any val){
	local.rv = '';
	local.val = arguments.val;
	if(isSimpleValue(local.val)){
		if(isBoolean(local.val)){
			if(local.val){
				local.rv = '<i class="icon check" />';
			} else {
				local.rv = '<i class="icon close" />';
			}
		} else if( listLen(local.val, ',') GT 4 ) {
			for(var item in arguments.val){ 
				local.rv &= item & '<br>';
			}
		} else if( !len(local.val) ){ 
			local.rv = '<em>Empty String</em>';
		} else {
			local.rv = arguments.val;
		}
	} else if(isArray(local.val)){
		local.rv = "ARRAY";
	}  else if(isStruct(local.val)){ 
		for(var item in arguments.val){ 
			local.rv &= item & '->' & arguments.val[item] & '<br>';
		}
	} else {
		local.rv = '<i class="icon question"></i>';
	}
	return local.rv;
}
function isActiveClass(route){
	if(request.wheels.params.route == arguments.route){
		return "item active";
	} else {
		return "item";
	}
}
</cfscript>