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
	
	Возврат "Ведомость по взаиморасчетам с контрагентами " + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	КомпоновщикНастроек.Настройки.Структура.Очистить();
	КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Организация", ПараметрыОтчета.Организация);
	
	СчетаУчета = Новый СписокЗначений;
	СчетаУчета.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПокупателями);
	СчетаУчета.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоАвансамПолученным);
	СчетаУчета.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПоставщиками);
	СчетаУчета.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоАвансамВыданным);
	//СчетаУчета.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПрочимиПоставщикамиИПодрядчиками);
	//СчетаУчета.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПрочимиПокупателямиИЗаказчиками);
	//СчетаУчета.Добавить(ПланыСчетов.Хозрасчетный.ПрочиеРасчетыСРазнымиДебиторамиИКредиторами);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СчетаВзаиморасчетов", СчетаУчета);
	
	УсловноеОформлениеАвтоотступа = Неопределено;
	Для каждого ЭлементОформления Из КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы Цикл
		Если ЭлементОформления.Представление = "Уменьшенный автоотступ" Тогда
			УсловноеОформлениеАвтоотступа = ЭлементОформления;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если УсловноеОформлениеАвтоотступа = Неопределено Тогда
		УсловноеОформлениеАвтоотступа = КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();
		УсловноеОформлениеАвтоотступа.Представление = "Уменьшенный автоотступ";
		УсловноеОформлениеАвтоотступа.Оформление.УстановитьЗначениеПараметра("Автоотступ", 1);
		УсловноеОформлениеАвтоотступа.Использование = Ложь;
		УсловноеОформлениеАвтоотступа.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
	Иначе
		УсловноеОформлениеАвтоотступа.Поля.Элементы.Очистить();
	КонецЕсли;
	
	КомпоновщикНастроек.Настройки.ПараметрыВывода.Элементы.Найти("ГоризонтальноеРасположениеОбщихИтогов").Значение = РасположениеИтоговКомпоновкиДанных.Нет;
	КомпоновщикНастроек.Настройки.ПараметрыВывода.Элементы.Найти("ГоризонтальноеРасположениеОбщихИтогов").Использование = Истина;
	КомпоновщикНастроек.Настройки.ПараметрыВывода.Элементы.Найти("ВертикальноеРасположениеОбщихИтогов").Использование = Истина;
	
	Если ПараметрыОтчета.СхемаКомпоновкиДанных.ВариантыНастроек[0].Имя = "ВедомостьПоВзаиморасчетамСРегистратором" тогда
		КомпоновщикНастроек.Настройки.ПараметрыВывода.Элементы.Найти("ВертикальноеРасположениеОбщихИтогов").Значение = РасположениеИтоговКомпоновкиДанных.Нет;
	Иначе
		КомпоновщикНастроек.Настройки.ПараметрыВывода.Элементы.Найти("ВертикальноеРасположениеОбщихИтогов").Значение = РасположениеИтоговКомпоновкиДанных.Конец;
	КонецЕсли;
	
	// Дополнительные данные
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
	Таблица = КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ТаблицаКомпоновкиДанных"));
	
	Колонка = Таблица.Колонки.Добавить();
	Колонка.Имя           = "НачОстаток";
	Колонка.Использование = Истина;
	
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Колонка.Выбор, Новый ПолеКомпоновкиДанных("НачОстаток"));
	
	Колонка = Таблица.Колонки.Добавить();
	Колонка.Имя           = "Приход";
	Колонка.Использование = Истина;
	
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Колонка.Выбор, Новый ПолеКомпоновкиДанных("Приход"));
	
	Колонка = Таблица.Колонки.Добавить();
	Колонка.Имя           = "Расход";
	Колонка.Использование = Истина;
	
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Колонка.Выбор, Новый ПолеКомпоновкиДанных("Расход"));

	
	Колонка = Таблица.Колонки.Добавить();
	Колонка.Имя           = "КонОстаток";
	Колонка.Использование = Истина;
	
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Колонка.Выбор, Новый ПолеКомпоновкиДанных("КонОстаток"));
	
	Структура = Таблица.Строки.Добавить();
	
	Для Каждого ПолеВыбраннойГруппировки Из ПараметрыОтчета.Группировка Цикл 
		Если ПолеВыбраннойГруппировки.Использование Тогда
			Структура = Структура.Структура.Добавить();
			
			ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Использование  = Истина;
			ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных(ПолеВыбраннойГруппировки.Поле);
			
			Если ПолеВыбраннойГруппировки.ТипГруппировки = 1 Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
			ИначеЕсли ПолеВыбраннойГруппировки.ТипГруппировки = 2 Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.ТолькоИерархия;
			Иначе
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
			КонецЕсли;
			
			Если ПолеВыбраннойГруппировки.Поле = "ДокументДвижения" тогда
				ПолеОтбора = Новый ПолеКомпоновкиДанных("ДокументДвижения");
				НовыйЭлемент = Структура.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
				НовыйЭлемент.Использование  = Истина;
				НовыйЭлемент.ЛевоеЗначение  = ПолеОтбора;
				НовыйЭлемент.ВидСравнения   = ВидСравненияКомпоновкиДанных.Заполнено;
				ПараметрВыводитьОтбор = Структура.ПараметрыВывода.Элементы.Найти("ВыводитьОтбор");
				ПараметрВыводитьОтбор.Использование = Истина;
				ПараметрВыводитьОтбор.Значение = ТипВыводаТекстаКомпоновкиДанных.НеВыводить;
			КонецЕсли;
			
			Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
			Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
			
			ПолеОформления = УсловноеОформлениеАвтоотступа.Поля.Элементы.Добавить();
			ПолеОформления.Поле = ПолеГруппировки.Поле;
			
		КонецЕсли;
	КонецЦикла;
	
	Если УсловноеОформлениеАвтоотступа.Поля.Элементы.Количество() = 0 Тогда
		УсловноеОформлениеАвтоотступа.Использование = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);

КонецПроцедуры

#КонецЕсли