&Вместо("ОпределитьНастройкиФормы")
Процедура Базар_ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
	
	СхемаКомпоновкиДанных = ПолучитьМакет("Базар_СхемаКомпоновкиДанных");
	
КонецПроцедуры
