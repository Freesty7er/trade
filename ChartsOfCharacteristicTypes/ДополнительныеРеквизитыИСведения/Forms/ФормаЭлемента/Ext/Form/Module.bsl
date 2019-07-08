﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Обработчик подсистемы запрета редактирования реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	ОбновитьСоставЭлементовФормы();
	
	ЕдинственноеЧислоПредмета = СтрПолучитьСтроку(Объект.СклоненияПредмета, 1);
	МножественноеЧислоПредмета = СтрПолучитьСтроку(Объект.СклоненияПредмета, 2);
	
	ОткрываетсяИзНабораСвойств = Параметры.ОткрываетсяИзНабораСвойств;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если Параметры.ОткрываетсяИзНабораСвойств Тогда
			Если ЗначениеЗаполнено(Параметры.Копируемый) Тогда
				Объект.Наименование              = Параметры.Копируемый.Наименование;
				Объект.Родитель                  = Параметры.Копируемый.Родитель;
				Объект.ЭтоДополнительноеСведение = Параметры.Копируемый.ЭтоДополнительноеСведение;
			Иначе
				Если ЗначениеЗаполнено(Параметры.Родитель) Тогда
					Объект.Родитель = ?(Параметры.Родитель.ЭтоГруппа, Параметры.Родитель, Параметры.Родитель.Родитель);
				КонецЕсли;
				Объект.ЭтоДополнительноеСведение = Параметры.ЭтоДополнительноеСведение;
			КонецЕсли;
			Элементы.ЭтоДополнительноеСведениеРеквизит.Доступность = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	ЭтоДополнительноеСведениеРеквизит = ?(Объект.ЭтоДополнительноеСведение, 1, 0);
	
	Заголовок = ПолучитьЗаголовок(Объект.Ссылка, Объект.ЭтоДополнительноеСведение);
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
	
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДополнительныеРеквизиты.Ссылка КАК Набор,
		|	ДополнительныеРеквизиты.Ссылка.Наименование
		|ИЗ
		|	Справочник.НаборыДополнительныхРеквизитовИСведений.ДополнительныеРеквизиты КАК ДополнительныеРеквизиты
		|ГДЕ
		|	ДополнительныеРеквизиты.Свойство = &Свойство
		|	И (НЕ ДополнительныеРеквизиты.Ссылка.ЭтоГруппа)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ДополнительныеСведения.Ссылка,
		|	ДополнительныеСведения.Ссылка.Наименование
		|ИЗ
		|	Справочник.НаборыДополнительныхРеквизитовИСведений.ДополнительныеСведения КАК ДополнительныеСведения
		|ГДЕ
		|	ДополнительныеСведения.Свойство = &Свойство
		|	И (НЕ ДополнительныеСведения.Ссылка.ЭтоГруппа)");
		
		Запрос.УстановитьПараметр("Свойство", Объект.Ссылка);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			спсНаборов.Добавить(Выборка.Набор, Выборка.Наименование);
		КонецЦикла;
	
	КонецЕсли;
	
	ОбновитьНадписьОНаборах();
	
	УстановитьЗаголовокКнопкиФормата(Элементы.РедактироватьФорматЗначения, ПустаяСтрока(Объект.ФорматСвойства));
	
	Если Объект.МногострочноеПолеВвода > 0 Тогда
		МногострочноеПолеВвода = Истина;
		МногострочноеПолеВводаЧисло = Объект.МногострочноеПолеВвода;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьЗаголовок(Ссылка, ЭтоДополнительноеСведение)
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		Заголовок = Строка(Ссылка);
		Если ЭтоДополнительноеСведение Тогда
			Заголовок = Заголовок + " " + НСтр("ru = '(Дополнительное сведение)'");
		Иначе
			Заголовок = Заголовок + " " + НСтр("ru = '(Дополнительный реквизит)'");
		КонецЕсли;
	Иначе
		Если ЭтоДополнительноеСведение Тогда
			Заголовок = НСтр("ru = 'Дополнительное сведение (создание)'");
		Иначе
			Заголовок = НСтр("ru = 'Дополнительный реквизит (создание)'");
		КонецЕсли;
	КонецЕсли;
	
	Возврат Заголовок;
	
КонецФункции

