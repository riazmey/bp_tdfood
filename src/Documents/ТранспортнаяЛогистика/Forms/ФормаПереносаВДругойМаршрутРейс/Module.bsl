
&НаКлиенте
Процедура Перенести(Команда)
	
	Если Элементы.МаршрутыРейсы.ТекущиеДанные.ПолучитьРодителя() = Неопределено И
		Элементы.МаршрутыРейсы.ТекущиеДанные.ПолучитьЭлементы().Количество() > 0 тогда
		Возврат;
	КонецЕсли;
	
	Если МаршрутИсточник = Элементы.МаршрутыРейсы.ТекущиеДанные.Маршрут тогда
		
		ТекстСообщения = "";
		Если РейсИсточник = Элементы.МаршрутыРейсы.ТекущиеДанные.Рейс тогда
			ТекстСообщения = "Не имеет смысла переносить точки рейса маршрута в тоже маршрут и рейс!";
		КонецЕсли;
		
		Если Элементы.МаршрутыРейсы.ТекущиеДанные.Рейс > РейсИсточник тогда
			ТекстСообщения = "Нельзя переносить точки рейса маршрута, в больший рейс этого же маршрута!";
		КонецЕсли;
		
		Если ВыделеныВсеСтрокиРейса И Элементы.МаршрутыРейсы.ТекущиеДанные.Рейс > РейсИсточник тогда
			Если Элементы.МаршрутыРейсы.ТекущиеДанные.Маршрут = МаршрутИсточник тогда
				ТекстСообщения = "Нельзя переносить все точки рейса маршрута, в больший рейс того же маршрута!";
			КонецЕсли;
		КонецЕсли;
		
		Если Не ПустаяСтрока(ТекстСообщения) тогда
			ПоказатьПредупреждение(
				Новый ОписаниеОповещения(),
				ТекстСообщения
			);
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("СамовывозИсточник", СамовывозИсточник);
	ПараметрыЗакрытия.Вставить("ВыделенныеСтроки" , ВходящиеПараметры.ВыделенныеСтроки);
	ПараметрыЗакрытия.Вставить("МаршрутИсточник"  , МаршрутИсточник);
	ПараметрыЗакрытия.Вставить("РейсИсточник"     , РейсИсточник);
	ПараметрыЗакрытия.Вставить("Маршрут"          , Элементы.МаршрутыРейсы.ТекущиеДанные.Маршрут);
	ПараметрыЗакрытия.Вставить("Рейс"             , Элементы.МаршрутыРейсы.ТекущиеДанные.Рейс);
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Для Каждого СтрокаМаршрута из Параметры.Маршруты цикл
		НоваяСтрокаМаршрута = Маршруты.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаМаршрута, СтрокаМаршрута);
		Если ЗначениеЗаполнено(НоваяСтрокаМаршрута.Водитель) тогда
			НоваяСтрокаМаршрута.Перевозчик = НоваяСтрокаМаршрута.Водитель.Перевозчик;
		Иначе
			Если ЗначениеЗаполнено(НоваяСтрокаМаршрута.Автомобиль) тогда
				НоваяСтрокаМаршрута.Перевозчик = НоваяСтрокаМаршрута.Автомобиль.Перевозчик;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	МаршрутИсточник        = Параметры.МаршрутИсточник;
	РейсИсточник           = Параметры.РейсИсточник;
	ВыделеныВсеСтрокиРейса = Параметры.ВыделеныВсеСтрокиРейса;
	
	Если ЗначениеЗаполнено(МаршрутИсточник) тогда
		СамовывозИсточник = МаршрутИсточник.Самовывоз;
	Иначе
		СамовывозИсточник = Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр(
		"ТаблицаМаршруты",
		Маршруты.Выгрузить()
	);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ТаблицаМаршруты.Маршрут КАК Справочник.Маршруты) КАК Маршрут,
	|	ВЫРАЗИТЬ(ТаблицаМаршруты.НомерСтроки КАК ЧИСЛО(15, 0)) КАК НомерСтроки,
	|	ВЫРАЗИТЬ(ТаблицаМаршруты.Самовывоз КАК БУЛЕВО) КАК Самовывоз,
	|	ВЫРАЗИТЬ(ТаблицаМаршруты.Водитель КАК Справочник.Водители) КАК Водитель,
	|	ВЫРАЗИТЬ(ТаблицаМаршруты.Автомобиль КАК Справочник.Автомобили) КАК Автомобиль,
	|	ВЫРАЗИТЬ(ТаблицаМаршруты.Перевозчик КАК Справочник.Контрагенты) КАК Перевозчик,
	|	ВЫРАЗИТЬ(ТаблицаМаршруты.Наценка КАК ЧИСЛО(15, 2)) КАК Наценка,
	|	ВЫРАЗИТЬ(ТаблицаМаршруты.Тоннаж КАК ЧИСЛО(10, 3)) КАК Тоннаж
	|ПОМЕСТИТЬ ТаблицаМаршруты
	|ИЗ
	|	&ТаблицаМаршруты КАК ТаблицаМаршруты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ТаблицаМаршруты.НомерСтроки, 99999) КАК НомерМаршрута,
	|	ЕСТЬNULL(ТаблицаМаршруты.Маршрут, Маршруты.Ссылка) КАК Маршрут,
	|	ВЫБОР
	|		КОГДА ТаблицаМаршруты.Маршрут = ЗНАЧЕНИЕ(Справочник.Маршруты.ПустаяСсылка)
	|			ТОГДА ""НЕ РАСПРЕДЕЛЕНО""
	|		ИНАЧЕ ВЫРАЗИТЬ(ЕСТЬNULL(ТаблицаМаршруты.Маршрут, Маршруты.Ссылка) КАК Справочник.Маршруты).Наименование
	|	КОНЕЦ КАК Представление,
	|	ЕСТЬNULL(ТаблицаМаршруты.Самовывоз, Маршруты.Самовывоз) КАК Самовывоз,
	|	ЕСТЬNULL(ТаблицаМаршруты.Водитель, ЗНАЧЕНИЕ(Справочник.Водители.ПустаяСсылка)) КАК Водитель,
	|	ЕСТЬNULL(ТаблицаМаршруты.Автомобиль, ЗНАЧЕНИЕ(Справочник.Автомобили.ПустаяСсылка)) КАК Автомобиль,
	|	ЕСТЬNULL(ТаблицаМаршруты.Перевозчик, ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)) КАК Перевозчик,
	|	СУММА(ЕСТЬNULL(ТаблицаМаршруты.Тоннаж, 0)) КАК Тоннаж,
	|	СУММА(ЕСТЬNULL(ТаблицаМаршруты.Наценка, 0)) КАК Наценка
	|ИЗ
	|	ТаблицаМаршруты КАК ТаблицаМаршруты
	|		ПОЛНОЕ СОЕДИНЕНИЕ Справочник.Маршруты КАК Маршруты
	|		ПО ТаблицаМаршруты.Маршрут = Маршруты.Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ЕСТЬNULL(ТаблицаМаршруты.Маршрут, Маршруты.Ссылка),
	|	ВЫБОР
	|		КОГДА ТаблицаМаршруты.Маршрут = ЗНАЧЕНИЕ(Справочник.Маршруты.ПустаяСсылка)
	|			ТОГДА ""НЕ РАСПРЕДЕЛЕНО""
	|		ИНАЧЕ ВЫРАЗИТЬ(ЕСТЬNULL(ТаблицаМаршруты.Маршрут, Маршруты.Ссылка) КАК Справочник.Маршруты).Наименование
	|	КОНЕЦ,
	|	ЕСТЬNULL(ТаблицаМаршруты.Водитель, ЗНАЧЕНИЕ(Справочник.Водители.ПустаяСсылка)),
	|	ЕСТЬNULL(ТаблицаМаршруты.Автомобиль, ЗНАЧЕНИЕ(Справочник.Автомобили.ПустаяСсылка)),
	|	ЕСТЬNULL(ТаблицаМаршруты.Перевозчик, ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)),
	|	ЕСТЬNULL(ТаблицаМаршруты.Самовывоз, Маршруты.Самовывоз),
	|	ЕСТЬNULL(ТаблицаМаршруты.НомерСтроки, 99999)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерМаршрута,
	|	Представление";
	
	ВыборкаМаршрутов = Запрос.Выполнить().Выбрать();
	
	Пока ВыборкаМаршрутов.Следующий() цикл
		
		Если НЕ ЗначениеЗаполнено(ВыборкаМаршрутов.Маршрут) тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрокаМаршрута = МаршрутыРейсы.ПолучитьЭлементы().Добавить();
		
		ЗаполнитьЗначенияСвойств(НоваяСтрокаМаршрута, ВыборкаМаршрутов);
		
		Если НЕ ВыборкаМаршрутов.Самовывоз тогда
			
			ПоследнийНомерРейса = 0;
			
			Для Каждого ДанныеРейса из Параметры.Рейсы цикл
				
				Если НЕ ДанныеРейса.Маршрут = ВыборкаМаршрутов.Маршрут тогда
					Продолжить;
				КонецЕсли;
				
				ДобавитьРейсВМаршрутыРейсы(НоваяСтрокаМаршрута,
				                           ДанныеРейса.Рейс,
				                           ДанныеРейса.Тоннаж,
				                           ДанныеРейса.Наценка);
				
				ПоследнийНомерРейса = ПоследнийНомерРейса + 1;
			КонецЦикла;
			
			Если ПоследнийНомерРейса > 0 тогда
				ДобавитьРейсВМаршрутыРейсы(НоваяСтрокаМаршрута, ПоследнийНомерРейса + 1, 0, 0);
			КонецЕсли;
		Иначе
			НоваяСтрокаМаршрута.Рейс = 1;
		КонецЕсли;
		
	КонецЦикла;
	
	ВходящиеПараметры = Новый Структура;
	ВходящиеПараметры.Вставить("ВыделенныеСтроки", Параметры.ВыделенныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(МаршрутИсточник) И ЗначениеЗаполнено(РейсИсточник) тогда
		УстановитьТекущуюСтрокуМаршрутыРейсы();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьРейсВМаршрутыРейсы(СтрокаМаршрута, НомерРейса, Тоннаж, Наценка)
	
	НоваяСтрокаРейса = СтрокаМаршрута.ПолучитьЭлементы().Добавить();
	НоваяСтрокаРейса.Маршрут = СтрокаМаршрута.Маршрут;
	НоваяСтрокаРейса.Водитель = СтрокаМаршрута.Водитель;
	НоваяСтрокаРейса.Автомобиль = СтрокаМаршрута.Автомобиль;
	НоваяСтрокаРейса.Рейс = НомерРейса;
	НоваяСтрокаРейса.Представление = "Рейс №" + Строка(НомерРейса);
	НоваяСтрокаРейса.Тоннаж = Тоннаж;
	НоваяСтрокаРейса.Наценка = Наценка;
	
КонецПроцедуры

&НаКлиенте
Процедура МаршрутыРейсыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Перенести(Элемент);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекущуюСтрокуМаршрутыРейсы()
	
	ТекущаяСтрокаУстановлена = Ложь;
	
	Для Каждого СтрокаМаршрут из МаршрутыРейсы.ПолучитьЭлементы() цикл
		
		Если СтрокаМаршрут.Маршрут = МаршрутИсточник тогда
			
			Если НЕ СтрокаМаршрут.Самовывоз тогда
				Для Каждого СтрокаРейс из СтрокаМаршрут.ПолучитьЭлементы() цикл
					
					Если СтрокаРейс.Рейс = РейсИсточник тогда
						
						Элементы.МаршрутыРейсы.ТекущаяСтрока = СтрокаРейс.ПолучитьИдентификатор();
						ТекущаяСтрокаУстановлена = Истина;
						Прервать;
						
					КонецЕсли;
					
				КонецЦикла;
			Иначе
				Элементы.МаршрутыРейсы.ТекущаяСтрока = СтрокаМаршрут.ПолучитьИдентификатор();
				Прервать;
			КонецЕсли;
			
		КонецЕсли;
		
		Если ТекущаяСтрокаУстановлена тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура МаршрутыРейсыПриАктивизацииСтрокиНаСервере()
	
	ИменаПолей = Новый Массив;
	ИменаПолей.Добавить("Водитель");
	ИменаПолей.Добавить("Автомобиль");
	
	ДанныеТекущейСтроки = МаршрутыРейсы.НайтиПоИдентификатору(Элементы.МаршрутыРейсы.ТекущаяСтрока);
	
	Для Каждого ИмяПоля из ИменаПолей цикл
		
		ПолеПоУмолчанию = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеТекущейСтроки.Маршрут, ИмяПоля);
		
		Если ЗначениеЗаполнено(ДанныеТекущейСтроки[ИмяПоля]) тогда
			ЭтаФорма[ИмяПоля] = ДанныеТекущейСтроки[ИмяПоля];
		Иначе
			НайденыеСтроки = Документы.ТранспортнаяЛогистика.НайтиВТаблицеМаршрутыВодителяИлиАвтомобиль(ЭтаФорма, ИмяПоля, ПолеПоУмолчанию);
			Если НайденыеСтроки.Количество() > 0 тогда
				ЭтаФорма[ИмяПоля] = Неопределено;
			Иначе
				ЭтаФорма[ИмяПоля] = ПолеПоУмолчанию;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтложенноеМаршрутыРейсыПриАктивизацииСтроки()
	
	Если НЕ Элементы.МаршрутыРейсы.ТекущиеДанные.Самовывоз тогда
		
		Элементы.Водитель.Видимость = Истина;
		Элементы.Автомобиль.Видимость = Истина;
		Элементы.Перевозчик.Видимость = Истина;
		
		МаршрутыРейсыПриАктивизацииСтрокиНаСервере();
		
	Иначе
		
		Элементы.Водитель.Видимость = Ложь;
		Элементы.Автомобиль.Видимость = Ложь;
		Элементы.Перевозчик.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МаршрутыРейсыПриАктивизацииСтроки(Элемент)
	
	Если Элементы.МаршрутыРейсы.ТекущаяСтрока = Неопределено тогда
		Возврат;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ОтложенноеМаршрутыРейсыПриАктивизацииСтроки", 0.1, Истина);
	
КонецПроцедуры

