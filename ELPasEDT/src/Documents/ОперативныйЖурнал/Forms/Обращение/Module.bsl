
&НаСервере
Функция СоздатьРаспоряжениеНаСервере(ТекущаяДатаКлиент, Сотрудник, Смена = Неопределено, Вахта = Неопределено, ДатаНачалаСмены = Неопределено, ДатаОкончанияСмены = Неопределено) 
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(Сотрудник) = Тип("Строка") Тогда
		
		//Документ для автора обращения
		НовДок = Документы.ОперативныйЖурнал.СоздатьДокумент();
		НовДок.Дата = ТекущаяДатаКлиент;
		НовДок.ВидЗаписи = Справочники.ВидыЗаписей.Обращение;
		НовДок.Событие = Справочники.События.СформированоОбращение;
		НовДок.Ответственный = Автор;
		НовДок.Комментарий = "Обращение к НСЦ "  + Сотрудник + ": " + Комментарий;
		НовДок.Подразделение = Автор.Подразделение;
		НовДок.ДатаСобытия = ДатаСобытия;
		НовДок.Смена = Смена;
		НовДок.Вахта = Вахта;
		НовДок.Статус = Перечисления.СтатусыДокументаОперативногоЖурнала.Чистовик;
		НовДок.Чистовик = Истина;
		НовДок.ДатаНачалаСмены = ДатаНачалаСмены;
		НовДок.ДатаОкончанияСмены = ДатаОкончанияСмены;  
		НовДок.СтатусОтданногоРаспоряжения = Перечисления.СтатусыОтданныхРаспоряжений.НеВыполнено;
		Для Каждого ТекСтр Из СписокОборудования Цикл
			НовСтр = НовДок.Оборудование.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтр, ТекСтр);
			НовСтр.СтатусОборудования = Перечисления.СтатусыОборудования.ЗаписьОЖ;
		КонецЦикла;
		НовДок.Описание = СформироватьОписание(Вахта, Смена, ДатаНачалаСмены, Автор.Подразделение);
		
		Попытка
			НовДок.Записать(РежимЗаписиДокумента.Проведение);		
		Исключение
			Сообщить(ОписаниеОшибки());
		КонецПопытки;
		
		ДокументРаспоряжение = НовДок.Ссылка;
		
	ИначеЕсли ТипЗнч(Сотрудник) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		
		//Документ для Сотрудника
		НовДок = Документы.ОперативныйЖурнал.СоздатьДокумент();
		НовДок.Дата = ТекущаяДатаКлиент;
		НовДок.ВидЗаписи = Справочники.ВидыЗаписей.Обращение;
		НовДок.Событие = Справочники.События.ПолученоОбращение;
		НовДок.Ответственный = ПолучитьПользователя(Сотрудник);
		НовДок.Комментарий = "Обращение от НСЦ " + Автор + ": " + Комментарий;
		НовДок.Подразделение = Сотрудник.Подразделение;
		НовДок.ДатаСобытия = ДатаСобытия;
		НовДок.Смена = Смена;
		НовДок.Вахта = Вахта;
		НовДок.Статус = Перечисления.СтатусыДокументаОперативногоЖурнала.РаспоряжениеПолучено;
		НовДок.ДатаНачалаСмены = ДатаНачалаСмены;
		НовДок.ДатаОкончанияСмены = ДатаОкончанияСмены;
		НовДок.ПолученоОт = Автор;
		НовДок.Распоряжение = ДокументРаспоряжение;
		Для Каждого ТекСтр Из СписокОборудования Цикл
			НовСтр = НовДок.Оборудование.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтр, ТекСтр);
			НовСтр.СтатусОборудования = Перечисления.СтатусыОборудования.ЗаписьОЖ;
		КонецЦикла;
		НовДок.Описание = СформироватьОписание(Вахта, Смена, ДатаНачалаСмены, Автор.Подразделение);
		
		Попытка
			НовДок.Записать();
			//20180918
			ДобавитьДвиженияПоРаспоряжению(НовДок.Ссылка, ДокументРаспоряжение);
			//20180918
		Исключение
			Сообщить(ОписаниеОшибки());
		КонецПопытки; 	
		
	КонецЕсли; 
	
КонецФункции

