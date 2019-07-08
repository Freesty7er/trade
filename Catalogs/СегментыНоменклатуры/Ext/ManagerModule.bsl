﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

//Возвращает имена блокруемых реквизитов для механизма блокирования реквизитов БСП
//	Возвращаемое значание:
//		Массив - имена блокируемых реквизитов
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("РегламентноеЗаданиеИспользуется; РегламентноеЗаданиеАктивно");
	Результат.Добавить("СпособФормирования");
	Результат.Добавить("ПредставлениеШаблонаСКД; Настройки");
	Результат.Добавить("Расписание; НастроитьРасписание");
	
	Возврат Результат;
	
КонецФункции

//Возвращает имена реквизитов, которые не должны отображаться в списке реквизитов обработки ГрупповоеИзменениеОбъектов
//
//	Возвращаемое значение:
//		Массив - массив имен реквизитов
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	НеРедактируемыеРеквизиты = Новый Массив;
	НеРедактируемыеРеквизиты.Добавить("ИмяШаблонаСКД");
	НеРедактируемыеРеквизиты.Добавить("РегламентноеЗадание");
	НеРедактируемыеРеквизиты.Добавить("СхемаКомпоновкиДанных");
	НеРедактируемыеРеквизиты.Добавить("ХранилищеНастроекКомпоновкиДанных");
	
	Возврат НеРедактируемыеРеквизиты;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Прочее

Функция ШаблоныСхемыКомпоновкиДанных() Экспорт
	
	Шаблоны = Новый Массив;
	
	Для каждого Макет из Метаданные.Справочники.СегментыНоменклатуры.Макеты Цикл
		
		Если Макет.ТипМакета <> Метаданные.СвойстваОбъектов.ТипМакета.СхемаКомпоновкиДанных Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		Шаблоны.Добавить(Новый Структура("Имя, Синоним", Макет.Имя, Макет.Синоним));
		
	КонецЦикла;
	
	Возврат Шаблоны;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы

Процедура ПослеЗагрузкиДанныхИзДругойМодели() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СегментыНоменклатуры.Ссылка,
	|	СегментыНоменклатуры.ИмяШаблонаСКД
	|ИЗ
	|	Справочник.СегментыНоменклатуры КАК СегментыНоменклатуры";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если ПустаяСтрока(Выборка.ИмяШаблонаСКД) Тогда
			СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
			СправочникОбъект.ХранилищеНастроекКомпоновкиДанных = Новый ХранилищеЗначения("");
			СправочникОбъект.СхемаКомпоновкиДанных = Новый ХранилищеЗначения("");
			
			СправочникОбъект.Записать();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры



#КонецЕсли