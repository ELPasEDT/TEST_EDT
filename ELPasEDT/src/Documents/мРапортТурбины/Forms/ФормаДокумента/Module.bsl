
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОперативныйЖурнал.ПриСозданииНаСервере(Объект.Ссылка, Элементы, Объект);
	
	ПолучитьДанныеРегистраНастроек();
	
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
	
	НастроитьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьФорму()
	
	Для Каждого ЭлементФормы Из ЭтаФорма.Элементы Цикл
		Если Тип(ЭлементФормы) = Тип("ПолеФормы") Тогда
			Для инд = 1 По 15 Цикл
				Если ЭлементФормы.Имя = "ЗначениеПоказателя" + инд Тогда
					СтруктураПараметра = ПолучитьНастройкиРегистра(ЭлементФормы.Имя);
					Если СтруктураПараметра.Количество() = 0 Тогда
						ЭлементФормы.Видимость = Ложь;
					Иначе 				
						ЭлементФормы.Видимость = Истина;
						ЭлементФормы.Заголовок = СтруктураПараметра.Синоним;
					КонецЕсли;				
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьНастройкиРегистра(ИмяПоказателя)
	
	СтруктураПараметра = Новый Структура;
	
	Для Каждого ТекСтр Из ДанныеРегистраНастроек Цикл
		Если ТекСтр.ЗначениеПоказателя = ИмяПоказателя Тогда
			СтруктураПараметра.Вставить("Синоним", ТекСтр.Синоним);
			СтруктураПараметра.Вставить("ТипЗначения", ТекСтр.ТипЗначения);
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтруктураПараметра;
	
КонецФункции

&НаСервере
Функция ПолучитьДанныеРегистраНастроек()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкаЗначенийПоказателейТурбины.ЗначениеПоказателя КАК ЗначениеПоказателя,
		|	НастройкаЗначенийПоказателейТурбины.Синоним КАК Синоним,
		|	НастройкаЗначенийПоказателейТурбины.ТипЗначения КАК ТипЗначения
		|ИЗ
		|	РегистрСведений.НастройкаЗначенийПоказателейТурбины КАК НастройкаЗначенийПоказателейТурбины
		|ГДЕ
		|	НастройкаЗначенийПоказателейТурбины.Организация = &Организация";
	
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	
	ДанныеРегистраНастроек.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецФункции

&НаКлиенте
Процедура ЗначениеПоказателяНачалоВыбора(Элемент)
	
	ТипЗначения = ПолучитьНастройкиРегистра(Элемент.Имя).ТипЗначения;
	
	Если ТипЗнч(ТипЗначения) = Тип("Строка") Тогда
		Элемент.ОграничениеТипа = Новый ОписаниеТипов("Строка");
	ИначеЕсли ТипЗнч(ТипЗначения) = Тип("Число") Тогда
		КвалификаторыЧисла = Новый КвалификаторыЧисла(10, 2, ДопустимыйЗнак.Любой);
		Элемент.ОграничениеТипа = Новый ОписаниеТипов("Число", КвалификаторыЧисла);
	ИначеЕсли ТипЗнч(ТипЗначения) = Тип("Дата") Тогда
		Элемент.ОграничениеТипа = Новый ОписаниеТипов("Дата");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеПоказателя1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗначениеПоказателяНачалоВыбора(Элемент);
КонецПроцедуры  

&НаКлиенте
Процедура ЗначениеПоказателя2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)  	
	ЗначениеПоказателяНачалоВыбора(Элемент);
КонецПроцедуры 

&НаКлиенте
Процедура ЗначениеПоказателя3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗначениеПоказателяНачалоВыбора(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеПоказателя4НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗначениеПоказателяНачалоВыбора(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеПоказателя5НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗначениеПоказателяНачалоВыбора(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеПоказателя6НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗначениеПоказателяНачалоВыбора(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеПоказателя7НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗначениеПоказателяНачалоВыбора(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеПоказателя8НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗначениеПоказателяНачалоВыбора(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеПоказателя9НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗначениеПоказателяНачалоВыбора(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеПоказателя10НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗначениеПоказателяНачалоВыбора(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеПоказателя11НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗначениеПоказателяНачалоВыбора(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеПоказателя12НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗначениеПоказателяНачалоВыбора(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеПоказателя13НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗначениеПоказателяНачалоВыбора(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеПоказателя14НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗначениеПоказателяНачалоВыбора(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеПоказателя15НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗначениеПоказателяНачалоВыбора(Элемент);
КонецПроцедуры










