
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//НастройкиАвтоматическойПечатиКонтрагент = Неопределено;
	//НастройкиАвтоматическойПечатиДоговор = Неопределено;
	//
	//Если Параметры.Отбор.Свойство("Контрагент") тогда
	//	НаборЗаписей.Отбор.Контрагент.Значение = Параметры.Отбор.Контрагент;
	//	Ссылка = Параметры.Отбор.Контрагент;
	//КонецЕсли;
	//
	//Если Параметры.Отбор.Свойство("Договор") тогда
	//	НаборЗаписей.Отбор.Договор.Значение = Параметры.Отбор.Договор;
	//	НаборЗаписей.Отбор.Контрагент.Значение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Отбор.Договор, "Владелец");
	//	Ссылка = Параметры.Отбор.Договор;
	//КонецЕсли;
	//
	//Если ЗначениеЗаполнено(НаборЗаписей.Отбор.Контрагент.Значение) тогда
	//	НастройкиАвтоматическойПечатиКонтрагент = НастройкиАвтоматическойПечатиСервер.НастройкиАвтоматическойПечатиКонтрагентаИлиДоговора(НаборЗаписей.Отбор.Контрагент.Значение);
	//КонецЕсли;
	//
	//Если ЗначениеЗаполнено(НаборЗаписей.Отбор.Договор.Значение) тогда
	//	НастройкиАвтоматическойПечатиДоговор = НастройкиАвтоматическойПечатиСервер.НастройкиАвтоматическойПечатиКонтрагентаИлиДоговора(НаборЗаписей.Отбор.Договор.Значение);
	//	Если НастройкиАвтоматическойПечатиДоговор = Неопределено тогда
	//		Если НЕ НастройкиАвтоматическойПечатиКонтрагент = Неопределено тогда
	//			НаборЗаписей.Отбор.Контрагент.Использование = Истина;
	//		КонецЕсли;
	//	Иначе
	//		НаборЗаписей.Отбор.Договор.Использование = Истина;
	//	КонецЕсли;
	//КонецЕсли;
	//
	//ЗаполнитьНаборЗаписей();
	//
	//УправлениеФормой();
	
КонецПроцедуры
