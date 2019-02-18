#Область ОписаниеПеременных

&НаКлиенте
Перем Ссылка1;

&НаКлиенте
Перем Ссылка2;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаголовокОшибки = НСтр("ru = 'Ошибка при настройке динамического списка присоединенных файлов.'");
	ОкончаниеОшибки = НСтр("ru = 'В этом случае настройка динамического списка невозможна.'");
	
	ИмяСправочникаХранилищаВерсийФайлов = РаботаСФайламиСлужебный.ИмяСправочникаХраненияВерсийФайлов(
		Параметры.Файл.ВладелецФайла, "", ЗаголовокОшибки, ОкончаниеОшибки);
		
	Если Не ПустаяСтрока(ИмяСправочникаХранилищаВерсийФайлов) Тогда
		НастроитьДинамическийСписок(ИмяСправочникаХранилищаВерсийФайлов);
	КонецЕсли;
	
	ВидимостьКомандыСравнить = 
		Не ОбщегоНазначенияКлиентСервер.ЭтоLinuxКлиент() И Не ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент();
	Элементы.ФормаСравнить.Видимость = ВидимостьКомандыСравнить;
	Элементы.КонтекстноеМенюСписокСравнить.Видимость = ВидимостьКомандыСравнить;
	
	УникальныйИдентификаторКарточкиФайла = Параметры.УникальныйИдентификаторКарточкиФайла;
	
	Список.Параметры.УстановитьЗначениеПараметра("Владелец", Параметры.Файл);
	ВладелецВерсии = Параметры.Файл;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СделатьАктивнойВыполнить()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НоваяАктивнаяВерсия = ТекущиеДанные.Ссылка;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайла(ТекущиеДанные.Владелец, ТекущиеДанные.Ссылка);
	
	Если ЗначениеЗаполнено(ДанныеФайла.Редактирует) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Смена активной версии разрешена только для незанятых файлов.'"));
	ИначеЕсли ДанныеФайла.ПодписанЭП Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Смена активной версии разрешена только для неподписанных файлов.'"));
	Иначе
		СменитьАктивнуюВерсиюФайла(НоваяАктивнаяВерсия);
		Оповестить("Запись_Файл", Новый Структура("Событие", "АктивнаяВерсияИзменена"), Параметры.Файл);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Файл"
	   И Параметр.Свойство("Событие")
	   И (    Параметр.Событие = "ЗаконченоРедактирование"
	      Или Параметр.Событие = "ВерсияСохранена") Тогда
		
		Если Параметры.Файл = Источник Тогда
			
			Элементы.Список.Обновить();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(ТекущиеДанные.Владелец, ТекущиеДанные.Ссылка, УникальныйИдентификатор);
	РаботаСФайламиСлужебныйКлиент.ОткрытьВерсиюФайла(Неопределено, ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточку(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 
		
		Версия = ТекущиеДанные.Ссылка;
		
		ПараметрыОткрытияФормы = Новый Структура("Ключ", Версия);
		ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ВерсияПрисоединенногоФайла", ПараметрыОткрытияФормы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	ПометитьНаУдалениеСнятьПометку();
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьНаУдаление(Команда)
	
	ПометитьНаУдалениеСнятьПометку();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 
		
		Версия = ТекущиеДанные.Ссылка;
		
		ПараметрыОткрытияФормы = Новый Структура("Ключ", Версия);
		ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ВерсияПрисоединенногоФайла", ПараметрыОткрытияФормы);
		
	КонецЕсли;
	
КонецПроцедуры

// Сравнить 2 выбранные версии. 
&НаКлиенте
Процедура Сравнить(Команда)
	
	ЧислоВыделенныхСтрок = Элементы.Список.ВыделенныеСтроки.Количество();
	
	Если ЧислоВыделенныхСтрок = 2 ИЛИ ЧислоВыделенныхСтрок = 1 Тогда
		Если ЧислоВыделенныхСтрок = 2 Тогда
			Ссылка1 = Элементы.Список.ВыделенныеСтроки[0];
			Ссылка2 = Элементы.Список.ВыделенныеСтроки[1];
		ИначеЕсли ЧислоВыделенныхСтрок = 1 Тогда
			Ссылка1 = Элементы.Список.ТекущиеДанные.Ссылка;
			Ссылка2 = Элементы.Список.ТекущиеДанные.РодительскаяВерсия;
		КонецЕсли;
		
		Расширение = НРег(Элементы.Список.ТекущиеДанные.Расширение);
		
		РаботаСФайламиСлужебныйКлиент.СравнитьФайлы(УникальныйИдентификатор, Ссылка1, Ссылка2, Расширение, ВладелецВерсии);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	ЧислоВыделенныхСтрок = Элементы.Список.ВыделенныеСтроки.Количество();
	
	КомандаСравненияДоступна = Ложь;
	
	Если ЧислоВыделенныхСтрок = 2 Тогда
		КомандаСравненияДоступна = Истина;
	ИначеЕсли ЧислоВыделенныхСтрок = 1 Тогда
		
		Если Не Элементы.Список.ТекущиеДанные.РодительскаяВерсия.Пустая() Тогда
			КомандаСравненияДоступна = Истина;
		Иначе
			КомандаСравненияДоступна = Ложь;
		КонецЕсли;
			
	Иначе
		КомандаСравненияДоступна = Ложь;
	КонецЕсли;

	Если КомандаСравненияДоступна = Истина Тогда
		Элементы.ФормаСравнить.Доступность = Истина;
		Элементы.КонтекстноеМенюСписокСравнить.Доступность = Истина;
	Иначе
		Элементы.ФормаСравнить.Доступность = Ложь;
		Элементы.КонтекстноеМенюСписокСравнить.Доступность = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВерсию(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(ТекущиеДанные.Владелец, ТекущиеДанные.Ссылка ,УникальныйИдентификатор);
	РаботаСФайламиСлужебныйКлиент.ОткрытьВерсиюФайла(Неопределено, ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляСохранения(ТекущиеДанные.Владелец, ТекущиеДанные.Ссылка , УникальныйИдентификатор);
	РаботаСФайламиСлужебныйКлиент.СохранитьКак(Неопределено, ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СменитьАктивнуюВерсиюФайла(Версия)
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		
		ЭлементБлокировкиДанных = Блокировка.Добавить(Метаданные.НайтиПоТипу(ТипЗнч(Версия.Владелец)).ПолноеИмя());
		ЭлементБлокировкиДанных.УстановитьЗначение("Ссылка", Версия.Владелец);
		
		ЭлементБлокировкиДанных = Блокировка.Добавить(Метаданные.НайтиПоТипу(ТипЗнч(Версия)).ПолноеИмя());
		ЭлементБлокировкиДанных.УстановитьЗначение("Ссылка", Версия);
		
		Блокировка.Заблокировать();
		
		ЗаблокироватьДанныеДляРедактирования(Версия.Владелец, , УникальныйИдентификаторКарточкиФайла);
		ЗаблокироватьДанныеДляРедактирования(Версия, , УникальныйИдентификаторКарточкиФайла);
		
		ФайлОбъект = Версия.Владелец.ПолучитьОбъект();
		Если ФайлОбъект.ПодписанЭП Тогда
			ВызватьИсключение НСтр("ru = 'У подписанного файла нельзя изменять активную версию.'");
		КонецЕсли;
		ФайлОбъект.ТекущаяВерсия = Версия;
		ФайлОбъект.ТекстХранилище = Версия.ТекстХранилище;
		ФайлОбъект.Записать();
		
		ВерсияОбъект = Версия.ПолучитьОбъект();
		ВерсияОбъект.Записать();
		
		РазблокироватьДанныеДляРедактирования(ФайлОбъект.Ссылка, УникальныйИдентификаторКарточкиФайла);
		РазблокироватьДанныеДляРедактирования(Версия, УникальныйИдентификаторКарточкиФайла);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ОтменитьТранзакцию();
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
	КонецПопытки;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПометкуУдаления(Версия, Пометка)
	ВерсияОбъект = Версия.ПолучитьОбъект();
	ВерсияОбъект.Заблокировать();
	ВерсияОбъект.УстановитьПометкуУдаления(Пометка);
КонецПроцедуры

&НаКлиенте
Процедура ПометитьНаУдалениеСнятьПометку()
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ПометкаУдаления Тогда 
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Снять с ""%1"" пометку на удаление?'"),
			Строка(ТекущиеДанные.Ссылка));
	Иначе
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Пометить ""%1"" на удаление?'"),
			Строка(ТекущиеДанные.Ссылка));
	КонецЕсли;
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ТекущиеДанные", ТекущиеДанные);
	Обработчик = Новый ОписаниеОповещения("ПометитьНаУдалениеСнятьПометкуЗавершение", ЭтотОбъект, ПараметрыОбработчика);
	ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
КонецПроцедуры

&НаКлиенте
Процедура ПометитьНаУдалениеСнятьПометкуЗавершение(Ответ, ПараметрыВыполнения) Экспорт
	Если Ответ <> КодВозвратаДиалога.Да Тогда 
		Возврат;
	КонецЕсли;
	ЗначениеПометкиУдаления = Не ПараметрыВыполнения.ТекущиеДанные.ПометкаУдаления;
	УстановитьПометкуУдаления(ПараметрыВыполнения.ТекущиеДанные.Ссылка, ЗначениеПометкиУдаления);
	
	Если ПараметрыВыполнения.ТекущиеДанные.ПометкаУдаления Тогда
		ПараметрыВыполнения.ТекущиеДанные.ИндексКартинкиТекущий = 1;
	Иначе
		ПараметрыВыполнения.ТекущиеДанные.ИндексКартинкиТекущий = ПараметрыВыполнения.ТекущиеДанные.ИндексКартинки;
	КонецЕсли;
	Элементы.Список.Обновить();
КонецПроцедуры

&НаСервере
Процедура НастроитьДинамическийСписок(ИмяСправочникаХранилищаВерсийФайлов)
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	
	ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВерсииФайлов.Код КАК Код,
		|	ВерсииФайлов.Размер КАК Размер,
		|	ВерсииФайлов.Комментарий КАК Комментарий,
		|	ВерсииФайлов.Автор КАК Автор,
		|	ВерсииФайлов.ДатаСоздания КАК ДатаСоздания,
		|	ВерсииФайлов.ПолноеНаименование КАК ПолноеНаименование,
		|	ВерсииФайлов.РодительскаяВерсия КАК РодительскаяВерсия,
		|	ВерсииФайлов.ИндексКартинки,
		|	ВЫБОР
		|		КОГДА ВерсииФайлов.ПометкаУдаления
		|			ТОГДА ВерсииФайлов.ИндексКартинки + 1
		|		ИНАЧЕ ВерсииФайлов.ИндексКартинки
		|	КОНЕЦ КАК ИндексКартинкиТекущий,
		|	ВерсииФайлов.ПометкаУдаления КАК ПометкаУдаления,
		|	ВерсииФайлов.Владелец КАК Владелец,
		|	ВерсииФайлов.Ссылка КАК Ссылка,
		|	ВЫБОР
		|		КОГДА ВерсииФайлов.Владелец.ТекущаяВерсия = ВерсииФайлов.Ссылка
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ЭтоТекущая,
		|	ВерсииФайлов.Расширение КАК Расширение,
		|	ВерсииФайлов.НомерВерсии КАК НомерВерсии
		|ИЗ
		|	Справочник." + ИмяСправочникаХранилищаВерсийФайлов + " КАК ВерсииФайлов
		|ГДЕ
		|	ВерсииФайлов.Владелец = &Владелец";
	
	ПолноеИмяСправочника = "Справочник." + ИмяСправочникаХранилищаВерсийФайлов;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяСправочника", ПолноеИмяСправочника);
	
	СвойстваСписка.ОсновнаяТаблица  = ПолноеИмяСправочника;
	СвойстваСписка.ДинамическоеСчитываниеДанных = Истина;
	СвойстваСписка.ТекстЗапроса = ТекстЗапроса;
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СвойстваСписка);
	
КонецПроцедуры

#КонецОбласти
