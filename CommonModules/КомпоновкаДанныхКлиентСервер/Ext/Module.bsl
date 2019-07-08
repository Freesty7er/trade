﻿// Копирует элементы из одной коллекции в другую
//
// Параметры:
//	ПриемникЗначения	- коллекция элементов КД, куда копируются параметры
//	ИсточникЗначения	- коллекция элементов КД, откуда копируются параметры
//	ОчищатьПриемник		- признак необходимости очистки приемника (Булево, по умолчанию: истина)
//
Процедура СкопироватьЭлементы(приемникЗначения, источникЗначения, очищатьПриемник = Истина) Экспорт
	
	Если ТипЗнч(источникЗначения) = Тип("УсловноеОформлениеКомпоновкиДанных")
		ИЛИ ТипЗнч(источникЗначения) = Тип("ВариантыПользовательскогоПоляВыборКомпоновкиДанных")
		ИЛИ ТипЗнч(источникЗначения) = Тип("ОформляемыеПоляКомпоновкиДанных")
		ИЛИ ТипЗнч(источникЗначения) = Тип("ЗначенияПараметровДанныхКомпоновкиДанных") Тогда
		создаватьПоТипу = Ложь;
	Иначе
		создаватьПоТипу = Истина;
	КонецЕсли;
	
	приемникЭлементов = приемникЗначения.Элементы;
	источникЭлементов = источникЗначения.Элементы;
	
	Если очищатьПриемник Тогда
		приемникЭлементов.Очистить();
	КонецЕсли;
	
	Для каждого элементИсточник Из источникЭлементов Цикл
		
		Если ТипЗнч(элементИсточник) = Тип("ЭлементПорядкаКомпоновкиДанных") Тогда
			// Элементы порядка добавляем в начало
			индекс = источникЭлементов.Индекс(элементИсточник);
			элементПриемник = приемникЭлементов.Вставить(индекс, ТипЗнч(элементИсточник));
		Иначе
			Если создаватьПоТипу Тогда
				элементПриемник = приемникЭлементов.Добавить(ТипЗнч(элементИсточник));
			Иначе
				элементПриемник = приемникЭлементов.Добавить();
			КонецЕсли;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(элементПриемник, элементИсточник);
		
		// В некоторых коллекциях необходимо заполнить другие коллекции
		Если ТипЗнч(источникЭлементов) = Тип("КоллекцияЭлементовУсловногоОформленияКомпоновкиДанных") Тогда
			
			СкопироватьЭлементы(элементПриемник.Поля, элементИсточник.Поля);
			СкопироватьЭлементы(элементПриемник.Отбор, элементИсточник.Отбор);
			
			ЗаполнитьЭлементы(элементПриемник.Оформление, элементИсточник.Оформление); 
			
		ИначеЕсли ТипЗнч(источникЭлементов)	= Тип("КоллекцияВариантовПользовательскогоПоляВыборКомпоновкиДанных") Тогда
			СкопироватьЭлементы(элементПриемник.Отбор, элементИсточник.Отбор);
		КонецЕсли;
		
		// В некоторых элементах коллекции необходимо заполнить другие коллекции
		Если ТипЗнч(элементИсточник) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			СкопироватьЭлементы(элементПриемник, элементИсточник);
		ИначеЕсли ТипЗнч(элементИсточник) = Тип("ГруппаВыбранныхПолейКомпоновкиДанных") Тогда
			СкопироватьЭлементы(элементПриемник, элементИсточник);
		ИначеЕсли ТипЗнч(ЭлементИсточник) = Тип("ПользовательскоеПолеВыборКомпоновкиДанных") Тогда
			СкопироватьЭлементы(элементПриемник.Варианты, элементИсточник.Варианты);
		ИначеЕсли ТипЗнч(ЭлементИсточник) = Тип("ПользовательскоеПолеВыражениеКомпоновкиДанных") Тогда
			элементПриемник.УстановитьВыражениеДетальныхЗаписей (элементИсточник.ПолучитьВыражениеДетальныхЗаписей());
			элементПриемник.УстановитьВыражениеИтоговыхЗаписей(элементИсточник.ПолучитьВыражениеИтоговыхЗаписей());
			элементПриемник.УстановитьПредставлениеВыраженияДетальныхЗаписей(элементИсточник.ПолучитьПредставлениеВыраженияДетальныхЗаписей ());
			элементПриемник.УстановитьПредставлениеВыраженияИтоговыхЗаписей(элементИсточник.ПолучитьПредставлениеВыраженияИтоговыхЗаписей ());
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры	// СкопироватьЭлементы()

// Заполняет одну коллекцию элементов на основании другой
//
// Параметры:
//	ПриемникЗначения	- коллекция элементов КД, куда копируются параметры
//	ИсточникЗначения	- коллекция элементов КД, откуда копируются параметры
//	ПервыйУровень		- уровень структуры коллекции элементов КД для копирования параметров
//
Процедура ЗаполнитьЭлементы(приемникЗначения, источникЗначения, первыйУровень = Неопределено) Экспорт
	
	Если ТипЗнч(приемникЗначения) = Тип("КоллекцияЗначенийПараметровКомпоновкиДанных") Тогда
		коллекцияЗначений = источникЗначения;
	Иначе
		коллекцияЗначений = источникЗначения.Элементы;
	КонецЕсли;
	
	Для каждого элементИсточник Из коллекцияЗначений Цикл
		
		Если первыйУровень = Неопределено Тогда
			элементПриемник = приемникЗначения.НайтиЗначениеПараметра(элементИсточник.Параметр);
		Иначе
			элементПриемник = первыйУровень.НайтиЗначениеПараметра(элементИсточник.Параметр);
		КонецЕсли;
		
		Если элементПриемник = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(элементПриемник, элементИсточник);
		
		Если ТипЗнч(элементИсточник) = Тип("ЗначениеПараметраКомпоновкиДанных") Тогда
			Если элементИсточник.ЗначенияВложенныхПараметров.Количество() <> 0 Тогда
				ЗаполнитьЭлементы(элементПриемник.ЗначенияВложенныхПараметров, элементИсточник.ЗначенияВложенныхПараметров, приемникЗначения);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры	// ЗаполнитьЭлементы()

// Добавляет отбор в коллекцию отборов компоновщика или группы отборов
//
// Параметры:
//	ЭлементСтруктуры- элемент структуры КД
//	Поле			- имя поля, по которому добавляется отбор
//	Значение		- значение отбора КД
//	ВидСравнения	- вид сравнений КД (по умолчанию: неопределено)
//	Использование	- признак использования отбора (по умолчанию: истина)
//	ВПользовательскиеНастройки - признак добавления в пользовательсие настройки КД (по умолчанию: ложь)
//
// Возвращаемое значение:
//	ЭлементОтбора (ЭлементОтбораКомпоновкиДанных)
//
Функция ДобавитьОтбор(ЭлементСтруктуры, Знач Поле, Значение, ВидСравнения = Неопределено, Использование = Истина, ВПользовательскиеНастройки = Ложь) Экспорт
	
	Если ТипЗнч(Поле) = Тип("Строка") Тогда
		Поле = Новый ПолеКомпоновкиДанных(Поле);
	КонецЕсли;
	
	Если ТипЗнч(ЭлементСтруктуры) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		Отбор = ЭлементСтруктуры.Настройки.Отбор;
		
		Если ВПользовательскиеНастройки Тогда
			Для Каждого ЭлементНастройки Из ЭлементСтруктуры.ПользовательскиеНастройки.Элементы Цикл
				Если ЭлементНастройки.ИдентификаторПользовательскойНастройки = ЭлементСтруктуры.Настройки.Отбор.ИдентификаторПользовательскойНастройки Тогда
					Отбор = ЭлементНастройки;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("НастройкиКомпоновкиДанных") Тогда
		Отбор = ЭлементСтруктуры.Отбор;
	Иначе
		Отбор = ЭлементСтруктуры;
	КонецЕсли;
	
	Если ВидСравнения = Неопределено Тогда
		ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	КонецЕсли;
	
	ЭлементОтбора = Неопределено;
	Для каждого Элемент Из Отбор.Элементы Цикл
		
		Если ТипЗнч(Элемент) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			Продолжить;
		КонецЕсли;
		
		Если Элемент.ЛевоеЗначение = Поле Тогда
			ЭлементОтбора = Элемент;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЭлементОтбора = Неопределено Тогда
		ЭлементОтбора = Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	КонецЕсли;
	ЭлементОтбора.Использование		= Использование;
	ЭлементОтбора.ЛевоеЗначение		= Поле;
	ЭлементОтбора.ВидСравнения		= ВидСравнения;
	ЭлементОтбора.ПравоеЗначение	= Значение;
	
	Возврат ЭлементОтбора;
	
КонецФункции
