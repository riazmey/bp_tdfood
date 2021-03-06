Функция СуществующиеЭлементыМногооборотнойТары(ЕстьПересчетыНоменклатуры = Истина) Экспорт
	
	ВидНоменклатурыТары = ПредопределенныеЭлементыРасширенияСервер.ПредопределенноеЗначениеРасширения("Справочник", "ВидыНоменклатуры", "МногооборотнаяТара");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВидНоменклатуры", ВидНоменклатурыТары);
	
	Если ЕстьПересчетыНоменклатуры тогда
		Запрос.Текст =
		"ВЫБРАТЬ
		|	НоменклатураМногооборотнаяТара.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Номенклатура.МногооборотнаяТара КАК НоменклатураМногооборотнаяТара
		|ГДЕ
		|	НоменклатураМногооборотнаяТара.Ссылка.ВидНоменклатуры = &ВидНоменклатуры
		|	И НоменклатураМногооборотнаяТара.КоличествоВМесте > 0
		|
		|СГРУППИРОВАТЬ ПО
		|	НоменклатураМногооборотнаяТара.Ссылка";
	Иначе
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Номенклатура.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|ГДЕ
		|	Номенклатура.ВидНоменклатуры = &ВидНоменклатуры
		|
		|СГРУППИРОВАТЬ ПО
		|	Номенклатура.Ссылка";
	КонецЕсли;
	
	ТаблицаЗапроса = Запрос.Выполнить().Выгрузить();
	
	Возврат ТаблицаЗапроса.ВыгрузитьКолонку("Ссылка");
	
КонецФункции

Функция СчетаМногооборотнойТары() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("МногооборотнаяТараОстатки"    , Неопределено);
	Результат.Вставить("МногооборотнаяТараПоставщики" , Неопределено);
	Результат.Вставить("МногооборотнаяТараВодители"   , Неопределено);
	Результат.Вставить("МногооборотнаяТараКонтрагенты", Неопределено);
	
	Для Каждого КлючИЗначение из Результат цикл
		
		Результат.Вставить(КлючИЗначение.Ключ,
		                   ПредопределенныеЭлементыРасширенияСервер.ПредопределенноеЗначениеРасширения(
		                         "ПланСчетов",
		                         "Хозрасчетный",
		                         КлючИЗначение.Ключ)
		);
	
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ПредопределенныеСчетаУчетаМногооборотнойТарыЗаполнены(СчетаУчета) Экспорт
	
	ВсеСчетаУчетаЗаполнены = Истина;
	Для Каждого КлючИЗначение из СчетаУчета цикл
		Если НЕ ЗначениеЗаполнено(КлючИЗначение.Значение) тогда
			ВсеСчетаУчетаЗаполнены = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ВсеСчетаУчетаЗаполнены;
	
КонецФункции

Процедура ДобавитьВТаблицуПечатиРеализацииМногооборотнуюТару(ДокументРеализация, ТаблицаДокумента) Экспорт
	
	ВидНоменклатурыТара = ПредопределенныеЭлементыРасширенияСервер.ПредопределенноеЗначениеРасширения("Справочник", "ВидыНоменклатуры", "МногооборотнаяТара");
	СчетаМТ = СчетаМногооборотнойТары();
	
	Если НЕ ПредопределенныеСчетаУчетаМногооборотнойТарыЗаполнены(СчетаМТ) тогда
		Возврат;
	КонецЕсли;
	
	СчетаЗапасов = Новый Массив;
	СчетаЗапасов.Добавить(СчетаМТ.МногооборотнаяТараКонтрагенты);
	
	НомерСубконтоГрузополучателя = 0;
	НомерСубконтоДокумента = 0;
	НомерСубконтоМногооборотнаяТара = 0;
	СчетчикСубконто = 0;
	ВидыСубконто = Новый Массив;
	Для Каждого Субконто Из СчетаМТ.МногооборотнаяТараКонтрагенты.ВидыСубконто Цикл
		
		СчетчикСубконто = СчетчикСубконто + 1;
		
		Если Субконто.ВидСубконто.ТипЗначения.СодержитТип(ТипЗнч(ДокументРеализация)) тогда
			НомерСубконтоДокумента = СчетчикСубконто;
		КонецЕсли;
		
		Если Субконто.ВидСубконто.ТипЗначения.СодержитТип(ТипЗнч(ДокументРеализация.Грузополучатель)) тогда
			НомерСубконтоГрузополучателя = СчетчикСубконто;
		КонецЕсли;
		
		Если Субконто.ВидСубконто.ТипЗначения.СодержитТип(Тип("СправочникСсылка.Номенклатура")) тогда
			НомерСубконтоМногооборотнаяТара = СчетчикСубконто;
		КонецЕсли;
		
		ВидыСубконто.Добавить(Субконто.ВидСубконто);
		
	КонецЦикла;
	
	Если НомерСубконтоГрузополучателя = 0
	 ИЛИ НомерСубконтоДокумента = 0
	 ИЛИ НомерСубконтоМногооборотнаяТара = 0 тогда
		Возврат;
	КонецЕсли;
	
	ВидыСубконто = Новый Массив;
	Для Каждого Субконто Из СчетаМТ.МногооборотнаяТараКонтрагенты.ВидыСубконто Цикл
		ВидыСубконто.Добавить(Субконто.ВидСубконто);
	КонецЦикла;
	
	ДатаОстатков = КонецДня(ДокументРеализация.Дата);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаОстатков"    , ДатаОстатков);
	Запрос.УстановитьПараметр("Грузополучатель" , ДокументРеализация.Грузополучатель);
	Запрос.УстановитьПараметр("ДокументДвижения", ДокументРеализация.Ссылка);
	Запрос.УстановитьПараметр("ВидыСубконто"    , ВидыСубконто);
	Запрос.УстановитьПараметр("СчетаЗапасов"    , СчетаЗапасов);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	&ДокументДвижения КАК Ссылка,
	|	ХозрасчетныйОбороты.Субконто" + НомерСубконтоМногооборотнаяТара + " КАК Товар,
	|	ВЫРАЗИТЬ(ХозрасчетныйОбороты.Субконто" + НомерСубконтоМногооборотнаяТара + " КАК Справочник.Номенклатура).Код КАК ТоварКод,
	|	ВЫРАЗИТЬ(ХозрасчетныйОбороты.Субконто" + НомерСубконтоМногооборотнаяТара + " КАК Справочник.Номенклатура).НаименованиеПолное КАК ТоварНаименование,
	|	ВЫРАЗИТЬ(ХозрасчетныйОбороты.Субконто" + НомерСубконтоМногооборотнаяТара + " КАК Справочник.Номенклатура).ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ВЫРАЗИТЬ(ХозрасчетныйОбороты.Субконто" + НомерСубконтоМногооборотнаяТара + " КАК Справочник.Номенклатура).ЕдиницаИзмерения.Код КАК ЕдиницаИзмеренияКод,
	|	ВЫРАЗИТЬ(ХозрасчетныйОбороты.Субконто" + НомерСубконтоМногооборотнаяТара + " КАК Справочник.Номенклатура).ЕдиницаИзмерения.Наименование КАК ЕдиницаИзмеренияНаименование,
	|	ВЫРАЗИТЬ(ХозрасчетныйОбороты.Субконто" + НомерСубконтоМногооборотнаяТара + " КАК Справочник.Номенклатура).ВидСтавкиНДС КАК ВидСтавкиНДС,
	|	ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.ПустаяСсылка) КАК СтавкаНДС,
	|	""без акциза"" КАК Акциз,
	|	СУММА(ЕСТЬNULL(ХозрасчетныйОбороты.КоличествоОборотДт, 0)) КАК Количество,
	|	0 КАК Всего,
	|	0 КАК ВсегоРуб,
	|	0 КАК СуммаНДС,
	|	0 КАК СуммаБезНДС,
	|	0 КАК СуммаБезНДСРуб,
	|	1 КАК НомерТабЧасти
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Обороты(
	|			НАЧАЛОПЕРИОДА(&ДатаОстатков, ДЕНЬ),
	|			КОНЕЦПЕРИОДА(&ДатаОстатков, ДЕНЬ),
	|			День,
	|			Счет В (&СчетаЗапасов),
	|			&ВидыСубконто,
	|			Субконто" + НомерСубконтоГрузополучателя + " = &Грузополучатель
	|				И Субконто" + НомерСубконтоДокумента + " = &ДокументДвижения,
	|			,
	|			) КАК ХозрасчетныйОбороты
	|
	|СГРУППИРОВАТЬ ПО
	|	ХозрасчетныйОбороты.Субконто" + НомерСубконтоМногооборотнаяТара + ",
	|	ВЫРАЗИТЬ(ХозрасчетныйОбороты.Субконто" + НомерСубконтоМногооборотнаяТара + " КАК Справочник.Номенклатура).НаименованиеПолное,
	|	ВЫРАЗИТЬ(ХозрасчетныйОбороты.Субконто" + НомерСубконтоМногооборотнаяТара + " КАК Справочник.Номенклатура).ЕдиницаИзмерения,
	|	ВЫРАЗИТЬ(ХозрасчетныйОбороты.Субконто" + НомерСубконтоМногооборотнаяТара + " КАК Справочник.Номенклатура).ЕдиницаИзмерения.Код,
	|	ВЫРАЗИТЬ(ХозрасчетныйОбороты.Субконто" + НомерСубконтоМногооборотнаяТара + " КАК Справочник.Номенклатура).ЕдиницаИзмерения.Наименование,
	|	ВЫРАЗИТЬ(ХозрасчетныйОбороты.Субконто" + НомерСубконтоМногооборотнаяТара + " КАК Справочник.Номенклатура).ВидСтавкиНДС";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() цикл
		
		НоваяСтрокаДокумента = ТаблицаДокумента.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаДокумента, Выборка);
		
		НоваяСтрокаДокумента.СтавкаНДС = Перечисления.СтавкиНДС.СтавкаНДС(Выборка.ВидСтавкиНДС, ДатаОстатков);
		
	КонецЦикла;
	
