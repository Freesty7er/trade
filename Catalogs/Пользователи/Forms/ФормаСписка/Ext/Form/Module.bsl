﻿
////////////////////////////////////////////////////////////////////////////////
// Обработчики событий формы
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//ИспользоватьГруппы = ПолучитьФункциональнуюОпцию("ИспользоватьГруппыПользователей");
	ИспользоватьГруппы = Истина;
	
	Если ТипЗнч(Параметры.ТекущаяСтрока) = Тип("СправочникСсылка.ГруппыПользователей") Тогда
		Если ИспользоватьГруппы Тогда
			Элементы.ГруппыПользователей.ТекущаяСтрока = Параметры.ТекущаяСтрока;
		Иначе
			Параметры.ТекущаяСтрока = Неопределено;
		КонецЕсли;
	Иначе
		ТекущийЭлемент = Элементы.ПользователиСписок;
		Элементы.ГруппыПользователей.ТекущаяСтрока = Справочники.ГруппыПользователей.ВсеПользователи;
		ОбновитьЗначениеПараметраКомпоновкиДанных(ПользователиСписок, "ГруппаПользователей", Справочники.ГруппыПользователей.ВсеПользователи);
		ОбновитьЗначениеПараметраКомпоновкиДанных(ПользователиСписок, "ВыбиратьИерархически", Истина);
	КонецЕсли;
	
	Если НЕ ИспользоватьГруппы Тогда
		Параметры.ВыборГруппПользователей = Ложь;
		Элементы.ГруппаПоказыватьПользователейДочернихГрупп.Видимость = Ложь;
		Элементы.СоздатьГруппуПользователей.Видимость = Ложь;
	КонецЕсли;
	
	// Настройка постоянных данных для списка пользователей
	ОбновитьЗначениеПараметраКомпоновкиДанных(ПользователиСписок, "ПустойУникальныйИдентификатор", Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	ГруппаПользователейВсеПользователи = Справочники.ГруппыПользователей.ВсеПользователи;
	
	Если НЕ ПравоДоступа("Добавление", Метаданные.Справочники.ГруппыПользователей) Тогда
		Элементы.СоздатьГруппуПользователей.Видимость = Ложь;
	КонецЕсли;
	Если НЕ ПравоДоступа("Добавление", Метаданные.Справочники.Пользователи) Тогда
		Элементы.СоздатьПользователя.Видимость = Ложь;
	КонецЕсли;
	
	Если Параметры.РежимВыбора Тогда
	
		Если Элементы.Найти("ПользователиИБ") <> Неопределено Тогда
			Элементы.ПользователиИБ.Видимость = Ложь;
		КонецЕсли;
		
		// Отбор не помеченных на удаление
		ПользователиСписок.Отбор.Элементы[0].Использование = Истина;
		
		Элементы.ПользователиСписок.РежимВыбора        =    Истина;
		Элементы.ГруппыПользователей.РежимВыбора       =    Параметры.ВыборГруппПользователей;
		Элементы.ВыбратьГруппуПользователей.Видимость  =    Параметры.ВыборГруппПользователей;
		Элементы.ВыбратьПользователя.КнопкаПоУмолчанию = НЕ Параметры.ВыборГруппПользователей;
		
		Если Параметры.ЗакрыватьПриВыборе = Ложь Тогда
			// Режим подбора
			Элементы.ПользователиСписок.МножественныйВыбор = Истина;
			Элементы.ПользователиСписок.РежимВыделения = РежимВыделенияТаблицы.Множественный;
			
			Если Параметры.ВыборГруппПользователей Тогда
				Заголовок                                     = НСтр("ru = 'Подбор пользователей и групп'");
				Элементы.ВыбратьПользователя.Заголовок        = НСтр("ru = 'Выбрать пользователей'");
				
				Элементы.ВыбратьГруппуПользователей.Заголовок = НСтр("ru = 'Выбрать группы'");
				
				Элементы.ГруппыПользователей.МножественныйВыбор = Истина;
				Элементы.ГруппыПользователей.РежимВыделения = РежимВыделенияТаблицы.Множественный;
			Иначе
				Заголовок                                     = НСтр("ru = 'Подбор пользователей'");
			КонецЕсли;
		Иначе
			Если Параметры.ВыборГруппПользователей Тогда
				Заголовок                                     = НСтр("ru = 'Выбор пользователя или группы'");
				Элементы.ВыбратьПользователя.Заголовок        = НСтр("ru = 'Выбрать пользователя'");
			Иначе
				Заголовок                                     = НСтр("ru = 'Выбор пользователя'");
			КонецЕсли;
		КонецЕсли;
	Иначе
		Элементы.ВыбратьПользователя.Видимость        = Ложь;
		Элементы.ВыбратьГруппуПользователей.Видимость = Ложь;
		
		#Область изменения_20180808_Карпачев_А_Ю
		Элементы.ПользователиСписок.РежимВыделения = РежимВыделенияТаблицы.Множественный;
		#КонецОбласти
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьСодержимоеФормыПриИзмененииГруппы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененСоставГруппыПользователей" Тогда
		Если Параметр = Элементы.ГруппыПользователей.ТекущаяСтрока Тогда
			Элементы.ПользователиСписок.Обновить();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если Настройки[ВыбиратьИерархически] = Неопределено Тогда
		ВыбиратьИерархически = Истина;
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// Обработчики событий команд и элементов формы
//

&НаКлиенте
Процедура СоздатьГруппуПользователей(Команда)
	
	Элементы.ГруппыПользователей.ДобавитьСтроку();
	
КонецПроцедуры


&НаКлиенте
Процедура ГруппыПользователейПриАктивизацииСтроки(Элемент)
	
	ОбновитьСодержимоеФормыПриИзмененииГруппы();
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПользователейВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОповеститьОВыборе(Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПользователейПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если НЕ Копирование Тогда
		Отказ = Истина;
		ПараметрыФормы = Новый Структура;
		
		Если ЗначениеЗаполнено(Элементы.ГруппыПользователей.ТекущаяСтрока) Тогда
			
			ПараметрыФормы.Вставить("ЗначенияЗаполнения", Новый Структура("Родитель", Элементы.ГруппыПользователей.ТекущаяСтрока));
		КонецЕсли;
		
		ОткрытьФорму("Справочник.ГруппыПользователей.ФормаОбъекта", ПараметрыФормы, Элементы.ГруппыПользователей);
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ПользователиСписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОповеститьОВыборе(Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиСписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ГруппаНовогоПользователя", Элементы.ГруппыПользователей.ТекущаяСтрока);
	
	Если Копирование И Элемент.ТекущиеДанные <> Неопределено Тогда
		ПараметрыФормы.Вставить("ЗначениеКопирования", Элемент.ТекущаяСтрока);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.Пользователи.ФормаОбъекта", ПараметрыФормы, Элементы.ПользователиСписок);
	
КонецПроцедуры


&НаКлиенте
Процедура ВыбиратьИерархическиПриИзменении(Элемент)
	
	ОбновитьСодержимоеФормыПриИзмененииГруппы();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции формы
//

&НаКлиенте
Процедура ОбновитьСодержимоеФормыПриИзмененииГруппы()
	
	Если НЕ ИспользоватьГруппы
	 ИЛИ Элементы.ГруппыПользователей.ТекущаяСтрока = ГруппаПользователейВсеПользователи Тогда
		//
		Элементы.ГруппаПоказыватьПользователейДочернихГрупп.ТекущаяСтраница = Элементы.ГруппаНельзяУстановитьСвойство;
		ОбновитьЗначениеПараметраКомпоновкиДанных(ПользователиСписок, "ВыбиратьИерархически", Истина);
		ОбновитьЗначениеПараметраКомпоновкиДанных(ПользователиСписок, "ГруппаПользователей", ГруппаПользователейВсеПользователи);
	Иначе
		Элементы.ГруппаПоказыватьПользователейДочернихГрупп.ТекущаяСтраница = Элементы.ГруппаУстановитьСвойство;
		ОбновитьЗначениеПараметраКомпоновкиДанных(ПользователиСписок, "ВыбиратьИерархически", ВыбиратьИерархически);
		ОбновитьЗначениеПараметраКомпоновкиДанных(ПользователиСписок, "ГруппаПользователей", Элементы.ГруппыПользователей.ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьЗначениеПараметраКомпоновкиДанных(Знач ВладелецПараметров, Знач ИмяПараметра, Знач ЗначениеПараметра)
	
	Для каждого Параметр Из ВладелецПараметров.Параметры.Элементы Цикл
		Если Строка(Параметр.Параметр) = ИмяПараметра Тогда
			Если Параметр.Использование И Параметр.Значение = ЗначениеПараметра Тогда
				Возврат;
			КонецЕсли;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ВладелецПараметров.Параметры.УстановитьЗначениеПараметра(ИмяПараметра, ЗначениеПараметра);
	
КонецПроцедуры

#Область изменения_20180809_Карпачев_А_Ю

&НаКлиенте
Процедура КомандаСравнитьРолиПользователей(Команда)
	
	формаСравнениеРолейДеревоПараметры = Новый Структура;
	
	параметрыСписокПользователей = Новый СписокЗначений;
	
	Для Каждого пользователь Из Элементы.ПользователиСписок.ВыделенныеСтроки Цикл
		параметрыСписокПользователей.Добавить(пользователь);
	КонецЦикла;
	
	формаСравнениеРолейДеревоПараметры.Вставить("СписокПользователей", параметрыСписокПользователей);
	
	формаСравнениеРолейДерево = ПолучитьФорму("Справочник.Пользователи.Форма.ФормаСравнениеРолейДерево", формаСравнениеРолейДеревоПараметры);
	
	Если формаСравнениеРолейДерево.Открыта() Тогда
		формаСравнениеРолейДерево.Закрыть();
	КонецЕсли;
	
	формаСравнениеРолейДерево.Открыть();
	
КонецПроцедуры

#КонецОбласти
