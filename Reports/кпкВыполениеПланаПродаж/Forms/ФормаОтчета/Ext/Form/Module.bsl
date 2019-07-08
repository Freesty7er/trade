﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ДатаНач = НачалоМесяца(ТекущаяДата());
	ДатаКон = КонецМесяца(ТекущаяДата());
	ВнеПлана = Истина;
	ТипОтчета = 3;
	ПланФормирования = 0;
КонецПроцедуры

&НаСервере
Функция ПроверкаФормы()
	ВсеХорошо = Истина;
	
	Если ДатаНач>ДатаКон Тогда 
		ВсеХорошо = Ложь;
	КонецЕсли;
	
	Если ПолеАгент = Справочники.ФизическиеЛица.ПустаяСсылка() Тогда
		ВсеХорошо = Ложь;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Пожалуйста выберите Агента!!!";
		Сообщение.Сообщить(); 
	КонецЕсли; 
	
	Возврат ВсеХорошо;
КонецФункции

&НаКлиенте
Процедура ДатаНачПриИзменении(Элемент)
	ДатаНач = ДатаНач;
КонецПроцедуры

&НаКлиенте
Процедура ДатаКонПриИзменении(Элемент)
	ДатаКон = ДатаКон;
КонецПроцедуры

&НаСервере
Функция ПолучитьТекстЗапросаДляПродаж()
	
	ТекстУсл = "";
	
	Группа      = ПолеГруппа;
	Внеплана    = ВнеПлана;
	РежимДатыБД = ПланФормирования;
	ТипОтчета   = ТипОтчета;
	ТипПлана    = ТипыПлана;
	
	Если Не Внеплана Тогда  		
		Если ТипОтчета = 1 Тогда
			ТекстУсл = "
			|ГДЕ
			|	Основной.КоличествоПлан <> 0";
		ИначеЕсли ТипОтчета = 2 Тогда
			ТекстУсл = "
			|ГДЕ		
			|	Основной.СуммаПлан <> 0";		
		Иначе
			ТекстУсл = "
			|ГДЕ
			|	Основной.КоличествоПлан <> 0
			|	И Основной.СуммаПлан <> 0";		
		КонецЕсли;
	КонецЕсли; 
	
	Если Не ТипПлана.Пустая() Тогда
		Если ТекстУсл = "" Тогда
			ТекстУсл = "
			|ГДЕ 
			|	Основной.ТипПлана = &ТипПлана";
		Иначе
			ТекстУсл = ТекстУсл + " И Основной.ТипПлана = &ТипПлана";
		КонецЕсли;
	КонецЕсли;
	
	Если РежимДатыБД Тогда
		ТекстДаты = "кпкСведенияДокумента.КПКДокумент.Дата МЕЖДУ &ДатаНач И &ДатаКон";						
	Иначе
		ТекстДаты = "кпкСведенияДокумента.ДатаВремяСоздания МЕЖДУ &ДатаНач И &ДатаКон";		
	КонецЕсли; 			
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Основной.НоменклатурнаяГруппа КАК НоменклатурнаяГруппа,
	|	Основной.КоличествоФакт КАК КоличествоФакт,
	|	Основной.СуммаФакт КАК СуммаФакт,
	|	Основной.КоличествоПлан КАК КоличествоПлан,
	|	Основной.СуммаПлан КАК СуммаПлан,
	|	Основной.КоличествоФакт - Основной.КоличествоПлан КАК ОтклонениеКоличество,
	|	Основной.СуммаФакт - Основной.СуммаПлан КАК ОтклонениеСумма,
	|	ВЫБОР
	|		КОГДА Основной.КоличествоПлан = 0
	|			ТОГДА 100
	|		ИНАЧЕ 100 * Основной.КоличествоФакт / Основной.КоличествоПлан
	|	КОНЕЦ КАК ПроцентКоличество,
	|	ВЫБОР
	|		КОГДА Основной.СуммаПлан = 0
	|			ТОГДА 100
	|		ИНАЧЕ 100 * Основной.СуммаФакт / Основной.СуммаПлан
	|	КОНЕЦ КАК ПроцентСумма
	|ИЗ
	|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		ЕСТЬNULL(Продажи.НоменклатурнаяГруппа, ЭталонныеДанные.НоменклатурнаяГруппа) КАК НоменклатурнаяГруппа,
	|		СУММА(ЕСТЬNULL(Продажи.КоличествоОборот, 0)) КАК КоличествоФакт,
	|		СУММА(ЕСТЬNULL(Продажи.СтоимостьОборот, 0)) КАК СуммаФакт,
	|		СУММА(ЕСТЬNULL(ЭталонныеДанные.КоличествоПлан, 0)) КАК КоличествоПлан,
	|		СУММА(ЕСТЬNULL(ЭталонныеДанные.СуммаПлан, 0)) КАК СуммаПлан,
	|		ЕСТЬNULL(ЭталонныеДанные.ТипПлана, """") КАК ТипПлана
	|	ИЗ
	|		(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|			СУММА(ЭталонныеДанные.КоличествоОборот) КАК КоличествоПлан,
	|			СУММА(ЭталонныеДанные.СуммаОборот) КАК СуммаПлан,
	|			ЭталонныеДанные.НоменклатурнаяГруппа КАК НоменклатурнаяГруппа,
	|			ЭталонныеДанные.ДокументПланирования.ТипПланированияПродаж КАК ТипПлана
	|		ИЗ
	|			РегистрНакопления.кпкПланыПродаж.Обороты(&ДатаНач, &ДатаКон, , Агент = &Агент" + ?(Не Группа.Пустая(), " И НоменклатурнаяГруппа = &Группа", "") + ") КАК ЭталонныеДанные
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ЭталонныеДанные.НоменклатурнаяГруппа,
	|			ЭталонныеДанные.ДокументПланирования.ТипПланированияПродаж) КАК ЭталонныеДанные
	|			ПОЛНОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
	|				СУММА(Продажи.КоличествоОборот) КАК КоличествоОборот,
	|				СУММА(Продажи.СебестоимостьОборот) КАК СтоимостьОборот,
	|				Продажи.Номенклатура.НоменклатурнаяГруппа КАК НоменклатурнаяГруппа
	|			ИЗ
	|				(ВЫБРАТЬ
	|					кпкСведенияДокумента.КПКДокумент КАК КПКДокумент,
	|					кпкСведенияДокумента.Агент КАК Агент,
	|					кпкСведенияДокумента.ДатаВремяСоздания КАК ДатаВремяСоздания,
	|					кпкСсылкиДокументов.Документ КАК Документ
	|				ИЗ
	|					РегистрСведений.кпкСведенияДокумента КАК кпкСведенияДокумента
	|						ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.кпкСсылкиДокументов КАК кпкСсылкиДокументов
	|						ПО кпкСведенияДокумента.КПКДокумент = кпкСсылкиДокументов.Ссылка
	|							И кпкСведенияДокумента.Агент = кпкСсылкиДокументов.Агент
	|				ГДЕ " + ТекстДаты + "
	|					И кпкСведенияДокумента.Агент = &Агент
	|					И (кпкСведенияДокумента.КПКДокумент.ПометкаУдаления = ЛОЖЬ
	|							ИЛИ кпкСсылкиДокументов.Документ.ПометкаУдаления = ЛОЖЬ)) КАК ДокументыКПК
	|					ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.Продажи.Обороты(" + ?(РежимДатыБД, "&ДатаНач", "") + "," + ?(РежимДатыБД, "&ДатаКон", "") + ", ," + ?(Не Группа.Пустая(), "Номенклатура.НоменклатурнаяГруппа = &Группа", "") + ") КАК Продажи
	|					ПО (Продажи.ЗаказПокупателя = ДокументыКПК.КПКДокумент
	|							ИЛИ Продажи.Документ = ДокументыКПК.КПКДокумент
	|							ИЛИ Продажи.Документ = ДокументыКПК.Документ)
	|			ГДЕ
	|				(НЕ Продажи.Документ ЕСТЬ NULL )
	|			
	|			СГРУППИРОВАТЬ ПО
	|				Продажи.Номенклатура.НоменклатурнаяГруппа) КАК Продажи
	|			ПО ЭталонныеДанные.НоменклатурнаяГруппа = Продажи.НоменклатурнаяГруппа
	|		
	|	СГРУППИРОВАТЬ ПО
	|		ЕСТЬNULL(ЭталонныеДанные.ТипПлана, """"),
	|		ЕСТЬNULL(Продажи.НоменклатурнаяГруппа, ЭталонныеДанные.НоменклатурнаяГруппа)) КАК Основной " + ТекстУсл + "
	|ИТОГИ
	|	СУММА(КоличествоФакт),
	|	СУММА(СуммаФакт),
	|	СУММА(КоличествоПлан),
	|	СУММА(СуммаПлан),
	|	СУММА(ОтклонениеКоличество),
	|	СУММА(ОтклонениеСумма),
	|	ВЫБОР
	|		КОГДА СУММА(Основной.КоличествоПлан) = 0
	|			ТОГДА 100
	|		ИНАЧЕ 100 * СУММА(Основной.КоличествоФакт) / СУММА(Основной.КоличествоПлан)
	|	КОНЕЦ КАК ПроцентКоличество,
	|	ВЫБОР
	|		КОГДА СУММА(Основной.СуммаПлан) = 0
	|			ТОГДА 100
	|		ИНАЧЕ 100 * СУММА(Основной.СуммаФакт) / СУММА(Основной.СуммаПлан)
	|	КОНЕЦ КАК ПроцентСумма
	|ПО
	|	ОБЩИЕ,
	|	НоменклатурнаяГруппа"; 	
	
	Возврат ТекстЗапроса;

КонецФункции //ПолучитьТекстЗапросаДляПродаж()

&НаСервере
Процедура СформироватьОтчет()
	
	Агент       = ПолеАгент;
	Группа      = ПолеГруппа;
	Внеплана    = ВнеПлана;
	РежимДатыБД = ПланФормирования;
	ТипОтчета   = ТипОтчета;
	ТипПлана    = ТипыПлана;
	ДатаНач     = НачалоДня(ДатаНач);
	ДатаКон     = КонецДня(ДатаКон);
	
	Запрос = Новый Запрос;
	Запрос.Текст = ПолучитьТекстЗапросаДляПродаж();
	Запрос.УстановитьПараметр("Агент",    Агент);
	Запрос.УстановитьПараметр("ДатаНач",  ДатаНач);
	Запрос.УстановитьПараметр("ДатаКон",  ДатаКон);
	Запрос.УстановитьПараметр("Группа",   Группа);
	Запрос.УстановитьПараметр("ТипПлана", ТипПлана);
	
	Результат.Очистить();
	
	Макет = Отчеты.кпкВыполениеПланаПродаж.ПолучитьМакет("ПланПродаж");
	
	Результат.НачатьАвтогруппировкуСтрок();
	
	ОбластьЗаголовок    = Макет.ПолучитьОбласть("Заголовок");
	ОбластьПараметр     = Макет.ПолучитьОбласть("Параметр");
	ОбластьПараметрВып  = Макет.ПолучитьОбласть("ПарВып");
	
	ОбластьШапка     		= Макет.ПолучитьОбласть("Шапка|Нач");
	ОбластьШапкаПланКол     = Макет.ПолучитьОбласть("Шапка|ПланКол");
	ОбластьШапкаПланСум     = Макет.ПолучитьОбласть("Шапка|ПланСум");
	ОбластьШапкаФактКол     = Макет.ПолучитьОбласть("Шапка|ФактКол");
	ОбластьШапкаФактСум     = Макет.ПолучитьОбласть("Шапка|ФактСум");
	//
	ОбластьШапкаОтклКол     = Макет.ПолучитьОбласть("Шапка|ОтклКол");
	ОбластьШапкаОтклСум     = Макет.ПолучитьОбласть("Шапка|ОтклСум");
	ОбластьШапкаПроцКол     = Макет.ПолучитьОбласть("Шапка|ПроцКол");
	ОбластьШапкаПроцСум     = Макет.ПолучитьОбласть("Шапка|ПроцСум");
	
	/////
	ОбластьСтрока   		 = Макет.ПолучитьОбласть("Строка|Нач");
	ОбластьСтрокаПланКол     = Макет.ПолучитьОбласть("Строка|ПланКол");
	ОбластьСтрокаПланСум     = Макет.ПолучитьОбласть("Строка|ПланСум");
	ОбластьСтрокаФактКол     = Макет.ПолучитьОбласть("Строка|ФактКол");
	ОбластьСтрокаФактСум     = Макет.ПолучитьОбласть("Строка|ФактСум");
	//
	ОбластьСтрокаОтклКол     = Макет.ПолучитьОбласть("Строка|ОтклКол");
	ОбластьСтрокаОтклСум     = Макет.ПолучитьОбласть("Строка|ОтклСум");
	ОбластьСтрокаПроцКол     = Макет.ПолучитьОбласть("Строка|ПроцКол");
	ОбластьСтрокаПроцСум     = Макет.ПолучитьОбласть("Строка|ПроцСум");
	
	/////
	ОбластьИтого  			 = Макет.ПолучитьОбласть("Итого|Нач");
	ОбластьИтогоПланКол      = Макет.ПолучитьОбласть("Итого|ПланКол");
	ОбластьИтогоПланСум      = Макет.ПолучитьОбласть("Итого|ПланСум");
	ОбластьИтогоФактКол      = Макет.ПолучитьОбласть("Итого|ФактКол");
	ОбластьИтогоФактСум      = Макет.ПолучитьОбласть("Итого|ФактСум");
	//
	ОбластьИтогоОтклКол      = Макет.ПолучитьОбласть("Итого|ОтклКол");
	ОбластьИтогоОтклСум      = Макет.ПолучитьОбласть("Итого|ОтклСум");
	ОбластьИтогоПроцКол      = Макет.ПолучитьОбласть("Итого|ПроцКол");
	ОбластьИтогоПроцСум      = Макет.ПолучитьОбласть("Итого|ПроцСум");

	
	ОбластьПодвал    = Макет.ПолучитьОбласть("Подвал|Нач");
	
	ОбластьПодвалПланКол     = Макет.ПолучитьОбласть("Подвал|ПланКол");
	ОбластьПодвалПланСум     = Макет.ПолучитьОбласть("Подвал|ПланСум");
	ОбластьПодвалФактКол     = Макет.ПолучитьОбласть("Подвал|ФактКол");
	ОбластьПодвалФактСум     = Макет.ПолучитьОбласть("Подвал|ФактСум");
	//
	ОбластьПодвалОтклКол     = Макет.ПолучитьОбласть("Подвал|ОтклКол");
	ОбластьПодвалОтклСум     = Макет.ПолучитьОбласть("Подвал|ОтклСум");
	ОбластьПодвалПроцКол     = Макет.ПолучитьОбласть("Подвал|ПроцКол");
	ОбластьПодвалПроцСум     = Макет.ПолучитьОбласть("Подвал|ПроцСум");

    ОбластьЗаголовок.Параметры.Заголовок = "Выполнение плана продаж за " + кпкАгентПлюс.ПолучитьПредставлениеПериода(ДатаНач, ДатаКон);
	Результат.Вывести(ОбластьЗаголовок);
	
	ОбластьПараметр.Параметры.Пар = "Агент: " + Агент;
	Результат.Вывести(ОбластьПараметр);  
	
	ОбластьПараметр.Параметры.Пар = "Период: " + кпкАгентПлюс.ПолучитьПредставлениеПериода(ДатаНач, ДатаКон);
	Результат.Вывести(ОбластьПараметр);   	
		
	ОбластьПараметр.Параметры.Пар = "Ответственный: " + УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(ОбщегоНазначения.ТекущийПользователь(), "ОсновнойОтветственный");
	
	Результат.Вывести(ОбластьПараметр);
	
	Результат.ФиксацияСверху = 9;

	Результат.Вывести(ОбластьШапка);
	
	Если ТипОтчета = 2 Тогда
		Результат.Присоединить(ОбластьШапкаПланСум);	
		Результат.Присоединить(ОбластьШапкаФактСум);	
		Результат.Присоединить(ОбластьШапкаОтклСум);	
		Результат.Присоединить(ОбластьШапкаПроцСум);	
	ИначеЕсли ТипОтчета = 1 Тогда
		Результат.Присоединить(ОбластьШапкаПланКол);	
		Результат.Присоединить(ОбластьШапкаФактКол);
		Результат.Присоединить(ОбластьШапкаОтклКол);	
		Результат.Присоединить(ОбластьШапкаПроцКол);	
	ИначеЕсли ТипОтчета = 3 Тогда    		
		Результат.Присоединить(ОбластьШапкаПланКол);			
		Результат.Присоединить(ОбластьШапкаПланСум);	
		
		Результат.Присоединить(ОбластьШапкаФактКол);
		Результат.Присоединить(ОбластьШапкаФактСум);	
		
		Результат.Присоединить(ОбластьШапкаОтклКол);	                                      		
		Результат.Присоединить(ОбластьШапкаОтклСум);	
		
		Результат.Присоединить(ОбластьШапкаПроцКол);	
		Результат.Присоединить(ОбластьШапкаПроцСум);			
	КонецЕсли;

	ВыборкаОбщийИтог = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ВыборкаОбщийИтог.Следующий();
	
	ОбластьИтого.Параметры.Заполнить(ВыборкаОбщийИтог);
	ОбластьИтогоПланКол.Параметры.Заполнить(ВыборкаОбщийИтог);
	ОбластьИтогоПланСум.Параметры.Заполнить(ВыборкаОбщийИтог);
	
	ОбластьИтогоФактКол.Параметры.Заполнить(ВыборкаОбщийИтог);
	ОбластьИтогоФактСум.Параметры.Заполнить(ВыборкаОбщийИтог);
	
	ОбластьИтогоОтклКол.Параметры.Заполнить(ВыборкаОбщийИтог);
	ОбластьИтогоОтклСум.Параметры.Заполнить(ВыборкаОбщийИтог);
	
	ОбластьИтогоПроцКол.Параметры.Заполнить(ВыборкаОбщийИтог);
	ОбластьИтогоПроцСум.Параметры.Заполнить(ВыборкаОбщийИтог);
		
	Результат.Вывести(ОбластьИтого, ВыборкаОбщийИтог.Уровень());
	
	Если ТипОтчета = 2 Тогда	
		Результат.Присоединить(ОбластьИтогоПланСум);	
		Результат.Присоединить(ОбластьИтогоФактСум);	
		Результат.Присоединить(ОбластьИтогоОтклСум);	
		Результат.Присоединить(ОбластьИтогоПроцСум);	
	ИначеЕсли ТипОтчета = 1 Тогда
		Результат.Присоединить(ОбластьИтогоПланКол);	
		Результат.Присоединить(ОбластьИтогоФактКол);
		Результат.Присоединить(ОбластьИтогоОтклКол);	
		Результат.Присоединить(ОбластьИтогоПроцКол);	
	ИначеЕсли ТипОтчета = 3 Тогда		
		Результат.Присоединить(ОбластьИтогоПланКол);			
		Результат.Присоединить(ОбластьИтогоПланСум);	
		
		Результат.Присоединить(ОбластьИтогоФактКол);
		Результат.Присоединить(ОбластьИтогоФактСум);	
		
		Результат.Присоединить(ОбластьИтогоОтклКол);	                                      		
		Результат.Присоединить(ОбластьИтогоОтклСум);	
		
		Результат.Присоединить(ОбластьИтогоПроцКол);	
		Результат.Присоединить(ОбластьИтогоПроцСум);			
	КонецЕсли;
	
	
	ВыборкаГрупп = ВыборкаОбщийИтог.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ВыпСумма = 0;
	ВыпКол   = 0;
	ВсегоКат = ВыборкаГрупп.Количество();
	
	Пока ВыборкаГрупп.Следующий() Цикл
		
		ВыпКол   = ВыпКол + Мин(100, ВыборкаГрупп.ПроцентКоличество); 
		ВыпСумма = ВыпСумма + Мин(100, ВыборкаГрупп.ПроцентСумма);
		
		ОбластьСтрока.Параметры.Заполнить(ВыборкаГрупп);
		
		Если ВыборкаГрупп.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.ПустаяСсылка() Тогда
			ОбластьСтрока.Параметры.СтрНоменклатурнаяГруппа = "<Без номенклатурной группы>";		
			ОбластьСтрока.ТекущаяОбласть.ЦветТекста = Новый Цвет(0,0,255);
		ИначеЕсли ВыборкаГрупп.КоличествоПлан = 0 и ВыборкаГрупп.СуммаПлан = 0 Тогда
			ОбластьСтрока.Параметры.СтрНоменклатурнаяГруппа = Строка(ВыборкаГрупп.НоменклатурнаяГруппа) + "(внеплана)";
			ОбластьСтрока.ТекущаяОбласть.ЦветТекста = Новый Цвет(0,185,0);
		Иначе
			ОбластьСтрока.Параметры.СтрНоменклатурнаяГруппа = Строка(ВыборкаГрупп.НоменклатурнаяГруппа);		
			ОбластьСтрока.ТекущаяОбласть.ЦветТекста = Новый Цвет(0,0,0);
		КонецЕсли;
		
		ОбластьСтрокаПланКол.Параметры.Заполнить(ВыборкаГрупп);
		ОбластьСтрокаПланСум.Параметры.Заполнить(ВыборкаГрупп);
		
		ОбластьСтрокаФактКол.Параметры.Заполнить(ВыборкаГрупп);
		ОбластьСтрокаФактСум.Параметры.Заполнить(ВыборкаГрупп);
		
		ОбластьСтрокаОтклКол.Параметры.Заполнить(ВыборкаГрупп);		
		ОбластьСтрокаОтклСум.Параметры.Заполнить(ВыборкаГрупп);
		
		ОбластьСтрокаПроцКол.Параметры.Заполнить(ВыборкаГрупп);
		ОбластьСтрокаПроцСум.Параметры.Заполнить(ВыборкаГрупп);	
		
		СтрФакт = Новый Структура("Тип, Группа", "Факт", ВыборкаГрупп.НоменклатурнаяГруппа);				
		СтрПлан = Новый Структура("Тип, Группа", "План", ВыборкаГрупп.НоменклатурнаяГруппа);				
		
		ОбластьСтрокаФактСум.Параметры.СтрФакт = СтрФакт;                      
		ОбластьСтрокаФактКол.Параметры.СтрФакт = СтрФакт;                      
		
		ОбластьСтрокаПланКол.Параметры.СтрПлан = СтрПлан;                      
		ОбластьСтрокаПланСум.Параметры.СтрПлан = СтрПлан;  
		
		Если Не Внеплана Тогда			
			Если ОбластьСтрока.ТекущаяОбласть.ЦветТекста = Новый Цвет(255,0,0) Тогда
				Продолжить;  				
			КонецЕсли;       			
		КонецЕсли;
		
		Результат.Вывести(ОбластьСтрока, ВыборкаГрупп.Уровень());
	
	
	Если ТипОтчета = 2 Тогда	
			Результат.Присоединить(ОбластьСтрокаПланСум);	
			Результат.Присоединить(ОбластьСтрокаФактСум);	
			Результат.Присоединить(ОбластьСтрокаОтклСум);	
			Результат.Присоединить(ОбластьСтрокаПроцСум);	
		ИначеЕсли ТипОтчета = 1 Тогда
			Результат.Присоединить(ОбластьСтрокаПланКол);	
			Результат.Присоединить(ОбластьСтрокаФактКол);
			Результат.Присоединить(ОбластьСтрокаОтклКол);	
			Результат.Присоединить(ОбластьСтрокаПроцКол);	
		ИначеЕсли ТипОтчета = 3 Тогда		
			Результат.Присоединить(ОбластьСтрокаПланКол);			
			Результат.Присоединить(ОбластьСтрокаПланСум);	
			
			Результат.Присоединить(ОбластьСтрокаФактКол);
			Результат.Присоединить(ОбластьСтрокаФактСум);	
			
			Результат.Присоединить(ОбластьСтрокаОтклКол);	                                      		
			Результат.Присоединить(ОбластьСтрокаОтклСум);	
			
			Результат.Присоединить(ОбластьСтрокаПроцКол);	
			Результат.Присоединить(ОбластьСтрокаПроцСум);			
		КонецЕсли;    	
     КонецЦикла;
	 
	Результат.ЗакончитьАвтогруппировкуСтрок();
	
	Результат.Вывести(ОбластьПодвал);     
	
	Если ТипОтчета = 2 Тогда	
		Результат.Присоединить(ОбластьПодвалПланСум);	
		Результат.Присоединить(ОбластьПодвалФактСум);	
		Результат.Присоединить(ОбластьПодвалОтклСум);	
		Результат.Присоединить(ОбластьПодвалПроцСум);	
	ИначеЕсли ТипОтчета = 1 Тогда
		Результат.Присоединить(ОбластьПодвалПланКол);	
		Результат.Присоединить(ОбластьПодвалФактКол);
		Результат.Присоединить(ОбластьПодвалОтклКол);	
		Результат.Присоединить(ОбластьПодвалПроцКол);	
	ИначеЕсли ТипОтчета = 3 Тогда		
		Результат.Присоединить(ОбластьПодвалПланКол);			
		Результат.Присоединить(ОбластьПодвалПланСум);	
		
		Результат.Присоединить(ОбластьПодвалФактКол);
		Результат.Присоединить(ОбластьПодвалФактСум);	
		
		Результат.Присоединить(ОбластьПодвалОтклКол);	                                      		
		Результат.Присоединить(ОбластьПодвалОтклСум);	
		
		Результат.Присоединить(ОбластьПодвалПроцКол);	
		Результат.Присоединить(ОбластьПодвалПроцСум);			
	КонецЕсли; 
	
	Если ТипОтчета = 2 Тогда	
		ОбластьПараметрВып.Параметры.Пар = "Выполнение плана " + Формат(ВыпСумма/?(ВсегоКат=0, 1, ВсегоКат), "ЧДЦ=2") + " %";
		Результат.Вывести(ОбластьПараметрВып);			
	ИначеЕсли ТипОтчета = 1 Тогда
		ОбластьПараметрВып.Параметры.Пар = "Выполнение плана " + Формат(ВыпКол/?(ВсегоКат=0, 1, ВсегоКат), "ЧДЦ=2") + " %";
		Результат.Вывести(ОбластьПараметрВып);			
	ИначеЕсли ТипОтчета = 3 Тогда			
		ОбластьПараметрВып.Параметры.Пар = "Выполнение плана по сумме " + Формат(ВыпСумма/?(ВсегоКат=0, 1, ВсегоКат), "ЧДЦ=2") + " %";
		Результат.Вывести(ОбластьПараметрВып);			
		
		ОбластьПараметрВып.Параметры.Пар = "Выполнение плана по количеству " + Формат(ВыпКол/?(ВсегоКат=0, 1, ВсегоКат), "ЧДЦ=2") + " %";
		Результат.Вывести(ОбластьПараметрВып);			
	КонецЕсли; 
	
	
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)

	Если ПроверкаФормы() Тогда
		СформироватьОтчет();
	Иначе Сообщение = Новый СообщениеПользователю;
		  Сообщение.Текст = "Проверьте правильность заполнения формы!!!";
		  Сообщение.Сообщить(); 
	КонецЕсли;
	
КонецПроцедуры
