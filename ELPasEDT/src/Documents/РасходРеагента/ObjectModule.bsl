 

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗаписьОтменена Тогда
		Для Каждого Набор Из Движения Цикл
			Набор.Очистить();
			Набор.Записать();
		КонецЦикла;
		Возврат;
	КонецЕсли;
	
	ДатаРасхода = Дата;
	
	Организация = Подразделение.Организация;
	ДатаРасхода = Дата;
	
	Если ЗначениеЗаполнено(Партия) Тогда
		Реагент = Партия.Реагент;
	Иначе
		Реагент = Неопределено;
	КонецЕсли;
	
	КоличествоВБазовойЕдинице = Количество * Партия.ЕдиницаИзмеренияКоличества.Коэффициент;
	Расход = КоличествоВБазовойЕдинице * Партия.Концентрация / 100
		* Партия.ЕдиницаИзмеренияКонцентрации.Коэффициент;
		
	Если Партия.УчитыватьПлотностьПриРасчетеКоличества 
		И ЗначениеЗаполнено(Партия.Плотность) 
		И ЗначениеЗаполнено(Партия.ЕдиницаИзмеренияПлотности)
		И ЗначениеЗаполнено(Партия.ЕдиницаИзмеренияПлотности.Коэффициент) 
		Тогда
		
		КоличествоВБазовойЕдинице = КоличествоВБазовойЕдинице 
			* Партия.Плотность * Партия.ЕдиницаИзмеренияПлотности.Коэффициент;
			
		Расход = Расход
			* Партия.Плотность * Партия.ЕдиницаИзмеренияПлотности.Коэффициент;
			
	КонецЕсли;
	
КонецПроцедуры


Процедура ОбработкаПроведения(Отказ, Режим)
	
	Если ЗаписьОтменена Тогда
		Для Каждого Набор Из Движения Цикл
			Набор.Очистить();
			Набор.Записать();
		КонецЦикла;
		Возврат;
	КонецЕсли;
	
	// регистр РеагентыВПодразделениях Расход
	//Движения.РеагентыВПодразделениях.Записывать = Истина;
	Движение = Движения.РеагентыВПодразделениях.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
	Движение.Период = Дата;
	Движение.Партия = Партия;
	Движение.ВидРеагента = ВидРеагента;
	Движение.Реагент = Реагент;
	Движение.Подразделение = Подразделение;
	
	Движение.Количество = Количество;
	Движение.КоличествоВБазовойЕдинице = КоличествоВБазовойЕдинице;
	Движение.КоличествоМоногидратаВБазовойЕдинице = Расход;
	
	Движения.РеагентыВПодразделениях.Записать();
	
	Параметры = Новый Структура;
	Параметры.Вставить("Период",        Новый Граница(МоментВремени(), ВидГраницы.Включая));
	Параметры.Вставить("ВидРеагента",   ВидРеагента);
	Параметры.Вставить("Партия",        Партия);
	Параметры.Вставить("Подразделение", Подразделение);
	Параметры.Вставить("Реагент",       Реагент);
	
	РегистрыНакопления.РеагентыВПодразделениях.ВыполнитьКонтрольОстатков(Параметры, Отказ);
	
	Если Не Отказ Тогда
		
		// регистр ИспользованиеРеагентов
		Движения.ИспользованиеРеагентов.Записывать = Истина;
		ДвижениеРегИспольз = Движения.ИспользованиеРеагентов.Добавить();
		ДвижениеРегИспольз.Период                  = Дата;
		ДвижениеРегИспольз.Организация             = Подразделение.Организация;
		ДвижениеРегИспольз.Подразделение           = Подразделение;
		ДвижениеРегИспольз.Оборудование            = Оборудование;
		ДвижениеРегИспольз.ВидРасхода              = ВидРасхода;
		ДвижениеРегИспольз.НаправлениеРасхода      = НаправлениеРасхода;
		ДвижениеРегИспольз.Партия                  = Партия;
		ДвижениеРегИспольз.Реагент                 = Реагент;
		ДвижениеРегИспольз.Количество                           = Движение.Количество;
		ДвижениеРегИспольз.КоличествоВБазовойЕдинице            = Движение.КоличествоВБазовойЕдинице;
		ДвижениеРегИспольз.КоличествоМоногидратаВБазовойЕдинице = Движение.КоличествоМоногидратаВБазовойЕдинице;
		ДвижениеРегИспольз.Сценарий = Справочники.СценарииПланирования.Факт;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Ответственный = ПользователиКлиентСервер.ТекущийПользователь();
	Подразделение = ПараметрыСеанса.ТекущийПользователь.Подразделение;
	Организация   = Подразделение.Организация;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПриходРеагента") Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	РеагентыВПодразделенияхОстатки.КоличествоОстаток КАК КоличествоОстаток
		|ИЗ
		|	РегистрНакопления.РеагентыВПодразделениях.Остатки(, Партия = &Партия) КАК РеагентыВПодразделенияхОстатки");
		Запрос.УстановитьПараметр("Партия", ДанныеЗаполнения.Ссылка);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
		
			// Заполнение шапки
			ВидРасхода    = Справочники.ВидыРасходаРеагентов.СписаниеОстатка;
			ВидРеагента   = ДанныеЗаполнения.ВидРеагента;
			Количество    = Выборка.КоличествоОстаток;
			Подразделение = ДанныеЗаполнения.Подразделение;
			Партия        = ДанныеЗаполнения.Ссылка;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ПометкаУдаления Или ЗаписьОтменена Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ПоследовательностьВводаОперацийРаботыХимцеха.Документ КАК Документ,
		|	ПоследовательностьВводаОперацийРаботыХимцеха.НомерОперации КАК НомерОперации
		|ИЗ
		|	РегистрСведений.ПоследовательностьВводаОперацийРаботыХимцеха КАК ПоследовательностьВводаОперацийРаботыХимцеха
		|ГДЕ
		|	ПоследовательностьВводаОперацийРаботыХимцеха.Документ = &Документ");
		Запрос.УстановитьПараметр("Документ", Ссылка);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			
			МЗ = РегистрыСведений.ПоследовательностьВводаОперацийРаботыХимцеха.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(МЗ, Выборка);
			МЗ.Удалить();
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры



