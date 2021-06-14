Function TextLinuxScript(NameScript) Export
	
	DataProcessors_LinuxScripts = DataProcessors.LinuxScripts.Create();
	Template = DataProcessors_LinuxScripts.GetTemplate(NameScript);
	
	Try
		Return Template.GetText();
	Except
		Return "";
	EndTry;
	
EndFunction