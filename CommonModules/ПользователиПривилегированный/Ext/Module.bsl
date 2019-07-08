﻿
// Инициализирует параметр сеанса "ДоступныеСклады". Параметр содержит массив ссылок на элементы
// справочника "СтруктурныеЕдиницы", доступные для просмотра и использования текущему пользователю.
//
Процедура ИнициализироватьДоступныеСклады() Экспорт
	
	ТекущийПользователь = ПараметрыСеанса.ТекущийПользователь;

	Если ТекущийПользователь.Пустая() Тогда
		мДоступныеСклады = Новый Массив;
	Иначе
		
		Запрос = Новый Запрос;
		#Область ТекстЗапроса
		Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ГруппыДоступаДоступныеСклады.Склад
		|ИЗ
		|	Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.ДоступныеСклады КАК ГруппыДоступаДоступныеСклады
		|		ПО ГруппыДоступаПользователи.Ссылка = ГруппыДоступаДоступныеСклады.Ссылка
		|ГДЕ
		|	ГруппыДоступаПользователи.Пользователь = &Пользователь";
		#КонецОбласти
		
		Запрос.УстановитьПараметр("Пользователь", ТекущийПользователь);
		
		мДоступныеСклады = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку(0);
		
	КонецЕсли; 
	
	ПараметрыСеанса.ДоступныеСклады = Новый ФиксированныйМассив(мДоступныеСклады);

КонецПроцедуры // ИнициализироватьДоступныеСклады()

// Инициализирует параметр сеанса "ДоступныеПоставщики". Параметр содержит массив ссылок на элементы
// справочника "Контрагенты", доступные для просмотра и использования текущему пользователю.
//
Процедура ИнициализироватьДоступныеПоставщики() Экспорт
	
	ТекущийПользователь = ПараметрыСеанса.ТекущийПользователь;

	Если ТекущийПользователь.Пустая() Тогда
		мДоступныеПоставщики = Новый Массив;
	Иначе
		
		Запрос = Новый Запрос;
		#Область ТекстЗапроса
		Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ГруппыДоступаДоступныеПоставщики.Поставщик
		|ИЗ
		|	Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.ДоступныеПоставщики КАК ГруппыДоступаДоступныеПоставщики
		|		ПО ГруппыДоступаПользователи.Ссылка = ГруппыДоступаДоступныеПоставщики.Ссылка
		|ГДЕ
		|	ГруппыДоступаПользователи.Пользователь = &Пользователь";
		#КонецОбласти
		
		Запрос.УстановитьПараметр("Пользователь", ТекущийПользователь);
		
		мДоступныеПоставщики = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку(0);
		
	КонецЕсли; 
	
	ПараметрыСеанса.ДоступныеПоставщики = Новый ФиксированныйМассив(мДоступныеПоставщики);

КонецПроцедуры // ИнициализироватьДоступныеПоставщики()

// Инициализирует параметр сеанса "ДоступныеМенеджеры". Параметр содержит массив ссылок на элементы
// справочника "Менеджеры", доступные для просмотра и использования текущему пользователю.
//
Процедура ИнициализироватьДоступныеМенеджеры() Экспорт
	
	ТекущийПользователь = ПараметрыСеанса.ТекущийПользователь;

	Если ТекущийПользователь.Пустая() Тогда
		мДоступныеМенеджеры = Новый Массив;
	Иначе
		
		Запрос = Новый Запрос;
		#Область ТекстЗапроса
		Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ГруппыДоступаДоступныеМенеджеры.ГруппаМенеджеров
		|ИЗ
		|	Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.ДоступныеМенеджеры КАК ГруппыДоступаДоступныеМенеджеры
		|		ПО ГруппыДоступаПользователи.Ссылка = ГруппыДоступаДоступныеМенеджеры.Ссылка
		|ГДЕ
		|	ГруппыДоступаПользователи.Пользователь = &Пользователь";
		#КонецОбласти
		
		Запрос.УстановитьПараметр("Пользователь", ТекущийПользователь);
		
		мДоступныеМенеджеры = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку(0);
		
	КонецЕсли; 
	
	ПараметрыСеанса.ДоступныеМенеджеры = Новый ФиксированныйМассив(мДоступныеМенеджеры);

КонецПроцедуры // ИнициализироватьДоступныеМенеджеры()

