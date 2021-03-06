&Вместо("ПолучитьДанныеДляПечатиСчетаФактуры1137")
Функция Базар_ПолучитьДанныеДляПечатиСчетаФактуры1137(МассивОбъектов, ТекстЗапросаПоСчетамФактурам, ДополнитьДаннымиУПД = Ложь, ФормированиеЭД = Ложь) Экспорт
	
	Если НЕ ПривилегированныйРежим() Тогда
		// Исключим из массива документы на чтение которых у пользователя нет прав
		УправлениеДоступомБП.УдалитьНедоступныеЭлементыИзМассива(МассивОбъектов);
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.УстановитьПараметр("НачалоПримененияПостановления1137",
		УчетНДСБП.ПолучитьДатуНачалаДействияПостановления1137());
	Запрос.Текст = ТекстЗапросаПоСчетамФактурам;
	Результаты   = Запрос.ВыполнитьПакет();
	
	ВыборкаСФ = Результаты[0].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "СчетФактура");
	
	ПлатежноРасчетныеДокументы	= Неопределено;
	Если Результаты.Количество() > 1 И НЕ Результаты[1].Пустой() Тогда
		ПлатежноРасчетныеДокументы = Результаты[1].Выгрузить();
		ПлатежноРасчетныеДокументы.Индексы.Добавить("СчетФактура");
	КонецЕсли;
	
	ТаблицаСчетовФактур = НовыйТаблицаСчетовФактур();
	
	ДанныеСчетаФактуры = Новый Структура(
		"СчетФактура,ВидСчетаФактуры,Контрагент,ДоговорКонтрагента,
		|ИспользуетсяПостановлениеНДС1137,НеподтверждениеНулевойСтавки,СводныйКомиссионный,СчетаФактурыОтИмениОрганизации");
	ДанныеСчетаФактуры.ИспользуетсяПостановлениеНДС1137 = Истина;
	ДанныеСчетаФактуры.НеподтверждениеНулевойСтавки = Ложь;
	ДанныеСчетаФактуры.СчетаФактурыОтИмениОрганизации = Ложь;
	Пока ВыборкаСФ.Следующий() Цикл
		
		ТаблицаДокумента    = Неопределено;
		ШтрихкодыУпаковок   = Неопределено;
		ДокументыОснования  = Новый Массив;
		ВыборкаПоОснованиям = ВыборкаСФ.Выбрать();
		КоличествоОснований = 0;
		
		Пока ВыборкаПоОснованиям.Следующий() Цикл
			
			Если ТипЗнч(ВыборкаПоОснованиям.СчетФактура) = Тип("ДокументСсылка.СчетФактураПолученный")
			   И ДополнитьДаннымиУПД 
			   И ВыборкаПоОснованиям.ВидСчетаФактуры <> Перечисления.ВидСчетаФактурыПолученного.НаПоступление Тогда
				// УПД за поставщика только по счету-фактуре на поступление
				Продолжить;
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(ВыборкаПоОснованиям.ДокументОснование) Тогда
				Продолжить;
			КонецЕсли;
			
			ДокументыОснования.Добавить(ВыборкаПоОснованиям.ДокументОснование);
			ЗаполнитьЗначенияСвойств(ДанныеСчетаФактуры, ВыборкаСФ);
			ПараметрыОснования = ПодготовитьДанныеДляПечатиСчетовФактур(ВыборкаПоОснованиям.ДокументОснование, ДанныеСчетаФактуры);
				
			Если ПараметрыОснования.Реквизиты = Неопределено 
			 ИЛИ ПараметрыОснования.ТаблицаДокумента = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			Реквизиты = ПараметрыОснования.Реквизиты[0];
			
			Если ТаблицаДокумента = Неопределено Тогда
				ТаблицаДокумента = ПараметрыОснования.ТаблицаДокумента;
			Иначе
				ОбщегоНазначенияБПВызовСервера.ЗагрузитьВТаблицуЗначений(ПараметрыОснования.ТаблицаДокумента, ТаблицаДокумента);
			КонецЕсли;
			//ГосИС
			Если ПараметрыОснования.Свойство("ШтрихкодыУпаковок") Тогда
				Если ШтрихкодыУпаковок = Неопределено Тогда
					ШтрихкодыУпаковок = ПараметрыОснования.ШтрихкодыУпаковок;
				Иначе
					ОбщегоНазначенияБПВызовСервера.ЗагрузитьВТаблицуЗначений(ПараметрыОснования.ШтрихкодыУпаковок, ШтрихкодыУпаковок);
				КонецЕсли;
			КонецЕсли;
			//Конец ГосИС
			КоличествоОснований = КоличествоОснований + 1;
			
		КонецЦикла;
		
		Если УчетНДСПереопределяемый.ЭтоСчетФактураНаАванс(ВыборкаСФ.ВидСчетаФактуры) И ДополнитьДаннымиУПД Тогда
			// Методически неверно оформлять УПД в случае получения предварительной оплаты.
			Продолжить;
		КонецЕсли;

		Если ТаблицаДокумента = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ТаблицаДокумента.Колонки.СуммаБезНДС.Имя = "Стоимость";
		
		Если ВыборкаСФ.Дата >= Дата(2016, 07, 01) 
			И ВыборкаСФ.Дата < Дата(2017, 10, 01)
			И ВыборкаСФ.ВидСчетаФактуры = Перечисления.ВидСчетаФактурыВыставленного.НаРеализацию Тогда
			Для Каждого СтрокаДокумента Из ТаблицаДокумента Цикл
				Если СокрЛП(СтрокаДокумента.ТоварКодТНВЭД) <> "--" Тогда
					МассивСтрок = Новый Массив();
					МассивСтрок.Добавить(СтрокаДокумента.ТоварНаименование);
					МассивСтрок.Добавить(НСтр("ru=', код ТН ВЭД'"));
					МассивСтрок.Добавить(" ");
					МассивСтрок.Добавить(СокрЛП(СтрокаДокумента.ТоварКодТНВЭД));
					СтрокаДокумента.ТоварНаименование = СтрСоединить(МассивСтрок);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Если КоличествоОснований > 1 Тогда
			ТаблицаДокумента.ЗаполнитьЗначения(1, "НомерСтроки,НомерТабЧасти");
		КонецЕсли;
		
		КолонкиГруппировок = ""
			+ "Товар,"
			+ "ТоварКод,"
			+ "ТоварКодТНВЭД,"
			+ "ТоварНаименование,"
			+ "СтранаПроисхождения,"
			+ "ПредставлениеСтраны,"
			+ "СтранаПроисхожденияКод,"
			+ "НомерГТД,"
			+ "ПредставлениеГТД,"
			+ "РегистрационныйНомерТД,"
			+ "ЕдиницаИзмерения,"
			+ "ЕдиницаИзмеренияКод,"
			+ "ЕдиницаИзмеренияНаименование,"
			+ "Цена,"
			+ "СтавкаНДС,"
			+ "КонтрагентСводныйСФ,"
			+ "Акциз,"
			+ "НомерСтроки,"
			+ "НомерТабЧасти,"
			+ "СертификатыДекларации";
		
		КолонкиСуммирования = ""
			+ "Количество,"
			+ "Всего,"
			+ "Стоимость,"
			+ "СуммаНДС,"
			+ "ВсегоРуб,"
			+ "НДСРуб,"
			+ "СуммаБезНДСРуб";
		
		ТаблицаДокумента.Свернуть(КолонкиГруппировок, КолонкиСуммирования);
		
		ДанныеШапки = ПодготовитьДанныеШапкиСчетаФактуры1137(ВыборкаСФ, Реквизиты, ПлатежноРасчетныеДокументы, ДополнитьДаннымиУПД, ФормированиеЭД);
		
		СчетФактура                    = ТаблицаСчетовФактур.Добавить();
		СчетФактура.Дата               = ВыборкаСФ.Дата;
		СчетФактура.СчетФактура        = ВыборкаСФ.СчетФактура;
		СчетФактура.ВидСчетаФактуры    = ВыборкаСФ.ВидСчетаФактуры;
		СчетФактура.СчетФактураБезНДС  = ВыборкаСФ.СчетФактураБезНДС;
		СчетФактура.ДанныеШапки        = ДанныеШапки;
		СчетФактура.ТаблицаДокумента   = ТаблицаДокумента;
		СчетФактура.ШтрихкодыУпаковок  = ШтрихкодыУпаковок;
		СчетФактура.ДокументыОснования = ДокументыОснования;
		СчетФактура.Ссылка             = ВыборкаСФ.СчетФактура;
		
	КонецЦикла;
	
	Возврат ТаблицаСчетовФактур;
	
КонецФункции

&Вместо("ПечатьУниверсальныхПередаточныхДокументов981")
Функция Базар_ПечатьУниверсальныхПередаточныхДокументов981(МассивОбъектов, ОбъектыПечати, ТекстЗапросаДокументам, ТолькоПередаточныйДокумент = Ложь, ТабДокумент = Неопределено, ПараметрыПечати) Экспорт
	
	Если ТабДокумент = Неопределено Тогда
		ТабДокумент = Новый ТабличныйДокумент;
	Иначе
		ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
	КонецЕсли;
	
	ТабДокумент.АвтоМасштаб        = Истина;
	ТабДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ТабДокумент.ЭкземпляровНаСтранице = 1;
	
	ТабДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_УниверсальныйПередаточныйДокумент_981";
	
	УстановкаМинимальныхПолейДляПечати(ТабДокумент);
	
	//Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьУПД.ПФ_MXL_УниверсальныйПередаточныйДокумент981"); // -- RIAZmey
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьУПД.Базар_ПФ_MXL_УниверсальныйПередаточныйДокумент981"); // ++ RIAZmey
	
	Возврат ТабличныйДокументУПД(
		Макет, МассивОбъектов, ОбъектыПечати, ТабДокумент, ТекстЗапросаДокументам, ТолькоПередаточныйДокумент, ПараметрыПечати);
		
КонецФункции

&Вместо("ПодготовитьДанныеШапкиСчетаФактуры1137")
Функция Базар_ПодготовитьДанныеШапкиСчетаФактуры1137(ВыборкаСФ, СтрокаТаблицыРеквизиты, ПлатежноРасчетныеДокументы, ДополнитьДаннымиУПД, ФормированиеЭД = Ложь)
	
	ДанныеШапки = ПродолжитьВызов(ВыборкаСФ, СтрокаТаблицыРеквизиты, ПлатежноРасчетныеДокументы, ДополнитьДаннымиУПД, ФормированиеЭД);
	
	Если ВыборкаСФ.ЭтоСчетФактураВыданный Тогда
		
		ДанныеАдресаДоставкиОрганизация = УправлениеКонтактнойИнформациейСлужебный.ДанныеАдресаДоставкиПоУмолчанию(ВыборкаСФ.Организация);
		ДанныеШапки.ПредставлениеГрузоотправителя = ДанныеШапки.ПредставлениеПоставщика + ", " +
		                                            ДанныеАдресаДоставкиОрганизация.ПредставлениеПолное;
		
		Если ДанныеШапки.Грузополучатель = ДанныеШапки.Покупатель тогда
			ДанныеАдресаПокупателя = УправлениеКонтактнойИнформациейСлужебный.ДанныеАдресаДоставкиПоУмолчанию(ДанныеШапки.Грузополучатель);
			ДанныеШапки.ПредставлениеГрузополучателя = ДанныеШапки.ПредставлениеПокупателя + ", " +
			                                           ДанныеАдресаПокупателя.ПредставлениеПолное;
		КонецЕсли;
		
		Если НЕ ОбщегоНазначенияБПВызовСервераПовтИсп.ЭтоЮрЛицо(ВыборкаСФ.Организация) тогда
			Если ЗначениеЗаполнено(ВыборкаСФ.СчетФактура.ЗаРуководителяНаОсновании) тогда
				ДанныеШапки.Свидетельство = ДанныеШапки.Свидетельство + "; основание подписи: " + ВыборкаСФ.СчетФактура.ЗаРуководителяНаОсновании.Наименование;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ДанныеШапки;
	
КонецФункции

&Вместо("ПодготовитьДанныеДляПечатиСчетовФактур")
Функция Базар_ПодготовитьДанныеДляПечатиСчетовФактур(ДокументОснование, ДанныеСчетаФактуры) Экспорт

	ДанныеДляПечати = Новый Структура;
	
	СчетФактураПолученныйИзСтранТаможенногоСоюза = 
		КонтрагентРезидентТаможенногоСоюза(ДанныеСчетаФактуры.Контрагент)
		И ТипЗнч(ДанныеСчетаФактуры.СчетФактура) = Тип("ДокументСсылка.СчетФактураПолученный");
	
	Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ПринятиеКУчетуОС")
		ИЛИ СчетФактураПолученныйИзСтранТаможенногоСоюза Тогда
		ДанныеДляПечати.Вставить("Реквизиты",			Неопределено);
		ДанныеДляПечати.Вставить("ТаблицаДокумента",	Неопределено);
		Возврат ДанныеДляПечати;
	КонецЕсли;
	
	ЦифровойИндексОбособленногоПодразделения = "";
	
	Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.СчетФактураВыданный") 
		И ЗначениеЗаполнено(ДокументОснование.ДокументОснование) Тогда 
		ОснованиеСчетаФактуры = ДокументОснование.ДокументОснование;
		Если ОснованиеСчетаФактуры.Метаданные().Реквизиты.Найти("ПодразделениеОрганизации") <> Неопределено Тогда
			ЦифровойИндексОбособленногоПодразделения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОснованиеСчетаФактуры,
				"ПодразделениеОрганизации.ЦифровойИндексОбособленногоПодразделения");
		КонецЕсли;
	КонецЕсли;
	
	ВалютаРеглУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	ДополнительнаяКолонкаПечатныхФормДокументов = Константы.ДополнительнаяКолонкаПечатныхФормДокументов.Получить();
	Если НЕ ЗначениеЗаполнено(ДополнительнаяКолонкаПечатныхФормДокументов) Тогда
		ДополнительнаяКолонкаПечатныхФормДокументов = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.НеВыводить;
	КонецЕсли;
	
	Если НЕ ДанныеСчетаФактуры.Свойство("НеподтверждениеНулевойСтавки") Тогда
		ДанныеСчетаФактуры.Вставить("НеподтверждениеНулевойСтавки", Ложь);
	КонецЕсли;
	
	Если НЕ ДанныеСчетаФактуры.Свойство("СводныйКомиссионный") Тогда
		ДанныеСчетаФактуры.Вставить("СводныйКомиссионный", Ложь);
	КонецЕсли;
	
	Если НЕ ДанныеСчетаФактуры.Свойство("СчетаФактурыОтИмениОрганизации") Тогда
		ДанныеСчетаФактуры.Вставить("СчетаФактурыОтИмениОрганизации", Ложь);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВалютаРеглУчета",					ВалютаРеглУчета);
	Запрос.УстановитьПараметр("ДокументОснование",					ДокументОснование);
	
	СводныйСФКомиссияПоЗакупке 	= Ложь;
	СводныйСФКомиссияПоПродаже	= Ложь;
	
	ПредставлениеПоставщика 	= "";
	АдресПоставщика 			= "";
	Грузоотправитель 			= "";
	ИННКПППоставщика 			= "";
	
	ПредставлениеПокупателя = "";
	АдресПокупателя 		= "";
	Грузополучатель			= "";
	ИННКПППокупателя 		= "";
	
	Если ДанныеСчетаФактуры.СводныйКомиссионный
		И НЕ ДанныеСчетаФактуры.СчетаФактурыОтИмениОрганизации Тогда
		Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.СчетФактураВыданный") Тогда
			//значит авансовый, нужно определить по закупке или по продаже
			Если ДанныеСчетаФактуры.ВидСчетаФактуры = Перечисления.ВидСчетаФактурыВыставленного.НаАвансКомитентаНаЗакупку Тогда
				//Значит авансовый выданный комиссионером (комиссия по закупке)
				СводныйСФКомиссияПоЗакупке = Истина;
				
				ПараметрыСводногоСФПоКомиссии = ПолучитьПараметрыСводногоСчетаФактурыКомиссияПоЗакупке(ДанныеСчетаФактуры.СчетФактура, ДанныеСчетаФактуры.ВидСчетаФактуры);
				
				ПредставлениеПоставщика = ПараметрыСводногоСФПоКомиссии.ПредставлениеПоставщика;
				АдресПоставщика 		= ПараметрыСводногоСФПоКомиссии.АдресПоставщика;
				Грузоотправитель 		= ПараметрыСводногоСФПоКомиссии.Грузоотправитель;
				ИННКПППоставщика 		= ПараметрыСводногоСФПоКомиссии.ИННКПППоставщика;	
			Иначе			
				//Значит авансовый выданный комитентом (комиссия по продаже)
				СводныйСФКомиссияПоПродаже	= Истина;
				
				ПараметрыСводногоСФПоКомиссии = ПолучитьПараметрыСводногоСчетаФактурыКомиссияПоПродаже(ДанныеСчетаФактуры.СчетФактура, ДанныеСчетаФактуры.ВидСчетаФактуры);
				
				ПредставлениеПокупателя = ПараметрыСводногоСФПоКомиссии.ПредставлениеПокупателя;
				АдресПокупателя 		= ПараметрыСводногоСФПоКомиссии.АдресПокупателя;
				Грузополучатель 		= ПараметрыСводногоСФПоКомиссии.Грузополучатель;
				ИННКПППокупателя 		= ПараметрыСводногоСФПоКомиссии.ИННКПППокупателя;
			КонецЕсли;
		ИначеЕсли ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ОтчетКомитентуОПродажах") 
			И ЗначениеЗаполнено(ДанныеСчетаФактуры.СчетФактура.Продавец) Тогда 
			//Значит комиссия по закупке СФ выданный комиссионером
			СводныйСФКомиссияПоЗакупке = Истина;
			
			ПараметрыСводногоСФПоКомиссии = ПолучитьПараметрыСводногоСчетаФактурыКомиссияПоЗакупке(ДанныеСчетаФактуры.СчетФактура, ДанныеСчетаФактуры.ВидСчетаФактуры);
			
			ПредставлениеПоставщика = ПараметрыСводногоСФПоКомиссии.ПредставлениеПоставщика;
			АдресПоставщика 		= ПараметрыСводногоСФПоКомиссии.АдресПоставщика;
			Грузоотправитель 		= ПараметрыСводногоСФПоКомиссии.Грузоотправитель;
			ИННКПППоставщика 		= ПараметрыСводногоСФПоКомиссии.ИННКПППоставщика;
			
		ИначеЕсли ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ОтчетКомиссионераОПродажах") Тогда
			//Значит комиссия по продаже СФ выданный комитентом
			СводныйСФКомиссияПоПродаже	= Истина;
			
			ПараметрыСводногоСФПоКомиссии = ПолучитьПараметрыСводногоСчетаФактурыКомиссияПоПродаже(ДанныеСчетаФактуры.СчетФактура, ДанныеСчетаФактуры.ВидСчетаФактуры);
			
			ПредставлениеПокупателя = ПараметрыСводногоСФПоКомиссии.ПредставлениеПокупателя;
			АдресПокупателя 		= ПараметрыСводногоСФПоКомиссии.АдресПокупателя;
			Грузополучатель 		= ПараметрыСводногоСФПоКомиссии.Грузополучатель;
			ИННКПППокупателя 		= ПараметрыСводногоСФПоКомиссии.ИННКПППокупателя;
		ИначеЕсли  ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
			//Значит комиссия по закупке СФ полученный от комиссионера
			СводныйСФКомиссияПоЗакупке = Истина;
			
			ПараметрыСводногоСФПоКомиссии = ПолучитьПараметрыСводногоСчетаФактурыКомиссияПоЗакупке(ДанныеСчетаФактуры.СчетФактура, ДанныеСчетаФактуры.ВидСчетаФактуры);
			
			ПредставлениеПоставщика = ПараметрыСводногоСФПоКомиссии.ПредставлениеПоставщика;
			АдресПоставщика 		= ПараметрыСводногоСФПоКомиссии.АдресПоставщика;
			Грузоотправитель 		= ПараметрыСводногоСФПоКомиссии.Грузоотправитель;
			ИННКПППоставщика 		= ПараметрыСводногоСФПоКомиссии.ИННКПППоставщика;
			
		КонецЕсли;
	КонецЕсли;
	
	ПониженныеВидыСтавок = Новый Массив;
	ЗначениеОбщейСтавкиНДС = 0;
	ЗначениеПониженнойСтавкиНДС = 0;
	ОбщаяСтавкаНДС = Перечисления.СтавкиНДС.ПустаяСсылка();
	ПониженнаяСтавкаНДС = Перечисления.СтавкиНДС.ПустаяСсылка();
	Если ДанныеСчетаФактуры.НеподтверждениеНулевойСтавки Тогда
		ПониженныеВидыСтавок.Добавить(Перечисления.ВидыСтавокНДС.Пониженная);
		ПониженныеВидыСтавок.Добавить(Перечисления.ВидыСтавокНДС.ПониженнаяРасчетная);
		
		ДатаДокументаОтгрузки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование, "Дата");
		
		ОбщаяСтавкаНДС = Перечисления.СтавкиНДС.СтавкаНДС(Перечисления.ВидыСтавокНДС.Общая, ДатаДокументаОтгрузки);
		ПониженнаяСтавкаНДС = Перечисления.СтавкиНДС.СтавкаНДС(Перечисления.ВидыСтавокНДС.Пониженная, ДатаДокументаОтгрузки);
		
		ЗначениеОбщейСтавкиНДС = УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(ОбщаяСтавкаНДС);
		ЗначениеПониженнойСтавкиНДС = УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(ПониженнаяСтавкаНДС);
	КонецЕсли;
	
	ЭтоДоговорПоставкиГосЗакупок = ГосЗакупкиСервер.ЭтоДоговорПоставкиГосЗакупок(ДанныеСчетаФактуры.ДоговорКонтрагента);
	
	Запрос.УстановитьПараметр("СводныйСФКомиссияПоЗакупке",			СводныйСФКомиссияПоЗакупке);
	Запрос.УстановитьПараметр("СводныйСФКомиссияПоПродаже",			СводныйСФКомиссияПоПродаже);
	Запрос.УстановитьПараметр("ПредставлениеПоставщика",			ПредставлениеПоставщика);
	Запрос.УстановитьПараметр("АдресПоставщика",					АдресПоставщика);
	Запрос.УстановитьПараметр("Грузоотправитель",					Грузоотправитель);
	Запрос.УстановитьПараметр("ИННКПППоставщика",					ИННКПППоставщика);
	Запрос.УстановитьПараметр("ПредставлениеПокупателя",			ПредставлениеПокупателя);
	Запрос.УстановитьПараметр("АдресПокупателя",					АдресПокупателя);
	Запрос.УстановитьПараметр("Грузополучатель",					Грузополучатель);
	Запрос.УстановитьПараметр("ИННКПППокупателя",					ИННКПППокупателя);
	Запрос.УстановитьПараметр("СчетФактура",						ДанныеСчетаФактуры.СчетФактура);
	Запрос.УстановитьПараметр("ВидСчетаФактуры",					ДанныеСчетаФактуры.ВидСчетаФактуры);
	Запрос.УстановитьПараметр("Контрагент",							ДанныеСчетаФактуры.Контрагент);
	Запрос.УстановитьПараметр("ДоговорКонтрагента",					ДанныеСчетаФактуры.ДоговорКонтрагента);
	Запрос.УстановитьПараметр("ИспользуетсяПостановлениеНДС1137",	ДанныеСчетаФактуры.ИспользуетсяПостановлениеНДС1137);
	Запрос.УстановитьПараметр("НеподтверждениеНулевойСтавки",		ДанныеСчетаФактуры.НеподтверждениеНулевойСтавки);
	Запрос.УстановитьПараметр("НомерСтроки",						?(ЗначениеЗаполнено(ДанныеСчетаФактуры.СчетФактура), Неопределено, ДанныеСчетаФактуры.НомерСтроки));
	Запрос.УстановитьПараметр("ПустоеПодразделение",				БухгалтерскийУчетПереопределяемый.ПустоеПодразделение());
	Запрос.УстановитьПараметр("ЦифровойИндексОбособленногоПодразделения", 
		ЦифровойИндексОбособленногоПодразделения);
	Запрос.УстановитьПараметр("ТекстБезАкциза",
		?(ДанныеСчетаФактуры.ИспользуетсяПостановлениеНДС1137, НСтр("ru = 'без акциза'"), ""));
	Запрос.УстановитьПараметр("ТекстКомиссионноеВознаграждение",	НСтр("ru = 'Комиссионное вознаграждение'"));
	Запрос.УстановитьПараметр("ДополнительнаяКолонкаПечатныхФормДокументов",
		ДополнительнаяКолонкаПечатныхФормДокументов);
	Запрос.УстановитьПараметр("ЕдиницаИзмеренияШтука", 
		Справочники.КлассификаторЕдиницИзмерения.ПолучитьЕдиницуИзмеренияПоУмолчанию());
	Запрос.УстановитьПараметр("ПониженныеВидыСтавок", ПониженныеВидыСтавок);
	Запрос.УстановитьПараметр("ЗначениеОбщейСтавкиНДС", ЗначениеОбщейСтавкиНДС);
	Запрос.УстановитьПараметр("ЗначениеПониженнойСтавкиНДС", ЗначениеПониженнойСтавкиНДС);
	Запрос.УстановитьПараметр("ОбщаяСтавкаНДС", ОбщаяСтавкаНДС);
	Запрос.УстановитьПараметр("ПониженнаяСтавкаНДС", ПониженнаяСтавкаНДС);
	Запрос.УстановитьПараметр("ЭтоДоговорПоставкиГосЗакупок", ЭтоДоговорПоставкиГосЗакупок);

	НомераТаблиц = Новый Структура;

	Запрос.Текст = Документы[ДокументОснование.Метаданные().Имя].ТекстЗапросаДанныеДляПечатиСчетовФактур(НомераТаблиц)
		+ ТекстЗапросаДанныеДляПечатиСчетовФактур(НомераТаблиц);
	
	Результат = Запрос.ВыполнитьПакет();

	Если Результат[НомераТаблиц.Реквизиты].Пустой()
		ИЛИ Результат[НомераТаблиц.ТаблицаДокумента].Пустой() Тогда
		
		ДанныеДляПечати.Вставить("Реквизиты",			Неопределено);
		ДанныеДляПечати.Вставить("ТаблицаДокумента",	Неопределено);

		Возврат ДанныеДляПечати;
		
	КонецЕсли;	
			
	ТаблицаРеквизиты = Результат[НомераТаблиц.Реквизиты].Выгрузить();
	ТаблицаДокумента = Результат[НомераТаблиц.ТаблицаДокумента].Выгрузить();
	Реквизиты = ТаблицаРеквизиты[0];

	РасчетыВУсловныхЕдиницах = ?(ТипЗнч(Реквизиты.РасчетыВУсловныхЕдиницах) = Тип("Булево"), Реквизиты.РасчетыВУсловныхЕдиницах, Ложь);
	
	НуженПересчетВРубли = (РасчетыВУсловныхЕдиницах ИЛИ ДанныеСчетаФактуры.НеподтверждениеНулевойСтавки)
		И Реквизиты.Валюта <> ВалютаРеглУчета
		И ДанныеСчетаФактуры.ИспользуетсяПостановлениеНДС1137;

	Если НуженПересчетВРубли Тогда
		ТаблицаРеквизиты.ЗаполнитьЗначения(ВалютаРеглУчета, "Валюта");
	КонецЕсли;

	СчетФактураНаРеализацию = ДанныеСчетаФактуры.ВидСчетаФактуры = Перечисления.ВидСчетаФактурыВыставленного.НаРеализацию;
	
	Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.РеализацияТоваровУслуг") тогда
		
		ВыборкаСопрДокументов = СопроводительныеДокументыСервер.ВыборкаСопроводительныхДокументов(ТаблицаДокумента.ВыгрузитьКолонку("Товар"), ДанныеСчетаФактуры.СчетФактура.Дата);
		ТаблицаДокумента.Колонки.Добавить("СертификатыДекларации");
		
		Если ДанныеСчетаФактуры.ДоговорКонтрагента.ОбособленныйУчетМногооботнойТары тогда
			МногооборотнаяТараСервер.ДобавитьВТаблицуПечатиРеализацииМногооборотнуюТару(ДокументОснование, ТаблицаДокумента);
		КонецЕсли;
		
	КонецЕсли;
	
	СтруктураРеквизитов = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(Реквизиты);
	НДСИсчисляетсяНалоговымАгентом = СтруктураРеквизитов.Свойство("НДСИсчисляетсяНалоговымАгентом") 
		И СтруктураРеквизитов.НДСИсчисляетсяНалоговымАгентом = Истина;
	
	Для каждого СтрокаДокумента Из ТаблицаДокумента Цикл
		
		Если НуженПересчетВРубли Тогда
			
			СтрокаДокумента.Всего	 = СтрокаДокумента.ВсегоРуб;
			СтрокаДокумента.СуммаНДС = СтрокаДокумента.НДСРуб;
			СтрокаДокумента.Цена	 = 0;
			
		КонецЕсли;	
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьПериодичностьУслуг") Тогда
			// Дополним наименование периодичностью услуги.
			// В таблицах документах у которых есть поле "Содержание" наименование формируется сразу с периодичностью, 
			// в этом случае ПериодичностьУслуги будет неопределено.
			// В остальных документах формируем наименование в момент печати.
			СтрокаДокумента.ТоварНаименование = РаботаСНоменклатуройКлиентСервер.СодержаниеУслуги(
				СтрокаДокумента.ТоварНаименование, СтрокаДокумента.ПериодичностьУслуги, Реквизиты.ДатаОснования);
		КонецЕсли;
		// Определяем окончательную сумму без НДС с учетом всех корректировок и цену
		СтрокаДокумента.СуммаБезНДС = СтрокаДокумента.Всего - СтрокаДокумента.СуммаНДС;
	
		Если СчетФактураНаРеализацию
			И НЕ НДСИсчисляетсяНалоговымАгентом
			И (СтрокаДокумента.СтавкаНДС = Перечисления.СтавкиНДС.НДС20_120
			ИЛИ СтрокаДокумента.СтавкаНДС = Перечисления.СтавкиНДС.НДС18_118
			ИЛИ СтрокаДокумента.СтавкаНДС = Перечисления.СтавкиНДС.НДС10_110) Тогда
			
			// В счетах-фактурах, составляемых по товарам (работам, услугам),
			// реализуемым по государственным регулируемым ценам,
			// в графе 7 следует указывать ставку налога в размере 18 (10) процентов,
			// а в графе 5 – стоимость поставляемых по счету-фактуре товаров
			// (выполненных работ, оказанных услуг) без налога на добавленную стоимость
			
			Если СтрокаДокумента.Количество <> 0 Тогда
				СтрокаДокумента.Цена = Окр(СтрокаДокумента.Всего / СтрокаДокумента.Количество, 2);
			КонецЕсли;
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтрокаДокумента.ЕдиницаИзмерения) Тогда
			СтрокаДокумента.Количество = 0;
			СтрокаДокумента.Цена = 0;
		ИначеЕсли СтрокаДокумента.Количество = 0 Тогда
			СтрокаДокумента.ЕдиницаИзмерения = "";
			СтрокаДокумента.Цена = 0;
		ИначеЕсли СтрокаДокумента.Цена = 0 Тогда
			СтрокаДокумента.Цена = Окр(СтрокаДокумента.СуммаБезНДС / СтрокаДокумента.Количество, 2);
		КонецЕсли;
		
		Если ЭтоДоговорПоставкиГосЗакупок тогда
			ТоварНаименование = СтрокаДокумента.ТоварНаименование;
			СтрокаДокумента.ТоварНаименование = ГосЗакупкиСервер.ПечатноеНаименованиеНоменклатурыГосЗакупок(ДанныеСчетаФактуры.ДоговорКонтрагента, СтрокаДокумента.ТоварГосЗакупок, СтрокаДокумента.ЦенаГосЗакупок);
			Если НЕ ЗначениеЗаполнено(СтрокаДокумента.ТоварНаименование) тогда
				СтрокаДокумента.ТоварНаименование = ТоварНаименование;
			КонецЕсли;
		КонецЕсли;
		
		Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.РеализацияТоваровУслуг") тогда
			СтрокаДокумента.СертификатыДекларации = СопроводительныеДокументыСервер.ТекстСопроводительныеДокументыНоменклатуры(ДанныеСчетаФактуры.ДоговорКонтрагента, СтрокаДокумента.Товар, ДанныеСчетаФактуры.СчетФактура.Дата, ВыборкаСопрДокументов);
		КонецЕсли;
		
	КонецЦикла;
	
	ТаблицаРеквизиты.Колонки.Добавить("ДокументОснование", Документы.ТипВсеСсылки());
	ТаблицаРеквизиты.ЗаполнитьЗначения(ДокументОснование, "ДокументОснование");
	
	Если ТаблицаРеквизиты.Колонки.Найти("СводныйСФКомиссияПоЗакупке") = Неопределено Тогда
		ТаблицаРеквизиты.Колонки.Добавить("СводныйСФКомиссияПоЗакупке", Новый ОписаниеТипов("Булево"));
		ТаблицаРеквизиты.ЗаполнитьЗначения(Ложь, "СводныйСФКомиссияПоЗакупке");
	КонецЕсли;
	
	Если ТаблицаРеквизиты.Колонки.Найти("СводныйСФКомиссияПоПродаже") = Неопределено Тогда
		ТаблицаРеквизиты.Колонки.Добавить("СводныйСФКомиссияПоПродаже", Новый ОписаниеТипов("Булево"));
		ТаблицаРеквизиты.ЗаполнитьЗначения(Ложь, "СводныйСФКомиссияПоПродаже");
	КонецЕсли;
	//ГосИС
	Если НомераТаблиц.Свойство("ШтрихкодыУпаковок") Тогда
		ШтрихкодыУпаковок = Результат[НомераТаблиц.ШтрихкодыУпаковок].Выгрузить();
		ДанныеДляПечати.Вставить("ШтрихкодыУпаковок", ЭлектронноеВзаимодействиеИСМП.ЧастичноеСодержимое(ШтрихкодыУпаковок));
	КонецЕсли;
	//Конец ГосИС
	
	ДанныеДляПечати.Вставить("Реквизиты",			ТаблицаРеквизиты);
	ДанныеДляПечати.Вставить("ТаблицаДокумента",	ТаблицаДокумента);

	Возврат ДанныеДляПечати;

