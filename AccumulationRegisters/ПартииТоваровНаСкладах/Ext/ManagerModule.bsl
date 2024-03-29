﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура создает пустую временную таблицу изменения движений.
//
Процедура СоздатьПустуюВременнуюТаблицуИзменение(ДополнительныеСвойства) Экспорт
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
	 ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 0
	|	ПартииТоваровНаСкладах.НомерСтроки КАК НомерСтроки,
	|	ПартииТоваровНаСкладах.Подразделение КАК Подразделение,
	|	ПартииТоваровНаСкладах.Склад КАК Склад,
	|	ПартииТоваровНаСкладах.Номенклатура КАК Номенклатура,
	|	ПартииТоваровНаСкладах.Количество КАК КоличествоПередЗаписью,
	|	ПартииТоваровНаСкладах.Количество КАК КоличествоИзменение,
	|	ПартииТоваровНаСкладах.Количество КАК КоличествоПриЗаписи
	|ПОМЕСТИТЬ ДвиженияПартииТоваровНаСкладахИзменение
	|ИЗ
	|	РегистрНакопления.ПартииТоваровНаСкладах КАК ПартииТоваровНаСкладах");
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураВременныеТаблицы.Вставить("ДвиженияЗапасыНаСкладахИзменение", Ложь);
	
КонецПроцедуры // СоздатьПустуюВременнуюТаблицуИзменение()
