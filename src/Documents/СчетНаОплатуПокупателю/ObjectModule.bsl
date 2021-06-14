
&После("ОбработкаПроведения")
Процедура Базар_ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	СписокОшибокПриПроведении = Неопределено;
	
	ГосЗакупкиСервер.ОбработкаПроведенияГосЗакупки(ЭтотОбъект, СписокОшибокПриПроведении, Отказ);
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(СписокОшибокПриПроведении, Отказ);
	
	ДвиженияТранспортнаяЛогистикаЗаказы(Отказ);
	ДвиженияЗаказыКлиентов(Отказ);
	
КонецПроцедуры

&После("ОбработкаЗаполнения")
Процедура Базар_ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ЭтоНовый() тогда
		
		СуммаВключаетНДС = Истина;
		
		Если НЕ ЗначениеЗаполнено(Склад) тогда
			СистемныеНастройкиБазар = ОбщегоНазначенияБазарСервер.СистемныеНастройкиБазар(Дата);
			Если ЗначениеЗаполнено(СистемныеНастройкиБазар.СкладОтгрузки) тогда
				Склад = СистемныеНастройкиБазар.СкладОтгрузки;
			КонецЕсли;
			Если ЗначениеЗаполнено(СистемныеНастройкиБазар.ТипЦенПродажи) И НЕ ЗначениеЗаполнено(ТипЦен) тогда
				ТипЦен = СистемныеНастройкиБазар.ТипЦенПродажи;
			КонецЕсли;
		КонецЕсли;
		
		ДанныеТранспортнойЛогистики = ТранспортнаяЛогистикаСервер.ДанныеТранспортнойЛогистики(ЭтотОбъект, Неопределено, ДанныеЗаполнения);
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеТранспортнойЛогистики);
		
	КонецЕсли;
	
КонецПроцедуры

&Перед("ОбработкаПроверкиЗаполнения")
Процедура Базар_ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверяемыеРеквизиты.Добавить("ДоговорКонтрагента");
	ПроверяемыеРеквизиты.Добавить("Товары.Цена");
	ПроверяемыеРеквизиты.Добавить("Товары.Количество");
	
	Если ГосЗакупкиСервер.ЭтоДоговорПоставкиГосЗакупок(ДоговорКонтрагента) тогда
		ПроверяемыеРеквизиты.Добавить("Товары.ЦенаГосЗакупок");
		ПроверяемыеРеквизиты.Добавить("Товары.КоличествоГосЗакупок");
	КонецЕсли;
	
	ПроверяемыеРеквизиты.Добавить("Товары.Сумма");
	
	Если ПеревозкаАвтотранспортом тогда
		ПроверяемыеРеквизиты.Добавить("АдресДоставки");
		ПроверяемыеРеквизиты.Добавить("ВремяЛогистикиНачало");
		ПроверяемыеРеквизиты.Добавить("ВремяЛогистикиОкончание");
	КонецЕсли;
	
КонецПроцедуры

&После("ПриКопировании")
Процедура Базар_ПриКопировании(ОбъектКопирования)
		
	Если НЕ ЗначениеЗаполнено(Склад) тогда
		СистемныеНастройкиБазар = ОбщегоНазначенияБазарСервер.СистемныеНастройкиБазар(Дата);
		Если ЗначениеЗаполнено(СистемныеНастройкиБазар.СкладОтгрузки) тогда
			Склад = СистемныеНастройкиБазар.СкладОтгрузки;
		КонецЕсли;
		Если ЗначениеЗаполнено(СистемныеНастройкиБазар.ТипЦенПродажи) И НЕ ЗначениеЗаполнено(ТипЦен) тогда
			ТипЦен = СистемныеНастройкиБазар.ТипЦенПродажи;
		КонецЕсли;
	КонецЕсли;
	
	ДанныеТранспортнойЛогистики = ТранспортнаяЛогистикаСервер.ДанныеТранспортнойЛогистики(ЭтотОбъект, Неопределено, ОбъектКопирования);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеТранспортнойЛогистики);
	
КонецПроцедуры

