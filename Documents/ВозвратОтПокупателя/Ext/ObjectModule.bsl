﻿
#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(данныеЗаполнения, стандартнаяОбработка)
	
	заполненНаОснованииДокумента = Ложь;
	
	ЗаполнениеОбъектовСервер.ЗаполнитьДанныеНовогоДокумента(ЭтотОбъект, данныеЗаполнения);
	
	// Заполнение по умолчанию.
	Если Организация.Пустая() Тогда
		Организация = Константы.ОсновнаяОрганизация.Получить();
	КонецЕсли;
	
	Если Подразделение.Пустая() Тогда
		Подразделение = ПользователиСервер.ПолучитьЗначениеНастройки("ОсновноеПодразделение");
	КонецЕсли;
	
	ДатаСоздания = ТекущаяДата();
	
	Если ТипЦен.Пустая() Тогда
		ТипЦен = Контрагент.ТипЦен;
	КонецЕсли;
	
	Если Менеджер.Пустая() Тогда
		Менеджер = Справочники.Менеджеры.БезМенеджера;
	КонецЕсли;
	
	// Ввод на основании.
	типДанныхЗаполнения = ТипЗнч(данныеЗаполнения);
	
	Если типДанныхЗаполнения = Тип("Структура") Тогда
		
		ЗаполнитьДокументПоОтбору(данныеЗаполнения);
		
	ИначеЕсли типДанныхЗаполнения = Тип("ДокументСсылка.ВозвратПоставщику") Тогда
		
		ЗаполнитьДокументНаОснованииВозвратаПоставщику(данныеЗаполнения);
		заполненНаОснованииДокумента = Истина;
		
	ИначеЕсли типДанныхЗаполнения = Тип("ДокументСсылка.РасходнаяНакладная") Тогда
		
		ЗаполнитьДокументНаОснованииРасходнойНакладной(данныеЗаполнения);
		заполненНаОснованииДокумента = Истина;
	
	КонецЕсли;
	
	свойствоСозданАвтоматически = Неопределено;
	Если ДополнительныеСвойства.Свойство("СозданАвтоматически", свойствоСозданАвтоматически) И свойствоСозданАвтоматически Тогда
		СозданАвтоматически = Истина;
		Комментарий = данныеЗаполнения.Комментарий;
	КонецЕсли;
	
	
КонецПроцедуры

