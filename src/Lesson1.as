package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import by.nickel.namecase.NCL;	
	import by.nickel.namecase.NameCaseUa;
	import by.nickel.namecase.NameCaseRu;
	
	/**
	 * ...
	 * @author Vitalik Krivtsov aka Nickel
	 */
	public class Lesson1 extends Sprite 
	{
		/**
		 * @private 
		 */
		private var ncua:NameCaseUa;
		
		/**
		 * @private 
		 */
		private var ncru:NameCaseRu;
		
		/**
		 * Cons.
		 */
		public function Lesson1( ) 
		{
			if ( stage ) init( );
			else addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
		private function init( event:Event = null ):void 
		{
			removeEventListener( Event.ADDED_TO_STAGE, init );
			
			/**
			 * Создаем обьект класса.  
			 * Теперь библиотека готова к работе.
			 */
			ncua = new NameCaseUa( );
			
			/**
			 * Производим склонения и выводим результат.
			 */
			trace( ncua.q('Андрій Миколайович') );		
			
			/**
			 * Создаем обьект класса.  
			 * Теперь библиотека готова к работе.
			 */
			ncru = new NameCaseRu( );
			
			/**
			 * Производим склонения и выводим результат.
			 */			
			trace( ncru.q('Андрей Николаевич') );		
			
		}
		
	}

}