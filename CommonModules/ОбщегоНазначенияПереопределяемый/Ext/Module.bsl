﻿
// Функция ПолучитьИсключенияПоискаСсылок возвращает список имен объектов метаданных,
// которые могут ссылаться на различные объекты метаданных без влияния на бизнес-логику приложения,
//  Например, наличие ссылок из регистра сведений "Версии объектов" на элементы справочника "Номенклатура"
// не ограничивает удаление элементов справочника "Номенклатура".
// 
// Возвращаемое значение:
//  Массив       - массив строк, например, "РегистрСведений.ВерсииОбъектов".
//
Функция ПолучитьИсключенияПоискаСсылок() Экспорт
	
	Массив = Новый Массив;
	
	// Валюты
	//Массив.Добавить(Метаданные.РегистрыСведений.КурсыВалют.ПолноеИмя());
	// Конец Валюты

	// ВерсионированиеОбъектов
	//Массив.Добавить(Метаданные.РегистрыСведений.ВерсииОбъектов.ПолноеИмя());
	// Конец ВерсионированиеОбъектов

	// Свойства
	//Массив.Добавить(Метаданные.РегистрыСведений.ДополнительныеСведения.ПолноеИмя());
	// Конец Свойства
	
	// ФизическиеЛица
	//Массив.Добавить(Метаданные.РегистрыСведений.ДокументыФизическихЛиц.ПолноеИмя());
	// Конец ФизическиеЛица
	
	// РаботаСФайлами
	//Массив.Добавить(Метаданные.РегистрыСведений.ФайлыВРабочемКаталоге.ПолноеИмя());
	// Конец РаботаСФайлами
	
	//Массив.Добавить(Метаданные.РегистрыСведений.НастройкиТранспортаОбмена.ПолноеИмя());
	//Массив.Добавить(Метаданные.РегистрыСведений.СостояниеОбменовДанными.ПолноеИмя());
		
	Возврат Массив;
	
КонецФункции // ПолучитьИсключенияПоискаСсылок()
