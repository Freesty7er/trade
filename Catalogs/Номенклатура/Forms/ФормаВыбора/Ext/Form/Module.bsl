﻿
&НаКлиенте
Процедура ЗапасыИерархияПриСменеТекущегоРодителя(Элемент)
	
	Если ТолькоЧтоОткрыт Тогда
		ТолькоЧтоОткрыт = Ложь;
	Иначе
		Группа = Элемент.ТекущийРодитель;
		ОбновитьСписокНоменклатуры();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗапасыИерархияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Группа = ВыбранноеЗначение;
	ОбновитьСписокНоменклатуры();

КонецПроцедуры

&НаКлиенте
Процедура ЗапасыИерархияВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Группа = Значение;
	ОбновитьСписокНоменклатуры();

КонецПроцедуры

&НаКлиенте
Процедура ЗапасыИерархияПередРазворачиванием(Элемент, Строка, Отказ)
	
	Если ТолькоЧтоОткрыт Тогда
		ТолькоЧтоОткрыт = Ложь;
	Иначе
		Группа = Строка;
		ОбновитьСписокНоменклатуры();
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ЗапасыИерархияПередСворачиванием(Элемент, Строка, Отказ)
	
	Группа = Строка;
	ОбновитьСписокНоменклатуры();

КонецПроцедуры

&НаКлиенте
Процедура ЗапасыИерархияПриАктивизацииСтроки(Элемент)
	
	СтандартнаяОбработка = Ложь;
	Группа = Элемент.ТекущаяСтрока;
	ОбновитьСписокНоменклатуры();

КонецПроцедуры


&НаКлиенте
// Процедура обновляет дерево номенклатуры.
//
Процедура ОбновитьСписокНоменклатуры()
		
	//СписокЗапасов.Параметры.УстановитьЗначениеПараметра("СтруктурнаяЕдиница", Склад);
	Список.Параметры.УстановитьЗначениеПараметра("Группа", Группа);
	Список.Параметры.УстановитьЗначениеПараметра("ОтборПоГруппе", ОтборПоГруппе);
	
	Элементы.Список.ТекущаяСтрока = ТекущаяСтрока;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОтборПоГруппе = Истина;
	ТолькоЧтоОткрыт = Истина;
	Группа = Справочники.Номенклатура.ПустаяСсылка();

	ТекущаяСтрока = Параметры.ТекущаяСтрока;

КонецПроцедуры
