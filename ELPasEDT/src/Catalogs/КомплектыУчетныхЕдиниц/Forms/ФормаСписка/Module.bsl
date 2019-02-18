
&НаСервере
Процедура УстановитьОсновнымНаСервере(Ссылка)
	
	Если Ссылка.ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	МЗ = РегистрыСведений.КомплектУчетныхЕдиницПоУмолчанию.СоздатьМенеджерЗаписи();
	МЗ.Организация = Ссылка.Организация;
	МЗ.Реагент = Ссылка.Реагент;
	МЗ.Комплект = Ссылка;
	МЗ.Записать();
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОсновным(Команда)
	
	ТекущаяСтрока = Элементы.Список.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		УстановитьОсновнымНаСервере(ТекущаяСтрока);
	КонецЕсли;
КонецПроцедуры
