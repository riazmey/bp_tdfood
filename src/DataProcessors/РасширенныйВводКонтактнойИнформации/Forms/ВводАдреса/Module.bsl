&НаКлиенте
Перем КоличествоКликовНаWebКарте;

&НаСервере
Процедура Базар_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("НаименованиеКонтрагента") тогда
		НаименованиеКонтрагента = Параметры.НаименованиеКонтрагента;
	Иначе
		НаименованиеКонтрагента = Неопределено;
	КонецЕсли;
	
	ДанныеАдреса = УправлениеКонтактнойИнформациейСлужебный.ДанныеАдресаДоставкиJSON(Параметры.Значение);
	Если ДанныеАдреса.АдресДоставкиСтруктура.Свойство("latitude")
		И ДанныеАдреса.АдресДоставкиСтруктура.Свойство("longitude") тогда
		Широта = ДанныеАдреса.АдресДоставкиСтруктура.latitude;
		Долгота = ДанныеАдреса.АдресДоставкиСтруктура.longitude;
	КонецЕсли;
	
	Если Параметры.Свойство("Контрагент") тогда
		Контрагент = Параметры.Контрагент;
	Иначе
		Контрагент = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Базар_ПриОткрытииПосле(Отказ)
	
	ФайловаяСистемаКлиент.СоздатьВременныйКаталог(Новый ОписаниеОповещения(
		"ОбработкаОповещенияСоздатьВременныйКаталогФормы"
		, ЭтаФорма));
	
КонецПроцедуры

&НаКлиенте
&После("ОбновитьПредставлениеАдреса")
Процедура Базар_ОбновитьПредставлениеАдресаПосле()
	
	InitWebMap();
	
	IF NOT WebMapStruct = Undefined Then
		StructReturned = WebMapClient.GeocodeAddress(Элементы.WEBКарта, WebMapStruct, ПредставлениеАдреса);
		Широта	= StructReturned.Latitude;
		Долгота	= StructReturned.Longitude;
		
		IF ValueIsFilled(Широта) AND ValueIsFilled(Долгота) Then
			Latitude  = Format(Широта , "ЧЦ=10; ЧДЦ=7; ЧРД=.; ЧРГ=");
			Longitude = Format(Долгота, "ЧЦ=10; ЧДЦ=7; ЧРД=.; ЧРГ=");
			WebMapClient.AddPlacemark(Элементы.WEBКарта,
			                    Latitude,
								Longitude,
								WebMapStruct.Color,
								WebMapStruct.TypeIcon,
								"Геокодированный адрес",
								ПредставлениеАдреса);
		EndIf;
	EndIf;
	
	КоличествоКликовНаWebКарте = 0;
	
КонецПроцедуры

&НаКлиенте
&Перед("КомандаОК")
Процедура Базар_КомандаОК(Команда)
	НаселенныйПунктДетально.Вставить("latitude", Формат(Широта, "ЧЦ=15; ЧДЦ=12; ЧРД=."));
	НаселенныйПунктДетально.Вставить("longitude", Формат(Долгота, "ЧЦ=15; ЧДЦ=12; ЧРД=."));
КонецПроцедуры

