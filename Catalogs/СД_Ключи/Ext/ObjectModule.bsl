﻿
#Область ОбработчикиСобытий

Процедура ПередЗаписью(отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Наименование = СтрШаблон("%1 / %2 / %3", ВидДокумента, Подразделение, Контрагент);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(данныеЗаполнения, текстЗаполнения, стандартнаяОбработка)
	
	Если ПустаяСтрока(Наименование) Тогда
		Наименование = "<авто>";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти