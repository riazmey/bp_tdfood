#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Заполним реквизиты формы из параметров.
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры,
		"Организация, Контрагент, ДоговорКонтрагента, Грузоотправитель, Грузополучатель,
		|АдресДоставки, АдресДоставкиJSON, Дата, СведенияОТранспортировкеИГрузе,
		|ПеревозкаАвтотранспортом, АвтомобильСсылка, ВодительСсылка, Маршрут,
		|Перевозчик, МаркаАвтомобиля, РегистрационныйЗнакАвтомобиля,
		|Водитель, ВодительскоеУдостоверение, КраткоеНаименованиеГруза,
		|СопроводительныеДокументы, РазделПеревозкаАвтотранспортом,
		|ВремяЛогистикиНачало, ВремяЛогистикиОкончание, Ссылка, ТолькоПросмотр");
	
	ПолноеНаименованиеКонтрагента = "";
	
	Если Грузополучатель = Контрагент тогда
		Грузополучатель = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
	КонецЕсли;
	
	Если Грузоотправитель = Организация тогда
		Грузоотправитель = ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка");
	КонецЕсли;
	
	// Отобразим грузоотправителя и грузополучателя
	Если НЕ ЗначениеЗаполнено(Грузоотправитель) Тогда
		ГрузоотправительОнЖе = 1;
	Иначе
		Если Грузоотправитель = Организация тогда
			ГрузоотправительОнЖе = 1;
			Грузоотправитель = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
		Иначе
			ГрузоотправительОнЖе = 0;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Грузополучатель) Тогда
		ГрузополучательОнЖе = 1;
	Иначе
		Если Грузополучатель = Контрагент тогда
			ГрузополучательОнЖе = 1;
			Грузоотправитель = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
		Иначе
			ГрузополучательОнЖе = 0;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Перевозчик) Тогда
		ПеревозчикОнЖе = 1;
	Иначе
		ПеревозчикОнЖе = 0;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		ТекстГрузоотправительОнЖе = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "Наименование");
	Иначе
		ТекстГрузоотправительОнЖе = НСтр("ru = 'Организация'");
	КонецЕсли;
	Элементы.ГрузоотправительОнЖе1.СписокВыбора[0].Представление = ТекстГрузоотправительОнЖе;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		ТекстПеревозчикОнЖе = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "Наименование");
	Иначе
		ТекстПеревозчикОнЖе = НСтр("ru = 'Организация'");
	КонецЕсли;
	Элементы.ПеревозчикОнЖе1.СписокВыбора[0].Представление = ТекстПеревозчикОнЖе;
	
	Если ЗначениеЗаполнено(Контрагент) Тогда
		РеквизитыКонтрагента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			Контрагент, "Наименование, НаименованиеПолное");
	
		ТекстГрузополучательОнЖе = РеквизитыКонтрагента.Наименование;
		
		Если ЗначениеЗаполнено(РеквизитыКонтрагента.НаименованиеПолное) Тогда
			ПолноеНаименованиеКонтрагента = РеквизитыКонтрагента.НаименованиеПолное;
		Иначе
			НаименованиеКонтрагента = РеквизитыКонтрагента.Наименование;
		КонецЕсли;
	Иначе
		ТекстГрузополучательОнЖе = НСтр("ru = 'Контрагент'");
	КонецЕсли;
	Элементы.ГрузополучательОнЖе1.СписокВыбора[0].Представление = ТекстГрузополучательОнЖе;
	
	// Заполнение адреса
	ЗаполнитьСписокАдресовДоставки();
	ДанныеАдресаДоставкиJSON = УправлениеКонтактнойИнформациейСлужебный.ДанныеАдресаДоставкиJSON(АдресДоставкиJSON, Дата);
	АдресДоставки = ДанныеАдресаДоставкиJSON.АдресДоставки;
	АдресДоставкиJSON = ДанныеАдресаДоставкиJSON.АдресДоставкиJSON;
	Если ДанныеАдресаДоставкиJSON.АдресДоставкиСтруктура.Свойство("latitude")
		И ДанныеАдресаДоставкиJSON.АдресДоставкиСтруктура.Свойство("longitude") тогда
		Широта = ДанныеАдресаДоставкиJSON.АдресДоставкиСтруктура.latitude;
		Долгота = ДанныеАдресаДоставкиJSON.АдресДоставкиСтруктура.longitude;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(АдресДоставкиJSON) тогда
		ОбновитьСписокАдресовДоставки();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДоговорКонтрагента) тогда
		ВидДоговора = ДоговорКонтрагента.ВидДоговора;
	КонецЕсли;
	
	Если Параметры.РазделПеревозкаАвтотранспортом тогда
		Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьДоставкуАвтотранспортом") тогда
			Элементы.ПеревозкаАвтотранспортом.Видимость = Ложь;
			Элементы.СтраницаПеревозкаАвтотранспортом.Видимость = Ложь;
			Элементы.ГруппаФормаЛево.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
		КонецЕсли;
		Если НЕ ТранспортнаяЛогистикаСервер.ДокументУчаствуетВТранспортнойЛогистике(Ссылка) тогда
			Элементы.ЗаполнитьРазделПеревозкаАвтотранспортом.Видимость = Ложь;
			Элементы.Маршрут.Видимость = Ложь;
			Маршрут = ПредопределенноеЗначение("Справочник.Маршруты.ПустаяСсылка");
		КонецЕсли;
	КонецЕсли;
	
	УстановитьРежимРаботыWebКарты();
	
	// Удаляем сохраненные настройки размеров формы
	ХранилищеСистемныхНастроек.Удалить("ОбщаяФорма.ДокументДоставка/НастройкиФормы", "", Пользователи.ТекущийПользователь());
	ХранилищеСистемныхНастроек.Удалить("ОбщаяФорма.ДокументДоставка/НастройкиОкна", "", Пользователи.ТекущийПользователь());
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СписВремени = ТранспортнаяЛогистикаКлиент.СписокВремениНачалаЛогистики();
	Элементы.ВремяЛогистикиНачало.СписокВыбора.Очистить();
	Элементы.ВремяЛогистикиОкончание.СписокВыбора.Очистить();
	Для Каждого Элемент из СписВремени Цикл
		Элементы.ВремяЛогистикиНачало.СписокВыбора.Добавить(Элемент.Значение,Элемент.Представление);
		Элементы.ВремяЛогистикиОкончание.СписокВыбора.Добавить(Элемент.Значение,Элемент.Представление);
	КонецЦикла;
	
	ФайловаяСистемаКлиент.СоздатьВременныйКаталог(Новый ОписаниеОповещения(
		"ОбработкаОповещенияСоздатьВременныйКаталогФормы"
		, ЭтаФорма));
		
КонецПроцедуры

&НаСервере
Процедура УстановитьРежимРаботыWebКарты()
	
	Если ГрузоотправительОнЖе = 1 Тогда
		ВыбранныйГрузоотправитель = Организация;
	Иначе
		ВыбранныйГрузоотправитель = Грузоотправитель;
	КонецЕсли;
	
	ДанныеАдреса = УправлениеКонтактнойИнформациейСлужебный.ДанныеАдресаДоставкиПоУмолчанию(ВыбранныйГрузоотправитель);
	
	Если ДанныеАдреса = Неопределено тогда
		НовыйРежимРаботыWebКарты = "КонтактнаяИнформация";
	Иначе
		НовыйРежимРаботыWebКарты = "РасчетМаршрута";
	КонецЕсли;
	
	Если НовыйРежимРаботыWebКарты <> РежимРаботыWebКарты тогда
		WebMapStruct = Undefined;
	КонецЕсли;
	
	РежимРаботыWebКарты = НовыйРежимРаботыWebКарты;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	ИначеЕсли Модифицированность И НЕ ПеренестиВДокумент Тогда
		Отказ = Истина;
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗакрытиемФормыЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Да);
	КонецЕсли;

	Если ПеренестиВДокумент И НЕ Отказ Тогда
		ОбработкаПроверкиЗаполненияНаКлиенте(Отказ);
	КонецЕсли;

	Если Отказ Тогда
		ПеренестиВДокумент = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)

	Если ПеренестиВДокумент И Модифицированность Тогда
		СтруктураРезультат = Новый Структура(
		"Организация, Контрагент, Грузоотправитель, Грузополучатель,
		|АдресДоставки, АдресДоставкиJSON, Дата, СведенияОТранспортировкеИГрузе,
		|ПеревозкаАвтотранспортом, АвтомобильСсылка, ВодительСсылка,
		|Перевозчик, МаркаАвтомобиля, РегистрационныйЗнакАвтомобиля,
		|Водитель, ВодительскоеУдостоверение, КраткоеНаименованиеГруза,
		|СопроводительныеДокументы, РазделПеревозкаАвтотранспортом,
		|ВремяЛогистикиНачало, ВремяЛогистикиОкончание");
		
		Если НЕ ЗначениеЗаполнено(Грузополучатель) тогда
			Грузополучатель = Контрагент;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Грузоотправитель) тогда
			Грузоотправитель = Организация;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(СтруктураРезультат, ЭтаФорма);
		
		Если ГрузоотправительОнЖе = 1 Тогда
			СтруктураРезультат.Грузоотправитель = Неопределено;
		КонецЕсли;

		Если ГрузополучательОнЖе = 1 Тогда
			СтруктураРезультат.Грузополучатель = Неопределено;
		КонецЕсли;
		
		Если ПеревозчикОнЖе = 1 Тогда
			СтруктураРезультат.Перевозчик = Неопределено;
		КонецЕсли;
		
		ОповеститьОВыборе(СтруктураРезультат);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчкиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГрузоотправительОнЖеПриИзменении(Элемент)
	
	ОбновитьСписокАдресовДоставки();
	УправлениеФормой(ЭтаФорма);
	УстановитьРежимРаботыWebКарты();
	WebMapUpdate();

КонецПроцедуры

&НаКлиенте
Процедура ГрузоотправительПриИзменении(Элемент)
	
	ОбновитьСписокАдресовДоставки();
	УстановитьРежимРаботыWebКарты();
	WebMapUpdate();
	
КонецПроцедуры

&НаКлиенте
Процедура ГрузоотправительАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	РаботаСКонтрагентамиБПКлиент.КонтрагентАвтоПодбор(
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ГрузоотправительОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	РаботаСКонтрагентамиБПКлиент.КонтрагентОкончаниеВводаТекста(
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
		
КонецПроцедуры

&НаКлиенте
Процедура ГрузоотправительОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РаботаСКонтрагентамиБПКлиент.КонтрагентОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ГрузополучательОнЖеПриИзменении(Элемент)
	
	ГрузополучательОнЖеПриИзмененииНаСервере();
	WebMapUpdate();

КонецПроцедуры

&НаКлиенте
Процедура ГрузополучательПриИзменении(Элемент)
	
	ОбновитьСписокАдресовДоставки();
	WebMapUpdate();

КонецПроцедуры

&НаКлиенте
Процедура ГрузополучательАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	РаботаСКонтрагентамиБПКлиент.КонтрагентАвтоПодбор(
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ГрузополучательОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	РаботаСКонтрагентамиБПКлиент.КонтрагентОкончаниеВводаТекста(
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
		
КонецПроцедуры

&НаКлиенте
Процедура ГрузополучательОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РаботаСКонтрагентамиБПКлиент.КонтрагентОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПеревозчикОнЖеПриИзменении(Элемент)
	
	ПеревозчикПриИзмененииНаСервере();
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПеревозчикАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	РаботаСКонтрагентамиБПКлиент.КонтрагентАвтоПодбор(
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
		
КонецПроцедуры

&НаКлиенте
Процедура ПеревозчикОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	РаботаСКонтрагентамиБПКлиент.КонтрагентОкончаниеВводаТекста(
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
		
КонецПроцедуры

&НаКлиенте
Процедура ПеревозчикОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РаботаСКонтрагентамиБПКлиент.КонтрагентОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВодительАвтомобильНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	УстановитьПараметрыВыбораВодительАвтомобиль(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ПеревозкаАвтотранспортомПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
	Если НЕ ПеревозкаАвтотранспортом тогда
		АдресДоставки = "";
		АдресДоставкиJSON = "";
		Широта = 0;
		Долгота = 0;
		ВремяЛогистикиНачало = Дата(1,1,1,0,0,0);
		ВремяЛогистикиОкончание = Дата(1,1,1,0,0,0);
		WebMapStruct = Undefined;
	Иначе
		ОбновитьСписокАдресовДоставки();
		ВремяЛогистикиНачало = ВернутьРеквизитОбъекта(ДоговорКонтрагента, "ВремяЛогистикиНачало");
		ВремяЛогистикиОкончание = ВернутьРеквизитОбъекта(ДоговорКонтрагента, "ВремяЛогистикиОкончание");
		АдресДоставкиОбработкаВыбораНаСервере(АдресДоставкиJSON);
		WebMapUpdate();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВернутьРеквизитОбъекта(СсылкаНаОбъект, Реквизит)
	
	Возврат СсылкаНаОбъект[Реквизит];
	
КонецФункции

&НаКлиенте
Процедура АдресДоставкиПриИзменении(Элемент)
	
	УправлениеФормой(ЭтотОбъект);
	Модифицированность = Истина;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПеревозчикПриИзменении(Элемент)
	
	ПеревозчикПриИзмененииНаСервере();
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПеревозчикПриИзмененииНаСервере()
	
	Если ПеревозчикОнЖе = 1 Тогда
		ВыбранныйПеревозчик = Организация;
	Иначе
		ВыбранныйПеревозчик = Перевозчик;
	КонецЕсли;
	
	Если ВыбранныйПеревозчик <> ВодительСсылка.Перевозчик тогда
		ВодительСсылка = ПредопределенноеЗначение("Справочник.Водители.ПустаяСсылка");
	КонецЕсли;
	
	Если ВыбранныйПеревозчик <> АвтомобильСсылка.Перевозчик тогда
		АвтомобильСсылка = ПредопределенноеЗначение("Справочник.Автомобили.ПустаяСсылка");
	КонецЕсли;
	
	ДанныеТранспортнойЛогистики = ТранспортнаяЛогистикаСервер.ДанныеТранспортнойЛогистики(Ссылка);
	
	Если НЕ ДанныеТранспортнойЛогистики.ВодительСсылка = ВодительСсылка
	 ИЛИ НЕ ДанныеТранспортнойЛогистики.АвтомобильСсылка = АвтомобильСсылка Тогда
		Маршрут = ПредопределенноеЗначение("Справочник.Маршруты.ПустаяСсылка");
	Иначе
		Маршрут = ДанныеТранспортнойЛогистики.Маршрут;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КраткоеНаименованиеГрузаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СформироватьНаименованиеГруза();
	
КонецПроцедуры

&НаКлиенте
Процедура СопроводительныеДокументыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СформироватьТекстСопроводительныхДокументов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ПеренестиВДокумент = Истина;
	Закрыть();

КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Модифицированность = Ложь;
	ПеренестиВДокумент = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;

	Элементы.Грузоотправитель.Доступность = (Форма.ГрузоотправительОнЖе = 0);
	Элементы.Грузополучатель.Доступность = (Форма.ГрузополучательОнЖе = 0);
	Элементы.Перевозчик.Доступность = (Форма.ПеревозчикОнЖе = 0);
	
	Если Форма.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПокупателем") тогда
		Элементы.ВремяЛогистикиНачало.Заголовок = "Время начала доставки";
		Элементы.ВремяЛогистикиОкончание.Заголовок = "Время окончания доставки";
		
	ИначеЕсли Форма.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПоставщиком") тогда
		Элементы.ВремяЛогистикиНачало.Заголовок = "Время начала закупки";
		Элементы.ВремяЛогистикиОкончание.Заголовок = "Время окончания закупки";
		
	Иначе	
		Элементы.ГруппаВремяЛогистики.Видимость = Ложь;
		
	КонецЕсли;
	
	Если Форма.РазделПеревозкаАвтотранспортом И Форма.ПеревозкаАвтотранспортом тогда
		Элементы.СтраницаПеревозкаАвтотранспортом.Видимость = Истина;
		Элементы.ГруппаФормаЛево.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
	Иначе
		Элементы.СтраницаПеревозкаАвтотранспортом.Видимость = Ложь;
		Элементы.ГруппаФормаЛево.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	КонецЕсли;
	
	Если Форма.ПеревозкаАвтотранспортом тогда
		Элементы.ГруппаВремяЛогистики.Видимость = Истина;
		Элементы.АдресДоставки.Видимость = Истина;
		Элементы.ГруппаФормаПраво.Видимость = Истина;
	Иначе
		Элементы.ГруппаВремяЛогистики.Видимость = Ложь;
		Элементы.АдресДоставки.Видимость = Ложь;
		Элементы.ГруппаФормаПраво.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ЗаполнитьРазделПеревозкаАвтотранспортом.Доступность = НЕ Форма.ТолькоПросмотр;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокАдресовДоставки()

	Если ГрузополучательОнЖе = 1 Тогда
		ВыбранныйГрузополучатель = Контрагент;
	Иначе
		ВыбранныйГрузополучатель = Грузополучатель;
	КонецЕсли;

	ЗаполнитьСписокАдресовДоставки();
	Если Элементы.АдресДоставки.СписокВыбора.Количество() > 0 Тогда
		АдресДоставкиОбработкаВыбораНаСервере(Элементы.АдресДоставки.СписокВыбора[0].Значение);
	Иначе
		Широта = 0;
		Долгота = 0;
		АдресДоставки = "";
		АдресДоставкиJSON = "";
	КонецЕсли;
	
	Если ГрузоотправительОнЖе = 1 Тогда
		ВыбранныйГрузоотправитель = Организация;
	Иначе
		ВыбранныйГрузоотправитель = Грузоотправитель;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаПроверкиЗаполненияНаКлиенте(Отказ)
	
	Если ПеревозкаАвтотранспортом тогда
		
		ОбязательныеПоля = Новый Массив;
		ОбязательныеПоля.Добавить("ВремяЛогистикиНачало");
		ОбязательныеПоля.Добавить("ВремяЛогистикиОкончание");
		ОбязательныеПоля.Добавить("АдресДоставки");
		
		Если РазделПеревозкаАвтотранспортом тогда
			ОбязательныеПоля.Добавить("АвтомобильСсылка");
			ОбязательныеПоля.Добавить("ВодительСсылка");
			ОбязательныеПоля.Добавить("КраткоеНаименованиеГруза");
		КонецЕсли;
		
		Для Каждого Поле из ОбязательныеПоля цикл
			Если НЕ ЗначениеЗаполнено(ЭтаФорма[Поле]) тогда
				
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
					"Поле", "Заполнение", НСтр("ru = '"+Элементы[Поле].Заголовок+"'"));
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстСообщения, ,
					Поле,
					"",
					Отказ
				);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Если ГрузоотправительОнЖе = 0 Тогда
		Если НЕ ЗначениеЗаполнено(Грузоотправитель) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
				"Поле", "Заполнение", НСтр("ru = 'Грузоотправитель'"));
			Поле = "Грузоотправитель";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения, ,
				Поле,
				"",
				Отказ
			);
		КонецЕсли;
	КонецЕсли;
	
	Если ГрузополучательОнЖе = 0 Тогда
		Если НЕ ЗначениеЗаполнено(Грузополучатель) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
				"Поле", "Заполнение", НСтр("ru = 'Грузополучатель'"));
			Поле = "Грузополучатель";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения, ,
				Поле,
				"",
				Отказ
			);
		КонецЕсли;
	КонецЕсли;
	
	Если ПеревозчикОнЖе = 0 Тогда
		Если НЕ ЗначениеЗаполнено(Перевозчик) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
				"Поле", "Заполнение", НСтр("ru = 'Перевозчик'"));
			Поле = "Перевозчик";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения, ,
				Поле,
				"",
				Отказ
			);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ГрузополучательОнЖеПриИзмененииНаСервере()

	ОбновитьСписокАдресовДоставки();
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗакрытиемФормыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПеренестиВДокумент = Истина;
		Закрыть();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		ПеренестиВДокумент = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресДоставкиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	АдресДоставкиОбработкаВыбораНаСервере(ВыбранноеЗначение);
	WebMapUpdate();
	
