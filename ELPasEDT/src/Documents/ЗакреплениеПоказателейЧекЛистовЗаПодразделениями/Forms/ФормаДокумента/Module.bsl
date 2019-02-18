
&НаСервереБезКонтекста
Функция ПолучитьЗначениеРеквизита(Объект, Реквизит)
	Возврат Объект[Реквизит];
КонецФункции

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	Объект.Организация = ПолучитьЗначениеРеквизита(Объект.Подразделение, "Организация");
КонецПроцедуры 

&НаКлиенте
Процедура ЧекЛистПоказательПриИзменении(Элемент)
	
	ТекДанные = Элементы.ЧекЛист.ТекущиеДанные;
	ТекДанные.ЕдиницаИзмерения = ПолучитьЕдиницуСервер(ТекДанные.Показатель);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьЕдиницуСервер(Показатель)
	
	Возврат Показатель.ЕдиницаИзмерения;
	
КонецФункции 

&НаКлиенте
Процедура Подбор(Команда)
	
	Настройки = Новый НастройкиКомпоновкиДанных;
 
    ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
     
	Форма = ОткрытьФорму("Справочник.ПоказателиЧекЛиста.ФормаВыбора", ПараметрыФормы, ЭтаФорма); 
	Форма.АвтоЗаголовок = Ложь;
	Форма.Заголовок = "Подбор показателей Чек- листов";
	
КонецПроцедуры

&НаКлиенте
Процедура ЧекЛистПриИзменении(Элемент)
	
	ТекДанные = Элементы.ЧекЛист.ТекущиеДанные;
	Если Не ТекДанные = Неопределено Тогда
		Если Объект.ЧекЛист.НайтиСтроки(Новый Структура("Показатель", ТекДанные.Показатель)).Количество() > 1 Тогда
			ПоказатьПредупреждение(,"Данный показатель уже есть в табличной части!");
			НомерСтроки = Объект.ЧекЛист.НайтиСтроки(Новый Структура("Показатель", ТекДанные.Показатель))[1].НомерСтроки;
			Объект.ЧекЛист.Удалить(НомерСтроки-1);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.ПоказателиЧекЛиста") Тогда
		
		Если Объект.ЧекЛист.НайтиСтроки(Новый Структура("Показатель", ВыбранноеЗначение)).Количество() > 0 Тогда
			ПоказатьПредупреждение(,"Данный показатель уже есть в табличной части!");
			Возврат;
		КонецЕсли;
		ДобавитьПоказатель(ВыбранноеЗначение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПоказатель(Показатель)
	
	НовСтр = Объект.ЧекЛист.Добавить();
	НовСтр.Показатель = Показатель;
	НовСтр.ЕдиницаИзмерения = Показатель.ЕдиницаИзмерения;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		Объект.Комментарий = "";
		Объект.Ответственный = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииДанныхНаСервере(ДатаДокумента)
	
	СтруктураДанных = РапортСервер.ДокументУжеСоздан(Объект.Ссылка.Метаданные(), ДатаДокумента, Объект.Подразделение);
	АдресХранилища = ПоместитьВоВременноеХранилище(СтруктураДанных, ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриИзмененииДанныхНаСервере(ТекущаяДата());
		СтруктураДанных = ПолучитьИзВременногоХранилища(АдресХранилища);
		Если Не СтруктураДанных.ДокументРапорта = Неопределено Тогда
			Отказ = Истина;
			РапортКлиент.ПоказатьИнформациюПоРапорту(СтруктураДанных, ЭтаФорма);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ПриИзмененииДанныхНаСервере(Объект.Дата);	
	СтруктураДанных = ПолучитьИзВременногоХранилища(АдресХранилища);
	Если Не СтруктураДанных.ДокументРапорта = Неопределено Тогда
		Модифицированность = Ложь;
		Закрыть();
		РапортКлиент.ПоказатьИнформациюПоРапорту(СтруктураДанных, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры















