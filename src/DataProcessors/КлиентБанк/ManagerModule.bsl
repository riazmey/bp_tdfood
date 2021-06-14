Функция СоздатьКэшВыборокДокументов() Экспорт
	
	ОписаниеТипаОрганизации     = Новый ОписаниеТипов("СправочникСсылка.Организации");
	ОписаниеТипаКонтрагенты     = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
	ОписаниеТипаВидДоговора     = Новый ОписаниеТипов("ПеречислениеСсылка.ВидыДоговоровКонтрагентов");
	ОписаниеТипаВыборка         = Новый ОписаниеТипов("ВыборкаИзРезультатаЗапроса");
	ОписаниеТипаТаблицаЗначений = Новый ОписаниеТипов("ТаблицаЗначений");
	
	ТаблицаЗапросов = Новый ТаблицаЗначений;
	ТаблицаЗапросов.Колонки.Добавить("Организация"         , ОписаниеТипаОрганизации);
	ТаблицаЗапросов.Колонки.Добавить("Контрагент"          , ОписаниеТипаКонтрагенты);
	ТаблицаЗапросов.Колонки.Добавить("ВидДоговора"         , ОписаниеТипаВидДоговора);
	ТаблицаЗапросов.Колонки.Добавить("КэшВыборкиДокументов", ОписаниеТипаВыборка);
	
	Возврат ТаблицаЗапросов;
	
КонецФункции

Функция НайтиДоговорКонтрагента(СтрокаТаблицы, Организация = Неопределено, КэшВыборокДокументов = Неопределено) Экспорт
	
	Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.Контрагент) тогда
		Возврат ПредопределенноеЗначение("Справочник.ДоговорыКонтрагентов.ПустаяСсылка");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) тогда
		Организация = ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка");
	КонецЕсли;
	
	Если КэшВыборокДокументов = Неопределено тогда
		КэшВыборокДокументовЛокально = СоздатьКэшВыборокДокументов();
	Иначе
		Если ТипЗнч(КэшВыборокДокументов) = Тип("ТаблицаЗначений") тогда
			КэшВыборокДокументовЛокально = КэшВыборокДокументов;
		Иначе
			КэшВыборокДокументовЛокально = СоздатьКэшВыборокДокументов();
		КонецЕсли;
	КонецЕсли;
	
	Если СтрокаТаблицы.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийСписаниеДенежныхСредств.ВозвратПокупателю")
	 ИЛИ СтрокаТаблицы.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеДенежныхСредств.ОплатаПокупателя") тогда
		ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПокупателем");
		
	ИначеЕсли СтрокаТаблицы.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеДенежныхСредств.ВозвратОтПоставщика")
	 ИЛИ СтрокаТаблицы.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийСписаниеДенежныхСредств.ОплатаПоставщику") тогда
		ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПоставщиком");
		
	Иначе
		ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.ПустаяСсылка");
		
	КонецЕсли;
	
	ВыборкаДоговоров = ВыборкаВозможныхДоговоров(Организация, СтрокаТаблицы.Контрагент, ВидДоговора);
	НайденыйДоговор  = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
	
	// Если не покупатель и единственный договор тогда успешный возврат
	Если НЕ ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПокупателем")
	И ВыборкаДоговоров.Количество() = 1 тогда
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.Договор) тогда
			ВыборкаДоговоров.Следующий();
			Возврат ВыборкаДоговоров.Ссылка;
		Иначе
			Возврат СтрокаТаблицы.Договор;
		КонецЕсли;
	КонецЕсли;
	
	НайденыйДоговор = НайтиДоговорВНазначенииПлатежаПоНомеруДоговора(СтрокаТаблицы, Организация, ВидДоговора, ВыборкаДоговоров);
	Если ЗначениеЗаполнено(НайденыйДоговор) тогда
		Возврат НайденыйДоговор;
	КонецЕсли;
	
	НайденыйДоговор = НайтиДоговорВНазначенииПлатежаПоНомерамДокументов(СтрокаТаблицы, Организация, ВидДоговора, КэшВыборокДокументовЛокально);
	Если ЗначениеЗаполнено(НайденыйДоговор) тогда
		Возврат НайденыйДоговор;
	КонецЕсли;

	Возврат ПредопределенноеЗначение("Справочник.ДоговорыКонтрагентов.ПустаяСсылка");
	
