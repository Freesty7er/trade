﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Константы.кпкРежимТоргТочек.Получить() = 1 Тогда
		Элементы.кпкТорговаяТочка.Видимость = Истина;
	Иначе
		Элементы.кпкТорговаяТочка.Видимость = Ложь;
	КонецЕсли; 
	
КонецПроцедуры
