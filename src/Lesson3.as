package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import by.nickel.namecase.NCL;		
	import by.nickel.namecase.NameCaseRu;
	
	
	/**
	 * <h2>Глава 3. Определение пола</h2>
	 * 
	 * <p>Библиотека имеет все необходимые функции для определения пола по ФИО.
	 * Данная особенность может быть полезной тогда, когда пользователь вводит
	 * только имя, но не указывает свой пол.<p>
	 * 
	 * <p>Определение пола реализуется при помощи метода genderDetect( fullname:String ).
	 * Где fullname строка с полным ФИО. Метод возвращает либо NCL.MAN, либо NCL.WOMAN в
	 * зависимости от пола человека.
	 * 
	 * @author Vitalik Krivtsov aka Nickel
	 */
	public class Lesson3 extends Sprite 
	{		
		/**
		 * @private 
		 */
		private var ncru:NameCaseRu;
		
		/**
		 * Cons.
		 */
		public function Lesson3( ) 
		{
			if ( stage ) init( );
			else addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
		private function init( event:Event = null ):void 
		{
			removeEventListener( Event.ADDED_TO_STAGE, init );
						
			ncru = new NameCaseRu( );
			
			/**
			 * 
			 */
			var array:Array = ['Андрей Николаевич', 'Ирина', 'Ефиопский Аркадий Василевич', 'Мария Николаевна', 'Розумовский Илья'];
			
			var random:Number = Math.ceil( Math.random() * 4 );
			
			/**
			 * Выбираем случайного человека из списка.
			 */
			var person:String = array[random] as String;		
					
			/**
			 * Определяем пол.
			 */
			var gender:int = ncru.genderDetect( person ); 
			trace( ncru.genderDetect( person ) );
				
			/**
			 * Выводим приветствие.
			 */
			trace( "Мы хотим предложить " +  ncru.q(person, NCL.DAT) + "наши новые товары из категорий:" );

			/**
			 * В зависимости от пола предлагаем разные товары.
			 */
			if ( gender == NCL.MAN)
			{
				trace( "<li>Рыбалка и охота</li>\n<li>Электроника</li>\n<li>Инструменты для дома</li>" );
			}
			else
			{
				trace( "<li>Книги о кулинарии</li>\n<li>Косметика</li>\n<li>Дом и семья</li>" );
			}	
			/**
			 * Мы хотим предложить Марии Николаевне наши новые товары из категорий:
			 * <li>Книги о кулинарии</li>
			 * <li>Косметика</li>
			 * <li>Дом и семья</li>
			 */
		}
		
	}

}