/**
 *
 */
var flashObj;			

function pageInit( )
{
	var flashVars = {
		language:"ru",
		firstName:"Павел",
		lastName:"Дуров",
		fatherName:"Валерьевич"
	};    
	
	var params = {
		menu: "false",
		scale: "noScale",
		allowFullscreen: "true",
		allowScriptAccess: "always",
		wmode: "opaque",
		bgcolor: "#FFFFFF"
	};  
	
	var attributes = {
		id:"namecaselib"
	};	
	swfobject.embedSWF( "example.swf", "as3namecaselib", "100", "100", "10.0.0", "expressInstall.swf", flashVars, params, attributes );
	flashObj = getSWF( "namecaselib" );  
}

function getSWF( movieName ) { 
	if ( navigator.appName.indexOf("Microsoft") != -1 ) {
		return window[movieName];  
	} else {
		return document[movieName];  
	}
};

function setLanguage( language ) {
    var value = document.getElementById('input').value;
	flashObj.q( language, value );
};
