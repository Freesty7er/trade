﻿//Признак использования настроек
&НаКлиенте
Перем мИспользоватьНастройки Экспорт;

//Типы объектов, для которых может использоваться обработка.
//По умолчанию для всех.
&НаКлиенте
Перем мТипыОбрабатываемыхОбъектов Экспорт;

&НаКлиенте
Перем мНастройка;

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Выполняет обработку объектов.
//
// Параметры:
//  Объект                 - обрабатываемый объект.
//  ПорядковыйНомерОбъекта - порядковый номер обрабатываемого объекта.
//
&НаСервере
Процедура ОбработатьОбъект(Ссылка, ПорядковыйНомерОбъекта, ТекстАлгоритма)

	Объект = Ссылка.ПолучитьОбъект();
	//[begin] Added by Sergey. http://infostart.ru/profile/18346/
	//25.03.2012 21:03:04
	Если ЭтаФорма.ИспользоватьРежимЗагрузкиОбменаДанными Тогда
		Объект.ОбменДанными.Загрузка = Истина;
	КонецЕсли; 
	//[end] Added 
	//Попытка
		Выполнить(ТекстАлгоритма);
	//Исключение
	//	Сообщить(ОписаниеОшибки());
	//КонецПопытки;

КонецПроцедуры // ОбработатьОбъект()

// Выполняет обработку объектов.
//
// Параметры:
//  Нет.
//
&НаКлиенте
Функция ВыполнитьОбработку() Экспорт
	
	Индикатор = ПолучитьИндикаторПроцесса(НайденныеОбъекты.Количество());
	Для Индекс = 0 По НайденныеОбъекты.Количество() - 1 Цикл
		ОбработатьИндикатор(Индикатор, Индекс + 1);
		
		Объект = НайденныеОбъекты.Получить(Индекс).Значение;
		ОбработатьОбъект(Объект, Индекс, ТекстПроизвольногоАлгоритма);
	КонецЦикла;
	
	Если Индекс > 0 Тогда
		ОповеститьОбИзменении(Тип(ОбъектПоиска.Тип + "Ссылка." + ОбъектПоиска.Имя));
	КонецЕсли;
	
	Возврат Индекс;
КонецФункции // вВыполнитьОбработку()

//[begin] Added by Sergey. http://infostart.ru/profile/18346/
//27.03.2012 22:26:55
// Выполняет обработку объектов.
//
// Параметры:
//  Нет.
//
&НаСервере
Функция ВыполнитьОбработкуСервер() Экспорт
	
	НачатьЗафиксироватьТранзакцию(ЭтаФорма.ОбрабатыватьВТранзакции, Истина);
	Для Индекс = 0 По НайденныеОбъекты.Количество() - 1 Цикл
		Объект = НайденныеОбъекты.Получить(Индекс).Значение;
		ОбработатьОбъект(Объект, Индекс, ТекстПроизвольногоАлгоритма);
	КонецЦикла;
	НачатьЗафиксироватьТранзакцию(ЭтаФорма.ОбрабатыватьВТранзакции, Ложь);
	
	Возврат Индекс;
КонецФункции // ВыполнитьОбработкуСервер()
//[end] Added 

// Сохраняет значения реквизитов формы.
//
// Параметры:
//  Нет.
//
&НаКлиенте
Процедура СохранитьНастройку() Экспорт

	Если ПустаяСтрока(ТекущаяНастройкаПредставление) Тогда
		Предупреждение("Задайте имя новой настройки для сохранения или выберите существующую настройку для перезаписи.");
	КонецЕсли;

	НоваяНастройка = Новый Структура;
	НоваяНастройка.Вставить("Обработка", ТекущаяНастройкаПредставление);
	НоваяНастройка.Вставить("Прочее", Новый Структура);
	
	Для каждого РеквизитНастройки из мНастройка Цикл
		Выполнить("НоваяНастройка.Прочее.Вставить(Строка(РеквизитНастройки.Ключ), " + Строка(РеквизитНастройки.Ключ) + ");");
	КонецЦикла;
	
	ДоступныеОбработки = ЭтаФорма.ВладелецФормы.ДоступныеОбработки;
	ТекущаяДоступнаяНастройка = Неопределено;
	Для Каждого ТекущаяДоступнаяНастройка Из ДоступныеОбработки.ПолучитьЭлементы() Цикл
		Если ТекущаяДоступнаяНастройка.ПолучитьИдентификатор() = Родитель Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
    Если ТекущаяНастройка = Неопределено ИЛИ НЕ ТекущаяНастройка.Обработка = ТекущаяНастройкаПредставление Тогда
		Если ТекущаяДоступнаяНастройка <> Неопределено Тогда
			НоваяСтрока = ТекущаяДоступнаяНастройка.ПолучитьЭлементы().Добавить();
			НоваяСтрока.Обработка = ТекущаяНастройкаПредставление;
			НоваяСтрока.Настройка.Добавить(НоваяНастройка);
			
			ЭтаФорма.ВладелецФормы.Элементы.ДоступныеОбработки.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
	
	Если ТекущаяДоступнаяНастройка <> Неопределено И ТекущаяСтрока > -1 Тогда
		Для Каждого ТекНастройка Из ТекущаяДоступнаяНастройка.ПолучитьЭлементы() Цикл
			Если ТекНастройка.ПолучитьИдентификатор() = ТекущаяСтрока Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ТекНастройка.Настройка.Количество() = 0 Тогда
			ТекНастройка.Настройка.Добавить(НоваяНастройка);
		Иначе
			ТекНастройка.Настройка[0].Значение = НоваяНастройка;
		КонецЕсли;
	КонецЕсли;
	
	ТекущаяНастройка = НоваяНастройка;
	ЭтаФорма.Модифицированность = Ложь;
КонецПроцедуры // вСохранитьНастройку()

// Восстанавливает сохраненные значения реквизитов формы.
//
// Параметры:
//  Нет.
//
&НаКлиенте
Процедура ЗагрузитьНастройку() Экспорт

	Если Элементы.ТекущаяНастройка.СписокВыбора.Количество() = 0 Тогда
		УстановитьИмяНастройки("Новая настройка");
	Иначе
		Если НЕ ТекущаяНастройка.Прочее = Неопределено Тогда
			мНастройка = ТекущаяНастройка.Прочее;
		КонецЕсли;
	КонецЕсли;

	Для каждого РеквизитНастройки из мНастройка Цикл
		Значение = мНастройка[РеквизитНастройки.Ключ];
		Выполнить(Строка(РеквизитНастройки.Ключ) + " = Значение;");
	КонецЦикла;

КонецПроцедуры //вЗагрузитьНастройку()

// Устанавливает значение реквизита "ТекущаяНастройка" по имени настройки или произвольно.
//
// Параметры:
//  ИмяНастройки   - произвольное имя настройки, которое необходимо установить.
//
&НаКлиенте
Процедура УстановитьИмяНастройки(ИмяНастройки = "") Экспорт

	Если ПустаяСтрока(ИмяНастройки) Тогда
		Если ТекущаяНастройка = Неопределено Тогда
			ТекущаяНастройкаПредставление = "";
		Иначе
			ТекущаяНастройкаПредставление = ТекущаяНастройка.Обработка;
		КонецЕсли;
	Иначе
		ТекущаяНастройкаПредставление = ИмяНастройки;
	КонецЕсли;

КонецПроцедуры // вУстановитьИмяНастройки()

// Получает структуру для индикации прогресса цикла.
//
// Параметры:
//  КоличествоПроходов – Число - максимальное значение счетчика;
//  ПредставлениеПроцесса – Строка, "Выполнено" – отображаемое название процесса;
//  ВнутреннийСчетчик - Булево, *Истина - использовать внутренний счетчик с начальным значением 1,
//                    иначе нужно будет передавать значение счетчика при каждом вызове обновления индикатора;
//  КоличествоОбновлений - Число, *100 - всего количество обновлений индикатора;
//  ЛиВыводитьВремя - Булево, *Истина - выводить приблизительное время до окончания процесса;
//  РазрешитьПрерывание - Булево, *Истина - разрешает пользователю прерывать процесс.
//
// Возвращаемое значение:
//  Структура - которую потом нужно будет передавать в метод ЛксОбработатьИндикатор.
//
&НаКлиенте
Функция ПолучитьИндикаторПроцесса(КоличествоПроходов, ПредставлениеПроцесса = "Выполнено", ВнутреннийСчетчик = Истина,
	КоличествоОбновлений = 100, ЛиВыводитьВремя = Истина, РазрешитьПрерывание = Истина) Экспорт 
	
	Индикатор = Новый Структура;
	Индикатор.Вставить("КоличествоПроходов", КоличествоПроходов);
	Индикатор.Вставить("ДатаНачалаПроцесса", ТекущаяДата());
	Индикатор.Вставить("ПредставлениеПроцесса", ПредставлениеПроцесса);
	Индикатор.Вставить("ЛиВыводитьВремя", ЛиВыводитьВремя);
	Индикатор.Вставить("РазрешитьПрерывание", РазрешитьПрерывание);
	Индикатор.Вставить("ВнутреннийСчетчик", ВнутреннийСчетчик);
	Индикатор.Вставить("Шаг", КоличествоПроходов / КоличествоОбновлений);
	Индикатор.Вставить("СледующийСчетчик", 0);
	Индикатор.Вставить("Счетчик", 0);
	Возврат Индикатор;
	