КонецПроцедуры

&НаСервере
Процедура АдресДоставкиОбработкаВыбораНаСервере(ВыбранноеЗначение)
	
	ДанныеАдресаДоставкиJSON = УправлениеКонтактнойИнформациейСлужебный.ДанныеАдресаДоставкиJSON(ВыбранноеЗначение, Дата);
	АдресДоставки = ДанныеАдресаДоставкиJSON.АдресДоставки;
	АдресДоставкиJSON = ДанныеАдресаДоставкиJSON.АдресДоставкиJSON;
	
	Если ДанныеАдресаДоставкиJSON.АдресДоставкиСтруктура.Свойство("latitude")
		И ДанныеАдресаДоставкиJSON.АдресДоставкиСтруктура.Свойство("longitude") тогда
		Широта = ДанныеАдресаДоставкиJSON.АдресДоставкиСтруктура.latitude;
		Долгота = ДанныеАдресаДоставкиJSON.АдресДоставкиСтруктура.longitude;
	КонецЕсли;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыВыбораВодительАвтомобиль(ИмяПоля)
	
	Элементы[ИмяПоля].ПараметрыВыбора = Новый ФиксированныйМассив(Новый Массив());
	
	Если ПеревозчикОнЖе = 1 Тогда
		ВыбранныйПеревозчик = Организация;
	Иначе
		ВыбранныйПеревозчик = Перевозчик;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВыбранныйПеревозчик) тогда
		ПараметрыВыбора= Новый Массив();
		ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Перевозчик", ВыбранныйПеревозчик));
		
		НовыеПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);
		
		Элементы[ИмяПоля].ПараметрыВыбора = НовыеПараметрыВыбора;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьНаименованиеГруза()
	
	МассивНоменклатуры = Ссылка.Товары.ВыгрузитьКолонку("Номенклатура");
	КраткоеНаименованиеГруза = СопроводительныеДокументыСервер.КраткоеНаименованиеГруза(МассивНоменклатуры);
	
КонецПроцедуры

&НаСервере
Процедура СформироватьТекстСопроводительныхДокументов()
	
	МассивНоменклатуры = Ссылка.Товары.ВыгрузитьКолонку("Номенклатура");
	
	СопроводительныеДокументы = СопроводительныеДокументыСервер.ТекстСопроводительныеДокументыНоменклатуры(
		Ссылка.ДоговорКонтрагента,
		МассивНоменклатуры,
		Ссылка.Дата,
		Неопределено,
		Истина
	);
	
КонецПроцедуры

#КонецОбласти


&НаСервере
Процедура ЗаполнитьСписокАдресовДоставки()
	
	Если ГрузополучательОнЖе = 1 Тогда
		ВыбранныйГрузополучатель = Контрагент;
	Иначе
		ВыбранныйГрузополучатель = Грузополучатель;
	КонецЕсли;
	
	СписокАдресов = УправлениеКонтактнойИнформациейСлужебный.СписокАдресовДоставки(ВыбранныйГрузополучатель, Дата);
	
	Элементы.АдресДоставки.СписокВыбора.Очистить();
	Для Каждого ЭлементСписка Из СписокАдресов цикл
		Элементы.АдресДоставки.СписокВыбора.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Procedure WebMapUpdate()
	
	InitWebMap();
	
	IF NOT WebMapStruct = Undefined Then
		
		IF ValueIsFilled(Широта) AND ValueIsFilled(Долгота) Then
			If ГрузополучательОнЖе = 1 Then
				SelectedShipper = Контрагент;
			Else
				SelectedShipper = Грузополучатель;
			EndIf;

			
			IF РежимРаботыWebКарты = "КонтактнаяИнформация" Then
				
				Latitude  = Format(Широта , "ЧЦ=10; ЧДЦ=7; ЧРД=.; ЧРГ=");
				Longitude = Format(Долгота, "ЧЦ=10; ЧДЦ=7; ЧРД=.; ЧРГ=");
				WebMapClient.AddPlacemark(Элементы.WEBКарта,
				                    Latitude,
									Longitude,
									WebMapStruct.Color,
									WebMapStruct.TypeIcon,
									SelectedShipper,
									АдресДоставки);
			Else
				If ГрузоотправительОнЖе = 1 Then
					SelectedConsignee = Организация;
				Else
					SelectedConsignee = Грузоотправитель;
				EndIf;
				
				ArrayRoutes = New Array;
				ArrayPoints = New Array;
				
				// New route
				Route = New Structure;
				
				// Add SelectedConsignee
				OtherOptions = New Structure;
				OtherOptions.Insert("NumCruise"   , Format(1, "ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0"));
				OtherOptions.Insert("NumInCruise" , Format(0, "ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0"));
				OtherOptions.Insert("Color"       , WebMapStruct.ColorPalette.Get("red"));
				OtherOptions.Insert("TypeIcon"    , WebMapStruct.IconsСollection.islandsstandart.Get("home"));
				ArrayPoints.Add(WebMapServer.CreatePointStructFromPartner(SelectedConsignee, OtherOptions));				
				
				// Add SelectedShipper
				OtherOptions = New Structure;
				OtherOptions.Insert("NumCruise"   , Format(1, "ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0"));
				OtherOptions.Insert("NumInCruise" , Format(1, "ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0"));
				OtherOptions.Insert("Color"       , WebMapStruct.ColorPalette.Get("black"));
				OtherOptions.Insert("TypeIcon"    , WebMapStruct.IconsСollection.islandsstandart.Get("person"));
				ArrayPoints.Add(WebMapServer.CreatePointStructFromPartner(SelectedShipper, OtherOptions));
				
				Route.Insert("ArrayPoints", ArrayPoints);
				
				ArrayRoutes.Add(Route);
				
				WebMapStruct.Insert("ArrayRoutes", ArrayRoutes);
				
				WebMapClient.PrepareHTMLTextRoutes(WebMapStruct);
				WebMapПолеHTML = WebMapStruct.HTMLText;
			EndIf;
		EndIf;
	EndIf;
	
EndProcedure

&НаКлиенте
Процедура ОбработкаОповещенияСоздатьВременныйКаталогФормы(ИмяКаталогаВременныхФайлов, ДополнительныеПараметры) Экспорт
	
	КаталогВременныхФайловДокумента = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ИмяКаталогаВременныхФайлов);
	WebMapUpdate();
	
КонецПроцедуры

&НаКлиенте
Procedure InitWebMap()
	
	IF StrLen(АдресДоставки) < 10 Then
		Широта = 0;
		Долгота = 0;
	EndIf;
	
	IF (Широта = 0 или Долгота = 0) И СтрДлина(АдресДоставки) < 10 Then
		WebMapClient.HTMLMessage(WebMapПолеHTML,
                           "Координаты точки не определены!<br>Отображение карты невозможно.",
		                   "#FFA07A");
		WebMapStruct = Undefined;
		Return;
	EndIf;
	
	If ГрузоотправительОнЖе = 1 Then
		SelectedShipper = Организация;
	Else
		SelectedShipper = Грузоотправитель;
	EndIf;
	
	HTMLTemplatesWebMap = HTMLTemplatesWebMap();
	
	If РежимРаботыWebКарты = "КонтактнаяИнформация" Then
		IF NOT WebMapStruct = Undefined Then
			Return;
		EndIf;
		
		NamePartner = Строка(SelectedShipper);
		
		GeocodeAddress = False;
		IF NOT ValueIsFilled(Широта) AND NOT ValueIsFilled(Долгота) Then
			GeocodeAddress = True;
		EndIf;
		
		LatCenter = ?(ValueIsFilled(Широта) , Format(Широта , "ЧЦ=10; ЧДЦ=7; ЧРД=.; ЧРГ="), "45.058262");
		LonCenter = ?(ValueIsFilled(Долгота), Format(Долгота, "ЧЦ=10; ЧДЦ=7; ЧРД=.; ЧРГ="), "38.982607");
		WebMapStruct = WebMapClient.CreateStruct("Геопозиционирование адреса", "e041936b-a266-4a20-8e94-d0d7ffef7ec4", , LatCenter, LonCenter, КаталогВременныхФайловДокумента);
		
		IF GeocodeAddress AND NOT WebMapStruct = Undefined Then
			StructReturned = WebMapClient.GeocodeAddress(Элементы.WEBКарта, WebMapStruct, АдресДоставки);
			Широта	= StructReturned.Latitude;
			Долгота	= StructReturned.Longitude;
			LatCenter = ?(ValueIsFilled(Широта) , Format(Широта , "ЧЦ=10; ЧДЦ=7; ЧРД=.; ЧРГ="), "45.058262");
			LonCenter = ?(ValueIsFilled(Долгота), Format(Долгота, "ЧЦ=10; ЧДЦ=7; ЧРД=.; ЧРГ="), "38.982607");
			WebMapStruct = WebMapClient.CreateStruct("Геопозиционирование адреса", "e041936b-a266-4a20-8e94-d0d7ffef7ec4", , LatCenter, LonCenter, КаталогВременныхФайловДокумента);
			ЭтаФорма.Modified = True;
		EndIf;
		
		IF WebMapStruct = Undefined THEN
			Return;
		ENDIF;
		
		WebMapStruct.Insert("NamePartner" , NamePartner);
		WebMapStruct.Insert("Address"     , АдресДоставки);
		WebMapStruct.Insert("Color"       , WebMapStruct.ColorPalette.Get("red"));
		WebMapStruct.Insert("TypeIcon"    , WebMapStruct.IconsСollection.islandsdot.Get("red"));

	Else
		
		IF WebMapStruct = Undefined THEN
			WebMapStruct = WebMapClient.CreateStruct("Маршрут от грузоотправителья к грузополучателю", "e041936b-a266-4a20-8e94-d0d7ffef7ec4",,,, КаталогВременныхФайловДокумента);
		ENDIF;
		
	EndIf;
	
	WebMapStruct.Insert("HTMLTextMap", WebMapServer.CommonTemplate());
	WebMapStruct.Insert("HTMLTextInit", HTMLTemplatesWebMap.HTMLTextInit);
	WebMapStruct.Insert("HTMLTextBody", HTMLTemplatesWebMap.HTMLTextBody);
	
	If РежимРаботыWebКарты = "КонтактнаяИнформация" Then
		WebMapClient.PrepareHTMLTextGeocodeAddress(WebMapStruct);
		WebMapПолеHTML = WebMapStruct.HTMLText;
	EndIf;
	