КонецФункции

Функция НайтиДоговорВНазначенииПлатежаПоНомеруДоговора(СтрокаТаблицы, Организация, ВидДоговора, ВыборкаДоговоров)
	
	СловарьВыражений = Новый Массив;
	СловарьВыражений.Добавить("ДОГОВОР ПОСТАВКИ");
	СловарьВыражений.Добавить("ДОГОВОРА ПОСТАВКИ");
	СловарьВыражений.Добавить("ДОГОВОРУ ПОСТАВКИ");
	СловарьВыражений.Добавить("КОНТРАКТУ");
	СловарьВыражений.Добавить("КОНТРАКТ");
	СловарьВыражений.Добавить("КОНТР");
	СловарьВыражений.Добавить("КОНТ");
	СловарьВыражений.Добавить("КОН-Т");
	СловарьВыражений.Добавить("КОН");
	СловарьВыражений.Добавить("К-Т");
	СловарьВыражений.Добавить("ДОГОВОРА");
	СловарьВыражений.Добавить("ДОГОВОРУ");
	СловарьВыражений.Добавить("ДОГОВОР");
	СловарьВыражений.Добавить("ДОГ.");
	СловарьВыражений.Добавить("ДОГ");
	СловарьВыражений.Добавить("АУКЦИОНА");
	СловарьВыражений.Добавить("АУКЦИОН");
	СловарьВыражений.Добавить("АУК");
	СловарьВыражений.Добавить("Г/К");
	СловарьВыражений.Добавить("ГК");
	
	Для Каждого Выражение из СловарьВыражений цикл
		НайденыйНомер = НайтиНомерОбъектаВНазначенииПлатежаПоВыражению(Выражение, СтрокаТаблицы.НазначениеПлатежа);
		Если ЗначениеЗаполнено(НайденыйНомер) тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(НайденыйНомер) тогда
		Пока ВыборкаДоговоров.Следующий() цикл
			Если СокрЛП(ВРЕГ(ВыборкаДоговоров.НомерДоговора)) = СокрЛП(ВРЕГ(НайденыйНомер)) тогда
				Возврат ВыборкаДоговоров.Ссылка;
			КонецЕсли;
		КонецЦикла;
		НайденыйНомер = "";
	КонецЕсли;
	
	// Если в номере договора присутствуют символы алфавита (А ,Б, В...) или спец символы
	// вроде "точка", с пробелом и без, тогда функция НайтиНомерОбъектаВНазначенииПлатежаПоВыражению
	// не найдет номерв в назначении платежа, в связи с этим попытаемся найти номера договора,
	// посредством перебора договоров, с поиском по вхождению номера в назначении платежа
	ВыборкаДоговоров.Сбросить();
	Пока ВыборкаДоговоров.Следующий() цикл
		Если СтрДлина(ВыборкаДоговоров.НомерДоговора) >= 6 тогда
			Если НЕ Найти(ВРЕГ(СтрокаТаблицы.НазначениеПлатежа), ВРЕГ(ВыборкаДоговоров.НомерДоговора)) = 0 тогда
				Возврат ВыборкаДоговоров.Ссылка;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	// Если покупатель является юридическим лицом и у него нет ни одного договора заключенного по гос. закупкам или это Физическое лицо,
	// тогда считаем что это коммерческая организация, и тогда можно попытаться найти единственный активный (по срокам) договор
	Если ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПокупателем")
	    И (СтрокаТаблицы.Контрагент.ЮридическоеФизическоеЛицо = ПредопределенноеЗначение("Перечисление.ЮридическоеФизическоеЛицо.ЮридическоеЛицо")
		ИЛИ СтрокаТаблицы.Контрагент.ЮридическоеФизическоеЛицо = ПредопределенноеЗначение("Перечисление.ЮридическоеФизическоеЛицо.ФизическоеЛицо")) Тогда
		
		ЭтоКоммерческийПокупатель = Истина;
		Если СтрокаТаблицы.Контрагент.ЮридическоеФизическоеЛицо = ПредопределенноеЗначение("Перечисление.ЮридическоеФизическоеЛицо.ЮридическоеЛицо") тогда
			ВыборкаДоговоров.Сбросить();
			Пока ВыборкаДоговоров.Следующий() цикл
				Если ГосЗакупкиСервер.ЭтоДоговорПоставкиГосЗакупок(ВыборкаДоговоров.Ссылка) тогда
					ЭтоКоммерческийПокупатель = Ложь;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Если ЭтоКоммерческийПокупатель тогда
			ЕдинственныйДоговор = ВыборкаВозможныхДоговоров(Организация,
			                                                СтрокаТаблицы.Контрагент,
			                                                ВидДоговора,
			                                                СтрокаТаблицы.ДатаПроведения);
			
			Если ЕдинственныйДоговор.Количество() = 1 тогда
				ЕдинственныйДоговор.Следующий();
				Возврат ЕдинственныйДоговор.Ссылка;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// Если договор с поставщиком, и не нашли по номеру, тогда попытаемся найти
	// единственный действующий по срокам
	Если ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПоставщиком") Тогда
		ЕдинственныйДоговор = ВыборкаВозможныхДоговоров(Организация,
		                                                СтрокаТаблицы.Контрагент,
		                                                ВидДоговора,
		                                                СтрокаТаблицы.ДатаПроведения);
		
		Если ЕдинственныйДоговор.Количество() = 1 тогда
			ЕдинственныйДоговор.Следующий();
			Возврат ЕдинственныйДоговор.Ссылка;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ПредопределенноеЗначение("Справочник.ДоговорыКонтрагентов.ПустаяСсылка");
	
КонецФункции

Функция НайтиДоговорВНазначенииПлатежаПоНомерамДокументов(СтрокаТаблицы, Организация, ВидДоговора, КэшВыборокДокументов)
	
	Если ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.ПустаяСсылка") тогда
		Возврат ПредопределенноеЗначение("Справочник.ДоговорыКонтрагентов.ПустаяСсылка");
	КонецЕсли;
	
	СловарьВыражений = Новый Массив;
	СловарьВыражений.Добавить("НАКЛАДНАЯ");
	СловарьВыражений.Добавить("НАКЛАДНОЙ");
	СловарьВыражений.Добавить("ПО Н");
	СловарьВыражений.Добавить("НАК");
	СловарьВыражений.Добавить("НАКЛ");
	СловарьВыражений.Добавить("ТН");
	СловарьВыражений.Добавить("Т/Н");
	СловарьВыражений.Добавить("УПД");
	СловарьВыражений.Добавить("СЧ");
	СловарьВыражений.Добавить("СЧЕТ");
	СловарьВыражений.Добавить("СЧЕТА");
	СловарьВыражений.Добавить("СЧЕТУ");
	СловарьВыражений.Добавить("СЧ.Н.");
	СловарьВыражений.Добавить("СЧ,Н.");
	СловарьВыражений.Добавить("СЧ.,Н.");
	СловарьВыражений.Добавить("СФ");
	СловарьВыражений.Добавить("С/Ф");
		
	// Поиск в назначении платежа номера документа "РеализацияТоваровУслуг" или ПоступлениеТоваровУслуг"
	// и при упешном поиске документа, у него получаем договор
	Отборы = Новый Структура;
	Отборы.Вставить("Контрагент" , СтрокаТаблицы.Контрагент);
	Отборы.Вставить("Организация", Организация);
	Отборы.Вставить("ВидДоговора", ВидДоговора);
	
	НайденыеСтрокиКэша = КэшВыборокДокументов.НайтиСтроки(Отборы);	
	Если НайденыеСтрокиКэша.Количество() = 0 Тогда
		
		Запрос = Новый Запрос;
		Для Каждого КлючИЗначение из Отборы цикл
			Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла;
		
		Если ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПокупателем") тогда
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	РеализацияТоваровУслуг.Ссылка КАК Ссылка,
			|	РеализацияТоваровУслуг.Дата КАК Дата,
			|	РеализацияТоваровУслуг.Номер КАК Номер,
			|	РеализацияТоваровУслуг.ДоговорКонтрагента КАК ДоговорКонтрагента
			|ПОМЕСТИТЬ РеализацияТоваровУслуг
			|ИЗ
			|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
			|ГДЕ
			|	РеализацияТоваровУслуг.Контрагент = &Контрагент
			|	И ВЫБОР
			|			КОГДА &Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
			|				ТОГДА ИСТИНА
			|			ИНАЧЕ РеализацияТоваровУслуг.Организация = &Организация
			|		КОНЕЦ
			|	И РеализацияТоваровУслуг.Проведен = ИСТИНА
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	СчетФактураВыданныйДокументыОснования.Ссылка КАК Ссылка,
			|	СчетФактураВыданныйДокументыОснования.Ссылка.Дата КАК Дата,
			|	СчетФактураВыданныйДокументыОснования.Ссылка.Номер КАК Номер,
			|	ВЫРАЗИТЬ(СчетФактураВыданныйДокументыОснования.ДокументОснование КАК Документ.РеализацияТоваровУслуг).ДоговорКонтрагента КАК ДоговорКонтрагента
			|ПОМЕСТИТЬ СчетаФактурыВыданные
			|ИЗ
			|	Документ.СчетФактураВыданный.ДокументыОснования КАК СчетФактураВыданныйДокументыОснования
			|ГДЕ
			|	СчетФактураВыданныйДокументыОснования.Ссылка.Проведен = ИСТИНА
			|	И ВЫБОР
			|			КОГДА &Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
			|				ТОГДА ИСТИНА
			|			ИНАЧЕ СчетФактураВыданныйДокументыОснования.Ссылка.Организация = &Организация
			|		КОНЕЦ
			|	И СчетФактураВыданныйДокументыОснования.Ссылка.Контрагент = &Контрагент
			|
			|СГРУППИРОВАТЬ ПО
			|	СчетФактураВыданныйДокументыОснования.Ссылка,
			|	ВЫРАЗИТЬ(СчетФактураВыданныйДокументыОснования.ДокументОснование КАК Документ.РеализацияТоваровУслуг).ДоговорКонтрагента,
			|	СчетФактураВыданныйДокументыОснования.Ссылка.Номер
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	СчетНаОплатуПокупателю.Ссылка КАК Ссылка,
			|	СчетНаОплатуПокупателю.Дата КАК Дата,
			|	СчетНаОплатуПокупателю.Номер КАК Номер,
			|	СчетНаОплатуПокупателю.ДоговорКонтрагента КАК ДоговорКонтрагента
			|ПОМЕСТИТЬ СчетаНаОплатуПокупателю
			|ИЗ
			|	Документ.СчетНаОплатуПокупателю КАК СчетНаОплатуПокупателю
			|ГДЕ
			|	СчетНаОплатуПокупателю.Проведен = ИСТИНА
			|	И ВЫБОР
			|			КОГДА &Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
			|				ТОГДА ИСТИНА
			|			ИНАЧЕ СчетНаОплатуПокупателю.Организация = &Организация
			|		КОНЕЦ
			|	И СчетНаОплатуПокупателю.Контрагент = &Контрагент
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	РеализацияТоваровУслуг.Ссылка КАК Ссылка,
			|	РеализацияТоваровУслуг.Дата КАК Дата,
			|	РеализацияТоваровУслуг.Номер КАК Номер,
			|	РеализацияТоваровУслуг.ДоговорКонтрагента КАК ДоговорКонтрагента
			|ИЗ
			|	РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	СчетаФактурыВыданные.Ссылка,
			|	СчетаФактурыВыданные.Дата,
			|	СчетаФактурыВыданные.Номер,
			|	СчетаФактурыВыданные.ДоговорКонтрагента
			|ИЗ
			|	СчетаФактурыВыданные КАК СчетаФактурыВыданные
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	СчетаНаОплатуПокупателю.Ссылка,
			|	СчетаНаОплатуПокупателю.Дата,
			|	СчетаНаОплатуПокупателю.Номер,
			|	СчетаНаОплатуПокупателю.ДоговорКонтрагента
			|ИЗ
			|	СчетаНаОплатуПокупателю КАК СчетаНаОплатуПокупателю
			|
			|УПОРЯДОЧИТЬ ПО
			|	Дата,
			|	ДоговорКонтрагента";
			
		ИначеЕсли ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПоставщиком") тогда
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ПоступлениеТоваровУслуг.Ссылка КАК Ссылка,
			|	ПоступлениеТоваровУслуг.Дата КАК Дата,
			|	ПоступлениеТоваровУслуг.НомерВходящегоДокумента КАК Номер,
			|	ПоступлениеТоваровУслуг.ДоговорКонтрагента КАК ДоговорКонтрагента
			|ИЗ
			|	Документ.ПоступлениеТоваровУслуг КАК ПоступлениеТоваровУслуг
			|ГДЕ
			|	ПоступлениеТоваровУслуг.Контрагент = &Контрагент
			|	И ВЫБОР
			|			КОГДА &Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
			|				ТОГДА ИСТИНА
			|			ИНАЧЕ ПоступлениеТоваровУслуг.Организация = &Организация
			|		КОНЕЦ
			|	И ПоступлениеТоваровУслуг.Проведен = ИСТИНА
			|
			|УПОРЯДОЧИТЬ ПО
			|	Дата,
			|	ДоговорКонтрагента";
		КонецЕсли;
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если РезультатЗапроса.Пустой() тогда
			Возврат ПредопределенноеЗначение("Справочник.ДоговорыКонтрагентов.ПустаяСсылка");
		КонецЕсли;
		
		ВыборкаДокументов = РезультатЗапроса.Выбрать();
		
		НоваяСтрокаКэша = КэшВыборокДокументов.Добавить();
		НоваяСтрокаКэша.Организация = Организация;
		НоваяСтрокаКэша.Контрагент = СтрокаТаблицы.Контрагент;
		НоваяСтрокаКэша.ВидДоговора = ВидДоговора;
		НоваяСтрокаКэша.КэшВыборкиДокументов = ВыборкаДокументов;
		
	Иначе
		ВыборкаДокументов = НайденыеСтрокиКэша.Получить(0).КэшВыборкиДокументов;
		ВыборкаДокументов.Сбросить();
		
	КонецЕсли;
	
	Для Каждого Выражение из СловарьВыражений цикл
		НайденыйНомер = НайтиНомерОбъектаВНазначенииПлатежаПоВыражению(Выражение, СтрокаТаблицы.НазначениеПлатежа);
		
		Если ЗначениеЗаполнено(НайденыйНомер) тогда
			
			Пока ВыборкаДокументов.Следующий() цикл
				
				Если ВыборкаДокументов.Дата > КонецДня(СтрокаТаблицы.ДатаПроведения) тогда
					Прервать;
				КонецЕсли;
				
				ПечатныйНомерДокумента = "";
				ЭлектронноеВзаимодействиеПереопределяемый.ПолучитьПечатныйНомерДокумента(ВыборкаДокументов.Ссылка, ПечатныйНомерДокумента);
				
				НомерДокумента = ?(ТипЗнч(ВыборкаДокументов.Ссылка) = Тип("ДокументСсылка.РеализацияТоваровУслуг"), ПечатныйНомерДокумента, СокрЛП(ВыборкаДокументов.Номер));
				
				Если СокрЛП(ВРЕГ(НомерДокумента)) = СокрЛП(ВРЕГ(НайденыйНомер)) тогда
					Возврат ВыборкаДокументов.ДоговорКонтрагента;
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ПредопределенноеЗначение("Справочник.ДоговорыКонтрагентов.ПустаяСсылка");
	
КонецФункции

Функция ВыборкаВозможныхДоговоров(Организация, Контрагент, ВидДоговора, ДатаДокумента = Неопределено)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВидДоговора", ВидДоговора);	
	Запрос.УстановитьПараметр("Контрагент" , Контрагент);
	Запрос.УстановитьПараметр("Организация", Организация);
	Если ДатаДокумента = Неопределено тогда
		Запрос.УстановитьПараметр("ДатаДокумента", Дата(1,1,1,0,0,0));
	Иначе
		Запрос.УстановитьПараметр("ДатаДокумента", ДатаДокумента);
	КонецЕсли;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДоговорыКонтрагентов.Ссылка КАК Ссылка,
	|	ДоговорыКонтрагентов.Номер КАК НомерДоговора
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|ГДЕ
	|	ДоговорыКонтрагентов.Владелец = &Контрагент
	|	И ВЫБОР
	|			КОГДА &Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ДоговорыКонтрагентов.Организация = &Организация
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА &ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.ПустаяСсылка)
	|				ТОГДА НЕ ДоговорыКонтрагентов.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СПоставщиком)
	|						И НЕ ДоговорыКонтрагентов.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СПокупателем)
	|			ИНАЧЕ ДоговорыКонтрагентов.ВидДоговора = &ВидДоговора
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА &ДатаДокумента = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ВЫБОР
	|					КОГДА ДоговорыКонтрагентов.СрокДействия = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|						ТОГДА ЛОЖЬ
	|					ИНАЧЕ ВЫБОР
	|							КОГДА ДоговорыКонтрагентов.НачалоДействия = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|								ТОГДА ВЫБОР
	|										КОГДА ДоговорыКонтрагентов.Дата = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|											ТОГДА ЛОЖЬ
	|										ИНАЧЕ ДоговорыКонтрагентов.Дата <= &ДатаДокумента
	|												И ДоговорыКонтрагентов.СрокДействия >= &ДатаДокумента
	|									КОНЕЦ
	|							ИНАЧЕ ДоговорыКонтрагентов.НачалоДействия <= &ДатаДокумента
	|									И ДоговорыКонтрагентов.НачалоДействия >= &ДатаДокумента
	|						КОНЕЦ
	|				КОНЕЦ
	|		КОНЕЦ";
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

Функция НайтиНомерОбъектаВНазначенииПлатежаПоВыражению(Выражение, Знач НазначениеПлатежа)
	
	НазначениеПлатежа = ВРЕГ(НазначениеПлатежа);
	НайденыйНомер     = "";
	Цифры             = "0123456789";
	
	РазделителиМеждуВыражениемИНомером = Новый Массив;
	РазделителиМеждуВыражениемИНомером.Добавить(" № ");
	РазделителиМеждуВыражениемИНомером.Добавить(" N ");
	РазделителиМеждуВыражениемИНомером.Добавить(" # ");
	РазделителиМеждуВыражениемИНомером.Добавить(" . ");
	РазделителиМеждуВыражениемИНомером.Добавить(" , ");
	РазделителиМеждуВыражениемИНомером.Добавить(" №");
	РазделителиМеждуВыражениемИНомером.Добавить(" N");
	РазделителиМеждуВыражениемИНомером.Добавить(" #");
	РазделителиМеждуВыражениемИНомером.Добавить(" .");
	РазделителиМеждуВыражениемИНомером.Добавить(" ,");
	РазделителиМеждуВыражениемИНомером.Добавить("№ ");
	РазделителиМеждуВыражениемИНомером.Добавить("N ");
	РазделителиМеждуВыражениемИНомером.Добавить("# ");
	РазделителиМеждуВыражениемИНомером.Добавить(". ");
	РазделителиМеждуВыражениемИНомером.Добавить(", ");
	РазделителиМеждуВыражениемИНомером.Добавить(" ");
	РазделителиМеждуВыражениемИНомером.Добавить("№");
	РазделителиМеждуВыражениемИНомером.Добавить("N");
	РазделителиМеждуВыражениемИНомером.Добавить("#");
	РазделителиМеждуВыражениемИНомером.Добавить(".");
	РазделителиМеждуВыражениемИНомером.Добавить(",");
	
	СпецСимволыВНомере = Новый Массив;
	СпецСимволыВНомере.Добавить("/");
	СпецСимволыВНомере.Добавить("\");
	СпецСимволыВНомере.Добавить("-");
	СпецСимволыВНомере.Добавить("_");
	
	Счетчик = 0;
	Пока Счетчик < 100 цикл // Защита от бесконечного цикла
		// Ищем вхождение выражения
		НайденаяПозицияВыражения = Найти(НазначениеПлатежа, Выражение);
		
		// Не нашли выражение - возврат
		Если НайденаяПозицияВыражения = 0 Тогда
			Возврат НайденыйНомер;
		КонецЕсли;
		
		// Если конец строки - возврат
		Если НайденаяПозицияВыражения + СтрДлина(Выражение) - 1 = СтрДлина(НазначениеПлатежа) Тогда
			Возврат НайденыйНомер;
		КонецЕсли;
		
		СледующийСимвол = Сред(НазначениеПлатежа,НайденаяПозицияВыражения + СтрДлина(Выражение), 1);
		
		// Ищем начало номера
		ПервыйСимволНомера = 0;
		Если Найти(Цифры, СледующийСимвол) = 0 тогда
			Для Каждого Разделитель из РазделителиМеждуВыражениемИНомером цикл
				НайденаяПозицияВыраженияСРазделителем = Найти(НазначениеПлатежа, Выражение + Разделитель);
				Если НайденаяПозицияВыраженияСРазделителем <> 0 Тогда
					ПервыйСимволНомера = НайденаяПозицияВыраженияСРазделителем + СтрДлина(Выражение + Разделитель);
					Прервать;
				КонецЕсли;
			КонецЦикла;
		Иначе
			ПервыйСимволНомера = НайденаяПозицияВыражения + СтрДлина(Выражение);
		КонецЕсли;
		
		// Не нашли начало номера - ищем другое пдобное выражение
		Если ПервыйСимволНомера = 0 Тогда
			НазначениеПлатежа = Прав(НазначениеПлатежа, СтрДлина(НазначениеПлатежа) - СтрДлина(Лев(НазначениеПлатежа, НайденаяПозицияВыражения - 1 + СтрДлина(Выражение))));
			Продолжить;
		КонецЕсли;
		
		// Получем номер
		НайденыйНомер = "";
		ПредыдущийСимвол = "";
		Для СчетчикСимволов = ПервыйСимволНомера по СтрДлина(НазначениеПлатежа) - 1 цикл
			Символ = Сред(НазначениеПлатежа, СчетчикСимволов, 1);
			Если Найти(Цифры, Символ) = 0 тогда
				Если СпецСимволыВНомере.Найти(Символ) = Неопределено тогда
					СледующийСимвол = "";
					Если СчетчикСимволов + 1 <= СтрДлина(НазначениеПлатежа) - 1 тогда
						СледующийСимвол = Сред(НазначениеПлатежа, СчетчикСимволов + 1, 1);
					КонецЕсли;
					
					Если СпецСимволыВНомере.Найти(ПредыдущийСимвол) <> Неопределено и СледующийСимвол = " " тогда
						НайденыйНомер = Сред(НазначениеПлатежа, ПервыйСимволНомера, СчетчикСимволов - ПервыйСимволНомера + 1);
					Иначе
						НайденыйНомер = Сред(НазначениеПлатежа, ПервыйСимволНомера, СчетчикСимволов - ПервыйСимволНомера);
					КонецЕсли;
					Прервать;
				КонецЕсли;
			КонецЕсли;
			ПредыдущийСимвол = Символ;
		КонецЦикла;
		
		Если ЗначениеЗаполнено(НайденыйНомер) тогда
			Возврат НайденыйНомер;
		КонецЕсли;
		
		// Убираем все символы левее того что нашли, чтобы продолжить поиск вхождений
		НазначениеПлатежа = Прав(НазначениеПлатежа, СтрДлина(НазначениеПлатежа) - СтрДлина(Лев(НазначениеПлатежа, НайденаяПозицияВыражения - 1 + СтрДлина(Выражение))));
	КонецЦикла;
	
	Возврат НайденыйНомер;
КонецФункции

Функция НомерИмеетСимволыАлфавита(Номер)
	
	РусскийАлфавит = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ";
	АнглийскийАлфавит = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	
	ВРЕГНОМЕР = ВРЕГ(Номер);
	КоличествоСимволов = СтрДлина(ВРЕГНОМЕР);
	Для СчетчикСимволов = 1 по КоличествоСимволов Цикл
		Символ = Сред(ВРЕГНОМЕР, СчетчикСимволов, 1);
		
		Если НЕ Найти(РусскийАлфавит, Символ) = 0
		 ИЛИ НЕ Найти(АнглийскийАлфавит, Символ) = 0 тогда
			Возврат Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ложь;
КонецФункции

