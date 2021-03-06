&НаСервере
Процедура Базар_ПередЗаписьюНаСервереПеред(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение тогда
		
		Для Каждого СтрокаРасшифровкиПлатежа из Объект.РасшифровкаПлатежа цикл
			
			КонтрольРасчетовНаличнымиДеньгамиСервер.КонтрольРасчетовНаличнымиДеньгами(
				Объект,
				СтрокаРасшифровкиПлатежа.ДоговорКонтрагента,
				СтрокаРасшифровкиПлатежа.СуммаПлатежа,
				Отказ
			);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Базар_РасшифровкаПлатежаДоговорКонтрагентаПриИзмененииПосле(Элемент)
	
	Если НЕ ЗначениеЗаполнено(РасшифровкаПлатежаДоговорКонтрагента) тогда
		Объект.Основание = "";
	Иначе
		Объект.Основание = Строка(РасшифровкаПлатежаДоговорКонтрагента);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Базар_РасшифровкаПлатежаСделкаПриИзмененииПосле(Элемент)
	
	Если НЕ ЗначениеЗаполнено(РасшифровкаПлатежаДоговорКонтрагента) ИЛИ НЕ ЗначениеЗаполнено(РасшифровкаПлатежаСделка)тогда
		Объект.Основание = "";
	Иначе
		Объект.Основание = Строка(РасшифровкаПлатежаДоговорКонтрагента);
	КонецЕсли;
	
КонецПроцедуры
