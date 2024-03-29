﻿
Функция ПолучитьОписаниеИСхемуКомпоновкиДанныхПоИмениМакета(ссылка, имяШаблона) Экспорт

	возвращаемоеЗначение = Новый Структура;
	возвращаемоеЗначение.Вставить("Описание",                  "");
	возвращаемоеЗначение.Вставить("СхемаКомпоновкиДанных",     Неопределено);
	возвращаемоеЗначение.Вставить("НастройкиКомпоновкиДанных", Неопределено);
	
	Если ТипЗнч(ссылка) = Тип("СправочникСсылка.СегментыПартнеров") Тогда
		
		имяСправочника = "СегментыПартнеров";
		
	ИначеЕсли ТипЗнч(ссылка) = Тип("СправочникСсылка.СегментыНоменклатуры") Тогда
		
		ИмяСправочника = "СегментыНоменклатуры";
		
		// нач. 17.03.2017 Карпачев А.Ю.
	ИначеЕсли ТипЗнч(ссылка) = Тип("СправочникСсылка.ЦелевыеПоказатели") Тогда
		имяСправочника = "ЦелевыеПоказатели";
		// кон. 17.03.2017 Карпачев А.Ю.
		
	Иначе
		
		Возврат возвращаемоеЗначение;
		
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
	
	запрос.УстановитьПараметр("Ссылка",Ссылка);
	
	выборка = запрос.Выполнить().Выбрать();
	
	Если Не ЗначениеЗаполнено(имяШаблона) Тогда
		
		возвращаемоеЗначение.Описание = имяШаблона;
		Если выборка.Следующий() Тогда
			
			схемаКомпоновкиДанных = выборка.ХранилищеСхемыКомпоновкиДанных.Получить();
			Если схемаКомпоновкиДанных = Неопределено Тогда
				возвращаемоеЗначение.СхемаКомпоновкиДанных = Справочники[имяСправочника].ПолучитьМакет("ОсновнаяСхема");
				возвращаемоеЗначение.НастройкиКомпоновкиДанных = возвращаемоеЗначение.СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
			Иначе
				возвращаемоеЗначение.СхемаКомпоновкиДанных = схемаКомпоновкиДанных;
				возвращаемоеЗначение.НастройкиКомпоновкиДанных = выборка.ХранилищеНастроекКомпоновкиДанных.Получить();
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		возвращаемоеЗначение.Описание = Метаданные.НайтиПоТипу(ТипЗнч(ссылка)).Макеты.Найти(имяШаблона).Синоним;
		возвращаемоеЗначение.СхемаКомпоновкиДанных = Справочники[имяСправочника].ПолучитьМакет(имяШаблона);
		
		Если выборка.Следующий() Тогда
			возвращаемоеЗначение.НастройкиКомпоновкиДанных = выборка.ХранилищеНастроекКомпоновкиДанных.Получить();
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат возвращаемоеЗначение;

КонецФункции	// ПолучитьОписаниеИСхемуКомпоновкиДанныхПоИмениМакета()

#Область ОбработчикиСобытийСправочниковСегментов

