package  
{
	import by.nickel.namecase.NCL;
	import by.nickel.namecase.NameCaseRu;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Vitalik Krivtsov aka Nickel
	 */
	public class Lesson5 extends Sprite 
	{		
		/**
		 * @private 
		 */
		private var ncru:NameCaseRu;
		
		/**
		 * Cons.
		 */
		public function Lesson5( ) 
		{
			if ( stage ) init( );
			else addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
		private function init( event:Event = null ):void 
		{
			removeEventListener( Event.ADDED_TO_STAGE, init );
						
			ncru = new NameCaseRu( );
			/**
			 * Форматированный вывод.
			 */
			
			/**
			 * Можно не указывать пол и формат.
			 */
			trace( ncru.qFullName("Иванов", "Фёдор", "Ильич", NCL.INS) ); //Ивановым Фёдором Ильичом
			
			/**
			 * В формате не обязательно использовать все слова.
			 */
			trace( ncru.qFullName("Иванов", "Фёдор", "Ильич", NCL.INS, NCL.MAN, "N F") ); //Фёдором Ильичом
			
			/**
			 * Можно указать формат и не указывать пол человека.
			 */
			trace( ncru.qFullName("Иванов", "Фёдор", "Ильич", NCL.INS, 0, "S N") ); //Ивановым Фёдором
			
			/**
			 * Можно указать все параметры.
			 */
			trace( ncru.qFullName("Иванов", "Фёдор", "Ильич", NCL.INS, NCL.MAN, "S N F") ); //Ивановым Фёдором Ильичом
			
			/**
			 * В строке-формате могут присутствовать любые символы.
			 */
			trace( ncru.qFullName("Иванов", "Фёдор", "Ильич", NCL.INS, NCL.MAN, "Фамилия: S, Имя: N N, Отчество: F") ); //Фамилия: Ивановым, Имя: Фёдором, Отчество: Ильичом
			
			/**
			 * Другие способы быстрого склонения.			 * 
			 */
			
			/**
			 * Пол можно не указывать.
			 */
			trace( ncru.qFatherName("Николаевич", NCL.DAT) );
			
			/**
			 * Если не указать падеж, получим массив со всеми падежами.
			 */
			trace( ncru.qFirstName("Андрей") );			
			
			/**
			 * В ситувациях, когда не возможно определить пол, его полезно указать.
			 */
			trace( ncru.qLastName("Касюк", NCL.DAT, NCL.MAN) );
		
		}
	}

}