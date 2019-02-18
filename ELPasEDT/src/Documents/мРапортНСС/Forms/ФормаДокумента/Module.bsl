
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОперативныйЖурнал.ПриСозданииНаСервере(Объект.Ссылка, Элементы, Объект);
	
	ПолучитьДанныеРегистраНастроек();
	ПолучитьДанныеРегистраНастроекШапка();
	
	//дорбавим 1 строку в шапку
	Если Объект.Ссылка.Пустая() Тогда
		НовСтр = Объект.ПоказателиШапки.Добавить();
	КонецЕсли;
	
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
		Если Тип(ЭлементФормы) = Тип("ПолеФормы") И ТипЗнч(ЭлементФормы.Родитель) = Тип("ТаблицаФормы") Тогда
			Если ЭлементФормы.Родитель.Имя = "ПоказателиШапки" Тогда
				Для инд = 1 По 15 Цикл
					Если ЭлементФормы.Имя = "ПоказателиШапкиЗначениеПоказателя" + инд Тогда
						СтруктураПараметра = ПолучитьНастройкиРегистраШапка("ЗначениеПоказателя" + инд);
						Если СтруктураПараметра.Количество() = 0 Тогда
							ЭлементФормы.Видимость = Ложь;
						Иначе 				
							ЭлементФормы.Видимость = Истина;
							ЭлементФормы.Заголовок = СтруктураПараметра.Синоним;
						КонецЕсли;				
					КонецЕсли;
				КонецЦикла;
			ИначеЕсли ЭлементФормы.Родитель.Имя = "ЗначенияПоказателей" Тогда
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

&НаКлиенте
Функция ПолучитьНастройкиРегистраШапка(ИмяПоказателя)
	
	СтруктураПараметра = Новый Структура;
	
	Для Каждого ТекСтр Из ДанныеРегистраНастроекШапка Цикл
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
		|	НастройкаЗначенийПоказателейНСС.ЗначениеПоказателя КАК ЗначениеПоказателя,
		|	НастройкаЗначенийПоказателейНСС.Синоним КАК Синоним,
		|	НастройкаЗначенийПоказателейНСС.ТипЗначения КАК ТипЗначения
		|ИЗ
		|	РегистрСведений.НастройкаЗначенийПоказателейНСС КАК НастройкаЗначенийПоказателейНСС
		|ГДЕ
		|	НастройкаЗначенийПоказателейНСС.Организация = &Организация";
	
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	
	ДанныеРегистраНастроек.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецФункции

&НаСервере
Функция ПолучитьДанныеРегистраНастроекШапка()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкаЗначенийПоказателейНССШапка.ЗначениеПоказателя КАК ЗначениеПоказателя,
		|	НастройкаЗначенийПоказателейНССШапка.Синоним КАК Синоним,
		|	НастройкаЗначенийПоказателейНССШапка.ТипЗначения КАК ТипЗначения
		|ИЗ
		|	РегистрСведений.НастройкаЗначенийПоказателейНССШапка КАК НастройкаЗначенийПоказателейНССШапка
		|ГДЕ
		|	НастройкаЗначенийПоказателейНССШапка.Организация = &Организация";
	
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	
	ДанныеРегистраНастроекШапка.Загрузить(Запрос.Выполнить().Выгрузить());
	
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
Процедура ЗначениеПоказателяШапкаНачалоВыбора(Элемент, инд)
	
	ТипЗначения = ПолучитьНастройкиРегистраШапка("ЗначениеПоказателя" + инд).ТипЗначения;
	
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

&НаКлиенте
Процедура ПоказателиШапкиЗначениеПоказателя1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗначениеПоказателяШапкаНачалоВыбора(Элемент, 1);
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиШапкиЗначениеПоказателя2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗначениеПоказателяШапкаНачалоВыбора(Элемент, 2);
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиШапкиЗначениеПоказателя3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗначениеПоказателяШапкаНачалоВыбора(Элемент, 3);
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиШапкиЗначениеПоказателя4НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗначениеПоказателяШапкаНачалоВыбора(Элемент, 4);
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиШапкиЗначениеПоказателя5НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗначениеПоказателяШапкаНачалоВыбора(Элемент, 5);
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиШапкиЗначениеПоказателя6НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗначениеПоказателяШапкаНачалоВыбора(Элемент, 6);
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиШапкиЗначениеПоказателя7НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗначениеПоказателяШапкаНачалоВыбора(Элемент, 7);
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиШапкиЗначениеПоказателя8НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗначениеПоказателяШапкаНачалоВыбора(Элемент, 8);
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиШапкиЗначениеПоказателя9НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗначениеПоказателяШапкаНачалоВыбора(Элемент, 9);
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиШапкиЗначениеПоказателя10НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗначениеПоказателяШапкаНачалоВыбора(Элемент, 10);
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиШапкиЗначениеПоказателя11НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗначениеПоказателяШапкаНачалоВыбора(Элемент, 11);
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиШапкиЗначениеПоказателя12НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗначениеПоказателяШапкаНачалоВыбора(Элемент, 12);
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиШапкиЗначениеПоказателя13НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗначениеПоказателяШапкаНачалоВыбора(Элемент, 13);
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиШапкиЗначениеПоказателя14НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗначениеПоказателяШапкаНачалоВыбора(Элемент, 14);
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиШапкиЗначениеПоказателя15НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗначениеПоказателяШапкаНачалоВыбора(Элемент, 15);
КонецПроцедуры










