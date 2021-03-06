#Область ТранспортнаяЛогистика

Функция СписокАдресовДоставки(КонтрагентОрганизация, Дата) Экспорт
	
	СписокАдресов = Новый СписокЗначений;
	
	Если НЕ ЗначениеЗаполнено(КонтрагентОрганизация) ИЛИ НЕ ЗначениеЗаполнено(Дата) Тогда
		Возврат СписокАдресов;
	КонецЕсли;
	
	ТипыКИ = Новый Массив;
	ТипыКИ.Добавить(Перечисления.ТипыКонтактнойИнформации.Адрес);
	
	Объекты = Новый Массив();
	Объекты.Добавить(КонтрагентОрганизация);
	Адреса = УправлениеКонтактнойИнформациейБП.КонтактнаяИнформацияОбъектовНаДату(Объекты, ТипыКИ, , Дата);
	
	// Сортируем по приоритету таблицу адресов
	ВидыАдресовПоПриоритету = ПриоритетыАдресовДоставки(КонтрагентОрганизация);
	Адреса.Колонки.Добавить("Приоритет", ОбщегоНазначения.ОписаниеТипаЧисло(1));
	Для Каждого Адрес Из Адреса Цикл
		Адрес.Приоритет = ВидыАдресовПоПриоритету.Получить(Адрес.Вид);
	КонецЦикла;
	Адреса.Сортировать("Приоритет Убыв, Вид");
	
	Для Каждого Адрес Из Адреса Цикл
		СписокАдресов.Добавить(Адрес.Значение, "" + Адрес.Вид + ": " + Адрес.Представление);
	КонецЦикла;
	
	Возврат СписокАдресов;
	
КонецФункции