&НаКлиенте
Procedure InitWebMap()
	
	IF StrLen(ПредставлениеАдреса) < 20 Then
		Широта = 0;
		Долгота = 0;
	EndIf;
	
	IF АдресВведенВСвободнойФорме() Then
		WebMapClient.HTMLMessage(WebMapПолеHTML,
                           "Для успешной работы с Web картами, выберите адрес Российского происхождения!",
		                   "#2F4F4F");
		WebMapStruct = Undefined;
		Return;
	EndIf;
	
	IF (Широта = 0 или Долгота = 0) И СтрДлина(ПредставлениеАдреса) < 20 Then
		WebMapClient.HTMLMessage(WebMapПолеHTML,
                           "Координаты точки не определены!<br>Отображение карты невозможно.",
		                   "#FFA07A");
		WebMapStruct = Undefined;
		Return;
	EndIf;
	
	IF NOT WebMapStruct = Undefined Then
		Return;
	EndIf;
	
	NamePartner = ?(ValueIsFilled(НаименованиеКонтрагента), НаименованиеКонтрагента, "Адрес геоточки");
	
	GeocodeAddress = False;
	IF NOT ValueIsFilled(Широта) AND NOT ValueIsFilled(Долгота) Then
		GeocodeAddress = True;
	EndIf;
	
	LatCenter = ?(ValueIsFilled(Широта) , Format(Широта , "ЧЦ=10; ЧДЦ=7; ЧРД=.; ЧРГ="), "45.058262");
	LonCenter = ?(ValueIsFilled(Долгота), Format(Долгота, "ЧЦ=10; ЧДЦ=7; ЧРД=.; ЧРГ="), "38.982607");
	WebMapStruct = WebMapClient.CreateStruct("Геопозиционирование адреса", "e041936b-a266-4a20-8e94-d0d7ffef7ec4", , LatCenter, LonCenter, КаталогВременныхФайловДокумента);
	
	IF GeocodeAddress AND NOT WebMapStruct = Undefined Then
		StructReturned = WebMapClient.GeocodeAddress(Элементы.WEBКарта, WebMapStruct, ПредставлениеАдреса);
		Широта	= StructReturned.Latitude;
		Долгота	= StructReturned.Longitude;
		LatCenter = ?(ValueIsFilled(Широта) , Format(Широта , "ЧЦ=10; ЧДЦ=7; ЧРД=.; ЧРГ="), "45.058262");
		LonCenter = ?(ValueIsFilled(Долгота), Format(Долгота, "ЧЦ=10; ЧДЦ=7; ЧРД=.; ЧРГ="), "38.982607");
		WebMapStruct = WebMapClient.CreateStruct("Геопозиционирование адреса", "e041936b-a266-4a20-8e94-d0d7ffef7ec4", , LatCenter, LonCenter, КаталогВременныхФайловДокумента);
		ЭтаФорма.Modified = True;
	EndIf;
	
	IF WebMapStruct = Undefined THEN
		Return;
	ENDIF;
	
	HTMLTemplatesWebMap = HTMLTemplatesWebMap();
	
	WebMapStruct.Insert("NamePartner" , NamePartner);
	WebMapStruct.Insert("Address"     , ПредставлениеАдреса);
	WebMapStruct.Insert("Color"       , WebMapStruct.ColorPalette.Get("red"));
	WebMapStruct.Insert("TypeIcon"    , WebMapStruct.IconsСollection.islandsdot.Get("red"));
	WebMapStruct.Insert("HTMLTextMap" , WebMapServer.CommonTemplate());
	WebMapStruct.Insert("HTMLTextInit", HTMLTemplatesWebMap.HTMLTextInit);
	WebMapStruct.Insert("HTMLTextBody", HTMLTemplatesWebMap.HTMLTextBody);

	WebMapClient.PrepareHTMLTextGeocodeAddress(WebMapStruct);	
	WebMapПолеHTML = WebMapStruct.HTMLText;
	
EndProcedure

&НаСервере
Function HTMLTemplatesWebMap()
	
	ReturnedStruct = New Structure;
	
	ObjectOnForm = FormAttributeToValue("Объект");
	HTMLTextInit = ObjectOnForm.GetTemplate("HTMLYandexMap_function_init").GetText();
	HTMLTextBody = ObjectOnForm.GetTemplate("HTMLYandexMap_body").GetText();
	
	ReturnedStruct.Вставить("HTMLTextInit", HTMLTextInit);
	ReturnedStruct.Вставить("HTMLTextBody", HTMLTextBody);
	
	Return ReturnedStruct;
	
EndFunction

&НаСервере
Функция АдресВведенВСвободнойФорме()
	Возврат УправлениеКонтактнойИнформациейСлужебный.АдресВведенВСвободнойФорме(НаселенныйПунктДетально);
КонецФункции

&НаКлиенте
Процедура WEBКартаПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	Если КоличествоКликовНаWebКарте = Неопределено тогда
		КоличествоКликовНаWebКарте = 1;
	Иначе
		КоличествоКликовНаWebКарте = КоличествоКликовНаWebКарте + 1;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("WEBКартаПриДвойномНажатии", 0.25, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура WEBКартаПриДвойномНажатии()
	
	Если КоличествоКликовНаWebКарте <= 1 тогда
		КоличествоКликовНаWebКарте = 0;
		Возврат;
	КонецЕсли;
	
	Если АдресВведенВСвободнойФорме() тогда
		Возврат;
	КонецЕсли;
	
	Если WebMapStruct = Неопределено тогда
		Возврат;
	КонецЕсли;
	
	StructReturned = WebMapClient.GetCoordsOnMap(Элементы.WEBКарта);
	WebMapClient.AddPlacemark(Элементы.WEBКарта,
	                    StructReturned.Latitude,
						StructReturned.Longitude,
						WebMapStruct.Color,
						WebMapStruct.TypeIcon,
						?(ЗначениеЗаполнено(Контрагент), Строка(Контрагент), "Геокодированный адрес"),
						ПредставлениеАдреса);
	
	Широта	= StructReturned.Latitude;
	Долгота	= StructReturned.Longitude;
	
	Модифицированность = Истина;
	КоличествоКликовНаWebКарте = 0;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещенияСоздатьВременныйКаталогФормы(ИмяКаталогаВременныхФайлов, ДополнительныеПараметры) Экспорт
	
	КаталогВременныхФайловДокумента = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ИмяКаталогаВременныхФайлов);
	
	WebMapStruct = Неопределено;
	
	InitWebMap();
	
	Если НЕ ЗначениеЗаполнено(Широта)И НЕ ЗначениеЗаполнено(Долгота) тогда
		ОбновитьПредставлениеАдреса();
	КонецЕсли;
	
КонецПроцедуры
