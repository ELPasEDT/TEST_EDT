
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("УстановитьНеВключатьВЖурнал") И ДополнительныеСвойства.УстановитьНеВключатьВЖурнал Тогда
		НеВключатьВЖурнал = 
			(
				(ЗакачкаНачата = ЗакачкаЗавершена)
				И (РасходНачат = РасходЗавершен)
				И (Расход = 0)
				И (РасходТоварногоРеагента = 0)
				
				И (УровеньНаНачалоЗакачки = УровеньНаОкончаниеЗакачки)
				И (УровеньНаНачалоРасхода = УровеньНаОкончаниеРасхода)
				
			);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если ЗаписьОтменена Или НеВключатьВЖурнал Тогда
		Для Каждого Набор Из Движения Цикл
			Набор.Очистить();
			Набор.Записать();
		КонецЦикла;
		Возврат;
	КонецЕсли;
	
	ДвиженияПоРегРаботаХимцеха();
	
	Если РасходЗавершен Тогда
			
		// регистр РеагентыВПодразделениях
		//Движения.РеагентыВПодразделениях.Записывать = Истина;
		Движение = Движения.РеагентыВПодразделениях.Добавить();
		Движение.ВидДвижения   = ВидДвиженияНакопления.Расход;
		Движение.Период        = Дата;
		Движение.Подразделение = Подразделение;
		Движение.ВидРеагента   = ВидРеагента;
		Движение.Реагент       = Реагент;
		Движение.Партия        = Партия;
		
		Движение.КоличествоВБазовойЕдинице            = РасходТоварногоРеагента;
		Движение.КоличествоМоногидратаВБазовойЕдинице = Расход;
		Движение.Количество                           = ?(Партия.ЕдиницаИзмеренияКоличества.Коэффициент <> 0, Движение.КоличествоВБазовойЕдинице / Партия.ЕдиницаИзмеренияКоличества.Коэффициент, 0);

		Если Партия.УчитыватьПлотностьПриРасчетеКоличества
			И ЗначениеЗаполнено(Партия.Плотность)
			И ЗначениеЗаполнено(Партия.ЕдиницаИзмеренияПлотности.Коэффициент) Тогда
			Движение.Количество = Движение.Количество / Партия.Плотность / Партия.ЕдиницаИзмеренияПлотности.Коэффициент;
		КонецЕсли;
		
		Движения.РеагентыВПодразделениях.Записать();
							
		// регистр ИспользованиеРеагентов
		Движения.ИспользованиеРеагентов.Записывать = Истина;
		ДвижениеИспРеаг = Движения.ИспользованиеРеагентов.Добавить();
		ДвижениеИспРеаг.Период                  = Дата;
		ДвижениеИспРеаг.Организация             = Организация;
		ДвижениеИспРеаг.Подразделение           = Подразделение;
		ДвижениеИспРеаг.Оборудование            = Оборудование;
		ДвижениеИспРеаг.ВидРасхода              = ВидРасхода;
		ДвижениеИспРеаг.НаправлениеРасхода      = НаправлениеРасхода;
		ДвижениеИспРеаг.Партия                  = Партия;
		ДвижениеИспРеаг.Реагент                 = Реагент;
		ДвижениеИспРеаг.Количество              = Движение.Количество;
		ДвижениеИспРеаг.КоличествоВБазовойЕдинице = Движение.КоличествоВБазовойЕдинице;
		ДвижениеИспРеаг.КоличествоМоногидратаВБазовойЕдинице = Движение.КоличествоМоногидратаВБазовойЕдинице;
		ДвижениеИспРеаг.ОбъемСработанного = ОбъемСработанногоРаствораРасход + ОбъемСработанногоРаствораЗакачка;
		ДвижениеИспРеаг.Сценарий = Справочники.СценарииПланирования.Факт;
		
	КонецЕсли;
	
	Если ЗакачкаНачата И Не ЕстьЗаписьУровня(ДатаНачалаЗакачки) Тогда
		Движения.УровеньРаствораВМернике.Записывать = Истина;
		Движение = Движения.УровеньРаствораВМернике.Добавить();
		Движение.Период = ДатаНачалаЗакачки;
		Движение.Оборудование = Оборудование;
		Движение.Уровень = УровеньНаНачалоЗакачки;
	КонецЕсли;
	
	Если ЗакачкаЗавершена И Не ЕстьЗаписьУровня(ДатаОкончанияЗакачки) Тогда
		Движения.УровеньРаствораВМернике.Записывать = Истина;
		Движение = Движения.УровеньРаствораВМернике.Добавить();
		Движение.Период = ДатаОкончанияЗакачки;
		Движение.Оборудование = Оборудование;
		Движение.Уровень = УровеньНаОкончаниеЗакачки;
	КонецЕсли;
	
	Если РасходНачат И Не ЕстьЗаписьУровня(ДатаНачалаРасхода) Тогда
		Движения.УровеньРаствораВМернике.Записывать = Истина;
		Движение = Движения.УровеньРаствораВМернике.Добавить();
		Движение.Период = ДатаНачалаРасхода;
		Движение.Оборудование = Оборудование;
		Движение.Уровень = УровеньНаНачалоРасхода;
	КонецЕсли;
	
	Если РасходЗавершен И Не ЕстьЗаписьУровня(ДатаОкончанияРасхода) Тогда
		Движения.УровеньРаствораВМернике.Записывать = Истина;
		Движение = Движения.УровеньРаствораВМернике.Добавить();
		Движение.Период = ДатаОкончанияРасхода;
		Движение.Оборудование = Оборудование;
		Движение.Уровень = УровеньНаОкончаниеРасхода;
	КонецЕсли;
	
	Параметры = Новый Структура;
	Параметры.Вставить("Период",        Новый Граница(МоментВремени(), ВидГраницы.Включая));
	Параметры.Вставить("ВидРеагента",   ВидРеагента);
	Параметры.Вставить("Партия",        Партия);
	Параметры.Вставить("Подразделение", Подразделение);
	Параметры.Вставить("Реагент",       Реагент);
	
	РегистрыНакопления.РеагентыВПодразделениях.ВыполнитьКонтрольОстатков(Параметры, Отказ);
	
КонецПроцедуры

Функция ЕстьЗаписьУровня(Период)
	
	ЕстьЗапись = Ложь;
	
	Для Каждого Стр Из Движения.УровеньРаствораВМернике Цикл
		Если Стр.Период = Период Тогда
			ЕстьЗапись = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ЕстьЗапись;
	
КонецФункции

Процедура ДвиженияПоРегРаботаХимцеха()
	
	Движения.РаботаХимцеха.Записывать = Истина;
		
	НеВыключатьРасход  = Ложь;	
	НеВыключатьЗакачку = Ложь;
		
	////   [  Включение закачки              ]      [Расход продолжпется, отметка откл.   расхода - отсечка врем.]         // /////////////////////
	//Если ЗакачкаНачата И Не ЗакачкаЗавершена  И   РасходНачат И РасходЗавершен И РассчитатьРасходВоВремяЗакачки Тогда    // Определение операций,
	//	НеВыключатьРасход  = Истина;;                                                                                    // которые не
	//КонецЕсли;                                                                                                           // останавливают
	//                                                                                                                     // расход или закачку
	////   [  Включение расхода          ]     [Закачка продолжается, отметка откл. закачки - отсечка врем     ]           //
	//Если РасходНачат И Не РасходЗавершен  И  ЗакачкаНачата И ЗакачкаЗавершена И РассчитатьРасходВоВремяЗакачки  Тогда    // 
	//	НеВыключатьЗакачку = Истина;                                                                                     // /////////////////////
	//КонецЕсли;
	
	Если ЗакачкаНачата Тогда
		Движение = Движения.РаботаХимцеха.Добавить();
		Движение.Период                       = ДатаНачалаЗакачки;
		Движение.Оборудование                 = Оборудование;
		Движение.ВидЗаписи                    = Перечисления.ВидыЗаписейЖурналаУчетаРеагентов.Закачка;
		Движение.Включено                     = Истина;
		Движение.Уровень                      = УровеньНаНачалоЗакачки;
		Движение.Концентрация                 = КонцентрацияНаНачалоЗакачки;
		Движение.ВремяРаботы                  = 0;
		Движение.Ответственный                = ОтветственныйНачалаЗакачки;
		Движение.Смена                        = СменаНачалаЗакачки;
		Движение.Вахта                        = ВахтаНачалаЗакачки;
		Движение.ЕдиницаИзмеренияКоличества   = ЕдиницаИзмеренияКоличества;
		Движение.ЕдиницаИзмеренияКонцентрации = ЕдиницаИзмеренияКонцентрации;
		Движение.ЕдиницаИзмеренияПлотности    = ЕдиницаИзмеренияПлотности;
		Движение.ВидРеагента                  = ВидРеагента;
		Движение.Подразделение                = Подразделение;
	КонецЕсли;
	
	Если ЗакачкаЗавершена И Не НеВыключатьЗакачку Тогда
		Движение = Неопределено;
		Если ЗакачкаНачата И ДатаНачалаЗакачки  = ДатаОкончанияЗакачки Тогда
			ДвижениеНайдено = Ложь;
			Для Каждого Движение Из Движения.РаботаХимцеха Цикл
				Если Движение.Оборудование = Оборудование
					И Движение.ВидЗаписи = Перечисления.ВидыЗаписейЖурналаУчетаРеагентов.Закачка
					И Движение.Период = ДатаОкончанияЗакачки Тогда
					ДвижениеНайдено = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если Не ДвижениеНайдено Тогда
				Движение = Неопределено;
			КонецЕсли;
		КонецЕсли;
		Если Движение = Неопределено Тогда
			Движение = Движения.РаботаХимцеха.Добавить();
		КонецЕсли;
		Движение.Период                       = ДатаОкончанияЗакачки;
		Движение.Оборудование                 = Оборудование;
		Движение.ВидЗаписи                    = Перечисления.ВидыЗаписейЖурналаУчетаРеагентов.Закачка;
		Движение.Включено                     = Ложь;
		Движение.Уровень                      = УровеньНаОкончаниеЗакачки;
		Движение.Концентрация                 = КонцентрацияНаОкончаниеЗакачки;
		Движение.ВремяРаботы                  = ВремяЗакачки;
		Движение.Ответственный                = ОтветственныйОкончанияЗакачки;
		Движение.Смена                        = СменаОкончанияЗакачки;
		Движение.Вахта                        = ВахтаОкончанияЗакачки;
		Движение.ЕдиницаИзмеренияКоличества   = ЕдиницаИзмеренияКоличества;
		Движение.ЕдиницаИзмеренияКонцентрации = ЕдиницаИзмеренияКонцентрации;
		Движение.ЕдиницаИзмеренияПлотности    = ЕдиницаИзмеренияПлотности;
		Движение.ВидРеагента                  = ВидРеагента;
		Движение.Подразделение                = Подразделение;
	КонецЕсли;
	
	Если РасходНачат Тогда
		Движение = Движения.РаботаХимцеха.Добавить();
		Движение.Период                       = ДатаНачалаРасхода;
		Движение.Оборудование                 = Оборудование;
		Движение.ВидЗаписи                    = Перечисления.ВидыЗаписейЖурналаУчетаРеагентов.Расход;
		Движение.Включено                     = Истина;
		Движение.Уровень                      = УровеньНаНачалоРасхода;
		Движение.Концентрация                 = КонцентрацияНаНачалоРасхода;
		Движение.ВремяРаботы                  = 0;
		Движение.Ответственный                = ОтветственныйНачалаРасхода;
		Движение.Смена                        = СменаНачалаРасхода;
		Движение.Вахта                        = ВахтаНачалаРасхода;
		Движение.ЕдиницаИзмеренияКоличества   = ЕдиницаИзмеренияКоличества;
		Движение.ЕдиницаИзмеренияКонцентрации = ЕдиницаИзмеренияКонцентрации;
		Движение.ЕдиницаИзмеренияПлотности    = ЕдиницаИзмеренияПлотности;
		Движение.ВидРеагента                  = ВидРеагента;
		Движение.Подразделение                = Подразделение;
	КонецЕсли;
	
	Если РасходЗавершен И Не НеВыключатьРасход Тогда
		Движение = Неопределено;
		Если РасходНачат И ДатаНачалаРасхода = ДатаОкончанияРасхода Тогда
			ДвижениеНайдено = Ложь;
			Для Каждого Движение Из Движения.РаботаХимцеха Цикл
				Если Движение.Оборудование = Оборудование
					И Движение.ВидЗаписи = Перечисления.ВидыЗаписейЖурналаУчетаРеагентов.Расход
					И Движение.Период = ДатаОкончанияРасхода Тогда
					ДвижениеНайдено = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если Не ДвижениеНайдено Тогда
				Движение = Неопределено;
			КонецЕсли;
		КонецЕсли;
		Если Движение = Неопределено Тогда
			Движение = Движения.РаботаХимцеха.Добавить();
		КонецЕсли;
		Движение.Период                       = ДатаОкончанияРасхода;
		Движение.Оборудование                 = Оборудование;
		Движение.ВидЗаписи                    = Перечисления.ВидыЗаписейЖурналаУчетаРеагентов.Расход;
		Движение.Включено                     = Ложь;
		Движение.Уровень                      = УровеньНаОкончаниеРасхода;
		Движение.Концентрация                 = КонцентрацияНаОкончаниеРасхода;
		Движение.ВремяРаботы                  = ВремяРасхода;
		Движение.Ответственный                = ОтветственныйОкончанияРасхода;
		Движение.Смена                        = СменаОкончанияРасхода;
		Движение.Вахта                        = ВахтаОкончанияРасхода;
		Движение.ЕдиницаИзмеренияКоличества   = ЕдиницаИзмеренияКоличества;
		Движение.ЕдиницаИзмеренияКонцентрации = ЕдиницаИзмеренияКонцентрации;
		Движение.ЕдиницаИзмеренияПлотности    = ЕдиницаИзмеренияПлотности;
		Движение.ВидРеагента                  = ВидРеагента;
		Движение.Подразделение                = Подразделение;
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

Процедура РассчитатьРасход(ПараметрыОборудования = Неопределено) Экспорт
	
	РассчитатьРасход  = ЗначениеЗаполнено(ДатаОкончанияЧистогоРасхода);
	
	Если Не РассчитатьРасход И Не РассчитатьРасходВоВремяЗакачки Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыОборудования = Неопределено Тогда
		Отказ = Ложь;
		ПараметрыОборудования = РегистрыСведений.ОборудованиеХимЦеха.ПолучитьПараметрыОборудования
			(Дата, Оборудование, Отказ);
	КонецЕсли;
	
	
	Если РассчитатьРасход И ВремяРасхода = 0 И ОбъемСработанногоРаствораРасход = 0 Тогда
		ВремяРасхода = 
			(ДатаОкончанияЧистогоРасхода - ДатаНачалаРасхода) / 60;
		ОбъемСработанногоРаствораРасход = 
			ПараметрыОборудования.ПлощадьОснования * (УровеньНаНачалоРасхода - УровеньНаОкончаниеРасхода);
	КонецЕсли;
		
	
	Если РассчитатьРасходВоВремяЗакачки Тогда
		
		ВремяЗакачки =
			(ДатаОкончанияЗакачки - ДатаНачалаЗакачки) / 60; 
			
				
		Если ОбъемСработанногоРаствораРасход <> 0 И ВремяРасхода <> 0 Тогда
			СкоростьРасхода = ОбъемСработанногоРаствораРасход / ВремяРасхода;
		Иначе
			СкоростьРасхода = ПолучитьСкоростьРасхода();
		КонецЕсли;
		
		ОбъемСработанногоРаствораЗакачка =
			СкоростьРасхода * ВремяЗакачки;
		
	КонецЕсли;
	
	Расход = РассчитатьПоФормуле(Перечисления.РассчетныеПоказателиЖурналаУчетаРеагентов.Расход,
		Реагент,
		Оборудование.Организация,
		ОбъемСработанногоРаствораЗакачка,
		ОбъемСработанногоРаствораРасход,
		Макс(КонцентрацияНаНачалоЗакачки, КонцентрацияНаОкончаниеРасхода),
		ПлотностьПоТаблицам, 
		Партия, // партия
		ПлотностьПоТаблицам, // расход100
		ЕдиницаИзмеренияКонцентрации, // е.и. конц
		ЕдиницаИзмеренияКоличества,  // е.и. колич
		ЕдиницаИзмеренияПлотности);
			
	РасходТоварногоРеагента = РассчитатьПоФормуле(Перечисления.РассчетныеПоказателиЖурналаУчетаРеагентов.РасходТоварногоРеагента,
		Реагент,
		Оборудование.Организация,
		ОбъемСработанногоРаствораЗакачка,
		ОбъемСработанногоРаствораРасход,
		Макс(КонцентрацияНаНачалоЗакачки, КонцентрацияНаОкончаниеРасхода),
		ПлотностьПоТаблицам,
		Партия, // партия
		Расход, // расход100
		ЕдиницаИзмеренияКонцентрации, // е.и. конц
		ЕдиницаИзмеренияКоличества,  // е.и. колич
		ЕдиницаИзмеренияПлотности);
	