Процедура ОбработкаПроведения(отказ, режимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	УправлениеНебольшойФирмойСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	//	ПроверкаСтрок
	// Если КоличествоОтклонение > Константа.НормаОтклоненияЗаказа
	
	// ВЗАИМОРАСЧЕТЫ
	Взаиморасчеты = ЭтотОбъект.Движения.ВзаиморасчетыСПокупателями;
	
	Движение = Взаиморасчеты.Добавить();
	
	Движение.Период 		= ЭтотОбъект.Дата;
	Движение.ВидДвижения 	= ВидДвиженияНакопления.Приход;
	Движение.Контрагент		= ЭтотОбъект.Контрагент;
	Движение.Подразделение	= Подразделение;
	
	Если Контрагент.ТипВеденияВзаиморасчетов = Перечисления.ТипыВеденияВзаиморасчетов.ПоНакладным Тогда
		Движение.КредитныйДокумент = Ссылка.ДокОсн;
	КонецЕсли;
	
	Движение.Менеджер = ЭтотОбъект.Менеджер;
	Движение.Сумма 			= -1*ЭтотОбъект.СуммаДокумента;
	
	
	
	// ТОВАРЫ
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ВозвратОтПокупателяЗапасы.НомерСтроки,
	|	ВозвратОтПокупателяЗапасы.Номенклатура,
	|	ВозвратОтПокупателяЗапасы.Количество,
	|	ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Цена, 0) * ВозвратОтПокупателяЗапасы.Количество КАК Стоимость,
	|	ВозвратОтПокупателяЗапасы.Сумма КАК ПродСтоимость,
	|	ВозвратОтПокупателяЗапасы.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ВозвратОтПокупателяЗапасы.ПроцентСкидки,
	|	ВозвратОтПокупателяЗапасы.Скидка КАК СуммаСкидки,
	|	ВозвратОтПокупателяЗапасы.Ссылка.Менеджер
	|ИЗ
	|	Документ.ВозвратОтПокупателя.Запасы КАК ВозвратОтПокупателяЗапасы
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&ДатаСреза, ) КАК ЦеныНоменклатурыСрезПоследних
	|		ПО ВозвратОтПокупателяЗапасы.Номенклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура
	|			И (ЦеныНоменклатурыСрезПоследних.ТипЦен = &ЦенаСклада)
	|			И (ЦеныНоменклатурыСрезПоследних.Подразделение = &Подразделение)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыУчетаПоПодразделениям.СрезПоследних(&ДатаСреза, ) КАК ПараметрыУчетаПоПодразделениямСрезПоследних
	|		ПО (ПараметрыУчетаПоПодразделениямСрезПоследних.СтруктурнаяЕдиница = &Подразделение),
	|	Константы КАК Константы
	|ГДЕ
	|	ВозвратОтПокупателяЗапасы.Ссылка = &Ссылка";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("ДатаСреза", Ссылка.Дата);
	
	СтурктураПараметровПоПодразделению = Новый Структура("Подразделение, ДатаСреза", Подразделение, Дата);
	СтурктураПараметровПоПодразделению = ЦенообразованиеСервер.ПолучитьПараметрыУчетаПоПодразделению(СтурктураПараметровПоПодразделению);
	
	Запрос.УстановитьПараметр("ЦенаСклада", СтурктураПараметровПоПодразделению.ЦенаСклада);
	
	//Управленческий 				= Движения.Управленческий;
	ПартииТоваров 				= Движения.ПартииТоваровНаСкладах;
	Продажи 					= Движения.Продажи;
	ФинРезультаты 				= Движения.ФинансовыйРезультат;
	ВзаиморасчетыСПоставщиками 	= Движения.ВзаиморасчетыСПоставщиками;
	
	//Управленческий.Записывать 				= Истина;
	Взаиморасчеты.Записывать 				= Истина;
	ПартииТоваров.Записывать 				= Истина;
	Продажи.Записывать 						= Истина;
	ФинРезультаты.Записывать 				= Истина;
	ВзаиморасчетыСПоставщиками.Записывать 	= Истина;
	Движения.ТоварыВРознице.Записывать		= Истина;
	Движения.Имущество.Записывать 			= Истина;
	
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ИтДоход = 0;
	
	Пока Выборка.Следующий() Цикл
		
		Движение = ПартииТоваров.Добавить();
		
		Движение.Период 		= ЭтотОбъект.Дата;
		Движение.ВидДвижения 	= ВидДвиженияНакопления.Расход;
		Движение.Номенклатура 	= Выборка.Номенклатура;
		
		//Если ЭтотОбъект.Дата >= Константы.ДатаВводаСкладаВозвратов.Получить() Тогда
		//	Движение.Склад 			= Константы.СкладВозвратов.Получить();
		//Иначе
		//	Движение.Склад 			= Выборка.СтруктурнаяЕдиница;
		//КонецЕсли;
		//
		//Если НЕ(ЭтотОбъект.Подразделение.Код = "000000017") Тогда
			Движение.Склад 			= Выборка.СтруктурнаяЕдиница;
		//КонецЕсли;
		
		
		Движение.Подразделение 	= Подразделение;
		Движение.Количество 	= -Выборка.Количество;
		Движение.Стоимость 		= -Выборка.Стоимость;
		
		движение.СтоимостьВал	= -выборка.Стоимость;
		движение.Валюта			= Константы.ВалютаУчета.Получить();
		движение.СчетУчета		= выборка.Номенклатура.СчетУчета;
		движение.КорСчет		= ПланыСчетов.Внутренний.ВзаиморасчетыСПокупателямиЗаТовар;
		движение.ВидХранения	= Перечисления.ВидыХраненияЗапасов.НаСкладе;
		//Движение.Категория 		= ЭтотОбъект.Контрагент.КатегоияКонтрагента;
		
		
		
		Движение = Продажи.Добавить();
		
		Движение.Период 		= ЭтотОбъект.Дата;
		Движение.Номенклатура 	= Выборка.Номенклатура;
		Движение.Менеджер		= ЭтотОбъект.Менеджер;
		Движение.Контрагент		= ЭтотОбъект.Контрагент;
		Движение.Подразделение	= Подразделение;
		
		Движение.МаршрутРазвоза	= ?(ЭтотОбъект.ДокОсн.ДокОсн = Неопределено,Справочники.МаршрутыРазвоза.ПустойМаршрут, ЭтотОбъект.ДокОсн.ДокОсн.МаршрутРазвоза);
		
		Движение.Количество 	= -1*Выборка.Количество;
		Движение.ПродСтоимость	= -1*Выборка.ПродСтоимость;
		Движение.Доход	 		= -1*(Выборка.ПродСтоимость - Выборка.Стоимость);
		
		Движение.ТипЦены		= ЭтотОбъект.ТипЦен;
		Движение.ЭтоВозврат		= Истина;
		
		Движение.ПроцентСкидки	= Выборка.ПроцентСкидки;
		Движение.КредитныйДокумент	= ЭтотОбъект.ДокОсн;
		Движение.СуммаСкидки	= -1*Выборка.СуммаСкидки;
		
        ИтДоход = ИтДоход + Движение.Доход;
		
	КонецЦикла;
	
	// (сторно) Результат от реализации товаров
	Если НЕ ИтДоход = 0 Тогда
		Движение = ФинРезультаты.Добавить();
		Движение.Период 		= ЭтотОбъект.Дата;
		Движение.Подразделение	= ЭтотОбъект.Подразделение;
		Движение.СтатьяДоходов 	= Справочники.СтатьиДоходов.МаржинальныйДоход;
		Движение.СуммаДоходов	= ИтДоход;
	КонецЕсли;
	
	ГРУППА_ПРОДУКТА_КАНЦТОВАРЫ = Справочники.КД_ГруппыНоменклатуры.НайтиПоКоду("000000026");
	ГРУППА_ПРОДУКТА_ХОЗТОВАРЫ = Справочники.КД_ГруппыНоменклатуры.НайтиПоКоду("000000024");
	
	исключаяГруппыПродукта = Новый Массив;
	исключаяГруппыПродукта.Добавить(ГРУППА_ПРОДУКТА_КАНЦТОВАРЫ);
	исключаяГруппыПродукта.Добавить(ГРУППА_ПРОДУКТА_ХОЗТОВАРЫ);

	суммаТовара = 0;
	Для Каждого строкаЗапасы Из Запасы Цикл
		Если Не строкаЗапасы.Номенклатура.КД_Группа = ГРУППА_ПРОДУКТА_КАНЦТОВАРЫ И
			Не строкаЗапасы.Номенклатура.КД_Группа = ГРУППА_ПРОДУКТА_ХОЗТОВАРЫ Тогда
			суммаТовара = суммаТовара + строкаЗапасы.Сумма;
		КонецЕсли;
	КонецЦикла;
	
	// допроведем розницу ....
	Если ДополнительныеСвойства.УчетнаяПолитика.АвтоУчетРозницы Тогда
		
		СтруктураПараметровОтдела = Новый Структура("Организация, Контрагент", ДокОсн.Организация, Контрагент);
		РозницаСервер.ПолучитьПараметрыОтдела(СтруктураПараметровОтдела);
		
		Если Не СтруктураПараметровОтдела.Подразделение = Неопределено Тогда
			
			// Партии товаров в рознице
			Движение = ПартииТоваров.Добавить();
			
			Движение.ВидДвижения 	= ВидДвиженияНакопления.Приход;
			Движение.Период 		= Дата;
			Движение.Подразделение 	= СтруктураПараметровОтдела.Подразделение;
			Движение.Склад 			= СтруктураПараметровОтдела.Склад;
			Движение.ЦФО 			= СтруктураПараметровОтдела.ОтделМагазина;
			//Движение.Стоимость 		= -1*Запасы.Итог("Сумма");
			//Движение.ПродСтоимость 	= -1*Запасы.Итог("СуммаБезСкидки");
			Движение.Стоимость 		= -суммаТовара;
			Движение.ПродСтоимость 	= -суммаТовара;
			
			Движение.СтоимостьВал	= -1*запасы.Итог("Сумма");
			движение.Валюта			= Константы.ВалютаУчета.Получить();
			движение.ВидХранения	= Перечисления.ВидыХраненияЗапасов.НаСкладе;

			
			// Взаиморасчеты с "Поставщиками"
			Движение = ВзаиморасчетыСПоставщиками.Добавить();
			
			Движение.ВидДвижения 	= ВидДвиженияНакопления.Расход;
			Движение.Период 		= Дата;
			Движение.Подразделение	= СтруктураПараметровОтдела.Подразделение;
			Движение.Контрагент 	= ДополнительныеСвойства.УчетнаяПолитика.Контрагент;
			Движение.ЦФО 			= СтруктураПараметровОтдела.ОтделМагазина;
			Движение.Сумма 			= -1*Запасы.Итог("Сумма");
			
			
			запрос = Новый Запрос;
			
			#Область ТекстЗапроса
			
			запрос.Текст =
			"ВЫБРАТЬ
			|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
			|	ВозвратОтПокупателяЗапасы.Ссылка.Дата КАК Период,
			|	ОтделыВМагазинах.Подразделение,
			|	ОтделыВМагазинах.Ссылка КАК ОтделМагазина,
			|	ВозвратОтПокупателяЗапасы.Номенклатура,
			|	-ВозвратОтПокупателяЗапасы.Количество КАК Количество,
			|	-ВозвратОтПокупателяЗапасы.СуммаБезСкидки КАК Сумма,
			|	-ВозвратОтПокупателяЗапасы.Скидка КАК Наценка
			|ИЗ
			|	Документ.ВозвратОтПокупателя.Запасы КАК ВозвратОтПокупателяЗапасы
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОтделыВМагазинах КАК ОтделыВМагазинах
			|		ПО ВозвратОтПокупателяЗапасы.Ссылка.Контрагент = ОтделыВМагазинах.Магазин
			|			И (ОтделыВМагазинах.Организация = ВозвратОтПокупателяЗапасы.Ссылка.Организация
			|				ИЛИ ОтделыВМагазинах.Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка))
			|ГДЕ
			|	ВозвратОтПокупателяЗапасы.Ссылка = &Документ
			|	И ВозвратОтПокупателяЗапасы.Количество > 0
			|	И НЕ ВозвратОтПокупателяЗапасы.Номенклатура.КД_Группа В (&ИсключаяГруппыПродукта)";
			
			#КонецОбласти
			
			запрос.УстановитьПараметр("Документ", Ссылка);
			запрос.УстановитьПараметр("ИсключаяГруппыПродукта", исключаяГруппыПродукта);
			
			результатЗапроса = запрос.Выполнить();
			
			Движения.ТоварыВРознице.Загрузить(РезультатЗапроса.Выгрузить());
		КонецЕсли;
		
	КонецЕсли;
	
	// ИМУЩЕСТВО
	Если Имущество.Количество() > 0 Тогда
		
		Для Каждого СтрокаСостава Из Имущество Цикл
			
			движение = Движения.Имущество.Добавить();
			
			движение.ВидДвижения = ВидДвиженияНакопления.Приход;
			движение.Период 		= Дата;
			движение.Подразделение	= Подразделение;
			движение.Номенклатура 	= СтрокаСостава.Номенклатура;
			движение.МОЛ			= СтрокаСостава.МОЛ;
			движение.ЦФО			= СтрокаСостава.ЦФО;
			движение.Количество 	= СтрокаСостава.Количество;
			движение.Стоимость 		= СтрокаСостава.Сумма;
			движение.СчетУчета		= СтрокаСостава.Номенклатура.СчетУчета;
			
		КонецЦикла;
		
	КонецЕсли;
	
	// Запись наборов записей.
	//УправлениеНебольшойФирмойСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

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
		|	Документ.ВозвратОтПокупателя.Запасы КАК СоставДокумента
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
	
	Если (Контрагент.ТипВеденияВзаиморасчетов = Перечисления.ТипыВеденияВзаиморасчетов.ПоДоговору)  Тогда
		УправлениеНебольшойФирмойСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Договор");
    Иначе
		ПроверяемыеРеквизиты.Добавить("ДокОсн");
	КонецЕсли;
	
	// кроме "собственных филиалов"
	Если Организация.ЕстьНДС И Не Контрагент.КД_КаналСбыта = Справочники.КД_КаналыСбыта.НайтиПоКоду("000000010") Тогда
		
		// проверим состав.....
		запрос = Новый Запрос;
		
		#Область ТекстЗапроса
		
		запрос.Текст =
		"ВЫБРАТЬ
		|	Запасы.НомерСтроки,
		|	ВЫРАЗИТЬ(Запасы.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура
		|ПОМЕСТИТЬ ТаблицаЗапасы
		|ИЗ
		|	&Запасы КАК Запасы
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВложенныйЗапрос.НомерСтроки,
		|	ВложенныйЗапрос.НоменклатураОснования,
		|	ВложенныйЗапрос.Номенклатура
		|ИЗ
		|	(ВЫБРАТЬ
		|		ТаблицаЗапасы.НомерСтроки КАК НомерСтроки,
		|		ЕСТЬNULL(РасходнаяНакладнаяЗапасы.Номенклатура, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) КАК НоменклатураОснования,
		|		ТаблицаЗапасы.Номенклатура КАК Номенклатура
		|	ИЗ
		|		ТаблицаЗапасы КАК ТаблицаЗапасы
		|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.РасходнаяНакладная.Запасы КАК РасходнаяНакладнаяЗапасы
		|			ПО (&ДокОсн = РасходнаяНакладнаяЗапасы.Ссылка)
		|				И ТаблицаЗапасы.Номенклатура = РасходнаяНакладнаяЗапасы.Номенклатура) КАК ВложенныйЗапрос
		|ГДЕ
		|	ВложенныйЗапрос.НоменклатураОснования = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)";
		
		#КонецОбласти
		
		таблицаЗапасы = Запасы.Выгрузить(, "НомерСтроки, Номенклатура");
		
		запрос.УстановитьПараметр("Запасы", таблицаЗапасы);
		запрос.УстановитьПараметр("ДокОсн", ДокОсн);
		
		результатЗапроса = запрос.Выполнить();
		
		Если Не результатЗапроса.Пустой() Тогда
			// есть ошибки
			выборка = результатЗапроса.Выбрать();
			Пока выборка.Следующий() Цикл
				
				сообщить("строка: "+выборка.НомерСтроки+", "+выборка.Номенклатура+" - отсутствует в документе основании.");
				отказ = Истина;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;

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
	
	СуммаСкидки = ОбщегоНазначенияСервер.ПолучитьСуммуДокумента(ЭтотОбъект, "Запасы",,"Скидка");	
	
	СуммаДокумента = ОбщегоНазначенияСервер.ПолучитьСуммуДокумента(ЭтотОбъект, "Запасы,Имущество");
	
	ОбщегоНазначенияСервер.УстановитьНомерДокумента(ЭтотОбъект);

