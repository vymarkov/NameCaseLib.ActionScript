package by.nickel.namecase 
{
	/**
	 * Класс содержит функции для работы со строками, которые используются в NCLNameCaseLib
	 * 
	 * @author Vitalik Krivtsov aka Nickel
	 */
	internal class NCLStr 
	{
		
		/**
		 * Cons.
		 */
		public function NCLStr( ) 
		{
			
		}
		
		/**
		 * Получить подстроку из строки.
		 * 
		 * @param String str строка.
		 * @param int start начало подстроки.
		 * @param int length длина подстроки.
		 * @return String подстрока.
		 */
		public static function substr( str:String, start:int, length:int = 0 ):String
		{			
			return str.substr( start, length );
		}
		
		
		/**
		 * Поиск подстроки в строке.
		 * 
		 * @param haystack строка, в которой искать.
		 * @param needle подстрока, которую нужно найти.
		 * @param offset начало поиска.
		 * @return позиция подстроки в строке.
		 */
		public static function strpos( haystack:String, needle:String, offset:int = 0 ):int
		{
			haystack = haystack.substr( offset );
			return haystack.search( needle );			
		}
		
		/**
		 * Определение длины строки.
		 * 
		 * @param str строка.
		 * @return длина строки.
		 */
		public static function strlen( str:String ):int
		{
			return str.length;
		}
		
		/**
		 * Переводит строку в нижний регистр.
		 * 
		 * @param str строка.
		 */
		public static function strtolower( str:String ):String
		{
			return str.toLowerCase( );
		}
		
		/**
		 * Переводит строку в верхний регистр.
		 * 
		 * @param str строка.
		 * @return строка в верхнем регистре.
		 */
		public static function strtoupper( str:String ):String
		{
			return str.toUpperCase( );			
		}
		
		public static function strrpos( ):void
		{
			
		}
		
		/**
		 * Проверяет в нижнем ли регистре находится строка.
		 * 
		 * @param	phrase строка
		 * @return в нижнем ли регистре строка.
		 */
		public static function isLowerCase( phrase:String ):Boolean
		{
			var value:Boolean = phrase == NCLStr.strtolower( phrase );
			return value;
		}
		
		/**
		 * Проверяет в верхнем ли регистре находится строка.
		 * 
		 * @param phrase
		 * @return в верхнем ли регистре строка.
		 */
		public static function isUpperCase( phrase:String ):Boolean
		{
			var value:Boolean = phrase == NCLStr.strtoupper( phrase );
			return value;			
		}
		
		/**
		 * Превращает строку в массив букв.
		 * 
		 * @param phrase строка
		 * @return Array массив букв
		 */
		public static function splitLetters( phrase:String ):Array
		{			
			var lettersArr:Array = [];
			var length:int = phrase.length;
			for ( var i:int; i < length; i++ )
				lettersArr[i] = phrase.charAt( i );
			return lettersArr;				
		}
		
		/**
		 * Соединяет массив букв в строку.
		 * 
		 * @param	lettersArr массив букв.
		 * @return строка.
		 */
		public static function connectLetters( lettersArr:Array ):String
		{
			return lettersArr.join( '' );
		}	
		
		/**
		 * Разбивает строку на части использу шаблон.
		 * 
		 * @param pattern шаблон разбития.
		 * @param string строка, которую нужно разбить.
		 * @return разбитый массив.
		 */
		public static function explode( pattern:*, string:String ):Array
		{
			return string.split( pattern );
		}
		
		/**
		 * Если <code>string</code> строка, тогда проверяется входит ли буква <code>letter</code> в строку <code>string</code>.
		 * Если <code>string</code> массив, тогда проверяется входит ли строка <code>letter</code> в массив <code>string</code>.
		 * 
		 * @param letter буква или строка, которую нужно искать
		 * @param строка или массив, в котором нужно искать
		 * 
		 * @return true если искомое значение найдено
		 */
		public static function search( letter:String, string:Object ):Boolean
		{
			//Если второй параметр массив.
			if ( string is Array )
			{				
				var array:Array = string as Array;
				for ( var i:int = 0; i < array.length; i++ )
				{
					if ( array[i] == letter )
					{
						return true;
					}
				}			
			}
			else if ( string is String ) 
			{					
				if ( NCLStr.strpos(string as String, letter) > 0 )
				{					
					return true;
				}
				else
				{				
					return false;
				}				
			}			
			return false;			
		}
		
		/**
		 * Если <code>stopAfter</code> = 0, тогда вырезает length последних букв с текущего слова (<code>word</code>)
		 * Если нет, тогда вырезает <code>stopAfter</code> букв начиная от <code>length</code> с конца.
		 * 
		 * @param int length количество букв с конца.
		 * @param int stopAfter количество букв которые нужно вырезать (0 - все)
		 *
		 * @return String требуемая подстрока.
		 */
		public static function last( word:String, length:int = 1, stopAfter:int = 0 ):String
		{
			var cut:int;
			//Сколько букв нужно вырезать все или только часть
			if ( !stopAfter )
			{
				cut = length;
			}
			else
			{
				cut = stopAfter;
			}				
			return NCLStr.substr( word, -length, cut );
		}	
		
		/**
		 * Функция проверяет, входит ли имя <var>nameNeedle</var> в перечень имен <var>$names</var>.
		 * 
		 * @param String nameNeedle - имя которое нужно найти
		 * @param Array names - перечень имен в котором нужно найти имя
		 */
		public static function inNames( nameNeedle:String, names:Array ):Boolean
		{
			for ( var i:int; i < names.length; i++ )
			{
				var value:Boolean = NCLStr.strtolower(nameNeedle) == NCLStr.strtolower(names[i]);
				if ( value )
				{
					return true;
				}
			}
			return false;
		}
		
	}
}