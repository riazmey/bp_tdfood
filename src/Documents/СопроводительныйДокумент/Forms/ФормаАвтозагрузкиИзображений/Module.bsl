////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	КонвертироватьИзображение = ОбщегоНазначенияКлиент.ЭтоLinuxКлиент();
	Элементы.КонвертироватьИзображение.Видимость = ОбщегоНазначенияКлиент.ЭтоLinuxКлиент();
	
	ЗаполнитьТаблицуФайлов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	ИначеЕсли Модифицированность И НЕ ПеренестиВДокумент Тогда
		Отказ = Истина;
		ТекстВопроса = НСтр("ru = 'Вы хотите перед закрытием загрузить изменения?'");
		Оповещение = Новый ОписаниеОповещения("ОбработкаОповещенияВопросПередЗакрытиемФормы", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Да);
	КонецЕсли;

	Если Отказ Тогда
		ПеренестиВДокумент = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)

	Если ПеренестиВДокумент И Модифицированность Тогда
		ФайловаяСистемаКлиент.СоздатьВременныйКаталог(Новый ОписаниеОповещения("ОбработкаОповещенияСоздатьВременныйКаталогФормы",  ЭтаФорма));
	КонецЕсли;

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ
&НаКлиенте
Процедура КаталогЗагрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ФайловаяСистемаКлиент.ВыбратьКаталог(Новый ОписаниеОповещения("ОбработкаОповещенияВыбратьКаталог", ЭтотОбъект));
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ТаблицаФайлов
&НаКлиенте
Процедура ТаблицаФайловПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОтобразитьИзображениеНаФорме", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаФайловПометкаПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
&НаКлиенте
Процедура Загрузить(Команда)
	
	ПеренестиВДокумент = Истина;
	ЭтаФорма.Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаФайловУправлениеПометками(Команда)
	
	Для Каждого Строка из ТаблицаФайлов цикл
		
		Если Команда.Имя = "ТаблицаФайловУстановитьПометки" тогда
			Строка.Пометка = Истина;
		ИначеЕсли Команда.Имя = "ТаблицаФайловСнятьПометки" тогда
			Строка.Пометка = Ложь;
		ИначеЕсли Команда.Имя = "ТаблицаФайловИнвертироватьПометки" тогда
			Строка.Пометка = НЕ Строка.Пометка;
		КонецЕсли;
		
	КонецЦикла;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТаблицуФайлов()
	
	ЕстьФайлыДляЗагрузки = Ложь;
	ЕстьКаталогЗагрузки  = Ложь;
	
	Если ЗначениеЗаполнено(КаталогЗагрузки) тогда
		Каталог = Новый Файл(КаталогЗагрузки);
		Если Каталог.Существует() Тогда
			ЕстьКаталогЗагрузки = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ЕстьКаталогЗагрузки тогда
		
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
			Для Каждого Файл из НайденныеФайлы цикл 
				НоваяСтрока = ТаблицаФайлов.Добавить();
				НоваяСтрока.Имя = Файл.Имя;
				НоваяСтрока.ПолныйПуть = Файл.ПолноеИмя;
				НоваяСтрока.Пометка = Ложь;
			КонецЦикла;
		КонецЦикла;
		
	КонецЕсли;

	Если ТаблицаФайлов.Количество() > 0 И Элементы.ТаблицаФайлов.ТекущаяСтрока = Неопределено тогда
		Элементы.ТаблицаФайлов.ТекущаяСтрока = ТаблицаФайлов.Получить(0).ПолучитьИдентификатор();
	КонецЕсли;
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьИзображениеНаФорме()
	
	Если Элементы.ТаблицаФайлов.ТекущаяСтрока = Неопределено тогда
		АдресКартинки = "";
	Иначе
		ДвоичныеДанные = Новый ДвоичныеДанные(Элементы.ТаблицаФайлов.ТекущиеДанные.ПолныйПуть);
		АдресКартинки = ПоместитьВоВременноеХранилище(ДвоичныеДанные,УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТКИ ОПОВЕЩЕНИЙ
&НаКлиенте
Процедура ОбработкаОповещенияВопросПередЗакрытиемФормы(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПеренестиВДокумент = Истина;
		Закрыть();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		ПеренестиВДокумент = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещенияСоздатьВременныйКаталогФормы(ИмяКаталогаВременныхФайлов, ДополнительныеПараметры) Экспорт
	
	КаталогВременныхФайлов = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ИмяКаталогаВременныхФайлов);
	
	Для Каждого ДанныеФайла из ТаблицаФайлов цикл
		
		Если НЕ ДанныеФайла.Пометка тогда
			Продолжить;
		КонецЕсли;
		
		ФайлИзображенияИсточник = Новый Файл(ДанныеФайла.ПолныйПуть);
		ФайлИзображенияНазначения = Новый Файл(КаталогВременныхФайлов + ДанныеФайла.Имя);
		
		Если ФайлИзображенияИсточник.Существует() И НЕ ФайлИзображенияНазначения.Существует() тогда
			КопироватьФайл(ДанныеФайла.ПолныйПуть, КаталогВременныхФайлов + ДанныеФайла.Имя);
		КонецЕсли;
		
		Если КонвертироватьИзображение И ОбщегоНазначенияКлиент.ЭтоLinuxКлиент() тогда
			ПараметрыСкрипта = Новый Структура;
			ПараметрыСкрипта.Вставить("Arguments", """" + КаталогВременныхФайлов + ДанныеФайла.Имя + """");

			LinuxScriptsClient.ExecuteTemplateLinuxScript("convert_image", КаталогВременныхФайлов, ПараметрыСкрипта);
		КонецЕсли;

		
		Если УдалятьЗагруженныеФайлы И ФайлИзображенияИсточник.Существует() тогда
			УдалитьФайлы(ДанныеФайла.ПолныйПуть);
		КонецЕсли;
		
		Если ФайлИзображенияНазначения.Существует() тогда
			ДанныеФайла.ПолныйПуть = КаталогВременныхФайлов + ДанныеФайла.Имя;
		Иначе
			ДанныеФайла.Пометка = Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
	ПередаваемыПараметры = Новый Структура;
	ПередаваемыПараметры.Вставить("ТаблицаФайлов"         , ТаблицаФайлов);
	ПередаваемыПараметры.Вставить("КаталогВременныхФайлов", КаталогВременныхФайлов);
	
	ОповеститьОВыборе(ПередаваемыПараметры);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещенияВыбратьКаталог(Каталог, ДополнительныеПараметры) Экспорт
	
	Если Не ПустаяСтрока(Каталог) Тогда 
		КаталогЗагрузки = Каталог;
		ОчиститьСообщения();
		ТаблицаФайлов.Очистить();
		ЗаполнитьТаблицуФайлов();
	КонецЕсли;
	
КонецПроцедуры