Функция СформироватьОписание(Вахта, Смена, ДатаНачалаСмены, Подразделение) 	
		
	Если стрДлина(Строка(Смена.ВремяНачала)) = 19 Тогда
		тВремяНачала = " " + Лев(Прав(Смена.ВремяНачала, 8), 5);
	Иначе
		тВремяНачала = Лев(Прав(Смена.ВремяНачала, 8), 5);
	КонецЕсли;	
	тВремяОкончания = Лев(Прав(Смена.ВремяОкончания, 8), 5); 		
	СменаПрописью = Формат(ДатаНачалаСмены, "ДФ=dd/MM/yy") + тВремяНачала + " - " + тВремяОкончания; 		
	Описание = "" + Формат(ТекущаяДата(), "ДЛФ=DDT") + " " + Подразделение + "        " + Вахта + "        " + Смена + "        " + СменаПрописью;
	Возврат Описание;  		
	
КонецФункции

//20180918
&НаСервере
Процедура ДобавитьДвиженияПоРаспоряжению(НовДок, ДокументРаспоряжение)
	
	МенеджерЗаписи = РегистрыСведений.Распоряжения.СоздатьМенеджерЗаписи(); 
	МенеджерЗаписи.Распоряжение = ДокументРаспоряжение;
	МенеджерЗаписи.Ответственный = НовДок.Ответственный;
	МенеджерЗаписи.ТекстРаспоряжения = НовДок.Комментарий;
	МенеджерЗаписи.ДатаРаспоряжения = ТекущаяДатаСеанса(); 
	МенеджерЗаписи.Записать();
	
КонецПроцедуры
//20180918

&НаСервере
Функция ПолучитьПользователя(ФизическоеЛицо)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Пользователи.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|ГДЕ
		|	Пользователи.ФизическоеЛицо = &ФизическоеЛицо
		|	И НЕ Пользователи.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("ФизическоеЛицо", ФизическоеЛицо);
	
	Результат = Запрос.Выполнить().Выбрать();
	
	Если Результат.Следующий() Тогда
		Возврат Результат.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ЗаполнитьСписокСотрудников()
	
	УстановитьПривилегированныйРежим(Истина);
	ПодразделениеНСС = ПолучитьПодразделениеНСС(Автор.Подразделение);
	
	Запрос = Новый Запрос;
	//Запрос.Текст = 
	//	"ВЫБРАТЬ
	//	|	АктивныеСмены.Регистратор КАК Регистратор
	//	|ПОМЕСТИТЬ ВТ_ДокументПриемаСменыНСС
	//	|ИЗ
	//	|	РегистрСведений.АктивныеСмены КАК АктивныеСмены
	//	|ГДЕ
	//	|	АктивныеСмены.СменаОткрыта
	//	|	И АктивныеСмены.Подразделение = &Подразделение
	//	|;
	//	|
	//	|////////////////////////////////////////////////////////////////////////////////
	//	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	//	|	ОперативныйЖурналСотрудники.Сотрудник КАК Сотрудник,
	//	|	ЛОЖЬ КАК Выбран
	//	|ИЗ
	//	|	Документ.ОперативныйЖурнал.Сотрудники КАК ОперативныйЖурналСотрудники
	//	|ГДЕ
	//	|	ОперативныйЖурналСотрудники.Ссылка В
	//	|			(ВЫБРАТЬ
	//	|				ВТ_ДокументПриемаСменыНСС.Регистратор КАК Регистратор
	//	|			ИЗ
	//	|				ВТ_ДокументПриемаСменыНСС КАК ВТ_ДокументПриемаСменыНСС)
	//	|	И ОперативныйЖурналСотрудники.Сотрудник.НСЦ
	//	|	И НЕ ОперативныйЖурналСотрудники.Сотрудник = &Автор
	//	|	И ОперативныйЖурналСотрудники.Выбран";
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	АктивныеСмены.Регистратор КАК Регистратор
	|ПОМЕСТИТЬ ВТ_ДокументПриемаСменыНСС
	|ИЗ
	|	РегистрСведений.АктивныеСмены КАК АктивныеСмены
	|ГДЕ
	|	АктивныеСмены.СменаОткрыта
	|	И АктивныеСмены.Подразделение = &Подразделение
	|
	|УПОРЯДОЧИТЬ ПО
	|	АктивныеСмены.Период УБЫВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОперативныйЖурналСотрудники.Сотрудник КАК Сотрудник,
	|	ЛОЖЬ КАК Выбран
	|ИЗ
	|	Документ.ОперативныйЖурнал.Сотрудники КАК ОперативныйЖурналСотрудники
	|ГДЕ
	|	ОперативныйЖурналСотрудники.Ссылка В
	|			(ВЫБРАТЬ
	|				ВТ_ДокументПриемаСменыНСС.Регистратор КАК Регистратор
	|			ИЗ
	|				ВТ_ДокументПриемаСменыНСС КАК ВТ_ДокументПриемаСменыНСС)
	|	И ОперативныйЖурналСотрудники.Сотрудник.НСЦ
	|	И НЕ ОперативныйЖурналСотрудники.Сотрудник = &Автор
	|	И ОперативныйЖурналСотрудники.Выбран";
	
	Запрос.УстановитьПараметр("Подразделение", ПодразделениеНСС);
	Запрос.УстановитьПараметр("Автор", Автор.ФизическоеЛицо);
	
	СписокСотрудников.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецФункции

&НаСервере
Функция ПолучитьПодразделениеНСС(мПодразделение)
	
	Если ЗначениеЗаполнено(мПодразделение.Родитель) Тогда
		Возврат ПолучитьПодразделениеНСС(мПодразделение.Родитель);
	Иначе
		Возврат мПодразделение;
	КонецЕсли; 		
	
КонецФункции

&НаСервере
Функция ПолучитьСменуНСС()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	АктивныеСменыСрезПоследних.Смена КАК Смена
		|ИЗ
		|	РегистрСведений.АктивныеСмены.СрезПоследних(
		|			,
		|			Подразделение = &Подразделение
		|				И СтаршийСмены = &СтаршийСмены) КАК АктивныеСменыСрезПоследних
		|ГДЕ
		|	АктивныеСменыСрезПоследних.СменаОткрыта";
	
	Запрос.УстановитьПараметр("Подразделение", Автор.Подразделение);
	Запрос.УстановитьПараметр("СтаршийСмены", Автор);
	
	Результат = Запрос.Выполнить().Выбрать();
	
	Если Результат.Следующий() Тогда
		Возврат Результат.Смена;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура СоздатьРаспоряжение(Команда)
	
	//20180926
	//Проверка заполнения Оборудования
	ПроверкаПоОборудованию = Истина;
	НомСтр = 1;
	Для Каждого ТекСтр Из СписокОборудования Цикл
		Если Не ЗначениеЗаполнено(ТекСтр.Оборудование) Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Не заполнено Оборудование в строке " + НомСтр;
			Сообщение.Поле = "Объект.СписокОборудования["+(НомСтр-1)+"].Оборудование";
			Сообщение.Сообщить();			
			ПроверкаПоОборудованию = Ложь;
		КонецЕсли;
		НомСтр = НомСтр + 1;
	КонецЦикла;
	Если Не ПроверкаПоОборудованию Тогда
		Возврат;
	КонецЕсли;
	//20180926
	
	Если Не ЗначениеЗаполнено(Комментарий) Тогда
		ПоказатьПредупреждение(,"Заполните текст распоряжения!");
		Возврат;
	КонецЕсли;
	
	РаспоряженияСформированы = Ложь;
	// 	
	СтруктураПараметров = Новый Структура("Вахта, Смена, ДатаНачалаСмены, ДатаОкончанияСмены");
	ЗаполнитьСтруктуруПараметров(СтруктураПараметров);
	Для Каждого ТекСтр Из СписокСотрудников Цикл
		Если ТекСтр.Выбран Тогда  
			ТекущаяДатаКлиент = ТекущаяДата();
			//Распоряжение автору
			СоздатьРаспоряжениеНаСервере(ТекущаяДатаКлиент, Строка(ТекСтр.Сотрудник), СтруктураПараметров.Смена, СтруктураПараметров.Вахта, СтруктураПараметров.ДатаНачалаСмены, СтруктураПараметров.ДатаОкончанияСмены);
			//Распоряжения сотрудникам
			ВахтаНСЦ = ПолучитьВахтуНСЦ(ТекСтр.Сотрудник);
			СоздатьРаспоряжениеНаСервере(ТекущаяДатаКлиент, ТекСтр.Сотрудник, СтруктураПараметров.Смена, ВахтаНСЦ, СтруктураПараметров.ДатаНачалаСмены, СтруктураПараметров.ДатаОкончанияСмены);
			РаспоряженияСформированы = Истина;
		КонецЕсли;
	КонецЦикла;
	//
	Если РаспоряженияСформированы Тогда
		ПоказатьПредупреждение(,"Обращение сформировано!");
		//Оповестить("ОбновитьСписокОЖ");
	Иначе 
		ПоказатьПредупреждение(,"Сотрудники для обращения не выбраны!");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьВахтуНСЦ(Сотрудник)	
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВахтаНСЦ = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Пользователи.Ссылка КАК СтаршийСмены
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|ГДЕ
	|	НЕ Пользователи.ПометкаУдаления
	|	И Пользователи.ФизическоеЛицо = &ФизическоеЛицо";
	
	Запрос.УстановитьПараметр("ФизическоеЛицо", Сотрудник);
	
	Результат = Запрос.Выполнить().Выбрать();
	
	Если Результат.Следующий() Тогда
		
		СтаршийСмены = Результат.СтаршийСмены;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	АктивныеСмены.Регистратор.Вахта КАК Вахта
		|ИЗ
		|	РегистрСведений.АктивныеСмены КАК АктивныеСмены
		|ГДЕ
		|	АктивныеСмены.СменаОткрыта
		|	И АктивныеСмены.СтаршийСмены = &СтаршийСмены";
		
		Запрос.УстановитьПараметр("СтаршийСмены", СтаршийСмены);
		
		Результат = Запрос.Выполнить().Выбрать();
		
		Если Результат.Следующий() Тогда
			
			ВахтаНСЦ = Результат.Вахта;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ВахтаНСЦ;

