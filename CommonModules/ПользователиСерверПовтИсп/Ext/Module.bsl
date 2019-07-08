﻿
////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Функция ВсеРоли() возвращает таблицу значений имен всех ролей конфигурации.
//
// Параметры:
// 
// Возвращаемое значение:
//  ТаблицаЗначений
//      Имя         - Строка.
//
Функция ВсеРоли() Экспорт
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Имя", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(1000)));
	
	Для каждого Роль Из Метаданные.Роли Цикл
		Таблица.Добавить().Имя = Роль.Имя;
	КонецЦикла;
	
	Возврат Таблица;
	
КонецФункции

// Функция СинонимыРолей возвращает таблицу значений
// с колонками Роль и РольСиноним, которая формируется
// из метаданных
//
// Возвращаемое значение:
//  ТаблицаЗначений.
//    Роль        - Строка(150)
//    СинонимРоли - Строка(1000)
//
Функция СинонимыРолей() Экспорт
	
	СинонимыРолей = Новый ТаблицаЗначений;
	СинонимыРолей.Колонки.Добавить("Роль",        Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(150)));
	СинонимыРолей.Колонки.Добавить("РольСиноним", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(1000)));
	
	Для каждого Роль Из Метаданные.Роли Цикл
		
		ОписаниеРоли = СинонимыРолей.Добавить();
		ОписаниеРоли.Роль        = Роль.Имя;
		ОписаниеРоли.РольСиноним = Роль.Синоним;
		
	КонецЦикла;
		
	Возврат СинонимыРолей;
	
КонецФункции

// Функция ДеревоРолей возвращает дерево
// ролей с/без подсистем
//  Если роль не принадлежит ни одной подсистеме
// она добавляется "в корень"
// 
// Параметры:
//  ПоПодсистемам - Булево, если ложь, все роли добавляются в "корень"
// 
// Возвращаемое значение:
//  ДеревоЗначений
//    ЭтоРоль       - Булево
//    Имя           - Строка - имя     роли или подсистемы
//    Синоним       - Строка - синоним роли или подсистемы
//
Функция ДеревоРолей(ПоПодсистемам = Истина) Экспорт
	
	Дерево = Новый ДеревоЗначений;
	Дерево.Колонки.Добавить("ЭтоРоль",       Новый ОписаниеТипов("Булево"));
	Дерево.Колонки.Добавить("Имя",           Новый ОписаниеТипов("Строка"));
	Дерево.Колонки.Добавить("Синоним",       Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(1000)));
	
	Если ПоПодсистемам Тогда
		ЗаполнитьПодсистемыИРоли(Дерево.Строки);
	КонецЕсли;
	
	// Добавление ненайденных ролей
	Для каждого Роль Из Метаданные.Роли Цикл
		Если Дерево.Строки.НайтиСтроки(Новый Структура("ЭтоРоль, Имя", Истина, Роль.Имя), Истина).Количество() = 0 Тогда
			СтрокаДерева = Дерево.Строки.Добавить();
			СтрокаДерева.ЭтоРоль       = Истина;
			СтрокаДерева.Имя           = Роль.Имя;
			СтрокаДерева.Синоним       = Роль.Синоним;
		КонецЕсли;
	КонецЦикла;
	
	Дерево.Строки.Сортировать("ЭтоРоль Убыв, Синоним Возр", Истина);
	
	Возврат Дерево;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры модуля

Процедура ЗаполнитьПодсистемыИРоли(КоллекцияСтрокДерева, Подсистемы = Неопределено)
	
	Если Подсистемы = Неопределено Тогда
		Подсистемы = Метаданные.Подсистемы;
	КонецЕсли;
	
	Для каждого Подсистема Из Подсистемы Цикл
		
		ОписаниеПодсистемы = КоллекцияСтрокДерева.Добавить();
		ОписаниеПодсистемы.Имя           = Подсистема.Имя;
		ОписаниеПодсистемы.Синоним       = Подсистема.Синоним;
		
		ЗаполнитьПодсистемыИРоли(ОписаниеПодсистемы.Строки, Подсистема.Подсистемы);
		
		Для каждого Роль Из Метаданные.Роли Цикл
			Если Подсистема.Состав.Содержит(Роль) Тогда
				ОписаниеРоли = ОписаниеПодсистемы.Строки.Добавить();
				ОписаниеРоли.ЭтоРоль       = Истина;
				ОписаниеРоли.Имя           = Роль.Имя;
				ОписаниеРоли.Синоним       = Роль.Синоним;
			КонецЕсли;
		КонецЦикла;
		
		Если ОписаниеПодсистемы.Строки.НайтиСтроки(Новый Структура("ЭтоРоль", Истина), Истина).Количество() = 0 Тогда
			КоллекцияСтрокДерева.Удалить(ОписаниеПодсистемы);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

функция ПолучитьДоступныеПодразделения() Экспорт
	
		текущийПользователь = ПараметрыСеанса.ТекущийПользователь;

	Если текущийПользователь.Пустая() Тогда
		мДоступныеПодразделения = Новый Массив;
	Иначе
		
		запрос = Новый Запрос;
		
		#Область ТекстЗапроса
		
		запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ГруппыПользователейПодразделения.Подразделение
		|ИЗ
		|	Справочник.ГруппыПользователей.Состав КАК ГруппыПользователейСостав
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГруппыПользователей.Подразделения КАК ГруппыПользователейПодразделения
		|		ПО ГруппыПользователейСостав.Ссылка = ГруппыПользователейПодразделения.Ссылка
		|ГДЕ
		|	ГруппыПользователейСостав.Пользователь = &Пользователь";
		
		#КонецОбласти
		
		запрос.УстановитьПараметр("Пользователь", текущийПользователь);
		
		мДоступныеПодразделения = запрос.Выполнить().Выгрузить().ВыгрузитьКолонку(0);
		
	КонецЕсли;
	
	Возврат Новый ФиксированныйМассив(мДоступныеПодразделения);

КонецФункции

Функция ПолучитьЗначениеНастройки(настройка, Знач пользователь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);	

	запрос = Новый Запрос;
	
	#Область ТекстЗапроса
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НастройкиПользователей.Значение
	|ИЗ
	|	РегистрСведений.НастройкиПользователей КАК НастройкиПользователей
	|ГДЕ
	|	НастройкиПользователей.Пользователь = &Пользователь
	|	И НастройкиПользователей.Настройка = &Параметр";
	
	#КонецОбласти
	
	запрос.УстановитьПараметр("Пользователь", пользователь);
	запрос.УстановитьПараметр("Параметр", ПланыВидовХарактеристик.НастройкиПользователей[настройка]);
	
	результат = Запрос.Выполнить();

	пустоеЗначение = ПланыВидовХарактеристик.НастройкиПользователей[настройка].ТипЗначения.ПривестиЗначение();
	
	Если результат.Пустой() Тогда
		Возврат пустоеЗначение;
	Иначе
	
		выборка = результат.Выбрать();
		выборка.Следующий();
		
		значениеНастройки = выборка.Значение;
		Если ЗначениеЗаполнено(значениеНастройки) Тогда
			Возврат ПланыВидовХарактеристик.НастройкиПользователей[настройка].ТипЗначения.ПривестиЗначение(значениеНастройки);
		Иначе
			Возврат пустоеЗначение;
		КонецЕсли; 
	
	КонецЕсли; 

КонецФункции // ПолучитьЗначениеНастройки()