// Инициализирует параметр сеанса "ДоступныеПодразделение". Параметр содержит массив ссылок на элементы
// справочника "Менеджеры", доступные для просмотра и использования текущему пользователю.
//
Процедура ИнициализироватьДоступныеПодразделения() Экспорт
	
	//текущийПользователь = ПараметрыСеанса.ТекущийПользователь;

	//Если текущийПользователь.Пустая() Тогда
	//	мДоступныеПодразделения = Новый Массив;
	//Иначе
	//	
	//	запрос = Новый Запрос;
	//	
	//	#Область ТекстЗапроса
	//	Запрос.Текст =
	//	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	//	|	ГруппыПользователейПодразделения.Подразделение
	//	|ИЗ
	//	|	Справочник.ГруппыПользователей.Состав КАК ГруппыПользователейСостав
	//	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГруппыПользователей.Подразделения КАК ГруппыПользователейПодразделения
	//	|		ПО ГруппыПользователейСостав.Ссылка = ГруппыПользователейПодразделения.Ссылка
	//	|ГДЕ
	//	|	ГруппыПользователейСостав.Пользователь = &Пользователь";
	//	#КонецОбласти
	//	
	//	запрос.УстановитьПараметр("Пользователь", текущийПользователь);
	//	
	//	мДоступныеПодразделения = запрос.Выполнить().Выгрузить().ВыгрузитьКолонку(0);
	//	
	//КонецЕсли; 
	//
	//ПараметрыСеанса.ДоступныеПодразделения = Новый ФиксированныйМассив(мДоступныеПодразделения);
	
	ПараметрыСеанса.ДоступныеПодразделения = ПользователиСерверПовтИсп.ПолучитьДоступныеПодразделения();

КонецПроцедуры // ИнициализироватьДоступныеПодразделения()

// Инициализирует параметр сеанса "ДоступныеКатегорииРаботников". Параметр содержит массив ссылок на элементы
// справочника "Менеджеры", доступные для просмотра и использования текущему пользователю.
//
Процедура ИнициализироватьДоступныеКатегорииРаботников() Экспорт
	
	текущийПользователь = ПараметрыСеанса.ТекущийПользователь;

	Если текущийПользователь.Пустая() Тогда
		мДоступныеКатегорииРаботников = Новый Массив;
	Иначе
		
		запрос = Новый Запрос;
		
		#Область ТекстЗапроса
		Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ГруппыДоступаКЗарплатеРаботниковКатегорииРаботников.КатегорияРаботника
		|ИЗ
		|	Справочник.ГруппыДоступаКЗарплатеРаботников.Пользователи КАК ГруппыДоступаКЗарплатеРаботниковПользователи
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступаКЗарплатеРаботников.КатегорииРаботников КАК ГруппыДоступаКЗарплатеРаботниковКатегорииРаботников
		|		ПО ГруппыДоступаКЗарплатеРаботниковПользователи.Ссылка = ГруппыДоступаКЗарплатеРаботниковКатегорииРаботников.Ссылка
		|ГДЕ
		|	ГруппыДоступаКЗарплатеРаботниковПользователи.Пользователь = &Пользователь";
		#КонецОбласти
		
		запрос.УстановитьПараметр("Пользователь", текущийПользователь);
		
		мДоступныеКатегорииРаботников = запрос.Выполнить().Выгрузить().ВыгрузитьКолонку(0);
		
	КонецЕсли; 
	
	ПараметрыСеанса.ДоступныеКатегорииРаботников = Новый ФиксированныйМассив(мДоступныеКатегорииРаботников);

КонецПроцедуры // ИнициализироватьДоступныеПодразделения()

Процедура ПодписатьДокументы(мДокументы) Экспорт
	
	Если мДокументы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	областьДанных = "Документ."+мДокументы[0].Метаданные().Имя;
	
	запрос = Новый Запрос;
	
	#Область ТекстЗапроса
	
	запрос.Текст =
	"ВЫБРАТЬ
	|	ОбластьДанных.Ссылка
	|ИЗ
	|	&ОбластьДанных КАК ОбластьДанных
	|ГДЕ
	|	ОбластьДанных.Ссылка В(&мДокументы)";
	
	запрос.Текст = СтрЗаменить(запрос.Текст, "&ОбластьДанных", областьДанных);
	
	#КонецОбласти
	
	запрос.УстановитьПараметр("мДокументы", мДокументы);
	
	результатЗапроса = запрос.Выполнить();
	
	НачатьТранзакцию();
	
	блокировкаДанных = Новый БлокировкаДанных;
	
	элементБлокировки = блокировкаДанных.Добавить();
	элементБлокировки.Область = областьДанных;
	элементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	элементБлокировки.ИсточникДанных = результатЗапроса;
	элементБлокировки.ИспользоватьИзИсточникаДанных("Ссылка", "Ссылка");
	
	блокировкаДанных.Заблокировать();

	выборка = результатЗапроса.Выбрать();
	Пока выборка.Следующий() Цикл
		
		объект = выборка.Ссылка.ПолучитьОбъект();
		объект.ОтметкаБухгалтераОПроверке = Не выборка.Ссылка.ОтметкаБухгалтераОПроверке;
		объект.ОбменДанными.Загрузка = Истина;
		объект.Записать();
		
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры
