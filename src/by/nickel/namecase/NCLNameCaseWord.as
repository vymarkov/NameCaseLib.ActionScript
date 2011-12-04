package by.nickel.namecase 
{
	/**
	 * NCLNameCaseWord - класс, который служит для хранения всей информации о каждом слове.
	 * 
	 * @author Vitalik Krivtsov aka Nickel
	 */
	public class NCLNameCaseWord 
	{
		/**
		 * @private 
		 * Слово в нижнем регистре, которое хранится в об’єкте класса.
		 */
		private var Word:String;
		
		/**
		 * @private 
		 * Слово, которое хранится в об’єкте класса.
		 */
		private var OriginalWord:String;
		
		/**
		 * @private
		 * Тип текущей записи (Фамилия/Имя/Отчество)
		 * - <b>N</b> - ім’я
		 * - <b>S</b> - прізвище
		 * - <b>F</b> - по-батькові
		 */
		private var NamePart:String;
		
		/**
		 * Маска больших букв в слове.
		 * 
		 * Содержит информацию о том, какие буквы в слове были большими, а какие мальникими:
		 * - x - маленькая буква
		 * - X - больная буква
		 */
		private var letterMask:Array = [];
		
		/**
		 * @private 
		 * Содержит true, если все слово было в верхнем регистре и false, если не было.
		 */
		private var isUpperCase:Boolean = false;
		
		/**
		 * @private
		 * Массив содержит все падежи слова, полученые после склонения текущего слова.
		 */
		private var NameCases:Array = [];
		
		/**
		 * @private 
		 * Номер правила, по которому было произведено склонение текущего слова.
		 */
		private var Rule:Number = 0;	
		
		/**
		 * @private 
		 * Номер правила, по которому было произведено склонение текущего слова.
		 */
		private var Gender:int = 0;	
				
		/**
		 * Cons. 
		 * Создание нового обьекта со словом <code>word</code>
		 * 
		 * @param word слово
		 */
		public function NCLNameCaseWord( word:String ) 
		{			
			generateMask( word );
			Word = NCLStr.strtolower( word );	
			OriginalWord = word;
		}
		
		/**
		 * Генерирует маску, которая содержит информацию о том, какие буквы в слове были большими, а какие маленькими:
		 * - x - маленькая буква
		 * - X - больная буква
		 * 
		 * @param word слово, для которого генерировать маску.
		 */
		private function generateMask( word:String ):void 
		{
			var letters:Array = NCLStr.splitLetters( word ); 			
			isUpperCase = true;
			
			for ( var i:int = 0; i < letters.length; i++ )
			{
				var value:Boolean = NCLStr.isLowerCase( letters[i] );
				if ( value )
				{
					letterMask.push( 'x' );	
					isUpperCase = false;
				}
				else
				{
					letterMask.push( 'X' );										
				}				
			}					
		}
		
		/**
		 * Возвращает все падежи слова в начальную маску:
		 * - x - маленькая буква
		 * - X - больная буква
		 */
		private function returnMask( ):void
		{		
			if ( isUpperCase )
			{				
				for ( var string:String in NameCases )
					nameCases[string] = NCLStr.strtoupper( nameCases[string] );				
			}
			else 
			{			
				var maskLength:int = letterMask.length;									
				for ( var i:int = 0; i < nameCases.length; i++ )
				{	
					var value:String = nameCases[i] as String;	
					var caseLength:int = NCLStr.strlen( value );
					var max:Number = Math.min( caseLength, maskLength );
					var word:String = '';								
					for ( var j:int = 0; j < max; j++ )
					{						
						var letter:String = NCLStr.substr( value, j, 1 );					
						if ( letterMask[j] == 'X' )						
							letter = NCLStr.strtoupper( letter );						
						word += letter;					
					}
					nameCases[i] = word += NCLStr.substr( value, max, caseLength - maskLength );
				}			
			}
		}
			
		/**
		 * 
		 * @param	number
		 * @return
		 */
		public function getNameCase( caseNum:int ):String
		{
			return nameCases[caseNum];		
		}
		
		/**
		 * Расчитывает и возвращает пол текущего слова.
		 * 
		 * @private 
		 * @return int 
		 */
		public function get gender( ):int 
		{			
			return Gender;
		}
		
		/**
		 * @param value
		 */
		public function set gender( value:int ):void 
		{
			Gender = value;			
		}
		
		/**
		 * @private 
		 */
		public function get namePart( ):String 
		{
			return NamePart;
		}	
		
		/**
		 * @param value
		 */
		public function set namePart( value:String ):void
		{
			NamePart = value;
		}	
				
		/**
		 * @private 
		 */
		public function get word( ):String 
		{
			return Word;
		}
		
		/**
		 * @private 
		 */
		public function get nameCases( ):Array 
		{
			return NameCases;
		}
		
		/**
		 * @private 
		 */
		public function set nameCases( value:Array ):void
		{
			NameCases = value;
			returnMask( );
		}
				
		/**
		 * @private 
		 */
		public function get rule( ):Number 
		{
			return Rule;
		}
		
		public function set rule( value:Number ):void 
		{
			Rule = value;
		}
		
		/**
		 * 
		 */
		public function get originalWord( ):String 
		{
			return OriginalWord;
		}
		
		public function toString( ):String 
		{
			return "[NCLNameCaseWord gender=" + gender + " namePart=" + namePart + " word=" + word + " nameCases=" + nameCases + 
						" rule=" + rule + "]";
		}
		
	}
}