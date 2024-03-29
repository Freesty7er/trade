﻿#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.КД_ПланыДолиВитрины.Записывать = Истина;
	
	запрос = Новый Запрос;
	
	#Область ТекстЗапроса
	
	запрос.Текст = 
	"ВЫБРАТЬ
	|	УстановкаПланаДолиВитриныСостав.Ссылка.Дата КАК Период,
	|	УстановкаПланаДолиВитриныСостав.Ссылка.Подразделение,
	|	УстановкаПланаДолиВитриныСостав.Ссылка.ГруппаПродукции,
	|	УстановкаПланаДолиВитриныСостав.КатегорияТТ,
	|	УстановкаПланаДолиВитриныСостав.ТорговаяТочка,
	|	УстановкаПланаДолиВитриныСостав.КоличествоSKU
	|ИЗ
	|	Документ.УстановкаПланаДолиВитрины.Состав КАК УстановкаПланаДолиВитриныСостав
	|ГДЕ
	|	УстановкаПланаДолиВитриныСостав.Ссылка = &Ссылка";
		
	#КонецОбласти 
	
	запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Движения.КД_ПланыДолиВитрины.Загрузить(запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

Процедура ПередЗаписью(отказ, режимЗаписи, режимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Подразделение.Пустая() Тогда
		
		ТекстСообщения = НСтр("ru = 'Запись невозможна без заполнения Подразделения.'");
		ПроверкаДанныхКлиентСервер.СообщитьОбОшибке(отказ, текстСообщения, ЭтотОбъект, "Подразделение");
		
	КонецЕсли;
	
	Если Не Дата = НачалоДня(Дата) Тогда
		Дата = НачалоДня(Дата);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(объектКопирования)
	
	ЗаполнениеОбъектовСервер.ЗаполнитьДанныеСкопированногоДокумента(ЭтотОбъект, объектКопирования);
	
КонецПроцедуры
	
#КонецОбласти 