&НаКлиенте
Процедура ПередЗаписью(Отказ)
	
	// Проверим, есть ли с таким же наименованием свойство
	Если ЕстьСТакимЖеНаименованием(Объект.Наименование, Объект.Ссылка) Тогда
		Если Вопрос(НСтр("ru = 'С указанным наименованием уже был введен ранее доп.реквизит/сведение.
			                   |Продолжить запись?'"),
			        РежимДиалогаВопрос.ОКОтмена) = КодВозвратаДиалога.Отмена Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Объект.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектов")) Тогда
		ТекущийОбъект.СклоненияПредмета = ЕдинственноеЧислоПредмета + Символы.ПС + МножественноеЧислоПредмета;
	Иначе
		ТекущийОбъект.СклоненияПредмета = "";
	КонецЕсли;
	
	Если (НЕ Объект.ЭтоДополнительноеСведение)
	   И
		(Объект.ТипЗначения.СодержитТип(Тип("Число"))
	 ИЛИ Объект.ТипЗначения.СодержитТип(Тип("Дата"))
	 ИЛИ Объект.ТипЗначения.СодержитТип(Тип("Булево"))
	    )Тогда
		//
	Иначе
		ТекущийОбъект.ФорматСвойства = "";
	КонецЕсли;
	
	ТекущийОбъект.МногострочноеПолеВвода = 0;
	
	Если НЕ Объект.ЭтоДополнительноеСведение И 
		Объект.ТипЗначения.СодержитТип(Тип("Строка")) И Объект.ТипЗначения.Типы().Количество() = 1 Тогда
		Если МногострочноеПолеВвода Тогда
			ТекущийОбъект.МногострочноеПолеВвода = МногострочноеПолеВводаЧисло;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект)
	
	Если ОткрываетсяИзНабораСвойств Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ДополнительныеРеквизиты.Ссылка КАК Набор,
	|	ЛОЖЬ КАК ВходитВНабор,
	|	ЛОЖЬ КАК ДополнительноеСведение
	|ИЗ
	|	Справочник.НаборыДополнительныхРеквизитовИСведений.ДополнительныеРеквизиты КАК ДополнительныеРеквизиты
	|ГДЕ
	|	((НЕ ДополнительныеРеквизиты.Ссылка В (&ВключенВНаборы))
	|			ИЛИ &ЭтоДополнительноеСведение)
	|	И (НЕ ДополнительныеРеквизиты.Ссылка.ЭтоГруппа)
	|	И ДополнительныеРеквизиты.Свойство = &Свойство
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДополнительныеСведения.Ссылка,
	|	ЛОЖЬ,
	|	ИСТИНА
	|ИЗ
	|	Справочник.НаборыДополнительныхРеквизитовИСведений.ДополнительныеСведения КАК ДополнительныеСведения
	|ГДЕ
	|	((НЕ ДополнительныеСведения.Ссылка В (&ВключенВНаборы))
	|			ИЛИ (НЕ &ЭтоДополнительноеСведение))
	|	И (НЕ ДополнительныеСведения.Ссылка.ЭтоГруппа)
	|	И ДополнительныеСведения.Свойство = &Свойство
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НаборыДополнительныхРеквизитовИСведений.Ссылка,
	|	ИСТИНА,
	|	&ЭтоДополнительноеСведение
	|ИЗ
	|	Справочник.НаборыДополнительныхРеквизитовИСведений КАК НаборыДополнительныхРеквизитовИСведений
	|ГДЕ
	|	НаборыДополнительныхРеквизитовИСведений.Ссылка В(&ВключенВНаборы)
	|	И (НЕ НаборыДополнительныхРеквизитовИСведений.ДополнительныеРеквизиты.Ссылка В
	|				(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|					ДополнительныеРеквизиты.Ссылка КАК Набор
	|				ИЗ
	|					Справочник.НаборыДополнительныхРеквизитовИСведений.ДополнительныеРеквизиты КАК ДополнительныеРеквизиты
	|				ГДЕ
	|					ДополнительныеРеквизиты.Ссылка В (&ВключенВНаборы)
	|					И (НЕ ДополнительныеРеквизиты.Ссылка.ЭтоГруппа)
	|					И ДополнительныеРеквизиты.Свойство = &Свойство
	|					И (НЕ &ЭтоДополнительноеСведение)
	|		
	|				ОБЪЕДИНИТЬ ВСЕ
	|		
	|				ВЫБРАТЬ РАЗЛИЧНЫЕ
	|					ДополнительныеСведения.Ссылка КАК Набор
	|				ИЗ
	|					Справочник.НаборыДополнительныхРеквизитовИСведений.ДополнительныеСведения КАК ДополнительныеСведения
	|				ГДЕ
	|					ДополнительныеСведения.Ссылка В (&ВключенВНаборы)
	|					И (НЕ ДополнительныеСведения.Ссылка.ЭтоГруппа)
	|					И ДополнительныеСведения.Свойство = &Свойство
	|					И &ЭтоДополнительноеСведение))");
	
	Запрос.Параметры.Вставить("Свойство", ТекущийОбъект.Ссылка);
	Запрос.Параметры.Вставить("ЭтоДополнительноеСведение", ТекущийОбъект.ЭтоДополнительноеСведение);
	Запрос.Параметры.Вставить("ВключенВНаборы", спсНаборов);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НаборСвойств = Выборка.Набор.ПолучитьОбъект();
		ЗаблокироватьДанныеДляРедактирования(Выборка.Набор);
		
		Если Выборка.ВходитВНабор Тогда
			
			Если Выборка.ДополнительноеСведение Тогда
				
				НаборСвойств.ДополнительныеСведения.Добавить().Свойство = ТекущийОбъект.Ссылка;
				
			Иначе
				
				НаборСвойств.ДополнительныеРеквизиты.Добавить().Свойство = ТекущийОбъект.Ссылка;
				
			КонецЕсли;
			
		Иначе
			
			Если Выборка.ДополнительноеСведение Тогда
				
				НаборСвойств.ДополнительныеСведения.Удалить(НаборСвойств.ДополнительныеСведения.Найти(ТекущийОбъект.Ссылка, "Свойство"));
				
			Иначе
				
				НаборСвойств.ДополнительныеРеквизиты.Удалить(НаборСвойств.ДополнительныеРеквизиты.Найти(ТекущийОбъект.Ссылка, "Свойство"));
				
			КонецЕсли;
			
		КонецЕсли;
		
		НаборСвойств.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	СтруктураОповещения = Новый Структура;
	СтруктураОповещения.Вставить("ЭтоДополнительноеСведение", Объект.ЭтоДополнительноеСведение);
	СтруктураОповещения.Вставить("Комментарий", Объект.Комментарий);
	
	Оповестить("ЗаписаноДополнительноеСвойство", СтруктураОповещения, Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// Обработчик подсистемы запрета редактирования реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	Заголовок = ПолучитьЗаголовок(Объект.Ссылка, Объект.ЭтоДополнительноеСведение);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	Если Не Объект.Ссылка.Пустая() Тогда
		Результат = ОткрытьФормуМодально("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.Форма.ФормаПоискаСсылокНаПВХ", Новый Структура("Ссылка", Объект.Ссылка));
		Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
			ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(ЭтаФорма, Результат);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РедактироватьФорматЗначения(Команда)
	
	Конструктор = Новый КонструкторФорматнойСтроки(Объект.ФорматСвойства);
	
	Конструктор.ДоступныеТипы = Объект.ТипЗначения;
	
	Если Конструктор.ОткрытьМодально() Тогда
		Объект.ФорматСвойства = Конструктор.Текст;
		УстановитьЗаголовокКнопкиФормата(Элементы.РедактироватьФорматЗначения, ПустаяСтрока(Объект.ФорматСвойства));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ОткрытьФормуРедактированияКомментария(Элемент.ТекстРедактирования, Объект.Комментарий, Модифицированность);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ЭтоДополнительноеСведениеРеквизитПриИзменении(Элемент)
	
	Объект.ЭтоДополнительноеСведение = ЭтоДополнительноеСведениеРеквизит;
	
	ОбновитьСоставЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьСписокНаборовВыполнить()
	
	ОткрытьСписокНаборов();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипЗначенияПриИзменении(Элемент)
	
	Если НЕ Объект.ТипЗначения.СодержитТип(Тип("Число"))
	   И НЕ Объект.ТипЗначения.СодержитТип(Тип("Дата"))
	   И НЕ Объект.ТипЗначения.СодержитТип(Тип("Булево")) Тогда
		Объект.ФорматСвойства = "";
		УстановитьЗаголовокКнопкиФормата(Элементы.РедактироватьФорматЗначения, Истина);
	КонецЕсли;

	Если Объект.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектов")) 
	 ИЛИ Объект.ТипЗначения.СодержитТип(Тип("Число"))
	 ИЛИ Объект.ТипЗначения.СодержитТип(Тип("Дата"))
	 ИЛИ Объект.ТипЗначения.СодержитТип(Тип("Булево"))
	 ИЛИ Объект.ТипЗначения.СодержитТип(Тип("Строка")) Тогда
		ОбновитьСоставЭлементовФормы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МногострочноеПолеВводаЧислоПриИзменении(Элемент)
	
	МногострочноеПолеВвода = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Процедура ОбновитьСоставЭлементовФормы()
	
	Если Объект.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектов")) Тогда
		Элементы.ГруппаСклонения.Видимость = Истина;
	Иначе
		Элементы.ГруппаСклонения.Видимость = Ложь;
	КонецЕсли;
	
	Если (НЕ Объект.ЭтоДополнительноеСведение)
	   И
		(Объект.ТипЗначения.СодержитТип(Тип("Число"))
	 ИЛИ Объект.ТипЗначения.СодержитТип(Тип("Дата"))
	 ИЛИ Объект.ТипЗначения.СодержитТип(Тип("Булево"))
	    )Тогда
	 
		Элементы.РедактироватьФорматЗначения.Видимость = Истина;
	Иначе
		Элементы.РедактироватьФорматЗначения.Видимость = Ложь;
	КонецЕсли;
	
	Если (НЕ Объект.ЭтоДополнительноеСведение)
		И Объект.ТипЗначения.СодержитТип(Тип("Строка"))
		И Объект.ТипЗначения.Типы().Количество() = 1 Тогда
		Элементы.ГруппаМногострочность.Видимость = Истина;
	Иначе
		Элементы.ГруппаМногострочность.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовокКнопкиФормата(КнопкаФормы, ФорматНеУстановлен)
	
	Если ФорматНеУстановлен Тогда
		КнопкаФормы.Заголовок = НСтр("ru = 'Формат по умолчанию'");
	Иначе
		КнопкаФормы.Заголовок = НСтр("ru = 'Формат установлен'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЕстьСТакимЖеНаименованием(Наименование, Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	1
	|ИЗ
	|	ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения КАК ДополнительныеРеквизитыИСведения
	|ГДЕ
	|	ДополнительныеРеквизитыИСведения.Наименование = &Наименование
	|	И ДополнительныеРеквизитыИСведения.Ссылка <> &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка",       Ссылка);
	Запрос.УстановитьПараметр("Наименование", Наименование);
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

&НаСервере
Процедура ОбновитьНадписьОНаборах()
	
	Колво = спсНаборов.Количество();
	Если Колво = 0 Тогда
		ИнформационнаяНадпись = НСтр("ru = 'Не входит ни в один набор'");
	ИначеЕсли Колво = 1 Тогда
		ИнформационнаяНадпись =
		  СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		    НСтр("ru = 'Входит в набор: %1'"), спсНаборов[0].Представление);
	Иначе
		СтрНаборы = СокрЛП(ЧислоПрописью(Колво, "НД=Ложь", "набор,набора,наборов,м,,,,,0"));
		Пока Истина Цикл
			Поз = Найти(СтрНаборы, " ");
			Если Поз = 0 Тогда
				Прервать;
			КонецЕсли;
			СтрНаборы =СокрЛП(Сред(СтрНаборы, Поз+1));
		КонецЦикла;
		
		ИнформационнаяНадпись = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		                          НСтр("ru = 'Входит в %1 %2'"), Колво, СтрНаборы );
	КонецЕсли;
	
	Элементы.РедактироватьСписокНаборов.Заголовок = ИнформационнаяНадпись;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокНаборов()
	
	Если ОткрываетсяИзНабораСвойств Тогда
		Предупреждение(НСтр("ru = 'Свойство открыто из формы набора.
		                          |Редактирование списка наборов по свойству не производится!'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура("ВыбранныеНаборы,ЭтоДополнительноеСведение", спсНаборов, Объект.ЭтоДополнительноеСведение);
	
	Результат = ОткрытьФормуМодально("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.Форма.ФормаРедактированияСпискаНаборов", ПараметрыОткрытия);
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	спсНаборов = Результат;
	ОбновитьНадписьОНаборах();
	
КонецПроцедуры

