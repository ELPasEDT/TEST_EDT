#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнитьОбъектЗначениямиПоУмолчанию();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Не ИспользоватьДляОтправки И Не ИспользоватьДляПолучения Тогда
		ПроверяемыеРеквизиты.Очистить();
		ПроверяемыеРеквизиты.Добавить("Наименование");
		Возврат;
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не ИспользоватьДляОтправки Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СерверИсходящейПочты");
	КонецЕсли;
	
	Если Не ИспользоватьДляПолучения Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СерверВходящейПочты");
	КонецЕсли;
		
	Если Не ПустаяСтрока(АдресЭлектроннойПочты) И Не ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(АдресЭлектроннойПочты, Истина) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Почтовый адрес заполнен неверно.'"), ЭтотОбъект, "АдресЭлектроннойПочты");
		МассивНепроверяемыхРеквизитов.Добавить("АдресЭлектроннойПочты");
		Отказ = Истина;
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ОбщегоНазначения.УдалитьДанныеИзБезопасногоХранилища(Ссылка);
	УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.Свойство("НеПроверятьИзменениеНастроек") И Не Ссылка.Пустая() Тогда
		
		СписокРеквизитов = "ИспользоватьДляОтправки,ИспользоватьДляПолучения,СерверВходящейПочты,СерверИсходящейПочты,ВладелецУчетнойЗаписи,ИспользоватьЗащищенноеСоединениеДляВходящейПочты,ИспользоватьЗащищенноеСоединениеДляИсходящейПочты,ИспользоватьБезопасныйВходНаСерверВходящейПочты,ИспользоватьБезопасныйВходНаСерверИсходящейПочты,Пользователь,ПользовательSMTP";
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, СписокРеквизитов);
		
		ТребуетсяПроверкаПароля = ЗначениеЗаполнено(ЗначенияРеквизитов.ВладелецУчетнойЗаписи);
		Если ТребуетсяПроверкаПароля Тогда
			ДоИзменения = Новый Структура(СписокРеквизитов);
			ЗаполнитьЗначенияСвойств(ДоИзменения, ЗначенияРеквизитов);
			ПослеИзменения = Новый Структура(СписокРеквизитов);
			ЗаполнитьЗначенияСвойств(ПослеИзменения, ЭтотОбъект);
			ТребуетсяПроверкаПароля = ОбщегоНазначения.ЗначениеВСтрокуXML(ДоИзменения) <> ОбщегоНазначения.ЗначениеВСтрокуXML(ПослеИзменения);
		КонецЕсли;
		
		Если ТребуетсяПроверкаПароля Тогда
			ТекстСообщенияОбОшибке = НСтр("ru = 'Не подтвержден пароль для изменения настроек учетной записи.'");
			ПроверкаПароля = Неопределено;
			Если Не ДополнительныеСвойства.Свойство("Пароль", ПроверкаПароля) Или Не ПарольВведенВерно(ПроверкаПароля) Тогда
				ВызватьИсключение ТекстСообщенияОбОшибке;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьОбъектЗначениямиПоУмолчанию() Экспорт
	
	ИмяПользователя = НСтр("ru = '1С:Предприятие'");
	ИспользоватьДляПолучения = Ложь;
	ИспользоватьДляОтправки = Ложь;
	ОставлятьКопииСообщенийНаСервере = Ложь;
	ПериодХраненияСообщенийНаСервере = 0;
	ВремяОжидания = 30;
	ПортСервераВходящейПочты = 110;
	ПортСервераИсходящейПочты = 25;
	ПротоколВходящейПочты = "POP";
	
КонецПроцедуры

Функция ПарольВведенВерно(ПроверкаПароля)
	УстановитьПривилегированныйРежим(Истина);
	Пароли = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Ссылка, "Пароль,ПарольSMTP");
	УстановитьПривилегированныйРежим(Ложь);
	
	ПроверяемыеПароли = Новый Массив;
	Если ЗначениеЗаполнено(Пароли.Пароль) Тогда
		ПроверяемыеПароли.Добавить(Пароли.Пароль);
	КонецЕсли;
	Если ЗначениеЗаполнено(Пароли.ПарольSMTP) Тогда
		ПроверяемыеПароли.Добавить(Пароли.ПарольSMTP);
	КонецЕсли;
	
	Для Каждого ПроверяемыйПароль Из ПроверяемыеПароли Цикл
		Если ПроверкаПароля <> ПроверяемыйПароль Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
КонецФункции

#КонецОбласти

#КонецЕсли