КонецПроцедуры

Процедура ПриКопировании(объектКопирования)
	
	ЗаполнениеОбъектовСервер.ЗаполнитьДанныеСкопированногоДокумента(ЭтотОбъект, объектКопирования);
	
	ДатаСоздания = ТекущаяДата();
	СозданАвтоматически = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗаполнениеПоОснованию

Процедура ЗаполнитьДокументПоОтбору(Знач данныеЗаполнения)
	
	Если данныеЗаполнения.Свойство("Контрагент") Тогда
		ТипЦен 	= данныеЗаполнения.Контрагент.ТипЦен;
	КонецЕсли;
	
КонецПроцедуры	

Процедура ЗаполнитьДокументНаОснованииРасходнойНакладной(Знач данныеЗаполнения)
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Заполнение реквизитов документа.
	ЗаполнениеОбъектовСервер.ЗаполнитьРеквизитыДокументаПриВводеНаОсновании(ЭтотОбъект, данныеЗаполнения);
	
	запрос = Новый Запрос;
	
	#Область ТекстЗапроса
	
	запрос.Текст =
	"ВЫБРАТЬ
	|	РасходнаяНакладнаяЗапасы.Номенклатура,
	|	РасходнаяНакладнаяЗапасы.ЕдиницаИзмерения,
	|	РасходнаяНакладнаяЗапасы.Количество,
	|	РасходнаяНакладнаяЗапасы.Цена,
	|	РасходнаяНакладнаяЗапасы.Сумма,
	|	РасходнаяНакладнаяЗапасы.СтавкаНДС,
	|	РасходнаяНакладнаяЗапасы.СуммаНДС,
	|	РасходнаяНакладнаяЗапасы.Всего,
	|	РасходнаяНакладнаяЗапасы.ПроцентСкидки,
	|	РасходнаяНакладнаяЗапасы.Скидка,
	|	РасходнаяНакладнаяЗапасы.СуммаБезСкидки,
	|	РасходнаяНакладнаяЗапасы.Номенклатура.Родитель.Склад КАК СтруктурнаяЕдиница
	|ИЗ
	|	Документ.РасходнаяНакладная.Запасы КАК РасходнаяНакладнаяЗапасы
	|ГДЕ
	|	РасходнаяНакладнаяЗапасы.Ссылка = &ДокументОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РасходнаяНакладнаяИмущество.Номенклатура,
	|	РасходнаяНакладнаяИмущество.Количество,
	|	РасходнаяНакладнаяИмущество.Цена,
	|	РасходнаяНакладнаяИмущество.Сумма,
	|	РасходнаяНакладнаяИмущество.МОЛ,
	|	РасходнаяНакладнаяИмущество.Ссылка.ЦФО
	|ИЗ
	|	Документ.РасходнаяНакладная.Имущество КАК РасходнаяНакладнаяИмущество
	|ГДЕ
	|	РасходнаяНакладнаяИмущество.Ссылка = &ДокументОснование";
	
	#КонецОбласти
	
	запрос.УстановитьПараметр("ДокументОснование", данныеЗаполнения);
	результатЗапроса = запрос.ВыполнитьПакет();
	
	ДокОсн = данныеЗаполнения;
	
	Запасы.Загрузить(результатЗапроса[0].Выгрузить());
	Имущество.Загрузить(результатЗапроса[1].Выгрузить());
	
КонецПроцедуры

Процедура ЗаполнитьДокументНаОснованииВозвратаПоставщику(Знач данныеЗаполнения)
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Заполнение реквизитов документа.
	ЗаполнениеОбъектовСервер.ЗаполнитьРеквизитыДокументаПриВводеНаОсновании(ЭтотОбъект, данныеЗаполнения);
	
	запрос = Новый Запрос;
	
	#Область ТекстЗапроса
	
	запрос.Текст =
	"ВЫБРАТЬ
	|	ВозвратПоставщику.Ссылка КАК ДокументОснование,
	|	СД_СоответствияСрезПоследних.КлючСоответствия,
	|	ЕСТЬNULL(СД_СоответствияСрезПоследних.ПодразделениеЗначение, ВозвратПоставщику.Подразделение) КАК Подразделение,
	|	ЕСТЬNULL(СД_СоответствияСрезПоследних.КонтрагентЗначение, ВозвратПоставщику.Контрагент) КАК Контрагент,
	|	ВозвратПоставщику.ЦФОПолучатель КАК ЦФО
	|ИЗ
	|	Документ.ВозвратПоставщику КАК ВозвратПоставщику
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СД_Соответствия.СрезПоследних(&МоментВремени, КлючСоответствия.ВидДокумента = &ВидДокумента) КАК СД_СоответствияСрезПоследних
	|		ПО (СД_СоответствияСрезПоследних.Активно = ИСТИНА)
	|			И ВозвратПоставщику.Подразделение = СД_СоответствияСрезПоследних.КлючСоответствия.Подразделение
	|			И ВозвратПоставщику.Контрагент = СД_СоответствияСрезПоследних.КлючСоответствия.Контрагент
	|ГДЕ
	|	ВозвратПоставщику.Ссылка = &ДокументОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВозвратПоставщикуЗапасы.Номенклатура,
	|	ВозвратПоставщикуЗапасы.ЕдиницаИзмерения,
	|	ВозвратПоставщикуЗапасы.Количество,
	|	ВозвратПоставщикуЗапасы.Цена,
	|	ВозвратПоставщикуЗапасы.Сумма,
	|	ВозвратПоставщикуЗапасы.СтавкаНДС,
	|	ВозвратПоставщикуЗапасы.СуммаНДС,
	|	ВозвратПоставщикуЗапасы.Всего,
	|	ВозвратПоставщикуЗапасы.Номенклатура.Родитель.Склад КАК СтруктурнаяЕдиница
	|ИЗ
	|	Документ.ВозвратПоставщику.Запасы КАК ВозвратПоставщикуЗапасы
	|ГДЕ
	|	ВозвратПоставщикуЗапасы.Ссылка = &ДокументОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВозвратПоставщикуИмущество.Номенклатура,
	|	ВозвратПоставщикуИмущество.Количество,
	|	ВозвратПоставщикуИмущество.Цена,
	|	ВозвратПоставщикуИмущество.Сумма,
	|	ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка) КАК МОЛ,
	|	ВозвратПоставщикуИмущество.Ссылка.ЦФОПолучатель КАК ЦФО
	|ИЗ
	|	Документ.ВозвратПоставщику.Имущество КАК ВозвратПоставщикуИмущество
	|ГДЕ
	|	ВозвратПоставщикуИмущество.Ссылка = &ДокументОснование";
	
	#КонецОбласти
	
	запрос.УстановитьПараметр("МоментВремени", МоментВремени());
	запрос.УстановитьПараметр("ДокументОснование", данныеЗаполнения);
	запрос.УстановитьПараметр("ВидДокумента", Перечисления.СД_ВидыСвязанныхДокументов.ВозвратПоставщику);
	
	результатЗапроса = запрос.ВыполнитьПакет();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, результатЗапроса[0].Выгрузить()[0]);
	
	Запасы.Загрузить(результатЗапроса[1].Выгрузить());
	Имущество.Загрузить(результатЗапроса[2].Выгрузить());

	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
