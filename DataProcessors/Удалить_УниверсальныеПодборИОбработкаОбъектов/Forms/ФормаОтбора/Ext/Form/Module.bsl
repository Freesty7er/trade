﻿// Добавляет отбор в набор отборов компоновщика или группы отборов
//
Функция ДобавитьОтбор(ЭлементСтруктуры, Знач Поле, Значение, ВидСравнения = Неопределено, Использование = Истина) Экспорт
	
	Если ТипЗнч(Поле) = Тип("Строка") Тогда
		Поле = Новый ПолеКомпоновкиДанных(Поле);
	КонецЕсли;
	
	Если ТипЗнч(ЭлементСтруктуры) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		Отбор = ЭлементСтруктуры.Настройки.Отбор;
	Иначе
		Отбор = ЭлементСтруктуры;
	КонецЕсли;
	
	Если ВидСравнения = Неопределено Тогда
		ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	КонецЕсли;
	
	НовыйЭлемент = Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	НовыйЭлемент.Использование  = Использование;
	НовыйЭлемент.ЛевоеЗначение  = Поле;
	НовыйЭлемент.ВидСравнения   = ВидСравнения;
	НовыйЭлемент.ПравоеЗначение = Значение;
	Возврат НовыйЭлемент;
	
КонецФункции

&НаСервере
Функция ПолучитьРезультат(НачатьПоиск = Ложь)
	СтруктураРезультата = Новый Структура;
	СтруктураРезультата.Вставить("ТекстЗапроса", ТекстЗапроса);
	СтруктураРезультата.Вставить("ТекстПроизвольногоЗапроса", ТекстПроизвольногоЗапроса);
	СтруктураРезультата.Вставить("СтрокаПоиска", СтрокаПоиска);
	СтруктураРезультата.Вставить("СтрокаПоискаСписок", Элементы.СтрокаПоиска.СписокВыбора.ВыгрузитьЗначения());
	СтруктураРезультата.Вставить("Настройки", ОтборДанных.ПолучитьНастройки());
	СтруктураРезультата.Вставить("РежимПоиска", РежимПоиска);
	СтруктураРезультата.Вставить("ПараметрыЗапроса", ПараметрыЗапроса);
	СтруктураРезультата.Вставить("НачатьПоиск", НачатьПоиск);
	
	Возврат СтруктураРезультата;
КонецФункции

&НаСервере
Процедура ЗаполнитьНастройки(Настройки)
	
	СхемаКомпоновки = Новый СхемаКомпоновкиДанных();		
    	
	Источник = СхемаКомпоновки.ИсточникиДанных.Добавить();
	Источник.Имя = "ИсточникДанных";
	Источник.СтрокаСоединения="";
	Источник.ТипИсточникаДанных = "local";
	
	НаборДанных = СхемаКомпоновки.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.Запрос = ТекстЗапроса;
	НаборДанных.Имя = "НаборДанныхЗапроса";
	НаборДанных.ИсточникДанных = Источник.Имя;
	НаборДанных.АвтоЗаполнениеДоступныхПолей = Истина;
	
	АдресСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновки, УникальныйИдентификатор);
	ОтборДанных.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы)); 
	
	Если Настройки <> Неопределено Тогда
		ОтборДанных.ЗагрузитьНастройки(Настройки);
	КонецЕсли;
	ОтборДанных.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.Полное);
	ОтборДанных.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	
	Если ОтборДанных.Настройки.Отбор.Элементы.Количество() = 0 Тогда
		Для каждого ЭлементДоступногоОтбора Из ОтборДанных.Настройки.ДоступныеПоляОтбора.Элементы Цикл    
			ДобавитьОтбор(ОтборДанных.Настройки.Отбор, ЭлементДоступногоОтбора.Поле, , ВидСравненияКомпоновкиДанных.Равно, Ложь);
		КонецЦикла; //Для каждого ЭлементДоступногоОтбора Из   
	КонецЕсли; 
	
	Если ОтборДанных.Настройки.Порядок.Элементы.Количество() = 0 Тогда
		Для каждого ЭлементДоступногоПорядка Из ОтборДанных.Настройки.ДоступныеПоляПорядка.Элементы Цикл    
			НовыйПорядок = ОтборДанных.Настройки.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
		    НовыйПорядок.Использование = Ложь;
		    НовыйПорядок.Поле = ЭлементДоступногоПорядка.Поле;
		    НовыйПорядок.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
		КонецЦикла; //Для каждого ЭлементДоступногоПорядка Из   
	КонецЕсли; 
	
	Если ОтборДанных.Настройки.Выбор.Элементы.Количество() = 0 Тогда
		НовыйЭлемент = ОтборДанных.Настройки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		НовыйЭлемент.Использование = Истина;
		НовыйЭлемент.Поле = Новый ПолеКомпоновкиДанных("СистемныеПоля.НомерПоПорядку"); //SystemFields.GroupSerialNumber
		
		Для каждого ЭлементДоступногоВыбора Из ОтборДанных.Настройки.ДоступныеПоляВыбора.Элементы Цикл    
			Если НЕ ЭлементДоступногоВыбора.Папка Тогда
				Если ИменаПолейТЧ.НайтиПоЗначению(ЭлементДоступногоВыбора.Поле) = Неопределено Тогда
					НовыйЭлемент = ОтборДанных.Настройки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
				    НовыйЭлемент.Использование = Истина;
				    НовыйЭлемент.Поле = ЭлементДоступногоВыбора.Поле;
				КонецЕсли; 
			КонецЕсли; 
		КонецЦикла; //Для каждого ЭлементДоступногоВыбора Из   
		
		Если ИменаПолейТЧ.Количество() > 0 Тогда
			
			ГруппаЭлементов = ОтборДанных.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			ГруппаЭлементов.Использование = Истина;
			ГруппаЭлементов.Заголовок = НСтр("ru = 'Агрегатные поля'");
			
			Для каждого ЭлементМассива Из ИменаПолейТЧ Цикл    
				Если ОтборДанных.Настройки.ДоступныеПоляВыбора.НайтиПоле(ЭлементМассива.Значение) <> Неопределено Тогда
					НовыйЭлемент = ГруппаЭлементов.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
				    НовыйЭлемент.Использование = Истина;
				    НовыйЭлемент.Поле = ЭлементМассива.Значение;
				КонецЕсли; 
			КонецЦикла; //Для каждого ЭлементМассива Из  
			
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьПараметрыЗапроса()
	Если ПустаяСтрока(ТекстЗапроса) Тогда
		Возврат "Отсутствует текст запроса.";
	КонецЕсли;
	
	Запрос = Новый Запрос(ТекстПроизвольногоЗапроса);
	Попытка
		ПараметрыВЗапросе = Запрос.НайтиПараметры();
	Исключение
		Возврат ОписаниеОшибки();
	КонецПопытки;
	
	Для каждого ПараметрЗапроса Из ПараметрыВЗапросе Цикл
		ИмяПараметра =  ПараметрЗапроса.Имя;
		СтрокаПараметров = ПараметрыЗапроса.НайтиСтроки(Новый Структура("ИмяПараметра", ИмяПараметра));
		Если  СтрокаПараметров.Количество() = 0 Тогда
			СтрокаПараметров = ПараметрыЗапроса.Добавить();
			СтрокаПараметров.ИмяПараметра = ИмяПараметра;
		Иначе 
			СтрокаПараметров = СтрокаПараметров[0];
		КонецЕсли; 
		
		СтрокаПараметров.ЗначениеПараметра = ПараметрЗапроса.ТипЗначения.ПривестиЗначение(СтрокаПараметров.ЗначениеПараметра);
	КонецЦикла;
	
	Возврат Истина;
КонецФункции

&НаСервере
Процедура УстановитьВидимостьДоступность()
	Если РежимПоиска = 1 Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ПроизвольныйЗапрос;
	Иначе
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ОтборПоЗначениямРеквизитов;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ТекстЗапроса = Параметры.ТекстЗапроса;
	ТекстПроизвольногоЗапроса = Параметры.ТекстПроизвольногоЗапроса;
	СтрокаПоиска = Параметры.СтрокаПоиска;
	Если Параметры.Свойство("СтрокаПоискаСписок") Тогда
		Элементы.СтрокаПоиска.СписокВыбора.ЗагрузитьЗначения(Параметры.СтрокаПоискаСписок);
	КонецЕсли; 
	
	Элементы.РежимПоиска.СписокВыбора.Добавить(0, "Отбор по реквизитам");
	Элементы.РежимПоиска.СписокВыбора.Добавить(1, "Произвольный запрос");
	
	РежимПоиска = Параметры.РежимПоиска;
	ПараметрыЗапроса.Загрузить(Параметры.ПараметрыЗапроса.Выгрузить());
	
	ИменаПолейТЧ = Параметры.ИменаПолейТЧ;
	
	Заголовок = Заголовок + " [" + Параметры.ОбъектПоиска.Представление + "]";
	
	Настройки = Параметры.Настройки;
	ЗаполнитьНастройки(Настройки);
	
	УстановитьВидимостьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	#Если ТолстыйКлиентУправляемоеПриложение  Тогда
	Элементы.КонтекстноеМенюТекстЗапросаКонструкторЗапроса.Доступность = Истина;
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыЗапросаЗначениеПараметраОчистка(Элемент, СтандартнаяОбработка)
	Элемент.ВыбиратьТип = Истина;
КонецПроцедуры

&НаКлиенте
Процедура РежимПоискаПриИзменении(Элемент)
	УстановитьВидимостьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(СтрокаПоиска) Тогда
		СписокВыбора = Элементы.СтрокаПоиска.СписокВыбора;
		ПозицияСтроки = СписокВыбора.НайтиПоЗначению(СтрокаПоиска);
		Если ПозицияСтроки = Неопределено Тогда
			СписокВыбора.Вставить(0, СтрокаПоиска);
		Иначе
			СписокВыбора.Сдвинуть(ПозицияСтроки, - СписокВыбора.Индекс(ПозицияСтроки));
		КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПрименитьОтбор(Команда)
	Закрыть(ПолучитьРезультат(Ложь));
КонецПроцедуры

&НаКлиенте
Процедура НайтиОбъекты(Команда)
	Закрыть(ПолучитьРезультат(Истина));
КонецПроцедуры

&НаКлиенте
Процедура КонструкторЗапроса(Команда)
	#Если ТолстыйКлиентУправляемоеПриложение  Тогда
	КонструкторЗапроса = Новый КонструкторЗапроса;
	
	Если НЕ ПустаяСтрока(ТекстЗапроса) Тогда 
		КонструкторЗапроса.Текст = ТекстЗапроса;
	КонецЕсли;
	
	Если КонструкторЗапроса.ОткрытьМодально() Тогда 
		ТекстЗапроса = КонструкторЗапроса.Текст;
	КонецЕсли;
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПараметры(Команда)
	Результат = ЗаполнитьПараметрыЗапроса();
	Если Результат <> Истина Тогда
		Предупреждение(Результат, 60, "Ошибка!");
	КонецЕсли;
КонецПроцедуры