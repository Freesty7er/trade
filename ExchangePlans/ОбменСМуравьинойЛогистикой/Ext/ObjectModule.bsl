﻿#Область ОбработчикаСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЭтотУзел И ПустаяСтрока(Код) Тогда
		Код = "000000001";
		Наименование = "Центральный узел";
	ИначеЕсли Не Подразделение = Ссылка.Подразделение Тогда
		Код = Подразделение.Код;
		Наименование = Подразделение.Наименование;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти