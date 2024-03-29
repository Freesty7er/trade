﻿&НаСервере
Процедура УстановитьВидимостьЗакладок()
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Элементы.ПОС.Видимость = Истина;
		Элементы.Операторы.Видимость = Истина;
		
		УдалитьЭлементОтбораСписка(СписокОператоров, "Владелец");
		УстановитьЭлементОтбораСписка(СписокОператоров, "Владелец", Объект.Ссылка);
		
		УдалитьЭлементОтбораСписка(СписокПОС, "ТорговаяТочка");
		УстановитьЭлементОтбораСписка(СписокПОС, "ТорговаяТочка", Объект.Ссылка);
		
	Иначе
		// Это новый элемент
		Элементы.ПОС.Видимость = Ложь;
		Элементы.Операторы.Видимость = Ложь;
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	УстановитьВидимостьЗакладок();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьВидимостьЗакладок();
	
КонецПроцедуры

//Устанавливает элемент отбор динамического списка
//
//Параметры:
//Список			- обрабатываемый динамический список,
//ИмяПоля			- имя поля компоновки, отбор по которому нужно установить,
//ВидСравнения		- вид сравнения отбора, по умолчанию - Равно,
//ПравоеЗначение 	- значение отбора
//
Процедура УстановитьЭлементОтбораСписка(Список, ИмяПоля, ПравоеЗначение, ВидСравнения = Неопределено)
	
	ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных(ИмяПоля);
	ЭлементОтбора.ВидСравнения     = ?(ВидСравнения = Неопределено, ВидСравненияКомпоновкиДанных.Равно, ВидСравнения);
	ЭлементОтбора.Использование    = Истина;
	ЭлементОтбора.ПравоеЗначение   = ПравоеЗначение;
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
КонецПроцедуры // УстановитьЭлементОтбораСписка()

Процедура УдалитьЭлементОтбораСписка(Список, ИмяПоля)
	
	ЭлементыОтбора = Список.Отбор.Элементы;
	ПолеКомпоновки = Новый ПолеКомпоновкиДанных(ИмяПоля);
	Для Каждого ЭлементОтбора Из ЭлементыОтбора Цикл
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных")
			И ЭлементОтбора.ЛевоеЗначение = ПолеКомпоновки Тогда
			ЭлементыОтбора.Удалить(ЭлементОтбора);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры // УдалитьЭлементОтбораСписка()