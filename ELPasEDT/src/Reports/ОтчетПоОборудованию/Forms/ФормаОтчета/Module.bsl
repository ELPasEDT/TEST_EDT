
&НаКлиенте
Процедура ВидОборудованияПриИзменении(Элемент)
	
	//Отчет.КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы[0].Элементы.[0]
	//Отчет.КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы[0].Элементы[0].Поле
	
	ЗаполнитьВыбранныеПоля();
	УстановитьОбновитьОтбор();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсеРеквизиты(Команда)
	
	Для Каждого ТекСотрока Из ВыбранныеПооля Цикл
		ТекСотрока.Выбор = Истина;
		ОбновитьДобавитьПолеОтчета(ТекСотрока.Реквизит, ТекСотрока.Выбор);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВыборВсехРеквизитов(Команда)
	
	Для Каждого ТекСотрока Из ВыбранныеПооля Цикл
		ТекСотрока.Выбор = Ложь;
		ОбновитьДобавитьПолеОтчета(ТекСотрока.Реквизит, ТекСотрока.Выбор);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СформироватьЗаголовокРеквизита(РеквизитНаименование, Заголовок, ЕдиницаИзмеренияПредставление = "")
	
	ЗаголовокРеквизита = РеквизитНаименование;
	
	Если Не ПустаяСтрока(Заголовок) Тогда
		ЗаголовокРеквизита = Заголовок;
	КонецЕсли;
	
	Если Не ПустаяСтрока(ЕдиницаИзмеренияПредставление) Тогда
		ЗаголовокРеквизита = ЗаголовокРеквизита + ", " + ЕдиницаИзмеренияПредставление;
	КонецЕсли;
	
	Возврат ЗаголовокРеквизита;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьВыбранныеПоля()
	
	///////////////////////////////////////////////////////////////////////////////
	// Очистим настройки компоновщика
	
	ВыбранныеПооля.Очистить();
	
	ФиксированныеПоля = Новый Массив;
	ФиксированныеПоля.Добавить(Новый ПолеКомпоновкиДанных("СистемныеПоля.НомерПоПорядку"));
	ФиксированныеПоля.Добавить(Новый ПолеКомпоновкиДанных("Оборудование"));
	
	КоличПолей = Отчет.КомпоновщикНастроек.Настройки.Выбор.Элементы.Количество();
	Для Инд = 1 По КоличПолей Цикл
		ОбрИнд = КоличПолей - Инд;
		Элемент = Отчет.КомпоновщикНастроек.Настройки.Выбор.Элементы[ОбрИнд];
		Если ФиксированныеПоля.Найти(Элемент.Поле) = Неопределено Тогда
			Отчет.КомпоновщикНастроек.Настройки.Выбор.Элементы.Удалить(Элемент);
		КонецЕсли;
	КонецЦикла;
	
	///////////////////////////////////////////////////////////////////////////////
	// Заполн7им настройки компоновщика
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВидыОборудованияРеквизитыПаспорта.Реквизит КАК Реквизит,
	|	ВидыОборудованияРеквизитыПаспорта.Заголовок КАК Заголовок,
	|	ВидыОборудованияРеквизитыПаспорта.Реквизит.ЕдиницаИзмерения КАК РеквизитЕдиницаИзмерения,
	|	ПРЕДСТАВЛЕНИЕ(ВидыОборудованияРеквизитыПаспорта.Реквизит) КАК РеквизитПредставление,
	|	ПРЕДСТАВЛЕНИЕ(ВидыОборудованияРеквизитыПаспорта.Реквизит.ЕдиницаИзмерения) КАК ЕдиницаИзмеренияПредставление
	|ИЗ
	|	Справочник.ВидыОборудования.РеквизитыПаспорта КАК ВидыОборудованияРеквизитыПаспорта
	|ГДЕ
	|	ВидыОборудованияРеквизитыПаспорта.Ссылка = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", Отчет.ВидОборудования);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ТипРеквизита = ТипЗнч(Выборка.Реквизит);
		
		Если ТипРеквизита = Тип("ПланВидовХарактеристикСсылка.РеквизитыПаспортовОборудования") Тогда
			НовСтр = ВыбранныеПооля.Добавить();
			НовСтр.Выбор = Истина;
			НовСтр.Реквизит = Выборка.Реквизит;
			ОбновитьДобавитьПолеОтчета(Выборка.Реквизит);
		ИначеЕсли ТипРеквизита = Тип("СправочникСсылка.ГруппыКолонокПаспорта") Тогда
			Для Каждого Стр Из Выборка.Реквизит.РеквизитыГруппы Цикл
				НовСтр = ВыбранныеПооля.Добавить();
				НовСтр.Выбор = Истина;
				НовСтр.Реквизит = Стр.Реквизит;
				ОбновитьДобавитьПолеОтчета(Стр.Реквизит);
			КонецЦикла;
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДобавитьПолеОтчета(Реквизит, Выбор = Истина)
	
	ПутьКДанным = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Оборудование.[%1]", Реквизит);
	Поле = Новый ПолеКомпоновкиДанных(ПутьКДанным);
	
	РеквизитОбработан = Ложь;
	
	Для Каждого Элемент Из Отчет.КомпоновщикНастроек.Настройки.Выбор.Элементы Цикл
		Если Элемент.Поле = Поле Тогда
			Элемент.Использование = Выбор;
			РеквизитОбработан = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Не РеквизитОбработан Тогда
		Элемент = Отчет.КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		Элемент.Поле = Поле;
		Элемент.Использование = Выбор;
		Элемент.Заголовок = Реквизит;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеПооляВыборПриИзменении(Элемент)
	
	ТекСотрока = Элементы.ВыбранныеПооля.ТекущиеДанные;
	ОбновитьДобавитьПолеОтчета(ТекСотрока.Реквизит, ТекСотрока.Выбор);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОбновитьОтбор()
	
	///////////////////////////////////////////////////////////////////////////////
	// Очистим отбор
	
	Поле          = Новый ПолеКомпоновкиДанных("Оборудование.ВидОборудования");
	ЭлементОтбора = Неопределено;
	
	КоличЭлементовОтбора = Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы.Количество();
	Для Инд = 1 По КоличЭлементовОтбора Цикл
		
		ОбрИнд = КоличЭлементовОтбора - Инд;
		Элемент = Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы[ОбрИнд];

		Если Элемент.ЛевоеЗначение = Поле Тогда
			ЭлементОтбора = Элемент;
		Иначе
			Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы.Удалить(Элемент);
		КонецЕсли;
	КонецЦикла;
	
	///////////////////////////////////////////////////////////////////////////////
	// Основной отбор - по виду оборудования
	
	Если ЭлементОтбора = Неопределено Тогда
		ЭлементОтбора = Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Поле;
	КонецЕсли;
	
	ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение   = Отчет.ВидОборудования;
	ЭлементОтбора.Использование    = Истина;
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	
	///////////////////////////////////////////////////////////////////////////////
	// Дополнительный отбор по подразделению
	
	Поле          = Новый ПолеКомпоновкиДанных("Оборудование.Подразделение");
	ЭлементОтбора = Неопределено;
	
	Для Каждого Элемент Из Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
		Если Элемент.ЛевоеЗначение = Поле Тогда
			ЭлементОтбора = Элемент;
		КонецЕсли;
	КонецЦикла;
	
	Если ЭлементОтбора = Неопределено Тогда
		ЭлементОтбора = Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		
		ЭлементОтбора.ЛевоеЗначение    = Поле;
		ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование    = Ложь;
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
	КонецЕсли;
	
	///////////////////////////////////////////////////////////////////////////////
	// Дополнительные отборы по значениям реквизитов паспорта
	
	ИсклПоле = Новый ПолеКомпоновкиДанных("СистемныеПоля.НомерПоПорядку");
	
	Для Каждого Элемент Из Отчет.КомпоновщикНастроек.Настройки.Выбор.Элементы Цикл
		Если Элемент.Поле = ИсклПоле Тогда
			Продолжить;
		КонецЕсли;
		ЭлементОтбора = Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Элемент.Поле;
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование = Ложь;
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
	КонецЦикла;
	
КонецПроцедуры