КонецПроцедуры

Функция РассчитатьПоФормуле(Показатель, 
	Реагент,
	Организация,
	
	ОбъемСработанногоРаствораЗакачка = Неопределено,
	ОбъемСработанногоРаствораРасход  = Неопределено,
	Концентрация                     = Неопределено,
	Плотность                        = Неопределено,
	
	Партия                           = Неопределено,
	Расход100                        = Неопределено,
	
	ЕдиницаИзмеренияКонцентрации     = Неопределено,
	ЕдиницаИзмеренияКоличества       = Неопределено,
	ЕдиницаИзмеренияПлотности        = Неопределено,
	
	Расшифровка = "") Экспорт
	
	Результат = 0;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ФормулыПоказателейЖурналаУчетаРеагентовРеагенты.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА ФормулыПоказателейЖурналаУчетаРеагентовРеагенты.Реагент = &Реагент
	|			ТОГДА 0
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК Приоритет,
	|	ФормулыПоказателейЖурналаУчетаРеагентовРеагенты.Ссылка.Формула КАК Формула
	|ИЗ
	|	Справочник.ФормулыПоказателейЖурналаУчетаРеагентов.Реагенты КАК ФормулыПоказателейЖурналаУчетаРеагентовРеагенты
	|ГДЕ
	|	(ФормулыПоказателейЖурналаУчетаРеагентовРеагенты.Реагент = &ВидРеагента
	|			ИЛИ ФормулыПоказателейЖурналаУчетаРеагентовРеагенты.Реагент = &Реагент)
	|	И НЕ ФормулыПоказателейЖурналаУчетаРеагентовРеагенты.Ссылка.ПометкаУдаления
	|	И ФормулыПоказателейЖурналаУчетаРеагентовРеагенты.Ссылка.Показатель = &Показатель
	|	И ФормулыПоказателейЖурналаУчетаРеагентовРеагенты.Ссылка.Организация = &Организация
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет");
	Запрос.УстановитьПараметр("Показатель", Показатель);
	Запрос.УстановитьПараметр("ВидРеагента", Реагент.ВидРеагента);
	Запрос.УстановитьПараметр("Реагент", Реагент);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
	
		Попытка
			Результат = Вычислить(Выборка.Формула);
		Исключение
			Сообщить(ОписаниеОшибки());
			Результат = 0;
		КонецПопытки;
		
	КонецЕсли;
	
	// Подгогтовка расшифровкм
	
	Расшифровка = Расшифровка + Результат;
	
	ПараметрыФормулы = РазобратьСтроку(Выборка.Формула, " */-+()?,
	|");
	
	Расшифровка = Расшифровка + "
	|" + Выборка.Формула + "
	|";
	
	
	Для Каждого ПараметрФормулы Из ПараметрыФормулы Цикл
		
		Попытка
			
			Значение = Вычислить(ПараметрФормулы);
			Расшифровка = Расшифровка + "
			|" + ПараметрФормулы + "=" + Значение;
			
		Исключение
			
		КонецПопытки;
		
	КонецЦикла;
	
	Расшифровка = Расшифровка + "
	|
	|";
	
	Возврат Результат;
	
КонецФункции

Функция РазобратьСтроку(Строка, Разделитель)

	ДлинаСтроки = СтрДлина(Строка);
	Значения    = Новый Массив;
	ТекЗначение = "";
	
	Для Инд = 1 По ДлинаСтроки Цикл
		
		ТекСимвол = Сред(Строка, Инд, 1);
		
		Если СтрНайти(Разделитель, ТекСимвол) Тогда
			Значения.Добавить(ТекЗначение);
			ТекЗначение = "";
		Иначе
			ТекЗначение = ТекЗначение + ТекСимвол;
		КонецЕсли;
		
	КонецЦикла;
	
	Значения.Добавить(ТекЗначение); // добавим крайний элемент
	
	Возврат Значения;
	
КонецФункции

Функция ПолучитьСкоростьРасхода()
	
	Скорость = 0;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВЫБОР
	|		КОГДА ЗаписьЖурналаУчетаРеагентов.ВремяРасхода <> 0
	|			ТОГДА ЗаписьЖурналаУчетаРеагентов.ОбъемСработанногоРаствораРасход / ЗаписьЖурналаУчетаРеагентов.ВремяРасхода
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СкоростьРасхода,
	|	ЗаписьЖурналаУчетаРеагентов.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ЗаписьЖурналаУчетаРеагентов КАК ЗаписьЖурналаУчетаРеагентов
	|ГДЕ
	|	ЗаписьЖурналаУчетаРеагентов.ВремяРасхода <> 0
	|	И ЗаписьЖурналаУчетаРеагентов.ОбъемСработанногоРаствораРасход <> 0
	|	И ЗаписьЖурналаУчетаРеагентов.Проведен
	|	И НЕ ЗаписьЖурналаУчетаРеагентов.ЗаписьОтменена
	|	И ЗаписьЖурналаУчетаРеагентов.Оборудование = &Оборудование
	|	И ЗаписьЖурналаУчетаРеагентов.Дата <= &Дата
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка УБЫВ
	|АВТОУПОРЯДОЧИВАНИЕ");
	Запрос.УстановитьПараметр("Оборудование", Оборудование);
	Запрос.УстановитьПараметр("Дата", Дата);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Скорость = Выборка.СкоростьРасхода;
	КонецЕсли;
	
	Возврат Скорость;
	
КонецФункции
