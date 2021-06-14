#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьВнешниеНаборыДанных",    Истина);
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета", Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",  Ложь);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",  Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",      Истина);

	Возврат Результат;

КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 
	
	Возврат "Анализ продаж" + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
КонецФункции

Функция ПолучитьВнешниеНаборыДанных(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	СистемныеНастройкиБазар = ОбщегоНазначенияБазарСервер.СистемныеНастройкиБазар(КонецДня(ПараметрыОтчета.КонецПериода));
	
	СчетаПродаж = Новый Массив;
	СчетаПродаж.Добавить(ПланыСчетов.Хозрасчетный.ВыручкаНеЕНВД);
	
	СубконтоПродаж = Новый Массив;
	СубконтоПродаж.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НоменклатурныеГруппы);
	СубконтоПродаж.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
	СубконтоПродаж.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СтавкиНДС);
	
	СчетаСебестоимости = Новый Массив;
	СчетаСебестоимости.Добавить(ПланыСчетов.Хозрасчетный.СебестоимостьПродажНеЕНВД);
	
	СчетаСПартионнымУчетом = Новый Массив;
	СчетаСПартионнымУчетом.Добавить(ПланыСчетов.Хозрасчетный.ТоварыНаСкладах);
	СчетаСПартионнымУчетом.Добавить(ПланыСчетов.Хозрасчетный.ТоварыВРозничнойТорговле);
	
	СубконтоНоменклатураПартии = Новый Массив;
	СубконтоНоменклатураПартии.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
	СубконтоНоменклатураПартии.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Партии);
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("НачалоПериода", КонецДня(ПараметрыОтчета.НачалоПериода));
	Запрос.УстановитьПараметр("КонецПериода" , КонецДня(ПараметрыОтчета.КонецПериода));
	Запрос.УстановитьПараметр("Организация"  , ПараметрыОтчета.Организация);
	
	Запрос.УстановитьПараметр("СчетаПродаж"                 , СчетаПродаж);
	Запрос.УстановитьПараметр("СубконтоПродаж"              , СубконтоПродаж);
	Запрос.УстановитьПараметр("СчетаСебестоимости"          , СчетаСебестоимости);
	Запрос.УстановитьПараметр("СчетаУчетаСебестоимости"     , Отчеты.АнализПродаж.СчетаУчетаСебестоимости());
	Запрос.УстановитьПараметр("СубконтоНоменклатураПартии"  , СубконтоНоменклатураПартии);
	Запрос.УстановитьПараметр("ТипЦеныСебестоимость"        , СистемныеНастройкиБазар.ТипЦенСебестоимость);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЦеныНоменклатуры.Период КАК Период,
	|	ЦеныНоменклатуры.Номенклатура КАК Номенклатура,
	|	ЦеныНоменклатуры.Цена КАК Цена
	|ПОМЕСТИТЬ ВТ_ЦеныНоменклатуры
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры КАК ЦеныНоменклатуры
	|ГДЕ
	|	ЦеныНоменклатуры.ТипЦен = &ТипЦеныСебестоимость
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ХозрасчетныйОбороты.Организация КАК Организация,
	|	ХозрасчетныйОбороты.Подразделение КАК Подразделение,
	|	ХозрасчетныйОбороты.Регистратор КАК Документ,
	|	ХозрасчетныйОбороты.Субконто2 КАК Номенклатура,
	|	ВЫРАЗИТЬ(ВЫБОР
	|			КОГДА ХозрасчетныйОбороты.Субконто3 = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.БезНДС)
	|					ИЛИ ХозрасчетныйОбороты.Субконто3 = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС0)
	|				ТОГДА 0
	|			ИНАЧЕ ВЫБОР
	|					КОГДА ХозрасчетныйОбороты.Субконто3 = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС10)
	|							ИЛИ ХозрасчетныйОбороты.Субконто3 = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС10_110)
	|						ТОГДА 10
	|					ИНАЧЕ ВЫБОР
	|							КОГДА ХозрасчетныйОбороты.Субконто3 = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС20)
	|									ИЛИ ХозрасчетныйОбороты.Субконто3 = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС20_120)
	|								ТОГДА 20
	|							ИНАЧЕ ВЫБОР
	|									КОГДА ХозрасчетныйОбороты.Субконто3 = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС18)
	|											ИЛИ ХозрасчетныйОбороты.Субконто3 = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС18_118)
	|										ТОГДА 18
	|									ИНАЧЕ 0
	|								КОНЕЦ
	|						КОНЕЦ
	|				КОНЕЦ
	|		КОНЕЦ КАК ЧИСЛО(10, 0)) КАК СтавкаНДС,
	|	СУММА(ХозрасчетныйОбороты.СуммаОборотКт) КАК Сумма,
	|	СУММА(ХозрасчетныйОбороты.КоличествоОборотКт) КАК Количество
	|ПОМЕСТИТЬ ВТ_Продажи
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Обороты(&НачалоПериода, &КонецПериода, Регистратор, Счет В (&СчетаПродаж), &СубконтоПродаж, Организация = &Организация, , ) КАК ХозрасчетныйОбороты
	|
	|СГРУППИРОВАТЬ ПО
	|	ХозрасчетныйОбороты.Подразделение,
	|	ХозрасчетныйОбороты.Субконто2,
	|	ХозрасчетныйОбороты.Организация,
	|	ВЫРАЗИТЬ(ВЫБОР
	|			КОГДА ХозрасчетныйОбороты.Субконто3 = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.БезНДС)
	|					ИЛИ ХозрасчетныйОбороты.Субконто3 = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС0)
	|				ТОГДА 0
	|			ИНАЧЕ ВЫБОР
	|					КОГДА ХозрасчетныйОбороты.Субконто3 = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС10)
	|							ИЛИ ХозрасчетныйОбороты.Субконто3 = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС10_110)
	|						ТОГДА 10
	|					ИНАЧЕ ВЫБОР
	|							КОГДА ХозрасчетныйОбороты.Субконто3 = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС20)
	|									ИЛИ ХозрасчетныйОбороты.Субконто3 = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС20_120)
	|								ТОГДА 20
	|							ИНАЧЕ ВЫБОР
	|									КОГДА ХозрасчетныйОбороты.Субконто3 = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС18)
	|											ИЛИ ХозрасчетныйОбороты.Субконто3 = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.НДС18_118)
	|										ТОГДА 18
	|									ИНАЧЕ 0
	|								КОНЕЦ
	|						КОНЕЦ
	|				КОНЕЦ
	|		КОНЕЦ КАК ЧИСЛО(10, 0)),
	|	ХозрасчетныйОбороты.Регистратор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ХозрасчетныйОбороты.Организация КАК Организация,
	|	ХозрасчетныйОбороты.Подразделение КАК Подразделение,
	|	ХозрасчетныйОбороты.Регистратор КАК Документ,
	|	ХозрасчетныйОбороты.Субконто1 КАК Номенклатура,
	|	СУММА(ХозрасчетныйОбороты.СуммаОборотКт) КАК Стоимость,
	|	СУММА(ХозрасчетныйОбороты.КоличествоОборотКт) КАК Количество
	|ПОМЕСТИТЬ ВТ_Себестоимость
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Обороты(&НачалоПериода, &КонецПериода, Регистратор, Счет В (&СчетаУчетаСебестоимости), &СубконтоНоменклатураПартии, Организация = &Организация, КорСчет В (&СчетаСебестоимости), ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.НоменклатурныеГруппы)) КАК ХозрасчетныйОбороты
	|
	|СГРУППИРОВАТЬ ПО
	|	ХозрасчетныйОбороты.Организация,
	|	ХозрасчетныйОбороты.Подразделение,
	|	ХозрасчетныйОбороты.Субконто1,
	|	ХозрасчетныйОбороты.Регистратор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ВТ_Продажи.Организация, ВТ_Себестоимость.Организация) КАК Организация,
	|	ЕСТЬNULL(ВТ_Продажи.Подразделение, ВТ_Себестоимость.Подразделение) КАК Подразделение,
	|	ЕСТЬNULL(ВТ_Продажи.Документ, ВТ_Себестоимость.Документ) КАК Документ,
	|	ЕСТЬNULL(ВТ_Продажи.Номенклатура, ВТ_Себестоимость.Номенклатура) КАК Номенклатура,
	|	МАКСИМУМ(ЕСТЬNULL(ВТ_Продажи.СтавкаНДС, 0)) КАК СтавкаНДС,
	|	СУММА(ЕСТЬNULL(ВТ_Продажи.Количество, 0)) КАК Количество,
	|	СУММА(ЕСТЬNULL(ВТ_Продажи.Сумма, 0)) КАК СуммаПродаж,
	|	СУММА(ЕСТЬNULL(ВТ_Себестоимость.Стоимость, 0)) КАК СуммаСебестоимость
	|ПОМЕСТИТЬ ВТ_Итоговая
	|ИЗ
	|	ВТ_Продажи КАК ВТ_Продажи
	|		ПОЛНОЕ СОЕДИНЕНИЕ ВТ_Себестоимость КАК ВТ_Себестоимость
	|		ПО ВТ_Продажи.Организация = ВТ_Себестоимость.Организация
	|			И ВТ_Продажи.Подразделение = ВТ_Себестоимость.Подразделение
	|			И ВТ_Продажи.Документ = ВТ_Себестоимость.Документ
	|			И ВТ_Продажи.Номенклатура = ВТ_Себестоимость.Номенклатура
	|
	|СГРУППИРОВАТЬ ПО
	|	ЕСТЬNULL(ВТ_Продажи.Организация, ВТ_Себестоимость.Организация),
	|	ЕСТЬNULL(ВТ_Продажи.Подразделение, ВТ_Себестоимость.Подразделение),
	|	ЕСТЬNULL(ВТ_Продажи.Номенклатура, ВТ_Себестоимость.Номенклатура),
	|	ЕСТЬNULL(ВТ_Продажи.Документ, ВТ_Себестоимость.Документ)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Итоговая.Документ КАК Документ,
	|	ВТ_Итоговая.Номенклатура КАК Номенклатура,
	|	МАКСИМУМ(ВТ_ЦеныНоменклатуры.Период) КАК Период
	|ПОМЕСТИТЬ ВТ_ПериодыЦенРегистраторов
	|ИЗ
	|	ВТ_Итоговая КАК ВТ_Итоговая
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ЦеныНоменклатуры КАК ВТ_ЦеныНоменклатуры
	|		ПО ВТ_Итоговая.Номенклатура = ВТ_ЦеныНоменклатуры.Номенклатура
	|			И ВТ_Итоговая.Документ.Дата <= ВТ_ЦеныНоменклатуры.Период
	|			И (ВТ_Итоговая.СуммаСебестоимость = 0)
	|{ГДЕ
	|	ВТ_Итоговая.Организация.*,
	|	ВТ_Итоговая.Подразделение.*,
	|	ВТ_Итоговая.Номенклатура.*,
	|	ВТ_Итоговая.Количество,
	|	ВТ_Итоговая.СуммаПродаж,
	|	ВТ_Итоговая.СуммаСебестоимость}
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_Итоговая.Номенклатура,
	|	ВТ_Итоговая.Документ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Итоговая.Организация КАК Организация,
	|	ВТ_Итоговая.Подразделение КАК Подразделение,
	|	ВТ_Итоговая.Документ КАК Документ,
	|	ВТ_Итоговая.Номенклатура КАК Номенклатура,
	|	МАКСИМУМ(ВТ_Итоговая.СтавкаНДС) КАК СтавкаНДС,
	|	СУММА(ВТ_Итоговая.Количество) КАК Количество,
	|	СУММА(ВТ_Итоговая.СуммаПродаж) КАК СуммаПродаж,
	|	СУММА(ВЫБОР
	|			КОГДА ЗакупочныеЦеныРегистраторов.Цена ЕСТЬ NULL
	|				ТОГДА ВТ_Итоговая.СуммаСебестоимость * 100 / (100 - ЕСТЬNULL(ВТ_Итоговая.СтавкаНДС, 0))
	|			ИНАЧЕ ЗакупочныеЦеныРегистраторов.Цена * ВТ_Итоговая.Количество
	|		КОНЕЦ) КАК СуммаСебестоимость
	|ПОМЕСТИТЬ ВТ_ИтоговаяСЦенамиНоменклатуры
	|ИЗ
	|	ВТ_Итоговая КАК ВТ_Итоговая
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ВТ_ПериодыЦенРегистраторов.Документ КАК Документ,
	|			ВТ_ПериодыЦенРегистраторов.Номенклатура КАК Номенклатура,
	|			ВТ_ЦеныНоменклатуры.Цена КАК Цена
	|		ИЗ
	|			ВТ_ЦеныНоменклатуры КАК ВТ_ЦеныНоменклатуры
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ПериодыЦенРегистраторов КАК ВТ_ПериодыЦенРегистраторов
	|				ПО ВТ_ЦеныНоменклатуры.Номенклатура = ВТ_ПериодыЦенРегистраторов.Номенклатура
	|					И ВТ_ЦеныНоменклатуры.Период = ВТ_ПериодыЦенРегистраторов.Период) КАК ЗакупочныеЦеныРегистраторов
	|		ПО ВТ_Итоговая.Документ = ЗакупочныеЦеныРегистраторов.Документ
	|			И ВТ_Итоговая.Номенклатура = ЗакупочныеЦеныРегистраторов.Номенклатура
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_Итоговая.Организация,
	|	ВТ_Итоговая.Подразделение,
	|	ВТ_Итоговая.Номенклатура,
	|	ВТ_Итоговая.Документ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ИтоговаяСЦенамиНоменклатуры.Организация КАК Организация,
	|	ВТ_ИтоговаяСЦенамиНоменклатуры.Подразделение КАК Подразделение,
	|	ВТ_ИтоговаяСЦенамиНоменклатуры.Документ.Контрагент КАК Контрагент,
	|	ВТ_ИтоговаяСЦенамиНоменклатуры.Документ.Грузополучатель КАК Грузополучатель,
	|	ВТ_ИтоговаяСЦенамиНоменклатуры.Документ.ВодительСсылка КАК Водитель,
	|	ВТ_ИтоговаяСЦенамиНоменклатуры.Документ.АвтомобильСсылка КАК Автомобиль,
	|	ВТ_ИтоговаяСЦенамиНоменклатуры.Документ КАК Документ,
	|	ВТ_ИтоговаяСЦенамиНоменклатуры.Номенклатура КАК Номенклатура,
	|	МАКСИМУМ(ВЫРАЗИТЬ(ВТ_ИтоговаяСЦенамиНоменклатуры.СтавкаНДС КАК ЧИСЛО(10, 0))) КАК СтавкаНДС,
	|	СУММА(ВТ_ИтоговаяСЦенамиНоменклатуры.Количество) КАК Количество,
	|	СУММА(ВТ_ИтоговаяСЦенамиНоменклатуры.СуммаПродаж) КАК СуммаПродаж,
	|	СУММА(ВТ_ИтоговаяСЦенамиНоменклатуры.СуммаСебестоимость) КАК СуммаСебестоимость
	|{ВЫБРАТЬ
	|	Организация.* КАК Организация,
	|	Подразделение.* КАК Подразделение,
	|	Документ.Контрагент.* КАК Контрагент,
	|	Документ.Грузополучатель.* КАК Грузополучатель,
	|	Документ.ВодительСсылка.* КАК Водитель,
	|	Документ.АвтомобильСсылка.* КАК Автомобиль,
	|	Документ.* КАК Документ,
	|	Номенклатура.* КАК Номенклатура,
	|	СтавкаНДС КАК СтавкаНДС,
	|	Количество КАК Количество,
	|	СуммаПродаж КАК СуммаПродаж,
	|	СуммаСебестоимость КАК СуммаСебестоимость}
	|ИЗ
	|	ВТ_ИтоговаяСЦенамиНоменклатуры КАК ВТ_ИтоговаяСЦенамиНоменклатуры
	|{ГДЕ
	|	ВТ_ИтоговаяСЦенамиНоменклатуры.Организация.* КАК Организация,
	|	ВТ_ИтоговаяСЦенамиНоменклатуры.Подразделение.* КАК Подразделение,
	|	ВТ_ИтоговаяСЦенамиНоменклатуры.Документ.Контрагент.* КАК Контрагент,
	|	ВТ_ИтоговаяСЦенамиНоменклатуры.Документ.Грузополучатель.* КАК Грузополучатель,
	|	ВТ_ИтоговаяСЦенамиНоменклатуры.Документ.ВодительСсылка.* КАК Водитель,
	|	ВТ_ИтоговаяСЦенамиНоменклатуры.Документ.АвтомобильСсылка.* КАК Автомобиль,
	|	ВТ_ИтоговаяСЦенамиНоменклатуры.Документ.* КАК Документ,
	|	ВТ_ИтоговаяСЦенамиНоменклатуры.Номенклатура.* КАК Номенклатура,
	|	(ВЫРАЗИТЬ(ВТ_ИтоговаяСЦенамиНоменклатуры.СтавкаНДС КАК ЧИСЛО(10, 0))) КАК СтавкаНДС,
	|	ВТ_ИтоговаяСЦенамиНоменклатуры.Количество КАК Количество,
	|	ВТ_ИтоговаяСЦенамиНоменклатуры.СуммаПродаж КАК СуммаПродаж,
	|	ВТ_ИтоговаяСЦенамиНоменклатуры.СуммаСебестоимость КАК СуммаСебестоимость}
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_ИтоговаяСЦенамиНоменклатуры.Организация,
	|	ВТ_ИтоговаяСЦенамиНоменклатуры.Подразделение,
	|	ВТ_ИтоговаяСЦенамиНоменклатуры.Документ.Контрагент,
	|	ВТ_ИтоговаяСЦенамиНоменклатуры.Документ.Грузополучатель,
	|	ВТ_ИтоговаяСЦенамиНоменклатуры.Документ.ВодительСсылка,
	|	ВТ_ИтоговаяСЦенамиНоменклатуры.Документ.АвтомобильСсылка,
	|	ВТ_ИтоговаяСЦенамиНоменклатуры.Документ,
	|	ВТ_ИтоговаяСЦенамиНоменклатуры.Номенклатура";
	
	РезультатыРасчета = Запрос.Выполнить().Выгрузить();
	
	Возврат Новый Структура("РезультатыРасчета", РезультатыРасчета);
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	//КомпоновщикНастроек.Настройки.Структура.Очистить();
	//КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Организация", ПараметрыОтчета.Организация);
	
	//СубконтоПродаж = Новый Массив;
	//СубконтоПродаж.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НоменклатурныеГруппы);
	//СубконтоПродаж.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
	//СубконтоПродаж.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СтавкиНДС);
	//
	//СчетаПродаж = Новый Массив;
	//СчетаПродаж.Добавить(ПланыСчетов.Хозрасчетный.ВыручкаНеЕНВД);
	//
	//СчетаСебестоимости = Новый Массив;
	//СчетаСебестоимости.Добавить(ПланыСчетов.Хозрасчетный.СебестоимостьПродажНеЕНВД);
	//
	//СчетаСПартионнымУчетом = Новый Массив;
	//СчетаСПартионнымУчетом.Добавить(ПланыСчетов.Хозрасчетный.ТоварыНаСкладах);
	//СчетаСПартионнымУчетом.Добавить(ПланыСчетов.Хозрасчетный.ТоварыВРозничнойТорговле);
	//
	//СубконтоНоменклатураПартии = Новый Массив;
	//СубконтоНоменклатураПартии.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
	//СубконтоНоменклатураПартии.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Партии);
	//
	//БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СчетаПродаж"                 , СчетаПродаж);
	//БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СубконтоПродаж"              , СубконтоПродаж);
	//БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СчетаСебестоимости"          , СчетаСебестоимости);
	//БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СчетаУчетаСебестоимости"     , СчетаУчетаСебестоимости());
	//БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СубконтоНоменклатураПартии"  , СубконтоНоменклатураПартии);
	
	УсловноеОформлениеАвтоотступа = Неопределено;
	Для каждого ЭлементОформления Из КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы Цикл
		Если ЭлементОформления.Представление = "Уменьшенный автоотступ" Тогда
			УсловноеОформлениеАвтоотступа = ЭлементОформления;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если УсловноеОформлениеАвтоотступа = Неопределено Тогда
		УсловноеОформлениеАвтоотступа = КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();
		УсловноеОформлениеАвтоотступа.Представление = "Уменьшенный автоотступ";
		УсловноеОформлениеАвтоотступа.Оформление.УстановитьЗначениеПараметра("Автоотступ", 1);
		УсловноеОформлениеАвтоотступа.Использование = Ложь;
		УсловноеОформлениеАвтоотступа.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
	Иначе
		УсловноеОформлениеАвтоотступа.Поля.Элементы.Очистить();
	КонецЕсли;
		
	// Дополнительные данные
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
	// Создаем таблицу в СКД
	ТаблицаАнализПродаж = Неопределено;
	Для Каждого ЭлементСтруктуры Из КомпоновщикНастроек.Настройки.Структура Цикл
		Если ЭлементСтруктуры.Имя = "ТаблицаАнализПродаж" Тогда
			ТаблицаАнализПродаж = ЭлементСтруктуры;
		КонецЕсли;
	КонецЦикла;
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(
		ТаблицаАнализПродаж,
		"ГоризонтальноеРасположениеОбщихИтогов",
		РасположениеИтоговКомпоновкиДанных.Конец
	);
	
	// Группировки
	ТаблицаАнализПродаж.Строки.Очистить();
	Группировка = ТаблицаАнализПродаж.Строки;
	Для Каждого ПолеВыбраннойГруппировки Из ПараметрыОтчета.Группировка Цикл 
		Если ПолеВыбраннойГруппировки.Использование Тогда
			Если ТипЗнч(Группировка) = Тип("КоллекцияЭлементовСтруктурыТаблицыКомпоновкиДанных") Тогда
				Группировка = Группировка.Добавить();
			Иначе
				Группировка = Группировка.Структура.Добавить();
			КонецЕсли;
			БухгалтерскиеОтчетыВызовСервера.ЗаполнитьГруппировку(ПолеВыбраннойГруппировки, Группировка);
		КонецЕсли;
	КонецЦикла;
	
	Если УсловноеОформлениеАвтоотступа.Поля.Элементы.Количество() = 0 Тогда
		УсловноеОформлениеАвтоотступа.Использование = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);