КонецФункции // ЛксПолучитьИндикаторПроцесса()

// Проверяет и обновляет индикатор. Нужно вызывать на каждом проходе индицируемого цикла.
//
// Параметры:
//  Индикатор    – Структура – индикатора, полученная методом ЛксПолучитьИндикаторПроцесса;
//  Счетчик      – Число – внешний счетчик цикла, используется при ВнутреннийСчетчик = Ложь.
//
&НаКлиенте
Процедура ОбработатьИндикатор(Индикатор, Счетчик = 0) Экспорт 
	
	Если Индикатор.ВнутреннийСчетчик Тогда
		Индикатор.Счетчик = Индикатор.Счетчик + 1;
		Счетчик = Индикатор.Счетчик;
	КонецЕсли;
	Если Индикатор.РазрешитьПрерывание Тогда
		ОбработкаПрерыванияПользователя();
	КонецЕсли;
	
	Если Счетчик > Индикатор.СледующийСчетчик Тогда
		Индикатор.СледующийСчетчик = Цел(Счетчик + Индикатор.Шаг);
		Если Индикатор.ЛиВыводитьВремя Тогда
			ПрошлоВремени = ТекущаяДата() - Индикатор.ДатаНачалаПроцесса;
			Осталось = ПрошлоВремени * (Индикатор.КоличествоПроходов / Счетчик - 1);
			Часов = Цел(Осталось / 3600);
			Осталось = Осталось - (Часов * 3600);
			Минут = Цел(Осталось / 60);
			Секунд = Цел(Цел(Осталось - (Минут * 60)));
			ОсталосьВремени = Формат(Часов, "ЧЦ=2; ЧН=00; ЧВН=") + ":" 
			+ Формат(Минут, "ЧЦ=2; ЧН=00; ЧВН=") + ":" 
			+ Формат(Секунд, "ЧЦ=2; ЧН=00; ЧВН=");
			ТекстОсталось = "Осталось: ~" + ОсталосьВремени;
		Иначе
			ТекстОсталось = "";
		КонецЕсли;
		
		Если Индикатор.КоличествоПроходов > 0 Тогда
			ТекстСостояния = ТекстОсталось;
		Иначе
			ТекстСостояния = "";
		КонецЕсли;
		
		Состояние(Индикатор.ПредставлениеПроцесса, Счетчик / Индикатор.КоличествоПроходов * 100, ТекстСостояния);
	КонецЕсли;
	
	Если Счетчик = Индикатор.КоличествоПроходов Тогда
		Состояние(Индикатор.ПредставлениеПроцесса, 100, ТекстСостояния);
	КонецЕсли;
	
