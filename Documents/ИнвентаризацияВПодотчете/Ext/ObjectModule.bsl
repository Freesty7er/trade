﻿#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(отказ, режимПроведения)
	
	Движения.ВзаиморасчетыССотрудниками.Записывать = Истина;
	Движения.ДенежныеДокументыВыданные.Записывать = Истина;
	Движения.РасчетыПоОплатеТруда.Записывать = Истина;
	Движения.ФинансовыйРезультат.Записывать = Истина;
	Движения.ПартииТоваровНаСкладах.Записывать = Истина;
	
	запрос = Новый Запрос;
	запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	#Область ТекстЗапроса
	// 0 - временная таблица состава
	// 1 - ДенежныеДокументыВыданные
	// 2 - "ВзаиморасчетыССотрудниками"
	// 3 - "РасчетыПоОплатеТруда"
	// 4 - "ФинансовыйРезультат"
	// 5 - "ПартииТоваровНаСкладах"
	запрос.Текст = 
	"ВЫБРАТЬ
	|	ИнвентаризацияВПодотчетеСостав.Номенклатура,
	|	ИнвентаризацияВПодотчетеСостав.Количество - ИнвентаризацияВПодотчетеСостав.КоличествоФакт КАК Количество,
	|	ИнвентаризацияВПодотчетеСостав.Сумма - ИнвентаризацияВПодотчетеСостав.СуммаФакт КАК Сумма,
	|	ИнвентаризацияВПодотчетеСостав.Ссылка.Подразделение,
	|	ИнвентаризацияВПодотчетеСостав.Ссылка.Дата КАК Период,
	|	ИнвентаризацияВПодотчетеСостав.Ссылка.Сотрудник,
	|	ИнвентаризацияВПодотчетеСостав.Номенклатура.СчетУчета,
	|	ИнвентаризацияВПодотчетеСостав.Номенклатура.Родитель.Склад КАК Склад,
	|	ВалютаУчета.Значение КАК Валюта,
	|	(ИнвентаризацияВПодотчетеСостав.Количество - ИнвентаризацияВПодотчетеСостав.КоличествоФакт) * ИнвентаризацияВПодотчетеСостав.Цена КАК СуммаНедостачи,
	|	ИнвентаризацияВПодотчетеСостав.СуммаФакт - ИнвентаризацияВПодотчетеСостав.Сумма + (ИнвентаризацияВПодотчетеСостав.Количество - ИнвентаризацияВПодотчетеСостав.КоличествоФакт) * ИнвентаризацияВПодотчетеСостав.Цена КАК СуммаПереоценки
	|ПОМЕСТИТЬ ТаблицаСостава
	|ИЗ
	|	Документ.ИнвентаризацияВПодотчете.Состав КАК ИнвентаризацияВПодотчетеСостав,
	|	Константа.ВалютаУчета КАК ВалютаУчета
	|ГДЕ
	|	ИнвентаризацияВПодотчетеСостав.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаСостава.Период КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ТаблицаСостава.Подразделение,
	|	ТаблицаСостава.Сотрудник,
	|	ТаблицаСостава.Номенклатура,
	|	ТаблицаСостава.Количество,
	|	ТаблицаСостава.СуммаНедостачи КАК Сумма
	|ИЗ
	|	ТаблицаСостава КАК ТаблицаСостава
	|ГДЕ
	|	ТаблицаСостава.СуммаНедостачи <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаСостава.Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ТаблицаСостава.Подразделение,
	|	ТаблицаСостава.Сотрудник,
	|	ЗНАЧЕНИЕ(ПланСчетов.Внутренний.Зарплата) КАК СчетУчета,
	|	СУММА(ТаблицаСостава.СуммаНедостачи) КАК Сумма
	|ИЗ
	|	ТаблицаСостава КАК ТаблицаСостава
	|ГДЕ
	|	ТаблицаСостава.Количество <> 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаСостава.Период,
	|	ТаблицаСостава.Подразделение,
	|	ТаблицаСостава.Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаСостава.Период,
	|	ТаблицаСостава.Подразделение,
	|	ТаблицаСостава.Сотрудник,
	|	НАЧАЛОПЕРИОДА(ТаблицаСостава.Период, МЕСЯЦ) КАК ПериодРегистрации,
	|	ЗНАЧЕНИЕ(Справочник.ВидыРасчетов.Штраф) КАК ВидРасчета,
	|	СУММА(ТаблицаСостава.СуммаНедостачи) КАК Результат
	|ИЗ
	|	ТаблицаСостава КАК ТаблицаСостава
	|ГДЕ
	|	ТаблицаСостава.СуммаНедостачи <> 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаСостава.Период,
	|	ТаблицаСостава.Подразделение,
	|	ТаблицаСостава.Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаСостава.Период,
	|	ТаблицаСостава.Подразделение,
	|	ЗНАЧЕНИЕ(Справочник.СтатьиДоходов.Переоценка) КАК СтатьяДоходов,
	|	СУММА(ТаблицаСостава.СуммаПереоценки) КАК СуммаДоходов
	|ИЗ
	|	ТаблицаСостава КАК ТаблицаСостава
	|ГДЕ
	|	ТаблицаСостава.СуммаПереоценки <> 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаСостава.Период,
	|	ТаблицаСостава.Подразделение
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаСостава.Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ТаблицаСостава.Подразделение,
	|	ТаблицаСостава.Склад,
	|	ТаблицаСостава.Номенклатура,
	|	ТаблицаСостава.НоменклатураСчетУчета КАК СчетУчета,
	|	ТаблицаСостава.Валюта,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыХраненияЗапасов.ВПодотчете) КАК ВидХранения,
	|	ТаблицаСостава.Сотрудник КАК МОЛ,
	|	ТаблицаСостава.Количество,
	|	ТаблицаСостава.Сумма КАК Стоимость,
	|	ТаблицаСостава.Сумма КАК СтоимостьВал
	|ИЗ
	|	ТаблицаСостава КАК ТаблицаСостава
	|ГДЕ
	|	(ТаблицаСостава.Количество <> 0
	|			ИЛИ ТаблицаСостава.Сумма <> 0)";
		
	#КонецОбласти
	
	запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	результатЗапроса = запрос.ВыполнитьПакет();
	
	#Область ПросмотрВременныхТаблиц
		запрос.Текст = "ВЫБРАТЬ * ИЗ ТаблицаСостава";
	#КонецОбласти 
	
	Движения.ДенежныеДокументыВыданные.Загрузить(результатЗапроса[1].Выгрузить());
	Движения.ВзаиморасчетыССотрудниками.Загрузить(результатЗапроса[2].Выгрузить());
	Движения.РасчетыПоОплатеТруда.Загрузить(результатЗапроса[3].Выгрузить());
	Движения.ФинансовыйРезультат.Загрузить(результатЗапроса[4].Выгрузить());
	Движения.ПартииТоваровНаСкладах.Загрузить(результатЗапроса[5].Выгрузить());
	
	#Область ПоследовательностьЗапасы
	
	Если Не отказ Тогда
		
		запрос = Новый Запрос;
		
		#Область ТекстЗапроса
		
		запрос.Текст =
		"ВЫБРАТЬ
		|	СоставДокумента.Ссылка.Подразделение,
		|	СоставДокумента.Номенклатура.Родитель.Склад КАК МестоХранения,
		|	СоставДокумента.Номенклатура.Родитель.СчетУчета КАК СчетУчета
		|ИЗ
		|	Документ.ИнвентаризацияВПодотчете.Состав КАК СоставДокумента
		|ГДЕ
		|	СоставДокумента.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	СоставДокумента.Номенклатура.Родитель.СчетУчета,
		|	СоставДокумента.Ссылка.Подразделение,
		|	СоставДокумента.Номенклатура.Родитель.Склад";
			
		#КонецОбласти 
		
		запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		результатЗапроса = запрос.Выполнить();
		
		ПринадлежностьПоследовательностям.Запасы.Загрузить(результатЗапроса.Выгрузить());
		
		отбор = Новый Структура ("Подразделение, МестоХранения, СчетУчета");
		
		выборка = результатЗапроса.Выбрать();
		Пока выборка.Следующий() Цикл
			
			ЗаполнитьЗначенияСвойств(отбор, выборка);
			
			Последовательности.Запасы.УстановитьГраницу(МоментВремени(), отбор);
			
		КонецЦикла;
		
	КонецЕсли;
	
	#КонецОбласти 
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(отказ, проверяемыеРеквизиты)
	
	ОбработкаТабличныхЧастейСервер.ПроверитьДублиСтрокТабличнойЧасти(Отказ, ЭтотОбъект, "Состав", Новый Структура("Номенклатура", "Номенклатура"));

КонецПроцедуры

Процедура ПередЗаписью(отказ, режимЗаписи, режимПроведения)
	
	ПринадлежностьПоследовательностям.Запасы.Очистить();
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Подразделение.Пустая() Тогда
		
		ТекстСообщения = НСтр("ru = 'Запись невозможна без заполнения Подразделения.'");
		ПроверкаДанныхКлиентСервер.СообщитьОбОшибке(отказ, текстСообщения, ЭтотОбъект, "Подразделение");
		
	КонецЕсли;
	
	Если Не Дата = КонецДня(Дата) Тогда
		Дата = КонецДня(Дата);
	КонецЕсли;
	
	УстановитьВремя(РежимАвтоВремя.Последним);


КонецПроцедуры

Процедура ПриКопировании(объектКопирования)
	
	ЗаполнениеОбъектовСервер.ЗаполнитьДанныеСкопированногоДокумента(ЭтотОбъект, ОбъектКопирования);
	
КонецПроцедуры

#КонецОбласти 