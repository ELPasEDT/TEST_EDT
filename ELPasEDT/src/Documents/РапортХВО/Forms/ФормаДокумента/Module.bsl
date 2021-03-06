
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОперативныйЖурнал.ПриСозданииНаСервере(Объект.Ссылка, Элементы, Объект);
	
	//Проверка на созданный ранее документ
	//Если Объект.Ссылка.Пустая() Тогда
	//	СтруктураДанных = РапортСервер.ДокументУжеСоздан(Объект.Ссылка.Метаданные(), ТекущаяДата(), Объект.Подразделение);
	//	АдресХранилища = ПоместитьВоВременноеХранилище(СтруктураДанных, ЭтаФорма.УникальныйИдентификатор);
	//КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьНаСозданныйРанееДокумент()
	
	СтруктураДанных = РапортСервер.ДокументУжеСоздан(Объект.Ссылка.Метаданные(), Объект.Дата, Объект.Подразделение);
	АдресХранилища = ПоместитьВоВременноеХранилище(СтруктураДанных, ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Объект.Ссылка.Пустая() Тогда
		Объект.Дата = ТекущаяДата();
		ПроверитьНаСозданныйРанееДокумент();
		СтруктураДанных = ПолучитьИзВременногоХранилища(АдресХранилища);
		Если Не СтруктураДанных.ДокументРапорта = Неопределено Тогда
			Отказ = Истина;
			РапортКлиент.ПоказатьИнформациюПоРапорту(СтруктураДанных, ЭтаФорма);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
