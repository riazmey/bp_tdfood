&Вместо("УстановитьВремяНовогоДокумента")
Процедура Базар_УстановитьВремяНовогоДокумента(Источник, Отказ) Экспорт
	
	// ИМЯ ДОКУМЕНТА                  ТИП. ВРЕМЯ     НОВ. ВРЕМЯ
	// СписаниеСРасчетногоСчета         18 0 0         4 0   0   Изменения
	// ПриходныйКассовыйОрдер           17 0 0         4 15  0   Изменения
	// РасходныйКассовыйОрдер           18 0 0         4 30  0   Изменения

	// Если НЕ ЗначениеЗаполнено(Источник.ИнвентаризацияТоваровНаСкладе) тогда
	//     СписаниеТоваров                  13 0 0         5 0   0   Изменения
	//     ОприходованиеТоваров             7  0 0         5 15  0   Изменения
	// КонецЕсли;
	
	// ПоступлениеТоваровУслуг          7  0 0         5 30  0   Изменения
	// АвансовыйОтчет                   10 0 0         5 45  0   Изменения
	// ПеремещениеТоваров               11 0 0         6 00  0   Изменения
	// СпецификацияДоговора                            6 0   0   Изменения
	// КорректировкаПоступления         9  0 0         6 30  0   Изменения
	// Партия                           6  0 0         7 0   0   Изменения
	// ВозвратТоваровПоставщику         14 0 0         8 0   0   Изменения
	// ВозвратТоваровОтПокупателя       7  0 0         8 15  0   Изменения
	// УстановкаЦенНоменклатуры         6  0 0         8 30  0   Изменения
	// ПереоценкаТоваровВРознице        6  0 0         8 45  0   Изменения
	// ТребованиеНакладная              12 0 0         9 0   0   Изменения
	// СчетНаОплатуПокупателю                          10 0  0   Изменения
	// ТранспортнаяЛогистика                           11 0  0   Изменения
	// МаршрутныйЛист                                  11 30 0   Изменения
	// РеализацияТоваровУслуг           14 0 0         14 0  0   \/
	// ДвижениеМногооборотнойТары                      15 0  0   Изменения
	// ПоступлениеНаРасчетныйСчет       17 0 0         15 30 0   Изменения
	// КорректировкаРеализации          16 0 0         16 0  0   \/
	// ОтчетОРозничныхПродажах          14 0 0         18 0  0   Изменения
	// КорректировкаДолга               19 0 0         19 0  0   \/
	// АктСверкиВзаиморасчетов          20 0 0         20 0  0   \/
	// СчетФактураВыданный              21 0 0         21 0  0   \/
	// СчетФактураПолученный            21 0 0         21 0  0   \/
	// ИнвентаризацияТоваровНаСкладе    6  0 0         23 20 0   Изменения
	
	// Если ЗначениеЗаполнено(Источник.ИнвентаризацияТоваровНаСкладе) тогда
	//     СписаниеТоваров                  13 0 0         23 30 0   Изменения
	//     ОприходованиеТоваров             7  0 0         23 40 0   Изменения
	// КонецЕсли;
	
	// ВводНачальныхОстатков            23 59 59       23 50 0   Изменения
 
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ФиксированноеВремяВДокументах") Тогда
		Возврат;
	КонецЕсли;
	
	Менеджер = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Источник.Ссылка);
	Если Менеджер = Неопределено Тогда
		Если Источник.Ссылка.Метаданные().Имя = "СпецификацияДоговора" тогда
			Менеджер = Документы["СпецификацияДоговора"];
		Иначе
			Возврат;
		КонецЕсли
	КонецЕсли;
	
	ТекущаяДата               = НачалоДня(Источник.Дата);
	
	Если Источник.Ссылка.Метаданные().Имя = "СписаниеТоваров" ИЛИ
		 Источник.Ссылка.Метаданные().Имя = "ОприходованиеТоваров" ИЛИ
		 Источник.Ссылка.Метаданные().Имя = "ПоступлениеНаРасчетныйСчет" тогда
		ВремяДокументаПоУмолчанию = Менеджер.Базар_ВремяДокументаПоУмолчанию(Источник);
	Иначе
		ВремяДокументаПоУмолчанию = Менеджер.ВремяДокументаПоУмолчанию();
	КонецЕсли;
	
	НачальноеДатаВремя        = ТекущаяДата + ВремяДокументаПоУмолчанию.Часы * 3600 + ВремяДокументаПоУмолчанию.Минуты * 60
	                            + ?(ВремяДокументаПоУмолчанию.Свойство("Секунды"), ВремяДокументаПоУмолчанию.Секунды, 0);
	КонечноеДатаВремя        = НачальноеДатаВремя + 3600;

	
	Если Источник.Дата < НачальноеДатаВремя ИЛИ Источник.ЭтоНовый() ИЛИ Источник.Дата > КонечноеДатаВремя тогда
		Источник.Дата = ВремяДокумента(Источник.Ссылка, НачальноеДатаВремя, КонечноеДатаВремя);
	КонецЕсли;
	
КонецПроцедуры

Функция ВремяДокумента(ДокументСсылка, НачальноеДатаВремя, КонечноеДатаВремя)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачальноеДатаВремя", НачальноеДатаВремя);
	Запрос.УстановитьПараметр("КонечноеДатаВремя", КонечноеДатаВремя);
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ДокументСсылка.Дата КАК Дата
	|ИЗ
	|	Документ." + ДокументСсылка.Метаданные().Имя + " КАК ДокументСсылка
	|ГДЕ
	|	ДокументСсылка.ПометкаУдаления = ЛОЖЬ
	|	И ДокументСсылка.Ссылка <> &ДокументСсылка
	|	И ДокументСсылка.Дата МЕЖДУ &НачальноеДатаВремя И &КонечноеДатаВремя
	|
	|СГРУППИРОВАТЬ ПО
	|	ДокументСсылка.Дата
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата УБЫВ";
	
	Выборка = Запрос.Выполнить().Выбрать(); // " + ДокументСсылка.Метаданные().Имя + "    // РеализацияТоваровУслуг
	
	Если Выборка.Следующий() тогда
		ПоследнееВремя = Выборка.Дата;
		
		Если ПоследнееВремя < НачальноеДатаВремя тогда
			Возврат НачальноеДатаВремя;
		КонецЕсли;
		
		Если ПоследнееВремя = НачальноеДатаВремя тогда
			Возврат НачальноеДатаВремя + 1;
		КонецЕсли;
		
		Если ПоследнееВремя > НачальноеДатаВремя тогда
			Возврат ПоследнееВремя + 1;
		КонецЕсли;
		
	Иначе
		Возврат НачальноеДатаВремя;
	КонецЕсли;
	
КонецФункции