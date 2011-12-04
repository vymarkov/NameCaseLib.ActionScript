package  
{
	import by.nickel.namecase.NCL;
	import by.nickel.namecase.NameCaseRu;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.describeType;
	
	/**
	 * <h2>Глава 6. Определение формата ФИО.</h2>
	 * <p>
	 * Еще одна полезная функция библиотеки, это определение, в каком формате записано ФИО.
	 * Для этого нужно использовать метод getFullNameFormat( fullname:String ), где fullname 
	 * строка, которая содержит ФИО. Метод возвращает форматированную строку. 
	 * </p>
	 * 
	 * @author Vitalik Krivtsov aka Nickel
	 */
	public class Lesson7 extends Sprite 
	{		
		/**
		 * @private 
		 */
		private var ncru:NameCaseRu;
		
		/**
		 * Cons.
		 */
		public function Lesson7( ) 
		{
			if ( stage ) init( );
			else addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
		/**
		 * 
		 * @param	event
		 */
		private function init( event:Event = null ):void 
		{
			removeEventListener( Event.ADDED_TO_STAGE, init );
				
			/**
			 * 
			 */
			ncru = new NameCaseRu( );
						
			var people:Array = ["Андрей Николаевич", 'Ирина', 'Ефиопский Аркадий Василевич', 'Мария Николаевна', 'Розумовский Илья'];
			
			for each ( var person:String in people )
			{				
				// Для каждого человека выводим формат ФИО.			 
				trace( ncru.getFullNameFormat(person) + " - " + person );
				/**
				 * N F  - Андрей Николаевич
				 * N  - Ирина
				 * S N F  - Ефиопский Аркадий Василевич
				 * N F  - Мария Николаевна
				 * S S  - Розумовский Илья
				 */
			}
		}
		
	}

}