КонецПроцедуры

&НаСервере
Функция СчетаУчетаСебестоимости() Экспорт
	
	Счета_1011 = БухгалтерскийУчетПовтИсп.СчетаВИерархии(ПланыСчетов.Хозрасчетный.СпецоснасткаИСпецодеждаВЭксплуатации);
	СчетаИсключаемые = ОбщегоНазначенияКлиентСервер.СкопироватьМассив(Счета_1011);
	СчетаИсключаемые.Добавить(ПланыСчетов.Хозрасчетный.МатериалыПереданныеВПереработку);            // 10.07
	СчетаИсключаемые.Добавить(ПланыСчетов.Хозрасчетный.ТоварыВРозничнойТорговлеВПродажныхЦенахНТТ); // 41.12
	СчетаИсключаемые.Добавить(ПланыСчетов.Хозрасчетный.КорректировкаТоваровПрошлогоПериода);        // 41.К
	
	СчетаУчетаТоваров = БухгалтерскиеОтчеты.СчетаУчетаТоваров(СчетаИсключаемые);
	
	СчетаСПартионнымУчетом = Новый Массив;
	Для Каждого Счет Из СчетаУчетаТоваров Цикл
		Если БухгалтерскийУчет.НаСчетеВедетсяПартионныйУчет(Счет) Тогда
			Если БухгалтерскийУчет.ВедетсяУчетПоСкладам(Счет) Тогда
				СчетаСПартионнымУчетом.Добавить(Счет);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат СчетаСПартионнымУчетом;
	
КонецФункции

#КонецЕсли