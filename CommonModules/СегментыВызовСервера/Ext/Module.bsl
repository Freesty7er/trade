﻿//Удаляет из регистра сведений записи, относящиеся к сегменту
Процедура Очистить(сегментСсылка) Экспорт

	Если ТипЗнч(сегментСсылка) = Тип("СправочникСсылка.СегментыПартнеров") Тогда
		наборСегмента = РегистрыСведений.ПартнерыСегмента.СоздатьНаборЗаписей();
	Иначе
		//наборСегмента = РегистрыСведений.НоменклатураСегмента.СоздатьНаборЗаписей();	
	КонецЕсли;
		
	наборСегмента.Отбор.Сегмент.Установить(сегментСсылка);
	наборСегмента.Записать();

КонецПроцедуры

//Заполняет регистр сведений объектами, вошедшими в сегмент
Процедура Сформировать(сегментСсылка) Экспорт

	ПР = ПривилегированныйРежим();
	
	Если НЕ ПР Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;

	списокЭлементов = СегментыСервер.СписокЭлементовСКД(СегментСсылка);
	
	включатьХарактеристики = списокЭлементов.Колонки.Найти("ХарактеристикаЭлемента") <> Неопределено;

	Если ТипЗнч(сегментСсылка) = Тип("СправочникСсылка.СегментыПартнеров") Тогда
			
		наборЗаписей = РегистрыСведений.ПартнерыСегмента.СоздатьНаборЗаписей();
		наборЗаписей.Отбор.Сегмент.Установить(СегментСсылка);
		
		Для Каждого элемент Из списокЭлементов Цикл
			
			Если НЕ ЗначениеЗаполнено(элемент.ЭлементСписка) Тогда
				Продолжить;
			КонецЕсли;
			
			запись = НаборЗаписей.Добавить();
			запись.Сегмент = сегментСсылка;
			запись.Партнер = элемент.ЭлементСписка;
			
		КонецЦикла;	
	Иначе
		
		//НаборЗаписей = РегистрыСведений.НоменклатураСегмента.СоздатьНаборЗаписей();
		//НаборЗаписей.Отбор.Сегмент.Установить(СегментСсылка);
		//
		//Для Каждого Элемент Из СписокЭлементов Цикл
		//	Если НЕ ЗначениеЗаполнено(Элемент.ЭлементСписка) Тогда
		//		Продолжить;
		//	КонецЕсли;
		//	Запись = НаборЗаписей.Добавить();
		//	Запись.Сегмент = СегментСсылка;
		//	Запись.Номенклатура = Элемент.ЭлементСписка;
		//	Если ВключатьХарактеристики Тогда
		//		Запись.Характеристика = Элемент.ХарактеристикаЭлемента;
		//	КонецЕсли;
		//КонецЦикла;
	
	КонецЕсли;

	наборЗаписей.Записать();

	Если НЕ ПР Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;

КонецПроцедуры	// Сформировать()

//Возвращает таблицу значений, содержащую ссылки на элементы,
//входящие в сегмент, по настройкам СКД
//
Функция СписокЭлементовСКД(сегментСсылка) Экспорт

	настройки = ПолучитьНастройкиСписка(сегментСсылка);
	Возврат ТаблицаСКД(настройки.СКД, настройки.Настройки);

КонецФункции	// СписокЭлементовСКД()

//Возвращает структуру, содержащую СКД сегмента и настройки варианта,
//содержащего список элементов. При этом подключаются поля запроса списка.
//
Функция ПолучитьНастройкиСписка(сегментСсылка)
	
	реквизитыСКДСегмента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		сегментСсылка,
		"СхемаКомпоновкиДанных,ХранилищеНастроекКомпоновкиДанных,ИмяШаблонаСКД");
		
	настройкиСегмента = реквизитыСКДСегмента.ХранилищеНастроекКомпоновкиДанных.Получить();
		
	Если ПустаяСтрока(реквизитыСКДСегмента.ИмяШаблонаСКД) Тогда
		
		СКД = реквизитыСКДСегмента.СхемаКомпоновкиДанных.Получить();
		
	Иначе
		
		СКД_Макета = ПолучитьОписаниеИСхемуКомпоновкиДанныхПоИмениМакета(сегментСсылка, реквизитыСКДСегмента.ИмяШаблонаСКД);
		СКД = СКД_Макета.СхемаКомпоновкиДанных;
		
	КонецЕсли;
	
	//подключить поля запроса списка
	
	Если СКД.НаборыДанных.Найти("СписокСегмента") <> Неопределено Тогда
		
		поля = СКД.НаборыДанных.СписокСегмента.Поля;
		
		Для Каждого поле Из поля Цикл
			поле.ОграничениеИспользования.Поле = Ложь;
		КонецЦикла;//подключить поля запроса списка
		
		настройкиСписка = СКД.ВариантыНастроек.Список.Настройки;
		настройки = СКД.НастройкиПоУмолчанию;
		
		компоновкаДанныхКлиентСервер.СкопироватьЭлементы(настройкиСписка.ПараметрыДанных, настройки.ПараметрыДанных);
		компоновкаДанныхКлиентСервер.СкопироватьЭлементы(настройкиСписка.Отбор, настройки.Отбор);
		
	ИначеЕсли  СКД.НаборыДанных.Найти("ФормированиеСегмента") <> Неопределено Тогда
		
		Если настройкиСегмента <> Неопределено Тогда
			
			настройкиСписка = настройкиСегмента;
			
		Иначе
			
			настройкиСписка = СКД.ВариантыНастроек.ФормированиеСегмента.Настройки;
			
		КонецЕсли;
		
	Иначе
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	Возврат Новый Структура("СКД, Настройки", СКД, настройкиСписка);
	
КонецФункции	// ПолучитьНастройкиСписка()

//Формирует и возвращает таблицу значений по СКД и настройкам
//Параметры:
//СКД - схема компоновки данных,
//Настройки - вариант настроек схемы, по которым необходимо сформировать таблицу
//
Функция ТаблицаСКД(СКД, настройки)

	компоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	макетКомпоновки = КомпоновщикМакета.Выполнить(
		СКД, настройки,,,
		Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
		
	процессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	процессорКомпоновкиДанных.Инициализировать(МакетКомпоновки);
	процессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	
	таблицаЗначений = Новый ТаблицаЗначений;
	
	процессорВывода.УстановитьОбъект(ТаблицаЗначений);
	процессорВывода.Вывести(ПроцессорКомпоновкиДанных);

	колонка = таблицаЗначений.Колонки.Найти("Партнер");
	Если колонка <> Неопределено Тогда
		колонка.Имя = "ЭлементСписка";
	КонецЕсли;
	
	колонка = таблицаЗначений.Колонки.Найти("Номенклатура");
	Если колонка <> Неопределено Тогда
		колонка.Имя = "ЭлементСписка";
	КонецЕсли;
	
	колонка = таблицаЗначений.Колонки.Найти("Характеристика");
	Если колонка <> Неопределено Тогда
		колонка.Имя = "ХарактеристикаЭлемента";
	КонецЕсли;
	
	Если таблицаЗначений.Колонки.Количество() = 1 Тогда
		таблицаЗначений.Свернуть("ЭлементСписка");
	Иначе
		таблицаЗначений.Свернуть("ЭлементСписка,ХарактеристикаЭлемента");
	КонецЕсли;

	Возврат таблицаЗначений;

КонецФункции	// ТаблицаСКД()

Функция ПолучитьОписаниеИСхемуКомпоновкиДанныхПоИмениМакета(ссылка, имяШаблона) Экспорт

	возвращаемоеЗначение = Новый Структура;
	возвращаемоеЗначение.Вставить("Описание",                  "");
	возвращаемоеЗначение.Вставить("СхемаКомпоновкиДанных",     Неопределено);
	возвращаемоеЗначение.Вставить("НастройкиКомпоновкиДанных", Неопределено);
	
	Если ТипЗнч(ссылка) = Тип("СправочникСсылка.СегментыПартнеров") Тогда
		
		имяСправочника = "СегментыПартнеров";
		
	//ИначеЕсли ТипЗнч(ссылка) = Тип("СправочникСсылка.СегментыНоменклатуры") Тогда
	//	
	//	имяСправочника = "СегментыНоменклатуры";
		
	Иначе
		
		Возврат ВозвращаемоеЗначение;
	
	КонецЕсли;
	
	запрос = Новый Запрос;
	
	#Область ТекстЗапроса
	
	запрос.Текст = "
	|ВЫБРАТЬ
	|	Сегменты.СхемаКомпоновкиДанных КАК ХранилищеСхемыКомпоновкиДанных,
	|	Сегменты.ХранилищеНастроекКомпоновкиДанных
	|ИЗ
	|	Справочник." + ИмяСправочника + " КАК Сегменты
	|ГДЕ
	|	Сегменты.Ссылка = &Ссылка";
	
	#КонецОбласти 
	
	запрос.УстановитьПараметр("Ссылка",ссылка);
	
	выборка = запрос.Выполнить().Выбрать();
	
	Если Не ЗначениеЗаполнено(имяШаблона) Тогда
		
		возвращаемоеЗначение.Описание = имяШаблона;
		
		Если выборка.Следующий() Тогда
			
			схемаКомпоновкиДанных = выборка.ХранилищеСхемыКомпоновкиДанных.Получить();
			
			Если схемаКомпоновкиДанных = Неопределено Тогда
				возвращаемоеЗначение.СхемаКомпоновкиДанных = Справочники[ИмяСправочника].ПолучитьМакет("ОсновнаяСхема");
				возвращаемоеЗначение.НастройкиКомпоновкиДанных = возвращаемоеЗначение.СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
			Иначе
				возвращаемоеЗначение.СхемаКомпоновкиДанных = схемаКомпоновкиДанных;
				возвращаемоеЗначение.НастройкиКомпоновкиДанных = выборка.ХранилищеНастроекКомпоновкиДанных.Получить();
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		возвращаемоеЗначение.Описание = Метаданные.НайтиПоТипу(ТипЗнч(Ссылка)).Макеты.Найти(имяШаблона).Синоним;
		возвращаемоеЗначение.СхемаКомпоновкиДанных = Справочники[имяСправочника].ПолучитьМакет(имяШаблона);
		
		Если выборка.Следующий() Тогда
			возвращаемоеЗначение.НастройкиКомпоновкиДанных = выборка.ХранилищеНастроекКомпоновкиДанных.Получить();
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат возвращаемоеЗначение;

КонецФункции	// ПолучитьОписаниеИСхемуКомпоновкиДанныхПоИмениМакета()

Функция ПолучитьАдресаСхемыКомпоновкиДанныхВоВременномХранилище(сегментСсылка,
	                                                            имяШаблонаСКД,
	                                                            адресСКД,
	                                                            адресНастроекСКД,
	                                                            уникальныйИдентификатор) Экспорт
	
	адреса = Новый Структура("СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных");
	
	// Схема
	Если ЗначениеЗаполнено(имяШаблонаСКД) И ПустаяСтрока(адресСКД) Тогда
		схемаИНастройки = СегментыСервер.ПолучитьОписаниеИСхемуКомпоновкиДанныхПоИмениМакета(сегментСсылка, имяШаблонаСКД);
		схемаКомпоновкиДанных = схемаИНастройки.СхемаКомпоновкиДанных;
		адреса.СхемаКомпоновкиДанных = ПоместитьВоВременноеХранилище(схемаКомпоновкиДанных, уникальныйИдентификатор)
	Иначе
		адреса.СхемаКомпоновкиДанных = адресСКД;
	КонецЕсли;

	// Настройки
	Если Не ПустаяСтрока(адресНастроекСКД) Тогда
		адреса.НастройкиКомпоновкиДанных = адресНастроекСКД;
	КонецЕсли;
	
	Возврат адреса;
	
КонецФункции	// ПолучитьАдресаСхемыКомпоновкиДанныхВоВременномХранилище()

// нач. 17.03.2017 Карпачев А.Ю. перенос из ут 11.1
Функция ПрименитьИзмененияКСхемеКомпоновкиДанных(СегментСсылка, ИмяШаблонаСКД, АдресСКД, АдресНастроекСКД, УникальныйИдентификатор) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ИмяШаблонаСКД", ИмяШаблонаСКД);
	ВозвращаемоеЗначение.Вставить("ПредставлениеШаблонаСКД",НСтр("ru = 'Произвольный'"));
	ВозвращаемоеЗначение.Вставить("АдресСКД", "");
	ВозвращаемоеЗначение.Вставить("АдресНастроекСКД","");
	
	Если ЗначениеЗаполнено(ИмяШаблонаСКД) Тогда
		
		СхемаИНастройки = СегментыСервер.ПолучитьОписаниеИСхемуКомпоновкиДанныхПоИмениМакета(СегментСсылка, ИмяШаблонаСКД);
		// Если схема компоновки данных из макета <> полученной из редактора схеме компоновки данных
		Если СегментыСервер.ПолучитьXML(СхемаИНастройки.СхемаКомпоновкиДанных) <> СегментыСервер.ПолучитьXML(ПолучитьИзВременногоХранилища(АдресСКД)) Тогда
			
			ВозвращаемоеЗначение.ИмяШаблонаСКД  = "";
			ВозвращаемоеЗначение.АдресСКД = АдресСКД;
			
		Иначе
			
			ВозвращаемоеЗначение.ПредставлениеШаблонаСКД = СхемаИНастройки.Описание;
			
		КонецЕсли;
		
		// Полученные настройки могут быть равны настройкам по умолчанию схемы.
		КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
		Попытка
			КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаИНастройки.СхемаКомпоновкиДанных));
		Исключение
		КонецПопытки;
		КомпоновщикНастроек.ЗагрузитьНастройки(СхемаИНастройки.СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
		КомпоновщикНастроек.Восстановить();
		Если СегментыСервер.ПолучитьXML(КомпоновщикНастроек.ПолучитьНастройки()) <> СегментыСервер.ПолучитьXML(ПолучитьИзВременногоХранилища(АдресНастроекСКД)) Тогда
			ВозвращаемоеЗначение.АдресНастроекСКД = АдресНастроекСКД;
		КонецЕсли;
		
	Иначе
		
		ВозвращаемоеЗначение.АдресСКД = АдресСКД;
		
		Схема = ПолучитьИзВременногоХранилища(АдресСКД);
		ХранилищеСхемыКомпоновкиДанных = Новый ХранилищеЗначения(Схема);
		
		КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
		Попытка
			КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(Схема));
		Исключение
		КонецПопытки;
		КомпоновщикНастроек.ЗагрузитьНастройки(Схема.НастройкиПоУмолчанию);
		КомпоновщикНастроек.Восстановить();
		
		Если СегментыСервер.ПолучитьXML(КомпоновщикНастроек.ПолучитьНастройки()) <> СегментыСервер.ПолучитьXML(ПолучитьИзВременногоХранилища(АдресНастроекСКД)) Тогда
			ВозвращаемоеЗначение.АдресНастроекСКД = АдресНастроекСКД;
		КонецЕсли;
	
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции
// кон. 17.03.2017 Карпачев А.Ю.
