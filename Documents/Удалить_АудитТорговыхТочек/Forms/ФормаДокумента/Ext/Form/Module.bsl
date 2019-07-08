﻿&НаСервере
Процедура ЗаполнитьПоМенеджеруСервер()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	КонтрагентыМенеджеры.Ссылка КАК Контрагент,
	|	КонтрагентыМенеджеры.Ссылка.АдресДоставкиОбласть,
	|	КонтрагентыМенеджеры.Ссылка.АдресДоставкиРайон,
	|	КонтрагентыМенеджеры.Ссылка.АдресДоставкиГород,
	|	КонтрагентыМенеджеры.Ссылка.АдресДоставкиУлица,
	|	КонтрагентыМенеджеры.Ссылка.АдресДоставкиДом,
	|	КонтрагентыМенеджеры.Ссылка.АдресДоставкиСтроение,
	|	КонтрагентыМенеджеры.Ссылка.Свойство_КолвоСКУ
	|ИЗ
	|	Справочник.Контрагенты.Менеджеры КАК КонтрагентыМенеджеры
	|ГДЕ
	|	КонтрагентыМенеджеры.Менеджер = &Менеджер
	|
	|УПОРЯДОЧИТЬ ПО
	|	КонтрагентыМенеджеры.Ссылка.Наименование");
	
	Запрос.УстановитьПараметр("Менеджер", Объект.Менеджер);
	
	Объект.СтрокиДокумента.Загрузить(Запрос.Выполнить().Выгрузить());
	
	
КонецПроцедуры


&НаКлиенте
Процедура ЗаполнитьПоМенеджеру(Команда)
	ЗаполнитьПоМенеджеруСервер();
КонецПроцедуры
