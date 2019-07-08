﻿// Процедура устанавливает параметры подбора.
//
&НаСервере
Процедура УстановитьПараметрыПодбора()
	
	СписокДолгов.Параметры.УстановитьЗначениеПараметра("ОкончаниеПериода", ОкончаниеПериода);
	СписокДолгов.Параметры.УстановитьЗначениеПараметра("Контрагент", Контрагент);
	СписокДолгов.Параметры.УстановитьЗначениеПараметра("Подразделение", Подразделение);
	СписокДолгов.Параметры.УстановитьЗначениеПараметра("Безналичный", Безналичный);
	
КонецПроцедуры // УстановитьПараметрыПодбора()

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОкончаниеПериода 	= Параметры.ОкончаниеПериода;
	Контрагент 			= Параметры.Контрагент;
	Подразделение       = Параметры.Подразделение;
	
	Безналичный 		= Ложь;	
	//Если Параметры.Свойство("ДенежныйСчет") Тогда
	//	Безналичный			= Параметры.ДенежныйСчет.Безналичный;
	//КонецЕСли;
	
	УстановитьПараметрыПодбора();


КонецПроцедуры

&НаКлиенте
Процедура СписокДолговВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = ЛОЖЬ;
	
	Закрыть(КодВозвратаДиалога.OK);

КонецПроцедуры

&НаКлиенте
Процедура СписокДолговВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	// Вставить содержимое обработчика.
	структураПараметров = Новый Структура("Менеджер, КредДокумент, Долг, ОбработкаВыбораДолгов", Элемент.ТекущиеДанные.Менеджер,Элемент.ТекущиеДанные.КредитныйДокумент, Элемент.ТекущиеДанные.СуммаОстаток, Истина);
	
	ОповеститьОВыборе(структураПараметров);
	//Закрыть(СтруктураПараметров);
	
КонецПроцедуры
