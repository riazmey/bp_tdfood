
&НаКлиенте
Процедура Базар_ПриОткрытииПосле(Отказ)
	
	Элементы.ДокументОснование.Видимость = ЗначениеЗаполнено(Объект.ДокументОснование);
	ЭтаФорма.ТолькоПросмотр = ЗначениеЗаполнено(Объект.ДокументОснование);
	Элементы.ГруппаЛегенда.Видимость = Объект.Проведен;
	УстановитьФлагиСтрокБезДвижений();
	УстановитьУсловноеОформлениеТовары();
	
КонецПроцедуры

&НаКлиенте
Процедура Базар_ПослеЗаписиПосле(ПараметрыЗаписи)
	
	Элементы.ГруппаЛегенда.Видимость = Объект.Проведен;
	УстановитьФлагиСтрокБезДвижений();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформлениеТовары()
	
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.БезДвижений");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Истина;
	ЭлементОтбора.Использование = Истина;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.ТусклоРозовый);
	
	ОформляемыеПоля = Новый Массив;
	ОформляемыеПоля.Добавить("ТоварыНомерСтроки");
	ОформляемыеПоля.Добавить("ТоварыНоменклатураКод");
	ОформляемыеПоля.Добавить("ТоварыНоменклатураАртикул");
	ОформляемыеПоля.Добавить("ТоварыНоменклатура");
	ОформляемыеПоля.Добавить("ТоварыЦена");
	ОформляемыеПоля.Добавить("ТоварыВалюта");
	ОформляемыеПоля.Добавить("ТоварыОтступ");	

	Для Каждого ИмяПоля из ОформляемыеПоля цикл
		ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
		ПолеОформления.Поле = Новый ПолеКомпоновкиДанных(ИмяПоля);
		ПолеОформления.Использование = Истина;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура УстановитьФлагиСтрокБезДвижений()
	
	Если НЕ Объект.Проведен тогда
		Возврат;
	КонецЕсли;
	
	МассивНоменклатуры = Объект.Товары.Выгрузить(,"Номенклатура").ВыгрузитьКолонку("Номенклатура");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивНоменклатуры", МассивНоменклатуры);
	Запрос.УстановитьПараметр("ТипЦен", Объект.ТипЦен);
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.УстановитьПараметр("Дата", Объект.Дата);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЦеныНоменклатуры.Номенклатура КАК Номенклатура
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры КАК ЦеныНоменклатуры
	|ГДЕ
	|	ЦеныНоменклатуры.Период МЕЖДУ НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ) И КОНЕЦПЕРИОДА(&Дата, ДЕНЬ)
	|	И ЦеныНоменклатуры.ТипЦен = &ТипЦен
	|	И ЦеныНоменклатуры.Номенклатура В(&МассивНоменклатуры)
	|	И ЦеныНоменклатуры.Регистратор = &Ссылка";
	
	ТаблицаПроведенных = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрокаТовары из Объект.Товары цикл
		НайденаяСтрока = ТаблицаПроведенных.Найти(СтрокаТовары.Номенклатура, "Номенклатура");
		СтрокаТовары.БезДвижений = НайденаяСтрока = Неопределено;
	КонецЦикла;
	
КонецПроцедуры

&Вместо("ЗаполнитьТабличнуюЧастьПоПоступлению")
&НаСервере
// Процедура выполняет заполнение табличной части 
// копированием из выбранного пользователем документа Поступления.
//
// Параметры:
//  ДокументПоступление - Документ поступления, данными которого надо заполнить табличную часть.
//  ЧиститьТипыЦен      - Признак необходимости очистки типов цен перед заполнением.
//
Процедура Базар_ЗаполнитьТабличнуюЧастьПоПоступлению(ДокументПоступление, ЧиститьТипыЦен = Истина)

	Запрос = Новый Запрос;
    Запрос.УстановитьПараметр("ДокументОснование", ДокументПоступление);

	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Док.СуммаВключаетНДС КАК СуммаВключаетНДС,
	|	Док.ВалютаДокумента КАК ВалютаДокумента,
	|	Док.ТипЦен КАК ТипЦен,
	|	ЕСТЬNULL(Док.ТипЦен.ЦенаВключаетНДС, Док.СуммаВключаетНДС) КАК ТипЦенЦенаВключаетНДС
	|ИЗ
	|	Документ.ПоступлениеТоваровУслуг КАК Док
	|ГДЕ
	|	Док.Ссылка = &ДокументОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Цена КАК Цена,
	|	Товары.СтавкаНДС КАК СтавкаНДС,
	|	МИНИМУМ(Товары.НомерСтроки) КАК НомерСтроки
	|ИЗ
	|	Документ.ПоступлениеТоваровУслуг.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &ДокументОснование
	|	И Товары.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	Товары.Номенклатура,
	|	Товары.Цена,
	|	Товары.СтавкаНДС
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";

	Результаты = Запрос.ВыполнитьПакет();
	
	Шапка = Результаты[0].Выбрать();
	Шапка.Следующий();
	
	Выборка = Результаты[1].Выбрать();

	Пока Выборка.Следующий() Цикл

		СтруктураОтбора = Новый Структура();
		СтруктураОтбора.Вставить("Номенклатура", Выборка.Номенклатура);

		СтрокаТабличнойЧасти = ОбработкаТабличныхЧастейКлиентСервер.НайтиСтрокуТабЧасти(Объект, "Товары", СтруктураОтбора);

		Если СтрокаТабличнойЧасти = Неопределено Тогда

			СтрокаТабличнойЧасти = Объект.Товары.Добавить();
			СтрокаТабличнойЧасти.Номенклатура = Выборка.Номенклатура;

		КонецЕсли;
		СтрокаТабличнойЧасти.Цена  = УчетНДСКлиентСервер.ПересчитатьЦенуПриИзмененииФлаговНалогов(
		                                        Выборка.Цена,
		                                        Шапка.СуммаВключаетНДС,
		                                        Шапка.ТипЦенЦенаВключаетНДС,
		                                        УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(Выборка.СтавкаНДС));

		СтрокаТабличнойЧасти.Валюта =  Шапка.ВалютаДокумента;
		
	КонецЦикла;

КонецПроцедуры // ЗаполнитьТабличнуюЧастьПоПоступлению()