КонецПроцедуры

Функция НайтиДвиженияМногооборотнойТарыНаОсновании(ДокументОснование, ВидОперации = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(ДокументОснование) тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВидОперации) тогда
		Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") тогда
			ВидОперацииЗапроса = Перечисления.Базар_ВидыДвиженийМногооборотнойТары.ВозвратПоставщику;
		Иначе
			ВидОперацииЗапроса = Перечисления.Базар_ВидыДвиженийМногооборотнойТары.Передача;
		КонецЕсли;
	Иначе
		ВидОперацииЗапроса = ВидОперации;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	Запрос.УстановитьПараметр("ВидОперации", ВидОперацииЗапроса);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДвижениеМногооборотнойТары.Ссылка КАК Ссылка,
	|	ДвижениеМногооборотнойТары.ПометкаУдаления КАК ПометкаУдаления,
	|	ДвижениеМногооборотнойТары.Проведен КАК Проведен
	|ИЗ
	|	Документ.ДвижениеМногооборотнойТары КАК ДвижениеМногооборотнойТары
	|ГДЕ
	|	ДвижениеМногооборотнойТары.ДокументОснование = &ДокументОснование
	|	И ДвижениеМногооборотнойТары.ВидОперации = &ВидОперации
	|
	|УПОРЯДОЧИТЬ ПО
	|	Проведен УБЫВ,
	|	ПометкаУдаления";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() тогда
		Возврат Неопределено;
	Иначе
		Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");
	КонецЕсли;
	
КонецФункции