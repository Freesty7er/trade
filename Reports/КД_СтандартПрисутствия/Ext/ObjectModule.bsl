﻿
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Для Каждого элемент Из КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если ТипЗнч(элемент) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") И Строка(элемент.Параметр) = "ПериодОтчета" Тогда
			Если НачалоМесяца(элемент.Значение.ДатаНачала) <> НачалоМесяца(элемент.Значение.ДатаОкончания) Тогда
				Сообщить("Период отчета не может быть больше месяца.");
				Отказ = Истина;
			КонецЕсли;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
