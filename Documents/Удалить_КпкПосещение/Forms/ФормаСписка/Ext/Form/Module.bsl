﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Константы.кпкРежимТоргТочек.Получить() = 1 Тогда
		Элементы.ТорговаяТочка.Видимость = Истина;
	Иначе
		Элементы.ТорговаяТочка.Видимость = Ложь;
	КонецЕсли; 
	
КонецПроцедуры
