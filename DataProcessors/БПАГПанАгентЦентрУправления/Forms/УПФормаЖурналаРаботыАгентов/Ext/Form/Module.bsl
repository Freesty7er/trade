﻿Перем КаталогОбмена, ОбновитьКарту;

Функция ПолучитьXML(Настройки) Экспорт

	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку();
	СериализаторXDTO.ЗаписатьXML(ЗаписьXML, Настройки, "settingsComposition", "http://v8.1c.ru/8.1/data-composition-system/settings");

	Возврат ЗаписьXML.Закрыть();

КонецФункции

Функция ПолучитьНастройкиИзXML(ТекстXML) Экспорт

	Если ТекстXML = "" Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ЧтениеXML = Новый ЧтениеXML;
 	ЧтениеXML.УстановитьСтроку(ТекстXML);
	
	Возврат СериализаторXDTO.ПрочитатьXML(ЧтениеXML, Тип("ПользовательскиеНастройкиКомпоновкиДанных"));

КонецФункции

Функция ПолучитьАгентовСОтбором(ОтборПоАгентам)
	
	ОбъектОбработка = РеквизитФормыВЗначение("Объект");
	СхемаКомпоновкиДанных = ОбъектОбработка.ПолучитьМакет("СКДАгенты");
	
	НастройкиКомпоновкиДанных = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	
	Для Каждого ЭлементОтбора Из НастройкиКомпоновкиДанных.Отбор.Элементы Цикл
		Если ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Агент") Тогда
			НастройкиКомпоновкиДанных.Отбор.Элементы.Удалить(ЭлементОтбора);
		КонецЕсли;
	КонецЦикла;
	ЭлементОтбора = НастройкиКомпоновкиДанных.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Агент"); 
	ЭлементОтбора.ВидСравнения = ОтборПоАгентам.ВидСравнения; 
	ЭлементОтбора.ПравоеЗначение = ОтборПоАгентам.ПравоеЗначение; 
	ЭлементОтбора.Использование = ОтборПоАгентам.Использование;	
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));

	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных);

	ТаблицаРезультат = Новый ТаблицаЗначений;
		
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(ТаблицаРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);

    Возврат ТаблицаРезультат;
КонецФункции

&НаСервере
Процедура ОбновитьЛоги(СписокКодовАгентов)

	// Загрузка накопленных автоматических логов
	Запрос = Новый Запрос();
	Запрос.Текст =
	"ВЫБРАТЬ
	|	БПАГАгенты.Ссылка КАК Агент,
	|	БПАГАгенты.Код КАК Код
	|ИЗ
	|	Справочник.БПАГАгенты КАК БПАГАгенты
	|ГДЕ
	|	НЕ БПАГАгенты.ПометкаУдаления
	|	И БПАГАгенты.Код В(&СписокКодовАгентов)";
	
	Запрос.УстановитьПараметр("СписокКодовАгентов", СписокКодовАгентов);
	
	ТЗАгенты = Запрос.Выполнить().Выгрузить();
	
	ОбъектОбработка = РеквизитФормыВЗначение("Объект");
	ОбъектОбработка.ОбновитьКэшНастроекАгентов();
	ОбъектОбработка.ЗагрузитьЖурналРаботы(ТЗАгенты);
	
КонецПроцедуры	

&НаКлиенте
Процедура Сформировать(Команда)
	
	Период = ПолучитьПериодИзНастроек();
	
	Если (Период.ДатаНачала < Дата(2000, 1, 1)) ИЛИ (Период.ДатаОкончания < Дата(2000, 1, 1)) Тогда
		Предупреждение("Неверно указан период!");
		Возврат;
	КонецЕсли;	
	
	Если Период.ДатаНачала > Период.ДатаОкончания Тогда
		Предупреждение("Неверно указан период!");
		Возврат;
	КонецЕсли;
	
	ОбновитьКарту = Истина;
	ЗагрузитьТаблицуЛога();
КонецПроцедуры

Функция ПолучитьПериодИзНастроек()
	
	Компоновщик.ЗагрузитьНастройки(Компоновщик.ПолучитьНастройки());
	
	Период = Неопределено;
	тмпЭлемент = Компоновщик.Настройки.ПараметрыДанных.Элементы.Найти("Период");
	Если тмпЭлемент <> Неопределено Тогда
		Период = тмпЭлемент.Значение;
	КонецЕсли;
	
	Если Период = Неопределено Тогда
		Период = Новый СтандартныйПериод(НачалоДня(ТекущаяДата()), КонецДня(ТекущаяДата()));
	КонецЕсли;
	
	Возврат	Период;
КонецФункции

Процедура ЗагрузитьТаблицуЛога()
	
	Для Каждого тмпЭлемент Из Компоновщик.Настройки.Отбор.Элементы Цикл
		Если СокрЛП(тмпЭлемент.ЛевоеЗначение) = "Агент" Тогда
			ОтборПоАгентам = тмпЭлемент;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ТЗАгенты = ПолучитьАгентовСОтбором(ОтборПоАгентам);
	
	Агенты = ТЗАгенты.ВыгрузитьКолонку("Агент");
	
	Объект.ЛогАгента.Очистить();
	
	Если Агенты.Количество() > 1 Тогда
		ВыводитьЛинии = Ложь;
	Иначе
		ВыводитьЛинии = Истина;
	КонецЕсли;
	
	СписокКодовАгентов = Новый СписокЗначений;
	Для Каждого текАгент Из Агенты Цикл
		СписокКодовАгентов.Добавить(текАгент.Код);
	КонецЦикла;
	ОбновитьЛоги(СписокКодовАгентов);
	
	Для Каждого текАгент Из Агенты Цикл
		ОбъектОбработка = РеквизитФормыВЗначение("Объект");
		ТЗ = Новый ТаблицаЗначений();
		СписокФайловЛога = ОбъектОбработка.ПолучитьМассивФайловЛога(Период.ДатаНачала, КонецДня(Период.ДатаОкончания), текАгент.Код);
		Для Каждого ФайлЛога Из СписокФайловЛога Цикл
			ИмяФайлаИсточника = КаталогОбмена + СокрЛП(текАгент.Код) + "\Logs\" + ФайлЛога.Представление + ".plist";
			ФайлЗагрузки = Новый Файл(ИмяФайлаИсточника);
			Если ФайлЗагрузки.Существует() Тогда
				Если ТЗ.Количество() = 0 Тогда
					ТЗ = ОбъектОбработка.ПолучитьТЗЛога(текАгент, ФайлЛога , "Logs");	
				Иначе
					ВремТЗ = ОбъектОбработка.ПолучитьТЗЛога(текАгент, ФайлЛога , "Logs");
					Если ВремТЗ <> Неопределено Тогда
						Для Каждого СтрокаТЗ Из ВремТЗ Цикл
							НоваяСтрока = ТЗ.Добавить();
							ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЗ);
						КонецЦикла;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		Если ТЗ.Количество() = 0 Тогда
			Продолжить; 
		КонецЕсли;
		
		// Переименование колонок
		ТекКолонка = ТЗ.Колонки.Найти("date");
		ТекКолонка.Имя = "Дата";
		ТекКолонка = ТЗ.Колонки.Найти("batteryLevel");
		ТекКолонка.Имя = "УровеньЗарядаБатареии";
		ТекКолонка = ТЗ.Колонки.Найти("locationLatitude");
		ТекКолонка.Имя = "Широта";
		ТекКолонка = ТЗ.Колонки.Найти("locationLongitude");
		ТекКолонка.Имя = "Долгота";
		ТекКолонка = ТЗ.Колонки.Найти("uniqueID");
		ТекКолонка.Имя = "ID";
		ТекКолонка = ТЗ.Колонки.Найти("locationDate");
		ТекКолонка.Имя = "ДатаОпределенияКоординат";
		ТекКолонка = ТЗ.Колонки.Найти("locationSystemEnabled");
		ТекКолонка.Имя = "РазрешенGPS";
		ТекКолонка = ТЗ.Колонки.Найти("locationAppEnabled");
		ТекКолонка.Имя = "РазрешенGPSДляПриложения";
		ТекКолонка = ТЗ.Колонки.Найти("type");
		ТекКолонка.Имя = "Тип";
		ТекКолонка = ТЗ.Колонки.Найти("locationSpeed");
		ТекКолонка.Имя = "СкоростьВМоментОпределенияКоординат";
		ТекКолонка = ТЗ.Колонки.Найти("locationAccuracy");
		ТекКолонка.Имя = "ТочностьОпределенияКоординат";
		ТекКолонка = ТЗ.Колонки.Найти("data");
		ТекКолонка.Имя = "Данные";
		
		ТЗ.Колонки.Добавить("IDДокумента");
		ТЗ.Колонки.Добавить("КодОрганизации");
		ТЗ.Колонки.Добавить("КодАгента");
		ТЗ.Колонки.Добавить("КодТТ");
		ТЗ.Колонки.Добавить("КодВариантаАнкеты");
		
		Для Каждого СтрокаТЗ Из ТЗ Цикл
			
			СтрокаТЗ.КодАгента = текАгент.Код;

			Если СтрокаТЗ.Данные = Неопределено Тогда
				СтрокаТЗ.Данные = Новый Структура;
			Иначе
				Если СтрокаТЗ.Данные.Свойство("uniqueID") Тогда
					СтрокаТЗ.IDДокумента = СтрокаТЗ.Данные.uniqueID;
				Иначе
					СтрокаТЗ.IDДокумента = "";
				КонецЕсли;
				
				Если СтрокаТЗ.Данные.Свойство("companyID") Тогда
					СтрокаТЗ.КодОрганизации = СтрокаТЗ.Данные.companyID;
				Иначе
					СтрокаТЗ.КодОрганизации = "";
				КонецЕсли;
				
				Если СтрокаТЗ.Данные.Свойство("posID") Тогда
					СтрокаТЗ.КодТТ = СтрокаТЗ.Данные.posID;
				Иначе
					СтрокаТЗ.КодТТ = "";
				КонецЕсли;
				
				Если СтрокаТЗ.Данные.Свойство("questionnaireTypeID") Тогда
					СтрокаТЗ.КодВариантаАнкеты = СтрокаТЗ.Данные.questionnaireTypeID;
				Иначе
					СтрокаТЗ.КодВариантаАнкеты = "";
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
		
		ТЗСТипами = Новый ТаблицаЗначений;
		ТЗСТипами.Колонки.Добавить("ID", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(20)));
		ТЗСТипами.Колонки.Добавить("Дата", Новый ОписаниеТипов("Дата"));
		ТЗСТипами.Колонки.Добавить("Тип", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(20)));
		ТЗСТипами.Колонки.Добавить("РазрешенGPS", Новый ОписаниеТипов("Булево"));
		ТЗСТипами.Колонки.Добавить("РазрешенGPSДляПриложения", Новый ОписаниеТипов("Булево"));
		ТЗСТипами.Колонки.Добавить("Широта", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(20)));
		ТЗСТипами.Колонки.Добавить("Долгота", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(20)));
		ТЗСТипами.Колонки.Добавить("ДатаОпределенияКоординат", Новый ОписаниеТипов("Дата"));
		ТЗСТипами.Колонки.Добавить("ТочностьОпределенияКоординат", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(20)));
		ТЗСТипами.Колонки.Добавить("СкоростьВМоментОпределенияКоординат", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(20)));
		
		ТЗСТипами.Колонки.Добавить("УровеньЗарядаБатареии", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(20)));
		ТЗСТипами.Колонки.Добавить("Данные", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(1024)));
		ТЗСТипами.Колонки.Добавить("IDДокумента", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(100)));
		ТЗСТипами.Колонки.Добавить("КодОрганизации", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(20)));
		ТЗСТипами.Колонки.Добавить("КодТТ", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(20)));
		ТЗСТипами.Колонки.Добавить("КодАгента", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(20)));
		ТЗСТипами.Колонки.Добавить("КодВариантаАнкеты", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(20)));
		
		Для Каждого СтрокаТЗ Из ТЗ Цикл
			СтрокаДанных = "";
			Если НЕ СтрокаТЗ.Данные = Неопределено Тогда
				Для Каждого СтрокаData Из СтрокаТЗ.Данные Цикл
					СтрокаДанных = СтрокаДанных + СтрокаData.Ключ + "," + СтрокаData.Значение + ",";
				КонецЦикла;
				СтрокаДанных = Лев(СтрокаДанных, СтрДлина(СтрокаДанных) - 1);
			КонецЕсли;
			СтрокаТЗ.Данные = СтрокаДанных;
			
			СтрокаТЗ.УровеньЗарядаБатареии = Число(СтрокаТЗ.УровеньЗарядаБатареии);
			СтрокаТЗ.СкоростьВМоментОпределенияКоординат = Число(СтрокаТЗ.СкоростьВМоментОпределенияКоординат);
			СтрокаТЗ.ТочностьОпределенияКоординат = Число(СтрокаТЗ.ТочностьОпределенияКоординат);
			
			Если СтрокаТЗ.РазрешенGPS = "1" Тогда
				СтрокаТЗ.РазрешенGPS = Истина;
			Иначе
				СтрокаТЗ.РазрешенGPS = Ложь;
			КонецЕсли;
			
			Если СтрокаТЗ.РазрешенGPSДляПриложения = "1" Тогда
				СтрокаТЗ.РазрешенGPSДляПриложения = Истина;
			Иначе
				СтрокаТЗ.РазрешенGPSДляПриложения = Ложь;
			КонецЕсли;
			
			НоваяСтрока = ТЗСТипами.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЗ);
		КонецЦикла;
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Табл", ТЗСТипами);
		МВТ = Новый МенеджерВременныхТаблиц;
		Запрос.МенеджерВременныхТаблиц = МВТ;
		
		Запрос.Текст = "ВЫБРАТЬ
		|	Табл.ID,
		|	Табл.Дата,
		|	Табл.Тип,
		|	Табл.РазрешенGPS,
		|	Табл.РазрешенGPSДляПриложения,
		|	Табл.Широта,
		|	Табл.Долгота,
		|	Табл.ДатаОпределенияКоординат,
		|	Табл.ТочностьОпределенияКоординат,
		|	Табл.СкоростьВМоментОпределенияКоординат,
		|	Табл.УровеньЗарядаБатареии,
		|	Табл.Данные,
		|	Табл.IDДокумента,
		|	Табл.КодОрганизации,
		|	Табл.КодАгента,
		|	Табл.КодТТ,
		|	Табл.КодВариантаАнкеты
		|ПОМЕСТИТЬ Табл
		|ИЗ
		|	&Табл КАК Табл";
		
		Запрос.Выполнить();
		Запрос.Текст = "ВЫБРАТЬ
		|	Табл.ID,
		|	Табл.Дата,
		|	Табл.Тип,
		|	Табл.РазрешенGPS,
		|	Табл.РазрешенGPSДляПриложения,
		|	Табл.Широта,
		|	Табл.Долгота,
		|	Табл.ДатаОпределенияКоординат,
		|	Табл.ТочностьОпределенияКоординат,
		|	Табл.СкоростьВМоментОпределенияКоординат,
		|	Табл.УровеньЗарядаБатареии,
		|	Табл.Данные,
		|	Табл.IDДокумента,
		|	Табл.КодОрганизации,
		|	Табл.КодАгента,
		|	Табл.КодТТ,
		|	Табл.КодВариантаАнкеты,
		|	БПАГДокументыАгентовСрезПоследних.Документ,
		|	БПАГОрганизации.Ссылка КАК Организация,
		|	БПАГТорговыеТочки.Ссылка КАК ТТ,
		|	БПАГАгенты.Ссылка КАК Агент,
		|	БПАГВидыАнкет.Ссылка КАК Анкета
		|ИЗ
		|	Табл КАК Табл
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.БПАГДокументыАгентов.СрезПоследних КАК БПАГДокументыАгентовСрезПоследних
		|		ПО Табл.IDДокумента = БПАГДокументыАгентовСрезПоследних.ИД
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.БПАГОрганизации КАК БПАГОрганизации
		|		ПО Табл.КодОрганизации = БПАГОрганизации.Код
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.БПАГАгенты КАК БПАГАгенты
		|		ПО Табл.КодАгента = БПАГАгенты.Код
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.БПАГТорговыеТочки КАК БПАГТорговыеТочки
		|		ПО Табл.КодТТ = БПАГТорговыеТочки.Код
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.БПАГВидыАнкет КАК БПАГВидыАнкет
		|		ПО Табл.КодВариантаАнкеты = БПАГВидыАнкет.Код";
		
		ТЗ =  Запрос.Выполнить().Выгрузить();
		// Прогоняем через СКД
		СКД = ОбъектОбработка.ПолучитьМакет("ОтборыЛогов");
		ТЗРезультат = РезультатКомпоновкиВТЗ(СКД, ТЗ);
		
		// Получаем список колонок
		КолонкиСтроки = Новый Массив;
		Для Каждого Колонка Из ТЗРезультат.Колонки Цикл
			КолонкиСтроки.Добавить(Колонка.Имя);
		КонецЦикла;
		
		ТЗРезультат.Колонки.Добавить("ТипПредставление");
		ТЗРезультат.Колонки.Добавить("IDЧисло");
		
		Для Каждого СтрокаТЗ Из ТЗРезультат Цикл
			СтрокаТЗ.ТипПредставление = ПолучитьПредставлениеТипаЛога(СтрокаТЗ.Тип);
			СтрокаТЗ.IDЧисло = Число(СтрокаТЗ.ID);
		КонецЦикла;
				
		Для Каждого СтрокаРезультат Из ТЗРезультат Цикл
			НоваяСтрока = Объект.ЛогАгента.Добавить();
		    ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаРезультат);
		КонецЦикла;
		
	КонецЦикла;
	
	Объект.ЛогАгента.Сортировать("IDЧисло");	
	
	Если Элементы.ГруппаДанных.ТекущаяСтраница.Имя = "ГруппаКарта" Тогда
		ВывестиHTMLКарты();
	КонецЕсли;
	
КонецПроцедуры

Функция РезультатКомпоновкиВТЗ(СКД, ТЗ) Экспорт
	
	НастройкиКомпоновщика = Компоновщик.Настройки;
	
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ИсточникДанных1", ТЗ );
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	Для Каждого тмпЭлемент Из НастройкиКомпоновщика.ПараметрыДанных.Элементы Цикл
		Если СокрЛП(тмпЭлемент.Параметр) = "НачалоПериода" Тогда
			тмпЭлемент.Значение = Период.ДатаНачала;
		ИначеЕсли СокрЛП(тмпЭлемент.Параметр) = "ОкончаниеПериода" Тогда
			тмпЭлемент.Значение = Период.ДатаОкончания;
		КонецЕсли;
	КонецЦикла;
	
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СКД, НастройкиКомпоновщика,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));

	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных, ВнешниеНаборыДанных);

	ТаблицаРезультат = Новый ТаблицаЗначений;
		
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(ТаблицаРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);

    Возврат ТаблицаРезультат;
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СхемаКомпоновкиДанных = РеквизитФормыВЗначение("Объект").ПолучитьМакет("ОтборыЛогов");
	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
	
	Компоновщик.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных));
	Компоновщик.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
КонецПроцедуры

Функция ПолучитьИконкуМаркера(Тип = Неопределено)
	Если Тип = Неопределено Тогда
		Возврат "http://www.google.com/mapfiles/marker.png";
	КонецЕсли;
	
	Попытка
		Тип = Формат(Тип, "ЧГ=");
	Исключение
	КонецПопытки;
	
	Если Тип = "0" Тогда
		Возврат "http://www.google.com/mapfiles/ms/micons/yellow-dot.png";
		//"Документ создан (новый)";
	ИначеЕсли Тип = "1" Тогда
		Возврат "http://www.google.com/mapfiles/ms/micons/green-dot.png";
		//"Документ сохранен";
	ИначеЕсли Тип = "2" Тогда
		Возврат "http://www.google.com/mapfiles/ms/micons/red-dot.png";
		//"Документ удален";
	ИначеЕсли Тип = "3" Тогда
		Возврат "http://www.google.com/mapfiles/ms/micons/yellow-dot.png";
		//"Документ открыт";
	ИначеЕсли Тип = "4" Тогда
		Возврат "http://www.google.com/mapfiles/ms/micons/red-dot.png";
		//"Документ закрыт (изменения не сохранены)";
	ИначеЕсли Тип = "5" Тогда
		Возврат "http://www.google.com/mapfiles/ms/micons/red-dot.png";
		//"Документ восстановлен после сбоя (открыт)";
	ИначеЕсли Тип = "6" Тогда
		Возврат "http://www.google.com/mapfiles/ms/micons/green-dot.png";
		//"Документ распечатан";
	ИначеЕсли Тип = "7" Тогда
		Возврат "http://www.google.com/mapfiles/ms/micons/yellow-dot.png";
		//"Документ создан автоматически (новый)";
	ИначеЕсли Тип = "8" Тогда
		Возврат "http://www.google.com/mapfiles/ms/micons/yellow-dot.png";
		//"Документ переоформлен автоматически";
	ИначеЕсли Тип = "101" Тогда
		Возврат "http://www.google.com/mapfiles/ms/micons/green-dot.png";
		//"Отчет распечатан";
	ИначеЕсли Тип = "201" Тогда
		Возврат "http://labs.google.com/ridefinder/images/mm_20_yellow.png";
		//"Установлены новые координаты ТТ";
	ИначеЕсли Тип = "202" Тогда
		Возврат "http://labs.google.com/ridefinder/images/mm_20_blue.png";
		//"Сделано фото";
	ИначеЕсли Тип = "301" Тогда
		Возврат "http://labs.google.com/ridefinder/images/mm_20_green.png";
		//"Обмен начат";
	ИначеЕсли Тип = "302" Тогда
		Возврат "http://labs.google.com/ridefinder/images/mm_20_green.png";
		//"Обмен завершен";
	ИначеЕсли Тип = "303" Тогда
		Возврат "http://labs.google.com/ridefinder/images/mm_20_red.png";
		//"Обмен завершен c ошибкой";
	ИначеЕсли Тип = "304" Тогда
		Возврат "http://labs.google.com/ridefinder/images/mm_20_red.png";
		//"Обмен остановлен пользователем";
	ИначеЕсли Тип = "401" Тогда
		Возврат "http://labs.google.com/ridefinder/images/mm_20_orange.png";
		//"Вход в базу (начало работы)";
	ИначеЕсли Тип = "402" Тогда
		Возврат "http://labs.google.com/ridefinder/images/mm_20_orange.png";
		//"Настройки базы изменены";
	ИначеЕсли Тип = "403" Тогда
		Возврат "http://labs.google.com/ridefinder/images/mm_20_orange.png";
		//"База восстановлена из бекапа";
	ИначеЕсли Тип = "501" Тогда
		Возврат "http://labs.google.com/ridefinder/images/mm_20_orange.png";
		//"Выход приложения из фона (показано окно приложения)";
	ИначеЕсли Тип = "502" Тогда
		Возврат "http://labs.google.com/ridefinder/images/mm_20_orange.png";
		//"Вход приложения в фон (окно приложения скрыто)";
	ИначеЕсли Тип = "601" Тогда
		Возврат "http://labs.google.com/ridefinder/images/mm_20_red.png";
		//"Пользователь запретил программе использовать GPS";
	ИначеЕсли Тип = "7001" Тогда
		Возврат "http://panagent.ru/1c/icons/routestart.png";
		//"Начало маршрута";
	ИначеЕсли Тип = "7002" Тогда
		Возврат "http://panagent.ru/1c/icons/routeend.png";
		//"Конец маршрута";
	Иначе
		Возврат "http://www.google.com/mapfiles/marker.png";
	КонецЕсли;
КонецФункции

Функция ПолучитьСтрокуМаркера(СтрокаТЗ)
	
	Строка = ПолучитьПредставлениеТипаЛога(СтрокаТЗ.Тип) + ": ";
	Строка = Строка + СтрокаТЗ.Дата;
	
	Если СокрЛП(СтрокаТЗ.Агент) <> "" Тогда
		Строка = Строка + "\n" + СокрЛП(СтрокаТЗ.Агент);
	КонецЕсли;
	
	Если СокрЛП(СтрокаТЗ.ТТ) <> "" Тогда
		Строка = Строка + "\n" + СокрЛП(СтрокаТЗ.ТТ.Владелец) + " " + СокрЛП(СтрокаТЗ.ТТ);
	КонецЕсли;
	
	Если СокрЛП(СтрокаТЗ.Документ) <> "" Тогда
		Строка = Строка + "\n" + СокрЛП(СтрокаТЗ.Документ);
	КонецЕсли;
	
	Если СокрЛП(СтрокаТЗ.Анкета) <> "" Тогда
		Строка = Строка + "\n" + СокрЛП(СтрокаТЗ.Анкета);
	КонецЕсли;
	
	Строка = СтрЗаменить(Строка, """", " ");
	
	Возврат Строка;
КонецФункции

Функция СтрокуЛогаВСтруктуруСОбъектами(ТекСтрока)	
	СтрокаТаб = Объект.ЛогАгента.НайтиПоИдентификатору(ТекСтрока);
	СтруктураЛога = Новый Структура;
	СтруктураЛога.Вставить("ID", СтрокаТаб.ID);
	СтруктураЛога.Вставить("Дата", СтрокаТаб.Дата);
	СтруктураЛога.Вставить("УровеньЗарядаБатареии", СтрокаТаб.УровеньЗарядаБатареии);
	СтруктураЛога.Вставить("Широта", СтрокаТаб.Широта);
	СтруктураЛога.Вставить("Долгота", СтрокаТаб.Долгота);
	СтруктураЛога.Вставить("ДатаОпределенияКоординат", СтрокаТаб.ДатаОпределенияКоординат);
	СтруктураЛога.Вставить("РазрешенGPS", СтрокаТаб.РазрешенGPS);
	СтруктураЛога.Вставить("РазрешенGPSДляПриложения", СтрокаТаб.РазрешенGPSДляПриложения);
	СтруктураЛога.Вставить("Тип", СтрокаТаб.Тип);
	СтруктураЛога.Вставить("СкоростьВМоментОпределенияКоординат", СтрокаТаб.СкоростьВМоментОпределенияКоординат);
	СтруктураЛога.Вставить("ТочностьОпределенияКоординат", СтрокаТаб.ТочностьОпределенияКоординат);
	СтруктураЛога.Вставить("ТипПредставление", СтрокаТаб.ТипПредставление);
	
	СтруктураДанных = Новый Структура;
	Если НЕ СтрокаТаб.Данные = "" тогда
		МассивДанных = РазложитьСтрокуВМассив(СтрокаТаб.Данные);
		Имя = "";
		Для Счет = 0 По МассивДанных.Количество() - 1 Цикл
			Если Счет = 0 Тогда
				Имя = МассивДанных[Счет];	
			ИначеЕсли Цел(Счет/2) = Счет/2 Тогда
				Имя = МассивДанных[Счет];
			Иначе	
				СтруктураДанных.Вставить(Имя ,МассивДанных[Счет]);
			КонецЕсли;
		КонецЦикла;	
	КонецЕсли;
	
	СтруктураДанных = НайтиСсылкиНаДокументы(СтруктураДанных, СтруктураЛога.Тип);
	
	СтруктураЛога.Вставить("Данные", СтруктураДанных);
		
	Возврат СтруктураЛога;
КонецФункции

Функция НайтиСсылкиНаДокументы(Данные, Тип);
	
	Структура = Данные;
		
	Если Данные.Свойство("uniqueID") Тогда
		Если Данные.uniqueID <> "" Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	БПАГДокументыАгентовСрезПоследних.Документ КАК Документ
			|ИЗ
			|	РегистрСведений.БПАГДокументыАгентов.СрезПоследних КАК БПАГДокументыАгентовСрезПоследних
			|ГДЕ
			|	БПАГДокументыАгентовСрезПоследних.ИД = &ИДДокумента";
			
			Запрос.УстановитьПараметр("ИДДокумента", Данные.uniqueID);
			
			Результат = Запрос.Выполнить().Выгрузить();
			
			Если Результат.Количество() > 0 Тогда
				Структура.Вставить("Ссылка", Результат[0].Документ);
			Иначе
				Если Данные.type = "Order" Тогда
					Структура.Вставить("Ссылка", Документы.ЗаказКлиента.ПустаяСсылка());
				ИначеЕсли  Данные.type = "Sale" Тогда
					Структура.Вставить("Ссылка", Документы.РеализацияТоваровУслуг.ПустаяСсылка());
				КонецЕсли;
				// **** Дописать
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Данные.Свойство("date") Тогда
		Если Данные.date <> "" Тогда
			Данные.date = ПолучитьДатуИВремяGMT(Данные.date);
		КонецЕсли;
	КонецЕсли;
	
	Если Данные.Свойство("status") Тогда
		Если Данные.status <> "" Тогда
			ПредставлениеСтатуса = "";
			
			Если Данные.status = "0" Тогда
				ПредставлениеСтатуса = "Документ недооформлен";
			ИначеЕсли Данные.status = "1" Тогда
				ПредставлениеСтатуса = "Документ готов к отправке";
			ИначеЕсли Данные.status = "2" Тогда
				ПредставлениеСтатуса = "Документ напечатан и готов к отправке";
			ИначеЕсли Данные.status = "11" Тогда
				ПредставлениеСтатуса = "Документ отправлен в Центр";
			ИначеЕсли Данные.status = "12" Тогда
				ПредставлениеСтатуса = "Документ сохранен и проведен в учетной системе";
			ИначеЕсли Данные.status = "13" Тогда
				ПредставлениеСтатуса = "Документ сохранен, но не проведен в учетной системе";
			ИначеЕсли Данные.status = "14" Тогда
				ПредставлениеСтатуса = "Документ удален либо помечен на удаление";
			КонецЕсли;
			
			Структура.Вставить("ПредставлениеСтатуса", ПредставлениеСтатуса);
		КонецЕсли;
	КонецЕсли;
	
	Если Данные.Свойство("companyID") Тогда
		Если Данные.companyID <> "" Тогда
			Структура.Вставить("ОрганизацияСсылка", Справочники.БПАГОрганизации.НайтиПоКоду(Данные.companyID));
		КонецЕсли;
	КонецЕсли;
	
	Если Данные.Свойство("posID") Тогда	
		Если Данные.posID <> "" Тогда
			Структура.Вставить("ТорговаяТочкаСсылка", Справочники.БПАГТорговыеТочки.НайтиПоКоду(Данные.posID));
		КонецЕсли;
	КонецЕсли;
	
	Если Данные.Свойство("questionnaireTypeID") Тогда
		Если Данные.questionnaireTypeID <> "" Тогда
			Структура.Вставить("АнкетаСсылка", Справочники.БПАГВидыАнкет.НайтиПоКоду(Данные.questionnaireTypeID));
		КонецЕсли;
	КонецЕсли;
	
	Возврат Структура;		
КонецФункции

&НаКлиенте
Процедура ОтобразитьДанныеСтрокиЛога(ТекСтрока)
	СтрукутураСтроки = СтрокуЛогаВСтруктуруСОбъектами(ТекСтрока);
	
	ПараметрыФормы = Новый Структура;	
	ПараметрыФормы.Вставить("ДанныеЛога", СтрукутураСтроки);
  
	ФормаМаршрута = ОткрытьФормуМодально("Обработка.БПАГПанАгентЦентрУправления.Форма.УПФормаРасшифровкиЖурнала", ПараметрыФормы);
КонецПроцедуры

&НаКлиенте
Процедура ЛогАгентаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	// Формирование ключа
	СписокЗнаений = Новый СписокЗначений;
	ТекСтрока = Элемент.Текущаястрока;
	
	ОтобразитьДанныеСтрокиЛога(ТекСтрока);
КонецПроцедуры

Функция РазложитьСтрокуВМассив(Знач Стр, Разделитель = ",") Экспорт	
	МассивСтрок = Новый Массив();
	Если Разделитель = " " Тогда
		Стр = СокрЛП(Стр);
		Пока 1=1 Цикл
			Поз = Найти(Стр,Разделитель);
			Если Поз=0 Тогда
				МассивСтрок.Добавить(Стр);
				Возврат МассивСтрок;
			КонецЕсли;
			МассивСтрок.Добавить(Лев(Стр,Поз-1));
			Стр = СокрЛ(Сред(Стр,Поз));
		КонецЦикла;
	Иначе
		ДлинаРазделителя = СтрДлина(Разделитель);
		Пока 1=1 Цикл
			Поз = Найти(Стр,Разделитель);
			Если Поз=0 Тогда
				МассивСтрок.Добавить(Стр);
				Возврат МассивСтрок;
			КонецЕсли;
			МассивСтрок.Добавить(Лев(Стр,Поз-1));
			Стр = Сред(Стр,Поз+ДлинаРазделителя);
		КонецЦикла;
	КонецЕсли;	
КонецФункции

Функция ПолучитьДатуИВремяGMT(СтрокаДаты)
	
	Если СтрокаДаты = "" Тогда
		Возврат Дата("00010101");	
	КонецЕсли;
	
	Если СтрокаДаты = "01.01.0001 0:00:00" Тогда
		Возврат Дата("00010101");
	КонецЕсли;
	
	СтрокаДатаВремя = Строка(СтрокаДаты); 	
	ПозицияGMT = Найти(СтрокаДатаВремя, "GMT");
	Если ПозицияGMT <> 0 Тогда
		СтрокаДатаВремя = Лев(СтрокаДатаВремя, ПозицияGMT - 2);
	КонецЕсли;
	СтрокаДатаВремя = СтрЗаменить(СтрокаДатаВремя, " ", ",");
	СтрокаДатаВремя = СтрЗаменить(СтрокаДатаВремя, ":", ",");
	СтрокаДатаВремя = СтрЗаменить(СтрокаДатаВремя, ".", ",");
	МассивДаты = РазложитьСтрокуВМассив(СтрокаДатаВремя);
	ДатаВремя = Дата(МассивДаты[2], МассивДаты[1], МассивДаты[0], МассивДаты[3], МассивДаты[4], МассивДаты[5]);

	Возврат ДатаВремя;
	
КонецФункции

Функция ПолучитьПредставлениеТипаЛога(Тип)
	Если Тип = "0" Тогда
		Возврат "Документ создан (новый)";
	ИначеЕсли Тип = "1" Тогда
		Возврат "Документ сохранен";
	ИначеЕсли Тип = "2" Тогда
		Возврат "Документ удален";
	ИначеЕсли Тип = "3" Тогда
		Возврат "Документ открыт";
	ИначеЕсли Тип = "4" Тогда
		Возврат "Документ закрыт (изменения не сохранены)";
	ИначеЕсли Тип = "5" Тогда
		Возврат "Документ восстановлен после сбоя (открыт)";
	ИначеЕсли Тип = "6" Тогда
		Возврат "Документ распечатан";
	ИначеЕсли Тип = "7" Тогда
		Возврат "Документ создан автоматически (новый)";
	ИначеЕсли Тип = "8" Тогда
		Возврат "Документ переоформлен автоматически";
	ИначеЕсли Тип = "101" Тогда
		Возврат "Отчет распечатан";
	ИначеЕсли Тип = "201" Тогда
		Возврат "Установлены новые координаты ТТ";
	ИначеЕсли Тип = "202" Тогда
		Возврат "Сделано фото";
	ИначеЕсли Тип = "301" Тогда
		Возврат "Обмен начат";
	ИначеЕсли Тип = "302" Тогда
		Возврат "Обмен завершен";
	ИначеЕсли Тип = "303" Тогда
		Возврат "Обмен завершен c ошибкой";
	ИначеЕсли Тип = "304" Тогда
		Возврат "Обмен остановлен пользователем";
	ИначеЕсли Тип = "401" Тогда
		Возврат "Вход в базу (начало работы)";
	ИначеЕсли Тип = "402" Тогда
		Возврат "Настройки базы изменены";
	ИначеЕсли Тип = "403" Тогда
		Возврат "База восстановлена из бекапа";
	ИначеЕсли Тип = "501" Тогда
		Возврат "Выход приложения из фона (показано окно приложения)";
	ИначеЕсли Тип = "502" Тогда
		Возврат "Вход приложения в фон (окно приложения скрыто)";
	ИначеЕсли Тип = "601" Тогда
		Возврат "Пользователь запретил программе использовать GPS";
	ИначеЕсли Тип = "602" Тогда
		Возврат "Фоновое получение GPS-координат";
	ИначеЕсли Тип = "7001" Тогда
		Возврат "Начало маршрута";
	ИначеЕсли Тип = "7002" Тогда
		Возврат "Конец маршрута";
	Иначе	
		Возврат "";
	КонецЕсли;	
КонецФункции

Функция ПроверитьНаличиеНастройкиВыгрузкиЛога()
	ВидНастройкиПоследнегоIDЛога = Справочники.БПАГВидыНастроекАгентов.НайтиПоКоду("processedLogID");
	НаборЗаписей = РегистрыСведений.БПАГНастройкиАгентов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ВидНастройки.Установить(ВидНастройкиПоследнегоIDЛога);
	НаборЗаписей.Прочитать();
	Если НаборЗаписей.Количество() = 0 Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	НастройкиПрисутствуют = ПроверитьНаличиеНастройкиВыгрузкиЛога();
	Если Не НастройкиПрисутствуют Тогда
		Сообщить("В настройках агента не установлен параметр ""Отправлять журнал действий с устройства""!", СтатусСообщения.Важное);
	КонецЕсли;
	
	Элементы.ПользовательскиеНастройки.Видимость = Истина;
	ОбновитьКарту = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтбор(Команда)
	УправлениеВидимостью();
КонецПроцедуры

&НаКлиенте
Процедура УправлениеВидимостью()
	ПолеHTMLДокументаКарта = "";
	Элементы.ПользовательскиеНастройки.Видимость = НЕ Элементы.ПользовательскиеНастройки.Видимость;
	Элементы.ПоказатьОтбор.Заголовок = ?(Элементы.ПользовательскиеНастройки.Видимость, "Скрыть отбор", "Показать отбор");
	Сформировать(Неопределено);
КонецПроцедуры

Процедура ВывестиHTMLКарты()
	Если ОбновитьКарту = Ложь Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаКоординат = "";
	// Выводим на карту
	ВывелиМаркерНачалаМаршрута = Ложь;
	ПоследняяСтрокаТЗСКоординатами = Неопределено;
	Для Каждого СтрокаТЗ Из Объект.ЛогАгента Цикл
		Если СтрДлина(СтрЗаменить(СтрокаТЗ.Широта, "0", "")) < 2 Или СтрДлина(СтрЗаменить(СтрокаТЗ.Долгота, "0", "")) < 2 Тогда
			// Нулевые координаты
		Иначе
			Если Не ВывелиМаркерНачалаМаршрута Тогда
				//Маркер начала маршрута
				ВывелиМаркерНачалаМаршрута = Истина;
				
				СтрокаМаркера = СокрЛП(СтрокаТЗ.Дата) + " Начало маршрута" + "\n";
				Если СокрЛП(СтрокаТЗ.Агент) <> "" Тогда
					СтрокаМаркера = СтрокаМаркера + СокрЛП(СтрокаТЗ.Агент);
				КонецЕсли;
				СтрокаМаркера = СтрЗаменить(СтрокаМаркера, """", " ");
				
				СтрокаКоординат = "[""" + СтрокаМаркера + """, " + СтрокаТЗ.Широта + ", " + СтрокаТЗ.Долгота + ", '" + ПолучитьИконкуМаркера(7001) + "', " + "1" + "],";
			КонецЕсли;
			
			СтрокаМаркера = ПолучитьСтрокуМаркера(СтрокаТЗ);
			Если СтрокаТЗ.Тип = "602" Тогда
				СтрокаКоординат = СтрокаКоординат + "[""" + СтрокаМаркера + """, " + СтрокаТЗ.Широта + ", " + СтрокаТЗ.Долгота + ", '" + ПолучитьИконкуМаркера(СтрокаТЗ.Тип) + "', " + "0" + "],";
			Иначе
				СтрокаКоординат = СтрокаКоординат + "[""" + СтрокаМаркера + """, " + СтрокаТЗ.Широта + ", " + СтрокаТЗ.Долгота + ", '" + ПолучитьИконкуМаркера(СтрокаТЗ.Тип) + "', " + "1" + "],";
			КонецЕсли;
			ПоследняяСтрокаТЗСКоординатами = СтрокаТЗ;
		КонецЕсли;
	КонецЦикла;
	
	//Маркер конца маршрута
	Если ПоследняяСтрокаТЗСКоординатами <> Неопределено Тогда
		
		СтрокаМаркера = СокрЛП(ПоследняяСтрокаТЗСКоординатами.Дата) + " Конец маршрута" + "\n";
		Если СокрЛП(ПоследняяСтрокаТЗСКоординатами.Агент) <> "" Тогда
			СтрокаМаркера = СтрокаМаркера + СокрЛП(ПоследняяСтрокаТЗСКоординатами.Агент);
		КонецЕсли;
		СтрокаМаркера = СтрЗаменить(СтрокаМаркера, """", " ");
		
		СтрокаКоординат = СтрокаКоординат + "[""" + СтрокаМаркера + """, " + ПоследняяСтрокаТЗСКоординатами.Широта + ", " + ПоследняяСтрокаТЗСКоординатами.Долгота + ", '" + ПолучитьИконкуМаркера(7002) + "', " + "1" + "]";
	ИначеЕсли СтрДлина(СтрокаКоординат) > 0 Тогда
		СтрокаКоординат = Лев(СтрокаКоординат, СтрДлина(СтрокаКоординат) - 1);
	КонецЕсли;
	
	Текст = 
	"<HTML><HEAD><TITLE>Карты Google</TITLE>
	|<META name=viewport content=""initial-scale=1.0, user-scalable=yes""></META>
	|<META content=""text/html; charset=UTF-8"" http-equiv=content-type></META>
	|<SCRIPT type=text/javascript src=""http://maps.google.com/maps/api/js?sensor=false""></SCRIPT>
	|<SCRIPT type=text/javascript>
	|
	|var map;
    |
  	|function drawRoute() {
	| 	var agentRoute = [" + СтрокаКоординат + "
	|  	];
	|	
	|	var bounds = new google.maps.LatLngBounds();	 
    |	var coords = new Array(agentRoute.length);
    |	// Markers
    |	for (var i = 0; i < agentRoute.length; i++) {
	|		var place = agentRoute[i];
    |	    var myLatLng = new google.maps.LatLng(place[1], place[2]);
    |	    bounds.extend(myLatLng);
	|		coords[i] = myLatLng;
    |	    
	|		if (place[4]) {
	|		var marker = new google.maps.Marker({
    |	        position: myLatLng,
    |	        title: place[0],
	|			icon:place[3] 
    |	    });
	|		marker.setMap(map);
	|		}
    |	}";
	Если ВыводитьЛинии Тогда
	Текст = Текст + 
 	"	// Polyline
    |	var polyline = new google.maps.Polyline({
	|       path: coords,
    |	    strokeColor: ""#0000AA"",
    |	    strokeOpacity: 1.0,
    |	    strokeWeight: 2
    |	});
    |	polyline.setMap(map);";
	КонецЕсли;
	Текст = Текст +
	"	// Center
	|	map.setCenter(bounds.getCenter(), map.fitBounds(bounds));
	|
  	|}
    |
	|function onLoad() {
    |	var myOptions = {
    |		mapTypeId: google.maps.MapTypeId.ROADMAP,
    |		mapTypeControl: true,
    |		mapTypeControlOptions: {
    |			style: window.google.maps.MapTypeControlStyle.DROPDOWN_MENU
    |		}
    |	}
    |	map = new google.maps.Map(document.getElementById(""map_canvas""), myOptions);
    |	drawRoute();
	|}
    |
	|window.onload = onLoad;  
    |
	|</SCRIPT>
	|
	|</HEAD>
	|<body onload=""onLoad()"">
	|  <div id=""map_canvas"" style=""width:100%; height:100%""></div>
	|</body>
	|</html>";
	
	ПолеHTMLДокументаКарта = Текст;	
	ОбновитьКарту = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ГруппаДанныхПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если Элемент.ТекущаяСтраница.Имя = "ГруппаКарта" Тогда
		ВывестиHTMLКарты();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	СтрокаСохраненныхНастроек = ПолучитьXML(Компоновщик.ПользовательскиеНастройки);
	Настройки["СтрокаСохраненныхНастроек"] = СтрокаСохраненныхНастроек;
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	СтрокаСохраненныхНастроек = Настройки["СтрокаСохраненныхНастроек"];
	Попытка
		Компоновщик.ЗагрузитьПользовательскиеНастройки(ПолучитьНастройкиИзXML(СтрокаСохраненныхНастроек));
	Исключение
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКарту(Команда)
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.ДобавитьСтроку(ПолеHTMLДокументаКарта);
    ТекстовыйДокумент.Записать("c:\Temp\Карта.html");
	
КонецПроцедуры

КаталогОбмена = БПАГ.БПАГПолучитьНастройку("1СКаталогОбмена");
