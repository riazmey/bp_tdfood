Процедура СформироватьТекстСообщенияОписывающихДокументы(ТаблицаДокументов, ТекстСообщения) Экспорт

	ТекстСообщения = ТекстСообщения + Символы.ПС;
	
	СчетчикДокументов = 0;
	МаксКолВыводимыхДокументовВСообщении = 2;
	Для Каждого СтрокаДокумента из ТаблицаДокументов цикл
		СчетчикДокументов = СчетчикДокументов + 1;
		
		Если СчетчикДокументов > МаксКолВыводимыхДокументовВСообщении тогда
			Прервать;
		КонецЕсли;
		
		ПредставлениеДокумента = Строка(ТипЗнч(СтрокаДокумента.Документ)) +
		                         " № " + СтрокаДокумента.Номер +  " от " +
		                         Формат(СтрокаДокумента.Дата, "ДФ=dd.MM.yyyy");
		ТекстСообщения = ТекстСообщения + ?(СчетчикДокументов = 1 ИЛИ СчетчикДокументов = ТаблицаДокументов.Количество(), "", ",") + " " + ПредставлениеДокумента;
	КонецЦикла;
	
	Если ТаблицаДокументов.Количество() > МаксКолВыводимыхДокументовВСообщении тогда
		ТекстСообщения = ТекстСообщения + ", и еще " + Строка(ТаблицаДокументов.Количество() - МаксКолВыводимыхДокументовВСообщении) + " документа/ов.";
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДанныеСтрокиТовары(ДанныеСтроки, ДанныеЗаполнения) Экспорт
	
	Если ДанныеЗаполнения = Неопределено тогда
		ДанныеСтроки.ЦенаГосЗакупок = 0;
		ДанныеСтроки.ЕдиницаИзмеренияГосЗакупок = ПредопределенноеЗначение("Справочник.КлассификаторЕдиницИзмерения.ПустаяСсылка");
		ДанныеСтроки.КоэффициентГосЗакупок = 1;
	Иначе
		ЗаполнитьЗначенияСвойств(ДанныеСтроки, ДанныеЗаполнения);
		ДанныеСтроки.КоэффициентГосЗакупок = ?(ДанныеЗаполнения.КоэффициентГосЗакупок = 0, 1, ДанныеЗаполнения.КоэффициентГосЗакупок);
		Если ДанныеСтроки.КоличествоГосЗакупок = 0 тогда
			Если ДанныеЗаполнения.Свойство("КоличествоОстаток") тогда
				ДанныеСтроки.КоличествоГосЗакупок = ДанныеЗаполнения.КоличествоОстаток;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ТоварыПересчитатьСуммуСуммуНДСиВсего(СтрокаТовары, СуммаВключаетНДС) Экспорт
	
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧастиГосЗакупок(СтрокаТовары);
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(СтрокаТовары, СуммаВключаетНДС);
	
	Попытка
		СуммаСкидки = СтрокаТовары.СуммаСкидки;
	Исключение
		СуммаСкидки = 0;
	КонецПопытки;
	
	СтрокаТовары.Всего = СтрокаТовары.Сумма + ?(СуммаВключаетНДС, 0, СтрокаТовары.СуммаНДС) - СуммаСкидки;
	
КонецПроцедуры