Функция ДанныеАдресаДоставкиJSON(АдресДоставкиJSON, Дата = Неопределено) Экспорт
	
	СтруктураВозврата = Новый Структура("АдресДоставки,
	                                    |АдресДоставкиJSON,
										|АдресДоставкиСтруктура");
	
	Если ЗначениеЗаполнено(Дата) тогда
		ДатаНастроек = Дата;
	Иначе
		ДатаНастроек = ТекущаяДата();
	КонецЕсли;
	
	СистемныеНастройкиБазар = ОбщегоНазначенияБазарСервер.СистемныеНастройкиБазар(ДатаНастроек);
	
	Попытка
		АдресДоставкиСтруктура = СтрокуJSONВСтруктуру(АдресДоставкиJSON);
		АдресДоставки = СокращенноеПредставлениеАдреса(АдресДоставкиСтруктура, СистемныеНастройкиБазар.ДомашнийРегион);
	Исключение
		АдресДоставки = "";
		АдресДоставкиJSON = "";
		АдресДоставкиСтруктура = Новый Структура;
	КонецПопытки;
	
	СтруктураВозврата.АдресДоставки = АдресДоставки;
	СтруктураВозврата.АдресДоставкиJSON = АдресДоставкиJSON;
	СтруктураВозврата.АдресДоставкиСтруктура = АдресДоставкиСтруктура;
	
	Возврат СтруктураВозврата;
	
КонецФункции

Функция ДанныеАдресаДоставкиПоУмолчанию(КонтрагентОрганизация, Дата = Неопределено) Экспорт
	
	Если НЕ ЗначениеЗаполнено(КонтрагентОрганизация) тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Дата) тогда
		ДатаНастроек = ТекущаяДата();
	Иначе
		ДатаНастроек = Дата;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КонтрагентыКонтактнаяИнформация.Вид КАК ВидАдреса,
	|	КонтрагентыКонтактнаяИнформация.Значение КАК СтрокаJSON,
	|	КонтрагентыКонтактнаяИнформация.Представление КАК ПредставлениеПолное
	|ПОМЕСТИТЬ Контрагенты
	|ИЗ
	|	Справочник.Контрагенты.КонтактнаяИнформация КАК КонтрагентыКонтактнаяИнформация
	|ГДЕ
	|	КонтрагентыКонтактнаяИнформация.Ссылка = &Ссылка
	|	И КонтрагентыКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Адрес)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОрганизацииКонтактнаяИнформация.Вид КАК ВидАдреса,
	|	ОрганизацииКонтактнаяИнформация.Значение КАК СтрокаJSON,
	|	ОрганизацииКонтактнаяИнформация.Представление КАК ПредставлениеПолное
	|ПОМЕСТИТЬ Организации
	|ИЗ
	|	Справочник.Организации.КонтактнаяИнформация КАК ОрганизацииКонтактнаяИнформация
	|ГДЕ
	|	ОрганизацииКонтактнаяИнформация.Ссылка = &Ссылка
	|	И ОрганизацииКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Адрес)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(Контрагенты.ВидАдреса, Организации.ВидАдреса) КАК ВидАдреса,
	|	ЕСТЬNULL(Контрагенты.СтрокаJSON, Организации.СтрокаJSON) КАК СтрокаJSON,
	|	ВЫРАЗИТЬ(0 КАК ЧИСЛО(15, 12)) КАК Широта,
	|	ВЫРАЗИТЬ(0 КАК ЧИСЛО(15, 12)) КАК Долгота,
	|	ЕСТЬNULL(Контрагенты.ПредставлениеПолное, Организации.ПредставлениеПолное) КАК ПредставлениеПолное,
	|	ВЫРАЗИТЬ("""" КАК СТРОКА(250)) КАК ПредставлениеСокращенное,
	|	ВЫРАЗИТЬ(0 КАК ЧИСЛО(1, 0)) КАК Приоритет
	|ИЗ
	|	Контрагенты КАК Контрагенты
	|		ПОЛНОЕ СОЕДИНЕНИЕ Организации КАК Организации
	|		ПО Контрагенты.ВидАдреса = Организации.ВидАдреса";
	
	Запрос.УстановитьПараметр("Ссылка", КонтрагентОрганизация);
	
	ТаблицаАдресов = Запрос.Выполнить().Выгрузить();
	ВидыАдресовПоПриоритету = ПриоритетыАдресовДоставки(КонтрагентОрганизация);
	
	Если ТаблицаАдресов.Количество() = 0 тогда
		Возврат Неопределено;
	КонецЕсли;
	
	// Удаляем адреса без координат и устанавливаем вес приоритета
	КоличествоСтрок = ТаблицаАдресов.Количество();
	СчетчикСтрок = 1;
	Пока СчетчикСтрок <= КоличествоСтрок цикл
		
		ТекущаяСтрока = ТаблицаАдресов.Получить(СчетчикСтрок - 1);
		
		СтруктураАдреса = СтрокуJSONВСтруктуру(ТекущаяСтрока.СтрокаJSON);
		Если СтруктураАдреса.Свойство("latitude") И СтруктураАдреса.Свойство("longitude") тогда
			Если НЕ ЗначениеЗаполнено(СтруктураАдреса.latitude) ИЛИ НЕ ЗначениеЗаполнено(СтруктураАдреса.longitude) тогда
				ТаблицаАдресов.Удалить(СчетчикСтрок - 1);
				КоличествоСтрок = КоличествоСтрок - 1;
			Иначе
				ТекущаяСтрока.Приоритет = ВидыАдресовПоПриоритету.Получить(ТекущаяСтрока.ВидАдреса);
				ТекущаяСтрока.Широта = СтруктураАдреса.latitude;
				ТекущаяСтрока.Долгота = СтруктураАдреса.longitude;
			КонецЕсли;
		Иначе
			ТаблицаАдресов.Удалить(СчетчикСтрок - 1);
			КоличествоСтрок = КоличествоСтрок - 1;
		КонецЕсли;
		
		СчетчикСтрок = СчетчикСтрок + 1;
		
	КонецЦикла;
	
	// Сортировка адресов по приоритету
	ТаблицаАдресов.Сортировать("Приоритет Убыв, ВидАдреса");
	
	Если ТаблицаАдресов.Количество() > 0 тогда
		СистемныеНастройкиБазар = ОбщегоНазначенияБазарСервер.СистемныеНастройкиБазар(ДатаНастроек);
		ВыбранныйАдрес = ТаблицаАдресов.Получить(0);
		СтруктураАдреса = СтрокуJSONВСтруктуру(ВыбранныйАдрес.СтрокаJSON);
		ВыбранныйАдрес.ПредставлениеСокращенное = СокращенноеПредставлениеАдреса(СтруктураАдреса, СистемныеНастройкиБазар.ДомашнийРегион);
		
		Возврат ВыбранныйАдрес;
		
	Иначе
		Возврат Неопределено;
		
	КонецЕсли;
	
КонецФункции

Функция ПриоритетыАдресовДоставки(КонтрагентОрганизация)
	
	ВидыАдресовПоПриоритету = Новый Соответствие;
	
	Если ТипЗнч(КонтрагентОрганизация) = Тип("СправочникСсылка.Контрагенты") тогда
		
		ВидыАдресовПоПриоритету.Вставить(ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ФактАдресКонтрагента"), 3);
		ВидыАдресовПоПриоритету.Вставить(ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ПочтовыйАдресКонтрагента"), 2);
		ВидыАдресовПоПриоритету.Вставить(ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ЮрАдресКонтрагента"), 1);
		
	ИначеЕсли ТипЗнч(КонтрагентОрганизация) = Тип("СправочникСсылка.Организации") тогда
		
		ВидыАдресовПоПриоритету.Вставить(ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ФактАдресОрганизации"), 3);
		ВидыАдресовПоПриоритету.Вставить(ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ПочтовыйАдресОрганизации"), 2);
		ВидыАдресовПоПриоритету.Вставить(ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ЮрАдресОрганизации"), 1);
		
	КонецЕсли;
	
	Возврат ВидыАдресовПоПриоритету;
	
КонецФункции

Функция СокращенноеПредставлениеАдреса(Знач Адрес, ДомашнийРегион = Неопределено) Экспорт
	
	Если ТипЗнч(Адрес) <> Тип("Структура") Тогда
		ВызватьИсключение НСтр("ru='Для формирования представления адреса передан некорректный тип адреса'");
	КонецЕсли;
	
	Если НЕ Адрес.Свойство("AddressType") тогда
		Если Адрес.Свойство("Value") тогда
			Возврат Адрес.Value;
		Иначе
			Возврат "";
		КонецЕсли;
	КонецЕсли;
	
	ТипАдреса = Адрес.AddressType;
	
	Если УправлениеКонтактнойИнформациейКлиентСервер.ЭтоАдресВСвободнойФорме(ТипАдреса) Тогда
		
		Если Не Адрес.Свойство("Country") Или ПустаяСтрока(Адрес.Country) Тогда
			Возврат Адрес.Value;
		КонецЕсли;
		
		ВПредставлениеЕстьСтрана = СтрНачинаетсяС(ВРег(Адрес.Value), ВРег(Адрес.Country));
		Если ВПредставлениеЕстьСтрана И СтрНайти(Адрес.Value, ",") > 0 Тогда
			СписокПолей = СтрРазделить(Адрес.Value, ",");
			СписокПолей.Удалить(0);
			Возврат СтрСоединить(СписокПолей, ",");
		КонецЕсли;
		
		Возврат Адрес.Value;
		
	КонецЕсли;
	
	Если НЕ ДомашнийРегион = Неопределено И НЕ ПустаяСтрока(ДомашнийРегион) тогда
		Если Адрес.Свойство("area") И Адрес.Свойство("areaType") тогда
			Если Адрес.area + " " + Адрес.areaType = ДомашнийРегион тогда
				Адрес.area  = "";
				Адрес.areaType = "";
			КонецЕсли;
		Иначе
			Если Адрес.Свойство("Value") тогда
				Возврат Адрес.Value;
			Иначе
				Возврат "";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Адрес.Свойство("ZipCode") тогда
		Адрес.ZipCode  = "";
	КонецЕсли;
	
	СписокЗаполненныхУровней = Новый Массив;
	
	Для каждого ИмяУровня Из РаботаСАдресамиКлиентСервер.ИменаУровнейАдреса(ТипАдреса, Истина) Цикл
		
		Если СтрСравнить(ИмяУровня, "locality") = 0 
			И РаботаСАдресамиКлиентСервер.ЭтоМуниципальныйАдрес(ТипАдреса)
			И ЗначениеЗаполнено(Адрес.city)
			И ПустаяСтрока(Адрес.locality) Тогда
			СписокЗаполненныхУровней.Добавить(СокрЛП(Адрес["city"] + " " + Адрес["cityType"]));
			
		ИначеЕсли Адрес.Свойство(ИмяУровня) И НЕ ПустаяСтрока(Адрес[ИмяУровня]) Тогда
			Если НЕ РаботаСАдресамиКлиентСервер.ПредставлениеУровняБезСокращения(ИмяУровня) Тогда
				Если Адрес.Свойство(ИмяУровня) и Адрес.Свойство(ИмяУровня + "Type") тогда
					СписокЗаполненныхУровней.Добавить(СокрЛП(Адрес[ИмяУровня] + " " + Адрес[ИмяУровня + "Type"]));
				Иначе
					Если Адрес.Свойство(ИмяУровня) И НЕ Адрес.Свойство(ИмяУровня + "Type") тогда
						СписокЗаполненныхУровней.Добавить(СокрЛП(Адрес[ИмяУровня]));
					КонецЕсли;
					Если НЕ Адрес.Свойство(ИмяУровня) И Адрес.Свойство(ИмяУровня + "Type") тогда
						СписокЗаполненныхУровней.Добавить(СокрЛП(Адрес[ИмяУровня + "Type"]));
					КонецЕсли;
				КонецЕсли;
			Иначе
				СписокЗаполненныхУровней.Добавить(Адрес[ИмяУровня]);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Адрес.Свойство("HouseNumber") И НЕ ПустаяСтрока(Адрес.HouseNumber) Тогда
		СписокЗаполненныхУровней.Добавить(НРег(Адрес.HouseType) + " " + Адрес.HouseNumber);
	ИначеЕсли Адрес.Свойство("stead") И Не ПустаяСтрока(Адрес.stead) Тогда
		СписокЗаполненныхУровней.Добавить("участок" + " " + Адрес.stead);
	КонецЕсли;
	
	Если Адрес.Свойство("Buildings") И Адрес.Buildings.Количество() > 0 Тогда
		
		Для каждого Строение Из Адрес.Buildings Цикл
			Если ЗначениеЗаполнено(Строение.Number) Тогда
				СписокЗаполненныхУровней.Добавить(НРег(Строение.Type) + " " + Строение.Number);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Если Адрес.Свойство("Apartments")
		И Адрес.Apartments <> Неопределено
		И Адрес.Apartments.Количество() > 0 Тогда
		
		Для каждого Строение Из Адрес.Apartments Цикл
			Если ЗначениеЗаполнено(Строение.Number) Тогда
				Если СтрСравнить(Строение.Type, "Другое") <> 0 Тогда
					СписокЗаполненныхУровней.Добавить(НРег(Строение.Type) + " " + Строение.Number);
				Иначе
					СписокЗаполненныхУровней.Добавить(Строение.Number);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Представление = СтрСоединить(СписокЗаполненныхУровней, ", ");
	
	Возврат Представление;
	
КонецФункции

#КонецОбласти

&Вместо("СтрокуJSONВСтруктуру")
Функция Базар_СтрокуJSONВСтруктуру(Значение) Экспорт
	
	Если ПустаяСтрока(Значение) тогда
		Значение = "{}";
	КонецЕсли;
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(Значение);
	
	Результат = ПрочитатьJSON(ЧтениеJSON,,,, "ВосстановлениеПолейКонтактнойИнформации", УправлениеКонтактнойИнформациейСлужебный);
	
	ЧтениеJSON.Закрыть();
	
	Возврат Результат;
	
КонецФункции