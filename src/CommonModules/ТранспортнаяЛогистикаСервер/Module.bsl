Функция ДанныеТранспортнойЛогистики(Документ, ДополнительныеПараметры = Неопределено, ДанныеЗаполнения = Неопределено) Экспорт
	
	ЭтоОбъект = НЕ Документы.ТипВсеСсылки().СодержитТип(ТипЗнч(Документ));
	МетаданныеДокумент = Документ.Ссылка.Метаданные();
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("Грузоотправитель"        , ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка"));
	СтруктураВозврата.Вставить("Грузополучатель"         , ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка"));
	СтруктураВозврата.Вставить("АдресДоставки"           , "");
	СтруктураВозврата.Вставить("АдресДоставкиJSON"       , "");
	СтруктураВозврата.Вставить("ВремяЛогистикиНачало"    , Дата(1,1,1,0,0,0));
	СтруктураВозврата.Вставить("ВремяЛогистикиОкончание" , Дата(1,1,1,0,0,0));
	СтруктураВозврата.Вставить("ПеревозкаАвтотранспортом", Ложь);
	Если МетаданныеДокумент.Имя = "РеализацияТоваровУслуг" тогда
		СтруктураВозврата.Вставить("Водитель"                     , "");
		СтруктураВозврата.Вставить("ВодительСсылка"               , ПредопределенноеЗначение("Справочник.Водители.ПустаяСсылка"));
		СтруктураВозврата.Вставить("ВодительскоеУдостоверение"    , "");
		СтруктураВозврата.Вставить("МаркаАвтомобиля"              , "");
		СтруктураВозврата.Вставить("АвтомобильСсылка"             , ПредопределенноеЗначение("Справочник.Автомобили.ПустаяСсылка"));
		СтруктураВозврата.Вставить("Маршрут"                      , ПредопределенноеЗначение("Справочник.Маршруты.ПустаяСсылка"));
		СтруктураВозврата.Вставить("РегистрационныйЗнакАвтомобиля", "");
		СтруктураВозврата.Вставить("КраткоеНаименованиеГруза"     , "");
		СтруктураВозврата.Вставить("Перевозчик"                   , ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка"));
		СтруктураВозврата.Вставить("СопроводительныеДокументы"    , "");
	КонецЕсли;
	
	ДанныеДокумента = Новый Структура("Организация,
	                                  |Контрагент,
	                                  |ДоговорКонтрагента,
	                                  |Грузоотправитель,
	                                  |Грузополучатель,
	                                  |Дата");
	
	//Получим необходимые данные из документа
	Для Каждого КлючИЗначение из ДанныеДокумента цикл
		Если ЭтоОбъект тогда
			Значение = Документ[КлючИЗначение.Ключ];
		Иначе
			Значение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Документ, КлючИЗначение.Ключ);
		КонецЕсли;
		ДанныеДокумента.Вставить(КлючИЗначение.Ключ, Значение);
	КонецЦикла;
	
	// Заполняем структуру возврата данными из текущего документа
	Для Каждого КлючИЗначение из СтруктураВозврата цикл
		Если ЭтоОбъект тогда
			Значение = Документ[КлючИЗначение.Ключ];
		Иначе
			Значение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Документ, КлючИЗначение.Ключ);
		КонецЕсли;
		СтруктураВозврата.Вставить(КлючИЗначение.Ключ, Значение);
	КонецЦикла;
	
	// Заполняем общие данные для Счетов на оплату и Реализацию товаров, по текущим данным документа
	СтруктураВозврата.Грузоотправитель = ?(ЗначениеЗаполнено(ДанныеДокумента.Грузоотправитель), ДанныеДокумента.Грузоотправитель, ДанныеДокумента.Организация);
	СтруктураВозврата.Грузополучатель = ?(ЗначениеЗаполнено(ДанныеДокумента.Грузополучатель), ДанныеДокумента.Грузополучатель, ДанныеДокумента.Контрагент);
	
	// Перед дальнейшим заполнением нужно проверить есть ли грузополучатель или грузоотправитель, которые
	// нужно обязательно заменить, т.к. эти реквизиты - основа для дальнейшего заполнения
	ИсключенныеИзЗаполненияПоляДанныхЗаполнения = Новый Массив;
	ИсключенныеИзЗаполненияПоляДанныхЗаполнения.Добавить("Грузополучатель");
	ИсключенныеИзЗаполненияПоляДанныхЗаполнения.Добавить("Грузоотправитель");
	ОбновитьПринудительноАдресДоставки = Ложь;
	Если НЕ ДополнительныеПараметры = Неопределено тогда
		Если ДополнительныеПараметры.Свойство("Грузоотправитель") тогда
			СтруктураВозврата.Грузоотправитель = ДополнительныеПараметры.Грузоотправитель;
		КонецЕсли;
		Если ДополнительныеПараметры.Свойство("Грузополучатель") тогда
			СтруктураВозврата.Грузополучатель = ДополнительныеПараметры.Грузополучатель;
			ОбновитьПринудительноАдресДоставки = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если (ДанныеДокумента.Грузополучатель <> СтруктураВозврата.Грузополучатель ИЛИ ОбновитьПринудительноАдресДоставки) И ЗначениеЗаполнено(СтруктураВозврата.Грузоотправитель) тогда
		ДанныеАдресаДоставки = УправлениеКонтактнойИнформациейСлужебный.ДанныеАдресаДоставкиПоУмолчанию(СтруктураВозврата.Грузополучатель);
		
		Если НЕ ДанныеАдресаДоставки = Неопределено тогда
			СтруктураВозврата.АдресДоставкиJSON = ДанныеАдресаДоставки.СтрокаJSON;
			СтруктураВозврата.АдресДоставки = ДанныеАдресаДоставки.ПредставлениеСокращенное;
		КонецЕсли;
		ИсключенныеИзЗаполненияПоляДанныхЗаполнения.Добавить("АдресДоставкиJSON");
		ИсключенныеИзЗаполненияПоляДанныхЗаполнения.Добавить("АдресДоставки");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДанныеДокумента.ДоговорКонтрагента) И МетаданныеДокумент.Имя = "СчетНаОплатуПокупателю" тогда
		СтруктураВозврата.ВремяЛогистикиНачало = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеДокумента.ДоговорКонтрагента, "ВремяЛогистикиНачало");
		СтруктураВозврата.ВремяЛогистикиОкончание = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеДокумента.ДоговорКонтрагента, "ВремяЛогистикиОкончание");
		СтруктураВозврата.ПеревозкаАвтотранспортом = Истина;
		ИсключенныеИзЗаполненияПоляДанныхЗаполнения.Добавить("ВремяЛогистикиНачало");
		ИсключенныеИзЗаполненияПоляДанныхЗаполнения.Добавить("ВремяЛогистикиОкончание");
		ИсключенныеИзЗаполненияПоляДанныхЗаполнения.Добавить("ПеревозкаАвтотранспортом");
	КонецЕсли;
	
	// Заполним данные на основании Данных заполнения (поверх данных документа)
	Если НЕ ДанныеЗаполнения = Неопределено И ТипЗнч(ДанныеЗаполнения) = Тип("Структура") тогда
		Для Каждого КлючИЗначение из ДанныеЗаполнения цикл
			Если ИсключенныеИзЗаполненияПоляДанныхЗаполнения.Найти(КлючИЗначение.Ключ) = Неопределено тогда
				СтруктураВозврата.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтруктураВозврата.Грузоотправитель) И ЗначениеЗаполнено(СтруктураВозврата.Грузополучатель) тогда
		СтруктураВозврата.ПеревозкаАвтотранспортом = Истина;
	КонецЕсли;
	
	Если МетаданныеДокумент.Имя = "СчетНаОплатуПокупателю" тогда
		Возврат СтруктураВозврата;
	Иначе
		Если НЕ ЗначениеЗаполнено(ДанныеДокумента.ДоговорКонтрагента) ИЛИ 
			НЕ ЗначениеЗаполнено(СтруктураВозврата.Грузоотправитель) ИЛИ
			НЕ ЗначениеЗаполнено(СтруктураВозврата.Грузополучатель) тогда
			
			// Перед возвратом результата, необходимо заменить в структре возврата дополнительные параметры
			Если НЕ ДополнительныеПараметры = Неопределено тогда
				Для Каждого КлючИЗначение из ДополнительныеПараметры цикл
					СтруктураВозврата.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
				КонецЦикла;
			КонецЕсли;
			
			Возврат СтруктураВозврата;
		КонецЕсли;
	КонецЕсли;
	
	ТаблицаТовары = Документ.Товары.Выгрузить();
	
	ПараметрыПеревозкаАвтотранспортом = Новый Структура;
	ПараметрыПеревозкаАвтотранспортом.Вставить("Дата"              , ДанныеДокумента.Дата);
	ПараметрыПеревозкаАвтотранспортом.Вставить("ТипДокумента"      , ТипЗнч(Документ));
	ПараметрыПеревозкаАвтотранспортом.Вставить("Документ"          , Документ);
	ПараметрыПеревозкаАвтотранспортом.Вставить("ДоговорКонтрагента", ДанныеДокумента.ДоговорКонтрагента);
	ПараметрыПеревозкаАвтотранспортом.Вставить("Грузополучатель"   , СтруктураВозврата.Грузополучатель);
	
	Если ТипЗнч(ТаблицаТовары) = Тип("ТаблицаЗначений") тогда
		ПараметрыПеревозкаАвтотранспортом.Вставить("МассивНоменклатуры", ТаблицаТовары.ВыгрузитьКолонку("Номенклатура"));
	КонецЕсли;
	
	ДанныеПеревозкаАвтотранспортом = ДанныеРазделаПеревозкаАвтотранспортом(ПараметрыПеревозкаАвтотранспортом);
	
	Если НЕ ДанныеПеревозкаАвтотранспортом = Неопределено тогда
		ЗаполнитьЗначенияСвойств(СтруктураВозврата, ДанныеПеревозкаАвтотранспортом);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтруктураВозврата.ВодительСсылка) И ЗначениеЗаполнено(СтруктураВозврата.АвтомобильСсылка) тогда
		СтруктураВозврата.ПеревозкаАвтотранспортом = Истина;
	Иначе
		СтруктураВозврата.ПеревозкаАвтотранспортом = Ложь;
	КонецЕсли;
	
	// Перед возвратом результата, необходимо заменить в структре возврата дополнительные параметры
	Если НЕ ДополнительныеПараметры = Неопределено тогда
		Для Каждого КлючИЗначение из ДополнительныеПараметры цикл
			СтруктураВозврата.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Возврат СтруктураВозврата;
	
КонецФункции

Функция ДокументУчаствуетВТранспортнойЛогистике(Документ) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Дата", Документ.Дата);
	Запрос.УстановитьПараметр("Ссылка", Документ.Ссылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТранспортнаяЛогистикаДоставкаОбороты.ДокументДвижения КАК ДокументДвижения
	|ИЗ
	|	РегистрНакопления.ТранспортнаяЛогистикаДоставка.Обороты(НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ), КОНЕЦПЕРИОДА(&Дата, ДЕНЬ), Регистратор, ДокументДвижения = &Ссылка) КАК ТранспортнаяЛогистикаДоставкаОбороты
	|
	|СГРУППИРОВАТЬ ПО
	|	ТранспортнаяЛогистикаДоставкаОбороты.ДокументДвижения";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Возврат Выборка.Следующий();
	
КонецФункции

Функция ДанныеРазделаПеревозкаАвтотранспортом(Параметры)
	
	Если НЕ ТипЗнч(Параметры) = Тип("Структура") тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ОбязательныеПараметры = Новый Массив;
	ОбязательныеПараметры.Добавить("ДоговорКонтрагента");
	ОбязательныеПараметры.Добавить("Грузополучатель");
	ОбязательныеПараметры.Добавить("ТипДокумента");
	ОбязательныеПараметры.Добавить("Дата");
	
	Для Каждого ОбязательныйПараметр из ОбязательныеПараметры цикл
		Если НЕ Параметры.Свойство(ОбязательныйПараметр) тогда
			Возврат Неопределено;
		КонецЕсли;
	КонецЦикла;
	
	ТекстПолейВозврата = "АдресДоставкиJSON,
	                     |АдресДоставки,
	                     |ВремяЛогистикиНачало,
	                     |ВремяЛогистикиОкончание,
	                     |Маршрут,
	                     |Перевозчик,
	                     |Водитель,
	                     |ВодительСсылка,
	                     |ВодительскоеУдостоверение,
	                     |МаркаАвтомобиля,
	                     |АвтомобильСсылка,
	                     |РегистрационныйЗнакАвтомобиля";
	
	Если Параметры.Свойство("МассивНоменклатуры") тогда
		ТекстПолейВозврата = ТекстПолейВозврата + ", КраткоеНаименованиеГруза, СопроводительныеДокументы";
	КонецЕсли;
	
	СтруктураВозврата = Новый Структура(ТекстПолейВозврата);
	ЗаполнитьЗначенияСвойств(СтруктураВозврата, Параметры);
	
	Если ТипЗнч(Параметры.Документ) = Тип("ДокументОбъект.РеализацияТоваровУслуг") ИЛИ ТипЗнч(Параметры.Документ) = Тип("ДокументСсылка.РеализацияТоваровУслуг") тогда
		ДанныеТранспортнойЛогистики = ДанныеТранспортнаяЛогистикаДоставка(Параметры.Документ.Ссылка, Параметры.Документ.СчетНаОплатуПокупателю, Параметры.Дата);
	Иначе
		ДанныеТранспортнойЛогистики = ДанныеТранспортнаяЛогистикаДоставка(Параметры.Документ.Ссылка, Неопределено, Параметры.Дата);
	КонецЕсли;
	
	Если НЕ ДанныеТранспортнойЛогистики = Неопределено тогда
		ЗаполнитьЗначенияСвойств(СтруктураВозврата, ДанныеТранспортнойЛогистики);
	КонецЕсли;
	
	Если (НЕ ЗначениеЗаполнено(СтруктураВозврата.ВремяЛогистикиНачало)
		ИЛИ НЕ ЗначениеЗаполнено(СтруктураВозврата.ВремяЛогистикиОкончание))
		И ЗначениеЗаполнено(Параметры.ДоговорКонтрагента) тогда
		СтруктураВозврата.ВремяЛогистикиНачало = Параметры.ДоговорКонтрагента.ВремяЛогистикиНачало;
		СтруктураВозврата.ВремяЛогистикиОкончание = Параметры.ДоговорКонтрагента.ВремяЛогистикиОкончание;
	КонецЕсли;
	
	Если СтруктураВозврата.Свойство("СопроводительныеДокументы")
		И ЗначениеЗаполнено(Параметры.ДоговорКонтрагента)
		И Параметры.МассивНоменклатуры.Количество() > 0 тогда
		СтруктураВозврата.СопроводительныеДокументы = СопроводительныеДокументыСервер.ТекстСопроводительныеДокументыНоменклатуры(
		                                              Параметры.ДоговорКонтрагента,
		                                              Параметры.МассивНоменклатуры,
		                                              Параметры.Дата,
		                                              Неопределено,
		                                              Истина);
		
		СтруктураВозврата.КраткоеНаименованиеГруза = СопроводительныеДокументыСервер.КраткоеНаименованиеГруза(Параметры.МассивНоменклатуры);
	КонецЕсли;
		
	ДанныеАдресаДоставки = УправлениеКонтактнойИнформациейСлужебный.ДанныеАдресаДоставкиПоУмолчанию(Параметры.Грузополучатель);
	
	Если НЕ ДанныеАдресаДоставки = Неопределено тогда
		СтруктураВозврата.АдресДоставкиJSON = ДанныеАдресаДоставки.СтрокаJSON;
		СтруктураВозврата.АдресДоставки = ДанныеАдресаДоставки.ПредставлениеСокращенное;
	КонецЕсли;
	
	Возврат СтруктураВозврата;
	
КонецФункции

Функция ДанныеТранспортнаяЛогистикаДоставка(ДокументРеализация, ДокументСчет, Дата)
	
	Если НЕ ТипЗнч(ДокументРеализация) = Тип("ДокументСсылка.РеализацияТоваровУслуг") тогда
		Возврат Неопределено;
	Конецесли;
	
	СтруктураВозврата = Новый Структура("Маршрут,
	                                    |Водитель,
										|ВодительСсылка,
										|ВодительскоеУдостоверение,
										|МаркаАвтомобиля,
										|АвтомобильСсылка,
										|РегистрационныйЗнакАвтомобиля,
										|Перевозчик,
										|ВремяЛогистикиНачало,
										|ВремяЛогистикиОкончание,
										|");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Дата"          , Дата);
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументРеализация);
	
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ТранспортнаяЛогистикаДоставкаОбороты.Маршрут КАК Маршрут,
	|	ТранспортнаяЛогистикаДоставкаОбороты.Водитель.Перевозчик КАК Перевозчик,
	|	ТранспортнаяЛогистикаДоставкаОбороты.Водитель.ФизическоеЛицо.Наименование КАК Водитель,
	|	ТранспортнаяЛогистикаДоставкаОбороты.Водитель КАК ВодительСсылка,
	|	ТранспортнаяЛогистикаДоставкаОбороты.Водитель.ВодительскоеУдостоверение КАК ВодительскоеУдостоверение,
	|	ТранспортнаяЛогистикаДоставкаОбороты.Автомобиль КАК АвтомобильСсылка,
	|	ТранспортнаяЛогистикаДоставкаОбороты.Автомобиль.РегистрационныйЗнак КАК РегистрационныйЗнакАвтомобиля,
	|	ТранспортнаяЛогистикаДоставкаОбороты.Автомобиль.Марка + "" "" + ТранспортнаяЛогистикаДоставкаОбороты.Автомобиль.Модель КАК МаркаАвтомобиля
	|ИЗ
	|	РегистрНакопления.ТранспортнаяЛогистикаДоставка.Обороты(НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ), КОНЕЦПЕРИОДА(&Дата, ДЕНЬ), , ДокументДвижения = &ДокументСсылка) КАК ТранспортнаяЛогистикаДоставкаОбороты
	|ГДЕ
	|	ТранспортнаяЛогистикаДоставкаОбороты.КоличествоПриход > 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ТранспортнаяЛогистикаДоставкаОбороты.Маршрут,
	|	ТранспортнаяЛогистикаДоставкаОбороты.Автомобиль,
	|	ТранспортнаяЛогистикаДоставкаОбороты.Водитель,
	|	ТранспортнаяЛогистикаДоставкаОбороты.Водитель.ФизическоеЛицо.Наименование,
	|	ТранспортнаяЛогистикаДоставкаОбороты.Водитель.ВодительскоеУдостоверение,
	|	ТранспортнаяЛогистикаДоставкаОбороты.Автомобиль.РегистрационныйЗнак,
	|	ТранспортнаяЛогистикаДоставкаОбороты.Автомобиль.Марка + "" "" + ТранспортнаяЛогистикаДоставкаОбороты.Автомобиль.Модель,
	|	ТранспортнаяЛогистикаДоставкаОбороты.Водитель.Перевозчик";

	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() тогда
		ЗаполнитьЗначенияСвойств(СтруктураВозврата, Выборка);
		Возврат СтруктураВозврата;
	Иначе
		Запрос.УстановитьПараметр("ДокументСсылка", ДокументСчет);
		
		Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ТранспортнаяЛогистикаЗаказы.Маршрут КАК Маршрут,
		|	ТранспортнаяЛогистикаЗаказы.Водитель.Перевозчик КАК Перевозчик,
		|	ТранспортнаяЛогистикаЗаказы.Водитель.ФизическоеЛицо.Наименование КАК Водитель,
		|	ТранспортнаяЛогистикаЗаказы.Водитель КАК ВодительСсылка,
		|	ТранспортнаяЛогистикаЗаказы.Водитель.ВодительскоеУдостоверение КАК ВодительскоеУдостоверение,
		|	ТранспортнаяЛогистикаЗаказы.Автомобиль КАК АвтомобильСсылка,
		|	ТранспортнаяЛогистикаЗаказы.Автомобиль.РегистрационныйЗнак КАК РегистрационныйЗнакАвтомобиля,
		|	ТранспортнаяЛогистикаЗаказы.Автомобиль.Марка + "" "" + ТранспортнаяЛогистикаЗаказы.Автомобиль.Модель КАК МаркаАвтомобиля
		|ИЗ
		|	РегистрНакопления.ТранспортнаяЛогистикаЗаказы КАК ТранспортнаяЛогистикаЗаказы
		|ГДЕ
		|	ТранспортнаяЛогистикаЗаказы.Период МЕЖДУ НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ) И КОНЕЦПЕРИОДА(&Дата, ДЕНЬ)
		|	И ТранспортнаяЛогистикаЗаказы.ДокументДвижения = &ДокументСсылка
		|	И ТранспортнаяЛогистикаЗаказы.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
		|
		|СГРУППИРОВАТЬ ПО
		|	ТранспортнаяЛогистикаЗаказы.Маршрут,
		|	ТранспортнаяЛогистикаЗаказы.Автомобиль,
		|	ТранспортнаяЛогистикаЗаказы.Водитель,
		|	ТранспортнаяЛогистикаЗаказы.Водитель.ФизическоеЛицо.Наименование,
		|	ТранспортнаяЛогистикаЗаказы.Водитель.ВодительскоеУдостоверение,
		|	ТранспортнаяЛогистикаЗаказы.Автомобиль.РегистрационныйЗнак,
		|	ТранспортнаяЛогистикаЗаказы.Автомобиль.Марка + "" "" + ТранспортнаяЛогистикаЗаказы.Автомобиль.Модель,
		|	ТранспортнаяЛогистикаЗаказы.Водитель.Перевозчик";

		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() тогда
			ЗаполнитьЗначенияСвойств(СтруктураВозврата, Выборка);
			Возврат СтруктураВозврата;
		Иначе
			Возврат Неопределено;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

Функция ОтгруженныеМаршруты(Дата, Организация) Экспорт
	
	ОтгруженныеМаршруты = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТранспортнаяЛогистикаДоставкаОбороты.Организация КАК Организация,
	|	ТранспортнаяЛогистикаДоставкаОбороты.Маршрут КАК Маршрут,
	|	ТранспортнаяЛогистикаДоставкаОбороты.Водитель КАК Водитель,
	|	ТранспортнаяЛогистикаДоставкаОбороты.Автомобиль КАК Автомобиль
	|ИЗ
	|	РегистрНакопления.ТранспортнаяЛогистикаДоставка.Обороты(НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ), КОНЕЦПЕРИОДА(&Дата, ДЕНЬ), День, Организация = &Организация) КАК ТранспортнаяЛогистикаДоставкаОбороты";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() цикл
		
		ОписаниеМаршрута = Новый Структура("Организация, Маршрут, Водитель, Автомобиль");
		ЗаполнитьЗначенияСвойств(ОписаниеМаршрута, Выборка);
		
		ОтгруженныеМаршруты.Добавить(ОписаниеМаршрута);
		
	КонецЦикла;
	
	Возврат ОтгруженныеМаршруты;
	
КонецФункции