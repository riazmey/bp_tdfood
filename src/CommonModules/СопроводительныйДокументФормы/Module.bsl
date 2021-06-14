////////////////////////////////////////////////////////////////////////////////
// СопроводительныйДокументФормы: серверные процедуры и функции, вызываемые из форм
// документа "Сопроводительный документ".
//  
////////////////////////////////////////////////////////////////////////////////

Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт

	Элементы 	= Форма.Элементы;
	Объект		= Форма.Объект;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(Форма);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(Форма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка)
		И Форма.Параметры.Свойство("ЗначенияЗаполнения") Тогда
		
		Если Форма.Параметры.ЗначенияЗаполнения.Свойство("ВидОперации") тогда
			Форма.Объект.ВидОперации = Форма.Параметры.ЗначенияЗаполнения.ВидОперации;
		КонецЕсли;
		УстановитьЗаголовокФормыНаСервере(Форма);
		Форма.УправлениеФормойНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт

	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(Форма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	Форма.ПодготовитьФормуНаСервере();

КонецПроцедуры

Процедура ПослеЗаписиНаСервере(Форма, ПараметрыЗаписи) Экспорт
	
	Объект = Форма.Объект;
	
	// Удаляем существующие записи
	НаборЗаписей = РегистрыСведений.Базар_СопроводительныеДокументыИзображения.СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.ДокументРегистратор.Установить(Объект.Ссылка);
	
	НаборЗаписей.Прочитать();
	НаборЗаписей.Очистить();
	
	// Производим запись данных в регистр сведений "СопроводительныеДокументыИзображения"
	Для Каждого ДанныеИзображения из Объект.Изображения цикл
		
		АдресВременногоХранилища = ПараметрыЗаписи.АдресаВременногоХранилища.Получить(ДанныеИзображения.НомерСтроки - 1);
		
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.ДокументРегистратор = Объект.Ссылка;
		НоваяЗапись.GUIDИзображения     = ДанныеИзображения.GUIDИзображения;
		НоваяЗапись.Изображение         = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(АдресВременногоХранилища));

	КонецЦикла;
	
	НаборЗаписей.Записать();
	
	УстановитьЗаголовокФормыНаСервере(Форма);

КонецПроцедуры

Процедура УстановитьЗаголовокФормыНаСервере(Форма) Экспорт
	
	Объект = Форма.Объект;

	Форма.Заголовок = "";
	ТекстЗаголовка	= НСтр("ru = '"+ Строка(Объект.ВидОперации)+"'");
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекстЗаголовка = ТекстЗаголовка + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru=' %1 от %2'"), Объект.Номер, Объект.Дата);
	Иначе
		ТекстЗаголовка = ТекстЗаголовка + " (создание)";
	КонецЕсли;
	
	Форма.Заголовок = ТекстЗаголовка;

КонецПроцедуры
