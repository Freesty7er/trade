﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("ДанныеЛога") Тогда
		Для Каждого ЭлементЛога Из Параметры.ДанныеЛога Цикл
			Если ЭлементЛога.Ключ = "Данные" Тогда
				Для Каждого ЭлементДанных Из ЭлементЛога.Значение Цикл
					НоваяСтрока = Данные.Добавить();
					НоваяСтрока.Имя = ЭлементДанных.Ключ;
					НоваяСтрока.Значение = ЭлементДанных.Значение;
				КонецЦикла;
			Иначе
				НоваяСтрока = Лог.Добавить();
				НоваяСтрока.Имя = ЭлементЛога.Ключ;
				НоваяСтрока.Значение = ЭлементЛога.Значение;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры
