#Область ОписаниеПеременных

&НаКлиенте
Перем КлиентскиеПараметры Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ПерсональныеНастройки = ЭлектроннаяПодпись.ПерсональныеНастройки();
	СохранятьСертификатВместеСПодписью = ПерсональныеНастройки.СохранятьСертификатВместеСПодписью;
	СохранятьСертификатВместеСПодписьюИсходноеЗначение = СохранятьСертификатВместеСПодписью;
	
	СохранятьВсеПодписи = Параметры.СохранятьВсеПодписи;
	
	Если ЗначениеЗаполнено(Параметры.ЗаголовокДанных) Тогда
		Элементы.ПредставлениеДанных.Заголовок = Параметры.ЗаголовокДанных;
	Иначе
		Элементы.ПредставлениеДанных.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
	КонецЕсли;
	
	ПредставлениеДанных = Параметры.ПредставлениеДанных;
	Элементы.ПредставлениеДанных.Гиперссылка = Параметры.ПредставлениеДанныхОткрывается;
	
	Если Не ЗначениеЗаполнено(ПредставлениеДанных) Тогда
		Элементы.ПредставлениеДанных.Видимость = Ложь;
	КонецЕсли;
	
	Если Не Параметры.ПоказатьКомментарий Тогда
		Элементы.ТаблицаПодписейКомментарий.Видимость = Ложь;
	КонецЕсли;
	
	ЗаполнитьПодписи(Параметры.Объект);
	
	БольшеНеСпрашивать = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если СохранятьВсеПодписи Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеДанныхНажатие(Элемент, СтандартнаяОбработка)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПредставлениеДанныхНажатие(ЭтотОбъект,
		Элемент, СтандартнаяОбработка, КлиентскиеПараметры.ТекущийСписокПредставлений);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьПодпись(Команда)
	
	Если БольшеНеСпрашивать Или (СохранятьСертификатВместеСПодписью <> СохранятьСертификатВместеСПодписьюИсходноеЗначение)Тогда
		СохранитьНастройки(БольшеНеСпрашивать, СохранятьСертификатВместеСПодписью);
		ОбновитьПовторноИспользуемыеЗначения();
		Оповестить("Запись_ЛичныеНастройкиЭлектроннойПодписиИШифрования", Новый Структура, "ДействияПриСохраненииСЭП, СохранятьСертификатВместеСПодписью");
	КонецЕсли;
	
	Закрыть(ТаблицаПодписей);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ЭлектроннаяПодписьСлужебный.ОформитьСписокПодписей(ЭтотОбъект, "ТаблицаПодписей");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПодписи(Объект)
	
	Если ТипЗнч(Объект) = Тип("Строка") Тогда
		КоллекцияПодписей = ПолучитьИзВременногоХранилища(Объект);
	Иначе
		КоллекцияПодписей = ЭлектроннаяПодпись.УстановленныеПодписи(Объект);
	КонецЕсли;
	
	Для каждого ВсеСвойстваПодписи Из КоллекцияПодписей Цикл
		НоваяСтрока = ТаблицаПодписей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВсеСвойстваПодписи);
		
		НоваяСтрока.АдресПодписи = ПоместитьВоВременноеХранилище(
			ВсеСвойстваПодписи.Подпись, УникальныйИдентификатор);
			
		ДанныеСертификата = ВсеСвойстваПодписи.Сертификат.Получить();
		
		Если ТипЗнч(ДанныеСертификата) = Тип("Строка") Тогда
			НоваяСтрока.РасширениеСертификата = "txt";
			НоваяСтрока.АдресСертификата = ПоместитьВоВременноеХранилище(
				ДвоичныеДанныеСтроки(ДанныеСертификата), УникальныйИдентификатор);
		Иначе
			НоваяСтрока.РасширениеСертификата = "cer";
			НоваяСтрока.АдресСертификата = ПоместитьВоВременноеХранилище(
				ДанныеСертификата, УникальныйИдентификатор);
		КонецЕсли;
		НоваяСтрока.Пометка = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ДвоичныеДанныеСтроки(ДанныеСтроки)
	
	ВременныйФайл = ПолучитьИмяВременногоФайла();
	
	ЗаписьТекста = Новый ЗаписьТекста(ВременныйФайл, КодировкаТекста.UTF8);
	ЗаписьТекста.Записать(ДанныеСтроки);
	ЗаписьТекста.Закрыть();
	
	ДвоичныеДанныеСертификата = Новый ДвоичныеДанные(ВременныйФайл);
	
	УдалитьФайлы(ВременныйФайл);
	
	Возврат ДвоичныеДанныеСертификата;
	
КонецФункции

&НаСервереБезКонтекста
Процедура СохранитьНастройки(БольшеНеСпрашивать, СохранятьСертификатВместеСПодписью)
	
	ЧастьНастроек = Новый Структура;
	Если БольшеНеСпрашивать Тогда
		ЧастьНастроек.Вставить("ДействияПриСохраненииСЭП", "СохранятьВсеПодписи");
	КонецЕсли;
	ЧастьНастроек.Вставить("СохранятьСертификатВместеСПодписью", СохранятьСертификатВместеСПодписью);
	ЭлектроннаяПодписьСлужебный.СохранитьПерсональныеНастройки(ЧастьНастроек);
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

#КонецОбласти
