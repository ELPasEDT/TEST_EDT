
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ТекущийПользователь = ПараметрыСеанса.ТекущийПользователь;
	Организация = ПолучитьОрганизациюПользователя(ТекущийПользователь.Подразделение);
	Ответственный = ТекущийПользователь;
	Подразделение = ТекущийПользователь.Подразделение;
	
	//Ввод на основании Шаблона
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ШаблонРапортКотлы") Тогда
		УстановитьПривилегированныйРежим(Истина);
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения, , "Дата, Номер, Проведен, Организация, Подразделение, Ответственный"); 		
		Дата = ТекущаяДатаСеанса();
		Для Каждого ТекСтр Из ДанныеЗаполнения.ДанынеПоКотлам Цикл
			НовСтр = ДанынеПоКотлам.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтр, ТекСтр);
		КонецЦикла;
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьОрганизациюПользователя(Подразделение) 	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Подразделения.Организация КАК Организация
		|ИЗ
		|	Справочник.Подразделения КАК Подразделения
		|ГДЕ
		|	Подразделения.Ссылка = &Подразделение
		|	И НЕ Подразделения.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	
	Результат = Запрос.Выполнить().Выбрать();
	
	Если Результат.Следующий() Тогда
		Возврат Результат.Организация;
	Иначе 
		Возврат Справочники.Организации.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции
