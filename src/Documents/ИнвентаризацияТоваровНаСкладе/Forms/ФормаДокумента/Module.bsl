&НаКлиенте
Процедура Базар_ТоварыЦенаПриИзмененииПосле(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	СтрокаТабличнойЧасти.СуммаУчет = СтрокаТабличнойЧасти.Цена * СтрокаТабличнойЧасти.КоличествоУчет;
	
КонецПроцедуры

&НаКлиенте
Процедура Базар_ЗаполнитьЦеныПоЦенамНоменклатурыВместо(Команда)
	
	ТекстВопроса = НСтр("ru = 'Вы действительно хотите перезаполнить цены, по ценам номенклатуры? При этом изменсятся суммы (факта и учета).'");
	Оповещение = Новый ОписаниеОповещения("ОтветНаВопросПерезаполнитьЦены", ЭтотОбъект, Неопределено);
	ПоказатьВопрос(Оповещение,
	               ТекстВопроса,
	               РежимДиалогаВопрос.ДаНет,
	               30,
	               КодВозвратаДиалога.Да,
	               "Перезаполнить цены?",
	               КодВозвратаДиалога.Нет);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветНаВопросПерезаполнитьЦены(Ответ, ДополнительныеНастройки) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ЗаполнитьЦеныПоЦенамНоменклатуры();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЦеныПоЦенамНоменклатуры()
	
	Документы.ИнвентаризацияТоваровНаСкладе.ЗаполнитьЦеныПоЦенамНоменклатуры(Объект.Товары, Объект.Дата);
	Модифицированность = Истина;
	
КонецПроцедуры