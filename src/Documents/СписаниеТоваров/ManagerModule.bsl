Функция Базар_ВремяДокументаПоУмолчанию(Источник) Экспорт
	
	Если ЗначениеЗаполнено(Источник.ИнвентаризацияТоваровНаСкладе) тогда
		Возврат Новый Структура("Часы, Минуты", 23, 30);
	Иначе
		Возврат Новый Структура("Часы, Минуты", 5, 0);
	КонецЕсли;
	
КонецФункции

&Вместо("ПечатьСписаниеТоваров")
Функция Базар_ПечатьСписаниеТоваров(МассивОбъектов, ОбъектыПечати)

	УстановитьПривилегированныйРежим(Истина);
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	СписаниеТоваров.Ссылка КАК Ссылка,
	|	СписаниеТоваров.Номер КАК Номер,
	|	СписаниеТоваров.Дата КАК Дата,
	|	СписаниеТоваров.Дата КАК ДатаНач,
	|	СписаниеТоваров.Дата КАК ДатаКон,
	|	СписаниеТоваров.Организация КАК Организация,
	|	СписаниеТоваров.Склад КАК Склад,
	|	Склады.ТипСклада КАК ТипСклада,
	|	Склады.ТипЦенРозничнойТорговли КАК ТипЦенРозничнойТорговлиСклада,
	|	Склады.Представление КАК ПредставлениеСклада,
	|	СписаниеТоваров.ПодразделениеОрганизации КАК ПодразделениеОрганизации,
	|	ВЫБОР
	|		КОГДА СписаниеТоваров.ПодразделениеОрганизации.НаименованиеПолное ПОДОБНО """"
	|			ТОГДА СписаниеТоваров.ПодразделениеОрганизации.Наименование
	|		ИНАЧЕ СписаниеТоваров.ПодразделениеОрганизации.НаименованиеПолное
	|	КОНЕЦ КАК ПредставлениеПодразделения,
	|	СписаниеТоваров.СуммаДокумента КАК СуммаДокумента,
	|	Константы.ВалютаРегламентированногоУчета КАК ВалютаДокумента,
	|	СписаниеТоваров.Товары.(
	|		НомерСтроки КАК НомерСтроки,
	|		Номенклатура КАК Номенклатура,
	|		Номенклатура.НаименованиеПолное КАК Товар,
	|		ВЫБОР
	|			КОГДА &ДополнительнаяКолонкаПечатныхФормДокументов = ЗНАЧЕНИЕ(Перечисление.ДополнительнаяКолонкаПечатныхФормДокументов.Артикул)
	|				ТОГДА СписаниеТоваров.Товары.Номенклатура.Артикул
	|			ИНАЧЕ СписаниеТоваров.Товары.Номенклатура.Код
	|		КОНЕЦ КАК Код,
	|		КоличествоМест КАК КоличествоМест,
	|		Количество КАК Количество,
	|		ЕдиницаИзмерения.Представление КАК ЕдиницаИзмерения,
	|		Номенклатура.ЕдиницаИзмерения.Наименование КАК ЕдиницаХранения,
	|		Цена КАК Цена,
	|		Сумма КАК Сумма,
	|		Номенклатура.НоменклатурнаяГруппа КАК НоменклатурнаяГруппа
	|	) КАК Товары,
	|	СписаниеТоваров.ВозвратнаяТара.(
	|		НомерСтроки КАК НомерСтроки,
	|		Номенклатура КАК Номенклатура,
	|		Номенклатура.НаименованиеПолное КАК Товар,
	|		ВЫБОР
	|			КОГДА &ДополнительнаяКолонкаПечатныхФормДокументов = ЗНАЧЕНИЕ(Перечисление.ДополнительнаяКолонкаПечатныхФормДокументов.Артикул)
	|				ТОГДА СписаниеТоваров.ВозвратнаяТара.Номенклатура.Артикул
	|			ИНАЧЕ СписаниеТоваров.ВозвратнаяТара.Номенклатура.Код
	|		КОНЕЦ КАК Код,
	|		Количество КАК Количество,
	|		Номенклатура.ЕдиницаИзмерения.Наименование КАК ЕдиницаИзмерения,
	|		Номенклатура.ЕдиницаИзмерения.Наименование КАК ЕдиницаХранения
	|	) КАК ВозвратнаяТара
	|ИЗ
	|	Документ.СписаниеТоваров КАК СписаниеТоваров
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Склады КАК Склады
	|		ПО СписаниеТоваров.Склад = Склады.Ссылка,
	|	Константы КАК Константы
	|ГДЕ
	|	СписаниеТоваров.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	СписаниеТоваров.Дата,
	|	СписаниеТоваров.Ссылка,
	|	НоменклатурнаяГруппа,
	|	Номенклатура
	|ИТОГИ
	|	МИНИМУМ(ДатаНач),
	|	МАКСИМУМ(ДатаКон)
	|ПО
	|	ОБЩИЕ";
	
	ДополнительнаяКолонкаПечатныхФормДокументов = Константы.ДополнительнаяКолонкаПечатныхФормДокументов.Получить();
	Если НЕ ЗначениеЗаполнено(ДополнительнаяКолонкаПечатныхФормДокументов) Тогда
		ДополнительнаяКолонкаПечатныхФормДокументов = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.НеВыводить;
	КонецЕсли;
 	ВыводитьКоды = ДополнительнаяКолонкаПечатныхФормДокументов <> Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.НеВыводить;
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.УстановитьПараметр("ДополнительнаяКолонкаПечатныхФормДокументов", ДополнительнаяКолонкаПечатныхФормДокументов);
	Запрос.Текст = ТекстЗапроса;

	ШапкаИтоги = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб			= Истина;
	ТабличныйДокумент.ОриентацияСтраницы	= ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.КлючПараметровПечати	= "ПАРАМЕТРЫ_ПЕЧАТИ_СписаниеТоваров_Накладная";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.СписаниеТоваров.ПФ_MXL_Накладная");

	Если ШапкаИтоги.Следующий() Тогда

		ДатаНач = ?(ЗначениеЗаполнено(ШапкаИтоги.ДатаНач), ШапкаИтоги.ДатаНач, '00010101');
		ДатаКон = ?(ЗначениеЗаполнено(ШапкаИтоги.ДатаКон), ШапкаИтоги.ДатаКон, '00010101');

		ТаблицаСуммСписанияПоДокументам = БухгалтерскийУчетПереопределяемый.ПолучитьСуммуСписанияАктивов(МассивОбъектов, ДатаНач, ДатаКон);
		СтруктураПоиска = Новый Структура("Регистратор, Номенклатура");

		ПервыйДокумент = Истина;
		Шапка = ШапкаИтоги.Выбрать();
		Пока Шапка.Следующий() Цикл
			ТаблицаТовары = Шапка.Товары.Выгрузить();
			ТаблицаТара   = Шапка.ВозвратнаяТара.Выгрузить();
			
			УчетПоПродажнойСтоимости = (УчетнаяПолитика.СпособОценкиТоваровВРознице(Шапка.Организация, Шапка.Дата) =
				Перечисления.СпособыОценкиТоваровВРознице.ПоПродажнойСтоимости);
			
			Если Не ПервыйДокумент Тогда
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			
			ПервыйДокумент = Ложь;
			// Запомним номер строки, с которой начали выводить текущий документ.
			НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
			
			// Выводим шапку накладной
			ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
			ОбластьМакета.Параметры.Заполнить(Новый Структура("ТекстЗаголовка", ОбщегоНазначенияБПВызовСервера.СформироватьЗаголовокДокумента(Шапка, "Списание товаров")));
			ТабличныйДокумент.Вывести(ОбластьМакета);

			ОбластьМакета = Макет.ПолучитьОбласть("РеквизитыОрганизации");
			ОбластьМакета.Параметры.Заполнить(Шапка);
			СведенияОбОрганизации    = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Шапка.Организация, Шапка.Дата);
			ПредставлениеОрганизации = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "НаименованиеДляПечатныхФорм,");
			ОбластьМакета.Параметры.Заполнить(Новый Структура("ПредставлениеОрганизации", ПредставлениеОрганизации));
			ТабличныйДокумент.Вывести(ОбластьМакета);


			ОбластьНомера = Макет.ПолучитьОбласть("ШапкаТаблицы|НомерСтроки");
			ОбластьКодов  = Макет.ПолучитьОбласть("ШапкаТаблицы|КолонкаКодов");
			ОбластьДанных = Макет.ПолучитьОбласть("ШапкаТаблицы|Данные");

			ТабличныйДокумент.Вывести(ОбластьНомера);
			Если ВыводитьКоды Тогда
				ДанныеЗаполнения = Новый Структура;
				Если ДополнительнаяКолонкаПечатныхФормДокументов = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Артикул Тогда
					ДанныеЗаполнения.Вставить("ИмяКолонкиКодов", "Артикул");
				ИначеЕсли ДополнительнаяКолонкаПечатныхФормДокументов = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Код Тогда
					ДанныеЗаполнения.Вставить("ИмяКолонкиКодов", "Код");
				КонецЕсли;
				ОбластьКодов.Параметры.Заполнить(ДанныеЗаполнения);
				ТабличныйДокумент.Присоединить(ОбластьКодов);
			КонецЕсли;
			
			ТабличныйДокумент.Присоединить(ОбластьДанных);

			ОбластьКолонкаТовар = Макет.Область("Товар");

			Если Не ВыводитьКоды Тогда
				ОбластьКолонкаТовар.ШиринаКолонки = ОбластьКолонкаТовар.ШиринаКолонки + 
													Макет.Область("КолонкаКодов").ШиринаКолонки;
			КонецЕсли;

			ОбластьНомера = Макет.ПолучитьОбласть("Строка|НомерСтроки");
			ОбластьКодов  = Макет.ПолучитьОбласть("Строка|КолонкаКодов");
			ОбластьДанных = Макет.ПолучитьОбласть("Строка|Данные");
			
			Ном = 0;
			СуммаСписанияВсего = 0;
			
			Для каждого СтрокаТаблицыТовары Из ТаблицаТовары Цикл
			
				Ном = Ном + 1;
				
				ДанныеЗаполнения = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(СтрокаТаблицыТовары);
				
				ДанныеЗаполнения.Вставить("НомерСтроки", Ном);
				ОбластьНомера.Параметры.Заполнить(ДанныеЗаполнения);
				ТабличныйДокумент.Вывести(ОбластьНомера);

				Если ВыводитьКоды Тогда
					ОбластьКодов.Параметры.Заполнить(Новый Структура("Артикул", СтрокаТаблицыТовары.Код));
					ТабличныйДокумент.Присоединить(ОбластьКодов);
				КонецЕсли;

				//Определим цену - в случае розницы в продажных ценах - продажную
				Если НЕ УчетПоПродажнойСтоимости И ЗначениеЗаполнено(Шапка.Ссылка.ИнвентаризацияТоваровНаСкладе) тогда
					
					ЦенаСписания = СтрокаТаблицыТовары.Цена;
					Сумма        = ЦенаСписания * СтрокаТаблицыТовары.Количество;
					
				Иначе
					
					Если УчетПоПродажнойСтоимости 
						И Шапка.ТипСклада = Перечисления.ТипыСкладов.НеавтоматизированнаяТорговаяТочка Тогда
						
						ЦенаСписания = СтрокаТаблицыТовары.Цена;
						Сумма        = ЦенаСписания * СтрокаТаблицыТовары.Количество;
						
					ИначеЕсли УчетПоПродажнойСтоимости 
						И Шапка.ТипСклада  = Перечисления.ТипыСкладов.РозничныйМагазин Тогда
						
						ЦенаСписания = Ценообразование.ПолучитьЦенуНоменклатуры(СтрокаТаблицыТовары.Номенклатура, 
							Шапка.ТипЦенРозничнойТорговлиСклада, Шапка.Дата, Шапка.ВалютаДокумента, 1, 1);
						Сумма        = ЦенаСписания * СтрокаТаблицыТовары.Количество;
						
					Иначе
						
						СтруктураПоиска.Вставить("Регистратор", 	Шапка.Ссылка);
						СтруктураПоиска.Вставить("Номенклатура", 	СтрокаТаблицыТовары.Номенклатура);
						НайденныеСтроки = ТаблицаСуммСписанияПоДокументам.НайтиСтроки(СтруктураПоиска);
						
						Если НайденныеСтроки.Количество() = 0 Тогда
							ЦенаСписания = 0;
							Сумма        = 0; 
						Иначе
							СтрокаСуммСписания = НайденныеСтроки[0];
							
							ЦенаСписания = ?(СтрокаСуммСписания.Количество = 0, 0, СтрокаСуммСписания.Сумма / СтрокаСуммСписания.Количество);
							Сумма        = ЦенаСписания * СтрокаТаблицыТовары.Количество;
						КонецЕсли;
					КонецЕсли;
					
				КонецЕсли;
				
				СуммаСписанияВсего = СуммаСписанияВсего + Сумма;
				
				ДанныеЗаполнения.Вставить("Цена", ЦенаСписания);
				ДанныеЗаполнения.Вставить("Сумма", Сумма);
				
				ОбластьДанных.Параметры.Заполнить(ДанныеЗаполнения);
				
				ТабличныйДокумент.Присоединить(ОбластьДанных);
			КонецЦикла;
			
			Для каждого СтрокаТаблицаТара Из ТаблицаТара Цикл
			
				Ном = Ном + 1;
				
				ДанныеЗаполнения = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(СтрокаТаблицаТара);
				ДанныеЗаполнения.Вставить("НомерСтроки", Ном);
				ОбластьНомера.Параметры.Заполнить(ДанныеЗаполнения);
				
				ТабличныйДокумент.Вывести(ОбластьНомера);

				Если ВыводитьКоды Тогда
					ОбластьКодов.Параметры.Заполнить(Новый Структура("Артикул", СтрокаТаблицаТара.Код));
					ТабличныйДокумент.Присоединить(ОбластьКодов);
				КонецЕсли;
				
				ТоварНаименование = СтрЗаменить(НСтр("ru = '%1 (возвратная тара)'"), "%1" ,СтрокаТаблицаТара.Товар);
				ДанныеЗаполнения.Вставить("Товар", ТоварНаименование);
				
				СтруктураПоиска.Вставить("Регистратор", 	Шапка.Ссылка);
				СтруктураПоиска.Вставить("Номенклатура",	СтрокаТаблицаТара.Номенклатура);
				НайденныеСтроки = ТаблицаСуммСписанияПоДокументам.НайтиСтроки(СтруктураПоиска);

				Если НайденныеСтроки.Количество() = 0 Тогда
					ЦенаСписания = 0;
					Сумма        = 0;
				Иначе
					СтрокаСуммСписания = НайденныеСтроки[0];
					
					ЦенаСписания = ?(СтрокаСуммСписания.Количество = 0, 0, СтрокаСуммСписания.Сумма / СтрокаСуммСписания.Количество);
					Сумма        = ЦенаСписания * СтрокаТаблицаТара.Количество;
				КонецЕсли;
				
				СуммаСписанияВсего = СуммаСписанияВсего + Сумма;
				
				ДанныеЗаполнения.Вставить("Цена", ЦенаСписания);
				ДанныеЗаполнения.Вставить("Сумма", Сумма);
				
				ОбластьДанных.Параметры.Заполнить(ДанныеЗаполнения);
				ТабличныйДокумент.Присоединить(ОбластьДанных);
			КонецЦикла;

			// Вывести Итого
			ОбластьНомера = Макет.ПолучитьОбласть("Итого|НомерСтроки");
			ОбластьКодов  = Макет.ПолучитьОбласть("Итого|КолонкаКодов");
			ОбластьДанных = Макет.ПолучитьОбласть("Итого|Данные");

			ТабличныйДокумент.Вывести(ОбластьНомера);
			Если ВыводитьКоды Тогда
				ТабличныйДокумент.Присоединить(ОбластьКодов);
			КонецЕсли;
			
			ОбластьДанных.Параметры.Заполнить(Новый Структура("Всего", ОбщегоНазначенияБПВызовСервера.ФорматСумм(СуммаСписанияВсего)));
			ТабличныйДокумент.Присоединить(ОбластьДанных);

			// Вывести Сумму прописью
			ОбластьМакета = Макет.ПолучитьОбласть("СуммаПрописью");
			
			СуммаПрописью  = ОбщегоНазначенияБПВызовСервера.СформироватьСуммуПрописью(СуммаСписанияВсего, Шапка.ВалютаДокумента);
			КоличествоСтрокВсего = ТаблицаТовары.Количество() + ТаблицаТара.Количество();
			
			ИтоговаяСтрока = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Всего наименований %1, на сумму %2'"), 
				КоличествоСтрокВсего, 
				ОбщегоНазначенияБПВызовСервера.ФорматСумм(СуммаСписанияВсего, Шапка.ВалютаДокумента));
			
			ОбластьМакета.Параметры.Заполнить(Новый Структура("ИтоговаяСтрока, СуммаПрописью", ИтоговаяСтрока, СуммаПрописью));

			ТабличныйДокумент.Вывести(ОбластьМакета);

			// Вывести подписи
			ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			// В табличном документе зададим имя области, в которую был 
			// выведен объект. Нужно для возможности печати покомплектно.
			УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 
				НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
			
		КонецЦикла;
	
	КонецЕсли;

	Возврат ТабличныйДокумент;

КонецФункции