КонецПроцедуры // ЛксОбработатьИндикатор()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если мИспользоватьНастройки Тогда
		УстановитьИмяНастройки();
		ЗагрузитьНастройку();
	Иначе
		Элементы.ТекущаяНастройка.Доступность = Ложь;
		Элементы.СохранитьНастройки.Доступность = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Настройка") Тогда
		ТекущаяНастройка = Параметры.Настройка;
	КонецЕсли;
	Если Параметры.Свойство("НайденныеОбъекты") Тогда
		НайденныеОбъекты.ЗагрузитьЗначения(Параметры.НайденныеОбъекты);
	КонецЕсли;
	ТекущаяСтрока = -1;
	Если Параметры.Свойство("ТекущаяСтрока") Тогда
		Если Параметры.ТекущаяСтрока <> Неопределено Тогда
			ТекущаяСтрока = Параметры.ТекущаяСтрока;
		КонецЕсли;
	КонецЕсли;
	Если Параметры.Свойство("Родитель") Тогда
		Родитель = Параметры.Родитель;
	КонецЕсли;
	Если Параметры.Свойство("ОбъектПоиска") Тогда
		ОбъектПоиска = Параметры.ОбъектПоиска;
	КонецЕсли;
	
	//[begin] Added by Sergey. http://infostart.ru/profile/18346/
	//25.03.2012 21:01:51
	ДобавляемыеРеквизиты = Новый Массив();
	Реквизит = Новый РеквизитФормы("ОбрабатыватьВТранзакции", Новый ОписаниеТипов("Булево"), , , Истина);
	ДобавляемыеРеквизиты.Добавить(Реквизит);
	Реквизит = Новый РеквизитФормы("ИспользоватьРежимЗагрузкиОбменаДанными", Новый ОписаниеТипов("Булево"), , , Истина);
	ДобавляемыеРеквизиты.Добавить(Реквизит);
	ЭтаФорма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	
	Если Параметры.Свойство("ОбрабатыватьВТранзакции") Тогда
		ЭтаФорма.ОбрабатыватьВТранзакции = Параметры.ОбрабатыватьВТранзакции;
	КонецЕсли;
	Если Параметры.Свойство("ИспользоватьРежимЗагрузкиОбменаДанными") Тогда
		ЭтаФорма.ИспользоватьРежимЗагрузкиОбменаДанными = Параметры.ИспользоватьРежимЗагрузкиОбменаДанными;
	КонецЕсли;
	//[end] Added 
	
	Элементы.ТекущаяНастройка.СписокВыбора.Очистить();
	Если Параметры.Свойство("Настройки") Тогда
		Для Каждого Строка из Параметры.Настройки Цикл
			Элементы.ТекущаяНастройка.СписокВыбора.Добавить(Строка, Строка.Обработка);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

//[begin] Added by Sergey. http://infostart.ru/profile/18346/
//25.03.2012 21:02:14
&НаСервереБезКонтекста
Процедура НачатьЗафиксироватьТранзакцию(ОбрабатыватьВТранзакции, НачалоТранзакции = Ложь)  
	
	Если ОбрабатыватьВТранзакции Тогда
		Если НачалоТранзакции Тогда
			НачатьТранзакцию();
		Иначе                  
			ЗафиксироватьТранзакцию();
		КонецЕсли;  //  
	КонецЕсли; 
	
КонецПроцедуры //НачатьЗафиксироватьТранзакцию
//[end] Added 

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ, ВЫЗЫВАЕМЫЕ ИЗ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ВыполнитьОбработкуКоманда(Команда)
	
	Если ЗначениеЗаполнено(ТекстПроизвольногоАлгоритма) Тогда
		//[begin] Added by Sergey. http://infostart.ru/profile/18346/
		//25.03.2012 21:02:35
		Если ЭтаФорма.ОбрабатыватьВТранзакции Тогда
			ОбработаноОбъектов = ВыполнитьОбработкуСервер();
		Иначе                  
			ОбработаноОбъектов = ВыполнитьОбработку();
		КонецЕсли;  //  
		//[end] Added 

		Предупреждение("Обработка <" + СокрЛП(ЭтаФорма.Заголовок) + "> завершена!
					   |Обработано объектов: " + ОбработаноОбъектов + ".");
	Иначе
		Предупреждение(НСтр("ru = 'Не указан текст произвольного алгоритма!'"));
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройкиКоманда(Команда)
	СохранитьНастройку();
КонецПроцедуры

&НаКлиенте
Процедура ТекущаяНастройкаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;

	Если НЕ ТекущаяНастройка = ВыбранноеЗначение Тогда

		Если ЭтаФорма.Модифицированность Тогда
			Если Вопрос("Сохранить текущую настройку?", РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да) = КодВозвратаДиалога.Да Тогда
				СохранитьНастройку();
			КонецЕсли;
		КонецЕсли;

		ТекущаяНастройка = ВыбранноеЗначение;
		УстановитьИмяНастройки();

		ЗагрузитьНастройку();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТекстПроизвольногоАлгоритмаПриИзменении(Элемент)
	ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ТекущаяНастройкаПриИзменении(Элемент)
	ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ИНИЦИАЛИЗАЦИЯ МОДУЛЬНЫХ ПЕРЕМЕННЫХ

мИспользоватьНастройки = Истина;

//Реквизиты настройки и значения по умолчанию.
мНастройка = Новый Структура("ТекстПроизвольногоАлгоритма");

мТипыОбрабатываемыхОбъектов = Неопределено;