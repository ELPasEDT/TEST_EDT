

&НаСервере
Процедура ОборудованиеПриИзмененииНаСервере()
	
	Если ПустаяСтрока(Объект.ДиспетчерскоеНаименование) Тогда
		Объект.ДиспетчерскоеНаименование = Объект.Оборудование.ДиспетчерскоеНаименование;
	КонецЕсли;
	Если ПустаяСтрока(Объект.Наименование) Тогда
		Объект.Наименование = Объект.Оборудование.Наименование;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОборудованиеПриИзменении(Элемент)
	ОборудованиеПриИзмененииНаСервере();
КонецПроцедуры