КонецФункции

&Вместо("ТекстЗапросаДанныеДляПечатиСчетовФактур")
Функция Базар_ТекстЗапросаДанныеДляПечатиСчетовФактур(НомераТаблиц)

	НомераТаблиц.Вставить("ТаблицаДокумента", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.НомерТабЧасти КАК НомерТабЧасти,
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.Товар = ""СуммоваяРазница""
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ ТаблицаДокумента.Товар
	|	КОНЕЦ КАК Товар,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.Товар = ""СуммоваяРазница""
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ ТаблицаДокумента.ТоварГосЗакупок
	|	КОНЕЦ КАК ТоварГосЗакупок,
	|	ВЫБОР
	|		КОГДА &ДополнительнаяКолонкаПечатныхФормДокументов = ЗНАЧЕНИЕ(Перечисление.ДополнительнаяКолонкаПечатныхФормДокументов.Артикул)
	|			ТОГДА ТаблицаДокумента.ТоварАртикул
	|		ИНАЧЕ ТаблицаДокумента.ТоварКод
	|	КОНЕЦ КАК ТоварКод,
	|	ТаблицаДокумента.ТоварНаименование КАК ТоварНаименование,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.ТоварКодТНВЭД = ЗНАЧЕНИЕ(Справочник.КлассификаторТНВЭД.ПустаяСсылка)
	|			ТОГДА ""--""
	|		ИНАЧЕ ТаблицаДокумента.ТоварКодТНВЭД
	|	КОНЕЦ КАК ТоварКодТНВЭД,
	|	ТаблицаДокумента.СтранаПроисхождения КАК СтранаПроисхождения,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СтранаПроисхождения = ЗНАЧЕНИЕ(Справочник.СтраныМира.РОССИЯ)
	|			ТОГДА """"
	|		ИНАЧЕ ЕСТЬNULL(СтраныМира.Наименование, """")
	|	КОНЕЦ КАК ПредставлениеСтраны,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СтранаПроисхождения = ЗНАЧЕНИЕ(Справочник.СтраныМира.РОССИЯ)
	|			ТОГДА """"
	|		ИНАЧЕ ЕСТЬNULL(СтраныМира.Код, """")
	|	КОНЕЦ КАК СтранаПроисхожденияКод,
	|	ТаблицаДокумента.НомерГТД КАК НомерГТД,
	|	ТаблицаДокумента.ПредставлениеГТД КАК ПредставлениеГТД,
	|	ТаблицаДокумента.РегистрационныйНомерТД КАК РегистрационныйНомерТД,
	|	ТаблицаДокумента.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ЕСТЬNULL(КлассификаторЕдиницИзмерения.Код, """") КАК ЕдиницаИзмеренияКод,
	|	ЕСТЬNULL(КлассификаторЕдиницИзмерения.Наименование, """") КАК ЕдиницаИзмеренияНаименование,
	|	ТаблицаДокумента.Количество КАК Количество,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СуммаВключаетНДС
	|				И НЕ &НеподтверждениеНулевойСтавки
	|			ТОГДА ВЫБОР
	|					КОГДА ТаблицаДокумента.Количество = 0
	|						ТОГДА 0
	|					КОГДА ТаблицаДокумента.СуммаНДС = 0
	|						ТОГДА ТаблицаДокумента.Цена
	|					ИНАЧЕ ВЫРАЗИТЬ((ТаблицаДокумента.Сумма - ТаблицаДокумента.СуммаНДС) / ТаблицаДокумента.Количество КАК ЧИСЛО(15, 2))
	|				КОНЕЦ
	|		ИНАЧЕ ТаблицаДокумента.Цена
	|	КОНЕЦ КАК Цена,
	|	ТаблицаДокумента.ЦенаГосЗакупок КАК ЦенаГосЗакупок,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СуммаВключаетНДС
	|				И НЕ &НеподтверждениеНулевойСтавки
	|			ТОГДА ТаблицаДокумента.Сумма
	|		ИНАЧЕ ТаблицаДокумента.Сумма + ВЫБОР
	|				КОГДА &НеподтверждениеНулевойСтавки
	|					ТОГДА ТаблицаДокумента.Сумма * ВЫБОР
	|							КОГДА СтавкиНДСНоменклатура.ВидСтавкиНДС В (&ПониженныеВидыСтавок)
	|								ТОГДА &ЗначениеПониженнойСтавкиНДС / 100
	|							ИНАЧЕ &ЗначениеОбщейСтавкиНДС / 100
	|						КОНЕЦ
	|				ИНАЧЕ ТаблицаДокумента.СуммаНДС
	|			КОНЕЦ
	|	КОНЕЦ КАК Всего,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.Товар = ""СуммоваяРазница""
	|			ТОГДА 0
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ТаблицаДокумента.СуммаВключаетНДС
	|					ТОГДА ТаблицаДокумента.Сумма - ТаблицаДокумента.СуммаНДС
	|				ИНАЧЕ ТаблицаДокумента.Сумма
	|			КОНЕЦ
	|	КОНЕЦ КАК СуммаБезНДС,
	|	ВЫБОР
	|		КОГДА &НеподтверждениеНулевойСтавки
	|			ТОГДА ТаблицаДокумента.Сумма * ВЫБОР
	|					КОГДА СтавкиНДСНоменклатура.ВидСтавкиНДС В (&ПониженныеВидыСтавок)
	|						ТОГДА &ЗначениеПониженнойСтавкиНДС / 100
	|					ИНАЧЕ &ЗначениеОбщейСтавкиНДС / 100
	|				КОНЕЦ
	|		ИНАЧЕ ТаблицаДокумента.СуммаНДС
	|	КОНЕЦ КАК СуммаНДС,
	|	ВЫБОР
	|		КОГДА &НеподтверждениеНулевойСтавки
	|			ТОГДА ВЫБОР
	|					КОГДА СтавкиНДСНоменклатура.ВидСтавкиНДС В (&ПониженныеВидыСтавок)
	|						ТОГДА &ПониженнаяСтавкаНДС
	|					ИНАЧЕ &ОбщаяСтавкаНДС
	|				КОНЕЦ
	|		ИНАЧЕ ТаблицаДокумента.СтавкаНДС
	|	КОНЕЦ КАК СтавкаНДС,
	|	&ТекстБезАкциза КАК Акциз,
	|	ТаблицаДокумента.Ссылка КАК Ссылка,
	|	ТаблицаДокумента.ЭтоКомиссия КАК ЭтоКомиссия,
	|	ВЫБОР
	|		КОГДА &НеподтверждениеНулевойСтавки
	|			ТОГДА ТаблицаДокумента.СуммаБезНДСРуб + ТаблицаДокумента.СуммаБезНДСРуб * ВЫБОР
	|					КОГДА СтавкиНДСНоменклатура.ВидСтавкиНДС В (&ПониженныеВидыСтавок)
	|						ТОГДА &ЗначениеПониженнойСтавкиНДС / 100
	|					ИНАЧЕ &ЗначениеОбщейСтавкиНДС / 100
	|				КОНЕЦ
	|		ИНАЧЕ ТаблицаДокумента.ВсегоРуб
	|	КОНЕЦ КАК ВсегоРуб,
	|	ВЫБОР
	|		КОГДА &НеподтверждениеНулевойСтавки
	|			ТОГДА ТаблицаДокумента.СуммаБезНДСРуб * ВЫБОР
	|					КОГДА СтавкиНДСНоменклатура.ВидСтавкиНДС В (&ПониженныеВидыСтавок)
	|						ТОГДА &ЗначениеПониженнойСтавкиНДС / 100
	|					ИНАЧЕ &ЗначениеОбщейСтавкиНДС / 100
	|				КОНЕЦ
	|		ИНАЧЕ ТаблицаДокумента.НДСРуб
	|	КОНЕЦ КАК НДСРуб,
	|	ТаблицаДокумента.СуммаБезНДСРуб КАК СуммаБезНДСРуб,
	|	ТаблицаДокумента.КонтрагентСводныйСФ КАК КонтрагентСводныйСФ,
	|	ТаблицаДокумента.ПериодичностьУслуги КАК ПериодичностьУслуги
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтраныМира КАК СтраныМира
	|		ПО (СтраныМира.Ссылка = ТаблицаДокумента.СтранаПроисхождения)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторЕдиницИзмерения КАК КлассификаторЕдиницИзмерения
	|		ПО (КлассификаторЕдиницИзмерения.Ссылка = ТаблицаДокумента.ЕдиницаИзмерения)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СтавкиНДСНоменклатура
	|		ПО (СтавкиНДСНоменклатура.Ссылка = ТаблицаДокумента.Товар)
	|ГДЕ
	|	ВЫБОР
	|			КОГДА &НеподтверждениеНулевойСтавки
	|				ТОГДА НЕ ТаблицаДокумента.ЭтоКомиссия
	|						И ТаблицаДокумента.СтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС0)
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерТабЧасти,
	|	НомерСтроки";

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

&Вместо("ФорматныйКонтрольИННиКПППоСчетуФактуреПройден")
Функция Базар_ФорматныйКонтрольИННиКПППоСчетуФактуреПройден(Объект) Экспорт

	Возврат Истина;
	
	ФорматныйКонтрольПройден = ПродолжитьВызов(Объект);
	
	Возврат ФорматныйКонтрольПройден;
	
КонецФункции

&Вместо("ФорматныйКонтрольИННиКППКонтрагентаПройден")
Функция Базар_ФорматныйКонтрольИННиКППКонтрагентаПройден(Контрагент, ТипСчетФактуры, ВыводитьСообщенияАдресно = Истина) Экспорт
	
	Возврат Истина;
	
	ФорматныйКонтрольПройден = ПродолжитьВызов(Контрагент, ТипСчетФактуры, ВыводитьСообщенияАдресно);
	
	Возврат ФорматныйКонтрольПройден;
	
КонецФункции