﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если НЕ ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		Отказ = Истина;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Настройки = РегламентныеЗаданияСлужебный.ПолучитьНастройкиВыполненияРегламентныхЗаданий();
	УстановитьПривилегированныйРежим(Ложь);
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Настройки);
	
	Если НЕ Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		Элементы.АвтоматическиЗапускатьОтдельныйСеансДляВыполненияРегламентныхЗаданий.Доступность = Ложь;
	КонецЕсли;
	
	Если ПериодУведомленияОНекорректномВыполненииРегламентныхЗаданий <= 0 Тогда
		ПериодУведомленияОНекорректномВыполненииРегламентныхЗаданий = 1;
	КонецЕсли;
	
	Элементы.ЗапуститьОтдельныйСеансДляВыполненияРегламентныхЗаданий.Видимость
		= НЕ Параметры.СкрытьКомандуЗапускаОтдельногоСеанса;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	//ОбщегоНазначенияКлиент.ЗапроситьПодтверждениеЗакрытияФормы(Отказ, Модифицированность);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПериодУведомленияОНекорректномВыполненииРегламентныхЗаданийПриИзменении(Элемент)
	
	Если ПериодУведомленияОНекорректномВыполненииРегламентныхЗаданий <= 0 Тогда
		ПериодУведомленияОНекорректномВыполненииРегламентныхЗаданий = 1;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Записать(Команда)
	
	ЗаписатьИзменения();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	ЗаписатьИзменения();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьОтдельныйСеансДляВыполненияРегламентныхЗаданий(Команда)
	
	ПодключитьОбработчикОжидания(
		"ЗапуститьОтдельныйСеансДляВыполненияРегламентныхЗаданийЧерезОбработчикОжидания",
		1,
		Истина);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ЗаписатьИзменения()
	
	ЗаписатьИзмененияНаСервере();
	Модифицированность = Ложь;
	
	РегламентныеЗаданияСлужебныйКлиент.ОтключитьГлобальныйОбработчикОжидания(
		"УведомлятьОНекорректномВыполненииРегламентныхЗаданий");
	
	Если УведомлятьОНекорректномВыполненииРегламентныхЗаданий Тогда
		
		РегламентныеЗаданияСлужебныйКлиент.ПодключитьГлобальныйОбработчикОжидания(
			"УведомлятьОНекорректномВыполненииРегламентныхЗаданий",
			ПериодУведомленияОНекорректномВыполненииРегламентныхЗаданий * 60,
			Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьИзмененияНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	Настройки = РегламентныеЗаданияСлужебный.ПолучитьНастройкиВыполненияРегламентныхЗаданий();
	
	Если Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь) Тогда
		ЗаполнитьЗначенияСвойств(Настройки, ЭтаФорма);
	Иначе
		ЗаполнитьЗначенияСвойств(
			Настройки,
			ЭтаФорма,
			,
			"АвтоматическиЗапускатьОтдельныйСеансДляВыполненияРегламентныхЗаданий");
	КонецЕсли;
	
	РегламентныеЗаданияСлужебный.УстановитьНастройкиВыполненияРегламентныхЗаданий(Настройки);
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Настройки);
	
КонецПроцедуры