Процедура ПриСозданииНаСервере(форма) Экспорт
	
	объект = форма.Объект;
	объектСсылка = объект.Ссылка;
	
	Если ТипЗнч(объектСсылка) = Тип("СправочникСсылка.СегментыПартнеров") Тогда
		
		поПартнерам = Истина;
		
		//ИначеЕсли ТипЗнч(объектСсылка) = Тип("СправочникСсылка.СегментыНоменклатуры") Тогда
		//	
		//	поПартнерам = Ложь;
		
		// 2017.03.17 Карпачев А.Ю.
	ИначеЕсли ТипЗнч(объектСсылка) = Тип("СправочникСсылка.ЦелевыеПоказатели") Тогда
		поПартнерам = Ложь;
		// просто что бы не вывалится из процедуры и получить "ИмяШаблонаСКД"
		// /2017.03.17 Карпачев А.Ю.
		
	Иначе
		
		Возврат;
		
	КонецЕсли;
	
	Если поПартнерам Тогда
		Форма.ЕстьПравоИзменения = ПравоДоступа("Изменение",Метаданные.Справочники.СегментыПартнеров);
	Иначе
		//Форма.ЕстьПравоИзменения = ПравоДоступа("Изменение",Метаданные.Справочники.СегментыНоменклатуры);
	КонецЕсли;
	
	// нач. 17.03.2017 Карпачев А.Ю.
	Если ТипЗнч(объектСсылка) <> Тип("СправочникСсылка.ЦелевыеПоказатели") Тогда
		// кон. 17.03.2017 Карпачев А.Ю.
	
	форма.Элементы.ДатаОчистки.ТолькоПросмотр =
		объект.СпособФормирования <> Перечисления.СпособыФормированияСегментов.ФормироватьВручную;
		
		// нач. 17.03.2017 Карпачев А.Ю.
	КонецЕсли;
	// кон. 17.03.2017 Карпачев А.Ю.
		
	Если ЗначениеЗаполнено(объектСсылка) Тогда
		
		СКД = объект.Ссылка.СхемаКомпоновкиДанных.Получить();
		настройки = объект.Ссылка.ХранилищеНастроекКомпоновкиДанных.Получить();
		
		Если СКД <> Неопределено Тогда
			Форма.АдресСКД = ПоместитьВоВременноеХранилище(СКД, Новый УникальныйИдентификатор);
		КонецЕсли;
		
		Если Настройки <> Неопределено Тогда
			Форма.АдресНастроекСКД = ПоместитьВоВременноеХранилище(Настройки, Новый УникальныйИдентификатор);
		КонецЕсли;
		
	Иначе
		
		объект.ИмяШаблонаСКД = "ОсновнаяСхема";
		
	КонецЕсли;
	
	// нач. 17.03.2017 Карпачев А.Ю.
	Если ТипЗнч(объектСсылка) <> Тип("СправочникСсылка.ЦелевыеПоказатели") Тогда
		// кон. 17.03.2017 Карпачев А.Ю.
		
		ПолучитьРасписаниеРегламентногоЗадания(Форма);
		
		// нач. 17.03.2017 Карпачев А.Ю.
	КонецЕсли;
	// кон. 17.03.2017 Карпачев А.Ю.
	
	Если НЕ ПустаяСтрока(объект.ИмяШаблонаСКД) Тогда
		
		метаданныеШаблона = Метаданные.НайтиПоТипу(ТипЗнч(ОбъектСсылка)).Макеты.Найти(Объект.ИмяШаблонаСКД);
		Если метаданныеШаблона = Неопределено Тогда
			
			Форма.ПредставлениеШаблонаСКД = НСтр("ru = 'Произвольная'");
			
		Иначе
			
			Форма.ПредставлениеШаблонаСКД = МетаданныеШаблона.Синоним;
			
		КонецЕсли;
		
	Иначе
		
		Форма.ПредставлениеШаблонаСКД = НСтр("ru = 'Произвольная'");
		
	КонецЕсли;
	
КонецПроцедуры	// ПриСозданииНаСервере()

Процедура ПередЗаписьюНаСервере(форма, текущийОбъект) Экспорт
	
	Если Не ПустаяСтрока(форма.АдресСКД) Тогда 
		текущийОбъект.СхемаКомпоновкиДанных = 
			Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(форма.АдресСКД));
	Иначе
		
		текущийОбъект.СхемаКомпоновкиДанных = Новый ХранилищеЗначения(Неопределено);

	КонецЕсли;
	
	Если Не ПустаяСтрока(форма.АдресНастроекСКД) Тогда 
		
		текущийОбъект.ХранилищеНастроекКомпоновкиДанных =
			Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(форма.АдресНастроекСКД));
			
	Иначе
			
		текущийОбъект.ХранилищеНастроекКомпоновкиДанных = Новый ХранилищеЗначения(Неопределено);
		
	КонецЕсли;
	
	// нач. 22.03.2017 Карпачев А.Ю.
	Если ТипЗнч(текущийОбъект) <> Тип("СправочникОбъект.ЦелевыеПоказатели") Тогда
		// кон. 22.03.2017 Карпачев А.Ю.
		
		Если форма.Объект.СпособФормирования = Перечисления.СпособыФормированияСегментов.ПериодическиОбновлять Тогда
			текущийОбъект.ДополнительныеСвойства.Вставить("Расписание", форма.Расписание);
			текущийОбъект.ДополнительныеСвойства.Вставить("Использование", форма.РегламентноеЗаданиеИспользуется);
		КонецЕсли;
		
		// нач. 22.03.2017 Карпачев А.Ю.
	КонецЕсли;
	// кон. 22.03.2017 Карпачев А.Ю.

КонецПроцедуры	// ПередЗаписьюНаСервере()

Процедура СегментОбъектПередЗаписью(объект, отказ) Экспорт
	
	Если отказ Или объект.ОбменДанными.Загрузка Или объект.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	// Создание регламентное задание (получение уникального идентификатора)
	УстановитьПривилегированныйРежим(Истина);
	
	задание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(объект.РегламентноеЗадание);
	
	Если Задание = Неопределено И объект.СпособФормирования = Перечисления.СпособыФормированияСегментов.ПериодическиОбновлять Тогда
		
		задание = РегламентныеЗадания.СоздатьРегламентноеЗадание(Метаданные.РегламентныеЗадания.ФормированиеСегментов);
		задание.Использование = Ложь;
		задание.Наименование = НСтр("ru = 'Формирование сегмента партнеров: '") + СокрЛП(Объект.Наименование);
		задание.Записать();
		
		объект.РегламентноеЗадание = задание.УникальныйИдентификатор;
		
	КонецЕсли;
	
	объект.ДополнительныеСвойства.Вставить("Задание", задание);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры	// СегментОбъектПередЗаписью()

Процедура СегментПередУдалением(объект, отказ) Экспорт

	Если отказ Или объект.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если Не объект.СпособФормирования = Перечисления.СпособыФормированияСегментов.ФормироватьДинамически Тогда
		СегментыВызовСервера.Очистить(объект.Ссылка);
	КонецЕсли;
	
	задание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(объект.РегламентноеЗадание);
	Если задание <> Неопределено Тогда
		задание.Удалить();
	КонецЕсли;

КонецПроцедуры	// СегментПередУдалением()

Процедура СегментОбработкаЗаполнения(объект) Экспорт
	
	Если Не объект.ЭтоГруппа Тогда
		
		//установить ответственного по умолчанию
		объект.Автор = Пользователи.ТекущийПользователь();
		
		//установить дату создания
		объект.ДатаСоздания = ТекущаяДатаСеанса();
		
	КонецЕсли;
	
КонецПроцедуры	// СегментОбработкаЗаполнения()

Процедура СегментПриКопировании(объект) Экспорт
	
	
	Если Не объект.ЭтоГруппа Тогда
		
		объект.Автор = Пользователи.ТекущийПользователь();
		объект.ДатаСоздания = ТекущаяДата();
		объект.РегламентноеЗадание = Неопределено;
	
	КонецЕсли;
	
КонецПроцедуры	// СегментПриКопировании()

