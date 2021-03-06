
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Заголовок = "Товары точки маршрута: " + Параметры.ТочкаМаршрута;
	Масштаб = ?(Параметры.КомпактноеРазмещениеНаФорме, 85, 100);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивДокументов", Параметры.МассивДокументов);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТранспортнаяЛогистикаЗаказы.Номенклатура.Наименование КАК Наименование,
	|	ТранспортнаяЛогистикаЗаказы.Номенклатура КАК Товар,
	|	СУММА(ТранспортнаяЛогистикаЗаказы.Количество) КАК Количество,
	|	СУММА(ТранспортнаяЛогистикаЗаказы.Тоннаж) КАК Тоннаж,
	|	СУММА(ТранспортнаяЛогистикаЗаказы.Наценка) КАК Наценка
	|ИЗ
	|	РегистрНакопления.ТранспортнаяЛогистикаЗаказы КАК ТранспортнаяЛогистикаЗаказы
	|ГДЕ
	|	ТранспортнаяЛогистикаЗаказы.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|	И ТранспортнаяЛогистикаЗаказы.ДокументДвижения В(&МассивДокументов)
	|
	|СГРУППИРОВАТЬ ПО
	|	ТранспортнаяЛогистикаЗаказы.Номенклатура,
	|	ТранспортнаяЛогистикаЗаказы.Номенклатура.Наименование
	|
	|УПОРЯДОЧИТЬ ПО
	|	Наименование,
	|	Количество УБЫВ";
	
	ТЗИтоги = Запрос.Выполнить().Выгрузить();
	
	Товары.Загрузить(ТЗИтоги);
	
	Если ТЗИтоги.Количество() > 0 тогда
		ТЗИтоги.Свернуть("","Тоннаж, Наценка");
		ИтогоТоннаж  = ТЗИтоги.Получить(0).Тоннаж;
		ИтогоНаценка = ТЗИтоги.Получить(0).Наценка;
	КонецЕсли;
	
КонецПроцедуры
