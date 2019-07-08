﻿// Функция - Сформировать таблицы для проведения
//
// Параметры:
//  ссылка	 - Документ.СводныйПутевойЛист	 - 
// 
// Возвращаемое значение:
//   - Массив
//		[1] ДенежныеДокументыВыданные
//		[2] ВзаиморасчетыССотрудниками
//		[3] ФинансовыйРезультат
//		[4] РасчетыПоОплатеТруда
//		[5] ПартииТоваровНаСкладах
//
Функция СформироватьТаблицыДляПроведения(ссылка) Экспорт
	
	запрос = Новый Запрос;
	
	#Область ТекстЗапроса
	
	запрос.Текст =
	"ВЫБРАТЬ
	|	СводныйПутевойЛистСостав.Ссылка.Дата КАК Период,
	|	СводныйПутевойЛистСостав.Ссылка.Подразделение КАК Подразделение,
	|	СводныйПутевойЛистСостав.Водитель КАК Сотрудник,
	|	СводныйПутевойЛистСостав.ЗаправкаНоменклатура КАК ЗаправкаНоменклатура,
	|	СводныйПутевойЛистСостав.ЗаправкаНоменклатура.СчетУчета,
	|	СводныйПутевойЛистСостав.ЗаправкаНоменклатура.Родитель.Склад КАК ЗаправкаСклад,
	|	СводныйПутевойЛистСостав.ЗаправкаТалоны КАК ЗаправкаТалоны,
	|	СводныйПутевойЛистСостав.ЗаправкаТалоны * ЕСТЬNULL(ЦеныНоменклатуры.Цена, 0) КАК ЗаправкаТалоныСумма,
	|	СводныйПутевойЛистСостав.ЗаправкаСумма,
	|	СводныйПутевойЛистСостав.СуммаЗарплаты,
	|	СводныйПутевойЛистСостав.Автомобиль,
	|	ВалютаУчета.Значение КАК ВалютаДокумента,
	|	СводныйПутевойЛистСостав.Экспедитор,
	|	СводныйПутевойЛистСостав.СуммаЗарплатыЭкспедитора,
	|	СводныйПутевойЛистСостав.ЗаправкаСуммаСмартКарта
	|ПОМЕСТИТЬ ТаблицаДокумента
	|ИЗ
	|	Документ.СводныйПутевойЛист.Состав КАК СводныйПутевойЛистСостав
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&ДатаСреза, ) КАК ЦеныНоменклатуры
	|		ПО СводныйПутевойЛистСостав.Ссылка.Подразделение = ЦеныНоменклатуры.Подразделение
	|			И (ЦеныНоменклатуры.ТипЦен = ЗНАЧЕНИЕ(Справочник.ТипыЦен.Закупка))
	|			И СводныйПутевойЛистСостав.ЗаправкаНоменклатура = ЦеныНоменклатуры.Номенклатура,
	|	Константа.ВалютаУчета КАК ВалютаУчета
	|ГДЕ
	|	СводныйПутевойЛистСостав.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДенежныеДокументыВыданные.ВидДвижения,
	|	ДенежныеДокументыВыданные.Период,
	|	ДенежныеДокументыВыданные.Подразделение,
	|	ДенежныеДокументыВыданные.Сотрудник,
	|	ДенежныеДокументыВыданные.Номенклатура,
	|	ДенежныеДокументыВыданные.Количество,
	|	ДенежныеДокументыВыданные.Сумма
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|		ТаблицаДокумента.Период КАК Период,
	|		ТаблицаДокумента.Подразделение КАК Подразделение,
	|		ТаблицаДокумента.Сотрудник КАК Сотрудник,
	|		ТаблицаДокумента.ЗаправкаНоменклатура КАК Номенклатура,
	|		ТаблицаДокумента.ЗаправкаТалоны КАК Количество,
	|		ТаблицаДокумента.ЗаправкаТалоныСумма КАК Сумма
	|	ИЗ
	|		ТаблицаДокумента КАК ТаблицаДокумента) КАК ДенежныеДокументыВыданные
	|ГДЕ
	|	ДенежныеДокументыВыданные.Количество <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВзаиморасчетыССотрудниками.Период,
	|	ВзаиморасчетыССотрудниками.Подразделение,
	|	ВзаиморасчетыССотрудниками.Сотрудник,
	|	ВзаиморасчетыССотрудниками.ВидДвижения КАК ВидДвижения,
	|	ВзаиморасчетыССотрудниками.СчетУчета КАК СчетУчета,
	|	СУММА(ВзаиморасчетыССотрудниками.Сумма) КАК Сумма,
	|	СУММА(ВзаиморасчетыССотрудниками.СуммаВал) КАК СуммаВал
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|		ТаблицаДокумента.Период КАК Период,
	|		ТаблицаДокумента.Подразделение КАК Подразделение,
	|		ТаблицаДокумента.Сотрудник КАК Сотрудник,
	|		ЗНАЧЕНИЕ(ПланСчетов.Внутренний.Подотчет) КАК СчетУчета,
	|		ТаблицаДокумента.ЗаправкаСумма КАК Сумма,
	|		ТаблицаДокумента.ЗаправкаСумма КАК СуммаВал
	|	ИЗ
	|		ТаблицаДокумента КАК ТаблицаДокумента
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход),
	|		ТаблицаДокумента.Период,
	|		ТаблицаДокумента.Подразделение,
	|		ТаблицаДокумента.Сотрудник,
	|		ЗНАЧЕНИЕ(ПланСчетов.Внутренний.Зарплата),
	|		ТаблицаДокумента.СуммаЗарплаты,
	|		ТаблицаДокумента.СуммаЗарплаты
	|	ИЗ
	|		ТаблицаДокумента КАК ТаблицаДокумента
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход),
	|		ТаблицаДокумента.Период,
	|		ТаблицаДокумента.Подразделение,
	|		ТаблицаДокумента.Экспедитор,
	|		ЗНАЧЕНИЕ(ПланСчетов.Внутренний.Зарплата),
	|		ТаблицаДокумента.СуммаЗарплатыЭкспедитора,
	|		ТаблицаДокумента.СуммаЗарплатыЭкспедитора
	|	ИЗ
	|		ТаблицаДокумента КАК ТаблицаДокумента
	|	ГДЕ
	|		ТаблицаДокумента.СуммаЗарплатыЭкспедитора <> 0) КАК ВзаиморасчетыССотрудниками
	|ГДЕ
	|	ВзаиморасчетыССотрудниками.Сумма <> 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ВзаиморасчетыССотрудниками.Подразделение,
	|	ВзаиморасчетыССотрудниками.Период,
	|	ВзаиморасчетыССотрудниками.Сотрудник,
	|	ВзаиморасчетыССотрудниками.ВидДвижения,
	|	ВзаиморасчетыССотрудниками.СчетУчета
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ФинансовыйРезультат.Период,
	|	ФинансовыйРезультат.Подразделение,
	|	ФинансовыйРезультат.СтатьяЗатрат КАК СтатьяЗатрат,
	|	СУММА(ФинансовыйРезультат.СуммаРасходов) КАК СуммаРасходов,
	|	ФинансовыйРезультат.Объект
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаДокумента.Период КАК Период,
	|		ТаблицаДокумента.Подразделение КАК Подразделение,
	|		&РасходыНаГСМ КАК СтатьяЗатрат,
	|		ТаблицаДокумента.ЗаправкаТалоныСумма + ТаблицаДокумента.ЗаправкаСумма + ТаблицаДокумента.ЗаправкаСуммаСмартКарта КАК СуммаРасходов,
	|		ТаблицаДокумента.Автомобиль КАК Объект
	|	ИЗ
	|		ТаблицаДокумента КАК ТаблицаДокумента
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаДокумента.Период,
	|		ТаблицаДокумента.Подразделение,
	|		&ЗарплатаВодители,
	|		ТаблицаДокумента.СуммаЗарплаты,
	|		ТаблицаДокумента.Автомобиль
	|	ИЗ
	|		ТаблицаДокумента КАК ТаблицаДокумента
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаДокумента.Период,
	|		ТаблицаДокумента.Подразделение,
	|		&ЗарплатаВодители,
	|		ТаблицаДокумента.СуммаЗарплатыЭкспедитора,
	|		ТаблицаДокумента.Автомобиль
	|	ИЗ
	|		ТаблицаДокумента КАК ТаблицаДокумента
	|	ГДЕ
	|		ТаблицаДокумента.СуммаЗарплатыЭкспедитора <> 0) КАК ФинансовыйРезультат
	|ГДЕ
	|	ФинансовыйРезультат.СуммаРасходов <> 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ФинансовыйРезультат.Объект,
	|	ФинансовыйРезультат.СтатьяЗатрат,
	|	ФинансовыйРезультат.Подразделение,
	|	ФинансовыйРезультат.Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РасчетыПоОплатеТруда.Период,
	|	РасчетыПоОплатеТруда.Подразделение,
	|	РасчетыПоОплатеТруда.Сотрудник,
	|	РасчетыПоОплатеТруда.ВидРасчета,
	|	РасчетыПоОплатеТруда.ПериодРегистрации,
	|	СУММА(РасчетыПоОплатеТруда.Результат) КАК Результат
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаДокумента.Период КАК Период,
	|		ТаблицаДокумента.Подразделение КАК Подразделение,
	|		ТаблицаДокумента.Сотрудник КАК Сотрудник,
	|		&ВидРасчетаОплатаПоПробегу КАК ВидРасчета,
	|		&ПериодРегистрации КАК ПериодРегистрации,
	|		ТаблицаДокумента.СуммаЗарплаты КАК Результат
	|	ИЗ
	|		ТаблицаДокумента КАК ТаблицаДокумента
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаДокумента.Период,
	|		ТаблицаДокумента.Подразделение,
	|		ТаблицаДокумента.Экспедитор,
	|		&ВидРасчетаОплатаПоПробегу,
	|		&ПериодРегистрации,
	|		ТаблицаДокумента.СуммаЗарплатыЭкспедитора
	|	ИЗ
	|		ТаблицаДокумента КАК ТаблицаДокумента
	|	ГДЕ
	|		ТаблицаДокумента.СуммаЗарплатыЭкспедитора <> 0) КАК РасчетыПоОплатеТруда
	|ГДЕ
	|	РасчетыПоОплатеТруда.Результат <> 0
	|
	|СГРУППИРОВАТЬ ПО
	|	РасчетыПоОплатеТруда.ПериодРегистрации,
	|	РасчетыПоОплатеТруда.Период,
	|	РасчетыПоОплатеТруда.Подразделение,
	|	РасчетыПоОплатеТруда.Сотрудник,
	|	РасчетыПоОплатеТруда.ВидРасчета
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПартииТоваровНаСкладах.ВидДвижения,
	|	ПартииТоваровНаСкладах.Период,
	|	ПартииТоваровНаСкладах.Подразделение,
	|	ПартииТоваровНаСкладах.Склад,
	|	ПартииТоваровНаСкладах.МОЛ,
	|	ПартииТоваровНаСкладах.Номенклатура,
	|	ПартииТоваровНаСкладах.Количество,
	|	ПартииТоваровНаСкладах.Стоимость,
	|	ПартииТоваровНаСкладах.СтоимостьВал,
	|	ПартииТоваровНаСкладах.СчетУчета,
	|	ПартииТоваровНаСкладах.Валюта,
	|	ПартииТоваровНаСкладах.ВидХранения,
	|	ЗНАЧЕНИЕ(ПланСчетов.Внутренний.Затраты) КАК КорСчет
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|		ТаблицаДокумента.Период КАК Период,
	|		ТаблицаДокумента.Подразделение КАК Подразделение,
	|		ТаблицаДокумента.ЗаправкаСклад КАК Склад,
	|		ТаблицаДокумента.Сотрудник КАК МОЛ,
	|		ТаблицаДокумента.ЗаправкаНоменклатура КАК Номенклатура,
	|		ТаблицаДокумента.ЗаправкаТалоны КАК Количество,
	|		ТаблицаДокумента.ЗаправкаТалоныСумма КАК Стоимость,
	|		ТаблицаДокумента.ЗаправкаТалоныСумма КАК СтоимостьВал,
	|		ТаблицаДокумента.ЗаправкаНоменклатураСчетУчета КАК СчетУчета,
	|		ТаблицаДокумента.ВалютаДокумента КАК Валюта,
	|		ЗНАЧЕНИЕ(Перечисление.ВидыХраненияЗапасов.ВПодотчете) КАК ВидХранения
	|	ИЗ
	|		ТаблицаДокумента КАК ТаблицаДокумента) КАК ПартииТоваровНаСкладах
	|ГДЕ
	|	ПартииТоваровНаСкладах.Количество <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВзаиморасчетыСПоставщиками.ВидДвижения,
	|	ВзаиморасчетыСПоставщиками.Период,
	|	ВзаиморасчетыСПоставщиками.Подразделение,
	|	ВзаиморасчетыСПоставщиками.Контрагент,
	|	ВзаиморасчетыСПоставщиками.Сумма
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|		ТаблицаДокумента.Период КАК Период,
	|		ТаблицаДокумента.Подразделение КАК Подразделение,
	|		&КонтрагентСмартКарты КАК Контрагент,
	|		ТаблицаДокумента.ЗаправкаСуммаСмартКарта КАК Сумма
	|	ИЗ
	|		ТаблицаДокумента КАК ТаблицаДокумента
	|	ГДЕ
	|		ТаблицаДокумента.ЗаправкаСуммаСмартКарта <> 0) КАК ВзаиморасчетыСПоставщиками";
	
	#КонецОбласти
	
	запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;

	запрос.УстановитьПараметр("Ссылка", 					ссылка);
	запрос.УстановитьПараметр("ДатаСреза", 					ссылка.Дата);
	
	запрос.УстановитьПараметр("РасходыНаГСМ", 				Справочники.СтатьиЗатрат.НайтиПоКоду("000000009"));
	запрос.УстановитьПараметр("ЗарплатаВодители", 			Справочники.СтатьиЗатрат.НайтиПоКоду("000000120"));
	запрос.УстановитьПараметр("КонтрагентСмартКарты", 		Справочники.Контрагенты.НайтиПоКоду("F00023431"));
	запрос.УстановитьПараметр("ПериодРегистрации", 			НачалоМесяца(ссылка.Дата));
	запрос.УстановитьПараметр("ВидРасчетаОплатаПоПробегу", 	Справочники.ВидыРасчетов.ОплатаПоПробегу);

	Возврат запрос.ВыполнитьПакет();
	
КонецФункции