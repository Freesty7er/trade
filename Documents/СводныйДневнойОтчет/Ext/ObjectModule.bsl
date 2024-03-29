﻿
#Область ОбработчикиСобытий

Процедура ПриКопировании(объектКопирования)
	
	ЗаполнениеОбъектовСервер.ЗаполнитьДанныеСкопированногоДокумента(ЭтотОбъект, объектКопирования);
	
КонецПроцедуры

Процедура ОбработкаПроведения(отказ, режимПроведения)

	// Инициализация дополнительных свойств для проведения документа.
	ОбщегоНазначенияСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	ОбщегоНазначенияСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Инициализация данных документа.
	Документы.СводныйДневнойОтчет.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	
	// Отражение в разделах учета
	ОбщегоНазначенияСервер.ОтразитьДвиженияПоРегистрамНакопления(ДополнительныеСвойства, Движения, отказ);
	
КонецПроцедуры

#КонецОбласти