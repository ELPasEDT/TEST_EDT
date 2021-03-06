
&НаКлиенте
Процедура СоздатьПоШаблону(Команда)
	
	ДокументШаблона = ПолучитьДокументШаблона();
	
	Если Не ЗначениеЗаполнено(ДокументШаблона) Тогда
		ПоказатьПредупреждение(, "Документ шаблона для организации: " + Организация + " и подразделения: " + Подразделение + " не найден!");
		Возврат;
	КонецЕсли;		
		
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Основание", ДокументШаблона);
	
	ОткрытьФорму("Документ.мРапортТопливо.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры   

&НаСервере
Функция ПолучитьДокументШаблона()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ШаблонРапортТопливо.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ШаблонРапортТопливо КАК ШаблонРапортТопливо
		|ГДЕ
		|	ШаблонРапортТопливо.Проведен
		|	И ШаблонРапортТопливо.Организация = &Организация
		|	И ШаблонРапортТопливо.Подразделение = &Подразделение
		|
		|УПОРЯДОЧИТЬ ПО
		|	ШаблонРапортТопливо.Дата УБЫВ";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	
	Результат = Запрос.Выполнить().Выбрать();
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Результат.Следующий() Тогда
		Возврат Результат.Ссылка;
	Иначе
		Возврат Документы.ШаблонРапортТопливо.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Подразделение = ПараметрыСеанса.ТекущийПользователь.Подразделение;
	Организация = Подразделение.Организация;
	
КонецПроцедуры

