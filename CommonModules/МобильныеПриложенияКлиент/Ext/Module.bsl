﻿// Выполняет подключение внешней компоненты MAppDataExch для обмена данными с мобильными приложениями
//
Процедура ПодключитьВнешнююКомпонентуДляОбменаДаннымиСМобильнымиПриложениями() Экспорт

	КомпонентаПодключена = ПодключитьВнешнююКомпоненту("ОбщийМакет.КомпонентаОбменДаннымиСМобильнымиПриложениями", "ОбменДаннымиСМобильнымиПриложениями");
	Сообщение = ?(КомпонентаПодключена, НСтр("ru='компонента подключена'"), НСтр("ru='при подключении возникли ошибки. Возможно, компонента не установлена.'"));
	Картинка = ?(КомпонентаПодключена, БиблиотекаКартинок.Информация32, БиблиотекаКартинок.Ошибка32);
	
	Если КомпонентаПодключена Тогда
		Попытка
			глКомпонентаОбменаСМобильнымиПриложениями = Новый ("AddIn.ОбменДаннымиСМобильнымиПриложениями.MAppDataExchange");
			МобильныеПриложенияКлиент.УстановитьНастройкиПользователяПриРаботеСКомпонентойОбменаДанными();
		Исключение
			глКомпонентаОбменаСМобильнымиПриложениями = Неопределено;
			Сообщение = НСтр("ru='при подключении возникли ошибки.'");
			Картинка = БиблиотекаКартинок.Ошибка32;
		КонецПопытки;
	КонецЕсли;
	
	ЗаголовокСообщения = НСтр("ru='Подключение компоненты:'");
	ПоказатьОповещениеПользователя(ЗаголовокСообщения,,Сообщение, Картинка);

КонецПроцедуры

