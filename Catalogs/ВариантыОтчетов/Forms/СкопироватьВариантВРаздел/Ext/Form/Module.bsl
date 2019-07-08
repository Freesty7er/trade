﻿
&НаКлиенте
Процедура ДеревоПодсистемВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Элементы.ДеревоПодсистем.ТекущиеДанные = Неопределено тогда
		Предупреждение("Не выбран раздел отчета");
		Возврат;
	КонецЕсли;
	
	Если Элементы.СписокОтчетовИВариантов.ТекущиеДанные = Неопределено тогда
		Предупреждение("Не выбран вариант.");
		Возврат;
	КонецЕсли;
	Структура = Новый Структура("Путь, Отчет, Вариант, ССылка, ПредставлениеВарианта");
	
	Структура.Путь    = Элементы.ДеревоПодсистем.ТекущиеДанные.Путь;
	Структура.Вариант = Элементы.СписокОтчетовИВариантов.ТекущиеДанные.Вариант;
	Структура.Отчет   = Элементы.СписокОтчетовИВариантов.ТекущиеДанные.Отчет;
	Структура.Ссылка  = Элементы.СписокОтчетовИВариантов.ТекущиеДанные.Ссылка;
	Структура.ПредставлениеВарианта = Элементы.СписокОтчетовИВариантов.ТекущиеДанные.ПредставлениеВарианта;
	Закрыть(Структура);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗагузитьСтруктураПодсистем();
	
	ЗагрузитьСписокВариантовИОтчетов();
	
КонецПроцедуры

&НаСервере
Процедура ЗагузитьСтруктураПодсистем()
	
	ДеревоПодсистемДляКопирования = Новый ДеревоЗначений;
	ДеревоПодсистемДляКопирования.Колонки.Добавить("Подсистема");
	ДеревоПодсистемДляКопирования.Колонки.Добавить("Название");
	
	СписокПодсистем = Новый СписокЗначений;
	СписокПодсистем.Добавить("");
	
	// Сделаем список отчетов
	СписокПодсистем = ВариантыОтчетов.ПолучитьСписокПодсистем(СписокПодсистем, ДеревоПодсистемДляКопирования);

	СтрокаКонфигурации = ДеревоПодсистем.ПолучитьЭлементы().Добавить();
	СтрокаКонфигурации.Путь = "";
	СтрокаКонфигурации.Представление = "Конфигурация";
	СтрокаКонфигурации.Предопредленная = истина;
	
	СоответсвиеПодсистемИСтрок = Новый Соответствие;
	
	СкопироватьДеревоЗначений(СтрокаКонфигурации.ПолучитьЭлементы(), ДеревоПодсистемДляКопирования.Строки, СоответсвиеПодсистемИСтрок);

КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСписокВариантовИОтчетов()
	
	ТЗ = "ВЫБРАТЬ
	     |	ВариантыОтчетов.КлючОбъекта КАК Отчет,
	     |	ВариантыОтчетов.ПредставлениеОбъекта КАК ПредставлениеОтчета,
	     |	ВариантыОтчетов.КлючВарианта КАК Вариант,
	     |	ВариантыОтчетов.Наименование КАК ПредставлениеВарианта,
	     |	ВариантыОтчетов.Ссылка
	     |ИЗ
	     |	Справочник.ВариантыОтчетов КАК ВариантыОтчетов";
		 
	Запрос = Новый Запрос(ТЗ);
	Выборка = Запрос.Выполнить().Выбрать();
	
	СписокОтчетовИВариантов.Очистить();
	
	Пока Выборка.Следующий() Цикл
		
		СтрокаДвижения = СписокОтчетовИВариантов.Добавить();
		СтрокаДвижения.Отчет                 = Выборка.Отчет;
		СтрокаДвижения.Ссылка                = Выборка.Ссылка;
		СтрокаДвижения.Вариант               = Выборка.Вариант;
		СтрокаДвижения.ПредставлениеОтчета   = Выборка.ПредставлениеОтчета;
		СтрокаДвижения.ПредставлениеВарианта = Выборка.ПредставлениеВарианта;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СкопироватьДеревоЗначений(КолекцияПриемник, КолекцияИсточник, СоответсвиеПодсистемИСтрок)
	
	Для каждого Элемент из КолекцияИсточник Цикл
		СтрокаЗначение                 = КолекцияПриемник.Добавить();
		СтрокаЗначение.Путь            = Элемент.Подсистема;
		СтрокаЗначение.Представление   = Элемент.Название;
		СтрокаЗначение.Предопредленная = Метаданные.НайтиПоПолномуИмени("Подсистема." + СтрЗаменить(Элемент.Подсистема, "\", ".Подсистема.")) <> Неопределено;
		СоответсвиеПодсистемИСтрок.Вставить(СтрокаЗначение.Путь, СтрокаЗначение);
		СкопироватьДеревоЗначений(СтрокаЗначение.ПолучитьЭлементы(), Элемент.Строки, СоответсвиеПодсистемИСтрок);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	Если Элементы.ДеревоПодсистем.ТекущиеДанные = Неопределено тогда
		Предупреждение("Не выбран раздел отчета");
		Возврат;
	КонецЕсли;
	
	Если Элементы.СписокОтчетовИВариантов.ТекущиеДанные = Неопределено тогда
		Предупреждение("Не выбран вариант.");
		Возврат;
	КонецЕсли;
	Структура = Новый Структура("Путь, Отчет, Вариант, ССылка, ПредставлениеВарианта");
	
	Структура.Путь    = Элементы.ДеревоПодсистем.ТекущиеДанные.Путь;
	Структура.Вариант = Элементы.СписокОтчетовИВариантов.ТекущиеДанные.Вариант;
	Структура.Отчет   = Элементы.СписокОтчетовИВариантов.ТекущиеДанные.Отчет;
	Структура.Ссылка  = Элементы.СписокОтчетовИВариантов.ТекущиеДанные.Ссылка;
	Структура.ПредставлениеВарианта = Элементы.СписокОтчетовИВариантов.ТекущиеДанные.ПредставлениеВарианта;
	Закрыть(Структура);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры


