
&НаКлиенте
Процедура СоздатьПоШаблону(Команда)
	
	ДокументШаблона = ПолучитьДокументШаблона();
	
	Если Не ЗначениеЗаполнено(ДокументШаблона) Тогда
		ПоказатьПредупреждение(, "Документ шаблона для организации: " + Организация + " и подразделения: " + Подразделение + " не найден!");
		Возврат;
	КонецЕсли;		
		
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Основание", ДокументШаблона);
	
	ОткрытьФорму("Документ.мРапортПГУ.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДокументШаблона()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ШаблонРапортПГУ.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ШаблонРапортПГУ КАК ШаблонРапортПГУ
		|ГДЕ
		|	ШаблонРапортПГУ.Проведен
		|	И ШаблонРапортПГУ.Организация = &Организация
		|	И ШаблонРапортПГУ.Подразделение = &Подразделение
		|
		|УПОРЯДОЧИТЬ ПО
		|	ШаблонРапортПГУ.Дата УБЫВ";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	
	Результат = Запрос.Выполнить().Выбрать();
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Результат.Следующий() Тогда
		Возврат Результат.Ссылка;
	Иначе
		Возврат Документы.ШаблонРапортПГУ.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Подразделение = ПараметрыСеанса.ТекущийПользователь.Подразделение;
	Организация = Подразделение.Организация;
	
КонецПроцедуры

