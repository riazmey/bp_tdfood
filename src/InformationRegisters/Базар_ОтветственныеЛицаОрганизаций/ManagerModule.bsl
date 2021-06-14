
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(СтруктурнаяЕдиница)
	|	ИЛИ ЗначениеРазрешено(СтруктурнаяЕдиница.Владелец)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли

Процедура ЗаписатьНаборЗаписейИсторииОтветственныеЛицаОрганизаций(СтруктурнаяЕдиница, РеквизитыПодписи) Экспорт 
	
	ЭтоЗаписьНового = НЕ ЗначениеЗаполнено(РеквизитыПодписи.Период);
	
	История = РегистрыСведений.ОтветственныеЛицаОрганизаций.СоздатьНаборЗаписей();
	История = История.Выгрузить();
	НоваяСтрока = История.Добавить();
	НоваяСтрока.СтруктурнаяЕдиница = СтруктурнаяЕдиница;
	ЗаполнитьЗначенияСвойств(НоваяСтрока,РеквизитыПодписи);
	
	Если ЭтоЗаписьНового тогда
		НоваяСтрока.Период = Дата("19800101");
	КонецЕслИ;
		
	Набор = РегистрыСведений.ОтветственныеЛицаОрганизаций.СоздатьНаборЗаписей();
	Набор.Отбор.СтруктурнаяЕдиница.Установить(СтруктурнаяЕдиница);
	Набор.Отбор.ОтветственноеЛицо.Установить(РеквизитыПодписи.ОтветственноеЛицо);
	Набор.Прочитать();
	ИсторияДоИзменения = Набор.Выгрузить();
	
	// Получим только измененные записи и запишем их поштучно для того, что бы верно сработала дата запрета редактирования
	ИзмененнаяИстория = ИсторияДоИзменения.СкопироватьКолонки();
	ИзмененнаяИстория.Колонки.Добавить("ТипИзменения", Новый ОписаниеТипов("Строка"));
	
	Для Каждого ЗаписьИстории Из История Цикл
		ЗаписьИсторииДоИзменения =  ИсторияДоИзменения.Найти(ЗаписьИстории.Период, "Период");
		Если ЗаписьИсторииДоИзменения = Неопределено Тогда
			ИзмененнаяЗапись = ИзмененнаяИстория.Добавить();
			ИзмененнаяЗапись.ТипИзменения = "Добавление";
			ЗаполнитьЗначенияСвойств(ИзмененнаяЗапись, ЗаписьИстории);
		Иначе
			Для Каждого Колонка Из ИсторияДоИзменения.Колонки Цикл
				Если ЗаписьИстории[Колонка.Имя] <> ЗаписьИсторииДоИзменения[Колонка.Имя] Тогда
					ИзмененнаяЗапись = ИзмененнаяИстория.Добавить();
					ИзмененнаяЗапись.ТипИзменения = "Изменение";
					ЗаполнитьЗначенияСвойств(ИзмененнаяЗапись, ЗаписьИстории);
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	// Найдем удаленные записи
	Для Каждого ЗаписьИсторииДоИзменения Из ИзмененнаяИстория Цикл
		ЗаписьИстории = ИсторияДоИзменения.Найти(ЗаписьИстории.Период, "Период");
		Если ЗаписьИсторииДоИзменения = Неопределено Тогда
			ИзмененнаяЗапись = ИзмененнаяИстория.Добавить();
			ИзмененнаяЗапись.ТипИзменения = "Удаление";
			ЗаполнитьЗначенияСвойств(ИзмененнаяЗапись, ЗаписьИстории);
		КонецЕсли;
	КонецЦикла;
	
	ИзмененнаяИстория.Сортировать("Период");
	
	Для Каждого ИзмененнаяЗапись ИЗ ИзмененнаяИстория Цикл
		
		НаборЗаписей = РегистрыСведений.ОтветственныеЛицаОрганизаций.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Период.Установить(ИзмененнаяЗапись.Период);
		НаборЗаписей.Отбор.СтруктурнаяЕдиница.Установить(ИзмененнаяЗапись.СтруктурнаяЕдиница);
		НаборЗаписей.Отбор.ОтветственноеЛицо.Установить(ИзмененнаяЗапись.ОтветственноеЛицо);

		Если ЭтоЗаписьНового Тогда
			НаборЗаписей.ДополнительныеСвойства.Вставить("ПропуститьПроверкуЗапретаИзменения", Истина);
		КонецЕсли;
		
		Если ИзмененнаяЗапись.ТипИзменения = "Удаление" Тогда
			НаборЗаписей.Записать();
		Иначе
			Запись = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(Запись, ИзмененнаяЗапись);
			НаборЗаписей.Записать();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры
