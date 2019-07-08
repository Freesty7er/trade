﻿
#Область КомандыФормы

&НаКлиенте
Процедура КомандаЗаполнить(Команда)
	КомандаЗаполнитьНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ПрочиеПроцедурыИФункции

&НаСервере
Процедура КомандаЗаполнитьНаСервере()
	
	запрос = Новый Запрос;
	запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	#Область ТекстЗапроса
	
	запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПОДСТРОКА(Планирование_ЛистЗадачСписокЗаданий.Задача, 1, 150) КАК Задача,
	|	Планирование_ЛистЗадачСписокЗаданий.План
	|ПОМЕСТИТЬ ВТ_СписокЗаданий
	|ИЗ
	|	Документ.Планирование_ЛистЗадач.СписокЗаданий КАК Планирование_ЛистЗадачСписокЗаданий
	|ГДЕ
	|	Планирование_ЛистЗадачСписокЗаданий.Ссылка = &Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Задача
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Планирование_ЛистЗадачСписокИсполнителей.Менеджер КАК Менеджер
	|ПОМЕСТИТЬ ВТ_СписокИсполнителей
	|ИЗ
	|	Документ.Планирование_ЛистЗадач.СписокИсполнителей КАК Планирование_ЛистЗадачСписокИсполнителей
	|ГДЕ
	|	Планирование_ЛистЗадачСписокИсполнителей.Ссылка = &Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Менеджер
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_СписокЗаданий.Задача,
	|	ВТ_СписокИсполнителей.Менеджер,
	|	ВТ_СписокЗаданий.План
	|ИЗ
	|	ВТ_СписокЗаданий КАК ВТ_СписокЗаданий,
	|	ВТ_СписокИсполнителей КАК ВТ_СписокИсполнителей";
	
	#КонецОбласти
	
	запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	результатЗапроса = запрос.Выполнить();
	
	Объект.Состав.Загрузить(результатЗапроса.Выгрузить());
	
КонецПроцедуры

#КонецОбласти