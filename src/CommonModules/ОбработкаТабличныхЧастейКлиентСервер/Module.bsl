Процедура ПриИзмененииКоличествоЦенаГосЗакупок(Форма, ИмяТаблицы, ЗначениеПустогоКоличества = 0, ПрименяютсяСтавки4и2 = Ложь) Экспорт

	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	СтрокаТаблицы = Элементы[ИмяТаблицы].ТекущиеДанные;
	РассчитатьСуммуТабЧастиГосЗакупок(СтрокаТаблицы, ЗначениеПустогоКоличества);
	
	Если СтрокаТаблицы.Свойство("СуммаНДС") Тогда
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "ПокупательНалоговыйАгентПоНДС")
			И Форма.ПокупательНалоговыйАгентПоНДС = Истина
			И Форма.ВедетсяУчетНДСПоФЗ335 Тогда 
			СтрокаТаблицы.СуммаНДС = 0;
		Иначе
			РассчитатьСуммуНДСТабЧасти(СтрокаТаблицы, Объект.СуммаВключаетНДС, ПрименяютсяСтавки4и2);
		КонецЕсли;
	КонецЕсли;

	Если СтрокаТаблицы.Свойство("СуммаВРознице") Тогда
		СтрокаТаблицы.СуммаВРознице = СтрокаТаблицы.Количество * СтрокаТаблицы.ЦенаВРознице;
	КонецЕсли;

	Если СтрокаТаблицы.Свойство("Всего") Тогда
		СтрокаТаблицы.Всего = СтрокаТаблицы.Сумма + ?(Объект.СуммаВключаетНДС, 0, СтрокаТаблицы.СуммаНДС);
	КонецЕсли;

КонецПроцедуры

// Рассчитывает сумму в строке табличной части документа
//
// Параметры:
//  СтрокаТабличнойЧасти - строка табличной части документа
//
Процедура РассчитатьСуммуТабЧастиГосЗакупок(СтрокаТабличнойЧасти, ЗначениеПустогоКоличества = 0) Экспорт

	СтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.ЦенаГосЗакупок * ?(СтрокаТабличнойЧасти.КоличествоГосЗакупок = 0, ЗначениеПустогоКоличества, СтрокаТабличнойЧасти.КоличествоГосЗакупок);

КонецПроцедуры