Процедура СегментПриЗаписи(объект, отказ) Экспорт
	
	Если отказ Или объект.ОбменДанными.Загрузка Или объект.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если объект.СпособФормирования = Перечисления.СпособыФормированияСегментов.ФормироватьДинамически Тогда
		СегментыВызовСервера.Очистить(объект.Ссылка);
	КонецЕсли;
	
	Если объект.ДополнительныеСвойства.Свойство("Задание") Тогда
		
		задание = объект.ДополнительныеСвойства.Задание;
		Если задание = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
	Иначе
		Возврат;
	КонецЕсли;
	
	
	заданиеИзменено = Ложь;
	
	Если Не объект.СпособФормирования = Перечисления.СпособыФормированияСегментов.ПериодическиОбновлять Тогда
		
		задание.Использование = Ложь;
		заданиеИзменено = Истина;
		
	КонецЕсли;
	
	// Расписание устанавливается в форме элемента
	Если объект.ДополнительныеСвойства.Свойство("Расписание") 
			И ТипЗнч(объект.ДополнительныеСвойства.Расписание) = Тип("РасписаниеРегламентногоЗадания")
			И Строка(объект.ДополнительныеСвойства.Расписание) <> Строка(задание.Расписание)
		Тогда
		задание.Расписание = объект.ДополнительныеСвойства.Расписание;
		заданиеИзменено = Истина;
	КонецЕсли;
	
	// Использование устанавливается в форме элемента
	Если объект.ПометкаУдаления И задание.Использование Тогда
		
		задание.Использование = Ложь;
		заданиеИзменено = Истина;
		
	ИначеЕсли объект.ДополнительныеСвойства.Свойство("Использование") 
			И объект.ДополнительныеСвойства.Использование <> задание.Использование Тогда
			
		задание.Использование = объект.ДополнительныеСвойства.Использование;
		заданиеИзменено = Истина;
		
	КонецЕсли;

	Если ТипЗнч(объект.Ссылка) = Тип("СправочникСсылка.СегментыПартнеров") Тогда
		
		НаименованиеЗадания = НСтр("ru = 'Формирование сегмента партнеров: '");
		
	//ИначеЕсли ТипЗнч(объект.Ссылка) = Тип("СправочникСсылка.СегментыНоменклатуры") Тогда
	//	
	//	НаименованиеЗадания = НСтр("ru = 'Формирование сегмента номенклатуры: '");
		
	КонецЕсли;
	
	НаименованиеЗадания = НаименованиеЗадания + СокрЛП(объект.Наименование);
	
	Если задание.Наименование <> НаименованиеЗадания Тогда
		задание.Наименование = НаименованиеЗадания;
		заданиеИзменено = Истина;
	КонецЕсли;
	
	Если Не (задание.Параметры.Количество() = 1) Или Не (задание.Параметры[0] = объект.Ссылка) Тогда
		
		параметрыЗадания = Новый Массив;
		параметрыЗадания.Добавить(Объект.Ссылка);
		
		задание.Параметры = параметрыЗадания;
		заданиеИзменено = Истина;
		
	КонецЕсли;
		
	Если заданиеИзменено Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		
		задание.Записать();
		
	КонецЕсли;
	
КонецПроцедуры	// СегментПриЗаписи()

#КонецОбласти 


//Выполняет очистку не динамических сегментов по запланированным датам
//
Процедура ВыполнитьПлановуюОчистку() Экспорт

	УстановитьПривилегированныйРежим(Истина);

	//выбрать сегменты, формируемые вручную с подходящей датой очистки
	запрос = Новый Запрос;
	
	#Область ТекстЗапроса
	
	запрос.Текст =
	"ВЫБРАТЬ
	|//	СегментыНоменклатуры.Ссылка
	|//ИЗ
	|//	Справочник.СегментыНоменклатуры КАК СегментыНоменклатуры
	|//ГДЕ
	|//	СегментыНоменклатуры.СпособФормирования = ЗНАЧЕНИЕ(Перечисление.СпособыФормированияСегментов.ФормироватьВручную)
	|//	И СегментыНоменклатуры.ДатаОчистки <> ДАТАВРЕМЯ(1, 1, 1)
	|//	И СегментыНоменклатуры.ДатаОчистки <= &ДатаОчистки
	|//
	|//ОБЪЕДИНИТЬ ВСЕ
	|
	|//ВЫБРАТЬ
	|	СегментыПартнеров.Ссылка
	|ИЗ
	|	Справочник.СегментыПартнеров КАК СегментыПартнеров
	|ГДЕ
	|	СегментыПартнеров.СпособФормирования = ЗНАЧЕНИЕ(Перечисление.СпособыФормированияСегментов.ФормироватьВручную)
	|	И СегментыПартнеров.ДатаОчистки <> ДАТАВРЕМЯ(1, 1, 1)
	|	И СегментыПартнеров.ДатаОчистки <= &ДатаОчистки";
	
	#КонецОбласти 		
	
	запрос.УстановитьПараметр("ДатаОчистки",ТекущаяДата());
	
	выборка = запрос.Выполнить().Выбрать();

	//очистить выбранные сегменты
	Пока выборка.Следующий() Цикл
		СегментыВызовСервера.Очистить(выборка.Ссылка);
	КонецЦикла;

	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры	// ВыполнитьПлановуюОчистку()

