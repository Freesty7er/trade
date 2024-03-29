﻿
#Область ПеременныеМодуля

Перем м_СтруктураНастроек Экспорт;	// Этой переменной присваиваются настройки, которые этот элемент справочника сохранит в требуемом виде.

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		// Обмен данными. Проверки не выполняем.
		Возврат;
	КонецЕсли; 
	
	Если Не Отказ Тогда
		
		// У элемента могут меняться различные настройки, поэтому при перезаписи необходимо заново получить имеющуюся
		// структуру настроек. Если переменной м_СтруктураНастроек не присвоено никакого значения, то присвоим ей уже
		// хранящиеся в элементе данные.
		ХранилищеНастроек = Новый ХранилищеЗначения(?(м_СтруктураНастроек = Неопределено, ПолучитьСтруктуруНастроек(), м_СтруктураНастроек), Новый СжатиеДанных(5));
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ДополнительныеПроцедурыИФункции

// Возвращает структуру настроек, хранящихся в хранилище значений.
//
// Возвращаемое значение:
//   Структура   - Структура настроек.
//
Функция ПолучитьСтруктуруНастроек() Экспорт

	СтруктураНастроек = ХранилищеНастроек.Получить();
	Возврат ?(СтруктураНастроек = Неопределено, Новый Структура, СтруктураНастроек);

КонецФункции // ПолучитьСтруктуруНастроек()

#КонецОбласти
