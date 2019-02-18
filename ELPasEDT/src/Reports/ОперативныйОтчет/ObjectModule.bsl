Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	// Получаем необходимую СКД.
	
	НеобходимаяСКД = Неопределено;
	Если ЭтотОбъект.ВидОтчета = 1 Тогда 
		НеобходимаяСКД = ЭтотОбъект.ПолучитьМакет("СКД_ОперативныйЖурнал");
	ИначеЕсли ЭтотОбъект.ВидОтчета = 2 Тогда
		НеобходимаяСКД = ЭтотОбъект.ПолучитьМакет("СКД_ХимРеагенты");
	ИначеЕсли ЭтотОбъект.ВидОтчета = 3 Тогда
		НеобходимаяСКД = ЭтотОбъект.ПолучитьМакет("СКД_ПриемСдачаСмены");
	КонецЕсли;
	
	// Устанавливаем выбранную СКД как основную.
	ЭтотОбъект.СхемаКомпоновкиДанных = НеобходимаяСКД;
	
	// Загружаем настройки выбранной СКД в компоновщик настроек.
	ИсточникДоступныхНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(НеобходимаяСКД); 
	ЭтотОбъект.КомпоновщикНастроек.Инициализировать(ИсточникДоступныхНастроек);
	ЭтотОбъект.КомпоновщикНастроек.ЗагрузитьНастройки(НеобходимаяСКД.НастройкиПоУмолчанию);
	
	// Устанавливаем настройки.
	ПараметрыДанных = ЭтотОбъект.КомпоновщикНастроек.Настройки.ПараметрыДанных;
	ПараметрНачПер = Новый ПараметрКомпоновкиДанных("НачалоПериода");
	ЗначениеНачПер = ПараметрыДанных.НайтиЗначениеПараметра(ПараметрНачПер);
	Если ЗначениеНачПер <> Неопределено Тогда 
		ПараметрыДанных.УстановитьЗначениеПараметра(ПараметрНачПер, НачалоДня(ЭтотОбъект.ДатаНач));
	КонецЕсли;

	
	ПараметрыДанных = ЭтотОбъект.КомпоновщикНастроек.Настройки.ПараметрыДанных;
	ПараметрКонПер = Новый ПараметрКомпоновкиДанных("КонецПериода");
	ЗначениеКонПер = ПараметрыДанных.НайтиЗначениеПараметра(ПараметрКонПер);
	Если ЗначениеКонПер <> Неопределено Тогда 
		ПараметрыДанных.УстановитьЗначениеПараметра(ПараметрКонПер, КонецДня(ЭтотОбъект.ДатаКон));
	КонецЕсли;
	
	//ПараметрВидЛица = Новый ПараметрКомпоновкиДанных("ЮрФизЛицо");
	//ЗначениеВидЛица = ПараметрыДанных.НайтиЗначениеПараметра(ПараметрВидЛица);
	//Если ЗначениеВидЛица <> Неопределено Тогда 
	//	ПараметрыДанных.УстановитьЗначениеПараметра(ПараметрВидЛица, ЭтотОбъект.ВидЛица);
	//КонецЕсли;
	//ПараметрыДанных = ЭтотОбъект.КомпоновщикНастроек.Настройки.ПараметрыДанных;
	//ПараметрТолькоНаОснСкладе = Новый ПараметрКомпоновкиДанных("НаОсновномСкладе");
	//ЗначениеТолькоНаОснСкладе = ПараметрыДанных.НайтиЗначениеПараметра(ПараметрТолькоНаОснСкладе);
	//Если ЗначениеТолькоНаОснСкладе <> Неопределено Тогда 
	//	ПараметрыДанных.УстановитьЗначениеПараметра(ПараметрТолькоНаОснСкладе, ЭтотОбъект.ТолькоНаОсновномСкладе);
	//КонецЕсли;
	
КонецПроцедуры