// Запускает формирование сегмента и контролирует результат
// 
// Параметры:
//   Сегменты (СправочникСсылка.СегментыПартнеров, СправочникСсылка.СегментыНоменклатуры) - Сегмент, который должен быть сформирован
//
Процедура ВыполнитьПериодическоеФормирование(сегмент) Экспорт
	
	Если ПустаяСтрока(ИмяПользователя()) Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(сегмент) Тогда
		Возврат;
	КонецЕсли;
	
	параметрыЖурнала = Новый Структура("ГруппаСобытий, Метаданные, Данные");
	параметрыЖурнала.ГруппаСобытий = НСтр("ru = 'Формирование сегмента. Запуск по расписанию'");
	параметрыЖурнала.Метаданные    = сегмент.Метаданные();
	параметрыЖурнала.Данные        = сегмент;
	
	ЗаписьЖурнала(параметрыЖурнала, УровеньЖурналаРегистрации.Примечание, , НСтр("ru = 'Запуск'"));
	
	реквизитыСегмента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		сегмент,
		"ПометкаУдаления, СпособФормирования, Наименование ");
	
	// Проверки
	Если реквизитыСегмента.ПометкаУдаления Тогда
		ЗаписьЖурнала(параметрыЖурнала, , ,
			НСтр("ru = 'Завершение'"), НСтр("ru = 'Сегмент помечен на удаление'"));
		Возврат;
	ИначеЕсли реквизитыСегмента.СпособФормирования <> Перечисления.СпособыФормированияСегментов.ПериодическиОбновлять Тогда
		ЗаписьЖурнала(параметрыЖурнала, , ,
			НСтр("ru = 'Завершение'"), НСтр("ru = 'Сегмент не периодически обновляемый'"));
		Возврат;
	КонецЕсли;
	
	Попытка
		СегментыВызовСервера.Сформировать(сегмент);
	Исключение
		ЗаписьЖурнала(параметрыЖурнала, , ,
			НСтр("ru = 'Ошибка формирования сегмента %1'"), ИнформацияОбОшибке(), 
			"'"+ реквизитыСегмента.Наименование +"'");
	КонецПопытки;
	
	ЗаписьЖурнала(параметрыЖурнала, УровеньЖурналаРегистрации.Примечание, ,НСтр("ru = 'Завершение'"));
	
КонецПроцедуры	// ВыполнитьПериодическоеФормирование()

