package  
{
	import by.nickel.namecase.NCL;	
	import by.nickel.namecase.NameCaseRu;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * <h2>Глава 2. Встроенные константы.</h2>
	 * <p>Так как каждый падеж имеет свой номер, то для упрощения работы с библиотекой используются 
	 * константы. Описание констант можно найти в классе by.nickel.namecase.NCL. Рассмотрим все
	 * из них.</p>
	 * <p>Для указания пола используются константы:</p>
	 *  <ul>
	 * 	  <li>NCL.MAN – мужской пол</li>
	 * 	  <li>NCL.WOMAN – женский пол</li>
	 *  </ul>
	 * <p>Для указания падежей украинского и русского языка:</p>
	 * <ul> 	  
	 *	  <li>NCL.NOM - именительный падеж</li>
	 *    <li>NCL.GEN - родительный падеж</li>
	 * 	  <li>NCL.DAT - дательный падеж</li>
	 *    <li>NCL.ACC - винительный падеж</li>
	 *    <li>NCL.INS - творительный падеж</li>
	 *    <li>NCL.ABL - предложный падеж</li>
	 *  </ul>
	 * <h2>Использование встроенных констант.</h2>
	 * <p>
	 * Метод q( fullname:String, caseNum:int = 0, gender:int = 0) имеет три параметра.
	 * Один из них не есть обязательными.</br> 
	 * 
	 * Параметр <code>caseNum</code> указывает на падеж, в который нужно поставить слово
	 * fullname. Если он не указан, или равен NCL.NOM, тогда метод возвращает массив со
	 * всеми падежами. 
	 * 
	 * Параметр <code>gender</code> указывает на пол человека. Если в качестве параметра
	 * указать NCL.WOMAN, тогда склонение будет производиться по правилам склонения женскиx
	 * ФИО. Если же параметр не указан или равен 0, тогда система сама определит пол человека.
	 * 
	 * В параметре <code>fullname<code> может быть любое количе ство слов. Система сама разделит их 
	 * на составные части и произведет склонение каждой.</p>
	 * 
	 * @author Vitalik Krivtsov aka Nickel
	 */
	public class Lesson2 extends Sprite 
	{
		/**
		 * @private 
		 */
		private var ncru:NameCaseRu;
		
		/**
		 * Cons.
		 */
		public function Lesson2( ) 
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
			
			/**
			 * Указываем падеж.
			 */
			trace( ncru.q('Андрей Николаевич', NCL.GEN) );
			
			/**
			 * Явно не указываем пол.
			 */
			trace( ncru.q('Иващук') );
			
			/**
			 * Указываем мужской пол и не указываем падеж. 
			 */
			trace( ncru.q('Иващук', NCL.NOM, NCL.MAN));				
		}
		
	}

}