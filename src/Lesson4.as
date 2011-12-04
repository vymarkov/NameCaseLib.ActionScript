package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import by.nickel.namecase.NCL;
	import by.nickel.namecase.NameCaseRu;	
	
	/**
	 * <h2>Глава 4. Работа с разными регистрами</h2>
	 * <p>Не имеет значения, в каком регистре ФИО передается для склонения.
	 * Перед началом обработки каждого слова создается маска, где сохранено,
	 * какие буквы были в верхнем, а какие - в нижнем регистре. После успешного
	 * склонения, регистр слов автоматически возвращается.</p>
	 * 
	 * @author Vitalik Krivtsov aka Nickel
	 */
	public class Lesson4 extends Sprite 
	{		
		/**
		 * @private 
		 */
		private var ncru:NameCaseRu;
		
		/**
		 * Cons.
		 */
		public function Lesson4( ) 
		{
			if ( stage ) init( );
			else addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
		private function init( event:Event = null ):void 
		{
			removeEventListener( Event.ADDED_TO_STAGE, init );
						
			ncru = new NameCaseRu( );
						
			trace( ncru.q("АНДРЕЙ НИКОЛАЕВИЧ", NCL.GEN) );//АНДРЕЯ НИКОЛАЕВИЧА
			trace( ncru.q("королёв Никита ПЕТРОВИЧ", NCL.GEN) );//королёва Никиты ПЕТРОВИЧА 
			trace( ncru.q("ПороСЁнОК ПёТР", NCL.GEN) );//ПороСЁнКА ПёТРа 
		}
		
	}

}