&После("ПередЗаписью")
Процедура Базар_ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	// Заполнение даты документа
	ФиксированноеВремяДокументов.УстановитьВремяНовогоДокумента(ЭтотОбъект, Отказ);
	
	Если НЕ Отказ тогда
		
		Если НЕ ЗначениеЗаполнено(Грузополучатель) тогда
			Грузополучатель = Контрагент;
		КонецЕсли;
		
		Если НЕ ЭтоНовый() тогда
			Если НЕ Проведен ИЛИ РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения тогда
				ДвиженияТранспортнаяЛогистика = Движения.ТранспортнаяЛогистикаЗаказы;
				ДвиженияТранспортнаяЛогистика.Очистить();
				ДвиженияТранспортнаяЛогистика.Записать();
				
				ДвиженияЗаказыКлиентов = Движения.ЗаказыКлиентов;
				ДвиженияЗаказыКлиентов.Очистить();
				ДвиженияЗаказыКлиентов.Записать();
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДвиженияТранспортнаяЛогистикаЗаказы(Отказ)
	
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияТранспортнаяЛогистика = Движения.ТранспортнаяЛогистикаЗаказы;
	ДвиженияТранспортнаяЛогистика.Очистить();
	
	Если НЕ ПеревозкаАвтотранспортом тогда
		ДвиженияТранспортнаяЛогистика.Записать();
		Возврат;
	КонецЕсли;
	
	СистемныеНастройкиБазар = ОбщегоНазначенияБазарСервер.СистемныеНастройкиБазар(Дата);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",Ссылка);
	Запрос.УстановитьПараметр("Дата",Дата);
	Запрос.УстановитьПараметр("ТипЦенСебестоимости", СистемныеНастройкиБазар.ТипЦенСебестоимость);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СчетНаОплатуПокупателюТовары.Ссылка.Организация КАК Организация,
	|	СчетНаОплатуПокупателюТовары.Ссылка КАК ДокументДвижения,
	|	СчетНаОплатуПокупателюТовары.Ссылка.АдресДоставки КАК АдресПредставление,
	|	СчетНаОплатуПокупателюТовары.Ссылка.ВремяЛогистикиНачало КАК ВремяЛогистикиНачало,
	|	СчетНаОплатуПокупателюТовары.Ссылка.ВремяЛогистикиОкончание КАК ВремяЛогистикиОкончание,
	|	СчетНаОплатуПокупателюТовары.Ссылка.Грузоотправитель КАК Грузоотправитель,
	|	СчетНаОплатуПокупателюТовары.Ссылка.Грузополучатель КАК Грузополучатель,
	|	СчетНаОплатуПокупателюТовары.Номенклатура КАК Номенклатура,
	|	СУММА(СчетНаОплатуПокупателюТовары.Количество) КАК Количество,
	|	СУММА(СчетНаОплатуПокупателюТовары.Количество * СчетНаОплатуПокупателюТовары.Номенклатура.ВесЕдиницы) КАК Тоннаж,
	|	СУММА(СчетНаОплатуПокупателюТовары.Наценка) КАК Наценка
	|ИЗ
	|	Документ.СчетНаОплатуПокупателю.Товары КАК СчетНаОплатуПокупателюТовары
	|ГДЕ
	|	СчетНаОплатуПокупателюТовары.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	СчетНаОплатуПокупателюТовары.Ссылка.Организация,
	|	СчетНаОплатуПокупателюТовары.Ссылка,
	|	СчетНаОплатуПокупателюТовары.Ссылка.АдресДоставки,
	|	СчетНаОплатуПокупателюТовары.Ссылка.ВремяЛогистикиНачало,
	|	СчетНаОплатуПокупателюТовары.Ссылка.ВремяЛогистикиОкончание,
	|	СчетНаОплатуПокупателюТовары.Ссылка.Грузоотправитель,
	|	СчетНаОплатуПокупателюТовары.Ссылка.Грузополучатель,
	|	СчетНаОплатуПокупателюТовары.Номенклатура";
	
	Выборка = Запрос.Выполнить().Выбрать();
		
	Пока Выборка.Следующий() Цикл
		
		НоваяЗапись = ДвиженияТранспортнаяЛогистика.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяЗапись,Выборка);
		
		НоваяЗапись.ВидДвижения = ВидДвиженияНакопления.Приход;
		НоваяЗапись.Период = Дата;
		НоваяЗапись.Регистратор = Ссылка;
		
		Если НЕ ЗначениеЗаполнено(Выборка.Грузоотправитель) тогда
			НоваяЗапись.Грузоотправитель = Выборка.Организация;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Выборка.Грузополучатель) тогда
			НоваяЗапись.Грузополучатель = Выборка.Контрагент;
		КонецЕсли;
		
		
	КонецЦикла;
	
	ДвиженияТранспортнаяЛогистика.Записать();
	
КонецПроцедуры

Процедура ДвиженияЗаказыКлиентов(Отказ)
	
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияЗаказыКлиентов = Движения.ЗаказыКлиентов;
	ДвиженияЗаказыКлиентов.Очистить();
		
	Для Каждого СтрокаТовар из Товары цикл
		
		НоваяЗапись = ДвиженияЗаказыКлиентов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяЗапись, ЭтотОбъект);
		ЗаполнитьЗначенияСвойств(НоваяЗапись, СтрокаТовар);
		
		НоваяЗапись.Период = Дата;
		НоваяЗапись.Регистратор = Ссылка;
		
		Если НЕ ЗначениеЗаполнено(Грузоотправитель) тогда
			НоваяЗапись.Грузоотправитель = Организация;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Грузополучатель) тогда
			НоваяЗапись.Грузополучатель = Контрагент;
		КонецЕсли;
		
		
	КонецЦикла;
	
	ДвиженияЗаказыКлиентов.Записать();
	
КонецПроцедуры