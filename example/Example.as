package  
{
	import by.nickel.namecase.NameCaseRu;
	import by.nickel.namecase.NameCaseUa;	
	import by.nickel.namecase.NCLNameCaseWord;
	import by.nickel.namecase.NCL;
	
	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	/**
	 * ...
	 * @author Vitalik Krivtsov aka Nickel
	 */
	public class Example extends Sprite 
	{
		/**
		 * @private
		 */
		private var ncru:NameCaseRu = new NameCaseRu( );
		
		/**
		 * @private
		 */
		private var ncua:NameCaseUa = new NameCaseUa( );
		
		/**
		 * @private
		 */
		private var fullName:String;
		
		/**
		 * @private
		 */
		private var cases:Array = ['{nom}', '{gen}', '{dat}', '{acc}', '{ins}', '{abl}' ]
		
		/**
		 * @private 
		 */
		private var code:String = '<div class=\'beautifull_word\'>{fullname}<div class=\'word wrong\'><a href=\'#\' onclick=\'document.getElementById(\'mistake\').style.display = \'block\'; return false;\' title=\'Вы нашли ошибку?\'>Ошибка?</a></div></div><div><ul class=\'namecase\'><li title=\'Именительный падеж\'>И. {nom}</li><li title=\'Родительный падеж\'>Р. {gen}</li><li title=\'Дательный падеж\'>Д. {dat}</li><li title=\'Винительный падеж\'>В. {acc}</li><li title=\'Творительный падеж\'>Т. {ins}</li><li title=\'Предложный падеж\'>П. {abl}</li></ul></div><div class=\'versionb\'>Для склонения было использовано NameCaseLib на ActionScript3.0 v0.4 от 06.12.2011 22:00</div>';                                    
		
		/**
		 * Cons.
		 */
		public function Example( ) 
		{			
			var params:Object = stage.loaderInfo.parameters as Object;		
			fullName = params.lastName + ' ' + params.firstName + ' ' + params.fatherName;
				
			if ( ExternalInterface.available )
			{
				ExternalInterface.call( "q", 'ok' );
				ExternalInterface.addCallback( 'q', q );
				q( params.language, fullName );	
			}			
		}
		
		/**
		 * 
		 * @param	fullName
		 */
		private function q( language:String, fullName:String ):void
		{	
			this.fullName = fullName;	
		
			if ( language == 'ru' )
			{
				qru( );
			}
			else
			{
				qua( );				
			}		
		}		
		
		private function qua( ):void 
		{
			//ExternalInterface.call( 'function(){alert("ok")};' );
			var arrayList:Array = ncua.q( this.fullName );	
			
			if ( ncua.gender == NCL.MAN )								
				ExternalInterface.call( 'function(){ document.getElementById(\'left\').innerHTML = "<div class=\'face man\'><span>Мужчина</span></div><div class=\'flags ru\'><span>Русский язык</span></div>" }' );			
			else 			
				ExternalInterface.call( 'function(){ document.getElementById(\'left\').innerHTML = "<div class=\'face woman\'><span>Женщина</span></div><div class=\'flags ru\'><span>Русский язык</span></div>"; }' );	
				
			var value:String = code;
			for ( var i:int; i < cases.length; i++ )			
				value = value.replace( cases[i], arrayList[i] );
				
			var fname:String = '';
			for each ( var word:NCLNameCaseWord in ncua.words )			
				if ( word.namePart == 'S' ) 					
					fname += '<div class=\'beautifull_word\'><div id=\'last_name\' class=\'word second\'>' + word.originalWord + '<span>Фамилия</span></div>';			
				else if ( word.namePart == 'F' ) 								
					fname += '<div id=\'father_name\' class=\'word father\'>' + word.originalWord  +'<span>Отчество</span></div>';
				else if ( word.namePart == 'N'  )									
					fname += '<div id=\'first_name\' class=\'word first\'>' + word.originalWord +'<span>Имя</span></div>';	
			value = value.replace( '{fullname}', fname );
				
			ExternalInterface.call( 'function(){ document.getElementById(\'right\').innerHTML = "' + value +'" }' );			
		}
		
		/**
		 * 
		 */
		private function qru( ):void 
		{
			var arrayList:Array = ncru.q( this.fullName );	 
			if ( ncru.gender == NCL.MAN )								
				ExternalInterface.call( 'function(){ document.getElementById(\'left\').innerHTML = "<div class=\'face man\'><span>Мужчина</span></div><div class=\'flags ru\'><span>Русский язык</span></div>" }' );			
			else 			
				ExternalInterface.call( 'function(){ document.getElementById(\'left\').innerHTML = "<div class=\'face woman\'><span>Женщина</span></div><div class=\'flags ru\'><span>Русский язык</span></div>"; }' );	
				
			var value:String = code;
			for ( var i:int; i < cases.length; i++ )			
				value = value.replace( cases[i], arrayList[i] );
				
			var fname:String = '';
			for each ( var word:NCLNameCaseWord in ncru.words )			
				if ( word.namePart == 'S' ) 					
					fname += '<div class=\'beautifull_word\'><div id=\'last_name\' class=\'word second\'>' + word.originalWord + '<span>Фамилия</span></div>';			
				else if ( word.namePart == 'F' ) 								
					fname += '<div id=\'father_name\' class=\'word father\'>' + word.originalWord  +'<span>Отчество</span></div>';
				else if ( word.namePart == 'N'  )									
					fname += '<div id=\'first_name\' class=\'word first\'>' + word.originalWord +'<span>Имя</span></div>';	
			value = value.replace( '{fullname}', fname );
				
			ExternalInterface.call( 'function(){ document.getElementById(\'right\').innerHTML = "' + value +'" }' );
		}
	}
}