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
			trace( ncru.q('Роман Мураль') );	
			trace( ncru.words );
			trace( ncru.q('Илья Перекопский') );	
			trace( ncru.q('Гавриил Гордеев') );	
			trace( ncru.q('Нинель Овечкина') );	
			trace( ncru.q('Нинель Гелашвили') );	
			trace( ncru.q('Эльнара Петрова') );	
			trace( ncru.q('Даша Номеровская') );	
			trace( ncru.q('Саша Муромский') );	
			trace( ncru.q('Алеся Кладковских') );	
			trace( ncru.q('Альбина Дмитренко') );	
			trace( ncru.q('Настасия Вискас') );	
			trace( ncru.q('Воробей Лев Ильич') );
			trace( ncru.q('Леха Цымалёв') );
			trace( ncru.q('Фамил Садыгов') );
			trace( ncru.q('Катюха') );
			trace( ncru.q('Фелиция Жанлис') );
			trace( ncru.q('Дарья Тесленко') );
			trace( ncru.q('Наталья Тесленко') );
			
			trace( ncru.words );
		}
		
	}

}