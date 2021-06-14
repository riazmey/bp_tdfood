#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета", Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",  Ложь);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",  Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",      Истина);

	Возврат Результат;

КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 
	
	Возврат "Динамика цен" + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();
	
	Периодичность = БухгалтерскиеОтчетыКлиентСервер.ПолучитьЗначениеПериодичности(ПараметрыОтчета.Периодичность, ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
	ПериодичностьОтчета = Новый Соответствие;
	ПериодичностьОтчета.Вставить(6, "ДЕНЬ");
	ПериодичностьОтчета.Вставить(9, "МЕСЯЦ");
	ПериодичностьОтчета.Вставить(10, "КВАРТАЛ");
	ПериодичностьОтчета.Вставить(11, "ПОЛУГОДИЕ");
	ПериодичностьОтчета.Вставить(12, "ГОД");
	
	
	СхемаЭталон = ПолучитьМакет("СхемаКомпоновкиДанных");
	ТекстЗапроса = СхемаЭталон.НаборыДанных.ДинамикаЦен.Запрос;
	
	Схема.НаборыДанных.ДинамикаЦен.Запрос = СтрЗаменить(ТекстЗапроса, ", ДЕНЬ", ", " + ПериодичностьОтчета.Получить(Периодичность));
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Периодичность", Периодичность);
	Если НЕ ЗначениеЗаполнено(ПараметрыОтчета.Номенклатура) тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Номенклатура", Справочники.Номенклатура.ПустаяСсылка());
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Номенклатура", ПараметрыОтчета.Номенклатура);
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(ПараметрыОтчета.ТипЦен) тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ТипЦен", Справочники.ТипыЦенНоменклатуры.ПустаяСсылка());
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ТипЦен", ПараметрыОтчета.ТипЦен);
	КонецЕсли;
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
		
	// Дополнительные данные
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
	ТаблицаДинамикиЦен   = Неопределено;
	Для Каждого ЭлементСтруктуры Из КомпоновщикНастроек.Настройки.Структура Цикл
		Если ЭлементСтруктуры.Имя = "ТаблицаДинамикиЦен" Тогда
			ТаблицаДинамикиЦен = ЭлементСтруктуры;
		КонецЕсли;
	КонецЦикла;	
	
	Если ТаблицаДинамикиЦен <> Неопределено Тогда
		
		// Поля выбора
		//ПолеВыбора = Новый ПолеКомпоновкиДанных("Цена");
		//НовоеПолеВыбора = ТаблицаДинамикиЦен.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		//НовоеПолеВыбора.Поле = ПолеВыбора;
		//НовоеПолеВыбора.Использование = Истина;
		
		ТаблицаДинамикиЦен.Колонки.Очистить();
		ГруппировкаПериод = ТаблицаДинамикиЦен.Колонки.Добавить();
		ПолеГруппировки = ГруппировкаПериод.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование = Истина;
		ПолеГруппировки.Поле          = Новый ПолеКомпоновкиДанных("Период");
		ПолеГруппировки.ТипДополнения = БухгалтерскиеОтчетыВызовСервера.ПолучитьТипДополненияПоИнтервалу(Периодичность);
		ПолеГруппировки.НачалоПериода = НачалоДня(ПараметрыОтчета.НачалоПериода);
		ПолеГруппировки.КонецПериода  = КонецДня(ПараметрыОтчета.КонецПериода);
		
		
		ПолеОтборПериода = ГруппировкаПериод.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ПолеОтборПериода.Использование  = Истина;
		ПолеОтборПериода.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Цена");
		ПолеОтборПериода.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеРавно;
		ПолеОтборПериода.ПравоеЗначение = 0;
		ПараметрВыводитьОтбор = ГруппировкаПериод.ПараметрыВывода.Элементы.Найти("ВыводитьОтбор");
		ПараметрВыводитьОтбор.Использование = Истина;
		ПараметрВыводитьОтбор.Значение = ТипВыводаТекстаКомпоновкиДанных.НеВыводить;
		
		
		ГруппировкаПериод.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		ПорядокПериод = ГруппировкаПериод.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
		ПорядокПериод.Поле = ПолеГруппировки.Поле;
		
		// Группировки
		ТаблицаДинамикиЦен.Строки.Очистить();
		Группировка = ТаблицаДинамикиЦен.Строки;
		Для Каждого ПолеВыбраннойГруппировки Из ПараметрыОтчета.Группировка Цикл 
			Если ПолеВыбраннойГруппировки.Использование Тогда
				Если ТипЗнч(Группировка) = Тип("КоллекцияЭлементовСтруктурыТаблицыКомпоновкиДанных") Тогда
					Группировка = Группировка.Добавить();
				Иначе
					Группировка = Группировка.Структура.Добавить();
				КонецЕсли;
				БухгалтерскиеОтчетыВызовСервера.ЗаполнитьГруппировку(ПолеВыбраннойГруппировки, Группировка);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);

КонецПроцедуры

#КонецЕсли