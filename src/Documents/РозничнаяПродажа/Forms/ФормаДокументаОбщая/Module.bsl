&НаКлиентеНаСервереБезКонтекста
&После("УправлениеФормой")
Процедура Базар_УправлениеФормой(Форма)
	
	Если ЗначениеЗаполнено(Форма.Объект.Перемещение) тогда
		Форма.Элементы.Основание.Видимость = Ложь;
		Форма.Элементы.Перемещение.Видимость = Истина;
	Иначе
		Форма.Элементы.Основание.Видимость = Истина;
		Форма.Элементы.Перемещение.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
&Вместо("ОснованиеПриИзменении")
Процедура Базар_ОснованиеПриИзменении(Элемент)
	
	Если НЕ Объект.Основание.Пустая() ИЛИ НЕ Объект.Перемещение.Пустая() Тогда
		ОснованиеПриИзмененииНаСервере();
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	ОбновитьИтоги(ЭтаФорма);
КонецПроцедуры

&НаСервере
&Вместо("ОснованиеПриИзмененииНаСервере")
Процедура Базар_ОснованиеПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(Объект.Основание) тогда
		ЗаполнитьЗначенияСвойств(Объект, Объект.Основание, "СуммаВключаетНДС, ТипЦен, ДокументБезНДС");
		Документы.РозничнаяПродажа.СкопироватьТабличныеЧасти(Объект, Объект.Основание);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Перемещение) тогда
		Документы.РозничнаяПродажа.ЗаполнитьНаОснованииПеремещения(Объект, Объект.Перемещение);
	КонецЕсли;
	
КонецПроцедуры