EndProcedure

&НаСервере
Функция HTMLTemplatesWebMap()
	
	СтруктураВозврата = Новый Структура;
	
	Если РежимРаботыWebКарты = "КонтактнаяИнформация" Тогда
		HTMLTextInit = Обработки.РасширенныйВводКонтактнойИнформации.ПолучитьМакет("HTMLYandexMap_function_init").ПолучитьТекст();
		HTMLTextBody = Обработки.РасширенныйВводКонтактнойИнформации.ПолучитьМакет("HTMLYandexMap_body").ПолучитьТекст();
		
	ИначеЕсли РежимРаботыWebКарты = "РасчетМаршрута" тогда
		HTMLTextInit = Документы.ТранспортнаяЛогистика.ПолучитьМакет("HTMLYandexMap_function_init").ПолучитьТекст();
		HTMLTextBody = Документы.ТранспортнаяЛогистика.ПолучитьМакет("HTMLYandexMap_body").ПолучитьТекст();
		
	КонецЕсли;
	
	СтруктураВозврата.Вставить("HTMLTextInit", HTMLTextInit);
	СтруктураВозврата.Вставить("HTMLTextBody", HTMLTextBody);
	
	Возврат СтруктураВозврата;
	
КонецФункции

&НаКлиенте
Процедура ВремяЛогистикиНачалоПриИзменении(Элемент)
	
	СписокВремени = ТранспортнаяЛогистикаКлиент.СписокВремениНачалаЛогистики(ВремяЛогистикиНачало,);
	Элементы.ВремяЛогистикиОкончание.СписокВыбора.Очистить();
	Для Каждого Элемент из СписокВремени Цикл
		Элементы.ВремяЛогистикиОкончание.СписокВыбора.Добавить(Элемент.Значение, Элемент.Представление);
	КонецЦикла;
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяЛогистикиОкончаниеПриИзменении(Элемент)
	
	СписокВремени = ТранспортнаяЛогистикаКлиент.СписокВремениНачалаЛогистики(,ВремяЛогистикиОкончание);
	Элементы.ВремяЛогистикиНачало.СписокВыбора.Очистить();
	Для Каждого Элемент из СписокВремени Цикл
		Элементы.ВремяЛогистикиНачало.СписокВыбора.Добавить(Элемент.Значение,Элемент.Представление);
	КонецЦикла;
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРазделПеревозкаАвтотранспортомНаСервере()
	
	ДанныеТранспортнойЛогистики = ТранспортнаяЛогистикаСервер.ДанныеТранспортнойЛогистики(Ссылка);
	ЗаполнитьЗначенияСвойств(ЭтаФорма, ДанныеТранспортнойЛогистики);
	
	// Отобразим грузоотправителя и грузополучателя
	Если НЕ ЗначениеЗаполнено(Грузоотправитель) Тогда
		ГрузоотправительОнЖе = 1;
	Иначе
		Если Грузоотправитель = Организация тогда
			ГрузоотправительОнЖе = 1;
			Грузоотправитель = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
		Иначе
			ГрузоотправительОнЖе = 0;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Грузополучатель) Тогда
		ГрузополучательОнЖе = 1;
	Иначе
		Если Грузополучатель = Контрагент тогда
			ГрузополучательОнЖе = 1;
			Грузоотправитель = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
		Иначе
			ГрузополучательОнЖе = 0;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Перевозчик) Тогда
		ПеревозчикОнЖе = 1;
	Иначе
		ПеревозчикОнЖе = 0;
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРазделПеревозкаАвтотранспортом(Команда)
	
	ЗаполнитьРазделПеревозкаАвтотранспортомНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ВодительАвтомобильПриИзменении(Элемент)
	
	ВодительАвтомобильПриИзмененииНаСервере(Элемент.Имя);
	
КонецПроцедуры

&НаСервере
Процедура ВодительАвтомобильПриИзмененииНаСервере(ИмяПоля)
	
	Если ПеревозчикОнЖе = 1 Тогда
		ВыбранныйПеревозчик = Организация;
	Иначе
		ВыбранныйПеревозчик = Перевозчик;
	КонецЕсли;
	
	Если НЕ ЭтаФорма[ИмяПоля].Перевозчик = ВыбранныйПеревозчик тогда
		ПеревозчикОнЖе = 0;
		ЭтаФорма[ИмяПоля] = ВыбранныйПеревозчик;
	КонецЕсли;
	
	Если ИмяПоля = "ВодительСсылка" тогда
		
		Если ЗначениеЗаполнено(ВодительСсылка) Тогда
			Водитель = ВодительСсылка.ФизическоеЛицо.Наименование;
			ВодительскоеУдостоверение = ВодительСсылка.ВодительскоеУдостоверение;
		Иначе
			Водитель = "";
			ВодительскоеУдостоверение = "";
		КонецЕсли;
		
	ИначеЕсли ИмяПоля = "АвтомобильСсылка" тогда
		
		Если ЗначениеЗаполнено(АвтомобильСсылка) ТОгда
			МаркаАвтомобиля = АвтомобильСсылка.Марка;
			РегистрационныйЗнакАвтомобиля = АвтомобильСсылка.РегистрационныйЗнак;
		Иначе
			МаркаАвтомобиля = "";
			РегистрационныйЗнакАвтомобиля = "";
		КонецЕсли;
		
	КонецЕсли;
	
	ДанныеТранспортнойЛогистики = ТранспортнаяЛогистикаСервер.ДанныеТранспортнойЛогистики(Ссылка);
	
	Если НЕ ДанныеТранспортнойЛогистики.ВодительСсылка = ВодительСсылка
	 ИЛИ НЕ ДанныеТранспортнойЛогистики.АвтомобильСсылка = АвтомобильСсылка Тогда
		Маршрут = ПредопределенноеЗначение("Справочник.Маршруты.ПустаяСсылка");
	Иначе
		Маршрут = ДанныеТранспортнойЛогистики.Маршрут;
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры


