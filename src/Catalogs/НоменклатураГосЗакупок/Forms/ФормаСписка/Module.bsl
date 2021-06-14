
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ТекущаяДатаПользователя = ОбщегоНазначения.ТекущаяДатаПользователя();
	
	Для Каждого ВидСтавки Из Перечисления.ВидыСтавокНДС Цикл
		
		ЭлементУО = УсловноеОформление.Элементы.Добавить();

		КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ВидСтавкиНДС");

		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
			"Список.ВидСтавкиНДС", ВидСравненияКомпоновкиДанных.Равно, ВидСтавки);

		ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст",
			Строка(Перечисления.СтавкиНДС.СтавкаНДС(ВидСтавки, ТекущаяДатаПользователя)));
		
	КонецЦикла;
	
КонецПроцедуры