Function ExecuteTemplateLinuxScript(NameScript, Val Directory = Undefined, Options = Undefined) Export
	
	TextScript = LinuxScriptsServer.TextLinuxScript(NameScript);
	
	If NOT ValueIsFilled(TextScript) then
		Return Undefined;
	EndIf;
	
	If NOT TypeOf(Options) = Type("Structure") then
		Options = New Structure;
	EndIf;
	
	Options.Insert("NameScript", NameScript);
	Options.Insert("TextScript", TextScript);
	Options.Insert("DeleteDirectory", Directory = Undefined);	
	
	If Directory = Undefined then
		Directory = CreateTemporaryDirectory("shell");
	EndIf;
	CreateAndExecuteLinuxScript(Directory, Options);
	
EndFunction

Procedure CreateAndExecuteLinuxScript(Directory, Options) Export
	
	Directory = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(Directory);
	
	TextScript = Options.TextScript;
	NameFile = Options.NameScript + ".sh";
	FullNameFile = Directory + NameFile;
	
	If NOT CreateExecutableFile(Directory, NameFile, TextScript) then
		Return;
	EndIf;
	
	StringArguments = "";
	If Options.Property("Arguments") then
		StringArguments = " " + Options.Arguments;
	EndIf;
	
	RunApp(FullNameFile + StringArguments, Directory, True);
	
	If Options.DeleteDirectory then
		BeginDeletingFiles(New NotifyDescription(
			"ProcessingDeletingFiles"
			, LinuxScriptsClient)
			, Directory);
	EndIf;
	
EndProcedure

Procedure ProcessingDeletingFiles(Options) Export
	
EndProcedure

Function CreateTemporaryDirectory(Extension)
	
	Directory = "v8_" + String(New UUID);
	
	If NOT IsBlankString(Extension) then
		Directory = Directory + "." + Extension;
	EndIf;
	
	CreateDirectory(TempFilesDir() + Directory);
	
	Return TempFilesDir() + Directory; 
	
EndFunction

Function CreateExecutableFile(Directory, NameFile, TextScript)
	
	FullNameFile = Directory + NameFile;
	
	File = New File(FullNameFile);
	If File.Exist() then
		System("chmod 700 " + FullNameFile, Directory);
		Return True;
	EndIf;
	
	Try
		// Create file whith BOM
		ShellFileUTF8_BOM = New TextDocument();
		ShellFileUTF8_BOM.AddLine(TextScript);
		ShellFileUTF8_BOM.Записать(FullNameFile, "UTF-8");
		
		// Remove all BOM symbols
		BinaryData = New BinaryData(FullNameFile);
		String64 = Base64String(BinaryData);
		String64 = Right(String64,StrLen(String64)-4);
		DataToRecord = Base64Value(String64);
		DataToRecord.Write(FullNameFile);
		
		// Remove ^M symbols (symbol - new string)
		System("sed -i -e 's/\r$//' """ + FullNameFile + """", Directory);
	Except
		Return False;
	EndTry;
	
	System("chmod 700 " + FullNameFile, Directory);
	
	Return True;
	
EndFunction