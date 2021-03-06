
&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	Объект.Организация = ПолучитьЗначениеРеквизита(Объект.Подразделение, "Организация");
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьЗначениеРеквизита(Ссылка, Реквизит)
	Возврат Ссылка[Реквизит];
КонецФункции


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не РольДоступна("ПолныеПрава") Тогда
		Элементы.Ответственный.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЗаполнитьЕдИзм();
	КонецЕсли;
	
	УстановитьФорматПериодаПланирования();
	
КонецПроцедуры


&НаКлиенте
Процедура ПланРеагентПриИзменении(Элемент)
	УстановитьСписокНаправленийРасхода(Элементы.План.ТекущаяСтрока);
	ЗаполнитьЕдИзм(Элементы.План.ТекущаяСтрока);
КонецПроцедуры


&НаСервере
Процедура УстановитьСписокНаправленийРасхода(ТекущаяСтрокаИнд)
	
	ТекущаяСтрока = Объект.План.НайтиПоИдентификатору(ТекущаяСтрокаИнд);
		
	Элементы.ПланНаправлениеРасхода.СписокВыбора.Очистить();
	
	Если Не ЗначениеЗаполнено(ТекущаяСтрока.ВидРасхода) Тогда
		ТекущаяСтрока.НаправлениеРасхода = Неопределено;
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВидыРасходаРеагентовНаправленияРасхода.НаправлениеРасхода КАК НаправлениеРасхода,
	|	ВидыРасходаРеагентовНаправленияРасхода.НаправлениеРасхода.Представление КАК НаправлениеРасходаПредставление,
	|	ВидыРасходаРеагентовНаправленияРасхода.НаправлениеРасхода.ДиспетчерскоеНаименование КАК НаправлениеРасходаДиспетчерскоеНаименование
	|ИЗ
	|	Справочник.ВидыРасходаРеагентов.НаправленияРасхода КАК ВидыРасходаРеагентовНаправленияРасхода
	|ГДЕ
	|	ВидыРасходаРеагентовНаправленияРасхода.Ссылка = &Ссылка
	|	И ВидыРасходаРеагентовНаправленияРасхода.ВидРеагента = &ВидРеагента");
	Запрос.УстановитьПараметр("Ссылка", ТекущаяСтрока.ВидРасхода);
	Запрос.УстановитьПараметр("ВидРеагента", ТекущаяСтрока.Реагент.ВидРеагента);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Представление = Выборка.НаправлениеРасходаПредставление;
		Если Не ПустаяСтрока(Выборка.НаправлениеРасходаДиспетчерскоеНаименование) Тогда
			Представление = Представление + " (" + Выборка.НаправлениеРасходаДиспетчерскоеНаименование + ")"
		КонецЕсли;
		Элементы.ПланНаправлениеРасхода.СписокВыбора.Добавить(Выборка.НаправлениеРасхода, Представление);
	КонецЦикла;
	Если ЗначениеЗаполнено(ТекущаяСтрока.НаправлениеРасхода) 
		И Элементы.ПланНаправлениеРасхода.СписокВыбора.НайтиПоЗначению(ТекущаяСтрока.НаправлениеРасхода) = Неопределено 
		Тогда
		ТекущаяСтрока.НаправлениеРасхода = Неопределено;
	КонецЕсли;
	
КонецПроцедуры



&НаКлиенте
Процедура ПланВидРасходаПриИзменении(Элемент)
	УстановитьСписокНаправленийРасхода(Элементы.План.ТекущаяСтрока);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЕдИзм(ИДСтроки = Неопределено)
	
	Если ИДСтроки = Неопределено Тогда
		ВидРеагента = Новый Массив;
		Для Каждого Стр Из Объект.План Цикл
			ВидРеагента.Добавить(Стр.Реагент.ВидРеагента);
		КонецЦикла;
	Иначе
		ВидРеагента = Объект.План.НайтиПоИдентификатору(ИДСтроки).Реагент.ВидРеагента;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	БазовыеЕдиницыИзмеренияРеагентов.ЕдиницаИзмеренияКоличества КАК ЕдиницаИзмеренияКоличества,
	|	БазовыеЕдиницыИзмеренияРеагентов.ВидРеагента КАК ВидРеагента
	|ИЗ
	|	РегистрСведений.БазовыеЕдиницыИзмеренияРеагентов КАК БазовыеЕдиницыИзмеренияРеагентов
	|ГДЕ
	|	БазовыеЕдиницыИзмеренияРеагентов.ВидРеагента В(&ВидРеагента)");
	Запрос.УстановитьПараметр("ВидРеагента", ВидРеагента);
	
	ТабЕдиниц = Запрос.Выполнить().Выгрузить();
	
	Если ИДСтроки <> Неопределено Тогда
		Если ТабЕдиниц.Количество() > 0 Тогда
			Объект.План.НайтиПоИдентификатору(ИДСтроки).БазоваяЕдиницаИзмерения = ТабЕдиниц[0].ЕдиницаИзмеренияКоличества;
		Иначе
			Объект.План.НайтиПоИдентификатору(ИДСтроки).БазоваяЕдиницаИзмерения = Неопределено;
		КонецЕсли;
	Иначе
		Отбор = Новый Структура("ВидРеагента");
		Для Каждого Стр Из Объект.План Цикл
			Отбор.ВидРеагента = Стр.Реагент.ВидРеагента;
			Найденные = ТабЕдиниц.НайтиСтроки(Отбор);
			Если Найденные.Количество() > 0 Тогда
				Стр.БазоваяЕдиницаИзмерения = Найденные[0].ЕдиницаИзмеренияКоличества;
			Иначе
				Стр.БазоваяЕдиницаИзмерения = Неопределено;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФорматПериодаПланирования()
	Если Объект.Сценарий.ПериодПланирования = Перечисления.ПериодыПланирования.Год Тогда
		Элементы.ПланПериод.Формат = "ДФ=yyyy";
	ИначеЕсли Объект.Сценарий.ПериодПланирования = Перечисления.ПериодыПланирования.Месяц Тогда
		Элементы.ПланПериод.Формат = "ДФ='MMMM yyyy'";
	Иначе
		Элементы.ПланПериод.Формат = "";
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СценарийПриИзмененииНаСервере()
	
	УстановитьФорматПериодаПланирования();
	
	Если ЗначениеЗаполнено(Объект.Сценарий) Тогда
		Для Каждого Стр Из Объект.План Цикл
			Если Объект.Сценарий.ПериодПланирования = Перечисления.ПериодыПланирования.Год Тогда
				Стр.Период = НачалоГода(Стр.Период);
			ИначеЕсли Объект.Сценарий.ПериодПланирования = Перечисления.ПериодыПланирования.Месяц Тогда
				Стр.Период = НачалоМесяца(Стр.Период);
			КонецЕсли;			 
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СценарийПриИзменении(Элемент)
	СценарийПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПланПериодПриИзмененииНаСервере(ИДТекСтр)
	ТекСтр = Объект.План.НайтиПоИдентификатору(ИДТекСтр);
	Если Объект.Сценарий.ПериодПланирования = Перечисления.ПериодыПланирования.Год Тогда
		ТекСтр.Период = НачалоГода(ТекСтр.Период);
	ИначеЕсли Объект.Сценарий.ПериодПланирования = Перечисления.ПериодыПланирования.Месяц Тогда
		ТекСтр.Период = НачалоМесяца(ТекСтр.Период);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПланПериодПриИзменении(Элемент)
	ПланПериодПриИзмененииНаСервере(Элементы.План.ТекущаяСтрока);
КонецПроцедуры
