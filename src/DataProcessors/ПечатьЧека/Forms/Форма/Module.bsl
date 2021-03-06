&НаСервере
Процедура Базар_ЗаполнитьПоДокументуРасчетаПослеНаСервере()
	
	Объект.ТаблицаТоваров.Очистить();
	
	ЕстьИнформацияОбАгентахПоСтрокам = Ложь;
	
	ДокументыВРасшифровке = ДокументОснование.РасшифровкаПлатежа.Выгрузить();
	ДокументыВРасшифровке.Свернуть("Сделка, СчетНаОплату");
	
	Если ДокументыВРасшифровке.Количество() = 1 тогда
		
		ДанныеРасшифровки = ДокументыВРасшифровке.Получить(0);
		
		ТаблицаТоварыОтгрузки = Неопределено;
		Если ЗначениеЗаполнено(ДанныеРасшифровки.Сделка) тогда
			Если ТипЗнч(ДанныеРасшифровки.Сделка) = Тип("ДокументСсылка.РеализацияТоваровУслуг") тогда
				ТаблицаТоварыОтгрузки = ДанныеРасшифровки.Сделка.Товары.Выгрузить();
			КонецЕсли;
		КонецЕсли;
		
		Если ТаблицаТоварыОтгрузки = Неопределено тогда
			Если ЗначениеЗаполнено(ДанныеРасшифровки.СчетНаОплату) тогда
				ТаблицаТоварыОтгрузки = ДанныеРасшифровки.СчетНаОплату.Товары.Выгрузить();
			КонецЕсли;
		КонецЕсли;
		
		Если НЕ ТаблицаТоварыОтгрузки = Неопределено тогда
			
			Для Каждого СтрокаТовары из ТаблицаТоварыОтгрузки цикл
				
				ДанныеПоставщика = Новый Структура("Наименование, ИНН, Телефон");
				ДанныеАгента = Новый Структура("ОператорПеревода, ОператорПоПриемуПлатежей, ПлатежныйАгент",
				                               Новый Структура("Адрес, ИНН, Наименование, Телефон"),
				                               Новый Структура("Телефон"),
				                               Новый Структура("Операция, Телефон"));
				
				НоваяСтрока = Объект.ТаблицаТоваров.Добавить();
				
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТовары);
				
				НоваяСтрока.Наименование = СтрокаТовары.Номенклатура.НаименованиеПолное;
				НоваяСтрока.ПризнакСпособаРасчета = ПредопределенноеЗначение("Перечисление.ПризнакиСпособаРасчета.ОплатаКредита");
				НоваяСтрока.ЦенаСоСкидками = НоваяСтрока.Цена;
				НоваяСтрока.ПризнакПредметаРасчета = ПредопределенноеЗначение("Перечисление.ПризнакиПредметаРасчета.ПлатежВыплата");
				НоваяСтрока.ПризнакАгентаСтрокой = "Собственные товары и услуги";
				
				НоваяСтрока.ДанныеПоставщика = ДанныеПоставщика;
				НоваяСтрока.ДанныеАгента = ДанныеАгента;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Базар_ЗаполнитьПоДокументуРасчетаПосле(Команда)
	
	Базар_ЗаполнитьПоДокументуРасчетаПослеНаСервере();
	ТаблицаТоваровПриИзменении(Элементы.ТаблицаТоваров);
	
КонецПроцедуры

&НаСервере
Процедура Базар_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	ДокументОснование = Параметры.Ссылка;
	
КонецПроцедуры

&НаКлиенте
Процедура Базар_ПриОткрытииПосле(Отказ)
	
	Если НЕ ЗначениеЗаполнено(ДокументОснование) тогда
		Элементы.ЗаполнитьПоДокументуРасчета.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры
