package by.nickel.namecase 
{	
	import by.nickel.namecase.NCL;
	import by.nickel.namecase.NCLNameCaseWord;
	import by.nickel.namecase.NCLStr;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Vitalik Krivtsov aka Nickel
	 */
	internal class NCLNameCaseCore 
	{			
		/**
		 * Версия библиотеки.
		 */
		public static const version:String = '0.0.1'; 
		
		/**
		 * Версия языкового файла.
		 */
		protected var LanguageBuild:String = '11071017';
		
		/**
		 * Переменная, в которую заносится слово с которым сейчас идет работа
		 */
		protected var CaseCount:int = 6;
		
		/**
		 * Переменная, в которую заносится слово с которым сейчас идет работа
		 */
		protected var WorkingWord:String = '';		
		
		/**
		 * Массив содержит результат склонения слова - слово во всех падежах
		 */
		protected var lastResult:Array = [ ];
		
		/**
		 * Массив содержит елементы типа NCLNameCaseWord. Это все слова которые нужно обработать и просклонять
		 */
		protected var Words:Array = [ ];
		
		/**
		 * 
		 */
		protected var Gender:int;
		
		/**
		 * Готовность системы:
		 * - Все слова идентифицированы (известо к какой части ФИО относится слово)
		 * - У всех слов определен пол
		 * Если все сделано стоит флаг true, при добавлении нового слова флаг сбрасывается на false
		 */
		private var ready:Boolean = false;
		
		/**
		 * Если все текущие слова было просклонены и в каждом слове уже есть результат склонения,
		 * тогда true. Если было добавлено новое слово флаг збрасывается на false 
		 */
		private var finished:Boolean = false;
				
		/**
		 * Номер последнего использованого правила, устанавливается методом Rule()
		 */
		private var Rule:int = 0;
				
		/**
		 * Массив содержит информацию о том какие слова из массива Words относятся к
		 * фамилии, какие к отчеству а какие к имени. Массив нужен потому, что при добавлении слов мы не
		 * всегда знаем какая часть ФИО сейчас, поэтому после идентификации всех слов генерируется массив
		 * индексов для быстрого поиска в дальнейшем.
		 */		
		private var index:Object;
		
		
		
		/**
		 * Cons.
		 */
		public function NCLNameCaseCore( ) 
		{
						
		}
		
		/**
		 * Сбрасывает все информацию на начальную. Очищает все слова добавленые в систему.
		 * После выполнения система готова работать с начала. 
		 * 
		 * @return void
		 */
		private function fullReset( ):void
		{	
			Gender = 0;
			Words = [];
			index = { 'N':[], 'F':[], 'S':[] };
			reset( );
			notReady( );			
		}
		
		/**
		 * Метод очищает результаты последнего склонения слова. Нужен при склонении нескольких слов.
		 */
		private function reset( ):void
		{
			Rule = 0;
			lastResult = [];			
		}
		
		/**
		 * Устанавливает флаги о том, что система не готово и слова еще не были просклонены.
		 */
		private function notReady( ):void
		{
			ready = false;
			finished = false;			
		}
		
		/**
		 * Устанавливает номер последнего правила.
		 * 
		 * @param	index номер правила которое нужно установить.
		 */
		//protected function rule( index:int ):void
		//{
			//lastRule = index;
		//}
		
		/**
		 * Устанавливает слово текущим для работы системы. Очищает кеш слова.
		 * @param word слово, которое нужно установить
		 *
		protected function setWorkingWord( word:String ):void
		{
			//Сбрасываем настройки
			reset( );
			//Ставим слово
			workingWord = word;			
		}*/
		
		/**
		 * Если не нужно склонять слово, делает результат таким же как и именительный падеж
		 */
		protected function makeResultTheSame( ):void
		{
			var array:Array = [];
			
			for ( var i:int; i < this.CaseCount; i++ )			
				array[i] = workingWord;
				
			lastResult = array;	
		}	
		
		/**
		 * Над текущим словом (<code>workingWord</code>) выполняются правила в порядке указаном в <code>rulesArray</code>.
		 * <code>gender</code> служит для указания какие правила использовать мужские ('man') или женские ('woman').
		 * 
		 * @param	gender
		 * @param	rulesArray
		 * @return
		 */
		protected function RulesChain( gender:String, rulesArray:Array ):Boolean
		{				
			for ( var i:int = 0; i < rulesArray.length; i++ )
			{
				var ruleID:String = rulesArray[i]; 
				var ruleMethod:String = gender + 'Rule' + ruleID;				
				var value:Boolean = this[ruleMethod]( ); 				
				if ( value )
				{
					return true;
				}
			}
			return false;			
		}		
		
		/**
		 * Склоняет слово <code>word</code>, удаляя из него <code>replaceLast</code> последних букв
		 * и добавляя в каждый падеж окончание из массива <code>endings</code>.
		 *
		 * @param	word слово, к которому нужно добавить окончания.
		 * @param	endings массив окончаний.
		 * @param	replaceLast сколько последних букв нужно убрать с начального слова.
		 */
		protected function wordForms( word:String, endings:Array, replaceLast:int = 0 ):void
		{						
			var result:Array = [workingWord];						
			word = NCLStr.substr( word, 0, NCLStr.strlen(word) - replaceLast );	
			
			for ( var i:int = 1; i < CaseCount; i++ )			
				result[i] = word + endings[i - 1];
				
			lastResult = result;		
		}
		
		/**
		 * В массив <code>Words</code> добавляется новый об’єкт класса NCLNameCaseWord
		 * со словом <code>firstname</code> и пометкой, что это имя.
		 * 
		 * @param firstname имя.
		 * @return 
		 */		
		private function addFirstName( firstName:String ):void
		{			
			var word:NCLNameCaseWord = new NCLNameCaseWord( firstName );
			word.namePart = 'N';
			word.gender = Gender;
			words.push( word );
		}
		
		
		/**
		 * В массив Words добавляется новый обєкт класса NCLNameCaseWord
		 * со словом <code>lastName</code> и пометкой, что это имя.
		 * 
		 * @param lastName имя.
		 * @return void
		 */
		private function addLastName( lastName:String ):void
		{
			var word:NCLNameCaseWord = new NCLNameCaseWord( lastName );
			word.namePart = 'S';
			word.gender = Gender;
			words.push( word );
		}
		
		/**
		 * В массив <code>Words</code> добавляется новый об’єкт класса NCLNameCaseWord
		 * со словом <code>fatherName</code> и пометкой, что это имя.
		 * 
		 * @param fatherName имя.
		 * @return 
		 */
		private function addFatherName( fatherName:String ):void
		{
			var word:NCLNameCaseWord = new NCLNameCaseWord( fatherName );
			word.namePart = 'F';
			word.gender = Gender;
			words.push( word );
		}
		
		/**
		 * Всем словам устанавливается пол, который может иметь следующие значения
		 * - 0 - не определено
		 * - NCL.MAN - мужчина
		 * - NCL.WOMAN - женщина
		 * 
		 * @param gender пол, который нужно установить.
		 * @return
		 *
		public function setGender( gender:int = 0 ):void//NCLNameCaseCore
		{
			//trace( this, "setGender", "Words.length: ", Words.length  );
			//for ( vari:int = 0; i < Words.length; i++ )
			//{
				//Words[i].setTrueGender( gender );
			//}
			//return this;
		}*/
		
		/**
		 * В системy заносится сразу фамилия, имя, отчество.
		 * @param secondName фамилия.
		 * @param firstName имя.
		 * @param fatherName отчество.
		 * @return
		 *
		public function setFullName( secondName:String = "", firstName:String = "", fatherName:String = ""):NCLNameCaseCore
		{
			//this.setFirstName( firstName );
			//this.setSecondName( secondName );
			///this.setFatherName( fatherName );
			return this;			
		}*/
		
		/**
		 * В массив <code>Words</code> добавляется новый об’єкт класса NCLNameCaseWord
		 * со словом <code>firstname</code> и пометкой, что это имя
		 *
		 * @param firstname имя.
		 * @return NCLNameCaseCore
		 */
		//public function setName( firstname:String = '' ):NCLNameCaseCore
		//{
			//return this.setFirstName( firstname );			
		//}
		
		/**
		 * В массив <code>Words</code> добавляется новый об’єкт класса NCLNameCaseWord
		 * со словом <code>secondname</code> и пометкой, что это имя
		 * 
		 * @param secondname фамилия.
		 * @return NCLNameCaseCore.
		 *
		public function setLastName( secondname:String = '' ):NCLNameCaseCore
		{
			return this.setSecondName( secondname );			
		}*/
		
		/**
		 * В массив <code>Words</code> добавляется новый об’єкт класса NCLNameCaseWord
		 * со словом <code>secondname</code> и пометкой, что это имя
		 * 
		 * @param secondname фамилия.
		 * @return NCLNameCaseCore.
		 *
		public function setSirName( secondname:String = '' ):NCLNameCaseCore
		{
			return this.setSecondName( secondname );			
		}*/
		
		/**
		 * Если слово <code>word</code> не идентифицировано, тогда определяется это имя, фамилия или отчество.
		 * 
		 * @param word слово которое нужно идентифицировать.
		 *
		private function prepareNamePart( word:NCLNameCaseWord ):void
		{
			trace( this, '-----------------------------prepareNamePart()' );
			if ( !word.getNamePart() )	
			{
				this.detectNamePart( word );
			}
			trace( this, '-----------------------------prepareNamePart()', word.getNamePart() );
		}*/
		
		/**
		 * Проверяет все ли слова идентифицированы, если нет тогда для каждого определяется это имя, фамилия или отчество.
		 *
		private function prepareAllNameParts( ):void
		{
			trace( this, '----------------------------------prepareAllNameParts()' );
			for ( vari:int; i < Words.length; i++ )
			{
				this.prepareNamePart( Words[i] );
			}			
		}*/
		
		/**
		 * Определяет пол для слова <code>word</code>.
		 * 
		 * @param	word слово для которого нужно определить пол.
		 *
		private function prepareGender( word:NCLNameCaseWord ):void
		{
			trace( "--------------------------------prepareGender( )", "word.gender:", word.gender );
			
			varnamePart:String = word.getNamePart( );
			switch( namePart )
			{
				case 'N':
					this.GenderByFirstName( word );
					break;
				case 'F':
					this.GenderByFatherName( word );
					break;
				case 'S':
					this.GenderBySecondName( word );
					break;					
			}					
		}*/
		
		/**
		 * Для всех слов проверяет определен ли пол, если нет - определяет его.
		 * После этого расчитывает пол для всех слов и устанавливает такой пол всем словам.
		 * 
		 * @return Boolean был ли определен пол.
		 *
		private function solveGender( ):Boolean
		{
			varword:NCLNameCaseWord;
			//Ищем, может где-то пол уже установлен.
			for ( vari:int; i < Words.length; i++ )
			{
				word = Words[i] as NCLNameCaseWord;
				//if ( word.isGenderSolved() )
				//{
					this.setGender( word.gender );
					return true;
				//}
			}
			 //Если нет тогда определяем у каждого слова и потом сумируем
			varman:int = 0;
			varwoman:int = 0;
			
			for ( varj:int; j < Words.length; j++ )
			{
				this.prepareGender( Words[j] as NCLNameCaseWord );
				vargender:Array = word.getGender( );
				man += gender[NCL.MAN];
				woman += gender[NCL.WOMAN];
			}
			
			if ( man > woman )
			{
				this.setGender( NCL.MAN );
			}
			else
			{
				this.setGender( NCL.WOMAN );
			}
			return true;
		}
		*/
		
		/**
		 * Генерируется массив, который содержит информацию о том какие слова из массива <code>Words</code> относятся к
		 * фамилии, какие к отчеству а какие к имени. Массив нужен потому, что при добавлении слов мы не
		 * всегда знаем какая часть ФИО сейчас, поэтому после идентификации всех слов генерируется массив
		 * индексов для быстрого поиска в дальнейшем.
		 */
		private function generateIndex ( ):void
		{
			index = { 'N':[], 'F':[], 'S':[] };
			//this.index = { 'N':[], 'S':[], 'F':[] };
			//for each ( varword:NCLNameCaseWord in Words )
			//{
				//index[0][word.namePart].push( i );
			//}
			
			for ( var i:int = 0; i < Words.length; i++ )
			{
				var word:NCLNameCaseWord = Words[i] as NCLNameCaseWord;
				//varnamepart:String = word.getNamePart( );
				index[word.namePart].push( word.word );				
			}
		}
		
		/**
		 * Выполнет все необходимые подготовления для склонения.
		 * Все слова идентфицируются. Определяется пол.
		 * Обновляется индекс.
		 */
		private function prepareEverything( ):void
		{		
			if ( !ready )	
			{
				prepareAllNameParts( );					
				generateIndex( );
				ready = true;
			}
		}
				
		/**
		 * 
		 */
		private function prepareAllNameParts( ):void
		{
			//trace( "prepareAllNameParts" );
			for each ( var word:NCLNameCaseWord in words )							
				if ( !word.namePart ) {					
					detectNamePart( word );
				}
			if ( !Gender )
				prepareGender( );			
		}
		
		/**
		 * По указаным словам определяется пол человека:
		 * - 0 - не определено
         * - NCL.MAN - мужчина
         * - NCL.WOMAN - женщина
		 */
		private function genderAutoDetect( ):int
		{
			this.prepareEverything( );
			if ( Words[0] )
			{
				return Words[0].gender;
			}
			return 0;
		}
					
		/**
		 * Склоняет слово <code>word</code> по нужным правилам в зависимости от пола и типа слова.
		 * 
		 * @param word слово, которое нужно просклонять.
		 * @return
		 */
		private function wordCase( word:NCLNameCaseWord ):void
		{		
			var gender:String = word.gender == NCL.MAN ? 'man' : 'woman';	
			var namepart:String;
			
			switch( word.namePart )
			{
				case 'F':
					namepart = 'Father';
					break;
				case 'N':
					namepart = 'First';
					break;
				case 'S':
					namepart = 'Second';
					break;					
			}
			
			var method:String = gender + namepart + 'Name';
			//trace( " method: ",  method );
			WorkingWord = word.word;
			
			var result:Boolean;			
			switch( method )
			{
				case 'manFirstName':
					result = manFirstName( );
					break;
				case 'womanFirstName':
					result = womanFirstName( );					
					break;
				case 'manSecondName':
					result = manSecondName( );
					break;
				case 'womanSecondName':
					result = womanSecondName( );
					break;
				case 'manFatherName':
					result = manFatherName( );
					break;
				case 'womanFatherName':
					result = womanFatherName( );
					break;
			}
			
			if ( result )
			{				
				word.nameCases = lastResult;
				word.rule = Rule;
			}
			else
			{				
				word.nameCases = [];			
				for ( var i:int = 0; i < CaseCount; i++ )								
					word.nameCases.push( word.originalWord );				
				word.rule = -1;
			}			
		}
		
		/**
		 * Производит склонение всех слов, который хранятся в массиве <code>Words</code>.
		 */
		protected function AllWordCases( ):void
		{	
			if ( !finished )
			{				
				prepareEverything( );
				
				for each( var word:NCLNameCaseWord in words ) 
					wordCase( word );	
					
				finished = true;
			}				
		}
		
		/**
		 *  Если указан номер падежа <code>number</code>, тогда возвращается строка с таким номером падежа,
		 *  если нет, тогда возвращается массив со всеми падежами текущего слова.
		 * 
		 * @param word слово для котрого нужно вернуть падеж.
		 * @param number номер падежа, который нужно вернуть.
		 * @return массив или строка с нужным падежом.
		 */
		private function getWordCase( word:NCLNameCaseWord, number:int = 0 ):*
		{		
			if ( number == 0 || number < 0 || number > (this.CaseCount - 1) )
			{
				return word.nameCases;
			}
			else
			{
				return word.nameCases[number];
			}
		}
		
		/**
		 * Если нужно было просклонять несколько слов, то их необходимо собрать в одну строку.
	     * Эта функция собирает все слова указаные в <code>indexArray</code>  в одну строку.
		 * 
		 * @param	indexArray индексы слов, которые необходимо собрать вместе.
		 * @param	number номер падежа.
		 * @return либо массив со всеми падежами, либо строка с одним падежом.
		 */
		private function getCasesConnected( indexArray:Array, number:int = 0 ):*
		{
			var readyArr:Array = [];
			
			for ( var i:int = 0; i < indexArray.length; i++ )				
				readyArr[i] = getWordCase( this.Words[i], number );
				
			if ( readyArr.length )
			{
				if ( readyArr[0] is Array )
				{
					//Масив нужно скелить каждый падеж
					var resultArr:Array = [];
					for ( var j:int = 0; j < this.CaseCount; j++ )
					{
						var tmp:Array = [];
						for ( var t:int = 0; t < readyArr.length; t++ )
						{
							tmp.push( readyArr[t][j] );							
						}
						resultArr[j] = tmp.join( ' ' );						
					}
					return resultArr;
				}
				else
				{
					return readyArr.join( ' ' );					
				}
			}
			return '';			
		}	
		
		/**
		 * Функция ставит имя в нужный падеж.
		 * 
		 * Если указан номер падежа <code>number</code>, тогда возвращается строка с таким номером падежа,
		 * если нет, тогда возвращается массив со всеми падежами текущего слова.
		 *
		 * @param number номер падежа.
		 * @return массив или строка с нужным падежом.
		 */
		public function getFirstNameCase( number:int = 0 ):*
		{
			AllWordCases( );			
			return getCasesConnected( index['N'], number );
		}
		
		/**
		 * Функция ставит фамилию в нужный падеж.
		 * 
		 * Если указан номер падежа <code>number</code>, тогда возвращается строка с таким номером падежа,
		 * если нет, тогда возвращается массив со всеми падежами текущего слова.
		 *
		 * @param number номер падежа.
		 * @return массив или строка с нужным падежом.
		 */
		public function getSecondNameCase( number:int = 0 ):*
		{
			AllWordCases( );
			return getCasesConnected( index['S'], number );
		}
		
		/**
		 * Функция ставит отчество в нужный падеж.
		 * 
		 * Если указан номер падежа <code>number</code>, тогда возвращается строка с таким номером падежа,
		 * если нет, тогда возвращается массив со всеми падежами текущего слова.
		 *
		 * @param number номер падежа.
		 * @return массив или строка с нужным падежом.
		 */
		public function getFatherNameCase( number:int = 0 ):*
		{
			AllWordCases( );
			return getCasesConnected( index['F'], number );
		}
				
				
		/**
		 * Склоняет текущие слова во все падежи и форматирует слово по шаблону <code>format</code>
		 * <b>Формат:</b>
		 * - S - Фамилия
		 * - N - Имя
		 * - F - Отчество
		 * 
		 * @param	format
		 * @return
		 */
		private function getFormattedArray( ):Array
		{			
			//return getFormattedArrayHard( );
			
			var result:Array = [];
			
			/*
			varlength:int = NCLStr.strlen( format as String );
			varresult:Array = [];
			varcases:Array = [ { } ];
			cases[0]['S'] = this.getCasesConnected( this.index['S'] );
			cases[0]['N'] = this.getCasesConnected( this.index['N'] );
			cases[0]['F'] = this.getCasesConnected( this.index['F'] );
			
			for ( varcurCase:int = 0; curCase < this.CaseCount; curCase++ )
			{
				varline:String = '';
				for ( vari:int = 0; i < length; i++ )
				{
					varsymbol:String = NCLStr.substr( format as String, i, 1 );
					if ( symbol == 'S' )
					{
						line += cases[0]['S'][curCase];
					}
					else if ( symbol == 'N' )
					{
						line += cases[0]['N'][curCase];
					}
					else if ( symbol == 'F' )
					{
						line += cases[0]['F'][curCase];						
					}
					else
					{
						line += symbol;
					}
				}
				result.push( line );
			}
			*/
			return result;
		}
		
		/**
		 * Склоняет текущие слова во все падежи и форматирует слово по шаблону <code>format</code>
		 * <b>Формат:</b>
		 * - S - Фамилия
		 * - N - Имя
		 * - F - Отчество
		 * 
		 * @param	format
		 * @return
		 */
		private function getFormattedArrayHard( ):Array 
		{
			var result:Array = [];
			//var cases:Object = {};
			/*
			for each ( var word:NCLNameCaseWord in words )
			{
				if (  word.namePart == 'N' ) 									
					cases.firstName = word.nameCases;				
				else if ( word.namePart == 'S' )				
					cases.secondName = word.nameCases;				
				else									
					cases.fatherName = word.nameCases;					
			}
			*/
			
			for ( var caseNum:int; caseNum < CaseCount; caseNum++)
			{
				var line:String = '';
				for each ( var word:NCLNameCaseWord in words )
				{
					line += word.getNameCase( caseNum ) + ' ';  			
				}							
				line = NCLStr.substr( line, 0, NCLStr.strlen(line) -1);
				result.push( line );
			}
			/*
			for ( var i:int = 0; i < CaseCount; i++)
			{
				var line:String = '';
				if ( cases.firstName )
				{					
					line += cases.firstName[i] + ' ';				
				}
				
				if ( cases.secondName )	
				{					
					line += cases.secondName[i] + ' ';
				}
					
				if ( cases.fatherName )
				{
					line += cases.fatherName[i] + ' ';
				}				
				line = NCLStr.substr( line, 0, NCLStr.strlen(line) -1);
				result.push( line );
			}	
			*/
			return result;							
		}		
		
		/** 
		 * Склоняет текущие слова в падеж <code>caseNum</code> и форматирует слово по шаблону <code>format</code>
		 * <b>Формат:</b>
		 * - S - Фамилия
		 * - N - Имя
		 * - F - Отчество
		 * 
		 * @param caseNum
		 * @param format массив с форматом.
		 * @return строка в нужном падеже.
		 */
		private function getFormattedHard( format:Array, caseNum:int = 0 ):String
		{		
			var result:String = '';			
			for each ( var word:NCLNameCaseWord in format )
				result += word.nameCases[caseNum] + ' ';				
			return result;
		}
				
		/**
		 * Склоняет текущие слова в падеж <code>caseNum</code>.
		 * 
		 * @param	caseNum
		 * @param	format
		 * @return
		 */
		private function getFormatted( caseNum:int, format:* = null ):*
		{			
			AllWordCases( );
				
			if ( !caseNum ) 
			{
				return getFormattedArrayHard( );				
			}			
			else if ( format is String )
			{				
				var dictionary:Dictionary = new Dictionary( );				
				for each ( var word:NCLNameCaseWord in words )
					dictionary[word.namePart] = word;
				
				var result:String = format as String;	
				if ( result.search(/N/g) != -1 )										
					result = result.replace( /N/g, dictionary.N.getNameCase(caseNum) );				
					
				if ( format.search(/S/g) != -1 )					
					result = result.replace( /S/g, dictionary.S.getNameCase(caseNum) );					
				
				if ( format.search(/F/g) != -1 )							
					result = result.replace( /F/g, dictionary.F.getNameCase(caseNum) );	
					
				//trace ( "timer2: ", getTimer() - timer );		
				/*
				varlength:int = NCLStr.strlen( format as String );
				varresult:String = '';
				varcaseword:NCLNameCaseWord;
				
				for ( vari:int = 0; i < length; i++ )
				{
					varsymbol:String = NCLStr.substr( format as String, i, 1 );	
					if ( symbol == 'S' || symbol == 'N' || symbol == 'F' )
					{
						trace( "symbol!!!", symbol );
					}
					
					if ( symbol == 'S' )
					{
						caseword = dictionary[symbol] as NCLNameCaseWord;
						result += caseword.nameCases[caseNum];
					}
					else if ( symbol == 'N' )
					{						
						result += ( dictionary[symbol] as NCLNameCaseWord ).nameCases[caseNum];
					}
					else if ( symbol == 'F' )
					{		
						caseword = dictionary[symbol] as NCLNameCaseWord;
						result += caseword.nameCases[caseNum];						
					}
					else
					{
						result += symbol;						
					}
					//trace( '"' + i + '":"', result, symbol );
				}
				*/
				//trace ( "timer2: ", getTimer() - timer );
				return result;
			} 
			else 
			{
				return getFormattedHard( words, caseNum ) as String;
			}
		}
		
		/** 
		 * Разбивает строку <code>fullname</code> на слова и возвращает формат в котором записано имя.
		 * <b>Формат:</b>
		 * - S - Фамилия
		 * - N - Имя
		 * - F - Отчество
		 * 
		 * @param fullname строка, для которой необходимо определить формат.
		 * @return
		 */
		public function getFullNameFormat( fullName:String ):String
		{
			fullReset( );
			splitFullName( fullName );
			
			var format:String = '';
			for ( var i:int; i < words.length; i++ )
			{
				var word:NCLNameCaseWord = words[i] as NCLNameCaseWord; 
				format += word.namePart + ' ';
			}
			return format;			
		}	
		
		/**
		 * Функция ставит отчество <code>fatherName</code> в нужный падеж <code>CaseNumber</code> по правилам пола <code>gender</code>.
		 * Если указан номер падежа <code>CaseNumber</code>, тогда возвращается строка с таким номером падежа,
		 * если нет, тогда возвращается массив со всеми падежами текущего слова.
		 *
		 * @param secondName имя, которое нужно просклонять.
		 * @param CaseNumber номер падежа. 
		 * @param gender пол, который нужно использовать.
		 * @return массив или строка с нужным падежом.
		 */
		public function qFatherName( fatherName:String, caseNumber:int = 0, gender:int = 0):*
		{
			fullReset( );
			Gender = gender;
			addFatherName( fatherName );			
			AllWordCases( );
			return getCasesConnected( index['F'], caseNumber );	
		}
		
		/**
		 * Функция ставит имя <code>firstName</code> в нужный падеж <code>CaseNumber</code> по правилам пола <code>gender</code>.
		 * Если указан номер падежа <code>CaseNumber</code>, тогда возвращается строка с таким номером падежа,
		 * если нет, тогда возвращается массив со всеми падежами текущего слова.
		 *
		 * @param firstName имя, которое нужно просклонять.
		 * @param CaseNumber номер падежа. 
		 * @param gender пол, который нужно использовать.
		 * 
		 * @return массив или строка с нужным падежом.
		 */
		public function qFirstName( firstName:String, caseNumber:int = 0, gender:int = 0 ):*
		{
			fullReset( );
			Gender = gender;
			addFirstName( firstName );				
			AllWordCases( );
			return getCasesConnected( index['N'], caseNumber );	
		}
		
		/**
		 * Функция ставит фамилию <code>firstName</code> в нужный падеж <code>CaseNumber</code> по правилам пола <code>gender</code>.
		 * Если указан номер падежа <code>CaseNumber</code>, тогда возвращается строка с таким номером падежа,
		 * если нет, тогда возвращается массив со всеми падежами текущего слова.
		 *
		 * @param secondName имя, которое нужно просклонять.
		 * @param CaseNumber номер падежа. 
		 * @param gender пол, который нужно использовать.
		 * @return массив или строка с нужным падежом.
		 */
		public function qLastName( lastName:String, 
								   caseNumber:int = 0, 
								   gender:int = 0
								  ):*
		{
			fullReset( );		
			Gender = gender;
			addLastName( lastName );			
			AllWordCases( );
			return getCasesConnected( index['S'], caseNumber );			
		}
		
		/**
		 * Склоняет фамилию <code>secondName</code>, имя <code>firstName</code>,
		 * отчество <code>fatherName</code> в падеж <code>$caseNum</code> по правилам 
		 * пола <code>gender</code> и форматирует результат по шаблону <code>format</code>
		 * <b>Формат:</b>
		 * - S - Фамилия
		 * - N - Имя
		 * - F - Отчество
		 * 
		 * @param secondName фамилия
		 * @param firstName имя
		 * @param fatherName отчество
		 * @param gender пол
		 * @param caseNum номер падежа
		 * @param format формат 
		 * 
		 * @return либо массив со всеми падежами, либо строка.
		 */
		public function qFullName( lastName:String = '', 
								   firstName:String = '',
								   fatherName:String = '', 								   
								   caseNum:int = 0, 
								   gender:int = 0,
								   format:String = "S N F" 
								   ):*
		{
			fullReset( );
			Gender = gender;
			
			addLastName( lastName );	
			addFirstName( firstName );	
			addFatherName( fatherName );
				
			return getFormatted( caseNum, format );
		}
		
		/**
		 * Склоняет ФИО <code>fullname</code> в падеж <code>caseNum</code> по правилам пола <code>gender</code>.
		 * Возвращает результат в таком же формате, как он и был.
		 * 
		 * @param	fullname
		 * @param	caseNum
		 * @param	gender
		 * @return
		 */
		public function q( fullname:String, caseNum:int = 0, gender:int = 0 ):*
		{	
			fullReset( );			
			splitFullName( fullname );			
			
			if ( gender )
				for each ( var word:NCLNameCaseWord in words )
					word.gender = gender;		
			
			return getFormatted( caseNum );
		}
		
		/**
		 * Разбивает строку <code>fullname</code> на слова и возвращает формат в котором записано имя
		 * <b>Формат:</b>
		 * - S - Фамилия
		 * - N - Имя
		 * - F - Отчество
		 * 
		 * @param fullname cтрока, для которой необходимо определить формат.
		 * @return
		 */		
		private function splitFullName( fullname:String ):void
		{			
			var list:Array = fullname.split( ' ' );
			
			for each ( var string:String in list )			
				Words.push( new NCLNameCaseWord(string) );
				
			prepareEverything( );			
		}
		
		/**
		 * Определяет пол человека по ФИО.
		 * 
		 * @param fullname ФИО.
		 * @return пол человека.
		 */
		public function genderDetect( fullname:String ):int
		{
			fullReset( );
			splitFullName( fullname );
			return genderAutoDetect( );
		}
		
		/**
		 * @private
		 * 
		 * @return
		 */
		public function get workingWord( ):String
		{
			return WorkingWord;
		}
		
		/**
		 * Возвращает внутренний массив Words, каждая запись имеет тип NCLNameCaseWord.
		 * 
		 * @return
		 */
		public function get words( ):Array
		{
			return Words;
		}
		
		
		/**
		 * Возвращает версию библиотеки.
		 * 
		 * @return String версия библиотеки
		 */
		public function get version( ):String
		{
			return NCLNameCaseCore.version;
		}
		
		/**
		 * Возвращает версию использованого языкового файла.
		 * 
		 * @return String версия языкового файла.
		 */
		public function get languageVersion( ):String
		{
			return LanguageBuild;
		}
		
		/**
		 * @private
		 */
		public function get rule( ):int 
		{
			return Rule;
		}
		
		/**
		 * @private
		 * 
		 * @param value
		 */
		public function set rule( value:int ):void
		{
			Rule = value;
		}
		
		/**
		 * Определяет пол для слова.
		 */
		protected function prepareGender( ):void
		{	
			
		}
		
		/**
		 * Функция пытается применить цепочку правил для мужских имен.
		 */
		protected function manFirstName( ):Boolean
		{
			return false;
		}
		
		/**
		 * Функция пытается применить цепочку правил для женских имен.
		 */
		protected function womanFirstName( ):Boolean
		{
			return false;
		}
		
		/**
		 * Функция пытается применить цепочку правил для мужских фамилий.
		 */
		protected function manSecondName( ):Boolean
		{
			return false;
		}
		
		/**
		 * Функция пытается применить цепочку правил для женских фамилий.
		 * 
		 * @return
		 */
		protected function womanSecondName( ):Boolean
		{
			return false;
		}
		
		/**
		 * Функция склоняет мужский отчества.
		 * 
		 * @return
		 */
		protected function manFatherName( ):Boolean
		{
			return false;
		}
		
		/**
		 * Функция склоняет женские отчества.
		 * 
		 * @return
		 */
		protected function womanFatherName( ):Boolean
		{
			return false;
		}
				
		/**
		 * 
		 * @return Boolean
		 */
		protected function manRule1( ):Boolean
		{
			return false;
		}
		
		/**
		 * 
		 * @return Boolean
		 */
		protected function manRule2( ):Boolean
		{
			return false;
		}
		
		/**
		 * 
		 * @return Boolean
		 */
		protected function manRule3( ):Boolean
		{
			return false;
		}
		
		/**
		 * 
		 * @return Boolean
		 */
		protected function manRule4( ):Boolean
		{
			return false;
		}
		
		/**
		 * 
		 * @return
		 */
		protected function manRule5( ):Boolean
		{
			return false;
		}
		
		/**
		 * 
		 * @return
		 */
		protected function manRule6( ):Boolean
		{
			return false;
		}
		
		/**
		 * 
		 * @return
		 */
		protected function manRule7( ):Boolean
		{
			return false;
		}
		
		/**
		 * 
		 * @return
		 */
		protected function manRule8( ):Boolean
		{
			return false;
		}
		
		/**
		 * 
		 * @return
		 */
		protected function womanRule1( ):Boolean
		{
			return false;			
		}
		
		/**
		 * 
		 * @return
		 */
		protected function womanRule2( ):Boolean
		{
			return false;			
		}
		
		/**
		 * 
		 * @return
		 */
		protected function womanRule3( ):Boolean
		{
			return false;			
		}
		
		/**
		 * 
		 * @return
		 */
		protected function womanRule4( ):Boolean
		{
			return false;			
		}	
		
		/**
		 * 
		 */
		protected function detectNamePart( word:NCLNameCaseWord ):void
		{
			
		}	
		
		public function getValue( name:String ):*
		{
			return this[name];
		}
	}

}