// Выполняет обработку внешнего события, полученного от мобильного приложения
//
// Параметры:
//  Источник - Строка, описывающая источник
//  Событие - Строка, идентифицирующая конкретное событие
//..Данные - Данные - данные, полученные в рамках события
//
Процедура ОбработатьВнешнееСобытиеОтМобильногоПриложения(Источник, Событие, Данные) Экспорт
	
	СтруктураИсточникаСобытия = ПолучитьСтруктуруИсточникаСобытия(Источник);
	
	КодМобильногоКомпьютера = СтруктураИсточникаСобытия.КодМобильногоКомпьютера;
	ИдентификаторМобильнойБазы = СтруктураИсточникаСобытия.ИдентификаторМобильнойБазы;
	ИмяПользователя = СтруктураИсточникаСобытия.ИмяПользователя;
	ПарольПользователя = СтруктураИсточникаСобытия.ПарольПользователя;
	
	ПараметрыОбменаДанными = Данные;
	
	// Сначала проверяется, определены ли настройки для указанного устройства и пользователя
	Если НЕ МобильныеПриложения.АутентификацияВыполнена(ИмяПользователя, КодМобильногоКомпьютера, ПарольПользователя) Тогда
		ТекстСообщения = НСтр("ru='Для пользователя не определены настройки в системе'");
		Попытка
			глКомпонентаОбменаСМобильнымиПриложениями.СообщитьКлиентуОбОшибке(КодМобильногоКомпьютера, ТекстСообщения);
			Возврат;
		Исключение
			ИмяСобытия = НСтр("ru='Ошибка при вызове метода компоненты обмена данными'");
			ОбщегоНазначенияКлиент.ДобавитьСообщениеДляЖурналаРегистрации(ИмяСобытия,"Ошибка",ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			Возврат;
		КонецПопытки;
	КонецЕсли;
	
	Если Событие = "ПолучитьПриложение" Тогда
		
		ПриложениеСтрокой = МобильныеПриложения.ПолучитьПриложение(ИмяПользователя, КодМобильногоКомпьютера, ПараметрыОбменаДанными);
		Попытка
			глКомпонентаОбменаСМобильнымиПриложениями.УстановитьПриложение(КодМобильногоКомпьютера, ПриложениеСтрокой);
		Исключение
			ИмяСобытия = НСтр("ru='Ошибка при вызове метода компоненты обмена данными'");
			ОбщегоНазначенияКлиент.ДобавитьСообщениеДляЖурналаРегистрации(ИмяСобытия,"Ошибка",ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			Возврат;
		КонецПопытки;
			
	ИначеЕсли Событие = "ПолучитьДанные" Тогда
		
		Попытка
			НачальнаяИнициализацияИБ = глКомпонентаОбменаСМобильнымиПриложениями.ПолучитьРежимНачальнойИнициализации(КодМобильногоКомпьютера);
		Исключение
			ИмяСобытия = НСтр("ru='Ошибка при вызове метода компоненты обмена данными'");
			ОбщегоНазначенияКлиент.ДобавитьСообщениеДляЖурналаРегистрации(ИмяСобытия,"Ошибка",ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			Возврат;
		КонецПопытки;
		
		ДанныеДляОбмена = МобильныеПриложения.ПолучитьДанные(ИмяПользователя, КодМобильногоКомпьютера, НачальнаяИнициализацияИБ, ПараметрыОбменаДанными);
		
		Попытка
			глКомпонентаОбменаСМобильнымиПриложениями.ПередатьДанныеКлиенту(КодМобильногоКомпьютера, ДанныеДляОбмена);
		Исключение
			ИмяСобытия = НСтр("ru='Ошибка при вызове метода компоненты обмена данными'");
			ОбщегоНазначенияКлиент.ДобавитьСообщениеДляЖурналаРегистрации(ИмяСобытия,"Ошибка",ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			Возврат;
		КонецПопытки;
		
	ИначеЕсли Событие = "ЗаписатьДанные" Тогда
		
		Попытка
			ДанныеМобильногоПриложения = глКомпонентаОбменаСМобильнымиПриложениями.ПолучитьДанныеКлиента(КодМобильногоКомпьютера);
		Исключение
			ИмяСобытия = НСтр("ru='Ошибка при вызове метода компоненты обмена данными'");
			ОбщегоНазначенияКлиент.ДобавитьСообщениеДляЖурналаРегистрации(ИмяСобытия,"Ошибка",ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			Возврат;
		КонецПопытки;
		
		Попытка
			МобильныеПриложения.ЗаписатьДанные(ИмяПользователя, КодМобильногоКомпьютера, ДанныеМобильногоПриложения, ПараметрыОбменаДанными);
		Исключение
			ТекстСообщения = ИнформацияОбОшибке().Описание;
			Попытка
				глКомпонентаОбменаСМобильнымиПриложениями.СообщитьКлиентуОбОшибке(КодМобильногоКомпьютера, ТекстСообщения);
				Возврат;
			Исключение
				ИмяСобытия = НСтр("ru='Ошибка при вызове метода компоненты обмена данными'");
				ОбщегоНазначенияКлиент.ДобавитьСообщениеДляЖурналаРегистрации(ИмяСобытия,"Ошибка",ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));			
				Возврат;
			КонецПопытки;
			ИмяСобытия = НСтр("ru='Ошибка при записи данных, полученных от мобильного приложения'");
			ОбщегоНазначенияКлиент.ДобавитьСообщениеДляЖурналаРегистрации(ИмяСобытия,"Ошибка",ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
	ИначеЕсли Событие = "ПодтвердитьЗавершениеСеанса" Тогда
		
		Попытка
			МобильныеПриложения.ЗарегистрироватьПолучениеДанных(ИмяПользователя, КодМобильногоКомпьютера, ПараметрыОбменаДанными);
		Исключение
			ИмяСобытия = НСтр("ru='Ошибка при регистрации получения данных от мобильного приложения'");
			ОбщегоНазначенияКлиент.ДобавитьСообщениеДляЖурналаРегистрации(ИмяСобытия,"Ошибка",ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			Возврат;
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

// Формирует и возвращает структуру, содержащую информацию об инициаторе обмена
//
// Параметры:
//  Источник - строка с разделителями, содержащая информацию об источнике
//
// Возвращаемое значение:
//  Структура, содержащая информацию об инициаторе обмена
//
Функция ПолучитьСтруктуруИсточникаСобытия(Источник)
	
	СтруктураИсточника = Новый Структура();
	СтруктураИсточника.Вставить("КодМобильногоКомпьютера", СтрЗаменить(СтрПолучитьСтроку(Источник,2), Символы.ПС, ""));
	СтруктураИсточника.Вставить("ИдентификаторМобильнойБазы", СтрЗаменить(СтрПолучитьСтроку(Источник,3), Символы.ПС, ""));
	СтруктураИсточника.Вставить("ИмяПользователя", СтрЗаменить(СтрПолучитьСтроку(Источник,4), Символы.ПС, ""));
	СтруктураИсточника.Вставить("ПарольПользователя", СтрЗаменить(СтрПолучитьСтроку(Источник,5), Символы.ПС, ""));
		
	Возврат СтруктураИсточника;
	
КонецФункции

// Выполняет необходимые действия, связанные с мобильными приложениями, при старте системы
//
Процедура ПриНачалеРаботыСистемы() Экспорт
	
	Если МобильныеПриложения.ПодключатьКомпонентуОбменаДаннымиПриСтартеСистемы() Тогда
		МобильныеПриложенияКлиент.ПодключитьВнешнююКомпонентуДляОбменаДаннымиСМобильнымиПриложениями();
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает компоненте обмена данными настройки, определенные для текущего пользователя
//
Процедура УстановитьНастройкиПользователяПриРаботеСКомпонентойОбменаДанными() Экспорт
	
	СписокНастроек = МобильныеПриложения.ПолучитьНастройкиРаботыПользователяСКомпонентойОбменаДанными();
	
	ИспользоватьTCPIP = Ложь;
	ИспользоватьIRDA = Ложь;
	ИспользоватьCOMПорт = Ложь;
	
	ПортTCPIP = 2002;
	ИмяСервисаIRDA = "S1C8";
	COMПорт = 1;
	
	ВестиЖурналСобытий = Ложь;
	КаталогЖурналаСобытий = "";
	
	Для Каждого Настройка из СписокНастроек Цикл
		Если Настройка.Представление = "ИспользоватьTCPIP" Тогда
			ИспользоватьTCPIP = Настройка.Значение;
		ИначеЕсли Настройка.Представление = "ИспользоватьIRDA" Тогда
			ИспользоватьIRDA = Настройка.Значение;
		ИначеЕсли Настройка.Представление = "ИспользоватьCOMПорт" Тогда
			ИспользоватьCOMПорт = Настройка.Значение;
		ИначеЕсли Настройка.Представление = "ПортTCPIP" Тогда
			ПортTCPIP = Настройка.Значение;
		ИначеЕсли Настройка.Представление = "ИмяСервисаIRDA" Тогда
			ИмяСервисаIRDA = Настройка.Значение;
		ИначеЕсли Настройка.Представление = "COMПорт" Тогда
			COMПорт = Настройка.Значение;
		ИначеЕсли Настройка.Представление = "ВестиЖурналСобытий" Тогда
			ВестиЖурналСобытий = Настройка.Значение;
		ИначеЕсли Настройка.Представление = "КаталогЖурналаСобытий" Тогда
			КаталогЖурналаСобытий = Настройка.Значение;
		КонецЕсли;
	КонецЦикла;
	
	Если ИспользоватьTCPIP Тогда
		глКомпонентаОбменаСМобильнымиПриложениями.ПодключитьTCPIP(ПортTCPIP);
	КонецЕсли;
	
	Если ИспользоватьIRDA Тогда
		глКомпонентаОбменаСМобильнымиПриложениями.ПодключитьIRDA(ИмяСервисаIRDA);
	КонецЕсли;
	
	Если ИспользоватьCOMПорт Тогда
		глКомпонентаОбменаСМобильнымиПриложениями.ПодключитьCOMПорт(COMПорт);
	КонецЕсли;
	
	Если ВестиЖурналСобытий Тогда
		глКомпонентаОбменаСМобильнымиПриложениями.КаталогЖурналаСобытий = КаталогЖурналаСобытий;
		глКомпонентаОбменаСМобильнымиПриложениями.ВестиЖурналСобытий = ВестиЖурналСобытий;
	КонецЕсли;
	
КонецПроцедуры