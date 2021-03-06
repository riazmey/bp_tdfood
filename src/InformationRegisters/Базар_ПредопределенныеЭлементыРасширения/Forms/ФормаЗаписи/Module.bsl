&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ОбъектМетаданных.СписокВыбора.Очистить();
	Элементы.ОбъектМетаданных.СписокВыбора.ЗагрузитьЗначения(ДоступныеИдентификаторыОбъектов());
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектМетаданныхНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДоступныеИдентификаторыОбъектов = ДоступныеИдентификаторыОбъектов();
	
	ДанныеВыбора = Новый СписокЗначений;
	ДанныеВыбора.ЗагрузитьЗначения(ДоступныеИдентификаторыОбъектов);
	
	Элемент.СписокВыбора.Очистить();
	Элемент.СписокВыбора.ЗагрузитьЗначения(ДоступныеИдентификаторыОбъектов);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектМетаданныхПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Запись.ОбъектМетаданных) тогда
		Запись.ОбъектМетаданных = Неопределено;
		Возврат;
	КонецЕсли;
	
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	// Приведем тип значения ссылки к типу выбранных метаданных
	Если НЕ ЗначениеЗаполнено(Запись.ОбъектМетаданных) тогда
		Возврат;
	КонецЕсли;
	
	СтруктураЗамены = Новый Структура;
	СтруктураЗамены.Вставить("Справочник"  , "СправочникСсылка");
	СтруктураЗамены.Вставить("Документ"    , "ДокументСсылка");
	СтруктураЗамены.Вставить("Перечисление", "ПеречислениеСсылка");
	СтруктураЗамены.Вставить("ПланСчетов"  , "ПланСчетовСсылка");
	
	ПолноеИмяМетаданных = Неопределено;
	Для Каждого КлючИЗначение из СтруктураЗамены цикл
		Если СтрНайти(Запись.ОбъектМетаданных.ПолноеИмя, КлючИЗначение.Ключ) > 0 тогда
			ПолноеИмяМетаданных = СтрЗаменить(Запись.ОбъектМетаданных.ПолноеИмя, КлючИЗначение.Ключ, КлючИЗначение.Значение);
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ ЗначениеЗаполнено(ПолноеИмяМетаданных) тогда
		Возврат;
	КонецЕсли;
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип(ПолноеИмяМетаданных));
	ОписаниеТипа = Новый ОписаниеТипов(МассивТипов);

	Элементы.Ссылка.ОграничениеТипа = ОписаниеТипа;
	Запись.Ссылка = ОписаниеТипа.ПривестиЗначение(Запись.Ссылка);
	
КонецПроцедуры

&НаСервере
Функция ДоступныеИдентификаторыОбъектов()
	
	ДоступныеИдентификаторы = Новый Массив;
	ТипыСсылки = Метаданные.РегистрыСведений.Базар_ПредопределенныеЭлементыРасширения.Измерения.Ссылка.Тип;
	
	Для Каждого ТипСсылки из ТипыСсылки.Типы() цикл
		ОбъектСсылка = Новый(ТипСсылки);
		
		МетаданныеОбъекта = ОбъектСсылка.Метаданные();
		ТипОбъекта = Неопределено;
		Если ОбщегоНазначения.ЭтоСправочник(МетаданныеОбъекта) тогда
			ТипОбъекта = "Справочник";
		ИначеЕсли ОбщегоНазначения.ЭтоДокумент(МетаданныеОбъекта) тогда
			ТипОбъекта = "Документ";
		ИначеЕсли ОбщегоНазначения.ЭтоПеречисление(МетаданныеОбъекта) тогда
			ТипОбъекта = "Перечисление";
		ИначеЕсли ОбщегоНазначения.ЭтоПланСчетов(МетаданныеОбъекта) тогда
			ТипОбъекта = "ПланСчетов";
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ТипОбъекта) тогда
			Продолжить;
		КонецЕсли;
		
		ИдентификаторМетаданных = Справочники.ИдентификаторыОбъектовМетаданных.НайтиПоРеквизиту("ПолноеИмя", ТипОбъекта + "." + ОбъектСсылка.Метаданные().Имя);
		
		Если НЕ ЗначениеЗаполнено(ИдентификаторМетаданных) тогда
			ИдентификаторМетаданных = Справочники.ИдентификаторыОбъектовРасширений.НайтиПоРеквизиту("ПолноеИмя", ТипОбъекта + "." + ОбъектСсылка.Метаданные().Имя);
			Если НЕ ЗначениеЗаполнено(ИдентификаторМетаданных) тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		ДоступныеИдентификаторы.Добавить(ИдентификаторМетаданных);
		
	КонецЦикла;
	
	Возврат ДоступныеИдентификаторы;
	
КонецФункции