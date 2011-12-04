package by.nickel.namecase 
{
	import by.nickel.namecase.NCLNameCaseCore;
	import by.nickel.namecase.NCLNameCaseWord;
	import by.nickel.namecase.NCLStr;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Vitalik Krivtsov aka Nickel
	 */
	public class NameCaseRu extends NCLNameCaseCore 
	{	
		/**
		 * Список окончаний характерных для фамилий 
		 * По шаблону {letter}, где  любой символ кроме тех, что в {exclude}
		 */		
		private static var SplitSecondExclude:Object = { 'а':'взйкмнпрстфя', 'б':'а', 'в':'аь', 'г':'а', 'д':'ар', 'е':'бвгдйлмня','ё':'бвгдйлмня','ж':'',	'з':'а','и':'гдйклмнопрсфя','й':'ля','к':'аст',	'л':'аилоья', 'м':'аип', 'н':'ат', 'о':'вдлнпря', 'п':'п', 'р':'адикпть', 'с':'атуя', 'т':'аор', 'у':'дмр',	'ф':'аь', 'х':'а', 'ц':'а', 'ч':'',	'ш':'а', 'щ':'','ъ':'',	'ы':'дн', 'ь':'я', 'э':'','ю':'','я':'нс' };
		
		/**
		 * 
		 */
		private static var exception:Object = { 'а':['Анджелкович', 'Атанацкович'], 'б':['Боровняк', ], 'в':['Вешович', 'Войнович', 'Вуксанович', 'Вучкович'], 'д':['Депрерадович', 'Джорджевич'], 'ж':['Живкович', 'Жукович'], 'и':['Ивкович'], 'й':['Йованович', 'Йовович'], 'м':['Малкович', 'Марьянович', 'Милорадович', 'Милутинович', 'Милошевич', 'Милькович', 'Митрович', 'Мичунович', 'Младенович'], 'о':['Обрадович', 'Огневич'], 'п':['Попович'], 'р':['Райкович'], 'с':['Стойкович', 'Стоякович'], 'т':['Тодорович', 'Тривунович', 'Трифунович'], 'ц':['Цветкович'], 'я':['Янкович'] };
		
		/**
		 * @private
		 * Список гласных русского языка.
		 */
		private var vowels:String = 'аеёиоуыэюя';
		
		/**
		 * @private 
		 * Список согласных русского языка.
		 */
		private var consonant:String = 'бвгджзйклмнпрстфхцчшщ';
		
		/**
		 * @private 
		 * Окончания имен/фамилий, который не склоняются.
		 */
		private var ovo:Array = [ 'ово', 'ако', 'аго', 'яго', 'ирь' ];
		
		/**
		 * @private 
		 * Окончания имен/фамилий, который не склоняются.
		 */
		private var ih:Array = [ 'ки', 'их', 'ых', 'ко', 'ло', 'но', 'то' ];	
		
		
		/**
		 * @private
		 */
		public static function get splitSecondExclude( ):Object 
		{
			return SplitSecondExclude;
		}
				
		/**
		 * Cons.
		 */
		public function NameCaseRu( ) 
		{			
			CaseCount = 6;
		}
				
		/**
		 * Мужские имена, оканчивающиеся на любой ь и -й, склоняются
		 * так же, как обычные существительные мужского рода.
		 * 
		 * @return Boolean true если правило было задействовано и false если нет. 
		 */
		override protected function manRule1( ):Boolean
		{			
			if ( NCLStr.search(NCLStr.last(workingWord, 1), 'ьй') )	
			{
				if ( NCLStr.last(workingWord,  2, 1 ) != 'и' )
				{
					wordForms( workingWord, ['я', 'ю', 'я', 'ем', 'е'], 1 );	
					rule = 101;
					return true;
				}
				else
				{
					wordForms( this.workingWord, ['я', 'ю', 'я', 'ем', 'и'], 1 );
					rule = 102;
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Мужские имена, оканчивающиеся на любой твердый согласный, 
		 * склоняются так же, как обычные существительные мужского рода.
		 * 
		 * @return Boolean true если правило было задействовано и false если нет. 
		 */
		override protected function manRule2( ):Boolean
		{
			if ( NCLStr.search(NCLStr.last(workingWord, 1), this.consonant ) )	
			{
				if ( NCLStr.inNames(workingWord, ['Павел']) )
				{
					lastResult = [ 'Павел', 'Павла', 'Павлу', 'Павла', 'Павлом', 'Павле' ];
					rule = 201;
					return true;
				}
				else if ( NCLStr.inNames(workingWord, ['Лев']) )
				{
					lastResult = [ 'Лев', 'Льва', 'Льву', 'Льва', 'Львом', 'Льве' ];	
					rule = 202;
					return true;
				}
                                else if ( NCLStr.search(NCLStr.last(workingWord, 2, 1), 'её' ) ) 
				{
					wordForms( workingWord, [ 'ька', 'ьку', 'ька', 'ьком', 'ьке' ], 2 );					
					rule = 605;
					return true;				
				} 
				else
				{
					wordForms( workingWord, ['а', 'у', 'а', 'ом', 'е'] );
					rule = 203;
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Мужские и женские имена, оканчивающиеся на -а, склоняются, как и любые 
		 * существительные с таким же окончанием.
		 * Мужские и женские имена, оканчивающиеся иа -я, -ья, -ия, -ея, независимо от языка, 
		 * из которого они происходят, склоняются как существительные с соответствующими окончаниями.
		 * 
		 * @return Boolean true если правило было задействовано и false если нет. 
		 */
		override protected function manRule3( ):Boolean
		{
			if ( NCLStr.last(workingWord, 1) == 'а' )
			{
				if ( !NCLStr.search(NCLStr.last(workingWord, 2, 1), 'кшгх') )
				{
					wordForms( this.workingWord, ['ы', 'е', 'у', 'ой', 'е'], 1 );	
					rule = 301;
					return true;
				}
				else
				{
					wordForms( workingWord, ['и', 'е', 'у', 'ой', 'е'], 1 );	
					rule = 302;
					return true;					
				}
			} 
			else if ( NCLStr.last(workingWord, 1) == 'я' )
			{
				wordForms( workingWord, ['и', 'е', 'ю', 'ей', 'е'], 1 );	
				rule = 303;
				return true;			
			}
			return false;
		}	
		
		/**
		 * Мужские фамилии, оканчивающиеся на -ь -й, склоняются так же, 
		 * как обычные существительные мужского рода.
		 * 
		 * @return true если правило было задействовано и false если нет. 
		 */
		override protected function manRule4( ):Boolean
		{
			if ( NCLStr.search(NCLStr.last(workingWord, 1), 'ьй') )
			{
				//Слова типа Воробей
				if ( NCLStr.last(workingWord, 3) == 'бей' )
				{
					wordForms( this.workingWord, ['ья', 'ью', 'ья', 'ьем', 'ье'], 2 );	
					rule = 400;
					return true;
				}
				else if ( NCLStr.last(workingWord, 3, 1) == 'а' || NCLStr.search(NCLStr.last(workingWord, 2, 1), 'ел') )
				{
					this.wordForms( this.workingWord, [ 'я', 'ю', 'я', 'ем', 'е' ], 1 );	
					rule = 401;
					return true;					
				} //Толстой -» ТолстЫм 
				else if (  NCLStr.last(workingWord, 2, 1) == 'ы' || NCLStr.last(workingWord, 3, 1) == 'т' )
				{
					this.wordForms( this.workingWord, [ 'я', 'ю', 'я', 'ем', 'е' ], 1 );	
					rule = 402;
					return true;					
				} //Лесничий
				else if ( NCLStr.last(workingWord, 3) == 'чий' )
				{
					this.wordForms( this.workingWord, [ 'ьего', 'ьему', 'ьего', 'ьим', 'ьем' ], 2 );
					rule = 403;
					return true;
				} 
				else if ( !NCLStr.search(NCLStr.last(workingWord, 2,1), this.vowels) || NCLStr.last(workingWord, 2, 1) == 'и' )
				{
					this.wordForms( this.workingWord, [ 'ого', 'ому', 'ого', 'им', 'ом' ], 2 );
					rule = 404;
					return true;					
				}
				else
				{
					this.makeResultTheSame( )
					rule = 405;
					return true;					
				}
			} 			
			return false;
		}
		
		/**
		 * Мужские фамилии, оканчивающиеся на -к.
		 * 
		 * @return true если правило было задействовано и false если нет. 
		 */
		override protected function manRule5( ):Boolean
		{
			if ( NCLStr.last(workingWord, 1) == 'к' )
			{
				//Если перед слово на ок, то нужно убрать о
				if ( NCLStr.last(workingWord, 2, 1) == 'о' ) 	
				{
					this.wordForms( this.workingWord, [ 'ка', 'ку', 'ка', 'ком', 'ке' ], 2 );
					rule = 501;
					return true;					
				}
				else if ( NCLStr.last(workingWord, 2, 1) == 'е' )
				{
					this.wordForms( this.workingWord, [ 'ька', 'ьку', 'ька', 'ьком', 'ьке' ], 2 );
					rule = 502;
					return true;					
				}
				else
				{
					this.wordForms( this.workingWord, [ 'а', 'у', 'а', 'ом', 'е' ] );
					rule = 503;
					return true;					
				}
			}
			else if ( NCLStr.last(workingWord, 1) == 'ь' )
			{
				wordForms( workingWord, [ 'я', 'ю', 'я', 'ем', 'е' ], 1 );
				rule = 504;
				return true;					
			}
			return false;
		}
		
		/**
		 * Мужские фамили на согласный выбираем ем/ом/ым.
		 * 
		 * @return Boolean true если правило было задействовано и false если нет.
		 */
		override protected function manRule6( ):Boolean
		{
			if ( NCLStr.last(workingWord, 1) == 'ч' )		
			{
				wordForms( this.workingWord, [ 'а', 'у', 'а', 'ем', 'е' ] );
				rule = 601;
				return true;
			}//е перед ц выпадает
			else if ( NCLStr.last(workingWord, 2) == 'ец' ) 
			{
				wordForms( this.workingWord, [ 'ца', 'цу', 'ца', 'цом', 'це' ], 2 );
				rule = 604;
				return true;				
			} 
			else if ( NCLStr.search(NCLStr.last(workingWord, 1), 'цсршмхт') ) 
			{
				wordForms( this.workingWord, [ 'а', 'у', 'а', 'ом', 'е' ] );
				rule = 602;
				return true;									
			}
			else if ( NCLStr.search(NCLStr.last(workingWord, 1), consonant) ) 
			{
				wordForms( this.workingWord, [ 'а', 'у', 'а', 'ым', 'е' ] );
				rule = 603;
				return true;				
			}
			return false;
		}
		
		/**
		 * Мужские фамили на -а -я.
		 * 
		 * @return Boolean true если правило было задействовано и false если нет.  
		 */
		override protected function manRule7( ):Boolean
		{
			if ( NCLStr.last(workingWord, 1) == 'а' )
			{
				//Если основа на ш, то нужно и, ей
				if ( NCLStr.last(workingWord, 2, 1) == 'ш' ) 
				{
					this.wordForms( this.workingWord, [ 'и', 'е', 'у', 'ей', 'е' ], 1 );
					rule = 701;
					return true;						
				} 
				else if ( NCLStr.search(NCLStr.last(workingWord, 2, 1), 'хкг') )
				{
					this.wordForms( this.workingWord, [ 'и', 'е', 'у', 'ой', 'е' ], 1 );
					rule = 702;
					return true;					
				} 
				else 
				{
					this.wordForms( this.workingWord, [ 'ы', 'е', 'у', 'ой', 'е' ], 1 );
					rule = 703;
					return true;					
				}				
			} 
			else if ( NCLStr.last(workingWord, 1) == 'я' )
			{
				this.wordForms( this.workingWord, [ 'ой', 'ой', 'ую', 'ой', 'ой' ], 2 );
				rule = 704;
				return true;				
			}
			return false;			
		}
		
		/**
		 * Не склоняются мужский фамилии.
		 * 
		 * @return Boolean true если правило было задействовано и false если нет.  
		 */
		override protected function manRule8( ):Boolean
		{
			if ( NCLStr.search(NCLStr.last(workingWord, 3), ovo) || NCLStr.search(NCLStr.last(workingWord, 2), this.ih) )
			{				
				rule = 8;
				makeResultTheSame( );
				return true;				
			}
			return false;
		}
		
		/**
		 * Мужские и женские имена, оканчивающиеся на -а, склоняются, 
		 * как и любые существительные с таким же окончанием.
		 * 
		 * @return Boolean
		 */
		override protected function womanRule1( ):Boolean
		{
			if ( NCLStr.last(workingWord, 1) == 'а' && NCLStr.last(workingWord, 2, 1) != 'и' ) 
			{
				if ( !NCLStr.search(NCLStr.last(workingWord, 2, 1), 'шхкг') )
				{
					wordForms( this.workingWord, [ 'ы', 'е', 'у', 'ой', 'е' ], 1 );
					rule = 101;
					return true;					
				}
				else
				{
					if ( NCLStr.last(workingWord, 2, 1) == 'ш' )
					{
						wordForms( workingWord, [ 'и', 'е', 'у', 'ей', 'е' ], 1 );
						rule = 102;
						return true;
					}
					else
					{
						wordForms( workingWord, [ 'и', 'е', 'у', 'ой', 'е' ], 1 );
						rule = 103;
						return true;						
					}
				}
			}
			return false;
		}
		
		/**
		 * Мужские и женские имена, оканчивающиеся иа -я, -ья, -ия, -ея, независимо от языка, 
		 * из которого они происходят, склоняются как существительные с соответствующими окончаниями.
		 * 
		 * @return true если правило было задействовано и false если нет.  
		 */
		override protected function womanRule2( ):Boolean
		{		
			if ( NCLStr.last(workingWord, 1) == 'я' ) 
			{
				if ( NCLStr.last(workingWord, 2, 1) != 'и' )	
				{
					wordForms( this.workingWord, [ 'и', 'е', 'ю', 'ей', 'е' ], 1 );
					rule = 201;
					return true;						
				}
				else
				{
					this.wordForms( this.workingWord, [ 'и', 'и', 'ю', 'ей', 'и' ], 1 );
					rule = 202;
					return true;						
				}
			}
			return false;			
		}
		
		/**
		 * Русские женские имена, оканчивающиеся на мягкий согласный, склоняются, 
		 * как существительные женского рода типа дочь, тень.
		 * 
		 * @return
		 */
		override protected function womanRule3( ):Boolean
		{
			if ( NCLStr.last(workingWord, 1) == 'ь' )	
			{
				wordForms( this.workingWord, [ 'и', 'и', 'ь', 'ью', 'и' ], 1 );
				rule = 3;
				return true;				
			}
			return false;
		}
		
		/**
		 * Женские фамилия, оканчивающиеся на -а -я, склоняются,
		 * как и любые существительные с таким же окончанием.
		 * 
		 * @return
		 */
		override protected function womanRule4( ):Boolean
		{
			if ( NCLStr.last(workingWord, 1) == 'а' )	
			{
				if ( NCLStr.search(NCLStr.last(workingWord, 2, 1), 'гк') )
				{
					wordForms( this.workingWord, [ 'и', 'е', 'у', 'ой', 'е' ], 1 );
					rule = 401;
					return true;					
				}
				else if ( NCLStr.search(NCLStr.last(workingWord, 2, 1), 'ш') )
				{
					this.wordForms( this.workingWord, [ 'и', 'е', 'у', 'ей', 'е' ], 1 );
					rule = 402;
					return true;					
				}
				else
				{
					this.wordForms( this.workingWord, [ 'ой', 'ой', 'у', 'ой', 'ой' ], 1 );
					rule = 403;
					return true;
				}
			}
			else if ( NCLStr.last(workingWord, 1) == 'я' ) 
			{
				this.wordForms( this.workingWord, [ 'ой', 'ой', 'ую', 'ой', 'ой' ], 2 );
				rule = 404;
				return true;				
			}
			return false;
		}
		
		/**
		 * Функция пытается применить цепочку правил для мужских имен.
		 * 
		 * @return Boolean true - если было использовано правило из списка,
		 * false - если правило не было найденым.
		 */
		override protected function manFirstName( ):Boolean
		{		
			return RulesChain( 'man', [1, 2, 3] );			
		}
		
		/**
		 * Функция пытается применить цепочку правил для женских имен.
		 * 
		 * @return Boolean true - если было использовано правило из списка,
		 * false - если правило не было найденым.
		 */
		override protected function womanFirstName( ):Boolean
		{
			return this.RulesChain( 'woman', [1, 2, 3] );			
		}
		
		/**
		 * 
		 * 
		 * @return Boolean true - если было использовано правило из списка,
		 * false - если правило не было найденым.
		 */
		override protected function manSecondName( ):Boolean
		{
			return this.RulesChain( 'man', [8, 4, 5, 6, 7] );			
		}
		
		/**
		 * 
		 * 
		 * @return Boolean true - если было использовано правило из списка,
		 * false - если правило не было найденым.
		 */
		override protected function womanSecondName( ):Boolean
		{
			return this.RulesChain( 'woman', [4] );			
		}
		
		/**
		 * Функция склоняет мужский отчества.
		 * 
		 * @return Boolean true - если слово было успешно изменено, false - если не получилось этого сделать.
		 */
		override protected function manFatherName( ):Boolean
		{
			if ( NCLStr.inNames(workingWord, ['Ильич']) )
			{
				wordForms( workingWord, ['а', 'у', 'а', 'ом', 'е'] );
				return true;
			}
			else if ( NCLStr.last(workingWord, 2) == 'ич' )
			{
				wordForms( workingWord, ['а', 'у', 'а', 'ем', 'е'] );
				return true;				
			}
			return false;
		}
		
		/**
		 * Функция склоняет женские отчества.
		 * 
		 * @return true - если слово было успешно изменено, false - если не получилось этого сделать.
		 */
		override protected function womanFatherName( ):Boolean
		{
			//Проверяем действительно ли отчество
			if ( NCLStr.last(workingWord, 2) == 'на' )
			{
				this.wordForms( this.workingWord, ['ы', 'е', 'у', 'ой', 'е'], 1 );
				return true;				
			}
			return false;
		}
		
		/**
		 * Идетифицирует слово определяе имя это, или фамилия, или отчество 
		 * - <b>N</b> - имя.
		 * - <b>S</b> - фамилия.
		 * - <b>F</b> - отчество.
		 */
		override protected function detectNamePart( nameCaseWord:NCLNameCaseWord ):void
		{			
			var word:String = nameCaseWord.word;
			WorkingWord = word;
							
			//Считаем вероятность
			var firstName:Number = 0;
			var lastName:Number = 0;
			var fatherName:Number = 0;		
						
			/**
			 * Отчества с оканчанием: -вна (Виталиевна, Ивановна, Игоревна и т.д.),
			 * а так же -вич, -ьич (Виталиевич, Иванович, Валерьевич и т.д. ).
			 */			
			if ( NCLStr.search(NCLStr.last(word, 3), ['вна', 'чна']))
			{			
				Gender = 2;
				fatherName += 10;
			}				
						
			/**
			 * 
			 */
			if ( NCLStr.search(NCLStr.last(word, 3), ['вич', 'ьич']) )
			{
				/**
				 * Исключения. Сербские фамилии, которые оканчиваються на -ич. 
				 * Так как в русском языке данные фамилии будут считатся отчеством,
				 * из-за чего будут склонены. В русском языке такие фамилии не склоняются. 
				 */
				var value:String = NCLStr.substr( word, 0, 1 );
				if ( exception[value] )
				{	
					if ( NCLStr.inNames(word, exception[value] as Array) )
					{	
						lastName += 10;						
					}
					else 
					{						
						fatherName += 10;				
					}
				}				
			} 
						
			//var names:String = 'злата, мальвина, антонина, альбина, агриппина, маша, ольга, фаина, екатерина, карина, марина, валентина, кристина, калина, аделина, алина, ангелина, галина, каролина, павлина, полина, элина, мина, нина, ева, ирина'
			//if ( names.search(word) )
				//trace( names );
			
			if ( NCLStr.inNames(word, ['Нинель', 'Амина', 'Яна', 'Янина', 'Виолетта', 'Злата', 'Мальвина', 'Антонина', 'Альбина', 'Агриппина', 'Маша', 'Ольга', 'Фаина', 'Екатерина', 'Карина', 'Марина', 'Валентина', 'Кристина', 'Калина', 'Аделина', 'Алина', 'Ангелина', 'Галина', 'Каролина', 'Павлина', 'Полина', 'Элина', 'Мина', 'Нина', 'Ева', 'Ирина']) )
			{				
				Gender = 2;
				firstName += 10;				
			}
			
			/**
			 * Сербские фамилии.
			 */
			if ( NCLStr.search(NCLStr.last(word, 3), ['сич', 'бич', 'уич', 'нич', 'шич', 'чич', 'гон', 'жич', 'тич', 'вач', 'кич', 'рич']) )//кич
			{
				lastName += 0.5;
			}
						
			/**
			 * Имена с оканчанием -ий (Евгений, Дмитрий, Анатолий и т.д.)
			 * Имена с оканчанием -ей (Андрей, Алексей, Сергей и т.д.)
			 * Имена с оканчанием -ав (Станислав, Владислав, Ярослав и т.д.) 
			 * Имена с оканчанием -на (Полина, Тина, Яна, Янина и т.д.) 
			 * Ласкательные имена с оканчанием -ша. Например, Маша, Наташа, Саша, Миша и т.д.
			 */
			if ( NCLStr.search(NCLStr.last(word, 2), ['ий', 'ав', 'ей', 'ек', 'ёк', 'ок']) )	
			{	
				/**
				 * Возможно, что это фамилия (Муромский, Гайворонский, Садлинский и т.д).
				 */
				if ( NCLStr.last(word, 4) != 'ский' && NCLStr.last(word, 3) != 'бей' )
				{		
					firstName += 0.5;	
				}							
				Gender = NCL.MAN;				
			}
			
			if ( NCLStr.search(NCLStr.last(word, 2), ['ша', 'ия', 'ья']) )
			{
				firstName += 0.5;
				Gender = NCL.WOMAN;				
			}
						
			/**
			 * Ласкательные имена, например Саша, Женя и т.п. 
			 * 
			 * Определить пол в таких именах с фамилиями, оканчивающимся 
			 * на согласные или характерные оканчания, например, -ко 
			 * библиотека не может. Не смотря на это, имя и фамилия будут 
			 * просклонены правильно.
			 * 
			 * Метод genderDetect() в таких случаях использовать не рекомендуется.
			 * По умолчанию будет определьон пол как мужской. 			 * 
			 */
			if ( NCLStr.inNames(word, ['Алеся', 'Ниля', 'Лена', 'Катя', 'Неля', 'Настя', 'Таня', 'Аня', 'Юля', 'Оля']) )
			{				
				Gender = 2;
				firstName += 10;				
			}
			
			if ( NCLStr.search(NCLStr.last(word, 3), ['тин', 'тын']) )
			{
				firstName += 0.5;				
			}
					
			if ( NCLStr.inNames(word, ['Эмиль', 'Льоша','Миша', 'Саша', 'Даня', 'Лев', 'Яков', 'Каллиник', 'Еремей', 'Лазарь', 'Исак', 'Исаак', 'Валентин', 'Константин', 'Мартин', 'Устин', 'Элькин']) )
			{					
				Gender = 1;
				firstName += 10;				
			}
			
			// Армянские имена: -ник, рик, сик, мик. 
			if ( NCLStr.search(NCLStr.last(word, 3), ['ник', 'рик', 'вик', 'сик', 'мик']) )
			{
				firstName += 10;
			}
			
			// Армянские фамилии -ян. 
			if ( NCLStr.search(NCLStr.last(word, 2), ['ян', 'нц']) )
			{
				lastName += 0.4;
			}
			
			//похоже на фамилию
			if ( NCLStr.search(NCLStr.last(word, 2), ['ич', 'ки', 'ов', 'ин', 'ев', 'ёв', 'ый', 'ын', 'ой', 'ко', 'ук', 'як', 'ца', 'их', 'ик', 'ун', 'ок', 'ша', 'ая', 'га', 'ёк', 'аш', 'ив', 'юк', 'ус', 'це', 'ак', 'бр', 'яр', 'де', 'ых', 'уз', 'ец', 'ль']))
			{
				lastName += 0.4;
			}
			
			if ( NCLStr.search(NCLStr.last(word, 3), ['бей', 'ило','ова', 'ева', 'ёва', 'ына', 'тых', 'рик', 'вач', 'аха', 'шен', 'мей', 'арь', 'вка', 'шир', 'бан', 'тин', 'чий', 'ина', 'гай']) )
			{
				lastName += 0.4;
			}
			
			if (NCLStr.search(NCLStr.last(word, 4), ['ский','ьник', 'нчук', 'тник', 'кирь', 'ский', 'шена']))
			{
				lastName += 0.4;
			}   
			
			if ( NCLStr.last(word, 1) != 'a' )
			{
				
			}
			
			var max:Number = Math.max( firstName, lastName, fatherName );
			//trace( 'firstName, lastName, fatherName', firstName, lastName, fatherName, word );
			if ( firstName == max )							
				nameCaseWord.namePart = 'N';			
			else if ( lastName == max )							
				nameCaseWord.namePart = 'S';		
			else								
				nameCaseWord.namePart = 'F';		
			designateGender( );
		}
				
		/**
		 * 
		 */
		protected function genderByFatherName( nameCaseWord:NCLNameCaseWord ):void
		{	
			if ( Gender != 0 )
			{
				nameCaseWord.gender = Gender;
				return;
			}
				
			if ( NCLStr.last(nameCaseWord.word, 2) == 'ич' )
			{
				// мужчина					
				nameCaseWord.gender = 1;
				Gender = 1;
			}
			if ( NCLStr.last(nameCaseWord.word, 2) == 'на' )
			{
				// женщина
				nameCaseWord.gender = 2;	
				Gender = 2;
			}			
		}		
		
		/**
		 * 
		 */
		protected function genderBySecondName( nameCaseWord:NCLNameCaseWord ):void
		{			
			if ( Gender != 0 )
			{
				nameCaseWord.gender = Gender;
				return;
			}
		
			var man:Number = 0;
			var woman:Number = 0;
			var Word:String = nameCaseWord.word;
			
			if ( NCLStr.search(NCLStr.last( Word, 2), ['ов', 'ин', 'ев', 'ий', 'ёв', 'ый', 'ын', 'ой']) )
			{
				man += .4;
			}
			
			if ( NCLStr.search(NCLStr.last(Word, 3), ['ова', 'ина', 'ева', 'ёва', 'ына', 'мин']) )
			{
				woman += .4;
			}
			
			if ( NCLStr.search(NCLStr.last(Word, 2), ['ая']) )
			{
				woman += .4;
			}
			
			var max:Number = Math.max( man, woman );
			if ( max == man )
			{				
				nameCaseWord.gender = Gender = 1;
			}
			else if ( max == woman )
			{
				nameCaseWord.gender = Gender = 2;
			}	
			Gender = Math.max( man, woman );
		}
		
		/**
		 * Определение пола по правилам имен.		
		 */
		protected function genderByFirstName( nameCaseWord:NCLNameCaseWord ):void
		{			
			if ( Gender != 0 )
			{
				nameCaseWord.gender = Gender;
				return;
			}
			
			var man:Number = 0; 
			var woman:Number = 0; 
			var word:String = nameCaseWord.word;
			//Если имя заканчивается на -й, то, скорее всего, мужчина.
			if ( NCLStr.last(word, 1) == 'й' )			
				man += 0.9;			
			
			if ( NCLStr.search(NCLStr.last(word, 2), ['он', 'ов', 'ав', 'ам', 'ол', 'ан', 'рд', 'мп']) )			
				man += 0.3; 
			
			if ( NCLStr.search(NCLStr.last(word, 1), consonant) )			
				man += 0.01;				
			
			if ( NCLStr.last(word, 1) == 'ь' ) 			
				man += 0.02;			
			
			if ( NCLStr.search(NCLStr.last(word, 2), ['вь', 'фь', 'ль']) )			
				woman += 0.1;				
			
			if ( NCLStr.search(NCLStr.last(word, 2), ['ла', 'на']) )			
				woman += 0.04;		
			
			if ( NCLStr.search(NCLStr.last(word, 2), ['то', 'ма']) )			
				man += 0.01;		
			
			if ( NCLStr.search(NCLStr.last(word, 3), ['лья', 'вва', 'ока', 'ука', 'ита']) )			
				man += 0.2;	
			
			if ( NCLStr.search(NCLStr.last(word, 3), ['има']) )			
				woman += 0.15;				
			
			if ( NCLStr.search(NCLStr.last(word, 3), ['рия', 'лия', 'ния', 'сия', 'дра', 'лла', 'кла', 'опа']) )			
				woman += 0.5;		
			
			if ( NCLStr.search(NCLStr.last(word, 4), ['льда', 'фира', 'нина', 'лита', 'алья']) )			
				woman += 0.5;		
			
			if ( NCLStr.inNames( word, ['Вова', 'Павел', 'Игорь']) )			
				man += 10;
				
			var max:Number = Math.max( man, woman );
			if ( max == man )
			{				
			 	nameCaseWord.gender = Gender = NCL.MAN;			
			}
			else
			{								
				nameCaseWord.gender = Gender = NCL.WOMAN;
			}			
		}
		
		/**
		 * 
		 * @param gender
		 */
		private function designateGender( ):void
		{
			for each ( var word:NCLNameCaseWord in words )		
				word.gender = Gender;	
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
	}

}