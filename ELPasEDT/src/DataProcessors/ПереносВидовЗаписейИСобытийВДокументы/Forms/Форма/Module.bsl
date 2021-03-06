
&НаСервере
Процедура ЗаполнитьТаблицуНаСервере()
	
	//Виды Записей
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВидыЗаписей.Ссылка КАК ВидЗаписи
		|ИЗ
		|	Справочник.ВидыЗаписей КАК ВидыЗаписей
		|ГДЕ
		|	НЕ ВидыЗаписей.ПометкаУдаления
		|	И НЕ ВидыЗаписей.Предопределенный
		|АВТОУПОРЯДОЧИВАНИЕ";
	
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	
	Объект.ВидыЗаписей.Загрузить(Запрос.Выполнить().Выгрузить());
	
	//Таблица
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ОперативныйЖурнал.ВидЗаписи КАК ВидЗаписи,
		|	ОперативныйЖурнал.Событие КАК Событие,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ОперативныйЖурнал.Ссылка) КАК Ссылка
		|ИЗ
		|	Документ.ОперативныйЖурнал КАК ОперативныйЖурнал
		|ГДЕ
		|	ОперативныйЖурнал.Проведен
		|	И НЕ ОперативныйЖурнал.ВидЗаписи.Предопределенный
		|	И НЕ ОперативныйЖурнал.Событие = ЗНАЧЕНИЕ(Справочник.События.ПустаяСсылка)
		|	И ОперативныйЖурнал.Подразделение.Организация = &Организация
		|
		|СГРУППИРОВАТЬ ПО
		|	ОперативныйЖурнал.ВидЗаписи,
		|	ОперативныйЖурнал.Событие
		|АВТОУПОРЯДОЧИВАНИЕ";
	
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	
	Объект.КПереносу.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтроки(ВидЗаписи)  
	
	Для Каждого ТекСтр Из ВидЗаписи.УдалитьСобытия Цикл
		Если ЗначениеЗаполнено(ТекСтр.Событие) Тогда
			НовСтр = Объект.КПереносу.Добавить();
			НовСтр.ВидЗаписи = ВидЗаписи;
			НовСтр.Событие = ТекСтр.Событие;
			НовСтр.Порядок = ТекСтр.НомерСтроки;
			НовСтр.СобытиеПоУмолчанию = ВидЗаписи.УдалитьСобытиеПоУмолчанию;
		КонецЕсли;
	КонецЦикла;
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТаблицу(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Организация) Тогда
		ПоказатьПредупреждение(, "Заполнение Организации обязательно!");
		Возврат;
	КонецЕсли;
	
	Если Объект.КПереносу.Количество() > 0 Тогда
		Оповещение = Новый ОписаниеОповещения("ОтветНаВопрос", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, "Таблица данных для переноса заполнена. Перезаполнить?", РежимДиалогаВопрос.ДаНет); 		
	КонецЕсли;
	Если Объект.КПереносу.Количество() > 0 Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьТаблицуНаСервере(); 	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветНаВопрос(Ответ, ДопПарамтеры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		Объект.КПереносу.Очистить();
		ЗаполнитьТаблицуНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьДокументыНаСервере()
	
	Для Каждого ТекСтр Из Объект.ВидыЗаписей Цикл
		СтрокиОтбора = Объект.КПереносу.НайтиСтроки(Новый Структура("ВидЗаписи", ТекСтр.ВидЗаписи));
		Если СтрокиОтбора.Количество() > 0 Тогда
			НовДок = НайтиДокумент(ТекСтр.ВидЗаписи);
			Если НовДок = Неопределено Тогда
				НовДок = СоздатьНовыйДокумент(ТекСтр.ВидЗаписи, СтрокиОтбора);
				СозданРанее = Ложь;
			Иначе
				СозданРанее = Истина;
			КонецЕсли;
			НовСтр = Объект.Документы.Добавить();
			НовСтр.Документ = НовДок;
			НовСтр.СозданРанее = СозданРанее;
		КонецЕсли;		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция СоздатьНовыйДокумент(ВидЗаписи, мСтроки)
	
	НовДок = Документы.ЗакреплениеВидаЗаписиИСобытийЗаПодразделением.СоздатьДокумент();
	НовДок.Дата = ТекущаяДата();
	НовДок.Организация = Объект.Организация;
	НовДок.Подразделение = Объект.Подразделение;
	НовДок.ВидЗаписи = ВидЗаписи;
	НовДок.СобытиеПоУмолчанию = мСтроки[0].Событие;
	НовДок.Комментарий = "Сформирован автоматически " + Формат(ТекущаяДата(), "ДЛФ=DD");
	
	Для Каждого ТекСтр Из мСтроки Цикл 
		НовСтр = НовДок.СписокСобытий.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр, ТекСтр);
		НовСтр.Порядок = ТекСтр.НомерСтроки;
	КонецЦикла;
	
	Попытка
		НовДок.Записать(РежимЗаписиДокумента.Запись);
		Возврат НовДок.Ссылка;
	Исключение
		Сообщить("Не удалось сформировать документ для вида записи " + ВидЗаписи);
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции

&НаСервере
Функция НайтиДокумент(ВидЗаписи)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗакреплениеВидаЗаписиИСобытийЗаПодразделением.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ЗакреплениеВидаЗаписиИСобытийЗаПодразделением КАК ЗакреплениеВидаЗаписиИСобытийЗаПодразделением
		|ГДЕ
		|	НЕ ЗакреплениеВидаЗаписиИСобытийЗаПодразделением.ПометкаУдаления
		|	И ЗакреплениеВидаЗаписиИСобытийЗаПодразделением.Подразделение = &Подразделение
		|	И ЗакреплениеВидаЗаписиИСобытийЗаПодразделением.ВидЗаписи = &ВидЗаписи";
	
	Запрос.УстановитьПараметр("ВидЗаписи", ВидЗаписи);
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	
	Результат = Запрос.Выполнить().Выбрать();
	
	Если Результат.Следующий() Тогда
		Возврат Результат.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура СформироватьДокументы(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Подразделение) Тогда
		ПоказатьПредупреждение(, "Заполнение Подразделения обязательно!");
		Возврат;
	КонецЕсли;
	
	Объект.Документы.Очистить();
	СформироватьДокументыНаСервере();
	
	Элементы.Панель.ТекущаяСтраница = Элементы.СформированныеДокументы;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветНаВопросОДокументах(Ответ, ДопПарамтеры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		Объект.Документы.Очистить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Объект.КПереносу.Очистить();
	Объект.Документы.Очистить();
	Объект.Подразделение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	Объект.Документы.Очистить();
	
КонецПроцедуры



