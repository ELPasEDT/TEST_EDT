
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	Настройки = КомпоновщикНастроек.Настройки; 
	
	ОтборПоПодразделению = Новый ПолеКомпоновкиДанных("Подразделение"); 
	Для Каждого ЭлементНастройки Из Настройки.Отбор.Элементы Цикл 
		Если ЭлементНастройки.ЛевоеЗначение = ОтборПоПодразделению Тогда 
			ЭлементНастройки.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии; 
			ЭлементНастройки.ПравоеЗначение = ПараметрыСеанса.ТекущийПользователь.Подразделение; 
			ЭлементНастройки.Использование = Истина; 
			Если ЗначениеЗаполнено(ЭлементНастройки.ИдентификаторПользовательскойНастройки) Тогда 
				ПользовательскийПараметр = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ЭлементНастройки.ИдентификаторПользовательскойНастройки); 
				Если ТипЗнч(ПользовательскийПараметр) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда 
					ПользовательскийПараметр.ВидСравнения = ЭлементНастройки.ВидСравнения; 
					ПользовательскийПараметр.ПравоеЗначение = ЭлементНастройки.ПравоеЗначение; 
					ПользовательскийПараметр.Использование = ЭлементНастройки.Использование; 
				КонецЕсли; 
			КонецЕсли; 
			Прервать; 
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры
