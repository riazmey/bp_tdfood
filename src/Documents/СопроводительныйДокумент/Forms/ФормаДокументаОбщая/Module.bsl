////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СопроводительныйДокументФормы.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ФайловаяСистемаКлиент.СоздатьВременныйКаталог(Новый ОписаниеОповещения(
		"ОбработкаОповещенияСоздатьВременныйКаталогФормы"
		, ЭтаФорма));
	
	Элементы.КемВыдан.СписокВыбора.ЗагрузитьЗначения(МассивВыбораКемВыданИлиКомуВыданНаСервере("КемВыдан"));
	Элементы.КомуВыдан.СписокВыбора.ЗагрузитьЗначения(МассивВыбораКемВыданИлиКомуВыданНаСервере("КомуВыдан"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	НачатьУдалениеФайлов(Новый ОписаниеОповещения(
		"ОбработкаОповещенияУдалениеВременногоКаталогаФормы"
		, ЭтотОбъект)
		, КаталогВременныхФайловДокумента);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	СопроводительныйДокументФормы.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СопроводительныйДокументФормыКлиент.ПередЗаписью(
		ЭтаФорма, Отказ, ПараметрыЗаписи);
		
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	СопроводительныйДокументФормы.ПослеЗаписиНаСервере(ЭтаФорма, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ФайловаяСистемаКлиент.СоздатьВременныйКаталог(Новый ОписаниеОповещения(
		"ОбработкаОповещенияСоздатьВременныйКаталогФормы"
		, ЭтаФорма));

	ОбновитьПредставленияСтрокТаблицыИзображения();
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаВыбора(ПолученныеПараметры, ИсточникВыбора)
	
	Если ТипЗнч(ПолученныеПараметры) = Тип("Структура") тогда
		
		Если ПолученныеПараметры.Свойство("КаталогВременныхФайлов") тогда
			
			ПолученныеФайлы = НайтиФайлы(ПолученныеПараметры.КаталогВременныхФайлов, "*.*");
			НовыйПодкаталог = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(КаталогВременныхФайловДокумента + Новый УникальныйИдентификатор);
			
			СоздатьКаталог(НовыйПодкаталог);
			
			Если ПолученныеПараметры.Свойство("ТаблицаФайлов") тогда
				
				Для Каждого ДанныеФайлы из ПолученныеПараметры.ТаблицаФайлов цикл
					
					Если НЕ ДанныеФайлы.Пометка тогда
						Продолжить;
					КонецЕсли;
					
					НовоеИзображение = Объект.Изображения.Добавить();
					НовоеИзображение.ПредставлениеСтроки = "Изображение №" + НовоеИзображение.НомерСтроки;
					НовоеИзображение.GUIDИзображения = Новый УникальныйИдентификатор;
					НовоеИзображение.ПолныйПуть = НовыйПодкаталог + ДанныеФайлы.Имя;
					
					КопироватьФайл(ДанныеФайлы.ПолныйПуть, НовоеИзображение.ПолныйПуть);
					
					Модифицированность = Истина;
					
				КонецЦикла;
				
			КонецЕсли;
			
			НачатьУдалениеФайлов(Новый ОписаниеОповещения(
				"ОбработкаОповещенияУдалениеВременногоКаталогаФормы"
				, ЭтотОбъект)
				, ПолученныеПараметры.КаталогВременныхФайлов);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ
&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Элементы.ГруппаИзображения И Объект.Изображения.Количество() = 0 тогда
		ИмяФормыЗагрузкиИзображений = "Документ.СопроводительныйДокумент.Форма.ФормаАвтозагрузкиИзображений";
		
		ЕстьФайлыДляЗагрузки = Ложь;
		ЕстьКаталогЗагрузки  = Ложь;
		НастройкиФормы  = СохраненныеНастройкиФормы(ИмяФормыЗагрузкиИзображений);
		
		Если НастройкиФормы = Неопределено тогда
			КаталогЗагрузки = КаталогВременныхФайлов();
		Иначе
			КаталогЗагрузки = НастройкиФормы.Получить("КаталогЗагрузки");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(КаталогЗагрузки) тогда
			Каталог = Новый Файл(КаталогЗагрузки);
			Если Каталог.Существует() Тогда
				ЕстьКаталогЗагрузки = Истина;
			КонецЕсли;
		КонецЕсли;
		
		Если ЕстьКаталогЗагрузки тогда
			
			//ФильтрФайлов = "Изображения (Все)|*.jpg;*.jpeg;*.jpe;*.png;*.gif|Изображение JPEG (*.jpg;*.jpeg;*.jpe)|*.jpg;*.jpeg;*.jpe|Изображение PNG (*.png)|*.png|Изображение GIF (*.gif)|*.gif";
			
			МассивТипов = Новый Массив;
			МассивТипов.Добавить("*.jpg");
			МассивТипов.Добавить("*.jpeg");
			МассивТипов.Добавить("*.jpe");
			МассивТипов.Добавить("*.png");
			МассивТипов.Добавить("*.gif");
			
			КоличествоТипов = МассивТипов.Количество();
			Для Счетчик = 1 по КоличествоТипов цикл
				МассивТипов.Добавить(ВРЕГ(МассивТипов.Получить(Счетчик - 1)));
			КонецЦикла;

			Для Каждого ТипФайлов из МассивТипов цикл
				Найденныефайлы = НайтиФайлы(КаталогЗагрузки, ТипФайлов);     
				Если Найденныефайлы.Количество() > 0 тогда
					ЕстьФайлыДляЗагрузки = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
		Если ЕстьФайлыДляЗагрузки тогда
			ОткрытьФорму(ИмяФормыЗагрузкиИзображений, , ЭтаФорма);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Изображения
&НаКлиенте
Процедура ИзображенияПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОтобразитьИзображениеНаФорме", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзображенияПриИзменении(Элемент)
	
	ПодключитьОбработчикОжидания("ОбновитьПредставленияСтрокТаблицыИзображения", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзображенияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС
&НаСервере
Процедура УправлениеФормойНаСервере() Экспорт
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере() Экспорт

	УправлениеФормой(ЭтаФорма);
	
	СопроводительныйДокументФормы.УстановитьЗаголовокФормыНаСервере(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьИзображениеНаФорме()
	
	Если Элементы.Изображения.ТекущаяСтрока = Неопределено тогда
		АдресКартинки = "";
	Иначе
		Если ЗначениеЗаполнено(Элементы.Изображения.ТекущиеДанные.ПолныйПуть) тогда
			ДвоичныеДанные = Новый ДвоичныеДанные(Элементы.Изображения.ТекущиеДанные.ПолныйПуть);
			АдресКартинки = ПоместитьВоВременноеХранилище(ДвоичныеДанные,УникальныйИдентификатор);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПредставленияСтрокТаблицыИзображения()
	
	Для Каждого ДанныеИзображения из ЭтаФорма.Объект.Изображения цикл
		ДанныеИзображения.ПредставлениеСтроки = "Изображение №" + ДанныеИзображения.НомерСтроки;
	КонецЦикла
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	ВидимостьДатаОкончанияДействия      = Истина;
	ВидимостьКемВыдан                   = Истина;
	ВидимостьГруппаСтандартыНаПродукцию = Истина;
	ВидимостьГруппаДополнительно        = Истина;
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.Базар_ВидыСопроводительныхДокументов.КачественноеУдостоверение") Тогда
		ВидимостьГруппаСтандартыНаПродукцию = Ложь;
		ВидимостьГруппаДополнительно        = Ложь;
	ИначеЕсли Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.Базар_ВидыСопроводительныхДокументов.ПротоколЛабораторногоИсследования") Тогда
		ВидимостьДатаОкончанияДействия      = Ложь;
		ВидимостьГруппаСтандартыНаПродукцию = Ложь;
	ИначеЕсли Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.Базар_ВидыСопроводительныхДокументов.ИнформационноеПисьмо") Тогда
		ВидимостьКемВыдан                   = Ложь;
		ВидимостьДатаОкончанияДействия      = Ложь;
		ВидимостьГруппаСтандартыНаПродукцию = Ложь;
	КонецЕсли;

	Элементы.ДатаОкончанияДействия.Видимость      = ВидимостьДатаОкончанияДействия;
	Элементы.КемВыдан.Видимость                   = ВидимостьКемВыдан;
	Элементы.ГруппаСтандартыНаПродукцию.Видимость = ВидимостьГруппаСтандартыНаПродукцию;
	Элементы.ГруппаДополнительно.Видимость        = ВидимостьГруппаДополнительно;
	
КонецПроцедуры

&НаСервере
Функция ВернутьДвоичныеДанныеНаСервере(GUIDИзображения)
	
	НаборЗаписей = РегистрыСведений.Базар_СопроводительныеДокументыИзображения.СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.ДокументРегистратор.Установить(Объект.Ссылка);
	НаборЗаписей.Отбор.GUIDИзображения.Установить(GUIDИзображения);
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() <> 1 тогда	
		Возврат Неопределено;
	КонецЕсли;
	
	Если ТипЗнч(НаборЗаписей.Получить(0).Изображение) = Тип("ХранилищеЗначения") тогда
		ДвоичныеДанные = НаборЗаписей.Получить(0).Изображение.Получить();
		Возврат ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция СохраненныеНастройкиФормы(ИмяФормыЗагрузкиИзображений)
	
	Возврат ХранилищеСистемныхНастроек.Загрузить(ИмяФормыЗагрузкиИзображений+"/ТекущиеДанные", "");
	
КонецФункции

&НаКлиенте
Процедура ЗагрузитьИзображения(Команда)
	
	ОткрытьФорму("Документ.СопроводительныйДокумент.Форма.ФормаАвтозагрузкиИзображений", , ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Функция МассивВыбораКемВыданИлиКомуВыданНаСервере(Реквизит)
	
	Запрос = Новый Запрос;    //"+Реквизит+"
	Запрос.Текст = "ВЫБРАТЬ
	               |	Базар_СопроводительныеДокументы."+Реквизит+" КАК Значение
	               |ИЗ
	               |	РегистрСведений.Базар_СопроводительныеДокументы КАК Базар_СопроводительныеДокументы
	               |ГДЕ
	               |	Базар_СопроводительныеДокументы."+Реквизит+" <> """"
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	Базар_СопроводительныеДокументы."+Реквизит+"
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Значение";
	
	ТаблицаВыбора = Запрос.Выполнить().Выгрузить();
		
	Возврат ТаблицаВыбора.ВыгрузитьКолонку("Значение");
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТКИ ОПОВЕЩЕНИЙ, ПОДКЛЮЧАЕМЫЕ КОМАНДЫ
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры
 
&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры
 
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещенияУдалениеВременногоКаталогаФормы(Контекст) Экспорт
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещенияСоздатьВременныйКаталогФормы(ИмяКаталогаВременныхФайлов, ДополнительныеПараметры) Экспорт
	
	КаталогВременныхФайловДокумента = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ИмяКаталогаВременныхФайлов);
	
	Для Каждого СтрокаИзображения из Объект.Изображения цикл
			
		АдресДвоичныхДанных = ВернутьДвоичныеДанныеНаСервере(СтрокаИзображения.GUIDИзображения);
		
		Если АдресДвоичныхДанных = Неопределено Тогда
			Продолжить;
		Иначе
			Изображение = ПолучитьИзВременногоХранилища(АдресДвоичныхДанных);
			ПолныйПуть = КаталогВременныхФайловДокумента + СтрокаИзображения.GUIDИзображения;
			
			ФайлИзображения = Новый Файл(ПолныйПуть);
			Если НЕ ФайлИзображения.Существует() тогда
				Изображение.Записать(ПолныйПуть);
			КонецЕСли;
			
			СтрокаИзображения.ПолныйПуть = ПолныйПуть;
			
		Конецесли;
		
		СтрокаИзображения.ПредставлениеСтроки = "Изображение №"+СтрокаИзображения.НомерСтроки;
		
	КонецЦикла;

КонецПроцедуры