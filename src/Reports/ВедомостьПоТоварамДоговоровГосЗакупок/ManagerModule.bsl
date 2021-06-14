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
	
	Возврат "Остатки и счета на оплату" + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
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
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ОтборГдеКонОстатокМеньшеНуля", ПараметрыОтчета.ОтборГдеКонОстатокМеньшеНуля);
	
	// Дополнительные данные
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);
	
	// Создаем таблицу в СКД
	Таблица = КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ТаблицаКомпоновкиДанных"));
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Таблица, "ГоризонтальноеРасположениеОбщихИтогов", РасположениеИтоговКомпоновкиДанных.Конец);
	
	
	// Группировки
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
			
			Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
			//Если ПараметрыОтчета.ПоказательКоличество тогда
				ДобавитьПоказателиВГруппировку(Структура, "Количество");
			//КонецЕсли;
			//Если ПараметрыОтчета.ПоказательСумма тогда
			//	ДобавитьПоказателиВГруппировку(Структура, "Сумма");
			//КонецЕсли;
			Если ПолеВыбраннойГруппировки.Поле = "НоменклатураГосЗакупок" тогда
				ПолеГруппировкиЕдИзм = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
				ПолеГруппировкиЕдИзм.Использование  = Истина;
				ПолеГруппировкиЕдИзм.Поле           = Новый ПолеКомпоновкиДанных("ЕдиницаИзмеренияГосЗакупок");
				ПолеГруппировкиЕдИзм.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
				
				ПолеГруппировкиЦена = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
				ПолеГруппировкиЦена.Использование  = Истина;
				ПолеГруппировкиЦена.Поле           = Новый ПолеКомпоновкиДанных("Цена");
				ПолеГруппировкиЦена.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
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
			
			Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);

КонецПроцедуры

Процедура ДобавитьПоказателиВГруппировку(Группировка, ИмяПоказателя)
	
	Показатели = Новый Массив;
	Показатели.Добавить("НачальныйОстаток");
	Показатели.Добавить("Приход");
	Показатели.Добавить("Расход");
	Показатели.Добавить("КонечныйОстаток");
	
	Для Каждого Показатель из Показатели цикл
		
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группировка.Выбор, Новый ПолеКомпоновкиДанных(ИмяПоказателя + Показатель));
		
	КонецЦикла;
	
КонецПроцедуры

#КонецЕсли