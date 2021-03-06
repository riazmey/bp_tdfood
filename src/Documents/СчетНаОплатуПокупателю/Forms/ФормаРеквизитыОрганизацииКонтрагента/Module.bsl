
&НаСервере
Процедура Базар_ЗаполнитьПодписиУполномоченныхЛицПослеНаСервере()
	
	ПодписиУполномоченныхЛиц = ОтветственныеЛицаБП.РеквизитыПодписиУполномоченныхЛиц(Организация,
	                                                                                 ПользователиКлиентСервер.ТекущийПользователь(),
	                                                                                 Неопределено,
	                                                                                 ДатаДокумента);
	
	ПодписиРуководитель = ПодписиУполномоченныхЛиц.Получить(ПредопределенноеЗначение("Перечисление.ОтветственныеЛицаОрганизаций.Руководитель"));
	ПодписиГлавныйБухгалтер = ПодписиУполномоченныхЛиц.Получить(ПредопределенноеЗначение("Перечисление.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер"));
	
	Руководитель = ПодписиРуководитель.ФизическоеЛицо;
	ЗаРуководителяНаОсновании = ПодписиРуководитель.ОснованиеПраваПодписи;
	ГлавныйБухгалтер = ПодписиГлавныйБухгалтер.ФизическоеЛицо;
	ЗаГлавногоБухгалтераНаОсновании = ПодписиГлавныйБухгалтер.ОснованиеПраваПодписи;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура Базар_ЗаполнитьПодписиУполномоченныхЛицПосле(Команда)
	
	Базар_ЗаполнитьПодписиУполномоченныхЛицПослеНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура Базар_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	Элементы.ЗаполнитьПодписиУполномоченныхЛиц.Доступность = НЕ ТолькоПросмотр;
	Элементы.Склад.Видимость = Ложь;
	
КонецПроцедуры
