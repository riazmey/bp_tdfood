&Вместо("ПолучитьТаблицыСписанияМПЗ")
Функция Базар_ПолучитьТаблицыСписанияМПЗ(Параметры, Отказ)

	ТаблицыСписанияМПЗ = Новый Структура("СписанныеМПЗ, ИзмененияВидаДеятельности, СтоимостьПродукции, Материалы");
	Реквизиты = Параметры.Реквизиты[0];
	
	СписокМПЗ = Параметры.СписокМПЗ; // Таблица cписанных партий по данным БУ
	СписокМПЗ.Колонки.Добавить("ВидМПЗ",               Новый ОписаниеТипов("ПеречислениеСсылка.ВидыМПЗ"));
	СписокМПЗ.Колонки.Добавить("ВидПоступившегоМПЗ",   Новый ОписаниеТипов("ПеречислениеСсылка.ВидыМПЗ"));
	СписокМПЗ.Колонки.Добавить("ХарактерДеятельности", Новый ОписаниеТипов("ПеречислениеСсылка.ХарактерДеятельности"));
	
	// Заполняем виды МПЗ, номенклатурные группы и характеры деятельности
	УчетнаяПолитикаНУ = УчетнаяПолитикаНалоговогоУчета(Реквизиты.Организация, Реквизиты.Период);
		
	СтруктураПараметров = Новый Структура("ВидОперации, ТипСклада, ДеятельностьНаПатенте, НоменклатурнаяГруппа, ВидМПЗ,
		|СчетУчета, СтатьяЗатрат, ВидДеятельностиДляНалоговогоУчетаЗатрат, СчетДоходов");
	ЗаполнитьЗначенияСвойств(СтруктураПараметров, Реквизиты);
	
	Для каждого МПЗ из СписокМПЗ Цикл
		
		МПЗ.ВидМПЗ = ВидМПЗПоСчетуУчета(МПЗ.СчетУчета);
		
		Если НЕ ЗначениеЗаполнено(МПЗ.ВидМПЗ) Тогда
			Продолжить;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(СтруктураПараметров, МПЗ);
		
		Если Реквизиты.ТипСписания = "Списание" Тогда 
			
			// Вид полученного МПЗ при выпуске продукции
			МПЗ.ВидПоступившегоМПЗ = ВидМПЗПоСчетуУчета(МПЗ.СчетЗатрат, МПЗ.Продукция, МПЗ.ВидРасходовНУ, МПЗ.ПринятиеКналоговомуУчету);
			Если МПЗ.ВидПоступившегоМПЗ = Перечисления.ВидыМПЗ.ПрочиеРасходы Тогда
				// Списание МПЗ не может формировать прочих расходов
				МПЗ.ВидПоступившегоМПЗ = Перечисления.ВидыМПЗ.ИныеМатериальныеРасходы;
			КонецЕсли;
			
			СтруктураПараметров.СчетУчета = МПЗ.СчетЗатрат;
			СтруктураПараметров.ВидМПЗ    = МПЗ.ВидПоступившегоМПЗ;
			
		КонецЕсли;
		
		МПЗ.НоменклатурнаяГруппа = ПолучитьНоменклатурнуюГруппу(УчетнаяПолитикаНУ, СтруктураПараметров);
		МПЗ.ХарактерДеятельности = ПолучитьХарактерДеятельности(УчетнаяПолитикаНУ, СтруктураПараметров);
		
	КонецЦикла;
	
	//Установка управляемой блокировки
	СтруктураПараметров = Новый Структура("ТипТаблицы, ИмяТаблицы", "РегистрНакопления", "ИПМПЗ");
	ОписаниеИсточника = Новый Структура;
	ОписаниеИсточника.Вставить("Номенклатура", "Номенклатура");
	ОписаниеИсточника.Вставить("ВидМПЗ",       "ВидМПЗ");
	ОписаниеИсточника.Вставить("Партия",       "Партия");
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ИПМПЗ");
	ЭлементБлокировки.УстановитьЗначение("Организация", Реквизиты.Организация);
	ЭлементБлокировки.УстановитьЗначение("Период", Новый Диапазон(, Реквизиты.Период));
	ЭлементБлокировки.ИсточникДанных =
		ПодготовитьИсточникДанныхБлокировки(СтруктураПараметров, СписокМПЗ, ОписаниеИсточника);
	Для каждого КолонкаИсточника Из ОписаниеИсточника Цикл
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных(КолонкаИсточника.Ключ, КолонкаИсточника.Значение);
	КонецЦикла;
	Блокировка.Заблокировать();
	
	// Формирование запроса по остаткам МПЗ в НУ
	// При помощи данного запроса мы получим распределение списанных партий
	// по видам деятельности и документам оплаты
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаКон",
		Новый Граница(Новый МоментВремени(Реквизиты.Период, Реквизиты.Регистратор), ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("Организация",        Реквизиты.Организация);
	Запрос.УстановитьПараметр("СписокНоменклатуры", ОбщегоНазначения.ВыгрузитьКолонку(СписокМПЗ, "Номенклатура", Истина));
	Запрос.УстановитьПараметр("СписокВидовМПЗ",     ОбщегоНазначения.ВыгрузитьКолонку(СписокМПЗ, "ВидМПЗ", Истина));
	Запрос.УстановитьПараметр("СписокПартий",       ОбщегоНазначения.ВыгрузитьКолонку(СписокМПЗ, "Партия", Истина));
	Запрос.УстановитьПараметр("СписокВозвраты",     Параметры.СписокВозвраты);
	
	ЕстьВозвраты = (Параметры.СписокВозвраты.Количество() > 0);
	
	ТекстЗапроса = "";
	
	Если ЕстьВозвраты Тогда
		// Возвращаемые тем же документом МПЗ
		ТекстЗапроса = ТекстЗапроса +
		"ВЫБРАТЬ
		|	СписокВозвраты.НоменклатурнаяГруппа,
		|	СписокВозвраты.ХарактерДеятельности,
		|	СписокВозвраты.ВидМПЗ,
		|	СписокВозвраты.Номенклатура,
		|	СписокВозвраты.Партия,
		|	СписокВозвраты.ДокументОплаты,
		|	СписокВозвраты.Количество,
		|	СписокВозвраты.Сумма,
		|	СписокВозвраты.НДС
		|ПОМЕСТИТЬ ИПМПЗВозвраты
		|ИЗ
		|	&СписокВозвраты КАК СписокВозвраты" + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	КонецЕсли; 
	
	ТекстЗапроса = ТекстЗапроса + 
		"ВЫБРАТЬ
		|	ИПМПЗОстатки.НоменклатурнаяГруппа,
		|	ИПМПЗОстатки.ХарактерДеятельности,
		|	ИПМПЗОстатки.ВидМПЗ,
		|	ИПМПЗОстатки.Номенклатура,
		|	ИПМПЗОстатки.Партия,
		|	ИПМПЗОстатки.ДокументОплаты КАК ДокументОплаты,
		|	ИПМПЗОстатки.КоличествоОстаток,
		|	ИПМПЗОстатки.СуммаОстаток,
		|	ИПМПЗОстатки.НДСОстаток
		|ПОМЕСТИТЬ ВТИПМПЗОстатки
		|ИЗ
		|	РегистрНакопления.ИПМПЗ.Остатки(
		|			&ДатаКон,
		|			Организация = &Организация
		|				И ВидМПЗ В (&СписокВидовМПЗ)
		|				И Номенклатура В (&СписокНоменклатуры)
		|				И Партия В (&СписокПартий)) КАК ИПМПЗОстатки";
	
	Если ЕстьВозвраты Тогда
		
		// Добавляем МПЗ возвращаемые тем же документом
		ТекстЗапроса = ТекстЗапроса + "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|";
		
		ТекстЗапроса = ТекстЗапроса +
		"ВЫБРАТЬ
		|	ИПМПЗВозвраты.НоменклатурнаяГруппа,
		|	ИПМПЗВозвраты.ХарактерДеятельности,
		|	ИПМПЗВозвраты.ВидМПЗ,
		|	ИПМПЗВозвраты.Номенклатура,
		|	ИПМПЗВозвраты.Партия,
		|	ИПМПЗВозвраты.ДокументОплаты,
		|	ИПМПЗВозвраты.Количество,
		|	ИПМПЗВозвраты.Сумма,
		|	ИПМПЗВозвраты.НДС
		|ИЗ
		|	ИПМПЗВозвраты КАК ИПМПЗВозвраты";
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапроса + "
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ДокументОплаты" + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
	ТекстЗапроса = ТекстЗапроса +
		"ВЫБРАТЬ
		|	ИПМПЗОстатки.НоменклатурнаяГруппа,
		|	ИПМПЗОстатки.ХарактерДеятельности,
		|	ИПМПЗОстатки.ВидМПЗ,
		|	ИПМПЗОстатки.Номенклатура,
		|	ИПМПЗОстатки.Партия,
		|	ИПМПЗОстатки.ДокументОплаты,
		|	ЕСТЬNULL(РеквизитыДокументовОплаты.ДатаРегистратора, ДАТАВРЕМЯ(3999, 12, 31)) КАК ДатаДокументаОплаты,
		|	СУММА(ИПМПЗОстатки.КоличествоОстаток) КАК Количество,
		|	СУММА(ИПМПЗОстатки.СуммаОстаток) КАК Сумма,
		|	СУММА(ИПМПЗОстатки.НДСОстаток) КАК НДС
		|ИЗ
		|	ВТИПМПЗОстатки КАК ИПМПЗОстатки
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеПервичныхДокументов КАК РеквизитыДокументовОплаты
		|		ПО (РеквизитыДокументовОплаты.Организация = &Организация)
		|			И ИПМПЗОстатки.ДокументОплаты = РеквизитыДокументовОплаты.Документ
		|
		|СГРУППИРОВАТЬ ПО
		|	ИПМПЗОстатки.ДокументОплаты,
		|	ЕСТЬNULL(РеквизитыДокументовОплаты.ДатаРегистратора, ДАТАВРЕМЯ(3999, 12, 31)),
		|	ИПМПЗОстатки.ВидМПЗ,
		|	ИПМПЗОстатки.Партия,
		|	ИПМПЗОстатки.Номенклатура,
		|	ИПМПЗОстатки.ХарактерДеятельности,
		|	ИПМПЗОстатки.НоменклатурнаяГруппа";
		
	Запрос.Текст  = ТекстЗапроса;
	ТаблицаПартий = Запрос.Выполнить().Выгрузить();
	ОбщегоНазначенияБПВызовСервера.ПронумероватьТаблицу(ТаблицаПартий, "НомерСтроки");
	ТаблицаПартий.Индексы.Добавить("НомерСтроки");
	
	ТаблицаПартий.Индексы.Добавить("ВидМПЗ, Номенклатура, Партия, НоменклатурнаяГруппа, ХарактерДеятельности");
	ТаблицаПартий.Индексы.Добавить("ВидМПЗ, Номенклатура, Партия, ХарактерДеятельности");
	
	ОтборПартийПоВидуДеятельности      = Новый Структура("ВидМПЗ, Номенклатура, Партия, НоменклатурнаяГруппа, ХарактерДеятельности");
	ОтборПартийПоНоменклатурнойГруппе  = Новый Структура("ВидМПЗ, Номенклатура, Партия, НоменклатурнаяГруппа");
	ОтборПартийПоХарактеруДеятельности = Новый Структура("ВидМПЗ, Номенклатура, Партия, ХарактерДеятельности");
	ОтборПартий                        = Новый Структура("ВидМПЗ, Номенклатура, Партия");
	
	СписанныеМПЗ              = ПолучитьПустуюТаблицуСписанныеМПЗ();
	СтоимостьПродукции        = ПолучитьПустуюТаблицуСтоимостьПродукции();
	ИзмененияВидаДеятельности = ПолучитьПустуюТаблицуИзмененияВидаДеятельности();
	
	КонтролироватьОстаток = НЕ БухгалтерскийУчетПереопределяемый.ОтключитьКонтрольОтрицательныхОстатков();
	
	// Подбор партий из запроса
	Для каждого МПЗ из СписокМПЗ Цикл
		
		Если НЕ ЗначениеЗаполнено(МПЗ.ВидМПЗ) Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(МПЗ.Партия) Тогда
			
			// Партия по данным бухгалтерского учета не определена
			Если НЕ КонтролироватьОстаток Тогда
				
				НайденныеПартии = ТаблицаПартий.СкопироватьКолонки();
				Партия = НайденныеПартии.Добавить();
				ЗаполнитьЗначенияСвойств(Партия, МПЗ);
				Партия.Количество = МПЗ.Количество;
				Партия.Сумма      = 0;
				Партия.НДС        = 0;
				
				ЗаполнитьСтрокуСписанияМПЗ(МПЗ, Партия, СписанныеМПЗ, ИзмененияВидаДеятельности, СтоимостьПродукции, Реквизиты);
				
			КонецЕсли;
			
			Продолжить;
			
		КонецЕсли;
		
		Если МПЗ.ВидМПЗ = Перечисления.ВидыМПЗ.ОС ИЛИ МПЗ.ВидМПЗ = Перечисления.ВидыМПЗ.НМА Тогда
			
			ЗаполнитьЗначенияСвойств(ОтборПартий, МПЗ);
			
			Если РаспределитьПартииОСилиНМА(ОтборПартий, МПЗ, ТаблицаПартий, СписанныеМПЗ, ИзмененияВидаДеятельности, СтоимостьПродукции, Реквизиты) Тогда
			Иначе
				СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не списана номенклатура ""%1"", так как в учете индивидуального предпринимателя не найдены остатки по партии ""%2""'"), 
					МПЗ.Номенклатура, МПЗ.Партия);
				Поле = МПЗ.ИмяСписка + "[" + Формат(МПЗ.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].Количество";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, Реквизиты.Регистратор, Поле, "Объект", Отказ);
				
			КонецЕсли;
			
		ИначеЕсли МПЗ.Количество > 0 Тогда
			
			ЗаполнитьЗначенияСвойств(ОтборПартийПоВидуДеятельности, МПЗ);
			ЗаполнитьЗначенияСвойств(ОтборПартийПоНоменклатурнойГруппе, МПЗ);
			ЗаполнитьЗначенияСвойств(ОтборПартийПоХарактеруДеятельности, МПЗ);
			ЗаполнитьЗначенияСвойств(ОтборПартий, МПЗ);
			
			// Распределение партий с отбором от частного к общему
			Если      РаспределитьПартииМПЗ(ОтборПартийПоВидуДеятельности,      МПЗ, ТаблицаПартий, СписанныеМПЗ, ИзмененияВидаДеятельности, СтоимостьПродукции, Реквизиты) Тогда
			ИначеЕсли РаспределитьПартииМПЗ(ОтборПартийПоНоменклатурнойГруппе,  МПЗ, ТаблицаПартий, СписанныеМПЗ, ИзмененияВидаДеятельности, СтоимостьПродукции, Реквизиты) Тогда
			ИначеЕсли РаспределитьПартииМПЗ(ОтборПартийПоХарактеруДеятельности, МПЗ, ТаблицаПартий, СписанныеМПЗ, ИзмененияВидаДеятельности, СтоимостьПродукции, Реквизиты) Тогда
			ИначеЕсли РаспределитьПартииМПЗ(ОтборПартий,                        МПЗ, ТаблицаПартий, СписанныеМПЗ, ИзмененияВидаДеятельности, СтоимостьПродукции, Реквизиты) Тогда
			Иначе
				//СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				//	НСтр("ru = 'Не списано ""%1"" ед. по номенклатуре ""%2"", так как в учете индивидуального предпринимателя не найдены остатки по партии ""%3""'"), 
				//	МПЗ.Количество, МПЗ.Номенклатура, МПЗ.Партия);
				//Поле = МПЗ.ИмяСписка + "[" + Формат(МПЗ.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].Количество";
				//ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, Реквизиты.Регистратор, Поле, "Объект", Отказ);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Материалы = СтоимостьПродукции.Скопировать(, "НоменклатураПоступившая, НоменклатураСписанная, ПартияСписаннойНоменклатуры, Сумма");
	Материалы.Свернуть("НоменклатураПоступившая, НоменклатураСписанная, ПартияСписаннойНоменклатуры", "Сумма");
	
	СтоимостьПродукции.Колонки.ВидПоступившегоМПЗ.Имя      = "ВидМПЗ";
	СтоимостьПродукции.Колонки.НоменклатураПоступившая.Имя = "Номенклатура";
	СтоимостьПродукции.Свернуть("НоменклатурнаяГруппа, ХарактерДеятельности, ВидМПЗ, Номенклатура, ДокументОплаты",
		"КоличествоСписано, Сумма, НДС");
	
	ТаблицыСписанияМПЗ.СписанныеМПЗ              = СписанныеМПЗ;
	ТаблицыСписанияМПЗ.ИзмененияВидаДеятельности = ИзмененияВидаДеятельности;
	ТаблицыСписанияМПЗ.СтоимостьПродукции        = СтоимостьПродукции;
	ТаблицыСписанияМПЗ.Материалы                 = Материалы;
	
	Возврат ТаблицыСписанияМПЗ;
	
КонецФункции

&Вместо("ПодготовитьТаблицыКорректировкиПоступленияМПЗ")
Функция Базар_ПодготовитьТаблицыКорректировкиПоступленияМПЗ(ТаблицаТоваров, ТаблицаУслуг, ТаблицаРеквизитов, Отказ) Экспорт
	
	СтруктураТаблиц = Новый Структура;
	СтруктураТаблиц.Вставить("ТаблицаМПЗ");				// Таблица корректировки регистра ИПМПЗ
	СтруктураТаблиц.Вставить("ТаблицаИМР");				// Таблица корректировки регистра ИПИныеМатериальныеРасходы
	СтруктураТаблиц.Вставить("ТаблицаПрочиеРасходы");	// Таблица корректировки регистра ИППрочиеРасходы
	СтруктураТаблиц.Вставить("ТаблицаРБП");				// Таблица корректировки регистра ИПРБП
	СтруктураТаблиц.Вставить("ТаблицаМПЗОтгруженные");	// Таблица корректировки регистра ИПМПЗОтгруженные
	СтруктураТаблиц.Вставить("ТаблицаДоходы");			// Таблица корректировки регистра ИПДоходы
	
	Если Не ЗначениеЗаполнено(ТаблицаУслуг)
		И Не ЗначениеЗаполнено(ТаблицаТоваров)
	 Или Не ЗначениеЗаполнено(ТаблицаРеквизитов) Тогда
	    Возврат СтруктураТаблиц;
	КонецЕсли;
	
	Реквизиты = ТаблицаРеквизитов[0];
	Если НЕ УчетнаяПолитика.ПлательщикНДФЛ(Реквизиты.Организация, Реквизиты.Период) Тогда
		Возврат СтруктураТаблиц;
	КонецЕсли;
	
	Параметры = ПодготовитьПараметрыТаблицыКорректировкиПоступленияМПЗ(ТаблицаТоваров, ТаблицаУслуг, ТаблицаРеквизитов);
	Реквизиты     = Параметры.Реквизиты[0];
	СписокТоваров = Параметры.СписокТоваров;
	СписокУслуг   = Параметры.СписокУслуг;
	
	Если Реквизиты.ВидОперации = Перечисления.ВидыОперацийИсправленияПоступленияРеализации.ИсправлениеОшибки 
		ИЛИ Реквизиты.ВидОперации = Перечисления.ВидыОперацийИсправленияПоступленияРеализации.ИсправлениеСобственнойОшибки Тогда
		// Все исправления выполняются в одном налоговом периоде
		Реквизиты.Период = Мин(КонецГода(Реквизиты.ПартияДата), Реквизиты.Период);
	КонецЕсли;
	
	СписокТоваров.Колонки.Добавить("ВидМПЗ", Новый ОписаниеТипов("ПеречислениеСсылка.ВидыМПЗ"));
	СписокУслуг.Колонки.Добавить("ВидМПЗ",   Новый ОписаниеТипов("ПеречислениеСсылка.ВидыМПЗ"));
	
	Для каждого МПЗ Из СписокТоваров Цикл
		МПЗ.ВидМПЗ = ВидМПЗПоСчетуУчета(МПЗ.СчетУчета, МПЗ.СтатьяЗатрат, МПЗ.ВидРасходовНУ, МПЗ.ПринятиеКналоговомуУчету);
	КонецЦикла;
	
	Для каждого МПЗ Из СписокУслуг Цикл
		МПЗ.ВидМПЗ = ВидМПЗПоСчетуУчета(МПЗ.СчетУчета, МПЗ.СтатьяЗатрат, МПЗ.ВидРасходовНУ, МПЗ.ПринятиеКналоговомуУчету);
	КонецЦикла;
	
	// Таблица изменений МПЗ отгруженных
	СписокМПЗОтгруженные = Новый ТаблицаЗначений;
	СписокМПЗОтгруженные.Колонки.Добавить("ИмяСписка",            ОбщегоНазначения.ОписаниеТипаСтрока(100));
	СписокМПЗОтгруженные.Колонки.Добавить("НомерСтроки",          ОбщегоНазначения.ОписаниеТипаЧисло(10, 0));
	СписокМПЗОтгруженные.Колонки.Добавить("НоменклатурнаяГруппа", Новый ОписаниеТипов("СправочникСсылка.НоменклатурныеГруппы"));
	СписокМПЗОтгруженные.Колонки.Добавить("ХарактерДеятельности", Новый ОписаниеТипов("ПеречислениеСсылка.ХарактерДеятельности"));
	СписокМПЗОтгруженные.Колонки.Добавить("ВидМПЗ",               Новый ОписаниеТипов("ПеречислениеСсылка.ВидыМПЗ"));
	СписокМПЗОтгруженные.Колонки.Добавить("Номенклатура",         Справочники.ТипВсеСсылки());
	СписокМПЗОтгруженные.Колонки.Добавить("ДокументОплаты",       Документы.ТипВсеСсылки());
	СписокМПЗОтгруженные.Колонки.Добавить("ИзменениеКоличества",  ОбщегоНазначения.ОписаниеТипаЧисло(15, 3));
	СписокМПЗОтгруженные.Колонки.Добавить("ИзменениеСуммы",       ОбщегоНазначения.ОписаниеТипаЧисло(15, 2));
	СписокМПЗОтгруженные.Колонки.Добавить("ИзменениеНДС",         ОбщегоНазначения.ОписаниеТипаЧисло(15, 2));
	
	// Таблица изменений МПЗ отгруженных и оплаченных
	СписокМПЗОплаченные = Новый ТаблицаЗначений;
	СписокМПЗОплаченные.Колонки.Добавить("ИмяСписка",            ОбщегоНазначения.ОписаниеТипаСтрока(100));
	СписокМПЗОплаченные.Колонки.Добавить("НомерСтроки",          ОбщегоНазначения.ОписаниеТипаЧисло(10, 0));
	СписокМПЗОплаченные.Колонки.Добавить("НоменклатурнаяГруппа", Новый ОписаниеТипов("СправочникСсылка.НоменклатурныеГруппы"));
	СписокМПЗОплаченные.Колонки.Добавить("ХарактерДеятельности", Новый ОписаниеТипов("ПеречислениеСсылка.ХарактерДеятельности"));
	СписокМПЗОплаченные.Колонки.Добавить("Номенклатура",         Справочники.ТипВсеСсылки());
	СписокМПЗОплаченные.Колонки.Добавить("ВидМПЗ",               Новый ОписаниеТипов("ПеречислениеСсылка.ВидыМПЗ"));
	СписокМПЗОплаченные.Колонки.Добавить("ДокументОтгрузки",     Документы.ТипВсеСсылки());
	СписокМПЗОплаченные.Колонки.Добавить("ИзменениеКоличества",  ОбщегоНазначения.ОписаниеТипаЧисло(15, 3));
	СписокМПЗОплаченные.Колонки.Добавить("ИзменениеСуммы",       ОбщегоНазначения.ОписаниеТипаЧисло(15, 2));
	СписокМПЗОплаченные.Колонки.Добавить("ИзменениеНДС",         ОбщегоНазначения.ОписаниеТипаЧисло(15, 2));
	
	СписокУслуг.Индексы.Добавить("ВидМПЗ");
	ОтборИМР           = Новый Структура("ВидМПЗ", Перечисления.ВидыМПЗ.ИныеМатериальныеРасходы);
	ОтборПрочиеРасходы = Новый Структура("ВидМПЗ", Перечисления.ВидыМПЗ.ПрочиеРасходы);
	ОтборРБП           = Новый Структура("ВидМПЗ", Перечисления.ВидыМПЗ.РБП);
	
	ТаблицаМПЗ = ПодготовитьТаблицуКорретировкиПоступленияМПЗ(СписокТоваров, СписокМПЗОтгруженные, Реквизиты);
	
	//ТаблицаОбороты = ПодготовитьТаблицуКорретировкиПоступленияОбороты(СписокМПЗОтгруженные.Скопировать(), Реквизиты);
	//Если ТаблицаОбороты <> Неопределено И ТаблицаОбороты.Количество() > 0 Тогда
	//	
	//	Для Каждого ОборотМПЗ Из ТаблицаОбороты Цикл
	//		
	//		СообщениеОбОшибке = 
	//			НСтр("ru = 'Невозможно скорректировать стоимость списанных на расходы материалов'");
	//		Поле = ОборотМПЗ.ИмяСписка + "[" + Формат(ОборотМПЗ.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].Номенклатура";
	//		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, Реквизиты.Регистратор, Поле, "Объект", Отказ);
	//		
	//	КонецЦикла;
	//	
	//	Возврат СтруктураТаблиц;
	//	
	//КонецЕсли;
	
	ТаблицаМПЗОтгруженные = ПодготовитьТаблицуКорретировкиПоступленияМПЗОтгруженные(СписокМПЗОтгруженные, СписокМПЗОплаченные, Реквизиты);
	ТаблицаДоходы         = ПодготовитьТаблицуКорретировкиПоступленияДоходов(СписокМПЗОплаченные, Реквизиты);
	
	ТаблицаИМР           = ПодготовитьТаблицуКорретировкиПоступленияИМР(СписокУслуг.Скопировать(ОтборИМР), Реквизиты);
	ТаблицаПрочиеРасходы = ПодготовитьТаблицуКорретировкиПоступленияПрочихРасходов(СписокУслуг.Скопировать(ОтборПрочиеРасходы), Реквизиты);
	ТаблицаРБП           = ПодготовитьТаблицуКорретировкиПоступленияРБП(СписокУслуг.Скопировать(ОтборРБП), Реквизиты);
	
	СтруктураТаблиц.ТаблицаМПЗ            = ТаблицаМПЗ;
	СтруктураТаблиц.ТаблицаИМР            = ТаблицаИМР;
	СтруктураТаблиц.ТаблицаПрочиеРасходы  = ТаблицаПрочиеРасходы;
	СтруктураТаблиц.ТаблицаРБП            = ТаблицаРБП;
	СтруктураТаблиц.ТаблицаМПЗОтгруженные = ТаблицаМПЗОтгруженные;
	СтруктураТаблиц.ТаблицаДоходы         = ТаблицаДоходы;
	
	Возврат СтруктураТаблиц;

КонецФункции