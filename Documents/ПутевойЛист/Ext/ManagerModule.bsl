﻿Функция СформироватьТаблицыДляПроведения(ссылка) Экспорт
	
	запрос = Новый Запрос;
	
	#Область ТекстЗапроса
	    
	// 2 - "ДенежныеДокументыВыданные"
	// 3 - "ПартииТоваровНаСкладах"
	// 4 - "ФинансовыйРезультат"
	// 5 - "ВзаиморасчетыССотрудниками"
	// 6 - "РасчетыПоОплатеТруда"
	// 7 - "ПоказанияСпидометра"
	// 8 - "ВзаиморасчетыСПокупателями"
	
	запрос.Текст = 
	"ВЫБРАТЬ
	|	ПутевойЛистЗаправочнаяВедомость.ЗаправкаТалоны КАК ТалоныКоличество,
	|	ПутевойЛистЗаправочнаяВедомость.ЗаправкаНоменклатура КАК Номенклатура,
	|	ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Цена, 0) * ПутевойЛистЗаправочнаяВедомость.ЗаправкаТалоны КАК ТалоныСумма,
	|	ПутевойЛистЗаправочнаяВедомость.Ссылка.Дата КАК Период,
	|	ПутевойЛистЗаправочнаяВедомость.Ссылка.Водитель КАК Сотрудник,
	|	ПутевойЛистЗаправочнаяВедомость.Ссылка.Подразделение,
	|	ВалютаУчета.Значение КАК Валюта,
	|	ПутевойЛистЗаправочнаяВедомость.ЗаправкаНоменклатура.СчетУчета КАК НоменклатураСчетУчета,
	|	ПутевойЛистЗаправочнаяВедомость.ЗаправкаНоменклатура.Родитель.Склад КАК Склад,
	|	ПутевойЛистЗаправочнаяВедомость.Ссылка.Автомобиль,
	|	ПутевойЛистЗаправочнаяВедомость.Ссылка.ПоказанияСпидометра
	|ПОМЕСТИТЬ ВТ_ТаблицаДокумента
	|ИЗ
	|	Документ.ПутевойЛист.ЗаправочнаяВедомость КАК ПутевойЛистЗаправочнаяВедомость
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&ДатаСреза, ) КАК ЦеныНоменклатурыСрезПоследних
	|		ПО ПутевойЛистЗаправочнаяВедомость.Ссылка.Подразделение = ЦеныНоменклатурыСрезПоследних.Подразделение
	|			И ПутевойЛистЗаправочнаяВедомость.ЗаправкаНоменклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура
	|			И (ЦеныНоменклатурыСрезПоследних.ТипЦен = ЗНАЧЕНИЕ(Справочник.ТипыЦен.Закупка)),
	|	Константа.ВалютаУчета КАК ВалютаУчета
	|ГДЕ
	|	ПутевойЛистЗаправочнаяВедомость.Ссылка = &Ссылка
	|	И ПутевойЛистЗаправочнаяВедомость.ЗаправкаНоменклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПутевойЛист.Дата КАК Период,
	|	ПутевойЛист.Подразделение,
	|	ПутевойЛист.Водитель КАК Сотрудник,
	|	ЗНАЧЕНИЕ(Справочник.ВидыРасчетов.ОплатаПоПробегу) КАК ВидРасчета,
	|	ПутевойЛист.ЗарплатаВодителя КАК Результат
	|ПОМЕСТИТЬ ВТ_Зарплата
	|ИЗ
	|	Документ.ПутевойЛист КАК ПутевойЛист
	|ГДЕ
	|	ПутевойЛист.Ссылка = &Ссылка
	|	И ПутевойЛист.ЗарплатаВодителя <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПутевойЛист.Дата,
	|	ПутевойЛист.Подразделение,
	|	ПутевойЛист.Экспедитор,
	|	ЗНАЧЕНИЕ(Справочник.ВидыРасчетов.ОплатаПоПробегу),
	|	ПутевойЛист.ЗарплатаЭкспедитора
	|ИЗ
	|	Документ.ПутевойЛист КАК ПутевойЛист
	|ГДЕ
	|	ПутевойЛист.Ссылка = &Ссылка
	|	И ПутевойЛист.ЗарплатаЭкспедитора <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПутевойЛистЗарплата.Ссылка.Дата,
	|	ПутевойЛистЗарплата.Ссылка.Подразделение,
	|	ПутевойЛистЗарплата.Сотрудник,
	|	ПутевойЛистЗарплата.ВидРасчета,
	|	ПутевойЛистЗарплата.Результат
	|ИЗ
	|	Документ.ПутевойЛист.Зарплата КАК ПутевойЛистЗарплата
	|ГДЕ
	|	ПутевойЛистЗарплата.Ссылка = &Ссылка
	|	И ПутевойЛистЗарплата.Результат <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДенежныеДокументы.ВидДвижения,
	|	ДенежныеДокументы.Период,
	|	ДенежныеДокументы.Подразделение,
	|	ДенежныеДокументы.Сотрудник,
	|	ДенежныеДокументы.Номенклатура,
	|	ДенежныеДокументы.Количество,
	|	ДенежныеДокументы.Сумма
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|		ВТ_ТаблицаДокумента.Период КАК Период,
	|		ВТ_ТаблицаДокумента.Подразделение КАК Подразделение,
	|		ВТ_ТаблицаДокумента.Сотрудник КАК Сотрудник,
	|		ВТ_ТаблицаДокумента.Номенклатура КАК Номенклатура,
	|		ВТ_ТаблицаДокумента.ТалоныКоличество КАК Количество,
	|		ВТ_ТаблицаДокумента.ТалоныСумма КАК Сумма
	|	ИЗ
	|		ВТ_ТаблицаДокумента КАК ВТ_ТаблицаДокумента) КАК ДенежныеДокументы
	|ГДЕ
	|	ДенежныеДокументы.Количество <> 0
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
	|	ПартииТоваровНаСкладах.СчетУчета,
	|	ПартииТоваровНаСкладах.Количество,
	|	ПартииТоваровНаСкладах.Стоимость,
	|	ПартииТоваровНаСкладах.СтоимостьВал,
	|	ПартииТоваровНаСкладах.Валюта,
	|	ПартииТоваровНаСкладах.ВидХранения,
	|	ПартииТоваровНаСкладах.КорСчет
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|		ВТ_ТаблицаДокумента.Период КАК Период,
	|		ВТ_ТаблицаДокумента.Подразделение КАК Подразделение,
	|		ВТ_ТаблицаДокумента.Склад КАК Склад,
	|		ВТ_ТаблицаДокумента.Сотрудник КАК МОЛ,
	|		ВТ_ТаблицаДокумента.Номенклатура КАК Номенклатура,
	|		ВТ_ТаблицаДокумента.НоменклатураСчетУчета КАК СчетУчета,
	|		ВТ_ТаблицаДокумента.ТалоныКоличество КАК Количество,
	|		ВТ_ТаблицаДокумента.ТалоныСумма КАК Стоимость,
	|		ВТ_ТаблицаДокумента.ТалоныСумма КАК СтоимостьВал,
	|		ВТ_ТаблицаДокумента.Валюта КАК Валюта,
	|		ЗНАЧЕНИЕ(Перечисление.ВидыХраненияЗапасов.ВПодотчете) КАК ВидХранения,
	|		ЗНАЧЕНИЕ(ПланСчетов.Внутренний.Затраты) КАК КорСчет
	|	ИЗ
	|		ВТ_ТаблицаДокумента КАК ВТ_ТаблицаДокумента) КАК ПартииТоваровНаСкладах
	|ГДЕ
	|	ПартииТоваровНаСкладах.Количество <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ФинансовыйРезультат.Период,
	|	ФинансовыйРезультат.Подразделение,
	|	ФинансовыйРезультат.Объект,
	|	ФинансовыйРезультат.СтатьяЗатрат,
	|	ФинансовыйРезультат.СтатьяДоходов,
	|	СУММА(ФинансовыйРезультат.СуммаРасходов) КАК СуммаРасходов,
	|	ФинансовыйРезультат.СуммаДоходов
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВТ_ТаблицаДокумента.Период КАК Период,
	|		ВТ_ТаблицаДокумента.Подразделение КАК Подразделение,
	|		ВТ_ТаблицаДокумента.Автомобиль КАК Объект,
	|		ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.РасходыНаГСМ) КАК СтатьяЗатрат,
	|		НЕОПРЕДЕЛЕНО КАК СтатьяДоходов,
	|		ВТ_ТаблицаДокумента.ТалоныСумма КАК СуммаРасходов,
	|		0 КАК СуммаДоходов
	|	ИЗ
	|		ВТ_ТаблицаДокумента КАК ВТ_ТаблицаДокумента
	|	ГДЕ
	|		ВТ_ТаблицаДокумента.ТалоныСумма <> 0
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ПутевойЛист.Дата,
	|		ПутевойЛист.Подразделение,
	|		ПутевойЛист.Автомобиль,
	|		АТ_СтатьяЗатратПоЗарплате.Значение,
	|		НЕОПРЕДЕЛЕНО,
	|		ПутевойЛист.ЗарплатаВодителя,
	|		0
	|	ИЗ
	|		Документ.ПутевойЛист КАК ПутевойЛист,
	|		Константа.АТ_СтатьяЗатратПоЗарплате КАК АТ_СтатьяЗатратПоЗарплате
	|	ГДЕ
	|		ПутевойЛист.Ссылка = &Ссылка
	|		И ПутевойЛист.ЗарплатаВодителя <> 0
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ПутевойЛист.Дата,
	|		ПутевойЛист.Подразделение,
	|		ПутевойЛист.Автомобиль,
	|		АТ_СтатьяЗатратПоЗарплате.Значение,
	|		НЕОПРЕДЕЛЕНО,
	|		ПутевойЛист.ЗарплатаЭкспедитора,
	|		0
	|	ИЗ
	|		Документ.ПутевойЛист КАК ПутевойЛист,
	|		Константа.АТ_СтатьяЗатратПоЗарплате КАК АТ_СтатьяЗатратПоЗарплате
	|	ГДЕ
	|		ПутевойЛист.Ссылка = &Ссылка
	|		И ПутевойЛист.ЗарплатаЭкспедитора <> 0
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ПутевойЛистСписокЗатрат.Ссылка.Дата,
	|		ПутевойЛистСписокЗатрат.Ссылка.Подразделение,
	|		ПутевойЛистСписокЗатрат.Ссылка.Автомобиль,
	|		ПутевойЛистСписокЗатрат.СтатьяЗатрат,
	|		НЕОПРЕДЕЛЕНО,
	|		ПутевойЛистСписокЗатрат.Сумма,
	|		0
	|	ИЗ
	|		Документ.ПутевойЛист.СписокЗатрат КАК ПутевойЛистСписокЗатрат
	|	ГДЕ
	|		ПутевойЛистСписокЗатрат.Ссылка = &Ссылка
	|		И ПутевойЛистСписокЗатрат.Сумма <> 0
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ПутевойЛистЗарплата.Ссылка.Дата,
	|		ПутевойЛистЗарплата.Ссылка.Подразделение,
	|		ПутевойЛистЗарплата.Ссылка.Автомобиль,
	|		ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.РасходыНаОплатуТруда),
	|		НЕОПРЕДЕЛЕНО,
	|		ПутевойЛистЗарплата.Результат,
	|		0
	|	ИЗ
	|		Документ.ПутевойЛист.Зарплата КАК ПутевойЛистЗарплата
	|	ГДЕ
	|		ПутевойЛистЗарплата.Ссылка = &Ссылка
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ПутевойЛист.Дата,
	|		ПутевойЛист.Подразделение,
	|		ПутевойЛист.Автомобиль,
	|		НЕОПРЕДЕЛЕНО,
	|		ЗНАЧЕНИЕ(Справочник.СтатьиДоходов.ТранспортныеУслуги),
	|		0,
	|		ПутевойЛист.СуммаДокумента
	|	ИЗ
	|		Документ.ПутевойЛист КАК ПутевойЛист
	|	ГДЕ
	|		ПутевойЛист.Ссылка = &Ссылка
	|		И ПутевойЛист.Плательщик <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)) КАК ФинансовыйРезультат
	|
	|СГРУППИРОВАТЬ ПО
	|	ФинансовыйРезультат.Период,
	|	ФинансовыйРезультат.Подразделение,
	|	ФинансовыйРезультат.Объект,
	|	ФинансовыйРезультат.СтатьяЗатрат,
	|	ФинансовыйРезультат.СуммаДоходов,
	|	ФинансовыйРезультат.СтатьяДоходов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ВТ_Зарплата.Период,
	|	ВТ_Зарплата.Подразделение,
	|	ВТ_Зарплата.Сотрудник,
	|	СУММА(ВТ_Зарплата.Результат) КАК Сумма,
	|	ЗНАЧЕНИЕ(ПланСчетов.Внутренний.Зарплата) КАК СчетУчета,
	|	ВалютаУчета.Значение КАК Валюта
	|ИЗ
	|	ВТ_Зарплата КАК ВТ_Зарплата,
	|	Константа.ВалютаУчета КАК ВалютаУчета
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_Зарплата.Период,
	|	ВТ_Зарплата.Подразделение,
	|	ВалютаУчета.Значение,
	|	ВТ_Зарплата.Сотрудник
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(виддвижениянакопления.расход),
	|	ПутевойЛистСписокЗатрат.Ссылка.Дата,
	|	ПутевойЛистСписокЗатрат.Ссылка.Подразделение,
	|	ПутевойЛистСписокЗатрат.Ссылка.Водитель,
	|	СУММА(ПутевойЛистСписокЗатрат.Сумма),
	|	ЗНАЧЕНИЕ(ПланСчетов.Внутренний.Подотчет),
	|	ВалютаУчета.Значение
	|ИЗ
	|	Документ.ПутевойЛист.СписокЗатрат КАК ПутевойЛистСписокЗатрат,
	|	Константа.ВалютаУчета КАК ВалютаУчета
	|ГДЕ
	|	ПутевойЛистСписокЗатрат.Ссылка = &Ссылка
	|	И ПутевойЛистСписокЗатрат.Сумма <> 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ПутевойЛистСписокЗатрат.Ссылка.Подразделение,
	|	ВалютаУчета.Значение,
	|	ПутевойЛистСписокЗатрат.Ссылка.Дата,
	|	ПутевойЛистСписокЗатрат.Ссылка.Водитель
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Зарплата.Период,
	|	ВТ_Зарплата.Подразделение,
	|	НАЧАЛОПЕРИОДА(ВТ_Зарплата.Период, МЕСЯЦ) КАК ПериодРегистрации,
	|	ВТ_Зарплата.Сотрудник,
	|	ВТ_Зарплата.ВидРасчета,
	|	СУММА(ВТ_Зарплата.Результат) КАК Результат
	|ИЗ
	|	ВТ_Зарплата КАК ВТ_Зарплата
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_Зарплата.ВидРасчета,
	|	ВТ_Зарплата.Период,
	|	ВТ_Зарплата.Подразделение,
	|	НАЧАЛОПЕРИОДА(ВТ_Зарплата.Период, МЕСЯЦ),
	|	ВТ_Зарплата.Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПутевойЛист.Дата КАК Период,
	|	ПутевойЛист.Подразделение,
	|	ПутевойЛист.Автомобиль КАК Машина,
	|	ПутевойЛист.ПоказанияСпидометра КАК Спидометр
	|ИЗ
	|	Документ.ПутевойЛист КАК ПутевойЛист
	|ГДЕ
	|	ПутевойЛист.ПоказанияСпидометра <> 0
	|	И ПутевойЛист.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(виддвижениянакопления.приход) КАК ВидДвижения,
	|	ПутевойЛист.Дата КАК Период,
	|	ПутевойЛист.Подразделение,
	|	ПутевойЛист.Плательщик КАК Контрагент,
	|	ЗНАЧЕНИЕ(справочник.менеджеры.безменеджера) КАК Менеджер,
	|	ПутевойЛист.СуммаДокумента КАК Сумма,
	|	ВалютаУчета.Значение КАК Валюта
	|ИЗ
	|	Документ.ПутевойЛист КАК ПутевойЛист,
	|	Константа.ВалютаУчета КАК ВалютаУчета
	|ГДЕ
	|	ПутевойЛист.Ссылка = &Ссылка
	|	И ПутевойЛист.Плательщик <> ЗНАЧЕНИЕ(Справочник.Контрагенты.пустаяссылка)";
	
	#КонецОбласти 
	
	запрос.УстановитьПараметр("Ссылка", ссылка);
	запрос.УстановитьПараметр("ДатаСреза", ссылка.Дата);
	
	Возврат запрос.ВыполнитьПакет();
	
КонецФункции