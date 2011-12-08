package by.nickel.namecase 
{
	/**
	 * ...
	 * @author Vitalik Krivtsov aka Nickel
	 */
	public class NameCaseUa extends NCLNameCaseCore 
	{
		/**
		 * @private
		 * Список гласных русского языка.
		 */
		private var vowels:String = "аеёиоуыэюя";
		
		/**
		 * Список согласных украинского языка
		 * @param String  
		 */
		private var consonant:String = "бвгджзйклмнпрстфхцчшщ";
		
		/**
		 * Українські шиплячі приголосні.		
		 */
		private var shyplyachi:String = "жчшщ";
   
		/**
		 * Українські нешиплячі приголосні
		 */
		private var neshyplyachi:String = "бвгдзклмнпрстфхц";
   
		/**
		 * Українські завжди м’які звуки.      
		 */
		private var myaki:String = 'ьюяєї';
    
		/**
		 * Українські губні звуки
		 */
		private var gubni:String = 'мвпбф';
	
		/**
		 * Cons.
		 */
		public function NameCaseUa( ) 
		{
			CaseCount = 7;
			
		}
		
		/**
		 * Чергування українських приголосних
		 * Чергування г к х — з ц с.
		 * 
		 * @param String letter літера, яку необхідно перевірити на чергування
		 * @return String літера, де вже відбулося чергування
		 */
		private function inverseGKH( letter:String ):String
		{
			switch( letter )
			{
				case 'г':
					return 'з';
				case 'к':
					return 'ц';
				case 'х': 
					return 'с';
			}
			return letter;			
		}
		
		/**
		 * Перевіряє чи символ є апострофом чи не є.
		 * 
		 * @param String char симпол для перевірки.
		 * @return Boolean true якщо символ є апострофом 
		 */
		private function isApostrof( char:String ):Boolean
		{			
			var string:String = ' ' + consonant + vowels;
			
			if ( NCLStr.search(char, string) )
			{
				return false;
			}
			return true;
		}	
		/**
		 * Чергування українських приголосних.
		 * Чергування г к — ж ч.
		 * 
		 * @param String letter літера, яку необхідно перевірити на чергування
		 * @return String літера, де вже відбулося чергування 
		 */
		private function inverse2( letter:String ):String
		{
			switch( letter )
			{
				case 'к':
					return 'ч';
				case 'г':
					return 'ж';
			}
			return letter;			
		}
		
		/**
		 * <b>Визначення групи для іменників 2-ї відміни</b>
		 * 1 - тверда
		 * 2 - мішана
		 * 3 - м’яка
		 * 
		 * <b>Правило:</b>
		 * - Іменники з основою на твердий нешиплячий належать до твердої групи: 
		 *   береза, дорога, Дніпро, шлях, віз, село, яблуко.
		 * - Іменники з основою на твердий шиплячий належать до мішаної групи: 
		 *   пожеж-а, пущ-а, тиш-а, алич-а, вуж, кущ, плющ, ключ, плече, прізвище.
		 * - Іменники з основою на будь-який м'який чи пом'якше­ний належать до м'якої групи: 
		 *   земля [земл'а], зоря [зор'а], армія [арм'ійа], сім'я [с'імйа], серпень, фахівець, 
		 *   трамвай, су­зір'я [суз'ірйа], насіння [насін'н'а], узвишшя Іузвиш'ш'а
		 *
		 * @param String word іменник, групу якого необхідно визначити
		 * @return int номер групи іменника 
		 */
		private function detect2Group( word:String ):int
		{
			var osnova:String = word;
			var stack:Array = [];
			//Ріжемо слово поки не зустрінемо приголосний і записуемо в стек всі голосні які зустріли
			while ( NCLStr.search(NCLStr.substr(osnova, -1, 1), vowels + 'ь') )
			{
				stack.push( NCLStr.substr(osnova, -1, 1) );	
				osnova = NCLStr.substr(osnova, 0, NCLStr.strlen(osnova) - 1 );
			}      
            
			var stackLength:int = stack.length;
			//нульове закінчення.
			var last:String = 'Z'; 			
			if ( stackLength )			
				last = stack[stack.length - 1];
			var osnovaEnd:String = NCLStr.substr( osnova, -1, 1 );
      
			if ( NCLStr.search(osnovaEnd, neshyplyachi) && !NCLStr.search(last, myaki) ) 
			{
				return 1;
			}
			else if ( NCLStr.search(osnovaEnd, shyplyachi) && !NCLStr.search(last, myaki) )			
			{
				return 2;
			}			return 3;			        
		}
		
		/**
		 * Шукаємо в слові <var>word</var> перше входження літери 
		 * з переліку <var>vowels</var> з кінця.
		 * 
		 * @param	word слово, якому необхідно знайти голосні.
		 * @param	vowels перелік літер, які треба знайти.
		 * @return
		 */
		private function FirstLastVowel( word:String, vowels:String ):String
		{
			var length:int = NCLStr.strlen( word ) -1;
			for ( var i:int = length; i > 0; i-- )
			{
				var char:String = NCLStr.substr( word, i, 1 );
				if ( NCLStr.search(char, vowels) )
					return char;
			}	
			return '';
		}
		
		/**
		 * 
		 * @param	word
		 * @return
		 */
		private function getOsnova( word:String ):String
		{
			var osnova:String = word;
			//Ріжемо слово поки не зустрінемо приголосний
			while ( NCLStr.search(NCLStr.substr(osnova, -1, 1), vowels + 'ь') )
				osnova = NCLStr.substr( osnova, 0, NCLStr.strlen(osnova) - 1 );
			return osnova; 		
		}
		
		/**
		 * 
		 * @return Boolean true - якщо було задіяно правило з переліку, false - якщо правило не знайдено.
		 */
	    override protected function manRule1( ):Boolean
		{
			//Предпоследний символ
			var beforeLast:String = NCLStr.last( workingWord, 2, 1 );			
			//Останні літера або а
			if ( NCLStr.last(workingWord, 1) == 'а' )
			{
				wordForms( workingWord, [beforeLast + 'и', inverseGKH(beforeLast) + 'і', beforeLast + 'у', beforeLast + 'ою', inverseGKH(beforeLast) + 'і', beforeLast + 'о'], 2 );
				rule = 101;
				return true;
			}
			else if ( NCLStr.last(workingWord, 1) == 'я' )
			{
				//Перед останньою літерою стоїть я
				if ( beforeLast == 'і' )
				{
					wordForms( workingWord, ['ї', 'ї', 'ю', 'єю', 'ї', 'є'], 1);
					rule = 102;
					return true;
				}
				else
				{
					wordForms( workingWord, [beforeLast + 'і', inverseGKH(beforeLast) + 'і', beforeLast + 'ю', beforeLast + 'ею', inverseGKH(beforeLast) + 'і', beforeLast + 'е'], 2);
					rule = 103;
					return true;
				}				
			}
			return false;
		}
			
		/**
		 * 
		 * @return Boolean true - якщо було задіяно правило з переліку, false - якщо правило не знайдено.
		 */
		override protected function manRule2( ):Boolean
		{
			if ( NCLStr.last(workingWord, 1) == 'р' )
			{
				if ( NCLStr.inNames(workingWord, ['Ігор', 'Лазар']) ) 
				{
					wordForms( workingWord, ['я', 'еві', 'я', 'ем', 'еві', 'е']);
					rule = 201;
					return true;
				}
				else
				{
					var osnova:String = workingWord;
					if ( NCLStr.substr(osnova, -2, 1) == 'і' )
						osnova = NCLStr.substr( osnova, 0, NCLStr.strlen(osnova) - 2) + 'о' + NCLStr.substr( osnova, -1, 1 );
					wordForms( osnova, ['а', 'ові', 'а', 'ом', 'ові', 'е'] );
					rule = 202;
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 
		 * @return Boolean true - якщо було задіяно правило з переліку, false - якщо правило не знайдено.
		 */
		override protected function manRule3( ):Boolean
		{
			var beforeLast:String = NCLStr.last( workingWord, 2, 1 );
			if ( NCLStr.search(NCLStr.last(workingWord, 1), consonant + 'оь') )
			{
				var group:int = detect2Group( workingWord );
				var osnova:String = getOsnova( workingWord );
				var osLast:String = NCLStr.substr( osnova, -1, 1 );
				
				if ( osLast != 'й' && NCLStr.substr(osnova, -2, 1) == 'і' && !NCLStr.search(NCLStr.substr(NCLStr.strtolower(osnova), -4, 4), ['світ', 'цвіт']) && !NCLStr.inNames(workingWord,  ['Гліб']) && NCLStr.search(NCLStr.last(workingWord, 2), ['ік', 'іч']) )
					osnova = NCLStr.substr( osnova, 0, NCLStr.strlen(osnova) - 2) + 'о' + NCLStr.substr(osnova, -1, 1);
				if ( NCLStr.substr(osnova, 0, 1) == 'о' && FirstLastVowel(osnova, vowels + 'гк') == 'е' && NCLStr.last(workingWord, 2) != 'сь' ) 
				{
					var delim:int = NCLStr.strpos( osnova, 'е' );
					osnova = NCLStr.substr( osnova, 0, delim ) + NCLStr.substr( osnova, delim + 1, NCLStr.strlen(osnova) - delim );					
				}
				
				if ( group == 1 )
				{
					//Тверда група
					//Слова, що закінчуються на ок.	
					if ( NCLStr.last(workingWord, 2) == 'ок' && NCLStr.last(workingWord, 3) != 'оок' )
					{
						wordForms( workingWord, ['ка', 'кові', 'ка', 'ком', 'кові', 'че'], 2 );
						rule = 301;
						return true;
					}
					else if ( NCLStr.search(NCLStr.last(workingWord, 2), ['ов', 'ев', 'єв']) && !NCLStr.inNames(workingWord, ['Лев', 'Остромов']) )
					{
						wordForms( osnova, [osLast + 'а', osLast + 'у', osLast + 'а', osLast + 'им', osLast + 'у', inverse2(osLast) + 'е'], 1 );
						rule = 302;
						return true;						
					}
					else if ( NCLStr.search(NCLStr.last(workingWord, 2), ['ін']) )
					{
						wordForms( workingWord, ['а', 'у', 'а', 'ом', 'у', 'е'] );		
						rule = 303;
						return true;
					}
					else
					{
						wordForms( osnova, [osLast + 'а', osLast + 'ові', osLast + 'а', osLast + 'ом', osLast + 'ові', inverse2(osLast) + 'е'], 1 );
						rule = 304;
						return true;
					}			
				}
				
				if ( group == 2 ) 
				{
					wordForms( osnova, ['а', 'еві', 'а', 'ем', 'еві', 'е'] );
					rule = 305;
					return true;
				}
				
				if ( group == 3 ) 
				{
					if ( NCLStr.last(workingWord, 2) == 'ей' && NCLStr.search(NCLStr.last(workingWord, 3, 1), gubni) )
					{
						osnova = NCLStr.substr( workingWord, 0, NCLStr.strlen(workingWord) - 2) + '’';	
						wordForms( osnova, ['я', 'єві', 'я', 'єм', 'єві', 'ю'] );
						rule = 306;
						return true;
					}
					else if ( NCLStr.last(workingWord, 1) == 'й' || beforeLast == 'і' )
					{
						wordForms( workingWord, ['я', 'єві', 'я', 'єм', 'єві', 'ю'], 1);
						rule = 307;
						return true;						
					} 
					else if ( workingWord == 'швець' )
					{
						wordForms( workingWord, ['евця', 'евцеві', 'евця', 'евцем', 'евцеві', 'евцю'], 4);
						rule = 308;
						return true;						
					}
					//Слова що закінчуються на ець
					else if ( NCLStr.last(workingWord, 3) == 'ець' )
					{
						wordForms( workingWord, ['ця', 'цеві', 'ця', 'цем', 'цеві', 'цю'], 3);
						rule = 309;
						return true;						
					}
					//Слова що закінчуються на єць яць
					else if ( NCLStr.search(NCLStr.last(workingWord, 3), ['єць', 'яць']) )
					{
						wordForms( workingWord, ['йця', 'йцеві', 'йця', 'йцем', 'йцеві', 'йцю'], 3);
						rule = 310;
						return true;						
					}
					else
					{
						wordForms( workingWord, ['я', 'еві', 'я', 'ем', 'еві', 'ю'], 3);
						rule = 311;
						return true;						
					}
				}
			}
			return false;			
		}
		
		/**
		 * 
		 * @return Boolean true - якщо було задіяно правило з переліку, false - якщо правило не знайдено.
		 */
		override protected function manRule4( ):Boolean
		{
			if ( NCLStr.last(workingWord, 1) == 'і' )
			{
				wordForms( workingWord, ['их', 'им', 'их', 'ими', 'их', 'і'], 1);
				rule = 4;
				return true;				
			}
			return false;
		}
		
		/**
		 * 
		 * @return Boolean true - якщо було задіяно правило з переліку, false - якщо правило не знайдено.
		 */
		override protected function manRule5( ):Boolean
		{
			if ( NCLStr.search(NCLStr.last(workingWord, 2), ['ий', 'ой']) )
			{
				wordForms( workingWord, ['ого', 'ому', 'ого', 'им', 'ому', 'ий'], 2);
				rule = 5;
				return true;				
			}
			return false;			
		}
		
		/**
		 * 
		 * @return
		 */
		override protected function womanRule1( ):Boolean
		{
			var osnova:String;
			//Предпоследний символ
			var beforeLast:String = NCLStr.last( workingWord, 2, 1 ); 	
			 //Якщо закінчується на ніга - нога
			if ( NCLStr.last(workingWord, 4) == 'ніга' )
			{
				osnova = NCLStr.substr( workingWord, 0, NCLStr.strlen(workingWord) - 3) + 'о';
				wordForms( osnova, ['ги', 'зі', 'гу', 'гою', 'зі', 'го'] );
				rule = 101;
				return true;				
			}
			else if ( NCLStr.last(workingWord, 1) == 'а' )
			{
				wordForms( workingWord, [beforeLast + 'и', inverseGKH(beforeLast) + 'і', beforeLast + 'у', beforeLast + 'ою', inverseGKH(beforeLast) + 'і', beforeLast + 'о'], 2 );
				rule = 102
				return true;
			}
			else if ( NCLStr.last(workingWord, 1) == 'я' )
			{
				if ( NCLStr.search(beforeLast, vowels) || isApostrof(beforeLast) )
				{
					wordForms( workingWord, ['ї', 'ї', 'ю', 'єю', 'ї', 'є'], 1 );
					rule = 103;
					return true;					
				}
				else
				{
					wordForms( workingWord, [beforeLast + 'і', inverseGKH(beforeLast) + 'і', beforeLast + 'ю', beforeLast + 'ею', inverseGKH(beforeLast) + 'і', beforeLast + 'е'], 2 );
					rule = 104;
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 
		 * @return
		 */
		override protected function womanRule2( ):Boolean
		{
			if ( NCLStr.search(NCLStr.last(workingWord, 1), consonant + 'ь') ) 
			{
				var osnova:String = getOsnova( workingWord );
				var apostrof:String = '';
				var duplicate:String = '';
				var osLast:String = NCLStr.substr( osnova, -1, 1 );
				var osBeforeLast:String = NCLStr.substr( osnova, -2, 1 );
				//Чи треба ставити апостроф
				if ( NCLStr.search(osLast, 'мвпбф') && NCLStr.search(osBeforeLast, vowels) ) 
					apostrof = '’';				
				//Чи треба подвоювати
				if ( NCLStr.search(osLast, 'дтзсцлн') )
					duplicate = apostrof;
				 //Відмінюємо
				if ( NCLStr.last(workingWord, 1) == 'ь' )
				{
					wordForms( osnova, ['і', 'і', 'ь', duplicate + apostrof + 'ю', 'і', 'е'] );
					rule = 201
					return true;					 
				}
				else
				{
					wordForms( osnova, ['і', 'і', '', duplicate + apostrof + 'ю', 'і', 'е'] );
					rule = 202;
					return true;					
				}				
			}
			return false;			
		}
		
		/**
		 * 
		 * @return
		 */
		override protected function womanRule3( ):Boolean
		{
			var beforeLast:String = NCLStr.last( workingWord, 2, 1 ); 
			if ( NCLStr.last(workingWord, 2) == 'ая' )
			{
				wordForms( workingWord, ['ої', 'ій', 'ую', 'ою', 'ій', 'ая'], 2 );
				rule = 301;
				return true;				
			}
			
			if ( NCLStr.last(workingWord, 1) == 'а' && NCLStr.search(NCLStr.last(workingWord, 2, 1), 'чнв') || NCLStr.search(NCLStr.last(workingWord, 3, 2),['ьк']) )
			{
				wordForms( workingWord, [beforeLast + 'ої', beforeLast + 'ій', beforeLast + 'у', beforeLast + 'ою', beforeLast + 'ій', beforeLast + 'о'], 2 );
				rule = 302;
				return true;				
			}
			return false;
		}
		
		/**
		 * 
		 * @return Boolean
		 */
		override protected function manFirstName( ):Boolean
		{
			return RulesChain( 'man', [1,2,3] );
		}
		
		/**
		 * 
		 * @return Boolean
		 */
		override protected function womanFirstName( ):Boolean
		{
			return RulesChain( 'woman', [1,2] );
		}
		
		/**
		 * 
		 * @return Boolean
		 */
		override protected function manSecondName( ):Boolean
		{
			return RulesChain( 'man', [5, 1, 2, 3, 4] );			
		}
		
		/**
		 * 
		 * @return Boolean
		 */
		override protected function womanSecondName( ):Boolean
		{
			return RulesChain( 'woman', [3, 1] );			
		}
		
		/**
		 * 
		 * @return Boolean
		 */
		override protected function manFatherName( ):Boolean
		{
			if ( NCLStr.search(NCLStr.last(workingWord, 2), ['ич', 'іч']) )
			{
				wordForms( workingWord, ['а', 'у', 'а', 'ем', 'у', 'у'] );
				return true;				
			}
			return false;
		}
		
		/**
		 * 
		 * @return Boolean
		 */
		override protected function womanFatherName( ):Boolean
		{
			if ( NCLStr.search(NCLStr.last(workingWord, 3), ['вна']) )
			{
				wordForms( workingWord, ['и', 'і', 'у', 'ою', 'і', 'о'], 1 );
				return true;				
			}
			return false;			
		}
		
		/**
		 * 
		 */
		override protected function prepareGender( ):void
		{	
			for each ( var word:NCLNameCaseWord in words )
			{
				switch( word.namePart )
				{
					case 'N':
						genderByFirstName( word );
						break;
					case 'F':
						genderByFatherName( word );
						break;
					case 'S':
						genderBySecondName( word );
						break;					
				}				
			}			
		}
		
		/**
		 * Визначення статі, за правилами імені.
		 * 
		 * @param word об’єкт класу зі словом, для якого необхідно визначити стать.
		 */ 
		protected function genderByFirstName( word:NCLNameCaseWord ):void
		{
			var man:Number = 0;
			var woman:Number = 0;			
			//Попробуем выжать максимум из имени
			//Если имя заканчивается на й, то скорее всего мужчина
			if ( NCLStr.last(workingWord, 1) == 'й')
			{
				man += 0.9;
			}

			if ( NCLStr.inNames(workingWord, ['Петро', 'Микола']) )
			{
				man += 30;
			}

			if ( NCLStr.search(NCLStr.last(workingWord, 2), ['он', 'ов', 'ав', 'ам', 'ол', 'ан', 'рд', 'мп', 'ко', 'ло']))
			{
				man += 0.5;
			}

			if ( NCLStr.search(NCLStr.last(workingWord, 3), ['бов', 'нка', 'яра', 'ила', 'опа']))
			{
				woman += 0.5;
			}
			
			if ( NCLStr.search(NCLStr.last(workingWord, 1), consonant))
			{
				man += 0.01;
			}

			if ( NCLStr.last(workingWord, 1) == 'ь' )
			{
				man += 0.02;
			}
			
			if ( NCLStr.search(NCLStr.last(workingWord, 2), ['дь']))
			{
				woman += 0.1;
			}
			
			if ( NCLStr.search(NCLStr.last(workingWord, 3), ['ель', 'бов']))
			{
				woman += 0.4;
			}
			word.gender = Math.max( woman, man );        
		}
		
		/**
		 * Визначення статі, за правилами по-батькові.
		 * 
		 * @param word об’єкт класу зі словом, для якого необхідно визначити стать.
		 */ 
		protected function genderByFatherName( nameCaseWord:NCLNameCaseWord ):void
		{			 
			if ( NCLStr.last(nameCaseWord.word, 2) == 'ич' )
			{
				nameCaseWord.gender = NCL.MAN;; // мужчина
			}
			if ( NCLStr.last(nameCaseWord.word, 2) == 'на' )
			{
				nameCaseWord.gender = NCL.WOMAN;// женщина
			}			
		}
		
		/**
		 * Визначення статі, за правилами по-батькові.
		 * 
		 * @param	word об’єкт класу зі словом, для якого необхідно визначити стать.
		 */ 
		protected function genderBySecondName( word:NCLNameCaseWord ):void
		{
			var man:Number = 0; //Мужчина
			var woman:Number = 0; //Женщина

			if ( NCLStr.search(NCLStr.last(workingWord, 2), ['ов', 'ин', 'ев', 'єв', 'ін', 'їн', 'ий', 'їв', 'ів', 'ой', 'ей']))
			{
				man += 0.4;
			}
			
			if ( NCLStr.search(NCLStr.last(workingWord, 3), ['ова', 'ина', 'ева', 'єва', 'іна', 'мін']))
			{
				woman += 0.4;
			}
			
			if ( NCLStr.search(NCLStr.last(workingWord, 2), ['ая']))
			{
				woman += 0.4;
			}
			
			var max:Number = Math.max( man, woman );
			if ( max == man )
			{				
				word.gender = 1;
			}
			else if ( max == woman )
			{
				word.gender = 2;
			}
		}
		
		override protected function detectNamePart( nameCaseWord:NCLNameCaseWord ):void
		{		
			var word:String = nameCaseWord.word;
			//var length:int = NCLStr.strlen( word );					
			//Считаем вероятность
			var first:Number = 0;
			var second:Number = 0;
			var father:Number = 0;		
			
			//Eсли смахивает на отчество
			if ( NCLStr.search(NCLStr.last(word, 3), ['вна', 'чна', 'ліч']) || NCLStr.search(NCLStr.last(word, 4), ['ьмич', 'ович'] ) ) 
				father += 3;		
			//Похоже на имя
			if ( NCLStr.search(NCLStr.last( word, 3), ['тин']) || NCLStr.search(NCLStr.last(word, 4), ['ьмич', 'юбов', 'івна', 'явка', 'орив', 'кіян']) )							
				first += 0.5;					
			//Исключения
			if ( NCLStr.inNames( word, ['Лев', 'Гаїна', 'Афіна', 'Антоніна', 'Ангеліна', 'Альвіна', 'Альбіна', 'Аліна', 'Павло', 'Олесь', 'Микола', 'Мая', 'Англеліна', 'Елькін', 'Мерлін']) )			
				first += 10;
			 //похоже на фамилию	
			if ( NCLStr.search(NCLStr.last(word, 2), ['ов', 'ін', 'ев', 'єв', 'ий', 'ин', 'ой', 'ко', 'ук', 'як', 'ца', 'их', 'ик', 'ун', 'ок', 'ша', 'ая', 'га', 'єк', 'аш', 'ив', 'юк', 'ус', 'це', 'ак', 'бр', 'яр', 'іл', 'ів', 'ич', 'сь', 'ей', 'нс', 'яс', 'ер', 'ай', 'ян', 'ах', 'ць', 'ющ', 'іс', 'ач', 'уб', 'ох', 'юх', 'ут', 'ча', 'ул', 'вк', 'зь', 'уц', 'їн', 'де', 'уз', 'юр', 'ік', 'іч', 'ро']) )
				second += .4;
				
			if ( NCLStr.search(NCLStr.last(word, 3), ['ова', 'ева', 'єва', 'тих', 'рик', 'вач', 'аха', 'шен', 'мей', 'арь', 'вка', 'шир', 'бан', 'чий', 'іна', 'їна', 'ька', 'ань', 'ива', 'аль', 'ура', 'ран', 'ало', 'ола', 'кур', 'оба', 'оль', 'нта', 'зій', 'ґан', 'іло', 'шта', 'юпа', 'рна', 'бла', 'еїн', 'има', 'мар', 'кар', 'оха', 'чур', 'ниш', 'ета', 'тна', 'зур', 'нір', 'йма', 'орж', 'рба', 'іла', 'лас', 'дід', 'роз', 'аба', 'чан', 'ган']) )
				second += .4;	
				
			if ( NCLStr.search(NCLStr.last(word, 4), ['ьник', 'нчук', 'тник', 'кирь', 'ский', 'шена', 'шина', 'вина', 'нина', 'гана', 'гана', 'хній', 'зюба', 'орош', 'орон', 'сило', 'руба', 'лест', 'мара', 'обка', 'рока', 'сика', 'одна', 'нчар', 'вата', 'ндар', 'грій']) )
				second += .4;
				
			if ( NCLStr.last(workingWord, 1) == 'і' ) 
				second += .2;			
			
			var max:Number = Math.max( first, second, father );
			if ( first == max )	
			{				
				nameCaseWord.namePart = 'N';			
			}
			else if ( second == max ) 	
			{				
				nameCaseWord.namePart = 'S';				
			}
			else	
			{				
				nameCaseWord.namePart = 'F';			
			}			
		}
	}

}