
&НаСервере
Процедура ПартияПриИзмененииНаСервере()
	
	Объект.ВидРеагента   = Объект.Партия.ВидРеагента;
	Объект.Подразделение = Объект.Партия.Подразделение;
	Объект.Реагент       = Объект.Партия.Реагент;
	
КонецПроцедуры

&НаКлиенте
Процедура ПартияПриИзменении(Элемент)
	ПартияПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если Не РольДоступна("ПолныеПрава") И Не РольДоступна("ИнженерХВО") И Параметры.Свойство("ДокументПриемаСмены") 
			И Параметры.ДокументПриемаСмены <> Объект.ДокументПриемаСмены Тогда
			
			ТолькоПросмотр = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Свойство("КлючЗаписи") Тогда
		СтрокаЖурнала = Параметры.КлючЗаписи;
	КонецЕсли;
	
	Если РольДоступна("ПолныеПрава") Тогда
		Элементы.Ответственный.ТолькоПросмотр = Ложь;
	КонецЕсли;
	
	ЗаполнитьСписокНаправленийРасхода();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если СтрокаЖурнала <> Неопределено Тогда
		//Оповестить("ИзменениеСтроки", СтрокаЖурнала);
		Оповестить("ИзмененаЗаписьЖургала", Новый Структура("Подразделение, Ссылка", Объект.Подразделение, Объект.Ссылка));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокНаправленийРасхода(Очистить = Ложь)
	
	Если Очистить И СтрокаЖурнала <> Неопределено Тогда
		СтрокаЖурнала.НаправлениеРасхода = Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВидыРасходаРеагентовНаправленияРасхода.НаправлениеРасхода КАК НаправлениеРасхода,
	|	ПРЕДСТАВЛЕНИЕ(ВидыРасходаРеагентовНаправленияРасхода.НаправлениеРасхода) КАК НаправлениеРасходаПредставление,
	|	ВидыРасходаРеагентовНаправленияРасхода.НаправлениеРасхода.ДиспетчерскоеНаименование КАК НаправлениеРасходаДиспетчерскоеНаименование
	|ИЗ
	|	Справочник.ВидыРасходаРеагентов.НаправленияРасхода КАК ВидыРасходаРеагентовНаправленияРасхода
	|ГДЕ
	|	ВидыРасходаРеагентовНаправленияРасхода.Ссылка = &Ссылка
	|	И ВидыРасходаРеагентовНаправленияРасхода.ВидРеагента = &ВидРеагента");
	Запрос.УстановитьПараметр("Ссылка", Объект.ВидРасхода);
	Запрос.УстановитьПараметр("ВидРеагента", Объект.ВидРеагента);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Элементы.НаправлениеРасхода.СписокВыбора.Очистить();
	Пока Выборка.Следующий() Цикл
		Представление = Выборка.НаправлениеРасходаПредставление;
		Если Не ПустаяСтрока(Выборка.НаправлениеРасходаДиспетчерскоеНаименование) Тогда
			Представление = Представление + " (" + Выборка.НаправлениеРасходаДиспетчерскоеНаименование + ")"
		КонецЕсли;
		Элементы.НаправлениеРасхода.СписокВыбора.Добавить(Выборка.НаправлениеРасхода, Представление);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидРасходаПриИзменении(Элемент)
	ЗаполнитьСписокНаправленийРасхода();
	Объект.НаправлениеРасхода = Неопределено;
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Объект.Подразделение) Тогда
		Объект.Организация = ПолучитьЗначениеРеквизита(Объект.Подразделение, "Организация");
	Иначе
		Объект.Организация = Неопределено;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьЗначениеРеквизита(Ссылув, ИмяРеквизита)
	Возврат Ссылув[ИмяРеквизита];
КонецФункции

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
КонецПроцедуры

&НаКлиенте
Процедура РеагентПриИзменении(Элемент)
	Объект.ВидРеагента = ПолучитьЗначениеРеквизита(Объект.Реагент, "ВидРеагента");
	ЗаполнитьСписокНаправленийРасхода(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ВидРеагентаПриИзменении(Элемент)
	ЗаполнитьСписокНаправленийРасхода(Истина);
КонецПроцедуры

&НаСервере
Процедура ОборудованиеПриИзмененииНаСервере()
	
	Если Не ЗначениеЗаполнено(Объект.Оборудование) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ОборудованиеХимЦехаСрезПоследних.ВидРеагента КАК ВидРеагента,
	|	ОборудованиеХимЦехаСрезПоследних.Подразделение КАК Подразделение
	|ИЗ
	|	РегистрСведений.ОборудованиеХимЦеха.СрезПоследних(&Период, Оборудование = &Оборудование) КАК ОборудованиеХимЦехаСрезПоследних");
	Запрос.УстановитьПараметр("Период", Объект.Дата);
	Запрос.УстановитьПараметр("Оборудование", Объект.Оборудование);
	
	Выборка = запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Объект.ВидРеагента   = Выборка.ВидРеагента;
		Объект.Подразделение = Выборка.Подразделение;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Подразделение) Тогда
		Объект.Организация = ПолучитьЗначениеРеквизита(Объект.Подразделение, "Организация");
	Иначе
		Объект.Организация = Неопределено;
	КонецЕсли;
	
	ЗаполнитьСписокНаправленийРасхода(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОборудованиеПриИзменении(Элемент)
	ОборудованиеПриИзмененииНаСервере();
КонецПроцедуры