// Создает запись в журнале регистрации и сообщениях пользователю, 
//  Поддерживает до 4х параметров в комментарии при помощи функции 
//    СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку
//  Поддерживает передачу информации об обшибке, подробное представление 
//    ошибки добавляется в комментарий записи в журнал регистрации
// 
// Параметры:
//   ПараметрыЖурнала (Структура) - Параметры записи в журнал регистрации
//       |- Префикс (Строка) - Префикс для имени события журнала регистрации
//       |- Метаданные (ОбъектМетаданных) - Метаданные для записи в журнал регистрации
//       |- Данные (*)       - Данные для записи в журнал регистрации
//   Уровень (Число(0..4))  - Соответствует уровням журнала регистрации
//   Подкласс (Число(0..4)) - Суффикс для имени события журнала регистрации
//   КомментарийСПараметрами (Строка) - Комментарий, возможно с параметрами %1 .. %4
//   ИнформацияОбОшибке (ИнформацияОбОшибке, Строка) - Информация об ошибке, которую так же необходимо
//                                                     задокументировать в комментарии журнала регистрации
//   Параметр1 .. Параметр4 (*) - Параметры для подстановки в комментарий
//
Процедура ЗаписьЖурнала(параметрыЖурнала, уровеньЖурнала = Неопределено, имяСобытия = "", 
		Знач комментарийСПараметрами = "", информацияОбОшибке = Неопределено, 
		параметр1 = Неопределено, 
		параметр2 = Неопределено, 
		параметр3 = Неопределено, 
		параметр4 = Неопределено
	) Экспорт
	
	// Определение уровня журнала регистрации на основе типа переданного сообщения об ошибке
	Если ТипЗнч(уровеньЖурнала) <> Тип("УровеньЖурналаРегистрации") Тогда
		Если ТипЗнч(информацияОбОшибке) = Тип("Строка") Тогда
			уровеньЖурнала = УровеньЖурналаРегистрации.Предупреждение;
		ИначеЕсли ТипЗнч(ИнформацияОбОшибке) = Тип("ИнформацияОбОшибке") Тогда
			уровеньЖурнала = УровеньЖурналаРегистрации.Ошибка;
		Иначе
			уровеньЖурнала = УровеньЖурналаРегистрации.Информация;
		КонецЕсли;
	КонецЕсли;
	
	// Комментарий для журнала регистрации и пользователя
	Если параметр1 <> Неопределено Тогда
		комментарийСПараметрами = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			КомментарийСПараметрами, Параметр1, Параметр2, Параметр3, Параметр4);
	КонецЕсли;
	
	Если ТипЗнч(информацияОбОшибке) = Тип("ИнформацияОбОшибке") Тогда
		Если комментарийСПараметрами = "" Тогда
			тестСообщенияПользователю = КраткоеПредставлениеОшибки(информацияОбОшибке);
			комментарийСПараметрами = ПодробноеПредставлениеОшибки(информацияОбОшибке);
		Иначе
			тестСообщенияПользователю = комментарийСПараметрами + Символы.ПС + краткоеПредставлениеОшибки(ИнформацияОбОшибке);
			комментарийСПараметрами = комментарийСПараметрами + Символы.ПС + подробноеПредставлениеОшибки(ИнформацияОбОшибке);
		КонецЕсли;
	Иначе
		Если ТипЗнч(информацияОбОшибке) = Тип("Строка") И информацияОбОшибке <> "" Тогда
			комментарийСПараметрами = комментарийСПараметрами + Символы.ПС + информацияОбОшибке;
		КонецЕсли;
		тестСообщенияПользователю = комментарийСПараметрами;
	КонецЕсли;
	
	// Журнал регистрации 
	УстановитьПривилегированныйРежим(Истина);
	
	ЗаписьЖурналаРегистрации(
		параметрыЖурнала.ГруппаСобытий + ?(имяСобытия = "", "", ". "+ имяСобытия), 
		уровеньЖурнала, 
		параметрыЖурнала.Метаданные, 
		параметрыЖурнала.Данные, 
		комментарийСПараметрами);
		
	УстановитьПривилегированныйРежим(Ложь);
	
	Если уровеньЖурнала = УровеньЖурналаРегистрации.Ошибка ИЛИ уровеньЖурнала = УровеньЖурналаРегистрации.Предупреждение Тогда
		
		Если уровеньЖурнала = УровеньЖурналаРегистрации.Ошибка Тогда
			параметрыЖурнала.Вставить("БылиОшибки", Истина);
		Иначе
			параметрыЖурнала.Вставить("БылиПредупреждения", Истина);
		КонецЕсли;
		
		сообщение = Новый СообщениеПользователю;
		сообщение.Текст = СокрЛП(ТестСообщенияПользователю); //  + Символы.ПС + Символы.ПС + НСтр("ru = 'Подробности см. в журнале регистрации.'")
		сообщение.УстановитьДанные(ПараметрыЖурнала.Данные);
		сообщение.Сообщить();
		
	КонецЕсли;
	
КонецПроцедуры	// ЗаписьЖурнала()

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ


//Возвращает структуру, содержащую СКД сегмента и настройки варианта,
//содержащего список элементов. При этом подключаются поля запроса списка.
//
Функция ПолучитьНастройкиСписка(сегментСсылка)
	
	реквизитыСКДСегмента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		СегментСсылка,
		"СхемаКомпоновкиДанных,ХранилищеНастроекКомпоновкиДанных,ИмяШаблонаСКД");
		
	настройкиСегмента = реквизитыСКДСегмента.ХранилищеНастроекКомпоновкиДанных.Получить();
		
	Если ПустаяСтрока(реквизитыСКДСегмента.ИмяШаблонаСКД) Тогда
		
		СКД = реквизитыСКДСегмента.СхемаКомпоновкиДанных.Получить();
		
	Иначе
		
		СКД_Макета = ПолучитьОписаниеИСхемуКомпоновкиДанныхПоИмениМакета(СегментСсылка, РеквизитыСКДСегмента.ИмяШаблонаСКД);
		СКД = СКД_Макета.СхемаКомпоновкиДанных;
		
	КонецЕсли;
	
	//подключить поля запроса списка
	
	Если СКД.НаборыДанных.Найти("СписокСегмента") <> Неопределено Тогда
		
		Поля = СКД.НаборыДанных.СписокСегмента.Поля;
		Для Каждого Поле Из Поля Цикл
			Поле.ОграничениеИспользования.Поле = Ложь;
		КонецЦикла;//подключить поля запроса списка
		
		НастройкиСписка = СКД.ВариантыНастроек.Список.Настройки;
		Настройки = СКД.НастройкиПоУмолчанию;
		КомпоновкаДанныхКлиентСервер.СкопироватьЭлементы(НастройкиСписка.ПараметрыДанных, Настройки.ПараметрыДанных);
		КомпоновкаДанныхКлиентСервер.СкопироватьЭлементы(НастройкиСписка.Отбор, Настройки.Отбор);
		
	ИначеЕсли  СКД.НаборыДанных.Найти("ФормированиеСегмента") <> Неопределено Тогда
		
		Если НастройкиСегмента <> Неопределено Тогда
			
			НастройкиСписка = НастройкиСегмента;
			
		Иначе
			
			НастройкиСписка = СКД.ВариантыНастроек.ФормированиеСегмента.Настройки;
			
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
		СКД,Настройки,,,
		Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
		
	процессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	процессорКомпоновкиДанных.Инициализировать(МакетКомпоновки);
	
	процессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	
	таблицаЗначений = Новый ТаблицаЗначений;
	
	процессорВывода.УстановитьОбъект(таблицаЗначений);
	процессорВывода.Вывести(процессорКомпоновкиДанных);

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

Процедура ПолучитьРасписаниеРегламентногоЗадания(форма)
	
	форма.Расписание = Новый РасписаниеРегламентногоЗадания;
	
	Если форма.Объект.Ссылка.Пустая() Тогда
		
		форма.Расписание.ВремяНачала = '00010101220000'; // в 10:00 вечера
		форма.Расписание.ПериодПовтораДней = 1; //каждый день
		
	Иначе
		
		УстановитьПривилегированныйРежим(Истина);
		
		идентификаторЗадания = Форма.Объект.РегламентноеЗадание;
		Если ТипЗнч(идентификаторЗадания) = Тип("УникальныйИдентификатор") Тогда
			
			задание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
			
			Если задание <> Неопределено Тогда
				форма.Расписание = задание.Расписание;
				форма.РегламентноеЗаданиеИспользуется = задание.Использование;
				форма.РасписаниеСтрокой = Строка(форма.Расписание);
			КонецЕсли;
			
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры	// ПолучитьРасписаниеРегламентногоЗадания()


////////////////////////////////////////////////////////////////////////////////
// Прочие процедуры и функции.

//Возвращает флаг вхождения объекта в сегмент
//Параметры:
//ОбъектСсылка - ссылка на анализируемый объект - партнера или номенклатуру,
//СегментСсылка - ссылка на сегмент партнеров или номенклатуры,
//ХарактеристикаОбъекта - характеристика номенклатуры,
//Динамический - способ формирования сегмента - ФормироватьДинамически
Функция ВходитВСегмент(объектСсылка, сегментСсылка, характеристика = Неопределено, динамический = Истина) Экспорт
	
	Если динамический Тогда
		
		Если НЕ ПривилегированныйРежим() Тогда
			УстановитьПривилегированныйРежим(Истина);
		КонецЕсли;
		
		настройки = ПолучитьНастройкиСписка(СегментСсылка);
		
		Если настройки.СКД.НаборыДанных.Найти("ФормированиеСегмента") = Неопределено Тогда
			
			//установить отбор списка
			элементОтбора = Настройки.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			элементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЭлементСписка");
			элементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
			элементОтбора.ПравоеЗначение = ОбъектСсылка;
			элементОтбора.Использование  = Истина;
			
			Если характеристика <> Неопределено Тогда
				элементОтбора = Настройки.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
				элементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ХарактеристикаЭлемента");
				элементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
				элементОтбора.ПравоеЗначение = характеристика;
				элементОтбора.Использование  = Истина;
			КонецЕсли;
			
		Иначе
			
			поПартнеру = ТипЗнч(ОбъектСсылка) = Тип("СправочникСсылка.Контрагенты");
			
			КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(
				Настройки.Настройки, 
				Новый ПолеКомпоновкиДанных(?(ПоПартнеру,"Партнер","Номенклатура")),
				ОбъектСсылка);
			
			Если НЕ поПартнеру И характеристика <> Неопределено Тогда
				КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(
					Настройки.Настройки, 
					Новый ПолеКомпоновкиДанных("Характеристика"),
					Характеристика);
			КонецЕсли;
			
		КонецЕсли;
		
		Возврат ТаблицаСКД(Настройки.СКД, Настройки.Настройки).Количество() > 0;
		
	Иначе
		
		запрос = Новый запрос;
		
		Если	ТипЗнч(ОбъектСсылка) = Тип("СправочникСсылка.Партнеры") Тогда
			
			
			запрос.Текст = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
			|	ПартнерыСегмента.Партнер
			|ИЗ
			|	РегистрСведений.ПартнерыСегмента КАК ПартнерыСегмента
			|ГДЕ
			|	ПартнерыСегмента.Сегмент = &СегментСсылка
			|	И ПартнерыСегмента.Партнер = &ОбъектСсылка"; 
			

		//ИначеЕсли ТипЗнч(ОбъектСсылка) = Тип("СправочникСсылка.Номенклатура") Тогда
		//	
		//	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		//	               |	НоменклатураСегмента.Номенклатура
		//	               |ИЗ
		//	               |	РегистрСведений.НоменклатураСегмента КАК НоменклатураСегмента
		//	               |ГДЕ
		//	               |	НоменклатураСегмента.Сегмент = &СегментСсылка
		//	               |	И НоменклатураСегмента.Номенклатура = &ОбъектСсылка
		//	               |	И НоменклатураСегмента.Характеристика = &Характеристика";
		//	
		//	
			
		Иначе
			
			Возврат Неопределено;
			
		КонецЕсли;
		
		запрос.УстановитьПараметр("ОбъектСсылка", объектСсылка);
		запрос.УстановитьПараметр("СегментСсылка", сегментСсылка);
		запрос.УстановитьПараметр("Характеристика", характеристика);
		
		Возврат НЕ запрос.Выполнить().Пустой();
		
	КонецЕсли;
	
КонецФункции	// ВходитВСегмент()

// нач. 17.03.2017 Карпачев А.Ю. перенос из ут 11.1
Функция ПолучитьXML(Значение) Экспорт
	
	Запись = Новый ЗаписьXML();
	Запись.УстановитьСтроку();
	СериализаторXDTO.ЗаписатьXML(Запись, Значение);
	Возврат Запись.Закрыть();
	
КонецФункции
// кон. 17.03.2017 Карпачев А.Ю.

//Возвращает таблицу значений, содержащую ссылки на элементы,
//входящие в сегмент, по настройкам СКД
//
Функция СписокЭлементовСКД(СегментСсылка) Экспорт

	Настройки = ПолучитьНастройкиСписка(СегментСсылка);
	Возврат ТаблицаСКД(Настройки.СКД, Настройки.Настройки);

КонецФункции
