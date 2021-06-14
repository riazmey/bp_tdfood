Function CommonTemplate() Export
	
	Return GetCommonTemplate("HTMLYandexMap").GetText();
	
EndFunction

Function CreatePointStruct(Name, Latitude, Longitude, OtherOptions = Undefined) Export
	
	IF TypeOf(Latitude) = Type("Число") THEN
		Lat = Format(Latitude, "ЧЦ=10; ЧДЦ=7; ЧРД=.; ЧРГ=");
	ELSIF TypeOf(Latitude) = Type("Строка") THEN
		Lat = Latitude;
	ELSE
		Return Undefined;
	ENDIF;
	
	IF TypeOf(Longitude) = Type("Число") THEN
		Lon = Format(Longitude, "ЧЦ=10; ЧДЦ=7; ЧРД=.; ЧРГ=");
	ELSIF TypeOf(Longitude) = Type("Строка") THEN
		Lon = Longitude;
	ELSE
		Return Undefined;
	ENDIF;

	
	Point = New Structure;
	Point.Insert("Name"     , Name);
	Point.Insert("Latitude" , Lat);
	Point.Insert("Longitude", Lon);
	
	IF NOT OtherOptions = Undefined THEN
		IF TypeOf(OtherOptions) = Type("Структура") THEN
			FOR EACH Options IN OtherOptions DO
				Point.Insert(Options.Key, Options.Value);
			ENDDO;
		ENDIF;
	ENDIF;
	
	Return Point;
	
EndFunction

Function CreatePointStructFromPartner(Partner, OtherOptions = Undefined) Export
	
	NewOtherOptions = New Structure;
	
	OptionsAddress = УправлениеКонтактнойИнформациейСлужебный.ДанныеАдресаДоставкиПоУмолчанию(Partner);
	
	If OptionsAddress = Undefined then
		Return Undefined;
	EndIf;
		
	NewOtherOptions.Insert("Address", OptionsAddress.ПредставлениеСокращенное);
	
	IF NOT OtherOptions = Undefined THEN
		IF TypeOf(OtherOptions) = Type("Структура") THEN
			FOR EACH Options IN OtherOptions DO
				NewOtherOptions.Insert(Options.Key, Options.Value);
			ENDDO;
		ENDIF;
	ENDIF;
	
	Return CreatePointStruct(String(Partner), OptionsAddress.Широта, OptionsAddress.Долгота, NewOtherOptions);
	
EndFunction