КонецФункции

&НаСервере
Процедура ЗаполнитьСтруктуруПараметров(СтруктураПараметров)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	АктивныеСмены.Период КАК Период,
		|	АктивныеСмены.Регистратор КАК Регистратор
		|ПОМЕСТИТЬ ВТ_Регистр
		|ИЗ
		|	РегистрСведений.АктивныеСмены КАК АктивныеСмены
		|ГДЕ
		|	АктивныеСмены.Подразделение = &Подразделение
		|	И АктивныеСмены.СтаршийСмены = &СтаршийСмены
		|	И АктивныеСмены.СменаОткрыта
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(ВТ_Регистр.Период) КАК Период
		|ПОМЕСТИТЬ ВТ_ПоследняяЗаписьПоПодразделению
		|ИЗ
		|	ВТ_Регистр КАК ВТ_Регистр
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_Регистр.Регистратор.Вахта КАК Вахта,
		|	ВТ_Регистр.Регистратор.Смена КАК Смена,
		|	ВТ_Регистр.Регистратор.ДатаНачалаСмены КАК ДатаНачалаСмены,
		|	ВТ_Регистр.Регистратор.ДатаОкончанияСмены КАК ДатаОкончанияСмены
		|ИЗ
		|	ВТ_Регистр КАК ВТ_Регистр
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ПоследняяЗаписьПоПодразделению КАК ВТ_ПоследняяЗаписьПоПодразделению
		|		ПО ВТ_Регистр.Период = ВТ_ПоследняяЗаписьПоПодразделению.Период";
	
	Запрос.УстановитьПараметр("Подразделение", Автор.Подразделение);
	Запрос.УстановитьПараметр("СтаршийСмены", Автор);
	
	Результат = Запрос.Выполнить().Выбрать();
	
	Если Результат.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(СтруктураПараметров, Результат);
	КонецЕсли;   	
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Автор = ПараметрыСеанса.ТекущийПользователь;
	ДатаПриемаСмены = ОперативныйЖурнал.ПолучитьДатуПриемаСмены(Автор);
	ЗаполнитьСписокСотрудников();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОборудованияПриИзменении(Элемент)
	
	ТекДанные = Элементы.СписокОборудования.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СписокОборудования.НайтиСтроки(Новый Структура("Оборудование", ТекДанные.Оборудование)).Количество() > 1 Тогда
		ПоказатьПредупреждение(,"Данное оборудование уже есть в табличной части!");
		СписокОборудования.Удалить(ТекДанные);
		Возврат;
	КонецЕсли;
	
	ТекДанные.ДиспетчерскоеНаименование = ПолучитьДиспетчерскоеНаименование(ТекДанные.Оборудование);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДиспетчерскоеНаименование(Оборудование)
	
	Возврат Оборудование.ДиспетчерскоеНаименование;
	
КонецФункции

&НаКлиенте
Процедура ВыбратьВсехСотрудников(Команда)
	
	Для Каждого СтрСотрудник Из СписокСотрудников Цикл
		СтрСотрудник.Выбран = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВсехСотрудников(Команда)
	
	Для Каждого СтрСотрудник Из СписокСотрудников Цикл
		СтрСотрудник.Выбран = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ДатаСобытия = ТекущаяДата();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаСобытияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ДатаПриемаСмены) Тогда
		Если ДатаСобытия < ДатаПриемаСмены Тогда
			ПоказатьПредупреждение(, "Нельзя создать документ ранее начала приема смены (" + Формат(ДатаПриемаСмены, "ДЛФ=DDT") + ").");
			ДатаСобытия = ДатаПриемаСмены + 1;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры























